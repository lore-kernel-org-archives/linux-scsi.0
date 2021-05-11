Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF536C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 16:20:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82AE26054E
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 16:20:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbhEKQV1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 May 2021 12:21:27 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2705 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbhEKQV0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 May 2021 12:21:26 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FfjkQ5f7hz1BLM9;
        Wed, 12 May 2021 00:17:34 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Wed, 12 May 2021 00:20:06 +0800
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <ming.lei@redhat.com>,
        <kashyap.desai@broadcom.com>, <chenxiang66@hisilicon.com>,
        <yama@redhat.com>, <dgilbert@interlog.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v2] blk-mq: Use request queue-wide tags for tagset-wide sbitmap
Date:   Wed, 12 May 2021 00:15:43 +0800
Message-ID: <1620749743-36000-1-git-send-email-john.garry@huawei.com>
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
---

Please retest, thanks! For some reason I could not recreate the original
issue, but I am using qemu...

Changes since v1:
- Embed sbitmaps in request_queue struct
- Relocate IO sched functions to blk-mq-sched.c
- Fix error path code

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index 42a365b1b9c0..9a012e0818cb 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -507,11 +507,9 @@ static void blk_mq_sched_free_tags(struct blk_mq_tag_set *set,
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
@@ -521,12 +519,10 @@ static int blk_mq_sched_alloc_tags(struct request_queue *q,
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
 
@@ -544,16 +540,40 @@ static void blk_mq_sched_tags_teardown(struct request_queue *q)
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
 }
 
+static int blk_mq_init_sched_shared_sbitmap(struct request_queue *queue)
+{
+	struct blk_mq_tag_set *set = queue->tag_set;
+	int ret;
+
+	/*
+	 * Set initial depth at max so that we don't need to reallocate for
+	 * updating nr_requests.
+	 */
+	ret = blk_mq_init_bitmaps(&queue->sched_bitmap_tags,
+				  &queue->sched_breserved_tags,
+				  set, MAX_SCHED_RQ, set->reserved_tags);
+	if (ret)
+		return ret;
+
+	sbitmap_queue_resize(&queue->sched_bitmap_tags,
+			     queue->nr_requests - set->reserved_tags);
+
+	return 0;
+}
+
+static void blk_mq_exit_sched_shared_sbitmap(struct request_queue *queue)
+{
+	sbitmap_queue_free(&queue->sched_bitmap_tags);
+	sbitmap_queue_free(&queue->sched_breserved_tags);
+}
+
 int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
 {
 	struct blk_mq_hw_ctx *hctx;
@@ -578,12 +598,25 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
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
+						&q->sched_bitmap_tags;
+			hctx->sched_tags->breserved_tags =
+						&q->sched_breserved_tags;
+		}
 	}
 
 	ret = e->ops.init_sched(q, e);
 	if (ret)
-		goto err;
+		goto err_free_sbitmap;
 
 	blk_mq_debugfs_register_sched(q);
 
@@ -603,7 +636,10 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
 
 	return 0;
 
-err:
+err_free_sbitmap:
+	if (blk_mq_is_sbitmap_shared(q->tag_set->flags))
+		blk_mq_exit_sched_shared_sbitmap(q);
+err_free_tags:
 	blk_mq_sched_free_requests(q);
 	blk_mq_sched_tags_teardown(q);
 	q->elevator = NULL;
@@ -641,5 +677,7 @@ void blk_mq_exit_sched(struct request_queue *q, struct elevator_queue *e)
 	if (e->type->ops.exit_sched)
 		e->type->ops.exit_sched(e);
 	blk_mq_sched_tags_teardown(q);
+	if (blk_mq_is_sbitmap_shared(q->tag_set->flags))
+		blk_mq_exit_sched_shared_sbitmap(q);
 	q->elevator = NULL;
 }
diff --git a/block/blk-mq-sched.h b/block/blk-mq-sched.h
index 5b18ab915c65..aff037cfd8e7 100644
--- a/block/blk-mq-sched.h
+++ b/block/blk-mq-sched.h
@@ -5,6 +5,8 @@
 #include "blk-mq.h"
 #include "blk-mq-tag.h"
 
