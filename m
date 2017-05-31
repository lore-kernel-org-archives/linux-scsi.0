From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 04/15] lpfc: Add changes to assist in NVMET debugging
Date: Tue, 30 May 2017 23:04:28 -0700
Message-ID: <20170531060439.2073-5-jsmart2021@gmail.com>
References: <20170531060439.2073-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:34846 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750994AbdEaGE4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2017 02:04:56 -0400
Received: by mail-qt0-f193.google.com with SMTP id r58so809362qtb.2
        for <linux-scsi@vger.kernel.org>; Tue, 30 May 2017 23:04:56 -0700 (PDT)
In-Reply-To: <20170531060439.2073-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Inconsistent error messages and context state checks

Context state sanity checks were not accurate or
inconsistent in the code paths.

Separated LS context states from FCP.
Added and modified context state sanity checks.
Use context state to determine if a sol or unsol ABORT is needed.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nvmet.c | 208 ++++++++++++++++++++++++++++-------------
 drivers/scsi/lpfc/lpfc_nvmet.h |  14 +--
 2 files changed, 151 insertions(+), 71 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index f94294b77b7b..e062c317e2f6 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -112,6 +112,15 @@ lpfc_nvmet_xmt_ls_rsp_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 
 	status = bf_get(lpfc_wcqe_c_status, wcqe);
 	result = wcqe->parameter;
+	ctxp = cmdwqe->context2;
+
+	if (ctxp->state != LPFC_NVMET_STE_LS_RSP || ctxp->entry_cnt != 2) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
+				"6410 NVMET LS cmpl state mismatch IO x%x: "
+				"%d %d\n",
+				ctxp->oxid, ctxp->state, ctxp->entry_cnt);
+	}
+
 	if (!phba->targetport)
 		goto out;
 
@@ -123,15 +132,14 @@ lpfc_nvmet_xmt_ls_rsp_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 		atomic_inc(&tgtp->xmt_ls_rsp_cmpl);
 
 out:
-	ctxp = cmdwqe->context2;
 	rsp = &ctxp->ctx.ls_req;
 
 	lpfc_nvmeio_data(phba, "NVMET LS  CMPL: xri x%x stat x%x result x%x\n",
 			 ctxp->oxid, status, result);
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_NVME_DISC,
-			"6038 %s: Entrypoint: ctx %p status %x/%x\n", __func__,
-			ctxp, status, result);
+			"6038 NVMET LS rsp cmpl: %d %d oxid x%x\n",
+			status, result, ctxp->oxid);
 
 	lpfc_nlp_put(cmdwqe->context1);
 	cmdwqe->context2 = NULL;
@@ -173,6 +181,12 @@ lpfc_nvmet_ctxbuf_post(struct lpfc_hba *phba, struct lpfc_nvmet_ctxbuf *ctx_buf)
 		ctxp->txrdy = NULL;
 		ctxp->txrdy_phys = 0;
 	}
+
+	if (ctxp->state == LPFC_NVMET_STE_FREE) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
+				"6411 NVMET free, already free IO x%x: %d %d\n",
+				ctxp->oxid, ctxp->state, ctxp->entry_cnt);
+	}
 	ctxp->state = LPFC_NVMET_STE_FREE;
 
 	spin_lock_irqsave(&phba->sli4_hba.nvmet_io_wait_lock, iflag);
@@ -580,8 +594,17 @@ lpfc_nvmet_xmt_ls_rsp(struct nvmet_fc_target_port *tgtport,
 	int rc;
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_NVME_DISC,
-			"6023 %s: Entrypoint ctx %p %p\n", __func__,
-			ctxp, tgtport);
+			"6023 NVMET LS rsp oxid x%x\n", ctxp->oxid);
+
+	if ((ctxp->state != LPFC_NVMET_STE_LS_RCV) ||
+	    (ctxp->entry_cnt != 1)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
+				"6412 NVMET LS rsp state mismatch "
+				"oxid x%x: %d %d\n",
+				ctxp->oxid, ctxp->state, ctxp->entry_cnt);
+	}
+	ctxp->state = LPFC_NVMET_STE_LS_RSP;
+	ctxp->entry_cnt++;
 
 	nvmewqeq = lpfc_nvmet_prep_ls_wqe(phba, ctxp, rsp->rspdma,
 				      rsp->rsplen);
