From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 1/3] remove long dead DMA_INT
Date: Fri, 4 May 2007 22:57:37 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0705042255150.21060@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33946 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S376144AbXEDU5l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 May 2007 16:57:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

DMA_INT code is disabled since 1998, remove it to prepare
for further cleanup.

Signed-off-by: G. Liakhovetski <g.liakhovetski@gmx.de>

diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index a583e89..d0e171c 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -625,70 +625,6 @@ dc390_StartSCSI( struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_sr
     return 0;
 }
 
-//#define DMA_INT EN_DMA_INT /*| EN_PAGE_INT*/
-#define DMA_INT 0
-
-#if DMA_INT
-/* This is similar to AM53C974.c ... */
-static u8 
-dc390_dma_intr (struct dc390_acb* pACB)
-{
-  struct dc390_srb* pSRB;
-  u8 dstate;
-  DEBUG0(u16 pstate; struct pci_dev *pdev = pACB->pdev);
-  
-  DEBUG0(pci_read_config_word(pdev, PCI_STATUS, &pstate));
-  DEBUG0(if (pstate & (PCI_STATUS_SIG_SYSTEM_ERROR | PCI_STATUS_DETECTED_PARITY))\
-	{ printk(KERN_WARNING "DC390: PCI state = %04x!\n", pstate); \
-	  pci_write_config_word(pdev, PCI_STATUS, (PCI_STATUS_SIG_SYSTEM_ERROR | PCI_STATUS_DETECTED_PARITY));});
-
-  dstate = DC390_read8 (DMA_Status); 
-
-  if (! pACB->pActiveDCB || ! pACB->pActiveDCB->pActiveSRB) return dstate;
-  else pSRB  = pACB->pActiveDCB->pActiveSRB;
-  
-  if (dstate & (DMA_XFER_ABORT | DMA_XFER_ERROR | POWER_DOWN | PCI_MS_ABORT))
-    {
-	printk (KERN_ERR "DC390: DMA error (%02x)!\n", dstate);
-	return dstate;
-    }
-  if (dstate & DMA_XFER_DONE)
-    {
-	u32 residual, xferCnt; int ctr = 6000000;
-	if (! (DC390_read8 (DMA_Cmd) & READ_DIRECTION))
-	  {
-	    do
-	      {
-		DEBUG1(printk (KERN_DEBUG "DC390: read residual bytes ... \n"));
-		dstate = DC390_read8 (DMA_Status);
-		residual = DC390_read8 (CtcReg_Low) | DC390_read8 (CtcReg_Mid) << 8 |
-		  DC390_read8 (CtcReg_High) << 16;
-		residual += DC390_read8 (Current_Fifo) & 0x1f;
-	      } while (residual && ! (dstate & SCSI_INTERRUPT) && --ctr);
-	    if (!ctr) printk (KERN_CRIT "DC390: dma_intr: DMA aborted unfinished: %06x bytes remain!!\n", DC390_read32 (DMA_Wk_ByteCntr));
-	    /* residual =  ... */
-	  }
-	else
-	    residual = 0;
-	
-	/* ??? */
-	
-	xferCnt = pSRB->SGToBeXferLen - residual;
-	pSRB->SGBusAddr += xferCnt;
-	pSRB->TotalXferredLen += xferCnt;
-	pSRB->SGToBeXferLen = residual;
-# ifdef DC390_DEBUG0
-	printk (KERN_INFO "DC390: DMA: residual = %i, xfer = %i\n", 
-		(unsigned int)residual, (unsigned int)xferCnt);
-# endif
-	
-	DC390_write8 (DMA_Cmd, DMA_IDLE_CMD);
-    }
-  dc390_laststatus &= ~0xff000000; dc390_laststatus |= dstate << 24;
-  return dstate;
-}
-#endif
-
 
 static void __inline__
 dc390_InvalidCmd(struct dc390_acb* pACB)
@@ -708,9 +644,6 @@ DC390_Interrupt(void *dev_id)
     u8  phase;
     void   (*stateV)( struct dc390_acb*, struct dc390_srb*, u8 *);
     u8  istate, istatus;
-#if DMA_INT
-    u8  dstatus;
-#endif
 
     sstatus = DC390_read8 (Scsi_Status);
     if( !(sstatus & INTERRUPT) )
@@ -718,22 +651,9 @@ DC390_Interrupt(void *dev_id)
 
     DEBUG1(printk (KERN_DEBUG "sstatus=%02x,", sstatus));
 
-#if DMA_INT
-    spin_lock_irq(pACB->pScsiHost->host_lock);
-    dstatus = dc390_dma_intr (pACB);
-    spin_unlock_irq(pACB->pScsiHost->host_lock);
-
-    DEBUG1(printk (KERN_DEBUG "dstatus=%02x,", dstatus));
-    if (! (dstatus & SCSI_INTERRUPT))
-      {
-	DEBUG0(printk (KERN_WARNING "DC390 Int w/o SCSI actions (only DMA?)\n"));
-	return IRQ_NONE;
-      }
-#else
     //DC390_write32 (DMA_ScsiBusCtrl, WRT_ERASE_DMA_STAT | EN_INT_ON_PCI_ABORT);
     //dstatus = DC390_read8 (DMA_Status);
     //DC390_write32 (DMA_ScsiBusCtrl, EN_INT_ON_PCI_ABORT);
