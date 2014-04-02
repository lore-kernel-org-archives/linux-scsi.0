From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/5] blk-mq: add ->init_request and ->exit_request methods
Date: Wed,  2 Apr 2014 16:57:14 +0200
Message-ID: <1396450634-32021-6-git-send-email-hch@lst.de>
References: <1396450634-32021-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1396450634-32021-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The current blk_mq_init_commands/blk_mq_free_commands interface has a two
problems:

 1) Because only the constructor is passed to blk_mq_init_commands there
    is no easy way to clean up when a comman initialization failed.  The
    current code simply leaks the allocations done in the constructor.
 2) There is no good place to call blk_mq_free_commands: before
    blk_cleanup_queue there is no guarantee that all outstanding commands
    have completed, so we can't free them yet.  After blk_cleanup_queue
    the queue has usually been freed.  This can be worked around by
    grabbing an unconditional reference before calling blk_cleanup_queue
    and dropping it after blk_mq_free_commands is done, although that's
    not exatly pretty and driver writers are guaranteed to get it wrong
    sooner or later.

Both issues are easily fixed by making the request constructor and
destructor normal blk_mq_ops methods.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c             |  105 ++++++++++++++------------------------------
 drivers/block/virtio_blk.c |   23 +++++-----
 include/linux/blk-mq.h     |   14 +++++-
 3 files changed, 55 insertions(+), 87 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 289b7e5..e0b65c4 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1005,74 +1005,20 @@ static void blk_mq_hctx_notify(void *data, unsigned long action,
 	blk_mq_put_ctx(ctx);
 }
 
