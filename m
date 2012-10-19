From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH v2 07/19]  be2iscsi: Fix kernel panic in blk_iopoll disable mode.
Date: Sat, 20 Oct 2012 04:42:49 +0530
Message-ID: <079ca946-681b-443e-be8a-2cf98fc85a49@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:38754 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090Ab2JSXN7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Oct 2012 19:13:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: John Soni Jose <sony.john-n@emulex.com>, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 Kernel used to panic while running IO is disable mode, as there
 was an issue with getting the correct EQ on which completion has come.
 Fix done is create workqueue per hba and work item for each EQ created.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be.h      |    3 +
 drivers/scsi/be2iscsi/be_main.c |   83 +++++++++++++++++++++++----------------
 drivers/scsi/be2iscsi/be_main.h |    3 -
 3 files changed, 52 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be.h b/drivers/scsi/be2iscsi/be.h
index a50b6a9..3c1f8e9 100644
--- a/drivers/scsi/be2iscsi/be.h
+++ b/drivers/scsi/be2iscsi/be.h
@@ -84,9 +84,12 @@ static inline void queue_tail_inc(struct be_queue_info *q)
 /*ISCSI */
 
 struct be_eq_obj {
+	bool todo_mcc_cq;
+	bool todo_cq;
 	struct be_queue_info q;
 	struct beiscsi_hba *phba;
 	struct be_queue_info *cq;
+	struct work_struct work_cqs; /* Work Item */
 	struct blk_iopoll	iopoll;
 };
 
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 41c7c56..0217997 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -769,7 +769,7 @@ static irqreturn_t be_isr_mcc(int irq, void *dev_id)
 		     resource_id) / 32] &
 		     EQE_RESID_MASK) >> 16) == mcc->id) {
 			spin_lock_irqsave(&phba->isr_lock, flags);
-			phba->todo_mcc_cq = 1;
+			pbe_eq->todo_mcc_cq = true;
 			spin_unlock_irqrestore(&phba->isr_lock, flags);
 		}
 		AMAP_SET_BITS(struct amap_eq_entry, valid, eqe, 0);
@@ -777,8 +777,8 @@ static irqreturn_t be_isr_mcc(int irq, void *dev_id)
 		eqe = queue_tail_node(eq);
 		num_eq_processed++;
 	}
-	if (phba->todo_mcc_cq)
-		queue_work(phba->wq, &phba->work_cqs);
+	if (pbe_eq->todo_mcc_cq)
+		queue_work(phba->wq, &pbe_eq->work_cqs);
 	if (num_eq_processed)
 		hwi_ring_eq_db(phba, eq->id, 1,	num_eq_processed, 1, 1);
 
@@ -818,29 +818,26 @@ static irqreturn_t be_isr_msix(int irq, void *dev_id)
 			eqe = queue_tail_node(eq);
 			num_eq_processed++;
 		}
-		if (num_eq_processed)
-			hwi_ring_eq_db(phba, eq->id, 1,	num_eq_processed, 0, 1);
-
-		return IRQ_HANDLED;
 	} else {
 		while (eqe->dw[offsetof(struct amap_eq_entry, valid) / 32]
 						& EQE_VALID_MASK) {
 			spin_lock_irqsave(&phba->isr_lock, flags);
-			phba->todo_cq = 1;
+			pbe_eq->todo_cq = true;
 			spin_unlock_irqrestore(&phba->isr_lock, flags);
 			AMAP_SET_BITS(struct amap_eq_entry, valid, eqe, 0);
 			queue_tail_inc(eq);
 			eqe = queue_tail_node(eq);
 			num_eq_processed++;
 		}
-		if (phba->todo_cq)
-			queue_work(phba->wq, &phba->work_cqs);
-
-		if (num_eq_processed)
-			hwi_ring_eq_db(phba, eq->id, 1, num_eq_processed, 1, 1);
 
-		return IRQ_HANDLED;
+		if (pbe_eq->todo_cq)
+			queue_work(phba->wq, &pbe_eq->work_cqs);
 	}
