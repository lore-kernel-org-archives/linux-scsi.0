From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: TMSCSIM [2.6] (was: Re: [PATCH] Re: AMD 53c974 SCSI driver in
 2.6)
Date: Sun, 23 Nov 2003 00:27:32 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0311230024300.1354-100000@poirot.grange>
References: <Pine.LNX.4.44.0311202354360.2876-100000@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.gmx.net ([213.165.64.20]:19667 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S262940AbTKVX3I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Nov 2003 18:29:08 -0500
Received: from lyakh (helo=localhost)
	by poirot.grange with local-esmtp (Exim 3.35 #1 (Debian))
	id 1ANhA4-0001gp-00
	for <linux-scsi@vger.kernel.org>; Sun, 23 Nov 2003 00:27:32 +0100
In-Reply-To: <Pine.LNX.4.44.0311202354360.2876-100000@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The appended patch is an attempt to fix the tmscsim driver for 2.6. Tested
only on an on-board AM53C974 controller so far.

Thanks
Guennadi
---
Guennadi Liakhovetski

diff -ur linux-2.6.0-test7.arm/drivers/scsi/dc390.h linux-2.6.0-test7/drivers/scsi/dc390.h
--- linux-2.6.0-test7.arm/drivers/scsi/dc390.h	Sat Aug  9 06:33:17 2003
+++ linux-2.6.0-test7/drivers/scsi/dc390.h	Thu Nov 13 21:41:12 2003
@@ -36,14 +36,10 @@
 extern int DC390_detect(Scsi_Host_Template *psht);
 extern int DC390_queue_command(Scsi_Cmnd *cmd, void (*done)(Scsi_Cmnd *));
 extern int DC390_abort(Scsi_Cmnd *cmd);
-extern int DC390_reset(Scsi_Cmnd *cmd, unsigned int resetFlags);
+extern int DC390_reset(Scsi_Cmnd *cmd);
 extern int DC390_bios_param(struct scsi_device *sdev, struct block_device *dev,
 		sector_t capacity, int geom[]);

-#ifdef MODULE
 static int DC390_release(struct Scsi_Host *);
-#else
-# define DC390_release NULL
-#endif

 #endif /* DC390_H */
diff -ur linux-2.6.0-test7.arm/drivers/scsi/scsiiom.c linux-2.6.0-test7/drivers/scsi/scsiiom.c
--- linux-2.6.0-test7.arm/drivers/scsi/scsiiom.c	Sat Aug  9 06:31:55 2003
+++ linux-2.6.0-test7/drivers/scsi/scsiiom.c	Sat Nov 22 23:54:15 2003
@@ -5,9 +5,6 @@
  *		     Bus Master Host Adapter			       *
  ***********************************************************************/
 /* $Id: scsiiom.c,v 2.55.2.17 2000/12/20 00:39:37 garloff Exp $ */
-
-#error Please convert me to Documentation/DMA-mapping.txt
-
 static void __inline__
 dc390_freetag (PDCB pDCB, PSRB pSRB)
 {
@@ -36,9 +33,12 @@
     }
     if (time_before (jiffies, pACB->pScsiHost->last_reset))
     {
-	DEBUG0(printk ("DC390: We were just reset and don't accept commands yet!\n");)
+	DEBUG0(printk ("DC390: We were just reset and don't accept commands yet!\n"));
 	return 1;
     }
+    /* KG: Moved pci mapping here */
+    dc390_pci_map(pSRB);
+    /* TODO: error handling */
     DC390_write8 (Scsi_Dest_ID, pDCB->TargetID);
     DC390_write8 (Sync_Period, pDCB->SyncPeriod);
     DC390_write8 (Sync_Offset, pDCB->SyncOffset);
@@ -47,8 +47,9 @@
     DC390_write8 (CtrlReg4, pDCB->CtrlR4);
     DC390_write8 (ScsiCmd, CLEAR_FIFO_CMD);		/* Flush FIFO */
     DEBUG1(printk (KERN_INFO "DC390: Start SCSI command: %02x (Sync:%02x)\n",\
-	    pSRB->pcmd->cmnd[0], pDCB->SyncMode);)
-    disc_allowed = pDCB->DevMode & EN_DISCONNECT_; try_sync_nego = 0;
+	    pSRB->pcmd->cmnd[0], pDCB->SyncMode));
+    disc_allowed = pDCB->DevMode & EN_DISCONNECT_;
+    try_sync_nego = 0;
     /* Don't disconnect on AUTO_REQSENSE, cause it might be an
      * Contingent Allegiance Condition (6.6), where no tags should be used.
      * All other have to be allowed to disconnect to prevent Incorrect
@@ -78,13 +79,13 @@
 	DC390_write8 (ScsiFifo, SIMPLE_QUEUE_TAG);
 	pDCB->TagMask |= (1 << tag_no); pSRB->TagNumber = tag_no;
 	DC390_write8 (ScsiFifo, tag_no);
-	DEBUG1(printk (KERN_DEBUG "DC390: Select w/DisCn for Cmd %li (SRB %p), Using Tag %02x\n", pSRB->pcmd->pid, pSRB, tag_no);)
+	DEBUG1(printk (KERN_DEBUG "DC390: Select w/DisCn for Cmd %li (SRB %p), Using Tag %02x\n", pSRB->pcmd->pid, pSRB, tag_no));
 	cmd = SEL_W_ATN3;
       }
     else	/* No TagQ */
       {
 //      no_tag:
-	DEBUG1(printk (KERN_DEBUG "DC390: Select w%s/DisCn for Cmd %li (SRB %p), No TagQ\n", (disc_allowed?"":"o"), pSRB->pcmd->pid, pSRB);)
+	DEBUG1(printk (KERN_DEBUG "DC390: Select w%s/DisCn for Cmd %li (SRB %p), No TagQ\n", (disc_allowed?"":"o"), pSRB->pcmd->pid, pSRB));
       };

     pSRB->SRBState = SRB_START_;
@@ -92,7 +93,7 @@
     if (try_sync_nego)
       {
 	UCHAR Sync_Off = pDCB->SyncOffset;
-        DEBUG0(printk (KERN_INFO "DC390: NEW Sync Nego code triggered (%i %i)\n", pDCB->TargetID, pDCB->TargetLUN);)
+        DEBUG0(printk (KERN_INFO "DC390: NEW Sync Nego code triggered (%i %i)\n", pDCB->TargetID, pDCB->TargetLUN));
 	pSRB->MsgOutBuf[0] = EXTENDED_MESSAGE;
 	pSRB->MsgOutBuf[1] = 3;
 	pSRB->MsgOutBuf[2] = EXTENDED_SDTR;
@@ -116,7 +117,7 @@
 	    DC390_write8 (ScsiFifo, 0);
 	    DC390_write8 (ScsiFifo, sizeof(pSRB->pcmd->sense_buffer));
 	    DC390_write8 (ScsiFifo, 0);
-	    DEBUG1(printk (KERN_DEBUG "DC390: AutoReqSense !\n");)
+	    DEBUG1(printk (KERN_DEBUG "DC390: AutoReqSense !\n"));
 	  }
 	else	/* write cmnd to bus */
 	  {
@@ -127,15 +128,15 @@
 	  };
       }
     DEBUG0(if (pACB->pActiveDCB)	\
-	   printk (KERN_WARNING "DC390: ActiveDCB != 0\n");)
+	   printk (KERN_WARNING "DC390: ActiveDCB != 0\n"));
     DEBUG0(if (pDCB->pActiveSRB)	\
-	   printk (KERN_WARNING "DC390: ActiveSRB != 0\n");)
+	   printk (KERN_WARNING "DC390: ActiveSRB != 0\n"));
     //DC390_write8 (DMA_Cmd, DMA_IDLE_CMD);
     if (DC390_read8 (Scsi_Status) & INTERRUPT)
     {
 	dc390_freetag (pDCB, pSRB);
 	DEBUG0(printk ("DC390: Interrupt during Start SCSI (pid %li, target %02i-%02i)\n",
-		pSRB->pcmd->pid, pSRB->pcmd->target, pSRB->pcmd->lun);)
+		pSRB->pcmd->pid, pSRB->pcmd->device->id, pSRB->pcmd->device->lun));
 	pSRB->SRBState = SRB_READY;
 	//DC390_write8 (ScsiCmd, CLEAR_FIFO_CMD);
 	pACB->SelLost++;
@@ -158,13 +159,13 @@
 {
   PSRB pSRB;
   UCHAR dstate;
-  DEBUG0(USHORT pstate;PDEVDECL1;)
+  DEBUG0(USHORT pstate;PDEVDECL1);

-  DEBUG0(PDEVSET1;)
-  DEBUG0(PCI_READ_CONFIG_WORD (PDEV, PCI_STATUS, &pstate);)
+  DEBUG0(PDEVSET1);
+  DEBUG0(PCI_READ_CONFIG_WORD (PDEV, PCI_STATUS, &pstate));
   DEBUG0(if (pstate & (PCI_STATUS_SIG_SYSTEM_ERROR | PCI_STATUS_DETECTED_PARITY))\
 	{ printk(KERN_WARNING "DC390: PCI state = %04x!\n", pstate); \
-	  PCI_WRITE_CONFIG_WORD (PDEV, PCI_STATUS, (PCI_STATUS_SIG_SYSTEM_ERROR | PCI_STATUS_DETECTED_PARITY));};)
+	  PCI_WRITE_CONFIG_WORD (PDEV, PCI_STATUS, (PCI_STATUS_SIG_SYSTEM_ERROR | PCI_STATUS_DETECTED_PARITY));});

   dstate = DC390_read8 (DMA_Status);

@@ -183,7 +184,7 @@
 	  {
 	    do
 	      {
-		DEBUG1(printk (KERN_DEBUG "DC390: read residual bytes ... \n");)
+		DEBUG1(printk (KERN_DEBUG "DC390: read residual bytes ... \n"));
 		dstate = DC390_read8 (DMA_Status);
 		residual = DC390_read8 (CtcReg_Low) | DC390_read8 (CtcReg_Mid) << 8 |
 		  DC390_read8 (CtcReg_High) << 16;
@@ -210,10 +211,10 @@
     }
   dc390_laststatus &= ~0xff000000; dc390_laststatus |= dstate << 24;
   return dstate;
-};
+}
 #endif

-void __inline__
+static irqreturn_t __inline__
 DC390_Interrupt( int irq, void *dev_id, struct pt_regs *regs)
 {
     PACB   pACB, pACB2;
@@ -226,37 +227,37 @@
 #if DMA_INT
     UCHAR  dstatus;
 #endif
-    DC390_AFLAGS DC390_IFLAGS //DC390_DFLAGS
+    DC390_AFLAGS DC390_IFLAGS; //DC390_DFLAGS

     pACB = (PACB)dev_id;
     for (pACB2 = dc390_pACB_start; (pACB2 && pACB2 != pACB); pACB2 = pACB2->pNextACB);
     if (!pACB2)
     {
 	printk ("DC390: IRQ called with foreign dev_id %p!\n", pACB);
-	return;
+	return IRQ_NONE;
     }

     //DC390_LOCK_DRV;

     sstatus = DC390_read8 (Scsi_Status);
     if( !(sstatus & INTERRUPT) )
-	{ /*DC390_UNLOCK_DRV;*/ return; };
+	{ /*DC390_UNLOCK_DRV;*/ return IRQ_NONE; };

-    DEBUG1(printk (KERN_DEBUG "sstatus=%02x,", sstatus);)
+    DEBUG1(printk (KERN_DEBUG "sstatus=%02x,", sstatus));

 #if DMA_INT
-    DC390_LOCK_IO;
+    DC390_LOCK_IO(pACB->pScsiHost);
     DC390_LOCK_ACB;
     dstatus = dc390_dma_intr (pACB);
     DC390_UNLOCK_ACB;
-    DC390_UNLOCK_IO;
+    DC390_UNLOCK_IO(pACB->pScsiHost);

-    DEBUG1(printk (KERN_DEBUG "dstatus=%02x,", dstatus);)
+    DEBUG1(printk (KERN_DEBUG "dstatus=%02x,", dstatus));
     if (! (dstatus & SCSI_INTERRUPT))
       {
-	DEBUG0(printk (KERN_WARNING "DC390 Int w/o SCSI actions (only DMA?)\n");)
+	DEBUG0(printk (KERN_WARNING "DC390 Int w/o SCSI actions (only DMA?)\n"));
 	//DC390_UNLOCK_DRV;
-	return;
+	return IRQ_NONE;
       };
 #else
     //DC390_write32 (DMA_ScsiBusCtrl, WRT_ERASE_DMA_STAT | EN_INT_ON_PCI_ABORT);
@@ -264,14 +265,14 @@
     //DC390_write32 (DMA_ScsiBusCtrl, EN_INT_ON_PCI_ABORT);
 #endif

-    DC390_LOCK_IO;
+    DC390_LOCK_IO(pACB->pScsiHost);
     DC390_LOCK_ACB;
     //DC390_UNLOCK_DRV_NI; /* Allow _other_ CPUs to process IRQ (useful for shared IRQs) */

     istate = DC390_read8 (Intern_State);
     istatus = DC390_read8 (INT_Status); /* This clears Scsi_Status, Intern_State and INT_Status ! */

-    DEBUG1(printk (KERN_INFO "Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=%02x,",istatus);)
+    DEBUG1(printk (KERN_INFO "Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=%02x,",istatus));
     dc390_laststatus &= ~0x00ffffff;
     dc390_laststatus |= /* dstatus<<24 | */ sstatus<<16 | istate<<8 | istatus;

@@ -325,13 +326,13 @@
 	  dc390_EnableMsgOut_Abort (pACB, pSRB);

 	phase = pSRB->ScsiPhase;
-	DEBUG1(printk (KERN_INFO "DC390: [%i]%s(0) (%02x)\n", phase, dc390_p0_str[phase], sstatus);)
+	DEBUG1(printk (KERN_INFO "DC390: [%i]%s(0) (%02x)\n", phase, dc390_p0_str[phase], sstatus));
 	stateV = (void *) dc390_phase0[phase];
 	( *stateV )( pACB, pSRB, &sstatus );

 	pSRB->ScsiPhase = sstatus & 7;
 	phase = (UCHAR) sstatus & 7;
-	DEBUG1(printk (KERN_INFO "DC390: [%i]%s(1) (%02x)\n", phase, dc390_p1_str[phase], sstatus);)
+	DEBUG1(printk (KERN_INFO "DC390: [%i]%s(1) (%02x)\n", phase, dc390_p1_str[phase], sstatus));
 	stateV = (void *) dc390_phase1[phase];
 	( *stateV )( pACB, pSRB, &sstatus );
 	goto unlock;
@@ -340,17 +341,19 @@
  unlock:
     //DC390_LOCK_DRV_NI;
     DC390_UNLOCK_ACB;
-    DC390_UNLOCK_IO;
+    DC390_UNLOCK_IO(pACB->pScsiHost);
     //DC390_UNLOCK_DRV; /* Restore initial flags */
+    return IRQ_HANDLED;
 }

