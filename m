From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 33/39] scsi: initial blk-mq support
Date: Mon, 17 Mar 2014 06:28:06 -0700
Message-ID: <20140317133136.393238629@bombadil.infradead.org>
References: <20140317132733.789623766@bombadil.infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=0033-scsi-initial-blk-mq-support.patch
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Add support for using the blk-mq code to submit requests to SCSI
drivers.  There is very little blk-mq specific code, because we
try to push most things out to the block layer.

Based on the earlier scsi-mq prototype by Nicholas Bellinger, although
not a whole lot of actual code is left.

Not-quite-signed-off-yet-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi.c      |   13 +-
 drivers/scsi/scsi_lib.c  |  355 +++++++++++++++++++++++++++++++++++++++++-----
 drivers/scsi/scsi_priv.h |    1 +
 drivers/scsi/scsi_scan.c |    5 +-
 include/scsi/scsi_host.h |    3 +
 5 files changed, 338 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 0df3913..7672371 100644
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
@@ -462,6 +463,10 @@ int scsi_setup_command_freelist(struct Scsi_Host *shost)
 	spin_lock_init(&shost->free_list_lock);
 	INIT_LIST_HEAD(&shost->free_list);
 
+	/* blk-mq uses a block-level allocator */
+	if (shost->hostt->use_blk_mq)
+		return 0;
+
 	shost->cmd_pool = scsi_get_host_cmd_pool(shost);
 	if (!shost->cmd_pool)
 		return -ENOMEM;
@@ -720,8 +725,14 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
  */
 static void scsi_done(struct scsi_cmnd *cmd)
 {
+	struct request *req = cmd->request;
+
 	trace_scsi_dispatch_cmd_done(cmd);
-	blk_complete_request(cmd->request);
+
+	if (req->mq_ctx)
+		blk_mq_complete_request(req);
+	else
+		blk_complete_request(req);
 }
 
 /**
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 94d5893..836f197 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -20,6 +20,7 @@
 #include <linux/delay.h>
 #include <linux/hardirq.h>
 #include <linux/scatterlist.h>
+#include <linux/blk-mq.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -111,6 +112,21 @@ scsi_set_blocked(struct scsi_cmnd *cmd, int reason)
 	}
 }
 
+static void scsi_mq_requeue_work(struct work_struct *work)
+{
+	struct request *rq = container_of(work, struct request, mq_flush_work);
+	struct scsi_cmnd *cmd = rq->special;
+
+	blk_mq_insert_request(rq, true, true, false);
+	put_device(&cmd->device->sdev_gendev);
+}
+
+static void scsi_mq_requeue_request(struct request *rq)
+{
+	INIT_WORK(&rq->mq_flush_work, scsi_mq_requeue_work);
+	kblockd_schedule_work(rq->q, &rq->mq_flush_work);
+}
+
 /**
  * __scsi_queue_insert - private queue insertion
  * @cmd: The SCSI command being requeued
@@ -147,6 +163,11 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
 	 * lock such that the kblockd_schedule_work() call happens
 	 * before blk_cleanup_queue() finishes.
 	 */
+	if (q->mq_ops) {
+		cmd->request->cmd_flags |= REQ_DONTPREP;
+		scsi_mq_requeue_request(cmd->request);
+		return;
+	}
 	spin_lock_irqsave(q->queue_lock, flags);
 	blk_requeue_request(q, cmd->request);
 	kblockd_schedule_work(q, &device->requeue_work);
@@ -304,6 +325,14 @@ void scsi_device_unbusy(struct scsi_device *sdev)
 	atomic_dec(&sdev->device_busy);
 }
 
+static void __scsi_kick_queue(struct request_queue *q)
+{
+	if (q->mq_ops)
+		blk_mq_start_stopped_hw_queues(q, false);
+	else
+		blk_run_queue(q);
+}
+
 /*
  * Called for single_lun devices on IO completion. Clear starget_sdev_user,
  * and call blk_run_queue for all the scsi_devices on the target -
@@ -328,7 +357,7 @@ static void scsi_single_lun_run(struct scsi_device *current_sdev)
 	 * but in most cases, we will be first. Ideally, each LU on the
 	 * target would get some limited time or requests on the target.
 	 */
