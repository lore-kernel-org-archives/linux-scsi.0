From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/7] blk_end_request: add new request completion
	interface
Date: Mon, 3 Sep 2007 09:45:45 +0200
Message-ID: <20070903074545.GH4253@kernel.dk>
References: <20070831.184112.45519768.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070831.184112.45519768.k-ueda@ct.jp.nec.com>
Sender: linux-ide-owner@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, mike.miller@hp.com, grant.likely@secretlab.ca, dm-devel@redhat.com, j-nomura@ce.jp.nec.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 31 2007, Kiyoshi Ueda wrote:
> This patch adds 2 new interfaces for request completion:
>   o blk_end_request()   : called without queue lock
>   o __blk_end_request() : called with queue lock held
> 
> Some device drivers call some generic functions below between
> end_that_request_{first/chunk} and end_that_request_last().
>   o add_disk_randomness()
>   o blk_queue_end_tag()
>   o blkdev_dequeue_request()
> These are called in the blk_end_request() as a part of generic
> request completion.
> So all device drivers become to call above functions.
> 
> Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> ---
>  block/ll_rw_blk.c      |   82 +++++++++++++++++++++++++++++++++++++++++++++++++ include/linux/blkdev.h |    2 +
>  2 files changed, 84 insertions(+)
> 
> diff -rupN 2.6.23-rc3-mm1/block/ll_rw_blk.c 01-blkendreq-interface/block/ll_rw_blk.c
> --- 2.6.23-rc3-mm1/block/ll_rw_blk.c	2007-08-22 18:54:03.000000000 -0400
> +++ 01-blkendreq-interface/block/ll_rw_blk.c	2007-08-23 17:19:20.000000000 -0400
> @@ -3669,6 +3669,88 @@ void end_request(struct request *req, in
>  
>  EXPORT_SYMBOL(end_request);
>  
> +/**
> + * ____blk_end_request - Generic end_io function to complete a request.
> + * @rq:           the request being processed
> + * @uptodate:     1 for success, 0 for I/O error, < 0 for specific error
> + * @nr_bytes:     number of bytes to complete
> + * @needlock:     1 for queue lock need to be held.
> + *                0 for queue lock held already.
> + *
> + * Description:
> + *     Ends I/O on a number of bytes attached to @rq.
> + *     If @rq has leftover, sets it up for the next range of segments.
> + *
> + * Return:
> + *     0 - we are done with this request
> + *     1 - this request is not freed yet, it still has pending buffers.
> + **/
> +static int ____blk_end_request(struct request *rq, int uptodate, int nr_bytes,
> +			       int needlock)
> +{
> +	struct request_queue *q = rq->q;
> +	unsigned long flags = 0UL;
> +
> +	if (blk_fs_request(rq) || blk_pc_request(rq)) {
> +		if (__end_that_request_first(rq, uptodate, nr_bytes))
> +			return 1;
> +	}
> +
> +	/*
> +	 * No need to check the argument here because it is done
> +	 * in add_disk_randomness().
> +	 */
> +	add_disk_randomness(rq->rq_disk);
> +
> +	if (needlock)
> +		spin_lock_irqsave(q->queue_lock, flags);
> +
> +	if (blk_rq_tagged(rq))
> +		blk_queue_end_tag(q, rq);
> +
> +	if (!list_empty(&rq->queuelist))
> +		blkdev_dequeue_request(rq);
> +
> +	end_that_request_last(rq, uptodate);
> +
> +	if (needlock)
> +		spin_unlock_irqrestore(q->queue_lock, flags);
> +
> +	return 0;
> +}
> +
> +/**
> + * blk_end_request - Helper function for drivers to complete the request.
> + * @rq:       the request being processed
> + * @uptodate: 1 for success, 0 for I/O error, < 0 for specific error
> + * @nr_bytes: number of bytes to complete
> + *
> + * Description:
> + *     Ends I/O on a number of bytes attached to @rq.
> + *     If @rq has leftover, sets it up for the next range of segments.
> + *
> + * Return:
> + *     0 - we are done with this request
> + *     1 - still buffers pending for this request
> + **/
> +int blk_end_request(struct request *rq, int uptodate, int nr_bytes)
> +{
> +	return ____blk_end_request(rq, uptodate, nr_bytes, 1);
> +}
> +EXPORT_SYMBOL_GPL(blk_end_request);
> +
> +/**
> + * __blk_end_request - Helper function for drivers to complete the request.
> + *
> + * Description:
> + *     Must be called with queue lock held unlike blk_end_request().
> + **/
> +int __blk_end_request(struct request *rq, int uptodate, int nr_bytes)
> +{
> +	return ____blk_end_request(rq, uptodate, nr_bytes, 0);
> +}
> +EXPORT_SYMBOL_GPL(__blk_end_request);
> +
>  void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
>  		     struct bio *bio)
>  {
> diff -rupN 2.6.23-rc3-mm1/include/linux/blkdev.h 01-blkendreq-interface/include/linux/blkdev.h
> --- 2.6.23-rc3-mm1/include/linux/blkdev.h	2007-08-13 00:25:24.000000000 -0400
> +++ 01-blkendreq-interface/include/linux/blkdev.h	2007-08-23 17:22:50.000000000 -0400
> @@ -728,6 +728,8 @@ static inline void blk_run_address_space
>   * for parts of the original function. This prevents
>   * code duplication in drivers.
>   */
> +extern int blk_end_request(struct request *rq, int uptodate, int nr_bytes);
> +extern int __blk_end_request(struct request *rq, int uptodate, int nr_bytes);
>  extern int end_that_request_first(struct request *, int, int);
>  extern int end_that_request_chunk(struct request *, int, int);
>  extern void end_that_request_last(struct request *, int);

We get in to way too many levels of underscores here. Please changes
this to be blk_end_request() and blk_end_request_locked(), where the
former grabs the queue lock but the latter assumes it's held. Then have
the static __blk_end_request() where the lock MUST be held - do this in
the caller, don't pass it as an argument!

-- 
Jens Axboe

