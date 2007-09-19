From: Johannes Dickgreber <tanzy@gmx.de>
Subject: [PATCH] qla1280: uses wrong failure path after failed pci_set_dma_mask
Date: Thu, 20 Sep 2007 01:07:57 +0200
Message-ID: <46F1ABCD.8050102@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48850 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754878AbXISXG2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Sep 2007 19:06:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi

I think there will be a wrong goto target after a failed
pci_set_dma_mask.

Please Check.

Signed-off-by: Johannes Dickgreber tanzy@gmx.de
---
--- qla1280.c.orig	2007-09-19 23:32:33 +0200
+++ qla1280.c	2007-09-19 23:58:46 +0200
@@ -4298,7 +4298,7 @@ qla1280_probe_one(struct pci_dev *pdev, 
 			printk(KERN_WARNING "scsi(%li): Unable to set a "
 			       "suitable DMA mask - aborting\n", ha->host_no);
 			error = -ENODEV;
-			goto error_free_irq;
+			goto error_put_host;
 		}
 	} else
 		dprintk(2, "scsi(%li): 64 Bit PCI Addressing Enabled\n",
@@ -4308,7 +4308,7 @@ qla1280_probe_one(struct pci_dev *pdev, 
 		printk(KERN_WARNING "scsi(%li): Unable to set a "
 		       "suitable DMA mask - aborting\n", ha->host_no);
 		error = -ENODEV;
-		goto error_free_irq;
+		goto error_put_host;
 	}
 #endif



