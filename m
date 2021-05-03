Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F573C433ED
	for <linux-scsi@archiver.kernel.org>; Mon,  3 May 2021 10:27:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DF5861183
	for <linux-scsi@archiver.kernel.org>; Mon,  3 May 2021 10:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233342AbhECK14 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 May 2021 06:27:56 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:18310 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233108AbhECK14 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 May 2021 06:27:56 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FYfGf5cqGzB3D7;
        Mon,  3 May 2021 18:24:26 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Mon, 3 May 2021 18:26:51 +0800
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <ming.lei@redhat.com>,
        <kashyap.desai@broadcom.com>, <chenxiang66@hisilicon.com>,
        <yama@redhat.com>, John Garry <john.garry@huawei.com>
Subject: [PATCH] blk-mq: Use request queue-wide tags for tagset-wide sbitmap
Date:   Mon, 3 May 2021 18:22:13 +0800
Message-ID: <1620037333-2495-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The tags used for an IO scheduler are currently per hctx.

As such, when q->nr_hw_queues grows, so does the request queue total IO
scheduler tag depth.

This may cause problems for SCSI MQ HBAs whose total driver depth is
fixed.

Ming and Yanhui report higher CPU usage and lower throughput in scenarios
where the fixed total driver tag depth is appreciably lower than the total
scheduler tag depth:
https://lore.kernel.org/linux-block/440dfcfc-1a2c-bd98-1161-cec4d78c6dfc@huawei.com/T/#mc0d6d4f95275a2743d1c8c3e4dc9ff6c9aa3a76b

In that scenario, since the scheduler tag is got first, much contention
is introduced since a driver tag may not be available after we have got
the sched tag.

Improve this scenario by introducing request queue-wide tags for when
a tagset-wide sbitmap is used. The static sched requests are still
allocated per hctx, as requests are initialised per hctx, as in
blk_mq_init_request(..., hctx_idx, ...) ->
set->ops->init_request(.., hctx_idx, ...).

For simplicity of resizing the request queue sbitmap when updating the
request queue depth, just init at the max possible size, so we don't need
to deal with the possibly with swapping out a new sbitmap for old if
we need to grow.

Signed-off-by: John Garry <john.garry@huawei.com>

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index e1e997af89a0..121207abc026 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -497,11 +497,9 @@ static void blk_mq_sched_free_tags(struct blk_mq_tag_set *set,
 				   struct blk_mq_hw_ctx *hctx,
 				   unsigned int hctx_idx)
 {
-	unsigned int flags = set->flags & ~BLK_MQ_F_TAG_HCTX_SHARED;
-
 	if (hctx->sched_tags) {
 		blk_mq_free_rqs(set, hctx->sched_tags, hctx_idx);
-		blk_mq_free_rq_map(hctx->sched_tags, flags);
+		blk_mq_free_rq_map(hctx->sched_tags, set->flags);
 		hctx->sched_tags = NULL;
 	}
 }
@@ -511,12 +509,10 @@ static int blk_mq_sched_alloc_tags(struct request_queue *q,
 				   unsigned int hctx_idx)
 {
 	struct blk_mq_tag_set *set = q->tag_set;
-	/* Clear HCTX_SHARED so tags are init'ed */
-	unsigned int flags = set->flags & ~BLK_MQ_F_TAG_HCTX_SHARED;
 	int ret;
 
 	hctx->sched_tags = blk_mq_alloc_rq_map(set, hctx_idx, q->nr_requests,
-					       set->reserved_tags, flags);
+					       set->reserved_tags, set->flags);
 	if (!hctx->sched_tags)
 		return -ENOMEM;
 
@@ -534,11 +530,8 @@ static void blk_mq_sched_tags_teardown(struct request_queue *q)
 	int i;
 
 	queue_for_each_hw_ctx(q, hctx, i) {
-		/* Clear HCTX_SHARED so tags are freed */
-		unsigned int flags = hctx->flags & ~BLK_MQ_F_TAG_HCTX_SHARED;
-
 		if (hctx->sched_tags) {
-			blk_mq_free_rq_map(hctx->sched_tags, flags);
+			blk_mq_free_rq_map(hctx->sched_tags, hctx->flags);
 			hctx->sched_tags = NULL;
 		}
 	}
