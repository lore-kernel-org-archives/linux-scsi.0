From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: [RFC 6/8] IB/srp: reduce lock coverage of command completion
Date: Thu, 23 Dec 2010 16:31:31 -0500
Message-ID: <1293139893-11678-7-git-send-email-dillowda@ornl.gov>
References: <1293139893-11678-1-git-send-email-dillowda@ornl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1293139893-11678-1-git-send-email-dillowda-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

We only need the lock to cover list and credit manipulations, so push
those into srp_remove_req() and update the call chains.

We reorder the request removal and command completion in
srp_process_rsp() to avoid the SCSI mid-layer sending another command
before we've released our request and added any credits returned by the
target. This prevents us from returning HOST_BUSY unneccesarily.

This is a break-out of Bart Van Assche's work, modified to avoid
HOST_BUSY.
---
 drivers/infiniband/ulp/srp/ib_srp.c |   34 ++++++++++------------------------
 1 files changed, 10 insertions(+), 24 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 96d301e..4e8ae59 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -549,18 +549,24 @@ static void srp_unmap_data(struct scsi_cmnd *scmnd,
 			scsi_sg_count(scmnd), scmnd->sc_data_direction);
 }
 
-static void srp_remove_req(struct srp_target_port *target, struct srp_request *req)
+static void srp_remove_req(struct srp_target_port *target,
+			   struct srp_request *req, s32 req_lim_delta)
 {
+	unsigned long flags;
+
 	srp_unmap_data(req->scmnd, target, req);
+	spin_lock_irqsave(target->scsi_host->host_lock, flags);
+	target->req_lim += req_lim_delta;
 	req->scmnd = NULL;
 	list_move_tail(&req->list, &target->free_reqs);
+	spin_unlock_irqrestore(target->scsi_host->host_lock, flags);
 }
 
 static void srp_reset_req(struct srp_target_port *target, struct srp_request *req)
 {
 	req->scmnd->result = DID_RESET << 16;
 	req->scmnd->scsi_done(req->scmnd);
-	srp_remove_req(target, req);
+	srp_remove_req(target, req, 0);
 }
 
 static int srp_reconnect_target(struct srp_target_port *target)
@@ -595,13 +601,11 @@ static int srp_reconnect_target(struct srp_target_port *target)
 	while (ib_poll_cq(target->send_cq, 1, &wc) > 0)
 		; /* nothing */
 
-	spin_lock_irq(target->scsi_host->host_lock);
 	for (i = 0; i < SRP_CMD_SQ_SIZE; ++i) {
 		struct srp_request *req = &target->req_ring[i];
 		if (req->scmnd)
 			srp_reset_req(target, req);
 	}
-	spin_unlock_irq(target->scsi_host->host_lock);
 
 	list_del_init(&target->free_tx);
 	for (i = 0; i < SRP_SQ_SIZE; ++i)
@@ -913,14 +917,6 @@ static void srp_process_rsp(struct srp_target_port *target, struct srp_rsp *rsp)
 {
 	struct srp_request *req;
 	struct scsi_cmnd *scmnd;
-	unsigned long flags;
-	s32 delta;
-
-	delta = (s32) be32_to_cpu(rsp->req_lim_delta);
-
-	spin_lock_irqsave(target->scsi_host->host_lock, flags);
-
-	target->req_lim += delta;
 
 	if (unlikely(rsp->tag & SRP_TAG_TSK_MGMT)) {
 		target->tsk_mgmt_status = -1;
@@ -948,12 +944,10 @@ static void srp_process_rsp(struct srp_target_port *target, struct srp_rsp *rsp)
 		else if (rsp->flags & (SRP_RSP_FLAG_DIOVER | SRP_RSP_FLAG_DIUNDER))
 			scsi_set_resid(scmnd, be32_to_cpu(rsp->data_in_res_cnt));
 
+		srp_remove_req(target, req, be32_to_cpu(rsp->req_lim_delta));
 		scmnd->host_scribble = NULL;
 		scmnd->scsi_done(scmnd);
-		srp_remove_req(target, req);
 	}
-
-	spin_unlock_irqrestore(target->scsi_host->host_lock, flags);
 }
 
 static int srp_response_common(struct srp_target_port *target, s32 req_delta,
@@ -1501,18 +1495,14 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 			      SRP_TSK_ABORT_TASK))
 		return FAILED;
 
-	spin_lock_irq(target->scsi_host->host_lock);
-
 	if (req->scmnd) {
 		if (!target->tsk_mgmt_status) {
-			srp_remove_req(target, req);
+			srp_remove_req(target, req, 0);
 			scmnd->result = DID_ABORT << 16;
 		} else
 			ret = FAILED;
 	}
 
-	spin_unlock_irq(target->scsi_host->host_lock);
-
 	return ret;
 }
 
@@ -1531,16 +1521,12 @@ static int srp_reset_device(struct scsi_cmnd *scmnd)
 	if (target->tsk_mgmt_status)
 		return FAILED;
 
-	spin_lock_irq(target->scsi_host->host_lock);
-
 	for (i = 0; i < SRP_CMD_SQ_SIZE; ++i) {
 		struct srp_request *req = &target->req_ring[i];
 		if (req->scmnd && req->scmnd->device == scmnd->device)
 			srp_reset_req(target, req);
 	}
 
-	spin_unlock_irq(target->scsi_host->host_lock);
-
 	return SUCCESS;
 }
 
-- 
1.7.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
