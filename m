From: <Sumit.Saxena@lsi.com>
Subject: [PATCH 3/4] megaraid_sas : Set 32-bit DMA mask
Date: Wed, 12 Feb 2014 23:38:44 +0530
Message-ID: <201402121238.s1CCcS4F007153@cosmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1lp0153.outbound.protection.outlook.com ([207.46.163.153]:39209
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbaBLMi7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Feb 2014 07:38:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com, kashyap.desai@lsi.com, aradford@gmail.com

If consistent DMA mask is set to 64 bit, fall back to 32bit DMA mask and 32bit consistent DMA mask.
64bit consistent DMA mask may be set on some 64bit DMA slot, which causes DMA offset "10000000000000" and
MFI_INIT and IOCTL frames will have high memory addresses, leads to firmware FAULT.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Sumit Saxena <sumit.saxena@lsi.com>
---
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 9d1dc99..74cd884 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4218,6 +4218,19 @@ megasas_set_dma_mask(struct pci_dev *pdev)
 		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) != 0)
 			goto fail_set_dma_mask;
 	}
+	/*
+	 * Ensure that all data structures are allocated in 32-bit
+	 * memory.
+	 */
+	if (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)) != 0) {
+		/* Try 32bit DMA mask and 32 bit Consistent dma mask */
+		if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32))
+			&& !pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)))
+			dev_info(&pdev->dev, "set 32bit DMA mask"
+				"and 32 bit consistent mask\n");
+		else
+			goto fail_set_dma_mask;
+	}
 
 	return 0;
 