@@ -568,12 +561,25 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
 	queue_for_each_hw_ctx(q, hctx, i) {
 		ret = blk_mq_sched_alloc_tags(q, hctx, i);
 		if (ret)
-			goto err;
+			goto err_free_tags;
+	}
+
+	if (blk_mq_is_sbitmap_shared(q->tag_set->flags)) {
+		ret = blk_mq_init_sched_shared_sbitmap(q);
+		if (ret)
+			goto err_free_tags;
+
+		queue_for_each_hw_ctx(q, hctx, i) {
+			hctx->sched_tags->bitmap_tags =
+					q->sched_bitmap_tags;
+			hctx->sched_tags->breserved_tags =
+					q->sched_breserved_tags;
+		}
 	}
 
 	ret = e->ops.init_sched(q, e);
 	if (ret)
-		goto err;
+		goto err_free_sbitmap;
 
 	blk_mq_debugfs_register_sched(q);
 
@@ -584,6 +590,7 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
 				eq = q->elevator;
 				blk_mq_sched_free_requests(q);
 				blk_mq_exit_sched(q, eq);
+				blk_mq_exit_sched_shared_sbitmap(q);
 				kobject_put(&eq->kobj);
 				return ret;
 			}
@@ -593,7 +600,10 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
 
 	return 0;
 
-err:
+err_free_sbitmap:
+	if (blk_mq_is_sbitmap_shared(q->tag_set->flags))
+		blk_mq_exit_sched_shared_sbitmap(q);
+err_free_tags:
 	blk_mq_sched_free_requests(q);
 	blk_mq_sched_tags_teardown(q);
 	q->elevator = NULL;
@@ -631,5 +641,7 @@ void blk_mq_exit_sched(struct request_queue *q, struct elevator_queue *e)
 	if (e->type->ops.exit_sched)
 		e->type->ops.exit_sched(e);
 	blk_mq_sched_tags_teardown(q);
+	if (blk_mq_is_sbitmap_shared(q->tag_set->flags))
+		blk_mq_exit_sched_shared_sbitmap(q);
 	q->elevator = NULL;
 }
diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 2a37731e8244..734fedceca7d 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -466,19 +466,40 @@ static int blk_mq_init_bitmap_tags(struct blk_mq_tags *tags,
 	return -ENOMEM;
 }
 
-int blk_mq_init_shared_sbitmap(struct blk_mq_tag_set *set, unsigned int flags)
+static int __blk_mq_init_bitmaps(struct sbitmap_queue *bitmap_tags,
+				 struct sbitmap_queue *breserved_tags,
+				 struct blk_mq_tag_set *set,
+				 unsigned int queue_depth,
+				 unsigned int reserved)
 {
-	unsigned int depth = set->queue_depth - set->reserved_tags;
+	unsigned int depth = queue_depth - reserved;
 	int alloc_policy = BLK_MQ_FLAG_TO_ALLOC_POLICY(set->flags);
 	bool round_robin = alloc_policy == BLK_TAG_ALLOC_RR;
-	int i, node = set->numa_node;
 
-	if (bt_alloc(&set->__bitmap_tags, depth, round_robin, node))
+	if (bt_alloc(bitmap_tags, depth, round_robin, set->numa_node))
 		return -ENOMEM;
-	if (bt_alloc(&set->__breserved_tags, set->reserved_tags,
-		     round_robin, node))
+	if (bt_alloc(breserved_tags, set->reserved_tags,
+		     round_robin, set->numa_node))
 		goto free_bitmap_tags;
 
+	return 0;
+
+free_bitmap_tags:
+	sbitmap_queue_free(bitmap_tags);
+	return -ENOMEM;
+}
+
+int blk_mq_init_shared_sbitmap(struct blk_mq_tag_set *set)
+{
+	int i, ret;
+
+	ret = __blk_mq_init_bitmaps(&set->__bitmap_tags,
+				    &set->__breserved_tags,
+				    set, set->queue_depth,
+				    set->reserved_tags);
+	if (ret)
+		return ret;
+
 	for (i = 0; i < set->nr_hw_queues; i++) {
 		struct blk_mq_tags *tags = set->tags[i];
 
@@ -487,9 +508,6 @@ int blk_mq_init_shared_sbitmap(struct blk_mq_tag_set *set, unsigned int flags)
 	}
 
 	return 0;
-free_bitmap_tags:
-	sbitmap_queue_free(&set->__bitmap_tags);
-	return -ENOMEM;
 }
 
 void blk_mq_exit_shared_sbitmap(struct blk_mq_tag_set *set)
