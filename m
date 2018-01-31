From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v5] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Tue, 30 Jan 2018 19:44:27 -0700
Message-ID: <2f7ea970-bd0d-d2c2-429b-c6eeb1694507@kernel.dk>
References: <20180130142459.52668-1-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180130142459.52668-1-snitzer@redhat.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

On 1/30/18 7:24 AM, Mike Snitzer wrote:
> From: Ming Lei <ming.lei@redhat.com>
> 
> This status is returned from driver to block layer if device related
> resource is unavailable, but driver can guarantee that IO dispatch
> will be triggered in future when the resource is available.
> 
> Convert some drivers to return BLK_STS_DEV_RESOURCE.  Also, if driver
> returns BLK_STS_RESOURCE and SCHED_RESTART is set, rerun queue after
> a delay (BLK_MQ_DELAY_QUEUE) to avoid IO stalls.  BLK_MQ_DELAY_QUEUE is
> 3 ms because both scsi-mq and nvmefc are using that magic value.
> 
> If a driver can make sure there is in-flight IO, it is safe to return
> BLK_STS_DEV_RESOURCE because:
> 
> 1) If all in-flight IOs complete before examining SCHED_RESTART in
> blk_mq_dispatch_rq_list(), SCHED_RESTART must be cleared, so queue
> is run immediately in this case by blk_mq_dispatch_rq_list();
> 
> 2) if there is any in-flight IO after/when examining SCHED_RESTART
> in blk_mq_dispatch_rq_list():
> - if SCHED_RESTART isn't set, queue is run immediately as handled in 1)
> - otherwise, this request will be dispatched after any in-flight IO is
>   completed via blk_mq_sched_restart()
> 
> 3) if SCHED_RESTART is set concurently in context because of
> BLK_STS_RESOURCE, blk_mq_delay_run_hw_queue() will cover the above two
> cases and make sure IO hang can be avoided.
> 
> One invariant is that queue will be rerun if SCHED_RESTART is set.

This looks pretty good to me. I'm waffling a bit on whether to retain
the current BLK_STS_RESOURCE behavior and name the new one something
else, but I do like using the DEV name in there to signify the
difference between a global and device resource.

Just a few small nits below - can you roll a v6 with the changes?

> diff --git a/block/blk-core.c b/block/blk-core.c
> index cdae69be68e9..38279d4ae08b 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -145,6 +145,7 @@ static const struct {
>  	[BLK_STS_MEDIUM]	= { -ENODATA,	"critical medium" },
>  	[BLK_STS_PROTECTION]	= { -EILSEQ,	"protection" },
>  	[BLK_STS_RESOURCE]	= { -ENOMEM,	"kernel resource" },
> +	[BLK_STS_DEV_RESOURCE]	= { -ENOMEM,	"device resource" },
>  	[BLK_STS_AGAIN]		= { -EAGAIN,	"nonblocking retry" },

I think we should make BLK_STS_DEV_RESOURCE be -EBUSY, that more closely
matches the result and makes it distinctly different than the global
shortage that is STS_RESOURCE/ENOMEM.

> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 43e7449723e0..e39b4e2a63db 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -1160,6 +1160,8 @@ static bool blk_mq_mark_tag_wait(struct blk_mq_hw_ctx **hctx,
>  	return true;
>  }
>  
> +#define BLK_MQ_QUEUE_DELAY	3		/* ms units */

Make that BLK_MQ_RESOURCE_DELAY or something like that. The name is too
generic right now.

> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 2d973ac54b09..f41d2057215f 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -39,6 +39,23 @@ typedef u8 __bitwise blk_status_t;
>  
>  #define BLK_STS_AGAIN		((__force blk_status_t)12)
>  
> +/*
> + * BLK_STS_DEV_RESOURCE is returned from driver to block layer if device
> + * related resource is unavailable, but driver can guarantee that queue
> + * will be rerun in future once the resource is available (whereby
> + * dispatching requests).
> + *
> + * To safely return BLK_STS_DEV_RESOURCE, and allow forward progress, a
> + * driver just needs to make sure there is in-flight IO.
> + *
> + * Difference with BLK_STS_RESOURCE:
> + * If driver isn't sure if the queue will be rerun once device resource
> + * is made available, please return BLK_STS_RESOURCE.  For example: when
> + * memory allocation, DMA Mapping or other system resource allocation
> + * fails and IO can't be submitted to device.
> + */
> +#define BLK_STS_DEV_RESOURCE	((__force blk_status_t)13)

I'd rephrase that as:

BLK_STS_DEV_RESOURCE is returned from the driver to the block layer if
device related resource are unavailable, but the driver can guarantee
that the queue will be rerun in the future once resources become
available again. This is typically the case for device specific
resources that are consumed for IO. If the driver fails allocating these
resources, we know that inflight (or pending) IO will free these
resource upon completion.

This is different from BLK_STS_RESOURCE in that it explicitly references
device specific resource. For resources of wider scope, allocation
failure can happen without having pending IO. This means that we can't
rely on request completions freeing these resources, as IO may not be in
flight. Examples of that are kernel memory allocations, DMA mappings, or
any other system wide resources.

-- 
Jens Axboe