-	blk_run_queue(current_sdev->request_queue);
+	__scsi_kick_queue(current_sdev->request_queue);
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (starget->starget_sdev_user)
@@ -341,7 +370,7 @@ static void scsi_single_lun_run(struct scsi_device *current_sdev)
 			continue;
 
 		spin_unlock_irqrestore(shost->host_lock, flags);
-		blk_run_queue(sdev->request_queue);
+		__scsi_kick_queue(sdev->request_queue);
 		spin_lock_irqsave(shost->host_lock, flags);
 	
 		scsi_device_put(sdev);
@@ -434,7 +463,7 @@ static void scsi_starved_list_run(struct Scsi_Host *shost)
 			continue;
 		spin_unlock_irqrestore(shost->host_lock, flags);
 
-		blk_run_queue(slq);
+		__scsi_kick_queue(slq);
 		blk_put_queue(slq);
 
 		spin_lock_irqsave(shost->host_lock, flags);
@@ -465,7 +494,7 @@ static void scsi_run_queue(struct request_queue *q)
 	if (!list_empty(&sdev->host->starved_list))
 		scsi_starved_list_run(sdev->host);
 
-	blk_run_queue(q);
+	__scsi_kick_queue(q);
 }
 
 void scsi_requeue_run_queue(struct work_struct *work)
@@ -476,6 +505,9 @@ void scsi_requeue_run_queue(struct work_struct *work)
 	sdev = container_of(work, struct scsi_device, requeue_work);
 	q = sdev->request_queue;
 	scsi_run_queue(q);
+
+	if (q->mq_ops)
+		put_device(&sdev->sdev_gendev);
 }
 
 static void scsi_uninit_command(struct scsi_cmnd *cmd)
@@ -545,6 +577,13 @@ void scsi_run_host_queues(struct Scsi_Host *shost)
 		scsi_run_queue(sdev->request_queue);
 }
 
