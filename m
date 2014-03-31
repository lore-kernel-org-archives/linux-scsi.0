From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/4] blk-mq: move request structures into struct blk_mq_tags
Date: Mon, 31 Mar 2014 16:46:14 +0200
Message-ID: <1396277175-21382-4-git-send-email-hch@lst.de>
References: <1396277175-21382-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1396277175-21382-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Matias Bjorling <m@bjorling.me>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is in preparation for allowing to share the tags, and thus request
allocation between multiple queues.

Also remove blk_mq_tag_to_rq, as it was unused and thus untestable.  If we
need it back it can easil be re-added as a non-inline function.

Note that we also now straight out fail queue initialization if we can't
allocate tags - keeping track of a reduced queue_depth over a more complex
call chain isn't easil possible and this shouldn't happen on an of todays
systems.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq-tag.c     |   13 --------
 block/blk-mq.c         |   84 +++++++++++++++++++++++++-----------------------
 block/blk-mq.h         |   18 +++++++++++
 include/linux/blk-mq.h |    8 -----
 4 files changed, 61 insertions(+), 62 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 83ae96c..108f82b 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -7,19 +7,6 @@
 #include "blk-mq.h"
 #include "blk-mq-tag.h"
 
-/*
- * Per tagged queue (tag address space) map
- */
-struct blk_mq_tags {
-	unsigned int nr_tags;
-	unsigned int nr_reserved_tags;
-	unsigned int nr_batch_move;
-	unsigned int nr_max_cache;
-
-	struct percpu_ida free_tags;
-	struct percpu_ida reserved_tags;
-};
-
 void blk_mq_wait_for_tags(struct blk_mq_tags *tags)
 {
 	int tag = blk_mq_get_tag(tags, __GFP_WAIT, false);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index ec0c276..f1b5d52 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -81,7 +81,7 @@ static struct request *__blk_mq_alloc_request(struct blk_mq_hw_ctx *hctx,
 
 	tag = blk_mq_get_tag(hctx->tags, gfp, reserved);
 	if (tag != BLK_MQ_TAG_FAIL) {
-		rq = hctx->rqs[tag];
+		rq = hctx->tags->rqs[tag];
 		blk_rq_init(hctx->queue, rq);
 		rq->tag = tag;
 
@@ -406,7 +406,9 @@ static void blk_mq_timeout_check(void *__data, unsigned long *free_tags)
 		if (tag >= hctx->queue_depth)
 			break;
 
-		rq = hctx->rqs[tag++];
+		rq = hctx->tags->rqs[tag++];
+		if (rq->q != hctx->queue)
+			continue;
 
 		if (!test_bit(REQ_ATOM_STARTED, &rq->atomic_flags))
 			continue;
@@ -993,7 +995,7 @@ static int blk_mq_init_hw_commands(struct blk_mq_hw_ctx *hctx,
 	int ret = 0;
 
 	for (i = 0; i < hctx->queue_depth; i++) {
-		struct request *rq = hctx->rqs[i];
+		struct request *rq = hctx->tags->rqs[i];
 
 		ret = init(data, hctx, rq, i);
 		if (ret)
@@ -1030,7 +1032,7 @@ static void blk_mq_free_hw_commands(struct blk_mq_hw_ctx *hctx,
 	unsigned int i;
 
 	for (i = 0; i < hctx->queue_depth; i++) {
-		struct request *rq = hctx->rqs[i];
+		struct request *rq = hctx->tags->rqs[i];
 
 		free(data, hctx, rq, i);
 	}
@@ -1049,20 +1051,19 @@ void blk_mq_free_commands(struct request_queue *q,
 }
 EXPORT_SYMBOL(blk_mq_free_commands);
 
-static void blk_mq_free_rq_map(struct blk_mq_hw_ctx *hctx)
+static void blk_mq_free_rq_map(struct blk_mq_tags *tags)
 {
 	struct page *page;
 
-	while (!list_empty(&hctx->page_list)) {
-		page = list_first_entry(&hctx->page_list, struct page, lru);
+	while (!list_empty(&tags->page_list)) {
+		page = list_first_entry(&tags->page_list, struct page, lru);
 		list_del_init(&page->lru);
 		__free_pages(page, page->private);
 	}
 
-	kfree(hctx->rqs);
+	kfree(tags->rqs);
 
-	if (hctx->tags)
-		blk_mq_free_tags(hctx->tags);
+	blk_mq_free_tags(tags);
 }
 
 static size_t order_to_size(unsigned int order)
@@ -1075,28 +1076,35 @@ static size_t order_to_size(unsigned int order)
 	return ret;
 }
 
-static int blk_mq_init_rq_map(struct blk_mq_hw_ctx *hctx,
-			      unsigned int reserved_tags, int node)
+static struct blk_mq_tags *blk_mq_init_rq_map(unsigned int total_tags,
+		unsigned int reserved_tags, unsigned int cmd_size, int node)
 {
+	struct blk_mq_tags *tags;
 	unsigned int i, j, entries_per_page, max_order = 4;
 	size_t rq_size, left;
 
-	INIT_LIST_HEAD(&hctx->page_list);
+	tags = blk_mq_init_tags(total_tags, reserved_tags, node);
+	if (!tags)
+		return NULL;
+
+	INIT_LIST_HEAD(&tags->page_list);
 
-	hctx->rqs = kmalloc_node(hctx->queue_depth * sizeof(struct request *),
+	tags->rqs = kmalloc_node(total_tags * sizeof(struct request *),
 					GFP_KERNEL, node);
-	if (!hctx->rqs)
-		return -ENOMEM;
+	if (!tags->rqs) {
+		blk_mq_free_tags(tags);
+		return NULL;
+	}
 
 	/*
 	 * rq_size is the size of the request plus driver payload, rounded
 	 * to the cacheline size
 	 */
-	rq_size = round_up(sizeof(struct request) + hctx->cmd_size,
+	rq_size = round_up(sizeof(struct request) + cmd_size,
 				cache_line_size());
-	left = rq_size * hctx->queue_depth;
+	left = rq_size * total_tags;
 
-	for (i = 0; i < hctx->queue_depth;) {
+	for (i = 0; i < total_tags; ) {
 		int this_order = max_order;
 		struct page *page;
 		int to_do;
@@ -1116,38 +1124,28 @@ static int blk_mq_init_rq_map(struct blk_mq_hw_ctx *hctx,
 		} while (1);
 
 		if (!page)
-			break;
+			goto fail;
 
 		page->private = this_order;
-		list_add_tail(&page->lru, &hctx->page_list);
+		list_add_tail(&page->lru, &tags->page_list);
 
 		p = page_address(page);
 		entries_per_page = order_to_size(this_order) / rq_size;
-		to_do = min(entries_per_page, hctx->queue_depth - i);
+		to_do = min(entries_per_page, total_tags - i);
 		left -= to_do * rq_size;
 		for (j = 0; j < to_do; j++) {
-			hctx->rqs[i] = p;
+			tags->rqs[i] = p;
 			p += rq_size;
 			i++;
 		}
 	}
 
-	if (i < (reserved_tags + BLK_MQ_TAG_MIN))
-		goto err_rq_map;
-	else if (i != hctx->queue_depth) {
-		hctx->queue_depth = i;
-		pr_warn("%s: queue depth set to %u because of low memory\n",
-					__func__, i);
-	}
-
-	hctx->tags = blk_mq_init_tags(hctx->queue_depth, reserved_tags, node);
-	if (!hctx->tags) {
-err_rq_map:
-		blk_mq_free_rq_map(hctx);
-		return -ENOMEM;
-	}
+	return tags;
 
-	return 0;
+fail:
+	pr_warn("%s: failed to allocate requests\n", __func__);
+	blk_mq_free_rq_map(tags);
+	return NULL;
 }
 
 static int blk_mq_init_hw_queues(struct request_queue *q,
@@ -1180,7 +1178,9 @@ static int blk_mq_init_hw_queues(struct request_queue *q,
 						blk_mq_hctx_notify, hctx);
 		blk_mq_register_cpu_notifier(&hctx->cpu_notifier);
 
-		if (blk_mq_init_rq_map(hctx, reg->reserved_tags, node))
+		hctx->tags = blk_mq_init_rq_map(hctx->queue_depth,
+				reg->reserved_tags, reg->cmd_size, node);
+		if (!hctx->tags)
 			break;
 
 		/*
@@ -1220,7 +1220,8 @@ static int blk_mq_init_hw_queues(struct request_queue *q,
 			reg->ops->exit_hctx(hctx, j);
 
 		blk_mq_unregister_cpu_notifier(&hctx->cpu_notifier);
-		blk_mq_free_rq_map(hctx);
+		if (hctx->tags)
+			blk_mq_free_rq_map(hctx->tags);
 		kfree(hctx->ctxs);
 	}
 
@@ -1397,7 +1398,8 @@ void blk_mq_free_queue(struct request_queue *q)
 	queue_for_each_hw_ctx(q, hctx, i) {
 		kfree(hctx->ctx_map);
 		kfree(hctx->ctxs);
-		blk_mq_free_rq_map(hctx);
+		if (hctx->tags)
+			blk_mq_free_rq_map(hctx->tags);
 		blk_mq_unregister_cpu_notifier(&hctx->cpu_notifier);
 		if (q->mq_ops->exit_hctx)
 			q->mq_ops->exit_hctx(hctx, i);
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 238379a..eca3a47 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -1,6 +1,24 @@
 #ifndef INT_BLK_MQ_H
 #define INT_BLK_MQ_H
 
+#include <linux/percpu_ida.h>
+
+/*
+ * Tag address space map.
+ */
+struct blk_mq_tags {
+	unsigned int nr_tags;
+	unsigned int nr_reserved_tags;
+	unsigned int nr_batch_move;
+	unsigned int nr_max_cache;
+
+	struct percpu_ida free_tags;
+	struct percpu_ida reserved_tags;
+
+	struct request **rqs;
+	struct list_head page_list;
+};
+
 struct blk_mq_ctx {
 	struct {
 		spinlock_t		lock;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 0120451..69aa3ad 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -32,8 +32,6 @@ struct blk_mq_hw_ctx {
 	unsigned int 		nr_ctx_map;
 	unsigned long		*ctx_map;
 
-	struct request		**rqs;
-	struct list_head	page_list;
 	struct blk_mq_tags	*tags;
 
 	unsigned long		queued;
@@ -162,12 +160,6 @@ static inline void *blk_mq_rq_to_pdu(struct request *rq)
 	return (void *) rq + sizeof(*rq);
 }
 
-static inline struct request *blk_mq_tag_to_rq(struct blk_mq_hw_ctx *hctx,
-					       unsigned int tag)
-{
-	return hctx->rqs[tag];
-}
-
 #define queue_for_each_hw_ctx(q, hctx, i)				\
 	for ((i) = 0; (i) < (q)->nr_hw_queues &&			\
 	     ({ hctx = (q)->queue_hw_ctx[i]; 1; }); (i)++)
-- 
1.7.10.4
