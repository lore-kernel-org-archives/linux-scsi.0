Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C8D4C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 02:03:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B83CA61415
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 02:03:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbhENCEw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 22:04:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27911 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230213AbhENCEw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 May 2021 22:04:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620957820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XUUlvqNyvKlyLaPFHB8CAatW7xT4Gd7RHo/V7t5+CpQ=;
        b=H1E7bnT7Ml8ehbv5szxD3F9jfYxUdCTDS5dtZ7WBz3U44zDHyYSK3pdObIFs6U3bL+BlOG
        S3br41AqhQXH25NGiaKEfKTspuCm5eCZvFIIEx0R0Wz6R8vo5u8rk5sjwztR8yj9Yz8fO9
        bDY/FfdJn0BcClYAXEuw7QGZMQIIsmQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-49BR4mfAMaepo9kVjmidrQ-1; Thu, 13 May 2021 22:03:39 -0400
X-MC-Unique: 49BR4mfAMaepo9kVjmidrQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6AC7CFC93;
        Fri, 14 May 2021 02:03:37 +0000 (UTC)
Received: from T590 (ovpn-12-87.pek2.redhat.com [10.72.12.87])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AF41F60CC6;
        Fri, 14 May 2021 02:03:29 +0000 (UTC)
Date:   Fri, 14 May 2021 10:03:25 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     axboe@kernel.dk, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kashyap.desai@broadcom.com, chenxiang66@hisilicon.com,
        yama@redhat.com, dgilbert@interlog.com
Subject: Re: [PATCH v3 1/2] blk-mq: Some tag allocation code refactoring
Message-ID: <YJ3abcOPU3rvh51i@T590>
References: <1620907258-30910-1-git-send-email-john.garry@huawei.com>
 <1620907258-30910-2-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1620907258-30910-2-git-send-email-john.garry@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, May 13, 2021 at 08:00:57PM +0800, John Garry wrote:
