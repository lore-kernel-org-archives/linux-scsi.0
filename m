From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 2/3] tmscsim: remove bogus endianness conversions
Date: Fri, 4 May 2007 22:59:40 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0705042257410.21060@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54237 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S376152AbXEDU7n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 May 2007 16:59:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

cpu_to_le32 endianness conversions in tmscsim.c, followed by
arithmetic operations don't look correct. Besides, {in,out}[wl]
already perform the necessary conversions. Further, bus addresses
of request buffers are guaranteed to be (mapped) under 4G by
current scsi- and block-layer defaults. This could be explicitly
enforced by using blk_queue_bounce_limit(), which, however,
doesn't seem to be the common practice among SCSI drivers.

Signed-off-by: G. Liakhovetski <g.liakhovetski@gmx.de>

diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index d0e171c..be869d0 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -778,8 +778,8 @@ dc390_DataOut_0( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus)
 		pSRB->pSegmentList++;
 		psgl = pSRB->pSegmentList;
 
-		pSRB->SGBusAddr = cpu_to_le32(pci_dma_lo32(sg_dma_address(psgl)));
-		pSRB->SGToBeXferLen = cpu_to_le32(sg_dma_len(psgl));
+		pSRB->SGBusAddr = sg_dma_address(psgl);
+		pSRB->SGToBeXferLen = sg_dma_len(psgl);
 	    }
 	    else
 		pSRB->SGToBeXferLen = 0;
@@ -842,7 +842,7 @@ dc390_DataIn_0( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus)
 	    DEBUG1(ResidCnt = ((unsigned long) DC390_read8 (CtcReg_High) << 16)	\
 		+ ((unsigned long) DC390_read8 (CtcReg_Mid) << 8)		\
 		+ ((unsigned long) DC390_read8 (CtcReg_Low)));
-	    DEBUG1(printk (KERN_DEBUG "Count_2_Zero (ResidCnt=%i,ToBeXfer=%li),", ResidCnt, pSRB->SGToBeXferLen));
+	    DEBUG1(printk (KERN_DEBUG "Count_2_Zero (ResidCnt=%u,ToBeXfer=%lu),", ResidCnt, pSRB->SGToBeXferLen));
 
 	    DC390_write8 (DMA_Cmd, READ_DIRECTION+DMA_IDLE_CMD);
 
@@ -853,8 +853,8 @@ dc390_DataIn_0( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus)
 		pSRB->pSegmentList++;
 		psgl = pSRB->pSegmentList;
 
-		pSRB->SGBusAddr = cpu_to_le32(pci_dma_lo32(sg_dma_address(psgl)));
-		pSRB->SGToBeXferLen = cpu_to_le32(sg_dma_len(psgl));
+		pSRB->SGBusAddr = sg_dma_address(psgl);
+		pSRB->SGToBeXferLen = sg_dma_len(psgl);
 	    }
 	    else
 		pSRB->SGToBeXferLen = 0;
@@ -921,11 +921,12 @@ din_1:
 
 		ptr = (u8 *) bus_to_virt( pSRB->SGBusAddr );
 		*ptr = bval;
-		pSRB->SGBusAddr++; xferCnt++;
+		pSRB->SGBusAddr++;
+		xferCnt++;
 		pSRB->TotalXferredLen++;
 		pSRB->SGToBeXferLen--;
 	    }
-	    DEBUG1(printk (KERN_DEBUG "Xfered: %li, Total: %li, Remaining: %li\n", xferCnt,\
+	    DEBUG1(printk (KERN_DEBUG "Xfered: %lu, Total: %lu, Remaining: %lu\n", xferCnt,\
 			   pSRB->TotalXferredLen, pSRB->SGToBeXferLen));
 
 	}
@@ -1157,14 +1158,14 @@ dc390_restore_ptr (struct dc390_acb* pACB, struct dc390_srb* pSRB)
 	    {
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
-	pSRB->SGToBeXferLen -= (pSRB->Saved_Ptr - pSRB->TotalXferredLen);
-	pSRB->SGBusAddr += (pSRB->Saved_Ptr - pSRB->TotalXferredLen);
+	pSRB->SGToBeXferLen -= pSRB->Saved_Ptr - pSRB->TotalXferredLen;
+	pSRB->SGBusAddr += pSRB->Saved_Ptr - pSRB->TotalXferredLen;
 	printk (KERN_INFO "DC390: Pointer restored. Segment %i, Total %li, Bus %08lx\n",
 		pSRB->SGIndex, pSRB->Saved_Ptr, pSRB->SGBusAddr);
 
@@ -1315,8 +1316,8 @@ dc390_DataIO_Comm( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 ioDir)
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
diff --git a/drivers/scsi/tmscsim.h b/drivers/scsi/tmscsim.h
index 9b66fa8..c3d8c80 100644
--- a/drivers/scsi/tmscsim.h
+++ b/drivers/scsi/tmscsim.h
@@ -19,14 +19,6 @@
 
 #define SEL_TIMEOUT		153	/* 250 ms selection timeout (@ 40 MHz) */
 
-#define pci_dma_lo32(a)			(a & 0xffffffff)
-
-typedef u8		UCHAR;	/*  8 bits */
-typedef u16		USHORT;	/* 16 bits */
-typedef u32		UINT;	/* 32 bits */
-typedef unsigned long	ULONG;	/* 32/64 bits */
-
-
 /*
 ;-----------------------------------------------------------------------
 ; SCSI Request Block
@@ -43,7 +35,9 @@ struct scatterlist	*pSegmentList;
 
 struct scatterlist Segmentx;	/* make a one entry of S/G list table */
 
-unsigned long	SGBusAddr;	/*;a segment starting address as seen by AM53C974A*/
+unsigned long	SGBusAddr;	/*;a segment starting address as seen by AM53C974A
+				  in CPU endianness. We're only getting 32-bit bus
+				  addresses by default */
 unsigned long	SGToBeXferLen;	/*; to be xfer length */
 unsigned long	TotalXferredLen;
 unsigned long	SavedTotXLen;
