From: Oliver Neukum <oliver@neukum.org>
Subject: [PATCH 3/3]DC395: Debugging cleanups
Date: Tue, 27 May 2003 22:38:44 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200305272238.44900.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Mail1.kontent.de ([81.88.34.36]:13013 "EHLO Mail1.KONTENT.De")
	by vger.kernel.org with ESMTP id S264104AbTE0U3H convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 May 2003 16:29:07 -0400
Received: from pD9E4D453.dip.t-dialin.net (pD9E4D453.dip.t-dialin.net [217.228.212.83])
	by Mail1.KONTENT.De (Postfix) with ESMTP id 0898913BD8B
	for <linux-scsi@vger.kernel.org>; Tue, 27 May 2003 22:42:30 +0200 (CEST)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

further cleanups.

	Regards
		Oliver


diff -Nru a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c	Tue May 27 13:14:28 2003
+++ b/drivers/scsi/dc395x.c	Tue May 27 13:14:28 2003
@@ -3128,13 +3055,13 @@
 	bval =3D DC395x_read8(TRM_S1040_SCSI_FIFOCNT);
 	if (!(bval & 0x40)) {
 		bval &=3D 0x1f;
-		printk(DC395X_NAME
-		       ": DIP0(%li): %i bytes in SCSI FIFO (stat %04x) (left %08x)!!=
\n",
+		dprintkl(KERN_DEBUG,
+		       "DIP0(%li): %i bytes in SCSI FIFO (stat %04x) (left %08x)!!\n=
",
 		       pSRB->pcmd->pid, bval & 0x1f, scsi_status,
 		       dLeftCounter);
 		if ((dLeftCounter =3D=3D 0)
 		    || (scsi_status & SCSIXFERCNT_2_ZERO)) {
-			printk(DC395X_NAME ": Clear FIFO!\n");
+			dprintkl(KERN_DEBUG, "Clear FIFO!\n");
 			DC395x_clrfifo(pACB, "DIP0");
 		}
 	}
@@ -3159,9 +3086,7 @@
 DC395x_DataInPhase1(struct AdapterCtlBlk *pACB, struct ScsiReqBlk *pSR=
B,
 		    u16 * pscsi_status)
 {
-#ifdef DC395x_DEBUG0
-	printk(KERN_INFO DC395X_NAME ": DC395x_DataInPhase1..... ");
-#endif
+	dprintkdbg(DBG_0, "DC395x_DataInPhase1.....\n");
 	/* FIFO should be cleared, if previous phase was not DataPhase */
 	/*DC395x_clrfifo (pACB, "DIP1"); */
 	/* Allow data in! */
@@ -3189,19 +3114,15 @@
 	u8 bval;
 	struct DeviceCtlBlk *pDCB;
=20
-#ifdef DC395x_DEBUG0
-	printk(KERN_INFO DC395X_NAME
-	       ": DataIO_transfer %c (pid %li): len =3D %i, SG: %i/%i\n",
+	dprintkdbg(DBG_0, "DataIO_transfer %c (pid %li): len =3D %i, SG: %i/%=
i\n",
 	       ((ioDir & DMACMD_DIR) ? 'r' : 'w'), pSRB->pcmd->pid,
 	       pSRB->SRBTotalXferLength, pSRB->SRBSGIndex,
 	       pSRB->SRBSGCount);
-#endif
 	TRACEPRINTF("%05x(%i/%i)*", pSRB->SRBTotalXferLength,
 		    pSRB->SRBSGIndex, pSRB->SRBSGCount);
 	pDCB =3D pSRB->pSRBDCB;
 	if (pSRB =3D=3D pACB->pTmpSRB) {
-		printk(DC395X_NAME
-		       ": ERROR! Using TmpSRB in DataPhase!\n");
+		dprintkl(KERN_ERR, "Using TmpSRB in DataPhase!\n");
 	}
 	if (pSRB->SRBSGIndex < pSRB->SRBSGCount) {
 		if (pSRB->SRBTotalXferLength > DC395x_LASTPIO) {
@@ -3211,8 +3132,7 @@
 			 * Maybe, even ABORTXFER would be appropriate
 			 */
 			if (dma_status & XFERPENDING) {
-				printk(DC395X_NAME
-				       ": Xfer pending! Expect trouble!!\n");
+				dprintkl(KERN_DEBUG, "Xfer pending! Expect trouble!!\n");
 				DC395x_dumpinfo(pACB, pDCB, pSRB);
 				DC395x_write8(TRM_S1040_DMA_CONTROL,
 					      CLRXFIFO);
@@ -3280,19 +3200,13 @@
 					DC395x_write8
 					    (TRM_S1040_SCSI_CONFIG2,
 					     CFG2_WIDEFIFO);
-				DEBUGPIO(printk
-					 (DC395X_NAME
-					  ": DOP1: PIO %i bytes from %p:",
+				dprintkdbg(DBG_PIO, "DOP1: PIO %i bytes from %p:",
 					  pSRB->SRBTotalXferLength,
 					  pSRB->virt_addr);
-				    )
-				    while (pSRB->SRBTotalXferLength) {
-					DEBUGPIO(printk
-						 (" %02x",
-						  (unsigned char) *(pSRB->
-								    virt_addr));
-					    )
-					    DC395x_write8
+				while (pSRB->SRBTotalXferLength) {
+					if (debug_enabled(DBG_PIO))
+						printk(" %02x", (unsigned char) *(pSRB->virt_addr));
+					DC395x_write8
 					    (TRM_S1040_SCSI_FIFO,
 					     *(pSRB->virt_addr)++);
 					pSRB->SRBTotalXferLength--;
@@ -3302,10 +3216,9 @@
 					    && !pSRB->SegmentX[pSRB->
 							       SRBSGIndex].
 					    length) {
-						DEBUGPIO(printk
-							 (" (next segment)");
-						    )
-						    pSRB->SRBSGIndex++;
+						if (debug_enabled(DBG_PIO))
+							printk(" (next segment)");
+						pSRB->SRBSGIndex++;
 						DC395x_update_SGlist(pSRB,
 								     pSRB->
 								     SRBTotalXferLength);
@@ -3313,19 +3226,17 @@
 				}
 				if (pSRB->pSRBDCB->SyncPeriod & WIDE_SYNC) {
 					if (ln % 2) {
-						DC395x_write8
-						    (TRM_S1040_SCSI_FIFO,
-						     0);
-						DEBUGPIO(printk(" |00");
-						    )
+						DC395x_write8(TRM_S1040_SCSI_FIFO, 0);
+						if (debug_enabled(DBG_PIO))
+							printk(" |00");
 					}
 					DC395x_write8
 					    (TRM_S1040_SCSI_CONFIG2, 0);
 				}
 				/*DC395x_write32(TRM_S1040_SCSI_COUNTER, ln); */
-				DEBUGPIO(printk("\n");
-				    )
-				    DC395x_write8(TRM_S1040_SCSI_COMMAND,
+				if (debug_enabled(DBG_PIO))
+					printk("\n");
+				DC395x_write8(TRM_S1040_SCSI_COMMAND,
 						  SCMD_FIFO_OUT);
 			}
 		}
@@ -3353,7 +3264,7 @@
 					data2 =3D
 					    DC395x_read8
 					    (TRM_S1040_SCSI_FIFO);
-					/*printk (DC395X_NAME ": DataIO: Xfer pad: %02x %02x\n", data, da=
ta2); */
+					/*dprintkl(KERN_DEBUG, "DataIO: Xfer pad: %02x %02x\n", data, dat=
a2); */
 				} else {
 					/* Danger, Robinson: If you find KGs scattered over the wide
 					 * disk, the driver or chip is to blame :-( */
@@ -3371,7 +3282,7 @@
 					data =3D
 					    DC395x_read8
 					    (TRM_S1040_SCSI_FIFO);
-					/*printk (DC395X_NAME ": DataIO: Xfer pad: %02x\n", data); */
+					/*dprintkl(KERN_DEBUG, "DataIO: Xfer pad: %02x\n", data); */
 				} else {
 					DC395x_write8(TRM_S1040_SCSI_FIFO,
 						      'K');
@@ -3389,7 +3300,7 @@
 		}
 	}
 	/*DC395x_monitor_next_IRQ =3D 2; */
-	/*printk (" done\n"); */
+	/*printk(" done\n"); */
 }

=20
@@ -3405,10 +3316,7 @@
 DC395x_StatusPhase0(struct AdapterCtlBlk *pACB, struct ScsiReqBlk *pSR=
B,
 		    u16 * pscsi_status)
 {
-#ifdef DC395x_DEBUG0
-	printk(KERN_INFO DC395X_NAME ": StatusPhase0 (pid %li)\n",
-	       pSRB->pcmd->pid);
-#endif
+	dprintkdbg(DBG_0, "StatusPhase0 (pid %li)\n", pSRB->pcmd->pid);
 	TRACEPRINTF("STP0 *");
 	pSRB->TargetStatus =3D DC395x_read8(TRM_S1040_SCSI_FIFO);
 	pSRB->EndMessage =3D DC395x_read8(TRM_S1040_SCSI_FIFO);	/* get messag=
e */
@@ -3436,10 +3344,7 @@
 DC395x_StatusPhase1(struct AdapterCtlBlk *pACB, struct ScsiReqBlk *pSR=
B,
 		    u16 * pscsi_status)
 {
-#ifdef DC395x_DEBUG0
-	printk(KERN_INFO DC395X_NAME ": StatusPhase1 (pid=3D%li)\n",
-	       pSRB->pcmd->pid);
-#endif
+	dprintkdbg(DBG_0, "StatusPhase1 (pid=3D%li)\n", pSRB->pcmd->pid);
 	TRACEPRINTF("STP1 *");
 	/* Cleanup is now done at the end of DataXXPhase0 */
 	/*DC395x_cleanup_after_transfer (pACB, pSRB); */
@@ -3494,8 +3399,8 @@
 	DC395x_ENABLE_MSGOUT;
 	pSRB->SRBState &=3D ~SRB_MSGIN;
 	pSRB->SRBState |=3D SRB_MSGOUT;
-	printk(KERN_INFO DC395X_NAME
-	       ": Reject message %02x from %02i-%i\n", pSRB->MsgInBuf[0],
+	dprintkl(KERN_INFO,
+	       "Reject message %02x from %02i-%i\n", pSRB->MsgInBuf[0],
 	       pSRB->pSRBDCB->TargetID, pSRB->pSRBDCB->TargetLUN);
 	TRACEPRINTF("\\*");
 }
@@ -3525,12 +3430,10 @@
 {
 	struct ScsiReqBlk *lastSRB =3D pDCB->pGoingLast;
 	struct ScsiReqBlk *pSRB =3D pDCB->pGoingSRB;
-#ifdef DC395x_DEBUG0
-	printk(DC395X_NAME ": QTag Msg (SRB %p): %i ", pSRB, tag);
-#endif
+	dprintkdbg(DBG_0, "QTag Msg (SRB %p): %i\n", pSRB, tag);
 	if (!(pDCB->TagMask & (1 << tag)))
-		printk(DC395X_NAME
-		       ": MsgIn_QTag: TagMask (%08x) does not reserve tag %i!\n",
+		dprintkl(KERN_DEBUG,
+		       "MsgIn_QTag: TagMask (%08x) does not reserve tag %i!\n",
 		       pDCB->TagMask, tag);
=20
 	if (!pSRB)
@@ -3542,10 +3445,8 @@
 			goto mingx0;
 		pSRB =3D pSRB->pNextSRB;
 	}
-#ifdef DC395x_DEBUG0
-	printk("pid %li (%i-%i)\n", pSRB->pcmd->pid,
+	dprintkdbg(DBG_0, "pid %li (%i-%i)\n", pSRB->pcmd->pid,
 	       pSRB->pSRBDCB->TargetID, pSRB->pSRBDCB->TargetLUN);
-#endif
 	if (pDCB->DCBFlag & ABORT_DEV_) {
 		/*pSRB->SRBState =3D SRB_ABORT_SENT; */
 		DC395x_EnableMsgOut_Abort(pACB, pSRB);
@@ -3578,7 +3479,7 @@
 	pSRB->MsgCnt =3D 1;
 	DC395x_ENABLE_MSGOUT;
 	TRACEPRINTF("?*");
-	printk(DC395X_NAME ": Unknown tag received: %i: abort !!\n", tag);
+	dprintkl(KERN_DEBUG, "Unknown tag received: %i: abort !!\n", tag);
 	return pSRB;
 }
=20
@@ -3599,8 +3500,7 @@
 DC395x_MsgIn_set_async(struct AdapterCtlBlk *pACB, struct ScsiReqBlk *=
pSRB)
 {
 	struct DeviceCtlBlk *pDCB =3D pSRB->pSRBDCB;
-	printk(DC395X_NAME ": Target %02i: No sync transfers\n",
-	       pDCB->TargetID);
+	dprintkl(KERN_DEBUG, "Target %02i: No sync transfers\n", pDCB->Target=
ID);
 	TRACEPRINTF("!S *");
 	pDCB->SyncMode &=3D ~(SYNC_NEGO_ENABLE);
 	pDCB->SyncMode |=3D SYNC_NEGO_DONE;
@@ -3613,9 +3513,7 @@
 	    && !(pDCB->SyncMode & WIDE_NEGO_DONE)) {
 		DC395x_Build_WDTR(pACB, pDCB, pSRB);
 		DC395x_ENABLE_MSGOUT;
-		DEBUG0(printk
-		       (DC395X_NAME ": SDTR(rej): Try WDTR anyway ...\n");
-		    )
+		dprintkdbg(DBG_0, "SDTR(rej): Try WDTR anyway ...\n");
 	}
 }

@@ -3630,14 +3528,11 @@
 	/*u8 oldsyncperiod =3D pDCB->SyncPeriod; */
 	/*u8 oldsyncoffset =3D pDCB->SyncOffset; */

-#ifdef DC395x_DEBUG1
-	printk(KERN_INFO DC395X_NAME
-	       ": Target %02i: Sync: %ins (%02i.%01i MHz) Offset %i\n",
+	dprintkdbg(DBG_1, "Target %02i: Sync: %ins (%02i.%01i MHz) Offset %i\=
n",
 	       pDCB->TargetID, pSRB->MsgInBuf[3] << 2,
 	       (250 / pSRB->MsgInBuf[3]),
 	       ((250 % pSRB->MsgInBuf[3]) * 10) / pSRB->MsgInBuf[3],
 	       pSRB->MsgInBuf[4]);
-#endif

 	if (pSRB->MsgInBuf[4] > 15)
 		pSRB->MsgInBuf[4] =3D 15;
@@ -3655,8 +3550,8 @@
 			    dc395x_clock_period[bval]))
 		bval++;
 	if (pSRB->MsgInBuf[3] < dc395x_clock_period[bval])
-		printk(KERN_INFO DC395X_NAME
-		       ": Increase sync nego period to %ins\n",
+		dprintkl(KERN_INFO,
+		       "Increase sync nego period to %ins\n",
 		       dc395x_clock_period[bval] << 2);
 	pSRB->MsgInBuf[3] =3D dc395x_clock_period[bval];
 	pDCB->SyncPeriod &=3D 0xf0;
@@ -3668,8 +3563,8 @@
 	else
 		fact =3D 250;
=20
-	printk(KERN_INFO DC395X_NAME
-	       ": Target %02i: %s Sync: %ins Offset %i (%02i.%01i MB/s)\n",
+	dprintkl(KERN_INFO,
+	       "Target %02i: %s Sync: %ins Offset %i (%02i.%01i MB/s)\n",
 	       pDCB->TargetID, (fact =3D=3D 500) ? "Wide16" : "",
 	       pDCB->MinNegoPeriod << 2, pDCB->SyncOffset,
 	       (fact / pDCB->MinNegoPeriod),
@@ -3679,7 +3574,7 @@
 	TRACEPRINTF("S%i *", pDCB->MinNegoPeriod << 2);
 	if (!(pSRB->SRBState & SRB_DO_SYNC_NEGO)) {
 		/* Reply with corrected SDTR Message */
-		printk(DC395X_NAME ": .. answer w/  %ins %i\n",
+		dprintkl(KERN_DEBUG, " .. answer w/  %ins %i\n",
 		       pSRB->MsgInBuf[3] << 2, pSRB->MsgInBuf[4]);

 		memcpy(pSRB->MsgOutBuf, pSRB->MsgInBuf, 5);
@@ -3691,9 +3586,7 @@
 		    && !(pDCB->SyncMode & WIDE_NEGO_DONE)) {
 			DC395x_Build_WDTR(pACB, pDCB, pSRB);
 			DC395x_ENABLE_MSGOUT;
-			DEBUG0(printk
-			       (DC395X_NAME ": SDTR: Also try WDTR ...\n");
-			    )
+			dprintkdbg(DBG_0, "SDTR: Also try WDTR ...\n");
 		}
 	}
 	pSRB->SRBState &=3D ~SRB_DO_SYNC_NEGO;
@@ -3708,10 +3601,8 @@
 			struct ScsiReqBlk *pSRB)
 {
 	struct DeviceCtlBlk *pDCB =3D pSRB->pSRBDCB;
-#ifdef DC395x_DEBUG_KG
-	printk(DC395X_NAME ": WDTR got rejected from target %02i\n",
+	dprintkdbg(DBG_KG, "WDTR got rejected from target %02i\n",
 	       pDCB->TargetID);
-#endif
 	TRACEPRINTF("!W *");
 	pDCB->SyncPeriod &=3D ~WIDE_SYNC;
 	pDCB->SyncMode &=3D ~(WIDE_NEGO_ENABLE);
@@ -3722,9 +3613,7 @@
 	    && !(pDCB->SyncMode & SYNC_NEGO_DONE)) {
 		DC395x_Build_SDTR(pACB, pDCB, pSRB);
 		DC395x_ENABLE_MSGOUT;
-		DEBUG0(printk
-		       (DC395X_NAME ": WDTR(rej): Try SDTR anyway ...\n");
-		    )
+		dprintkdbg(DBG_0, "WDTR(rej): Try SDTR anyway ...\n");
 	}
 }
=20
@@ -3738,8 +3627,8 @@
 		pSRB->MsgInBuf[3] =3D wide;
 	/* Completed */
 	if (!(pSRB->SRBState & SRB_DO_WIDE_NEGO)) {
-		printk(DC395X_NAME
-		       ": Target %02i initiates Wide Nego ...\n",
+		dprintkl(KERN_DEBUG,
+		       "Target %02i initiates Wide Nego ...\n",
 		       pDCB->TargetID);
 		memcpy(pSRB->MsgOutBuf, pSRB->MsgInBuf, 4);
 		pSRB->MsgCnt =3D 4;
@@ -3755,18 +3644,15 @@
 	pSRB->SRBState &=3D ~SRB_DO_WIDE_NEGO;
 	TRACEPRINTF("W%i *", (pDCB->SyncPeriod & WIDE_SYNC ? 1 : 0));
 	/*pDCB->SyncMode &=3D ~(WIDE_NEGO_ENABLE+WIDE_NEGO_DONE); */
-#ifdef DC395x_DEBUG_KG
-	printk(DC395X_NAME
-	       ": Wide transfers (%i bit) negotiated with target %02i\n",
+	dprintkdbg(DBG_KG,
+	       "Wide transfers (%i bit) negotiated with target %02i\n",
 	       (8 << pSRB->MsgInBuf[3]), pDCB->TargetID);
-#endif
 	DC395x_reprog(pACB, pDCB);
 	if ((pDCB->SyncMode & SYNC_NEGO_ENABLE)
 	    && !(pDCB->SyncMode & SYNC_NEGO_DONE)) {
 		DC395x_Build_SDTR(pACB, pDCB, pSRB);
 		DC395x_ENABLE_MSGOUT;
-		DEBUG0(printk(DC395X_NAME ": WDTR: Also try SDTR ...\n");
-		    )
+		dprintkdbg(DBG_0, "WDTR: Also try SDTR ...\n");
 	}
 }

@@ -3797,17 +3683,14 @@
 {
 	struct DeviceCtlBlk *pDCB;

-#ifdef DC395x_DEBUG0
-	printk(KERN_INFO DC395X_NAME
-	       ": DC395x_MsgInPhase0..............\n ");
-#endif
+	dprintkdbg(DBG_0, "DC395x_MsgInPhase0..............\n");
 	TRACEPRINTF("MIP0*");
 	pDCB =3D pACB->pActiveDCB;

 	pSRB->MsgInBuf[pACB->MsgLen++] =3D DC395x_read8(TRM_S1040_SCSI_FIFO);
 	if (DC395x_MsgIn_complete(pSRB->MsgInBuf, pACB->MsgLen)) {
 		TRACEPRINTF("(%02x)*", pSRB->MsgInBuf[0]);
-		/*printk (KERN_INFO DC395X_NAME ": MsgIn:"); */
+		/*dprintkl(KERN_INFO, "MsgIn:"); */
 		/*DC395x_printMsg (pSRB->MsgInBuf, pACB->MsgLen); */
=20
 		/* Now eval the msg */
@@ -3860,12 +3743,10 @@

 			/* Discard  wide residual */
 		case MSG_IGNOREWIDE:
-			DEBUG0(printk
-			       (DC395X_NAME ": Ignore Wide Residual!\n");
-			    )
-			    /*DC395x_write32 (TRM_S1040_SCSI_COUNTER, 1); */
-			    /*DC395x_read8 (TRM_S1040_SCSI_FIFO); */
-			    break;
+			dprintkdbg(DBG_0, "Ignore Wide Residual!\n");
+			/*DC395x_write32 (TRM_S1040_SCSI_COUNTER, 1); */
+			/*DC395x_read8 (TRM_S1040_SCSI_FIFO); */
+			break;
=20
 			/* nothing has to be done */
 		case COMMAND_COMPLETE:
@@ -3876,22 +3757,19 @@
 			 * scsi command. Thanks, G=E9rard, for pointing it out.
 			 */
 		case SAVE_POINTERS:
-#ifdef DC395x_DEBUG0
-			printk(DC395X_NAME
-			       ": SAVE POINTER message received (pid %li: rem.%i) ... ignor=
e :-(\n",
+			dprintkdbg(DBG_0, "SAVE POINTER message received (pid %li: rem.%i) =
=2E.. ignore :-(\n",
 			       pSRB->pcmd->pid, pSRB->SRBTotalXferLength);
-#endif
 			/*pSRB->Saved_Ptr =3D pSRB->TotalXferredLen; */
 			break;
 			/* The device might want to restart transfer with a RESTORE */
 		case RESTORE_POINTERS:
-			printk(DC395X_NAME
-			       ": RESTORE POINTER message received ... ignore :-(\n");
+			dprintkl(KERN_DEBUG,
+			       "RESTORE POINTER message received ... ignore :-(\n");
 			/*dc395x_restore_ptr (pACB, pSRB); */
 			break;
 		case ABORT:
-			printk(DC395X_NAME
-			       ": ABORT msg received (pid %li %02i-%i)\n",
+			dprintkl(KERN_DEBUG,
+			       "ABORT msg received (pid %li %02i-%i)\n",
 			       pSRB->pcmd->pid, pDCB->TargetID,
 			       pDCB->TargetLUN);
 			pDCB->DCBFlag |=3D ABORT_DEV_;
@@ -3900,8 +3778,7 @@
 			/* reject unknown messages */
 		default:
 			if (pSRB->MsgInBuf[0] & IDENTIFY_BASE) {
-				printk(DC395X_NAME
-				       ": Identify Message received?\n");
+				dprintkl(KERN_DEBUG, "Identify Message received?\n");
 				/*TRACEOUT (" %s\n", pSRB->debugtrace); */
 				pSRB->MsgCnt =3D 1;
 				pSRB->MsgOutBuf[0] =3D pDCB->IdentifyMsg;
@@ -3944,10 +3821,7 @@
 DC395x_MsgInPhase1(struct AdapterCtlBlk *pACB, struct ScsiReqBlk *pSRB=
,
 		   u16 * pscsi_status)
 {
-#ifdef DC395x_DEBUG0
-	printk(KERN_INFO DC395X_NAME
-	       ": DC395x_MsgInPhase1..............\n ");
-#endif
+	dprintkdbg(DBG_0, "DC395x_MsgInPhase1..............\n");
 	TRACEPRINTF("MIP1 *");
 	DC395x_clrfifo(pACB, "MIP1");
 	DC395x_write32(TRM_S1040_SCSI_COUNTER, 1);
@@ -4050,14 +3924,10 @@
 	struct DeviceCtlBlk *pDCB;
 	struct ScsiReqBlk *pSRB;
=20
-#ifdef DC395x_DEBUG0
-	printk(KERN_INFO DC395X_NAME ": Disconnect (pid=3D%li)\n",
-	       pACB->pActiveDCB->pActiveSRB->pcmd->pid);
-#endif
+	dprintkdbg(DBG_0, "Disconnect (pid=3D%li)\n", pACB->pActiveDCB->pActi=
veSRB->pcmd->pid);
 	pDCB =3D pACB->pActiveDCB;
 	if (!pDCB) {
-		printk(KERN_ERR DC395X_NAME
-		       ": Disc: Exception Disconnect pDCB=3DNULL !!\n ");
+		dprintkl(KERN_ERR, "Disc: Exception Disconnect pDCB=3DNULL !!\n ");
 		udelay(500);
 		/* Suspend queue for a while */
 		pACB->pScsiHost->last_reset =3D
@@ -4077,8 +3947,7 @@
 	DC395x_clrfifo(pACB, "Disc");
 	DC395x_write16(TRM_S1040_SCSI_CONTROL, DO_HWRESELECT);
 	if (pSRB->SRBState & SRB_UNEXPECT_RESEL) {
-		printk(KERN_ERR DC395X_NAME
-		       ": Disc: Unexpected Reselection (%i-%i)\n",
+		dprintkl(KERN_ERR, "Disc: Unexpected Reselection (%i-%i)\n",
 		       pDCB->TargetID, pDCB->TargetLUN);
 		pSRB->SRBState =3D 0;
 		DC395x_Waiting_process(pACB);
@@ -4086,7 +3955,7 @@
 		/*Scsi_Cmnd* pcmd =3D pSRB->pcmd; */
 		pDCB->DCBFlag &=3D ~ABORT_DEV_;
 		pACB->pScsiHost->last_reset =3D jiffies + HZ / 2 + 1;
-		printk(KERN_ERR DC395X_NAME ": Disc: SRB_ABORT_SENT!\n");
+		dprintkl(KERN_ERR, "Disc: SRB_ABORT_SENT!\n");
 		DC395x_DoingSRB_Done(pACB, DID_ABORT, pSRB->pcmd, 1);
 		DC395x_Query_to_Waiting(pACB);
 		DC395x_Waiting_process(pACB);
@@ -4102,8 +3971,7 @@
 			if (pSRB->SRBState !=3D SRB_START_
 			    && pSRB->SRBState !=3D SRB_MSGOUT) {
 				pSRB->SRBState =3D SRB_READY;
-				printk(DC395X_NAME
-				       ": Unexpected Disconnection (pid %li)!\n",
+				dprintkl(KERN_DEBUG, "Unexpected Disconnection (pid %li)!\n",
 				       pSRB->pcmd->pid);
 				pSRB->TargetStatus =3D SCSI_STAT_SEL_TIMEOUT;
 				TRACEPRINTF("UnExpD *");
@@ -4112,12 +3980,10 @@
 			} else {
 				/* Normal selection timeout */
 				TRACEPRINTF("SlTO *");
-#ifdef DC395x_DEBUG_KG
-				printk(DC395X_NAME
-				       ": Disc: SelTO (pid=3D%li) for dev %02i-%i\n",
+				dprintkdbg(DBG_KG,
+				       "Disc: SelTO (pid=3D%li) for dev %02i-%i\n",
 				       pSRB->pcmd->pid, pDCB->TargetID,
 				       pDCB->TargetLUN);
-#endif
 				if (pSRB->RetryCnt++ > DC395x_MAX_RETRIES
 				    || pACB->scan_devices) {
 					pSRB->TargetStatus =3D
@@ -4126,10 +3992,8 @@
 				}
 				DC395x_freetag(pDCB, pSRB);
 				DC395x_Going_to_Waiting(pDCB, pSRB);
-#ifdef DC395x_DEBUG_KG
-				printk(DC395X_NAME ": Retry pid %li ...\n",
+				dprintkdbg(DBG_KG, "Retry pid %li ...\n",
 				       pSRB->pcmd->pid);
-#endif
 				DC395x_waiting_timer(pACB, HZ / 20);
 			}
 		} else if (pSRB->SRBState & SRB_DISCONNECT) {
@@ -4137,16 +4001,13 @@
 			/*
 			 * SRB_DISCONNECT (This is what we expect!)
 			 */
-			/* printk (DC395X_NAME ": DoWaitingSRB (pid=3D%li)\n", pSRB->pcmd->=
pid); */
+			/* dprintkl(KERN_DEBUG, "DoWaitingSRB (pid=3D%li)\n", pSRB->pcmd->p=
id); */
 			TRACEPRINTF("+*");
 			if (bval & 0x40) {
-				DEBUG0(printk
-				       (DC395X_NAME
-					": Debug: DISC: SCSI bus stat %02x: ACK set! Other controllers?\n=
",
+				dprintkdbg(DBG_0, "Debug: DISC: SCSI bus stat %02x: ACK set! Other=
 controllers?\n",
 					bval);
-				    )
-				    /* It could come from another initiator, therefore don't do mu=
ch ! */
-				    TRACEPRINTF("ACK(%02x) *", bval);
+				/* It could come from another initiator, therefore don't do much !=
 */
+				TRACEPRINTF("ACK(%02x) *", bval);
 				/*DC395x_dumpinfo (pACB, pDCB, pSRB); */
 				/*TRACEOUT (" %s\n", pSRB->debugtrace); */
 				/*pDCB->DCBFlag |=3D ABORT_DEV_; */
@@ -4162,7 +4023,7 @@
 			DC395x_freetag(pDCB, pSRB);
 			pDCB->pActiveSRB =3D 0;
 			pSRB->SRBState =3D SRB_FREE;
-			/*printk (DC395X_NAME ": done (pid=3D%li)\n", pSRB->pcmd->pid); */
+			/*dprintkl(KERN_DEBUG, "done (pid=3D%li)\n", pSRB->pcmd->pid); */
 			DC395x_SRBdone(pACB, pDCB, pSRB);
 		}
 	}
@@ -4184,9 +4045,7 @@
 	u8 id, lun;
 	u8 arblostflag =3D 0;

-#ifdef DC395x_DEBUG0
-	printk(KERN_INFO DC395X_NAME ": DC395x_Reselect..............\n ");
-#endif
+	dprintkdbg(DBG_0, "DC395x_Reselect..............\n");
=20
 	DC395x_clrfifo(pACB, "Resel");
 	/*DC395x_write16(TRM_S1040_SCSI_CONTROL, DO_HWRESELECT | DO_DATALATCH=
); */
@@ -4196,20 +4055,17 @@
 	if (pDCB) {		/* Arbitration lost but Reselection win */
 		pSRB =3D pDCB->pActiveSRB;
 		if (!pSRB) {
-			printk(DC395X_NAME
-			       ": Arb lost Resel won, but pActiveSRB =3D=3D 0!\n");
+			dprintkl(KERN_DEBUG, "Arb lost Resel won, but pActiveSRB =3D=3D 0!\=
n");
 			DC395x_write16(TRM_S1040_SCSI_CONTROL, DO_DATALATCH);	/* it's impor=
tant for atn stop */
 			return;
 		}
 		/* Why the if ? */
 		if (!(pACB->scan_devices)) {
-#ifdef DC395x_DEBUG_KG
-			printk(DC395X_NAME
-			       ": Arb lost but Resel win pid %li (%02i-%i) Rsel %04x Stat %=
04x\n",
+			dprintkdbg(DBG_KG,
+			       "Arb lost but Resel win pid %li (%02i-%i) Rsel %04x Stat %04=
x\n",
 			       pSRB->pcmd->pid, pDCB->TargetID,
 			       pDCB->TargetLUN, RselTarLunId,
 			       DC395x_read16(TRM_S1040_SCSI_STATUS));
-#endif
 			TRACEPRINTF("ArbLResel!*");
 			/*TRACEOUT (" %s\n", pSRB->debugtrace); */
 			arblostflag =3D 1;
@@ -4225,15 +4081,13 @@
 	}
 	/* Read Reselected Target Id and LUN */
 	if (!(RselTarLunId & (IDENTIFY_BASE << 8)))
-		printk(DC395X_NAME
-		       ": Resel expects identify msg! Got %04x!\n",
+		dprintkl(KERN_DEBUG, "Resel expects identify msg! Got %04x!\n",
 		       RselTarLunId);
 	id =3D RselTarLunId & 0xff;
 	lun =3D (RselTarLunId >> 8) & 7;
 	pDCB =3D DC395x_findDCB(pACB, id, lun);
 	if (!pDCB) {
-		printk(KERN_ERR DC395X_NAME
-		       ": Reselect from non existing device (%02i-%i)\n",
+		dprintkl(KERN_ERR, "Reselect from non existing device (%02i-%i)\n",
 		       id, lun);
 		DC395x_write16(TRM_S1040_SCSI_CONTROL, DO_DATALATCH);	/* it's import=
ant for atn stop */
 		return;
@@ -4242,21 +4096,20 @@
 	pACB->pActiveDCB =3D pDCB;

 	if (!(pDCB->DevMode & NTC_DO_DISCONNECT))
-		printk(DC395X_NAME
-		       ": Reselection in spite of forbidden disconnection? (%02i-%i)=
\n",
+		dprintkl(KERN_DEBUG, "Reselection in spite of forbidden disconnectio=
n? (%02i-%i)\n",
 		       pDCB->TargetID, pDCB->TargetLUN);

 	if ((pDCB->SyncMode & EN_TAG_QUEUEING) /*&& !arblostflag */ ) {
 		struct ScsiReqBlk *oldSRB =3D pSRB;
 		pSRB =3D pACB->pTmpSRB;
-#ifdef DC395x_DEBUGTRACE
+#if debug_enabled(DBG_TRACE|DBG_TRACEALL)
 		pSRB->debugpos =3D 0;
 		pSRB->debugtrace[0] =3D 0;
 #endif
 		pDCB->pActiveSRB =3D pSRB;
 		if (oldSRB)
 			TRACEPRINTF("ArbLResel(%li):*", oldSRB->pcmd->pid);
-		/*if (arblostflag) printk (DC395X_NAME ": Reselect: Wait for Tag ...=
 \n"); */
+		/*if (arblostflag) dprintkl(KERN_DEBUG, "Reselect: Wait for Tag ... =
\n"); */
 	} else {
 		/* There can be only one! */
 		pSRB =3D pDCB->pActiveSRB;
@@ -4266,8 +4119,8 @@
 			/*
 			 * abort command
 			 */
-			printk(DC395X_NAME
-			       ": Reselected w/o disconnected cmds from %02i-%i?\n",
+			dprintkl(KERN_DEBUG,
+			       "Reselected w/o disconnected cmds from %02i-%i?\n",
 			       pDCB->TargetID, pDCB->TargetLUN);
 			pSRB =3D pACB->pTmpSRB;
 			pSRB->SRBState =3D SRB_UNEXPECT_RESEL;
@@ -4308,13 +4161,10 @@
 	struct DeviceCtlBlk *pPrevDCB =3D pACB->pLinkDCB;
=20
 	if (pDCB->GoingSRBCnt > 1) {
-		DCBDEBUG(printk
-			 (KERN_INFO DC395X_NAME
-			  ": Driver won't free DCB (ID %i, LUN %i): 0x%08x because of SRBCn=
t %i\n",
+		dprintkdbg(DBG_DCB, "Driver won't free DCB (ID %i, LUN %i): 0x%08x b=
ecause of SRBCnt %i\n",
 			  pDCB->TargetID, pDCB->TargetLUN, (int) pDCB,
 			  pDCB->GoingSRBCnt);
-		    )
-		    return;
+		return;
 	}
 	pACB->DCBmap[pDCB->TargetID] &=3D ~(1 << pDCB->TargetLUN);
 	pACB->children[pDCB->TargetID][pDCB->TargetLUN] =3D NULL;
@@ -4335,19 +4185,16 @@
 			pACB->pLastDCB =3D pPrevDCB;
 	}

-	DCBDEBUG(printk
-		 (KERN_INFO DC395X_NAME
-		  ": Driver about to free DCB (ID %i, LUN %i): %p\n",
+	dprintkdbg(DBG_DCB, "Driver about to free DCB (ID %i, LUN %i): %p\n",
 		  pDCB->TargetID, pDCB->TargetLUN, pDCB);
-	    )
-	    if (pDCB =3D=3D pACB->pActiveDCB)
+	if (pDCB =3D=3D pACB->pActiveDCB)
 		pACB->pActiveDCB =3D 0;
 	if (pDCB =3D=3D pACB->pLinkDCB)
 		pACB->pLinkDCB =3D pDCB->pNextDCB;
 	if (pDCB =3D=3D pACB->pDCBRunRobin)
 		pACB->pDCBRunRobin =3D pDCB->pNextDCB;
 	pACB->DCBCnt--;
-	KFREE(pDCB);
+	dc395x_kfree(pDCB);
 	/* pACB->DeviceCnt--; */
 }
=20
@@ -4414,29 +4261,23 @@
 	dir =3D scsi_to_pci_dma_dir(pcmd->sc_data_direction);
 	if (pcmd->use_sg && dir !=3D PCI_DMA_NONE) {
 		/* unmap DC395x SG list */
-#ifdef DC395x_SGPARANOIA
-		printk(DC395X_NAME
-		       ": Unmap SG descriptor list %08x (%05x)\n",
+		dprintkdbg(DBG_SGPARANOIA,
+		       "Unmap SG descriptor list %08x (%05x)\n",
 		       pSRB->SRBSGBusAddr,
 		       sizeof(struct SGentry) * DC395x_MAX_SG_LISTENTRY);
-#endif
 		pci_unmap_single(pACB->pdev, pSRB->SRBSGBusAddr,
 				 sizeof(struct SGentry) *
 				 DC395x_MAX_SG_LISTENTRY,
 				 PCI_DMA_TODEVICE);
-#ifdef DC395x_SGPARANOIA
-		printk(DC395X_NAME ": Unmap %i SG segments from %p\n",
+		dprintkdbg(DBG_SGPARANOIA, "Unmap %i SG segments from %p\n",
 		       pcmd->use_sg, pcmd->request_buffer);
-#endif
 		/* unmap the sg segments */
 		pci_unmap_sg(pACB->pdev,
 			     (struct scatterlist *) pcmd->request_buffer,
 			     pcmd->use_sg, dir);
 	} else if (pcmd->request_buffer && dir !=3D PCI_DMA_NONE) {
-#ifdef DC395x_SGPARANOIA
-		printk(DC395X_NAME ": Unmap buffer at %08x (%05x)\n",
+		dprintkdbg(DBG_SGPARANOIA, "Unmap buffer at %08x (%05x)\n",
 		       pSRB->SegmentX[0].address, pcmd->request_bufflen);
-#endif
 		pci_unmap_single(pACB->pdev, pSRB->SegmentX[0].address,
 				 pcmd->request_bufflen, dir);
 	}
@@ -4454,10 +4295,8 @@
 	if (!(pSRB->SRBFlag & AUTO_REQSENSE))
 		return;
 	/* Unmap sense buffer */
-#ifdef DC395x_SGPARANOIA
-	printk(DC395X_NAME ": Unmap sense buffer from %08x (%05x)\n",
-	       pSRB->SegmentX[0].address, sizeof(pcmd->sense_buffer));
-#endif
+	dprintkdbg(DBG_SGPARANOIA, "Unmap sense buffer from %08x\n",
+	       pSRB->SegmentX[0].address);
 	pci_unmap_single(pACB->pdev, pSRB->SegmentX[0].address,
 			 pSRB->SegmentX[0].length, PCI_DMA_FROMDEVICE);
 	/* Restore SG stuff */
@@ -4497,22 +4336,16 @@
 		ptr =3D
 		    (struct ScsiInqData *) CPU_ADDR(*(struct scatterlist *)
 						    ptr);
-#ifdef DC395x_SGPARANOIA
-	printk(KERN_INFO DC395X_NAME
-	       ": SRBdone SG=3D%i (%i/%i), req_buf =3D %p, adr =3D %p\n",
+	dprintkdbg(DBG_SGPARANOIA,
+	       "SRBdone SG=3D%i (%i/%i), req_buf =3D %p, adr =3D %p\n",
 	       pcmd->use_sg, pSRB->SRBSGIndex, pSRB->SRBSGCount,
 	       pcmd->request_buffer, ptr);
-#endif
-#ifdef DC395x_DEBUG_KG
-	printk(KERN_INFO DC395X_NAME
-	       ": SRBdone (pid %li, target %02i-%i): ", pSRB->pcmd->pid,
+	dprintkdbg(DBG_KG,
+	       "SRBdone (pid %li, target %02i-%i): ", pSRB->pcmd->pid,
 	       pSRB->pcmd->device->id, pSRB->pcmd->device->lun);
-#endif
 	status =3D pSRB->TargetStatus;
 	if (pSRB->SRBFlag & AUTO_REQSENSE) {
-#ifdef DC395x_DEBUG0
-		printk(KERN_INFO "AUTO_REQSENSE1..............\n ");
-#endif
+		dprintkdbg(DBG_0, "AUTO_REQSENSE1..............\n");
 		DC395x_pci_unmap_sense(pACB, pSRB);
 		/*
 		 ** target status..........................
@@ -4520,60 +4353,58 @@
 		pSRB->SRBFlag &=3D ~AUTO_REQSENSE;
 		pSRB->AdaptStatus =3D 0;
 		pSRB->TargetStatus =3D CHECK_CONDITION << 1;
-#ifdef DC395x_DEBUG_KG
-		switch (pcmd->sense_buffer[2] & 0x0f) {
-		case NOT_READY:
-			printk
-			    ("\nDC395x:  ReqSense: NOT_READY (Cmnd =3D 0x%02x, Dev =3D %i-%=
i, Stat =3D %i, Scan =3D %i) ",
-			     pcmd->cmnd[0], pDCB->TargetID,
-			     pDCB->TargetLUN, status, pACB->scan_devices);
-			break;
-		case UNIT_ATTENTION:
-			printk
-			    ("\nDC395x:  ReqSense: UNIT_ATTENTION (Cmnd =3D 0x%02x, Dev =3D=
 %i-%i, Stat =3D %i, Scan =3D %i) ",
-			     pcmd->cmnd[0], pDCB->TargetID,
-			     pDCB->TargetLUN, status, pACB->scan_devices);
-			break;
-		case ILLEGAL_REQUEST:
-			printk
-			    ("\nDC395x:  ReqSense: ILLEGAL_REQUEST (Cmnd =3D 0x%02x, Dev =3D=
 %i-%i, Stat =3D %i, Scan =3D %i) ",
-			     pcmd->cmnd[0], pDCB->TargetID,
-			     pDCB->TargetLUN, status, pACB->scan_devices);
-			break;
-		case MEDIUM_ERROR:
-			printk
-			    ("\nDC395x:  ReqSense: MEDIUM_ERROR (Cmnd =3D 0x%02x, Dev =3D %=
i-%i, Stat =3D %i, Scan =3D %i) ",
-			     pcmd->cmnd[0], pDCB->TargetID,
-			     pDCB->TargetLUN, status, pACB->scan_devices);
-			break;
-		case HARDWARE_ERROR:
-			printk
-			    ("\nDC395x:  ReqSense: HARDWARE_ERROR (Cmnd =3D 0x%02x, Dev =3D=
 %i-%i, Stat =3D %i, Scan =3D %i) ",
-			     pcmd->cmnd[0], pDCB->TargetID,
-			     pDCB->TargetLUN, status, pACB->scan_devices);
-			break;
+		if (debug_enabled(DBG_KG)) {
+			switch (pcmd->sense_buffer[2] & 0x0f) {
+			case NOT_READY:
+				dprintkl(KERN_DEBUG,
+				     "ReqSense: NOT_READY (Cmnd =3D 0x%02x, Dev =3D %i-%i, Stat =3D=
 %i, Scan =3D %i) ",
+				     pcmd->cmnd[0], pDCB->TargetID,
+				     pDCB->TargetLUN, status, pACB->scan_devices);
+				break;
+			case UNIT_ATTENTION:
+				dprintkl(KERN_DEBUG,
+				     "ReqSense: UNIT_ATTENTION (Cmnd =3D 0x%02x, Dev =3D %i-%i, St=
at =3D %i, Scan =3D %i) ",
+				     pcmd->cmnd[0], pDCB->TargetID,
+				     pDCB->TargetLUN, status, pACB->scan_devices);
+				break;
+			case ILLEGAL_REQUEST:
+				dprintkl(KERN_DEBUG,
+				     "ReqSense: ILLEGAL_REQUEST (Cmnd =3D 0x%02x, Dev =3D %i-%i, S=
tat =3D %i, Scan =3D %i) ",
+				     pcmd->cmnd[0], pDCB->TargetID,
+				     pDCB->TargetLUN, status, pACB->scan_devices);
+				break;
+			case MEDIUM_ERROR:
+				dprintkl(KERN_DEBUG,
+				     "ReqSense: MEDIUM_ERROR (Cmnd =3D 0x%02x, Dev =3D %i-%i, Stat=
 =3D %i, Scan =3D %i) ",
+				     pcmd->cmnd[0], pDCB->TargetID,
+				     pDCB->TargetLUN, status, pACB->scan_devices);
+				break;
+			case HARDWARE_ERROR:
+				dprintkl(KERN_DEBUG,
+				     "ReqSense: HARDWARE_ERROR (Cmnd =3D 0x%02x, Dev =3D %i-%i, St=
at =3D %i, Scan =3D %i) ",
+				     pcmd->cmnd[0], pDCB->TargetID,
+				     pDCB->TargetLUN, status, pACB->scan_devices);
+				break;
+			}
+			if (pcmd->sense_buffer[7] >=3D 6)
+				dprintkl(KERN_DEBUG,=20
+				     "Sense=3D%02x, ASC=3D%02x, ASCQ=3D%02x (%08x %08x) ",
+				     pcmd->sense_buffer[2], pcmd->sense_buffer[12],
+				     pcmd->sense_buffer[13],
+				     *((unsigned int *) (pcmd->sense_buffer + 3)),
+				     *((unsigned int *) (pcmd->sense_buffer + 8)));
+			else
+				dprintkl(KERN_DEBUG,
+				     "Sense=3D%02x, No ASC/ASCQ (%08x) ",
+				     pcmd->sense_buffer[2],
+				     *((unsigned int *) (pcmd->sense_buffer + 3)));
 		}
-		if (pcmd->sense_buffer[7] >=3D 6)
-			printk
-			    ("\nDC395x:  Sense=3D%02x, ASC=3D%02x, ASCQ=3D%02x (%08x %08x) =
",
-			     pcmd->sense_buffer[2], pcmd->sense_buffer[12],
-			     pcmd->sense_buffer[13],
-			     *((unsigned int *) (pcmd->sense_buffer + 3)),
-			     *((unsigned int *) (pcmd->sense_buffer + 8)));
-		else
-			printk
-			    ("\nDC395x:  Sense=3D%02x, No ASC/ASCQ (%08x) ",
-			     pcmd->sense_buffer[2],
-			     *((unsigned int *) (pcmd->sense_buffer + 3)));
-#endif

 		if (status =3D=3D (CHECK_CONDITION << 1)) {
 			pcmd->result =3D DID_BAD_TARGET << 16;
 			goto ckc_e;
 		}
-#ifdef DC395x_DEBUG0
-		printk(KERN_INFO "AUTO_REQSENSE2..............\n ");
-#endif
+		dprintkdbg(DBG_0, "AUTO_REQSENSE2..............\n");

 		if ((pSRB->SRBTotalXferLength)
 		    && (pSRB->SRBTotalXferLength >=3D pcmd->underflow))
@@ -4680,28 +4511,24 @@
 	/* This may be interpreted by sb. or not ... */
 	pcmd->SCp.this_residual =3D pSRB->SRBTotalXferLength;
 	pcmd->SCp.buffers_residual =3D 0;
-#ifdef DC395x_DEBUG_KG
-	if (pSRB->SRBTotalXferLength)
-		printk
-		    ("\nDC395x:  pid %li: %02x (%02i-%i): Missed %i bytes\n",
-		     pcmd->pid, pcmd->cmnd[0], pcmd->device->id,
-		     pcmd->device->lun, pSRB->SRBTotalXferLength);
-#endif
+	if (debug_enabled(DBG_KG)) {
+		if (pSRB->SRBTotalXferLength)
+			dprintkdbg(DBG_KG, "pid %li: %02x (%02i-%i): Missed %i bytes\n",
+			     pcmd->pid, pcmd->cmnd[0], pcmd->device->id,
+			     pcmd->device->lun, pSRB->SRBTotalXferLength);
+	}

 	DC395x_Going_remove(pDCB, pSRB, 0);
 	/* Add to free list */
 	if (pSRB =3D=3D pACB->pTmpSRB)
-		printk("\nDC395x:  ERROR! Completed Cmnd with TmpSRB!\n");
+		dprintkl(KERN_ERR, "ERROR! Completed Cmnd with TmpSRB!\n");
 	else
 		DC395x_Free_insert(pACB, pSRB);

-	DEBUG0(printk
-	       (KERN_DEBUG DC395X_NAME ":  SRBdone: done pid %li\n",
-		pcmd->pid);
-	    )
-#ifdef DC395x_DEBUG_KG
-	    printk(" 0x%08x\n", pcmd->result);
-#endif
+	dprintkdbg(DBG_0, "SRBdone: done pid %li\n", pcmd->pid);
+	if (debug_enabled(DBG_KG)) {
+		printk(" 0x%08x\n", pcmd->result);
+	}
 	TRACEPRINTF("%08x(%li)*", pcmd->result, jiffies);
 	DC395x_pci_unmap(pACB, pSRB);
 	/*DC395x_UNLOCK_ACB_NI; */
@@ -4735,7 +4562,7 @@
 	pDCB =3D pACB->pLinkDCB;
 	if (!pDCB)
 		return;
-	printk(KERN_INFO DC395X_NAME ": DC395x_DoingSRB_Done: pids ");
+	dprintkl(KERN_INFO, "DC395x_DoingSRB_Done: pids ");
 	do {
 		/* As the ML may queue cmnds again, cache old values */
 		struct ScsiReqBlk *pWaitingSRB =3D pDCB->pWaitingSRB;
@@ -4779,12 +4606,12 @@
 			pSRB =3D pSRBTemp;
 		}
 		if (pDCB->pGoingSRB)
-			printk(DC395X_NAME
-			       ": How could the ML send cmnds to the Going queue? (%02i-%i)=
!!\n",
+			dprintkl(KERN_DEBUG,
+			       "How could the ML send cmnds to the Going queue? (%02i-%i)!!=
\n",
 			       pDCB->TargetID, pDCB->TargetLUN);
 		if (pDCB->TagMask)
-			printk(DC395X_NAME
-			       ": TagMask for %02i-%i should be empty, is %08x!\n",
+			dprintkl(KERN_DEBUG,
+			       "TagMask for %02i-%i should be empty, is %08x!\n",
 			       pDCB->TargetID, pDCB->TargetLUN,
 			       pDCB->TagMask);
 		/*pDCB->GoingSRBCnt =3D 0;; */
@@ -4850,10 +4677,7 @@
 {
 	/*u32  drv_flags=3D0; */

-#ifdef DC395x_DEBUG0
-	printk(KERN_INFO DC395X_NAME
-	       ": DC395x_ResetSCSIBus..............\n ");
-#endif
+	dprintkdbg(DBG_0, "DC395x_ResetSCSIBus..............\n");

 	/*DC395x_DRV_LOCK(drv_flags); */
 	pACB->ACBFlag |=3D RESET_DEV;	/* RESET_DETECT, RESET_DONE, RESET_DEV =
*/
@@ -4892,7 +4716,7 @@
 	wval =3D DC395x_read16(TRM_S1040_DMA_CONFIG) & ~DMA_FIFO_CTRL;
 	wval |=3D
 	    DMA_FIFO_HALF_HALF | DMA_ENHANCE /*| DMA_MEM_MULTI_READ */ ;
-	/*printk (KERN_INFO DC395X_NAME "DMA_Config: %04x\n", wval); */
+	/*dprintkl(KERN_INFO, "DMA_Config: %04x\n", wval); */
 	DC395x_write16(TRM_S1040_DMA_CONFIG, wval);
 	/* Clear pending interrupt status */
 	DC395x_read8(TRM_S1040_SCSI_INTSTATUS);
@@ -4912,7 +4736,7 @@
  */
 static void DC395x_ScsiRstDetect(struct AdapterCtlBlk *pACB)
 {
-	printk(KERN_INFO DC395X_NAME ": DC395x_ScsiRstDetect\n");
+	dprintkl(KERN_INFO, "DC395x_ScsiRstDetect\n");
 	/* delay half a second */
 	if (timer_pending(&pACB->Waiting_Timer))
 		del_timer(&pACB->Waiting_Timer);
@@ -4960,11 +4784,9 @@
 	Scsi_Cmnd *pcmd;
=20
 	pcmd =3D pSRB->pcmd;
-#ifdef DC395x_DEBUG_KG
-	printk(KERN_INFO DC395X_NAME
-	       ": DC395x_RequestSense for pid %li, target %02i-%i\n",
+	dprintkdbg(DBG_KG,
+	       "DC395x_RequestSense for pid %li, target %02i-%i\n",
 	       pcmd->pid, pcmd->device->id, pcmd->device->lun);
-#endif
 	TRACEPRINTF("RqSn*");
 	pSRB->SRBFlag |=3D AUTO_REQSENSE;
 	pSRB->AdaptStatus =3D 0;
@@ -4986,17 +4808,15 @@
 	pSRB->SegmentX[0].address =3D
 	    pci_map_single(pACB->pdev, pcmd->sense_buffer,
 			   sizeof(pcmd->sense_buffer), PCI_DMA_FROMDEVICE);
-#ifdef DC395x_SGPARANOIA
-	printk(DC395X_NAME ": Map sense buffer at %p (%05x) to %08x\n",
+	dprintkdbg(DBG_SGPARANOIA, "Map sense buffer at %p (%05x) to %08x\n",
 	       pcmd->sense_buffer, sizeof(pcmd->sense_buffer),
 	       pSRB->SegmentX[0].address);
-#endif
 	pSRB->SRBSGCount =3D 1;
 	pSRB->SRBSGIndex =3D 0;
=20
 	if (DC395x_StartSCSI(pACB, pDCB, pSRB)) {	/* Should only happen, if s=
b. else grabs the bus */
-		printk(DC395X_NAME
-		       ": Request Sense failed for pid %li (%02i-%i)!\n",
+		dprintkl(KERN_DEBUG,
+		       "Request Sense failed for pid %li (%02i-%i)!\n",
 		       pSRB->pcmd->pid, pDCB->TargetID, pDCB->TargetLUN);
 		TRACEPRINTF("?*");
 		DC395x_Going_to_Waiting(pDCB, pSRB);
@@ -5025,10 +4845,8 @@
 	struct DeviceCtlBlk *pDCB;
 	struct DeviceCtlBlk *pDCB2;
=20
-#ifdef DC395x_DEBUG0
-	printk(KERN_INFO DC395X_NAME ": DC395x_initDCB..............\n ");
-#endif
-	pDCB =3D KMALLOC(sizeof(struct DeviceCtlBlk), GFP_ATOMIC);
+	dprintkdbg(DBG_0, "DC395x_initDCB..............\n");
+	pDCB =3D dc395x_kmalloc(sizeof(struct DeviceCtlBlk), GFP_ATOMIC);
 	/*pDCB =3D DC395x_findDCB (pACB, target, lun); */
 	*ppDCB =3D pDCB;
 	pDCB2 =3D 0;
@@ -5098,12 +4916,10 @@
 		struct DeviceCtlBlk *prevDCB =3D pACB->pLinkDCB;
 		while (prevDCB->TargetID !=3D pDCB->TargetID)
 			prevDCB =3D prevDCB->pNextDCB;
-#ifdef DC395x_DEBUG_KG
-		printk(DC395X_NAME
-		       ": Copy settings from %02i-%02i to %02i-%02i\n",
+		dprintkdbg(DBG_KG,
+		       "Copy settings from %02i-%02i to %02i-%02i\n",
 		       prevDCB->TargetID, prevDCB->TargetLUN,
 		       pDCB->TargetID, pDCB->TargetLUN);
-#endif
 		pDCB->SyncMode =3D prevDCB->SyncMode;
 		pDCB->SyncPeriod =3D prevDCB->SyncPeriod;
 		pDCB->MinNegoPeriod =3D prevDCB->MinNegoPeriod;
@@ -5116,18 +4932,18 @@
 }

=20
-/* Dynamically allocated memory handling */
-
-#ifdef DC395x_DEBUGTRACE
-/* Memory for trace buffers */
+#if debug_enabled(DBG_TRACE|DBG_TRACEALL)
+/*
+ * Memory for trace buffers
+ */
 void DC395x_free_tracebufs(struct AdapterCtlBlk *pACB, int SRBIdx)
 {
 	int srbidx;
 	const unsigned bufs_per_page =3D PAGE_SIZE / DEBUGTRACEBUFSZ;
 	for (srbidx =3D 0; srbidx < SRBIdx; srbidx +=3D bufs_per_page) {
-		/*printk (DC395X_NAME ": Free tracebuf %p (for %i)\n", */
+		/*dprintkl(KERN_DEBUG, "Free tracebuf %p (for %i)\n", */
 		/*      pACB->SRB_array[srbidx].debugtrace, srbidx); */
-		KFREE(pACB->SRB_array[srbidx].debugtrace);
+		dc395x_kfree(pACB->SRB_array[srbidx].debugtrace);
 	}
 }
=20
@@ -5141,14 +4957,14 @@
 	int SRBIdx =3D 0;
 	unsigned i =3D 0;
 	unsigned char *ptr;
-	/*printk (DC395X_NAME ": Alloc %i pages for tracebufs\n", pages); */
+	/*dprintkl(KERN_DEBUG, "Alloc %i pages for tracebufs\n", pages); */
 	while (pages--) {
-		ptr =3D KMALLOC(PAGE_SIZE, GFP_KERNEL);
+		ptr =3D dc395x_kmalloc(PAGE_SIZE, GFP_KERNEL);
 		if (!ptr) {
 			DC395x_free_tracebufs(pACB, SRBIdx);
 			return 1;
 		}
-		/*printk (DC395X_NAME ": Alloc %li bytes at %p for tracebuf %i\n", *=
/
+		/*dprintkl(KERN_DEBUG, "Alloc %li bytes at %p for tracebuf %i\n", */
 		/*      PAGE_SIZE, ptr, SRBIdx); */
 		i =3D 0;
 		while (i < bufs_per_page && SRBIdx < DC395x_MAX_SRB_CNT)
@@ -5159,8 +4975,7 @@
 		pACB->TmpSRB.debugtrace =3D ptr + (i * DEBUGTRACEBUFSZ);
 		pACB->TmpSRB.debugtrace[0] =3D 0;
 	} else
-		printk(DC395X_NAME
-		       ": No space for tmpSRB tracebuf reserved?!\n");
+		dprintkl(KERN_DEBUG, "No space for tmpSRB tracebuf reserved?!\n");
 	return 0;
 }
 #endif
@@ -5173,9 +4988,9 @@
 	const unsigned SRBs_per_page =3D
 	    PAGE_SIZE / (DC395x_MAX_SG_LISTENTRY * sizeof(struct SGentry));
 	for (srbidx =3D 0; srbidx < SRBIdx; srbidx +=3D SRBs_per_page) {
-		/*printk (DC395X_NAME ": Free SG segs %p (for %i)\n", */
+		/*dprintkl(KERN_DEBUG, "Free SG segs %p (for %i)\n", */
 		/*      pACB->SRB_array[srbidx].SegmentX, srbidx); */
-		KFREE(pACB->SRB_array[srbidx].SegmentX);
+		dc395x_kfree(pACB->SRB_array[srbidx].SegmentX);
 	}
 }
=20
@@ -5194,14 +5009,14 @@
 	int SRBIdx =3D 0;
 	unsigned i =3D 0;
 	struct SGentry *ptr;
-	/*printk (DC395X_NAME ": Alloc %i pages for SG tables\n", pages); */
+	/*dprintkl(KERN_DEBUG, "Alloc %i pages for SG tables\n", pages); */
 	while (pages--) {
-		ptr =3D (struct SGentry *) KMALLOC(PAGE_SIZE, GFP_KERNEL);
+		ptr =3D (struct SGentry *) dc395x_kmalloc(PAGE_SIZE, GFP_KERNEL);
 		if (!ptr) {
 			DC395x_free_SG_tables(pACB, SRBIdx);
 			return 1;
 		}
-		/*printk (DC395X_NAME ": Alloc %li bytes at %p for SG segments %i\n"=
, */
+		/*dprintkl(KERN_DEBUG, "Alloc %li bytes at %p for SG segments %i\n",=
 */
 		/*      PAGE_SIZE, ptr, SRBIdx); */
 		i =3D 0;
 		while (i < SRBs_per_page && SRBIdx < DC395x_MAX_SRB_CNT)
@@ -5212,8 +5027,7 @@
 		pACB->TmpSRB.SegmentX =3D
 		    ptr + (i * DC395x_MAX_SG_LISTENTRY);
 	else
-		printk(DC395X_NAME
-		       ": No space for tmpSRB SG table reserved?!\n");
+		dprintkl(KERN_DEBUG, "No space for tmpSRB SG table reserved?!\n");
 	return 0;
 }
=20
@@ -5306,13 +5120,12 @@
 	 * link all device's SRB Q of this adapter=20
 	 */
 	if (DC395x_alloc_SG_tables(pACB)) {
-		printk(DC395X_NAME ": SG table allocation failed!\n");
+		dprintkl(KERN_DEBUG, "SG table allocation failed!\n");
 		return 1;
 	}
-#ifdef DC395x_DEBUGTRACE
+#if debug_enabled(DBG_TRACE|DBG_TRACEALL)
 	if (DC395x_alloc_tracebufs(pACB)) {
-		printk(DC395X_NAME
-		       ": SG trace buffer allocation failed!\n");
+		dprintkl(KERN_DEBUG, "SG trace buffer allocation failed!\n");
 		DC395x_free_SG_tables(pACB, DC395x_MAX_SRB_CNT);
 		return 1;
 	}
@@ -5329,15 +5142,11 @@

 	for (i =3D 0; i < DC395x_MAX_SCSI_ID; i++)
 		pACB->DCBmap[i] =3D 0;
-#ifdef DC395x_DEBUG0
-	printk(KERN_INFO DC395X_NAME
-	       ": pACB =3D %p, pDCBmap =3D %p, pSRB_array =3D %p\n", pACB,
+	dprintkdbg(DBG_0, "pACB =3D %p, pDCBmap =3D %p, pSRB_array =3D %p\n",=
 pACB,
 	       pACB->DCBmap, pACB->SRB_array);
-	printk(KERN_INFO DC395X_NAME
-	       ": ACB size=3D %04lx, DCB size=3D %04lx, SRB size=3D %04lx\n",
+	dprintkdbg(DBG_0, "ACB size=3D %04x, DCB size=3D %04x, SRB size=3D %0=
4x\n",
 	       sizeof(struct AdapterCtlBlk), sizeof(struct DeviceCtlBlk),
 	       sizeof(struct ScsiReqBlk));
-#endif
 	return 0;
 }

@@ -5374,16 +5183,14 @@
 	}

 	if (!request_region(io_port, host->n_io_port, DC395X_NAME)) {
-		printk(KERN_ERR DC395X_NAME
-		       ": Failed to reserve IO region 0x%x\n", io_port);
+		dprintkl(KERN_ERR, "Failed to reserve IO region 0x%x\n", io_port);
 		return -1;
 	}
 	if (!used_irq) {
 		if (request_irq
 		    (irq, DC395x_Interrupt, SA_SHIRQ, DC395X_NAME,
 		     (void *) host->hostdata)) {
-			printk(KERN_INFO DC395X_NAME
-			       ": Failed to register IRQ!\n");
+			dprintkl(KERN_INFO, "Failed to register IRQ!\n");
 			return -1;
 		}
 	}
@@ -5414,8 +5221,7 @@
 		pACB->Config |=3D HCC_SCSI_RESET;

 	if (pACB->Config & HCC_SCSI_RESET) {
-		printk(KERN_INFO DC395X_NAME
-		       ": Performing initial SCSI bus reset\n");
+		dprintkl(KERN_INFO, "Performing initial SCSI bus reset\n");
 		DC395x_write8(TRM_S1040_SCSI_CONTROL, DO_RSTSCSI);
=20
 		/*while (!( DC395x_read8(TRM_S1040_SCSI_INTSTATUS) & INT_SCSIRESET )=
); */
@@ -5694,8 +5500,8 @@
 		 * Checksum is wrong.=20
 		 * Load a set of defaults into the eeprom buffer
 		 */
-		printk(KERN_WARNING DC395X_NAME
-		       ": EEProm checksum error: using default values and options.\n=
");
+		dprintkl(KERN_WARNING,=20
+		       "EEProm checksum error: using default values and options.\n")=
;
 		eeprom->NvramSubVendorID[0] =3D (u8) PCI_VENDOR_ID_TEKRAM;
 		eeprom->NvramSubVendorID[1] =3D
 		    (u8) (PCI_VENDOR_ID_TEKRAM >> 8);
@@ -5753,7 +5559,7 @@
 	u8 bval;

 	bval =3D DC395x_read8(TRM_S1040_GEN_STATUS);
-	printk(KERN_INFO DC395X_NAME "%c: Connectors: ",
+	dprintkl(KERN_INFO, "%c: Connectors: ",
 	       ((bval & WIDESCSI) ? 'W' : ' '));
 	if (!(bval & CON5068))
 		printk("ext%s ", !(bval & EXT68HIGH) ? "68" : "50");
@@ -5807,12 +5613,11 @@
 	/*$$$$$$$$$$$  MEMORY ALLOCATE FOR ADAPTER CONTROL BLOCK $$$$$$$$$$$$=
 */
 	host =3D scsi_register(host_template, sizeof(struct AdapterCtlBlk));
 	if (!host) {
-		printk(KERN_INFO DC395X_NAME
-		       " : pSH scsi_register ERROR\n");
+		dprintkl(KERN_INFO, "pSH scsi_register ERROR\n");
 		return 0;
 	}
-	printk(KERN_INFO DC395X_NAME
-	       ": Used settings: AdapterID=3D%02i, Speed=3D%i(%02i.%01iMHz), =
DevMode=3D0x%02x\n",
+	dprintkl(KERN_INFO,
+	       "Used settings: AdapterID=3D%02i, Speed=3D%i(%02i.%01iMHz), De=
vMode=3D0x%02x\n",
 	       dc395x_trm_eepromBuf[index].NvramScsiId,
 	       dc395x_trm_eepromBuf[index].NvramTarget[0].NvmTarPeriod,
 	       dc395x_clock_speed[dc395x_trm_eepromBuf[index].
@@ -5820,8 +5625,8 @@
 	       dc395x_clock_speed[dc395x_trm_eepromBuf[index].
 				  NvramTarget[0].NvmTarPeriod] % 10,
 	       dc395x_trm_eepromBuf[index].NvramTarget[0].NvmTarCfg0);
-	printk(KERN_INFO DC395X_NAME
-	       ":      AdaptMode=3D0x%02x, Tags=3D%i(%02i), DelayReset=3D%is\=
n",
+	dprintkl(KERN_INFO,
+	       "               AdaptMode=3D0x%02x, Tags=3D%i(%02i), DelayRese=
t=3D%is\n",
 	       dc395x_trm_eepromBuf[index].NvramChannelCfg,
 	       dc395x_trm_eepromBuf[index].NvramMaxTag,
 	       1 << dc395x_trm_eepromBuf[index].NvramMaxTag,
@@ -5851,8 +5656,8 @@
 		/*DC395x_ACB_UNLOCK(pACB,acb_flags); */
 		return host;
 	} else {
-		printk(KERN_INFO DC395X_NAME
-		       ": DC395x_initAdapter initial ERROR\n");
+		dprintkl(KERN_INFO,
+		       "DC395x_initAdapter initial ERROR\n");
 		scsi_unregister(host);
 		/*DC395x_ACB_UNLOCK(pACB,acb_flags); */
 		return 0;
@@ -5881,11 +5686,10 @@
=20
 	/* without PCI we cannot do anything */
 	if (pci_present() =3D=3D 0) {
-		printk(KERN_INFO DC395X_NAME ": PCI not present\n");
+		dprintkl(KERN_INFO, "PCI not present\n");
 		return 0;
 	}
-	printk(KERN_INFO DC395X_NAME ": %s %s\n", DC395X_BANNER,
-	       DC395X_VERSION);
+	dprintkl(KERN_INFO, "%s %s\n", DC395X_BANNER, DC395X_VERSION);

 	while ((pdev =3D
 		pci_find_device(PCI_VENDOR_ID_TEKRAM,
@@ -5897,10 +5701,7 @@
 		io_port =3D
 		    pci_resource_start(pdev, 0) & PCI_BASE_ADDRESS_IO_MASK;
 		irq =3D pdev->irq;
-#ifdef DC395x_DEBUG0
-		printk(KERN_INFO DC395X_NAME ": IO_PORT=3D%04x,IRQ=3D%x\n",
-		       (unsigned int) io_port, irq);
-#endif
+		dprintkdbg(DBG_0, "IO_PORT=3D%04x,IRQ=3D%x\n", (unsigned int) io_por=
t, irq);
 		if ((scsi_host =3D
 		     DC395x_init(host_template, io_port, irq,
 				 DC395x_adapterCnt))) {
@@ -5915,7 +5716,7 @@
 	if (DC395x_adapterCnt) {
 		host_template->proc_name =3D DC395X_NAME;
 	}
-	printk(KERN_INFO DC395X_NAME ": %s: %i adapters found\n",
+	dprintkl(KERN_INFO, "%s: %i adapters found\n",
 	       DC395X_BANNER, DC395x_adapterCnt);
=20
 	return DC395x_adapterCnt;
@@ -5935,11 +5736,11 @@
 	    (struct AdapterCtlBlk *) cmd->device->host->hostdata;
 	struct DeviceCtlBlk *pDCB =3D
 	    DC395x_findDCB(pACB, cmd->device->id, cmd->device->lun);
-#ifdef DC395x_DEBUGTRACE
+#if debug_enabled(DBG_TRACE|DBG_TRACEALL)
 	struct ScsiReqBlk *pSRB =3D pACB->pFreeSRB;
 #endif
-	printk(KERN_INFO DC395X_NAME
-	       ": INQUIRY (%02i-%i) returned %08x: %02x %02x %02x %02x ...\n"=
,
+	dprintkl(KERN_INFO,
+	       "INQUIRY (%02i-%i) returned %08x: %02x %02x %02x %02x ...\n",
 	       cmd->device->id, cmd->device->lun, cmd->result,
 	       ((u8 *) cmd->request_buffer)[0],
 	       ((u8 *) cmd->request_buffer)[1],
@@ -5947,7 +5748,7 @@
 	       ((u8 *) cmd->request_buffer)[3]);
 	/*TRACEOUT ("%s\n", pSRB->debugtrace); */
 	if (cmd->result) {
-		printk(DC395X_NAME ": Unsetting Wide, Sync and TagQ!\n");
+		dprintkl(KERN_INFO, "Unsetting Wide, Sync and TagQ!\n");
 		if (pDCB) {
 			TRACEOUT("%s\n", pSRB->debugtrace);
 			pDCB->DevMode &=3D
@@ -5965,8 +5766,8 @@
 			pDCB->SyncMode &=3D ~WIDE_NEGO_ENABLE;
 		}
 	} else {
-		printk(DC395X_NAME
-		       ": ERROR! No DCB existent for %02i-%i ?\n",
+		dprintkl(KERN_ERR,
+		       "ERROR! No DCB existent for %02i-%i ?\n",
 		       cmd->device->id, cmd->device->lun);
 	}
 	kfree(cmd->buffer);
@@ -5981,15 +5782,15 @@
 {
 	char *buffer;
 	Scsi_Cmnd *cmd;
-	cmd =3D KMALLOC(sizeof(Scsi_Cmnd), GFP_ATOMIC);
+	cmd =3D dc395x_kmalloc(sizeof(Scsi_Cmnd), GFP_ATOMIC);
 	if (!cmd) {
-		printk(DC395X_NAME ": kmalloc failed in inquiry!\n");
+		dprintkl(KERN_ERR, "kmalloc failed in inquiry!\n");
 		return;
 	}
 	buffer =3D kmalloc(256, GFP_ATOMIC);
 	if (!buffer) {
 		kfree(cmd);
-		printk(DC395X_NAME ": kmalloc failed in inquiry!\n");
+		dprintkl(KERN_ERR, "kmalloc failed in inquiry!\n");
 		return;
 	}

@@ -6022,8 +5823,8 @@
 	pDCB->SyncMode |=3D SYNC_NEGO_ENABLE;
 	pDCB->SyncMode &=3D ~WIDE_NEGO_DONE;
 	pDCB->SyncMode |=3D WIDE_NEGO_ENABLE;
-	printk(KERN_INFO DC395X_NAME
-	       ": Queue INQUIRY command to dev %02i-%i\n", pDCB->TargetID,
+	dprintkl(KERN_INFO,=20
+	       "Queue INQUIRY command to dev %02i-%i\n", pDCB->TargetID,
 	       pDCB->TargetLUN);
 	DC395x_queue_command(cmd, DC395x_inquiry_done);
 }
@@ -6182,7 +5983,7 @@
 				pDCB->TargetID, pDCB->TargetLUN,
 				pDCB->GoingSRBCnt);
 		for (pSRB =3D pDCB->pGoingSRB; pSRB; pSRB =3D pSRB->pNextSRB)
-#ifdef DC395x_DEBUGTRACE
+#if debug_enabled(DBG_TRACE|DBG_TRACEALL)
 			SPRINTF("\n  %s", pSRB->debugtrace);
 #else
 			SPRINTF(" %li", pSRB->pcmd->pid);
@@ -6192,14 +5993,14 @@
 		pDCB =3D pDCB->pNextDCB;
 	}

-#ifdef DC395x_DEBUGDCB
-	SPRINTF("DCB list for ACB %p:\n", pACB);
-	pDCB =3D pACB->pLinkDCB;
-	SPRINTF("%p", pDCB);
-	for (dev =3D 0; dev < pACB->DCBCnt; dev++, pDCB =3D pDCB->pNextDCB)
-		SPRINTF("->%p", pDCB->pNextDCB);
-	SPRINTF("\n");
-#endif
+	if (debug_enabled(DBG_DCB)) {
+		SPRINTF("DCB list for ACB %p:\n", pACB);
+		pDCB =3D pACB->pLinkDCB;
+		SPRINTF("%p", pDCB);
+		for (dev =3D 0; dev < pACB->DCBCnt; dev++, pDCB =3D pDCB->pNextDCB)
+			SPRINTF("->%p", pDCB->pNextDCB);
+		SPRINTF("\n");
+	}
=20
 	*start =3D buffer + offset;
 	DC395x_UNLOCK_IO(pACB->pScsiHost);
@@ -6238,7 +6039,7 @@
 		DC395x_ResetSCSIBus(pACB);

 	DC395x_read8(TRM_S1040_SCSI_INTSTATUS);
-#ifdef DC395x_DEBUGTRACE
+#if debug_enabled(DBG_TRACE|DBG_TRACEALL)
 	DC395x_free_tracebufs(pACB, DC395x_MAX_SRB_CNT);
 #endif
 	DC395x_free_SG_tables(pACB, DC395x_MAX_SRB_CNT);
@@ -6256,19 +6057,14 @@
 	struct AdapterCtlBlk *pACB =3D
 	    (struct AdapterCtlBlk *) (host->hostdata);

-	DCBDEBUG(printk
-		 (KERN_INFO DC395X_NAME ": Free %i DCBs\n", pACB->DCBCnt);
-	    )
-	    pDCB =3D pACB->pLinkDCB;
+	dprintkdbg(DBG_DCB, "Free %i DCBs\n", pACB->DCBCnt);
+	pDCB =3D pACB->pLinkDCB;
 	if (pDCB) {
 		do {
 			nDCB =3D pDCB->pNextDCB;
-			DCBDEBUG(printk
-				 (KERN_INFO DC395X_NAME
-				  ": Free DCB (ID %i, LUN %i): %p\n",
+			dprintkdbg(DBG_DCB, "Free DCB (ID %i, LUN %i): %p\n",
 				  pDCB->TargetID, pDCB->TargetLUN, pDCB);
-			    )
-			    DC395x_remove_dev(pACB, pDCB);	/* includes a KFREE(pDCB); */
+			DC395x_remove_dev(pACB, pDCB);	/* includes a dc395x_kfree(pDCB); */
 			printk(".");
 			pDCB =3D nDCB;
 		} while (pDCB && pACB->pLinkDCB);
@@ -6288,7 +6084,7 @@
 	    (struct AdapterCtlBlk *) (host->hostdata);
 	unsigned long flags;

-	printk(DC395X_NAME ": release");
+	dprintkl(KERN_DEBUG, "release");
=20
 	DC395x_LOCK_IO(pACB->pScsiHost);
 	DC395x_shutdown(host);

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
