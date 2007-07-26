From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 6/21] advansys: Move to scsi hotplug initialisation model
Date: Thu, 26 Jul 2007 13:22:42 -0400
Message-ID: <11854705779-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:55151 "EHLO
	mail-06.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933557AbXGZR4G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jul 2007 13:56:06 -0400
In-Reply-To: 20070726171141.GE19275@parisc-linux.org
References: 20070726171141.GE19275@parisc-linux.org
In-Reply-To: <20070726171141.GE19275@parisc-linux.org>
References: <20070726171141.GE19275@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

 - Switch from scsi_register/scsi_unregister to scsi_host_alloc,
   scsi_add_host, scsi_scan_host and scsi_host_put.
 - Rename the scsi_host_template to advansys_template
 - Move the memory freeing on error from advansys_wide_init_chip()
   back into advansys_board_found() as we need to free it if
   scsi_add_host() returns an error.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |   71 +++++++++++++++++++++-------------------------
 1 files changed, 32 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index a663d14..b56f6c5 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -3784,7 +3784,7 @@ typedef struct adv_req {
 /*
  * Structure allocated for each board.
  *
- * This structure is allocated by scsi_register() at the end
+ * This structure is allocated by scsi_host_alloc() at the end
  * of the 'Scsi_Host' structure starting at the 'hostdata'
  * field. It is guaranteed to be allocated from DMA-able memory.
  */
@@ -4578,7 +4578,7 @@ advansys_biosparam(struct scsi_device *sdev, struct block_device *bdev,
 	return 0;
 }
 
-static struct scsi_host_template driver_template = {
+static struct scsi_host_template advansys_template = {
 	.proc_name = "advansys",
 #ifdef CONFIG_PROC_FS
 	.proc_info = advansys_proc_info,
@@ -17696,7 +17696,6 @@ static void AdvInquiryHandling(ADV_DVC_VAR *asc_dvc, ADV_SCSI_REQ_Q *scsiq)
 static int __devinit
 advansys_wide_init_chip(asc_board_t *boardp, ADV_DVC_VAR *adv_dvc_varp)
 {
-	ADV_CARR_T *carrp;
 	int req_cnt = 0;
 	adv_req_t *reqp = NULL;
 	int sg_cnt = 0;
@@ -17707,10 +17706,11 @@ advansys_wide_init_chip(asc_board_t *boardp, ADV_DVC_VAR *adv_dvc_varp)
 	 * Allocate buffer carrier structures. The total size
 	 * is about 4 KB, so allocate all at once.
 	 */
-	carrp = kmalloc(ADV_CARRIER_BUFSIZE, GFP_KERNEL);
-	ASC_DBG1(1, "advansys_wide_init_chip: carrp 0x%lx\n", (ulong) carrp);
+	boardp->orig_carrp = kmalloc(ADV_CARRIER_BUFSIZE, GFP_KERNEL);
+	ASC_DBG1(1, "advansys_wide_init_chip: carrp 0x%p\n",
+							boardp->orig_carrp);
 
-	if (!carrp)
+	if (!boardp->orig_carrp)
 		goto kmalloc_failed;
 
 	/*
@@ -17732,6 +17732,8 @@ advansys_wide_init_chip(asc_board_t *boardp, ADV_DVC_VAR *adv_dvc_varp)
 	if (!reqp)
 		goto kmalloc_failed;
 
+	boardp->orig_reqp = reqp;
+
 	/*
 	 * Allocate up to ADV_TOT_SG_BLOCK request structures for
 	 * the Wide board. Each structure is about 136 bytes.
@@ -17755,16 +17757,7 @@ advansys_wide_init_chip(asc_board_t *boardp, ADV_DVC_VAR *adv_dvc_varp)
 	if (!boardp->adv_sgblkp)
 		goto kmalloc_failed;
 
-	/* Save carrier buffer pointer. */
-	boardp->orig_carrp = carrp;
-
-	/*
-	 * Save original pointer for kfree() in case the
-	 * driver is built as a module and can be unloaded.
-	 */
-	boardp->orig_reqp = reqp;
-
-	adv_dvc_varp->carrier_buf = carrp;
+	adv_dvc_varp->carrier_buf = boardp->orig_carrp;
 
 	/*
 	 * Point 'adv_reqp' to the request structures and
@@ -17796,24 +17789,14 @@ advansys_wide_init_chip(asc_board_t *boardp, ADV_DVC_VAR *adv_dvc_varp)
 			   " error 0x%x\n", boardp->id, warn_code, err_code);
 	}
 
-	if (err_code == 0)
-		return 0;
-
-	while ((sgp = boardp->adv_sgblkp) != NULL) {
-		boardp->adv_sgblkp = sgp->next_sgblkp;
-		kfree(sgp);
-	}
-
- failed:
-	kfree(reqp);
-	kfree(carrp);
-	return err_code;
+	goto exit;
 
  kmalloc_failed:
 	ASC_PRINT1("advansys_wide_init_chip: board %d error: kmalloc() "
 		   "failed\n", boardp->id);
 	err_code = ADV_ERROR;
-	goto failed;
+ exit:
+	return err_code;
 }
 
 static struct Scsi_Host *__devinit
@@ -17824,6 +17807,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 	asc_board_t *boardp;
 	ASC_DVC_VAR *asc_dvc_varp = NULL;
 	ADV_DVC_VAR *adv_dvc_varp = NULL;
+	adv_sgblk_t *sgp;
 	int share_irq = FALSE;
 	int iolen = 0;
 	ADV_PADDR pci_memory_address;
@@ -17836,8 +17820,8 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 	 * Register the adapter, get its configuration, and
 	 * initialize it.
 	 */
-	ASC_DBG(2, "advansys_board_found: scsi_register()\n");
-	shost = scsi_register(&driver_template, sizeof(asc_board_t));
+	ASC_DBG(2, "advansys_board_found: scsi_host_alloc()\n");
+	shost = scsi_host_alloc(&advansys_template, sizeof(asc_board_t));
 
 	if (!shost)
 		return NULL;
@@ -18373,10 +18357,8 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 
 	/* BIOS start address. */
 	if (ASC_NARROW_BOARD(boardp)) {
-		shost->base = ((ulong)
-			     AscGetChipBiosAddress(asc_dvc_varp->
-						   iop_base,
-						   asc_dvc_varp->bus_type));
+		shost->base = AscGetChipBiosAddress(asc_dvc_varp->iop_base,
+						   asc_dvc_varp->bus_type);
 	} else {
 		/*
 		 * Fill-in BIOS board variables. The Wide BIOS saves
@@ -18511,13 +18493,24 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 	}
 
 	if (err_code != 0)
-		goto err_free_irq;
+		goto err_free_wide_mem;
 
 	ASC_DBG_PRT_SCSI_HOST(2, shost);
 
+	ret = scsi_add_host(shost, dev);
+	if (ret)
+		goto err_free_wide_mem;
+
+	scsi_scan_host(shost);
 	return shost;
 
- err_free_irq:
+ err_free_wide_mem:
+	kfree(boardp->orig_carrp);
+	kfree(boardp->orig_reqp);
+	while ((sgp = boardp->adv_sgblkp) != NULL) {
+		boardp->adv_sgblkp = sgp->next_sgblkp;
+		kfree(sgp);
+	}
 	free_irq(shost->irq, boardp);
  err_free_dma:
 	if (shost->dma_channel != NO_ISA_DMA)
@@ -18530,7 +18523,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 	if (boardp->ioremap_addr)
 		iounmap(boardp->ioremap_addr);
  err_shost:
-	scsi_unregister(shost);
+	scsi_host_put(shost);
 	asc_board_count--;
 	return NULL;
 }
@@ -18758,7 +18751,7 @@ static int advansys_release(struct Scsi_Host *shost)
 	ASC_ASSERT(boardp->prtbuf != NULL);
 	kfree(boardp->prtbuf);
 #endif /* CONFIG_PROC_FS */
-	scsi_unregister(shost);
+	scsi_host_put(shost);
 	ASC_DBG(1, "advansys_release: end\n");
 	return 0;
 }
-- 
1.4.4.4

