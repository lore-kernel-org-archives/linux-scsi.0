From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 02/13] block: add request submission interface
Date: Sun, 14 Sep 2008 16:10:58 +0300
Message-ID: <48CD0D62.4020303@panasas.com>
References: <20080912.103814.74754581.k-ueda@ct.jp.nec.com> <20080912.104152.63132582.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:13544 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754281AbYINNLI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Sep 2008 09:11:08 -0400
In-Reply-To: <20080912.104152.63132582.k-ueda@ct.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: jens.axboe@oracle.com, agk@redhat.com, James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com

Kiyoshi Ueda wrote:
> This patch adds blk_submit_request(), a generic request submission
> interface for request stacking drivers.
> Request-based dm will use it to submit their clones to underlying
> devices.
> 
> blk_rq_check_limits() is also added because it is possible that
> the lower queue has stronger limitations than the upper queue
> if multiple drivers are stacking at request-level.
> Not only for blk_submit_request()'s internal use, the function
> will be used by request-based dm when the queue limitation is
> modified (e.g. by replacing dm's table).
> 
> 
> Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> ---
>  block/blk-core.c       |   81 +++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/blkdev.h |    2 +
>  2 files changed, 83 insertions(+)
> 
> Index: 2.6.27-rc6/block/blk-core.c
> ===================================================================
> --- 2.6.27-rc6.orig/block/blk-core.c
> +++ 2.6.27-rc6/block/blk-core.c
> @@ -1517,6 +1517,87 @@ void submit_bio(int rw, struct bio *bio)
>  EXPORT_SYMBOL(submit_bio);
>  
>  /**
> + * blk_rq_check_limits - Helper function to check a request for the queue limit
> + * @q:  the queue
> + * @rq: the request being checked
> + *
> + * Description:
> + *    @rq may have been made based on weaker limitations of upper-level queues
> + *    in request stacking drivers, and it may violate the limitation of @q.
> + *    Since the block layer and the underlying device driver trust @rq
> + *    after it is inserted to @q, it should be checked against @q before
> + *    the insertion using this generic function.
> + *
> + *    This function should also be useful for request stacking drivers
> + *    in some cases below, so export this fuction.
> + *    Request stacking drivers like request-based dm may change the queue
> + *    limits while requests are in the queue (e.g. dm's table swapping).
> + *    Such request stacking drivers should check those requests agaist
> + *    the new queue limits again when they dispatch those requests,
> + *    although such checkings are also done against the old queue limits
> + *    when submitting requests.
> + */
> +int blk_rq_check_limits(struct request_queue *q, struct request *rq)
> +{
> +	if (rq->nr_sectors > q->max_sectors ||
> +	    rq->data_len > q->max_hw_sectors << 9) {
> +		printk(KERN_ERR "%s: over max size limit.\n", __func__);
> +		return -EIO;
> +	}
> +
> +	/*
> +	 * queue's settings related to segment counting like q->bounce_pfn
> +	 * may differ from that of other stacking queues.
> +	 * Recalculate it to check the request correctly on this queue's
> +	 * limitation.
> +	 */
> +	blk_recalc_rq_segments(rq);
> +	if (rq->nr_phys_segments > q->max_phys_segments ||
> +	    rq->nr_hw_segments > q->max_hw_segments) {
> +		printk(KERN_ERR "%s: over max segments limit.\n", __func__);
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(blk_rq_check_limits);
> +
> +/**
> + * blk_submit_request - Helper for stacking drivers to submit a request
> + * @q:  the queue to submit the request
> + * @rq: the request being queued
> + */
> +int blk_submit_request(struct request_queue *q, struct request *rq)
> +{
> +	unsigned long flags;
> +
> +	if (blk_rq_check_limits(q, rq))
> +		return -EIO;
> +
> +#ifdef CONFIG_FAIL_MAKE_REQUEST
> +	if (rq->rq_disk && rq->rq_disk->flags & GENHD_FL_FAIL &&
> +	    should_fail(&fail_make_request, blk_rq_bytes(rq)))
> +		return -EIO;
> +#endif
> +
> +	spin_lock_irqsave(q->queue_lock, flags);
> +
> +	/*
> +	 * Submitting request must be dequeued before calling this function
> +	 * because it will be linked to another request_queue
> +	 */
> +	BUG_ON(blk_queued_rq(rq));
> +
> +	drive_stat_acct(rq, 1);
> +	__elv_add_request(q, rq, ELEVATOR_INSERT_BACK, 0);
> +
> +	spin_unlock_irqrestore(q->queue_lock, flags);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(blk_submit_request);
> +

This looks awfully similar to blk_execute_rq_nowait With an Added 
blk_rq_check_limits, minus the __generic_unplug_device() and
q->request_fn(q) calls. Perhaps the common code could be re factored
out? Also isn't block-exec.c a better file for this function?

> +/**
>   * __end_that_request_first - end I/O on a request
>   * @req:      the request being processed
>   * @error:    0 for success, < 0 for error
> Index: 2.6.27-rc6/include/linux/blkdev.h
> ===================================================================
> --- 2.6.27-rc6.orig/include/linux/blkdev.h
> +++ 2.6.27-rc6/include/linux/blkdev.h
> @@ -664,6 +664,8 @@ extern void __blk_put_request(struct req
>  extern struct request *blk_get_request(struct request_queue *, int, gfp_t);
>  extern void blk_insert_request(struct request_queue *, struct request *, int, void *);
>  extern void blk_requeue_request(struct request_queue *, struct request *);
> +extern int blk_rq_check_limits(struct request_queue *q, struct request *rq);
> +extern int blk_submit_request(struct request_queue *q, struct request *rq);
>  extern void blk_plug_device(struct request_queue *);
>  extern void blk_plug_device_unlocked(struct request_queue *);
>  extern int blk_remove_plug(struct request_queue *);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


