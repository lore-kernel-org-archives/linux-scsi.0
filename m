From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] dc395x: Fix support for highmem
Date: Thu, 21 Apr 2005 23:49:34 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0504212341390.6761@poirot.grange>
References: <20050321075531.GC23911@suse.de> <7044.1111398919@www16.gmx.net>
  <Pine.LNX.4.56.0503211111290.20956@pcgl.dsa-ac.de>  <20050321104419.GH23911@suse.de>
  <Pine.LNX.4.56.0503211147420.20956@pcgl.dsa-ac.de>
 <Pine.LNX.4.60.0503302318250.9431@poirot.grange> <1112220802.9435.1.camel@mulgrave>
 <Pine.LNX.4.56.0503311051290.20956@pcgl.dsa-ac.de>
 <Pine.LNX.4.60.0504100035110.4283@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.gmx.net ([213.165.64.20]:14801 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S261157AbVDUVu1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Apr 2005 17:50:27 -0400
In-Reply-To: <Pine.LNX.4.60.0504100035110.4283@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <axboe@suse.de>, Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Kurt Garloff <garloff@suse.de>

Hi again

A patch to tmscsim.c, removing bus_to_virt() and, while at it, cleaning up 
cpu / le32 conversions, could look something like this. Notice, it uses 
the same <...>_k(un)map_atomic_sg() as proposed for dc395x, so, certainly 
this is not a final patch - in the end those function would migrate to 
something like scsi_lib.c(?). No, I still don't know how to test those PIO 
paths.

Kurt, there are your comments in dc395x.c around the PIO code. Have you 
found out when and how it gets invoked? Do you still remember? Any hints 
for testing possibilities?

Thanks
Guennadi
---
Guennadi Liakhovetski

diff -u a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
--- a/drivers/scsi/tmscsim.c	13 Jan 2005 21:10:01
+++ b/drivers/scsi/tmscsim.c	21 Apr 2005 21:36:51
@@ -856,8 +856,8 @@
 		pSRB->pSegmentList++;
 		psgl = pSRB->pSegmentList;
 
-		pSRB->SGBusAddr = cpu_to_le32(pci_dma_lo32(sg_dma_address(psgl)));
-		pSRB->SGToBeXferLen = cpu_to_le32(sg_dma_len(psgl));
+		pSRB->SGBusAddr = sg_dma_address(psgl);
+		pSRB->SGToBeXferLen = sg_dma_len(psgl);
 	    }
 	    else
 		pSRB->SGToBeXferLen = 0;
@@ -882,10 +882,42 @@
     }	    
 }
 
