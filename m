Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 397AAC07E9A
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 15:11:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2228B613B6
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 15:11:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239705AbhGNPO2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 11:14:28 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3411 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239668AbhGNPOX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 11:14:23 -0400
Received: from fraeml741-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GQ12q6Qy4z6K640;
        Wed, 14 Jul 2021 23:02:59 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml741-chm.china.huawei.com (10.206.15.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 14 Jul 2021 17:11:30 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 14 Jul 2021 16:11:28 +0100
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ming.lei@redhat.com>, <linux-scsi@vger.kernel.org>,
        <kashyap.desai@broadcom.com>, <hare@suse.de>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 8/9] blk-mq: Allocate per request queue static rqs for shared sbitmap
Date:   Wed, 14 Jul 2021 23:06:34 +0800
Message-ID: <1626275195-215652-9-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1626275195-215652-1-git-send-email-john.garry@huawei.com>
References: <1626275195-215652-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Similar to allocating a full set of static rqs per hw queue per tag set for
when using a shared sbitmap, it is also inefficient in memory terms to
allocate a full set of static rqs per hw queue per request queue.

Reduce memory usage by allocating a set of static rqs per request queue
for when using a shared sbitmap, and make the per-hctx
sched_tags->static_rqs[] point at them.

Error handling for updating the number of requests in
blk_mq_update_nr_requests() -> blk_mq_tag_update_depth() can get quite
complicated, so allocate the full max depth of rqs at init time to try to
simplify things. This will be somewhat inefficient for when the request
queue depth is not close to max, but generally still more efficient than
the current situation.

For failures in blk_mq_update_nr_requests() -> blk_mq_tag_update_depth()
when shrinking request queue depth, q->nr_requests still needs to be
updated. This is because some of the hctx->sched_tags may be successfully
updated, and now they are now smaller than q->nr_requests, which will lead
to problems since a scheduler tag could be greater than hctx->sched_tags
size.

