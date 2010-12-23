From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: [RFC 1/8] IB/srp: allow task management without a previous request
Date: Thu, 23 Dec 2010 16:31:26 -0500
Message-ID: <1293139893-11678-2-git-send-email-dillowda@ornl.gov>
References: <1293139893-11678-1-git-send-email-dillowda@ornl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1293139893-11678-1-git-send-email-dillowda-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

We can only have one task management comment outstanding, so move the
completion and status to the target port. This allows us to handle
resets of a LUN without a corresponding request having been sent.
Meanwhile, we don't need to play games with host_scribble, just use it
as the pointer it is.

This fixes a crash when we issue a bus reset using sg_reset.

Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=13893
Signed-off-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   90 ++++++++++++----------------------
 drivers/infiniband/ulp/srp/ib_srp.h |   10 ++--
 2 files changed, 37 insertions(+), 63 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 1e1e347..95fb9f0 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -542,6 +542,7 @@ static void srp_unmap_data(struct scsi_cmnd *scmnd,
 static void srp_remove_req(struct srp_target_port *target, struct srp_request *req)
 {
 	srp_unmap_data(req->scmnd, target, req);
+	req->scmnd = NULL;
 	list_move_tail(&req->list, &target->free_reqs);
 }
 
@@ -925,15 +926,13 @@ static void srp_process_rsp(struct srp_target_port *target, struct srp_rsp *rsp)
 
 	target->req_lim += delta;
 
-	req = &target->req_ring[rsp->tag & ~SRP_TAG_TSK_MGMT];
-
 	if (unlikely(rsp->tag & SRP_TAG_TSK_MGMT)) {
-		if (be32_to_cpu(rsp->resp_data_len) < 4)
-			req->tsk_status = -1;
-		else
-			req->tsk_status = rsp->data[3];
-		complete(&req->done);
+		target->tsk_mgmt_status = -1;
+		if (be32_to_cpu(rsp->resp_data_len) >= 4)
+			target->tsk_mgmt_status = rsp->data[3];
+		complete(&target->tsk_mgmt_done);
 	} else {
+		req = &target->req_ring[rsp->tag];
 		scmnd = req->scmnd;
 		if (!scmnd)
 			shost_printk(KERN_ERR, target->scsi_host,
@@ -953,13 +952,9 @@ static void srp_process_rsp(struct srp_target_port *target, struct srp_rsp *rsp)
 		else if (rsp->flags & (SRP_RSP_FLAG_DIOVER | SRP_RSP_FLAG_DIUNDER))
 			scsi_set_resid(scmnd, be32_to_cpu(rsp->data_in_res_cnt));
 
-		if (!req->tsk_mgmt) {
-			scmnd->host_scribble = (void *) -1L;
-			scmnd->scsi_done(scmnd);
-
-			srp_remove_req(target, req);
-		} else
-			req->cmd_done = 1;
+		scmnd->host_scribble = NULL;
+		scmnd->scsi_done(scmnd);
+		srp_remove_req(target, req);
 	}
 
 	spin_unlock_irqrestore(target->scsi_host->host_lock, flags);
@@ -1155,7 +1150,7 @@ static int srp_queuecommand_lck(struct scsi_cmnd *scmnd,
 
 	scmnd->scsi_done     = done;
 	scmnd->result        = 0;
-	scmnd->host_scribble = (void *) (long) req->index;
+	scmnd->host_scribble = (void *) req;
 
 	cmd = iu->buf;
 	memset(cmd, 0, sizeof *cmd);
@@ -1167,8 +1162,6 @@ static int srp_queuecommand_lck(struct scsi_cmnd *scmnd,
 
 	req->scmnd    = scmnd;
 	req->cmd      = iu;
-	req->cmd_done = 0;
-	req->tsk_mgmt = NULL;
 
 	len = srp_map_data(scmnd, target, req);
 	if (len < 0) {
@@ -1442,7 +1435,7 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 }
 
 static int srp_send_tsk_mgmt(struct srp_target_port *target,
-			     struct srp_request *req, u8 func)
+			     u64 req_tag, unsigned int lun, u8 func)
 {
 	struct ib_device *dev = target->srp_host->srp_dev->dev;
 	struct srp_iu *iu;
@@ -1451,12 +1444,10 @@ static int srp_send_tsk_mgmt(struct srp_target_port *target,
 	spin_lock_irq(target->scsi_host->host_lock);
 
 	if (target->state == SRP_TARGET_DEAD ||
-	    target->state == SRP_TARGET_REMOVED) {
-		req->scmnd->result = DID_BAD_TARGET << 16;
+	    target->state == SRP_TARGET_REMOVED)
 		goto out;
-	}
 
-	init_completion(&req->done);
+	init_completion(&target->tsk_mgmt_done);
 
 	iu = __srp_get_tx_iu(target, SRP_IU_TSK_MGMT);
 	if (!iu)
@@ -1468,21 +1459,19 @@ static int srp_send_tsk_mgmt(struct srp_target_port *target,
 	memset(tsk_mgmt, 0, sizeof *tsk_mgmt);
 
 	tsk_mgmt->opcode 	= SRP_TSK_MGMT;
-	tsk_mgmt->lun 		= cpu_to_be64((u64) req->scmnd->device->lun << 48);
-	tsk_mgmt->tag 		= req->index | SRP_TAG_TSK_MGMT;
+	tsk_mgmt->lun 		= cpu_to_be64((u64) lun << 48);
+	tsk_mgmt->tag 		= req_tag | SRP_TAG_TSK_MGMT;
 	tsk_mgmt->tsk_mgmt_func = func;
-	tsk_mgmt->task_tag 	= req->index;
+	tsk_mgmt->task_tag 	= req_tag;
 
 	ib_dma_sync_single_for_device(dev, iu->dma, sizeof *tsk_mgmt,
 				      DMA_TO_DEVICE);
 	if (__srp_post_send(target, iu, sizeof *tsk_mgmt))
 		goto out;
 
-	req->tsk_mgmt = iu;
-
 	spin_unlock_irq(target->scsi_host->host_lock);
 
-	if (!wait_for_completion_timeout(&req->done,
+	if (!wait_for_completion_timeout(&target->tsk_mgmt_done,
 					 msecs_to_jiffies(SRP_ABORT_TIMEOUT_MS)))
 		return -1;
 
@@ -1493,43 +1482,29 @@ out:
 	return -1;
 }
 
-static int srp_find_req(struct srp_target_port *target,
-			struct scsi_cmnd *scmnd,
-			struct srp_request **req)
-{
-	if (scmnd->host_scribble == (void *) -1L)
-		return -1;
-
-	*req = &target->req_ring[(long) scmnd->host_scribble];
-
-	return 0;
-}
-
 static int srp_abort(struct scsi_cmnd *scmnd)
 {
 	struct srp_target_port *target = host_to_target(scmnd->device->host);
-	struct srp_request *req;
+	struct srp_request *req = (struct srp_request *) scmnd->host_scribble;
 	int ret = SUCCESS;
 
 	shost_printk(KERN_ERR, target->scsi_host, "SRP abort called\n");
 
-	if (target->qp_in_error)
-		return FAILED;
-	if (srp_find_req(target, scmnd, &req))
+	if (!req || target->qp_in_error)
 		return FAILED;
-	if (srp_send_tsk_mgmt(target, req, SRP_TSK_ABORT_TASK))
+	if (srp_send_tsk_mgmt(target, req->index, scmnd->device->lun,
+			      SRP_TSK_ABORT_TASK))
 		return FAILED;
 
 	spin_lock_irq(target->scsi_host->host_lock);
 
-	if (req->cmd_done) {
-		srp_remove_req(target, req);
-		scmnd->scsi_done(scmnd);
-	} else if (!req->tsk_status) {
-		srp_remove_req(target, req);
-		scmnd->result = DID_ABORT << 16;
-	} else
-		ret = FAILED;
+	if (req->scmnd) {
+		if (!target->tsk_mgmt_status) {
+			srp_remove_req(target, req);
+			scmnd->result = DID_ABORT << 16;
+		} else
+			ret = FAILED;
+	}
 
 	spin_unlock_irq(target->scsi_host->host_lock);
 
@@ -1545,17 +1520,16 @@ static int srp_reset_device(struct scsi_cmnd *scmnd)
 
 	if (target->qp_in_error)
 		return FAILED;
-	if (srp_find_req(target, scmnd, &req))
-		return FAILED;
-	if (srp_send_tsk_mgmt(target, req, SRP_TSK_LUN_RESET))
+	if (srp_send_tsk_mgmt(target, SRP_TAG_NO_REQ, scmnd->device->lun,
+			      SRP_TSK_LUN_RESET))
 		return FAILED;
-	if (req->tsk_status)
+	if (target->tsk_mgmt_status)
 		return FAILED;
 
 	spin_lock_irq(target->scsi_host->host_lock);
 
 	list_for_each_entry_safe(req, tmp, &target->req_queue, list)
-		if (req->scmnd->device == scmnd->device)
+		if (req->scmnd && req->scmnd->device == scmnd->device)
 			srp_reset_req(target, req);
 
 	spin_unlock_irq(target->scsi_host->host_lock);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index ed0dce9..c923731 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -68,7 +68,8 @@ enum {
 	SRP_TSK_MGMT_SQ_SIZE	= 1,
 	SRP_CMD_SQ_SIZE		= SRP_REQ_SQ_SIZE - SRP_TSK_MGMT_SQ_SIZE,
 
-	SRP_TAG_TSK_MGMT	= 1 << (SRP_RQ_SHIFT + 1),
+	SRP_TAG_NO_REQ		= ~0UL,
+	SRP_TAG_TSK_MGMT	= 1UL << 31,
 
 	SRP_FMR_SIZE		= 256,
 	SRP_FMR_POOL_SIZE	= 1024,
@@ -113,12 +114,8 @@ struct srp_request {
 	struct list_head	list;
 	struct scsi_cmnd       *scmnd;
 	struct srp_iu	       *cmd;
-	struct srp_iu	       *tsk_mgmt;
 	struct ib_pool_fmr     *fmr;
-	struct completion	done;
 	short			index;
-	u8			cmd_done;
-	u8			tsk_status;
 };
 
 struct srp_target_port {
@@ -165,6 +162,9 @@ struct srp_target_port {
 	int			status;
 	enum srp_target_state	state;
 	int			qp_in_error;
+
+	struct completion	tsk_mgmt_done;
+	u8			tsk_mgmt_status;
 };
 
 struct srp_iu {
-- 
1.7.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