-void
-do_DC390_Interrupt( int irq, void *dev_id, struct pt_regs *regs)
+irqreturn_t do_DC390_Interrupt( int irq, void *dev_id, struct pt_regs *regs)
 {
-    DEBUG1(printk (KERN_INFO "DC390: Irq (%i) caught: ", irq);)
+    irqreturn_t ret;
+    DEBUG1(printk (KERN_INFO "DC390: Irq (%i) caught: ", irq));
     /* Locking is done in DC390_Interrupt */
-    DC390_Interrupt(irq, dev_id, regs);
-    DEBUG1(printk (".. IRQ returned\n");)
+    ret = DC390_Interrupt(irq, dev_id, regs);
+    DEBUG1(printk (".. IRQ returned\n"));
+    return ret;
 }

 void
@@ -381,8 +384,8 @@
 		pSRB->pSegmentList++;
 		psgl = pSRB->pSegmentList;

-		pSRB->SGBusAddr = virt_to_bus( psgl->address );
-		pSRB->SGToBeXferLen = (ULONG) psgl->length;
+		pSRB->SGBusAddr = cpu_to_le32(pci_dma_lo32(sg_dma_address(psgl)));
+		pSRB->SGToBeXferLen = cpu_to_le32(sg_dma_len(psgl));
 	    }
 	    else
 		pSRB->SGToBeXferLen = 0;
@@ -433,8 +436,8 @@
 	    dc390_laststatus &= ~0xff000000; dc390_laststatus |= dstate << 24;
 	    DEBUG1(ResidCnt = ((ULONG) DC390_read8 (CtcReg_High) << 16)	\
 		+ ((ULONG) DC390_read8 (CtcReg_Mid) << 8)		\
-		+ ((ULONG) DC390_read8 (CtcReg_Low));)
-	    DEBUG1(printk (KERN_DEBUG "Count_2_Zero (ResidCnt=%i,ToBeXfer=%li),", ResidCnt, pSRB->SGToBeXferLen);)
+		+ ((ULONG) DC390_read8 (CtcReg_Low)));
+	    DEBUG1(printk (KERN_DEBUG "Count_2_Zero (ResidCnt=%i,ToBeXfer=%li),", ResidCnt, pSRB->SGToBeXferLen));

 	    DC390_write8 (DMA_Cmd, READ_DIRECTION+DMA_IDLE_CMD); /* | DMA_INT */

@@ -445,8 +448,8 @@
 		pSRB->pSegmentList++;
 		psgl = pSRB->pSegmentList;

-		pSRB->SGBusAddr = virt_to_bus( psgl->address );
-		pSRB->SGToBeXferLen = (ULONG) psgl->length;
+		pSRB->SGBusAddr = cpu_to_le32(pci_dma_lo32(sg_dma_address(psgl)));
+		pSRB->SGToBeXferLen = cpu_to_le32(sg_dma_len(psgl));
 	    }
 	    else
 		pSRB->SGToBeXferLen = 0;
@@ -457,7 +460,7 @@
 	    bval = DC390_read8 (Current_Fifo);
 	    while( bval & 0x1f )
 	    {
-		DEBUG1(printk (KERN_DEBUG "Check for residuals,");)
+		DEBUG1(printk (KERN_DEBUG "Check for residuals,"));
 		if( (bval & 0x1f) == 1 )
 		{
 		    for(i=0; i < 0x100; i++)
@@ -488,7 +491,7 @@
 	    //DC390_write8 (DMA_Cmd, READ_DIRECTION+DMA_IDLE_CMD); /* | DMA_INT */
 	    dc390_laststatus &= ~0xff000000; dc390_laststatus |= bval << 24;

-	    DEBUG1(printk (KERN_DEBUG "Blast: Read %i times DMA_Status %02x", 0xa000-i, bval);)
+	    DEBUG1(printk (KERN_DEBUG "Blast: Read %i times DMA_Status %02x", 0xa000-i, bval));
 	    ResidCnt = (UINT) DC390_read8 (CtcReg_High);
 	    ResidCnt <<= 8;
 	    ResidCnt |= (UINT) DC390_read8 (CtcReg_Mid);
@@ -510,7 +513,7 @@
 		pSRB->SGToBeXferLen--;
 	    }
 	    DEBUG1(printk (KERN_DEBUG "Xfered: %li, Total: %li, Remaining: %li\n", xferCnt,\
-			   pSRB->TotalXferredLen, pSRB->SGToBeXferLen);)
+			   pSRB->TotalXferredLen, pSRB->SGToBeXferLen));

 	}
     }
@@ -579,7 +582,7 @@
 {
   pSRB->MsgOutBuf[0] = MESSAGE_REJECT;
   pSRB->MsgCnt = 1; DC390_ENABLE_MSGOUT;
-  DEBUG0 (printk (KERN_INFO "DC390: Reject message\n");)
+  DEBUG0 (printk (KERN_INFO "DC390: Reject message\n"));
 }

 /* abort command */
@@ -724,57 +727,55 @@


 /* handle RESTORE_PTR */
+/* I presume, this command is already mapped, so, have to remap. */
 static void
 dc390_restore_ptr (PACB pACB, PSRB pSRB)
 {
-  PSGL psgl;
-  pSRB->TotalXferredLen = 0;
-  pSRB->SGIndex = 0;
-  if( pSRB->pcmd->use_sg )
-    {
-      pSRB->SGcount = (UCHAR) pSRB->pcmd->use_sg;
-      pSRB->pSegmentList = (PSGL) pSRB->pcmd->request_buffer;
-      psgl = pSRB->pSegmentList;
-      while (pSRB->TotalXferredLen + (ULONG) psgl->length < pSRB->Saved_Ptr)
-	{
-	  pSRB->TotalXferredLen += (ULONG) psgl->length;
-	  pSRB->SGIndex++;
-	  if( pSRB->SGIndex < pSRB->SGcount )
+    Scsi_Cmnd* pcmd = pSRB->pcmd;
+    PSGL psgl;
+    pSRB->TotalXferredLen = 0;
+    pSRB->SGIndex = 0;
+    if (pcmd->use_sg) {
+	pSRB->pSegmentList = (PSGL) pcmd->request_buffer;
+	psgl = pSRB->pSegmentList;
+	//dc390_pci_sync(pSRB);
+
+	while (pSRB->TotalXferredLen + (ULONG) psgl->length < pSRB->Saved_Ptr)
+	{
+	    pSRB->TotalXferredLen += (ULONG) psgl->length;
+	    pSRB->SGIndex++;
+	    if( pSRB->SGIndex < pSRB->SGcount )
 	    {
-	      pSRB->pSegmentList++;
-	      psgl = pSRB->pSegmentList;
-
-	      pSRB->SGBusAddr = virt_to_bus( psgl->address );
-	      pSRB->SGToBeXferLen = (ULONG) psgl->length;
+		pSRB->pSegmentList++;
+		psgl = pSRB->pSegmentList;
+		pSRB->SGBusAddr = cpu_to_le32(pci_dma_lo32(sg_dma_address(psgl)));
+		pSRB->SGToBeXferLen = cpu_to_le32(sg_dma_len(psgl));
 	    }
-	  else
-	    pSRB->SGToBeXferLen = 0;
+	    else
+		pSRB->SGToBeXferLen = 0;
 	}
-      pSRB->SGToBeXferLen -= (pSRB->Saved_Ptr - pSRB->TotalXferredLen);
-      pSRB->SGBusAddr += (pSRB->Saved_Ptr - pSRB->TotalXferredLen);
-      printk (KERN_INFO "DC390: Pointer restored. Segment %i, Total %li, Bus %08lx\n", pSRB->SGIndex, pSRB->Saved_Ptr, pSRB->SGBusAddr);
-    }
-    else if( pSRB->pcmd->request_buffer )
-    {
+	pSRB->SGToBeXferLen -= (pSRB->Saved_Ptr - pSRB->TotalXferredLen);
+	pSRB->SGBusAddr += (pSRB->Saved_Ptr - pSRB->TotalXferredLen);
+	printk (KERN_INFO "DC390: Pointer restored. Segment %i, Total %li, Bus %08lx\n",
+		pSRB->SGIndex, pSRB->Saved_Ptr, pSRB->SGBusAddr);
+
+    } else if(pcmd->request_buffer) {
+	//dc390_pci_sync(pSRB);
+
+	pSRB->Segmentx.length = pcmd->request_bufflen - pSRB->Saved_Ptr;
 	pSRB->SGcount = 1;
 	pSRB->pSegmentList = (PSGL) &pSRB->Segmentx;
-	pSRB->Segmentx.address = (PUCHAR) pSRB->pcmd->request_buffer + pSRB->Saved_Ptr;
-	pSRB->Segmentx.length = pSRB->pcmd->request_bufflen - pSRB->Saved_Ptr;
-	printk (KERN_INFO "DC390: Pointer restored. Total %li, Bus %p\n",
-		pSRB->Saved_Ptr, pSRB->Segmentx.address);
-    }
-     else
-       {
+    } else {
 	 pSRB->SGcount = 0;
 	 printk (KERN_INFO "DC390: RESTORE_PTR message for Transfer without Scatter-Gather ??\n");
-       };
+    }

   pSRB->TotalXferredLen = pSRB->Saved_Ptr;
 };


 /* According to the docs, the AM53C974 reads the message and
- * generates a Succesful Operation IRQ before asserting ACK for
+ * generates a Successful Operation IRQ before asserting ACK for
  * the last byte (how does it know whether it's the last ?) */
 /* The old code handled it in another way, indicating, that on
  * every message byte an IRQ is generated and every byte has to
@@ -811,7 +812,7 @@
     /* Msg complete ? */
     if (dc390_MsgIn_complete (pSRB->MsgInBuf, pACB->MsgLen))
       {
-	DEBUG0 (printk (KERN_INFO "DC390: MsgIn:"); dc390_printMsg (pSRB->MsgInBuf, pACB->MsgLen);)
+	DEBUG0 (printk (KERN_INFO "DC390: MsgIn:"); dc390_printMsg (pSRB->MsgInBuf, pACB->MsgLen));
 	/* Now eval the msg */
 	switch (pSRB->MsgInBuf[0])
 	  {
@@ -853,7 +854,7 @@
 	    break;
 	    // The device might want to restart transfer with a RESTORE
 	  case RESTORE_POINTERS:
-	    DEBUG0(printk ("DC390: RESTORE POINTER message received ... try to handle\n");)
+	    DEBUG0(printk ("DC390: RESTORE POINTER message received ... try to handle\n"));
 	    dc390_restore_ptr (pACB, pSRB);
 	    break;

@@ -864,7 +865,7 @@
 	/* Clear counter and MsgIn state */
 	pSRB->SRBState &= ~SRB_MSGIN;
 	pACB->MsgLen = 0;
-      };
+      }

     *psstatus = SCSI_NOP0;
     DC390_write8 (ScsiCmd, MSG_ACCEPTED_CMD);
@@ -895,12 +896,12 @@
 	if( !pSRB->SGToBeXferLen )
 	{
 	    psgl = pSRB->pSegmentList;
-	    pSRB->SGBusAddr = virt_to_bus( psgl->address );
-	    pSRB->SGToBeXferLen = (ULONG) psgl->length;
-	    DEBUG1(printk (KERN_DEBUG " DC390: Next SG segment.");)
+	    pSRB->SGBusAddr = cpu_to_le32(pci_dma_lo32(sg_dma_address(psgl)));
+	    pSRB->SGToBeXferLen = cpu_to_le32(sg_dma_len(psgl));
+	    DEBUG1(printk (KERN_DEBUG " DC390: Next SG segment."));
 	}
 	lval = pSRB->SGToBeXferLen;
-	DEBUG1(printk (KERN_DEBUG " DC390: Start transfer: %li bytes (address %08lx)\n", lval, pSRB->SGBusAddr);)
+	DEBUG1(printk (KERN_DEBUG " DC390: Start transfer: %li bytes (address %08lx)\n", lval, pSRB->SGBusAddr));
 	DC390_write8 (CtcReg_Low, (UCHAR) lval);
 	lval >>= 8;
 	DC390_write8 (CtcReg_Mid, (UCHAR) lval);
@@ -916,9 +917,9 @@
 	DC390_write8 (ScsiCmd, DMA_COMMAND+INFO_XFER_CMD);

 	DC390_write8 (DMA_Cmd, DMA_START_CMD | ioDir | DMA_INT);
-	//DEBUG1(DC390_write32 (DMA_ScsiBusCtrl, WRT_ERASE_DMA_STAT | EN_INT_ON_PCI_ABORT);)
-	//DEBUG1(printk (KERN_DEBUG "DC390: DMA_Status: %02x\n", DC390_read8 (DMA_Status));)
-	//DEBUG1(DC390_write32 (DMA_ScsiBusCtrl, EN_INT_ON_PCI_ABORT);)
+	//DEBUG1(DC390_write32 (DMA_ScsiBusCtrl, WRT_ERASE_DMA_STAT | EN_INT_ON_PCI_ABORT));
+	//DEBUG1(printk (KERN_DEBUG "DC390: DMA_Status: %02x\n", DC390_read8 (DMA_Status)));
+	//DEBUG1(DC390_write32 (DMA_ScsiBusCtrl, EN_INT_ON_PCI_ABORT));
     }
     else    /* xfer pad */
     {
@@ -926,9 +927,9 @@
 	{
 	    pSRB->AdaptStatus = H_OVER_UNDER_RUN;
 	    pSRB->SRBStatus |= OVER_RUN;
-	    DEBUG0(printk (KERN_WARNING " DC390: Overrun -");)
+	    DEBUG0(printk (KERN_WARNING " DC390: Overrun -"));
 	}
-	DEBUG0(printk (KERN_WARNING " Clear transfer pad \n");)
+	DEBUG0(printk (KERN_WARNING " Clear transfer pad \n"));
 	DC390_write8 (CtcReg_Low, 0);
 	DC390_write8 (CtcReg_Mid, 0);
 	DC390_write8 (CtcReg_High, 0);
@@ -981,7 +982,7 @@
 	DC390_write8 (ScsiFifo, bval);
 	DC390_write8 (ScsiFifo, sizeof(pSRB->pcmd->sense_buffer));
 	DC390_write8 (ScsiFifo, bval);
-	DEBUG0(printk(KERN_DEBUG "DC390: AutoReqSense (CmndPhase)!\n");)
+	DEBUG0(printk(KERN_DEBUG "DC390: AutoReqSense (CmndPhase)!\n"));
     }
     pSRB->SRBState = SRB_COMMAND;
     DC390_write8 (ScsiCmd, INFO_XFER_CMD);
