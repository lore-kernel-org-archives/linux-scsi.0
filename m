From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH V7 4/6] blk-mq: introduce .get_budget and .put_budget in
 blk_mq_ops
Date: Thu, 12 Oct 2017 12:46:24 -0600
Message-ID: <9a741c03-90a3-e583-ddde-0ed71c8570a2@kernel.dk>
References: <20171012183704.22326-1-ming.lei@redhat.com>
 <20171012183704.22326-5-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171012183704.22326-5-ming.lei@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On 10/12/2017 12:37 PM, Ming Lei wrote:
> For SCSI devices, there is often per-request-queue depth, which need
> to be respected before queuing one request.
> 
> The current blk-mq always dequeues one request first, then calls .queue_rq()
> to dispatch the request to lld. One obvious issue of this way is that I/O
> merge may not be good, because when the per-request-queue depth can't be
> respected,  .queue_rq() has to return BLK_STS_RESOURCE, then this request
> has to staty in hctx->dispatch list, and never got chance to participate
> into I/O merge.
> 
> This patch introduces .get_budget and .put_budget callback in blk_mq_ops,
> then we can try to get reserved budget first before dequeuing request.
> Once we can't get budget for queueing I/O, we don't need to dequeue request
> at all, then I/O merge can get improved a lot.

I can't help but think that it would be cleaner to just be able to
reinsert the request into the scheduler properly, if we fail to
dispatch it. Bart hinted at that earlier as well.

With that, you would not need budget functions.

I don't feel _that_ strongly about it, though, and it is something
we can do down the line as well. I'd just hate having to introduce
budget ops only to kill them a little later.

If we stick with the budget, then add a parallel blk_mq_get_budget()
like you have a blk_mq_put_budget(), so we don't have to litter the code
with things like:

> +		if (q->mq_ops->get_budget && !q->mq_ops->get_budget(hctx))
> +			return true;

all over the place. There are also a few places where you don't use
blk_mq_put_budget() but open-code it instead, you should be consistent.

-- 
Jens Axboe
