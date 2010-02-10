From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH 1/1] mid-layer unblocks blocked sdev leaving queue stopped
Date: Wed, 10 Feb 2010 16:24:47 -0600
Message-ID: <4B73322F.2000001@sgi.com>
References: <4B29628D.9090208@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.179.30]:60830 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755801Ab0BJWYs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Feb 2010 17:24:48 -0500
In-Reply-To: <4B29628D.9090208@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Smart <James.Smart@Emulex.Com>, James Bottomley <James.Bottomley@suse.de>

No comments after almost 2 months?  This is a real problem resulting in hung i/o.
Any thoughts on when / if this might be integrated?

Thanks,
 Mike


Michael Reed wrote:
> scsi_add_lun() and scsi_sysfs_add_sdev() unconditionally set the sdev
> state to SDEV_RUNNING.  If this sdev was blocked via scsi_internal_device_block()
> the changing of the state to running will result in the device's queue
> remaining stopped after the call to scsi_internal_device_unblock() and
> commands becoming stuck.  This patch changes scsi_add_lun() and
> scsi_sysfs_add_sdev() to not move the sdev to running if it is
> blocked. It leaves it to the blocker of the sdev to unblock it.
> 
> Found during large lun count testing using 13 FC host adapter ports.
> In my testing the sdev was blocked due to disruptions or events on the
> fibre channel link.
> 
> Signed-off-by: Michael Reed <mdr@sgi.com>
> 
> ==
> 
> --- a/drivers/scsi/scsi_sysfs.c	2009-12-16 16:26:14.512882449 -0600
> +++ scsi-misc/drivers/scsi/scsi_sysfs.c	2009-12-16 16:23:33.352882975 -0600
> @@ -878,8 +878,14 @@ int scsi_sysfs_add_sdev(struct scsi_devi
>  	struct request_queue *rq = sdev->request_queue;
>  	struct scsi_target *starget = sdev->sdev_target;
>  
> -	if ((error = scsi_device_set_state(sdev, SDEV_RUNNING)) != 0)
> -		return error;
> +	/*
> +	 * If device is blocked, leave state alone and let
> +	 * blocker unblock when appropriate.
> +	 */
> +	if (sdev->sdev_state != SDEV_BLOCK) {
> +		if ((error = scsi_device_set_state(sdev, SDEV_RUNNING)) != 0)
> +			return error;
> +	}
>  
>  	error = scsi_target_add(starget);
>  	if (error)
> --- a/drivers/scsi/scsi_scan.c	2009-12-16 16:26:14.512882449 -0600
> +++ scsi-misc/drivers/scsi/scsi_scan.c	2009-12-16 16:25:58.084976675 -0600
> @@ -902,17 +902,22 @@ static int scsi_add_lun(struct scsi_devi
>  	if (*bflags & BLIST_USE_10_BYTE_MS)
>  		sdev->use_10_for_ms = 1;
>  
> -	/* set the device running here so that slave configure
> -	 * may do I/O */
> -	ret = scsi_device_set_state(sdev, SDEV_RUNNING);
> -	if (ret) {
> -		ret = scsi_device_set_state(sdev, SDEV_BLOCK);
> -
> +	/*
> +	 * If device is blocked, leave state alone and let blocker
> +	 * unblock when appropriate.  Otherwise, set the device
> +	 * running here so that slave configure may perform i/o.
> +	 */
> +	if (sdev->sdev_state != SDEV_BLOCK) {
> +		ret = scsi_device_set_state(sdev, SDEV_RUNNING);
>  		if (ret) {
> -			sdev_printk(KERN_ERR, sdev,
> +			ret = scsi_device_set_state(sdev, SDEV_BLOCK);
> +
> +			if (ret) {
> +				sdev_printk(KERN_ERR, sdev,
>  				    "in wrong state %s to complete scan\n",
>  				    scsi_device_state_name(sdev->sdev_state));
> -			return SCSI_SCAN_NO_RESPONSE;
> +				return SCSI_SCAN_NO_RESPONSE;
> +			}
>  		}
>  	}
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