@@ -1111,7 +1112,7 @@
     PSRB   pSRB, psrb;
     UCHAR  i, cnt;

-    DEBUG0(printk(KERN_INFO "DISC,");)
+    DEBUG0(printk(KERN_INFO "DISC,"));

     if (!pACB->Connected) printk(KERN_ERR "DC390: Disconnect not-connected bus?\n");
     pACB->Connected = 0;
@@ -1120,7 +1121,7 @@
      {
 	int j = 400;
 	DEBUG0(printk(KERN_ERR "ACB:%p->ActiveDCB:%p IOPort:%04x IRQ:%02x !\n",\
-	       pACB, pDCB, pACB->IOPortBase, pACB->IRQLevel);)
+	       pACB, pDCB, pACB->IOPortBase, pACB->IRQLevel));
 	while (--j) udelay (1000);
 	DC390_read8 (INT_Status);	/* Reset Pending INT */
 	DC390_write8 (ScsiCmd, EN_SEL_RESEL);
@@ -1194,12 +1195,12 @@
     PSRB   pSRB;
     UCHAR  id, lun;

-    DEBUG0(printk(KERN_INFO "RSEL,");)
+    DEBUG0(printk(KERN_INFO "RSEL,"));
     pACB->Connected = 1;
     pDCB = pACB->pActiveDCB;
     if( pDCB )
     {	/* Arbitration lost but Reselection won */
-	DEBUG0(printk ("DC390: (ActiveDCB != 0: Arb. lost but resel. won)!\n");)
+	DEBUG0(printk ("DC390: (ActiveDCB != 0: Arb. lost but resel. won)!\n"));
 	pSRB = pDCB->pActiveSRB;
 	if( !( pACB->scan_devices ) )
 	{
@@ -1211,7 +1212,7 @@
     }
     /* Get ID */
     lun = DC390_read8 (ScsiFifo);
-    DEBUG0(printk ("Dev %02x,", lun);)
+    DEBUG0(printk ("Dev %02x,", lun));
     if (!(lun & (1 << pACB->pScsiHost->this_id)))
       printk (KERN_ERR "DC390: Reselection must select host adapter: %02x!\n", lun);
     else
@@ -1221,7 +1222,7 @@
     lun = DC390_read8 (ScsiFifo);
     if (!(lun & IDENTIFY_BASE)) printk (KERN_ERR "DC390: Resel: Expect identify message!\n");
     lun &= 7;
-    DEBUG0(printk ("(%02i-%i),", id, lun);)
+    DEBUG0(printk ("(%02i-%i),", id, lun));
     pDCB = dc390_findDCB (pACB, id, lun);
     if (!pDCB)
     {
@@ -1262,7 +1263,7 @@
 	}
     }

-    DEBUG1(printk (KERN_DEBUG "Resel SRB(%p): TagNum (%02x)\n", pSRB, pSRB->TagNumber);)
+    DEBUG1(printk (KERN_DEBUG "Resel SRB(%p): TagNum (%02x)\n", pSRB, pSRB->TagNumber));
     pSRB->ScsiPhase = SCSI_NOP0;
     DC390_write8 (Scsi_Dest_ID, pDCB->TargetID);
     DC390_write8 (Sync_Period, pDCB->SyncPeriod);
@@ -1282,7 +1283,7 @@
    if (pDCB->GoingSRBCnt > 1)
      {
 	DCBDEBUG(printk (KERN_INFO "DC390: Driver won't free DCB (ID %i, LUN %i): 0x%08x because of SRBCnt %i\n",\
-		pDCB->TargetID, pDCB->TargetLUN, (int)pDCB, pDCB->GoingSRBCnt);)
+		pDCB->TargetID, pDCB->TargetLUN, (int)pDCB, pDCB->GoingSRBCnt));
 	return;
      };
    pACB->DCBmap[pDCB->TargetID] &= ~(1 << pDCB->TargetLUN);
@@ -1304,7 +1305,7 @@
    }

    DCBDEBUG(printk (KERN_INFO "DC390: Driver about to free DCB (ID %i, LUN %i): %p\n",\
-	   pDCB->TargetID, pDCB->TargetLUN, pDCB);)
+	   pDCB->TargetID, pDCB->TargetLUN, pDCB));
    if (pDCB == pACB->pActiveDCB) pACB->pActiveDCB = 0;
    if (pDCB == pACB->pLinkDCB) pACB->pLinkDCB = pDCB->pNextDCB;
    if (pDCB == pACB->pDCBRunRobin) pACB->pDCBRunRobin = pDCB->pNextDCB;
@@ -1366,14 +1367,18 @@
     PSGL   ptr2;
     ULONG  swlval;

-    pcmd = pSRB->pcmd; DCB_removed = 0;
+    pcmd = pSRB->pcmd;
+    /* KG: Moved pci_unmap here */
+    dc390_pci_unmap(pSRB);
+
+    DCB_removed = 0;
     status = pSRB->TargetStatus;
     ptr = (PSCSI_INQDATA) (pcmd->request_buffer);
     if( pcmd->use_sg )
-	ptr = (PSCSI_INQDATA) (((PSGL) ptr)->address);
+	ptr = (PSCSI_INQDATA) sg_dma_address((PSGL) ptr);

     DEBUG0(printk (" SRBdone (%02x,%08x), SRB %p, pid %li\n", status, pcmd->result,\
-		pSRB, pcmd->pid);)
+		pSRB, pcmd->pid));
     if(pSRB->SRBFlag & AUTO_REQSENSE)
     {	/* Last command was a Request Sense */
 	pSRB->SRBFlag &= ~AUTO_REQSENSE;
@@ -1415,7 +1420,7 @@
 	    else
 		  pcmd->result = MK_RES_LNX(DRIVER_SENSE,DID_OK,0,CHECK_CONDITION);
 		  REMOVABLEDEBUG(printk(KERN_INFO "Cmd=%02x,Result=%08x,XferL=%08x\n",pSRB->pcmd->cmnd[0],\
-			(UINT) pcmd->result, (UINT) pSRB->TotalXferredLen);)
+			(UINT) pcmd->result, (UINT) pSRB->TotalXferredLen));
 	    goto ckc_e;
 	}
 	else /* Retry */
@@ -1430,24 +1435,17 @@
 	    {
 		pcmd->result = MK_RES_LNX(DRIVER_SENSE,DID_OK,0,CHECK_CONDITION);
 		REMOVABLEDEBUG(printk(KERN_INFO "Cmd=%02x, Result=%08x, XferL=%08x\n",pSRB->pcmd->cmnd[0],\
-		       (UINT) pcmd->result, (UINT) pSRB->TotalXferredLen);)
+		       (UINT) pcmd->result, (UINT) pSRB->TotalXferredLen));
 		goto ckc_e;
 	    }
 	    SET_RES_DRV(pcmd->result,DRIVER_SENSE);
-	    pSRB->SGcount	 = (UCHAR) pSRB->SavedSGCount;
+	    pcmd->use_sg	 = pSRB->SavedSGCount;
 	    //pSRB->ScsiCmdLen	 = (UCHAR) (pSRB->Segment1[0] >> 8);
-	    DEBUG0 (printk ("DC390: RETRY pid %li (%02x), target %02i-%02i\n", pcmd->pid, pcmd->cmnd[0], pcmd->target, pcmd->lun);)
+	    DEBUG0 (printk ("DC390: RETRY pid %li (%02x), target %02i-%02i\n", pcmd->pid, pcmd->cmnd[0], pcmd->device->id, pcmd->device->lun));
 	    pSRB->SGIndex = 0;
 	    pSRB->TotalXferredLen = 0;
 	    pSRB->SGToBeXferLen = 0;
-	    if( pcmd->use_sg )
-		pSRB->pSegmentList = (PSGL) pcmd->request_buffer;
-	    else if( pcmd->request_buffer )
-	    {
-		pSRB->pSegmentList = (PSGL) &pSRB->Segmentx;
-		pSRB->Segmentx.address = (PUCHAR) pcmd->request_buffer;
-		pSRB->Segmentx.length = pcmd->request_bufflen;
-	    }
+
 	    if( dc390_StartSCSI( pACB, pDCB, pSRB ) ) {
 		dc390_Going_to_Waiting ( pDCB, pSRB );
 		dc390_waiting_timer (pACB, HZ/5);
@@ -1460,7 +1458,7 @@
 	if( status_byte(status) == CHECK_CONDITION )
 	{
 	    REMOVABLEDEBUG(printk (KERN_INFO "DC390: Check_Condition (Cmd %02x, Id %02x, LUN %02x)\n",\
-		    pcmd->cmnd[0], pDCB->TargetID, pDCB->TargetLUN);)
+		    pcmd->cmnd[0], pDCB->TargetID, pDCB->TargetLUN));
 	    if( (pSRB->SGIndex < pSRB->SGcount) && (pSRB->SGcount) && (pSRB->SGToBeXferLen) )
 	    {
 		bval = pSRB->SGcount;
@@ -1472,7 +1470,7 @@
 		    ptr2++;
 		}
 		REMOVABLEDEBUG(printk(KERN_INFO "XferredLen=%08x,NotXferLen=%08x\n",\
-			(UINT) pSRB->TotalXferredLen, (UINT) swlval);)
+			(UINT) pSRB->TotalXferredLen, (UINT) swlval));
 	    }
 	    dc390_RequestSense( pACB, pDCB, pSRB );
 	    return;
@@ -1515,14 +1513,6 @@
 		pSRB->SGIndex = 0;
 		pSRB->TotalXferredLen = 0;
 		pSRB->SGToBeXferLen = 0;
-		if( pcmd->use_sg )
-		    pSRB->pSegmentList = (PSGL) pcmd->request_buffer;
-		else if( pcmd->request_buffer )
-		{
-		    pSRB->pSegmentList = (PSGL) &pSRB->Segmentx;
-		    pSRB->Segmentx.address = (PUCHAR) pcmd->request_buffer;
-		    pSRB->Segmentx.length = pcmd->request_bufflen;
-		}
 		if( dc390_StartSCSI( pACB, pDCB, pSRB ) ) {
 		    dc390_Going_to_Waiting ( pDCB, pSRB );
 		    dc390_waiting_timer (pACB, HZ/5);
@@ -1637,7 +1627,7 @@
     /* Add to free list */
     dc390_Free_insert (pACB, pSRB);

-    DEBUG0(printk (KERN_DEBUG "DC390: SRBdone: done pid %li\n", pcmd->pid);)
+    DEBUG0(printk (KERN_DEBUG "DC390: SRBdone: done pid %li\n", pcmd->pid));
     DC390_UNLOCK_ACB_NI;
     pcmd->scsi_done (pcmd);
     DC390_LOCK_ACB_NI;
@@ -1677,7 +1667,7 @@

 /*	    ReleaseSRB( pDCB, pSRB ); */

-	    DEBUG0(printk (KERN_DEBUG "DC390: DoingSRB_Done: done pid %li\n", pcmd->pid);)
+	    DEBUG0(printk (KERN_DEBUG "DC390: DoingSRB_Done: done pid %li\n", pcmd->pid));
 	    DC390_UNLOCK_ACB_NI;
 	    pcmd->scsi_done( pcmd );
 	    DC390_LOCK_ACB_NI;
@@ -1712,7 +1702,7 @@
 dc390_ScsiRstDetect( PACB pACB )
 {
     printk ("DC390: Rst_Detect: laststat = %08x\n", dc390_laststatus);
-    //DEBUG0(printk(KERN_INFO "RST_DETECT,");)
+    //DEBUG0(printk(KERN_INFO "RST_DETECT,"));

     if (timer_pending (&pACB->Waiting_Timer)) del_timer (&pACB->Waiting_Timer);
     DC390_write8 (DMA_Cmd, DMA_IDLE_CMD);
@@ -1747,7 +1737,7 @@
     PSCSICMD  pcmd;

     REMOVABLEDEBUG(printk (KERN_INFO "DC390: RequestSense (Cmd %02x, Id %02x, LUN %02x)\n",\
-	    pSRB->pcmd->cmnd[0], pDCB->TargetID, pDCB->TargetLUN);)
+	    pSRB->pcmd->cmnd[0], pDCB->TargetID, pDCB->TargetLUN));

     pSRB->SRBFlag |= AUTO_REQSENSE;
     //pSRB->Segment0[0] = (UINT) pSRB->CmdBlock[0];
@@ -1761,10 +1751,8 @@

     pcmd = pSRB->pcmd;

-    pSRB->Segmentx.address = (PUCHAR) &(pcmd->sense_buffer);
-    pSRB->Segmentx.length = sizeof(pcmd->sense_buffer);
-    pSRB->pSegmentList = &pSRB->Segmentx;
-    pSRB->SGcount = 1;
+    /* We are called from SRBdone, original PCI mapping has been removed
+     * already, new one is set up from StartSCSI */
     pSRB->SGIndex = 0;

     //pSRB->CmdBlock[0] = REQUEST_SENSE;