-#endif
 
     spin_lock_irq(pACB->pScsiHost->host_lock);
 
@@ -879,7 +799,7 @@ dc390_DataOut_0( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus)
     }
     if ((*psstatus & 7) != SCSI_DATA_OUT)
     {
-	    DC390_write8 (DMA_Cmd, WRITE_DIRECTION+DMA_IDLE_CMD); /* | DMA_INT */
+	    DC390_write8 (DMA_Cmd, WRITE_DIRECTION+DMA_IDLE_CMD);
 	    DC390_write8 (ScsiCmd, CLEAR_FIFO_CMD);
     }	    
 }
@@ -924,7 +844,7 @@ dc390_DataIn_0( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus)
 		+ ((unsigned long) DC390_read8 (CtcReg_Low)));
 	    DEBUG1(printk (KERN_DEBUG "Count_2_Zero (ResidCnt=%i,ToBeXfer=%li),", ResidCnt, pSRB->SGToBeXferLen));
 
-	    DC390_write8 (DMA_Cmd, READ_DIRECTION+DMA_IDLE_CMD); /* | DMA_INT */
+	    DC390_write8 (DMA_Cmd, READ_DIRECTION+DMA_IDLE_CMD);
 
 	    pSRB->TotalXferredLen += pSRB->SGToBeXferLen;
 	    pSRB->SGIndex++;
@@ -973,7 +893,7 @@ din_1:
 	    }
 	    /* It seems a DMA Blast abort isn't that bad ... */
 	    if (!i) printk (KERN_ERR "DC390: DMA Blast aborted unfinished!\n");
-	    //DC390_write8 (DMA_Cmd, READ_DIRECTION+DMA_IDLE_CMD); /* | DMA_INT */
+	    //DC390_write8 (DMA_Cmd, READ_DIRECTION+DMA_IDLE_CMD);
 	    dc390_laststatus &= ~0xff000000; dc390_laststatus |= bval << 24;
 
 	    DEBUG1(printk (KERN_DEBUG "Blast: Read %i times DMA_Status %02x", 0xa000-i, bval));
@@ -1013,7 +933,7 @@ din_1:
     if ((*psstatus & 7) != SCSI_DATA_IN)
     {
 	    DC390_write8 (ScsiCmd, CLEAR_FIFO_CMD);
-	    DC390_write8 (DMA_Cmd, READ_DIRECTION+DMA_IDLE_CMD); /* | DMA_INT */
+	    DC390_write8 (DMA_Cmd, READ_DIRECTION+DMA_IDLE_CMD);
     }
 }
 
@@ -1391,7 +1311,7 @@ dc390_DataIO_Comm( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 ioDir)
 
     if( pSRB->SGIndex < pSRB->SGcount )
     {
-	DC390_write8 (DMA_Cmd, DMA_IDLE_CMD | ioDir /* | DMA_INT */);
+	DC390_write8 (DMA_Cmd, DMA_IDLE_CMD | ioDir);
 	if( !pSRB->SGToBeXferLen )
 	{
 	    psgl = pSRB->pSegmentList;
@@ -1410,12 +1330,12 @@ dc390_DataIO_Comm( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 ioDir)
 	DC390_write32 (DMA_XferCnt, pSRB->SGToBeXferLen);
 	DC390_write32 (DMA_XferAddr, pSRB->SGBusAddr);
 
-	//DC390_write8 (DMA_Cmd, DMA_IDLE_CMD | ioDir); /* | DMA_INT; */
+	//DC390_write8 (DMA_Cmd, DMA_IDLE_CMD | ioDir);
 	pSRB->SRBState = SRB_DATA_XFER;
 
 	DC390_write8 (ScsiCmd, DMA_COMMAND+INFO_XFER_CMD);
 
-	DC390_write8 (DMA_Cmd, DMA_START_CMD | ioDir | DMA_INT);
+	DC390_write8 (DMA_Cmd, DMA_START_CMD | ioDir);
 	//DEBUG1(DC390_write32 (DMA_ScsiBusCtrl, WRT_ERASE_DMA_STAT | EN_INT_ON_PCI_ABORT));
 	//DEBUG1(printk (KERN_DEBUG "DC390: DMA_Status: %02x\n", DC390_read8 (DMA_Status)));
 	//DEBUG1(DC390_write32 (DMA_ScsiBusCtrl, EN_INT_ON_PCI_ABORT));
@@ -1436,8 +1356,8 @@ dc390_DataIO_Comm( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 ioDir)
 	pSRB->SRBState |= SRB_XFERPAD;
 	DC390_write8 (ScsiCmd, DMA_COMMAND+XFER_PAD_BYTE);
 /*
-	DC390_write8 (DMA_Cmd, DMA_IDLE_CMD | ioDir); // | DMA_INT;
-	DC390_write8 (DMA_Cmd, DMA_START_CMD | ioDir | DMA_INT);
+	DC390_write8 (DMA_Cmd, DMA_IDLE_CMD | ioDir);
+	DC390_write8 (DMA_Cmd, DMA_START_CMD | ioDir);
 */
     }
 }
