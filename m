Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41687C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 15:33:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 192496103D
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 15:33:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232968AbhJRPgF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 11:36:05 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:39260 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbhJRPgE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Oct 2021 11:36:04 -0400
Date:   Mon, 18 Oct 2021 17:33:51 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634571232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=X5PLVM+v85DEZl575kxIvRhSuueGuUp8y25ivz6nr4c=;
        b=cFEqQK+DtsgyuaMeqPBRnSwOpWX75TDDARBn39YmCASB1nFW1Ulsl2rrU0Czo+InNaM6jE
        LiOyY0LtgNVGuhO7JzoG+hEpHp0jQnA0OVZgo+lQ49x/KDs9aFXO1DkQ2LbveIzJ7n7LXV
        kYiW/Jxo3fI5i0I56KAJ3aJTLLXwpLMcrXZ+cTPALpwZs4au77y1mAX3hSS8q+Q6Oo76p3
        K62JEB+iC9sAV26G417uHNvPihEDfG5n5PjkYYq319t2j4WQIE5VLJLFtj4+2xgCsTkrJi
        TJSZZU3EUr/wpFt7rkIgTI1x2Tni00fbjHtoSuw28PMgUPE2S0L5Go3s2CxBvg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634571232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=X5PLVM+v85DEZl575kxIvRhSuueGuUp8y25ivz6nr4c=;
        b=oTeipKltCk6EaJGTUlRQUR9rqVL9N3XIzDSgmW+gVivZKCjvpTWGPqosx+9+zDr7dPzUIH
        cktuZALJkmz0j/AA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     linux-scsi@vger.kernel.org
Cc:     Subbu Seetharaman <subbu.seetharaman@broadcom.com>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Jitendra Bhivare <jitendra.bhivare@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] scsi: be2iscsi: Replace irq_poll with threaded IRQ handler.
Message-ID: <20211018153351.t6mz4x3ugppet23k@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver is using irq_poll() (a NAPI like generic interface) for
completing individual I/O requests.
This could be replaced with threaded interrupts. The threaded interrupt
runs as a RT thread with priority 50-FIFO. It should run as the first
task after the interrupt unless a task with higher priority is active.
It can be interrupt by another hardware interrupt or a softirq.

This has been compile tested only. I'm interested if it causes any
regressions, improves the situation or neither.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/scsi/be2iscsi/Kconfig    |   1 -
 drivers/scsi/be2iscsi/be.h       |   3 +-
 drivers/scsi/be2iscsi/be_iscsi.c |   8 +-
 drivers/scsi/be2iscsi/be_main.c  | 145 ++++++++++++++-----------------
 drivers/scsi/be2iscsi/be_main.h  |   2 +-
 5 files changed, 74 insertions(+), 85 deletions(-)

diff --git a/drivers/scsi/be2iscsi/Kconfig b/drivers/scsi/be2iscsi/Kconfig
index 958c9b46ec787..0118b2a765caf 100644
--- a/drivers/scsi/be2iscsi/Kconfig
+++ b/drivers/scsi/be2iscsi/Kconfig
@@ -4,7 +4,6 @@ config BE2ISCSI
 	depends on PCI && SCSI && NET
 	select SCSI_ISCSI_ATTRS
 	select ISCSI_BOOT_SYSFS
-	select IRQ_POLL
 
 	help
 	This driver implements the iSCSI functionality for Emulex
diff --git a/drivers/scsi/be2iscsi/be.h b/drivers/scsi/be2iscsi/be.h
index 4c58a02590c7b..8623886810310 100644
--- a/drivers/scsi/be2iscsi/be.h
+++ b/drivers/scsi/be2iscsi/be.h
@@ -12,7 +12,7 @@
 
 #include <linux/pci.h>
 #include <linux/if_vlan.h>
-#include <linux/irq_poll.h>
+
 #define FW_VER_LEN	32
 #define MCC_Q_LEN	128
 #define MCC_CQ_LEN	256
