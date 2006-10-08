From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH] tmscsim: clean up endianness
Date: Sun, 8 Oct 2006 22:24:02 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0610082208090.20132@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:61350 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1751440AbWJHUXp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Oct 2006 16:23:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@steeleye.com>

Hi

The patch below removes endianness confusion from tmscsim. Don't think it 
was ever correct and ever worked on big endian?

Thanks
Guennadi
---
Guennadi Liakhovetski

diff -u a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
--- a/drivers/scsi/tmscsim.c	2006-10-02 00:48:52.000000000 +0200
+++ b/drivers/scsi/tmscsim.c	2006-10-04 22:27:18.000000000 +0200
@@ -859,8 +859,8 @@
 		pSRB->pSegmentList++;
 		psgl = pSRB->pSegmentList;
 
-		pSRB->SGBusAddr = cpu_to_le32(pci_dma_lo32(sg_dma_address(psgl)));
-		pSRB->SGToBeXferLen = cpu_to_le32(sg_dma_len(psgl));
+		pSRB->SGBusAddr = sg_dma_address(psgl);
+		pSRB->SGToBeXferLen = sg_dma_len(psgl);
 	    }
 	    else
 		pSRB->SGToBeXferLen = 0;
@@ -934,8 +934,8 @@
 		pSRB->pSegmentList++;
 		psgl = pSRB->pSegmentList;
 
-		pSRB->SGBusAddr = cpu_to_le32(pci_dma_lo32(sg_dma_address(psgl)));
-		pSRB->SGToBeXferLen = cpu_to_le32(sg_dma_len(psgl));
+		pSRB->SGBusAddr = sg_dma_address(psgl);
+		pSRB->SGToBeXferLen = sg_dma_len(psgl);
 	    }
 	    else
 		pSRB->SGToBeXferLen = 0;
@@ -1238,14 +1238,14 @@
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
 
@@ -1396,8 +1396,8 @@
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
diff -u a/drivers/scsi/tmscsim.h b/drivers/scsi/tmscsim.h
--- a/drivers/scsi/tmscsim.h	13 Jan 2005 21:10:01 -0000
+++ b/drivers/scsi/tmscsim.h	8 Oct 2006 19:56:01 -0000
@@ -20,8 +20,6 @@
 
 #define SEL_TIMEOUT		153	/* 250 ms selection timeout (@ 40 MHz) */
 
-#define pci_dma_lo32(a)			(a & 0xffffffff)
-
 typedef u8		UCHAR;	/*  8 bits */
 typedef u16		USHORT;	/* 16 bits */
 typedef u32		UINT;	/* 32 bits */
@@ -44,7 +42,7 @@
 
 struct scatterlist Segmentx;	/* make a one entry of S/G list table */
 
-unsigned long	SGBusAddr;	/*;a segment starting address as seen by AM53C974A*/
+dma_addr_t	SGBusAddr;	/*;a segment starting address as seen by AM53C974A*/
 unsigned long	SGToBeXferLen;	/*; to be xfer length */
 unsigned long	TotalXferredLen;
 unsigned long	SavedTotXLen;
