From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 3/3] block: move the padding adjustment to blk_rq_map_sg
Date: Thu, 10 Apr 2008 18:02:05 +0300
Message-ID: <47FE2BED.10508@panasas.com>
References: <1207837033-23835-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1207837033-23835-2-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1207837033-23835-3-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1207837033-23835-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:47759 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758964AbYDJPEd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Apr 2008 11:04:33 -0400
In-Reply-To: <1207837033-23835-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Tejun Heo <htejun@gmail.com>
Cc: linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>

On Thu, Apr 10 2008 at 17:17 +0300, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> blk_rq_map_user adjusts bi_size of the last bio. It breaks the rule
> that req->data_len (the true data length) is equal to sum(bio). It
> broke the scsi command completion code.
> 
> commit e97a294ef6938512b655b1abf17656cf2b26f709 was introduced to fix
> the above issue. However, the partial completion code doesn't work
> with it. The commit is also a layer violation (scsi mid-layer should
> not know about the block layer's padding).
> 
> This patch moves the padding adjustment to blk_rq_map_sg (suggested by
> James). The padding works like the drain buffer. This patch breaks the
> rule that req->data_len is equal to sum(sg), however, the drain buffer
> already broke it. So this patch just restores the rule that
> req->data_len is equal to sub(bio) without breaking anything new.
> 
> Now when a low level driver needs padding, blk_rq_map_user and
> blk_rq_map_user_iov guarantee there's enough room for padding.
> blk_rq_map_sg can safely extend the last entry of a scatter list.
> 

This is a grave bug this patchset must be submitted for 2.6.25 stable
releases after it has been tested.

> blk_rq_map_sg must extend the last entry of a scatter list only for a
> request that got through bio_copy_user_iov. This patches introduces
> new REQ_COPY_USER flag.
> 

What about blk_rq_map_kern? should we have a BUG_ON if a kernel driver
submits unaligned mapping according to what driver has set.

> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Tejun Heo <htejun@gmail.com>
> Cc: Mike Christie <michaelc@cs.wisc.edu>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> ---
>  block/blk-map.c        |   24 +++++-------------------
>  block/blk-merge.c      |    9 +++++++++
>  drivers/scsi/scsi.c    |    2 +-
>  include/linux/blkdev.h |    2 ++
>  4 files changed, 17 insertions(+), 20 deletions(-)
> 
> diff --git a/block/blk-map.c b/block/blk-map.c
> index ab43533..3c942bd 100644
> --- a/block/blk-map.c
> +++ b/block/blk-map.c
> @@ -141,25 +141,8 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
>  		ubuf += ret;
>  	}
>  
> -	/*
> -	 * __blk_rq_map_user() copies the buffers if starting address
> -	 * or length isn't aligned to dma_pad_mask.  As the copied
> -	 * buffer is always page aligned, we know that there's enough
> -	 * room for padding.  Extend the last bio and update
> -	 * rq->data_len accordingly.
> -	 *
> -	 * On unmap, bio_uncopy_user() will use unmodified
> -	 * bio_map_data pointed to by bio->bi_private.
> -	 */
> -	if (len & q->dma_pad_mask) {
> -		unsigned int pad_len = (q->dma_pad_mask & ~len) + 1;
> -		struct bio *tail = rq->biotail;
> -
> -		tail->bi_io_vec[tail->bi_vcnt - 1].bv_len += pad_len;
> -		tail->bi_size += pad_len;
> -
> -		rq->extra_len += pad_len;
> -	}
> +	if (!bio_flagged(bio, BIO_USER_MAPPED))
> +		rq->cmd_flags |= REQ_COPY_USER;
>  
>  	rq->buffer = rq->data = NULL;
>  	return 0;
> @@ -224,6 +207,9 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
>  		return -EINVAL;
>  	}
>  
> +	if (!bio_flagged(bio, BIO_USER_MAPPED))
> +		rq->cmd_flags |= REQ_COPY_USER;
> +
>  	bio_get(bio);
>  	blk_rq_bio_prep(q, rq, bio);
>  	rq->buffer = rq->data = NULL;
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index 0f58616..b5c5c4a 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -220,6 +220,15 @@ new_segment:
>  		bvprv = bvec;
>  	} /* segments in rq */
>  
> +
> +	if (unlikely(rq->cmd_flags & REQ_COPY_USER) &&
> +	    (rq->data_len & q->dma_pad_mask)) {

+	if (rq->data_len & q->dma_pad_mask) {
+		BUG_ON(!(rq->cmd_flags & REQ_COPY_USER));

> +		unsigned int pad_len = (q->dma_pad_mask & ~rq->data_len) + 1;
> +
> +		sg->length += pad_len;
> +		rq->extra_len += pad_len;
> +	}
> +
>  	if (q->dma_drain_size && q->dma_drain_needed(rq)) {
>  		if (rq->cmd_flags & REQ_RW)
>  			memset(q->dma_drain_buffer, 0, q->dma_drain_size);
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index c78b836..7a85cb3 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -759,7 +759,7 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
>  				"Notifying upper driver of completion "
>  				"(result %x)\n", cmd->result));
>  
> -	good_bytes = scsi_bufflen(cmd) + cmd->request->extra_len;

good god this is going into 2.6.25 kernel? ?!?!
why was it not put in blk_end_request ?

> +	good_bytes = scsi_bufflen(cmd);
>          if (cmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
>  		drv = scsi_cmd_to_driver(cmd);
>  		if (drv->done)
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 6f79d40..b3a58ad 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -112,6 +112,7 @@ enum rq_flag_bits {
>  	__REQ_RW_SYNC,		/* request is sync (O_DIRECT) */
>  	__REQ_ALLOCED,		/* request came from our alloc pool */
>  	__REQ_RW_META,		/* metadata io request */
> +	__REQ_COPY_USER,	/* contains copies of user pages */
>  	__REQ_NR_BITS,		/* stops here */
>  };
>  
> @@ -133,6 +134,7 @@ enum rq_flag_bits {
>  #define REQ_RW_SYNC	(1 << __REQ_RW_SYNC)
>  #define REQ_ALLOCED	(1 << __REQ_ALLOCED)
>  #define REQ_RW_META	(1 << __REQ_RW_META)
> +#define REQ_COPY_USER	(1 << __REQ_COPY_USER)
>  
>  #define BLK_MAX_CDB	16
>  

Boaz is :'(