Only in linux-2.6.0-test7/drivers/scsi/: scsiiom.c~
diff -ur linux-2.6.0-test7.arm/drivers/scsi/tmscsim.c linux-2.6.0-test7/drivers/scsi/tmscsim.c
--- linux-2.6.0-test7.arm/drivers/scsi/tmscsim.c	Sat Aug  9 06:42:57 2003
+++ linux-2.6.0-test7/drivers/scsi/tmscsim.c	Sat Nov 22 23:38:56 2003
@@ -178,33 +178,36 @@
 //#define DC390_REMOVABLEDEBUG
 //#define DC390_LOCKDEBUG

+//#define NOP do{}while(0)
+#define C_NOP
+
 /* Debug definitions */
 #ifdef DC390_DEBUG0
-# define DEBUG0(x) x;
+# define DEBUG0(x) x
 #else
-# define DEBUG0(x)
+# define DEBUG0(x) C_NOP
 #endif
 #ifdef DC390_DEBUG1
-# define DEBUG1(x) x;
+# define DEBUG1(x) x
 #else
-# define DEBUG1(x)
+# define DEBUG1(x) C_NOP
 #endif
 #ifdef DC390_DCBDEBUG
-# define DCBDEBUG(x) x;
+# define DCBDEBUG(x) x
 #else
-# define DCBDEBUG(x)
+# define DCBDEBUG(x) C_NOP
 #endif
 #ifdef DC390_PARSEDEBUG
-# define PARSEDEBUG(x) x;
+# define PARSEDEBUG(x) x
 #else
-# define PARSEDEBUG(x)
+# define PARSEDEBUG(x) C_NOP
 #endif
 #ifdef DC390_REMOVABLEDEBUG
-# define REMOVABLEDEBUG(x) x;
+# define REMOVABLEDEBUG(x) x
 #else
-# define REMOVABLEDEBUG(x)
+# define REMOVABLEDEBUG(x) C_NOP
 #endif
-#define DCBDEBUG1(x)
+#define DCBDEBUG1(x) C_NOP

 /* Includes */
 #include <linux/module.h>
@@ -226,6 +229,7 @@
 #include <linux/version.h>
 #include <linux/blkdev.h>
 #include <linux/timer.h>
+#include <linux/interrupt.h>

 #include "scsi.h"
 #include "hosts.h"
@@ -262,18 +266,7 @@
 #endif
 #endif

-
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,1,93)
-# define USE_SPINLOCKS 1
-# define NEW_PCI 1
-#else
-# undef NEW_PCI
-# if LINUX_VERSION_CODE >= KERNEL_VERSION(2,1,30)
-#  define USE_SPINLOCKS 2
-# endif
-#endif
-
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,99)
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,99) && defined(MODULE)
 static struct pci_device_id tmscsim_pci_tbl[] = {
 	{
 		.vendor		= PCI_VENDOR_ID_AMD,
@@ -286,143 +279,42 @@
 MODULE_DEVICE_TABLE(pci, tmscsim_pci_tbl);
 #endif

-#ifdef USE_SPINLOCKS
-
-# if USE_SPINLOCKS == 3 /* both */
-
-#  if defined (CONFIG_SMP)
-#   define DC390_LOCKA_INIT { spinlock_t __unlocked = SPIN_LOCK_UNLOCKED; pACB->lock = __unlocked; };
-#  else
-#   define DC390_LOCKA_INIT
-#  endif
-   spinlock_t dc390_drvlock = SPIN_LOCK_UNLOCKED;
-
-#  define DC390_AFLAGS unsigned long aflags;
-#  define DC390_IFLAGS unsigned long iflags;
-#  define DC390_DFLAGS unsigned long dflags;
-
-#  define DC390_LOCK_IO spin_lock_irqsave (((struct Scsi_Host *)dev)->host_lock, iflags)
-#  define DC390_UNLOCK_IO spin_unlock_irqrestore (((struct Scsi_Host *)dev)->host_lock, iflags)
-
-#  define DC390_LOCK_DRV spin_lock_irqsave (&dc390_drvlock, dflags)
-#  define DC390_UNLOCK_DRV spin_unlock_irqrestore (&dc390_drvlock, dflags)
-#  define DC390_LOCK_DRV_NI spin_lock (&dc390_drvlock)
-#  define DC390_UNLOCK_DRV_NI spin_unlock (&dc390_drvlock)
-
-#  define DC390_LOCK_ACB spin_lock_irqsave (&(pACB->lock), aflags)
-#  define DC390_UNLOCK_ACB spin_unlock_irqrestore (&(pACB->lock), aflags)
-#  define DC390_LOCK_ACB_NI spin_lock (&(pACB->lock))
-#  define DC390_UNLOCK_ACB_NI spin_unlock (&(pACB->lock))
-//#  define DC390_LOCKA_INIT spin_lock_init (&(pACB->lock))
-
-# else
-
-#  if USE_SPINLOCKS == 2 /* adapter specific locks */
-
-#   if defined (CONFIG_SMP)
-#    define DC390_LOCKA_INIT { spinlock_t __unlocked = SPIN_LOCK_UNLOCKED; pACB->lock = __unlocked; };
-#   else
-#    define DC390_LOCKA_INIT
-#   endif
-    spinlock_t dc390_drvlock = SPIN_LOCK_UNLOCKED;
-#   define DC390_AFLAGS unsigned long aflags;
-#   define DC390_IFLAGS
-#  define DC390_DFLAGS unsigned long dflags;
-#   define DC390_LOCK_IO(dev) /* spin_lock_irqsave (&io_request_lock, iflags) */
-#   define DC390_UNLOCK_IO(dev) /* spin_unlock_irqrestore (&io_request_lock, iflags) */
-#   define DC390_LOCK_DRV spin_lock_irqsave (&dc390_drvlock, dflags)
-#   define DC390_UNLOCK_DRV spin_unlock_irqrestore (&dc390_drvlock, dflags)
-#   define DC390_LOCK_DRV_NI spin_lock (&dc390_drvlock)
-#   define DC390_UNLOCK_DRV_NI spin_unlock (&dc390_drvlock)
-#   define DC390_LOCK_ACB spin_lock_irqsave (&(pACB->lock), aflags)
-#   define DC390_UNLOCK_ACB spin_unlock_irqrestore (&(pACB->lock), aflags)
-#   define DC390_LOCK_ACB_NI spin_lock (&(pACB->lock))
-#   define DC390_UNLOCK_ACB_NI spin_unlock (&(pACB->lock))
-//#   define DC390_LOCKA_INIT spin_lock_init (&(pACB->lock))
-
-#  else /* USE_SPINLOCKS == 1: global lock io_request_lock */
-
-#   define DC390_AFLAGS
-#   define DC390_IFLAGS unsigned long iflags;
-#   define DC390_DFLAGS unsigned long dflags;
-    spinlock_t dc390_drvlock = SPIN_LOCK_UNLOCKED;
-#   define DC390_LOCK_IO(dev) spin_lock_irqsave (((struct Scsi_Host *)dev)->host_lock, iflags)
-#   define DC390_UNLOCK_IO(dev) spin_unlock_irqrestore (((struct Scsi_Host *)dev)->host_lock, iflags)
-#   define DC390_LOCK_DRV spin_lock_irqsave (&dc390_drvlock, dflags)
-#   define DC390_UNLOCK_DRV spin_unlock_irqrestore (&dc390_drvlock, dflags)
-#   define DC390_LOCK_DRV_NI spin_lock (&dc390_drvlock)
-#   define DC390_UNLOCK_DRV_NI spin_unlock (&dc390_drvlock)
-#   define DC390_LOCK_ACB /* DC390_LOCK_IO */
-#   define DC390_UNLOCK_ACB /* DC390_UNLOCK_IO */
-#   define DC390_LOCK_ACB_NI /* spin_lock (&(pACB->lock)) */
-#   define DC390_UNLOCK_ACB_NI /* spin_unlock (&(pACB->lock)) */
-#   define DC390_LOCKA_INIT /* DC390_LOCKA_INIT */
-
-#  endif /* 2 */
-# endif /* 3 */
-
-#else /* USE_SPINLOCKS undefined */
-
-# define DC390_AFLAGS unsigned long aflags;
-# define DC390_IFLAGS unsigned long iflags;
-# define DC390_DFLAGS unsigned long dflags;
-# define DC390_LOCK_IO save_flags (iflags); cli ()
-# define DC390_UNLOCK_IO restore_flags (iflags)
-# define DC390_LOCK_DRV save_flags (dflags); cli ()
-# define DC390_UNLOCK_DRV restore_flags (dflags)
-# define DC390_LOCK_DRV_NI
-# define DC390_UNLOCK_DRV_NI
-# define DC390_LOCK_ACB save_flags (aflags); cli ()
-# define DC390_UNLOCK_ACB restore_flags (aflags)
-# define DC390_LOCK_ACB_NI
-# define DC390_UNLOCK_ACB_NI
-# define DC390_LOCKA_INIT
-#endif /* def */
+#define USE_SPINLOCKS 1
+#define NEW_PCI 1

+#define DC390_AFLAGS
+#define DC390_IFLAGS unsigned long iflags
+#define DC390_DFLAGS unsigned long dflags
+spinlock_t dc390_drvlock = SPIN_LOCK_UNLOCKED;
+#define DC390_LOCK_IO(dev) spin_lock_irqsave (((struct Scsi_Host *)dev)->host_lock, iflags)
+#define DC390_UNLOCK_IO(dev) spin_unlock_irqrestore (((struct Scsi_Host *)dev)->host_lock, iflags)
+#define DC390_LOCK_DRV spin_lock_irqsave (&dc390_drvlock, dflags)
+#define DC390_UNLOCK_DRV spin_unlock_irqrestore (&dc390_drvlock, dflags)
+#define DC390_LOCK_DRV_NI spin_lock (&dc390_drvlock)
+#define DC390_UNLOCK_DRV_NI spin_unlock (&dc390_drvlock)
+#define DC390_LOCK_ACB /* DC390_LOCK_IO */
+#define DC390_UNLOCK_ACB /* DC390_UNLOCK_IO */
+#define DC390_LOCK_ACB_NI /* spin_lock (&(pACB->lock)) */
+#define DC390_UNLOCK_ACB_NI /* spin_unlock (&(pACB->lock)) */
+#define DC390_LOCKA_INIT /* DC390_LOCKA_INIT */

 /* These macros are used for uniform access to 2.0.x and 2.1.x PCI config space*/

-#ifdef NEW_PCI
-# define PDEV pdev
-# define PDEVDECL struct pci_dev *pdev
-# define PDEVDECL0 struct pci_dev *pdev = NULL
-# define PDEVDECL1 struct pci_dev *pdev
-# define PDEVSET pACB->pdev=pdev
-# define PDEVSET1 pdev=pACB->pdev
-# define PCI_WRITE_CONFIG_BYTE(pd, rv, bv) pci_write_config_byte (pd, rv, bv)
-# define PCI_READ_CONFIG_BYTE(pd, rv, bv) pci_read_config_byte (pd, rv, bv)
-# define PCI_WRITE_CONFIG_WORD(pd, rv, bv) pci_write_config_word (pd, rv, bv)
-# define PCI_READ_CONFIG_WORD(pd, rv, bv) pci_read_config_word (pd, rv, bv)
-# define PCI_BUS_DEV pdev->bus->number, pdev->devfn
-# define PCI_PRESENT (1)
-# define PCI_SET_MASTER pci_set_master (pdev)
-# define PCI_FIND_DEVICE(vend, id) (pdev = pci_find_device (vend, id, pdev))
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,10)
-# define PCI_GET_IO_AND_IRQ io_port = pci_resource_start (pdev, 0); irq = pdev->irq
-#else
-# define PCI_GET_IO_AND_IRQ io_port = pdev->base_address[0] & PCI_BASE_ADDRESS_IO_MASK; irq = pdev->irq
-#endif
-#else
-# include <linux/bios32.h>
-# define PDEV pbus, pdevfn
-# define PDEVDECL UCHAR pbus, UCHAR pdevfn
-# define PDEVDECL0 UCHAR pbus = 0; UCHAR pdevfn = 0; USHORT pci_index = 0; int error
-# define PDEVDECL1 UCHAR pbus; UCHAR pdevfn /*; USHORT pci_index */
-# define PDEVSET pACB->pbus=pbus; pACB->pdevfn=pdevfn /*; pACB->pci_index=pci_index */
-# define PDEVSET1 pbus=pACB->pbus; pdevfn=pACB->pdevfn /*; pci_index=pACB->pci_index */
-# define PCI_WRITE_CONFIG_BYTE(pd, rv, bv) pcibios_write_config_byte (pd, rv, bv)
-# define PCI_READ_CONFIG_BYTE(pd, rv, bv) pcibios_read_config_byte (pd, rv, bv)
-# define PCI_WRITE_CONFIG_WORD(pd, rv, bv) pcibios_write_config_word (pd, rv, bv)
-# define PCI_READ_CONFIG_WORD(pd, rv, bv) pcibios_read_config_word (pd, rv, bv)
-# define PCI_BUS_DEV pbus, pdevfn
-# define PCI_PRESENT pcibios_present ()
-# define PCI_SET_MASTER dc390_set_master (pbus, pdevfn)
-# define PCI_FIND_DEVICE(vend, id) (!pcibios_find_device (vend, id, pci_index++, &pbus, &pdevfn))
-# define PCI_GET_IO_AND_IRQ error = pcibios_read_config_dword (pbus, pdevfn, PCI_BASE_ADDRESS_0, &io_port);	\
- error |= pcibios_read_config_byte (pbus, pdevfn, PCI_INTERRUPT_LINE, &irq);	\
- io_port &= 0xfffe;	\
- if (error) { printk (KERN_ERR "DC390_detect: Error reading PCI config registers!\n"); continue; }
-#endif
+#define PDEV pdev
+#define PDEVDECL struct pci_dev *pdev
+#define PDEVDECL0 struct pci_dev *pdev = NULL
+#define PDEVDECL1 struct pci_dev *pdev
+#define PDEVSET pACB->pdev=pdev
+#define PDEVSET1 pdev=pACB->pdev
+#define PCI_WRITE_CONFIG_BYTE(pd, rv, bv) pci_write_config_byte (pd, rv, bv)
+#define PCI_READ_CONFIG_BYTE(pd, rv, bv) pci_read_config_byte (pd, rv, bv)
+#define PCI_WRITE_CONFIG_WORD(pd, rv, bv) pci_write_config_word (pd, rv, bv)
+#define PCI_READ_CONFIG_WORD(pd, rv, bv) pci_read_config_word (pd, rv, bv)
+#define PCI_BUS_DEV pdev->bus->number, pdev->devfn
+#define PCI_PRESENT (1)
+#define PCI_SET_MASTER pci_set_master (pdev)
+#define PCI_FIND_DEVICE(vend, id) (pdev = pci_find_device (vend, id, pdev))
+#define PCI_GET_IO_AND_IRQ do{io_port = pci_resource_start (pdev, 0); irq = pdev->irq;} while(0)

 #include "tmscsim.h"

@@ -457,16 +349,14 @@
 static void __inline__ dc390_InvalidCmd( PACB pACB );
 static void __inline__ dc390_EnableMsgOut_Abort (PACB, PSRB);
 static void dc390_remove_dev (PACB pACB, PDCB pDCB);
-void do_DC390_Interrupt( int, void *, struct pt_regs *);
+irqreturn_t do_DC390_Interrupt( int, void *, struct pt_regs *);

 int    dc390_initAdapter( PSH psh, ULONG io_port, UCHAR Irq, UCHAR index );
 void   dc390_initDCB( PACB pACB, PDCB *ppDCB, UCHAR id, UCHAR lun);
 void   dc390_updateDCB (PACB pACB, PDCB pDCB);

-#ifdef MODULE
- static int DC390_release(struct Scsi_Host *host);
- static int dc390_shutdown (struct Scsi_Host *host);
-#endif
+static int DC390_release(struct Scsi_Host *host);
+static int dc390_shutdown (struct Scsi_Host *host);


 //static PSHT	dc390_pSHT_start = NULL;
@@ -609,7 +499,7 @@
 		ptr[id<<2] = (UCHAR)tmscsim[2];		/* EE_MODE1 */
 	if (tmscsim[1] != -2)
 		ptr[(id<<2) + 1] = (UCHAR)tmscsim[1];	/* EE_Speed */
-    };
+    }
 }

 /* Handle "-1" case */
