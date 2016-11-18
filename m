From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] vmw_pvscsi: switch to pci_alloc_irq_vectors
Date: Fri, 18 Nov 2016 07:02:38 +0100
Message-ID: <1479448958-6653-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39779 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751058AbcKRGCn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Nov 2016 01:02:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgill@vmware.com
Cc: pv-drivers@vmware.com, linux-scsi@vger.kernel.org

And simply the interrupt handler by splitting the INTx case that needs
to deal with shared interrupts into a separate helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/vmw_pvscsi.c | 104 +++++++++++++++++-----------------------------
 drivers/scsi/vmw_pvscsi.h |   5 ---
 2 files changed, 38 insertions(+), 71 deletions(-)

diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 4a0d3cd..642dd4e 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -68,10 +68,7 @@ struct pvscsi_ctx {
 
 struct pvscsi_adapter {
 	char				*mmioBase;
-	unsigned int			irq;
 	u8				rev;
-	bool				use_msi;
-	bool				use_msix;
 	bool				use_msg;
 	bool				use_req_threshold;
 
@@ -1160,30 +1157,26 @@ static bool pvscsi_setup_req_threshold(struct pvscsi_adapter *adapter,
 static irqreturn_t pvscsi_isr(int irq, void *devp)
 {
 	struct pvscsi_adapter *adapter = devp;
-	int handled;
-
-	if (adapter->use_msi || adapter->use_msix)
-		handled = true;
-	else {
-		u32 val = pvscsi_read_intr_status(adapter);
-		handled = (val & PVSCSI_INTR_ALL_SUPPORTED) != 0;
-		if (handled)
-			pvscsi_write_intr_status(devp, val);
-	}
-
-	if (handled) {
-		unsigned long flags;
+	unsigned long flags;
 
-		spin_lock_irqsave(&adapter->hw_lock, flags);
+	spin_lock_irqsave(&adapter->hw_lock, flags);
+	pvscsi_process_completion_ring(adapter);
+	if (adapter->use_msg && pvscsi_msg_pending(adapter))
+		queue_work(adapter->workqueue, &adapter->work);
+	spin_unlock_irqrestore(&adapter->hw_lock, flags);
 
-		pvscsi_process_completion_ring(adapter);
-		if (adapter->use_msg && pvscsi_msg_pending(adapter))
-			queue_work(adapter->workqueue, &adapter->work);
+	return IRQ_HANDLED;
+}
 
-		spin_unlock_irqrestore(&adapter->hw_lock, flags);
-	}
+static irqreturn_t pvscsi_shared_isr(int irq, void *devp)
+{
+	struct pvscsi_adapter *adapter = devp;
+	u32 val = pvscsi_read_intr_status(adapter);
 
-	return IRQ_RETVAL(handled);
+	if (!(val & PVSCSI_INTR_ALL_SUPPORTED))
+		return IRQ_NONE;
+	pvscsi_write_intr_status(devp, val);
+	return pvscsi_isr(irq, devp);
 }
 
 static void pvscsi_free_sgls(const struct pvscsi_adapter *adapter)
@@ -1195,34 +1188,10 @@ static void pvscsi_free_sgls(const struct pvscsi_adapter *adapter)
 		free_pages((unsigned long)ctx->sgl, get_order(SGL_SIZE));
 }
 
-static int pvscsi_setup_msix(const struct pvscsi_adapter *adapter,
-			     unsigned int *irq)
-{
-	struct msix_entry entry = { 0, PVSCSI_VECTOR_COMPLETION };
-	int ret;
-
-	ret = pci_enable_msix_exact(adapter->dev, &entry, 1);
-	if (ret)
-		return ret;
-
-	*irq = entry.vector;
-
-	return 0;
-}
-
 static void pvscsi_shutdown_intr(struct pvscsi_adapter *adapter)
 {
-	if (adapter->irq) {
-		free_irq(adapter->irq, adapter);
-		adapter->irq = 0;
-	}
-	if (adapter->use_msi) {
-		pci_disable_msi(adapter->dev);
-		adapter->use_msi = 0;
-	} else if (adapter->use_msix) {
-		pci_disable_msix(adapter->dev);
-		adapter->use_msix = 0;
-	}
+	free_irq(pci_irq_vector(adapter->dev, 0), adapter);
+	pci_free_irq_vectors(adapter->dev);
 }
 
 static void pvscsi_release_resources(struct pvscsi_adapter *adapter)
@@ -1358,11 +1327,11 @@ static u32 pvscsi_get_max_targets(struct pvscsi_adapter *adapter)
 
 static int pvscsi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
+	unsigned int irq_flag = PCI_IRQ_MSIX | PCI_IRQ_MSI | PCI_IRQ_LEGACY;
 	struct pvscsi_adapter *adapter;
 	struct pvscsi_adapter adapter_temp;
 	struct Scsi_Host *host = NULL;
 	unsigned int i;
-	unsigned long flags = 0;
 	int error;
 	u32 max_id;
 
@@ -1511,30 +1480,33 @@ static int pvscsi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto out_reset_adapter;
 	}
 
-	if (!pvscsi_disable_msix &&
-	    pvscsi_setup_msix(adapter, &adapter->irq) == 0) {
-		printk(KERN_INFO "vmw_pvscsi: using MSI-X\n");
-		adapter->use_msix = 1;
-	} else if (!pvscsi_disable_msi && pci_enable_msi(pdev) == 0) {
-		printk(KERN_INFO "vmw_pvscsi: using MSI\n");
-		adapter->use_msi = 1;
-		adapter->irq = pdev->irq;
-	} else {
-		printk(KERN_INFO "vmw_pvscsi: using INTx\n");
-		adapter->irq = pdev->irq;
-		flags = IRQF_SHARED;
-	}
+	if (pvscsi_disable_msix)
+		irq_flag &= ~PCI_IRQ_MSIX;
+	if (pvscsi_disable_msi)
+		irq_flag &= ~PCI_IRQ_MSI;
+
+	error = pci_alloc_irq_vectors(adapter->dev, 1, 1, irq_flag);
+	if (error)
+		goto out_reset_adapter;
 
 	adapter->use_req_threshold = pvscsi_setup_req_threshold(adapter, true);
 	printk(KERN_DEBUG "vmw_pvscsi: driver-based request coalescing %sabled\n",
 	       adapter->use_req_threshold ? "en" : "dis");
 
-	error = request_irq(adapter->irq, pvscsi_isr, flags,
-			    "vmw_pvscsi", adapter);
+	if (adapter->dev->msix_enabled || adapter->dev->msi_enabled) {
+		printk(KERN_INFO "vmw_pvscsi: using MSI%s\n",
+			adapter->dev->msix_enabled ? "-X" : "");
+		error = request_irq(pci_irq_vector(pdev, 0), pvscsi_isr,
+				0, "vmw_pvscsi", adapter);
+	} else {
+		printk(KERN_INFO "vmw_pvscsi: using INTx\n");
+		error = request_irq(pci_irq_vector(pdev, 0), pvscsi_shared_isr,
+				IRQF_SHARED, "vmw_pvscsi", adapter);
+	}
+
 	if (error) {
 		printk(KERN_ERR
 		       "vmw_pvscsi: unable to request IRQ: %d\n", error);
-		adapter->irq = 0;
 		goto out_reset_adapter;
 	}
 
diff --git a/drivers/scsi/vmw_pvscsi.h b/drivers/scsi/vmw_pvscsi.h
index c097d2c..b3060fe 100644
--- a/drivers/scsi/vmw_pvscsi.h
+++ b/drivers/scsi/vmw_pvscsi.h
@@ -423,11 +423,6 @@ struct PVSCSIConfigPageController {
 #define PVSCSI_MAX_INTRS        24
 
 /*
- * Enumeration of supported MSI-X vectors
- */
-#define PVSCSI_VECTOR_COMPLETION   0
-
-/*
  * Misc constants for the rings.
  */
 
-- 
2.1.4

