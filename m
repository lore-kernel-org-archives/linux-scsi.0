From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 8/8] IB/srp: Add multichannel support
Date: Wed, 01 Oct 2014 10:54:28 -0600
Message-ID: <542C31C4.1020702@kernel.dk>
References: <541C27BF.6070609@acm.org>	<541C28E0.7010705@acm.org>	<CACVXFVPzz37J-613NZCfPStUBxf0rLOtz71LJ07PpCxYg5nn+g@mail.gmail.com>	<541C49EC.6030404@acm.org> <CACVXFVPH_qPFUTT+796BZmWxeeG4tJ-Pyp8hqGqqSwt3YYkEqA@mail.gmail.com> <541C4D2F.9060907@acm.org> <541C4DF1.4090604@kernel.dk> <542C270B.5020002@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:54937 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbaJAQyc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2014 12:54:32 -0400
Received: by mail-pa0-f50.google.com with SMTP id kx10so579461pab.23
        for <linux-scsi@vger.kernel.org>; Wed, 01 Oct 2014 09:54:32 -0700 (PDT)
In-Reply-To: <542C270B.5020002@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, Ming Lei <ming.lei@canonical.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Robert Elliott <Elliott@hp.com>

On 2014-10-01 10:08, Bart Van Assche wrote:
> On 09/19/14 17:38, Jens Axboe wrote:
>> ctx was meant to be private, unfortunately it's leaked a bit into other
>> parts of block/. But it's still private within that, at least.
>>
>> Lets not add more stuff to struct request, it's already way too large.
>> We could add an exported
>>
>> struct blk_mq_hw_ctx *blk_mq_request_to_hctx(struct request *rq)
>> {
>> 	struct request_queue *q = rq->q;
>>
>> 	return q->mq_ops->map_queue(q, rq->mq_ctx->cpu);
>> }
>>
>> for this.
>
> How about the patch below ? That patch makes it easy for SCSI LLDs to obtain
> the hardware context index.
>
> [PATCH] blk-mq: Add blk_get_mq_tag()
>
> The queuecommand() callback functions in SCSI low-level drivers
> must know which hardware context has been selected by the block
> layer. Since passing the hctx pointer directly to the queuecommand
> callback function would require modification of all SCSI LLDs,
> add a function to the block layer that allows to query the hardware
> context index.
>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   block/blk-mq-tag.c     | 24 ++++++++++++++++++++++++
>   include/linux/blk-mq.h | 16 ++++++++++++++++
>   2 files changed, 40 insertions(+)
>
> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
> index c1b9242..5618759 100644
> --- a/block/blk-mq-tag.c
> +++ b/block/blk-mq-tag.c
> @@ -595,6 +595,30 @@ int blk_mq_tag_update_depth(struct blk_mq_tags *tags, unsigned int tdepth)
>   	return 0;
>   }
>
> +/**
> + * blk_get_mq_tag() - return a tag that is unique queue-wide
> + *
> + * The tag field in struct request is unique per hardware queue but not
> + * queue-wide. Hence this function. It is not only safe to use this function
> + * for multiqueue request queues but also for single-queue request queues.
> + * Note: rq->tag == -1 if tagging is not enabled for single-queue request
> + * queues.
> + */
> +struct blk_mq_tag blk_get_mq_tag(struct request *rq)
> +{
> +	struct request_queue *q = rq->q;
> +	struct blk_mq_tag tag = { rq->tag & ((1 << 16) - 1) };
> +	struct blk_mq_hw_ctx *hctx;
> +
> +	if (q->mq_ops) {
> +		hctx = q->mq_ops->map_queue(q, rq->mq_ctx->cpu);
> +		tag.tag |= hctx->queue_num << 16;
> +	}
> +
> +	return tag;
> +}
> +EXPORT_SYMBOL(blk_get_mq_tag);

Lets get rid of the blk_mq_tag struct and just have it be an u32 or 
something. We could potentially typedef it, but I'd prefer to just have 
it be an unsigned 32-bit int.

Probably also need some init time safety checks that 16-bits is enough 
to hold BLK_MQ_MAX_DEPTH. Just in case that is ever bumped, or the queue 
prefixing changes.

And I think we need to name this better. Your comment correctly 
describes that this generates a unique tag queue wide, but the name of 
the function implies that we just return the request tag. Most drivers 
wont use this. Perhaps add a queue flag that tells us that we should 
generate these tags and have it setup ala:

u32 blk_mq_unique_rq_tag(struct request *rq)
{
	struct request_queue *q = rq->q;
	u32 tag = rq->tag & ((1 << 16) - 1);
	struct blk_mq_hw_ctx *hctx;

	hctx = q->mq_ops->map_queue(q, rq->mq_ctx->cpu);	
	return tag | (hctx->queue_num << 16);
}

u32 blk_mq_rq_tag(struct request *rq)
{
	struct request_queue *q = rq->q;

	if (q->mq_ops &&
	    test_bit(QUEUE_FLAG_UNIQUE_TAGS, &q->queue_flags))
		return blk_mq_unique_rq_tag(rq);

	return rq->tag;
}

Totally untested, just typed in email.

-- 
Jens Axboe

