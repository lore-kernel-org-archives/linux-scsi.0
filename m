From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2] qla4xxx: switch to pci_alloc_irq_vectors
Date: Tue,  6 Dec 2016 14:56:50 +0100
Message-ID: <1481032610-31274-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43915 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752328AbcLFN4z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Dec 2016 08:56:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nilesh.Javali@cavium.com, QLogic-Storage-Upstream@qlogic.com, linux-scsi@vger.kernel.org

And simplify the MSI-X logic in general - just request the two
vectors directly instead of going through an indirection table.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/qla4xxx/ql4_def.h  | 18 +--------
 drivers/scsi/qla4xxx/ql4_glbl.h |  1 -
 drivers/scsi/qla4xxx/ql4_isr.c  | 27 +++++--------
 drivers/scsi/qla4xxx/ql4_nx.c   | 89 +++++++++++------------------------------
 4 files changed, 37 insertions(+), 98 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index a7cfc27..aeebefb 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -409,18 +409,9 @@ struct qla4_8xxx_legacy_intr_set {
 
 /* MSI-X Support */
 
-#define QLA_MSIX_DEFAULT	0x00
-#define QLA_MSIX_RSP_Q		0x01
-
+#define QLA_MSIX_DEFAULT	0
+#define QLA_MSIX_RSP_Q		1
 #define QLA_MSIX_ENTRIES	2
-#define QLA_MIDX_DEFAULT	0
-#define QLA_MIDX_RSP_Q		1
-
-struct ql4_msix_entry {
-	int have_irq;
-	uint16_t msix_vector;
-	uint16_t msix_entry;
-};
 
 /*
  * ISP Operations
@@ -572,9 +563,6 @@ struct scsi_qla_host {
 #define AF_IRQ_ATTACHED			10 /* 0x00000400 */
 #define AF_DISABLE_ACB_COMPLETE		11 /* 0x00000800 */
 #define AF_HA_REMOVAL			12 /* 0x00001000 */
-#define AF_INTx_ENABLED			15 /* 0x00008000 */
-#define AF_MSI_ENABLED			16 /* 0x00010000 */
-#define AF_MSIX_ENABLED			17 /* 0x00020000 */
 #define AF_MBOX_COMMAND_NOPOLL		18 /* 0x00040000 */
 #define AF_FW_RECOVERY			19 /* 0x00080000 */
 #define AF_EEH_BUSY			20 /* 0x00100000 */
@@ -762,8 +750,6 @@ struct scsi_qla_host {
 	struct isp_operations *isp_ops;
 	struct ql82xx_hw_data hw;
 
-	struct ql4_msix_entry msix_entries[QLA_MSIX_ENTRIES];
-
 	uint32_t nx_dev_init_timeout;
 	uint32_t nx_reset_timeout;
 	void *fw_dump;
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index 2559144..bce96a5 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -134,7 +134,6 @@ int qla4_8xxx_get_flash_info(struct scsi_qla_host *ha);
 void qla4_82xx_enable_intrs(struct scsi_qla_host *ha);
 void qla4_82xx_disable_intrs(struct scsi_qla_host *ha);
 int qla4_8xxx_enable_msix(struct scsi_qla_host *ha);
-void qla4_8xxx_disable_msix(struct scsi_qla_host *ha);
 irqreturn_t qla4_8xxx_msi_handler(int irq, void *dev_id);
 irqreturn_t qla4_8xxx_default_intr_handler(int irq, void *dev_id);
 irqreturn_t qla4_8xxx_msix_rsp_q(int irq, void *dev_id);
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index 4f9c0f2..d2cd33d 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -1107,7 +1107,7 @@ static void qla4_82xx_spurious_interrupt(struct scsi_qla_host *ha,
 	DEBUG2(ql4_printk(KERN_INFO, ha, "Spurious Interrupt\n"));
 	if (is_qla8022(ha)) {
 		writel(0, &ha->qla4_82xx_reg->host_int);
-		if (test_bit(AF_INTx_ENABLED, &ha->flags))
+		if (!ha->pdev->msi_enabled && !ha->pdev->msix_enabled)
 			qla4_82xx_wr_32(ha, ha->nx_legacy_intr.tgt_mask_reg,
 			    0xfbff);
 	}
@@ -1564,19 +1564,18 @@ int qla4xxx_request_irqs(struct scsi_qla_host *ha)
 
 try_msi:
 	/* Trying MSI */
-	ret = pci_enable_msi(ha->pdev);
-	if (!ret) {
+	ret = pci_alloc_irq_vectors(ha->pdev, 1, 1, PCI_IRQ_MSI);
+	if (ret > 0) {
 		ret = request_irq(ha->pdev->irq, qla4_8xxx_msi_handler,
 			0, DRIVER_NAME, ha);
 		if (!ret) {
 			DEBUG2(ql4_printk(KERN_INFO, ha, "MSI: Enabled.\n"));
-			set_bit(AF_MSI_ENABLED, &ha->flags);
 			goto irq_attached;
 		} else {
 			ql4_printk(KERN_WARNING, ha,
 			    "MSI: Failed to reserve interrupt %d "
 			    "already in use.\n", ha->pdev->irq);
-			pci_disable_msi(ha->pdev);
+			pci_free_irq_vectors(ha->pdev);
 		}
 	}
 
@@ -1592,7 +1591,6 @@ int qla4xxx_request_irqs(struct scsi_qla_host *ha)
 	    IRQF_SHARED, DRIVER_NAME, ha);
 	if (!ret) {
 		DEBUG2(ql4_printk(KERN_INFO, ha, "INTx: Enabled.\n"));
-		set_bit(AF_INTx_ENABLED, &ha->flags);
 		goto irq_attached;
 
 	} else {
@@ -1614,14 +1612,11 @@ int qla4xxx_request_irqs(struct scsi_qla_host *ha)
 
 void qla4xxx_free_irqs(struct scsi_qla_host *ha)
 {
-	if (test_and_clear_bit(AF_IRQ_ATTACHED, &ha->flags)) {
-		if (test_bit(AF_MSIX_ENABLED, &ha->flags)) {
-			qla4_8xxx_disable_msix(ha);
-		} else if (test_and_clear_bit(AF_MSI_ENABLED, &ha->flags)) {
-			free_irq(ha->pdev->irq, ha);
-			pci_disable_msi(ha->pdev);
-		} else if (test_and_clear_bit(AF_INTx_ENABLED, &ha->flags)) {
-			free_irq(ha->pdev->irq, ha);
-		}
-	}
+	if (!test_and_clear_bit(AF_IRQ_ATTACHED, &ha->flags))
+		return;
+
+	if (ha->pdev->msix_enabled)
+		free_irq(pci_irq_vector(ha->pdev, 1), ha);
+	free_irq(pci_irq_vector(ha->pdev, 0), ha);
+	pci_free_irq_vectors(ha->pdev);
 }
diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index bccd8b6..e91abb3 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -3945,7 +3945,7 @@ void qla4_82xx_process_mbox_intr(struct scsi_qla_host *ha, int out_count)
 		ha->isp_ops->interrupt_service_routine(ha, intr_status);
 
 		if (test_bit(AF_INTERRUPTS_ON, &ha->flags) &&
-		    test_bit(AF_INTx_ENABLED, &ha->flags))
+		    (!ha->pdev->msi_enabled && !ha->pdev->msix_enabled))
 			qla4_82xx_wr_32(ha, ha->nx_legacy_intr.tgt_mask_reg,
 					0xfbff);
 	}
@@ -4174,78 +4174,37 @@ qla4_82xx_disable_intrs(struct scsi_qla_host *ha)
 	spin_unlock_irq(&ha->hardware_lock);
 }
 
-struct ql4_init_msix_entry {
-	uint16_t entry;
-	uint16_t index;
-	const char *name;
-	irq_handler_t handler;
-};
-
-static struct ql4_init_msix_entry qla4_8xxx_msix_entries[QLA_MSIX_ENTRIES] = {
-	{ QLA_MSIX_DEFAULT, QLA_MIDX_DEFAULT,
-	    "qla4xxx (default)",
-	    (irq_handler_t)qla4_8xxx_default_intr_handler },
-	{ QLA_MSIX_RSP_Q, QLA_MIDX_RSP_Q,
-	    "qla4xxx (rsp_q)", (irq_handler_t)qla4_8xxx_msix_rsp_q },
-};
-
-void
-qla4_8xxx_disable_msix(struct scsi_qla_host *ha)
-{
-	int i;
-	struct ql4_msix_entry *qentry;
-
-	for (i = 0; i < QLA_MSIX_ENTRIES; i++) {
-		qentry = &ha->msix_entries[qla4_8xxx_msix_entries[i].index];
-		if (qentry->have_irq) {
-			free_irq(qentry->msix_vector, ha);
-			DEBUG2(ql4_printk(KERN_INFO, ha, "%s: %s\n",
-				__func__, qla4_8xxx_msix_entries[i].name));
-		}
-	}
-	pci_disable_msix(ha->pdev);
-	clear_bit(AF_MSIX_ENABLED, &ha->flags);
-}
-
 int
 qla4_8xxx_enable_msix(struct scsi_qla_host *ha)
 {
-	int i, ret;
-	struct msix_entry entries[QLA_MSIX_ENTRIES];
-	struct ql4_msix_entry *qentry;
-
-	for (i = 0; i < QLA_MSIX_ENTRIES; i++)
-		entries[i].entry = qla4_8xxx_msix_entries[i].entry;
+	int ret;
 
-	ret = pci_enable_msix_exact(ha->pdev, entries, ARRAY_SIZE(entries));
-	if (ret) {
+	ret = pci_alloc_irq_vectors(ha->pdev, QLA_MSIX_ENTRIES,
+			QLA_MSIX_ENTRIES, PCI_IRQ_MSIX);
+	if (ret < 0) {
 		ql4_printk(KERN_WARNING, ha,
 		    "MSI-X: Failed to enable support -- %d/%d\n",
 		    QLA_MSIX_ENTRIES, ret);
-		goto msix_out;
-	}
-	set_bit(AF_MSIX_ENABLED, &ha->flags);
-
-	for (i = 0; i < QLA_MSIX_ENTRIES; i++) {
-		qentry = &ha->msix_entries[qla4_8xxx_msix_entries[i].index];
-		qentry->msix_vector = entries[i].vector;
-		qentry->msix_entry = entries[i].entry;
-		qentry->have_irq = 0;
-		ret = request_irq(qentry->msix_vector,
-		    qla4_8xxx_msix_entries[i].handler, 0,
-		    qla4_8xxx_msix_entries[i].name, ha);
-		if (ret) {
-			ql4_printk(KERN_WARNING, ha,
-			    "MSI-X: Unable to register handler -- %x/%d.\n",
-			    qla4_8xxx_msix_entries[i].index, ret);
-			qla4_8xxx_disable_msix(ha);
-			goto msix_out;
-		}
-		qentry->have_irq = 1;
-		DEBUG2(ql4_printk(KERN_INFO, ha, "%s: %s\n",
-			__func__, qla4_8xxx_msix_entries[i].name));
+		return ret;
 	}
-msix_out:
+
+	ret = request_irq(pci_irq_vector(ha->pdev, 0),
+			qla4_8xxx_default_intr_handler, 0, "qla4xxx (default)",
+			ha);
+	if (ret)
+		goto out_free_vectors;
+
+	ret = request_irq(pci_irq_vector(ha->pdev, 1),
+			qla4_8xxx_msix_rsp_q, 0, "qla4xxx (rsp_q)", ha);
+	if (ret)
+		goto out_free_default_irq;
+
+	return 0;
+
+out_free_default_irq:
+	free_irq(pci_irq_vector(ha->pdev, 0), ha);
+out_free_vectors:
+	pci_free_irq_vectors(ha->pdev);
 	return ret;
 }
 
-- 
2.1.4

