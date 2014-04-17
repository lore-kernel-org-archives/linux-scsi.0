From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 5/7] blk-mq: initialize request on allocation
Date: Thu, 17 Apr 2014 22:54:23 +0800
Message-ID: <CACVXFVMAq0qw5vXqShmhcTTA5nww_OYaVz-yiEaf3_Q3-nrJfQ@mail.gmail.com>
References: <1397464212-4454-1-git-send-email-hch@lst.de>
	<1397464212-4454-6-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:58984 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbaDQOyY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Apr 2014 10:54:24 -0400
In-Reply-To: <1397464212-4454-6-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Matias Bjorling <m@bjorling.me>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>

On Mon, Apr 14, 2014 at 4:30 PM, Christoph Hellwig <hch@lst.de> wrote:
> If we want to share tag and request allocation between queues we cannot
> initialize the request at init/free time, but need to initialize it
> at allocation time as it might get used for different queues over its
> lifetime.

Could you explain the use pattern? Looks you mean there are
still users of the tag/req even after it is freed, that looks a bit
weird since the tag/req can still be reallocated in another path
after it is freed.

>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-mq.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index ef7acc0..1cb7618 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -82,6 +82,7 @@ static struct request *__blk_mq_alloc_request(struct blk_mq_hw_ctx *hctx,
>         tag = blk_mq_get_tag(hctx->tags, gfp, reserved);
>         if (tag != BLK_MQ_TAG_FAIL) {
>                 rq = hctx->rqs[tag];
> +               blk_rq_init(hctx->queue, rq);
>                 rq->tag = tag;
>
>                 return rq;
> @@ -254,9 +255,7 @@ static void __blk_mq_free_request(struct blk_mq_hw_ctx *hctx,
>         const int tag = rq->tag;
>         struct request_queue *q = rq->q;
>
> -       blk_rq_init(hctx->queue, rq);
>         blk_mq_put_tag(hctx->tags, tag);
> -
>         blk_mq_queue_exit(q);
>  }
>
> @@ -1100,7 +1099,6 @@ static int blk_mq_init_rq_map(struct blk_mq_hw_ctx *hctx,
>                 left -= to_do * rq_size;
>                 for (j = 0; j < to_do; j++) {
>                         hctx->rqs[i] = p;
> -                       blk_rq_init(hctx->queue, hctx->rqs[i]);
>                         if (reg->ops->init_request) {
>                                 error = reg->ops->init_request(driver_data,
>                                                 hctx, hctx->rqs[i], i);
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


Thanks,
-- 
Ming Lei
