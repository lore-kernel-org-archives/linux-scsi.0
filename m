From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V5 5/7] blk-mq-sched: move actual dispatching into one
 helper
Date: Mon, 9 Oct 2017 17:07:42 +0800
Message-ID: <20171009090741.GA22168@ming.t460p>
References: <20170930102720.30219-1-ming.lei@redhat.com>
 <20170930102720.30219-6-ming.lei@redhat.com>
 <20171002141956.GB16855@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171002141956.GB16855@infradead.org>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 02, 2017 at 07:19:56AM -0700, Christoph Hellwig wrote:
> Can you move this to the beginning of your series, just after
> the other edits to blk_mq_sched_dispatch_requests?

OK.

> 
> > +static void blk_mq_do_dispatch_sched(struct request_queue *q,
> > +				     struct elevator_queue *e,
> > +				     struct blk_mq_hw_ctx *hctx)
> 
> No need to pass anything but the hctx here, the other two can
> be trivially derived from it.

OK.

> 
> > +{
> > +	LIST_HEAD(rq_list);
> > +
> > +	do {
> > +		struct request *rq;
> > +
> > +		rq = e->type->ops.mq.dispatch_request(hctx);
> 
> how about shortening this to:
> 
> 	struct request *rq = e->type->ops.mq.dispatch_request(hctx);

OK

> 
> >  void blk_mq_sched_dispatch_requests(struct blk_mq_hw_ctx *hctx)
> >  {
> >  	struct request_queue *q = hctx->queue;
> > @@ -136,16 +152,8 @@ void blk_mq_sched_dispatch_requests(struct blk_mq_hw_ctx *hctx)
> >  	 * on the dispatch list or we were able to dispatch from the
> >  	 * dispatch list.
> >  	 */
> > -	if (do_sched_dispatch && has_sched_dispatch) {
> > -		do {
> > -			struct request *rq;
> > -
> > -			rq = e->type->ops.mq.dispatch_request(hctx);
> > -			if (!rq)
> > -				break;
> > -			list_add(&rq->queuelist, &rq_list);
> > -		} while (blk_mq_dispatch_rq_list(q, &rq_list));
> > -	}
> > +	if (do_sched_dispatch && has_sched_dispatch)
> > +		blk_mq_do_dispatch_sched(q, e, hctx);
> >  }
> 
> Please use this new helper to simplify the logic. E.g.:
> 
> 	if (!list_empty(&rq_list)) {
> 		blk_mq_sched_mark_restart_hctx(hctx);
> 		if (blk_mq_dispatch_rq_list(q, &rq_list) && has_sched_dispatch)
> 			blk_mq_do_dispatch_sched(hctx);
> 	} else if (has_sched_dispatch) {
> 		blk_mq_do_dispatch_sched(hctx);
> 	} else {
> 		blk_mq_flush_busy_ctxs(hctx, &rq_list);
> 		blk_mq_dispatch_rq_list(q, &rq_list);
> 	}

OK

-- 
Ming