> The tag allocation code to alloc the sbitmap pairs is common for regular
> bitmaps tags and shared sbitmap, so refactor into a common function.
> 
> Also remove superfluous "flags" argument from blk_mq_init_shared_sbitmap().
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  block/blk-mq-tag.c | 54 ++++++++++++++++++++++++++++------------------
>  block/blk-mq-tag.h |  9 +++++---
>  block/blk-mq.c     |  2 +-
>  3 files changed, 40 insertions(+), 25 deletions(-)
> 
> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
> index 2a37731e8244..45479c0f88a2 100644
> --- a/block/blk-mq-tag.c
> +++ b/block/blk-mq-tag.c
> @@ -445,39 +445,54 @@ static int bt_alloc(struct sbitmap_queue *bt, unsigned int depth,
>  				       node);
>  }
>  
> -static int blk_mq_init_bitmap_tags(struct blk_mq_tags *tags,
> -				   int node, int alloc_policy)
> +int blk_mq_init_bitmaps(struct sbitmap_queue *bitmap_tags,
> +			struct sbitmap_queue *breserved_tags,
> +			unsigned int queue_depth, unsigned int reserved,
> +			int node, int alloc_policy)
>  {
> -	unsigned int depth = tags->nr_tags - tags->nr_reserved_tags;
> +	unsigned int depth = queue_depth - reserved;
>  	bool round_robin = alloc_policy == BLK_TAG_ALLOC_RR;
>  
> -	if (bt_alloc(&tags->__bitmap_tags, depth, round_robin, node))
> +	if (bt_alloc(bitmap_tags, depth, round_robin, node))
>  		return -ENOMEM;
> -	if (bt_alloc(&tags->__breserved_tags, tags->nr_reserved_tags,
> -		     round_robin, node))
> +	if (bt_alloc(breserved_tags, reserved, round_robin, node))
>  		goto free_bitmap_tags;
>  
> +	return 0;
> +
> +free_bitmap_tags:
> +	sbitmap_queue_free(bitmap_tags);
> +	return -ENOMEM;
> +}
> +
> +static int blk_mq_init_bitmap_tags(struct blk_mq_tags *tags,
> +				   int node, int alloc_policy)
> +{
> +	int ret;
> +
> +	ret = blk_mq_init_bitmaps(&tags->__bitmap_tags,
> +				  &tags->__breserved_tags,
> +				  tags->nr_tags, tags->nr_reserved_tags,
> +				  node, alloc_policy);
> +	if (ret)
> +		return ret;
> +
>  	tags->bitmap_tags = &tags->__bitmap_tags;
>  	tags->breserved_tags = &tags->__breserved_tags;
>  
>  	return 0;
> -free_bitmap_tags:
> -	sbitmap_queue_free(&tags->__bitmap_tags);
> -	return -ENOMEM;
>  }
>  
> -int blk_mq_init_shared_sbitmap(struct blk_mq_tag_set *set, unsigned int flags)
> +int blk_mq_init_shared_sbitmap(struct blk_mq_tag_set *set)
>  {
> -	unsigned int depth = set->queue_depth - set->reserved_tags;
>  	int alloc_policy = BLK_MQ_FLAG_TO_ALLOC_POLICY(set->flags);
> -	bool round_robin = alloc_policy == BLK_TAG_ALLOC_RR;
> -	int i, node = set->numa_node;
> +	int i, ret;
>  
> -	if (bt_alloc(&set->__bitmap_tags, depth, round_robin, node))
> -		return -ENOMEM;
> -	if (bt_alloc(&set->__breserved_tags, set->reserved_tags,
> -		     round_robin, node))
> -		goto free_bitmap_tags;
> +	ret = blk_mq_init_bitmaps(&set->__bitmap_tags, &set->__breserved_tags,
> +				  set->queue_depth, set->reserved_tags,
> +				  set->numa_node, alloc_policy);
> +	if (ret)
> +		return ret;
>  
>  	for (i = 0; i < set->nr_hw_queues; i++) {
>  		struct blk_mq_tags *tags = set->tags[i];
> @@ -487,9 +502,6 @@ int blk_mq_init_shared_sbitmap(struct blk_mq_tag_set *set, unsigned int flags)
>  	}
>  
>  	return 0;
> -free_bitmap_tags:
> -	sbitmap_queue_free(&set->__bitmap_tags);
> -	return -ENOMEM;
>  }
>  
>  void blk_mq_exit_shared_sbitmap(struct blk_mq_tag_set *set)
> diff --git a/block/blk-mq-tag.h b/block/blk-mq-tag.h
> index 7d3e6b333a4a..2a718c8d080f 100644
> --- a/block/blk-mq-tag.h
> +++ b/block/blk-mq-tag.h
> @@ -26,11 +26,14 @@ extern struct blk_mq_tags *blk_mq_init_tags(unsigned int nr_tags,
>  					unsigned int reserved_tags,
>  					int node, unsigned int flags);
>  extern void blk_mq_free_tags(struct blk_mq_tags *tags, unsigned int flags);
> +extern int blk_mq_init_bitmaps(struct sbitmap_queue *bitmap_tags,
> +			       struct sbitmap_queue *breserved_tags,
> +			       unsigned int queue_depth,
> +			       unsigned int reserved,
> +			       int node, int alloc_policy);
>  
> -extern int blk_mq_init_shared_sbitmap(struct blk_mq_tag_set *set,
> -				      unsigned int flags);
> +extern int blk_mq_init_shared_sbitmap(struct blk_mq_tag_set *set);
>  extern void blk_mq_exit_shared_sbitmap(struct blk_mq_tag_set *set);
> -
>  extern unsigned int blk_mq_get_tag(struct blk_mq_alloc_data *data);
>  extern void blk_mq_put_tag(struct blk_mq_tags *tags, struct blk_mq_ctx *ctx,
>  			   unsigned int tag);
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 466676bc2f0b..499ad5462f7e 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -3488,7 +3488,7 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
>  	if (blk_mq_is_sbitmap_shared(set->flags)) {
>  		atomic_set(&set->active_queues_shared_sbitmap, 0);
>  
> -		if (blk_mq_init_shared_sbitmap(set, set->flags)) {
> +		if (blk_mq_init_shared_sbitmap(set)) {
>  			ret = -ENOMEM;
>  			goto out_free_mq_rq_maps;
>  		}
> -- 
> 2.26.2
> 

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

