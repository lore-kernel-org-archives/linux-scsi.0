From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 24/24] advansys: Remove array of all known hosts
Date: Fri, 27 Jul 2007 07:42:33 -0600
Message-ID: <11855437541196-git-send-email-matthew@wil.cx>
References: <20070727134038.GC21219@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:38912 "EHLO
	mail-06.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933515AbXG0Nmi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jul 2007 09:42:38 -0400
In-Reply-To: <20070727134038.GC21219@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

 - Remove some pointless checking the driver was performing on the midlayer
 - Keep an array of legacy (ISA and VLB) hosts
 - Move scsi_remove_host() call to advansys_release() and kill off
   advansys_remove
---
 drivers/scsi/advansys.c |  121 ++++++++++------------------------------------
 1 files changed, 27 insertions(+), 94 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 548ffcd..641bcb7 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -65,6 +65,7 @@
  * 6. Remove internal queueing
  * 7. Use scsi_transport_spi
  * 8. advansys_info is not safe against multiple simultaneous callers
+ * 9. Kill boardp->id
  */
 #warning this driver is still not properly converted to the DMA API
 
@@ -2469,7 +2470,7 @@ do { \
  * --- Driver Constants and Macros
  */
 
-#define ASC_NUM_BOARD_SUPPORTED 16
+#define ASC_LEGACY_BOARD_SUPPORTED 8
 #define ASC_NUM_IOPORT_PROBE    4
 #define ASC_NUM_BUS             2
 
@@ -2900,15 +2901,12 @@ typedef struct asc_board {
 							dvc_var.adv_dvc_var)
 #define adv_dvc_to_pdev(adv_dvc) to_pci_dev(adv_dvc_to_board(adv_dvc)->dev)
 
-/*
- * --- Driver Data
- */
-
-/* Note: All driver global data should be initialized. */
+/* Number of ISA/VLB boards detected in system. */
+static int asc_legacy_count;
+static struct Scsi_Host *asc_legacy_hosts[ASC_LEGACY_BOARD_SUPPORTED];
 
-/* Number of boards detected in system. */
+/* board number.  Used to initialise boardp->id */
 static int asc_board_count = 0;
-static struct Scsi_Host *asc_host[ASC_NUM_BOARD_SUPPORTED] = { NULL };
 
 /* Overrun buffer used by all narrow boards. */
 static uchar overrun_buf[ASC_OVERRUN_BSIZE] = { 0 };
@@ -2993,7 +2991,7 @@ static void asc_prt_hex(char *f, uchar *, int);
 
 #ifdef CONFIG_PROC_FS
 /*
- * advansys_proc_info() - /proc/scsi/advansys/[0-(ASC_NUM_BOARD_SUPPORTED-1)]
+ * advansys_proc_info() - /proc/scsi/advansys/
  *
  * *buffer: I/O buffer
  * **start: if inout == FALSE pointer into buffer where user read should start
@@ -4625,7 +4623,6 @@ static void asc_isr_callback(ASC_DVC_VAR *asc_dvc_varp, ASC_QDONE_INFO *qdonep)
 	asc_board_t *boardp;
 	struct scsi_cmnd *scp;
 	struct Scsi_Host *shost;
-	int i;
 
 	ASC_DBG2(1, "asc_isr_callback: asc_dvc_varp 0x%lx, qdonep 0x%lx\n",
 		 (ulong)asc_dvc_varp, (ulong)qdonep);
@@ -4644,23 +4641,7 @@ static void asc_isr_callback(ASC_DVC_VAR *asc_dvc_varp, ASC_QDONE_INFO *qdonep)
 	}
 	ASC_DBG_PRT_CDB(2, scp->cmnd, scp->cmd_len);
 
-	/*
-	 * If the request's host pointer is not valid, display a
-	 * message and return.
-	 */
 	shost = scp->device->host;
-	for (i = 0; i < asc_board_count; i++) {
-		if (asc_host[i] == shost) {
-			break;
-		}
-	}
-	if (i == asc_board_count) {
-		ASC_PRINT2
-		    ("asc_isr_callback: scp 0x%lx has bad host pointer, host 0x%lx\n",
-		     (ulong)scp, (ulong)shost);
-		return;
-	}
-
 	ASC_STATS(shost, callback);
 	ASC_DBG1(1, "asc_isr_callback: shost 0x%lx\n", (ulong)shost);
 
@@ -4788,7 +4769,6 @@ static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
 	adv_sgblk_t *sgblkp;
 	struct scsi_cmnd *scp;
 	struct Scsi_Host *shost;
-	int i;
 	ADV_DCNT resid_cnt;
 
 	ASC_DBG2(1, "adv_isr_callback: adv_dvc_varp 0x%lx, scsiqp 0x%lx\n",
@@ -4824,27 +4804,7 @@ static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
 	}
 	ASC_DBG_PRT_CDB(2, scp->cmnd, scp->cmd_len);
 
-	/*
-	 * If the request's host pointer is not valid, display a message
-	 * and return.
-	 */
 	shost = scp->device->host;
-	for (i = 0; i < asc_board_count; i++) {
-		if (asc_host[i] == shost) {
-			break;
-		}
-	}
-	/*
-	 * Note: If the host structure is not found, the adv_req_t request
-	 * structure and adv_sgblk_t structure, if any, is dropped.
-	 */
-	if (i == asc_board_count) {
-		ASC_PRINT2
-		    ("adv_isr_callback: scp 0x%lx has bad host pointer, host 0x%lx\n",
-		     (ulong)scp, (ulong)shost);
-		return;
-	}
-
 	ASC_STATS(shost, callback);
 	ASC_DBG1(1, "adv_isr_callback: shost 0x%lx\n", (ulong)shost);
 
@@ -16383,13 +16343,10 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 	if (!shost)
 		return NULL;
 
-	/* Save a pointer to the Scsi_Host of each board found. */
-	asc_host[asc_board_count++] = shost;
-
 	/* Initialize private per board data */
 	boardp = ASC_BOARDP(shost);
 	memset(boardp, 0, sizeof(asc_board_t));
-	boardp->id = asc_board_count - 1;
+	boardp->id = asc_board_count++;
 	spin_lock_init(&boardp->lock);
 	boardp->dev = dev;
 
@@ -16993,7 +16950,6 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 		iounmap(boardp->ioremap_addr);
  err_shost:
 	scsi_host_put(shost);
-	asc_board_count--;
 	return NULL;
 }
 
