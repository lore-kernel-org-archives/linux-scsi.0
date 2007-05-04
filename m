From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 3/3] tmscsim: Remove the last bus_to_virt()
Date: Fri, 4 May 2007 23:00:49 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0705042259430.21060@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60678 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1031576AbXEDVAx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 May 2007 17:00:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

Dynamically map the buffer for PIO for the residue byte.

Signed-off-by: G. Liakhovetski <g.liakhovetski@gmx.de>

diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index be869d0..aec63ef 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -351,6 +351,27 @@ static u8  dc390_clock_speed[] = {100,80,67,57,50, 40, 31, 20};
  * (DCBs, SRBs, Queueing)
  *
  **********************************************************************/
+static void inline dc390_start_segment(struct dc390_srb* pSRB)
+{
+	struct scatterlist *psgl = pSRB->pSegmentList;
+
+	/* start new sg segment */
+	pSRB->SGBusAddr = sg_dma_address(psgl);
+	pSRB->SGToBeXferLen = sg_dma_len(psgl);
+}
+
+static unsigned long inline dc390_advance_segment(struct dc390_srb* pSRB, u32 residue)
+{
+	unsigned long xfer = pSRB->SGToBeXferLen - residue;
+
+	/* xfer more bytes transferred */
+	pSRB->SGBusAddr += xfer;
+	pSRB->TotalXferredLen += xfer;
+	pSRB->SGToBeXferLen = residue;
+
+	return xfer;
+}
+
 static struct dc390_dcb __inline__ *dc390_findDCB ( struct dc390_acb* pACB, u8 id, u8 lun)
 {
    struct dc390_dcb* pDCB = pACB->pLinkDCB; if (!pDCB) return NULL;
@@ -741,11 +762,10 @@ static irqreturn_t do_DC390_Interrupt(int irq, void *dev_id)
 }
 
 static void
-dc390_DataOut_0( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus)
+dc390_DataOut_0(struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus)
 {
     u8   sstatus;
-    struct scatterlist *psgl;
-    u32    ResidCnt, xferCnt;
+    u32  ResidCnt;
     u8   dstate = 0;
 
     sstatus = *psstatus;
@@ -776,25 +796,20 @@ dc390_DataOut_0( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus)
 	    if( pSRB->SGIndex < pSRB->SGcount )
 	    {
 		pSRB->pSegmentList++;
-		psgl = pSRB->pSegmentList;
 
-		pSRB->SGBusAddr = sg_dma_address(psgl);
-		pSRB->SGToBeXferLen = sg_dma_len(psgl);
+		dc390_start_segment(pSRB);
 	    }
 	    else
 		pSRB->SGToBeXferLen = 0;
 	}
 	else
 	{
-	    ResidCnt  = (u32) DC390_read8 (Current_Fifo) & 0x1f;
-	    ResidCnt |= (u32) DC390_read8 (CtcReg_High) << 16;
-	    ResidCnt |= (u32) DC390_read8 (CtcReg_Mid) << 8; 
-	    ResidCnt += (u32) DC390_read8 (CtcReg_Low);
-
-	    xferCnt = pSRB->SGToBeXferLen - ResidCnt;
-	    pSRB->SGBusAddr += xferCnt;
-	    pSRB->TotalXferredLen += xferCnt;
-	    pSRB->SGToBeXferLen = ResidCnt;
+	    ResidCnt = ((u32) DC390_read8 (Current_Fifo) & 0x1f) +
+		    (((u32) DC390_read8 (CtcReg_High) << 16) |
+		     ((u32) DC390_read8 (CtcReg_Mid) << 8) |
+		     (u32) DC390_read8 (CtcReg_Low));
+
+	    dc390_advance_segment(pSRB, ResidCnt);
 	}
     }
     if ((*psstatus & 7) != SCSI_DATA_OUT)
@@ -805,13 +820,11 @@ dc390_DataOut_0( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus)
 }
 
 static void
