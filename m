From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] block: add global timeout to requests
Date: Tue, 24 Mar 2009 12:42:30 +0100
Message-ID: <20090324114230.GO27476@kernel.dk>
References: <1237407667.3350.43.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:37914 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbZCXLmc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Mar 2009 07:42:32 -0400
Content-Disposition: inline
In-Reply-To: <1237407667.3350.43.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Mar 18 2009, James Bottomley wrote:
> We can eliminate the SCSI command timed out check entirely if the block
> layer does this for us.  The way to do this in block is to check how
> long the request has been outstanding if a requeue is requested and
> ending it if we've gone over retries * timeout.
> 
> This will also eliminate many cases in SCSI where we evade the command
> timeout for various reasons (like initial success converted to requeue)
> 
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> 
> ---
> 
> Index: linux-2.6/block/blk-core.c
> ===================================================================
> --- linux-2.6.orig/block/blk-core.c	2009-02-19 16:42:00.140427205 -0500
> +++ linux-2.6/block/blk-core.c	2009-03-18 10:36:10.511526815 -0400
> @@ -937,6 +937,8 @@ EXPORT_SYMBOL(blk_start_queueing);
>   */
>  void blk_requeue_request(struct request_queue *q, struct request *rq)
>  {
> +	unsigned long wait_for = (rq->retries + 1) * rq->timeout;
> +
>  	blk_delete_timer(rq);
>  	blk_clear_rq_complete(rq);
>  	trace_block_rq_requeue(q, rq);
> @@ -944,7 +946,13 @@ void blk_requeue_request(struct request_
>  	if (blk_rq_tagged(rq))
>  		blk_queue_end_tag(q, rq);
>  
> -	elv_requeue_request(q, rq);
> +	if (time_before(rq->start_time + wait_for, jiffies)) {
> +		printk(KERN_ERR "%s: timing out command, waited %lus\n",
> +		       rq->rq_disk ? rq->rq_disk->disk_name : "?",
> +		       wait_for/HZ);
> +		blk_end_request(rq, -EIO, blk_rq_bytes(rq));
> +	} else
> +		elv_requeue_request(q, rq);
>  }
>  EXPORT_SYMBOL(blk_requeue_request);

Applied, though I think a

        time_after(jiffies, time)

is usually much clearer, since we are checking for an expired event (not
an early one) :-)

-- 
Jens Axboe