@@ -498,6 +516,52 @@ void blk_mq_exit_shared_sbitmap(struct blk_mq_tag_set *set)
 	sbitmap_queue_free(&set->__breserved_tags);
 }
 
+#define MAX_SCHED_RQ (16 * BLKDEV_MAX_RQ)
+
+int blk_mq_init_sched_shared_sbitmap(struct request_queue *queue)
+{
+	struct blk_mq_tag_set *set = queue->tag_set;
+	int ret;
+
+	queue->sched_bitmap_tags =
+		kmalloc(sizeof(*queue->sched_bitmap_tags), GFP_KERNEL);
+	queue->sched_breserved_tags =
+		kmalloc(sizeof(*queue->sched_breserved_tags), GFP_KERNEL);
+	if (!queue->sched_bitmap_tags || !queue->sched_breserved_tags)
+		goto err;
+
+	/*
+	 * Set initial depth at max so that we don't need to reallocate for
+	 * updating nr_requests.
+	 */
+	ret = __blk_mq_init_bitmaps(queue->sched_bitmap_tags,
+				    queue->sched_breserved_tags,
+				    set, MAX_SCHED_RQ, set->reserved_tags);
+	if (ret)
+		goto err;
+
+	sbitmap_queue_resize(queue->sched_bitmap_tags,
+			     queue->nr_requests - set->reserved_tags);
+
+	return 0;
+
+err:
+	kfree(queue->sched_bitmap_tags);
+	kfree(queue->sched_breserved_tags);
+	return -ENOMEM;
+}
+
+void blk_mq_exit_sched_shared_sbitmap(struct request_queue *queue)
+{
+	sbitmap_queue_free(queue->sched_bitmap_tags);
+	kfree(queue->sched_bitmap_tags);
+	queue->sched_bitmap_tags = NULL;
+
+	sbitmap_queue_free(queue->sched_breserved_tags);
+	kfree(queue->sched_breserved_tags);
+	queue->sched_breserved_tags = NULL;
+}
+
 struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
 				     unsigned int reserved_tags,
 				     int node, unsigned int flags)
@@ -551,8 +615,6 @@ int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
 	 */
 	if (tdepth > tags->nr_tags) {
 		struct blk_mq_tag_set *set = hctx->queue->tag_set;
-		/* Only sched tags can grow, so clear HCTX_SHARED flag  */
-		unsigned int flags = set->flags & ~BLK_MQ_F_TAG_HCTX_SHARED;
 		struct blk_mq_tags *new;
 		bool ret;
 
@@ -563,21 +625,21 @@ int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
 		 * We need some sort of upper limit, set it high enough that
 		 * no valid use cases should require more.
 		 */
-		if (tdepth > 16 * BLKDEV_MAX_RQ)
+		if (tdepth > MAX_SCHED_RQ)
 			return -EINVAL;
 
 		new = blk_mq_alloc_rq_map(set, hctx->queue_num, tdepth,
-				tags->nr_reserved_tags, flags);
+				tags->nr_reserved_tags, set->flags);
 		if (!new)
 			return -ENOMEM;
 		ret = blk_mq_alloc_rqs(set, new, hctx->queue_num, tdepth);
 		if (ret) {
-			blk_mq_free_rq_map(new, flags);
+			blk_mq_free_rq_map(new, set->flags);
 			return -ENOMEM;
 		}
 
 		blk_mq_free_rqs(set, *tagsptr, hctx->queue_num);
