From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH 3/4] be2iscsi: Fix MCCQ posting for Mbx-Cmd after driver initialization is complete
Date: Sun, 23 Mar 2014 18:10:47 -0400
Message-ID: <1395612648-25851-3-git-send-email-Jayamohan.Kallickal@emulex.com>
References: <1395612648-25851-1-git-send-email-Jayamohan.Kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:60306 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaCWWLH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Mar 2014 18:11:07 -0400
Received: by mail-pd0-f174.google.com with SMTP id y13so4487008pdi.19
        for <linux-scsi@vger.kernel.org>; Sun, 23 Mar 2014 15:11:06 -0700 (PDT)
In-Reply-To: <1395612648-25851-1-git-send-email-Jayamohan.Kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <Jayamohan.Kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

 Even before probe for function was completed, iSCSI Daemon had initiated login
 to target while OS was coming up. The targets which had node.startup=automatic,
 login process was initiated.Since function specific initialization was still in
 progress this lead to kernel panic.
 The reson was MCCQ was not yet created and login Mbx_Cmd was sent on MCCQ.
 wrb_from_mccq() failed with kernel-panic access.

 In this fix, we check  alloc_mcc_tag() if driver initialization is complete or not.
 Based on the result driver continues or return with an Error.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <Jayamohan.Kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c | 75 +++++++++++++++++++++++++----------------
 drivers/scsi/be2iscsi/be_main.h |  1 +
 2 files changed, 47 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 9be818f..317deee 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -598,6 +598,7 @@ static struct beiscsi_hba *beiscsi_hba_alloc(struct pci_dev *pcidev)
 	phba->pcidev = pci_dev_get(pcidev);
 	pci_set_drvdata(pcidev, phba);
 	phba->interface_handle = 0xFFFFFFFF;
+	phba->state = BE_ADAPTER_INIT_PHASE;
 
 	if (iscsi_host_add(shost, &phba->pcidev->dev))
 		goto free_devices;
@@ -895,45 +896,37 @@ static irqreturn_t be_isr_msix(int irq, void *dev_id)
 	struct beiscsi_hba *phba;
 	struct be_eq_entry *eqe = NULL;
 	struct be_queue_info *eq;
-	struct be_queue_info *cq;
 	unsigned int num_eq_processed;
 	struct be_eq_obj *pbe_eq;
 	unsigned long flags;
 
 	pbe_eq = dev_id;
 	eq = &pbe_eq->q;
-	cq = pbe_eq->cq;
-	eqe = queue_tail_node(eq);
 
 	phba = pbe_eq->phba;
-	num_eq_processed = 0;
 	if (blk_iopoll_enabled) {
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
+		hwi_ring_eq_db(phba, eq->id, 1,	0, 1, 1);
+		if (!blk_iopoll_sched_prep(&pbe_eq->iopoll))
+			blk_iopoll_sched(&pbe_eq->iopoll);
+		return IRQ_HANDLED;
+	}
 
-		if (pbe_eq->todo_cq)
-			queue_work(phba->wq, &pbe_eq->work_cqs);
+	num_eq_processed = 0;
+	eqe = queue_tail_node(eq);
+	while (eqe->dw[offsetof(struct amap_eq_entry, valid) / 32]
+					& EQE_VALID_MASK) {
+		spin_lock_irqsave(&phba->isr_lock, flags);
+		pbe_eq->todo_cq = true;
+		spin_unlock_irqrestore(&phba->isr_lock, flags);
+		AMAP_SET_BITS(struct amap_eq_entry, valid, eqe, 0);
+		queue_tail_inc(eq);
+		eqe = queue_tail_node(eq);
+		num_eq_processed++;
 	}
 
+	if (pbe_eq->todo_cq)
+		queue_work(phba->wq, &pbe_eq->work_cqs);
+
 	if (num_eq_processed)
 		hwi_ring_eq_db(phba, eq->id, 1,	num_eq_processed, 0, 1);
 
@@ -2281,6 +2274,10 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 		queue_tail_inc(cq);
 		sol = queue_tail_node(cq);
 		num_processed++;
+
+		/* we want to relinquish control to other tasks */
+		if (tot_nump >= BE2_MAX_NUM_CQ_PROC)
+			break;
 	}
 
 	if (num_processed > 0) {
@@ -2323,14 +2320,33 @@ void beiscsi_process_all_cqs(struct work_struct *work)
 
 static int be_iopoll(struct blk_iopoll *iop, int budget)
 {
-	unsigned int ret;
+	unsigned int ret, num_eq_processed;
 	struct beiscsi_hba *phba;
 	struct be_eq_obj *pbe_eq;
+	struct be_eq_entry *eqe = NULL;
+	struct be_queue_info *eq;
 
+	num_eq_processed = 0;
 	pbe_eq = container_of(iop, struct be_eq_obj, iopoll);
+	phba = pbe_eq->phba;
+	eq = &pbe_eq->q;
+	eqe = queue_tail_node(eq);
+
+	hwi_ring_eq_db(phba, eq->id, 1, num_eq_processed, 0, 1);
+
+	while (eqe->dw[offsetof(struct amap_eq_entry, valid) / 32]
+			& EQE_VALID_MASK) {
+
+		AMAP_SET_BITS(struct amap_eq_entry, valid, eqe, 0);
+		queue_tail_inc(eq);
+		eqe = queue_tail_node(eq);
+		num_eq_processed++;
+	}
+
+	hwi_ring_eq_db(phba, eq->id, 1, num_eq_processed, 0, 1);
+
 	ret = beiscsi_process_cq(pbe_eq);
 	if (ret < budget) {
-		phba = pbe_eq->phba;
 		blk_iopoll_complete(iop);
 		beiscsi_log(phba, KERN_INFO,
 			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_IO,
@@ -5699,6 +5715,7 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 		goto free_blkenbld;
 	}
 	hwi_enable_intr(phba);
+	phba->state &= ~BE_ADAPTER_INIT_PHASE;
 
 	if (beiscsi_setup_boot_info(phba))
 		/*
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index d5901a7..581ebdb 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -105,6 +105,7 @@
 #define BE_ADAPTER_LINK_DOWN	0x002
 #define BE_ADAPTER_PCI_ERR	0x004
 #define BE_ADAPTER_STATE_SHUTDOWN	0x008
+#define BE_ADAPTER_INIT_PHASE	0x8000
 
 
 #define BEISCSI_CLEAN_UNLOAD	0x01
-- 
1.8.5.3