@@ -751,15 +774,14 @@ lpfc_nvmet_xmt_fcp_abort(struct nvmet_fc_target_port *tgtport,
 	unsigned long flags;
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
-			"6103 Abort op: oxri x%x flg x%x cnt %d\n",
-			ctxp->oxid, ctxp->flag, ctxp->entry_cnt);
+			"6103 NVMET Abort op: oxri x%x flg x%x ste %d\n",
+			ctxp->oxid, ctxp->flag, ctxp->state);
 
-	lpfc_nvmeio_data(phba, "NVMET FCP ABRT: "
-			 "xri x%x flg x%x cnt x%x\n",
-			 ctxp->oxid, ctxp->flag, ctxp->entry_cnt);
+	lpfc_nvmeio_data(phba, "NVMET FCP ABRT: xri x%x flg x%x ste x%x\n",
+			 ctxp->oxid, ctxp->flag, ctxp->state);
 
 	atomic_inc(&lpfc_nvmep->xmt_fcp_abort);
-	ctxp->entry_cnt++;
+
 	spin_lock_irqsave(&ctxp->ctxlock, flags);
 
 	/* Since iaab/iaar are NOT set, we need to check
@@ -770,12 +792,17 @@ lpfc_nvmet_xmt_fcp_abort(struct nvmet_fc_target_port *tgtport,
 		return;
 	}
 	ctxp->flag |= LPFC_NVMET_ABORT_OP;
-	if (ctxp->flag & LPFC_NVMET_IO_INP)
-		lpfc_nvmet_sol_fcp_issue_abort(phba, ctxp, ctxp->sid,
-					       ctxp->oxid);
-	else
+
+	/* An state of LPFC_NVMET_STE_RCV means we have just received
+	 * the NVME command and have not started processing it.
+	 * (by issuing any IO WQEs on this exchange yet)
+	 */
+	if (ctxp->state == LPFC_NVMET_STE_RCV)
 		lpfc_nvmet_unsol_fcp_issue_abort(phba, ctxp, ctxp->sid,
 						 ctxp->oxid);
+	else
+		lpfc_nvmet_sol_fcp_issue_abort(phba, ctxp, ctxp->sid,
+					       ctxp->oxid);
 	spin_unlock_irqrestore(&ctxp->ctxlock, flags);
 }
 
@@ -790,6 +817,13 @@ lpfc_nvmet_xmt_fcp_release(struct nvmet_fc_target_port *tgtport,
 	unsigned long flags;
 	bool aborting = false;
 
+	if (ctxp->state != LPFC_NVMET_STE_DONE &&
+	    ctxp->state != LPFC_NVMET_STE_ABORT) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
+				"6413 NVMET release bad state %d %d oxid x%x\n",
+				ctxp->state, ctxp->entry_cnt, ctxp->oxid);
+	}
+
 	spin_lock_irqsave(&ctxp->ctxlock, flags);
 	if ((ctxp->flag & LPFC_NVMET_ABORT_OP) ||
 	    (ctxp->flag & LPFC_NVMET_XBUSY)) {
@@ -891,6 +925,7 @@ lpfc_nvmet_setup_io_context(struct lpfc_hba *phba)
 			return -ENOMEM;
 		}
 		ctx_buf->context->ctxbuf = ctx_buf;
