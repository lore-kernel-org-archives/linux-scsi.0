From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v3 05/16] lpfc: refactor debugfs queue dump routines
Date: Sun, 12 Feb 2017 13:52:29 -0800
Message-ID: <58a0d91d.rM8geDSrb5FPALB9%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35738 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751417AbdBLVwc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Feb 2017 16:52:32 -0500
Received: by mail-oi0-f65.google.com with SMTP id x84so5873568oix.2
        for <linux-scsi@vger.kernel.org>; Sun, 12 Feb 2017 13:52:32 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org


Create common wq, cq, eq, rq dump functions

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_debugfs.c |  22 ++--
 drivers/scsi/lpfc/lpfc_debugfs.h | 214 ++++++++++++++++-----------------------
 2 files changed, 101 insertions(+), 135 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 4b00809..f8f47af 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -4555,31 +4555,31 @@ lpfc_debugfs_terminate(struct lpfc_vport *vport)
 void
 lpfc_debug_dump_all_queues(struct lpfc_hba *phba)
 {
-	int fcp_wqidx;
+	int idx;
 
 	/*
 	 * Dump Work Queues (WQs)
 	 */
-	lpfc_debug_dump_mbx_wq(phba);
-	lpfc_debug_dump_els_wq(phba);
+	lpfc_debug_dump_wq(phba, DUMP_MBX, 0);
+	lpfc_debug_dump_wq(phba, DUMP_ELS, 0);
 
-	for (fcp_wqidx = 0; fcp_wqidx < phba->cfg_fcp_io_channel; fcp_wqidx++)
-		lpfc_debug_dump_fcp_wq(phba, fcp_wqidx);
+	for (idx = 0; idx < phba->cfg_fcp_io_channel; idx++)
+		lpfc_debug_dump_wq(phba, DUMP_FCP, idx);
 
 	lpfc_debug_dump_hdr_rq(phba);
 	lpfc_debug_dump_dat_rq(phba);
 	/*
 	 * Dump Complete Queues (CQs)
 	 */
-	lpfc_debug_dump_mbx_cq(phba);
-	lpfc_debug_dump_els_cq(phba);
+	lpfc_debug_dump_cq(phba, DUMP_MBX, 0);
+	lpfc_debug_dump_cq(phba, DUMP_ELS, 0);
 
-	for (fcp_wqidx = 0; fcp_wqidx < phba->cfg_fcp_io_channel; fcp_wqidx++)
-		lpfc_debug_dump_fcp_cq(phba, fcp_wqidx);
+	for (idx = 0; idx < phba->cfg_fcp_io_channel; idx++)
+		lpfc_debug_dump_cq(phba, DUMP_FCP, idx);
 
 	/*
 	 * Dump Event Queues (EQs)
 	 */
-	for (fcp_wqidx = 0; fcp_wqidx < phba->cfg_fcp_io_channel; fcp_wqidx++)
-		lpfc_debug_dump_hba_eq(phba, fcp_wqidx);
+	for (idx = 0; idx < phba->cfg_fcp_io_channel; idx++)
+		lpfc_debug_dump_hba_eq(phba, idx);
 }
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.h b/drivers/scsi/lpfc/lpfc_debugfs.h
index 8b2b6a3..9ae2c4b 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.h
+++ b/drivers/scsi/lpfc/lpfc_debugfs.h
@@ -42,6 +42,12 @@
 /* hbqinfo output buffer size */
 #define LPFC_HBQINFO_SIZE 8192
 
+enum {
+	DUMP_FCP,
+	DUMP_MBX,
+	DUMP_ELS,
+};
+
 /*
  * For SLI4 iDiag debugfs diagnostics tool
  */
@@ -358,58 +364,97 @@ lpfc_debug_dump_q(struct lpfc_queue *q)
 }
 
 /**
- * lpfc_debug_dump_fcp_wq - dump all entries from a fcp work queue
+ * lpfc_debug_dump_wq - dump all entries from the fcp work queue
  * @phba: Pointer to HBA context object.
- * @fcp_wqidx: Index to a FCP work queue.
+ * @wqidx: Index to a FCP work queue.
  *
- * This function dumps all entries from a FCP work queue specified by the
- * @fcp_wqidx.
+ * This function dumps all entries from a FCP work queue specified
+ * by the wqidx.
  **/
 static inline void
