From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 6/23] advansys: Move to scsi hotplug initialisation model
Date: Mon, 30 Jul 2007 10:56:51 -0600
Message-ID: <11858146281790-git-send-email-matthew@wil.cx>
References: <20070730165508.GH21219@parisc-linux.org> <11858146283240-git-send-email-matthew@wil.cx> <1185814628978-git-send-email-matthew@wil.cx> <11858146282602-git-send-email-matthew@wil.cx> <11858146283106-git-send-email-matthew@wil.cx> <11858146282252-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:43531 "EHLO
	mail-01.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964959AbXG3Q5N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jul 2007 12:57:13 -0400
In-Reply-To: <11858146282252-git-send-email-matthew@wil.cx>
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
 drivers/scsi/advansys.c |   61 +++++++++++++++++++++++++++-------------------
 1 files changed, 36 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 303dc98..8353680 100644
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
@@ -4632,17 +4632,12 @@ advansys_biosparam(struct scsi_device *sdev, struct block_device *bdev,
 	return 0;
 }
 
-static int __init advansys_detect(struct scsi_host_template *tpnt);
-static int advansys_release(struct Scsi_Host *shp);
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
@@ -4650,8 +4645,8 @@ static struct scsi_host_template driver_template = {
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
@@ -4664,8 +4659,6 @@ static struct scsi_host_template driver_template = {
 	.use_clustering = ENABLE_CLUSTERING,
 };
 
-#include "scsi_module.c"
-
 /*
  * --- Miscellaneous Driver Functions
  */
@@ -17839,8 +17832,8 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 	 * Register the adapter, get its configuration, and
 	 * initialize it.
 	 */
-	ASC_DBG(2, "advansys_board_found: scsi_register()\n");
-	shost = scsi_register(&driver_template, sizeof(asc_board_t));
+	ASC_DBG(2, "advansys_board_found: scsi_host_alloc()\n");
+	shost = scsi_host_alloc(&advansys_template, sizeof(asc_board_t));
 
 	if (!shost)
 		return NULL;
@@ -18503,6 +18496,11 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 
 	ASC_DBG_PRT_SCSI_HOST(2, shost);
 
+	ret = scsi_add_host(shost, dev);
+	if (ret)
+		goto err_free_wide_mem;
+
+	scsi_scan_host(shost);
 	return shost;
 
  err_free_wide_mem:
@@ -18519,7 +18517,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 	if (boardp->ioremap_addr)
 		iounmap(boardp->ioremap_addr);
  err_shost:
-	scsi_unregister(shost);
+	scsi_host_put(shost);
 	asc_board_count--;
 	return NULL;
 }
@@ -18537,9 +18535,8 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
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
@@ -18561,14 +18558,6 @@ static int __init advansys_detect(struct scsi_host_template *tpnt)
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
@@ -18829,6 +18818,7 @@ static int advansys_release(struct Scsi_Host *shost)
 	asc_board_t *boardp;
 
 	ASC_DBG(1, "advansys_release: begin\n");
+	scsi_remove_host(shost);
 	boardp = ASC_BOARDP(shost);
 	free_irq(shost->irq, shost);
 	if (shost->dma_channel != NO_ISA_DMA) {
@@ -18841,7 +18831,7 @@ static int advansys_release(struct Scsi_Host *shost)
 		advansys_wide_free_mem(boardp);
 	}
 	kfree(boardp->prtbuf);
-	scsi_unregister(shost);
+	scsi_host_put(shost);
 	ASC_DBG(1, "advansys_release: end\n");
 	return 0;
 }
@@ -18867,4 +18857,25 @@ static struct pci_device_id advansys_pci_tbl[] __devinitdata = {
 MODULE_DEVICE_TABLE(pci, advansys_pci_tbl);
 #endif /* CONFIG_PCI */
 
+static int __init advansys_init(void)
+{
+	int count;
+	count = advansys_detect();
+	if (count == 0)
+		return -ENODEV;
+
+	return 0;
+}
+
+static void __exit advansys_exit(void)
+{
+	int i;
+
+	for (i = 0; i < asc_board_count; i++)
+		advansys_release(asc_host[i]);
+}
+
+module_init(advansys_init);
+module_exit(advansys_exit);
+
 MODULE_LICENSE("GPL");
-- 
1.4.4.4

