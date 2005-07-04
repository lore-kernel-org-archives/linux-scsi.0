From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/9] qla1280: interupt posting for irq disabling/enabling
Date: Mon, 4 Jul 2005 17:48:19 +0200
Message-ID: <20050704154819.GC30435@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:47564 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261290AbVGDPsY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2005 11:48:24 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com, jes@trained-monkey.org
Cc: linux-scsi@vger.kernel.org, ths@linux-mips.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Thiemo Seufer <ths@linux-mips.org>

Index: linux-2.6/drivers/scsi/qla1280.c
===================================================================
--- linux-2.6.orig/drivers/scsi/qla1280.c	2005-06-19 20:48:30.000000000 +0200
+++ linux-2.6/drivers/scsi/qla1280.c	2005-06-19 20:55:09.000000000 +0200
@@ -1265,6 +1265,22 @@
 	return qla1280_biosparam(disk->device, NULL, disk->capacity, geom);
 }
 #endif
+ 
+/* disable risc and host interrupts */
+static inline void
+qla1280_disable_intrs(struct scsi_qla_host *ha)
+{
+	WRT_REG_WORD(&ha->iobase->ictrl, 0);
+	RD_REG_WORD(&ha->iobase->ictrl);	/* PCI Posted Write flush */
+}
+
+/* enable risc and host interrupts */
+static inline void
+qla1280_enable_intrs(struct scsi_qla_host *ha)
+{
+	WRT_REG_WORD(&ha->iobase->ictrl, (ISP_EN_INT | ISP_EN_RISC));
+	RD_REG_WORD(&ha->iobase->ictrl);	/* PCI Posted Write flush */
+}
 
 /**************************************************************************
  * qla1280_intr_handler
@@ -1286,7 +1302,7 @@
 	ha->isr_count++;
 	reg = ha->iobase;
 
-	WRT_REG_WORD(&reg->ictrl, 0);	/* disable our interrupt. */
+	qla1280_disable_intrs(ha);
 
 	data = qla1280_debounce_register(&reg->istatus);
 	/* Check for pending interrupts. */
@@ -1299,8 +1315,7 @@
 
 	spin_unlock(HOST_LOCK);
 
-	/* enable our interrupt. */
-	WRT_REG_WORD(&reg->ictrl, (ISP_EN_INT | ISP_EN_RISC));
+	qla1280_enable_intrs(ha);
 
 	LEAVE_INTR("qla1280_intr_handler");
 	return IRQ_RETVAL(handled);
@@ -1613,38 +1628,6 @@
 /*                QLogic ISP1280 Hardware Support Functions.                */
 /****************************************************************************/
 
- /*
-  * qla2100_enable_intrs
-  * qla2100_disable_intrs
-  *
-  * Input:
-  *      ha = adapter block pointer.
-  *
-  * Returns:
-  *      None
-  */
-static inline void
-qla1280_enable_intrs(struct scsi_qla_host *ha)
-{
-	struct device_reg __iomem *reg;
-
-	reg = ha->iobase;
-	/* enable risc and host interrupts */
-	WRT_REG_WORD(&reg->ictrl, (ISP_EN_INT | ISP_EN_RISC));
-	RD_REG_WORD(&reg->ictrl);	/* PCI Posted Write flush */
-}
-
-static inline void
-qla1280_disable_intrs(struct scsi_qla_host *ha)
-{
-	struct device_reg __iomem *reg;
-
-	reg = ha->iobase;
-	/* disable risc and host interrupts */
-	WRT_REG_WORD(&reg->ictrl, 0);
-	RD_REG_WORD(&reg->ictrl);	/* PCI Posted Write flush */
-}
-
 /*
  * qla1280_initialize_adapter
  *      Initialize board.
@@ -4751,7 +4734,7 @@
 
 #if LINUX_VERSION_CODE >= 0x020600
  error_disable_adapter:
-	WRT_REG_WORD(&ha->iobase->ictrl, 0);
+	qla1280_disable_intrs(ha);
 #endif
  error_free_irq:
 	free_irq(pdev->irq, ha);
@@ -4788,7 +4771,7 @@
 	scsi_remove_host(host);
 #endif
 
-	WRT_REG_WORD(&ha->iobase->ictrl, 0);
+	qla1280_disable_intrs(ha);
 
 	free_irq(pdev->irq, ha);
 