-lpfc_debug_dump_fcp_wq(struct lpfc_hba *phba, int fcp_wqidx)
+lpfc_debug_dump_wq(struct lpfc_hba *phba, int qtype, int wqidx)
 {
-	/* sanity check */
-	if (fcp_wqidx >= phba->cfg_fcp_io_channel)
+	struct lpfc_queue *wq;
+	char *qtypestr;
+
+	if (qtype == DUMP_FCP) {
+		wq = phba->sli4_hba.fcp_wq[wqidx];
+		qtypestr = "FCP";
+	} else if (qtype == DUMP_MBX) {
+		wq = phba->sli4_hba.mbx_wq;
+		qtypestr = "MBX";
+	} else if (qtype == DUMP_ELS) {
+		wq = phba->sli4_hba.els_wq;
+		qtypestr = "ELS";
+	} else
 		return;
 
-	printk(KERN_ERR "FCP WQ: WQ[Idx:%d|Qid:%d]\n",
-		fcp_wqidx, phba->sli4_hba.fcp_wq[fcp_wqidx]->queue_id);
-	lpfc_debug_dump_q(phba->sli4_hba.fcp_wq[fcp_wqidx]);
+	if (qtype == DUMP_FCP)
+		pr_err("%s WQ: WQ[Idx:%d|Qid:%d]\n",
+			qtypestr, wqidx, wq->queue_id);
+	else
+		pr_err("%s WQ: WQ[Qid:%d]\n",
+			qtypestr, wq->queue_id);
+
+	lpfc_debug_dump_q(wq);
 }
 
 /**
- * lpfc_debug_dump_fcp_cq - dump all entries from a fcp work queue's cmpl queue
+ * lpfc_debug_dump_cq - dump all entries from a fcp work queue's
+ * cmpl queue
  * @phba: Pointer to HBA context object.
- * @fcp_wqidx: Index to a FCP work queue.
+ * @wqidx: Index to a FCP work queue.
  *
- * This function dumps all entries from a FCP complete queue which is
- * associated to the FCP work queue specified by the @fcp_wqidx.
+ * This function dumps all entries from a FCP completion queue
+ * which is associated to the work queue specified by the @wqidx.
  **/
 static inline void
