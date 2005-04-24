From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] dc395x: Fix support for highmem
Date: Sun, 24 Apr 2005 16:31:06 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0504241627140.5774@poirot.grange>
References: <20050321075531.GC23911@suse.de> <7044.1111398919@www16.gmx.net>
  <Pine.LNX.4.56.0503211111290.20956@pcgl.dsa-ac.de>  <20050321104419.GH23911@suse.de>
  <Pine.LNX.4.56.0503211147420.20956@pcgl.dsa-ac.de>
 <Pine.LNX.4.60.0503302318250.9431@poirot.grange>  <1112220802.9435.1.camel@mulgrave>
  <Pine.LNX.4.56.0503311051290.20956@pcgl.dsa-ac.de>
 <Pine.LNX.4.60.0504100035110.4283@poirot.grange>  <Pine.LNX.4.60.0504212341390.6761@poirot.grange>
  <20050422113654.GY9371@suse.de>  <Pine.LNX.4.60.0504222203190.5348@poirot.grange>
  <Pine.LNX.4.60.0504231159260.8537@poirot.grange> <1114282904.5068.19.camel@mulgrave>
 <Pine.LNX.4.60.0504240212090.13715@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:41115 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S262283AbVDXObt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Apr 2005 10:31:49 -0400
In-Reply-To: <Pine.LNX.4.60.0504240212090.13715@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <axboe@suse.de>, Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Kurt Garloff <garloff@suse.de>

On Sun, 24 Apr 2005, Guennadi Liakhovetski wrote:

> On Sat, 23 Apr 2005, James Bottomley wrote:
> 
> > As long as the sg list hasn't gone through dma_map_sg, then you can rely
> > on its elements being contiguous in physical space.  Once it's gone
> > through dma_map_sg, it's elements are contiguous in the bus space beyond
> > the IOMMU, so no longer (possibly) even physically contiguous.
> 
> Thanks for the info. Let me see, if I got you right. Say, we've got an sg 
> with 2 elements: first 2 * PAGE_SIZE long, offset 0, pointing to page #0, 
> second PAGE_SIZE long, offset 0, page #3. Say, dma_map_sg returned 1, so, 
> it mapped all those 3 (physically discontiguous) pages to a contiguous bus 
> address range. And now sg_dma_len() returns 3 * PAGE_SIZE. But, I hope, 
> the .page, .length, and .offset elements stayed unchanged, so, one can 
> still walk elements 0 and 1, calculating a sum of sg[i].length and thus 
> arrive to the required page, right?
> 
> I'll redo the patch.

If my assumption above is right, the patch below should cover bigger than 
page sg-elements too.

Thanks
Guennadi
---
Guennadi Liakhovetski

Clean up endianness conversions, don't use bus_to_virt(), map atomically 
instead.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

diff -u a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
--- a/drivers/scsi/tmscsim.c	13 Jan 2005 21:10:01
+++ b/drivers/scsi/tmscsim.c	24 Apr 2005 12:59:36
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
@@ -882,10 +882,48 @@
     }	    
 }
 
+
+/**
+ * dc390_kmap_atomic_sg - find and atomically map an sg-elemnt
+ * @sg:		scatter-gather list
+ * @sg_count:	number of segments in sg
+ * @offset:	offset in bytes into sg, on return offset into the mapped area
+ * @len:	on return number of bytes mapped
+ *
+ * Returns virtual address of the start of the mapped page
+ */
+static void *dc390_kmap_atomic_sg(struct scatterlist *sg, int sg_count, size_t *offset, size_t *len)
+{
+	int i;
+	size_t sg_len = 0;
+	struct page *page;
+
+	for (i = 0; i < sg_count; i++) {
+		sg_len += sg[i].length;
+		if (sg_len > *offset)
+			break;
+	}
+
+	BUG_ON(i == sg_count);
+
+	*len = sg_len - *offset;
+	*offset = sg[i].offset + sg[i].length - *len;
+
+	page = sg[i].page + (*offset >> PAGE_SHIFT);
+	*offset &= ~PAGE_MASK;
+
+	return kmap_atomic(page, KM_BIO_SRC_IRQ);
+}
+
+static void dc390_kunmap_atomic_sg(void *virt)
+{
+	kunmap_atomic(virt, KM_BIO_SRC_IRQ);
+}
+
 static void
 dc390_DataIn_0( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus)
 {
-    u8   sstatus, residual, bval;
+    u8   sstatus;
     struct scatterlist *psgl;
     u32    ResidCnt, i;
     unsigned long   xferCnt;
@@ -931,16 +969,17 @@
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
@@ -988,10 +1027,25 @@
 
 	    if( residual )
 	    {
+		size_t count = 1;
+		unsigned long flags;
+		size_t offset = pSRB->TotalXferredLen;
+		struct scsi_cmnd *pcmd = pSRB->pcmd;
+		int sg_count = pcmd->use_sg ? : 1;
+		struct scatterlist *sg = pcmd->use_sg ?
+			(struct scatterlist *)pcmd->request_buffer : &pSRB->Segmentx;
+
 		bval = DC390_read8 (ScsiFifo);	    /* get one residual byte */
-		ptr = (u8 *) bus_to_virt( pSRB->SGBusAddr );
-		*ptr = bval;
-		pSRB->SGBusAddr++; xferCnt++;
+
+		local_irq_save(flags);
+		ptr = (u8*)dc390_kmap_atomic_sg(sg, sg_count, &offset, &count);
+
+		*(ptr + offset) = bval;
+		dc390_kunmap_atomic_sg(ptr);
+		local_irq_restore(flags);
+
+		pSRB->SGBusAddr++;
+		xferCnt++;
 		pSRB->TotalXferredLen++;
 		pSRB->SGToBeXferLen--;
 	    }
@@ -1212,32 +1266,31 @@
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
 
@@ -1245,11 +1298,11 @@
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
 
 
@@ -1385,8 +1438,8 @@
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
@@ -1397,8 +1450,8 @@
 	lval >>= 8;
 	DC390_write8 (CtcReg_High, (u8) lval);
 
-	DC390_write32 (DMA_XferCnt, pSRB->SGToBeXferLen);
-	DC390_write32 (DMA_XferAddr, pSRB->SGBusAddr);
+	DC390_write32 (DMA_XferCnt, cpu_to_le32(pSRB->SGToBeXferLen));
+	DC390_write32 (DMA_XferAddr, cpu_to_le32((u32)pSRB->SGBusAddr));
 
 	//DC390_write8 (DMA_Cmd, DMA_IDLE_CMD | ioDir); /* | DMA_INT; */
 	pSRB->SRBState = SRB_DATA_XFER;
@@ -2036,7 +2089,7 @@
 
     if (pSRB) 
     {
-	printk ("DC390: SRB: Xferred %08lx, Remain %08lx, State %08x, Phase %02x\n",
+	printk ("DC390: SRB: Xferred %08lx, Remain %08x, State %08x, Phase %02x\n",
 		pSRB->TotalXferredLen, pSRB->SGToBeXferLen, pSRB->SRBState,
 		pSRB->ScsiPhase);
 	printk ("DC390: AdpaterStatus: %02x, SRB Status %02x\n", pSRB->AdaptStatus, pSRB->SRBStatus);
