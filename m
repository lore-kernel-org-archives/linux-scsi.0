From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] block: move SCSI timeout check into block
Date: Wed, 17 Dec 2008 09:06:13 +0100
Message-ID: <20081217080613.GC32491@kernel.dk>
References: <1229464844.3193.49.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:8781 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745AbYLQIGm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Dec 2008 03:06:42 -0500
Content-Disposition: inline
In-Reply-To: <1229464844.3193.49.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Dec 16 2008, James Bottomley wrote:
> We can eliminate the SCSI command timed out check entirely if the block
> layer does this for us.  The way to do this in block is to check how
> long the request has been outstanding if a requeue is requested and
> ending it if we've gone over retries * timeout.
> 
> This will also eliminate many cases in SCSI where we evade the command
> timeout for various reasons (like initial success converted to requeue)
> 
> James
> 
> ---
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index c36aa98..d32af31 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -926,6 +926,8 @@ EXPORT_SYMBOL(blk_start_queueing);
>   */
>  void blk_requeue_request(struct request_queue *q, struct request *rq)
>  {
> +	unsigned long wait_for = (rq->retries + 1) * rq->timeout;
> +
>  	blk_delete_timer(rq);
>  	blk_clear_rq_complete(rq);
>  	blk_add_trace_rq(q, rq, BLK_TA_REQUEUE);
> @@ -933,7 +935,17 @@ void blk_requeue_request(struct request_queue *q, struct request *rq)
>  	if (blk_rq_tagged(rq))
>  		blk_queue_end_tag(q, rq);
>  
> -	elv_requeue_request(q, rq);
> +	if (time_before(rq->start_time + wait_for, jiffies)) {

I prefer time_after(), reads better.

> +		int bytes = (rq->hard_nr_sectors << 9);
> +
> +		printk(KERN_ERR "%s: timing out command, waited %lus\n",
> +		       rq->rq_disk ? rq->rq_disk->disk_name : "?",
> +		       wait_for/HZ);
> +		if (blk_pc_request(rq))
> +			bytes = rq->data_len;
> +		blk_end_request(rq, -EIO, bytes);

You can just do

                blk_end_request(rq, -EIO, blk_rq_bytes(rq));

and get rid of the 'bytes' variable and type check.

> +	} else
> +		elv_requeue_request(q, rq);
>  }
>  EXPORT_SYMBOL(blk_requeue_request);

But I agree with the patch. Will you rediff, or shall I just apply with
the suggest changes?

-- 
Jens Axboe