+		ctx_buf->context->state = LPFC_NVMET_STE_FREE;
 
 		ctx_buf->iocbq = lpfc_sli_get_iocbq(phba);
 		if (!ctx_buf->iocbq) {
@@ -1104,7 +1139,7 @@ lpfc_sli4_nvmet_xri_aborted(struct lpfc_hba *phba,
 		}
 
 		lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
-				"6318 XB aborted %x flg x%x (%x)\n",
+				"6318 XB aborted oxid %x flg x%x (%x)\n",
 				ctxp->oxid, ctxp->flag, released);
 		if (released)
 			lpfc_nvmet_ctxbuf_post(phba, ctxp->ctxbuf);
@@ -1254,7 +1289,8 @@ lpfc_nvmet_unsol_ls_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	ctxp->oxid = oxid;
 	ctxp->sid = sid;
 	ctxp->wqeq = NULL;
-	ctxp->state = LPFC_NVMET_STE_RCV;
+	ctxp->state = LPFC_NVMET_STE_LS_RCV;
+	ctxp->entry_cnt = 1;
 	ctxp->rqb_buffer = (void *)nvmebuf;
 
 	lpfc_nvmeio_data(phba, "NVMET LS   RCV: xri x%x sz %d from %06x\n",
@@ -1269,8 +1305,8 @@ lpfc_nvmet_unsol_ls_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 				 payload, size);
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_NVME_DISC,
-			"6037 %s: ctx %p sz %d rc %d: %08x %08x %08x "
-			"%08x %08x %08x\n", __func__, ctxp, size, rc,
+			"6037 NVMET Unsol rcv: sz %d rc %d: %08x %08x %08x "
+			"%08x %08x %08x\n", size, rc,
 			*payload, *(payload+1), *(payload+2),
 			*(payload+3), *(payload+4), *(payload+5));
 
@@ -1384,6 +1420,11 @@ lpfc_nvmet_unsol_fcp_buffer(struct lpfc_hba *phba,
 	sid = sli4_sid_from_fc_hdr(fc_hdr);
 
 	ctxp = (struct lpfc_nvmet_rcv_ctx *)ctx_buf->context;
+	if (ctxp->state != LPFC_NVMET_STE_FREE) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
+				"6414 NVMET Context corrupt %d %d oxid x%x\n",
+				ctxp->state, ctxp->entry_cnt, ctxp->oxid);
+	}
 	memset(ctxp, 0, sizeof(ctxp->ctx));
 	ctxp->wqeq = NULL;
 	ctxp->txrdy = NULL;
@@ -1548,9 +1589,9 @@ lpfc_nvmet_prep_ls_wqe(struct lpfc_hba *phba,
 
 	if (!lpfc_is_link_up(phba)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_DISC,
-				"6104 lpfc_nvmet_prep_ls_wqe: link err: "
-				"NPORT x%x oxid:x%x\n",
-				ctxp->sid, ctxp->oxid);
+				"6104 NVMET prep LS wqe: link err: "
+				"NPORT x%x oxid:x%x ste %d\n",
+				ctxp->sid, ctxp->oxid, ctxp->state);
 		return NULL;
 	}
 
@@ -1558,9 +1599,9 @@ lpfc_nvmet_prep_ls_wqe(struct lpfc_hba *phba,
 	nvmewqe = lpfc_sli_get_iocbq(phba);
 	if (nvmewqe == NULL) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_DISC,
-				"6105 lpfc_nvmet_prep_ls_wqe: No WQE: "
-				"NPORT x%x oxid:x%x\n",
-				ctxp->sid, ctxp->oxid);
+				"6105 NVMET prep LS wqe: No WQE: "
+				"NPORT x%x oxid x%x ste %d\n",
+				ctxp->sid, ctxp->oxid, ctxp->state);
 		return NULL;
 	}
 
@@ -1569,9 +1610,9 @@ lpfc_nvmet_prep_ls_wqe(struct lpfc_hba *phba,
 	    ((ndlp->nlp_state != NLP_STE_UNMAPPED_NODE) &&
 	    (ndlp->nlp_state != NLP_STE_MAPPED_NODE))) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_DISC,
