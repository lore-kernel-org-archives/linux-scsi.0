From: James Smart <james.smart@emulex.com>
Subject: Re: [PATCH] Protect against overflow in dev_loss_tmo
Date: Tue, 9 Mar 2010 09:14:37 -0500
Message-ID: <4B9657CD.6000805@emulex.com>
References: <20100309091848.4C7412BD8B@ochil.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:28740 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752079Ab0CIOO7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2010 09:14:59 -0500
In-Reply-To: <20100309091848.4C7412BD8B@ochil.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

I don't ever expect to see large dev_loss_tmo values, but the patch is fine.

Acked-by: James Smart <james.smart@emulex.com>

-- james s


Hannes Reinecke wrote:
> The rport structure defines dev_loss_tmo as u32, which is
> later multiplied with HZ to get the actual timeout value.
> This might overflow for large dev_loss_tmo values. So we
> should be better using u64 as intermediate variables here
> to protect against overflow.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
>
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> index 79660ee..9860322 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -833,7 +833,7 @@ static ssize_t
>  store_fc_rport_dev_loss_tmo(struct device *dev, struct device_attribute *attr,
>  			    const char *buf, size_t count)
>  {
> -	int val;
> +	unsigned long val;
>  	struct fc_rport *rport = transport_class_to_rport(dev);
>  	struct Scsi_Host *shost = rport_to_shost(rport);
>  	struct fc_internal *i = to_fc_internal(shost->transportt);
> @@ -847,6 +847,12 @@ store_fc_rport_dev_loss_tmo(struct device *dev, struct device_attribute *attr,
>  		return -EINVAL;
>  
>  	/*
> +	 * Check for overflow; dev_loss_tmo is u32
> +	 */
> +	if (val > UINT_MAX)
> +		return -EINVAL;
> +
> +	/*
>  	 * If fast_io_fail is off we have to cap
>  	 * dev_loss_tmo at SCSI_DEVICE_BLOCK_MAX_TIMEOUT
>  	 */
> @@ -2852,7 +2858,7 @@ void
>  fc_remote_port_delete(struct fc_rport  *rport)
>  {
>  	struct Scsi_Host *shost = rport_to_shost(rport);
> -	int timeout = rport->dev_loss_tmo;
> +	unsigned long timeout = rport->dev_loss_tmo;
>  	unsigned long flags;
>  
>  	/*
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   
