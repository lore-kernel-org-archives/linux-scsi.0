Return-Path: <SRS0=lopX=ZY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA7F1C47410
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Dec 2019 15:39:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A84AE20881
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Dec 2019 15:39:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbfLBPjd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Dec 2019 10:39:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:44832 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727549AbfLBPjb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Dec 2019 10:39:31 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0D84DC1A8;
        Mon,  2 Dec 2019 15:39:26 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 06/11] blk-mq: move shared sbitmap into elevator queue
Date:   Mon,  2 Dec 2019 16:39:09 +0100
Message-Id: <20191202153914.84722-7-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191202153914.84722-1-hare@suse.de>
References: <20191202153914.84722-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When an elevator is present the sbitmap is actually per request queue,
so modifying the tagset queue depth in the shared sbitmap case will
be doing the wrong thing as it'll change the queue depth for all
request queues.
So this patch moves the shared scheduler sbitmap into struct
elevator queue, thereby insulating any modifications to this
request queue only.
And with that we can increase the number of requests for the
shared sbitmap case to the queue depth times the number of queues,
as now all tags are allocated from the same bitmap.
This also solves the problem of sbitmap resizing in the shared sbitmap
case; we can simply require an elevator to be present if the queue depth
needs to be modified, as then the queue depth will be modified for this
particular request queue only.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-mq-sched.c     | 14 +++++++++++---
 block/blk-mq-tag.c       | 30 ++++++++++++++++--------------
 block/blk-mq-tag.h       |  8 +++++---
 block/blk-mq.c           | 41 +++++++++++++++--------------------------
 block/blk-sysfs.c        |  7 +++++++
 include/linux/blk-mq.h   |  4 ----
 include/linux/elevator.h |  3 +++
 7 files changed, 57 insertions(+), 50 deletions(-)

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index 1855f8f5edd4..f2184199a1b7 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -511,6 +511,12 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
 	 */
 	q->nr_requests = 2 * min_t(unsigned int, q->tag_set->queue_depth,
 				   BLKDEV_MAX_RQ);
+	/*
+	 * For the shared sbitmap case it's per request queue, so multiply
+	 * with the number of hw queues
+	 */
+	if (blk_mq_is_sbitmap_shared(tag_set))
+		q->nr_requests *= q->nr_hw_queues;
 
 	queue_for_each_hw_ctx(q, hctx, i) {
 		ret = blk_mq_sched_alloc_tags(q, hctx, i);
@@ -539,15 +545,16 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
 	}
 
 	if (blk_mq_is_sbitmap_shared(tag_set)) {
-		if (!blk_mq_init_sched_shared_sbitmap(tag_set, q->nr_requests)) {
+		eq = q->elevator;
+		if (!blk_mq_init_elevator_sbitmap(q, eq, q->nr_requests)) {
 			ret = -ENOMEM;
 			goto err;
 		}
 		queue_for_each_hw_ctx(q, hctx, i) {
 			struct blk_mq_tags *tags = hctx->sched_tags;
 
-			tags->bitmap_tags = &tag_set->__sched_bitmap_tags;
-			tags->breserved_tags = &tag_set->__sched_breserved_tags;
+			tags->bitmap_tags = &eq->__bitmap_tags;
+			tags->breserved_tags = &eq->__breserved_tags;
 		}
 	}
 
@@ -591,5 +598,6 @@ void blk_mq_exit_sched(struct request_queue *q, struct elevator_queue *e)
 	if (e->type->ops.exit_sched)
 		e->type->ops.exit_sched(e);
 	blk_mq_sched_tags_teardown(q);
+	blk_mq_exit_elevator_sbitmap(q, e);
 	q->elevator = NULL;
 }
diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 2e714123e846..39c7beffdd04 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -491,35 +491,37 @@ void blk_mq_exit_shared_sbitmap(struct blk_mq_tag_set *tag_set)
 	}
 }
 