-				"6106 lpfc_nvmet_prep_ls_wqe: No ndlp: "
-				"NPORT x%x oxid:x%x\n",
-				ctxp->sid, ctxp->oxid);
+				"6106 NVMET prep LS wqe: No ndlp: "
+				"NPORT x%x oxid x%x ste %d\n",
+				ctxp->sid, ctxp->oxid, ctxp->state);
 		goto nvme_wqe_free_wqeq_exit;
 	}
 	ctxp->wqeq = nvmewqe;
@@ -1643,9 +1684,9 @@ lpfc_nvmet_prep_ls_wqe(struct lpfc_hba *phba,
 	nvmewqe->drvrTimeout = (phba->fc_ratov * 3) + LPFC_DRVR_TIMEOUT;
 	nvmewqe->iocb_flag |= LPFC_IO_NVME_LS;
 
-	/* Xmit NVME response to remote NPORT <did> */
+	/* Xmit NVMET response to remote NPORT <did> */
 	lpfc_printf_log(phba, KERN_INFO, LOG_NVME_DISC,
-			"6039 Xmit NVME LS response to remote "
+			"6039 Xmit NVMET LS response to remote "
 			"NPORT x%x iotag:x%x oxid:x%x size:x%x\n",
 			ndlp->nlp_DID, nvmewqe->iotag, ctxp->oxid,
 			rspsize);
@@ -1677,9 +1718,9 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 
 	if (!lpfc_is_link_up(phba)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
-				"6107 lpfc_nvmet_prep_fcp_wqe: link err:"
-				"NPORT x%x oxid:x%x\n", ctxp->sid,
-				ctxp->oxid);
+				"6107 NVMET prep FCP wqe: link err:"
+				"NPORT x%x oxid x%x ste %d\n",
+				ctxp->sid, ctxp->oxid, ctxp->state);
 		return NULL;
 	}
 
@@ -1688,17 +1729,18 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 	    ((ndlp->nlp_state != NLP_STE_UNMAPPED_NODE) &&
 	     (ndlp->nlp_state != NLP_STE_MAPPED_NODE))) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
-				"6108 lpfc_nvmet_prep_fcp_wqe: no ndlp: "
-				"NPORT x%x oxid:x%x\n",
-				ctxp->sid, ctxp->oxid);
+				"6108 NVMET prep FCP wqe: no ndlp: "
+				"NPORT x%x oxid x%x ste %d\n",
+				ctxp->sid, ctxp->oxid, ctxp->state);
 		return NULL;
 	}
 
 	if (rsp->sg_cnt > phba->cfg_nvme_seg_cnt) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
-				"6109 lpfc_nvmet_prep_fcp_wqe: seg cnt err: "
-				"NPORT x%x oxid:x%x cnt %d\n",
-				ctxp->sid, ctxp->oxid, phba->cfg_nvme_seg_cnt);
+				"6109 NVMET prep FCP wqe: seg cnt err: "
+				"NPORT x%x oxid x%x ste %d cnt %d\n",
+				ctxp->sid, ctxp->oxid, ctxp->state,
+				phba->cfg_nvme_seg_cnt);
 		return NULL;
 	}
 
@@ -1709,9 +1751,9 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 		nvmewqe = ctxp->ctxbuf->iocbq;
 		if (nvmewqe == NULL) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
-					"6110 lpfc_nvmet_prep_fcp_wqe: No "
-					"WQE: NPORT x%x oxid:x%x\n",
-					ctxp->sid, ctxp->oxid);
+					"6110 NVMET prep FCP wqe: No "
+					"WQE: NPORT x%x oxid x%x ste %d\n",
+					ctxp->sid, ctxp->oxid, ctxp->state);
 			return NULL;
 		}
 		ctxp->wqeq = nvmewqe;
