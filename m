From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 5/24] advansys: Move to scsi hotplug initialisation model
Date: Fri, 27 Jul 2007 07:42:14 -0600
Message-ID: <11855437534073-git-send-email-matthew@wil.cx>
References: <20070727134038.GC21219@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:50058 "EHLO
	smtp-06.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759523AbXG0Nmf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jul 2007 09:42:35 -0400
In-Reply-To: <20070727134038.GC21219@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

 - Switch from scsi_register/scsi_unregister to scsi_host_alloc,
   scsi_add_host, scsi_scan_host and scsi_host_put.
 - Rename the scsi_host_template to advansys_template
 - Use module_init and module_exit instead of scsi_module.c
 - Remove protection against advansys_detect being called twice

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |   63 ++++++++++++++++++++++++++++------------------
 1 files changed, 38 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 87e7730..ec63139 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -3793,7 +3793,7 @@ typedef struct adv_req {
 /*
  * Structure allocated for each board.
  *
- * This structure is allocated by scsi_register() at the end
+ * This structure is allocated by scsi_host_alloc() at the end
  * of the 'Scsi_Host' structure starting at the 'hostdata'
  * field. It is guaranteed to be allocated from DMA-able memory.
  */
@@ -4635,17 +4635,12 @@ advansys_biosparam(struct scsi_device *sdev, struct block_device *bdev,
 	return 0;
 }
 
-static int __init advansys_detect(struct scsi_host_template *tpnt);
-static int advansys_release(struct Scsi_Host *shost);
-
-static struct scsi_host_template driver_template = {
+static struct scsi_host_template advansys_template = {
 	.proc_name = "advansys",
 #ifdef CONFIG_PROC_FS
 	.proc_info = advansys_proc_info,
 #endif
 	.name = "advansys",
-	.detect = advansys_detect,
-	.release = advansys_release,
 	.info = advansys_info,
 	.queuecommand = advansys_queuecommand,
 	.eh_bus_reset_handler = advansys_reset,
@@ -4653,8 +4648,8 @@ static struct scsi_host_template driver_template = {
 	.slave_configure = advansys_slave_configure,
 	/*
 	 * Because the driver may control an ISA adapter 'unchecked_isa_dma'
-	 * must be set. The flag will be cleared in advansys_detect for non-ISA
-	 * adapters. Refer to the comment in scsi_module.c for more information.
+	 * must be set. The flag will be cleared in advansys_board_found
+	 * for non-ISA adapters.
 	 */
 	.unchecked_isa_dma = 1,
 	/*
@@ -4667,8 +4662,6 @@ static struct scsi_host_template driver_template = {
 	.use_clustering = ENABLE_CLUSTERING,
 };
 
-#include "scsi_module.c"
-
 /*
  * --- Miscellaneous Driver Functions
  */
@@ -17881,8 +17874,8 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 	 * Register the adapter, get its configuration, and
 	 * initialize it.
 	 */
-	ASC_DBG(2, "advansys_board_found: scsi_register()\n");
-	shost = scsi_register(&driver_template, sizeof(asc_board_t));
+	ASC_DBG(2, "advansys_board_found: scsi_host_alloc()\n");
+	shost = scsi_host_alloc(&advansys_template, sizeof(asc_board_t));
 
 	if (!shost)
 		return NULL;
@@ -18556,6 +18549,11 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 
 	ASC_DBG_PRT_SCSI_HOST(2, shost);
 
+	ret = scsi_add_host(shost, dev);
+	if (ret)
+		goto err_free_wide_mem;
+
+	scsi_scan_host(shost);
 	return shost;
 
  err_free_wide_mem:
@@ -18577,7 +18575,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 	if (boardp->ioremap_addr)
 		iounmap(boardp->ioremap_addr);
  err_shost:
-	scsi_unregister(shost);
+	scsi_host_put(shost);
 	asc_board_count--;
 	return NULL;
 }
@@ -18595,9 +18593,8 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
  * it must not call SCSI mid-level functions including scsi_malloc()
  * and scsi_free().
  */
-static int __init advansys_detect(struct scsi_host_template *tpnt)
+static int __init advansys_detect(void)
 {
-	static int detect_called = ASC_FALSE;
 	int iop;
 	int bus;
 	int ioport = 0;
@@ -18619,14 +18616,6 @@ static int __init advansys_detect(struct scsi_host_template *tpnt)
 	};
 #endif /* CONFIG_PCI */
 
-	if (detect_called == ASC_FALSE) {
-		detect_called = ASC_TRUE;
-	} else {
-		printk
-		    ("AdvanSys SCSI: advansys_detect() multiple calls ignored\n");
-		return 0;
-	}
-
 	ASC_DBG(1, "advansys_detect: begin\n");
 
 	asc_board_count = 0;
@@ -18913,7 +18902,7 @@ static int advansys_release(struct Scsi_Host *shost)
 	ASC_ASSERT(boardp->prtbuf != NULL);
 	kfree(boardp->prtbuf);
 #endif /* CONFIG_PROC_FS */
-	scsi_unregister(shost);
+	scsi_host_put(shost);
 	ASC_DBG(1, "advansys_release: end\n");
 	return 0;
 }
@@ -18939,4 +18928,28 @@ static struct pci_device_id advansys_pci_tbl[] __devinitdata = {
 MODULE_DEVICE_TABLE(pci, advansys_pci_tbl);
 #endif /* CONFIG_PCI */
 
+static int __init advansys_init(void)
+{
+	int count;
+	count = advansys_detect();
+	return 0;
+}
+
+static void __exit advansys_exit(void)
+{
+	int i;
+
+	for (i = 0; i < asc_board_count; i++) {
+		struct Scsi_Host *host = asc_host[i];
+		if (!host)
+			continue;
+		scsi_remove_host(host);
+		advansys_release(host);
+		asc_host[i] = NULL;
+	}
+}
+
+module_init(advansys_init);
+module_exit(advansys_exit);
+
 MODULE_LICENSE("GPL");
-- 
1.4.4.4

