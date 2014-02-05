From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 12/15] scsi: initial blk-mq support
Date: Wed, 05 Feb 2014 04:41:30 -0800
Message-ID: <20140205124154.337539740@bombadil.infradead.org>
References: <20140205124118.332902571@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53241 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbaBEMl4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Feb 2014 07:41:56 -0500
Content-Disposition: inline; filename=0012-scsi-initial-blk-mq-support.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org

Add support for using the blk-mq code to submit requests to SCSI
drivers.  There is very little blk-mq specific code, but that's
partially because important functionality like partial completions
and request requeueing is still missing in blk-mq.  I hope to keep
most of the additions for these in the blk-mq core instead of the
SCSI layer, though.

Based on the earlier scsi-mq prototype by Nicholas Bellinger, although
not a whole lot of actual code is left.

Not-quite-signed-off-yet-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi.c      |   36 ++++++-
 drivers/scsi/scsi_lib.c  |  244 ++++++++++++++++++++++++++++++++++++++++++++--
 drivers/scsi/scsi_priv.h |    2 +
 drivers/scsi/scsi_scan.c |    5 +-
 include/scsi/scsi_host.h |    3 +
 5 files changed, 278 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index adb8bfb..cf5c110 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -44,6 +44,7 @@
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/blkdev.h>
+#include <linux/blk-mq.h>
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/completion.h>
@@ -688,6 +689,33 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 	return 0;
 }
 
+static void scsi_softirq_done_remote(void *data)
+{
+	return scsi_softirq_done(data);
+}
+
+static void scsi_mq_done(struct request *req)
+{
+	int cpu;
+
+#if 0
+	if (!ctx->ipi_redirect)
+		return scsi_softirq_done(cmd);
+#endif
+
+	cpu = get_cpu();
+	if (cpu != req->cpu && cpu_online(req->cpu)) {
+		req->csd.func = scsi_softirq_done_remote;
+		req->csd.info = req;
+		req->csd.flags = 0;
+		__smp_call_function_single(req->cpu, &req->csd, 0);
+	} else {
+		scsi_softirq_done(req);
+	}
+
+	put_cpu();
+}
+
 /**
  * scsi_done - Invoke completion on finished SCSI command.
  * @cmd: The SCSI Command for which a low-level device driver (LLDD) gives
@@ -701,8 +729,14 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
  */
 static void scsi_done(struct scsi_cmnd *cmd)
 {
+	struct request *req = cmd->request;
+
 	trace_scsi_dispatch_cmd_done(cmd);
-	blk_complete_request(cmd->request);
+
+	if (req->mq_ctx)
+		scsi_mq_done(req);
+	else
+		blk_complete_request(req);
 }
 
 /**
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e67950c..8dd8893 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -20,6 +20,7 @@
 #include <linux/delay.h>
 #include <linux/hardirq.h>
 #include <linux/scatterlist.h>
+#include <linux/blk-mq.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -554,6 +555,15 @@ static bool scsi_end_request(struct scsi_cmnd *cmd, int error, int bytes,
 	struct request *req = cmd->request;
 
 	/*
+	 * XXX: need to handle partial completions and retries here.
+	 */
+	if (req->mq_ctx) {
+		blk_mq_end_io(req, error);
+		put_device(&cmd->device->sdev_gendev);
+		return true;
+	}
+
+	/*
 	 * If there are blocks left over at the end, set up the command
 	 * to queue the remainder of them.
 	 */
