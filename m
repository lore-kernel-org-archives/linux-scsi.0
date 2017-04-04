From: Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [lpfc 11/19] Add NVMET changes to interface with 4.11 kernel
Date: Tue,  4 Apr 2017 10:17:04 -0700
Message-ID: <1491326232-11255-12-git-send-email-rkennedy@broadcom.com>
References: <1491326232-11255-1-git-send-email-rkennedy@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:38157 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754986AbdDDRZk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2017 13:25:40 -0400
Received: from pallmd1.broadcom.com (pallmd1.ash.broadcom.net [10.85.232.165])
        by rnd-relay.smtp.broadcom.com (Postfix) with ESMTP id 4629A30C09A
        for <linux-scsi@vger.kernel.org>; Tue,  4 Apr 2017 10:17:32 -0700 (PDT)
In-Reply-To: <1491326232-11255-1-git-send-email-rkennedy@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>

From: Dick Kennedy <rkennedy@lvnvda1400.lvn.broadcom.net>

---
 drivers/scsi/lpfc/lpfc_nvmet.c | 127 ++++++++++++++++++++++++++++++++---------
 drivers/scsi/lpfc/lpfc_nvmet.h |   7 ++-
 2 files changed, 105 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 551e81a..cbd6371 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -408,9 +408,7 @@ out:
 		if (phba->ktime_on)
 			lpfc_nvmet_ktime(phba, ctxp);
 #endif
-		/* Let Abort cmpl repost the context */
-		if (!(ctxp->flag & LPFC_NVMET_ABORT_OP))
-			lpfc_nvmet_rq_post(phba, ctxp, &ctxp->rqb_buffer->hbuf);
+		/* lpfc_nvmet_xmt_fcp_release() will recycle the context */
 	} else {
 		ctxp->entry_cnt++;
 		start_clean = offsetof(struct lpfc_iocbq, wqe);
@@ -543,27 +541,6 @@ lpfc_nvmet_xmt_fcp_op(struct nvmet_fc_target_port *tgtport,
 	}
 #endif
 
-	if (rsp->op == NVMET_FCOP_ABORT) {
-		lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
-				"6103 Abort op: oxri x%x %d cnt %d\n",
-				ctxp->oxid, ctxp->state, ctxp->entry_cnt);
-
-		lpfc_nvmeio_data(phba, "NVMET FCP ABRT: "
-				 "xri x%x state x%x cnt x%x\n",
-				 ctxp->oxid, ctxp->state, ctxp->entry_cnt);
-
-		atomic_inc(&lpfc_nvmep->xmt_fcp_abort);
-		ctxp->entry_cnt++;
-		ctxp->flag |= LPFC_NVMET_ABORT_OP;
-		if (ctxp->flag & LPFC_NVMET_IO_INP)
-			lpfc_nvmet_sol_fcp_issue_abort(phba, ctxp, ctxp->sid,
-						       ctxp->oxid);
-		else
-			lpfc_nvmet_unsol_fcp_issue_abort(phba, ctxp, ctxp->sid,
-							 ctxp->oxid);
-		return 0;
-	}
-
 	/* Sanity check */
 	if (ctxp->state == LPFC_NVMET_STE_ABORT) {
 		atomic_inc(&lpfc_nvmep->xmt_fcp_drop);
@@ -630,10 +607,76 @@ lpfc_nvmet_targetport_delete(struct nvmet_fc_target_port *targetport)
 	complete(&tport->tport_unreg_done);
 }
 
