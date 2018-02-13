From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v3 01/13] lpfc: Rework lpfc to allow different sli4 cq and eq handlers
Date: Tue, 13 Feb 2018 11:34:45 -0800
Message-ID: <20180213193457.21206-2-jsmart2021@gmail.com>
References: <20180213193457.21206-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:43055 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965625AbeBMTfd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Feb 2018 14:35:33 -0500
Received: by mail-qk0-f193.google.com with SMTP id i184so12727939qkf.10
        for <linux-scsi@vger.kernel.org>; Tue, 13 Feb 2018 11:35:33 -0800 (PST)
In-Reply-To: <20180213193457.21206-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Up until now, an SLI-4 device had no variance in the way it handled
its EQs and CQs. With newer hardware, there are now differences in
doorbells and some differences in how entries are valid.

Prepare the code for new hardware by creating a sli4-based callout
table that can be set based on if_type.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_init.c |  7 +++++
 drivers/scsi/lpfc/lpfc_sli.c  | 63 ++++++++++++++++++++++---------------------
 drivers/scsi/lpfc/lpfc_sli4.h |  5 ++++
 3 files changed, 44 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 465d890220d5..e24dca2b3f2f 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -9540,6 +9540,13 @@ lpfc_sli4_pci_mem_setup(struct lpfc_hba *phba)
 		}
 	}
 
+	/* Set up the EQ/CQ register handeling functions now */
+	if (if_type <= LPFC_SLI_INTF_IF_TYPE_2) {
+		phba->sli4_hba.sli4_eq_clr_intr = lpfc_sli4_eq_clr_intr;
+		phba->sli4_hba.sli4_eq_release = lpfc_sli4_eq_release;
+		phba->sli4_hba.sli4_cq_release = lpfc_sli4_cq_release;
+	}
+
 	return 0;
 
 out_iounmap_all:
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index e97d080e9f65..f91caae6489a 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -299,7 +299,7 @@ lpfc_sli4_eq_get(struct lpfc_queue *q)
  * @q: The Event Queue to disable interrupts
  *
  **/