@@ -641,7 +531,7 @@
 {
 	int i;
 	PARSEDEBUG(printk(KERN_INFO "DC390: setup %08x %08x %08x %08x %08x %08x\n", tmscsim[0],\
-		      tmscsim[1], tmscsim[2], tmscsim[3], tmscsim[4], tmscsim[5]);)
+			  tmscsim[1], tmscsim[2], tmscsim[3], tmscsim[4], tmscsim[5]));
 	for (i = 0; i < 6; i++)
 	{
 		if (tmscsim[i] < 0 || tmscsim[i] > 255)
@@ -652,7 +542,7 @@
 	if (tmscsim[1] >   7) tmscsim[1] =   4;
 	if (tmscsim[4] >   5) tmscsim[4] =   4;
 	if (tmscsim[5] > 180) tmscsim[5] = 180;
-};
+}
 #endif

 /* Override defaults on cmdline:
@@ -669,12 +559,12 @@
 	{
 		printk (KERN_NOTICE "DC390: ignore extra params!\n");
 		im = 6;
-	};
+	}
 	for (i = 0; i < im; i++)
 		tmscsim[i] = ints[i+1];
 	/* dc390_checkparams (); */
 	return 1;
-};
+}
 #ifndef MODULE
 __setup("tmscsim=", dc390_setup);
 #endif
@@ -688,11 +578,11 @@
 	{
 		printk (KERN_NOTICE "DC390: ignore extra params!\n");
 		im = 6;
-	};
+	}
 	for (i = 0; i < im; i++)
 		tmscsim[i] = ints[i+1];
 	/* dc390_checkparams (); */
-};
+}
 #endif


@@ -787,7 +677,7 @@
 {
     char interpd [] = {1,3,5,10,16,30,60,120};
     dc390_eepromBuf[index][EE_DELAY] = interpd [dc390_eepromBuf[index][EE_DELAY]];
-};
+}

 static UCHAR __init dc390_CheckEEpromCheckSum( PDEVDECL, UCHAR index )
 {
@@ -822,14 +712,14 @@
 	if (pDCB == pACB->pLinkDCB)
 	  {
 	     DCBDEBUG(printk (KERN_WARNING "DC390: DCB not found (DCB=%p, DCBmap[%2x]=%2x)\n",
-		     pDCB, id, pACB->DCBmap[id]);)
+			      pDCB, id, pACB->DCBmap[id]));
 	     return 0;
 	  }
-     };
+     }
    DCBDEBUG1( printk (KERN_DEBUG "DCB %p (%02x,%02x) found.\n",	\
-		      pDCB, pDCB->TargetID, pDCB->TargetLUN);)
+		      pDCB, pDCB->TargetID, pDCB->TargetLUN));
    return pDCB;
-};
+}

 /* Queueing philosphy:
  * There are a couple of lists:
@@ -858,39 +748,37 @@
 	if (q == queue) return 0;
     }
     return q;
-};
+}
 #endif


 /* Append to Query List */
 static void dc390_Query_append( PSCSICMD cmd, PACB pACB )
 {
-    DEBUG0(printk ("DC390: Append cmd %li to Query\n", cmd->pid);)
-    if( !pACB->QueryCnt )
-	pACB->pQueryHead = cmd;
-    else
-	pACB->pQueryTail->next = cmd;
+	dc390_cmd_scp_t *cmdq = (dc390_cmd_scp_t *)&cmd->SCp;
+
+	DEBUG0(printk ("DC390: Append cmd %li to Query\n", cmd->pid));

-    pACB->pQueryTail = cmd;
-    pACB->QueryCnt++;
-    pACB->CmdOutOfSRB++;
-    cmd->next = NULL;
+	list_add_tail(&cmdq->list, &pACB->cmdq);
+	pACB->QueryCnt++;
+	pACB->CmdOutOfSRB++;
 }


 /* Return next cmd from Query list */
 static PSCSICMD dc390_Query_get ( PACB pACB )
 {
-    PSCSICMD  pcmd;
-
-    pcmd = pACB->pQueryHead;
-    if (!pcmd) return pcmd;
-    DEBUG0(printk ("DC390: Get cmd %li from Query\n", pcmd->pid);)
-    pACB->pQueryHead = pcmd->next;
-    pcmd->next = NULL;
-    if (!pACB->pQueryHead) pACB->pQueryTail = NULL;
-    pACB->QueryCnt--;
-    return( pcmd );
+	PSCSICMD  pcmd;
+	dc390_cmd_scp_t *cmdq;
+	if (list_empty(&pACB->cmdq))
+		return NULL;
+
+	pcmd = (PSCSICMD) list_entry(pACB->cmdq.next, struct scsi_cmnd_list, scp.list);
+	DEBUG0(printk ("DC390: Get cmd %li from Query\n", pcmd->pid));
+	cmdq = (dc390_cmd_scp_t *)&pcmd->SCp;
+	list_del(&cmdq->list);
+	pACB->QueryCnt--;
+	return pcmd;
 }


@@ -900,7 +788,7 @@
     PSRB   pSRB;

     pSRB = pACB->pFreeSRB;
-    DEBUG0(printk ("DC390: Get Free SRB %p\n", pSRB);)
+    DEBUG0(printk ("DC390: Get Free SRB %p\n", pSRB));
     if( pSRB )
     {
 	pACB->pFreeSRB = pSRB->pNextSRB;
@@ -913,7 +801,7 @@
 /* Insert SRB oin top of free list */
 static __inline__ void dc390_Free_insert (PACB pACB, PSRB pSRB)
 {
-    DEBUG0(printk ("DC390: Free SRB %p\n", pSRB);)
+    DEBUG0(printk ("DC390: Free SRB %p\n", pSRB));
     pSRB->pNextSRB = pACB->pFreeSRB;
     pACB->pFreeSRB = pSRB;
 }
@@ -922,7 +810,7 @@
 /* Inserts a SRB to the top of the Waiting list */
 static __inline__ void dc390_Waiting_insert ( PDCB pDCB, PSRB pSRB )
 {
-    DEBUG0(printk ("DC390: Insert pSRB %p cmd %li to Waiting\n", pSRB, pSRB->pcmd->pid);)
+    DEBUG0(printk ("DC390: Insert pSRB %p cmd %li to Waiting\n", pSRB, pSRB->pcmd->pid));
     pSRB->pNextSRB = pDCB->pWaitingSRB;
     if (!pDCB->pWaitingSRB)
 	pDCB->pWaitLast = pSRB;
@@ -934,7 +822,7 @@
 /* Queue SRB to waiting list */
 static __inline__ void dc390_Waiting_append ( PDCB pDCB, PSRB pSRB)
 {
-    DEBUG0(printk ("DC390: Append pSRB %p cmd %li to Waiting\n", pSRB, pSRB->pcmd->pid);)
+	DEBUG0(printk ("DC390: Append pSRB %p cmd %li to Waiting\n", pSRB, pSRB->pcmd->pid));
     if( pDCB->pWaitingSRB )
 	pDCB->pWaitLast->pNextSRB = pSRB;
     else
@@ -949,7 +837,7 @@
 static __inline__ void dc390_Going_append (PDCB pDCB, PSRB pSRB)
 {
     pDCB->GoingSRBCnt++;
-    DEBUG0(printk("DC390: Append SRB %p to Going\n", pSRB);)
+    DEBUG0(printk("DC390: Append SRB %p to Going\n", pSRB));
     /* Append to the list of Going commands */
     if( pDCB->pGoingSRB )
 	pDCB->pGoingLast->pNextSRB = pSRB;
@@ -959,11 +847,11 @@
     pDCB->pGoingLast = pSRB;
     /* No next one in sent list */
     pSRB->pNextSRB = NULL;
-};
+}

 static __inline__ void dc390_Going_remove (PDCB pDCB, PSRB pSRB)
 {
-   DEBUG0(printk("DC390: Remove SRB %p from Going\n", pSRB);)
+	DEBUG0(printk("DC390: Remove SRB %p from Going\n", pSRB));
    if (pSRB == pDCB->pGoingSRB)
 	pDCB->pGoingSRB = pSRB->pNextSRB;
    else
@@ -978,12 +866,12 @@
 	  pDCB->pGoingLast = psrb;
      }
    pDCB->GoingSRBCnt--;
-};
+}

 /* Moves SRB from Going list to the top of Waiting list */
 static void dc390_Going_to_Waiting ( PDCB pDCB, PSRB pSRB )
 {
-    DEBUG0(printk(KERN_INFO "DC390: Going_to_Waiting (SRB %p) pid = %li\n", pSRB, pSRB->pcmd->pid);)
+    DEBUG0(printk(KERN_INFO "DC390: Going_to_Waiting (SRB %p) pid = %li\n", pSRB, pSRB->pcmd->pid));
     /* Remove SRB from Going */
     dc390_Going_remove (pDCB, pSRB);
     /* Insert on top of Waiting */
@@ -995,7 +883,7 @@
 static __inline__ void dc390_Waiting_to_Going ( PDCB pDCB, PSRB pSRB )
 {
 	/* Remove from waiting list */
-	DEBUG0(printk("DC390: Remove SRB %p from head of Waiting\n", pSRB);)
+	DEBUG0(printk("DC390: Remove SRB %p from head of Waiting\n", pSRB));
 	pDCB->pWaitingSRB = pSRB->pNextSRB;
 	if( !pDCB->pWaitingSRB ) pDCB->pWaitLast = NULL;
 	pDCB->WaitSRBCnt--;
@@ -1068,14 +956,14 @@
 void DC390_waiting_timed_out (unsigned long ptr)
 {
 	PACB pACB = (PACB)ptr;
-	DC390_IFLAGS
-	DC390_AFLAGS
-	DEBUG0(printk ("DC390: Debug: Waiting queue woken up by timer!\n");)
-	DC390_LOCK_IO(pACB.pScsiHost);
+	DC390_IFLAGS;
+	DC390_AFLAGS;
+	DEBUG0(printk ("DC390: Debug: Waiting queue woken up by timer!\n"));
+	DC390_LOCK_IO(pACB->pScsiHost);
 	DC390_LOCK_ACB;
 	dc390_Waiting_process (pACB);
 	DC390_UNLOCK_ACB;
-	DC390_UNLOCK_IO(pACB.pScsiHost);
+	DC390_UNLOCK_IO(pACB->pScsiHost);
 }

 /***********************************************************************
@@ -1116,9 +1004,79 @@
     else {
 	dc390_Waiting_insert (pDCB, pSRB);
 	dc390_waiting_timer (pACB, HZ/5);
-    };
+    }
 }

+
+/* Create pci mapping */
+static int dc390_pci_map (PSRB pSRB)
+{
+	int error = 0;
+	Scsi_Cmnd *pcmd = pSRB->pcmd;
+	struct pci_dev *pdev = pSRB->pSRBDCB->pDCBACB->pdev;
+	dc390_cmd_scp_t* cmdp = ((dc390_cmd_scp_t*)(&pcmd->SCp));
+	/* Map sense buffer */
+	if (pSRB->SRBFlag & AUTO_REQSENSE) {
+		sg_dma_address(&pSRB->Segmentx) = cmdp->saved_dma_handle =
+			pci_map_page(pdev, virt_to_page(pcmd->sense_buffer),
+				     (unsigned long)pcmd->sense_buffer & ~PAGE_MASK, sizeof(pcmd->sense_buffer),
+				     DMA_FROM_DEVICE);
+		pSRB->Segmentx.length = sizeof(pcmd->sense_buffer);
+		pSRB->SGcount = 1;
+		pSRB->pSegmentList = (PSGL) &pSRB->Segmentx;
+		DEBUG1(printk("%s(): Mapped sense buffer %p at %x\n", __FUNCTION__, pcmd->sense_buffer, cmdp->saved_dma_handle));
+	/* Make SG list */
+	} else if (pcmd->use_sg) {
+		pSRB->pSegmentList = (PSGL) pcmd->request_buffer;
+		pSRB->SGcount = pci_map_sg(pdev, pSRB->pSegmentList,
+					   pcmd->use_sg,
+					   scsi_to_pci_dma_dir(pcmd->sc_data_direction));
+		/* TODO: error handling */
+		if (!pSRB->SGcount)
+			error = 1;
+		DEBUG1(printk("%s(): Mapped SG %p with %d (%d) elements\n", __FUNCTION__, pcmd->request_buffer, pSRB->SGcount, pcmd->use_sg));
+	/* Map single segment */
+	} else if (pcmd->request_buffer && pcmd->request_bufflen) {
+		sg_dma_address(&pSRB->Segmentx) = cmdp->saved_dma_handle =
+			pci_map_page(pdev, virt_to_page(pcmd->request_buffer),
+				     (unsigned long)pcmd->request_buffer & ~PAGE_MASK,
+				     pcmd->request_bufflen, scsi_to_pci_dma_dir(pcmd->sc_data_direction));
+		/* TODO: error handling */
+		pSRB->Segmentx.length = pcmd->request_bufflen;
+		pSRB->SGcount = 1;
+		pSRB->pSegmentList = (PSGL) &pSRB->Segmentx;
+		DEBUG1(printk("%s(): Mapped request buffer %p at %x\n", __FUNCTION__, pcmd->request_buffer, cmdp->saved_dma_handle));
+	/* No mapping !? */
+    	} else
+		pSRB->SGcount = 0;
+	return error;
+}
+
+/* Remove pci mapping */
+static void dc390_pci_unmap (PSRB pSRB)
+{
+	Scsi_Cmnd* pcmd = pSRB->pcmd;
+	struct pci_dev *pdev = pSRB->pSRBDCB->pDCBACB->pdev;
+	dc390_cmd_scp_t* cmdp = ((dc390_cmd_scp_t*)(&pcmd->SCp));
+
+	if (pSRB->SRBFlag) {
+		pci_unmap_page(pdev, cmdp->saved_dma_handle,
+			       sizeof(pcmd->sense_buffer), DMA_FROM_DEVICE);
+		DEBUG1(printk("%s(): Unmapped sense buffer at %x\n", __FUNCTION__, cmdp->saved_dma_handle));
+	} else if (pcmd->use_sg) {
+		pci_unmap_sg(pdev, pcmd->request_buffer, pcmd->use_sg,
+			     scsi_to_pci_dma_dir(pcmd->sc_data_direction));
+		DEBUG1(printk("%s(): Unmapped SG at %p with %d elements\n", __FUNCTION__, pcmd->request_buffer, pcmd->use_sg));
+	} else if (pcmd->request_buffer && pcmd->request_bufflen) {
+		pci_unmap_page(pdev,
+			       cmdp->saved_dma_handle,
+			       pcmd->request_bufflen,
+			       scsi_to_pci_dma_dir(pcmd->sc_data_direction));
+		DEBUG1(printk("%s(): Unmapped request buffer at %x\n", __FUNCTION__, cmdp->saved_dma_handle));
+	}
+}
+
+
 /***********************************************************************
  * Function: static void dc390_BuildSRB (Scsi_Cmd *pcmd, PDCB pDCB,
  * 					 PSRB pSRB)
@@ -1134,21 +1092,6 @@
     //pSRB->ScsiCmdLen = pcmd->cmd_len;
     //memcpy (pSRB->CmdBlock, pcmd->cmnd, pcmd->cmd_len);

-    if( pcmd->use_sg )
-    {
-	pSRB->SGcount = (UCHAR) pcmd->use_sg;
-	pSRB->pSegmentList = (PSGL) pcmd->request_buffer;
-    }
-    else if( pcmd->request_buffer )
-    {
-	pSRB->SGcount = 1;
-	pSRB->pSegmentList = (PSGL) &pSRB->Segmentx;
-	pSRB->Segmentx.address = (PUCHAR) pcmd->request_buffer;
-	pSRB->Segmentx.length = pcmd->request_bufflen;
-    }
-    else
-	pSRB->SGcount = 0;
-
     pSRB->SGIndex = 0;
     pSRB->AdaptStatus = 0;
     pSRB->TargetStatus = 0;
@@ -1166,7 +1109,8 @@
     pSRB->ScsiPhase = 0;
     pSRB->EndMessage = 0;
     pSRB->TagNumber = 255;
-};
+    /* KG: deferred PCI mapping to dc390_StartSCSI */
+}

 /* Put cmnd from Query to Waiting list and send next Waiting cmnd */
 static void dc390_Query_to_Waiting (PACB pACB)
@@ -1183,7 +1127,7 @@
 	pSRB = dc390_Free_get ( pACB );
 	if (!pSRB) return;
 	pcmd = dc390_Query_get ( pACB );
-	if (!pcmd) { dc390_Free_insert (pACB, pSRB); return; }; /* should not happen */
+	if (!pcmd) { dc390_Free_insert (pACB, pSRB); return; } /* should not happen */
 	pDCB = dc390_findDCB (pACB, pcmd->device->id, pcmd->device->lun);
 	if (!pDCB)
 	{
@@ -1193,7 +1137,7 @@
 		DC390_UNLOCK_ACB_NI;
 		pcmd->done (pcmd);
 		DC390_LOCK_ACB_NI;
-	};
+	}
 	dc390_BuildSRB (pcmd, pDCB, pSRB);
 	dc390_Waiting_append ( pDCB, pSRB );
     }
