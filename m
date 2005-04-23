From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] dc395x: Fix support for highmem
Date: Sat, 23 Apr 2005 12:06:13 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0504231159260.8537@poirot.grange>
References: <20050321075531.GC23911@suse.de> <7044.1111398919@www16.gmx.net>
 <Pine.LNX.4.56.0503211111290.20956@pcgl.dsa-ac.de> <20050321104419.GH23911@suse.de>
 <Pine.LNX.4.56.0503211147420.20956@pcgl.dsa-ac.de>
 <Pine.LNX.4.60.0503302318250.9431@poirot.grange> <1112220802.9435.1.camel@mulgrave>
 <Pine.LNX.4.56.0503311051290.20956@pcgl.dsa-ac.de>
 <Pine.LNX.4.60.0504100035110.4283@poirot.grange> <Pine.LNX.4.60.0504212341390.6761@poirot.grange>
 <20050422113654.GY9371@suse.de> <Pine.LNX.4.60.0504222203190.5348@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:9143 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S261527AbVDWKG5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Apr 2005 06:06:57 -0400
In-Reply-To: <Pine.LNX.4.60.0504222203190.5348@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Kurt Garloff <garloff@suse.de>

Hm, it is sometimes a good idea to at least compile-test ones patches... 
So, the one below at least compiles.

One more thing I wanted to ask - what can one assume about request 
buffers? If it is a sg, I guess, each segment is within one page frame, 
right? And if sg is not used, is request_buffer also guaranteed to be 
within one page or not?

On Sat, 23 Apr 2005, Guennadi Liakhovetski wrote:

> On Fri, 22 Apr 2005, Jens Axboe wrote:
> 
> > On Thu, Apr 21 2005, Guennadi Liakhovetski wrote:
> > > +static void dc390_kunmap_atomic_sg(void *virt)
> > > +{
> > > +	kunmap_atomic(virt_to_page(virt), KM_BIO_SRC_IRQ);
> > > +}
> > 
> > Please remember to test this with highmem debug. The above is buggy,
> > kunmap_atomic() takes the mapped pointer, not the page structure.
> 
> Oops... Thanks. Sure, I'd like to test it - the problem been, I don't know 
> how to get the damn thing to execute that place. I'll keep thinking about 
> testing possibilities. So far on both my test machines with HDs, CD-ROM, 
> tape and an external ZIP it didn't hit that path. Below is an updated 
> patch.
> 
> By highmem debug do you mean just enabling the respective option under 
> kernel debugging or one still needs that patch from Andrea you mentioned 
> earlier to test it on low mem machines?

Thanks
Guennadi
---
Guennadi Liakhovetski

diff -u a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
--- a/drivers/scsi/tmscsim.c	13 Jan 2005 21:10:01
+++ b/drivers/scsi/tmscsim.c	23 Apr 2005 09:56:50
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
@@ -882,10 +882,44 @@
     }	    
 }
 
+
+/**
+ * dc390_kmap_atomic_sg - find and atomically map an sg-elemnt
+ * @sg:		scatter-gather list
+ * @sg_count:	number of segments in sg
+ * @offset:	offset in bytes into sg, on return offset into mapped area
+ * @len:	on return number of bytes mapped
+ *
+ * Returns virtual address of the start of the mapped page
+ */
+static void *dc390_kmap_atomic_sg(struct scatterlist *sg, int sg_count, size_t *offset, size_t *len)
+{
+	int i;
+	size_t sg_len = 0;
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
+	return kmap_atomic(sg[i].page, KM_BIO_SRC_IRQ);
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
@@ -931,16 +965,17 @@
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
@@ -988,10 +1023,24 @@
 
 	    if( residual )
 	    {
+		size_t count = 1;
+		unsigned long flags;
+		size_t offset = pSRB->TotalXferredLen;
+		struct scsi_cmnd *pcmd = pSRB->pcmd;
+		struct scatterlist *sg = pcmd->use_sg ?
+			(struct scatterlist *)pcmd->request_buffer : &pSRB->Segmentx;
+
 		bval = DC390_read8 (ScsiFifo);	    /* get one residual byte */
-		ptr = (u8 *) bus_to_virt( pSRB->SGBusAddr );
-		*ptr = bval;
-		pSRB->SGBusAddr++; xferCnt++;
+
+		local_irq_save(flags);
+		ptr = (u8*)dc390_kmap_atomic_sg(sg, pSRB->SGcount, &offset, &count);
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
@@ -1212,32 +1261,31 @@
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
 
@@ -1245,11 +1293,11 @@
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
 
 
@@ -1385,8 +1433,8 @@
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
@@ -1397,8 +1445,8 @@
 	lval >>= 8;
 	DC390_write8 (CtcReg_High, (u8) lval);
 
-	DC390_write32 (DMA_XferCnt, pSRB->SGToBeXferLen);
-	DC390_write32 (DMA_XferAddr, pSRB->SGBusAddr);
+	DC390_write32 (DMA_XferCnt, cpu_to_le32(pSRB->SGToBeXferLen));
+	DC390_write32 (DMA_XferAddr, cpu_to_le32((u32)pSRB->SGBusAddr));
 
 	//DC390_write8 (DMA_Cmd, DMA_IDLE_CMD | ioDir); /* | DMA_INT; */
 	pSRB->SRBState = SRB_DATA_XFER;
@@ -2036,7 +2084,7 @@
 
     if (pSRB) 
     {
-	printk ("DC390: SRB: Xferred %08lx, Remain %08lx, State %08x, Phase %02x\n",
+	printk ("DC390: SRB: Xferred %08lx, Remain %08x, State %08x, Phase %02x\n",
 		pSRB->TotalXferredLen, pSRB->SGToBeXferLen, pSRB->SRBState,
 		pSRB->ScsiPhase);
 	printk ("DC390: AdpaterStatus: %02x, SRB Status %02x\n", pSRB->AdaptStatus, pSRB->SRBStatus);