+static bool scsi_end_request(struct request *req, int error, unsigned int bytes)
+{
+	if (req->mq_ctx)
+		return blk_mq_end_io_partial(req, error, bytes);
+	return blk_end_request(req, error, bytes);
+}
+
 static inline unsigned int scsi_sgtable_index(unsigned short nents)
 {
 	unsigned int index;
@@ -705,14 +744,16 @@ static int __scsi_error_from_host_byte(struct scsi_cmnd *cmd, int result)
  *		   be put back on the queue and retried using the same
  *		   command as before, possibly after a delay.
  *
- *		c) We can call blk_end_request() with -EIO to fail
+ *		c) We can call scsi_end_request() with -EIO to fail
  *		   the remainder of the request.
  */
 void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 {
 	int result = cmd->result;
-	struct request_queue *q = cmd->device->request_queue;
+	struct scsi_device *sdev = cmd->device;
+	struct request_queue *q = sdev->request_queue;
 	struct request *req = cmd->request;
+	bool is_mq = !!q->mq_ops;
 	int error = 0;
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
@@ -801,14 +842,14 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	/*
 	 * If we finished all bytes in the request we are done now.
 	 */
-	if (!blk_end_request(req, error, good_bytes))
+	if (!scsi_end_request(req, error, good_bytes))
 		goto next_command;
 
 	/*
 	 * Kill remainder if no retrys.
 	 */
 	if (error && scsi_noretry_cmd(cmd)) {
-		blk_end_request(req, error, blk_rq_bytes(req));
+		scsi_end_request(req, error, blk_rq_bytes(req));
 		goto next_command;
 	}
 
@@ -830,11 +871,11 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	} else if (sense_valid && !sense_deferred) {
 		switch (sshdr.sense_key) {
 		case UNIT_ATTENTION:
-			if (cmd->device->removable) {
+			if (sdev->removable) {
 				/* Detected disc change.  Set a bit
 				 * and quietly refuse further access.
 				 */
-				cmd->device->changed = 1;
+				sdev->changed = 1;
 				description = "Media Changed";
 				action = ACTION_FAIL;
 			} else {
@@ -948,7 +989,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 				scsi_print_sense("", cmd);
 			scsi_print_command(cmd);
 		}
-		if (!blk_end_request(req, error, blk_rq_err_bytes(req)))
+		if (!scsi_end_request(req, error, blk_rq_err_bytes(req)))
 			goto next_command;
 		/*FALLTHRU*/
 	case ACTION_REPREP:
@@ -956,8 +997,14 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		/* Unprep the request and put it back at the head of the queue.
 		 * A new command will be prepared and issued.
 		 */
-		scsi_release_buffers(cmd);
-		scsi_requeue_command(q, cmd);
+		if (is_mq) {
+			cancel_delayed_work(&cmd->abort_work);
+			scsi_uninit_command(cmd);
+			scsi_mq_requeue_request(req);
+		} else {
+			scsi_release_buffers(cmd);
+			scsi_requeue_command(q, cmd);
+		}
 		break;
 	case ACTION_RETRY:
 		/* Retry the same command immediately */
@@ -971,8 +1018,12 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	return;
 
 next_command:
-	scsi_release_buffers(cmd);
-	scsi_next_command(cmd);
+	if (is_mq) {
+		kblockd_schedule_work(q, &sdev->requeue_work);
+	} else {
+		scsi_release_buffers(cmd);
+		scsi_next_command(cmd);
+	}
 }
 
 static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb,
@@ -980,12 +1031,17 @@ static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb,
 {
 	int count;
 
-	/*
-	 * If sg table allocation fails, requeue request later.
-	 */
-	if (unlikely(scsi_alloc_sgtable(sdb, req->nr_phys_segments,
-					gfp_mask))) {
-		return BLKPREP_DEFER;
+	if (!req->mq_ctx) {
+		/*
+		 * If sg table allocation fails, requeue request later.
+		 */
+		if (unlikely(scsi_alloc_sgtable(sdb, req->nr_phys_segments,
+						gfp_mask)))
+			return BLKPREP_DEFER;
+	} else {
+		BUG_ON(req->nr_phys_segments > SCSI_MAX_SG_SEGMENTS);
+		sdb->table.nents = req->nr_phys_segments;
+		sg_init_table(sdb->table.sgl, sdb->table.nents);
 	}
 
 	req->buffer = NULL;
@@ -1041,9 +1097,11 @@ int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
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
@@ -1635,6 +1693,123 @@ out_delay:
 		blk_delay_queue(q, SCSI_QUEUE_DELAY);
 }
 
+static int scsi_mq_prep_fn(struct request *req)
+{
+	struct scsi_cmnd *cmd = req->special;
+	struct scsi_device *sdev = req->q->queuedata;
+	struct Scsi_Host *shost = sdev->host;
+	unsigned char *sense_buf = cmd->sense_buffer;
+	struct scatterlist *sg;
+	int ret;
+
+	memset(sense_buf, 0, SCSI_SENSE_BUFFERSIZE);
+	memset(cmd, 0, sizeof(struct scsi_cmnd));
+
+	cmd->request = req;
+	cmd->device = sdev;
+	cmd->sense_buffer = sense_buf;
+
+	cmd->tag = req->tag;
+	cmd->cmnd = req->cmd;
+	cmd->prot_op = SCSI_PROT_NORMAL;
+
+	INIT_LIST_HEAD(&cmd->list);
+	INIT_DELAYED_WORK(&cmd->abort_work, scmd_eh_abort_handler);
+	cmd->jiffies_at_alloc = jiffies;
+	/* XXX: add to sdev->cmd_list here */
+
+	sg = (void *)cmd + sizeof(struct scsi_cmnd) + shost->hostt->cmd_size;
+	cmd->sdb.table.sgl = sg;
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
+		return BLK_MQ_RQ_QUEUE_ERROR;
+	}
+}
+
+static int scsi_mq_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
+{
+	struct request_queue *q = req->q;
+	struct scsi_device *sdev = q->queuedata;
+	struct Scsi_Host *shost = sdev->host;
+	struct scsi_cmnd *cmd = req->special;
+	int ret = BLK_MQ_RQ_QUEUE_BUSY;
+	int reason;
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
+	if (!(req->cmd_flags & REQ_DONTPREP)) {
+		ret = scsi_mq_prep_fn(req);
+		if (ret)
+			goto out_dec_host_busy;
+	}
+	req->cmd_flags &= ~REQ_DONTPREP;
+
+	scsi_init_cmd_errh(cmd);
+
+	reason = scsi_dispatch_cmd(cmd);
+	if (reason) {
+		scsi_set_blocked(cmd, reason);
+		ret = BLK_MQ_RQ_QUEUE_BUSY;
+		goto out_uninit;
+	}
+
+	return BLK_MQ_RQ_QUEUE_OK;
+
+out_uninit:
+	scsi_uninit_command(cmd);
+out_dec_host_busy:
+	cancel_delayed_work(&cmd->abort_work);
+	atomic_dec(&shost->host_busy);
+out_dec_target_busy:
+	atomic_dec(&scsi_target(sdev)->target_busy);
+out_dec_device_busy:
+	atomic_dec(&sdev->device_busy);
+out_put_device:
+	put_device(&sdev->sdev_gendev);
+out:
+	if (ret == BLK_MQ_RQ_QUEUE_BUSY) {
+		blk_mq_stop_hw_queue(hctx);
+		if (atomic_read(&sdev->device_busy) == 0 &&
+		    !scsi_device_blocked(sdev))
+		    	blk_delay_queue(q, SCSI_QUEUE_DELAY);
+	}
+	return ret;
+}
+
 u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
 {
 	struct device *host_dev;
@@ -1657,16 +1832,10 @@ u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
 }
 EXPORT_SYMBOL(scsi_calculate_bounce_limit);
 
-struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
-					 request_fn_proc *request_fn)
+static void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
 {
-	struct request_queue *q;
 	struct device *dev = shost->dma_dev;
 
-	q = blk_init_queue(request_fn, NULL);
-	if (!q)
-		return NULL;
-
 	/*
 	 * this limit is imposed by hardware restrictions
 	 */
@@ -1697,7 +1866,17 @@ struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
 	 * blk_queue_update_dma_alignment() later.
 	 */
 	blk_queue_dma_alignment(q, 0x03);
+}
 
+struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
+					 request_fn_proc *request_fn)
+{
+	struct request_queue *q;
+
+	q = blk_init_queue(request_fn, NULL);
+	if (!q)
+		return NULL;
+	__scsi_init_queue(shost, q);
 	return q;
 }
 EXPORT_SYMBOL(__scsi_alloc_queue);