+#define MAX_SCHED_RQ (16 * BLKDEV_MAX_RQ)
+
 void blk_mq_sched_assign_ioc(struct request *rq);
 
 bool blk_mq_sched_try_merge(struct request_queue *q, struct bio *bio,
diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 2a37731e8244..e3ab8631be22 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -13,6 +13,7 @@
 #include <linux/delay.h>
 #include "blk.h"
 #include "blk-mq.h"
+#include "blk-mq-sched.h"
 #include "blk-mq-tag.h"
 
 /*
@@ -466,19 +467,39 @@ static int blk_mq_init_bitmap_tags(struct blk_mq_tags *tags,
 	return -ENOMEM;
 }
 
-int blk_mq_init_shared_sbitmap(struct blk_mq_tag_set *set, unsigned int flags)
+int blk_mq_init_bitmaps(struct sbitmap_queue *bitmap_tags,
+			struct sbitmap_queue *breserved_tags,
+			struct blk_mq_tag_set *set,
+			unsigned int queue_depth, unsigned int reserved)
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
+	ret = blk_mq_init_bitmaps(&set->__bitmap_tags,
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
@@ -551,8 +569,6 @@ int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
 	 */
 	if (tdepth > tags->nr_tags) {
 		struct blk_mq_tag_set *set = hctx->queue->tag_set;
-		/* Only sched tags can grow, so clear HCTX_SHARED flag  */
-		unsigned int flags = set->flags & ~BLK_MQ_F_TAG_HCTX_SHARED;
 		struct blk_mq_tags *new;
 		bool ret;
 
@@ -563,21 +579,21 @@ int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
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
index 7d3e6b333a4a..6be5124f6657 100644
--- a/block/blk-mq-tag.h
+++ b/block/blk-mq-tag.h
@@ -26,11 +26,13 @@ extern struct blk_mq_tags *blk_mq_init_tags(unsigned int nr_tags,
 					unsigned int reserved_tags,
 					int node, unsigned int flags);
 extern void blk_mq_free_tags(struct blk_mq_tags *tags, unsigned int flags);
-
-extern int blk_mq_init_shared_sbitmap(struct blk_mq_tag_set *set,
-				      unsigned int flags);
+extern int blk_mq_init_bitmaps(struct sbitmap_queue *bitmap_tags,
+				 struct sbitmap_queue *breserved_tags,
+				 struct blk_mq_tag_set *set,
+				 unsigned int queue_depth,
+				 unsigned int reserved);
+extern int blk_mq_init_shared_sbitmap(struct blk_mq_tag_set *set);
 extern void blk_mq_exit_shared_sbitmap(struct blk_mq_tag_set *set);
-
 extern unsigned int blk_mq_get_tag(struct blk_mq_alloc_data *data);
 extern void blk_mq_put_tag(struct blk_mq_tags *tags, struct blk_mq_ctx *ctx,
 			   unsigned int tag);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 466676bc2f0b..8b5ecc801d3f 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3488,7 +3488,7 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
 	if (blk_mq_is_sbitmap_shared(set->flags)) {
 		atomic_set(&set->active_queues_shared_sbitmap, 0);
 
-		if (blk_mq_init_shared_sbitmap(set, set->flags)) {
+		if (blk_mq_init_shared_sbitmap(set)) {
 			ret = -ENOMEM;
 			goto out_free_mq_rq_maps;
 		}
@@ -3564,15 +3564,24 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
 		} else {
 			ret = blk_mq_tag_update_depth(hctx, &hctx->sched_tags,
 							nr, true);
+			if (blk_mq_is_sbitmap_shared(set->flags)) {
+				hctx->sched_tags->bitmap_tags =
+					&q->sched_bitmap_tags;
+				hctx->sched_tags->breserved_tags =
+					&q->sched_breserved_tags;
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
+			sbitmap_queue_resize(&q->sched_bitmap_tags,
+					     nr - set->reserved_tags);
+	}
 
 	blk_mq_unquiesce_queue(q);
 	blk_mq_unfreeze_queue(q);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1255823b2bc0..4092c2a38f10 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -25,6 +25,7 @@
 #include <linux/scatterlist.h>
 #include <linux/blkzoned.h>
 #include <linux/pm.h>
+#include <linux/sbitmap.h>
 
 struct module;
 struct scsi_ioctl_command;
@@ -493,6 +494,9 @@ struct request_queue {
 
 	atomic_t		nr_active_requests_shared_sbitmap;
 
+	struct sbitmap_queue	sched_bitmap_tags;
+	struct sbitmap_queue	sched_breserved_tags;
+
 	struct list_head	icq_list;
 #ifdef CONFIG_BLK_CGROUP
 	DECLARE_BITMAP		(blkcg_pols, BLKCG_MAX_POLS);
-- 
2.26.2

