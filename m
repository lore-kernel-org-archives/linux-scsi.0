From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH 07/17] be2iscsi: Fix the kernel panic in blkiopoll disable mode
Date: Sat, 29 Sep 2012 07:02:53 +0530
Message-ID: <da282c92-f339-43bc-a13f-28e13a2420a3@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:52555 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758342Ab2I2Bd6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Sep 2012 21:33:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 Fix kernel panic issue while running IO in blk_iopoll disable mode.
 Creating UNBOUND WQ for each EQ in the driver.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be.h      |    5 +
 drivers/scsi/be2iscsi/be_main.c |  159 +++++++++++++++++++++++++-------------
 drivers/scsi/be2iscsi/be_main.h |    5 -
 3 files changed, 109 insertions(+), 60 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be.h b/drivers/scsi/be2iscsi/be.h
index a50b6a9..be67c90 100644
--- a/drivers/scsi/be2iscsi/be.h
+++ b/drivers/scsi/be2iscsi/be.h
@@ -84,9 +84,14 @@ static inline void queue_tail_inc(struct be_queue_info *q)
 /*ISCSI */
 
 struct be_eq_obj {
+	char wq_name[32];
+	bool todo_mcc_cq;
+	bool todo_cq;
 	struct be_queue_info q;
 	struct beiscsi_hba *phba;
 	struct be_queue_info *cq;
+	struct workqueue_struct *wq; /* Work Q */
+	struct work_struct work_cqs; /* Work Item */
 	struct blk_iopoll	iopoll;
 };
 
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 0fb36b4..0ce96a0 100644
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
+		queue_work(pbe_eq->wq, &pbe_eq->work_cqs);
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
+			queue_work(pbe_eq->wq, &pbe_eq->work_cqs);
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
+				queue_work(pbe_eq->wq, &pbe_eq->work_cqs);
 
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
+			queue_work(pbe_eq->wq, &pbe_eq->work_cqs);
 
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
@@ -4464,13 +4461,28 @@ static void beiscsi_quiesce(struct beiscsi_hba *phba)
 	} else
 		if (phba->pcidev->irq)
 			free_irq(phba->pcidev->irq, phba);
+
 	pci_disable_msix(phba->pcidev);
-	destroy_workqueue(phba->wq);
-	if (blk_iopoll_enabled)
+
+	if (!blk_iopoll_enabled) {
+		if (phba->msix_enabled) {
+			for (i = 0; i <= phba->num_cpus; i++) {
+				pbe_eq = &phwi_context->be_eq[i];
+				destroy_workqueue(pbe_eq->wq);
+			}
+		} else {
+			pbe_eq = &phwi_context->be_eq[0];
+			destroy_workqueue(pbe_eq->wq);
+		}
+	} else {
 		for (i = 0; i < phba->num_cpus; i++) {
 			pbe_eq = &phwi_context->be_eq[i];
 			blk_iopoll_disable(&pbe_eq->iopoll);
 		}
+		pbe_eq = (phba->msix_enabled) ? &phwi_context->be_eq[i] :
+			 &phwi_context->be_eq[0];
+		destroy_workqueue(pbe_eq->wq);
+	}
 
 	beiscsi_clean_port(phba);
 	beiscsi_free_mem(phba);
@@ -4646,34 +4658,78 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 
 	phba->ctrl.mcc_alloc_index = phba->ctrl.mcc_free_index = 0;
 
-	snprintf(phba->wq_name, sizeof(phba->wq_name), "beiscsi_q_irq%u",
-		 phba->shost->host_no);
-	phba->wq = alloc_workqueue(phba->wq_name, WQ_MEM_RECLAIM, 1);
-	if (!phba->wq) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : beiscsi_dev_probe-"
-			    "Failed to allocate work queue\n");
-		goto free_twq;
-	}
-
-	INIT_WORK(&phba->work_cqs, beiscsi_process_all_cqs);
-
 	phwi_ctrlr = phba->phwi_ctrlr;
 	phwi_context = phwi_ctrlr->phwi_ctxt;