-dc390_DataIn_0( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus)
+dc390_DataIn_0(struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus)
 {
     u8   sstatus, residual, bval;
-    struct scatterlist *psgl;
-    u32    ResidCnt, i;
+    u32  ResidCnt, i;
     unsigned long   xferCnt;
-    u8      *ptr;
 
     sstatus = *psstatus;
 
@@ -851,10 +864,8 @@ dc390_DataIn_0( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus)
 	    if( pSRB->SGIndex < pSRB->SGcount )
 	    {
 		pSRB->pSegmentList++;
-		psgl = pSRB->pSegmentList;
 
-		pSRB->SGBusAddr = sg_dma_address(psgl);
-		pSRB->SGToBeXferLen = sg_dma_len(psgl);
+		dc390_start_segment(pSRB);
 	    }
 	    else
 		pSRB->SGToBeXferLen = 0;
@@ -894,41 +905,38 @@ din_1:
 	    /* It seems a DMA Blast abort isn't that bad ... */
 	    if (!i) printk (KERN_ERR "DC390: DMA Blast aborted unfinished!\n");
 	    //DC390_write8 (DMA_Cmd, READ_DIRECTION+DMA_IDLE_CMD);
-	    dc390_laststatus &= ~0xff000000; dc390_laststatus |= bval << 24;
+	    dc390_laststatus &= ~0xff000000;
+	    dc390_laststatus |= bval << 24;
 
 	    DEBUG1(printk (KERN_DEBUG "Blast: Read %i times DMA_Status %02x", 0xa000-i, bval));
-	    ResidCnt = (u32) DC390_read8 (CtcReg_High);
-	    ResidCnt <<= 8;
-	    ResidCnt |= (u32) DC390_read8 (CtcReg_Mid);
-	    ResidCnt <<= 8;
-	    ResidCnt |= (u32) DC390_read8 (CtcReg_Low);
-
-	    xferCnt = pSRB->SGToBeXferLen - ResidCnt;
-	    pSRB->SGBusAddr += xferCnt;
-	    pSRB->TotalXferredLen += xferCnt;
-	    pSRB->SGToBeXferLen = ResidCnt;
-
-	    if( residual )
-	    {
-		static int feedback_requested;
+	    ResidCnt = (((u32) DC390_read8 (CtcReg_High) << 16) |
+			((u32) DC390_read8 (CtcReg_Mid) << 8)) |
+		    (u32) DC390_read8 (CtcReg_Low);
+
+	    xferCnt = dc390_advance_segment(pSRB, ResidCnt);
+
+	    if (residual) {
+		size_t count = 1;
+		size_t offset = pSRB->SGBusAddr - sg_dma_address(pSRB->pSegmentList);
+		unsigned long flags;
+		u8 *ptr;
+
 		bval = DC390_read8 (ScsiFifo);	    /* get one residual byte */
 
-		if (!feedback_requested) {
-			feedback_requested = 1;
-			printk(KERN_WARNING "%s: Please, contact <linux-scsi@vger.kernel.org> "
-			       "to help improve support for your system.\n", __FILE__);
+		local_irq_save(flags);
+		ptr = scsi_kmap_atomic_sg(pSRB->pSegmentList, pSRB->SGcount, &offset, &count);
+		if (likely(ptr)) {
+			*(ptr + offset) = bval;
+			scsi_kunmap_atomic_sg(ptr);
 		}
+		local_irq_restore(flags);
+		WARN_ON(!ptr);
 
-		ptr = (u8 *) bus_to_virt( pSRB->SGBusAddr );
-		*ptr = bval;
-		pSRB->SGBusAddr++;
-		xferCnt++;
-		pSRB->TotalXferredLen++;
-		pSRB->SGToBeXferLen--;
+		/* 1 more byte read */
+		xferCnt += dc390_advance_segment(pSRB, pSRB->SGToBeXferLen - 1);
 	    }
 	    DEBUG1(printk (KERN_DEBUG "Xfered: %lu, Total: %lu, Remaining: %lu\n", xferCnt,\
 			   pSRB->TotalXferredLen, pSRB->SGToBeXferLen));
-
 	}
     }
     if ((*psstatus & 7) != SCSI_DATA_IN)
@@ -1137,7 +1145,7 @@ dc390_MsgIn_set_sync (struct dc390_acb* pACB, struct dc390_srb* pSRB)
 
 
 /* handle RESTORE_PTR */
-/* I presume, this command is already mapped, so, have to remap. */
+/* This doesn't look very healthy... to-be-fixed */
 static void 
 dc390_restore_ptr (struct dc390_acb* pACB, struct dc390_srb* pSRB)
 {
@@ -1146,6 +1154,7 @@ dc390_restore_ptr (struct dc390_acb* pACB, struct dc390_srb* pSRB)
     pSRB->TotalXferredLen = 0;
     pSRB->SGIndex = 0;
     if (pcmd->use_sg) {
+	size_t saved;
 	pSRB->pSegmentList = (struct scatterlist *)pcmd->request_buffer;
 	psgl = pSRB->pSegmentList;
 	//dc390_pci_sync(pSRB);
@@ -1157,15 +1166,16 @@ dc390_restore_ptr (struct dc390_acb* pACB, struct dc390_srb* pSRB)
 	    if( pSRB->SGIndex < pSRB->SGcount )
 	    {
 		pSRB->pSegmentList++;
-		psgl = pSRB->pSegmentList;
-		pSRB->SGBusAddr = sg_dma_address(psgl);
-		pSRB->SGToBeXferLen = sg_dma_len(psgl);
+
+		dc390_start_segment(pSRB);
 	    }
 	    else
 		pSRB->SGToBeXferLen = 0;
 	}
-	pSRB->SGToBeXferLen -= pSRB->Saved_Ptr - pSRB->TotalXferredLen;
-	pSRB->SGBusAddr += pSRB->Saved_Ptr - pSRB->TotalXferredLen;
+
+	saved = pSRB->Saved_Ptr - pSRB->TotalXferredLen;
+	pSRB->SGToBeXferLen -= saved;
+	pSRB->SGBusAddr += saved;
 	printk (KERN_INFO "DC390: Pointer restored. Segment %i, Total %li, Bus %08lx\n",
 		pSRB->SGIndex, pSRB->Saved_Ptr, pSRB->SGBusAddr);
 
@@ -1286,7 +1296,6 @@ dc390_MsgIn_0( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus)
 static void
 dc390_DataIO_Comm( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 ioDir)
 {
-    struct scatterlist *psgl;
     unsigned long  lval;
     struct dc390_dcb*   pDCB = pACB->pActiveDCB;
 
@@ -1315,9 +1324,8 @@ dc390_DataIO_Comm( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 ioDir)
 	DC390_write8 (DMA_Cmd, DMA_IDLE_CMD | ioDir);
 	if( !pSRB->SGToBeXferLen )
 	{
-	    psgl = pSRB->pSegmentList;
-	    pSRB->SGBusAddr = sg_dma_address(psgl);
-	    pSRB->SGToBeXferLen = sg_dma_len(psgl);
+	    dc390_start_segment(pSRB);
+
 	    DEBUG1(printk (KERN_DEBUG " DC390: Next SG segment."));
 	}
 	lval = pSRB->SGToBeXferLen;
