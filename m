From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] tmscsim EH fixes
Date: Thu, 24 Jun 2004 12:40:52 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040624104052.GA9648@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:16294 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S264198AbUFXKk7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Jun 2004 06:40:59 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: g.liakhovetski@gmx.de
Cc: linux-scsi@vger.kernel.org

 - there's a few places doing command completion from the error handler
   because if checks for USE_NEW_EH which isn't defined for us, remove
   those
 - the reset and abort routines still return the old EH return values,
   fixed
 - streamlined the abort/reset routines and made them more easily
   readable
 - switch to <scsi/scsi*.h> includes now that the old EH retvals are
   gone
 - kill dc390.h

(needs the two previous patches)


--- 1.13/drivers/scsi/dc390.h	2004-05-28 00:57:23 +02:00
+++ edited/drivers/scsi/dc390.h	2004-06-24 11:37:34 +02:00
@@ -1,32 +0,0 @@
-/***********************************************************************
- *	FILE NAME : DC390.H					       *
- *	     BY   : C.L. Huang					       *
- *	Description: Device Driver for Tekram DC-390(T) PCI SCSI       *
- *		     Bus Master Host Adapter			       *
- ***********************************************************************/
-/* $Id: dc390.h,v 2.43.2.22 2000/12/20 00:39:36 garloff Exp $ */
-
-/*
- * DC390/AMD 53C974 driver, header file
- */
-
-#ifndef DC390_H
-#define DC390_H
-
-#include <linux/version.h>
-
-#define DC390_BANNER "Tekram DC390/AM53C974"
-#define DC390_VERSION "2.1d 2004-05-27"
-
-/* We don't have eh_abort_handler, eh_device_reset_handler, 
- * eh_bus_reset_handler, eh_host_reset_handler yet! 
- * So long: Use old exception handling :-( */
-#define OLD_EH
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION (2,1,70) || defined (OLD_EH)
-# define NEW_EH
-#else
-# define NEW_EH use_new_eh_code: 1,
-# define USE_NEW_EH
-#endif
-#endif /* DC390_H */
--- 1.16/drivers/scsi/scsiiom.c	2004-06-24 10:17:22 +02:00
+++ edited/drivers/scsi/scsiiom.c	2004-06-24 11:36:38 +02:00
@@ -1586,18 +1586,6 @@
 	    psrb2 = psrb->pNextSRB;
 	    pcmd = psrb->pcmd;
 	    dc390_Free_insert (pACB, psrb);
-#ifndef USE_NEW_EH
-	    /* New EH will crash on being given timed out cmnds */
-	    if (pcmd == cmd)
-		pcmd->result = MK_RES(0,DID_ABORT,0,0);
-	    else
-		pcmd->result = MK_RES(0,DID_RESET,0,0);
-
-/*	    ReleaseSRB( pDCB, pSRB ); */
-
-	    DEBUG0(printk (KERN_DEBUG "DC390: DoingSRB_Done: done pid %li\n", pcmd->pid));
-	    pcmd->scsi_done( pcmd );
-#endif	
 	    psrb  = psrb2;
 	}
 	pdcb->GoingSRBCnt = 0;
--- 1.43/drivers/scsi/tmscsim.c	2004-06-24 10:17:22 +02:00
+++ edited/drivers/scsi/tmscsim.c	2004-06-24 12:03:12 +02:00
@@ -240,17 +240,15 @@
 #include <linux/spinlock.h>
 #include <asm/io.h>
 
-#if 0
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
-#else
-#include "scsi.h"
-#endif
 #include <scsi/scsi_host.h>
 #include <scsi/scsicam.h>
 
-#include "dc390.h"
+
+#define DC390_BANNER "Tekram DC390/AM53C974"
+#define DC390_VERSION "2.1d 2004-05-27"
 
 #define PCI_DEVICE_ID_AMD53C974 	PCI_DEVICE_ID_AMD_SCSI
 
@@ -304,7 +302,6 @@
 
 static PACB	dc390_pACB_start= NULL;
 static PACB	dc390_pACB_current = NULL;
-static ULONG	dc390_lastabortedpid = 0;
 static UINT	dc390_laststatus = 0;
 static UCHAR	dc390_adapterCnt = 0;
 
@@ -1218,150 +1215,54 @@
     printk ("DC390: In case of driver trouble read linux/Documentation/scsi/tmscsim.txt\n");
 }
 