@@ -1222,13 +1166,13 @@
 {
     PDCB   pDCB;
     PSRB   pSRB;
-    DC390_AFLAGS
     PACB   pACB = (PACB) cmd->device->host->hostdata;
+    DC390_AFLAGS;


     DEBUG0(/*  if(pACB->scan_devices) */	\
-	printk(KERN_INFO "DC390: Queue Cmd=%02x,Tgt=%d,LUN=%d (pid=%li)\n",\
-		cmd->cmnd[0],cmd->device->id,cmd->device->lun,cmd->pid);)
+	printk(KERN_INFO "DC390: Queue Cmd=%02x,Tgt=%d,LUN=%d (pid=%li), buffer=%p\n",\
+	       cmd->cmnd[0],cmd->device->id,cmd->device->lun,cmd->pid, cmd->buffer));

     DC390_LOCK_ACB;

@@ -1274,7 +1218,7 @@
 	    done (cmd);
 	    return (0);
 #endif
-	  };
+	  }

     }
     else if( !(pACB->scan_devices) && !(pACB->DCBmap[cmd->device->id] & (1 << cmd->device->lun)) )
@@ -1301,7 +1245,7 @@
 	    done (cmd);
 	    return (0);
 #endif
-	 };
+	 }
     }

     pACB->Cmds++;
@@ -1312,14 +1256,14 @@

     if( pACB->QueryCnt ) /* Unsent commands ? */
     {
-	DEBUG0(printk ("DC390: QueryCnt != 0\n");)
+	DEBUG0(printk ("DC390: QueryCnt != 0\n"));
 	dc390_Query_append ( cmd, pACB );
 	dc390_Waiting_process (pACB);
     }
     else if (pDCB->pWaitingSRB)
     {
  	pSRB = dc390_Free_get ( pACB );
-	DEBUG0(if (!pSRB) printk ("DC390: No free SRB but Waiting\n"); else printk ("DC390: Free SRB w/ Waiting\n");)
+	DEBUG0(if (!pSRB) printk ("DC390: No free SRB but Waiting\n"); else printk ("DC390: Free SRB w/ Waiting\n"));
 	if (!pSRB) dc390_Query_append (cmd, pACB);
 	else
 	  {
@@ -1331,7 +1275,7 @@
     else
     {
  	pSRB = dc390_Free_get ( pACB );
-	DEBUG0(if (!pSRB) printk ("DC390: No free SRB w/o Waiting\n"); else printk ("DC390: Free SRB w/o Waiting\n");)
+	DEBUG0(if (!pSRB) printk ("DC390: No free SRB w/o Waiting\n"); else printk ("DC390: Free SRB w/o Waiting\n"));
 	if (!pSRB)
 	{
 	    dc390_Query_append (cmd, pACB);
@@ -1341,11 +1285,11 @@
 	{
 	    dc390_BuildSRB (cmd, pDCB, pSRB);
 	    dc390_SendSRB (pACB, pSRB);
-	};
-    };
+	}
+    }

     DC390_UNLOCK_ACB;
-    DEBUG1(printk (KERN_DEBUG " ... command (pid %li) queued successfully.\n", cmd->pid);)
+    DEBUG1(printk (KERN_DEBUG " ... command (pid %li) queued successfully.\n", cmd->pid));
     return(0);
 }

@@ -1480,7 +1424,7 @@
 		sector_t capacity, int geom[])
 {
     return scsicam_bios_param (bdev, capacity, geom);
-};
+}
 #endif


@@ -1496,7 +1440,7 @@
 		pSRB->TotalXferredLen, pSRB->SGToBeXferLen, pSRB->SRBState,
 		pSRB->ScsiPhase);
 	printk ("DC390: AdpaterStatus: %02x, SRB Status %02x\n", pSRB->AdaptStatus, pSRB->SRBStatus);
-    };
+    }
     printk ("DC390: Status of last IRQ (DMA/SC/Int/IRQ): %08x\n", dc390_laststatus);
     printk ("DC390: Register dump: SCSI block:\n");
     printk ("DC390: XferCnt  Cmd Stat IntS IRQS FFIS Ctl1 Ctl2 Ctl3 Ctl4\n");
@@ -1512,7 +1456,7 @@
 	printk ("DC390: FIFO:");
 	while (DC390_read8(Current_Fifo) & 0x1f) printk (" %02x", DC390_read8(ScsiFifo));
 	printk ("\n");
-      };
+      }
     printk ("DC390: Register dump: DMA engine:\n");
     printk ("DC390: Cmd   STrCnt    SBusA    WrkBC    WrkAC Stat SBusCtrl\n");
     printk ("DC390:  %02x %08x %08x %08x %08x   %02x %08x\n",
@@ -1523,7 +1467,7 @@
     PDEVSET1; PCI_READ_CONFIG_WORD(PDEV, PCI_STATUS, &pstat);
     printk ("DC390: Register dump: PCI Status: %04x\n", pstat);
     printk ("DC390: In case of driver trouble read linux/Documentation/scsi/tmscsim.txt\n");
-};
+}


 /***********************************************************************
@@ -1543,11 +1487,10 @@
     PDCB  pDCB;
     PSRB  pSRB, psrb;
     UINT  count, i;
-    PSCSICMD  pcmd;
     int   status;
     //ULONG sbac;
-    DC390_AFLAGS
     PACB  pACB = (PACB) cmd->device->host->hostdata;
+    DC390_AFLAGS;

     DC390_LOCK_ACB;

@@ -1557,33 +1500,16 @@
     /* First scan Query list */
     if( pACB->QueryCnt )
     {
-	pcmd = pACB->pQueryHead;
-	if( pcmd == cmd )
-	{
-	    /* Found: Dequeue */
-	    pACB->pQueryHead = pcmd->next;
-	    pcmd->next = NULL;
-	    if (cmd == pACB->pQueryTail) pACB->pQueryTail = NULL;
-	    pACB->QueryCnt--;
-	    status = SCSI_ABORT_SUCCESS;
-	    goto  ABO_X;
-	}
-	for( count = pACB->QueryCnt, i=0; i<count-1; i++)
-	{
-	    if( pcmd->next == cmd )
-	    {
-		pcmd->next = cmd->next;
-		cmd->next = NULL;
-		if (cmd == pACB->pQueryTail) pACB->pQueryTail = NULL;
-		pACB->QueryCnt--;
-		status = SCSI_ABORT_SUCCESS;
-		goto  ABO_X;
-	    }
-	    else
-	    {
-		pcmd = pcmd->next;
-	    }
-	}
+	struct scsi_cmnd_list *t, *pcmd_l;
+	list_for_each_entry_safe(pcmd_l, t, &pACB->cmdq, scp.list)
+		if( (struct scsi_cmnd*)pcmd_l == cmd )
+		{
+			/* Found: Dequeue */
+			list_del(&pcmd_l->scp.list);
+			pACB->QueryCnt--;
+			status = SCSI_ABORT_SUCCESS;
+			goto  ABO_X;
+		}
     }

     pDCB = dc390_findDCB (pACB, cmd->device->id, cmd->device->lun);
@@ -1624,7 +1550,7 @@
 IN_WAIT:
 	dc390_Free_insert (pACB, pSRB);
 	pDCB->WaitSRBCnt--;
-	cmd->next = NULL;
+	INIT_LIST_HEAD((struct list_head*)&cmd->SCp);
 	status = SCSI_ABORT_SUCCESS;
 	goto  ABO_X;
     }
@@ -1677,7 +1603,7 @@
 		//udelay (10000);
 		//DC390_read8 (INT_Status);
 		//DC390_write8 (ScsiCmd, EN_SEL_RESEL);
-	};
+	}
     sbac = DC390_read32 (DMA_ScsiBusCtrl);
     if (sbac & SCSI_BUSY)
     {	/* clear BSY, SEL and ATN */
@@ -1695,7 +1621,7 @@
 	DC390_write8 (ScsiCmd, NOP_CMD);
 	sbac = DC390_read32 (DMA_ScsiBusCtrl);
 	printk ("%08lx\n", sbac);
-    };
+    }
 #endif
     dc390_lastabortedpid = cmd->pid;
     DC390_UNLOCK_ACB;
@@ -1781,11 +1707,11 @@
  * Returns : 0 on success.
  ***********************************************************************/