@@ -1014,12 +1024,15 @@ static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb,
 {
 	int count;
 
-	/*
-	 * If sg table allocation fails, requeue request later.
-	 */
-	if (unlikely(scsi_alloc_sgtable(sdb, req->nr_phys_segments,
-					gfp_mask))) {
-		return BLKPREP_DEFER;
+	BUG_ON(req->nr_phys_segments > SCSI_MAX_SG_SEGMENTS);
+
+	if (!req->mq_ctx) {
+		/*
+		 * If sg table allocation fails, requeue request later.
+		 */
+		if (unlikely(scsi_alloc_sgtable(sdb, req->nr_phys_segments,
+						gfp_mask)))
+			return BLKPREP_DEFER;
 	}
 
 	req->buffer = NULL;
@@ -1075,9 +1088,11 @@ int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 		BUG_ON(prot_sdb == NULL);
 		ivecs = blk_rq_count_integrity_sg(rq->q, rq->bio);
 
-		if (scsi_alloc_sgtable(prot_sdb, ivecs, gfp_mask)) {
-			error = BLKPREP_DEFER;
-			goto err_exit;
+		if (!rq->mq_ctx) {
+			if (scsi_alloc_sgtable(prot_sdb, ivecs, gfp_mask)) {
+				error = BLKPREP_DEFER;
+				goto err_exit;
+			}
 		}
 
 		count = blk_rq_map_integrity_sg(rq->q, rq->bio,
@@ -1505,7 +1520,7 @@ static void scsi_kill_request(struct request *req, struct request_queue *q)
 	blk_complete_request(req);
 }
 
-static void scsi_softirq_done(struct request *rq)
+void scsi_softirq_done(struct request *rq)
 {
 	struct scsi_cmnd *cmd = rq->special;
 	unsigned long wait_for = (cmd->allowed + 1) * rq->timeout;
@@ -1533,9 +1548,11 @@ static void scsi_softirq_done(struct request *rq)
 			scsi_finish_command(cmd);
 			break;
 		case NEEDS_RETRY:
+			WARN_ON(rq->mq_ctx);
 			scsi_queue_insert(cmd, SCSI_MLQUEUE_EH_RETRY);
 			break;
 		case ADD_TO_MLQUEUE:
+			WARN_ON(rq->mq_ctx);
 			scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
 			break;
 		default:
@@ -1668,6 +1685,120 @@ out_delay:
 		blk_delay_queue(q, SCSI_QUEUE_DELAY);
 }
 
+static int scsi_mq_prep_fn(struct request *req)
+{
+	struct scsi_cmnd *cmd = req->special;
+	int ret;
+
+	ret = scsi_prep_state_check(cmd->device, req);
+	if (ret != BLKPREP_OK)
+		goto out;
+
+	if (req->cmd_type == REQ_TYPE_FS)
+		ret = scsi_cmd_to_driver(cmd)->init_command(cmd);
+	else if (req->cmd_type == REQ_TYPE_BLOCK_PC)
+		ret = scsi_setup_blk_pc_cmnd(cmd->device, req);
+	else
+		ret = BLKPREP_KILL;
+
+out:
+	switch (ret) {
+	case BLKPREP_OK:
+		return 0;
+	case BLKPREP_DEFER:
+		return BLK_MQ_RQ_QUEUE_BUSY;
+	default:
+		req->errors = DID_NO_CONNECT << 16;
+		return BLK_MQ_RQ_QUEUE_ERROR;
+	}
+}
+
+static int scsi_mq_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *rq)
+{
+	struct request_queue *q = rq->q;
+	struct scsi_device *sdev = q->queuedata;
+	struct Scsi_Host *shost = sdev->host;
+	struct scsi_cmnd *cmd = rq->special;
+	unsigned char *sense_buf = cmd->sense_buffer;
+	struct scatterlist *sg;
+	int ret = BLK_MQ_RQ_QUEUE_BUSY;
+	int reason;
+
+	/*
+	 * blk-mq stores this in the mq_ctx, which can't be derferenced by
+	 * drivers.  For now use the old per-request field, but there must be
+	 * a better way.
+	 */
+	rq->cpu = raw_smp_processor_id();
+
+	if (!get_device(&sdev->sdev_gendev))
+		goto out;
+
+	if (!scsi_dev_queue_ready(q, sdev))
+		goto out_put_device;
+	if (!scsi_target_queue_ready(shost, sdev))
+		goto out_dec_device_busy;
+	if (!scsi_host_queue_ready(q, shost, sdev))
+		goto out_dec_target_busy;
+
+	memset(sense_buf, 0, SCSI_SENSE_BUFFERSIZE);
+	memset(cmd, 0, sizeof(struct scsi_cmnd));
+
+	cmd->request = rq;
+	cmd->device = sdev;
+	cmd->sense_buffer = sense_buf;
+
+	cmd->tag = rq->tag;
+	cmd->cmnd = rq->cmd;
+	cmd->prot_op = SCSI_PROT_NORMAL;
+
+	sg = (void *)cmd + sizeof(struct scsi_cmnd) + shost->hostt->cmd_size;
+
+	if (rq->nr_phys_segments) {
+		cmd->sdb.table.sgl = sg;
+		cmd->sdb.table.nents = rq->nr_phys_segments;
+		sg_init_table(cmd->sdb.table.sgl, rq->nr_phys_segments);
+	}
+
+	if (scsi_host_get_prot(shost)) {
+		cmd->prot_sdb = (void *)sg +
+			shost->sg_tablesize * sizeof(struct scatterlist);
+		memset(cmd->prot_sdb, 0, sizeof(struct scsi_data_buffer));
+
+		cmd->prot_sdb->table.sgl =
+			(struct scatterlist *)(cmd->prot_sdb + 1);
+	}
+
+	ret = scsi_mq_prep_fn(rq);
+	if (ret)
+		goto out_dec_host_busy;
+
+	scsi_init_cmd_errh(cmd);
+
+	reason = scsi_dispatch_cmd(cmd);
+	if (reason) {
+		scsi_set_blocked(cmd, reason);
+		goto out_uninit;
+	}
+
+	return BLK_MQ_RQ_QUEUE_OK;
+
+out_uninit:
+	if (rq->cmd_type == REQ_TYPE_FS)
+		scsi_cmd_to_driver(cmd)->uninit_command(cmd);
+out_dec_host_busy:
+	atomic_dec(&shost->host_busy);
+out_dec_target_busy:
+	atomic_dec(&scsi_target(sdev)->target_busy);
+out_dec_device_busy:
+	atomic_dec(&sdev->device_busy);
+	/* XXX: delay queue if device_busy == 0 */
+out_put_device:
+	put_device(&sdev->sdev_gendev);
+out:
+	return ret;
+}
+
 u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
 {
 	struct device *host_dev;
@@ -1754,6 +1885,99 @@ struct request_queue *scsi_alloc_queue(struct scsi_device *sdev)
 	return q;
 }
 
+static struct blk_mq_ops scsi_mq_ops = {
+	.queue_rq	= scsi_mq_queue_rq,
+	.map_queue	= blk_mq_map_queue,
+	.alloc_hctx	= blk_mq_alloc_single_hw_queue,
+	.free_hctx	= blk_mq_free_single_hw_queue,
+};
+
+struct request_queue *scsi_mq_alloc_queue(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct blk_mq_hw_ctx *hctx;
+	struct request_queue *q;
+	struct request *rq;
+	struct scsi_cmnd *cmd;
+	struct blk_mq_reg reg;
+	int i, j, sgl_size;
+
+	memset(&reg, 0, sizeof(reg));
+	reg.ops = &scsi_mq_ops;
+	reg.queue_depth = shost->cmd_per_lun;
+	if (!reg.queue_depth)
+		reg.queue_depth = 1;
+
+	/* XXX: what to do about chained S/G lists? */
+	if (shost->hostt->sg_tablesize > SCSI_MAX_SG_SEGMENTS)
+		shost->sg_tablesize = SCSI_MAX_SG_SEGMENTS;
+	sgl_size = shost->sg_tablesize * sizeof(struct scatterlist);
+
+	reg.cmd_size = sizeof(struct scsi_cmnd) +
+			sgl_size +
+			shost->hostt->cmd_size;
+	if (scsi_host_get_prot(shost))
+		reg.cmd_size += sizeof(struct scsi_data_buffer) + sgl_size;
+	reg.numa_node = NUMA_NO_NODE;
+	reg.nr_hw_queues = 1;
+	reg.flags = BLK_MQ_F_SHOULD_MERGE;
+
+	q = blk_mq_init_queue(&reg, sdev);
+	if (IS_ERR(q)) {
+		printk("blk_mq_init_queue failed\n");
+		return NULL;
+	}
+
+	blk_queue_prep_rq(q, scsi_prep_fn);
+	sdev->request_queue = q;
+	q->queuedata = sdev;
+
+	__scsi_init_queue(shost, q);
+
+	/*
+	 * XXX: figure out if we can get alignment right to allocate the sense
+	 * buffer with the other chunks of memory.
+	 *
+	 * If not we'll need to find a way to have the blk-mq core call us to
+	 * allocate/free commands so that we can properly clean up the
+	 * allocation instead of leaking it.
+	 */
+	queue_for_each_hw_ctx(q, hctx, i) {
+		for (j = 0; j < hctx->queue_depth; j++) {
+			rq = hctx->rqs[j];
+			cmd = rq->special;
+
+			cmd->sense_buffer = kzalloc_node(SCSI_SENSE_BUFFERSIZE,
+					   GFP_KERNEL, reg.numa_node);
+			if (!cmd->sense_buffer)
+				goto out_free_sense_buffers;
+		}
+	}
+
+	rq = q->flush_rq;
+	cmd = blk_mq_rq_to_pdu(rq);
+
+	cmd->sense_buffer = kzalloc_node(SCSI_SENSE_BUFFERSIZE,
+					   GFP_KERNEL, reg.numa_node);
+	if (!cmd->sense_buffer)
+		goto out_free_sense_buffers;
+
+	return q;
+
+out_free_sense_buffers:
+	queue_for_each_hw_ctx(q, hctx, i) {
+		for (j = 0; j < hctx->queue_depth; j++) {
+			rq = hctx->rqs[j];
+			cmd = rq->special;
+
+			kfree(cmd->sense_buffer);
+		}
+	}
+
+	blk_cleanup_queue(q);
+	return NULL;
+}
+
 /*
  * Function:    scsi_block_requests()
  *
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index f079a59..712cec2 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -88,8 +88,10 @@ extern void scsi_next_command(struct scsi_cmnd *cmd);
 extern void scsi_io_completion(struct scsi_cmnd *, unsigned int);
 extern void scsi_run_host_queues(struct Scsi_Host *shost);
 extern struct request_queue *scsi_alloc_queue(struct scsi_device *sdev);
+extern struct request_queue *scsi_mq_alloc_queue(struct scsi_device *sdev);
 extern int scsi_init_queue(void);
 extern void scsi_exit_queue(void);
+extern void scsi_softirq_done(struct request *rq);
 struct request_queue;
 struct request;
 extern struct kmem_cache *scsi_sdb_cache;
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 307a811..c807bc2 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -277,7 +277,10 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	 */
 	sdev->borken = 1;
 
-	sdev->request_queue = scsi_alloc_queue(sdev);
+	if (shost->hostt->use_blk_mq)
+		sdev->request_queue = scsi_mq_alloc_queue(sdev);
+	else
+		sdev->request_queue = scsi_alloc_queue(sdev);
 	if (!sdev->request_queue) {
 		/* release fn is set up in scsi_sysfs_device_initialise, so
 		 * have to free and put manually here */
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index c4e4875..d2661cb 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -531,6 +531,9 @@ struct scsi_host_template {
 	 */
 	unsigned int cmd_size;
 	struct scsi_host_cmd_pool *cmd_pool;
+
+	/* temporary flag to use blk-mq I/O path */
+	bool use_blk_mq;
 };
 
 /*
-- 
1.7.10.4