-		blk_mq_free_rq_map(*tagsptr, flags);
+		blk_mq_free_rq_map(*tagsptr, set->flags);
 		*tagsptr = new;
 	} else {
 		/*
diff --git a/block/blk-mq-tag.h b/block/blk-mq-tag.h
index 7d3e6b333a4a..553fa71efd42 100644
--- a/block/blk-mq-tag.h
+++ b/block/blk-mq-tag.h
@@ -27,10 +27,10 @@ extern struct blk_mq_tags *blk_mq_init_tags(unsigned int nr_tags,
 					int node, unsigned int flags);
 extern void blk_mq_free_tags(struct blk_mq_tags *tags, unsigned int flags);
 
-extern int blk_mq_init_shared_sbitmap(struct blk_mq_tag_set *set,
-				      unsigned int flags);
+extern int blk_mq_init_shared_sbitmap(struct blk_mq_tag_set *set);
 extern void blk_mq_exit_shared_sbitmap(struct blk_mq_tag_set *set);
-
+extern int blk_mq_init_sched_shared_sbitmap(struct request_queue *queue);
+extern void blk_mq_exit_sched_shared_sbitmap(struct request_queue *queue);
 extern unsigned int blk_mq_get_tag(struct blk_mq_alloc_data *data);
 extern void blk_mq_put_tag(struct blk_mq_tags *tags, struct blk_mq_ctx *ctx,
 			   unsigned int tag);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 927189a55575..f6e22b32a07f 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3473,7 +3473,7 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
 	if (blk_mq_is_sbitmap_shared(set->flags)) {
 		atomic_set(&set->active_queues_shared_sbitmap, 0);
 
-		if (blk_mq_init_shared_sbitmap(set, set->flags)) {
+		if (blk_mq_init_shared_sbitmap(set)) {
 			ret = -ENOMEM;
 			goto out_free_mq_rq_maps;
 		}
@@ -3549,15 +3549,24 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
 		} else {
 			ret = blk_mq_tag_update_depth(hctx, &hctx->sched_tags,
 							nr, true);
+			if (blk_mq_is_sbitmap_shared(set->flags)) {
+				hctx->sched_tags->bitmap_tags =
+					q->sched_bitmap_tags;
+				hctx->sched_tags->breserved_tags =
+					q->sched_breserved_tags;
+			}
 		}
 		if (ret)
 			break;
 		if (q->elevator && q->elevator->type->ops.depth_updated)
 			q->elevator->type->ops.depth_updated(hctx);
 	}
-
-	if (!ret)
+	if (!ret) {
 		q->nr_requests = nr;
+		if (q->elevator && blk_mq_is_sbitmap_shared(set->flags))
+			sbitmap_queue_resize(q->sched_bitmap_tags,
+					     nr - set->reserved_tags);
+	}
 
 	blk_mq_unquiesce_queue(q);
 	blk_mq_unfreeze_queue(q);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f2e77ba97550..8055ebd9f285 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -26,6 +26,7 @@
 #include <linux/scatterlist.h>
 #include <linux/blkzoned.h>
 #include <linux/pm.h>
+#include <linux/sbitmap.h>
 
 struct module;
 struct scsi_ioctl_command;
@@ -496,6 +497,9 @@ struct request_queue {
 
 	atomic_t		nr_active_requests_shared_sbitmap;
 
+	struct sbitmap_queue *sched_bitmap_tags;
+	struct sbitmap_queue *sched_breserved_tags;
+
 	struct list_head	icq_list;
 #ifdef CONFIG_BLK_CGROUP
 	DECLARE_BITMAP		(blkcg_pols, BLKCG_MAX_POLS);
-- 
2.26.2

