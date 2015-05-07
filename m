From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH 02/17] scsi_dh_alua: Disable ALUA handling for non-disk
 devices
Date: Thu, 07 May 2015 13:34:56 +0200
Message-ID: <554B4DE0.5020202@gmail.com>
References: <1430743343-47174-1-git-send-email-hare@suse.de> <1430743343-47174-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sf1.bxl.stone.is ([87.238.167.216]:41729 "EHLO sf1.bxl.stone.is"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751353AbbEGM0o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 May 2015 08:26:44 -0400
In-Reply-To: <1430743343-47174-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 05/04/15 14:42, Hannes Reinecke wrote:
> Non-disk devices should be ignored when detecting
> ALUA capabilities.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/scsi/device_handler/scsi_dh_alua.c | 17 +++++++++++++++++
>   1 file changed, 17 insertions(+)
>
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index e418849..834e80f 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -320,6 +320,23 @@ static int alua_check_tpgs(struct scsi_device *sdev, struct alua_dh_data *h)
>   {
>   	int err = SCSI_DH_OK;
>
> +	if (scsi_is_wlun(sdev->lun)) {
> +		h->tpgs = TPGS_MODE_NONE;
> +		sdev_printk(KERN_INFO, sdev,
> +			    "%s: disable for WLUN\n",
> +			    ALUA_DH_NAME);
> +		return SCSI_DH_DEV_UNSUPP;
> +	}
> +	if (sdev->type != TYPE_DISK &&
> +	    sdev->type != TYPE_RBC &&
> +	    sdev->type != TYPE_OSD) {
> +		h->tpgs = TPGS_MODE_NONE;
> +		sdev_printk(KERN_INFO, sdev,
> +			    "%s: disable for non-disk devices\n",
> +			    ALUA_DH_NAME);
> +		return SCSI_DH_DEV_UNSUPP;
> +	}
> +
>   	h->tpgs = scsi_device_tpgs(sdev);
>   	switch (h->tpgs) {
>   	case TPGS_MODE_EXPLICIT|TPGS_MODE_IMPLICIT:
>

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
