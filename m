Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17F80C433B4
	for <linux-scsi@archiver.kernel.org>; Thu,  6 May 2021 08:32:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB74E60E09
	for <linux-scsi@archiver.kernel.org>; Thu,  6 May 2021 08:32:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233591AbhEFIdj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 May 2021 04:33:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47702 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233390AbhEFIdV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 May 2021 04:33:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620289943;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7JqjdR2kw/Cet6YKuUtlMslbFesxe737tHzI7djxdT8=;
        b=LBFyS2JiRon6spRJ8mqlFluAffHPAUJ09IG1iBq4mLwYY2lF0s3WWAf0imTnZ+VLkfWlM1
        rkXAsRex1fJsyfZ3nuuoBi9mbBU/i4lDcYYuIjQbXZR5jK09K6HgWQ5kzNw5nySdC8iOa3
        paSAtazpppglR+ev9UYducguD1acEM0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-SBCbzLB-PXOHSPRggJCGXA-1; Thu, 06 May 2021 04:32:21 -0400
X-MC-Unique: SBCbzLB-PXOHSPRggJCGXA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1187F8014D8;
        Thu,  6 May 2021 08:32:20 +0000 (UTC)
Received: from T590 (ovpn-12-93.pek2.redhat.com [10.72.12.93])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8841E687F2;
        Thu,  6 May 2021 08:32:11 +0000 (UTC)
Date:   Thu, 6 May 2021 16:32:07 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     axboe@kernel.dk, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kashyap.desai@broadcom.com, chenxiang66@hisilicon.com,
        yama@redhat.com
Subject: Re: [PATCH] blk-mq: Use request queue-wide tags for tagset-wide
 sbitmap
Message-ID: <YJOph1oI8CTJjzQx@T590>
References: <1620037333-2495-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1620037333-2495-1-git-send-email-john.garry@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, May 03, 2021 at 06:22:13PM +0800, John Garry wrote:
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
> 
> diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
> index e1e997af89a0..121207abc026 100644
> --- a/block/blk-mq-sched.c
> +++ b/block/blk-mq-sched.c
> @@ -497,11 +497,9 @@ static void blk_mq_sched_free_tags(struct blk_mq_tag_set *set,
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
> @@ -511,12 +509,10 @@ static int blk_mq_sched_alloc_tags(struct request_queue *q,
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
> @@ -534,11 +530,8 @@ static void blk_mq_sched_tags_teardown(struct request_queue *q)
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
> @@ -568,12 +561,25 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
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
> +					q->sched_bitmap_tags;
> +			hctx->sched_tags->breserved_tags =
> +					q->sched_breserved_tags;
> +		}
>  	}
>  
>  	ret = e->ops.init_sched(q, e);
>  	if (ret)
> -		goto err;
> +		goto err_free_sbitmap;
>  
>  	blk_mq_debugfs_register_sched(q);
>  
> @@ -584,6 +590,7 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
>  				eq = q->elevator;
>  				blk_mq_sched_free_requests(q);
>  				blk_mq_exit_sched(q, eq);
> +				blk_mq_exit_sched_shared_sbitmap(q);

blk_mq_exit_sched_shared_sbitmap() has been called in blk_mq_exit_sched() already.

>  				kobject_put(&eq->kobj);
>  				return ret;
>  			}
> @@ -593,7 +600,10 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
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
> @@ -631,5 +641,7 @@ void blk_mq_exit_sched(struct request_queue *q, struct elevator_queue *e)
>  	if (e->type->ops.exit_sched)
>  		e->type->ops.exit_sched(e);
>  	blk_mq_sched_tags_teardown(q);
> +	if (blk_mq_is_sbitmap_shared(q->tag_set->flags))
> +		blk_mq_exit_sched_shared_sbitmap(q);
>  	q->elevator = NULL;
>  }
> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
> index 2a37731e8244..734fedceca7d 100644
> --- a/block/blk-mq-tag.c
> +++ b/block/blk-mq-tag.c
> @@ -466,19 +466,40 @@ static int blk_mq_init_bitmap_tags(struct blk_mq_tags *tags,
>  	return -ENOMEM;
>  }
>  
> -int blk_mq_init_shared_sbitmap(struct blk_mq_tag_set *set, unsigned int flags)
> +static int __blk_mq_init_bitmaps(struct sbitmap_queue *bitmap_tags,
> +				 struct sbitmap_queue *breserved_tags,
> +				 struct blk_mq_tag_set *set,
> +				 unsigned int queue_depth,
> +				 unsigned int reserved)
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
> +		     round_robin, set->numa_node))
>  		goto free_bitmap_tags;
>  
> +	return 0;
> +
> +free_bitmap_tags:
> +	sbitmap_queue_free(bitmap_tags);
> +	return -ENOMEM;
> +}
> +
> +int blk_mq_init_shared_sbitmap(struct blk_mq_tag_set *set)

IMO, this function should be named as blk_mq_init_shared_tags
and moved to blk-mq-sched.c

> +{
> +	int i, ret;
> +
> +	ret = __blk_mq_init_bitmaps(&set->__bitmap_tags,
> +				    &set->__breserved_tags,
> +				    set, set->queue_depth,
> +				    set->reserved_tags);
> +	if (ret)
> +		return ret;
> +
>  	for (i = 0; i < set->nr_hw_queues; i++) {
>  		struct blk_mq_tags *tags = set->tags[i];
>  
> @@ -487,9 +508,6 @@ int blk_mq_init_shared_sbitmap(struct blk_mq_tag_set *set, unsigned int flags)
>  	}
>  
>  	return 0;
> -free_bitmap_tags:
> -	sbitmap_queue_free(&set->__bitmap_tags);
> -	return -ENOMEM;
>  }
>  
>  void blk_mq_exit_shared_sbitmap(struct blk_mq_tag_set *set)
> @@ -498,6 +516,52 @@ void blk_mq_exit_shared_sbitmap(struct blk_mq_tag_set *set)
>  	sbitmap_queue_free(&set->__breserved_tags);
>  }
>  
> +#define MAX_SCHED_RQ (16 * BLKDEV_MAX_RQ)
> +
> +int blk_mq_init_sched_shared_sbitmap(struct request_queue *queue)
> +{
> +	struct blk_mq_tag_set *set = queue->tag_set;
> +	int ret;
> +
> +	queue->sched_bitmap_tags =
> +		kmalloc(sizeof(*queue->sched_bitmap_tags), GFP_KERNEL);
> +	queue->sched_breserved_tags =
> +		kmalloc(sizeof(*queue->sched_breserved_tags), GFP_KERNEL);
> +	if (!queue->sched_bitmap_tags || !queue->sched_breserved_tags)
> +		goto err;

The two sbitmap queues can be embedded into 'request queue', so that
we can avoid to re-allocation in every elevator switch.

I will ask Yanhui to test the patch and see if it can make a difference.


Thanks,
Ming

