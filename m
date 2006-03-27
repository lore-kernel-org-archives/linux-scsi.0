From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 4/11] aacraid: Error path cleanup
Date: Mon, 27 Mar 2006 09:44:11 -0800
Message-ID: <1143481451.21975.39.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:31167 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751117AbWC0RoO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Mar 2006 12:44:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

Received from Mark Salyzyn

Some of the error return paths during initialization resulted in a zero
report to caller

Signed-off-by: Mark Haverkamp <markh@osdl.org>
---
Applies to the scsi-misc-2.6 git tree.

--- scsi-misc-aac.orig/drivers/scsi/aacraid/linit.c	2006-03-22 11:17:41.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/linit.c	2006-03-22 11:17:46.000000000 -0800
@@ -799,10 +799,11 @@
 	error = pci_enable_device(pdev);
 	if (error)
 		goto out;
+	error = -ENODEV;
 
 	if (pci_set_dma_mask(pdev, DMA_32BIT_MASK) || 
 			pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK))
-		goto out;
+		goto out_disable_pdev;
 	/*
 	 * If the quirk31 bit is set, the adapter needs adapter
 	 * to driver communication memory to be allocated below 2gig
@@ -810,7 +811,7 @@
 	if (aac_drivers[index].quirks & AAC_QUIRK_31BIT) 
 		if (pci_set_dma_mask(pdev, 0x7FFFFFFFULL) ||
 				pci_set_consistent_dma_mask(pdev, 0x7FFFFFFFULL))
-			goto out;
+			goto out_disable_pdev;
 	
 	pci_set_master(pdev);
 

-- 
Mark Haverkamp <markh@osdl.org>

