From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 05/14] blk-mq-sched: don't dequeue request until all in
 ->dispatch are flushed
Date: Tue, 1 Aug 2017 18:44:34 +0800
Message-ID: <20170801104433.GC31452@ming.t460p>
References: <20170731165111.11536-1-ming.lei@redhat.com>
 <20170731165111.11536-7-ming.lei@redhat.com>
 <1501544540.2466.31.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1501544540.2466.31.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 31, 2017 at 11:42:21PM +0000, Bart Van Assche wrote:
> On Tue, 2017-08-01 at 00:51 +0800, Ming Lei wrote:
> > During dispatch, we moved all requests from hctx->dispatch to
> > one temporary list, then dispatch them one by one from this list.
> > Unfortunately duirng this period, run queue from other contexts
> > may think the queue is idle and start to dequeue from sw/scheduler
> > queue and try to dispatch because ->dispatch is empty.
> > 
> > This way will hurt sequential I/O performance because requests are
> > dequeued when queue is busy.
> > 
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  block/blk-mq-sched.c   | 24 ++++++++++++++++++------
> >  include/linux/blk-mq.h |  1 +
> >  2 files changed, 19 insertions(+), 6 deletions(-)
> > 
> > diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
> > index 3510c01cb17b..eb638063673f 100644
> > --- a/block/blk-mq-sched.c
> > +++ b/block/blk-mq-sched.c
> > @@ -112,8 +112,15 @@ void blk_mq_sched_dispatch_requests(struct blk_mq_hw_ctx *hctx)
> >  	 */
> >  	if (!list_empty_careful(&hctx->dispatch)) {
> >  		spin_lock(&hctx->lock);
> > -		if (!list_empty(&hctx->dispatch))
> > +		if (!list_empty(&hctx->dispatch)) {
> >  			list_splice_init(&hctx->dispatch, &rq_list);
> > +
> > +			/*
> > +			 * BUSY won't be cleared until all requests
> > +			 * in hctx->dispatch are dispatched successfully
> > +			 */
> > +			set_bit(BLK_MQ_S_BUSY, &hctx->state);
> > +		}
> >  		spin_unlock(&hctx->lock);
> >  	}
> >  
> > @@ -129,15 +136,20 @@ void blk_mq_sched_dispatch_requests(struct blk_mq_hw_ctx *hctx)
> >  	if (!list_empty(&rq_list)) {
> >  		blk_mq_sched_mark_restart_hctx(hctx);
> >  		can_go = blk_mq_dispatch_rq_list(q, &rq_list);
> > -	} else if (!has_sched_dispatch && !q->queue_depth) {
> > -		blk_mq_flush_busy_ctxs(hctx, &rq_list);
> > -		blk_mq_dispatch_rq_list(q, &rq_list);
> > -		can_go = false;
> > +		if (can_go)
> > +			clear_bit(BLK_MQ_S_BUSY, &hctx->state);
> >  	}
> >  
> > -	if (!can_go)
> > +	/* can't go until ->dispatch is flushed */
> > +	if (!can_go || test_bit(BLK_MQ_S_BUSY, &hctx->state))
> >  		return;
> >  
> > +	if (!has_sched_dispatch && !q->queue_depth) {
> > +		blk_mq_flush_busy_ctxs(hctx, &rq_list);
> > +		blk_mq_dispatch_rq_list(q, &rq_list);
> > +		return;
> > +	}
> 
> Hello Ming,
> 
> Since setting, clearing and testing of BLK_MQ_S_BUSY can happen concurrently
> and since clearing and testing happens without any locks held I'm afraid this

Yes, I really want to avoid lock.

> patch introduces the following race conditions:
> * Clearing of BLK_MQ_S_BUSY immediately after this bit has been set, resulting
>   in this bit not being set although there are requests on the dispatch list.

The window is small enough.

And in the context of setting the BUSY bit, dispatch still can't move on
because 'can_go' will stop that.

Even it happens, no big deal, it just means only one request is dequeued
a bit early. What we really need to avoid is I/O hang.


> * Checking BLK_MQ_S_BUSY after requests have been added to the dispatch list
>   but before that bit is set, resulting in test_bit(BLK_MQ_S_BUSY, &hctx->state)
>   reporting that the BLK_MQ_S_BUSY has not been set although there are requests
>   on the dispatch list.

Same as above, no big deal, we can survive that.


> * Checking BLK_MQ_S_BUSY after requests have been removed from the dispatch list
>   but before that bit is cleared, resulting in test_bit(BLK_MQ_S_BUSY, &hctx->state)
>   reporting that the BLK_MQ_S_BUSY
> has been set although there are no requests
>   on the dispatch list.

That won't be a problem, because dispatch will be started in the
context in which dispatch list is flushed, since the BUSY bit
is cleared after blk_mq_dispatch_rq_list() returns. So no I/O
hang.


-- 
Ming