-	if (blk_iopoll_enabled) {
+
+	if (!blk_iopoll_enabled) {
+		if (phba->msix_enabled) {
+			for (i = 0; i <= phba->num_cpus ; i++) {
+				pbe_eq = &phwi_context->be_eq[i];
+				snprintf(pbe_eq->wq_name,
+					 sizeof(pbe_eq->wq_name),
+					 "beiscsi_wq%02x_eq%02x",
+					 phba->shost->host_no, i);
+				pbe_eq->wq =
+					alloc_workqueue(pbe_eq->wq_name,
+							WQ_MEM_RECLAIM |
+							WQ_UNBOUND,
+							1);
+				if (!pbe_eq->wq) {
+					shost_printk(KERN_ERR, phba->shost,
+						     "beiscsi_dev_probe -"
+						     "Failed to allocate work queue\n");
+					goto free_twq;
+				}
+				INIT_WORK(&pbe_eq->work_cqs,
+					  beiscsi_process_all_cqs);
+			}
+		} else {
+			pbe_eq = &phwi_context->be_eq[0];
+			snprintf(pbe_eq->wq_name, sizeof(pbe_eq->wq_name),
+				 "beiscsi_wq%02x_eq_0",
+				 phba->shost->host_no);
+
+				pbe_eq->wq =
+					alloc_workqueue(pbe_eq->wq_name,
+							WQ_MEM_RECLAIM |
+							WQ_UNBOUND,
+							1);
+			if (!pbe_eq->wq) {
+				shost_printk(KERN_ERR, phba->shost,
+					     "beiscsi_dev_probe -"
+					     "Failed to allocate work queue\n");
+				goto free_twq;
+			}
+			INIT_WORK(&pbe_eq->work_cqs, beiscsi_process_all_cqs);
+		}
+	} else {
 		for (i = 0; i < phba->num_cpus; i++) {
 			pbe_eq = &phwi_context->be_eq[i];
 			blk_iopoll_init(&pbe_eq->iopoll, be_iopoll_budget,
 					be_iopoll);
 			blk_iopoll_enable(&pbe_eq->iopoll);
 		}
+		pbe_eq = &phwi_context->be_eq[i];
+		snprintf(pbe_eq->wq_name, sizeof(pbe_eq->wq_name),
+			 "beiscsi_wq%02x_eq_0",
+			 phba->shost->host_no);
+		 pbe_eq->wq = alloc_workqueue(pbe_eq->wq_name,
+					      WQ_MEM_RECLAIM | WQ_UNBOUND, 1);
+		if (!pbe_eq->wq) {
+			shost_printk(KERN_ERR, phba->shost,
+				     "beiscsi_dev_probe -"
+				     "Failed to allocate work queue\n");
+			goto free_twq;
+		}
+		INIT_WORK(&pbe_eq->work_cqs, beiscsi_process_all_cqs);
 	}
+
 	ret = beiscsi_init_irqs(phba);
 	if (ret < 0) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
 			    "BM_%d : beiscsi_dev_probe-"
 			    "Failed to beiscsi_init_irqs\n");
-		goto free_blkenbld;
+		goto free_twq;
 	}
 	hwi_enable_intr(phba);
 
@@ -4691,13 +4747,6 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 		    "\n\n\n BM_%d : SUCCESS - DRIVER LOADED\n\n\n");
 	return 0;
 
-free_blkenbld:
-	destroy_workqueue(phba->wq);
-	if (blk_iopoll_enabled)
-		for (i = 0; i < phba->num_cpus; i++) {
-			pbe_eq = &phwi_context->be_eq[i];
-			blk_iopoll_disable(&pbe_eq->iopoll);
-		}
 free_twq:
 	beiscsi_clean_port(phba);
 	beiscsi_free_mem(phba);
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index e24d550..687ac28 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -327,11 +327,6 @@ struct beiscsi_hba {
 	} fw_config;
 
 	u8 mac_address[ETH_ALEN];
-	unsigned short todo_cq;
-	unsigned short todo_mcc_cq;
-	char wq_name[20];
-	struct workqueue_struct *wq;	/* The actuak work queue */
-	struct work_struct work_cqs;	/* The work being queued */
 	struct be_ctrl_info ctrl;
 	unsigned int generation;
 	unsigned int interface_handle;
-- 
1.7.2

