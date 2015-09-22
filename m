From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 01/23] scsi_dh_alua: Disable ALUA handling for non-disk
 devices
Date: Tue, 22 Sep 2015 14:28:16 -0400
Message-ID: <1442946496.4132.3.camel@localhost.localdomain>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
	 <1440679281-13234-2-git-send-email-hare@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933759AbbIVS2S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Sep 2015 14:28:18 -0400
In-Reply-To: <1440679281-13234-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Thu, 2015-08-27 at 14:40 +0200, Hannes Reinecke wrote:
> Non-disk devices might support ALUA, but the firmware
> implementation is untested and frequently broken.
> As we're don't actually need it disable ALUA support
> for non-disk device for now.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index cc2773b..7d01ef0 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -320,6 +320,18 @@ static int alua_check_tpgs(struct scsi_device *sdev, struct alua_dh_data *h)
>  {
>  	int err = SCSI_DH_OK;
>  
> +	/*
> +	 * ALUA support for non-disk devices is fraught with
> +	 * difficulties, so disable it for now.
> +	 */
> +	if (sdev->type != TYPE_DISK) {
> +		h->tpgs = TPGS_MODE_NONE;
> +		sdev_printk(KERN_INFO, sdev,
> +			    "%s: disable for non-disk devices\n",
> +			    ALUA_DH_NAME);
> +		return SCSI_DH_DEV_UNSUPP;
> +	}
> +
>  	h->tpgs = scsi_device_tpgs(sdev);
>  	switch (h->tpgs) {
>  	case TPGS_MODE_EXPLICIT|TPGS_MODE_IMPLICIT:

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


