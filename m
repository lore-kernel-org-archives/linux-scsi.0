From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 39/39] scsi: implement ->init_request and ->exit_request
Date: Mon, 17 Mar 2014 06:28:12 -0700
Message-ID: <20140317133137.469944412@bombadil.infradead.org>
References: <20140317132733.789623766@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51825 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933308AbaCQNbh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Mar 2014 09:31:37 -0400
Content-Disposition: inline; filename=0039-scsi-implement-init_request-and-exit_request.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c |   67 ++++++++++++++++-------------------------------
 include/linux/blk-mq.h  |    3 +++
 2 files changed, 25 insertions(+), 45 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 836f197..e6d87e3 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1896,11 +1896,32 @@ struct request_queue *scsi_alloc_queue(struct scsi_device *sdev)
 	return q;
 }
 
+static int scsi_init_request(void *data, struct blk_mq_hw_ctx *hctx,
+		struct request *rq, unsigned int nr)
+{
+	struct scsi_cmnd *cmd = rq->special;
+
+	cmd->sense_buffer = kzalloc_node(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL,
+					hctx ? hctx->numa_node : -1);
+	if (!cmd->sense_buffer)
+		return -ENOMEM;
+	return 0;
+}
+
+static void scsi_exit_request(struct blk_mq_hw_ctx *hctx, struct request *rq)
+{
+	struct scsi_cmnd *cmd = rq->special;
+
+	kfree(cmd->sense_buffer);
+}
+
 static struct blk_mq_ops scsi_mq_ops = {
 	.queue_rq	= scsi_mq_queue_rq,
 	.map_queue	= blk_mq_map_queue,
 	.alloc_hctx	= blk_mq_alloc_single_hw_queue,
 	.free_hctx	= blk_mq_free_single_hw_queue,
+	.init_request	= scsi_init_request,
+	.exit_request	= scsi_exit_request,
 	.complete	= scsi_softirq_done,
 	.timeout	= scsi_times_out,
 };
@@ -1908,12 +1929,9 @@ static struct blk_mq_ops scsi_mq_ops = {
 struct request_queue *scsi_mq_alloc_queue(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost = sdev->host;
-	struct blk_mq_hw_ctx *hctx;
 	struct request_queue *q;
-	struct request *rq;
-	struct scsi_cmnd *cmd;
 	struct blk_mq_reg reg;
-	int i, j, sgl_size;
+	int sgl_size;
 
 	memset(&reg, 0, sizeof(reg));
 	reg.ops = &scsi_mq_ops;
@@ -1946,48 +1964,7 @@ struct request_queue *scsi_mq_alloc_queue(struct scsi_device *sdev)
 
 	__scsi_init_queue(shost, q);
 
-	/*
-	 * XXX: figure out if we can get alignment right to allocate the sense
-	 * buffer with the other chunks of memory.
-	 *
-	 * If not we'll need to find a way to have the blk-mq core call us to
-	 * allocate/free commands so that we can properly clean up the
-	 * allocation instead of leaking it.
-	 */
-	queue_for_each_hw_ctx(q, hctx, i) {
-		for (j = 0; j < hctx->queue_depth; j++) {
-			rq = hctx->rqs[j];
-			cmd = rq->special;
-
-			cmd->sense_buffer = kzalloc_node(SCSI_SENSE_BUFFERSIZE,
-					   GFP_KERNEL, reg.numa_node);
-			if (!cmd->sense_buffer)
-				goto out_free_sense_buffers;
-		}
-	}
-
-	rq = q->flush_rq;
-	cmd = blk_mq_rq_to_pdu(rq);
-
-	cmd->sense_buffer = kzalloc_node(SCSI_SENSE_BUFFERSIZE,
-					   GFP_KERNEL, reg.numa_node);
-	if (!cmd->sense_buffer)
-		goto out_free_sense_buffers;
-
 	return q;
-
-out_free_sense_buffers:
-	queue_for_each_hw_ctx(q, hctx, i) {
-		for (j = 0; j < hctx->queue_depth; j++) {
-			rq = hctx->rqs[j];
-			cmd = rq->special;
-
-			kfree(cmd->sense_buffer);
-		}
-	}
-
-	blk_cleanup_queue(q);
-	return NULL;
 }
 
 /*
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 4d34957..ff194f8 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -68,6 +68,7 @@ typedef int (init_hctx_fn)(struct blk_mq_hw_ctx *, void *, unsigned int);
 typedef void (exit_hctx_fn)(struct blk_mq_hw_ctx *, unsigned int);
 typedef int (init_request_fn)(void *, struct blk_mq_hw_ctx *,
 		struct request *, unsigned int);
+typedef void (exit_request_fn)(struct blk_mq_hw_ctx *, struct request *);
 
 struct blk_mq_ops {
 	/*
@@ -104,8 +105,10 @@ struct blk_mq_ops {
 	/*
 	 * Called for every command allocated by the block layer to allow
 	 * the driver to set up driver specific data.
+	 * Ditto for exit/teardown.
 	 */
 	init_request_fn		*init_request;
+	exit_request_fn		*exit_request;
 };
 
 enum {
-- 
1.7.10.4


