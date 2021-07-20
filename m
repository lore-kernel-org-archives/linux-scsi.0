Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78A9BC636C8
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Jul 2021 15:58:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A8EF61164
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Jul 2021 15:58:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239799AbhGTPR7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Jul 2021 11:17:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37508 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241214AbhGTOph (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Jul 2021 10:45:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626794762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VvhRyI9qx2opvkzxayFq3lx3Fi91A+65gJ9KuJmJw0Y=;
        b=ABjbqeQc8tgEuI/Wo8oTCCUnwDrfhNUnbm5xS4feM83FscDbELbsVRdwohoqtjD6vuNG/7
        0xMe/a/YhzZkUagnIfX4r4EwvTgWirF/8baBK+3IHECar7N8gwvZTsA3teUMza+bbPIF+W
        zfAZaBaHz9uKumFb+BOHZ1fnbSgBfV8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-t1xGmvbZPOu_b0e2Gaa-1g-1; Tue, 20 Jul 2021 11:22:40 -0400
X-MC-Unique: t1xGmvbZPOu_b0e2Gaa-1g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7462E80414C;
        Tue, 20 Jul 2021 15:22:39 +0000 (UTC)
Received: from T590 (ovpn-12-98.pek2.redhat.com [10.72.12.98])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C4FDE60877;
        Tue, 20 Jul 2021 15:22:30 +0000 (UTC)
Date:   Tue, 20 Jul 2021 23:22:25 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     axboe@kernel.dk, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kashyap.desai@broadcom.com, hare@suse.de
Subject: Re: [PATCH 0/9] blk-mq: Reduce static requests memory footprint for
 shared sbitmap
Message-ID: <YPbqMSjZIA8l0jHQ@T590>
References: <1626275195-215652-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1626275195-215652-1-git-send-email-john.garry@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 14, 2021 at 11:06:26PM +0800, John Garry wrote:
> Currently a full set of static requests are allocated per hw queue per
> tagset when shared sbitmap is used.
> 
> However, only tagset->queue_depth number of requests may be active at
> any given time. As such, only tagset->queue_depth number of static
> requests are required.
> 
> The same goes for using an IO scheduler, which allocates a full set of
> static requests per hw queue per request queue.
> 
> This series very significantly reduces memory usage in both scenarios by
> allocating static rqs per tagset and per request queue, respectively,
> rather than per hw queue per tagset and per request queue.
> 
> For megaraid sas driver on my 128-CPU arm64 system with 1x SATA disk, we
> save approx. 300MB(!) [370MB -> 60MB]
> 
> A couple of patches are marked as RFC, as maybe there is a better
> implementation approach.

There is another candidate for addressing this issue, and looks simpler:

 block/blk-mq-sched.c |  4 ++++
 block/blk-mq-tag.c   |  4 ++++
 block/blk-mq-tag.h   |  3 +++
 block/blk-mq.c       | 18 ++++++++++++++++++
 block/blk-mq.h       | 11 +++++++++++
 5 files changed, 40 insertions(+)

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index c838d81ac058..b9236ee0fe4e 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -538,6 +538,10 @@ static int blk_mq_sched_alloc_tags(struct request_queue *q,
 	if (!hctx->sched_tags)
 		return -ENOMEM;
 
+	blk_mq_set_master_tags(hctx->sched_tags,
+			q->queue_hw_ctx[0]->sched_tags, hctx->flags,
+			hctx_idx);
+
 	ret = blk_mq_alloc_rqs(set, hctx->sched_tags, hctx_idx, q->nr_requests);
 	if (ret)
 		blk_mq_sched_free_tags(set, hctx, hctx_idx);
diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 86f87346232a..c471a073234d 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -608,6 +608,10 @@ int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
 				tags->nr_reserved_tags, set->flags);
 		if (!new)
 			return -ENOMEM;
+
+		blk_mq_set_master_tags(new,
+			hctx->queue->queue_hw_ctx[0]->sched_tags, set->flags,
+			hctx->queue_num);
 		ret = blk_mq_alloc_rqs(set, new, hctx->queue_num, tdepth);
 		if (ret) {
 			blk_mq_free_rq_map(new, set->flags);
diff --git a/block/blk-mq-tag.h b/block/blk-mq-tag.h
index 8ed55af08427..0a3fbbc61e06 100644
--- a/block/blk-mq-tag.h
+++ b/block/blk-mq-tag.h
@@ -21,6 +21,9 @@ struct blk_mq_tags {
 	struct request **static_rqs;
 	struct list_head page_list;
 
+	/* only used for blk_mq_is_sbitmap_shared() */
+	struct blk_mq_tags	*master;
+
 	/*
 	 * used to clear request reference in rqs[] before freeing one
 	 * request pool
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 2c4ac51e54eb..ef8a6a7e5f7c 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2348,6 +2348,15 @@ void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
 {
 	struct page *page;
 
+	if (blk_mq_is_sbitmap_shared(set->flags)) {
+		if (tags->master)
+			tags = tags->master;
+		if (hctx_idx < set->nr_hw_queues - 1) {
+			blk_mq_clear_rq_mapping(set, tags, hctx_idx);
+			return;
+		}
+	}
+
 	if (tags->rqs && set->ops->exit_request) {
 		int i;
 
@@ -2444,6 +2453,12 @@ int blk_mq_alloc_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
 	size_t rq_size, left;
 	int node;
 
+	if (blk_mq_is_sbitmap_shared(set->flags) && tags->master) {
+		memcpy(tags->static_rqs, tags->master->static_rqs,
+		       sizeof(tags->static_rqs[0]) * tags->nr_tags);
+		return 0;
+	}
+
 	node = blk_mq_hw_queue_to_node(&set->map[HCTX_TYPE_DEFAULT], hctx_idx);
 	if (node == NUMA_NO_NODE)
 		node = set->numa_node;
@@ -2860,6 +2875,9 @@ static bool __blk_mq_alloc_map_and_request(struct blk_mq_tag_set *set,
 	if (!set->tags[hctx_idx])
 		return false;
 
+	blk_mq_set_master_tags(set->tags[hctx_idx], set->tags[0], flags,
+			       hctx_idx);
+
 	ret = blk_mq_alloc_rqs(set, set->tags[hctx_idx], hctx_idx,
 				set->queue_depth);
 	if (!ret)
diff --git a/block/blk-mq.h b/block/blk-mq.h
index d08779f77a26..a08b89be6acc 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -354,5 +354,16 @@ static inline bool hctx_may_queue(struct blk_mq_hw_ctx *hctx,
 	return __blk_mq_active_requests(hctx) < depth;
 }
 
+static inline void blk_mq_set_master_tags(struct blk_mq_tags *tags,
+		struct blk_mq_tags *master_tags, unsigned int flags,
+		unsigned int hctx_idx)
+{
+	if (blk_mq_is_sbitmap_shared(flags)) {
+		if (hctx_idx)
+			tags->master = master_tags;
+		else
+			tags->master = NULL;
+	}
+}
 
 #endif


Thanks,
Ming