-int DC390_reset (Scsi_Cmnd *cmd, unsigned int resetFlags)
+int DC390_reset (Scsi_Cmnd *cmd)
 {
     UCHAR   bval;
-    DC390_AFLAGS
     PACB    pACB = (PACB) cmd->device->host->hostdata;
+    DC390_AFLAGS;

     printk(KERN_INFO "DC390: RESET ... ");

@@ -1841,10 +1767,11 @@

     pDCB = kmalloc (sizeof(DC390_DCB), GFP_ATOMIC);
     DCBDEBUG(printk (KERN_INFO "DC390: alloc mem for DCB (ID %i, LUN %i): %p\n"	\
-	    id, lun, pDCB);)
+		     id, lun, pDCB));

-    *ppDCB = pDCB; pDCB2 = 0;
+    *ppDCB = pDCB;
     if (!pDCB) return;
+    pDCB2 = 0;
     if( pACB->DCBCnt == 0 )
     {
 	pACB->pLinkDCB = pDCB;
@@ -1853,7 +1780,7 @@
     else
     {
 	pACB->pLastDCB->pNextDCB = pDCB;
-    };
+    }

     pACB->DCBCnt++;

@@ -1925,21 +1852,21 @@
   } else {
 	pDCB->SyncMode &= ~EN_TAG_QUEUEING;
 	pDCB->MaxCommand = 1;
-  };
+  }

   if( pDCB->DevMode & SYNC_NEGO_ )
 	pDCB->SyncMode |= SYNC_ENABLE;
   else {
 	pDCB->SyncMode &= ~(SYNC_NEGO_DONE | SYNC_ENABLE);
 	pDCB->SyncOffset &= ~0x0f;
-  };
+  }

   //if (! (pDCB->DevMode & EN_DISCONNECT_)) pDCB->SyncMode &= ~EN_ATN_STOP;

   pDCB->CtrlR1 = pACB->pScsiHost->this_id;
   if( pDCB->DevMode & PARITY_CHK_ )
 	pDCB->CtrlR1 |= PARITY_ERR_REPO;
-};
+}


 /***********************************************************************
@@ -1956,8 +1883,8 @@
     {
       dc390_updateDCB (pACB, pDCB);
       pDCB = pDCB->pNextDCB;
-    };
-};
+    }
+}


 /***********************************************************************
@@ -2003,7 +1930,7 @@
 {
     PACB    pACB;
     UCHAR   i;
-    DC390_AFLAGS
+    DC390_AFLAGS;

     psh->can_queue = MAX_CMD_QUEUE;
     psh->cmd_per_lun = MAX_CMD_PER_LUN;
@@ -2021,15 +1948,13 @@
     psh->last_reset = jiffies;

     pACB = (PACB) psh->hostdata;
-    DC390_LOCKA_INIT;
-    DC390_LOCK_ACB;

     pACB->pScsiHost = psh;
     pACB->IOPortBase = (USHORT) io_port;
     pACB->IRQLevel = Irq;

     DEBUG0(printk (KERN_INFO "DC390: Adapter index %i, ID %i, IO 0x%08x, IRQ 0x%02x\n",	\
-	    index, psh->this_id, (int)io_port, Irq);)
+		   index, psh->this_id, (int)io_port, Irq));

     psh->max_id = 8;

@@ -2045,7 +1970,7 @@
     pACB->pFreeSRB = pACB->SRB_array;
     pACB->SRBCount = MAX_SRB_CNT;
     pACB->QueryCnt = 0;
-    pACB->pQueryHead = NULL;
+    INIT_LIST_HEAD(&pACB->cmdq);
     pACB->AdapterIndex = index;
     pACB->status = 0;
     psh->this_id = dc390_eepromBuf[index][EE_ADAPT_SCSI_ID];
@@ -2119,7 +2044,7 @@
 	dc390_pACB_current->pNextACB = pACB;
 	dc390_pACB_current = pACB;
 	pACB->pNextACB = NULL;
-      };
+      }

     DC390_write8 (CtrlReg1, DIS_INT_ON_SCSI_RST | psh->this_id);	/* Disable SCSI bus reset interrupt */

@@ -2133,7 +2058,7 @@
 	for( i=0; i<(500 + 1000*dc390_eepromBuf[pACB->AdapterIndex][EE_DELAY]); i++ )
 		udelay(1000);
 	 */
-    };
+    }
     pACB->ACBFlag = 0;
     DC390_read8 (INT_Status);				/* Reset Pending INT */

@@ -2176,7 +2101,7 @@
 {
     PSH   psh;
     PACB  pACB;
-    DC390_AFLAGS
+    DC390_AFLAGS;

     if (dc390_CheckEEpromCheckSum (PDEV, index))
     {
@@ -2224,20 +2149,18 @@
     }
 #endif

-    DEBUG0(printk(KERN_INFO "DC390: pSH = %8x,", (UINT) psh);)
-    DEBUG0(printk(" Index %02i,", index);)
+    DEBUG0(printk(KERN_INFO "DC390: pSH = %8x, Index %02i\n", (UINT) psh, index));

     dc390_initACB( psh, io_port, Irq, index );
-    pACB = (PACB) psh->hostdata;

     PDEVSET;

     if( !dc390_initAdapter( psh, io_port, Irq, index ) )
     {
-	DEBUG0(printk("\nDC390: pACB = %8x, pDCBmap = %8x, pSRB_array = %8x\n",\
-		(UINT) pACB, (UINT) pACB->DCBmap, (UINT) pACB->SRB_array);)
+	DEBUG0(printk("DC390: pACB = %8x, pDCBmap = %8x, pSRB_array = %8x\n",\
+		      (UINT) pACB, (UINT) pACB->DCBmap, (UINT) pACB->SRB_array));
 	DEBUG0(printk("DC390: ACB size= %4x, DCB size= %4x, SRB size= %4x\n",\
-		sizeof(DC390_ACB), sizeof(DC390_DCB), sizeof(DC390_SRB) );)
+		      sizeof(DC390_ACB), sizeof(DC390_DCB), sizeof(DC390_SRB) ));

 	DC390_UNLOCK_ACB;
         return (0);
@@ -2288,7 +2211,7 @@
 		PCI_WRITE_CONFIG_BYTE(PDEV, PCI_LATENCY_TIMER, 64);
 	}

-};
+}
 #endif /* ! NEW_PCI */

 static void __init dc390_set_pci_cfg (PDEVDECL)
@@ -2298,7 +2221,7 @@
 	cmd |= PCI_COMMAND_SERR | PCI_COMMAND_PARITY | PCI_COMMAND_IO;
 	PCI_WRITE_CONFIG_WORD (PDEV, PCI_COMMAND, cmd);
 	PCI_WRITE_CONFIG_WORD (PDEV, PCI_STATUS, (PCI_STATUS_SIG_SYSTEM_ERROR | PCI_STATUS_DETECTED_PARITY));
-};
+}


 int __init DC390_detect (Scsi_Host_Template *psht)
@@ -2306,10 +2229,7 @@
     PDEVDECL0;
     UCHAR   irq;
     UINT    io_port;
-    //DC390_IFLAGS
-    DC390_DFLAGS

-    DC390_LOCK_DRV;
     //dc390_pSHT_start = psht;
     dc390_pACB_start = NULL;

@@ -2320,17 +2240,15 @@
 	    if (pci_enable_device (pdev))
 		continue;
 #endif
-	    //DC390_LOCK_IO;		/* Remove this when going to new eh */
 	    PCI_GET_IO_AND_IRQ;
-	    DEBUG0(printk(KERN_INFO "DC390(%i): IO_PORT=%04x,IRQ=%x\n", dc390_adapterCnt, (UINT) io_port, irq);)
+	    DEBUG0(printk(KERN_INFO "DC390(%i): IO_PORT=%04x,IRQ=%x\n", dc390_adapterCnt, (UINT) io_port, irq));

 	    if( !DC390_init(psht, io_port, irq, PDEV, dc390_adapterCnt))
 	    {
 		PCI_SET_MASTER;
 		dc390_set_pci_cfg (PDEV);
 		dc390_adapterCnt++;
-	    };
-	    //DC390_UNLOCK_IO;		/* Remove when going to new eh */
+	    }
 	}
     else
 	printk (KERN_ERR "DC390: No PCI BIOS found!\n");
@@ -2342,7 +2260,6 @@
 	psht->proc_dir = &DC390_proc_scsi_tmscsim;
 #endif
     printk(KERN_INFO "DC390: %i adapters found\n", dc390_adapterCnt);
-    DC390_UNLOCK_DRV;
     return( dc390_adapterCnt );
 }

@@ -2368,17 +2285,17 @@
 	{
 		pDCB->DevMode &= ~(SYNC_NEGO_ | TAG_QUEUEING_ | EN_DISCONNECT_ );
 		dc390_updateDCB (pACB, pDCB);
-	};
-   };
+	}
+   }
    kfree (cmd);
-};
+}

 void dc390_inquiry (PACB pACB, PDCB pDCB)
 {
    char* buffer;
    Scsi_Cmnd* cmd;
    cmd = kmalloc (sizeof(Scsi_Cmnd) + 256, GFP_ATOMIC);
-   if (!cmd) { printk ("DC390: kmalloc failed in inquiry!\n"); return; };
+   if (!cmd) { printk ("DC390: kmalloc failed in inquiry!\n"); return; }
    buffer = (char*)cmd + sizeof(Scsi_Cmnd);

    memset (cmd, 0, sizeof(Scsi_Cmnd) + 256);
@@ -2401,13 +2318,13 @@
    cmd->scsi_done = dc390_inquiry_done;
    cmd->timeout_per_command = HZ;

-   cmd->request.rq_status = RQ_SCSI_BUSY;
+   cmd->request->rq_status = RQ_SCSI_BUSY;

    pDCB->SyncMode &= ~SYNC_NEGO_DONE;
    printk (KERN_INFO "DC390: Queue INQUIRY command to dev ID %02x LUN %02x\n",
 	   pDCB->TargetID, pDCB->TargetLUN);
    DC390_queue_command (cmd, dc390_inquiry_done);
-};
+}

 /***********************************************************************
  * Functions: dc390_sendstart(), dc390_sendstart_done()
@@ -2422,14 +2339,14 @@
    printk (KERN_INFO "DC390: SENDSTART (ID %02x LUN %02x) returned %08x\n",
 	   cmd->device->id, cmd->device->lun, cmd->result);
    kfree (cmd);
-};
+}

 void dc390_sendstart (PACB pACB, PDCB pDCB)
 {
    char* buffer;
    Scsi_Cmnd* cmd;
    cmd = kmalloc (sizeof(Scsi_Cmnd) + 256, GFP_ATOMIC);
-   if (!cmd) { printk ("DC390: kmalloc failed in sendstart!\n"); return; };
+   if (!cmd) { printk ("DC390: kmalloc failed in sendstart!\n"); return; }
    buffer = (char*)cmd + sizeof(Scsi_Cmnd);

    memset (cmd, 0, sizeof(Scsi_Cmnd) + 256);
@@ -2452,13 +2369,13 @@
    cmd->scsi_done = dc390_sendstart_done;
    cmd->timeout_per_command = 5*HZ;

-   cmd->request.rq_status = RQ_SCSI_BUSY;
+   cmd->request->rq_status = RQ_SCSI_BUSY;

    pDCB->SyncMode &= ~SYNC_NEGO_DONE;
    printk (KERN_INFO "DC390: Queue SEND_START command to dev ID %02x LUN %02x\n",
 	   pDCB->TargetID, pDCB->TargetLUN);
    DC390_queue_command (cmd, dc390_sendstart_done);
-};
+}

 /********************************************************************
  * Function: dc390_set_info()
@@ -2476,7 +2393,7 @@
    if (*p0 == *pos) return -1;
    *pos = strsep (buffer, " \t\n:=,;.");
    return 0;
-};
+}

 #define SCANF(buffer, pos, p0, var, min, max)		\
 if (dc390_scanf (&buffer, &pos, &p0, &var)) goto einv;	\
@@ -2493,12 +2410,12 @@
      }
    *pos = strsep (buffer, " \t\n:=,;");
    return 0;
-};
+}

-#define YESNO(buffer, pos, var, bmask)			\
-if (dc390_yesno (&buffer, &pos, &var, bmask)) goto einv;	\
-else dc390_updateDCB (pACB, pDCB);		\
-if (!p) goto ok
+#define YESNO(buffer, pos, var, bmask)					\
+	if (dc390_yesno (&buffer, &pos, &var, bmask)) goto einv;	\
+	else dc390_updateDCB (pACB, pDCB);				\
+	if (!pos) goto ok

 static int dc390_search (char** buffer, char** pos, char** p0, char* var, char* txt, int max, int scale, char* ign)
 {
@@ -2519,7 +2436,7 @@

      }
    return 0;
-};
+}

 #define SEARCH(buffer, pos, p0, var, txt, max)						\
 if (dc390_search (&buffer, &pos, &p0, (PUCHAR)(&var), txt, max, 100, "")) goto einv2;	\
@@ -2545,7 +2462,7 @@
      else *c++ = *p++;
    *c = 0;
    return _prstr;
-};
+}
 #endif

 int dc390_set_info (char *buffer, int length, PACB pACB)
@@ -2555,16 +2472,16 @@
   int dum = 0;
   char dev;
   PDCB pDCB = pACB->pLinkDCB;
-  DC390_IFLAGS
-  DC390_AFLAGS
+  DC390_IFLAGS;
+  DC390_AFLAGS;
   pos[length] = 0;

-  DC390_LOCK_IO(pACB.pScsiHost);
+  DC390_LOCK_IO(pACB->pScsiHost);
   DC390_LOCK_ACB;
   /* UPPERCASE */
   /* Don't use kernel toupper, because of 2.0.x bug: ctmp unexported */
   while (*pos)
-    { if (*pos >='a' && *pos <= 'z') *pos = *pos + 'A' - 'a'; pos++; };
+    { if (*pos >='a' && *pos <= 'z') *pos = *pos + 'A' - 'a'; pos++; }

   /* Remove WS */
   pos = strsep (&buffer, " \t:\n=,;");
@@ -2589,7 +2506,7 @@
       if (*pos) { SCANF (buffer, pos, p0, lun, 0, 7); } else goto einv;
       if (!*pos) goto einv;