For failures in blk_mq_update_nr_requests() -> blk_mq_tag_update_depth()
when growing a request queue depth, q->nr_requests does not need to be
updated.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 block/blk-mq-sched.c   | 51 ++++++++++++++++++++++++++++++++++++++----
 block/blk-mq-tag.c     | 12 +++++-----
 block/blk-mq.c         | 20 ++++++++++++++++-
 include/linux/blkdev.h |  4 ++++
 4 files changed, 76 insertions(+), 11 deletions(-)

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index 1e028183557d..7b5c46647820 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -538,6 +538,9 @@ static int blk_mq_sched_alloc_tags(struct request_queue *q,
 	if (!hctx->sched_tags)
 		return -ENOMEM;
 
+	if (blk_mq_is_sbitmap_shared(q->tag_set->flags))
+		return 0;
+
 	ret = blk_mq_alloc_rqs(set, hctx->sched_tags, hctx_idx, q->nr_requests);
 	if (ret)
 		blk_mq_sched_free_tags(set, hctx, hctx_idx);
@@ -563,8 +566,30 @@ static int blk_mq_init_sched_shared_sbitmap(struct request_queue *queue)
 {
 	struct blk_mq_tag_set *set = queue->tag_set;
 	int alloc_policy = BLK_MQ_FLAG_TO_ALLOC_POLICY(set->flags);
+	gfp_t flags = GFP_NOIO | __GFP_NOWARN | __GFP_NORETRY;
 	struct blk_mq_hw_ctx *hctx;
-	int ret, i;
+	int ret, i, j;
+
+	/*
+	 * In case we need to grow, allocate max we will ever need. This will
+	 * waste memory when the request queue depth is less than the max,
+	 * i.e. almost always. But helps keep our sanity, rather than dealing
+	 * with error handling in blk_mq_update_nr_requests().
+	 */
+	queue->static_rqs = kcalloc_node(MAX_SCHED_RQ, sizeof(struct request *),
+					 flags, queue->node);
+	if (!queue->static_rqs)
+		return -ENOMEM;
+
+	ret = __blk_mq_alloc_rqs(set, 0, MAX_SCHED_RQ, &queue->page_list,
+				 queue->static_rqs);
+	if (ret)
+		goto err_rqs;
+
+	queue_for_each_hw_ctx(queue, hctx, i) {
+		for (j = 0; j < queue->nr_requests; j++)
+			hctx->sched_tags->static_rqs[j] = queue->static_rqs[j];
+	}
 
 	/*
 	 * Set initial depth at max so that we don't need to reallocate for
@@ -575,7 +600,7 @@ static int blk_mq_init_sched_shared_sbitmap(struct request_queue *queue)
 				  MAX_SCHED_RQ, set->reserved_tags,
 				  set->numa_node, alloc_policy);
 	if (ret)
-		return ret;
+		goto err_bitmaps;
 
 	queue_for_each_hw_ctx(queue, hctx, i) {
 		hctx->sched_tags->bitmap_tags =
@@ -587,10 +612,24 @@ static int blk_mq_init_sched_shared_sbitmap(struct request_queue *queue)
 	blk_mq_tag_resize_sched_shared_sbitmap(queue);
 
 	return 0;
+
+err_bitmaps:
+	__blk_mq_free_rqs(set, 0, MAX_SCHED_RQ, &queue->page_list,
+			  queue->static_rqs);
+err_rqs:
+	kfree(queue->static_rqs);
+	queue->static_rqs = NULL;
+	return ret;
 }
 
 static void blk_mq_exit_sched_shared_sbitmap(struct request_queue *queue)
 {
+	__blk_mq_free_rqs(queue->tag_set, 0, MAX_SCHED_RQ, &queue->page_list,
+			  queue->static_rqs);
+
+	kfree(queue->static_rqs);
+	queue->static_rqs = NULL;
+
 	sbitmap_queue_free(&queue->sched_bitmap_tags);
 	sbitmap_queue_free(&queue->sched_breserved_tags);
 }
@@ -670,8 +709,12 @@ void blk_mq_sched_free_requests(struct request_queue *q)
 	int i;
 
 	queue_for_each_hw_ctx(q, hctx, i) {
-		if (hctx->sched_tags)
-			blk_mq_free_rqs(q->tag_set, hctx->sched_tags, i);
+		if (hctx->sched_tags) {
+			if (blk_mq_is_sbitmap_shared(q->tag_set->flags)) {
+			} else {
+				blk_mq_free_rqs(q->tag_set, hctx->sched_tags, i);
+			}
+		}
 	}
 }
 
diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 55c7f1bf41c7..e5a21907306a 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -592,7 +592,6 @@ int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
 	if (tdepth > tags->nr_tags) {
 		struct blk_mq_tag_set *set = hctx->queue->tag_set;
 		struct blk_mq_tags *new;
-		bool ret;
 
 		if (!can_grow)
 			return -EINVAL;
@@ -608,13 +607,14 @@ int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
 				tags->nr_reserved_tags, set->flags);
 		if (!new)
 			return -ENOMEM;
-		ret = blk_mq_alloc_rqs(set, new, hctx->queue_num, tdepth);
-		if (ret) {
-			blk_mq_free_rq_map(new, set->flags);
-			return -ENOMEM;
+		if (!blk_mq_is_sbitmap_shared(hctx->flags)) {
+			if (blk_mq_alloc_rqs(set, new, hctx->queue_num, tdepth)) {
+				blk_mq_free_rq_map(new, set->flags);
+				return -ENOMEM;
+			}
+			blk_mq_free_rqs(set, *tagsptr, hctx->queue_num);
 		}
 
-		blk_mq_free_rqs(set, *tagsptr, hctx->queue_num);
 		blk_mq_free_rq_map(*tagsptr, set->flags);
 		*tagsptr = new;
 	} else {
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 764c601376c6..443fd64239ed 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3694,10 +3694,17 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
 			ret = blk_mq_tag_update_depth(hctx, &hctx->sched_tags,
 						      nr, true);
 			if (blk_mq_is_sbitmap_shared(set->flags)) {
+				int j;
+
 				hctx->sched_tags->bitmap_tags =
 					&q->sched_bitmap_tags;
 				hctx->sched_tags->breserved_tags =
 					&q->sched_breserved_tags;
+
+				for (j = 0;j < hctx->sched_tags->nr_tags; j++) {
+					hctx->sched_tags->static_rqs[j] =
+							q->static_rqs[j];
+				}
 			}
 		} else {
 			ret = blk_mq_tag_update_depth(hctx, &hctx->tags, nr,
@@ -3708,7 +3715,18 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
 		if (q->elevator && q->elevator->type->ops.depth_updated)
 			q->elevator->type->ops.depth_updated(hctx);
 	}
-	if (!ret) {
+	if (ret) {
+		if (blk_mq_is_sbitmap_shared(set->flags) && (q->elevator)) {
+			/*
+			 * If we error'ed, then we need to revert to the
+			 * lowest size, otherwise we may attempt to reference
+			 * unset hctx->sched_tags->static_rqs[]
+			 */
+			q->nr_requests = min((unsigned long)nr,
+					     q->nr_requests);
+			blk_mq_tag_resize_sched_shared_sbitmap(q);
+		}
+	} else {
 		q->nr_requests = nr;
 		if (blk_mq_is_sbitmap_shared(set->flags)) {
 			if (q->elevator) {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6a64ea23f552..97e80a07adb2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -470,6 +470,10 @@ struct request_queue {
 	struct sbitmap_queue	sched_bitmap_tags;
 	struct sbitmap_queue	sched_breserved_tags;
 
+	/* For shared sbitmap */
+	struct request **static_rqs;
+	struct list_head page_list;
+
 	struct list_head	icq_list;
 #ifdef CONFIG_BLK_CGROUP
 	DECLARE_BITMAP		(blkcg_pols, BLKCG_MAX_POLS);
-- 
2.26.2