-static inline void
+inline void
 lpfc_sli4_eq_clr_intr(struct lpfc_queue *q)
 {
 	struct lpfc_register doorbell;
@@ -5302,41 +5302,42 @@ static void
 lpfc_sli4_arm_cqeq_intr(struct lpfc_hba *phba)
 {
 	int qidx;
+	struct lpfc_sli4_hba *sli4_hba = &phba->sli4_hba;
 
-	lpfc_sli4_cq_release(phba->sli4_hba.mbx_cq, LPFC_QUEUE_REARM);
-	lpfc_sli4_cq_release(phba->sli4_hba.els_cq, LPFC_QUEUE_REARM);
-	if (phba->sli4_hba.nvmels_cq)
-		lpfc_sli4_cq_release(phba->sli4_hba.nvmels_cq,
+	sli4_hba->sli4_cq_release(sli4_hba->mbx_cq, LPFC_QUEUE_REARM);
+	sli4_hba->sli4_cq_release(sli4_hba->els_cq, LPFC_QUEUE_REARM);
+	if (sli4_hba->nvmels_cq)
+		sli4_hba->sli4_cq_release(sli4_hba->nvmels_cq,
 						LPFC_QUEUE_REARM);
 
-	if (phba->sli4_hba.fcp_cq)
+	if (sli4_hba->fcp_cq)
 		for (qidx = 0; qidx < phba->cfg_fcp_io_channel; qidx++)
-			lpfc_sli4_cq_release(phba->sli4_hba.fcp_cq[qidx],
+			sli4_hba->sli4_cq_release(sli4_hba->fcp_cq[qidx],
 						LPFC_QUEUE_REARM);
 
-	if (phba->sli4_hba.nvme_cq)
+	if (sli4_hba->nvme_cq)
 		for (qidx = 0; qidx < phba->cfg_nvme_io_channel; qidx++)
-			lpfc_sli4_cq_release(phba->sli4_hba.nvme_cq[qidx],
+			sli4_hba->sli4_cq_release(sli4_hba->nvme_cq[qidx],
 						LPFC_QUEUE_REARM);
 
 	if (phba->cfg_fof)
-		lpfc_sli4_cq_release(phba->sli4_hba.oas_cq, LPFC_QUEUE_REARM);
+		sli4_hba->sli4_cq_release(sli4_hba->oas_cq, LPFC_QUEUE_REARM);
 
-	if (phba->sli4_hba.hba_eq)
+	if (sli4_hba->hba_eq)
 		for (qidx = 0; qidx < phba->io_channel_irqs; qidx++)
-			lpfc_sli4_eq_release(phba->sli4_hba.hba_eq[qidx],
-						LPFC_QUEUE_REARM);
+			sli4_hba->sli4_eq_release(sli4_hba->hba_eq[qidx],
+							LPFC_QUEUE_REARM);
 
 	if (phba->nvmet_support) {
 		for (qidx = 0; qidx < phba->cfg_nvmet_mrq; qidx++) {
-			lpfc_sli4_cq_release(
-				phba->sli4_hba.nvmet_cqset[qidx],
+			sli4_hba->sli4_cq_release(
+				sli4_hba->nvmet_cqset[qidx],
 				LPFC_QUEUE_REARM);
 		}
 	}
 
 	if (phba->cfg_fof)
-		lpfc_sli4_eq_release(phba->sli4_hba.fof_eq, LPFC_QUEUE_REARM);
+		sli4_hba->sli4_eq_release(sli4_hba->fof_eq, LPFC_QUEUE_REARM);
 }
 
 /**
@@ -7270,7 +7271,7 @@ lpfc_sli4_mbox_completions_pending(struct lpfc_hba *phba)
 bool
 lpfc_sli4_process_missed_mbox_completions(struct lpfc_hba *phba)
 {
-
+	struct lpfc_sli4_hba *sli4_hba = &phba->sli4_hba;
 	uint32_t eqidx;
 	struct lpfc_queue *fpeq = NULL;
 	struct lpfc_eqe *eqe;
@@ -7281,11 +7282,11 @@ lpfc_sli4_process_missed_mbox_completions(struct lpfc_hba *phba)
 
 	/* Find the eq associated with the mcq */
 
-	if (phba->sli4_hba.hba_eq)
+	if (sli4_hba->hba_eq)
 		for (eqidx = 0; eqidx < phba->io_channel_irqs; eqidx++)
-			if (phba->sli4_hba.hba_eq[eqidx]->queue_id ==
-			    phba->sli4_hba.mbx_cq->assoc_qid) {
-				fpeq = phba->sli4_hba.hba_eq[eqidx];
+			if (sli4_hba->hba_eq[eqidx]->queue_id ==
+			    sli4_hba->mbx_cq->assoc_qid) {
+				fpeq = sli4_hba->hba_eq[eqidx];
 				break;
 			}
 	if (!fpeq)
@@ -7293,7 +7294,7 @@ lpfc_sli4_process_missed_mbox_completions(struct lpfc_hba *phba)
 
 	/* Turn off interrupts from this EQ */
 
-	lpfc_sli4_eq_clr_intr(fpeq);
+	sli4_hba->sli4_eq_clr_intr(fpeq);
 
 	/* Check to see if a mbox completion is pending */
 
@@ -7314,7 +7315,7 @@ lpfc_sli4_process_missed_mbox_completions(struct lpfc_hba *phba)
 
 	/* Always clear and re-arm the EQ */
 
-	lpfc_sli4_eq_release(fpeq, LPFC_QUEUE_REARM);
+	sli4_hba->sli4_eq_release(fpeq, LPFC_QUEUE_REARM);
 
 	return mbox_pending;
 
@@ -9494,7 +9495,7 @@ lpfc_sli_issue_iocb(struct lpfc_hba *phba, uint32_t ring_number,
 				fpeq = phba->sli4_hba.hba_eq[idx];
 
 				/* Turn off interrupts from this EQ */
-				lpfc_sli4_eq_clr_intr(fpeq);
+				phba->sli4_hba.sli4_eq_clr_intr(fpeq);
 
 				/*
 				 * Process all the events on FCP EQ
@@ -9506,7 +9507,7 @@ lpfc_sli_issue_iocb(struct lpfc_hba *phba, uint32_t ring_number,
 				}
 
 				/* Always clear and re-arm the EQ */
-				lpfc_sli4_eq_release(fpeq,
+				phba->sli4_hba.sli4_eq_release(fpeq,
 					LPFC_QUEUE_REARM);
 			}
 			atomic_inc(&hba_eq_hdl->hba_eq_in_use);
@@ -13136,7 +13137,7 @@ lpfc_sli4_sp_process_cq(struct work_struct *work)
 				"(x%x), type (%d)\n", cq->queue_id, cq->type);
 
 	/* In any case, flash and re-arm the RCQ */
-	lpfc_sli4_cq_release(cq, LPFC_QUEUE_REARM);
+	phba->sli4_hba.sli4_cq_release(cq, LPFC_QUEUE_REARM);
 
 	/* wake up worker thread if there are works to be done */
 	if (workposted)
@@ -13568,7 +13569,7 @@ lpfc_sli4_hba_process_cq(struct work_struct *work)
 				"queue fcpcqid=%d\n", cq->queue_id);
 
 	/* In any case, flash and re-arm the CQ */
-	lpfc_sli4_cq_release(cq, LPFC_QUEUE_REARM);
+	phba->sli4_hba.sli4_cq_release(cq, LPFC_QUEUE_REARM);
 
 	/* wake up worker thread if there are works to be done */
 	if (workposted)
@@ -13585,7 +13586,7 @@ lpfc_sli4_eq_flush(struct lpfc_hba *phba, struct lpfc_queue *eq)
 		;
 
 	/* Clear and re-arm the EQ */
-	lpfc_sli4_eq_release(eq, LPFC_QUEUE_REARM);
+	phba->sli4_hba.sli4_eq_release(eq, LPFC_QUEUE_REARM);
 }
 
 
@@ -13733,7 +13734,7 @@ lpfc_sli4_fof_intr_handler(int irq, void *dev_id)
 		}
 	}
 	/* Always clear and re-arm the fast-path EQ */
-	lpfc_sli4_eq_release(eq, LPFC_QUEUE_REARM);
+	phba->sli4_hba.sli4_eq_release(eq, LPFC_QUEUE_REARM);
 	return IRQ_HANDLED;
 }
 
@@ -13791,7 +13792,7 @@ lpfc_sli4_hba_intr_handler(int irq, void *dev_id)
 
 	if (lpfc_fcp_look_ahead) {
 		if (atomic_dec_and_test(&hba_eq_hdl->hba_eq_in_use))
-			lpfc_sli4_eq_clr_intr(fpeq);
+			phba->sli4_hba.sli4_eq_clr_intr(fpeq);
 		else {
 			atomic_inc(&hba_eq_hdl->hba_eq_in_use);
 			return IRQ_NONE;
@@ -13826,7 +13827,7 @@ lpfc_sli4_hba_intr_handler(int irq, void *dev_id)
 		fpeq->EQ_max_eqe = ecount;
 
 	/* Always clear and re-arm the fast-path EQ */
-	lpfc_sli4_eq_release(fpeq, LPFC_QUEUE_REARM);
+	phba->sli4_hba.sli4_eq_release(fpeq, LPFC_QUEUE_REARM);
 
 	if (unlikely(ecount == 0)) {
 		fpeq->EQ_no_entry++;
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 4545c1fdcb55..0c0cbe296fed 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -582,6 +582,10 @@ struct lpfc_sli4_hba {
 	struct lpfc_bbscn_params bbscn_params;
 	struct lpfc_hba_eq_hdl *hba_eq_hdl; /* HBA per-WQ handle */
 
+	void (*sli4_eq_clr_intr)(struct lpfc_queue *q);
+	uint32_t (*sli4_eq_release)(struct lpfc_queue *q, bool arm);
+	uint32_t (*sli4_cq_release)(struct lpfc_queue *q, bool arm);
+
 	/* Pointers to the constructed SLI4 queues */
 	struct lpfc_queue **hba_eq;  /* Event queues for HBA */
 	struct lpfc_queue **fcp_cq;  /* Fast-path FCP compl queue */
@@ -848,6 +852,7 @@ void lpfc_sli_remove_dflt_fcf(struct lpfc_hba *);
 int lpfc_sli4_get_els_iocb_cnt(struct lpfc_hba *);
 int lpfc_sli4_get_iocb_cnt(struct lpfc_hba *phba);
 int lpfc_sli4_init_vpi(struct lpfc_vport *);
+inline void lpfc_sli4_eq_clr_intr(struct lpfc_queue *);
 uint32_t lpfc_sli4_cq_release(struct lpfc_queue *, bool);
 uint32_t lpfc_sli4_eq_release(struct lpfc_queue *, bool);
 void lpfc_sli4_fcfi_unreg(struct lpfc_hba *, uint16_t);
-- 
2.13.1