-      PARSEDEBUG(printk (KERN_INFO "DC390: config line %i %i %i:\"%s\"\n", dev, id, lun, prstr (pos, &buffer[length]));)
+      PARSEDEBUG(printk (KERN_INFO "DC390: config line %i %i %i:\"%s\"\n", dev, id, lun, prstr (pos, &buffer[length])));
       pDCB = pACB->pLinkDCB;
       for (dum = 0; dum < dev; dum++) pDCB = pDCB->pNextDCB;
       /* Sanity Check */
@@ -2598,14 +2515,14 @@
 	    printk (KERN_ERR "DC390: no such device: Idx=%02i ID=%02i LUN=%02i\n",
 		    dev, id, lun);
 	    goto einv2;
-	 };
+	 }

       if (pDCB->pWaitingSRB || pDCB->pGoingSRB)
       {
 	  printk ("DC390: Cannot change dev (%i-%i) cfg: Pending requests\n",
 		  pDCB->TargetID, pDCB->TargetLUN);
 	  goto einv;
-      };
+      }

       olddevmode = pDCB->DevMode;
       YESNO (buffer, pos, pDCB->DevMode, PARITY_CHK_);
@@ -2634,9 +2551,9 @@
 	  pDCB->NegoPeriod = dum >> 2;
 	  if (pDCB->NegoPeriod != olddevmode) needs_inquiry++;
 	  if (!pos) goto ok;
-	  if (memcmp (pos, "NS", 2) == 0) pos = strsep (*pos, " \t\n:=,;.");
+	  if (memcmp (pos, "NS", 2) == 0) pos = strsep (&pos, " \t\n:=,;.");
 	}
-      else pos = strsep (*pos, " \t\n:=,;.");
+      else pos = strsep (&pos, " \t\n:=,;.");
       if (!*pos) goto ok;

       /* Sync Speed in MHz */
@@ -2654,13 +2571,13 @@
 		for (; p0-pos > 1; p0--) dum /= 10;
 		pDCB->NegoPeriod = (100000/(100*dumold + dum)) >> 2;
 		if (pDCB->NegoPeriod < 19) pDCB->NegoPeriod = 19;
-		pos = strsep (*pos, " \t\n:=,;");
+		pos = strsep (&pos, " \t\n:=,;");
 		if (!*pos) goto ok;
-	     };
-	  if (*pos == 'M') pos = strsep (*pos, " \t\n:=,;");
+	     }
+	  if (*pos == 'M') pos = strsep (&pos, " \t\n:=,;");
 	  if (pDCB->NegoPeriod != olddevmode) needs_inquiry++;
 	}
-      else pos = strsep (*pos, " \t\n:=,;");
+      else pos = strsep (&pos, " \t\n:=,;");
       /* dc390_updateDCB (pACB, pDCB); */
       if (!*pos) goto ok;

@@ -2672,7 +2589,7 @@
 	  pDCB->SyncOffset = dum;
 	  if (pDCB->SyncOffset > olddevmode) needs_inquiry++;
 	}
-      else pos = strsep (*pos, " \t\n:=,;");
+      else pos = strsep (&pos, " \t\n:=,;");
       if (!*pos) goto ok;
       dc390_updateDCB (pACB, pDCB);

@@ -2685,13 +2602,13 @@
 		pDCB->MaxCommand = dum;
 	  else printk (KERN_INFO "DC390: Can't set MaxCmd larger than one without Tag Queueing!\n");
 	}
-      else pos = strsep (*pos, " \t\n:=,;");
+      else pos = strsep (&pos, " \t\n:=,;");

     }
   else
     {
       char* p1 = pos; UCHAR dum, newadaptid;
-      PARSEDEBUG(printk (KERN_INFO "DC390: chg adapt cfg \"%s\"\n", prstr (pos, &buffer[length]));)
+      PARSEDEBUG(printk (KERN_INFO "DC390: chg adapt cfg \"%s\"\n", prstr (pos, &buffer[length])));
       dum = GLITCH_TO_NS (pACB->glitch_cfg);
       /* Adapter setting */
       SEARCH (buffer, pos, p0, pACB->pScsiHost->max_id, "MAXID", 8);
@@ -2722,15 +2639,15 @@
  ok:
   DC390_UNLOCK_ACB;
   if (needs_inquiry)
-     { dc390_updateDCB (pACB, pDCB); dc390_inquiry (pACB, pDCB); };
-  DC390_UNLOCK_IO(pACB.pScsiHost);
+     { dc390_updateDCB (pACB, pDCB); dc390_inquiry (pACB, pDCB); }
+  DC390_UNLOCK_IO(pACB->pScsiHost);
   return (length);

  einv2:
   pos = p0;
  einv:
   DC390_UNLOCK_ACB;
-  DC390_UNLOCK_IO(pACB.pScsiHost);
+  DC390_UNLOCK_IO(pACB->pScsiHost);
   printk (KERN_WARNING "DC390: parse error near \"%s\"\n", (pos? pos: "NULL"));
   return (-EINVAL);

@@ -2741,22 +2658,22 @@
 	/* cmd.host = pACB->pScsiHost; */
 	printk (KERN_WARNING "DC390: Driver reset requested!\n");
 	DC390_UNLOCK_ACB;
-	DC390_reset (&cmd, 0);
-	DC390_UNLOCK_IO(pACB.pScsiHost);
-     };
+	DC390_reset (&cmd);
+	DC390_UNLOCK_IO(pACB->pScsiHost);
+     }
   return (length);

  dump:
      {
 	dc390_dumpinfo (pACB, 0, 0);
 	DC390_UNLOCK_ACB;
-	DC390_UNLOCK_IO(pACB.pScsiHost);
+	DC390_UNLOCK_IO(pACB->pScsiHost);
      }
   return (length);

  inquiry:
      {
-	pos = strsep (*pos, " \t\n.:;="); if (!*pos) goto einv;
+	pos = strsep (&pos, " \t\n.:;="); if (!*pos) goto einv;
 	dev = simple_strtoul (pos, &p0, 10);
 	if (dev >= pACB->DCBCnt) goto einv_dev;
 	for (dum = 0; dum < dev; dum++) pDCB = pDCB->pNextDCB;
@@ -2764,13 +2681,13 @@
 		dev, pDCB->TargetID, pDCB->TargetLUN);
 	DC390_UNLOCK_ACB;
 	dc390_inquiry (pACB, pDCB);
-	DC390_UNLOCK_IO(pACB.pScsiHost);
-     };
+	DC390_UNLOCK_IO(pACB->pScsiHost);
+     }
    return (length);

  remove:
      {
-	pos = strsep (*pos, " \t\n.:;="); if (!*pos) goto einv;
+	pos = strsep (&pos, " \t\n.:;="); if (!*pos) goto einv;
 	dev = simple_strtoul (pos, &p0, 10);
 	if (dev >= pACB->DCBCnt) goto einv_dev;
 	for (dum = 0; dum < dev; dum++) pDCB = pDCB->pNextDCB;
@@ -2779,29 +2696,29 @@
 	/* TO DO: We should make sure no pending commands are left */
 	dc390_remove_dev (pACB, pDCB);
 	DC390_UNLOCK_ACB;
-	DC390_UNLOCK_IO(pACB.pScsiHost);
-     };
+	DC390_UNLOCK_IO(pACB->pScsiHost);
+     }
    return (length);

  add:
      {
 	int id, lun;
-	pos = strsep (*pos, " \t\n.:;=");
+	pos = strsep (&pos, " \t\n.:;=");
 	if (*pos) { SCANF (buffer, pos, p0, id, 0, 7); } else goto einv;
 	if (*pos) { SCANF (buffer, pos, p0, lun, 0, 7); } else goto einv;
 	pDCB = dc390_findDCB (pACB, id, lun);
-	if (pDCB) { printk ("DC390: ADD: Device already existing\n"); goto einv; };
+	if (pDCB) { printk ("DC390: ADD: Device already existing\n"); goto einv; }
 	dc390_initDCB (pACB, &pDCB, id, lun);
 	DC390_UNLOCK_ACB;
 	dc390_inquiry (pACB, pDCB);
-	DC390_UNLOCK_IO(pACB.pScsiHost);
-     };
+	DC390_UNLOCK_IO(pACB->pScsiHost);
+     }
    return (length);

  start:
      {
 	int id, lun;
-	pos = strsep (*pos, " \t\n.:;=");
+	pos = strsep (&pos, " \t\n.:;=");
 	if (*pos) { SCANF (buffer, pos, p0, id, 0, 7); } else goto einv;
 	if (*pos) { SCANF (buffer, pos, p0, lun, 0, 7); } else goto einv;
 	pDCB = dc390_findDCB (pACB, id, lun);
@@ -2810,18 +2727,16 @@
 	DC390_UNLOCK_ACB;
 	dc390_sendstart (pACB, pDCB);
 	dc390_inquiry (pACB, pDCB);
-	DC390_UNLOCK_IO(pACB.pScsiHost);
-     };
+	DC390_UNLOCK_IO(pACB->pScsiHost);
+     }
    return (length);

  einv_dev:
    printk (KERN_WARNING "DC390: Ignore cmnd to invalid Dev(Idx) %i. Valid range: 0 - %i.\n",
 	   dev, pACB->DCBCnt - 1);
    DC390_UNLOCK_ACB;
-   DC390_UNLOCK_IO(pACB.pScsiHost);
+   DC390_UNLOCK_IO(pACB->pScsiHost);
    return (-EINVAL);
-
-
 }

 #undef SEARCH
@@ -2860,10 +2775,10 @@
 {
   int dev, spd, spd1;
   char *pos = buffer;
+  struct scsi_cmnd_list *cl;
   PACB pACB;
   PDCB pDCB;
-  PSCSICMD pcmd;
-  DC390_AFLAGS
+  DC390_AFLAGS;

   pACB = dc390_pACB_start;

@@ -2932,8 +2847,8 @@
       pDCB = pDCB->pNextDCB;
      }
     SPRINTF ("Commands in Queues: Query: %li:", pACB->QueryCnt);
-    for (pcmd = pACB->pQueryHead; pcmd; pcmd = pcmd->next)
-	SPRINTF (" %li", pcmd->pid);
+    list_for_each_entry(cl, &pACB->cmdq, scp.list)
+	SPRINTF (" %li", ((struct scsi_cmnd*)cl)->pid);
     if (timer_pending(&pACB->Waiting_Timer)) SPRINTF ("Waiting queue timer running\n");
     else SPRINTF ("\n");
     pDCB = pACB->pLinkDCB;
@@ -2983,8 +2898,6 @@
 #undef YESNO
 #undef SPRINTF

-#ifdef MODULE
-
 /***********************************************************************
  * Function : static int dc390_shutdown (struct Scsi_Host *host)
  *
@@ -3024,17 +2937,17 @@
     {
 	nDCB = pDCB->pNextDCB;
 	DCBDEBUG(printk (KERN_INFO "DC390: Free DCB (ID %i, LUN %i): %p\n",\
-		pDCB->TargetID, pDCB->TargetLUN, pDCB);)
+			 pDCB->TargetID, pDCB->TargetLUN, pDCB));
 	//kfree (pDCB);
 	dc390_remove_dev (pACB, pDCB);
 	pDCB = nDCB;
     } while (pDCB && pACB->pLinkDCB);

-};
+}

 int DC390_release (struct Scsi_Host *host)
 {
-    DC390_AFLAGS DC390_IFLAGS
+    DC390_AFLAGS DC390_IFLAGS;
     PACB pACB = (PACB)(host->hostdata);

     DC390_LOCK_IO(host);
@@ -3045,7 +2958,7 @@

     if (host->irq != SCSI_IRQ_NONE)
     {
-	DEBUG0(printk(KERN_INFO "DC390: Free IRQ %i\n",host->irq);)
+	DEBUG0(printk(KERN_INFO "DC390: Free IRQ %i\n",host->irq));
 	free_irq (host->irq, pACB);
     }

@@ -3055,17 +2968,16 @@
     DC390_UNLOCK_IO(host);
     return( 1 );
 }
-#endif /* def MODULE */

-static Scsi_Host_Template driver_template = DC390_T;
+static Scsi_Host_Template driver_template = {
    .proc_name      = "tmscsim",
    .proc_info      = DC390_proc_info,
    .name           = DC390_BANNER " V" DC390_VERSION,
    .detect         = DC390_detect,
    .release        = DC390_release,
    .queuecommand   = DC390_queue_command,
-   .abort          = DC390_abort,
-   .reset          = DC390_reset,
+   .eh_abort_handler		= DC390_abort,
+   .eh_bus_reset_handler	= DC390_reset,
    .bios_param     = DC390_bios_param,
    .can_queue      = 42,
    .this_id        = 7,
diff -ur linux-2.6.0-test7.arm/drivers/scsi/tmscsim.h linux-2.6.0-test7/drivers/scsi/tmscsim.h
--- linux-2.6.0-test7.arm/drivers/scsi/tmscsim.h	Sat Aug  9 06:40:56 2003
+++ linux-2.6.0-test7/drivers/scsi/tmscsim.h	Sat Nov 22 23:40:35 2003
@@ -24,6 +24,8 @@

 #define END_SCAN		2

+#define pci_dma_lo32(a)			(a & 0xffffffff)
+
 typedef u8		UCHAR;	/*  8 bits */
 typedef u16		USHORT;	/* 16 bits */
 typedef u32		UINT;	/* 32 bits */
@@ -213,8 +215,7 @@

 /* 0x2c: */
 ULONG		QueryCnt;
-PSCSICMD	pQueryHead;
-PSCSICMD	pQueryTail;
+struct list_head	cmdq;

 /* 0x38: */
 UCHAR		msgin123[4];
@@ -400,6 +401,20 @@

 /*;----SCSI MSG BYTE*/ /* see scsi/scsi.h */ /* One is missing ! */
 #define ABORT_TAG	0x0d
+
+/*
+ *	SISC query queue
+ */
+typedef struct {
+	struct list_head	list;
+	dma_addr_t		saved_dma_handle;
+} dc390_cmd_scp_t;
+
+struct scsi_cmnd_list
+{
+	char dummy[offsetof(struct scsi_cmnd, SCp)];
+	dc390_cmd_scp_t scp;
+};

 /*
 **  Inquiry Data format

