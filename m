Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5ECBC4320A
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 12:07:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99B6060FDA
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 12:07:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245192AbhH0MIH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 08:08:07 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3707 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245158AbhH0MIE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Aug 2021 08:08:04 -0400
Received: from fraeml735-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Gwz2D2c7Xz67c4B;
        Fri, 27 Aug 2021 20:05:56 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml735-chm.china.huawei.com (10.206.15.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 27 Aug 2021 14:07:13 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 27 Aug 2021 13:07:11 +0100
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ming.lei@redhat.com>, <linux-scsi@vger.kernel.org>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v3 12/13] blk-mq: Use shared tags for shared sbitmap support
Date:   Fri, 27 Aug 2021 20:02:03 +0800
Message-ID: <1630065724-69146-13-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1630065724-69146-1-git-send-email-john.garry@huawei.com>
References: <1630065724-69146-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently we use separate sbitmap pairs and active_queues atomic_t for
shared sbitmap support.

However a full sets of static requests are used per HW queue, which is
quite wasteful, considering that the total number of requests usable at
any given time across all HW queues is limited by the shared sbitmap depth.

As such, it is considerably more memory efficient in the case of shared
sbitmap to allocate a set of static rqs per tag set or request queue, and
not per HW queue.

So replace the sbitmap pairs and active_queues atomic_t with a shared
tags per tagset and request queue, which will hold a set of shared static
rqs.

Since there is now no valid HW queue index to be passed to the blk_mq_ops
.init and .exit_request callbacks, pass an invalid index token. This
changes the semantics of the APIs, such that the callback would need to
validate the HW queue index before using it. Currently no user of shared
sbitmap actually uses the HW queue index (as would be expected).