@@ -90,7 +90,6 @@ struct be_eq_obj {
 	struct beiscsi_hba *phba;
 	struct be_queue_info *cq;
 	struct work_struct mcc_work; /* Work Item */
-	struct irq_poll	iopoll;
 };
 
 struct be_mcc_obj {
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 8aeaddc93b167..e15d5c7ef611e 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -1224,15 +1224,17 @@ static void beiscsi_flush_cq(struct beiscsi_hba *phba)
 	struct be_eq_obj *pbe_eq;
 	struct hwi_controller *phwi_ctrlr;
 	struct hwi_context_memory *phwi_context;
+	struct pci_dev *pcidev;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
 	phwi_context = phwi_ctrlr->phwi_ctxt;
+	pcidev = phba->pcidev;
 
 	for (i = 0; i < phba->num_cpus; i++) {
 		pbe_eq = &phwi_context->be_eq[i];
-		irq_poll_disable(&pbe_eq->iopoll);
-		beiscsi_process_cq(pbe_eq, BE2_MAX_NUM_CQ_PROC);
-		irq_poll_enable(&pbe_eq->iopoll);
+		disable_irq(pci_irq_vector(pcidev, i));
+		beiscsi_process_cq(pbe_eq);
+		enable_irq(pci_irq_vector(pcidev, i));
 	}
 }
 
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index e70f69f791db6..c911444376459 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -35,7 +35,6 @@
 #include <linux/iscsi_boot_sysfs.h>
 #include <linux/module.h>
 #include <linux/bsg-lib.h>
-#include <linux/irq_poll.h>
 
 #include <scsi/libiscsi.h>
 #include <scsi/scsi_bsg_iscsi.h>
@@ -51,7 +50,6 @@
 #include "be_mgmt.h"
 #include "be_cmds.h"
 
-static unsigned int be_iopoll_budget = 10;
 static unsigned int be_max_phys_size = 64;
 static unsigned int enable_msix = 1;
 
@@ -59,7 +57,6 @@ MODULE_DESCRIPTION(DRV_DESC " " BUILD_STR);
 MODULE_VERSION(BUILD_STR);
 MODULE_AUTHOR("Emulex Corporation");
 MODULE_LICENSE("GPL");
-module_param(be_iopoll_budget, int, 0);
 module_param(enable_msix, int, 0);
 module_param(be_max_phys_size, uint, S_IRUGO);
 MODULE_PARM_DESC(be_max_phys_size,
@@ -696,6 +693,53 @@ static irqreturn_t be_isr_mcc(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t be_iopoll(struct beiscsi_hba *phba)
+{
+	unsigned int ret, io_events;
+	struct be_eq_obj *pbe_eq;
+	struct be_eq_entry *eqe = NULL;
+	struct be_queue_info *eq;
+
+	if (beiscsi_hba_in_error(phba))
+		return IRQ_NONE;
+
+	io_events = 0;
+	eq = &pbe_eq->q;
+	eqe = queue_tail_node(eq);
+	while (eqe->dw[offsetof(struct amap_eq_entry, valid) / 32] &
+			EQE_VALID_MASK) {
+		AMAP_SET_BITS(struct amap_eq_entry, valid, eqe, 0);
+		queue_tail_inc(eq);
+		eqe = queue_tail_node(eq);
+		io_events++;
+	}
+	hwi_ring_eq_db(phba, eq->id, 1, io_events, 0, 1);
+
+	ret = beiscsi_process_cq(pbe_eq);
+	pbe_eq->cq_count += ret;
+	beiscsi_log(phba, KERN_INFO,
+		    BEISCSI_LOG_CONFIG | BEISCSI_LOG_IO,
+		    "BM_%d : rearm pbe_eq->q.id =%d ret %d\n",
+		    pbe_eq->q.id, ret);
+	if (!beiscsi_hba_in_error(phba))
+		hwi_ring_eq_db(phba, pbe_eq->q.id, 0, 0, 1, 1);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t be_isr_misx_th(int irq, void *dev_id)
+{
+	struct beiscsi_hba *phba;
+	struct be_queue_info *eq;
+	struct be_eq_obj *pbe_eq;
+
+	pbe_eq = dev_id;
+	eq = &pbe_eq->q;
+
+	phba = pbe_eq->phba;
+	return be_iopoll(phba);
+}
+
 /**
  * be_isr_msix - The isr routine of the driver.
  * @irq: Not used
@@ -713,9 +757,16 @@ static irqreturn_t be_isr_msix(int irq, void *dev_id)
 	phba = pbe_eq->phba;
 	/* disable interrupt till iopoll completes */
 	hwi_ring_eq_db(phba, eq->id, 1,	0, 0, 1);
-	irq_poll_sched(&pbe_eq->iopoll);
 
-	return IRQ_HANDLED;
+	return IRQ_WAKE_THREAD;
+}
+
+static irqreturn_t be_isr_thread(int irq, void *dev_id)
+{
+	struct beiscsi_hba *phba;
+
+	phba = dev_id;
+	return be_iopoll(phba);
 }
 
 /**
@@ -735,6 +786,7 @@ static irqreturn_t be_isr(int irq, void *dev_id)
 	struct be_ctrl_info *ctrl;
 	struct be_eq_obj *pbe_eq;
 	int isr, rearm;
+	irqreturn_t ret;
 
 	phba = dev_id;
 	ctrl = &phba->ctrl;
@@ -774,10 +826,11 @@ static irqreturn_t be_isr(int irq, void *dev_id)
 		/* rearm for MCCQ */
 		rearm = 1;
 	}
+	ret = IRQ_HANDLED;
 	if (io_events)
-		irq_poll_sched(&pbe_eq->iopoll);
+		ret = IRQ_WAKE_THREAD;
 	hwi_ring_eq_db(phba, eq->id, 0, (io_events + mcc_events), rearm, 1);
-	return IRQ_HANDLED;
+	return ret;
 }
 
 static void beiscsi_free_irqs(struct beiscsi_hba *phba)
