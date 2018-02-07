From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 07/13] lpfc: Add if_type=6 support for cycling valid bits
Date: Tue,  6 Feb 2018 18:28:45 -0800
Message-ID: <20180207022851.11800-8-jsmart2021@gmail.com>
References: <20180207022851.11800-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:45615 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752820AbeBGC3G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Feb 2018 21:29:06 -0500
Received: by mail-ot0-f194.google.com with SMTP id 73so3758513oti.12
        for <linux-scsi@vger.kernel.org>; Tue, 06 Feb 2018 18:29:06 -0800 (PST)
In-Reply-To: <20180207022851.11800-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Traditional SLI4 required the driver to clear Valid bits on
EQEs and CQEs after consuming them.

The new if_type=6 hardware will cycle the value for what is
valid on each queue itteration. The driver no longer has to
touch the valid bits. This also means all the cpu cache
dirtying and perhaps flush/refill's done by the hardware
in accessing the EQ/CQ elements is eliminated.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hw4.h  | 18 ++++++++--
 drivers/scsi/lpfc/lpfc_init.c | 11 +++++++
 drivers/scsi/lpfc/lpfc_sli.c  | 77 +++++++++++++++++++++++++++++++++++--------
 drivers/scsi/lpfc/lpfc_sli4.h |  3 ++
 4 files changed, 92 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 0c33510fe75c..dba724e1f5ee 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -1040,6 +1040,9 @@ struct eq_context {
 #define lpfc_eq_context_valid_SHIFT	29
 #define lpfc_eq_context_valid_MASK	0x00000001
 #define lpfc_eq_context_valid_WORD	word0
+#define lpfc_eq_context_autovalid_SHIFT 28
+#define lpfc_eq_context_autovalid_MASK  0x00000001
+#define lpfc_eq_context_autovalid_WORD  word0
 	uint32_t word1;
 #define lpfc_eq_context_count_SHIFT	26
 #define lpfc_eq_context_count_MASK	0x00000003
@@ -1173,6 +1176,9 @@ struct cq_context {
 #define LPFC_CQ_CNT_512		0x1
 #define LPFC_CQ_CNT_1024	0x2
 #define LPFC_CQ_CNT_WORD7	0x3
+#define lpfc_cq_context_autovalid_SHIFT 15
+#define lpfc_cq_context_autovalid_MASK  0x00000001
+#define lpfc_cq_context_autovalid_WORD  word0
 	uint32_t word1;
 #define lpfc_cq_eq_id_SHIFT		22	/* Version 0 Only */
 #define lpfc_cq_eq_id_MASK		0x000000FF
@@ -1231,9 +1237,9 @@ struct lpfc_mbx_cq_create_set {
 #define lpfc_mbx_cq_create_set_cqe_size_SHIFT	25
 #define lpfc_mbx_cq_create_set_cqe_size_MASK	0x00000003
 #define lpfc_mbx_cq_create_set_cqe_size_WORD	word1
-#define lpfc_mbx_cq_create_set_auto_SHIFT	15
-#define lpfc_mbx_cq_create_set_auto_MASK	0x0000001
-#define lpfc_mbx_cq_create_set_auto_WORD	word1
+#define lpfc_mbx_cq_create_set_autovalid_SHIFT	15
+#define lpfc_mbx_cq_create_set_autovalid_MASK	0x0000001
+#define lpfc_mbx_cq_create_set_autovalid_WORD	word1
 #define lpfc_mbx_cq_create_set_nodelay_SHIFT	14
 #define lpfc_mbx_cq_create_set_nodelay_MASK	0x00000001
 #define lpfc_mbx_cq_create_set_nodelay_WORD	word1
@@ -3288,6 +3294,9 @@ struct lpfc_sli4_parameters {
 #define cfg_sli_hint_2_MASK			0x0000001f
 #define cfg_sli_hint_2_WORD			word1
 	uint32_t word2;
+#define cfg_eqav_SHIFT				31
+#define cfg_eqav_MASK				0x00000001
+#define cfg_eqav_WORD				word2
 	uint32_t word3;
 	uint32_t word4;
 #define cfg_cqv_SHIFT				14
@@ -3296,6 +3305,9 @@ struct lpfc_sli4_parameters {
 #define cfg_cqpsize_SHIFT			16
 #define cfg_cqpsize_MASK			0x000000ff
 #define cfg_cqpsize_WORD			word4
+#define cfg_cqav_SHIFT				31
+#define cfg_cqav_MASK				0x00000001
+#define cfg_cqav_WORD				word4
 	uint32_t word5;
 	uint32_t word6;
 #define cfg_mqv_SHIFT				14
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index c1d7436cca4a..65057e33b8b7 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8060,6 +8060,7 @@ lpfc_alloc_nvme_wq_cq(struct lpfc_hba *phba, int wqidx)
 				wqidx);
 		return 1;
 	}
+	qdesc->qe_valid = 1;
 	phba->sli4_hba.nvme_cq[wqidx] = qdesc;
 
 	qdesc = lpfc_sli4_queue_alloc(phba, LPFC_EXPANDED_PAGE_SIZE,
@@ -8097,6 +8098,7 @@ lpfc_alloc_fcp_wq_cq(struct lpfc_hba *phba, int wqidx)
 			"0499 Failed allocate fast-path FCP CQ (%d)\n", wqidx);
 		return 1;
 	}
+	qdesc->qe_valid = 1;
 	phba->sli4_hba.fcp_cq[wqidx] = qdesc;
 
 	/* Create Fast Path FCP WQs */
@@ -8290,6 +8292,7 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 					"0497 Failed allocate EQ (%d)\n", idx);
 			goto out_error;
 		}