@@ -17017,7 +16973,7 @@ static int __init advansys_detect(void)
 
 	ASC_DBG(1, "advansys_detect: begin\n");
 
-	asc_board_count = 0;
+	asc_legacy_count = 0;
 
 	/*
 	 * If I/O port probing has been modified, then verify and
@@ -17052,10 +17008,10 @@ static int __init advansys_detect(void)
 			 bus, asc_bus_name[bus]);
 		iop = 0;
 
-		while (asc_board_count < ASC_NUM_BOARD_SUPPORTED) {
+		while (asc_legacy_count < ASC_LEGACY_BOARD_SUPPORTED) {
 
-			ASC_DBG1(2, "advansys_detect: asc_board_count %d\n",
-				 asc_board_count);
+			ASC_DBG1(2, "advansys_detect: asc_legacy_count %d\n",
+				 asc_legacy_count);
 
 			switch (asc_bus[bus]) {
 			case ASC_IS_ISA:
@@ -17151,22 +17107,22 @@ static int __init advansys_detect(void)
 			}
 			ASC_DBG1(1, "advansys_detect: iop 0x%x\n", iop);
 
-			/*
-			 * Adapter not found, try next bus type.
-			 */
-			if (iop == 0) {
+			/* Adapter not found, try next bus type. */
+			if (iop == 0)
 				break;
-			}
 
 			shost = advansys_board_found(iop, NULL, asc_bus[bus]);
-			if (!shost)
+			if (shost) {
+				asc_legacy_hosts[asc_legacy_count++] = shost;
+			} else {
 				release_region(iop, ASC_IOADR_GAP);
+			}
 		}
 	}
 
-	ASC_DBG1(1, "advansys_detect: done: asc_board_count %d\n",
-		 asc_board_count);
-	return asc_board_count;
+	ASC_DBG1(1, "advansys_detect: done: asc_legacy_count %d\n",
+		 asc_legacy_count);
+	return asc_legacy_count;
 }
 
 /*
@@ -17176,10 +17132,10 @@ static int __init advansys_detect(void)
  */
 static int advansys_release(struct Scsi_Host *shost)
 {
-	asc_board_t *boardp;
+	asc_board_t *boardp = ASC_BOARDP(shost);
 
 	ASC_DBG(1, "advansys_release: begin\n");
-	boardp = ASC_BOARDP(shost);
+	scsi_remove_host(shost);
 	free_irq(shost->irq, shost);
 	if (shost->dma_channel != NO_ISA_DMA) {
 		ASC_DBG(1, "advansys_release: free_dma()\n");
@@ -17200,29 +17156,12 @@ static int advansys_release(struct Scsi_Host *shost)
 			kfree(sgp);
 		}
 	}
-#ifdef CONFIG_PROC_FS
-	ASC_ASSERT(boardp->prtbuf != NULL);
 	kfree(boardp->prtbuf);
-#endif /* CONFIG_PROC_FS */
 	scsi_host_put(shost);
 	ASC_DBG(1, "advansys_release: end\n");
 	return 0;
 }
 
-static void __devexit advansys_remove(struct Scsi_Host *shost)
-{
-	int i;
-	scsi_remove_host(shost);
-	advansys_release(shost);
-
-	for (i = 0; i < asc_board_count; i++) {
-		if (asc_host[i] == shost) {
-			asc_host[i] = NULL;
-			break;
-		}
-	}
-}
-
 static struct eisa_device_id advansys_eisa_table[] __devinitdata = {
 	{ "ABP7401" },
 	{ "ABP7501" },
@@ -17292,7 +17231,7 @@ static __devexit int advansys_eisa_remove(struct device *dev)
 		if (!shost)
 			continue;
 		ioport = shost->io_port;
-		advansys_remove(data->host[i]);
+		advansys_release(data->host[i]);
 		release_region(ioport, ASC_IOADR_GAP);
 	}
 
@@ -17374,7 +17313,7 @@ advansys_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 static void __devexit advansys_pci_remove(struct pci_dev *pdev)
 {
-	advansys_remove(pci_get_drvdata(pdev));
+	advansys_release(pci_get_drvdata(pdev));
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
 }
@@ -17411,14 +17350,8 @@ static void __exit advansys_exit(void)
 	pci_unregister_driver(&advansys_pci_driver);
 	eisa_driver_unregister(&advansys_eisa_driver);
 
-	for (i = 0; i < asc_board_count; i++) {
-		struct Scsi_Host *host = asc_host[i];
-		if (!host)
-			continue;
-		scsi_remove_host(host);
-		advansys_release(host);
-		asc_host[i] = NULL;
-	}
+	for (i = 0; i < asc_legacy_count; i++)
+		advansys_release(asc_legacy_hosts[i]);
 }
 
 module_init(advansys_init);
-- 
1.4.4.4