@@ -819,9 +872,10 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
 				goto free_msix_irqs;
 			}
 
-			ret = request_irq(pci_irq_vector(pcidev, i),
-					  be_isr_msix, 0, phba->msi_name[i],
-					  &phwi_context->be_eq[i]);
+			ret = request_threaded_irq(pci_irq_vector(pcidev, i),
+						   be_isr_msix, be_isr_misx_th,
+						   0, phba->msi_name[i],
+						   &phwi_context->be_eq[i]);
 			if (ret) {
 				beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
 					    "BM_%d : %s-Failed to register msix for i = %d\n",
@@ -847,8 +901,8 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
 		}
 
 	} else {
-		ret = request_irq(pcidev->irq, be_isr, IRQF_SHARED,
-				  "beiscsi", phba);
+		ret = request_threaded_irq(pcidev->irq, be_isr, be_isr_thread,
+					   IRQF_SHARED, "beiscsi", phba);
 		if (ret) {
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
 				    "BM_%d : %s-Failed to register irq\n",
@@ -1839,12 +1893,11 @@ static void beiscsi_mcc_work(struct work_struct *work)
 /**
  * beiscsi_process_cq()- Process the Completion Queue
  * @pbe_eq: Event Q on which the Completion has come
- * @budget: Max number of events to processed
  *
  * return
  *     Number of Completion Entries processed.
  **/
-unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq, int budget)
+unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 {
 	struct be_queue_info *cq;
 	struct sol_cqe *sol;
@@ -2018,55 +2071,12 @@ unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq, int budget)
 		queue_tail_inc(cq);
 		sol = queue_tail_node(cq);
 		num_processed++;
-		if (total == budget)
-			break;
 	}
 
 	hwi_ring_cq_db(phba, cq->id, num_processed, 1);
 	return total;
 }
 
