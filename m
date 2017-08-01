From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 04/14] blk-mq-sched: improve dispatching from sw queue
Date: Tue, 1 Aug 2017 18:50:15 +0800
Message-ID: <20170801105013.GD31452@ming.t460p>
References: <20170731165111.11536-1-ming.lei@redhat.com>
 <20170731165111.11536-6-ming.lei@redhat.com>
 <1501544074.2466.29.camel@wdc.com>
 <20170801101718.GB31452@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38462 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751631AbdHAKue (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 1 Aug 2017 06:50:34 -0400
Content-Disposition: inline
In-Reply-To: <20170801101718.GB31452@ming.t460p>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On Tue, Aug 01, 2017 at 06:17:18PM +0800, Ming Lei wrote:
> On Mon, Jul 31, 2017 at 11:34:35PM +0000, Bart Van Assche wrote:
> > On Tue, 2017-08-01 at 00:51 +0800, Ming Lei wrote:
> > > SCSI devices use host-wide tagset, and the shared
> > > driver tag space is often quite big. Meantime
> > > there is also queue depth for each lun(.cmd_per_lun),
> > > which is often small.
> > > 
> > > So lots of requests may stay in sw queue, and we
> > > always flush all belonging to same hw queue and
> > > dispatch them all to driver, unfortunately it is
> > > easy to cause queue busy becasue of the small
> > > per-lun queue depth. Once these requests are flushed
> > > out, they have to stay in hctx->dispatch, and no bio
> > > merge can participate into these requests, and
> > > sequential IO performance is hurted.
> > > 
> > > This patch improves dispatching from sw queue when
> > > there is per-request-queue queue depth by taking
> > > request one by one from sw queue, just like the way
> > > of IO scheduler.
> > > 
> > > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > > ---
> > >  block/blk-mq-sched.c | 25 +++++++++++++++----------
> > >  1 file changed, 15 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
> > > index 47a25333a136..3510c01cb17b 100644
> > > --- a/block/blk-mq-sched.c
> > > +++ b/block/blk-mq-sched.c
> > > @@ -96,6 +96,9 @@ void blk_mq_sched_dispatch_requests(struct blk_mq_hw_ctx *hctx)
> > >  	const bool has_sched_dispatch = e && e->type->ops.mq.dispatch_request;
> > >  	bool can_go = true;
> > >  	LIST_HEAD(rq_list);
> > > +	struct request *(*dispatch_fn)(struct blk_mq_hw_ctx *) =
> > > +		has_sched_dispatch ? e->type->ops.mq.dispatch_request :
> > > +			blk_mq_dispatch_rq_from_ctxs;
> > >  
> > >  	/* RCU or SRCU read lock is needed before checking quiesced flag */
> > >  	if (unlikely(blk_mq_hctx_stopped(hctx) || blk_queue_quiesced(q)))
> > > @@ -126,26 +129,28 @@ void blk_mq_sched_dispatch_requests(struct blk_mq_hw_ctx *hctx)
> > >  	if (!list_empty(&rq_list)) {
> > >  		blk_mq_sched_mark_restart_hctx(hctx);
> > >  		can_go = blk_mq_dispatch_rq_list(q, &rq_list);
> > > -	} else if (!has_sched_dispatch) {
> > > +	} else if (!has_sched_dispatch && !q->queue_depth) {
> > >  		blk_mq_flush_busy_ctxs(hctx, &rq_list);
> > >  		blk_mq_dispatch_rq_list(q, &rq_list);
> > > +		can_go = false;
> > >  	}
> > >  
> > > +	if (!can_go)
> > > +		return;
> > > +
> > >  	/*
> > >  	 * We want to dispatch from the scheduler if we had no work left
> > >  	 * on the dispatch list, OR if we did have work but weren't able
> > >  	 * to make progress.
> > >  	 */
> > > -	if (can_go && has_sched_dispatch) {
> > > -		do {
> > > -			struct request *rq;
> > > +	do {
> > > +		struct request *rq;
> > >  
> > > -			rq = e->type->ops.mq.dispatch_request(hctx);
> > > -			if (!rq)
> > > -				break;
> > > -			list_add(&rq->queuelist, &rq_list);
> > > -		} while (blk_mq_dispatch_rq_list(q, &rq_list));
> > > -	}
> > > +		rq = dispatch_fn(hctx);
> > > +		if (!rq)
> > > +			break;
> > > +		list_add(&rq->queuelist, &rq_list);
> > > +	} while (blk_mq_dispatch_rq_list(q, &rq_list));
> > >  }
> > 
> > Hello Ming,
> > 
> > Although I like the idea behind this patch, I'm afraid that this patch will
> > cause a performance regression for high-performance SCSI LLD drivers, e.g.
> > ib_srp. Have you considered to rework this patch as follows:
> > * Remove the code under "else if (!has_sched_dispatch && !q->queue_depth) {".
> 
> This will affect devices such as NVMe in which busy isn't triggered
> basically, so better to not do this.
> 
> > * Modify all blk_mq_dispatch_rq_list() functions such that these dispatch up
> >   to cmd_per_lun - (number of requests in progress) at once.
> 
> How can we get the accurate 'number of requests in progress' efficiently?
> 
> And we have done it in this way for blk-mq scheduler already, so it
> shouldn't be a problem.
> 
> From my test data of mq-deadline on lpfc, the performance is good,
> please see it in cover letter.

Forget to mention, ctx->list is one per-cpu list and the lock is percpu
lock, so changing to this way shouldn't be a performance issue.

-- 
Ming
