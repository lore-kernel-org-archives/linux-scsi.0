From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix wrong argument to pci_dma_sync_sg in megaraid driver
Date: Sun, 1 Feb 2004 17:00:32 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040201160032.GA14959@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:8876 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S265356AbUBAQAg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Feb 2004 11:00:36 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com, Atulm@lsil.com
Cc: linux-scsi@vger.kernel.org

sgl is incremented for each element in the routine, but pci_dma_sync_sg
needs the original buffer.


--- 1.59/drivers/scsi/megaraid.c	Fri Jan 23 06:37:03 2004
+++ edited/drivers/scsi/megaraid.c	Sat Jan 31 07:09:25 2004
@@ -1805,7 +1805,7 @@
 	*len = (u32)cmd->request_bufflen;
 
 	if( scb->dma_direction == PCI_DMA_TODEVICE ) {
-		pci_dma_sync_sg(adapter->dev, sgl, cmd->use_sg,
+		pci_dma_sync_sg(adapter->dev, cmd->request_buffer, cmd->use_sg,
 				PCI_DMA_TODEVICE);
 	}
 
