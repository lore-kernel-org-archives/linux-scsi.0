From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] fix gcc warning on 64 bit compile of gdth
Date: Mon, 03 Jan 2005 15:45:04 -0600
Message-ID: <1104788704.5506.67.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:18881 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261417AbVACVpU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Jan 2005 16:45:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: achim_leubner@adaptec.com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This warning:

drivers/scsi/gdth.c: In function `gdth_fill_raw_cmd':
drivers/scsi/gdth.c:2948: warning: cast to pointer from integer of
different size
drivers/scsi/gdth.c:2950: warning: cast to pointer from integer of
different size
drivers/scsi/gdth.c: In function `gdth_sync_event':
drivers/scsi/gdth.c:3644: warning: cast from pointer to integer of
different size
drivers/scsi/gdth.c:3646: warning: cast from pointer to integer of
different size

can be fixed with the following patch.

James

===== drivers/scsi/gdth.c 1.47 vs edited =====
--- 1.47/drivers/scsi/gdth.c	2005-01-03 10:53:29 -06:00
+++ edited/drivers/scsi/gdth.c	2005-01-03 11:09:32 -06:00
@@ -2945,9 +2945,9 @@
         offset = (ulong)scp->sense_buffer & ~PAGE_MASK;
         sense_paddr = pci_map_page(ha->pdev,page,offset,
                                    16,PCI_DMA_FROMDEVICE);
-        scp->SCp.buffer = (struct scatterlist *)((ulong32)sense_paddr);
+        scp->SCp.buffer = (struct scatterlist *)((unsigned long)sense_paddr);
         /* high part, if 64bit */
-        scp->host_scribble = (char *)(ulong32)((ulong64)sense_paddr >> 32);
+        scp->host_scribble = (char *)(unsigned long)((ulong64)sense_paddr >> 32);
         cmdp->OpCode           = GDT_WRITE;             /* always */
         cmdp->BoardNode        = LOCALBOARD;
         if (mode64) { 
@@ -3641,9 +3641,9 @@
                            scp->request_bufflen,scp->SCp.Message);
         if (scp->SCp.buffer) {
             dma_addr_t addr;
-            addr = (dma_addr_t)(ulong32)scp->SCp.buffer;
+            addr = (dma_addr_t)(unsigned long)scp->SCp.buffer;
             if (scp->host_scribble)
-                addr += (dma_addr_t)((ulong64)(ulong32)scp->host_scribble << 32);               
+                addr += (dma_addr_t)((ulong64)(unsigned long)scp->host_scribble << 32);               
             pci_unmap_page(ha->pdev,addr,16,PCI_DMA_FROMDEVICE);
         }
 


