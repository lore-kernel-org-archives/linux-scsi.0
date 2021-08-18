Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59F34C4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 08:17:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30CD26102A
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 08:17:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239728AbhHRIRv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Aug 2021 04:17:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57645 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239745AbhHRIRu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Aug 2021 04:17:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629274636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tVO2lZFNLdS73H60VcqwVbfOYv/lcIXIIWFCxSmK+q0=;
        b=gWoKFgCIOgT0acYNZuNzTobF2mZ+V4s11Mh50BBWiAPNPPsd90w9ZrkSfSb95RTNa07mqm
        iJG1wqPOvLMkWjuW/Zx82488JhFomdvqjn7yunR0VuF09yQnj3pR7ng9Mf3968WjTdFgwG
        oheXtPtFSWUv0n/2ZV95YP+xBUR5l1Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-MRvv2tYVPXyWH_F6sWfRHw-1; Wed, 18 Aug 2021 04:17:14 -0400
X-MC-Unique: MRvv2tYVPXyWH_F6sWfRHw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 11A0F10CE7A8;
        Wed, 18 Aug 2021 08:17:13 +0000 (UTC)
Received: from T590 (ovpn-8-40.pek2.redhat.com [10.72.8.40])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 54ED860C17;
        Wed, 18 Aug 2021 08:17:02 +0000 (UTC)
Date:   Wed, 18 Aug 2021 16:16:57 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, kashyap.desai@broadcom.com,
        hare@suse.de
Subject: Re: [PATCH v2 10/11] blk-mq: Use shared tags for shared sbitmap
 support
Message-ID: <YRzB+aCVVSP+OmE4@T590>
References: <1628519378-211232-1-git-send-email-john.garry@huawei.com>
 <1628519378-211232-11-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1628519378-211232-11-git-send-email-john.garry@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 09, 2021 at 10:29:37PM +0800, John Garry wrote:
> Currently we use separate sbitmap pairs and active_queues atomic_t for
> shared sbitmap support.
> 
> However a full set of static requests are used per HW queue, which is
> quite wasteful, considering that the total number of requests usable at
> any given time across all HW queues is limited by the shared sbitmap depth.
> 
> As such, it is considerably more memory efficient in the case of shared
> sbitmap to allocate a set of static rqs per tag set or request queue, and
> not per HW queue.
> 
> So replace the sbitmap pairs and active_queues atomic_t with a shared
> tags per tagset and request queue.

This idea looks good and the current implementation is simplified a bit
too.

> 
> Continue to use term "shared sbitmap" for now, as the meaning is known.

I guess shared tags is better.

> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  block/blk-mq-sched.c   | 77 ++++++++++++++++++++-----------------
>  block/blk-mq-tag.c     | 65 ++++++++++++-------------------
>  block/blk-mq-tag.h     |  4 +-
>  block/blk-mq.c         | 86 +++++++++++++++++++++++++-----------------
>  block/blk-mq.h         |  8 ++--
>  include/linux/blk-mq.h | 13 +++----
>  include/linux/blkdev.h |  3 +-
>  7 files changed, 131 insertions(+), 125 deletions(-)
> 
> diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
> index ac0408ebcd47..1101a2e4da9a 100644
> --- a/block/blk-mq-sched.c
> +++ b/block/blk-mq-sched.c
> @@ -522,14 +522,19 @@ static int blk_mq_sched_alloc_map_and_request(struct request_queue *q,
>  	struct blk_mq_tag_set *set = q->tag_set;
>  	int ret;
>  
> +	if (blk_mq_is_sbitmap_shared(q->tag_set->flags)) {
> +		hctx->sched_tags = q->shared_sbitmap_tags;
> +		return 0;
> +	}
> +
>  	hctx->sched_tags = blk_mq_alloc_rq_map(set, hctx_idx, q->nr_requests,
> -					       set->reserved_tags, set->flags);
> +					       set->reserved_tags);
>  	if (!hctx->sched_tags)
>  		return -ENOMEM;
>  
>  	ret = blk_mq_alloc_rqs(set, hctx->sched_tags, hctx_idx, q->nr_requests);
>  	if (ret) {
> -		blk_mq_free_rq_map(hctx->sched_tags, set->flags);
> +		blk_mq_free_rq_map(hctx->sched_tags);
>  		hctx->sched_tags = NULL;
>  	}
>  
> @@ -544,35 +549,39 @@ static void blk_mq_sched_tags_teardown(struct request_queue *q)
>  
>  	queue_for_each_hw_ctx(q, hctx, i) {
>  		if (hctx->sched_tags) {
> -			blk_mq_free_rq_map(hctx->sched_tags, hctx->flags);
> +			if (!blk_mq_is_sbitmap_shared(q->tag_set->flags))
> +				blk_mq_free_rq_map(hctx->sched_tags);
>  			hctx->sched_tags = NULL;
>  		}
>  	}
>  }
>  
> +static void blk_mq_exit_sched_shared_sbitmap(struct request_queue *queue)
> +{
> +	blk_mq_free_rq_map(queue->shared_sbitmap_tags);
> +	queue->shared_sbitmap_tags = NULL;
> +}
> +
>  static int blk_mq_init_sched_shared_sbitmap(struct request_queue *queue)
>  {
>  	struct blk_mq_tag_set *set = queue->tag_set;
> -	int alloc_policy = BLK_MQ_FLAG_TO_ALLOC_POLICY(set->flags);
> -	struct blk_mq_hw_ctx *hctx;
> -	int ret, i;
> +	struct blk_mq_tags *tags;
> +	int ret;
>  
>  	/*
>  	 * Set initial depth at max so that we don't need to reallocate for
>  	 * updating nr_requests.
>  	 */
> -	ret = blk_mq_init_bitmaps(&queue->sched_bitmap_tags,
> -				  &queue->sched_breserved_tags,
> -				  MAX_SCHED_RQ, set->reserved_tags,
> -				  set->numa_node, alloc_policy);
> -	if (ret)
> -		return ret;
> +	tags = queue->shared_sbitmap_tags = blk_mq_alloc_rq_map(set, 0,
> +					  set->queue_depth,
> +					  set->reserved_tags);
> +	if (!queue->shared_sbitmap_tags)
> +		return -ENOMEM;
>  
> -	queue_for_each_hw_ctx(queue, hctx, i) {
> -		hctx->sched_tags->bitmap_tags =
> -					&queue->sched_bitmap_tags;
> -		hctx->sched_tags->breserved_tags =
> -					&queue->sched_breserved_tags;
> +	ret = blk_mq_alloc_rqs(set, tags, 0, set->queue_depth);
> +	if (ret) {
> +		blk_mq_exit_sched_shared_sbitmap(queue);
> +		return ret;

There are two such patterns for allocate rq map and request pool
together, please put them into one helper(such as blk_mq_alloc_map_and_rqs)
which can return the allocated tags and handle failure inline. Also we may
convert current users into this helper.

>  	}
>  
>  	blk_mq_tag_update_sched_shared_sbitmap(queue);
> @@ -580,12 +589,6 @@ static int blk_mq_init_sched_shared_sbitmap(struct request_queue *queue)
>  	return 0;
>  }
>  
> -static void blk_mq_exit_sched_shared_sbitmap(struct request_queue *queue)
> -{
> -	sbitmap_queue_free(&queue->sched_bitmap_tags);
> -	sbitmap_queue_free(&queue->sched_breserved_tags);
> -}
> -
>  int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
>  {
>  	struct blk_mq_hw_ctx *hctx;
> @@ -607,21 +610,21 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
>  	q->nr_requests = 2 * min_t(unsigned int, q->tag_set->queue_depth,
>  				   BLKDEV_DEFAULT_RQ);
>  
> -	queue_for_each_hw_ctx(q, hctx, i) {
> -		ret = blk_mq_sched_alloc_map_and_request(q, hctx, i);
> +	if (blk_mq_is_sbitmap_shared(q->tag_set->flags)) {
> +		ret = blk_mq_init_sched_shared_sbitmap(q);
>  		if (ret)
> -			goto err_free_map_and_request;
> +			return ret;
>  	}
>  
> -	if (blk_mq_is_sbitmap_shared(q->tag_set->flags)) {
> -		ret = blk_mq_init_sched_shared_sbitmap(q);
> +	queue_for_each_hw_ctx(q, hctx, i) {
> +		ret = blk_mq_sched_alloc_map_and_request(q, hctx, i);
>  		if (ret)
>  			goto err_free_map_and_request;
>  	}
>  
>  	ret = e->ops.init_sched(q, e);
>  	if (ret)
> -		goto err_free_sbitmap;
> +		goto err_free_map_and_request;
>  
>  	blk_mq_debugfs_register_sched(q);
>  
> @@ -641,12 +644,12 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
>  
>  	return 0;
>  
> -err_free_sbitmap:
> -	if (blk_mq_is_sbitmap_shared(q->tag_set->flags))
> -		blk_mq_exit_sched_shared_sbitmap(q);
>  err_free_map_and_request:
>  	blk_mq_sched_free_requests(q);
>  	blk_mq_sched_tags_teardown(q);
> +	if (blk_mq_is_sbitmap_shared(q->tag_set->flags))
> +		blk_mq_exit_sched_shared_sbitmap(q);
> +
>  	q->elevator = NULL;
>  	return ret;
>  }
> @@ -660,9 +663,13 @@ void blk_mq_sched_free_requests(struct request_queue *q)
>  	struct blk_mq_hw_ctx *hctx;
>  	int i;
>  
> -	queue_for_each_hw_ctx(q, hctx, i) {
> -		if (hctx->sched_tags)
> -			blk_mq_free_rqs(q->tag_set, hctx->sched_tags, i);
> +	if (blk_mq_is_sbitmap_shared(q->tag_set->flags)) {
> +		blk_mq_free_rqs(q->tag_set, q->shared_sbitmap_tags, 0);
> +	} else {
> +		queue_for_each_hw_ctx(q, hctx, i) {
> +			if (hctx->sched_tags)
> +				blk_mq_free_rqs(q->tag_set, hctx->sched_tags, i);
> +		}
>  	}
>  }
>  
> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
> index 5f06ad6efc8f..e97bbf477b96 100644
> --- a/block/blk-mq-tag.c
> +++ b/block/blk-mq-tag.c
> @@ -27,10 +27,11 @@ bool __blk_mq_tag_busy(struct blk_mq_hw_ctx *hctx)
>  	if (blk_mq_is_sbitmap_shared(hctx->flags)) {
>  		struct request_queue *q = hctx->queue;
>  		struct blk_mq_tag_set *set = q->tag_set;
> +		struct blk_mq_tags *tags = set->shared_sbitmap_tags;
>  
>  		if (!test_bit(QUEUE_FLAG_HCTX_ACTIVE, &q->queue_flags) &&
>  		    !test_and_set_bit(QUEUE_FLAG_HCTX_ACTIVE, &q->queue_flags))
> -			atomic_inc(&set->active_queues_shared_sbitmap);
> +			atomic_inc(&tags->active_queues);
>  	} else {
>  		if (!test_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state) &&
>  		    !test_and_set_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
> @@ -61,10 +62,12 @@ void __blk_mq_tag_idle(struct blk_mq_hw_ctx *hctx)
>  	struct blk_mq_tag_set *set = q->tag_set;
>  
>  	if (blk_mq_is_sbitmap_shared(hctx->flags)) {
> +		struct blk_mq_tags *tags = set->shared_sbitmap_tags;
> +
>  		if (!test_and_clear_bit(QUEUE_FLAG_HCTX_ACTIVE,
>  					&q->queue_flags))
>  			return;
> -		atomic_dec(&set->active_queues_shared_sbitmap);
> +		atomic_dec(&tags->active_queues);
>  	} else {
>  		if (!test_and_clear_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
>  			return;
> @@ -510,38 +513,16 @@ static int blk_mq_init_bitmap_tags(struct blk_mq_tags *tags,
>  	return 0;
>  }
>  
> -int blk_mq_init_shared_sbitmap(struct blk_mq_tag_set *set)
> -{
> -	int alloc_policy = BLK_MQ_FLAG_TO_ALLOC_POLICY(set->flags);
> -	int i, ret;
> -
> -	ret = blk_mq_init_bitmaps(&set->__bitmap_tags, &set->__breserved_tags,
> -				  set->queue_depth, set->reserved_tags,
> -				  set->numa_node, alloc_policy);
> -	if (ret)
> -		return ret;
> -
> -	for (i = 0; i < set->nr_hw_queues; i++) {
> -		struct blk_mq_tags *tags = set->tags[i];
> -
> -		tags->bitmap_tags = &set->__bitmap_tags;
> -		tags->breserved_tags = &set->__breserved_tags;
> -	}
> -
> -	return 0;
> -}
> -
>  void blk_mq_exit_shared_sbitmap(struct blk_mq_tag_set *set)
>  {
> -	sbitmap_queue_free(&set->__bitmap_tags);
> -	sbitmap_queue_free(&set->__breserved_tags);
> +	blk_mq_free_rq_map(set->shared_sbitmap_tags);
> +	set->shared_sbitmap_tags = NULL;
>  }
>  
>  struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
>  				     unsigned int reserved_tags,
> -				     int node, unsigned int flags)
> +				     int node, int alloc_policy)
>  {
> -	int alloc_policy = BLK_MQ_FLAG_TO_ALLOC_POLICY(flags);
>  	struct blk_mq_tags *tags;
>  
>  	if (total_tags > BLK_MQ_TAG_MAX) {
> @@ -557,9 +538,6 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
>  	tags->nr_reserved_tags = reserved_tags;
>  	spin_lock_init(&tags->lock);
>  
> -	if (blk_mq_is_sbitmap_shared(flags))
> -		return tags;
> -
>  	if (blk_mq_init_bitmap_tags(tags, node, alloc_policy) < 0) {
>  		kfree(tags);
>  		return NULL;
> @@ -567,12 +545,10 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
>  	return tags;
>  }
>  
> -void blk_mq_free_tags(struct blk_mq_tags *tags, unsigned int flags)
> +void blk_mq_free_tags(struct blk_mq_tags *tags)
>  {
> -	if (!blk_mq_is_sbitmap_shared(flags)) {
> -		sbitmap_queue_free(tags->bitmap_tags);
> -		sbitmap_queue_free(tags->breserved_tags);
> -	}
> +	sbitmap_queue_free(tags->bitmap_tags);
> +	sbitmap_queue_free(tags->breserved_tags);
>  	kfree(tags);
>  }
>  
> @@ -604,18 +580,25 @@ int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
>  		if (tdepth > MAX_SCHED_RQ)
>  			return -EINVAL;
>  
> +		if (blk_mq_is_sbitmap_shared(set->flags)) {
> +			/* No point in allowing this to happen */
> +			if (tdepth > set->queue_depth)
> +				return -EINVAL;
> +			return 0;
> +		}

The above looks wrong, it isn't unusual to see small queue depth
hardware meantime we often have scheduler queue depth of 2 * set->queue_depth.

> +
>  		new = blk_mq_alloc_rq_map(set, hctx->queue_num, tdepth,
> -				tags->nr_reserved_tags, set->flags);
> +				tags->nr_reserved_tags);
>  		if (!new)
>  			return -ENOMEM;
>  		ret = blk_mq_alloc_rqs(set, new, hctx->queue_num, tdepth);
>  		if (ret) {
> -			blk_mq_free_rq_map(new, set->flags);
> +			blk_mq_free_rq_map(new);
>  			return -ENOMEM;
>  		}
>  
>  		blk_mq_free_rqs(set, *tagsptr, hctx->queue_num);
> -		blk_mq_free_rq_map(*tagsptr, set->flags);
> +		blk_mq_free_rq_map(*tagsptr);
>  		*tagsptr = new;
>  	} else {
>  		/*
> @@ -631,12 +614,14 @@ int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
>  
>  void blk_mq_tag_resize_shared_sbitmap(struct blk_mq_tag_set *set, unsigned int size)
>  {
> -	sbitmap_queue_resize(&set->__bitmap_tags, size - set->reserved_tags);
> +	struct blk_mq_tags *tags = set->shared_sbitmap_tags;
> +
> +	sbitmap_queue_resize(&tags->__bitmap_tags, size - set->reserved_tags);
>  }
>  
>  void blk_mq_tag_update_sched_shared_sbitmap(struct request_queue *q)
>  {
> -	sbitmap_queue_resize(&q->sched_bitmap_tags,
> +	sbitmap_queue_resize(q->shared_sbitmap_tags->bitmap_tags,
>  			     q->nr_requests - q->tag_set->reserved_tags);
>  }
>  
> diff --git a/block/blk-mq-tag.h b/block/blk-mq-tag.h
> index 88f3c6485543..c9fc52ee07c4 100644
> --- a/block/blk-mq-tag.h
> +++ b/block/blk-mq-tag.h
> @@ -30,8 +30,8 @@ struct blk_mq_tags {
>  
>  extern struct blk_mq_tags *blk_mq_init_tags(unsigned int nr_tags,
>  					unsigned int reserved_tags,
> -					int node, unsigned int flags);
> -extern void blk_mq_free_tags(struct blk_mq_tags *tags, unsigned int flags);
> +					int node, int alloc_policy);
> +extern void blk_mq_free_tags(struct blk_mq_tags *tags);
>  extern int blk_mq_init_bitmaps(struct sbitmap_queue *bitmap_tags,
>  			       struct sbitmap_queue *breserved_tags,
>  			       unsigned int queue_depth,
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 4d6723cfa582..d3dd5fab3426 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -2348,6 +2348,9 @@ void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
>  	struct blk_mq_tags *drv_tags;
>  	struct page *page;
>  
> +	if (blk_mq_is_sbitmap_shared(set->flags))
> +		drv_tags = set->shared_sbitmap_tags;
> +	else
>  		drv_tags = set->tags[hctx_idx];

Here I guess you need to avoid to double ->exit_request()?

>  
>  	if (tags->static_rqs && set->ops->exit_request) {
> @@ -2377,21 +2380,20 @@ void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
>  	}
>  }
>  
> -void blk_mq_free_rq_map(struct blk_mq_tags *tags, unsigned int flags)
> +void blk_mq_free_rq_map(struct blk_mq_tags *tags)
>  {
>  	kfree(tags->rqs);
>  	tags->rqs = NULL;
>  	kfree(tags->static_rqs);
>  	tags->static_rqs = NULL;
>  
> -	blk_mq_free_tags(tags, flags);
> +	blk_mq_free_tags(tags);
>  }
>  
>  struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
>  					unsigned int hctx_idx,
>  					unsigned int nr_tags,
> -					unsigned int reserved_tags,
> -					unsigned int flags)
> +					unsigned int reserved_tags)
>  {
>  	struct blk_mq_tags *tags;
>  	int node;
> @@ -2400,7 +2402,8 @@ struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
>  	if (node == NUMA_NO_NODE)
>  		node = set->numa_node;
>  
> -	tags = blk_mq_init_tags(nr_tags, reserved_tags, node, flags);
> +	tags = blk_mq_init_tags(nr_tags, reserved_tags, node,
> +				BLK_MQ_FLAG_TO_ALLOC_POLICY(set->flags));
>  	if (!tags)
>  		return NULL;
>  
> @@ -2408,7 +2411,7 @@ struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
>  				 GFP_NOIO | __GFP_NOWARN | __GFP_NORETRY,
>  				 node);
>  	if (!tags->rqs) {
> -		blk_mq_free_tags(tags, flags);
> +		blk_mq_free_tags(tags);
>  		return NULL;
>  	}
>  
> @@ -2417,7 +2420,7 @@ struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
>  					node);
>  	if (!tags->static_rqs) {
>  		kfree(tags->rqs);
> -		blk_mq_free_tags(tags, flags);
> +		blk_mq_free_tags(tags);
>  		return NULL;
>  	}
>  
> @@ -2859,8 +2862,14 @@ static bool __blk_mq_alloc_map_and_request(struct blk_mq_tag_set *set,
>  	unsigned int flags = set->flags;
>  	int ret = 0;
>  
> +	if (blk_mq_is_sbitmap_shared(flags)) {
> +		set->tags[hctx_idx] = set->shared_sbitmap_tags;
> +
> +		return true;
> +	}
> +
>  	set->tags[hctx_idx] = blk_mq_alloc_rq_map(set, hctx_idx,
> -					set->queue_depth, set->reserved_tags, flags);
> +					set->queue_depth, set->reserved_tags);
>  	if (!set->tags[hctx_idx])
>  		return false;
>  
> @@ -2869,7 +2878,7 @@ static bool __blk_mq_alloc_map_and_request(struct blk_mq_tag_set *set,
>  	if (!ret)
>  		return true;
>  
> -	blk_mq_free_rq_map(set->tags[hctx_idx], flags);
> +	blk_mq_free_rq_map(set->tags[hctx_idx]);
>  	set->tags[hctx_idx] = NULL;
>  	return false;
>  }
> @@ -2877,11 +2886,11 @@ static bool __blk_mq_alloc_map_and_request(struct blk_mq_tag_set *set,
>  static void blk_mq_free_map_and_requests(struct blk_mq_tag_set *set,
>  					 unsigned int hctx_idx)
>  {
> -	unsigned int flags = set->flags;
> -
>  	if (set->tags && set->tags[hctx_idx]) {
> -		blk_mq_free_rqs(set, set->tags[hctx_idx], hctx_idx);
> -		blk_mq_free_rq_map(set->tags[hctx_idx], flags);
> +		if (!blk_mq_is_sbitmap_shared(set->flags)) {

I remember you hate negative check, :-)

> +			blk_mq_free_rqs(set, set->tags[hctx_idx], hctx_idx);
> +			blk_mq_free_rq_map(set->tags[hctx_idx]);

We can add one helper of blk_mq_free_map_and_rqs(), and there seems
several such pattern.

> +		}
>  		set->tags[hctx_idx] = NULL;
>  	}
>  }
> @@ -3348,6 +3357,21 @@ static int __blk_mq_alloc_rq_maps(struct blk_mq_tag_set *set)
>  {
>  	int i;
>  
> +	if (blk_mq_is_sbitmap_shared(set->flags)) {
> +		int ret;
> +
> +		set->shared_sbitmap_tags = blk_mq_alloc_rq_map(set, 0,
> +						  set->queue_depth,
> +						  set->reserved_tags);
> +		if (!set->shared_sbitmap_tags)
> +			return -ENOMEM;
> +
> +		ret = blk_mq_alloc_rqs(set, set->shared_sbitmap_tags, 0,
> +				       set->queue_depth);
> +		if (ret)
> +			goto out_free_sbitmap_tags;
> +	}
> +
>  	for (i = 0; i < set->nr_hw_queues; i++) {
>  		if (!__blk_mq_alloc_map_and_request(set, i))
>  			goto out_unwind;
> @@ -3359,6 +3383,11 @@ static int __blk_mq_alloc_rq_maps(struct blk_mq_tag_set *set)
>  out_unwind:
>  	while (--i >= 0)
>  		blk_mq_free_map_and_requests(set, i);
> +	if (blk_mq_is_sbitmap_shared(set->flags))
> +		blk_mq_free_rqs(set, set->shared_sbitmap_tags, 0);
> +out_free_sbitmap_tags:
> +	if (blk_mq_is_sbitmap_shared(set->flags))
> +		blk_mq_exit_shared_sbitmap(set);

Once a helper of blk_mq_alloc_map_and_rqs() is added, the above failure
handling can be simplified too.


-- 
Ming

