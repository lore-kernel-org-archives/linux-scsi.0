Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2759C43461
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 01:58:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0EDB616E9
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 01:58:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhELB7a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 May 2021 21:59:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36249 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230137AbhELB72 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 11 May 2021 21:59:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620784700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IrSN/q1U2oWQiHJSxXKdOTlolgWacceb6n0DE2pKfEE=;
        b=TPfwJHYEzCK/Nwtvzb5cPRJwTIbf12k+OxmuuRy4mpAviol3pOXlvVVsmxlK+TKSSgZMuO
        3HJNKUTlA9z1pqIXj/YKuSlpSA8F6fb9KRFK0RRfUp9urxNAmn7wCLsb+0EYYT7GJlcBhH
        zY+a1dN5SehsUje35ywELrqZl29Rxew=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-521-7ZPIN5GwNgGi24_gTeHvtQ-1; Tue, 11 May 2021 21:58:16 -0400
X-MC-Unique: 7ZPIN5GwNgGi24_gTeHvtQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE27D803620;
        Wed, 12 May 2021 01:58:14 +0000 (UTC)
Received: from T590 (ovpn-12-110.pek2.redhat.com [10.72.12.110])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 19F032C617;
        Wed, 12 May 2021 01:58:06 +0000 (UTC)
Date:   Wed, 12 May 2021 09:58:01 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     axboe@kernel.dk, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kashyap.desai@broadcom.com, chenxiang66@hisilicon.com,
        yama@redhat.com, dgilbert@interlog.com
Subject: Re: [PATCH v2] blk-mq: Use request queue-wide tags for tagset-wide
 sbitmap