+		qdesc->qe_valid = 1;
 		phba->sli4_hba.hba_eq[idx] = qdesc;
 	}
 
@@ -8315,6 +8318,7 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 					"CQ Set (%d)\n", idx);
 				goto out_error;
 			}
+			qdesc->qe_valid = 1;
 			phba->sli4_hba.nvmet_cqset[idx] = qdesc;
 		}
 	}
@@ -8332,6 +8336,7 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 				"0500 Failed allocate slow-path mailbox CQ\n");
 		goto out_error;
 	}
+	qdesc->qe_valid = 1;
 	phba->sli4_hba.mbx_cq = qdesc;
 
 	/* Create slow-path ELS Complete Queue */
@@ -8343,6 +8348,7 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 				"0501 Failed allocate slow-path ELS CQ\n");
 		goto out_error;
 	}
+	qdesc->qe_valid = 1;
 	phba->sli4_hba.els_cq = qdesc;
 
 
@@ -8388,6 +8394,7 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 					"6079 Failed allocate NVME LS CQ\n");
 			goto out_error;
 		}
+		qdesc->qe_valid = 1;
 		phba->sli4_hba.nvmels_cq = qdesc;
 
 		/* Create NVME LS Work Queue */
@@ -10566,6 +10573,8 @@ lpfc_get_sli4_parameters(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	sli4_params->mqv = bf_get(cfg_mqv, mbx_sli4_parameters);
 	sli4_params->wqv = bf_get(cfg_wqv, mbx_sli4_parameters);
 	sli4_params->rqv = bf_get(cfg_rqv, mbx_sli4_parameters);
+	sli4_params->eqav = bf_get(cfg_eqav, mbx_sli4_parameters);
+	sli4_params->cqav = bf_get(cfg_cqav, mbx_sli4_parameters);
 	sli4_params->wqsize = bf_get(cfg_wqsize, mbx_sli4_parameters);
 	sli4_params->sgl_pages_max = bf_get(cfg_sgl_page_cnt,
 					    mbx_sli4_parameters);
@@ -12384,6 +12393,7 @@ lpfc_fof_queue_create(struct lpfc_hba *phba)
 	if (!qdesc)
 		goto out_error;
 
+	qdesc->qe_valid = 1;
 	phba->sli4_hba.fof_eq = qdesc;
 
 	if (phba->cfg_fof) {
@@ -12402,6 +12412,7 @@ lpfc_fof_queue_create(struct lpfc_hba *phba)
 		if (!qdesc)
 			goto out_error;
 
+		qdesc->qe_valid = 1;
 		phba->sli4_hba.oas_cq = qdesc;
 
 		/* Create OAS WQ */
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 1b07e61fb7bd..a5d6d8eddd2b 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -288,16 +288,18 @@ lpfc_sli4_mq_release(struct lpfc_queue *q)
 static struct lpfc_eqe *
 lpfc_sli4_eq_get(struct lpfc_queue *q)
 {
+	struct lpfc_hba *phba;
 	struct lpfc_eqe *eqe;
 	uint32_t idx;
 
 	/* sanity check on queue memory */
 	if (unlikely(!q))
 		return NULL;
+	phba = q->phba;
 	eqe = q->qe[q->hba_index].eqe;
 
 	/* If the next EQE is not valid then we are done */
-	if (!bf_get_le32(lpfc_eqe_valid, eqe))
+	if (bf_get_le32(lpfc_eqe_valid, eqe) != q->qe_valid)
 		return NULL;
 	/* If the host has not yet processed the next entry then we are done */
 	idx = ((q->hba_index + 1) % q->entry_count);
@@ -305,6 +307,10 @@ lpfc_sli4_eq_get(struct lpfc_queue *q)
 		return NULL;
 
 	q->hba_index = idx;
+	/* if the index wrapped around, toggle the valid bit */
+	if (phba->sli4_hba.pc_sli4_params.eqav && !q->hba_index)
+		q->qe_valid = (q->qe_valid) ? 0 : 1;
+
 
 	/*
 	 * insert barrier for instruction interlock : data from the hardware
@@ -376,17 +382,21 @@ uint32_t
 lpfc_sli4_eq_release(struct lpfc_queue *q, bool arm)
 {
 	uint32_t released = 0;
+	struct lpfc_hba *phba;
 	struct lpfc_eqe *temp_eqe;
 	struct lpfc_register doorbell;
 
 	/* sanity check on queue memory */
 	if (unlikely(!q))
 		return 0;
+	phba = q->phba;
 
 	/* while there are valid entries */
 	while (q->hba_index != q->host_index) {
-		temp_eqe = q->qe[q->host_index].eqe;
-		bf_set_le32(lpfc_eqe_valid, temp_eqe, 0);
+		if (!phba->sli4_hba.pc_sli4_params.eqav) {
+			temp_eqe = q->qe[q->host_index].eqe;
+			bf_set_le32(lpfc_eqe_valid, temp_eqe, 0);
+		}
 		released++;
 		q->host_index = ((q->host_index + 1) % q->entry_count);
 	}
@@ -430,17 +440,21 @@ uint32_t
 lpfc_sli4_if6_eq_release(struct lpfc_queue *q, bool arm)
 {
 	uint32_t released = 0;
+	struct lpfc_hba *phba;
 	struct lpfc_eqe *temp_eqe;
 	struct lpfc_register doorbell;
 
 	/* sanity check on queue memory */
 	if (unlikely(!q))
 		return 0;
+	phba = q->phba;
 
 	/* while there are valid entries */
 	while (q->hba_index != q->host_index) {
-		temp_eqe = q->qe[q->host_index].eqe;
-		bf_set_le32(lpfc_eqe_valid, temp_eqe, 0);
+		if (!phba->sli4_hba.pc_sli4_params.eqav) {
+			temp_eqe = q->qe[q->host_index].eqe;
+			bf_set_le32(lpfc_eqe_valid, temp_eqe, 0);
+		}
 		released++;
 		q->host_index = ((q->host_index + 1) % q->entry_count);
 	}
@@ -472,23 +486,28 @@ lpfc_sli4_if6_eq_release(struct lpfc_queue *q, bool arm)
 static struct lpfc_cqe *
 lpfc_sli4_cq_get(struct lpfc_queue *q)
 {
+	struct lpfc_hba *phba;
 	struct lpfc_cqe *cqe;
 	uint32_t idx;
 
 	/* sanity check on queue memory */
 	if (unlikely(!q))
 		return NULL;
+	phba = q->phba;
+	cqe = q->qe[q->hba_index].cqe;
 
 	/* If the next CQE is not valid then we are done */
-	if (!bf_get_le32(lpfc_cqe_valid, q->qe[q->hba_index].cqe))
+	if (bf_get_le32(lpfc_cqe_valid, cqe) != q->qe_valid)
 		return NULL;
 	/* If the host has not yet processed the next entry then we are done */
 	idx = ((q->hba_index + 1) % q->entry_count);
 	if (idx == q->host_index)
 		return NULL;
 
-	cqe = q->qe[q->hba_index].cqe;
 	q->hba_index = idx;
+	/* if the index wrapped around, toggle the valid bit */
+	if (phba->sli4_hba.pc_sli4_params.cqav && !q->hba_index)
+		q->qe_valid = (q->qe_valid) ? 0 : 1;
 
 	/*
 	 * insert barrier for instruction interlock : data from the hardware
@@ -521,16 +540,21 @@ uint32_t
 lpfc_sli4_cq_release(struct lpfc_queue *q, bool arm)
 {
 	uint32_t released = 0;
+	struct lpfc_hba *phba;
 	struct lpfc_cqe *temp_qe;
 	struct lpfc_register doorbell;
 
 	/* sanity check on queue memory */
 	if (unlikely(!q))
 		return 0;
+	phba = q->phba;
+
 	/* while there are valid entries */
 	while (q->hba_index != q->host_index) {
-		temp_qe = q->qe[q->host_index].cqe;
-		bf_set_le32(lpfc_cqe_valid, temp_qe, 0);
+		if (!phba->sli4_hba.pc_sli4_params.cqav) {
+			temp_qe = q->qe[q->host_index].cqe;
+			bf_set_le32(lpfc_cqe_valid, temp_qe, 0);
+		}
 		released++;
 		q->host_index = ((q->host_index + 1) % q->entry_count);
 	}
@@ -569,16 +593,21 @@ uint32_t
 lpfc_sli4_if6_cq_release(struct lpfc_queue *q, bool arm)
 {
 	uint32_t released = 0;
+	struct lpfc_hba *phba;
 	struct lpfc_cqe *temp_qe;
 	struct lpfc_register doorbell;
 
 	/* sanity check on queue memory */
 	if (unlikely(!q))
 		return 0;
+	phba = q->phba;
+
 	/* while there are valid entries */
 	while (q->hba_index != q->host_index) {
-		temp_qe = q->qe[q->host_index].cqe;
-		bf_set_le32(lpfc_cqe_valid, temp_qe, 0);
+		if (!phba->sli4_hba.pc_sli4_params.cqav) {
+			temp_qe = q->qe[q->host_index].cqe;
+			bf_set_le32(lpfc_cqe_valid, temp_qe, 0);
+		}
 		released++;
 		q->host_index = ((q->host_index + 1) % q->entry_count);
 	}
@@ -7372,6 +7401,7 @@ lpfc_sli4_mbox_completions_pending(struct lpfc_hba *phba)
 	struct lpfc_queue *mcq;
 	struct lpfc_mcqe *mcqe;
 	bool pending_completions = false;
+	uint8_t	qe_valid;
 
 	if (unlikely(!phba) || (phba->sli_rev != LPFC_SLI_REV4))
 		return false;
@@ -7380,7 +7410,8 @@ lpfc_sli4_mbox_completions_pending(struct lpfc_hba *phba)
 
 	mcq = phba->sli4_hba.mbx_cq;
 	idx = mcq->hba_index;
-	while (bf_get_le32(lpfc_cqe_valid, mcq->qe[idx].cqe)) {
+	qe_valid = mcq->qe_valid;
+	while (bf_get_le32(lpfc_cqe_valid, mcq->qe[idx].cqe) == qe_valid) {
 		mcqe = (struct lpfc_mcqe *)mcq->qe[idx].cqe;
 		if (bf_get_le32(lpfc_trailer_completed, mcqe) &&
 		    (!bf_get_le32(lpfc_trailer_async, mcqe))) {
@@ -7390,6 +7421,10 @@ lpfc_sli4_mbox_completions_pending(struct lpfc_hba *phba)
 		idx = (idx + 1) % mcq->entry_count;
 		if (mcq->hba_index == idx)
 			break;
+
+		/* if the index wrapped around, toggle the valid bit */
+		if (phba->sli4_hba.pc_sli4_params.cqav && !idx)
+			qe_valid = (qe_valid) ? 0 : 1;
 	}
 	return pending_completions;
 
@@ -8263,7 +8298,7 @@ lpfc_sli_issue_mbox_s4(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq,
 	} else if (flag == MBX_POLL) {
 		lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX | LOG_SLI,
 				"(%d):2542 Try to issue mailbox command "
-				"x%x (x%x/x%x) synchronously ahead of async"
+				"x%x (x%x/x%x) synchronously ahead of async "
 				"mailbox command queue: x%x x%x\n",
 				mboxq->vport ? mboxq->vport->vpi : 0,
 				mboxq->u.mb.mbxCommand,
@@ -14340,11 +14375,21 @@ lpfc_eq_create(struct lpfc_hba *phba, struct lpfc_queue *eq, uint32_t imax)
 			 LPFC_MBOX_OPCODE_EQ_CREATE,
 			 length, LPFC_SLI4_MBX_EMBED);
 	eq_create = &mbox->u.mqe.un.eq_create;
+	shdr = (union lpfc_sli4_cfg_shdr *) &eq_create->header.cfg_shdr;
 	bf_set(lpfc_mbx_eq_create_num_pages, &eq_create->u.request,
 	       eq->page_count);
 	bf_set(lpfc_eq_context_size, &eq_create->u.request.context,
 	       LPFC_EQE_SIZE);
 	bf_set(lpfc_eq_context_valid, &eq_create->u.request.context, 1);
+
+	/* Use version 2 of CREATE_EQ if eqav is set */
+	if (phba->sli4_hba.pc_sli4_params.eqav) {
+		bf_set(lpfc_mbox_hdr_version, &shdr->request,
+		       LPFC_Q_CREATE_VERSION_2);
+		bf_set(lpfc_eq_context_autovalid, &eq_create->u.request.context,
+		       phba->sli4_hba.pc_sli4_params.eqav);
+	}
+
 	/* don't setup delay multiplier using EQ_CREATE */
 	dmult = 0;
 	bf_set(lpfc_eq_context_delay_multi, &eq_create->u.request.context,
@@ -14389,7 +14434,6 @@ lpfc_eq_create(struct lpfc_hba *phba, struct lpfc_queue *eq, uint32_t imax)
 	mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 	mbox->context1 = NULL;
 	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
-	shdr = (union lpfc_sli4_cfg_shdr *) &eq_create->header.cfg_shdr;
 	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
 	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
 	if (shdr_status || shdr_add_status || rc) {
@@ -14472,6 +14516,8 @@ lpfc_cq_create(struct lpfc_hba *phba, struct lpfc_queue *cq,
 		       (cq->page_size / SLI4_PAGE_SIZE));
 		bf_set(lpfc_cq_eq_id_2, &cq_create->u.request.context,
 		       eq->queue_id);
+		bf_set(lpfc_cq_context_autovalid, &cq_create->u.request.context,
+		       phba->sli4_hba.pc_sli4_params.cqav);
 	} else {
 		bf_set(lpfc_cq_eq_id, &cq_create->u.request.context,
 		       eq->queue_id);
@@ -14643,6 +14689,9 @@ lpfc_cq_create_set(struct lpfc_hba *phba, struct lpfc_queue **cqp,
 			       &cq_set->u.request, 0);
 			bf_set(lpfc_mbx_cq_create_set_num_cq,
 			       &cq_set->u.request, numcq);
+			bf_set(lpfc_mbx_cq_create_set_autovalid,
+			       &cq_set->u.request,
+			       phba->sli4_hba.pc_sli4_params.cqav);
 			switch (cq->entry_count) {
 			case 2048:
 			case 4096:
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 708167b309bd..cf64aca82bd0 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -216,6 +216,7 @@ struct lpfc_queue {
 	struct work_struct spwork;
 
 	uint64_t isr_timestamp;
+	uint8_t	qe_valid;
 	struct lpfc_queue *assoc_qp;
 	union sli4_qe qe[1];	/* array to index entries (must be last) */
 };
@@ -486,6 +487,8 @@ struct lpfc_pc_sli4_params {
 	uint8_t mqv;
 	uint8_t wqv;
 	uint8_t rqv;
+	uint8_t eqav;
+	uint8_t cqav;
 	uint8_t wqsize;
 #define LPFC_WQ_SZ64_SUPPORT	1
 #define LPFC_WQ_SZ128_SUPPORT	2
-- 
2.13.1