+static void
+lpfc_nvmet_xmt_fcp_abort(struct nvmet_fc_target_port *tgtport,
+			 struct nvmefc_tgt_fcp_req *req)
+{
+	struct lpfc_nvmet_tgtport *lpfc_nvmep = tgtport->private;
+	struct lpfc_nvmet_rcv_ctx *ctxp =
+		container_of(req, struct lpfc_nvmet_rcv_ctx, ctx.fcp_req);
+	struct lpfc_hba *phba = ctxp->phba;
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
+			"6103 Abort op: oxri x%x %d cnt %d\n",
+			ctxp->oxid, ctxp->state, ctxp->entry_cnt);
+
+	lpfc_nvmeio_data(phba, "NVMET FCP ABRT: "
+			 "xri x%x state x%x cnt x%x\n",
+			 ctxp->oxid, ctxp->state, ctxp->entry_cnt);
+
+	atomic_inc(&lpfc_nvmep->xmt_fcp_abort);
+	ctxp->entry_cnt++;
+	ctxp->flag |= LPFC_NVMET_ABORT_OP;
+	if (ctxp->flag & LPFC_NVMET_IO_INP)
+		lpfc_nvmet_sol_fcp_issue_abort(phba, ctxp, ctxp->sid,
+					       ctxp->oxid);
+	else
+		lpfc_nvmet_unsol_fcp_issue_abort(phba, ctxp, ctxp->sid,
+						 ctxp->oxid);
+}
+
+static void
+lpfc_nvmet_xmt_fcp_release(struct nvmet_fc_target_port *tgtport,
+			   struct nvmefc_tgt_fcp_req *rsp)
+{
+	struct lpfc_nvmet_tgtport *lpfc_nvmep = tgtport->private;
+	struct lpfc_nvmet_rcv_ctx *ctxp =
+		container_of(rsp, struct lpfc_nvmet_rcv_ctx, ctx.fcp_req);
+	struct lpfc_hba *phba = ctxp->phba;
+	unsigned long flags;
+	bool aborting = false;
+
+	spin_lock_irqsave(&ctxp->ctxlock, flags);
+	if (ctxp->flag & LPFC_NVMET_ABORT_OP) {
+		aborting = true;
+		ctxp->flag |= LPFC_NVMET_CTX_RLS;
+	}
+	spin_unlock_irqrestore(&ctxp->ctxlock, flags);
+
+	if (aborting)
+		/* let the abort path do the real release */
+		return;
+
+	/* Sanity check */
+	if (ctxp->state != LPFC_NVMET_STE_DONE) {
+		atomic_inc(&lpfc_nvmep->xmt_fcp_drop);
+		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
+				"6117 Bad state IO x%x aborted\n",
+				ctxp->oxid);
+	}
+
+	lpfc_nvmeio_data(phba, "NVMET FCP FREE: xri x%x ste %d\n", ctxp->oxid,
+			 ctxp->state, 0);
+
+	lpfc_nvmet_rq_post(phba, ctxp, &ctxp->rqb_buffer->hbuf);
+}
+
 static struct nvmet_fc_target_template lpfc_tgttemplate = {
 	.targetport_delete = lpfc_nvmet_targetport_delete,
 	.xmt_ls_rsp     = lpfc_nvmet_xmt_ls_rsp,
 	.fcp_op         = lpfc_nvmet_xmt_fcp_op,
+	.fcp_abort      = lpfc_nvmet_xmt_fcp_abort,
+	.fcp_req_release = lpfc_nvmet_xmt_fcp_release,
 
 	.max_hw_queues  = 1,
 	.max_sgl_segments = LPFC_NVMET_DEFAULT_SEGS,
@@ -665,7 +708,9 @@ lpfc_nvmet_create_targetport(struct lpfc_hba *phba)
 	lpfc_tgttemplate.max_hw_queues = phba->cfg_nvme_io_channel;
 	lpfc_tgttemplate.max_sgl_segments = phba->cfg_sg_seg_cnt + 1;
 	lpfc_tgttemplate.target_features = NVMET_FCTGTFEAT_READDATA_RSP |
-					   NVMET_FCTGTFEAT_NEEDS_CMD_CPUSCHED;
+					   NVMET_FCTGTFEAT_NEEDS_CMD_CPUSCHED |
+					   NVMET_FCTGTFEAT_CMD_IN_ISR |
+					   NVMET_FCTGTFEAT_OPDONE_IN_ISR;
 
 #if (IS_ENABLED(CONFIG_NVME_TARGET_FC))
 	error = nvmet_fc_register_targetport(&pinfo, &lpfc_tgttemplate,
@@ -828,6 +873,7 @@ dropit:
 	ctxp->wqeq = NULL;
 	ctxp->state = LPFC_NVMET_STE_RCV;
 	ctxp->rqb_buffer = (void *)nvmebuf;
+	spin_lock_init(&ctxp->ctxlock);
 
 	lpfc_nvmeio_data(phba, "NVMET LS   RCV: xri x%x sz %d from %06x\n",
 			 oxid, size, sid);
@@ -1589,6 +1635,8 @@ lpfc_nvmet_sol_fcp_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 	struct lpfc_nvmet_rcv_ctx *ctxp;
 	struct lpfc_nvmet_tgtport *tgtp;
 	uint32_t status, result;
+	unsigned long flags;
+	bool released = false;
 
 	ctxp = cmdwqe->context2;
 	status = bf_get(lpfc_wcqe_c_status, wcqe);
@@ -1603,7 +1651,18 @@ lpfc_nvmet_sol_fcp_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 			result, wcqe->word3);
 
 	ctxp->state = LPFC_NVMET_STE_DONE;
-	lpfc_nvmet_rq_post(phba, ctxp, &ctxp->rqb_buffer->hbuf);
+	spin_lock_irqsave(&ctxp->ctxlock, flags);
+	if (ctxp->flag & LPFC_NVMET_CTX_RLS)
+		released = true;
+	ctxp->flag &= ~LPFC_NVMET_ABORT_OP;
+	spin_unlock_irqrestore(&ctxp->ctxlock, flags);
+
+	/*
+	 * if transport has released ctx, then can reuse it. Otherwise,
+	 * will be recycled by transport release call.
+	 */
+	if (released)
+		lpfc_nvmet_rq_post(phba, ctxp, &ctxp->rqb_buffer->hbuf);
 
 	cmdwqe->context2 = NULL;
 	cmdwqe->context3 = NULL;
@@ -1626,7 +1685,9 @@ lpfc_nvmet_xmt_fcp_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 {
 	struct lpfc_nvmet_rcv_ctx *ctxp;
 	struct lpfc_nvmet_tgtport *tgtp;
+	unsigned long flags;
 	uint32_t status, result;
+	bool released = false;
 
 	ctxp = cmdwqe->context2;
 	status = bf_get(lpfc_wcqe_c_status, wcqe);
@@ -1648,7 +1709,19 @@ lpfc_nvmet_xmt_fcp_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 					ctxp->state, ctxp->oxid);
 		}
 		ctxp->state = LPFC_NVMET_STE_DONE;