Message-ID: <YJs2KWMCn2kpyryT@T590>
References: <1620749743-36000-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1620749743-36000-1-git-send-email-john.garry@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, May 12, 2021 at 12:15:43AM +0800, John Garry wrote:
> The tags used for an IO scheduler are currently per hctx.
> 
> As such, when q->nr_hw_queues grows, so does the request queue total IO
> scheduler tag depth.
> 
> This may cause problems for SCSI MQ HBAs whose total driver depth is
> fixed.
> 
> Ming and Yanhui report higher CPU usage and lower throughput in scenarios
> where the fixed total driver tag depth is appreciably lower than the total
> scheduler tag depth:
> https://lore.kernel.org/linux-block/440dfcfc-1a2c-bd98-1161-cec4d78c6dfc@huawei.com/T/#mc0d6d4f95275a2743d1c8c3e4dc9ff6c9aa3a76b
> 
> In that scenario, since the scheduler tag is got first, much contention
> is introduced since a driver tag may not be available after we have got
> the sched tag.
> 
> Improve this scenario by introducing request queue-wide tags for when
> a tagset-wide sbitmap is used. The static sched requests are still
> allocated per hctx, as requests are initialised per hctx, as in
> blk_mq_init_request(..., hctx_idx, ...) ->
> set->ops->init_request(.., hctx_idx, ...).
> 
> For simplicity of resizing the request queue sbitmap when updating the
> request queue depth, just init at the max possible size, so we don't need
> to deal with the possibly with swapping out a new sbitmap for old if
> we need to grow.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
> 
> Please retest, thanks! For some reason I could not recreate the original
> issue, but I am using qemu...
> 
> Changes since v1:
> - Embed sbitmaps in request_queue struct
> - Relocate IO sched functions to blk-mq-sched.c
> - Fix error path code
> 
> diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
> index 42a365b1b9c0..9a012e0818cb 100644
> --- a/block/blk-mq-sched.c
> +++ b/block/blk-mq-sched.c
> @@ -507,11 +507,9 @@ static void blk_mq_sched_free_tags(struct blk_mq_tag_set *set,
>  				   struct blk_mq_hw_ctx *hctx,
>  				   unsigned int hctx_idx)
>  {
> -	unsigned int flags = set->flags & ~BLK_MQ_F_TAG_HCTX_SHARED;
> -
>  	if (hctx->sched_tags) {
>  		blk_mq_free_rqs(set, hctx->sched_tags, hctx_idx);
> -		blk_mq_free_rq_map(hctx->sched_tags, flags);
> +		blk_mq_free_rq_map(hctx->sched_tags, set->flags);
>  		hctx->sched_tags = NULL;
>  	}
>  }
> @@ -521,12 +519,10 @@ static int blk_mq_sched_alloc_tags(struct request_queue *q,
>  				   unsigned int hctx_idx)
>  {
>  	struct blk_mq_tag_set *set = q->tag_set;
> -	/* Clear HCTX_SHARED so tags are init'ed */
> -	unsigned int flags = set->flags & ~BLK_MQ_F_TAG_HCTX_SHARED;
>  	int ret;
>  
>  	hctx->sched_tags = blk_mq_alloc_rq_map(set, hctx_idx, q->nr_requests,
> -					       set->reserved_tags, flags);
> +					       set->reserved_tags, set->flags);
>  	if (!hctx->sched_tags)
>  		return -ENOMEM;
>  
> @@ -544,16 +540,40 @@ static void blk_mq_sched_tags_teardown(struct request_queue *q)
>  	int i;
>  
>  	queue_for_each_hw_ctx(q, hctx, i) {
> -		/* Clear HCTX_SHARED so tags are freed */
> -		unsigned int flags = hctx->flags & ~BLK_MQ_F_TAG_HCTX_SHARED;
> -
>  		if (hctx->sched_tags) {
> -			blk_mq_free_rq_map(hctx->sched_tags, flags);
> +			blk_mq_free_rq_map(hctx->sched_tags, hctx->flags);
>  			hctx->sched_tags = NULL;
>  		}
>  	}
>  }
>  
> +static int blk_mq_init_sched_shared_sbitmap(struct request_queue *queue)
> +{
> +	struct blk_mq_tag_set *set = queue->tag_set;
> +	int ret;
> +
> +	/*
> +	 * Set initial depth at max so that we don't need to reallocate for
> +	 * updating nr_requests.
> +	 */
> +	ret = blk_mq_init_bitmaps(&queue->sched_bitmap_tags,
> +				  &queue->sched_breserved_tags,
> +				  set, MAX_SCHED_RQ, set->reserved_tags);
> +	if (ret)
> +		return ret;
> +
> +	sbitmap_queue_resize(&queue->sched_bitmap_tags,
> +			     queue->nr_requests - set->reserved_tags);
> +
> +	return 0;
> +}
> +
> +static void blk_mq_exit_sched_shared_sbitmap(struct request_queue *queue)
> +{
> +	sbitmap_queue_free(&queue->sched_bitmap_tags);
> +	sbitmap_queue_free(&queue->sched_breserved_tags);
> +}
> +
>  int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
>  {
>  	struct blk_mq_hw_ctx *hctx;
> @@ -578,12 +598,25 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
>  	queue_for_each_hw_ctx(q, hctx, i) {
>  		ret = blk_mq_sched_alloc_tags(q, hctx, i);
>  		if (ret)
> -			goto err;
> +			goto err_free_tags;
> +	}
> +
> +	if (blk_mq_is_sbitmap_shared(q->tag_set->flags)) {
> +		ret = blk_mq_init_sched_shared_sbitmap(q);
> +		if (ret)
> +			goto err_free_tags;
> +
> +		queue_for_each_hw_ctx(q, hctx, i) {
> +			hctx->sched_tags->bitmap_tags =
> +						&q->sched_bitmap_tags;
> +			hctx->sched_tags->breserved_tags =
> +						&q->sched_breserved_tags;
> +		}

The above assignment can be folded into blk_mq_init_sched_shared_sbitmap().

>  	}
>  
>  	ret = e->ops.init_sched(q, e);
>  	if (ret)
> -		goto err;
> +		goto err_free_sbitmap;
>  
>  	blk_mq_debugfs_register_sched(q);
>  
> @@ -603,7 +636,10 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
>  
>  	return 0;
>  
> -err:
> +err_free_sbitmap:
> +	if (blk_mq_is_sbitmap_shared(q->tag_set->flags))
> +		blk_mq_exit_sched_shared_sbitmap(q);
> +err_free_tags:
>  	blk_mq_sched_free_requests(q);
>  	blk_mq_sched_tags_teardown(q);
>  	q->elevator = NULL;
> @@ -641,5 +677,7 @@ void blk_mq_exit_sched(struct request_queue *q, struct elevator_queue *e)
>  	if (e->type->ops.exit_sched)
>  		e->type->ops.exit_sched(e);
>  	blk_mq_sched_tags_teardown(q);
> +	if (blk_mq_is_sbitmap_shared(q->tag_set->flags))
> +		blk_mq_exit_sched_shared_sbitmap(q);

The above two lines can be moved to blk_mq_sched_tags_teardown().

>  	q->elevator = NULL;
>  }
> diff --git a/block/blk-mq-sched.h b/block/blk-mq-sched.h
> index 5b18ab915c65..aff037cfd8e7 100644
> --- a/block/blk-mq-sched.h
> +++ b/block/blk-mq-sched.h
> @@ -5,6 +5,8 @@
>  #include "blk-mq.h"
>  #include "blk-mq-tag.h"
>  
> +#define MAX_SCHED_RQ (16 * BLKDEV_MAX_RQ)
> +
>  void blk_mq_sched_assign_ioc(struct request *rq);
>  
>  bool blk_mq_sched_try_merge(struct request_queue *q, struct bio *bio,
> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
> index 2a37731e8244..e3ab8631be22 100644
> --- a/block/blk-mq-tag.c
> +++ b/block/blk-mq-tag.c
> @@ -13,6 +13,7 @@
>  #include <linux/delay.h>
>  #include "blk.h"
>  #include "blk-mq.h"
> +#include "blk-mq-sched.h"
>  #include "blk-mq-tag.h"
>  
>  /*
> @@ -466,19 +467,39 @@ static int blk_mq_init_bitmap_tags(struct blk_mq_tags *tags,
>  	return -ENOMEM;
>  }
>  
> -int blk_mq_init_shared_sbitmap(struct blk_mq_tag_set *set, unsigned int flags)
> +int blk_mq_init_bitmaps(struct sbitmap_queue *bitmap_tags,
> +			struct sbitmap_queue *breserved_tags,
> +			struct blk_mq_tag_set *set,

The 'set' parameter can be killed, meantime pass 'node' & 'alloc_policy',
just like blk_mq_init_bitmap_tags()'s type, then blk_mq_init_bitmaps()
can be re-used by blk_mq_init_bitmap_tags() for avoiding to duplicate
bitmap allocation code.

> +			unsigned int queue_depth, unsigned int reserved)

>  {
> -	unsigned int depth = set->queue_depth - set->reserved_tags;
> +	unsigned int depth = queue_depth - reserved;
>  	int alloc_policy = BLK_MQ_FLAG_TO_ALLOC_POLICY(set->flags);
>  	bool round_robin = alloc_policy == BLK_TAG_ALLOC_RR;
> -	int i, node = set->numa_node;
>  
> -	if (bt_alloc(&set->__bitmap_tags, depth, round_robin, node))
> +	if (bt_alloc(bitmap_tags, depth, round_robin, set->numa_node))
>  		return -ENOMEM;
> -	if (bt_alloc(&set->__breserved_tags, set->reserved_tags,
> -		     round_robin, node))
> +	if (bt_alloc(breserved_tags, set->reserved_tags,

s/set->reserved_tags/reserved/


Thanks, 
Ming

