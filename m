From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 1/5] aacraid: Use DMA mask defines
Date: Mon, 24 Oct 2005 10:51:44 -0700
Message-ID: <1130176305.4628.21.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:28126 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751196AbVJXRvs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 13:51:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn.

This patch changes the driver over to utilizing the DMA_64BIT_MASK and
DMA_32BIT_MASK manifests.

Applies to the scsi-rc-fixes-2.6 git tree.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

---

Index: scsi-rc-aac-1/drivers/scsi/aacraid/aachba.c
===================================================================
--- scsi-rc-aac-1.orig/drivers/scsi/aacraid/aachba.c	2005-10-19 13:03:36.000000000 -0700
+++ scsi-rc-aac-1/drivers/scsi/aacraid/aachba.c	2005-10-19 13:03:53.000000000 -0700
@@ -822,12 +822,12 @@
 		dev->dac_support = (dacmode!=0);
 	}
 	if(dev->dac_support != 0) {
-		if (!pci_set_dma_mask(dev->pdev, 0xFFFFFFFFFFFFFFFFULL) &&
-			!pci_set_consistent_dma_mask(dev->pdev, 0xFFFFFFFFFFFFFFFFULL)) {
+		if (!pci_set_dma_mask(dev->pdev, DMA_64BIT_MASK) &&
+			!pci_set_consistent_dma_mask(dev->pdev, DMA_64BIT_MASK)) {
 			printk(KERN_INFO"%s%d: 64 Bit DAC enabled\n",
 				dev->name, dev->id);
-		} else if (!pci_set_dma_mask(dev->pdev, 0xFFFFFFFFULL) &&
-			!pci_set_consistent_dma_mask(dev->pdev, 0xFFFFFFFFULL)) {
+		} else if (!pci_set_dma_mask(dev->pdev, DMA_32BIT_MASK) &&
+			!pci_set_consistent_dma_mask(dev->pdev, DMA_32BIT_MASK)) {
 			printk(KERN_INFO"%s%d: DMA mask set failed, 64 Bit DAC disabled\n",
 				dev->name, dev->id);
 			dev->dac_support = 0;
Index: scsi-rc-aac-1/drivers/scsi/aacraid/linit.c
===================================================================
--- scsi-rc-aac-1.orig/drivers/scsi/aacraid/linit.c	2005-10-19 13:03:36.000000000 -0700
+++ scsi-rc-aac-1/drivers/scsi/aacraid/linit.c	2005-10-19 13:03:53.000000000 -0700
@@ -752,8 +752,8 @@
 	if (error)
 		goto out;
 
-	if (pci_set_dma_mask(pdev, 0xFFFFFFFFULL) || 
-			pci_set_consistent_dma_mask(pdev, 0xFFFFFFFFULL))
+	if (pci_set_dma_mask(pdev, DMA_32BIT_MASK) || 
+			pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK))
 		goto out;
 	/*
 	 * If the quirk31 bit is set, the adapter needs adapter
@@ -797,8 +797,8 @@
 	 * address space.
 	 */
 	if (aac_drivers[index].quirks & AAC_QUIRK_31BIT)
-		if (pci_set_dma_mask(pdev, 0xFFFFFFFFULL))
-			goto out_free_fibs;
+		if (pci_set_dma_mask(pdev, DMA_32BIT_MASK))
+			goto out_deinit;
 
 	aac->maximum_num_channels = aac_drivers[index].channels;
 	error = aac_get_adapter_info(aac);

-- 
Mark Haverkamp <markh@osdl.org>

