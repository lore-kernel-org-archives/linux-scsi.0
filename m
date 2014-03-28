From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH] Block/iopoll: Remove redundant export variable blk_iopoll_enabled
Date: Fri, 28 Mar 2014 23:01:29 +0300
Message-ID: <1396036889-10794-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailp.voltaire.com ([193.47.165.129]:53697 "EHLO mellanox.co.il"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752383AbaC1UBy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Mar 2014 16:01:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@fb.com
Cc: linux-scsi@vger.kernel.org, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, Wen Xiong <wenxiong@linux.vnet.ibm.com>, Brian King <brking@us.ibm.com>

No need for this variable anymore - blk_iopoll should always
be enabled. Also remove the user references to it.

I just removed the blk_iopoll_enabled condition from the user logic
but I don't have the facilities to test that I didn't break be2iscsi
or ipr users, So I was hoping that Jayamohan & Wen can confirm.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Cc: Wen Xiong <wenxiong@linux.vnet.ibm.com>
Cc: Brian King <brking@us.ibm.com>
---
 block/blk-iopoll.c              |    3 -
 drivers/scsi/be2iscsi/be_main.c |  206 ++++++++++++---------------------------
 drivers/scsi/ipr.c              |   20 ++--
 include/linux/blk-iopoll.h      |    2 -
 kernel/sysctl.c                 |   12 ---
 5 files changed, 73 insertions(+), 170 deletions(-)

diff --git a/block/blk-iopoll.c b/block/blk-iopoll.c
index 1855bf5..c11d24e 100644
--- a/block/blk-iopoll.c
+++ b/block/blk-iopoll.c
@@ -14,9 +14,6 @@
 
 #include "blk.h"
 
-int blk_iopoll_enabled = 1;
-EXPORT_SYMBOL(blk_iopoll_enabled);
-
 static unsigned int blk_iopoll_budget __read_mostly = 256;
 
 static DEFINE_PER_CPU(struct list_head, blk_cpu_iopoll);
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 1f37505..a929c3c 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -873,7 +873,6 @@ static irqreturn_t be_isr_msix(int irq, void *dev_id)
 	struct be_queue_info *cq;
 	unsigned int num_eq_processed;
 	struct be_eq_obj *pbe_eq;
-	unsigned long flags;
 
 	pbe_eq = dev_id;
 	eq = &pbe_eq->q;
@@ -882,31 +881,15 @@ static irqreturn_t be_isr_msix(int irq, void *dev_id)
 
 	phba = pbe_eq->phba;
 	num_eq_processed = 0;
-	if (blk_iopoll_enabled) {
-		while (eqe->dw[offsetof(struct amap_eq_entry, valid) / 32]
-					& EQE_VALID_MASK) {
-			if (!blk_iopoll_sched_prep(&pbe_eq->iopoll))
-				blk_iopoll_sched(&pbe_eq->iopoll);
-
-			AMAP_SET_BITS(struct amap_eq_entry, valid, eqe, 0);
-			queue_tail_inc(eq);
-			eqe = queue_tail_node(eq);
-			num_eq_processed++;
-		}
-	} else {
-		while (eqe->dw[offsetof(struct amap_eq_entry, valid) / 32]
-						& EQE_VALID_MASK) {
-			spin_lock_irqsave(&phba->isr_lock, flags);
-			pbe_eq->todo_cq = true;
-			spin_unlock_irqrestore(&phba->isr_lock, flags);
-			AMAP_SET_BITS(struct amap_eq_entry, valid, eqe, 0);
-			queue_tail_inc(eq);
-			eqe = queue_tail_node(eq);
-			num_eq_processed++;
-		}
+	while (eqe->dw[offsetof(struct amap_eq_entry, valid) / 32]
+				& EQE_VALID_MASK) {
+		if (!blk_iopoll_sched_prep(&pbe_eq->iopoll))
+			blk_iopoll_sched(&pbe_eq->iopoll);
 
-		if (pbe_eq->todo_cq)
-			queue_work(phba->wq, &pbe_eq->work_cqs);
+		AMAP_SET_BITS(struct amap_eq_entry, valid, eqe, 0);
+		queue_tail_inc(eq);
+		eqe = queue_tail_node(eq);
+		num_eq_processed++;
 	}
 
 	if (num_eq_processed)
@@ -927,7 +910,6 @@ static irqreturn_t be_isr(int irq, void *dev_id)
 	struct hwi_context_memory *phwi_context;
 	struct be_eq_entry *eqe = NULL;
 	struct be_queue_info *eq;
-	struct be_queue_info *cq;
 	struct be_queue_info *mcc;
 	unsigned long flags, index;
 	unsigned int num_mcceq_processed, num_ioeq_processed;
@@ -953,72 +935,40 @@ static irqreturn_t be_isr(int irq, void *dev_id)
 
 	num_ioeq_processed = 0;
 	num_mcceq_processed = 0;
-	if (blk_iopoll_enabled) {
-		while (eqe->dw[offsetof(struct amap_eq_entry, valid) / 32]
-					& EQE_VALID_MASK) {
-			if (((eqe->dw[offsetof(struct amap_eq_entry,
-			     resource_id) / 32] &
-			     EQE_RESID_MASK) >> 16) == mcc->id) {
-				spin_lock_irqsave(&phba->isr_lock, flags);
-				pbe_eq->todo_mcc_cq = true;
-				spin_unlock_irqrestore(&phba->isr_lock, flags);
-				num_mcceq_processed++;
-			} else {
-				if (!blk_iopoll_sched_prep(&pbe_eq->iopoll))
-					blk_iopoll_sched(&pbe_eq->iopoll);
-				num_ioeq_processed++;
-			}
-			AMAP_SET_BITS(struct amap_eq_entry, valid, eqe, 0);
-			queue_tail_inc(eq);
-			eqe = queue_tail_node(eq);
-		}
-		if (num_ioeq_processed || num_mcceq_processed) {
-			if (pbe_eq->todo_mcc_cq)
-				queue_work(phba->wq, &pbe_eq->work_cqs);
-
-			if ((num_mcceq_processed) && (!num_ioeq_processed))
-				hwi_ring_eq_db(phba, eq->id, 0,
-					      (num_ioeq_processed +
-					       num_mcceq_processed) , 1, 1);
-			else
-				hwi_ring_eq_db(phba, eq->id, 0,
-					       (num_ioeq_processed +
-						num_mcceq_processed), 0, 1);
-
-			return IRQ_HANDLED;
-		} else
-			return IRQ_NONE;
-	} else {
-		cq = &phwi_context->be_cq[0];
-		while (eqe->dw[offsetof(struct amap_eq_entry, valid) / 32]
-						& EQE_VALID_MASK) {
-
-			if (((eqe->dw[offsetof(struct amap_eq_entry,
-			     resource_id) / 32] &
-			     EQE_RESID_MASK) >> 16) != cq->id) {
-				spin_lock_irqsave(&phba->isr_lock, flags);
-				pbe_eq->todo_mcc_cq = true;
-				spin_unlock_irqrestore(&phba->isr_lock, flags);
-			} else {
-				spin_lock_irqsave(&phba->isr_lock, flags);
-				pbe_eq->todo_cq = true;
-				spin_unlock_irqrestore(&phba->isr_lock, flags);
-			}
-			AMAP_SET_BITS(struct amap_eq_entry, valid, eqe, 0);
-			queue_tail_inc(eq);
-			eqe = queue_tail_node(eq);
+	while (eqe->dw[offsetof(struct amap_eq_entry, valid) / 32]
+				& EQE_VALID_MASK) {
+		if (((eqe->dw[offsetof(struct amap_eq_entry,
+		     resource_id) / 32] &
+		     EQE_RESID_MASK) >> 16) == mcc->id) {
+			spin_lock_irqsave(&phba->isr_lock, flags);
+			pbe_eq->todo_mcc_cq = true;
+			spin_unlock_irqrestore(&phba->isr_lock, flags);
+			num_mcceq_processed++;
+		} else {
+			if (!blk_iopoll_sched_prep(&pbe_eq->iopoll))
+				blk_iopoll_sched(&pbe_eq->iopoll);
 			num_ioeq_processed++;
 		}
-		if (pbe_eq->todo_cq || pbe_eq->todo_mcc_cq)
+		AMAP_SET_BITS(struct amap_eq_entry, valid, eqe, 0);
+		queue_tail_inc(eq);
+		eqe = queue_tail_node(eq);
+	}
+	if (num_ioeq_processed || num_mcceq_processed) {
+		if (pbe_eq->todo_mcc_cq)
 			queue_work(phba->wq, &pbe_eq->work_cqs);
 
-		if (num_ioeq_processed) {
+		if ((num_mcceq_processed) && (!num_ioeq_processed))
 			hwi_ring_eq_db(phba, eq->id, 0,
-				       num_ioeq_processed, 1, 1);
-			return IRQ_HANDLED;
-		} else
-			return IRQ_NONE;
-	}
+				      (num_ioeq_processed +
+				       num_mcceq_processed) , 1, 1);
+		else
+			hwi_ring_eq_db(phba, eq->id, 0,
+				       (num_ioeq_processed +
+					num_mcceq_processed), 0, 1);
+
+		return IRQ_HANDLED;
+	} else
+		return IRQ_NONE;
 }
 
 static int beiscsi_init_irqs(struct beiscsi_hba *phba)
@@ -5216,11 +5166,10 @@ static void beiscsi_quiesce(struct beiscsi_hba *phba,
 		}
 	pci_disable_msix(phba->pcidev);
 
-	if (blk_iopoll_enabled)
-		for (i = 0; i < phba->num_cpus; i++) {
-			pbe_eq = &phwi_context->be_eq[i];
-			blk_iopoll_disable(&pbe_eq->iopoll);
-		}
+	for (i = 0; i < phba->num_cpus; i++) {
+		pbe_eq = &phwi_context->be_eq[i];
+		blk_iopoll_disable(&pbe_eq->iopoll);
+	}
 
 	if (unload_state == BEISCSI_CLEAN_UNLOAD) {
 		destroy_workqueue(phba->wq);
@@ -5429,32 +5378,18 @@ static void beiscsi_eeh_resume(struct pci_dev *pdev)
 	phwi_ctrlr = phba->phwi_ctrlr;
 	phwi_context = phwi_ctrlr->phwi_ctxt;
 
-	if (blk_iopoll_enabled) {
-		for (i = 0; i < phba->num_cpus; i++) {
-			pbe_eq = &phwi_context->be_eq[i];
-			blk_iopoll_init(&pbe_eq->iopoll, be_iopoll_budget,
-					be_iopoll);
-			blk_iopoll_enable(&pbe_eq->iopoll);
-		}
-
-		i = (phba->msix_enabled) ? i : 0;
-		/* Work item for MCC handling */
+	for (i = 0; i < phba->num_cpus; i++) {
 		pbe_eq = &phwi_context->be_eq[i];
-		INIT_WORK(&pbe_eq->work_cqs, beiscsi_process_all_cqs);
-	} else {
-		if (phba->msix_enabled) {
-			for (i = 0; i <= phba->num_cpus; i++) {
-				pbe_eq = &phwi_context->be_eq[i];
-				INIT_WORK(&pbe_eq->work_cqs,
-					  beiscsi_process_all_cqs);
-			}
-		} else {
-			pbe_eq = &phwi_context->be_eq[0];
-			INIT_WORK(&pbe_eq->work_cqs,
-				  beiscsi_process_all_cqs);
-		}
+		blk_iopoll_init(&pbe_eq->iopoll, be_iopoll_budget,
+				be_iopoll);
+		blk_iopoll_enable(&pbe_eq->iopoll);
 	}
 
+	i = (phba->msix_enabled) ? i : 0;
+	/* Work item for MCC handling */
+	pbe_eq = &phwi_context->be_eq[i];
+	INIT_WORK(&pbe_eq->work_cqs, beiscsi_process_all_cqs);
+
 	ret = beiscsi_init_irqs(phba);
 	if (ret < 0) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
@@ -5614,32 +5549,18 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	phwi_ctrlr = phba->phwi_ctrlr;
 	phwi_context = phwi_ctrlr->phwi_ctxt;
 
-	if (blk_iopoll_enabled) {
-		for (i = 0; i < phba->num_cpus; i++) {
-			pbe_eq = &phwi_context->be_eq[i];
-			blk_iopoll_init(&pbe_eq->iopoll, be_iopoll_budget,
-					be_iopoll);
-			blk_iopoll_enable(&pbe_eq->iopoll);
-		}
-
-		i = (phba->msix_enabled) ? i : 0;
-		/* Work item for MCC handling */
+	for (i = 0; i < phba->num_cpus; i++) {
 		pbe_eq = &phwi_context->be_eq[i];
-		INIT_WORK(&pbe_eq->work_cqs, beiscsi_process_all_cqs);
-	} else {
-		if (phba->msix_enabled) {
-			for (i = 0; i <= phba->num_cpus; i++) {
-				pbe_eq = &phwi_context->be_eq[i];
-				INIT_WORK(&pbe_eq->work_cqs,
-					  beiscsi_process_all_cqs);
-			}
-		} else {
-				pbe_eq = &phwi_context->be_eq[0];
-				INIT_WORK(&pbe_eq->work_cqs,
-					  beiscsi_process_all_cqs);
-			}
+		blk_iopoll_init(&pbe_eq->iopoll, be_iopoll_budget,
+				be_iopoll);
+		blk_iopoll_enable(&pbe_eq->iopoll);
 	}
 
+	i = (phba->msix_enabled) ? i : 0;
+	/* Work item for MCC handling */
+	pbe_eq = &phwi_context->be_eq[i];
+	INIT_WORK(&pbe_eq->work_cqs, beiscsi_process_all_cqs);
+
 	ret = beiscsi_init_irqs(phba);
 	if (ret < 0) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
@@ -5668,11 +5589,10 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 
 free_blkenbld:
 	destroy_workqueue(phba->wq);
-	if (blk_iopoll_enabled)
-		for (i = 0; i < phba->num_cpus; i++) {
-			pbe_eq = &phwi_context->be_eq[i];
-			blk_iopoll_disable(&pbe_eq->iopoll);
-		}
+	for (i = 0; i < phba->num_cpus; i++) {
+		pbe_eq = &phwi_context->be_eq[i];
+		blk_iopoll_disable(&pbe_eq->iopoll);
+	}
 free_twq:
 	beiscsi_clean_port(phba);
 	beiscsi_free_mem(phba);
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 3f5b56a..c1c1486 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -3630,16 +3630,16 @@ static ssize_t ipr_store_iopoll_weight(struct device *dev,
 		return strlen(buf);
 	}
 
-	if (blk_iopoll_enabled && ioa_cfg->iopoll_weight &&
-			ioa_cfg->sis64 && ioa_cfg->nvectors > 1) {
+	if (ioa_cfg->iopoll_weight &&
+	    ioa_cfg->sis64 && ioa_cfg->nvectors > 1) {
 		for (i = 1; i < ioa_cfg->hrrq_num; i++)
 			blk_iopoll_disable(&ioa_cfg->hrrq[i].iopoll);
 	}
 
 	spin_lock_irqsave(shost->host_lock, lock_flags);
 	ioa_cfg->iopoll_weight = user_iopoll_weight;
-	if (blk_iopoll_enabled && ioa_cfg->iopoll_weight &&
-			ioa_cfg->sis64 && ioa_cfg->nvectors > 1) {
+	if (ioa_cfg->iopoll_weight &&
+	    ioa_cfg->sis64 && ioa_cfg->nvectors > 1) {
 		for (i = 1; i < ioa_cfg->hrrq_num; i++) {
 			blk_iopoll_init(&ioa_cfg->hrrq[i].iopoll,
 					ioa_cfg->iopoll_weight, ipr_iopoll);
@@ -5484,8 +5484,8 @@ static irqreturn_t ipr_isr_mhrrq(int irq, void *devp)
 		return IRQ_NONE;
 	}
 
-	if (blk_iopoll_enabled && ioa_cfg->iopoll_weight &&
-			ioa_cfg->sis64 && ioa_cfg->nvectors > 1) {
+	if (ioa_cfg->iopoll_weight &&
+	    ioa_cfg->sis64 && ioa_cfg->nvectors > 1) {
 		if ((be32_to_cpu(*hrrq->hrrq_curr) & IPR_HRRQ_TOGGLE_BIT) ==
 		       hrrq->toggle_bit) {
 			if (!blk_iopoll_sched_prep(&hrrq->iopoll))
@@ -9859,8 +9859,8 @@ static int ipr_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 	ioa_cfg->host->max_channel = IPR_VSET_BUS;
 	ioa_cfg->iopoll_weight = ioa_cfg->chip_cfg->iopoll_weight;
 
-	if (blk_iopoll_enabled && ioa_cfg->iopoll_weight &&
-			ioa_cfg->sis64 && ioa_cfg->nvectors > 1) {
+	if (ioa_cfg->iopoll_weight &&
+	    ioa_cfg->sis64 && ioa_cfg->nvectors > 1) {
 		for (i = 1; i < ioa_cfg->hrrq_num; i++) {
 			blk_iopoll_init(&ioa_cfg->hrrq[i].iopoll,
 					ioa_cfg->iopoll_weight, ipr_iopoll);
@@ -9889,8 +9889,8 @@ static void ipr_shutdown(struct pci_dev *pdev)
 	int i;
 
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
-	if (blk_iopoll_enabled && ioa_cfg->iopoll_weight &&
-			ioa_cfg->sis64 && ioa_cfg->nvectors > 1) {
+	if (ioa_cfg->iopoll_weight &&
+	    ioa_cfg->sis64 && ioa_cfg->nvectors > 1) {
 		ioa_cfg->iopoll_weight = 0;
 		for (i = 1; i < ioa_cfg->hrrq_num; i++)
 			blk_iopoll_disable(&ioa_cfg->hrrq[i].iopoll);
diff --git a/include/linux/blk-iopoll.h b/include/linux/blk-iopoll.h
index 308734d..77ae77c 100644
--- a/include/linux/blk-iopoll.h
+++ b/include/linux/blk-iopoll.h
@@ -43,6 +43,4 @@ extern void __blk_iopoll_complete(struct blk_iopoll *);
 extern void blk_iopoll_enable(struct blk_iopoll *);
 extern void blk_iopoll_disable(struct blk_iopoll *);
 
-extern int blk_iopoll_enabled;
-
 #endif
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 49e13e1..ef0bf04 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -112,9 +112,6 @@ extern int sysctl_nr_open_min, sysctl_nr_open_max;
 #ifndef CONFIG_MMU
 extern int sysctl_nr_trim_pages;
 #endif
-#ifdef CONFIG_BLOCK
-extern int blk_iopoll_enabled;
-#endif
 
 /* Constants used for minimum and  maximum */
 #ifdef CONFIG_LOCKUP_DETECTOR
@@ -1094,15 +1091,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif
-#ifdef CONFIG_BLOCK
-	{
-		.procname	= "blk_iopoll",
-		.data		= &blk_iopoll_enabled,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-#endif
 	{ }
 };
 
-- 
1.7.1