@@ -1723,13 +1765,12 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 	/* Sanity check */
 	if (((ctxp->state == LPFC_NVMET_STE_RCV) &&
 	    (ctxp->entry_cnt == 1)) ||
-	    ((ctxp->state == LPFC_NVMET_STE_DATA) &&
-	    (ctxp->entry_cnt > 1))) {
+	    (ctxp->state == LPFC_NVMET_STE_DATA)) {
 		wqe = (union lpfc_wqe128 *)&nvmewqe->wqe;
 	} else {
 		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
-				"6111 Wrong state %s: %d  cnt %d\n",
-				__func__, ctxp->state, ctxp->entry_cnt);
+				"6111 Wrong state NVMET FCP: %d  cnt %d\n",
+				ctxp->state, ctxp->entry_cnt);
 		return NULL;
 	}
 
@@ -1833,7 +1874,6 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 			bf_set(wqe_ar, &wqe->fcp_tsend.wqe_com, 0);
 			bf_set(wqe_irsplen, &wqe->fcp_tsend.wqe_com, 0);
 		}
-		ctxp->state = LPFC_NVMET_STE_DATA;
 		break;
 
 	case NVMET_FCOP_WRITEDATA:
@@ -1924,7 +1964,6 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 		sgl->word2 = cpu_to_le32(sgl->word2);
 		sgl->sge_len = 0;
 		sgl++;
-		ctxp->state = LPFC_NVMET_STE_DATA;
 		atomic_inc(&tgtp->xmt_fcp_write);
 		break;
 
@@ -1981,7 +2020,6 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 		bf_set(wqe_cmd_type, &wqe->fcp_trsp.wqe_com,
 		       FCP_COMMAND_TRSP);
 		bf_set(wqe_sup, &wqe->fcp_tsend.wqe_com, 0);
-		ctxp->state = LPFC_NVMET_STE_RSP;
 
 		if (rsp->rsplen == LPFC_NVMET_SUCCESS_LEN) {
 			/* Good response - all zero's on wire */
@@ -2030,6 +2068,8 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 		sgl++;
 		ctxp->offset += cnt;
 	}
+	ctxp->state = LPFC_NVMET_STE_DATA;
+	ctxp->entry_cnt++;
 	return nvmewqe;
 }
 
@@ -2207,17 +2247,32 @@ lpfc_nvmet_xmt_ls_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 	atomic_inc(&tgtp->xmt_ls_abort_cmpl);
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
-			"6083 Abort cmpl: ctx %p WCQE: %08x %08x %08x %08x\n",
+			"6083 Abort cmpl: ctx %p WCQE:%08x %08x %08x %08x\n",
 			ctxp, wcqe->word0, wcqe->total_data_placed,
 			result, wcqe->word3);
 
-	if (ctxp) {
-		cmdwqe->context2 = NULL;
-		cmdwqe->context3 = NULL;
-		lpfc_sli_release_iocbq(phba, cmdwqe);
-		kfree(ctxp);
-	} else
+	if (!ctxp) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_ABTS,
+				"6415 NVMET LS Abort No ctx: WCQE: "
+				 "%08x %08x %08x %08x\n",
+				wcqe->word0, wcqe->total_data_placed,
+				result, wcqe->word3);
+
 		lpfc_sli_release_iocbq(phba, cmdwqe);
+		return;
+	}
+
+	if (ctxp->state != LPFC_NVMET_STE_LS_ABORT) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
+				"6416 NVMET LS abort cmpl state mismatch: "
+				"oxid x%x: %d %d\n",
+				ctxp->oxid, ctxp->state, ctxp->entry_cnt);
+	}
+
+	cmdwqe->context2 = NULL;
+	cmdwqe->context3 = NULL;
+	lpfc_sli_release_iocbq(phba, cmdwqe);
+	kfree(ctxp);
 }
 
 static int