-static int blk_mq_init_hw_commands(struct blk_mq_hw_ctx *hctx,
-				   int (*init)(void *, struct blk_mq_hw_ctx *,
-					struct request *, unsigned int),
-				   void *data)
+static void blk_mq_free_rq_map(struct blk_mq_hw_ctx *hctx, void *driver_data)
 {
-	unsigned int i;
-	int ret = 0;
-
-	for (i = 0; i < hctx->queue_depth; i++) {
-		struct request *rq = hctx->rqs[i];
-
-		ret = init(data, hctx, rq, i);
-		if (ret)
-			break;
-	}
-
-	return ret;
-}
-
-int blk_mq_init_commands(struct request_queue *q,
-			 int (*init)(void *, struct blk_mq_hw_ctx *,
-					struct request *, unsigned int),
-			 void *data)
-{
-	struct blk_mq_hw_ctx *hctx;
-	unsigned int i;
-	int ret = 0;
-
-	queue_for_each_hw_ctx(q, hctx, i) {
-		ret = blk_mq_init_hw_commands(hctx, init, data);
-		if (ret)
-			break;
-	}
-
-	return ret;
-}
-EXPORT_SYMBOL(blk_mq_init_commands);
-
-static void blk_mq_free_hw_commands(struct blk_mq_hw_ctx *hctx,
-				    void (*free)(void *, struct blk_mq_hw_ctx *,
-					struct request *, unsigned int),
-				    void *data)
-{
-	unsigned int i;
+	struct page *page;
 
-	for (i = 0; i < hctx->queue_depth; i++) {
-		struct request *rq = hctx->rqs[i];
+	if (hctx->rqs && hctx->queue->mq_ops->exit_request) {
+		int i;
 
-		free(data, hctx, rq, i);
+		for (i = 0; i < hctx->queue_depth; i++) {
+			if (!hctx->rqs[i])
+				continue;
+			hctx->queue->mq_ops->exit_request(driver_data, hctx,
+							  hctx->rqs[i], i);
+		}
 	}
-}
-
-void blk_mq_free_commands(struct request_queue *q,
-			  void (*free)(void *, struct blk_mq_hw_ctx *,
-					struct request *, unsigned int),
-			  void *data)
-{
-	struct blk_mq_hw_ctx *hctx;
-	unsigned int i;
-
-	queue_for_each_hw_ctx(q, hctx, i)
-		blk_mq_free_hw_commands(hctx, free, data);
-}
-EXPORT_SYMBOL(blk_mq_free_commands);
-
-static void blk_mq_free_rq_map(struct blk_mq_hw_ctx *hctx)
-{
-	struct page *page;
 
 	while (!list_empty(&hctx->page_list)) {
 		page = list_first_entry(&hctx->page_list, struct page, lru);
@@ -1097,10 +1043,12 @@ static size_t order_to_size(unsigned int order)
 }
 
 static int blk_mq_init_rq_map(struct blk_mq_hw_ctx *hctx,
-			      unsigned int reserved_tags, int node)
+		struct blk_mq_reg *reg, void *driver_data, int node)
 {
+	unsigned int reserved_tags = reg->reserved_tags;
 	unsigned int i, j, entries_per_page, max_order = 4;
 	size_t rq_size, left;
+	int error;
 
 	INIT_LIST_HEAD(&hctx->page_list);
 
@@ -1149,14 +1097,23 @@ static int blk_mq_init_rq_map(struct blk_mq_hw_ctx *hctx,
 		for (j = 0; j < to_do; j++) {
 			hctx->rqs[i] = p;
 			blk_rq_init(hctx->queue, hctx->rqs[i]);
+			if (reg->ops->init_request) {
+				error = reg->ops->init_request(driver_data,
+						hctx, hctx->rqs[i], i);
+				if (error)
+					goto err_rq_map;
+			}
+
 			p += rq_size;
 			i++;
 		}
 	}
 
-	if (i < (reserved_tags + BLK_MQ_TAG_MIN))
+	if (i < (reserved_tags + BLK_MQ_TAG_MIN)) {
+		error = -ENOMEM;
 		goto err_rq_map;
-	else if (i != hctx->queue_depth) {
+	}
+	if (i != hctx->queue_depth) {
 		hctx->queue_depth = i;
 		pr_warn("%s: queue depth set to %u because of low memory\n",
 					__func__, i);
@@ -1164,12 +1121,14 @@ static int blk_mq_init_rq_map(struct blk_mq_hw_ctx *hctx,
 
 	hctx->tags = blk_mq_init_tags(hctx->queue_depth, reserved_tags, node);
 	if (!hctx->tags) {
-err_rq_map:
-		blk_mq_free_rq_map(hctx);
-		return -ENOMEM;
+		error = -ENOMEM;
+		goto err_rq_map;
 	}
 
 	return 0;
+err_rq_map:
+	blk_mq_free_rq_map(hctx, driver_data);
+	return error;
 }
 
 static int blk_mq_init_hw_queues(struct request_queue *q,
@@ -1202,7 +1161,7 @@ static int blk_mq_init_hw_queues(struct request_queue *q,
 						blk_mq_hctx_notify, hctx);
 		blk_mq_register_cpu_notifier(&hctx->cpu_notifier);
 
-		if (blk_mq_init_rq_map(hctx, reg->reserved_tags, node))
+		if (blk_mq_init_rq_map(hctx, reg, driver_data, node))
 			break;
 
 		/*
@@ -1242,7 +1201,7 @@ static int blk_mq_init_hw_queues(struct request_queue *q,
 			reg->ops->exit_hctx(hctx, j);
 
 		blk_mq_unregister_cpu_notifier(&hctx->cpu_notifier);
-		blk_mq_free_rq_map(hctx);
+		blk_mq_free_rq_map(hctx, driver_data);
 		kfree(hctx->ctxs);
 	}
 
@@ -1419,7 +1378,7 @@ void blk_mq_free_queue(struct request_queue *q)
 	queue_for_each_hw_ctx(q, hctx, i) {
 		kfree(hctx->ctx_map);
 		kfree(hctx->ctxs);
-		blk_mq_free_rq_map(hctx);
+		blk_mq_free_rq_map(hctx, q->queuedata);
 		blk_mq_unregister_cpu_notifier(&hctx->cpu_notifier);
 		if (q->mq_ops->exit_hctx)
 			q->mq_ops->exit_hctx(hctx, i);
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 11e8f4b..87447c1f 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -474,11 +474,22 @@ static const struct device_attribute dev_attr_cache_type_rw =
 	__ATTR(cache_type, S_IRUGO|S_IWUSR,
 	       virtblk_cache_type_show, virtblk_cache_type_store);
 
+static int virtblk_init_request(void *data, struct blk_mq_hw_ctx *hctx,
+		struct request *rq, unsigned int nr)
+{
+	struct virtio_blk *vblk = data;
+	struct virtblk_req *vbr = blk_mq_rq_to_pdu(rq);
+
+	sg_init_table(vbr->sg, vblk->sg_elems);
+	return 0;
+}
+
 static struct blk_mq_ops virtio_mq_ops = {
 	.queue_rq	= virtio_queue_rq,
 	.map_queue	= blk_mq_map_queue,
 	.alloc_hctx	= blk_mq_alloc_single_hw_queue,
 	.free_hctx	= blk_mq_free_single_hw_queue,
+	.init_request	= virtblk_init_request,
 	.complete	= virtblk_request_done,
 };
 
@@ -490,16 +501,6 @@ static struct blk_mq_reg virtio_mq_reg = {
 	.flags		= BLK_MQ_F_SHOULD_MERGE,
 };
 
-static int virtblk_init_vbr(void *data, struct blk_mq_hw_ctx *hctx,
-			     struct request *rq, unsigned int nr)
-{
-	struct virtio_blk *vblk = data;
-	struct virtblk_req *vbr = blk_mq_rq_to_pdu(rq);
-
-	sg_init_table(vbr->sg, vblk->sg_elems);
-	return 0;
-}
-
 static int virtblk_probe(struct virtio_device *vdev)
 {
 	struct virtio_blk *vblk;
@@ -563,8 +564,6 @@ static int virtblk_probe(struct virtio_device *vdev)
 		goto out_put_disk;
 	}
 
-	blk_mq_init_commands(q, virtblk_init_vbr, vblk);
-
 	q->queuedata = vblk;
 
 	virtblk_name_format("vd", index, vblk->disk->disk_name, DISK_NAME_LEN);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 0120451..897ca1a 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -66,6 +66,10 @@ typedef struct blk_mq_hw_ctx *(alloc_hctx_fn)(struct blk_mq_reg *,unsigned int);
 typedef void (free_hctx_fn)(struct blk_mq_hw_ctx *, unsigned int);
 typedef int (init_hctx_fn)(struct blk_mq_hw_ctx *, void *, unsigned int);
 typedef void (exit_hctx_fn)(struct blk_mq_hw_ctx *, unsigned int);
+typedef int (init_request_fn)(void *, struct blk_mq_hw_ctx *,
+		struct request *, unsigned int);
+typedef void (exit_request_fn)(void *, struct blk_mq_hw_ctx *,
+		struct request *, unsigned int);
 
 struct blk_mq_ops {
 	/*
@@ -98,6 +102,14 @@ struct blk_mq_ops {
 	 */
 	init_hctx_fn		*init_hctx;
 	exit_hctx_fn		*exit_hctx;
+
+	/*
+	 * Called for every command allocated by the block layer to allow
+	 * the driver to set up driver specific data.
+	 * Ditto for exit/teardown.
+	 */
+	init_request_fn		*init_request;
+	exit_request_fn		*exit_request;
 };
 
 enum {
@@ -117,8 +129,6 @@ enum {
 struct request_queue *blk_mq_init_queue(struct blk_mq_reg *, void *);
 int blk_mq_register_disk(struct gendisk *);
 void blk_mq_unregister_disk(struct gendisk *);
-int blk_mq_init_commands(struct request_queue *, int (*init)(void *data, struct blk_mq_hw_ctx *, struct request *, unsigned int), void *data);
-void blk_mq_free_commands(struct request_queue *, void (*free)(void *data, struct blk_mq_hw_ctx *, struct request *, unsigned int), void *data);
 
 void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule);
 
-- 
1.7.10.4
