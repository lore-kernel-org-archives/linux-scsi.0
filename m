From: David Dillow <dillowda@ornl.gov>
Subject: [PATCH v2 0/8] scaling and bug fixes for 2.6.38
Date: Wed,  5 Jan 2011 15:35:08 -0500
Message-ID: <1294259716-30706-1-git-send-email-dillowda@ornl.gov>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from amavis-outgoing2.knology.net ([24.214.64.231]:50681 "EHLO
	amavis-outgoing2.knology.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752357Ab1AEUfV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jan 2011 15:35:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, bvanassche@acm.org

Updated patches to reflect the list's review, and better reflect Bart's
role in preparing them. Once he's had a chance to look over them again,
I'll push these to my repo and send a pull request.

For convenience, the diff from the results of the first series to the
results of this series is below.

Bart Van Assche (6):
  IB/srp: consolidate state change code
  IB/srp: allow lockless work posting
  IB/srp: don't move active requests to their own list
  IB/srp: reduce local coverage for command submission and EH
  IB/srp: reduce lock coverage of command completion
  IB/srp: stop sharing the host lock with SCSI

David Dillow (8):
  IB/srp: allow task management without a previous request
  IB/srp: consolidate hot-path variables into cache lines

 drivers/infiniband/ulp/srp/ib_srp.c |  392 ++++++++++++++++-------------------
 drivers/infiniband/ulp/srp/ib_srp.h |   46 +++--
 2 files changed, 206 insertions(+), 232 deletions(-)

-- 

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index cef6191..7dcefe4 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -445,7 +445,7 @@ static bool srp_change_state(struct srp_target_port *target,
 			    enum srp_target_state old,
 			    enum srp_target_state new)
 {
-	int changed = false;
+	bool changed = false;
 
 	spin_lock_irq(&target->lock);
 	if (target->state == old) {
@@ -558,7 +558,7 @@ static void srp_remove_req(struct srp_target_port *target,
 	spin_lock_irqsave(&target->lock, flags);
 	target->req_lim += req_lim_delta;
 	req->scmnd = NULL;
-	list_move_tail(&req->list, &target->free_reqs);
+	list_add_tail(&req->list, &target->free_reqs);
 	spin_unlock_irqrestore(&target->lock, flags);
 }
 
@@ -609,7 +609,7 @@ static int srp_reconnect_target(struct srp_target_port *target)
 
 	list_del_init(&target->free_tx);
 	for (i = 0; i < SRP_SQ_SIZE; ++i)
-		list_move(&target->tx_ring[i]->list, &target->free_tx);
+		list_add(&target->tx_ring[i]->list, &target->free_tx);
 
 	target->qp_in_error = 0;
 	ret = srp_connect_target(target);
@@ -871,7 +871,7 @@ static struct srp_iu *__srp_get_tx_iu(struct srp_target_port *target,
 	}
 
 	iu = list_first_entry(&target->free_tx, struct srp_iu, list);
-	list_del_init(&iu->list);
+	list_del(&iu->list);
 	return iu;
 }
 
@@ -916,8 +916,13 @@ static void srp_process_rsp(struct srp_target_port *target, struct srp_rsp *rsp)
 {
 	struct srp_request *req;
 	struct scsi_cmnd *scmnd;
+	unsigned long flags;
 
 	if (unlikely(rsp->tag & SRP_TAG_TSK_MGMT)) {
+		spin_lock_irqsave(&target->lock, flags);
+		target->req_lim += be32_to_cpu(rsp->req_lim_delta);
+		spin_unlock_irqrestore(&target->lock, flags);
+
 		target->tsk_mgmt_status = -1;
 		if (be32_to_cpu(rsp->resp_data_len) >= 4)
 			target->tsk_mgmt_status = rsp->data[3];
@@ -1126,13 +1131,11 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	}
 
 	spin_lock_irqsave(&target->lock, flags);
-	/* This goes away once the scsi_eh routines stop testing it. */
-	scsi_cmd_get_serial(shost, scmnd);
 	iu = __srp_get_tx_iu(target, SRP_IU_CMD);
 	if (iu) {
 		req = list_first_entry(&target->free_reqs, struct srp_request,
 				      list);
-		list_del_init(&req->list);
+		list_del(&req->list);
 	}
 	spin_unlock_irqrestore(&target->lock, flags);
 
@@ -1207,7 +1210,6 @@ static int srp_alloc_iu_bufs(struct srp_target_port *target)
 		if (!target->tx_ring[i])
 			goto err;
 
-		INIT_LIST_HEAD(&target->tx_ring[i]->list);
 		list_add(&target->tx_ring[i]->list, &target->free_tx);
 	}
 
@@ -1461,10 +1463,10 @@ static int srp_send_tsk_mgmt(struct srp_target_port *target,
 	memset(tsk_mgmt, 0, sizeof *tsk_mgmt);
 
 	tsk_mgmt->opcode 	= SRP_TSK_MGMT;
-	tsk_mgmt->lun 		= cpu_to_be64((u64) lun << 48);
-	tsk_mgmt->tag 		= req_tag | SRP_TAG_TSK_MGMT;
+	tsk_mgmt->lun		= cpu_to_be64((u64) lun << 48);
+	tsk_mgmt->tag		= req_tag | SRP_TAG_TSK_MGMT;
 	tsk_mgmt->tsk_mgmt_func = func;
-	tsk_mgmt->task_tag 	= req_tag;
+	tsk_mgmt->task_tag	= req_tag;
 
 	ib_dma_sync_single_for_device(dev, iu->dma, sizeof *tsk_mgmt,
 				      DMA_TO_DEVICE);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 43f9129..9dc6fc3 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -66,8 +66,8 @@ enum {
 	SRP_TSK_MGMT_SQ_SIZE	= 1,
 	SRP_CMD_SQ_SIZE		= SRP_REQ_SQ_SIZE - SRP_TSK_MGMT_SQ_SIZE,
 
-	SRP_TAG_NO_REQ		= ~0UL,
-	SRP_TAG_TSK_MGMT	= 1UL << 31,
+	SRP_TAG_NO_REQ		= ~0U,
+	SRP_TAG_TSK_MGMT	= 1U << 31,
 
 	SRP_FMR_SIZE		= 256,
 	SRP_FMR_POOL_SIZE	= 1024,
@@ -124,7 +124,7 @@ struct srp_target_port {
 	s32			req_lim;
 
 	/* These are read-only in the hot path */
-	struct ib_cq	       *send_cq ____cacheline_aligned;
+	struct ib_cq	       *send_cq ____cacheline_aligned_in_smp;
 	struct ib_cq	       *recv_cq;
 	struct ib_qp	       *qp;
 	u32			lkey;
