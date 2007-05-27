From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 5/5] SCSI/initio conversion to PCI driver API
Date: Sun, 27 May 2007 10:59:55 -0400
Message-ID: <20070527145955.GE17085@havoc.gtf.org>
References: <20070527145200.GA17017@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:33574 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431AbXE0O7z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 May 2007 10:59:55 -0400
Content-Disposition: inline
In-Reply-To: <20070527145200.GA17017@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>


Prior simplifications in this patchset now permit a minimal conversion
to the new PCI API.

Further improvements and simplifications are certainly possible; those
should be presented in a separate patchset.

DO NOT APPLY (yet).  For feedback (and testers?) only.


3f42ce6a28b81cb057b2304e3aca6e873618a6fd
diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 702dcf5..e54449f 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -242,6 +242,7 @@ static void tul_read_eeprom(WORD CurBase);
 				/* ---- INTERNAL VARIABLES ---- */
 static HCS tul_hcs[MAX_SUPPORTED_ADAPTERS];
 static INI_ADPT_STRUCT i91u_adpt[MAX_SUPPORTED_ADAPTERS];
+static int i91u_adpt_count;
 
 /*NVRAM nvram, *nvramp = &nvram; */
 static NVRAM i91unvram;
@@ -2769,26 +2770,13 @@ static int tul_pci_dev_init(struct pci_dev *pDev)
 	if (rc)
 		return -ENODEV;
 	
+	i91u_adpt_count++;
 	return 0;
 }
 
 static int tul_NewReturnNumberOfAdapters(void)
 {
-	struct pci_dev *pDev = NULL;	/* Start from none              */
-	int iAdapters = 0;
-	int i;
-
-	init_i91uAdapter_table();
-
-	for (i = 0; i < ARRAY_SIZE(i91u_pci_devices); i++)
-	{
-		while ((pDev = pci_find_device(i91u_pci_devices[i].vendor, i91u_pci_devices[i].device, pDev)) != NULL) {
-			if (tul_pci_dev_init(pDev) == 0)
-				iAdapters++;
-		}
-	}
-
-	return iAdapters;
+	return i91u_adpt_count;
 }
 
 static int i91u_detect(struct scsi_host_template * tpnt)
@@ -2843,7 +2831,7 @@ static int i91u_detect(struct scsi_host_template * tpnt)
 		request_region(pHCB->HCS_Base, 256, "i91u"); /* Register */ 
 
 		pHCB->HCS_Index = i;	/* 7/29/98 */
-		hreg = scsi_register(tpnt, sizeof(HCS));
+		hreg = scsi_host_alloc(tpnt, sizeof(HCS));
 		if(hreg == NULL) {
 			release_region(pHCB->HCS_Base, 256);
 			return 0;
@@ -2865,8 +2853,21 @@ static int i91u_detect(struct scsi_host_template * tpnt)
 		if (ok < 0) {
 			printk(KERN_ERR "i91u: unable to request IRQ %d\n\n",
 			       pHCB->pci_dev->irq);
+			scsi_host_put(hreg);
+			release_region(pHCB->HCS_Base, 256);
+			return 0;
+		}
+
+		if (scsi_add_host(hreg, &pHCB->pci_dev->dev)) {
+			free_irq(pHCB->pci_dev->irq, hreg);
+			scsi_host_put(hreg);
+			release_region(pHCB->HCS_Base, 256);
 			return 0;
 		}
+
+		scsi_scan_host(hreg);
+
+		pci_set_drvdata(pHCB->pci_dev, hreg);
 	}
 
 	tpnt->this_id = -1;
@@ -3138,22 +3139,11 @@ static void i91uSCBPost(BYTE * pHcb, BYTE * pScb)
 	tul_release_scb(pHCB, pSCB);	/* Release SCB for current channel */
 }
 
-/*
- * Release ressources
- */
-static int i91u_release(struct Scsi_Host *hreg)
-{
-	free_irq(hreg->irq, hreg);
-	release_region(hreg->io_port, 256);
-	return 0;
-}
 MODULE_LICENSE("Dual BSD/GPL");
 
 static struct scsi_host_template driver_template = {
 	.proc_name	= "INI9100U",
 	.name		= i91u_REVID,
-	.detect		= i91u_detect,
-	.release	= i91u_release,
 	.queuecommand	= i91u_queuecommand,
 //	.abort		= i91u_abort,
 //	.reset		= i91u_reset,
@@ -3165,5 +3155,54 @@ static struct scsi_host_template driver_template = {
 	.cmd_per_lun 	= 1,
 	.use_clustering	= ENABLE_CLUSTERING,
 };
-#include "scsi_module.c"
 
+static int __devinit i91u_pci_probe(struct pci_dev *pdev,
+				    const struct pci_device_id *ent)
+{
+	return tul_pci_dev_init(pdev);
+}
+
+static void __devexit i91u_pci_remove(struct pci_dev *pdev)
+{
+	struct Scsi_Host *hreg = pci_get_drvdata(pdev);
+
+	scsi_remove_host(hreg);
+	free_irq(hreg->irq, hreg);
+	release_region(hreg->io_port, 256);
+	scsi_host_put(hreg);
+	pci_set_drvdata(pdev, NULL);
+	pci_disable_device(pdev);
+}
+
+static struct pci_driver i91u_pci_driver = {
+	.name		= "initio",
+	.id_table	= i91u_pci_devices,
+	.probe		= i91u_pci_probe,
+	.remove		= i91u_pci_remove,
+};
+
+static int __init i91u_init(void)
+{
+	int rc;
+	
+	init_i91uAdapter_table();
+
+	rc = pci_register_driver(&i91u_pci_driver);
+	if (rc)
+		return rc;
+	
+	if (!i91u_detect(&driver_template)) {
+		pci_unregister_driver(&i91u_pci_driver);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static void __exit i91u_exit(void)
+{
+	pci_unregister_driver(&i91u_pci_driver);
+}
+
+module_init(i91u_init);
+module_exit(i91u_exit);