Continue to use term "shared sbitmap" for now, as the meaning is known.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 block/blk-mq-sched.c   | 84 +++++++++++++++++++-------------------
 block/blk-mq-tag.c     | 61 +++++++++-------------------
 block/blk-mq-tag.h     |  6 +--
 block/blk-mq.c         | 92 ++++++++++++++++++++++++------------------
 block/blk-mq.h         |  5 ++-
 include/linux/blk-mq.h | 15 ++++---
 include/linux/blkdev.h |  3 +-
 7 files changed, 127 insertions(+), 139 deletions(-)

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index 17752f39e144..428da4949d80 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -519,6 +519,11 @@ static int blk_mq_sched_alloc_map_and_rqs(struct request_queue *q,
 					  struct blk_mq_hw_ctx *hctx,
 					  unsigned int hctx_idx)
 {
+	if (blk_mq_is_sbitmap_shared(q->tag_set->flags)) {
+		hctx->sched_tags = q->shared_sbitmap_tags;
+		return 0;
+	}
+
 	hctx->sched_tags = blk_mq_alloc_map_and_rqs(q->tag_set, hctx_idx,
 						    q->nr_requests);
 
@@ -527,61 +532,54 @@ static int blk_mq_sched_alloc_map_and_rqs(struct request_queue *q,
 	return 0;
 }
 
+static void blk_mq_exit_sched_shared_sbitmap(struct request_queue *queue)
+{
+	blk_mq_free_rq_map(queue->shared_sbitmap_tags);
+	queue->shared_sbitmap_tags = NULL;
+}
+
 /* called in queue's release handler, tagset has gone away */
-static void blk_mq_sched_tags_teardown(struct request_queue *q)
+static void blk_mq_sched_tags_teardown(struct request_queue *q, unsigned int flags)
 {
 	struct blk_mq_hw_ctx *hctx;
 	int i;
 
 	queue_for_each_hw_ctx(q, hctx, i) {
 		if (hctx->sched_tags) {
-			blk_mq_free_rq_map(hctx->sched_tags, hctx->flags);
+			if (!blk_mq_is_sbitmap_shared(q->tag_set->flags))
+				blk_mq_free_rq_map(hctx->sched_tags);
 			hctx->sched_tags = NULL;
 		}
 	}
+
+	if (blk_mq_is_sbitmap_shared(flags))
+		blk_mq_exit_sched_shared_sbitmap(q);
 }
 
 static int blk_mq_init_sched_shared_sbitmap(struct request_queue *queue)
 {
 	struct blk_mq_tag_set *set = queue->tag_set;
-	int alloc_policy = BLK_MQ_FLAG_TO_ALLOC_POLICY(set->flags);
-	struct blk_mq_hw_ctx *hctx;
-	int ret, i;
 
 	/*
 	 * Set initial depth at max so that we don't need to reallocate for
 	 * updating nr_requests.
 	 */
-	ret = blk_mq_init_bitmaps(&queue->sched_bitmap_tags,
-				  &queue->sched_breserved_tags,
-				  MAX_SCHED_RQ, set->reserved_tags,
-				  set->numa_node, alloc_policy);
-	if (ret)
-		return ret;
-
-	queue_for_each_hw_ctx(queue, hctx, i) {
-		hctx->sched_tags->bitmap_tags =
-					&queue->sched_bitmap_tags;
-		hctx->sched_tags->breserved_tags =
-					&queue->sched_breserved_tags;
-	}
+	queue->shared_sbitmap_tags = blk_mq_alloc_map_and_rqs(set,
+						BLK_MQ_NO_HCTX_IDX,
+						MAX_SCHED_RQ);
+	if (!queue->shared_sbitmap_tags)
+		return -ENOMEM;
 
 	blk_mq_tag_update_sched_shared_sbitmap(queue);
 
 	return 0;
 }
 
-static void blk_mq_exit_sched_shared_sbitmap(struct request_queue *queue)
-{
-	sbitmap_queue_free(&queue->sched_bitmap_tags);
-	sbitmap_queue_free(&queue->sched_breserved_tags);
-}
-
 int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
 {
+	unsigned int i, flags = q->tag_set->flags;
 	struct blk_mq_hw_ctx *hctx;
 	struct elevator_queue *eq;
-	unsigned int i;
 	int ret;
 
 	if (!e) {
@@ -598,21 +596,21 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
 	q->nr_requests = 2 * min_t(unsigned int, q->tag_set->queue_depth,
 				   BLKDEV_DEFAULT_RQ);
 
-	queue_for_each_hw_ctx(q, hctx, i) {
-		ret = blk_mq_sched_alloc_map_and_rqs(q, hctx, i);
+	if (blk_mq_is_sbitmap_shared(flags)) {
+		ret = blk_mq_init_sched_shared_sbitmap(q);
 		if (ret)
-			goto err_free_map_and_rqs;
+			return ret;
 	}
 
-	if (blk_mq_is_sbitmap_shared(q->tag_set->flags)) {
-		ret = blk_mq_init_sched_shared_sbitmap(q);
+	queue_for_each_hw_ctx(q, hctx, i) {
+		ret = blk_mq_sched_alloc_map_and_rqs(q, hctx, i);
 		if (ret)
 			goto err_free_map_and_rqs;
 	}
 
 	ret = e->ops.init_sched(q, e);
 	if (ret)
-		goto err_free_sbitmap;
+		goto err_free_map_and_rqs;
 
 	blk_mq_debugfs_register_sched(q);
 
@@ -632,12 +630,10 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
 
 	return 0;
 
-err_free_sbitmap:
-	if (blk_mq_is_sbitmap_shared(q->tag_set->flags))
-		blk_mq_exit_sched_shared_sbitmap(q);
-	blk_mq_sched_free_rqs(q);
 err_free_map_and_rqs:
-	blk_mq_sched_tags_teardown(q);
+	blk_mq_sched_free_rqs(q);
+	blk_mq_sched_tags_teardown(q, flags);
+
 	q->elevator = NULL;
 	return ret;
 }
@@ -651,9 +647,15 @@ void blk_mq_sched_free_rqs(struct request_queue *q)
 	struct blk_mq_hw_ctx *hctx;
 	int i;
 
-	queue_for_each_hw_ctx(q, hctx, i) {
-		if (hctx->sched_tags)
-			blk_mq_free_rqs(q->tag_set, hctx->sched_tags, i);
+	if (blk_mq_is_sbitmap_shared(q->tag_set->flags)) {
+		blk_mq_free_rqs(q->tag_set, q->shared_sbitmap_tags,
+				BLK_MQ_NO_HCTX_IDX);
+	} else {
+		queue_for_each_hw_ctx(q, hctx, i) {
+			if (hctx->sched_tags)
+				blk_mq_free_rqs(q->tag_set,
+						hctx->sched_tags, i);
+		}
 	}
 }
 
@@ -674,8 +676,6 @@ void blk_mq_exit_sched(struct request_queue *q, struct elevator_queue *e)
 	blk_mq_debugfs_unregister_sched(q);
 	if (e->type->ops.exit_sched)
 		e->type->ops.exit_sched(e);
-	blk_mq_sched_tags_teardown(q);
-	if (blk_mq_is_sbitmap_shared(flags))
-		blk_mq_exit_sched_shared_sbitmap(q);
+	blk_mq_sched_tags_teardown(q, flags);
 	q->elevator = NULL;
 }
diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index fcc33581ce5e..29b93ea0ea27 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -27,10 +27,11 @@ bool __blk_mq_tag_busy(struct blk_mq_hw_ctx *hctx)
 	if (blk_mq_is_sbitmap_shared(hctx->flags)) {
 		struct request_queue *q = hctx->queue;
 		struct blk_mq_tag_set *set = q->tag_set;
+		struct blk_mq_tags *tags = set->shared_sbitmap_tags;
 
 		if (!test_bit(QUEUE_FLAG_HCTX_ACTIVE, &q->queue_flags) &&
 		    !test_and_set_bit(QUEUE_FLAG_HCTX_ACTIVE, &q->queue_flags))
-			atomic_inc(&set->active_queues_shared_sbitmap);
+			atomic_inc(&tags->active_queues);
 	} else {
 		if (!test_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state) &&
 		    !test_and_set_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
@@ -61,10 +62,12 @@ void __blk_mq_tag_idle(struct blk_mq_hw_ctx *hctx)
 	struct blk_mq_tag_set *set = q->tag_set;
 
 	if (blk_mq_is_sbitmap_shared(hctx->flags)) {
+		struct blk_mq_tags *tags = set->shared_sbitmap_tags;
+
 		if (!test_and_clear_bit(QUEUE_FLAG_HCTX_ACTIVE,
 					&q->queue_flags))
 			return;
-		atomic_dec(&set->active_queues_shared_sbitmap);
+		atomic_dec(&tags->active_queues);
 	} else {
 		if (!test_and_clear_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
 			return;
@@ -510,38 +513,10 @@ static int blk_mq_init_bitmap_tags(struct blk_mq_tags *tags,
 	return 0;
 }
 
-int blk_mq_init_shared_sbitmap(struct blk_mq_tag_set *set)
-{
-	int alloc_policy = BLK_MQ_FLAG_TO_ALLOC_POLICY(set->flags);
-	int i, ret;
-
-	ret = blk_mq_init_bitmaps(&set->__bitmap_tags, &set->__breserved_tags,
-				  set->queue_depth, set->reserved_tags,
-				  set->numa_node, alloc_policy);
-	if (ret)
-		return ret;
-
-	for (i = 0; i < set->nr_hw_queues; i++) {
-		struct blk_mq_tags *tags = set->tags[i];
-
-		tags->bitmap_tags = &set->__bitmap_tags;
-		tags->breserved_tags = &set->__breserved_tags;
-	}
-
-	return 0;
-}
-
-void blk_mq_exit_shared_sbitmap(struct blk_mq_tag_set *set)
-{
-	sbitmap_queue_free(&set->__bitmap_tags);
-	sbitmap_queue_free(&set->__breserved_tags);
-}
-
 struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
 				     unsigned int reserved_tags,
-				     int node, unsigned int flags)
+				     int node, int alloc_policy)
 {
-	int alloc_policy = BLK_MQ_FLAG_TO_ALLOC_POLICY(flags);
 	struct blk_mq_tags *tags;
 
 	if (total_tags > BLK_MQ_TAG_MAX) {
@@ -557,9 +532,6 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
 	tags->nr_reserved_tags = reserved_tags;
 	spin_lock_init(&tags->lock);
 
-	if (blk_mq_is_sbitmap_shared(flags))
-		return tags;
-
 	if (blk_mq_init_bitmap_tags(tags, node, alloc_policy) < 0) {
 		kfree(tags);
 		return NULL;
@@ -567,12 +539,10 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
 	return tags;
 }
 
-void blk_mq_free_tags(struct blk_mq_tags *tags, unsigned int flags)
+void blk_mq_free_tags(struct blk_mq_tags *tags)
 {
-	if (!blk_mq_is_sbitmap_shared(flags)) {
-		sbitmap_queue_free(tags->bitmap_tags);
-		sbitmap_queue_free(tags->breserved_tags);
-	}
+	sbitmap_queue_free(tags->bitmap_tags);
+	sbitmap_queue_free(tags->breserved_tags);
 	kfree(tags);
 }
 
@@ -603,6 +573,13 @@ int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
 		if (tdepth > MAX_SCHED_RQ)
 			return -EINVAL;
 
+		/*
+		 * Only the sbitmap needs resizing since we allocated the max
+		 * initially.
+		 */
+		if (blk_mq_is_sbitmap_shared(set->flags))
+			return 0;
+
 		new = blk_mq_alloc_map_and_rqs(set, hctx->queue_num, tdepth);
 		if (!new)
 			return -ENOMEM;
@@ -623,12 +600,14 @@ int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
 
 void blk_mq_tag_resize_shared_sbitmap(struct blk_mq_tag_set *set, unsigned int size)
 {
-	sbitmap_queue_resize(&set->__bitmap_tags, size - set->reserved_tags);
+	struct blk_mq_tags *tags = set->shared_sbitmap_tags;
+
+	sbitmap_queue_resize(&tags->__bitmap_tags, size - set->reserved_tags);
 }
 
 void blk_mq_tag_update_sched_shared_sbitmap(struct request_queue *q)
 {
-	sbitmap_queue_resize(&q->sched_bitmap_tags,
+	sbitmap_queue_resize(q->shared_sbitmap_tags->bitmap_tags,
 			     q->nr_requests - q->tag_set->reserved_tags);
 }
 
diff --git a/block/blk-mq-tag.h b/block/blk-mq-tag.h
index 88f3c6485543..e433e39a9cfa 100644
--- a/block/blk-mq-tag.h
+++ b/block/blk-mq-tag.h
@@ -30,16 +30,14 @@ struct blk_mq_tags {
 
 extern struct blk_mq_tags *blk_mq_init_tags(unsigned int nr_tags,
 					unsigned int reserved_tags,
-					int node, unsigned int flags);
-extern void blk_mq_free_tags(struct blk_mq_tags *tags, unsigned int flags);
+					int node, int alloc_policy);
+extern void blk_mq_free_tags(struct blk_mq_tags *tags);
 extern int blk_mq_init_bitmaps(struct sbitmap_queue *bitmap_tags,
 			       struct sbitmap_queue *breserved_tags,
 			       unsigned int queue_depth,
 			       unsigned int reserved,
 			       int node, int alloc_policy);
 
-extern int blk_mq_init_shared_sbitmap(struct blk_mq_tag_set *set);
-extern void blk_mq_exit_shared_sbitmap(struct blk_mq_tag_set *set);
 extern unsigned int blk_mq_get_tag(struct blk_mq_alloc_data *data);
 extern void blk_mq_put_tag(struct blk_mq_tags *tags, struct blk_mq_ctx *ctx,
 			   unsigned int tag);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index af6bd375b6a5..958761c0b26b 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2352,7 +2352,10 @@ void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
 	struct blk_mq_tags *drv_tags;
 	struct page *page;
 
-	drv_tags = set->tags[hctx_idx];
+	if (blk_mq_is_sbitmap_shared(set->flags))
+		drv_tags = set->shared_sbitmap_tags;
+	else
+		drv_tags = set->tags[hctx_idx];
 
 	if (tags->static_rqs && set->ops->exit_request) {
 		int i;
@@ -2362,6 +2365,7 @@ void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
 
 			if (!rq)
 				continue;
+
 			set->ops->exit_request(set, rq, hctx_idx);
 			tags->static_rqs[i] = NULL;
 		}
@@ -2381,21 +2385,20 @@ void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
 	}
 }
 
-void blk_mq_free_rq_map(struct blk_mq_tags *tags, unsigned int flags)
+void blk_mq_free_rq_map(struct blk_mq_tags *tags)
 {
 	kfree(tags->rqs);
 	tags->rqs = NULL;
 	kfree(tags->static_rqs);
 	tags->static_rqs = NULL;
 
-	blk_mq_free_tags(tags, flags);
+	blk_mq_free_tags(tags);
 }
 
 static struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
 					       unsigned int hctx_idx,
 					       unsigned int nr_tags,
-					       unsigned int reserved_tags,
-					       unsigned int flags)
+					       unsigned int reserved_tags)
 {
 	struct blk_mq_tags *tags;
 	int node;
@@ -2404,7 +2407,8 @@ static struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
 	if (node == NUMA_NO_NODE)
 		node = set->numa_node;
 
-	tags = blk_mq_init_tags(nr_tags, reserved_tags, node, flags);
+	tags = blk_mq_init_tags(nr_tags, reserved_tags, node,
+				BLK_MQ_FLAG_TO_ALLOC_POLICY(set->flags));
 	if (!tags)
 		return NULL;
 
@@ -2412,7 +2416,7 @@ static struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
 				 GFP_NOIO | __GFP_NOWARN | __GFP_NORETRY,
 				 node);
 	if (!tags->rqs) {
-		blk_mq_free_tags(tags, flags);
+		blk_mq_free_tags(tags);
 		return NULL;
 	}
 
@@ -2421,7 +2425,7 @@ static struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
 					node);
 	if (!tags->static_rqs) {
 		kfree(tags->rqs);
-		blk_mq_free_tags(tags, flags);
+		blk_mq_free_tags(tags);
 		return NULL;
 	}
 
@@ -2863,14 +2867,13 @@ struct blk_mq_tags *blk_mq_alloc_map_and_rqs(struct blk_mq_tag_set *set,
 	struct blk_mq_tags *tags;
 	int ret;
 
-	tags = blk_mq_alloc_rq_map(set, hctx_idx, depth, set->reserved_tags,
-				   set->flags);
+	tags = blk_mq_alloc_rq_map(set, hctx_idx, depth, set->reserved_tags);
 	if (!tags)
 		return NULL;
 
 	ret = blk_mq_alloc_rqs(set, tags, hctx_idx, depth);
 	if (ret) {
-		blk_mq_free_rq_map(tags, set->flags);
+		blk_mq_free_rq_map(tags);
 		return NULL;
 	}
 
@@ -2880,6 +2883,12 @@ struct blk_mq_tags *blk_mq_alloc_map_and_rqs(struct blk_mq_tag_set *set,
 static bool __blk_mq_alloc_map_and_rqs(struct blk_mq_tag_set *set,
 				       int hctx_idx)
 {
+	if (blk_mq_is_sbitmap_shared(set->flags)) {
+		set->tags[hctx_idx] = set->shared_sbitmap_tags;
+
+		return true;
+	}
+
 	set->tags[hctx_idx] = blk_mq_alloc_map_and_rqs(set, hctx_idx,
 						       set->queue_depth);
 
@@ -2890,14 +2899,22 @@ void blk_mq_free_map_and_rqs(struct blk_mq_tag_set *set,
 			     struct blk_mq_tags *tags,
 			     unsigned int hctx_idx)
 {
-	unsigned int flags = set->flags;
-
 	if (tags) {
 		blk_mq_free_rqs(set, tags, hctx_idx);
-		blk_mq_free_rq_map(tags, flags);
+		blk_mq_free_rq_map(tags);
 	}
 }
 
+static void __blk_mq_free_map_and_rqs(struct blk_mq_tag_set *set,
+				      struct blk_mq_tags *tags,
+				      unsigned int hctx_idx)
+{
+	if (blk_mq_is_sbitmap_shared(set->flags))
+		return;
+
+	blk_mq_free_map_and_rqs(set, tags, hctx_idx);
+}
+
 static void blk_mq_map_swqueue(struct request_queue *q)
 {
 	unsigned int i, j, hctx_idx;
@@ -2976,7 +2993,7 @@ static void blk_mq_map_swqueue(struct request_queue *q)
 			 * allocation
 			 */
 			if (i && set->tags[i]) {
-				blk_mq_free_map_and_rqs(set, set->tags[i], i);
+				__blk_mq_free_map_and_rqs(set, set->tags[i], i);
 				set->tags[i] = NULL;
 			}
 
@@ -3272,7 +3289,7 @@ static void blk_mq_realloc_hw_ctxs(struct blk_mq_tag_set *set,
 		struct blk_mq_hw_ctx *hctx = hctxs[j];
 
 		if (hctx) {
-			blk_mq_free_map_and_rqs(set, set->tags[j], j);
+			__blk_mq_free_map_and_rqs(set, set->tags[j], j);
 			set->tags[j] = NULL;
 			blk_mq_exit_hctx(q, set, hctx, j);
 			hctxs[j] = NULL;
@@ -3362,6 +3379,14 @@ static int __blk_mq_alloc_rq_maps(struct blk_mq_tag_set *set)
 {
 	int i;
 
+	if (blk_mq_is_sbitmap_shared(set->flags)) {
+		set->shared_sbitmap_tags = blk_mq_alloc_map_and_rqs(set,
+						BLK_MQ_NO_HCTX_IDX,
+						set->queue_depth);
+		if (!set->shared_sbitmap_tags)
+			return -ENOMEM;
+	}
+
 	for (i = 0; i < set->nr_hw_queues; i++) {
 		if (!__blk_mq_alloc_map_and_rqs(set, i))
 			goto out_unwind;
@@ -3372,10 +3397,15 @@ static int __blk_mq_alloc_rq_maps(struct blk_mq_tag_set *set)
 
 out_unwind:
 	while (--i >= 0) {
-		blk_mq_free_map_and_rqs(set, set->tags[i], i);
+		__blk_mq_free_map_and_rqs(set, set->tags[i], i);
 		set->tags[i] = NULL;
 	}
 
+	if (blk_mq_is_sbitmap_shared(set->flags)) {
+		blk_mq_free_map_and_rqs(set, set->shared_sbitmap_tags,
+					BLK_MQ_NO_HCTX_IDX);
+	}
+
 	return -ENOMEM;
 }
 
@@ -3554,25 +3584,11 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
 	if (ret)
 		goto out_free_mq_map;
 
-	if (blk_mq_is_sbitmap_shared(set->flags)) {
-		atomic_set(&set->active_queues_shared_sbitmap, 0);
-
-		if (blk_mq_init_shared_sbitmap(set)) {
-			ret = -ENOMEM;
-			goto out_free_mq_rq_maps;
-		}
-	}
-
 	mutex_init(&set->tag_list_lock);
 	INIT_LIST_HEAD(&set->tag_list);
 
 	return 0;
 
-out_free_mq_rq_maps:
-	for (i = 0; i < set->nr_hw_queues; i++) {
-		blk_mq_free_map_and_rqs(set, set->tags[i], i);
-		set->tags[i] = NULL;
-	}
 out_free_mq_map:
 	for (i = 0; i < set->nr_maps; i++) {
 		kfree(set->map[i].mq_map);
@@ -3605,12 +3621,14 @@ void blk_mq_free_tag_set(struct blk_mq_tag_set *set)
 	int i, j;
 
 	for (i = 0; i < set->nr_hw_queues; i++) {
-		blk_mq_free_map_and_rqs(set, set->tags[i], i);
+		__blk_mq_free_map_and_rqs(set, set->tags[i], i);
 		set->tags[i] = NULL;
 	}
 
-	if (blk_mq_is_sbitmap_shared(set->flags))
-		blk_mq_exit_shared_sbitmap(set);
+	if (blk_mq_is_sbitmap_shared(set->flags)) {
+		blk_mq_free_map_and_rqs(set, set->shared_sbitmap_tags,
+					BLK_MQ_NO_HCTX_IDX);
+	}
 
 	for (j = 0; j < set->nr_maps; j++) {
 		kfree(set->map[j].mq_map);
@@ -3648,12 +3666,6 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
 		if (hctx->sched_tags) {
 			ret = blk_mq_tag_update_depth(hctx, &hctx->sched_tags,
 						      nr, true);
-			if (blk_mq_is_sbitmap_shared(set->flags)) {
-				hctx->sched_tags->bitmap_tags =
-					&q->sched_bitmap_tags;
-				hctx->sched_tags->breserved_tags =
-					&q->sched_breserved_tags;
-			}
 		} else {
 			ret = blk_mq_tag_update_depth(hctx, &hctx->tags, nr,
 						      false);
diff --git a/block/blk-mq.h b/block/blk-mq.h
index bcb0ca89d37a..b34385211e0a 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -54,7 +54,7 @@ void blk_mq_put_rq_ref(struct request *rq);
  */
 void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
 		     unsigned int hctx_idx);
-void blk_mq_free_rq_map(struct blk_mq_tags *tags, unsigned int flags);
+void blk_mq_free_rq_map(struct blk_mq_tags *tags);
 struct blk_mq_tags *blk_mq_alloc_map_and_rqs(struct blk_mq_tag_set *set,
 				unsigned int hctx_idx, unsigned int depth);
 void blk_mq_free_map_and_rqs(struct blk_mq_tag_set *set,
@@ -331,10 +331,11 @@ static inline bool hctx_may_queue(struct blk_mq_hw_ctx *hctx,
 	if (blk_mq_is_sbitmap_shared(hctx->flags)) {
 		struct request_queue *q = hctx->queue;
 		struct blk_mq_tag_set *set = q->tag_set;
+		struct blk_mq_tags *tags = set->shared_sbitmap_tags;
 
 		if (!test_bit(QUEUE_FLAG_HCTX_ACTIVE, &q->queue_flags))
 			return true;
-		users = atomic_read(&set->active_queues_shared_sbitmap);
+		users = atomic_read(&tags->active_queues);
 	} else {
 		if (!test_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
 			return true;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 13ba1861e688..808854a8ebc4 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -232,13 +232,11 @@ enum hctx_type {
  * @flags:	   Zero or more BLK_MQ_F_* flags.
  * @driver_data:   Pointer to data owned by the block driver that created this
  *		   tag set.
- * @active_queues_shared_sbitmap:
- * 		   number of active request queues per tag set.
- * @__bitmap_tags: A shared tags sbitmap, used over all hctx's
- * @__breserved_tags:
- *		   A shared reserved tags sbitmap, used over all hctx's
  * @tags:	   Tag sets. One tag set per hardware queue. Has @nr_hw_queues
  *		   elements.
+ * @shared_sbitmap_tags:
+ *		   Shared sbitmap set of tags. Has @nr_hw_queues elements. If
+ *		   set, shared by all @tags.
  * @tag_list_lock: Serializes tag_list accesses.
  * @tag_list:	   List of the request queues that use this tag set. See also
  *		   request_queue.tag_set_list.
@@ -255,12 +253,11 @@ struct blk_mq_tag_set {
 	unsigned int		timeout;
 	unsigned int		flags;
 	void			*driver_data;
-	atomic_t		active_queues_shared_sbitmap;
 
-	struct sbitmap_queue	__bitmap_tags;
-	struct sbitmap_queue	__breserved_tags;
 	struct blk_mq_tags	**tags;
 
+	struct blk_mq_tags	*shared_sbitmap_tags;
+
 	struct mutex		tag_list_lock;
 	struct list_head	tag_list;
 };
@@ -432,6 +429,8 @@ enum {
 	((policy & ((1 << BLK_MQ_F_ALLOC_POLICY_BITS) - 1)) \
 		<< BLK_MQ_F_ALLOC_POLICY_START_BIT)
 
+#define BLK_MQ_NO_HCTX_IDX	(-1U)
+
 struct gendisk *__blk_mq_alloc_disk(struct blk_mq_tag_set *set, void *queuedata,
 		struct lock_class_key *lkclass);
 #define blk_mq_alloc_disk(set, queuedata)				\
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index fc3987eda2c1..76f75274081e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -466,8 +466,7 @@ struct request_queue {
 
 	atomic_t		nr_active_requests_shared_sbitmap;
 
-	struct sbitmap_queue	sched_bitmap_tags;
-	struct sbitmap_queue	sched_breserved_tags;
+	struct blk_mq_tags	*shared_sbitmap_tags;
 
 	struct list_head	icq_list;
 #ifdef CONFIG_BLK_CGROUP
-- 
2.26.2

