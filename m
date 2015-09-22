From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 05/23] scsi_dh_alua: return standard SCSI return codes
 in submit_rtpg
Date: Tue, 22 Sep 2015 14:34:55 -0400
Message-ID: <1442946895.4132.7.camel@localhost.localdomain>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
	 <1440679281-13234-6-git-send-email-hare@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759281AbbIVSe5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Sep 2015 14:34:57 -0400
In-Reply-To: <1440679281-13234-6-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Thu, 2015-08-27 at 14:41 +0200, Hannes Reinecke wrote:
> Fixup submit_rtpg() to always return a standard SCSI return code.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 38 +++++++++++++++++-------------
>  1 file changed, 22 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 7b43ee3..c41d662 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -139,11 +139,13 @@ static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data *h,
>  			    bool rtpg_ext_hdr_req)
>  {
>  	struct request *rq;
> -	int err = SCSI_DH_RES_TEMP_UNAVAIL;
> +	int err = 0;
>  
>  	rq = get_alua_req(sdev, h->buff, h->bufflen, READ);
> -	if (!rq)
> +	if (!rq) {
> +		err = DRIVER_BUSY << 24;
>  		goto done;
> +	}
>  
>  	/* Prepare the command. */
>  	rq->cmd[0] = MAINTENANCE_IN;
> @@ -161,13 +163,10 @@ static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data *h,
>  	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
>  	rq->sense_len = h->senselen = 0;
>  
> -	err = blk_execute_rq(rq->q, NULL, rq, 1);
> -	if (err == -EIO) {
> -		sdev_printk(KERN_INFO, sdev,
> -			    "%s: rtpg failed with %x\n",
> -			    ALUA_DH_NAME, rq->errors);
> +	blk_execute_rq(rq->q, NULL, rq, 1);
> +	if (rq->errors) {
> +		err = rq->errors;
>  		h->senselen = rq->sense_len;
> -		err = SCSI_DH_IO;
>  	}
>  	blk_put_request(rq);
>  done:
> @@ -489,7 +488,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
>  	struct scsi_sense_hdr sense_hdr;
>  	int len, k, off, valid_states = 0;
>  	unsigned char *ucp;
> -	unsigned err;
> +	unsigned err, retval;
>  	bool rtpg_ext_hdr_req = 1;
>  	unsigned long expiry, interval = 0;
>  	unsigned int tpg_desc_tbl_off;
> @@ -501,13 +500,20 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
>  		expiry = round_jiffies_up(jiffies + h->transition_tmo * HZ);
>  
>   retry:
> -	err = submit_rtpg(sdev, h, rtpg_ext_hdr_req);
> -
> -	if (err == SCSI_DH_IO && h->senselen > 0) {
> -		err = scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
> -					   &sense_hdr);
> -		if (!err)
> -			return SCSI_DH_IO;
> +	retval = submit_rtpg(sdev, h, rtpg_ext_hdr_req);
> +
> +	if (retval) {
> +		if (!scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
> +					  &sense_hdr)) {
> +			sdev_printk(KERN_INFO, sdev,
> +				    "%s: rtpg failed, result %d\n",
> +				    ALUA_DH_NAME, retval);
> +			if (driver_byte(retval) == DRIVER_BUSY)
> +				err = SCSI_DH_DEV_TEMP_BUSY;
> +			else
> +				err = SCSI_DH_IO;
> +			return err;
> +		}
>  
>  		/*
>  		 * submit_rtpg() has failed on existing arrays

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


