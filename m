From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 03/10] be2iscsi: Free msi_name and disable HW intr
Date: Tue, 10 Oct 2017 16:18:13 +0530
Message-ID: <1507632500-26445-4-git-send-email-jitendra.bhivare@broadcom.com>
References: <1507632500-26445-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:43228 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755587AbdJJKsq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Oct 2017 06:48:46 -0400
Received: by mail-pf0-f172.google.com with SMTP id d2so13616651pfh.0
        for <linux-scsi@vger.kernel.org>; Tue, 10 Oct 2017 03:48:46 -0700 (PDT)
In-Reply-To: <1507632500-26445-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

In beiscsi_dev_probe, allocated msi_name does not get freed and enabled
HW interrupts are not disabled in iscsi_host_add error case.

Add beiscsi_free_irqs fn to handle the cleanup in probe and disable port.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be_main.c | 47 ++++++++++++++++++++++++++---------------
 1 file changed, 30 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 56ae0f4..8f7e394 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -790,6 +790,24 @@ static irqreturn_t be_isr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static void beiscsi_free_irqs(struct beiscsi_hba *phba)
+{
+	struct hwi_context_memory *phwi_context;
+	int i;
+
+	if (!phba->pcidev->msix_enabled) {
+		if (phba->pcidev->irq)
+			free_irq(phba->pcidev->irq, phba);
+		return;
+	}
+
+	phwi_context = phba->phwi_ctrlr->phwi_ctxt;
+	for (i = 0; i <= phba->num_cpus; i++) {
+		free_irq(pci_irq_vector(phba->pcidev, i),
+			 &phwi_context->be_eq[i]);
+		kfree(phba->msi_name[i]);
+	}
+}
 
 static int beiscsi_init_irqs(struct beiscsi_hba *phba)
 {
@@ -5396,15 +5414,7 @@ static void beiscsi_disable_port(struct beiscsi_hba *phba, int unload)
 	phwi_ctrlr = phba->phwi_ctrlr;
 	phwi_context = phwi_ctrlr->phwi_ctxt;
 	hwi_disable_intr(phba);
-	if (phba->pcidev->msix_enabled) {
-		for (i = 0; i <= phba->num_cpus; i++) {
-			free_irq(pci_irq_vector(phba->pcidev, i),
-				&phwi_context->be_eq[i]);
-			kfree(phba->msi_name[i]);
-		}
-	} else
-		if (phba->pcidev->irq)
-			free_irq(phba->pcidev->irq, phba);
+	beiscsi_free_irqs(phba);
 	pci_free_irq_vectors(phba->pcidev);
 
 	for (i = 0; i < phba->num_cpus; i++) {
@@ -5595,12 +5605,12 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	if (ret) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
 			    "BM_%d : be_ctrl_init failed\n");
-		goto hba_free;
+		goto free_hba;
 	}
 
 	ret = beiscsi_init_sliport(phba);
 	if (ret)
-		goto hba_free;
+		goto free_hba;
 
 	spin_lock_init(&phba->io_sgl_lock);
 	spin_lock_init(&phba->mgmt_sgl_lock);
@@ -5680,13 +5690,13 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
 			    "BM_%d : beiscsi_dev_probe-"
 			    "Failed to beiscsi_init_irqs\n");
-		goto free_blkenbld;
+		goto disable_iopoll;
 	}
 	hwi_enable_intr(phba);
 
 	ret = iscsi_host_add(phba->shost, &phba->pcidev->dev);
 	if (ret)
-		goto free_blkenbld;
+		goto free_irqs;
 
 	/* set online bit after port is operational */
 	set_bit(BEISCSI_HBA_ONLINE, &phba->state);
@@ -5724,12 +5734,15 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 		    "\n\n\n BM_%d : SUCCESS - DRIVER LOADED\n\n\n");
 	return 0;
 
-free_blkenbld:
-	destroy_workqueue(phba->wq);
+free_irqs:
+	hwi_disable_intr(phba);
+	beiscsi_free_irqs(phba);
+disable_iopoll:
 	for (i = 0; i < phba->num_cpus; i++) {
 		pbe_eq = &phwi_context->be_eq[i];
 		irq_poll_disable(&pbe_eq->iopoll);
 	}
+	destroy_workqueue(phba->wq);
 free_twq:
 	hwi_cleanup_port(phba);
 	beiscsi_cleanup_port(phba);
@@ -5738,9 +5751,9 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	pci_free_consistent(phba->pcidev,
 			    phba->ctrl.mbox_mem_alloced.size,
 			    phba->ctrl.mbox_mem_alloced.va,
-			   phba->ctrl.mbox_mem_alloced.dma);
+			    phba->ctrl.mbox_mem_alloced.dma);
 	beiscsi_unmap_pci_function(phba);
-hba_free:
+free_hba:
 	pci_disable_msix(phba->pcidev);
 	pci_dev_put(phba->pcidev);
 	iscsi_host_free(phba->shost);
-- 
2.7.4