-		lpfc_nvmet_rq_post(phba, ctxp, &ctxp->rqb_buffer->hbuf);
+		spin_lock_irqsave(&ctxp->ctxlock, flags);
+		if (ctxp->flag & LPFC_NVMET_CTX_RLS)
+			released = true;
+		ctxp->flag &= ~LPFC_NVMET_ABORT_OP;
+		spin_unlock_irqrestore(&ctxp->ctxlock, flags);
+
+		/*
+		 * if transport has released ctx, then can reuse it. Otherwise,
+		 * will be recycled by transport release call.
+		 */
+		if (released)
+			lpfc_nvmet_rq_post(phba, ctxp, &ctxp->rqb_buffer->hbuf);
+
 		cmdwqe->context2 = NULL;
 		cmdwqe->context3 = NULL;
 	}
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.h b/drivers/scsi/lpfc/lpfc_nvmet.h
index 0aa202c..d8bac4c 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.h
+++ b/drivers/scsi/lpfc/lpfc_nvmet.h
@@ -79,6 +79,7 @@ struct lpfc_nvmet_rcv_ctx {
 	struct lpfc_iocbq *wqeq;
 	struct lpfc_iocbq *abort_wqeq;
 	dma_addr_t txrdy_phys;
+	spinlock_t ctxlock; /* protect flag access */
 	uint32_t *txrdy;
 	uint32_t sid;
 	uint32_t offset;
@@ -95,8 +96,10 @@ struct lpfc_nvmet_rcv_ctx {
 #define LPFC_NVMET_STE_RSP		4
 #define LPFC_NVMET_STE_DONE		5
 	uint16_t flag;
-#define LPFC_NVMET_IO_INP		1
-#define LPFC_NVMET_ABORT_OP		2
+#define LPFC_NVMET_IO_INP		0x1
+#define LPFC_NVMET_ABORT_OP		0x2
+#define LPFC_NVMET_CTX_RLS		0x4
+
 	struct rqb_dmabuf *rqb_buffer;
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
-- 
2.1.0
