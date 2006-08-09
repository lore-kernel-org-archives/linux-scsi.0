From: Doug Maxey <dwm@enoyolf.org>
Subject: [PATCH 3/3] qla4xxx: iospace_config move defn
Date: Wed, 09 Aug 2006 13:42:44 -0500
Message-ID: <20060809184243.2021.48891.stgit@bebe.enoyolf.org>
References: <20060809182406.2021.90492.stgit@bebe.enoyolf.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:12979 "EHLO
	bebe.enoyolf.org") by vger.kernel.org with ESMTP id S1751303AbWHISrY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Aug 2006 14:47:24 -0400
In-Reply-To: <20060809182406.2021.90492.stgit@bebe.enoyolf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Ravi Anand <ravi.anand@qlogic.com>, David Somayajulu <david.somayajulu@qlogic.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org

From: Doug Maxey <dwm@enoyolf.org>

Move the defn before the caller, and remove the decl.

Signed-off-by: Doug Maxey <dwm@enoyolf.org>
---

 drivers/scsi/qla4xxx/ql4_os.c |  126 ++++++++++++++++++++---------------------
 1 files changed, 62 insertions(+), 64 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index f656fb3..30f245a 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -46,8 +46,6 @@ MODULE_PARM_DESC(extended_error_logging,
 
 void qla4xxx_config_dma_addressing(struct scsi_qla_host *ha);
 
-static int qla4xxx_iospace_config(struct scsi_qla_host *ha);
-
 /*
  * iSCSI template entry points
  */
@@ -1138,6 +1136,68 @@ static void qla4xxx_free_adapter(struct 
 
 }
 
+/***
+ * qla4xxx_iospace_config - maps registers
+ * @ha: pointer to adapter structure
+ *
+ * This routines maps HBA's registers from the pci address space
+ * into the kernel virtual address space for memory mapped i/o.
+ **/
+static int qla4xxx_iospace_config(struct scsi_qla_host *ha)
+{
+	unsigned long pio, pio_len, pio_flags;
+	unsigned long mmio, mmio_len, mmio_flags;
+
+	pio = pci_resource_start(ha->pdev, 0);
+	pio_len = pci_resource_len(ha->pdev, 0);
+	pio_flags = pci_resource_flags(ha->pdev, 0);
+	if (pio_flags & IORESOURCE_IO) {
+		if (pio_len < MIN_IOBASE_LEN) {
+			dev_warn(&ha->pdev->dev,
+				   "Invalid PCI I/O region size\n");
+			pio = 0;
+		}
+	} else {
+		dev_warn(&ha->pdev->dev, "region #0 not a PIO resource\n");
+		pio = 0;
+	}
+
+	/* Use MMIO operations for all accesses. */
+	mmio = pci_resource_start(ha->pdev, 1);
+	mmio_len = pci_resource_len(ha->pdev, 1);
+	mmio_flags = pci_resource_flags(ha->pdev, 1);
+
+	if (!(mmio_flags & IORESOURCE_MEM)) {
+		dev_err(&ha->pdev->dev,
+			   "region #0 not an MMIO resource, aborting\n");
+		goto iospace_error_exit;
+	}
+	if (mmio_len < MIN_IOBASE_LEN) {
+		dev_err(&ha->pdev->dev,
+			   "Invalid PCI mem region size, aborting\n");
+		goto iospace_error_exit;
+	}
+
+	if (pci_request_regions(ha->pdev, DRIVER_NAME)) {
+		dev_warn(&ha->pdev->dev,
+			 "Failed to reserve PIO/MMIO regions\n");
+		goto iospace_error_exit;
+	}
+
+	ha->pio_address = pio;
+	ha->pio_length = pio_len;
+	ha->reg = ioremap(mmio, MIN_IOBASE_LEN);
+	if (!ha->reg) {
+		dev_err(&ha->pdev->dev, "cannot remap MMIO, aborting\n");
+		goto iospace_error_exit;
+	}
+
+	return 0;
+
+iospace_error_exit:
+	return -ENOMEM;
+}
+
 /**
  * qla4xxx_probe_adapter - callback function to probe HBA
  * @pdev: pointer to pci_dev structure
@@ -1321,68 +1381,6 @@ static void __devexit qla4xxx_remove_ada
 	pci_set_drvdata(pdev, NULL);
 }
 
-/***
- * qla4xxx_iospace_config - maps registers
- * @ha: pointer to adapter structure
- *
- * This routines maps HBA's registers from the pci address space
- * into the kernel virtual address space for memory mapped i/o.
- **/
-static int qla4xxx_iospace_config(struct scsi_qla_host *ha)
-{
-	unsigned long pio, pio_len, pio_flags;
-	unsigned long mmio, mmio_len, mmio_flags;
-
-	pio = pci_resource_start(ha->pdev, 0);
-	pio_len = pci_resource_len(ha->pdev, 0);
-	pio_flags = pci_resource_flags(ha->pdev, 0);
-	if (pio_flags & IORESOURCE_IO) {
-		if (pio_len < MIN_IOBASE_LEN) {
-			dev_warn(&ha->pdev->dev,
-				   "Invalid PCI I/O region size\n");
-			pio = 0;
-		}
-	} else {
-		dev_warn(&ha->pdev->dev, "region #0 not a PIO resource\n");
-		pio = 0;
-	}
-
-	/* Use MMIO operations for all accesses. */
-	mmio = pci_resource_start(ha->pdev, 1);
-	mmio_len = pci_resource_len(ha->pdev, 1);
-	mmio_flags = pci_resource_flags(ha->pdev, 1);
-
-	if (!(mmio_flags & IORESOURCE_MEM)) {
-		dev_err(&ha->pdev->dev,
-			   "region #0 not an MMIO resource, aborting\n");
-		goto iospace_error_exit;
-	}
-	if (mmio_len < MIN_IOBASE_LEN) {
-		dev_err(&ha->pdev->dev,
-			   "Invalid PCI mem region size, aborting\n");
-		goto iospace_error_exit;
-	}
-
-	if (pci_request_regions(ha->pdev, DRIVER_NAME)) {
-		dev_warn(&ha->pdev->dev,
-			 "Failed to reserve PIO/MMIO regions\n");
-		goto iospace_error_exit;
-	}
-
-	ha->pio_address = pio;
-	ha->pio_length = pio_len;
-	ha->reg = ioremap(mmio, MIN_IOBASE_LEN);
-	if (!ha->reg) {
-		dev_err(&ha->pdev->dev, "cannot remap MMIO, aborting\n");
-		goto iospace_error_exit;
-	}
-
-	return 0;
-
-iospace_error_exit:
-	return -ENOMEM;
-}
-
 /**
  * qla4xxx_config_dma_addressing() - Configure OS DMA addressing method.
  * @ha: HA context
