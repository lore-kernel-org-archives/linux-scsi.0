From: Doug Maxey <dwm@enoyolf.org>
Subject: [PATCH ver3 3/4] qla4xxx: use dev_xxx on some pci/dma resource alloc warning and error printks
Date: Sat, 05 Aug 2006 17:52:27 -0500
Message-ID: <20060805225227.9557.30796.stgit@bebe.enoyolf.org>
References: <20060805225156.9557.99072.stgit@bebe.enoyolf.org>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:3997 "EHLO
	bebe.enoyolf.org") by vger.kernel.org with ESMTP id S1751416AbWHEWyr
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 5 Aug 2006 18:54:47 -0400
In-Reply-To: <20060805225156.9557.99072.stgit@bebe.enoyolf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Ravi Anand <ravi.anand@qlogic.com>, David Somayajulu <david.somayajulu@qlogic.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org

From: Doug Maxey <dwm@enoyolf.org>

Rework some of the printk's in the pci and dma resource allocations to
- use the appropriate dev_xxx macro.
- be non conditional

Signed-off-by: Doug Maxey <dwm@enoyolf.org>
---

 drivers/scsi/qla4xxx/ql4_os.c |   46 +++++++++++++++--------------------------
 1 files changed, 17 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 1da7cf8..d88c84f 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -688,7 +688,7 @@ static void qla4xxx_free_adapter(struct 
  * @ha: pointer to adapter structure
  *
  * This routines maps HBA's registers from the pci address space
- * into the kernel virtual address space for memory mapped i/o. 
+ * into the kernel virtual address space for memory mapped i/o.
  **/
 static int qla4xxx_iospace_config(struct scsi_qla_host *ha)
 {
@@ -700,15 +700,12 @@ static int qla4xxx_iospace_config(struct
 	pio_flags = pci_resource_flags(ha->pdev, 0);
 	if (pio_flags & IORESOURCE_IO) {
 		if (pio_len < MIN_IOBASE_LEN) {
-			ql4_printk(KERN_WARNING, ha,
-				   "Invalid PCI I/O region size (%s)...\n",
-				   pci_name(ha->pdev));
+			dev_warn(&ha->pdev->dev,
+				   "Invalid PCI I/O region size\n");
 			pio = 0;
 		}
 	} else {
-		ql4_printk(KERN_WARNING, ha,
-			   "region #0 not a PIO resource (%s)...\n",
-			   pci_name(ha->pdev));
+		dev_warn(&ha->pdev->dev, "region #0 not a PIO resource\n");
 		pio = 0;
 	}
 
@@ -718,23 +715,19 @@ static int qla4xxx_iospace_config(struct
 	mmio_flags = pci_resource_flags(ha->pdev, 1);
 
 	if (!(mmio_flags & IORESOURCE_MEM)) {
-		ql4_printk(KERN_ERR, ha,
-			   "region #0 not an MMIO resource (%s), aborting\n",
-			   pci_name(ha->pdev));
+		dev_err(&ha->pdev->dev,
+			   "region #0 not an MMIO resource, aborting\n");
 		goto iospace_error_exit;
 	}
 	if (mmio_len < MIN_IOBASE_LEN) {
-		ql4_printk(KERN_ERR, ha,
-			   "Invalid PCI mem region size (%s), aborting\n",
-			   pci_name(ha->pdev));
+		dev_err(&ha->pdev->dev,
+			   "Invalid PCI mem region size, aborting\n");
 		goto iospace_error_exit;
 	}
 
 	if (pci_request_regions(ha->pdev, DRIVER_NAME)) {
-		ql4_printk(KERN_WARNING, ha,
-			   "Failed to reserve PIO/MMIO regions (%s)\n",
-			   pci_name(ha->pdev));
-
+		dev_warn(&ha->pdev->dev,
+			 "Failed to reserve PIO/MMIO regions\n");
 		goto iospace_error_exit;
 	}
 
@@ -742,10 +735,7 @@ static int qla4xxx_iospace_config(struct
 	ha->pio_length = pio_len;
 	ha->reg = ioremap(mmio, MIN_IOBASE_LEN);
 	if (!ha->reg) {
-		ql4_printk(KERN_ERR, ha,
-			   "cannot remap MMIO (%s), aborting\n",
-			   pci_name(ha->pdev));
-
+		dev_err(&ha->pdev->dev, "cannot remap MMIO, aborting\n");
 		goto iospace_error_exit;
 	}
 
@@ -782,7 +772,7 @@ void qla4xxx_config_dma_addressing(struc
 /**
  * qla4xxx_mem_alloc - allocates memory for use by adapter.
  * @ha: Pointer to host adapter structure
- * 
+ *
  * Allocates DMA memory for request and response queues. Also allocates memory
  * for srbs.
  **/
@@ -799,9 +789,8 @@ static int qla4xxx_mem_alloc(struct scsi
 	ha->queues = dma_alloc_coherent(&ha->pdev->dev, ha->queues_len,
 					&ha->queues_dma, GFP_KERNEL);
 	if (ha->queues == NULL) {
-		ql4_printk(KERN_WARNING, ha,
-			   "Memory Allocation failed - queues.\n");
-
+		dev_warn(&ha->pdev->dev,
+			 "Memory Allocation failed - queues.\n");
 		goto mem_alloc_error_exit;
 	}
 	memset(ha->queues, 0, ha->queues_len);
@@ -836,9 +825,8 @@ static int qla4xxx_mem_alloc(struct scsi
 	ha->srb_mempool = mempool_create(SRB_MIN_REQ, mempool_alloc_slab,
 					 mempool_free_slab, srb_cachep);
 	if (ha->srb_mempool == NULL) {
-		ql4_printk(KERN_WARNING, ha,
-			   "Memory Allocation failed - SRB Pool.\n");
-
+		dev_warn(&ha->pdev->dev,
+			 "Memory Allocation failed - SRB Pool.\n");
 		goto mem_alloc_error_exit;
 	}
 
@@ -1709,7 +1697,7 @@ static int qla4xxx_eh_bus_reset(struct s
  * @ddb_entry: Pointer to device database entry
  *
  * This routine issues either a warm or cold target reset to the
- * specified device. The caller must ensure that the ddb_entry pointer 
+ * specified device. The caller must ensure that the ddb_entry pointer
  * is valid before calling this routine.
  *
  **/
