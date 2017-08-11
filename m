From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 3/6] hpsa: disable volume status check for older
 controller
Date: Fri, 11 Aug 2017 15:23:24 +0200
Message-ID: <c7e61ea8-696b-b00d-c804-c2297eee5d14@redhat.com>
References: <1502181315-102499-1-git-send-email-hare@suse.de>
 <1502181315-102499-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41206 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752703AbdHKNX2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Aug 2017 09:23:28 -0400
In-Reply-To: <1502181315-102499-4-git-send-email-hare@suse.de>
Content-Language: en-MW
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Don Brace <don.brace@microsemi.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Meelis Roos <mroos@linux.ee>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 8.8.2017 10:35, Hannes Reinecke wrote:
> Older Controller might not support volume status, so assume
> the volume is online here.
>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/hpsa.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 7ca6078..4ebf5d4 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -3832,6 +3832,17 @@ static int hpsa_update_device_info(struct ctlr_info *h,
>  		if (h->fw_support & MISC_FW_RAID_OFFLOAD_BASIC)
>  			hpsa_get_ioaccel_status(h, scsi3addr, this_device);
>  		volume_offline = hpsa_volume_offline(h, scsi3addr);
> +		if (volume_offline == HPSA_VPD_LV_STATUS_UNSUPPORTED &&
> +		    !h->supported) {
> +			/*
> +			 * Older / unsupported controllers might not support
> +			 * volume status
> +			 */
> +			dev_info(&h->pdev->dev,
> +				 "C0:T%d:L%d Volume status not available, assuming online.\n",
> +				 this_device->target, this_device->lun);
> +			volume_offline = 0;

Hi,
could we have here
volume_offline = HPSA_LV_OK;
instead ?
tomash

> +		}
>  		this_device->volume_offline = volume_offline;
>  		if (volume_offline == HPSA_LV_FAILED) {
>  			rc = HPSA_LV_FAILED;
