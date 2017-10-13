From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH V8 4/7] blk-mq: introduce .get_budget and .put_budget in
 blk_mq_ops
Date: Fri, 13 Oct 2017 11:32:41 -0600
Message-ID: <cbeb8016-4f0d-3054-a161-aa48bb63b5a5@kernel.dk>
References: <20171013172459.1376-1-ming.lei@redhat.com>
 <20171013172459.1376-5-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171013172459.1376-5-ming.lei@redhat.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On 10/13/2017 11:24 AM, Ming Lei wrote:
> For SCSI devices, there is often per-request-queue depth, which need
> to be respected before queuing one request.
> 
> The current blk-mq always dequeues request first, then calls .queue_rq()
> to dispatch the request to lld. One obvious issue of this way is that I/O
> merge may not be good, because when the per-request-queue depth can't be
> respected, .queue_rq() has to return BLK_STS_RESOURCE, then this request
> has to stay in hctx->dispatch list, and never got chance to participate
> into I/O merge.
> 
> This patch introduces .get_budget and .put_budget callback in blk_mq_ops,
> then we can try to get reserved budget first before dequeuing request.
> Once the budget for queueing I/O can't be satisfied, we don't need to
> dequeue request at all, then I/O merge can get improved a lot.

Still think this should be blk_mq_get_dispatch_budget(), like in the
incremental I sent out. That way you actually know what it is doing,
get_budget() could be anything.

> @@ -2582,6 +2606,9 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
>  	if (!set->ops->queue_rq)
>  		return -EINVAL;
>  
> +	if ((!!set->ops->get_budget) != (!!set->ops->put_budget))
> +		return -EINVAL;

	if (!set->ops->get_budget ^ !set->ops->put_budget)

is cleaner, imho.

-- 
Jens Axboe
