From: viro@parcelfarce.linux.theplanet.co.uk
Subject: [PATCH] megaraid iomem annotations
Date: Thu, 21 Oct 2004 00:53:35 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041020235335.GY23987@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:22697 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S270628AbUJTXxi
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Oct 2004 19:53:38 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
----
diff -urN RC9-bk4-ips/drivers/scsi/megaraid/megaraid_mbox.c RC9-bk4-megaraid/drivers/scsi/megaraid/megaraid_mbox.c
--- RC9-bk4-ips/drivers/scsi/megaraid/megaraid_mbox.c	Wed Oct 20 10:56:03 2004
+++ RC9-bk4-megaraid/drivers/scsi/megaraid/megaraid_mbox.c	Wed Oct 20 19:24:36 2004
@@ -872,8 +872,7 @@
 		goto out_free_raid_dev;
 	}
 
-	raid_dev->baseaddr = (unsigned long)
-			ioremap_nocache(raid_dev->baseport, 128);
+	raid_dev->baseaddr = ioremap_nocache(raid_dev->baseport, 128);
 
 	if (!raid_dev->baseaddr) {
 
@@ -996,7 +995,7 @@
 out_free_irq:
 	free_irq(adapter->irq, adapter);
 out_iounmap:
-	iounmap((caddr_t)raid_dev->baseaddr);
+	iounmap(raid_dev->baseaddr);
 out_release_regions:
 	pci_release_regions(pdev);
 out_free_raid_dev:
@@ -1024,7 +1023,7 @@
 
 	free_irq(adapter->irq, adapter);
 
-	iounmap((caddr_t)raid_dev->baseaddr);
+	iounmap(raid_dev->baseaddr);
 
 	pci_release_regions(adapter->pdev);
 
diff -urN RC9-bk4-ips/drivers/scsi/megaraid/megaraid_mbox.h RC9-bk4-megaraid/drivers/scsi/megaraid/megaraid_mbox.h
--- RC9-bk4-ips/drivers/scsi/megaraid/megaraid_mbox.h	Mon Oct 18 22:04:50 2004
+++ RC9-bk4-megaraid/drivers/scsi/megaraid/megaraid_mbox.h	Wed Oct 20 19:24:36 2004
@@ -231,7 +231,7 @@
 	dma_addr_t			mbox_dma;
 	spinlock_t			mailbox_lock;
 	unsigned long			baseport;
-	unsigned long			baseaddr;
+	void __iomem *			baseaddr;
 	struct mraid_pci_blk		mbox_pool[MBOX_MAX_SCSI_CMDS];
 	struct dma_pool			*mbox_pool_handle;
 	struct mraid_pci_blk		epthru_pool[MBOX_MAX_SCSI_CMDS];