-bool blk_mq_init_sched_shared_sbitmap(struct blk_mq_tag_set *tag_set,
-				      unsigned long nr_requests)
+bool blk_mq_init_elevator_sbitmap(struct request_queue *q,
+				  struct elevator_queue *eq,
+				  unsigned int nr_requests)
 {
-	unsigned int depth = nr_requests -tag_set->reserved_tags;
+	struct blk_mq_tag_set *tag_set = q->tag_set;
+	unsigned int depth = nr_requests - tag_set->reserved_tags;
 	int alloc_policy = BLK_MQ_FLAG_TO_ALLOC_POLICY(tag_set->flags);
 	bool round_robin = alloc_policy == BLK_TAG_ALLOC_RR;
 	int node = tag_set->numa_node;
 
-	if (tag_set->flags & BLK_MQ_F_TAG_SCHED_BITMAP_ALLOCATED)
-		return false;
-	if (bt_alloc(&tag_set->__sched_bitmap_tags, depth, round_robin, node))
+	if (!blk_mq_is_sbitmap_shared(q->tag_set))
+		return true;
+
+	if (bt_alloc(&eq->__bitmap_tags, depth, round_robin, node))
 		return false;
-	if (bt_alloc(&tag_set->__sched_breserved_tags, tag_set->reserved_tags,
+	if (bt_alloc(&eq->__breserved_tags, tag_set->reserved_tags,
 		     round_robin, node))
 		goto free_bitmap_tags;
 
-	tag_set->flags |= BLK_MQ_F_TAG_SCHED_BITMAP_ALLOCATED;
 	return true;
 free_bitmap_tags:
-	sbitmap_queue_free(&tag_set->__sched_bitmap_tags);
+	sbitmap_queue_free(&eq->__bitmap_tags);
 	return false;
 }
 
-void blk_mq_exit_shared_sched_sbitmap(struct blk_mq_tag_set *tag_set)
+void blk_mq_exit_elevator_sbitmap(struct request_queue *q,
+				  struct elevator_queue *eq)
 {
-	if (tag_set->flags & BLK_MQ_F_TAG_SCHED_BITMAP_ALLOCATED) {
-		sbitmap_queue_free(&tag_set->__sched_bitmap_tags);
-		sbitmap_queue_free(&tag_set->__sched_breserved_tags);
-		tag_set->flags &= ~BLK_MQ_F_TAG_SCHED_BITMAP_ALLOCATED;
+	if (blk_mq_is_sbitmap_shared(q->tag_set)) {
+		sbitmap_queue_free(&eq->__bitmap_tags);
+		sbitmap_queue_free(&eq->__breserved_tags);
 	}
 }
 
diff --git a/block/blk-mq-tag.h b/block/blk-mq-tag.h
index 9463b878462f..31a42d50a8f1 100644
--- a/block/blk-mq-tag.h
+++ b/block/blk-mq-tag.h
@@ -27,9 +27,11 @@ struct blk_mq_tags {
 
 extern bool blk_mq_init_shared_sbitmap(struct blk_mq_tag_set *tag_set);
 extern void blk_mq_exit_shared_sbitmap(struct blk_mq_tag_set *tag_set);
-extern bool blk_mq_init_sched_shared_sbitmap(struct blk_mq_tag_set *tag_set,
-					     unsigned long nr_requests);
-extern void blk_mq_exit_shared_sched_sbitmap(struct blk_mq_tag_set *tag_set);
+extern bool blk_mq_init_elevator_sbitmap(struct request_queue *q,
+					 struct elevator_queue *eq,
+					 unsigned int nr_tags);
+extern void blk_mq_exit_elevator_sbitmap(struct request_queue *q,
+					 struct elevator_queue *eq);
 extern struct blk_mq_tags *blk_mq_init_tags(struct blk_mq_tag_set *tag_set,
 					    unsigned int nr_tags,
 					    unsigned int reserved_tags,
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 054c0597c052..c5cff1de56b3 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3142,7 +3142,6 @@ void blk_mq_free_tag_set(struct blk_mq_tag_set *set)
 	for (i = 0; i < nr_hw_queues(set); i++)
 		blk_mq_free_map_and_requests(set, i);
 
-	blk_mq_exit_shared_sched_sbitmap(set);
 	blk_mq_exit_shared_sbitmap(set);
 
 	for (j = 0; j < set->nr_maps; j++) {
@@ -3159,12 +3158,14 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
 {
 	struct blk_mq_tag_set *set = q->tag_set;
 	struct blk_mq_hw_ctx *hctx;
-	bool sched_tags = false;
 	int i, ret;
 
 	if (!set)
 		return -EINVAL;
 
+	if (blk_mq_is_sbitmap_shared(set) && !q->elevator)
+		return -EINVAL;
+
 	if (q->nr_requests == nr)
 		return 0;
 
@@ -3183,7 +3184,6 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
 			ret = blk_mq_tag_update_depth(hctx, &hctx->tags, nr,
 							false);
 		} else {
-			sched_tags = true;
 			ret = blk_mq_tag_update_depth(hctx, &hctx->sched_tags,
 							nr, true);
 		}
@@ -3199,29 +3199,18 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
 	 * if some are updated, we should probably roll back the change altogether. FIXME
 	 */
 	if (!ret) {
-		if (blk_mq_is_sbitmap_shared(set)) {
-			if (sched_tags) {
-				blk_mq_exit_shared_sched_sbitmap(set);
-				if (!blk_mq_init_sched_shared_sbitmap(set, nr))
-					return -ENOMEM; /* fixup error handling */
-
-				queue_for_each_hw_ctx(q, hctx, i) {
-					hctx->sched_tags->bitmap_tags =
-						&set->__sched_bitmap_tags;
-					hctx->sched_tags->breserved_tags =
-						&set->__sched_breserved_tags;
-				}
-			} else {
-				blk_mq_exit_shared_sbitmap(set);
-				if (!blk_mq_init_shared_sbitmap(set))
-					return -ENOMEM; /* fixup error handling */
-
-				queue_for_each_hw_ctx(q, hctx, i) {
-					hctx->tags->bitmap_tags =
-						&set->__bitmap_tags;
-					hctx->tags->breserved_tags =
-						&set->__breserved_tags;
-				}
+		if (blk_mq_is_sbitmap_shared(set) && q->elevator) {
+			struct elevator_queue *eq = q->elevator;
+
+			blk_mq_exit_elevator_sbitmap(q, eq);
+			if (!blk_mq_init_elevator_sbitmap(q, eq, nr))
+				return -ENOMEM; /* fixup error handling */
+
+			queue_for_each_hw_ctx(q, hctx, i) {
+				hctx->sched_tags->bitmap_tags =
+					&eq->__bitmap_tags;
+				hctx->sched_tags->breserved_tags =
+					&eq->__breserved_tags;
 			}
 		}
 		q->nr_requests = nr;
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 46f5198be017..01e644b1cba5 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -78,6 +78,13 @@ queue_requests_store(struct request_queue *q, const char *page, size_t count)
 	if (nr < BLKDEV_MIN_RQ)
 		nr = BLKDEV_MIN_RQ;
 
+	/*
+	 * We can only modify the queue depth for shared sbitmaps
+	 * if an I/O scheduler is set.
+	 */
+	if (blk_mq_is_sbitmap_shared(q->tag_set) && !q->elevator)
+		return -EINVAL;
+
 	err = blk_mq_update_nr_requests(q, nr);
 	if (err)
 		return err;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 10c9ed3dbe80..b4515bb862d4 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -112,9 +112,6 @@ struct blk_mq_tag_set {
 	struct sbitmap_queue	__bitmap_tags;
 	struct sbitmap_queue	__breserved_tags;
 
-	struct sbitmap_queue	__sched_bitmap_tags;
-	struct sbitmap_queue	__sched_breserved_tags;
-
 	struct blk_mq_tags	**tags;
 
 	struct mutex		tag_list_lock;
@@ -234,7 +231,6 @@ enum {
 	BLK_MQ_F_TAG_QUEUE_SHARED	= 1 << 1,
 	BLK_MQ_F_TAG_HCTX_SHARED	= 1 << 2,
 	BLK_MQ_F_TAG_BITMAP_ALLOCATED	= 1 << 3,
-	BLK_MQ_F_TAG_SCHED_BITMAP_ALLOCATED = 1 << 4,
 	BLK_MQ_F_BLOCKING	= 1 << 5,
 	BLK_MQ_F_NO_SCHED	= 1 << 6,
 	BLK_MQ_F_ALLOC_POLICY_START_BIT = 8,
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index 901bda352dcb..11d492f56089 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -4,6 +4,7 @@
 
 #include <linux/percpu.h>
 #include <linux/hashtable.h>
+#include <linux/sbitmap.h>
 
 #ifdef CONFIG_BLOCK
 
@@ -104,6 +105,8 @@ struct elevator_queue
 	void *elevator_data;
 	struct kobject kobj;
 	struct mutex sysfs_lock;
+	struct sbitmap_queue __bitmap_tags;
+	struct sbitmap_queue __breserved_tags;
 	unsigned int registered:1;
 	DECLARE_HASHTABLE(hash, ELV_HASH_BITS);
 };
-- 
2.16.4

