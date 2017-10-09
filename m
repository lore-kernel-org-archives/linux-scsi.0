From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V5 7/7] blk-mq-sched: don't dequeue request until all in
 ->dispatch are flushed
Date: Mon, 9 Oct 2017 18:40:20 +0800
Message-ID: <20171009104019.GC22168@ming.t460p>
References: <20170930102720.30219-1-ming.lei@redhat.com>
 <20170930102720.30219-8-ming.lei@redhat.com>
 <20171003091128.GD21184@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171003091128.GD21184@infradead.org>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 03, 2017 at 02:11:28AM -0700, Christoph Hellwig wrote:
> This looks good in general:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Minor nitpicks below:
> 
> >  	const bool has_sched_dispatch = e && e->type->ops.mq.dispatch_request;
> 
> This is now only tested once, so you can remove the local variable
> for it.

There are still two users of the local variable, so I suggest to
keep it.

> 
> > +		/*
> > +		 * We may clear DISPATCH_BUSY just after it
> > +		 * is set from another context, the only cost
> > +		 * is that one request is dequeued a bit early,
> > +		 * we can survive that. Given the window is
> > +		 * small enough, no need to worry about performance
> > +		 * effect.
> > +		 */
> 
> Use your 80 line real estate for comments please.

OK.

> 
> >  	if (!has_sched_dispatch)
> > +		if (!q->queue_depth) {
> > +			blk_mq_flush_busy_ctxs(hctx, &rq_list);
> > +			blk_mq_dispatch_rq_list(q, &rq_list);
> > +		} else {
> > +			blk_mq_do_dispatch_ctx(q, hctx);
> > +		}
> > +	} else {
> >  		blk_mq_do_dispatch_sched(q, e, hctx);
> > +	}
> 
> Maybe flatten this out to:
> 
> 	if (e && e->type->ops.mq.dispatch_request) {
> 		blk_mq_do_dispatch_sched(q, e, hctx);
> 	} else if (q->queue_depth) {
> 		blk_mq_do_dispatch_ctx(q, hctx);
> 	} else {
> 		blk_mq_flush_busy_ctxs(hctx, &rq_list);
> 		blk_mq_dispatch_rq_list(q, &rq_list);
> 	}
> 

OK.


-- 
Ming
