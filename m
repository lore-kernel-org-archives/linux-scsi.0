From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] fix gcc warning on 64 bit compile of gdth
Date: Mon, 03 Jan 2005 17:53:38 -0600
Message-ID: <1104796418.5506.81.camel@mulgrave>
References: <1104788704.5506.67.camel@mulgrave>
	 <20050103224321.GY26051@parcelfarce.linux.theplanet.co.uk>
	 <1104792580.5506.69.camel@mulgrave>
	 <20050103225401.GZ26051@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:13794 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262003AbVACXx5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Jan 2005 18:53:57 -0500
In-Reply-To: <20050103225401.GZ26051@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
Cc: achim_leubner@adaptec.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2005-01-03 at 22:54 +0000, Al Viro wrote:
> ... and dma_handle *is* dma_addr_t and gets used in exact same driver to
> store the results of the same function (grep for pci_map_page in there).

Fine.  But I usually observe the rule of tamper minimally ... drivers
have a nasty habit of sticking to you if you do more than that.

Indeed, now I look at the cleaned up patch, the think will leak DMA
mappings if sense_paddr is zero (which is quite possible, since zero is
a valid bus physical address).  However, I'm declaring this too minimal
to bother with ... unless you want to fix it?

James

===== drivers/scsi/gdth.c 1.47 vs edited =====
--- 1.47/drivers/scsi/gdth.c	2005-01-03 10:53:29 -06:00
+++ edited/drivers/scsi/gdth.c	2005-01-03 17:47:54 -06:00
@@ -2945,9 +2945,8 @@
         offset = (ulong)scp->sense_buffer & ~PAGE_MASK;
         sense_paddr = pci_map_page(ha->pdev,page,offset,
                                    16,PCI_DMA_FROMDEVICE);
-        scp->SCp.buffer = (struct scatterlist *)((ulong32)sense_paddr);
-        /* high part, if 64bit */
-        scp->host_scribble = (char *)(ulong32)((ulong64)sense_paddr >> 32);
+        scp->SCp.dma_handle = sense_paddr;
+
         cmdp->OpCode           = GDT_WRITE;             /* always */
         cmdp->BoardNode        = LOCALBOARD;
         if (mode64) { 
@@ -3639,13 +3638,9 @@
         else if (scp->SCp.Status == GDTH_MAP_SINGLE) 
             pci_unmap_page(ha->pdev,scp->SCp.dma_handle,
                            scp->request_bufflen,scp->SCp.Message);
-        if (scp->SCp.buffer) {
-            dma_addr_t addr;
-            addr = (dma_addr_t)(ulong32)scp->SCp.buffer;
-            if (scp->host_scribble)
-                addr += (dma_addr_t)((ulong64)(ulong32)scp->host_scribble << 32);               
-            pci_unmap_page(ha->pdev,addr,16,PCI_DMA_FROMDEVICE);
-        }
+        if (scp->SCp.dma_handle)
+            pci_unmap_page(ha->pdev,scp->SCp.dma_handle,16,PCI_DMA_FROMDEVICE);
+
 
         if (ha->status == S_OK) {
             scp->SCp.Status = S_OK;
@@ -4830,7 +4825,7 @@
     scp->SCp.phase = -1;
     scp->SCp.sent_command = -1;
     scp->SCp.Status = GDTH_MAP_NONE;
-    scp->SCp.buffer = (struct scatterlist *)NULL;
+    scp->SCp.dma_handle = 0;
 
     hanum = NUMDATA(scp->device->host)->hanum;
 #ifdef GDTH_STATISTICS


