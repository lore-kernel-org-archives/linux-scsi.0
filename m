From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/10] block: introduce blk_rq_is_passthrough
Date: Tue, 31 Jan 2017 16:57:29 +0100
Message-ID: <1485878251-6107-9-git-send-email-hch@lst.de>
References: <1485878251-6107-1-git-send-email-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1485878251-6107-1-git-send-email-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This can be used to check for fs vs non-fs requests and basically
removes all knowledge of BLOCK_PC specific from the block layer,
as well as preparing for removing the cmd_type field in struct request.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c                      |  8 ++++----
 block/blk-exec.c                      |  2 +-
 block/blk.h                           |  2 +-
 block/elevator.c                      |  4 ++--
 block/mq-deadline.c                   |  2 +-
 drivers/ata/libata-scsi.c             |  2 +-
 drivers/block/cciss.c                 | 36 +++++++++++++++++------------------
 drivers/nvme/host/fc.c                |  2 +-
 drivers/nvme/host/pci.c               |  4 ++--
 drivers/nvme/host/rdma.c              |  4 ++--
 drivers/nvme/target/loop.c            |  2 +-
 drivers/scsi/hpsa.c                   |  4 ++--
 drivers/scsi/scsi.c                   |  2 +-
 drivers/scsi/scsi_error.c             |  4 ++--
 drivers/scsi/scsi_lib.c               |  6 +++---
 drivers/scsi/smartpqi/smartpqi_init.c |  2 +-
 drivers/scsi/sun3_scsi.c              |  2 +-
 include/linux/blkdev.h                | 16 +++++++++++-----
 include/linux/blktrace_api.h          |  4 ++--
 include/scsi/scsi_cmnd.h              |  2 +-
 kernel/trace/blktrace.c               |  2 +-
 21 files changed, 59 insertions(+), 53 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index d0c50fc..f5c9f40 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2506,10 +2506,10 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 	 * TODO: tj: This is too subtle.  It would be better to let
 	 * low level drivers do what they see fit.
 	 */
-	if (req->cmd_type == REQ_TYPE_FS)
+	if (!blk_rq_is_passthrough(req))
 		req->errors = 0;
 
