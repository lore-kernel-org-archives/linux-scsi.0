From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH, RFC] scsi: use host wide tags by default
Date: Fri, 17 Apr 2015 14:42:40 -0700
Message-ID: <1429306960.1079.25.camel@HansenPartnership.com>
References: <1429301471-5666-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33971 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751664AbbDQVmm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 17:42:42 -0400
In-Reply-To: <1429301471-5666-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, axboe@kernel.dk

On Fri, 2015-04-17 at 22:11 +0200, Christoph Hellwig wrote:
> diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
> index 82abfce..941a424 100644
> --- a/drivers/scsi/53c700.c
> +++ b/drivers/scsi/53c700.c
> @@ -325,7 +325,6 @@ NCR_700_detect(struct scsi_host_template *tpnt,
>  	tpnt->slave_destroy = NCR_700_slave_destroy;
>  	tpnt->slave_alloc = NCR_700_slave_alloc;
>  	tpnt->change_queue_depth = NCR_700_change_queue_depth;
> -	tpnt->use_blk_tags = 1;
>  
>  	if(tpnt->name == NULL)
>  		tpnt->name = "53c700";
> @@ -1107,7 +1106,9 @@ process_script_interrupt(__u32 dsps, __u32 dsp, struct scsi_cmnd *SCp,
>  			BUG();
>  		}
>  		if(hostdata->msgin[1] == A_SIMPLE_TAG_MSG) {
> -			struct scsi_cmnd *SCp = scsi_find_tag(SDp, hostdata->msgin[2]);
> +			struct scsi_cmnd *SCp;
> +
> +			SCp = scsi_find_tag(SDp->host, hostdata->msgin[2]);

This (and the following) is a stylistic modification and doesn't really
belong here.

>  			if(unlikely(SCp == NULL)) {
>  				printk(KERN_ERR "scsi%d: (%d:%d) no saved request for tag %d\n", 
>  				       host->host_no, reselection_id, lun, hostdata->msgin[2]);
> @@ -1119,7 +1120,9 @@ process_script_interrupt(__u32 dsps, __u32 dsp, struct scsi_cmnd *SCp,
>  				"reselection is tag %d, slot %p(%d)\n",
>  				hostdata->msgin[2], slot, slot->tag);
>  		} else {
> -			struct scsi_cmnd *SCp = scsi_find_tag(SDp, SCSI_NO_TAG);
> +			struct scsi_cmnd *SCp;
> +
> +			SCp = scsi_find_tag(SDp->host, SCSI_NO_TAG);
>  			if(unlikely(SCp == NULL)) {
>  				sdev_printk(KERN_ERR, SDp,
>  					"no saved request for untagged cmd\n");
[...]
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 3833bf5..72a72f9 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -662,32 +662,14 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
>   */
>  int scsi_change_queue_depth(struct scsi_device *sdev, int depth)
>  {
> -	unsigned long flags;
> -
> -	if (depth <= 0)
> -		goto out;
> -
> -	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
> +	if (depth > 0) {
> +		unsigned long flags;
>  
> -	/*
> -	 * Check to see if the queue is managed by the block layer.
> -	 * If it is, and we fail to adjust the depth, exit.
> -	 *
> -	 * Do not resize the tag map if it is a host wide share bqt,
> -	 * because the size should be the hosts's can_queue. If there
> -	 * is more IO than the LLD's can_queue (so there are not enuogh
> -	 * tags) request_fn's host queue ready check will handle it.
> -	 */
> -	if (!shost_use_blk_mq(sdev->host) && !sdev->host->bqt) {
> -		if (blk_queue_tagged(sdev->request_queue) &&
> -		    blk_queue_resize_tags(sdev->request_queue, depth) != 0)
> -			goto out_unlock;
> +		spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
> +		sdev->queue_depth = depth;
> +		spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);

This lock/unlock is a nasty global sync point which can be eliminated:
we can rely on the architectural atomicity of 32 bit writes (might need
to make sdev->queue_depth a u32 because I seem to remember 16 bit writes
had to be done as two byte stores on some architectures).

James


