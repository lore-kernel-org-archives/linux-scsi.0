From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 4/5] SCSI/initio PCI dev init factorization
Date: Sun, 27 May 2007 10:58:11 -0400
Message-ID: <20070527145811.GD17085@havoc.gtf.org>
References: <20070527145200.GA17017@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:33569 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131AbXE0O6M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 May 2007 10:58:12 -0400
Content-Disposition: inline
In-Reply-To: <20070527145200.GA17017@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>


Factor PCI device init into separate function.  No code changes,
except for return value differences.

Signed-off-by: Jeff Garzik <jeff@garzik.org>

6714c073a9df8c923fbfc661a1f287dfd1a74852
diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 2bc2390..702dcf5 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2742,38 +2742,53 @@ static irqreturn_t i91u_intr(int irqno, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static int tul_pci_dev_init(struct pci_dev *pDev)
+{
+	long dRegValue;
+	WORD wBIOS;
+	int rc;
+
+	rc = pci_enable_device(pDev);
+	if (rc)
+		return rc;
+
+	pci_read_config_dword(pDev, 0x44, (u32 *) & dRegValue);
+	wBIOS = (UWORD) (dRegValue & 0xFF);
+	if (((dRegValue & 0xFF00) >> 8) == 0xFF)
+		dRegValue = 0;
+	wBIOS = (wBIOS << 8) + ((UWORD) ((dRegValue & 0xFF00) >> 8));
+
+	rc = pci_set_dma_mask(pDev, DMA_32BIT_MASK);
+	if (rc) {
+		printk(KERN_WARNING 
+		       "i91u: Could not set 32 bit DMA mask\n");
+		return rc;
+	}
+
+	rc = Addi91u_into_Adapter_table(wBIOS, pDev);
+	if (rc)
+		return -ENODEV;
+	
+	return 0;
+}
+
 static int tul_NewReturnNumberOfAdapters(void)
 {
 	struct pci_dev *pDev = NULL;	/* Start from none              */
 	int iAdapters = 0;
-	long dRegValue;
-	WORD wBIOS;
-	int i = 0;
+	int i;
 
 	init_i91uAdapter_table();
 
 	for (i = 0; i < ARRAY_SIZE(i91u_pci_devices); i++)
 	{
 		while ((pDev = pci_find_device(i91u_pci_devices[i].vendor, i91u_pci_devices[i].device, pDev)) != NULL) {
-			if (pci_enable_device(pDev))
-				continue;
-			pci_read_config_dword(pDev, 0x44, (u32 *) & dRegValue);
-			wBIOS = (UWORD) (dRegValue & 0xFF);
-			if (((dRegValue & 0xFF00) >> 8) == 0xFF)
-				dRegValue = 0;
-			wBIOS = (wBIOS << 8) + ((UWORD) ((dRegValue & 0xFF00) >> 8));
-			if (pci_set_dma_mask(pDev, DMA_32BIT_MASK)) {
-				printk(KERN_WARNING 
-				       "i91u: Could not set 32 bit DMA mask\n");
-				continue;
-			}
-
-			if (Addi91u_into_Adapter_table(wBIOS, pDev) == 0)
+			if (tul_pci_dev_init(pDev) == 0)
 				iAdapters++;
 		}
 	}
 
-	return (iAdapters);
+	return iAdapters;
 }
 
 static int i91u_detect(struct scsi_host_template * tpnt)
