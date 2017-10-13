From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V7 4/6] blk-mq: introduce .get_budget and .put_budget in
 blk_mq_ops
Date: Fri, 13 Oct 2017 08:19:24 +0800
Message-ID: <20171013001919.GA24715@ming.t460p>
References: <20171012183704.22326-1-ming.lei@redhat.com>
 <20171012183704.22326-5-ming.lei@redhat.com>
 <9a741c03-90a3-e583-ddde-0ed71c8570a2@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9a741c03-90a3-e583-ddde-0ed71c8570a2@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 12, 2017 at 12:46:24PM -0600, Jens Axboe wrote:
> On 10/12/2017 12:37 PM, Ming Lei wrote:
> > For SCSI devices, there is often per-request-queue depth, which need
> > to be respected before queuing one request.
> > 
> > The current blk-mq always dequeues one request first, then calls .queue_rq()
> > to dispatch the request to lld. One obvious issue of this way is that I/O
> > merge may not be good, because when the per-request-queue depth can't be
> > respected,  .queue_rq() has to return BLK_STS_RESOURCE, then this request
> > has to staty in hctx->dispatch list, and never got chance to participate
> > into I/O merge.
> > 
> > This patch introduces .get_budget and .put_budget callback in blk_mq_ops,
> > then we can try to get reserved budget first before dequeuing request.
> > Once we can't get budget for queueing I/O, we don't need to dequeue request
> > at all, then I/O merge can get improved a lot.
> 
> I can't help but think that it would be cleaner to just be able to
> reinsert the request into the scheduler properly, if we fail to
> dispatch it. Bart hinted at that earlier as well.

Actually when I start to investigate the issue, the 1st thing I tried
is to reinsert, but that way is even worse on qla2xxx.

Once request is dequeued, the IO merge chance is decreased a lot.
With none scheduler, it becomes not possible to merge because
we only try to merge over the last 8 requests. With mq-deadline,
when one request is reinserted, another request may be dequeued
at the same time.

Not mention the cost of acquiring/releasing lock, that work
is just doing useless work and wasting CPU.

> 
> With that, you would not need budget functions.
> 
> I don't feel _that_ strongly about it, though, and it is something
> we can do down the line as well. I'd just hate having to introduce
> budget ops only to kill them a little later.
> 
> If we stick with the budget, then add a parallel blk_mq_get_budget()
> like you have a blk_mq_put_budget(), so we don't have to litter the code
> with things like:
> 
> > +		if (q->mq_ops->get_budget && !q->mq_ops->get_budget(hctx))
> > +			return true;
> 
> all over the place. There are also a few places where you don't use
> blk_mq_put_budget() but open-code it instead, you should be consistent.

OK.


-- 
Ming