+static int DC390_abort(struct scsi_cmnd *cmd)
+{
+	PACB pACB = (PACB) cmd->device->host->hostdata;
+	PDCB pDCB = (PDCB) cmd->device->hostdata;
+	PSRB pSRB, psrb;
 
-/***********************************************************************
- * Function : int DC390_abort (struct scsi_cmnd *cmd)
- *
- * Purpose : Abort an errant SCSI command
- *
- * Inputs : cmd - command to abort
- *
- * Returns : 0 on success, -1 on failure.
- *
- * Status: Buggy !
- ***********************************************************************/
+	printk("DC390: Abort command (pid %li, Device %02i-%02i)\n",
+			cmd->pid, cmd->device->id, cmd->device->lun);
 
-static int DC390_abort (struct scsi_cmnd *cmd)
-{
-    PDCB  pDCB = (PDCB) cmd->device->hostdata;
-    PSRB  pSRB, psrb;
-    UINT  count, i;
-    int   status;
-    //ULONG sbac;
-    PACB  pACB = (PACB) cmd->device->host->hostdata;
-
-    printk ("DC390: Abort command (pid %li, Device %02i-%02i)\n",
-	    cmd->pid, cmd->device->id, cmd->device->lun);
-
-    if( !pDCB ) goto  NOT_RUN;
-
-    /* Added 98/07/02 KG */
-    /*
-    pSRB = pDCB->pActiveSRB;
-    if (pSRB && pSRB->pcmd == cmd )
-	goto ON_GOING;
-     */
-    
-    pSRB = pDCB->pWaitingSRB;
-    if( !pSRB )
-	goto  ON_GOING;
+	pSRB = pDCB->pWaitingSRB;
+	if (!pSRB)
+		goto on_going;
 
-    /* Now scan Waiting queue */
-    if( pSRB->pcmd == cmd )
-    {
-	pDCB->pWaitingSRB = pSRB->pNextSRB;
-	goto  IN_WAIT;
-    }
-    else
-    {
-	psrb = pSRB;
-	if( !(psrb->pNextSRB) )
-	    goto ON_GOING;
-	while( psrb->pNextSRB->pcmd != cmd )
-	{
-	    psrb = psrb->pNextSRB;
-	    if( !(psrb->pNextSRB) || psrb == pSRB)
-		goto ON_GOING;
-	}
-	pSRB = psrb->pNextSRB;
-	psrb->pNextSRB = pSRB->pNextSRB;
-	if( pSRB == pDCB->pWaitLast )
-	    pDCB->pWaitLast = psrb;
-IN_WAIT:
-	dc390_Free_insert (pACB, pSRB);
+	/* Now scan Waiting queue */
+	if (pSRB->pcmd != cmd) {
+		psrb = pSRB;
+		if (!(psrb->pNextSRB))
+			goto on_going;
+
+		while (psrb->pNextSRB->pcmd != cmd) {
+			psrb = psrb->pNextSRB;
+			if (!(psrb->pNextSRB) || psrb == pSRB)
+				goto on_going;
+		}
+		
+		pSRB = psrb->pNextSRB;
+		psrb->pNextSRB = pSRB->pNextSRB;
+		if (pSRB == pDCB->pWaitLast)
+			pDCB->pWaitLast = psrb;
+	} else
+		pDCB->pWaitingSRB = pSRB->pNextSRB;
+
+	dc390_Free_insert(pACB, pSRB);
 	pDCB->WaitSRBCnt--;
 	INIT_LIST_HEAD((struct list_head*)&cmd->SCp);
-	status = SCSI_ABORT_SUCCESS;
-	goto  ABO_X;
-    }
-
-    /* SRB has already been sent ! */
-ON_GOING:
-    /* abort() is too stupid for already sent commands at the moment. 
-     * If it's called we are in trouble anyway, so let's dump some info 
-     * into the syslog at least. (KG, 98/08/20,99/06/20) */
-    dc390_dumpinfo (pACB, pDCB, pSRB);
-    pSRB = pDCB->pGoingSRB;
-    pDCB->DCBFlag |= ABORT_DEV_;
-    /* Now for the hard part: The command is currently processed */
-    for( count = pDCB->GoingSRBCnt, i=0; i<count; i++)
-    {
-	if( pSRB->pcmd != cmd )
-	    pSRB = pSRB->pNextSRB;
-	else
-	{
-	    if( (pACB->pActiveDCB == pDCB) && (pDCB->pActiveSRB == pSRB) )
-	    {
-		status = SCSI_ABORT_BUSY;
-		printk ("DC390: Abort current command (pid %li, SRB %p)\n",
-			cmd->pid, pSRB);
-		goto  ABO_X;
-	    }
-	    else
-	    {
-		status = SCSI_ABORT_SNOOZE;
-		goto  ABO_X;
-	    }
-	}
-    }
+	return SUCCESS;
 
-NOT_RUN:
-    status = SCSI_ABORT_NOT_RUNNING;
-
-ABO_X:
-    cmd->result = DID_ABORT << 16;
-    printk(KERN_INFO "DC390: Aborted pid %li with status %i\n", cmd->pid, status);
-#if 0
-    if (cmd->pid == dc390_lastabortedpid) /* repeated failure ? */
-	{
-		/* Let's do something to help the bus getting clean again */
-		DC390_write8 (DMA_Cmd, DMA_IDLE_CMD);
-		DC390_write8 (ScsiCmd, DMA_COMMAND);
-		//DC390_write8 (ScsiCmd, CLEAR_FIFO_CMD);
-		//DC390_write8 (ScsiCmd, RESET_ATN_CMD);
-		DC390_write8 (ScsiCmd, NOP_CMD);
-		//udelay (10000);
-		//DC390_read8 (INT_Status);
-		//DC390_write8 (ScsiCmd, EN_SEL_RESEL);
-	}
-    sbac = DC390_read32 (DMA_ScsiBusCtrl);
-    if (sbac & SCSI_BUSY)
-    {	/* clear BSY, SEL and ATN */
-	printk (KERN_WARNING "DC390: Reset SCSI device: ");
-	//DC390_write32 (DMA_ScsiBusCtrl, (sbac | SCAM) & ~SCSI_LINES);
-	//udelay (250);
-	//sbac = DC390_read32 (DMA_ScsiBusCtrl);
-	//printk ("%08lx ", sbac);
-	//DC390_write32 (DMA_ScsiBusCtrl, sbac & ~(SCSI_LINES | SCAM));
-	//udelay (100);
-	//sbac = DC390_read32 (DMA_ScsiBusCtrl);
-	//printk ("%08lx ", sbac);
-	DC390_write8 (ScsiCmd, RST_DEVICE_CMD);
-	udelay (250);
-	DC390_write8 (ScsiCmd, NOP_CMD);
-	sbac = DC390_read32 (DMA_ScsiBusCtrl);
-	printk ("%08lx\n", sbac);
-    }
-#endif
-    dc390_lastabortedpid = cmd->pid;
-    //do_DC390_Interrupt (pACB->IRQLevel, 0, 0);
-#ifndef USE_NEW_EH	
-    if (status == SCSI_ABORT_SUCCESS) cmd->scsi_done(cmd);
-#endif	
-    return( status );
+ on_going:
+	/* abort() is too stupid for already sent commands at the moment. 
+	 * * If it's called we are in trouble anyway, so let's dump some info 
+	 * into the syslog at least. (KG, 98/08/20,99/06/20) */
+	dc390_dumpinfo(pACB, pDCB, pSRB);
+
+	pDCB->DCBFlag |= ABORT_DEV_;
+	printk(KERN_INFO "DC390: Aborted pid %li\n", cmd->pid);
+	return FAILED;
 }
 
-
 static void dc390_ResetDevParam( PACB pACB )
 {
     PDCB   pDCB, pdcb;
@@ -1385,93 +1286,38 @@
 
 }
 
-#if 0
-/* Moves all SRBs from Going to Waiting for all DCBs */
-static void dc390_RecoverSRB( PACB pACB )
+static int DC390_bus_reset(struct scsi_cmnd *cmd)
 {
-    PDCB   pDCB, pdcb;
-    PSRB   psrb, psrb2;
-    UINT   cnt, i;
+	PACB    pACB = (PACB) cmd->device->host->hostdata;
+	UCHAR   bval;
 
-    pDCB = pACB->pLinkDCB;
-    if( !pDCB ) return;
-    pdcb = pDCB;
-    do
-    {
-	cnt = pdcb->GoingSRBCnt;
-	psrb = pdcb->pGoingSRB;
-	for (i=0; i<cnt; i++)
-	{
-	    psrb2 = psrb;
-	    psrb = psrb->pNextSRB;
-/*	    dc390_RewaitSRB( pDCB, psrb ); */
-	    if( pdcb->pWaitingSRB )
-	    {
-		psrb2->pNextSRB = pdcb->pWaitingSRB;
-		pdcb->pWaitingSRB = psrb2;
-	    }
-	    else
-	    {
-		pdcb->pWaitingSRB = psrb2;
-		pdcb->pWaitLast = psrb2;
-		psrb2->pNextSRB = NULL;
-	    }
-	}
-	pdcb->GoingSRBCnt = 0;
-	pdcb->pGoingSRB = NULL;
-	pdcb->TagMask = 0;
-	pdcb = pdcb->pNextDCB;
-    } while( pdcb != pDCB );
-}
-#endif
+	del_timer(&pACB->Waiting_Timer);
+	
+	bval = DC390_read8(CtrlReg1) | DIS_INT_ON_SCSI_RST;
+	DC390_write8(CtrlReg1, bval);/* disable IRQ on bus reset */
 
-/***********************************************************************
- * Function : int DC390_reset (struct scsi_cmnd *cmd, ...)
- *
- * Purpose : perform a hard reset on the SCSI bus
- *
- * Inputs : cmd - command which caused the SCSI RESET
- *	    resetFlags - how hard to try
- *
- * Returns : 0 on success.
- ***********************************************************************/
+	pACB->ACBFlag |= RESET_DEV;
+	dc390_ResetSCSIBus(pACB);
 
-static int DC390_reset (struct scsi_cmnd *cmd)
-{
-    UCHAR   bval;
-    PACB    pACB = (PACB) cmd->device->host->hostdata;
+	dc390_ResetDevParam(pACB);
+	udelay(1000);
+	pACB->pScsiHost->last_reset = jiffies + 3*HZ/2 
+		+ HZ * dc390_eepromBuf[pACB->AdapterIndex][EE_DELAY];
 
-    printk(KERN_INFO "DC390: RESET ... ");
+	DC390_write8(ScsiCmd, CLEAR_FIFO_CMD);
+	DC390_read8(INT_Status);		/* Reset Pending INT */
 
-    if (timer_pending (&pACB->Waiting_Timer)) del_timer (&pACB->Waiting_Timer);
-    bval = DC390_read8 (CtrlReg1);
-    bval |= DIS_INT_ON_SCSI_RST;
-    DC390_write8 (CtrlReg1, bval);	/* disable IRQ on bus reset */
-
-    pACB->ACBFlag |= RESET_DEV;
-    dc390_ResetSCSIBus( pACB );
-
-    dc390_ResetDevParam( pACB );
-    udelay (1000);
-    pACB->pScsiHost->last_reset = jiffies + 3*HZ/2 
-		+ HZ * dc390_eepromBuf[pACB->AdapterIndex][EE_DELAY];
-    
-    DC390_write8 (ScsiCmd, CLEAR_FIFO_CMD);
-    DC390_read8 (INT_Status);		/* Reset Pending INT */
+	dc390_DoingSRB_Done(pACB, cmd);
 
-    dc390_DoingSRB_Done( pACB, cmd );
-    /* dc390_RecoverSRB (pACB); */
-    pACB->pActiveDCB = NULL;
+	pACB->pActiveDCB = NULL;
+	pACB->ACBFlag = 0;
 
-    pACB->ACBFlag = 0;
-    bval = DC390_read8 (CtrlReg1);
-    bval &= ~DIS_INT_ON_SCSI_RST;
-    DC390_write8 (CtrlReg1, bval);	/* re-enable interrupt */
+	bval = DC390_read8(CtrlReg1) & ~DIS_INT_ON_SCSI_RST;
+	DC390_write8 (CtrlReg1, bval);	/* re-enable interrupt */
 
-    dc390_Waiting_process( pACB );
+	dc390_Waiting_process(pACB);
 
-    printk("done\n");
-    return( SCSI_RESET_SUCCESS );
+	return SUCCESS;
 }
 
 #include "scsiiom.c"
@@ -1825,7 +1671,7 @@
 	.slave_destroy		= dc390_slave_destroy,
 	.queuecommand		= DC390_queue_command,
 	.eh_abort_handler	= DC390_abort,
-	.eh_bus_reset_handler	= DC390_reset,
+	.eh_bus_reset_handler	= DC390_bus_reset,
 	.bios_param		= DC390_bios_param,
 	.can_queue		= 42,
 	.this_id		= 7,