@@ -2241,7 +2296,7 @@ lpfc_nvmet_unsol_issue_abort(struct lpfc_hba *phba,
 	    ((ndlp->nlp_state != NLP_STE_UNMAPPED_NODE) &&
 	    (ndlp->nlp_state != NLP_STE_MAPPED_NODE))) {
 		atomic_inc(&tgtp->xmt_abort_rsp_error);
-		lpfc_printf_log(phba, KERN_WARNING, LOG_NVME_ABTS,
+		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_ABTS,
 				"6134 Drop ABTS - wrong NDLP state x%x.\n",
 				(ndlp) ? ndlp->nlp_state : NLP_STE_MAX_STATE);
 
@@ -2251,7 +2306,6 @@ lpfc_nvmet_unsol_issue_abort(struct lpfc_hba *phba,
 
 	abts_wqeq = ctxp->wqeq;
 	wqe_abts = &abts_wqeq->wqe;
-	ctxp->state = LPFC_NVMET_STE_ABORT;
 
 	/*
 	 * Since we zero the whole WQE, we need to ensure we set the WQE fields
@@ -2339,7 +2393,7 @@ lpfc_nvmet_sol_fcp_issue_abort(struct lpfc_hba *phba,
 	    ((ndlp->nlp_state != NLP_STE_UNMAPPED_NODE) &&
 	    (ndlp->nlp_state != NLP_STE_MAPPED_NODE))) {
 		atomic_inc(&tgtp->xmt_abort_rsp_error);
-		lpfc_printf_log(phba, KERN_WARNING, LOG_NVME_ABTS,
+		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_ABTS,
 				"6160 Drop ABORT - wrong NDLP state x%x.\n",
 				(ndlp) ? ndlp->nlp_state : NLP_STE_MAX_STATE);
 
@@ -2352,7 +2406,7 @@ lpfc_nvmet_sol_fcp_issue_abort(struct lpfc_hba *phba,
 	ctxp->abort_wqeq = lpfc_sli_get_iocbq(phba);
 	if (!ctxp->abort_wqeq) {
 		atomic_inc(&tgtp->xmt_abort_rsp_error);
-		lpfc_printf_log(phba, KERN_WARNING, LOG_NVME_ABTS,
+		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_ABTS,
 				"6161 ABORT failed: No wqeqs: "
 				"xri: x%x\n", ctxp->oxid);
 		/* No failure to an ABTS request. */
@@ -2472,6 +2526,15 @@ lpfc_nvmet_unsol_fcp_issue_abort(struct lpfc_hba *phba,
 		ctxp->wqeq->hba_wqidx = 0;
 	}
 
+	if (ctxp->state == LPFC_NVMET_STE_FREE) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
+				"6417 NVMET ABORT ctx freed %d %d oxid x%x\n",
+				ctxp->state, ctxp->entry_cnt, ctxp->oxid);
+		rc = WQE_BUSY;
+		goto aerr;
+	}
+	ctxp->state = LPFC_NVMET_STE_ABORT;
+	ctxp->entry_cnt++;
 	rc = lpfc_nvmet_unsol_issue_abort(phba, ctxp, sid, xri);
 	if (rc == 0)
 		goto aerr;