-static int be_iopoll(struct irq_poll *iop, int budget)
-{
-	unsigned int ret, io_events;
-	struct beiscsi_hba *phba;
-	struct be_eq_obj *pbe_eq;
-	struct be_eq_entry *eqe = NULL;
-	struct be_queue_info *eq;
-
-	pbe_eq = container_of(iop, struct be_eq_obj, iopoll);
-	phba = pbe_eq->phba;
-	if (beiscsi_hba_in_error(phba)) {
-		irq_poll_complete(iop);
-		return 0;
-	}
-
-	io_events = 0;
-	eq = &pbe_eq->q;
-	eqe = queue_tail_node(eq);
-	while (eqe->dw[offsetof(struct amap_eq_entry, valid) / 32] &
-			EQE_VALID_MASK) {
-		AMAP_SET_BITS(struct amap_eq_entry, valid, eqe, 0);
-		queue_tail_inc(eq);
-		eqe = queue_tail_node(eq);
-		io_events++;
-	}
-	hwi_ring_eq_db(phba, eq->id, 1, io_events, 0, 1);
-
-	ret = beiscsi_process_cq(pbe_eq, budget);
-	pbe_eq->cq_count += ret;
-	if (ret < budget) {
-		irq_poll_complete(iop);
-		beiscsi_log(phba, KERN_INFO,
-			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_IO,
-			    "BM_%d : rearm pbe_eq->q.id =%d ret %d\n",
-			    pbe_eq->q.id, ret);
-		if (!beiscsi_hba_in_error(phba))
-			hwi_ring_eq_db(phba, pbe_eq->q.id, 0, 0, 1, 1);
-	}
-	return ret;
-}
-
 static void
 hwi_write_sgl_v2(struct iscsi_wrb *pwrb, struct scatterlist *sg,
 		  unsigned int num_sg, struct beiscsi_io_task *io_task)
@@ -5308,10 +5318,6 @@ static int beiscsi_enable_port(struct beiscsi_hba *phba)
 
 	phwi_ctrlr = phba->phwi_ctrlr;
 	phwi_context = phwi_ctrlr->phwi_ctxt;
-	for (i = 0; i < phba->num_cpus; i++) {
-		pbe_eq = &phwi_context->be_eq[i];
-		irq_poll_init(&pbe_eq->iopoll, be_iopoll_budget, be_iopoll);
-	}
 
 	i = (phba->pcidev->msix_enabled) ? i : 0;
 	/* Work item for MCC handling */
@@ -5344,10 +5350,6 @@ static int beiscsi_enable_port(struct beiscsi_hba *phba)
 	return 0;
 
 cleanup_port:
-	for (i = 0; i < phba->num_cpus; i++) {
-		pbe_eq = &phwi_context->be_eq[i];
-		irq_poll_disable(&pbe_eq->iopoll);
-	}
 	hwi_cleanup_port(phba);
 
 disable_msix:
@@ -5379,10 +5381,6 @@ static void beiscsi_disable_port(struct beiscsi_hba *phba, int unload)
 	beiscsi_free_irqs(phba);
 	pci_free_irq_vectors(phba->pcidev);
 
-	for (i = 0; i < phba->num_cpus; i++) {
-		pbe_eq = &phwi_context->be_eq[i];
-		irq_poll_disable(&pbe_eq->iopoll);
-	}
 	cancel_delayed_work_sync(&phba->eqd_update);
 	cancel_work_sync(&phba->boot_work);
 	/* WQ might be running cancel queued mcc_work if we are not exiting */
@@ -5637,11 +5635,6 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	phwi_ctrlr = phba->phwi_ctrlr;
 	phwi_context = phwi_ctrlr->phwi_ctxt;
 
-	for (i = 0; i < phba->num_cpus; i++) {
-		pbe_eq = &phwi_context->be_eq[i];
-		irq_poll_init(&pbe_eq->iopoll, be_iopoll_budget, be_iopoll);
-	}
-
 	i = (phba->pcidev->msix_enabled) ? i : 0;
 	/* Work item for MCC handling */
 	pbe_eq = &phwi_context->be_eq[i];
@@ -5698,10 +5691,6 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	hwi_disable_intr(phba);
 	beiscsi_free_irqs(phba);
 disable_iopoll:
-	for (i = 0; i < phba->num_cpus; i++) {
-		pbe_eq = &phwi_context->be_eq[i];
-		irq_poll_disable(&pbe_eq->iopoll);
-	}
 	destroy_workqueue(phba->wq);
 free_twq:
 	hwi_cleanup_port(phba);
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 98977c0700f1a..5c0e54eaf9e99 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -799,7 +799,7 @@ void hwi_ring_cq_db(struct beiscsi_hba *phba,
 		     unsigned int id, unsigned int num_processed,
 		     unsigned char rearm);
 
-unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq, int budget);
+unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq);
 void beiscsi_process_mcc_cq(struct beiscsi_hba *phba);
 
 struct pdu_nop_out {
-- 
2.33.0

