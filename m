From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 05/39] blk-mq: replace blk_mq_init_commands with a ->init_request method
Date: Mon, 17 Mar 2014 06:27:38 -0700
Message-ID: <20140317133132.105503343@bombadil.infradead.org>
References: <20140317132733.789623766@bombadil.infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=0005-blk-mq-replace-blk_mq_init_commands-with-a-init_requ.patch
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Bedides a simpler and cleared interface this also allows to initialize the
flush_rq properly.  The interface for that is still a bit messy as we don't
have a hw_ctx available for the flush request, but that's something that
should be fixable with a little work once the demand arises.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c             |   65 +++++++++++++++++++++-----------------------
 drivers/block/virtio_blk.c |   22 +++++++--------
 include/linux/blk-mq.h     |    9 +++++-
 3 files changed, 50 insertions(+), 46 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index e3284f6..c2ce99b 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -996,33 +996,6 @@ static void blk_mq_hctx_notify(void *data, unsigned long action,
 	blk_mq_put_ctx(ctx);
 }
 
-static void blk_mq_init_hw_commands(struct blk_mq_hw_ctx *hctx,
-				    void (*init)(void *, struct blk_mq_hw_ctx *,
-					struct request *, unsigned int),
-				    void *data)
-{
-	unsigned int i;
-
-	for (i = 0; i < hctx->queue_depth; i++) {
-		struct request *rq = hctx->rqs[i];
-
-		init(data, hctx, rq, i);
-	}
-}
-
-void blk_mq_init_commands(struct request_queue *q,
-			  void (*init)(void *, struct blk_mq_hw_ctx *,
-					struct request *, unsigned int),
-			  void *data)
-{
-	struct blk_mq_hw_ctx *hctx;
-	unsigned int i;
-
-	queue_for_each_hw_ctx(q, hctx, i)
-		blk_mq_init_hw_commands(hctx, init, data);
-}
-EXPORT_SYMBOL(blk_mq_init_commands);
-
 static void blk_mq_free_rq_map(struct blk_mq_hw_ctx *hctx)
 {
 	struct page *page;
@@ -1050,10 +1023,12 @@ static size_t order_to_size(unsigned int order)
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
 
@@ -1102,14 +1077,23 @@ static int blk_mq_init_rq_map(struct blk_mq_hw_ctx *hctx,
 		for (j = 0; j < to_do; j++) {
 			hctx->rqs[i] = p;
 			blk_mq_rq_init(hctx, hctx->rqs[i]);
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
@@ -1117,12 +1101,14 @@ static int blk_mq_init_rq_map(struct blk_mq_hw_ctx *hctx,
 
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
+	blk_mq_free_rq_map(hctx);
+	return error;
 }
 
 static int blk_mq_init_hw_queues(struct request_queue *q,
@@ -1155,7 +1141,7 @@ static int blk_mq_init_hw_queues(struct request_queue *q,
 						blk_mq_hctx_notify, hctx);
 		blk_mq_register_cpu_notifier(&hctx->cpu_notifier);
 
-		if (blk_mq_init_rq_map(hctx, reg->reserved_tags, node))
+		if (blk_mq_init_rq_map(hctx, reg, driver_data, node))
 			break;
 
 		/*
@@ -1334,6 +1320,17 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_reg *reg,
 	if (!q->flush_rq)
 		goto err_hw;
 
+	if (reg->ops->init_request) {
+		blk_rq_init(q, q->flush_rq);
+		if (reg->cmd_size)
+			q->flush_rq->special =
+				blk_mq_rq_to_pdu(q->flush_rq);
+
+		if (reg->ops->init_request(driver_data,
+				NULL, q->flush_rq, -1))
+			goto err_flush_rq;
+	}
+
 	if (blk_mq_init_hw_queues(q, reg, driver_data))
 		goto err_flush_rq;
 
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index b1cb3f4..a2e925b 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -474,11 +474,22 @@ static const struct device_attribute dev_attr_cache_type_rw =
 	__ATTR(cache_type, S_IRUGO|S_IWUSR,
 	       virtblk_cache_type_show, virtblk_cache_type_store);
 
+static int virtblk_init_request(void *data, struct blk_mq_hw_ctx *hctx,
+		struct request *rq, unsigned int nr)
+{
+	struct virtio_blk *vblk = data;
+	struct virtblk_req *vbr = rq->special;
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
 
@@ -490,15 +501,6 @@ static struct blk_mq_reg virtio_mq_reg = {
 	.flags		= BLK_MQ_F_SHOULD_MERGE,
 };
 
-static void virtblk_init_vbr(void *data, struct blk_mq_hw_ctx *hctx,
-			     struct request *rq, unsigned int nr)
-{
-	struct virtio_blk *vblk = data;
-	struct virtblk_req *vbr = rq->special;
-
-	sg_init_table(vbr->sg, vblk->sg_elems);
-}
-
 static int virtblk_probe(struct virtio_device *vdev)
 {
 	struct virtio_blk *vblk;
@@ -562,8 +564,6 @@ static int virtblk_probe(struct virtio_device *vdev)
 		goto out_put_disk;
 	}
 
-	blk_mq_init_commands(q, virtblk_init_vbr, vblk);
-
 	q->queuedata = vblk;
 
 	virtblk_name_format("vd", index, vblk->disk->disk_name, DISK_NAME_LEN);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 2ff2e8d..cac10e1 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -66,6 +66,8 @@ typedef struct blk_mq_hw_ctx *(alloc_hctx_fn)(struct blk_mq_reg *,unsigned int);
 typedef void (free_hctx_fn)(struct blk_mq_hw_ctx *, unsigned int);
 typedef int (init_hctx_fn)(struct blk_mq_hw_ctx *, void *, unsigned int);
 typedef void (exit_hctx_fn)(struct blk_mq_hw_ctx *, unsigned int);
+typedef int (init_request_fn)(void *, struct blk_mq_hw_ctx *,
+		struct request *, unsigned int);
 
 struct blk_mq_ops {
 	/*
@@ -98,6 +100,12 @@ struct blk_mq_ops {
 	 */
 	init_hctx_fn		*init_hctx;
 	exit_hctx_fn		*exit_hctx;
+
+	/*
+	 * Called for every command allocated by the block layer to allow
+	 * the driver to set up driver specific data.
+	 */
+	init_request_fn		*init_request;
 };
 
 enum {
@@ -117,7 +125,6 @@ enum {
 struct request_queue *blk_mq_init_queue(struct blk_mq_reg *, void *);
 int blk_mq_register_disk(struct gendisk *);
 void blk_mq_unregister_disk(struct gendisk *);
-void blk_mq_init_commands(struct request_queue *, void (*init)(void *data, struct blk_mq_hw_ctx *, struct request *, unsigned int), void *data);
 
 void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule);
 
-- 
1.7.10.4