-	if (error && req->cmd_type == REQ_TYPE_FS &&
+	if (error && !blk_rq_is_passthrough(req) &&
 	    !(req->rq_flags & RQF_QUIET)) {
 		char *error_type;
 
@@ -2581,7 +2581,7 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 	req->__data_len -= total_bytes;
 
 	/* update sector only for requests with clear definition of sector */
-	if (req->cmd_type == REQ_TYPE_FS)
+	if (!blk_rq_is_passthrough(req))
 		req->__sector += total_bytes >> 9;
 
 	/* mixed attributes always follow the first bio */
@@ -2659,7 +2659,7 @@ void blk_finish_request(struct request *req, int error)
 
 	BUG_ON(blk_queued_rq(req));
 
-	if (unlikely(laptop_mode) && req->cmd_type == REQ_TYPE_FS)
+	if (unlikely(laptop_mode) && !blk_rq_is_passthrough(req))
 		laptop_io_completion(&req->q->backing_dev_info);
 
 	blk_delete_timer(req);
diff --git a/block/blk-exec.c b/block/blk-exec.c
index ed51800..8cd0e9b 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -51,7 +51,7 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 	int where = at_head ? ELEVATOR_INSERT_FRONT : ELEVATOR_INSERT_BACK;
 
 	WARN_ON(irqs_disabled());
-	WARN_ON(rq->cmd_type == REQ_TYPE_FS);
+	WARN_ON(!blk_rq_is_passthrough(rq));
 
 	rq->rq_disk = bd_disk;
 	rq->end_io = done;
diff --git a/block/blk.h b/block/blk.h
index 9a716b5..c1bd4bf 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -249,7 +249,7 @@ static inline int blk_do_io_stat(struct request *rq)
 {
 	return rq->rq_disk &&
 	       (rq->rq_flags & RQF_IO_STAT) &&
-		(rq->cmd_type == REQ_TYPE_FS);
+		!blk_rq_is_passthrough(rq);
 }
 
 /*
diff --git a/block/elevator.c b/block/elevator.c
index ef7f594..dba9be8 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -634,7 +634,7 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where)
 
 	if (rq->rq_flags & RQF_SOFTBARRIER) {
 		/* barriers are scheduling boundary, update end_sector */
-		if (rq->cmd_type == REQ_TYPE_FS) {
+		if (!blk_rq_is_passthrough(rq)) {
 			q->end_sector = rq_end_sector(rq);
 			q->boundary_rq = rq;
 		}
@@ -676,7 +676,7 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where)
 		if (elv_attempt_insert_merge(q, rq))
 			break;
 	case ELEVATOR_INSERT_SORT:
-		BUG_ON(rq->cmd_type != REQ_TYPE_FS);
+		BUG_ON(blk_rq_is_passthrough(rq));
 		rq->rq_flags |= RQF_SORTED;
 		q->nr_sorted++;
 		if (rq_mergeable(rq)) {
diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index d93ec71..4958353 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -398,7 +398,7 @@ static void dd_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
 	if (blk_mq_sched_bypass_insert(hctx, rq))
 		return;
 
-	if (at_head || rq->cmd_type != REQ_TYPE_FS) {
+	if (at_head || blk_rq_is_passthrough(rq)) {
 		if (at_head)
 			list_add(&rq->queuelist, &dd->dispatch);
 		else
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 6abd739..c771d4c 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1265,7 +1265,7 @@ static void ata_scsi_sdev_config(struct scsi_device *sdev)
  */
 static int atapi_drain_needed(struct request *rq)
 {
-	if (likely(rq->cmd_type != REQ_TYPE_BLOCK_PC))
+	if (likely(!blk_rq_is_passthrough(rq)))
 		return 0;
 
 	if (!blk_rq_bytes(rq) || op_is_write(req_op(rq)))
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index b93bb73..53dc297 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1854,7 +1854,7 @@ static void cciss_softirq_done(struct request *rq)
 	dev_dbg(&h->pdev->dev, "Done with %p\n", rq);
 
 	/* set the residual count for pc requests */
-	if (rq->cmd_type == REQ_TYPE_BLOCK_PC)
+	if (blk_rq_is_passthrough(rq))
 		scsi_req(rq)->resid_len = c->err_info->ResidualCnt;
 
 	blk_end_request_all(rq, (rq->errors == 0) ? 0 : -EIO);
@@ -3083,7 +3083,7 @@ static inline int evaluate_target_status(ctlr_info_t *h,
 	driver_byte = DRIVER_OK;
 	msg_byte = cmd->err_info->CommandStatus; /* correct?  seems too device specific */
 
-	if (cmd->rq->cmd_type == REQ_TYPE_BLOCK_PC)
+	if (blk_rq_is_passthrough(cmd->rq))
 		host_byte = DID_PASSTHROUGH;
 	else
 		host_byte = DID_OK;
@@ -3092,7 +3092,7 @@ static inline int evaluate_target_status(ctlr_info_t *h,
 		host_byte, driver_byte);
 
 	if (cmd->err_info->ScsiStatus != SAM_STAT_CHECK_CONDITION) {
-		if (cmd->rq->cmd_type != REQ_TYPE_BLOCK_PC)
+		if (!blk_rq_is_passthrough(cmd->rq))
 			dev_warn(&h->pdev->dev, "cmd %p "
 			       "has SCSI Status 0x%x\n",
 			       cmd, cmd->err_info->ScsiStatus);
@@ -3103,16 +3103,16 @@ static inline int evaluate_target_status(ctlr_info_t *h,
 	sense_key = 0xf & cmd->err_info->SenseInfo[2];
 	/* no status or recovered error */
 	if (((sense_key == 0x0) || (sense_key == 0x1)) &&
-	    (cmd->rq->cmd_type != REQ_TYPE_BLOCK_PC))
+	    !blk_rq_is_passthrough(cmd->rq))
 		error_value = 0;
 
 	if (check_for_unit_attention(h, cmd)) {
-		*retry_cmd = !(cmd->rq->cmd_type == REQ_TYPE_BLOCK_PC);
+		*retry_cmd = !blk_rq_is_passthrough(cmd->rq);
 		return 0;
 	}
 
 	/* Not SG_IO or similar? */
-	if (cmd->rq->cmd_type != REQ_TYPE_BLOCK_PC) {
+	if (!blk_rq_is_passthrough(cmd->rq)) {
 		if (error_value != 0)
 			dev_warn(&h->pdev->dev, "cmd %p has CHECK CONDITION"
 			       " sense key = 0x%x\n", cmd, sense_key);
@@ -3146,14 +3146,14 @@ static inline void complete_command(ctlr_info_t *h, CommandList_struct *cmd,
 		rq->errors = evaluate_target_status(h, cmd, &retry_cmd);
 		break;
 	case CMD_DATA_UNDERRUN:
-		if (cmd->rq->cmd_type == REQ_TYPE_FS) {
+		if (!blk_rq_is_passthrough(cmd->rq)) {
 			dev_warn(&h->pdev->dev, "cmd %p has"
 			       " completed with data underrun "
 			       "reported\n", cmd);
 		}
 		break;
 	case CMD_DATA_OVERRUN:
-		if (cmd->rq->cmd_type == REQ_TYPE_FS)
+		if (!blk_rq_is_passthrough(cmd->rq))
 			dev_warn(&h->pdev->dev, "cciss: cmd %p has"
 			       " completed with data overrun "
 			       "reported\n", cmd);
@@ -3163,7 +3163,7 @@ static inline void complete_command(ctlr_info_t *h, CommandList_struct *cmd,
 		       "reported invalid\n", cmd);
 		rq->errors = make_status_bytes(SAM_STAT_GOOD,
 			cmd->err_info->CommandStatus, DRIVER_OK,
-			(cmd->rq->cmd_type == REQ_TYPE_BLOCK_PC) ?
+			blk_rq_is_passthrough(cmd->rq) ?
 				DID_PASSTHROUGH : DID_ERROR);
 		break;
 	case CMD_PROTOCOL_ERR:
@@ -3171,7 +3171,7 @@ static inline void complete_command(ctlr_info_t *h, CommandList_struct *cmd,
 		       "protocol error\n", cmd);
 		rq->errors = make_status_bytes(SAM_STAT_GOOD,
 			cmd->err_info->CommandStatus, DRIVER_OK,
-			(cmd->rq->cmd_type == REQ_TYPE_BLOCK_PC) ?
+			blk_rq_is_passthrough(cmd->rq) ?
 				DID_PASSTHROUGH : DID_ERROR);
 		break;
 	case CMD_HARDWARE_ERR:
@@ -3179,7 +3179,7 @@ static inline void complete_command(ctlr_info_t *h, CommandList_struct *cmd,
 		       " hardware error\n", cmd);
 		rq->errors = make_status_bytes(SAM_STAT_GOOD,
 			cmd->err_info->CommandStatus, DRIVER_OK,
-			(cmd->rq->cmd_type == REQ_TYPE_BLOCK_PC) ?
+			blk_rq_is_passthrough(cmd->rq) ?
 				DID_PASSTHROUGH : DID_ERROR);
 		break;
 	case CMD_CONNECTION_LOST:
@@ -3187,7 +3187,7 @@ static inline void complete_command(ctlr_info_t *h, CommandList_struct *cmd,
 		       "connection lost\n", cmd);
 		rq->errors = make_status_bytes(SAM_STAT_GOOD,
 			cmd->err_info->CommandStatus, DRIVER_OK,
-			(cmd->rq->cmd_type == REQ_TYPE_BLOCK_PC) ?
+			blk_rq_is_passthrough(cmd->rq) ?
 				DID_PASSTHROUGH : DID_ERROR);
 		break;
 	case CMD_ABORTED:
@@ -3195,7 +3195,7 @@ static inline void complete_command(ctlr_info_t *h, CommandList_struct *cmd,
 		       "aborted\n", cmd);
 		rq->errors = make_status_bytes(SAM_STAT_GOOD,
 			cmd->err_info->CommandStatus, DRIVER_OK,
-			(cmd->rq->cmd_type == REQ_TYPE_BLOCK_PC) ?
+			blk_rq_is_passthrough(cmd->rq) ?
 				DID_PASSTHROUGH : DID_ABORT);
 		break;
 	case CMD_ABORT_FAILED:
@@ -3203,7 +3203,7 @@ static inline void complete_command(ctlr_info_t *h, CommandList_struct *cmd,
 		       "abort failed\n", cmd);
 		rq->errors = make_status_bytes(SAM_STAT_GOOD,
 			cmd->err_info->CommandStatus, DRIVER_OK,
-			(cmd->rq->cmd_type == REQ_TYPE_BLOCK_PC) ?
+			blk_rq_is_passthrough(cmd->rq) ?
 				DID_PASSTHROUGH : DID_ERROR);
 		break;
 	case CMD_UNSOLICITED_ABORT:
@@ -3218,21 +3218,21 @@ static inline void complete_command(ctlr_info_t *h, CommandList_struct *cmd,
 				"%p retried too many times\n", cmd);
 		rq->errors = make_status_bytes(SAM_STAT_GOOD,
 			cmd->err_info->CommandStatus, DRIVER_OK,
-			(cmd->rq->cmd_type == REQ_TYPE_BLOCK_PC) ?
+			blk_rq_is_passthrough(cmd->rq) ?
 				DID_PASSTHROUGH : DID_ABORT);
 		break;
 	case CMD_TIMEOUT:
 		dev_warn(&h->pdev->dev, "cmd %p timedout\n", cmd);
 		rq->errors = make_status_bytes(SAM_STAT_GOOD,
 			cmd->err_info->CommandStatus, DRIVER_OK,
-			(cmd->rq->cmd_type == REQ_TYPE_BLOCK_PC) ?
+			blk_rq_is_passthrough(cmd->rq) ?
 				DID_PASSTHROUGH : DID_ERROR);
 		break;
 	case CMD_UNABORTABLE:
 		dev_warn(&h->pdev->dev, "cmd %p unabortable\n", cmd);
 		rq->errors = make_status_bytes(SAM_STAT_GOOD,
 			cmd->err_info->CommandStatus, DRIVER_OK,
-			cmd->rq->cmd_type == REQ_TYPE_BLOCK_PC ?
+			blk_rq_is_passthrough(cmd->rq) ?
 				DID_PASSTHROUGH : DID_ERROR);
 		break;
 	default:
@@ -3241,7 +3241,7 @@ static inline void complete_command(ctlr_info_t *h, CommandList_struct *cmd,
 		       cmd->err_info->CommandStatus);
 		rq->errors = make_status_bytes(SAM_STAT_GOOD,
 			cmd->err_info->CommandStatus, DRIVER_OK,
-			(cmd->rq->cmd_type == REQ_TYPE_BLOCK_PC) ?
+			blk_rq_is_passthrough(cmd->rq) ?
 				DID_PASSTHROUGH : DID_ERROR);
 	}
 
diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index fcc9dcf..40c979b 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -1937,7 +1937,7 @@ nvme_fc_complete_rq(struct request *rq)
 			return;
 		}
 
-		if (rq->cmd_type == REQ_TYPE_DRV_PRIV)
+		if (blk_rq_is_passthrough(rq))
 			error = rq->errors;
 		else
 			error = nvme_error_status(rq->errors);
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 7103bce..f29365b 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -588,7 +588,7 @@ static int nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
 	 */
 	if (ns && ns->ms && !blk_integrity_rq(req)) {
 		if (!(ns->pi_type && ns->ms == 8) &&
-					req->cmd_type != REQ_TYPE_DRV_PRIV) {
+		    !blk_rq_is_passthrough(req)) {
 			blk_mq_end_request(req, -EFAULT);
 			return BLK_MQ_RQ_QUEUE_OK;
 		}
@@ -645,7 +645,7 @@ static void nvme_complete_rq(struct request *req)
 			return;
 		}
 
-		if (req->cmd_type == REQ_TYPE_DRV_PRIV)
+		if (blk_rq_is_passthrough(req))
 			error = req->errors;
 		else
 			error = nvme_error_status(req->errors);
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 557f29b..ecc79b2 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1423,7 +1423,7 @@ static inline bool nvme_rdma_queue_is_ready(struct nvme_rdma_queue *queue,
 	if (unlikely(!test_bit(NVME_RDMA_Q_LIVE, &queue->flags))) {
 		struct nvme_command *cmd = nvme_req(rq)->cmd;
 
-		if (rq->cmd_type != REQ_TYPE_DRV_PRIV ||
+		if (!blk_rq_is_passthrough(rq) ||
 		    cmd->common.opcode != nvme_fabrics_command ||
 		    cmd->fabrics.fctype != nvme_fabrics_type_connect)
 			return false;
@@ -1522,7 +1522,7 @@ static void nvme_rdma_complete_rq(struct request *rq)
 			return;
 		}
 
-		if (rq->cmd_type == REQ_TYPE_DRV_PRIV)
+		if (blk_rq_is_passthrough(rq))
 			error = rq->errors;
 		else
 			error = nvme_error_status(rq->errors);
diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
index 9aaa700..f3862e3 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -104,7 +104,7 @@ static void nvme_loop_complete_rq(struct request *req)
 			return;
 		}
 
-		if (req->cmd_type == REQ_TYPE_DRV_PRIV)
+		if (blk_rq_is_passthrough(req))
 			error = req->errors;
 		else
 			error = nvme_error_status(req->errors);
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index cbc0c5f..c611412 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5539,8 +5539,8 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 	 * Retries always go down the normal I/O path.
 	 */
 	if (likely(cmd->retries == 0 &&
-		cmd->request->cmd_type == REQ_TYPE_FS &&
-		h->acciopath_status)) {
+			!blk_rq_is_passthrough(cmd->request) &&
+			h->acciopath_status)) {
 		rc = hpsa_ioaccel_submit(h, c, cmd, scsi3addr);
 		if (rc == 0)
 			return 0;
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 3d8d215..7bfbcfa 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -238,7 +238,7 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
 				"(result %x)\n", cmd->result));
 
 	good_bytes = scsi_bufflen(cmd);
-        if (cmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
+        if (!blk_rq_is_passthrough(cmd->request)) {
 		int old_good_bytes = good_bytes;
 		drv = scsi_cmd_to_driver(cmd);
 		if (drv->done)
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 4b40f74..b4ce7bb 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1106,7 +1106,7 @@ static int scsi_request_sense(struct scsi_cmnd *scmd)
 
 static int scsi_eh_action(struct scsi_cmnd *scmd, int rtn)
 {
-	if (scmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
+	if (!blk_rq_is_passthrough(scmd->request)) {
 		struct scsi_driver *sdrv = scsi_cmd_to_driver(scmd);
 		if (sdrv->eh_action)
 			rtn = sdrv->eh_action(scmd, rtn);
@@ -1746,7 +1746,7 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd)
 	 * the check condition was retryable.
 	 */
 	if (scmd->request->cmd_flags & REQ_FAILFAST_DEV ||
-	    scmd->request->cmd_type == REQ_TYPE_BLOCK_PC)
+	    blk_rq_is_passthrough(scmd->request))
 		return 1;
 	else
 		return 0;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 8188e5c..31629a7 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -582,7 +582,7 @@ void scsi_run_host_queues(struct Scsi_Host *shost)
 
 static void scsi_uninit_cmd(struct scsi_cmnd *cmd)
 {
-	if (cmd->request->cmd_type == REQ_TYPE_FS) {
+	if (!blk_rq_is_passthrough(cmd->request)) {
 		struct scsi_driver *drv = scsi_cmd_to_driver(cmd);
 
 		if (drv->uninit_command)
@@ -806,7 +806,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			sense_deferred = scsi_sense_is_deferred(&sshdr);
 	}
 
-	if (req->cmd_type == REQ_TYPE_BLOCK_PC) { /* SG_IO ioctl from block level */
+	if (blk_rq_is_passthrough(req)) {
 		if (result) {
 			if (sense_valid) {
 				/*
@@ -847,7 +847,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		error = __scsi_error_from_host_byte(cmd, result);
 	}
 
-	/* no bidi support for !REQ_TYPE_BLOCK_PC yet */
+	/* no bidi support for !blk_rq_is_passthrough yet */
 	BUG_ON(blk_bidi_rq(req));
 
 	/*
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 8702d9c..11c0dfb 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -4499,7 +4499,7 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost,
 	if (pqi_is_logical_device(device)) {
 		raid_bypassed = false;
 		if (device->offload_enabled &&
-			scmd->request->cmd_type == REQ_TYPE_FS) {
+				!blk_rq_is_passthrough(scmd->request)) {
 			rc = pqi_raid_bypass_submit_scsi_cmd(ctrl_info, device,
 				scmd, queue_group);
 			if (rc == 0 ||
diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
index 88db699..bcf7d05 100644
--- a/drivers/scsi/sun3_scsi.c
+++ b/drivers/scsi/sun3_scsi.c
@@ -260,7 +260,7 @@ static int sun3scsi_dma_xfer_len(struct NCR5380_hostdata *hostdata,
 {
 	int wanted_len = cmd->SCp.this_residual;
 
-	if (wanted_len < DMA_MIN_SIZE || cmd->request->cmd_type != REQ_TYPE_FS)
+	if (wanted_len < DMA_MIN_SIZE || blk_rq_is_passthrough(cmd->request))
 		return 0;
 
 	return wanted_len;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e4c5f28..7121be0 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -242,6 +242,11 @@ struct request {
 	struct request *next_rq;
 };
 
+static inline bool blk_rq_is_passthrough(struct request *rq)
+{
+	return rq->cmd_type != REQ_TYPE_FS;
+}
+
 static inline unsigned short req_get_ioprio(struct request *req)
 {
 	return req->ioprio;
@@ -698,9 +703,10 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 	((rq)->cmd_flags & (REQ_FAILFAST_DEV|REQ_FAILFAST_TRANSPORT| \
 			     REQ_FAILFAST_DRIVER))
 
-#define blk_account_rq(rq) \
-	(((rq)->rq_flags & RQF_STARTED) && \
-	 ((rq)->cmd_type == REQ_TYPE_FS))
+static inline bool blk_account_rq(struct request *rq)
+{
+	return (rq->rq_flags & RQF_STARTED) && !blk_rq_is_passthrough(rq);
+}
 
 #define blk_rq_cpu_valid(rq)	((rq)->cpu != -1)
 #define blk_bidi_rq(rq)		((rq)->next_rq != NULL)
@@ -775,7 +781,7 @@ static inline void blk_clear_rl_full(struct request_list *rl, bool sync)
 
 static inline bool rq_mergeable(struct request *rq)
 {
-	if (rq->cmd_type != REQ_TYPE_FS)
+	if (blk_rq_is_passthrough(rq))
 		return false;
 
 	if (req_op(rq) == REQ_OP_FLUSH)
@@ -1049,7 +1055,7 @@ static inline unsigned int blk_rq_get_max_sectors(struct request *rq,
 {
 	struct request_queue *q = rq->q;
 
-	if (unlikely(rq->cmd_type != REQ_TYPE_FS))
+	if (blk_rq_is_passthrough(rq))
 		return q->limits.max_hw_sectors;
 
 	if (!q->limits.chunk_sectors ||
diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index a143a67..341f941 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -114,12 +114,12 @@ extern void blk_fill_rwbs(char *rwbs, unsigned int op, int bytes);
 
 static inline sector_t blk_rq_trace_sector(struct request *rq)
 {
-	return (rq->cmd_type != REQ_TYPE_FS) ? 0 : blk_rq_pos(rq);
+	return blk_rq_is_passthrough(rq) ? 0 : blk_rq_pos(rq);
 }
 
 static inline unsigned int blk_rq_trace_nr_sectors(struct request *rq)
 {
-	return (rq->cmd_type != REQ_TYPE_FS) ? 0 : blk_rq_sectors(rq);
+	return blk_rq_is_passthrough(rq) ? 0 : blk_rq_sectors(rq);
 }
 
 #endif
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index f708f1a..b379f93 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -151,7 +151,7 @@ static inline void *scsi_cmd_priv(struct scsi_cmnd *cmd)
 	return cmd + 1;
 }
 
-/* make sure not to use it with REQ_TYPE_BLOCK_PC commands */
+/* make sure not to use it with passthrough commands */
 static inline struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
 {
 	return *(struct scsi_driver **)cmd->request->rq_disk->private_data;
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 512b347..e33050e 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -712,7 +712,7 @@ static void blk_add_trace_rq(struct request_queue *q, struct request *rq,
 	if (likely(!bt))
 		return;
 
-	if (rq->cmd_type != REQ_TYPE_FS)
+	if (blk_rq_is_passthrough(rq))
 		what |= BLK_TC_ACT(BLK_TC_PC);
 	else
 		what |= BLK_TC_ACT(BLK_TC_FS);
-- 
2.1.4