-lpfc_debug_dump_fcp_cq(struct lpfc_hba *phba, int fcp_wqidx)
+lpfc_debug_dump_cq(struct lpfc_hba *phba, int qtype, int wqidx)
 {
-	int fcp_cqidx, fcp_cqid;
-
-	/* sanity check */
-	if (fcp_wqidx >= phba->cfg_fcp_io_channel)
+	struct lpfc_queue *wq, *cq, *eq;
+	char *qtypestr;
+	int eqidx;
+
+	/* fcp wq and cq are 1:1, thus same indexes */
+
+	if (qtype == DUMP_FCP) {
+		wq = phba->sli4_hba.fcp_wq[wqidx];
+		cq = phba->sli4_hba.fcp_cq[wqidx];
+		qtypestr = "FCP";
+	} else if (qtype == DUMP_MBX) {
+		wq = phba->sli4_hba.mbx_wq;
+		cq = phba->sli4_hba.mbx_cq;
+		qtypestr = "MBX";
+	} else if (qtype == DUMP_ELS) {
+		wq = phba->sli4_hba.els_wq;
+		cq = phba->sli4_hba.els_cq;
+		qtypestr = "ELS";
+	} else
 		return;
 
-	fcp_cqid = phba->sli4_hba.fcp_wq[fcp_wqidx]->assoc_qid;
-	for (fcp_cqidx = 0; fcp_cqidx < phba->cfg_fcp_io_channel; fcp_cqidx++)
-		if (phba->sli4_hba.fcp_cq[fcp_cqidx]->queue_id == fcp_cqid)
+	for (eqidx = 0; eqidx < phba->cfg_fcp_io_channel; eqidx++) {
+		eq = phba->sli4_hba.hba_eq[eqidx];
+		if (cq->assoc_qid == eq->queue_id)
 			break;
-	if (phba->intr_type == MSIX) {
-		if (fcp_cqidx >= phba->cfg_fcp_io_channel)
-			return;
-	} else {
-		if (fcp_cqidx > 0)
-			return;
+	}
+	if (eqidx == phba->cfg_fcp_io_channel) {
+		pr_err("Couldn't find EQ for CQ. Using EQ[0]\n");
+		eqidx = 0;
+		eq = phba->sli4_hba.hba_eq[0];
 	}
 
-	printk(KERN_ERR "FCP CQ: WQ[Idx:%d|Qid%d]->CQ[Idx%d|Qid%d]:\n",
-		fcp_wqidx, phba->sli4_hba.fcp_wq[fcp_wqidx]->queue_id,
-		fcp_cqidx, fcp_cqid);
-	lpfc_debug_dump_q(phba->sli4_hba.fcp_cq[fcp_cqidx]);
+	if (qtype == DUMP_FCP)
+		pr_err("%s CQ: WQ[Idx:%d|Qid%d]->CQ[Idx%d|Qid%d]"
+			"->EQ[Idx:%d|Qid:%d]:\n",
+			qtypestr, wqidx, wq->queue_id, wqidx, cq->queue_id,
+			eqidx, eq->queue_id);
+	else
+		pr_err("%s CQ: WQ[Qid:%d]->CQ[Qid:%d]"
+			"->EQ[Idx:%d|Qid:%d]:\n",
+			qtypestr, wq->queue_id, cq->queue_id,
+			eqidx, eq->queue_id);
+
+	lpfc_debug_dump_q(cq);
 }
 
 /**
@@ -421,64 +466,15 @@ lpfc_debug_dump_fcp_cq(struct lpfc_hba *phba, int fcp_wqidx)
  * associated to the FCP work queue specified by the @fcp_wqidx.
  **/
 static inline void
-lpfc_debug_dump_hba_eq(struct lpfc_hba *phba, int fcp_wqidx)
+lpfc_debug_dump_hba_eq(struct lpfc_hba *phba, int qidx)
 {
-	struct lpfc_queue *qdesc;
-	int fcp_eqidx, fcp_eqid;
-	int fcp_cqidx, fcp_cqid;
-
-	/* sanity check */
-	if (fcp_wqidx >= phba->cfg_fcp_io_channel)
-		return;
-	fcp_cqid = phba->sli4_hba.fcp_wq[fcp_wqidx]->assoc_qid;
-	for (fcp_cqidx = 0; fcp_cqidx < phba->cfg_fcp_io_channel; fcp_cqidx++)
-		if (phba->sli4_hba.fcp_cq[fcp_cqidx]->queue_id == fcp_cqid)
-			break;
-	if (phba->intr_type == MSIX) {
-		if (fcp_cqidx >= phba->cfg_fcp_io_channel)
-			return;
-	} else {
-		if (fcp_cqidx > 0)
-			return;
-	}
+	struct lpfc_queue *qp;
 
-	fcp_eqidx = fcp_cqidx;
-	fcp_eqid = phba->sli4_hba.hba_eq[fcp_eqidx]->queue_id;
-	qdesc = phba->sli4_hba.hba_eq[fcp_eqidx];
+	qp = phba->sli4_hba.hba_eq[qidx];
 
-	printk(KERN_ERR "FCP EQ: WQ[Idx:%d|Qid:%d]->CQ[Idx:%d|Qid:%d]->"
-		"EQ[Idx:%d|Qid:%d]\n",
-		fcp_wqidx, phba->sli4_hba.fcp_wq[fcp_wqidx]->queue_id,
-		fcp_cqidx, fcp_cqid, fcp_eqidx, fcp_eqid);
-	lpfc_debug_dump_q(qdesc);
-}
+	pr_err("EQ[Idx:%d|Qid:%d]\n", qidx, qp->queue_id);
 
-/**
- * lpfc_debug_dump_els_wq - dump all entries from the els work queue
- * @phba: Pointer to HBA context object.
- *
- * This function dumps all entries from the ELS work queue.
- **/
-static inline void
-lpfc_debug_dump_els_wq(struct lpfc_hba *phba)
-{
-	printk(KERN_ERR "ELS WQ: WQ[Qid:%d]:\n",
-		phba->sli4_hba.els_wq->queue_id);
-	lpfc_debug_dump_q(phba->sli4_hba.els_wq);
-}
-
-/**
- * lpfc_debug_dump_mbx_wq - dump all entries from the mbox work queue
- * @phba: Pointer to HBA context object.
- *
- * This function dumps all entries from the MBOX work queue.
- **/
-static inline void
-lpfc_debug_dump_mbx_wq(struct lpfc_hba *phba)
-{
-	printk(KERN_ERR "MBX WQ: WQ[Qid:%d]\n",
-		phba->sli4_hba.mbx_wq->queue_id);
-	lpfc_debug_dump_q(phba->sli4_hba.mbx_wq);
+	lpfc_debug_dump_q(qp);
 }
 
 /**
@@ -510,36 +506,6 @@ lpfc_debug_dump_hdr_rq(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_debug_dump_els_cq - dump all entries from the els complete queue
- * @phba: Pointer to HBA context object.
- *
- * This function dumps all entries from the els complete queue.
- **/
-static inline void
-lpfc_debug_dump_els_cq(struct lpfc_hba *phba)
-{
-	printk(KERN_ERR "ELS CQ: WQ[Qid:%d]->CQ[Qid:%d]\n",
-		phba->sli4_hba.els_wq->queue_id,
-		phba->sli4_hba.els_cq->queue_id);
-	lpfc_debug_dump_q(phba->sli4_hba.els_cq);
-}
-
-/**
- * lpfc_debug_dump_mbx_cq - dump all entries from the mbox complete queue
- * @phba: Pointer to HBA context object.
- *
- * This function dumps all entries from the mbox complete queue.
- **/
-static inline void
-lpfc_debug_dump_mbx_cq(struct lpfc_hba *phba)
-{
-	printk(KERN_ERR "MBX CQ: WQ[Qid:%d]->CQ[Qid:%d]\n",
-		phba->sli4_hba.mbx_wq->queue_id,
-		phba->sli4_hba.mbx_cq->queue_id);
-	lpfc_debug_dump_q(phba->sli4_hba.mbx_cq);
-}
-
-/**
  * lpfc_debug_dump_wq_by_id - dump all entries from a work queue by queue id
  * @phba: Pointer to HBA context object.
  * @qid: Work queue identifier.
@@ -556,14 +522,15 @@ lpfc_debug_dump_wq_by_id(struct lpfc_hba *phba, int qid)
 		if (phba->sli4_hba.fcp_wq[wq_idx]->queue_id == qid)
 			break;
 	if (wq_idx < phba->cfg_fcp_io_channel) {
-		printk(KERN_ERR "FCP WQ[Idx:%d|Qid:%d]\n", wq_idx, qid);
+		pr_err("FCP WQ[Idx:%d|Qid:%d]\n", wq_idx, qid);
 		lpfc_debug_dump_q(phba->sli4_hba.fcp_wq[wq_idx]);
 		return;
 	}
 
 	if (phba->sli4_hba.els_wq->queue_id == qid) {
-		printk(KERN_ERR "ELS WQ[Qid:%d]\n", qid);
+		pr_err("ELS WQ[Qid:%d]\n", qid);
 		lpfc_debug_dump_q(phba->sli4_hba.els_wq);
+		return;
 	}
 }
 
@@ -617,27 +584,26 @@ lpfc_debug_dump_rq_by_id(struct lpfc_hba *phba, int qid)
 static inline void
 lpfc_debug_dump_cq_by_id(struct lpfc_hba *phba, int qid)
 {
-	int cq_idx = 0;
+	int cq_idx;
 
-	do {
+	for (cq_idx = 0; cq_idx < phba->cfg_fcp_io_channel; cq_idx++)
 		if (phba->sli4_hba.fcp_cq[cq_idx]->queue_id == qid)
 			break;
-	} while (++cq_idx < phba->cfg_fcp_io_channel);
 
 	if (cq_idx < phba->cfg_fcp_io_channel) {
-		printk(KERN_ERR "FCP CQ[Idx:%d|Qid:%d]\n", cq_idx, qid);
+		pr_err("FCP CQ[Idx:%d|Qid:%d]\n", cq_idx, qid);
 		lpfc_debug_dump_q(phba->sli4_hba.fcp_cq[cq_idx]);
 		return;
 	}
 
 	if (phba->sli4_hba.els_cq->queue_id == qid) {
-		printk(KERN_ERR "ELS CQ[Qid:%d]\n", qid);
+		pr_err("ELS CQ[Qid:%d]\n", qid);
 		lpfc_debug_dump_q(phba->sli4_hba.els_cq);
 		return;
 	}
 
 	if (phba->sli4_hba.mbx_cq->queue_id == qid) {
-		printk(KERN_ERR "MBX CQ[Qid:%d]\n", qid);
+		pr_err("MBX CQ[Qid:%d]\n", qid);
 		lpfc_debug_dump_q(phba->sli4_hba.mbx_cq);
 	}
 }
-- 
2.5.0