@@ -1717,6 +1896,100 @@ struct request_queue *scsi_alloc_queue(struct scsi_device *sdev)
 	return q;
 }
 
+static struct blk_mq_ops scsi_mq_ops = {
+	.queue_rq	= scsi_mq_queue_rq,
+	.map_queue	= blk_mq_map_queue,
+	.alloc_hctx	= blk_mq_alloc_single_hw_queue,
+	.free_hctx	= blk_mq_free_single_hw_queue,
+	.complete	= scsi_softirq_done,
+	.timeout	= scsi_times_out,
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
@@ -2462,9 +2735,13 @@ scsi_internal_device_block(struct scsi_device *sdev)
 	 * block layer from calling the midlayer with this device's
 	 * request queue. 
 	 */
-	spin_lock_irqsave(q->queue_lock, flags);
-	blk_stop_queue(q);
-	spin_unlock_irqrestore(q->queue_lock, flags);
+	if (q->mq_ops) {
+		blk_mq_stop_hw_queues(q);
+	} else {
+		spin_lock_irqsave(q->queue_lock, flags);
+		blk_stop_queue(q);
+		spin_unlock_irqrestore(q->queue_lock, flags);
+	}
 
 	return 0;
 }
@@ -2510,9 +2787,13 @@ scsi_internal_device_unblock(struct scsi_device *sdev,
 		 sdev->sdev_state != SDEV_OFFLINE)
 		return -EINVAL;
 
-	spin_lock_irqsave(q->queue_lock, flags);
-	blk_start_queue(q);
-	spin_unlock_irqrestore(q->queue_lock, flags);
+	if (q->mq_ops) {
+		blk_mq_start_stopped_hw_queues(q, false);
+	} else {
+		spin_lock_irqsave(q->queue_lock, flags);
+		blk_start_queue(q);
+		spin_unlock_irqrestore(q->queue_lock, flags);
+	}
 
 	return 0;
 }
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index f079a59..d63c87e 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -88,6 +88,7 @@ extern void scsi_next_command(struct scsi_cmnd *cmd);
 extern void scsi_io_completion(struct scsi_cmnd *, unsigned int);
 extern void scsi_run_host_queues(struct Scsi_Host *shost);
 extern struct request_queue *scsi_alloc_queue(struct scsi_device *sdev);
+extern struct request_queue *scsi_mq_alloc_queue(struct scsi_device *sdev);
 extern int scsi_init_queue(void);
 extern void scsi_exit_queue(void);
 struct request_queue;
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
