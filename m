From: Boaz Harrosh <ooo@electrozaur.com>
Subject: Re: [PATCH 7/7] block: allocate block_pc data separate from struct
 request
Date: Wed, 06 May 2015 14:46:18 +0300
Message-ID: <5549FF0A.6010901@electrozaur.com>
References: <1429303042-12078-1-git-send-email-hch@lst.de> <1429303042-12078-8-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:36137 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbbEFLqW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 May 2015 07:46:22 -0400
Received: by wgiu9 with SMTP id u9so8501977wgi.3
        for <linux-scsi@vger.kernel.org>; Wed, 06 May 2015 04:46:21 -0700 (PDT)
In-Reply-To: <1429303042-12078-8-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, linux-nvme@lists.infradead.org
Cc: linux-scsi@vger.kernel.org

On 04/17/2015 11:37 PM, Christoph Hellwig wrote:
> Don't bloat struct request with BLOCK_PC specific fields.
> 
> WIP, breaks dm BLOCK_PC passthrough and the old IDE driver for now.
<>
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 2e5020f..5d78a85 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
<>
> @@ -1274,15 +1270,24 @@ EXPORT_SYMBOL(blk_make_request);
>  /**
>   * blk_rq_set_block_pc - initialize a request to type BLOCK_PC
>   * @rq:		request to be initialized
> + * @cmd_len:	length of the CDB
> + * @gfp:	kmalloc flags
>   *
>   */
> -void blk_rq_set_block_pc(struct request *rq)
> +int blk_rq_set_block_pc(struct request *rq, unsigned short cmd_len,
> +		u8 *sense, gfp_t gfp)
>  {
>  	rq->cmd_type = REQ_TYPE_BLOCK_PC;
>  	rq->__data_len = 0;
>  	rq->__sector = (sector_t) -1;
>  	rq->bio = rq->biotail = NULL;
> -	memset(rq->__cmd, 0, sizeof(rq->__cmd));
> +
> +	rq->block_pc = kzalloc(sizeof(*rq->block_pc) + cmd_len, gfp);

I wish you would not embed a dynamic allocation here for any
driver regardless. This extra allocation does hurt a lot. See how in
SCSI fs commands you embedded it in scsi_cmnd so it catches as well
for multi-Q pre-allocation.

I think you need to just make it the same as *sense pass it from outside
and the allocation is the caller responsibility. The caller must have
an end-request call back set. (Or is a sync call)

Usually all users already have a structure to put this in. The only bit
more work is to take care of the free. If they are already passing sense
then they already need to free at end of request. Those that are synchronous
can have it on the stack. Only very few places need a bit of extra work.


> +	if (!rq->block_pc)
> +		return -ENOMEM;
> +	rq->block_pc->cmd_len = cmd_len;
> +	rq->block_pc->sense = sense;
> +	return 0;
>  }
>  EXPORT_SYMBOL(blk_rq_set_block_pc);
>  
> @@ -1379,6 +1384,10 @@ void __blk_put_request(struct request_queue *q, struct request *req)
>  	if (unlikely(!q))
>  		return;
>  
> +	/* could also be other type-specific data */
> +	if (req->block_pc)
> +		kfree(req->block_pc);
> +
>  	if (q->mq_ops) {
>  		blk_mq_free_request(req);
>  		return;
> diff --git a/block/blk-exec.c b/block/blk-exec.c
> index 3fec8a2..94e909e 100644
> --- a/block/blk-exec.c
> +++ b/block/blk-exec.c
> @@ -10,11 +10,6 @@
>  
>  #include "blk.h"
>  
> -/*
> - * for max sense size
> - */
> -#include <scsi/scsi_cmnd.h>
> -
>  /**
>   * blk_end_sync_rq - executes a completion event on a request
>   * @rq: request to complete
> @@ -100,16 +95,9 @@ int blk_execute_rq(struct request_queue *q, struct gendisk *bd_disk,
>  		   struct request *rq, int at_head)
>  {
>  	DECLARE_COMPLETION_ONSTACK(wait);
> -	char sense[SCSI_SENSE_BUFFERSIZE];
>  	int err = 0;
>  	unsigned long hang_check;
>  
> -	if (!rq->sense) {
> -		memset(sense, 0, sizeof(sense));
> -		rq->sense = sense;
> -		rq->sense_len = 0;
> -	}
> -
>  	rq->end_io_data = &wait;
>  	blk_execute_rq_nowait(q, bd_disk, rq, at_head, blk_end_sync_rq);
>  
> @@ -123,11 +111,6 @@ int blk_execute_rq(struct request_queue *q, struct gendisk *bd_disk,
>  	if (rq->errors)
>  		err = -EIO;
>  
> -	if (rq->sense == sense)	{
> -		rq->sense = NULL;
> -		rq->sense_len = 0;
> -	}
> -
>  	return err;
>  }
>  EXPORT_SYMBOL(blk_execute_rq);
<>
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 2da818a..e64a01b 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -80,6 +80,16 @@ enum rq_cmd_type_bits {
>  #define BLK_MAX_CDB	16
>  
>  /*
> + * when request is used as a packet command carrier
> + */
> +struct block_pc_request {
> +	unsigned short cmd_len;
> +	unsigned int sense_len;
> +	void *sense;

Better move cmd_len here the short will combine well
with the char array.

> +	unsigned char cmd[];
> +};
> +
> +/*
>   * Try to put the fields that are referenced together in the same cacheline.
>   *
>   * If you modify this structure, make sure to update blk_rq_init() and
> @@ -172,23 +182,19 @@ struct request {
>  	int tag;
>  	int errors;
>  
> -	/*
> -	 * when request is used as a packet command carrier
> -	 */
> -	unsigned char __cmd[BLK_MAX_CDB];
> -	unsigned char *cmd;
> -	unsigned short cmd_len;
> -
>  	unsigned int extra_len;	/* length of alignment and padding */
> -	unsigned int sense_len;
>  	unsigned int resid_len;	/* residual count */
> -	void *sense;
>  
>  	unsigned long deadline;
>  	struct list_head timeout_list;
>  	unsigned int timeout;
>  	int retries;
>  
> +	union {
> +		struct block_pc_request *block_pc;
> +		void *drv_private;
> +	};
> +

Exactly. drv_private is allocated by caller we can do the same for
block_pc. Also If (theoretically) a driver needs both it is just the
same pointer right? (container_of)

>  	/*
>  	 * completion callback.
>  	 */
> @@ -769,7 +775,8 @@ extern void __blk_put_request(struct request_queue *, struct request *);
>  extern struct request *blk_get_request(struct request_queue *, int, gfp_t);
>  extern struct request *blk_make_request(struct request_queue *, struct bio *,
>  					gfp_t);
> -extern void blk_rq_set_block_pc(struct request *);
> +int blk_rq_set_block_pc(struct request *rq, unsigned short cmd_len,
> +		u8 *sense, gfp_t gfp);
>  extern void blk_requeue_request(struct request_queue *, struct request *);
>  extern void blk_add_request_payload(struct request *rq, struct page *page,
>  		unsigned int len);
<>
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 9fc1aec..de6d7d0 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -92,7 +92,7 @@ struct scsi_cmnd {
>  
>  	/* These elements define the operation we are about to perform */
>  	unsigned char *cmnd;
> -
> +	unsigned char __cmnd[32];
>  
>  	/* These elements define the operation we ultimately want to perform */
>  	struct scsi_data_buffer sdb;
<>

Thanks
Boaz