@@ -2491,7 +2554,7 @@ lpfc_nvmet_unsol_fcp_issue_abort(struct lpfc_hba *phba,
 	atomic_inc(&tgtp->xmt_abort_rsp_error);
 	ctxp->flag &= ~LPFC_NVMET_ABORT_OP;
 	atomic_inc(&tgtp->xmt_abort_rsp_error);
-	lpfc_printf_log(phba, KERN_WARNING, LOG_NVME_ABTS,
+	lpfc_printf_log(phba, KERN_ERR, LOG_NVME_ABTS,
 			"6135 Failed to Issue ABTS for oxid x%x. Status x%x\n",
 			ctxp->oxid, rc);
 	return 1;
@@ -2508,12 +2571,24 @@ lpfc_nvmet_unsol_ls_issue_abort(struct lpfc_hba *phba,
 	unsigned long flags;
 	int rc;
 
+	if ((ctxp->state == LPFC_NVMET_STE_LS_RCV && ctxp->entry_cnt == 1) ||
+	    (ctxp->state == LPFC_NVMET_STE_LS_RSP && ctxp->entry_cnt == 2)) {
+		ctxp->state = LPFC_NVMET_STE_LS_ABORT;
+		ctxp->entry_cnt++;
+	} else {
+		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
+				"6418 NVMET LS abort state mismatch "
+				"IO x%x: %d %d\n",
+				ctxp->oxid, ctxp->state, ctxp->entry_cnt);
+		ctxp->state = LPFC_NVMET_STE_LS_ABORT;
+	}
+
 	tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
 	if (!ctxp->wqeq) {
 		/* Issue ABTS for this WQE based on iotag */
 		ctxp->wqeq = lpfc_sli_get_iocbq(phba);
 		if (!ctxp->wqeq) {
-			lpfc_printf_log(phba, KERN_WARNING, LOG_NVME_ABTS,
+			lpfc_printf_log(phba, KERN_ERR, LOG_NVME_ABTS,
 					"6068 Abort failed: No wqeqs: "
 					"xri: x%x\n", xri);
 			/* No failure to an ABTS request. */
@@ -2524,7 +2599,10 @@ lpfc_nvmet_unsol_ls_issue_abort(struct lpfc_hba *phba,
 	abts_wqeq = ctxp->wqeq;
 	wqe_abts = &abts_wqeq->wqe;
 
-	lpfc_nvmet_unsol_issue_abort(phba, ctxp, sid, xri);
+	if (lpfc_nvmet_unsol_issue_abort(phba, ctxp, sid, xri) == 0) {
+		rc = WQE_BUSY;
+		goto out;
+	}
 
 	spin_lock_irqsave(&phba->hbalock, flags);
 	abts_wqeq->wqe_cmpl = lpfc_nvmet_xmt_ls_abort_cmp;
@@ -2536,13 +2614,13 @@ lpfc_nvmet_unsol_ls_issue_abort(struct lpfc_hba *phba,
 		atomic_inc(&tgtp->xmt_abort_unsol);
 		return 0;
 	}
-
+out:
 	atomic_inc(&tgtp->xmt_abort_rsp_error);
 	abts_wqeq->context2 = NULL;
 	abts_wqeq->context3 = NULL;
 	lpfc_sli_release_iocbq(phba, abts_wqeq);
 	kfree(ctxp);
-	lpfc_printf_log(phba, KERN_WARNING, LOG_NVME_ABTS,
+	lpfc_printf_log(phba, KERN_ERR, LOG_NVME_ABTS,
 			"6056 Failed to Issue ABTS. Status x%x\n", rc);
 	return 0;
 }
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.h b/drivers/scsi/lpfc/lpfc_nvmet.h
index 6eb2f5d8d4ed..e675ef17be08 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.h
+++ b/drivers/scsi/lpfc/lpfc_nvmet.h
@@ -93,12 +93,14 @@ struct lpfc_nvmet_rcv_ctx {
 	uint16_t cpu;
 	uint16_t state;
 	/* States */
-#define LPFC_NVMET_STE_FREE		0
-#define LPFC_NVMET_STE_RCV		1
-#define LPFC_NVMET_STE_DATA		2
-#define LPFC_NVMET_STE_ABORT		3
-#define LPFC_NVMET_STE_RSP		4
-#define LPFC_NVMET_STE_DONE		5
+#define LPFC_NVMET_STE_LS_RCV		1
+#define LPFC_NVMET_STE_LS_ABORT		2
+#define LPFC_NVMET_STE_LS_RSP		3
+#define LPFC_NVMET_STE_RCV		4
+#define LPFC_NVMET_STE_DATA		5
+#define LPFC_NVMET_STE_ABORT		6
+#define LPFC_NVMET_STE_DONE		7
+#define LPFC_NVMET_STE_FREE		0xff
 	uint16_t flag;
 #define LPFC_NVMET_IO_INP		0x1  /* IO is in progress on exchange */
 #define LPFC_NVMET_ABORT_OP		0x2  /* Abort WQE issued on exchange */
-- 
2.11.0