+
+/**
+ * dc390_kmap_atomic_sg - find and atomically map an sg-elemnt
+ * @sg:		scatter-gather list
+ * @sg_count:	number of segments in sg
+ * @offset:	offset in bytes into sg
+ * @len:	on return number of bytes mapped
+ *
+ * Return virtual address
+ */
+static void *dc390_kmap_atomic_sg(struct scatterlist *sg, int sg_count, size_t offset, size_t *len)
+{
+	int i;
+	size_t sg_len = 0;
+
+	for (i = 0; i < sg_count; i++) {
+		sg_len += sg[i].length;
+		if (sg_len > offset)
+			break;
+	}
+
+	BUG_ON(i == sg_count);
+
+	*len = sg_len - offset;
+
+	return kmap_atomic(sg[i].page, KM_BIO_SRC_IRQ) + sg[i].offset + sg[i].length - *len;
+}
+
+static void dc390_kunmap_atomic_sg(void *virt)
+{
+	kunmap_atomic(virt_to_page(virt), KM_BIO_SRC_IRQ);
+}
 static void
 dc390_DataIn_0( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus)
 {
-    u8   sstatus, residual, bval;
+    u8   sstatus;
     struct scatterlist *psgl;
     u32    ResidCnt, i;
     unsigned long   xferCnt;
@@ -931,16 +963,17 @@
 		pSRB->pSegmentList++;
 		psgl = pSRB->pSegmentList;
 
-		pSRB->SGBusAddr = cpu_to_le32(pci_dma_lo32(sg_dma_address(psgl)));
-		pSRB->SGToBeXferLen = cpu_to_le32(sg_dma_len(psgl));
+		pSRB->SGBusAddr = sg_dma_address(psgl);
+		pSRB->SGToBeXferLen = sg_dma_len(psgl);
 	    }
 	    else
 		pSRB->SGToBeXferLen = 0;
 	}
 	else	/* phase changed */
 	{
-	    residual = 0;
-	    bval = DC390_read8 (Current_Fifo);
+	    u8 residual = 0;
+	    u8 bval = DC390_read8 (Current_Fifo);
+
 	    while( bval & 0x1f )
 	    {
 		DEBUG1(printk (KERN_DEBUG "Check for residuals,"));
@@ -988,10 +1021,20 @@
 
 	    if( residual )
 	    {
+		size_t count = 1;
+		unsigned long flags;
+
 		bval = DC390_read8 (ScsiFifo);	    /* get one residual byte */
-		ptr = (u8 *) bus_to_virt( pSRB->SGBusAddr );
+
+		local_irq_save(flags);
+		ptr = (u8*)dc390_kmap_atomic_sg(pSRB->pSegmentList, pSRB->SGcount, pSRB->TotalXferredLen, &count);
+
 		*ptr = bval;
-		pSRB->SGBusAddr++; xferCnt++;
+		dc390_kunmap_atomic_sg(ptr);
+		local_irq_restore(flags);
+
+		pSRB->SGBusAddr++;
+		xferCnt++;
 		pSRB->TotalXferredLen++;
 		pSRB->SGToBeXferLen--;
 	    }
@@ -1212,32 +1255,31 @@
 {
     struct scsi_cmnd *pcmd = pSRB->pcmd;
     struct scatterlist *psgl;
+
     pSRB->TotalXferredLen = 0;
     pSRB->SGIndex = 0;
     if (pcmd->use_sg) {
+	unsigned long last_xfer;
+
 	pSRB->pSegmentList = (struct scatterlist *)pcmd->request_buffer;
-	psgl = pSRB->pSegmentList;
-	//dc390_pci_sync(pSRB);
 
-	while (pSRB->TotalXferredLen + (unsigned long) sg_dma_len(psgl) < pSRB->Saved_Ptr)
-	{
-	    pSRB->TotalXferredLen += (unsigned long) sg_dma_len(psgl);
-	    pSRB->SGIndex++;
-	    if( pSRB->SGIndex < pSRB->SGcount )
-	    {
-		pSRB->pSegmentList++;
-		psgl = pSRB->pSegmentList;
-		pSRB->SGBusAddr = cpu_to_le32(pci_dma_lo32(sg_dma_address(psgl)));
-		pSRB->SGToBeXferLen = cpu_to_le32(sg_dma_len(psgl));
-	    }
-	    else
-		pSRB->SGToBeXferLen = 0;
+	for (psgl = pSRB->pSegmentList; pSRB->TotalXferredLen + sg_dma_len(psgl) < pSRB->Saved_Ptr; psgl++) {
+		pSRB->TotalXferredLen += sg_dma_len(psgl);
+		pSRB->SGIndex++;
 	}
-	pSRB->SGToBeXferLen -= (pSRB->Saved_Ptr - pSRB->TotalXferredLen);
-	pSRB->SGBusAddr += (pSRB->Saved_Ptr - pSRB->TotalXferredLen);
-	printk (KERN_INFO "DC390: Pointer restored. Segment %i, Total %li, Bus %08lx\n",
-		pSRB->SGIndex, pSRB->Saved_Ptr, pSRB->SGBusAddr);
 
+	BUG_ON(pSRB->SGIndex >= pSRB->SGcount);
+
+	last_xfer = pSRB->Saved_Ptr - pSRB->TotalXferredLen;
+
+	pSRB->pSegmentList += pSRB->SGIndex;
+	pSRB->SGBusAddr = sg_dma_address(psgl) + last_xfer;
+	pSRB->SGToBeXferLen = sg_dma_len(psgl) - last_xfer;
+
+	//dc390_pci_sync(pSRB);
+
+	DEBUG0(printk(KERN_INFO "DC390: Pointer restored. Segment %i, Total %li, Bus %08lx\n",
+		      pSRB->SGIndex, pSRB->Saved_Ptr, pSRB->SGBusAddr));
     } else if(pcmd->request_buffer) {
 	//dc390_pci_sync(pSRB);
 
@@ -1245,11 +1287,11 @@
 	pSRB->SGcount = 1;
 	pSRB->pSegmentList = (struct scatterlist *) &pSRB->Segmentx;
     } else {
-	 pSRB->SGcount = 0;
-	 printk (KERN_INFO "DC390: RESTORE_PTR message for Transfer without Scatter-Gather ??\n");
+	pSRB->SGcount = 0;
+	printk (KERN_INFO "DC390: RESTORE_PTR message for Transfer without Scatter-Gather ??\n");
     }
 
-  pSRB->TotalXferredLen = pSRB->Saved_Ptr;
+    pSRB->TotalXferredLen = pSRB->Saved_Ptr;
 }
 
 
@@ -1385,8 +1427,8 @@
 	if( !pSRB->SGToBeXferLen )
 	{
 	    psgl = pSRB->pSegmentList;
-	    pSRB->SGBusAddr = cpu_to_le32(pci_dma_lo32(sg_dma_address(psgl)));
-	    pSRB->SGToBeXferLen = cpu_to_le32(sg_dma_len(psgl));
+	    pSRB->SGBusAddr = sg_dma_address(psgl);
+	    pSRB->SGToBeXferLen = sg_dma_len(psgl);
 	    DEBUG1(printk (KERN_DEBUG " DC390: Next SG segment."));
 	}
 	lval = pSRB->SGToBeXferLen;
@@ -1397,8 +1439,8 @@
 	lval >>= 8;
 	DC390_write8 (CtcReg_High, (u8) lval);
 
-	DC390_write32 (DMA_XferCnt, pSRB->SGToBeXferLen);
-	DC390_write32 (DMA_XferAddr, pSRB->SGBusAddr);
+	DC390_write32 (DMA_XferCnt, cpu_to_le32(pSRB->SGToBeXferLen));
+	DC390_write32 (DMA_XferAddr, cpu_to_le32((u32)pSRB->SGBusAddr));
 
 	//DC390_write8 (DMA_Cmd, DMA_IDLE_CMD | ioDir); /* | DMA_INT; */
 	pSRB->SRBState = SRB_DATA_XFER;
@@ -2036,7 +2078,7 @@
 
     if (pSRB) 
     {
-	printk ("DC390: SRB: Xferred %08lx, Remain %08lx, State %08x, Phase %02x\n",
+	printk ("DC390: SRB: Xferred %08lx, Remain %08x, State %08x, Phase %02x\n",
 		pSRB->TotalXferredLen, pSRB->SGToBeXferLen, pSRB->SRBState,
 		pSRB->ScsiPhase);
 	printk ("DC390: AdpaterStatus: %02x, SRB Status %02x\n", pSRB->AdaptStatus, pSRB->SRBStatus);
