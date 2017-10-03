From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V5 1/7] blk-mq: issue rq directly in
 blk_mq_request_bypass_insert()
Date: Tue, 3 Oct 2017 21:39:07 +0800
Message-ID: <20171003133901.GA11183@ming.t460p>
References: <20170930102720.30219-1-ming.lei@redhat.com>
 <20170930102720.30219-2-ming.lei@redhat.com>
 <20171003085850.GA21184@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171003085850.GA21184@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 03, 2017 at 01:58:50AM -0700, Christoph Hellwig wrote:
> This patch does two many things at once and needs a split. I also
> don't really understand why it's in this series and not your dm-mpath
> performance one.

Because the following patches only set hctx as busy after
BLK_STS_RESOURCE is returned from .queue_rq(), then add the
rq into hctx->dispatch.

But commit 157f377beb71(block: directly insert blk-mq request from
blk_insert_cloned_request()) just inserts rq into hctx->dispatch
directly, then we can't think hctx as busy any more if there are
requests in hctx->dispatch. That said the commit(157f377beb71)
makes the busy detection approach not working any more.

>
> > +static void blk_mq_request_direct_insert(struct blk_mq_hw_ctx *hctx,
> > +					 struct request *rq)
> > +{
> > +	spin_lock(&hctx->lock);
> > +	list_add_tail(&rq->queuelist, &hctx->dispatch);
> > +	spin_unlock(&hctx->lock);
> > +
> > +	blk_mq_run_hw_queue(hctx, false);
> > +}
> 
> Why doesn't this share code with blk_mq_sched_bypass_insert?

It actually shares the code as this function is called
by blk_mq_request_bypass_insert().

> 
> >  /*
> >   * Should only be used carefully, when the caller knows we want to
> >   * bypass a potential IO scheduler on the target device.
> >   */
> > -void blk_mq_request_bypass_insert(struct request *rq)
> > +blk_status_t blk_mq_request_bypass_insert(struct request *rq)
> >  {
> >  	struct blk_mq_ctx *ctx = rq->mq_ctx;
> >  	struct blk_mq_hw_ctx *hctx = blk_mq_map_queue(rq->q, ctx->cpu);
> > +	blk_qc_t cookie;
> > +	blk_status_t ret;
> >  
> > -	spin_lock(&hctx->lock);
> > -	list_add_tail(&rq->queuelist, &hctx->dispatch);
> > -	spin_unlock(&hctx->lock);
> > -
> > -	blk_mq_run_hw_queue(hctx, false);
> > +	ret = blk_mq_try_issue_directly(hctx, rq, &cookie, true);
> > +	if (ret == BLK_STS_RESOURCE)
> > +		blk_mq_request_direct_insert(hctx, rq);
> > +	return ret;
> 
> If you actually insert the request on BLK_STS_RESOURCE why do you
> pass the error on?  In general BLK_STS_RESOURCE indicates a failure
> to issue.

OK, I will change it into BLK_STS_OK and switch it back in
the dm-rq patches.

> 
> > +/*
> > + * 'dispatch_only' means we only try to dispatch it out, and
> > + * don't deal with dispatch failure if BLK_STS_RESOURCE or
> > + * BLK_STS_IOERR happens.
> > + */
> > +static blk_status_t __blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
> > +		struct request *rq, blk_qc_t *cookie, bool may_sleep,
> > +		bool dispatch_only)
> 
> This dispatch_only argument that completely changes behavior is a
> nightmare.  Try to find a way to have a low-level helper that
> always behaves as if dispatch_only is set, and then build another
> helper that actually issues/completes around it.

OK, I will try to work towards that way.

-- 
Ming
