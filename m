From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V5 6/7] blk-mq-sched: improve dispatching from sw queue
Date: Tue, 3 Oct 2017 02:05:27 -0700
Message-ID: <20171003090527.GC21184@infradead.org>
References: <20170930102720.30219-1-ming.lei@redhat.com>
 <20170930102720.30219-7-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170930102720.30219-7-ming.lei@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, Sep 30, 2017 at 06:27:19PM +0800, Ming Lei wrote:
> SCSI devices use host-wide tagset, and the shared
> driver tag space is often quite big. Meantime
> there is also queue depth for each lun(.cmd_per_lun),
> which is often small.
> 
> So lots of requests may stay in sw queue, and we
> always flush all belonging to same hw queue and
> dispatch them all to driver, unfortunately it is
> easy to cause queue busy because of the small
> per-lun queue depth. Once these requests are flushed
> out, they have to stay in hctx->dispatch, and no bio
> merge can participate into these requests, and
> sequential IO performance is hurted.
> 
> This patch improves dispatching from sw queue when
> there is per-request-queue queue depth by taking
> request one by one from sw queue, just like the way
> of IO scheduler.

Once again, use your line length real estate for your change logs..

> +static void blk_mq_do_dispatch_ctx(struct request_queue *q,
> +				   struct blk_mq_hw_ctx *hctx)
> +{
> +	LIST_HEAD(rq_list);
> +	struct blk_mq_ctx *ctx = READ_ONCE(hctx->dispatch_from);
> +	bool dispatched;
> +
> +	do {
> +		struct request *rq;
> +
> +		rq = blk_mq_dequeue_from_ctx(hctx, ctx);

This probably should be merged wit hthe patch that introduceѕ
blk_mq_dequeue_from_ctx.

> +		if (!rq)
> +			break;
> +		list_add(&rq->queuelist, &rq_list);

Btw, do we really need to return a request from blk_mq_dequeue_from_ctx,
or would it be easier to just add it directly to the list passed as
an argument.  I did wonder that about the existing code already.

> +
> +		/* round robin for fair dispatch */
> +		ctx = blk_mq_next_ctx(hctx, rq->mq_ctx);
> +
> +		dispatched = blk_mq_dispatch_rq_list(q, &rq_list);
> +	} while (dispatched);
> +
> +	if (!dispatched)
> +		WRITE_ONCE(hctx->dispatch_from, ctx);

No need for the dispatched argument, just write this as:

	 } while (blk_mq_dispatch_rq_list(q, &rq_list));
	
	WRITE_ONCE(hctx->dispatch_from, ctx);

and do an early return instead of a break from inside the loop.

> +	} else if (!has_sched_dispatch && !q->queue_depth) {
> +		/*
> +		 * If there is no per-request_queue depth, we
> +		 * flush all requests in this hw queue, otherwise
> +		 * pick up request one by one from sw queue for
> +		 * avoiding to mess up I/O merge when dispatch
> +		 * run out of resource, which can be triggered
> +		 * easily by per-request_queue queue depth
> +		 */

Use your 80 line real estate for comments..