+
+	if (num_eq_processed)
+		hwi_ring_eq_db(phba, eq->id, 1,	num_eq_processed, 0, 1);
+
+	return IRQ_HANDLED;
 }
 
 /**
@@ -888,7 +885,7 @@ static irqreturn_t be_isr(int irq, void *dev_id)
 			     resource_id) / 32] &
 			     EQE_RESID_MASK) >> 16) == mcc->id) {
 				spin_lock_irqsave(&phba->isr_lock, flags);
-				phba->todo_mcc_cq = 1;
+				pbe_eq->todo_mcc_cq = true;
 				spin_unlock_irqrestore(&phba->isr_lock, flags);
 				num_mcceq_processed++;
 			} else {
@@ -901,8 +898,8 @@ static irqreturn_t be_isr(int irq, void *dev_id)
 			eqe = queue_tail_node(eq);
 		}
 		if (num_ioeq_processed || num_mcceq_processed) {
-			if (phba->todo_mcc_cq)
-				queue_work(phba->wq, &phba->work_cqs);
+			if (pbe_eq->todo_mcc_cq)
+				queue_work(phba->wq, &pbe_eq->work_cqs);
 
 			if ((num_mcceq_processed) && (!num_ioeq_processed))
 				hwi_ring_eq_db(phba, eq->id, 0,
@@ -925,11 +922,11 @@ static irqreturn_t be_isr(int irq, void *dev_id)
 			     resource_id) / 32] &
 			     EQE_RESID_MASK) >> 16) != cq->id) {
 				spin_lock_irqsave(&phba->isr_lock, flags);
-				phba->todo_mcc_cq = 1;
+				pbe_eq->todo_mcc_cq = true;
 				spin_unlock_irqrestore(&phba->isr_lock, flags);
 			} else {
 				spin_lock_irqsave(&phba->isr_lock, flags);
-				phba->todo_cq = 1;
+				pbe_eq->todo_cq = true;
 				spin_unlock_irqrestore(&phba->isr_lock, flags);
 			}
 			AMAP_SET_BITS(struct amap_eq_entry, valid, eqe, 0);
@@ -937,8 +934,8 @@ static irqreturn_t be_isr(int irq, void *dev_id)
 			eqe = queue_tail_node(eq);
 			num_ioeq_processed++;
 		}
-		if (phba->todo_cq || phba->todo_mcc_cq)
-			queue_work(phba->wq, &phba->work_cqs);
+		if (pbe_eq->todo_cq || pbe_eq->todo_mcc_cq)
+			queue_work(phba->wq, &pbe_eq->work_cqs);
 
 		if (num_ioeq_processed) {
 			hwi_ring_eq_db(phba, eq->id, 0,
@@ -2108,30 +2105,30 @@ void beiscsi_process_all_cqs(struct work_struct *work)
 	unsigned long flags;
 	struct hwi_controller *phwi_ctrlr;
 	struct hwi_context_memory *phwi_context;
-	struct be_eq_obj *pbe_eq;
-	struct beiscsi_hba *phba =
-	    container_of(work, struct beiscsi_hba, work_cqs);
+	struct beiscsi_hba *phba;
+	struct be_eq_obj *pbe_eq =
+	    container_of(work, struct be_eq_obj, work_cqs);
 
+	phba = pbe_eq->phba;
 	phwi_ctrlr = phba->phwi_ctrlr;
 	phwi_context = phwi_ctrlr->phwi_ctxt;
-	if (phba->msix_enabled)
-		pbe_eq = &phwi_context->be_eq[phba->num_cpus];
-	else
-		pbe_eq = &phwi_context->be_eq[0];
 
-	if (phba->todo_mcc_cq) {
+	if (pbe_eq->todo_mcc_cq) {
 		spin_lock_irqsave(&phba->isr_lock, flags);
-		phba->todo_mcc_cq = 0;
+		pbe_eq->todo_mcc_cq = false;
 		spin_unlock_irqrestore(&phba->isr_lock, flags);
 		beiscsi_process_mcc_isr(phba);
 	}
 
-	if (phba->todo_cq) {
+	if (pbe_eq->todo_cq) {
 		spin_lock_irqsave(&phba->isr_lock, flags);
-		phba->todo_cq = 0;
+		pbe_eq->todo_cq = false;
 		spin_unlock_irqrestore(&phba->isr_lock, flags);
 		beiscsi_process_cq(pbe_eq);
 	}
+
+	/* rearm EQ for further interrupts */
+	hwi_ring_eq_db(phba, pbe_eq->q.id, 0, 0, 1, 1);
 }
 
 static int be_iopoll(struct blk_iopoll *iop, int budget)
@@ -4642,7 +4639,7 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 
 	phba->ctrl.mcc_alloc_index = phba->ctrl.mcc_free_index = 0;
 
-	snprintf(phba->wq_name, sizeof(phba->wq_name), "beiscsi_q_irq%u",
+	snprintf(phba->wq_name, sizeof(phba->wq_name), "beiscsi_%02x_wq",
 		 phba->shost->host_no);
 	phba->wq = alloc_workqueue(phba->wq_name, WQ_MEM_RECLAIM, 1);
 	if (!phba->wq) {
@@ -4652,10 +4649,10 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 		goto free_twq;
 	}
 
-	INIT_WORK(&phba->work_cqs, beiscsi_process_all_cqs);
 
 	phwi_ctrlr = phba->phwi_ctrlr;
 	phwi_context = phwi_ctrlr->phwi_ctxt;
+
 	if (blk_iopoll_enabled) {
 		for (i = 0; i < phba->num_cpus; i++) {
 			pbe_eq = &phwi_context->be_eq[i];
@@ -4663,7 +4660,25 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 					be_iopoll);
 			blk_iopoll_enable(&pbe_eq->iopoll);
 		}
+
+		i = (phba->msix_enabled) ? i : 0;
+		/* Work item for MCC handling */
+		pbe_eq = &phwi_context->be_eq[i];
+		INIT_WORK(&pbe_eq->work_cqs, beiscsi_process_all_cqs);
+	} else {
+		if (phba->msix_enabled) {
+			for (i = 0; i <= phba->num_cpus; i++) {
+				pbe_eq = &phwi_context->be_eq[i];
+				INIT_WORK(&pbe_eq->work_cqs,
+					  beiscsi_process_all_cqs);
+			}
+		} else {
+				pbe_eq = &phwi_context->be_eq[0];
+				INIT_WORK(&pbe_eq->work_cqs,
+					  beiscsi_process_all_cqs);
+			}
 	}
+
 	ret = beiscsi_init_irqs(phba);
 	if (ret < 0) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index e24d550..02b23c9 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -327,11 +327,8 @@ struct beiscsi_hba {
 	} fw_config;
 
 	u8 mac_address[ETH_ALEN];
-	unsigned short todo_cq;
-	unsigned short todo_mcc_cq;
 	char wq_name[20];
 	struct workqueue_struct *wq;	/* The actuak work queue */
-	struct work_struct work_cqs;	/* The work being queued */
 	struct be_ctrl_info ctrl;
 	unsigned int generation;
 	unsigned int interface_handle;
-- 
1.7.2

