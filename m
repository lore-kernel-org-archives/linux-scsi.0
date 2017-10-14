From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V9 4/7] blk-mq: introduce .get_budget and .put_budget in
 blk_mq_ops
Date: Sat, 14 Oct 2017 15:34:24 +0800
Message-ID: <20171014073423.GA31235@ming.t460p>
References: <20171013180532.29304-1-ming.lei@redhat.com>
 <20171013180532.29304-5-ming.lei@redhat.com>
 <1507938223.13345.66.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1507938223.13345.66.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "tom81094@gmail.com" <tom81094@gmail.com>, "paolo.valente@linaro.org" <paolo.valente@linaro.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "john.garry@huawei.com" <john.garry@huawei.com>, "osandov@fb.com" <osandov@fb.com>, "loberman@redhat.com" <loberman@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 13, 2017 at 11:43:44PM +0000, Bart Van Assche wrote:
> On Sat, 2017-10-14 at 02:05 +0800, Ming Lei wrote:
> > @@ -89,19 +89,36 @@ static bool blk_mq_sched_restart_hctx(struct blk_mq_hw_ctx *hctx)
> >  	return false;
> >  }
> >  
> > -static void blk_mq_do_dispatch_sched(struct blk_mq_hw_ctx *hctx)
> > +static bool blk_mq_do_dispatch_sched(struct blk_mq_hw_ctx *hctx)
> 
> Shouldn't the meaning of the return value of this function be documented?

OK, will do it in V10.

> 
> >  {
> >  	struct request_queue *q = hctx->queue;
> >  	struct elevator_queue *e = q->elevator;
> >  	LIST_HEAD(rq_list);
> >  
> >  	do {
> > -		struct request *rq = e->type->ops.mq.dispatch_request(hctx);
> > +		struct request *rq;
> > +		blk_status_t ret;
> >  
> > -		if (!rq)
> > +		if (e->type->ops.mq.has_work &&
> > +				!e->type->ops.mq.has_work(hctx))
> >  			break;
> > +
> > +		ret = blk_mq_get_dispatch_budget(hctx);
> > +		if (ret == BLK_STS_RESOURCE)
> > +			return true;
> > +
> > +		rq = e->type->ops.mq.dispatch_request(hctx);
> > +		if (!rq) {
> > +			blk_mq_put_dispatch_budget(hctx, true);
> > +			break;
> > +		} else if (ret != BLK_STS_OK) {
> > +			blk_mq_end_request(rq, ret);
> > +			continue;
> > +		}
> >  		list_add(&rq->queuelist, &rq_list);
> > -	} while (blk_mq_dispatch_rq_list(q, &rq_list));
> > +	} while (blk_mq_dispatch_rq_list(q, &rq_list, true));
> > +
> > +	return false;
> >  }
> 
> This means that the request in rq_list becomes the owner of the budget allocated
> by blk_mq_get_dispatch_budget(). Shouldn't that be mentioned as a comment above
> blk_mq_dispatch_rq_list()?

OK.

> 
> > +	if (run_queue) {
> > +		if (!blk_mq_sched_needs_restart(hctx) &&
> > +		    !test_bit(BLK_MQ_S_TAG_WAITING, &hctx->state)) {
> > +			blk_mq_sched_mark_restart_hctx(hctx);
> > +			blk_mq_run_hw_queue(hctx, true);
> > +		}
> >  	}
> >  }
> 
> The above if-statement can be changed from a nested if into a single
> if-statement.

OK

>  
> Additionally, why has the code been added to blk_mq_sched_dispatch_requests()
> that reruns the queue if blk_mq_get_dispatch_budget() returned BLK_STS_RESOURCE?

That is because it is the place where we get return of BLK_STS_RESOURCE,
and it can be moved to __blk_mq_run_hw_queue(), but looks no big
difference.

> Is that code necessary or can it be left out?

It is necessary.

Without dispatch budget obtained, we don't dequeue now, and actually
do nothing, so we have to rerun the hw queue.

> 
> > +static inline void blk_mq_put_dispatch_budget(struct blk_mq_hw_ctx *hctx,
> > +		bool got_budget)
> > +{
> > +	struct request_queue *q = hctx->queue;
> > +
> > +	if (q->mq_ops->put_budget && got_budget)
> > +		q->mq_ops->put_budget(hctx);
> > +}
> 
> So the above function is passed a boolean as second argument and all what
> that boolean is used for is to decide whether or not the function is executed?
> Sorry but I think that's wrong and that the second argument should be removed
> and that it should be evaluated by the caller instead of inside
> blk_mq_put_dispatch_budget().

This way makes code clean. And not a big deal, I may change back to the
way you suggested.

-- 
Ming
