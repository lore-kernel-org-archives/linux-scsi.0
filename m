From: Oliver Neukum <oliver@neukum.org>
Subject: [PATCH 1/2]DC395: Debugging cleanup
Date: Tue, 27 May 2003 22:37:38 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200305272237.38751.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Mail1.kontent.de ([81.88.34.36]:36562 "EHLO Mail1.KONTENT.De")
	by vger.kernel.org with ESMTP id S264080AbTE0U17 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 May 2003 16:27:59 -0400
Received: from pD9E4D453.dip.t-dialin.net (pD9E4D453.dip.t-dialin.net [217.228.212.83])
	by Mail1.KONTENT.De (Postfix) with ESMTP id AEDAE10BE73
	for <linux-scsi@vger.kernel.org>; Tue, 27 May 2003 22:41:23 +0200 (CEST)
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
@@ -1403,52 +1399,49 @@

 	if (pACB->QueryCnt) {
 		/* Unsent commands ? */
-		DEBUG0(printk(DC395X_NAME ": QueryCnt !=3D 0\n");
-		    )
-		    DC395x_Query_append(cmd, pACB);
+		dprintkdbg(DBG_0, "QueryCnt !=3D 0\n");
+		DC395x_Query_append(cmd, pACB);
 		DC395x_Waiting_process(pACB);
 	} else {
 		if (pDCB->pWaitingSRB) {
 			pSRB =3D DC395x_Free_get(pACB);
-			DEBUG0(if (!pSRB)
-			       printk(DC395X_NAME
-				      ": No free SRB but Waiting\n");
-			       else
-			       printk(DC395X_NAME
-				      ": Free SRB w/ Waiting\n");)
-				if (!pSRB) {
-					DC395x_Query_append(cmd, pACB);
-				} else {
-					DC395x_BuildSRB(cmd, pDCB, pSRB);
-					DC395x_Waiting_append(pDCB, pSRB);
-				}
+			if (debug_enabled(DBG_0)) {
+				if (!pSRB)
+					dprintkdbg(DBG_0, "No free SRB but Waiting\n");
+				else
+					dprintkdbg(DBG_0, "Free SRB w/ Waiting\n");
+			}
+			if (!pSRB) {
+				DC395x_Query_append(cmd, pACB);
+			} else {
+				DC395x_BuildSRB(cmd, pDCB, pSRB);
+				DC395x_Waiting_append(pDCB, pSRB);
+			}
 			DC395x_Waiting_process(pACB);
 		} else {
 			pSRB =3D DC395x_Free_get(pACB);
-			DEBUG0(if (!pSRB)
-			       printk(DC395X_NAME
-				      ": No free SRB w/o Waiting\n");
-			       else
-			       printk(DC395X_NAME
-				      ": Free SRB w/o Waiting\n");)
-				if (!pSRB) {
-					DC395x_Query_append(cmd, pACB);
-					DC395x_Waiting_process(pACB);
-				} else {
-					DC395x_BuildSRB(cmd, pDCB, pSRB);
-					DC395x_SendSRB(pACB, pSRB);
-				}
+			if (debug_enabled(DBG_0)) {
+				if (!pSRB)
+					dprintkdbg(DBG_0, "No free SRB w/o Waiting\n");
+				else
+					dprintkdbg(DBG_0, "Free SRB w/o Waiting\n");
+			}
+			if (!pSRB) {
+				DC395x_Query_append(cmd, pACB);
+				DC395x_Waiting_process(pACB);
+			} else {
+				DC395x_BuildSRB(cmd, pDCB, pSRB);
+				DC395x_SendSRB(pACB, pSRB);
+			}
 		}
 	}

 	/*DC395x_ACB_LOCK(pACB,acb_flags); */
-	DEBUG1(printk
-	       (KERN_DEBUG " ... command (pid %li) queued successfully.\n",
-		cmd->pid);
-	    )
-	    DEBUGRECURSION(in_driver--;
-	    )
-	    return 0;
+	dprintkdbg(DBG_1, "... command (pid %li) queued successfully.\n", cmd=
->pid);
+#if debug_enabled(DBG_RECURSION)
+	dbg_in_driver--
+#endif
+	return 0;
 }
=20

@@ -1546,10 +1539,7 @@
 	struct AdapterCtlBlk *pACB;
 	int size =3D capacity;

-#ifdef DC395x_DEBUG0
-	printk(KERN_INFO DC395X_NAME
-	       ":DC395x_bios_param..............\n ");
-#endif
+	dprintkdbg(DBG_0, "DC395x_bios_param..............\n");
 	pACB =3D (struct AdapterCtlBlk *) sdev->host->hostdata;
 	heads =3D 64;
 	sectors =3D 32;
@@ -1586,12 +1576,10 @@
 		pSRB =3D pDCB->pActiveSRB;
 	if (pSRB) {
 		if (!(pSRB->pcmd))
-			printk(DC395X_NAME
-			       ": dump: SRB %p: cmd %p OOOPS!\n", pSRB,
+			dprintkl(KERN_INFO, "dump: SRB %p: cmd %p OOOPS!\n", pSRB,
 			       pSRB->pcmd);
 		else
-			printk(DC395X_NAME
-			       ": dump: SRB %p: cmd %p pid %li: %02x (%02i-%i)\n",
+			dprintkl(KERN_INFO, "dump: SRB %p: cmd %p pid %li: %02x (%02i-%i)\n=
",
 			       pSRB, pSRB->pcmd, pSRB->pcmd->pid,
 			       pSRB->pcmd->cmnd[0], pSRB->pcmd->device->id,
 			       pSRB->pcmd->device->lun);
@@ -1604,7 +1592,7 @@
 		     (pACB->pActiveDCB) ? "" : "not");
 		TRACEOUT("        %s\n", pSRB->debugtrace);
 	}
-	printk(DC395X_NAME ": dump: SCSI block\n");
+	dprintkl(KERN_INFO, "dump: SCSI block\n");
 	printk
 	    ("              Status %04x FIFOCnt %02x Signals %02x IRQStat %02=
x\n",
 	     DC395x_read16(TRM_S1040_SCSI_STATUS),
@@ -1624,7 +1612,7 @@
 	     DC395x_read8(TRM_S1040_SCSI_CONFIG2),
 	     DC395x_read8(TRM_S1040_SCSI_COMMAND),
 	     DC395x_read8(TRM_S1040_SCSI_TIMEOUT));
-	printk(DC395X_NAME ": dump: DMA block\n");
+	dprintkl(KERN_INFO, "dump: DMA block\n");
 	printk
 	    ("              Cmd %04x FIFOCnt %02x FStat %02x IRQStat %02x IRQ=
En %02x Cfg %04x\n",
 	     DC395x_read16(TRM_S1040_DMA_COMMAND),
@@ -1638,12 +1626,11 @@
 	       DC395x_read32(TRM_S1040_DMA_CXCNT),
 	       DC395x_read32(TRM_S1040_DMA_XHIGHADDR),
 	       DC395x_read32(TRM_S1040_DMA_XLOWADDR));
-	printk(DC395X_NAME
-	       ": dump: Misc: GCtrl %02x GStat %02x GTmr %02x\n",
+	dprintkl(KERN_INFO, "dump: Misc: GCtrl %02x GStat %02x GTmr %02x\n",
 	       DC395x_read8(TRM_S1040_GEN_CONTROL),
 	       DC395x_read8(TRM_S1040_GEN_STATUS),
 	       DC395x_read8(TRM_S1040_GEN_TIMER));
-	printk(DC395X_NAME ": dump: PCI Status %04x\n", pstat);
+	dprintkl(KERN_INFO, "dump: PCI Status %04x\n", pstat);

=20
 }
@@ -1651,18 +1638,20 @@

 static inline void DC395x_clrfifo(struct AdapterCtlBlk *pACB, char *tx=
t)
 {
-#ifdef DC395x_DEBUGFIFO
+#if debug_enabled(DBG_FIFO)
 	u8 lines =3D DC395x_read8(TRM_S1040_SCSI_SIGNAL);
 	u8 fifocnt =3D DC395x_read8(TRM_S1040_SCSI_FIFOCNT);
 	if (!(fifocnt & 0x40))
-		printk(DC395X_NAME
-		       ": Clr FIFO (%i bytes) on phase %02x in %s\n",
-		       fifocnt & 0x3f, lines, txt);
+		dprintkdbg(DBG_FIFO,
+		       "Clr FIFO (%i bytes) on phase %02x in %s\n",
+			fifocnt & 0x3f, lines, txt);
 #endif
+#if debug_enabled(DBG_TRACE)  =20
 	if (pACB->pActiveDCB && pACB->pActiveDCB->pActiveSRB) {
 		struct ScsiReqBlk *pSRB =3D pACB->pActiveDCB->pActiveSRB;
 		TRACEPRINTF("#*");
 	}
+#endif
 	DC395x_write16(TRM_S1040_SCSI_CONTROL, DO_CLRFIFO);
 }
=20
@@ -1682,10 +1671,7 @@
 	u8 PeriodIndex;
 	u16 index;
=20
-#ifdef DC395x_DEBUG0
-	printk(KERN_INFO DC395X_NAME
-	       ": DC395x_ResetDevParam..............\n ");
-#endif
+	dprintkdbg(DBG_0, "DC395x_ResetDevParam..............\n");
 	pDCB =3D pACB->pLinkDCB;
 	if (pDCB =3D=3D NULL)
 		return;
@@ -1728,7 +1714,7 @@
 	struct AdapterCtlBlk *pACB;
 	/*u32         acb_flags=3D0; */
=20
-	printk(KERN_INFO DC395X_NAME ": reset requested!\n");
+	dprintkl(KERN_INFO, "reset requested!\n");
 	pACB =3D (struct AdapterCtlBlk *) cmd->device->host->hostdata;
 	/* mid level guarantees no recursion */
 	/*DC395x_ACB_LOCK(pACB,acb_flags); */
@@ -1797,7 +1783,7 @@
 	int cnt =3D pACB->QueryCnt;
 	Scsi_Cmnd *pcmd;
 	Scsi_Cmnd *last =3D 0;
-	printk(DC395X_NAME ": DC395x_eh_abort: cmd %p (pid %li, %02i-%i) ",
+	dprintkl(KERN_INFO, "eh abort: cmd %p (pid %li, %02i-%i) ",
 	       cmd, cmd->pid, cmd->device->id, cmd->device->lun);
 	for (pcmd =3D pACB->pQueryHead; cnt--;
 	     last =3D pcmd, pcmd =3D (Scsi_Cmnd *) pcmd->host_scribble) {
@@ -1821,7 +1807,7 @@
 	}
 	pDCB =3D DC395x_findDCB(pACB, cmd->device->id, cmd->device->lun);
 	if (!pDCB) {
-		printk("no DCB !\n");
+		printk("no DCB!\n");
 		return FAILED;
 	}

@@ -1863,8 +1849,8 @@
 {
 	u8 *ptr =3D pSRB->MsgOutBuf + pSRB->MsgCnt;
 	if (pSRB->MsgCnt > 1) {
-		printk(DC395X_NAME
-		       ": Build_SDTR: MsgOutBuf BUSY (%i: %02x %02x)\n",
+		dprintkl(KERN_INFO,
+		       "Build_SDTR: MsgOutBuf BUSY (%i: %02x %02x)\n",
 		       pSRB->MsgCnt, pSRB->MsgOutBuf[0],
 		       pSRB->MsgOutBuf[1]);
 		return;
@@ -1897,8 +1883,8 @@
 	    ? 1 : 0;
 	u8 *ptr =3D pSRB->MsgOutBuf + pSRB->MsgCnt;
 	if (pSRB->MsgCnt > 1) {
-		printk(DC395X_NAME
-		       ": Build_WDTR: MsgOutBuf BUSY (%i: %02x %02x)\n",
+		dprintkl(KERN_INFO,
+		       "Build_WDTR: MsgOutBuf BUSY (%i: %02x %02x)\n",
 		       pSRB->MsgCnt, pSRB->MsgOutBuf[0],
 		       pSRB->MsgOutBuf[1]);
 		return;
@@ -1940,9 +1926,9 @@
 	unsigned long flags;
 	struct AdapterCtlBlk *pACB =3D (struct AdapterCtlBlk *) ptr;
 	struct ScsiReqBlk *pSRB;
-	printk(DC395X_NAME ": Debug: Chip forgot to produce SelTO IRQ!\n");
+	dprintkl(KERN_DEBUG, "Chip forgot to produce SelTO IRQ!\n");
 	if (!pACB->pActiveDCB || !pACB->pActiveDCB->pActiveSRB) {
-		printk(DC395X_NAME ": ... but no cmd pending? Oops!\n");
+		dprintkl(KERN_DEBUG, " ... but no cmd pending? Oops!\n");
 		return;
 	}
 	DC395x_LOCK_IO(pACB->pScsiHost);
@@ -1967,10 +1953,7 @@
 	u8 s_stat, scsicommand, i, identify_message;
 	u8 *ptr;
=20
-#ifdef DC395x_DEBUG0
-	printk(KERN_INFO DC395X_NAME
-	       ": DC395x_StartSCSI..............\n ");
-#endif
+	dprintkdbg(DBG_0, "DC395x_StartSCSI..............\n");
 	pSRB->TagNumber =3D TAG_NONE;	/* pACB->TagMaxNum: had error read in e=
eprom */

 	s_stat =3D DC395x_read8(TRM_S1040_SCSI_SIGNAL);
@@ -1979,12 +1962,10 @@
 	TRACEPRINTF("Start %02x *", s_stat);
 #if 1
 	if (s_stat & 0x20 /* s_stat2 & 0x02000 */ ) {
-#ifdef DC395x_DEBUG_KG
-		printk(DC395X_NAME
-		       ": Debug: StartSCSI: pid %li(%02i-%i): BUSY %02x %04x\n",
+		dprintkdbg(DBG_KG,
+		       "StartSCSI: pid %li(%02i-%i): BUSY %02x %04x\n",
 		       pSRB->pcmd->pid, pDCB->TargetID, pDCB->TargetLUN,
 		       s_stat, s_stat2);
-#endif
 		/*
 		 * Try anyway?
 		 *
@@ -2002,11 +1983,9 @@
 	}
 #endif
 	if (pACB->pActiveDCB) {
-		printk(DC395X_NAME
-		       ": We try to start a SCSI command (%li)!\n",
+		dprintkl(KERN_DEBUG, "We try to start a SCSI command (%li)!\n",
 		       pSRB->pcmd->pid);
-		printk(DC395X_NAME
-		       ": While another one (%li) is active!!\n",
+		dprintkl(KERN_DEBUG, "While another one (%li) is active!!\n",
 		       (pACB->pActiveDCB->pActiveSRB ? pACB->pActiveDCB->
 			pActiveSRB->pcmd->pid : 0));
 		TRACEOUT(" %s\n", pSRB->debugtrace);
@@ -2016,21 +1995,17 @@
 		return 1;
 	}
 	if (DC395x_read16(TRM_S1040_SCSI_STATUS) & SCSIINTERRUPT) {
-#ifdef DC395x_DEBUG_KG
-		printk(DC395X_NAME
-		       ": Debug: StartSCSI failed (busy) for pid %li(%02i-%i)\n",
+		dprintkdbg(DBG_KG,
+		       "StartSCSI failed (busy) for pid %li(%02i-%i)\n",
 		       pSRB->pcmd->pid, pDCB->TargetID, pDCB->TargetLUN);
-#endif
 		TRACEPRINTF("=B0*");
 		return 1;
 	}
 	/* Allow starting of SCSI commands half a second before we allow the =
mid-level
 	 * to queue them again after a reset */
 	if (time_before(jiffies, pACB->pScsiHost->last_reset - HZ / 2)) {
-#ifdef DC395x_DEBUG_KG
-		printk(DC395X_NAME
-		       ": We were just reset and don't accept commands yet!\n");
-#endif
+		dprintkdbg(DBG_KG,
+		       "We were just reset and don't accept commands yet!\n");
 		return 1;
 	}

@@ -2098,8 +2073,8 @@
 			tag_number++;
 		}
 		if (tag_number >=3D pDCB->MaxCommand) {
-			printk(KERN_WARNING DC395X_NAME
-			       ": Start_SCSI: Out of tags for pid %li (%i-%i)\n",
+			dprintkl(KERN_WARNING,
+			       "Start_SCSI: Out of tags for pid %li (%i-%i)\n",
 			       pSRB->pcmd->pid, pSRB->pcmd->device->id,
 			       pSRB->pcmd->device->lun);
 			pSRB->SRBState =3D SRB_READY;
@@ -2124,13 +2099,11 @@
 	/*
 	 *          Send CDB ..command block .........
 	 */
-#ifdef DC395x_DEBUG_KG
-	printk(KERN_INFO DC395X_NAME
-	       ": StartSCSI (pid %li) %02x (%i-%i): Tag %i\n",
+	dprintkdbg(DBG_KG,=20
+	       "StartSCSI (pid %li) %02x (%i-%i): Tag %i\n",
 	       pSRB->pcmd->pid, pSRB->pcmd->cmnd[0],
 	       pSRB->pcmd->device->id, pSRB->pcmd->device->lun,
 	       pSRB->TagNumber);
-#endif
 	if (pSRB->SRBFlag & AUTO_REQSENSE) {
 		DC395x_write8(TRM_S1040_SCSI_FIFO, REQUEST_SENSE);
 		DC395x_write8(TRM_S1040_SCSI_FIFO, (pDCB->TargetLUN << 5));
@@ -2153,14 +2126,11 @@
 		 * we caught an interrupt (must be reset or reselection ... )
 		 * : Let's process it first!
 		 */
-		DEBUG0(printk
-		       (DC395X_NAME
-			": Debug: StartSCSI failed (busy) for pid %li(%02i-%i)!\n",
+		dprintkdbg(DBG_0, "Debug: StartSCSI failed (busy) for pid %li(%02i-%=
i)!\n",
 			pSRB->pcmd->pid, pDCB->TargetID, pDCB->TargetLUN);
-		    )
-		    /*DC395x_clrfifo (pACB, "Start2"); */
-		    /*DC395x_write16 (TRM_S1040_SCSI_CONTROL, DO_HWRESELECT | DO_DAT=
ALATCH); */
-		    pSRB->SRBState =3D SRB_READY;
+		/*DC395x_clrfifo (pACB, "Start2"); */
+		/*DC395x_write16 (TRM_S1040_SCSI_CONTROL, DO_HWRESELECT | DO_DATALAT=
CH); */
+		pSRB->SRBState =3D SRB_READY;
 		DC395x_freetag(pDCB, pSRB);
 		pSRB->MsgCnt =3D 0;
 		return_code =3D 1;
@@ -2216,22 +2186,22 @@
 	/* This acknowledges the IRQ */
 	scsi_intstatus =3D DC395x_read8(TRM_S1040_SCSI_INTSTATUS);
 	if ((scsi_status & 0x2007) =3D=3D 0x2002)
-		printk(DC395X_NAME ": COP after COP completed? %04x\n",
+		dprintkl(KERN_DEBUG, "COP after COP completed? %04x\n",
 		       scsi_status);
-#if 1				/*def DC395x_DEBUG0 */
+#if 1				/*def DBG_0 */
 	if (DC395x_monitor_next_IRQ) {
-		printk(KERN_INFO DC395X_NAME
-		       ": status=3D%04x intstatus=3D%02x\n", scsi_status,
+		dprintkl(KERN_INFO,
+		       "status=3D%04x intstatus=3D%02x\n", scsi_status,
 		       scsi_intstatus);
 		DC395x_monitor_next_IRQ--;
 	}
 #endif
 	/*DC395x_ACB_LOCK(pACB,acb_flags); */
-#ifdef DC395x_DEBUG_KG
-	if (scsi_intstatus & INT_SELTIMEOUT)
-		printk(KERN_INFO DC395X_NAME ": Sel Timeout IRQ\n");
-#endif
-	/*printk (DC395X_NAME ": DC395x_IRQ: intstatus =3D %02x ", scsi_intst=
atus); */
+	if (debug_enabled(DBG_KG)) {
+		if (scsi_intstatus & INT_SELTIMEOUT)
+		dprintkdbg(DBG_KG, "Sel Timeout IRQ\n");
+	}
+	/*dprintkl(KERN_DEBUG, "DC395x_IRQ: intstatus =3D %02x ", scsi_intsta=
tus); */

 	if (timer_pending(&pACB->SelTO_Timer))
 		del_timer(&pACB->SelTO_Timer);
@@ -2245,8 +2215,7 @@
 		goto out_unlock;
 	}
 	if (scsi_intstatus & INT_SELECT) {
-		printk(KERN_INFO DC395X_NAME
-		       ": Host does not support target mode!\n");
+		dprintkl(KERN_INFO, "Host does not support target mode!\n");
 		goto out_unlock;
 	}
 	if (scsi_intstatus & INT_SCSIRESET) {
@@ -2256,16 +2225,14 @@
 	if (scsi_intstatus & (INT_BUSSERVICE | INT_CMDDONE)) {
 		pDCB =3D pACB->pActiveDCB;
 		if (!pDCB) {
-			printk(DC395X_NAME
-			       ": Oops: BusService (%04x %02x) w/o ActiveDCB!\n",
+			dprintkl(KERN_DEBUG,
+			       "Oops: BusService (%04x %02x) w/o ActiveDCB!\n",
 			       scsi_status, scsi_intstatus);
 			goto out_unlock;
 		}
 		pSRB =3D pDCB->pActiveSRB;
 		if (pDCB->DCBFlag & ABORT_DEV_) {
-#ifdef DC395x_DEBUG0
-			printk(KERN_INFO "MsgOut Abort Device..... ");
-#endif
+			dprintkdbg(DBG_0, "MsgOut Abort Device.....\n");
 			DC395x_EnableMsgOut_Abort(pACB, pSRB);
 		}
 		/*
@@ -2320,7 +2287,6 @@
 	return;
 }

-/*inline */
 irqreturn_t DC395x_Interrupt(int irq, void *dev_id, struct pt_regs *re=
gs)
 {
 	struct AdapterCtlBlk *pACB =3D DC395x_pACB_start;
@@ -2328,12 +2294,12 @@
 	u8 dma_status;
 	irqreturn_t handled =3D IRQ_NONE;

-#ifdef DC395x_DEBUG0
-	printk(KERN_INFO DC395X_NAME ": DC395x_Interrupt..............\n ");
+	dprintkdbg(DBG_0, "DC395x_Interrupt..............\n");
+#if debug_enabled(DBG_RECURSION)
+        if (dbg_in_driver++ > NORM_REC_LVL) {
+		dprintkl(KERN_DEBUG, "%i interrupt recursion?\n", dbg_in_driver);
+	}
 #endif
-	DEBUGRECURSION(if (in_driver++ > NORM_REC_LVL)
-		       printk(DC395X_NAME ": %i interrupt recursion?\n",
-			      in_driver);)

 	/*
 	 * Find which card generated the interrupt. Note that it may have
@@ -2362,10 +2328,10 @@
 		}
 		else if (dma_status & 0x20) {
 			/* Error from the DMA engine */
-			printk(DC395X_NAME ": Interrupt from DMA engine: %02x!\n",
+			dprintkl(KERN_INFO, "Interrupt from DMA engine: %02x!\n",
 			       dma_status);
 #if 0
-			printk(DC395X_NAME ": This means DMA error! Try to handle ...\n");
+			dprintkl(KERN_INFO, "This means DMA error! Try to handle ...\n");
 			if (pACB->pActiveDCB) {
 				pACB->pActiveDCB-> DCBFlag |=3D ABORT_DEV_;
 				if (pACB->pActiveDCB->pActiveSRB)
@@ -2373,14 +2339,16 @@
 			}
 			DC395x_write8(TRM_S1040_DMA_CONTROL, ABORTXFER | CLRXFIFO);
 #else
-			printk(DC395X_NAME ": Ignoring DMA error (probably a bad thing) ...=
\n");
+			dprintkl(KERN_INFO, "Ignoring DMA error (probably a bad thing) ...\=
n");
 			pACB =3D (struct AdapterCtlBlk *)NULL;
 #endif
 			handled =3D IRQ_HANDLED;
 		}
 	}

-	DEBUGRECURSION(in_driver--;)
+#if debug_enabled(DBG_RECURSION)
+	dbg_in_driver--
+#endif
 	return handled;
 }
=20
@@ -2397,9 +2365,7 @@
 DC395x_MsgOutPhase0(struct AdapterCtlBlk *pACB, struct ScsiReqBlk *pSR=
B,
 		    u16 * pscsi_status)
 {
-#ifdef DC395x_DEBUG0
-	printk(KERN_INFO DC395X_NAME ": DC395x_MsgOutPhase0..... ");
-#endif
+	dprintkdbg(DBG_0, "DC395x_MsgOutPhase0.....\n");
 	if (pSRB->SRBState & (SRB_UNEXPECT_RESEL + SRB_ABORT_SENT)) {
 		*pscsi_status =3D PH_BUS_FREE;	/*.. initial phase */
 	}
@@ -2425,24 +2391,18 @@
 	u8 *ptr;
 	struct DeviceCtlBlk *pDCB;

-#ifdef DC395x_DEBUG0
-	printk(KERN_INFO DC395X_NAME
-	       ": DC395x_MsgOutPhase1..............\n ");
-#endif
+	dprintkdbg(DBG_0, "DC395x_MsgOutPhase1..............\n");
 	TRACEPRINTF("MOP1*");
 	pDCB =3D pACB->pActiveDCB;
 	DC395x_clrfifo(pACB, "MOP1");
 	if (!(pSRB->SRBState & SRB_MSGOUT)) {
 		pSRB->SRBState |=3D SRB_MSGOUT;
-		printk(DC395X_NAME ": Debug: pid %li: MsgOut Phase unexpected.\n", p=
SRB->pcmd->pid);	/* So what ? */
+		dprintkl(KERN_DEBUG, "Debug: pid %li: MsgOut Phase unexpected.\n", p=
SRB->pcmd->pid);	/* So what ? */
 	}
 	if (!pSRB->MsgCnt) {
-		DEBUG0(printk
-		       (DC395X_NAME
-			": Debug: pid %li: NOP Msg (no output message there).\n",
+		dprintkdbg(DBG_0, "Debug: pid %li: NOP Msg (no output message there)=
=2E\n",
 			pSRB->pcmd->pid);
-		    )
-		    DC395x_write8(TRM_S1040_SCSI_FIFO, MSG_NOP);
+		DC395x_write8(TRM_S1040_SCSI_FIFO, MSG_NOP);
 		DC395x_write16(TRM_S1040_SCSI_CONTROL, DO_DATALATCH);	/* it's import=
ant for atn stop */
 		DC395x_write8(TRM_S1040_SCSI_COMMAND, SCMD_FIFO_OUT);
 		TRACEPRINTF("\\*");
@@ -2451,15 +2411,15 @@
 	}
 	ptr =3D (u8 *) pSRB->MsgOutBuf;
 	TRACEPRINTF("(*");
-	/*printk (DC395X_NAME ": Send msg: "); DC395x_printMsg (ptr, pSRB->Ms=
gCnt); */
-	/*printk (DC395X_NAME ": MsgOut: "); */
+	/*dprintkl(KERN_DEBUG, "Send msg: "); DC395x_printMsg (ptr, pSRB->Msg=
Cnt); */
+	/*dprintkl(KERN_DEBUG, "MsgOut: "); */
 	for (i =3D 0; i < pSRB->MsgCnt; i++) {
 		TRACEPRINTF("%02x *", *ptr);
 		DC395x_write8(TRM_S1040_SCSI_FIFO, *ptr++);
 	}
 	TRACEPRINTF(")*");
 	pSRB->MsgCnt =3D 0;
-	/*printk ("\n"); */
+	/*printk("\n"); */
 	if (			/*(pDCB->DCBFlag & ABORT_DEV_) && */
 		   (pSRB->MsgOutBuf[0] =3D=3D MSG_ABORT))
 		pSRB->SRBState =3D SRB_ABORT_SENT;
@@ -2509,10 +2469,7 @@
 	u8 *ptr;
 	u16 i;
=20
-#ifdef DC395x_DEBUG0
-	printk(KERN_INFO DC395X_NAME
-	       ": DC395x_CommandPhase1..............\n ");
-#endif
+	dprintkdbg(DBG_0, "DC395x_CommandPhase1..............\n");
 	TRACEPRINTF("COP1*");
 	DC395x_clrfifo(pACB, "COP1");
 	DC395x_write16(TRM_S1040_SCSI_CONTROL, DO_CLRATN);
@@ -2543,24 +2500,20 @@


 /* Do sanity checks for S/G list */
-#ifdef DC395x_SGPARANOIA
-static inline void DC395x_check_SG(struct ScsiReqBlk *pSRB)
-{
-	unsigned Length =3D 0;
-	unsigned Idx =3D pSRB->SRBSGIndex;
-	struct SGentry *psge =3D pSRB->SegmentX + Idx;
-	for (; Idx < pSRB->SRBSGCount; psge++, Idx++)
-		Length +=3D psge->length;
-	if (Length !=3D pSRB->SRBTotalXferLength)
-		printk(DC395X_NAME
-		       ": Inconsistent SRB S/G lengths (Tot=3D%i, Count=3D%i) !!\n",
-		       pSRB->SRBTotalXferLength, Length);
-}
-#else
 static inline void DC395x_check_SG(struct ScsiReqBlk *pSRB)
 {
+	if (debug_enabled(DBG_SGPARANOIA)) {
+		unsigned Length =3D 0;
+		unsigned Idx =3D pSRB->SRBSGIndex;
+		struct SGentry *psge =3D pSRB->SegmentX + Idx;
+		for (; Idx < pSRB->SRBSGCount; psge++, Idx++)
+			Length +=3D psge->length;
+		if (Length !=3D pSRB->SRBTotalXferLength)
+			dprintkdbg(DBG_SGPARANOIA,
+			       "Inconsistent SRB S/G lengths (Tot=3D%i, Count=3D%i) !!\n",
+			       pSRB->SRBTotalXferLength, Length);
+	}
 }
-#endif
=20

 /*
@@ -2576,10 +2529,8 @@
 	struct scatterlist *sg;
 	int segment =3D pcmd->use_sg;
=20
-#ifdef DC395x_DEBUG_KG
-	printk(DC395X_NAME ": Update SG: Total %i, Left %i\n",
+	dprintkdbg(DBG_KG, "Update SG: Total %i, Left %i\n",
 	       pSRB->SRBTotalXferLength, Left);
-#endif
 	DC395x_check_SG(pSRB);
 	psge =3D pSRB->SegmentX + pSRB->SRBSGIndex;
 	/* data that has already been transferred */
@@ -2612,28 +2563,28 @@
 		DC395x_check_SG(pSRB);
 	}
 	/* We need the corresponding virtual address sg_to_virt */
-	/*printk (DC395X_NAME ": sg_to_virt: bus %08x -> virt ", psge->addres=
s); */
+	/*dprintkl(KERN_DEBUG, "sg_to_virt: bus %08x -> virt ", psge->address=
); */
 	if (!segment) {
 		pSRB->virt_addr +=3D Xferred;
-		/*printk ("%p\n", pSRB->virt_addr); */
+		/*printk("%p\n", pSRB->virt_addr); */
 		return;
 	}
 	/* We have to walk the scatterlist to find it */
 	sg =3D (struct scatterlist *) pcmd->request_buffer;
 	while (segment--) {
-		/*printk ("(%08x)%p ", BUS_ADDR(*sg), PAGE_ADDRESS(sg)); */
+		/*printk("(%08x)%p ", BUS_ADDR(*sg), PAGE_ADDRESS(sg)); */
 		unsigned long mask =3D
 		    ~((unsigned long) sg->length - 1) & PAGE_MASK;
 		if ((BUS_ADDR(*sg) & mask) =3D=3D (psge->address & mask)) {
 			pSRB->virt_addr =3D (PAGE_ADDRESS(sg)
 					   + psge->address -
 					   (psge->address & PAGE_MASK));
-			/*printk ("%p\n", pSRB->virt_addr); */
+			/*printk("%p\n", pSRB->virt_addr); */
 			return;
 		}
 		++sg;
 	}
-	printk(DC395X_NAME ": sg_to_virt failed!\n");
+	dprintkl(KERN_ERR, "sg_to_virt failed!\n");
 	pSRB->virt_addr =3D 0;
 }
=20
@@ -2692,9 +2643,7 @@
 	u32 dLeftCounter =3D 0;
 	struct DeviceCtlBlk *pDCB =3D pSRB->pSRBDCB;

-#ifdef DC395x_DEBUG0
-	printk(KERN_INFO DC395X_NAME ": DC395x_DataOutPhase0.....\n ");
-#endif
+	dprintkdbg(DBG_0, "DC395x_DataOutPhase0.....\n");
 	TRACEPRINTF("DOP0*");
 	pDCB =3D pSRB->pSRBDCB;
 	scsi_status =3D *pscsi_status;
@@ -2711,16 +2660,12 @@
 	 * KG: Stop DMA engine pushing more data into the SCSI FIFO
 	 * If we need more data, the DMA SG list will be freshly set up, anyw=
ay
 	 */
-#ifdef DC395x_DEBUGPIO
-	printk(DC395X_NAME
-	       ": DOP0: DMA_FCNT: %02x, DMA_FSTAT: %02x, SCSI_FCNT: %02x, CTR=
 %06x, stat %04x, Tot: %06x\n",
+	dprintkdbg(DBG_PIO, "DOP0: DMA_FCNT: %02x, DMA_FSTAT: %02x, SCSI_FCNT=
: %02x, CTR %06x, stat %04x, Tot: %06x\n",
 	       DC395x_read8(TRM_S1040_DMA_FIFOCNT),
 	       DC395x_read8(TRM_S1040_DMA_FIFOSTAT),
 	       DC395x_read8(TRM_S1040_SCSI_FIFOCNT),
 	       DC395x_read32(TRM_S1040_SCSI_COUNTER), scsi_status,
 	       pSRB->SRBTotalXferLength);
-	/*DC395x_dumpinfo(pACB, pDCB, pSRB); */
-#endif
 	DC395x_write8(TRM_S1040_DMA_CONTROL, STOPDMAXFER | CLRXFIFO);

 	if (!(pSRB->SRBState & SRB_XFERPAD)) {
@@ -2744,23 +2689,22 @@
 			if (pDCB->SyncPeriod & WIDE_SYNC)
 				dLeftCounter <<=3D 1;
=20
-#ifdef DC395x_DEBUG_KG
-			printk(DC395X_NAME
-			       ": Debug: SCSI FIFO contains %i %s in DOP0\n",
+			dprintkdbg(DBG_KG,
+			       "Debug: SCSI FIFO contains %i %s in DOP0\n",
 			       DC395x_read8(TRM_S1040_SCSI_FIFOCNT),
 			       (pDCB->
 				SyncPeriod & WIDE_SYNC) ? "words" :
 			       "bytes");
-			printk(DC395X_NAME
-			       ": SCSI FIFOCNT %02x, SCSI CTR %08x\n",
+			dprintkdbg(DBG_KG,
+			       "SCSI FIFOCNT %02x, SCSI CTR %08x\n",
 			       DC395x_read8(TRM_S1040_SCSI_FIFOCNT),
 			       DC395x_read32(TRM_S1040_SCSI_COUNTER));
-			printk(DC395X_NAME
-			       ": DMA FIFOCNT %04x, FIFOSTAT %02x, DMA CTR %08x\n",
+			dprintkdbg(DBG_KG,
+			       "DMA FIFOCNT %04x, FIFOSTAT %02x, DMA CTR %08x\n",
 			       DC395x_read8(TRM_S1040_DMA_FIFOCNT),
 			       DC395x_read8(TRM_S1040_DMA_FIFOSTAT),
 			       DC395x_read32(TRM_S1040_DMA_CXCNT));
-#endif
+
 			/*
 			 * if WIDE scsi SCSI FIFOCNT unit is word !!!
 			 * so need to *=3D 2
@@ -2786,8 +2730,7 @@
 		if (dLeftCounter =3D=3D 1 && pDCB->SyncPeriod & WIDE_SYNC
 		    && pSRB->pcmd->request_bufflen % 2) {
 			dLeftCounter =3D 0;
-			printk(DC395X_NAME
-			       ": DOP0: Discard 1 byte. (%02x)\n",
+			dprintkl(KERN_INFO, "DOP0: Discard 1 byte. (%02x)\n",
 			       scsi_status);
 		}
 		/*
@@ -2808,8 +2751,8 @@
 			 * {
 			 *  TempDMAstatus =3D DC395x_read8(TRM_S1040_DMA_STATUS);
 			 * } while( !(TempDMAstatus & DMAXFERCOMP) && --ctr);
-			 * if (ctr < 6000000-1) printk (DC395X_NAME ": DMA should be comple=
te ... in DOP1\n");
-			 * if (!ctr) printk (KERN_ERR DC395X_NAME ": Deadlock in DataOutPha=
se0 !!\n");
+			 * if (ctr < 6000000-1) dprintkl(KERN_DEBUG, "DMA should be complet=
e ... in DOP1\n");
+			 * if (!ctr) dprintkl(KERN_ERR, "Deadlock in DataOutPhase0 !!\n");
 			 */
 			pSRB->SRBTotalXferLength =3D 0;
 		} else {	/* Update SG list         */
@@ -2829,9 +2772,8 @@
 			    || ((oldXferred & ~PAGE_MASK) =3D=3D
 				(PAGE_SIZE - diff))
 			    ) {
-				printk(DC395X_NAME
-				       ": Work around chip bug (%i)?\n",
-				       diff);
+				dprintkl(KERN_INFO,
+				       "Work around chip bug (%i)?\n", diff);
 				dLeftCounter =3D
 				    pSRB->SRBTotalXferLength - diff;
 				DC395x_update_SGlist(pSRB, dLeftCounter);
@@ -2844,16 +2786,16 @@
 	}
 #if 0
 	if (!(DC395x_read8(TRM_S1040_SCSI_FIFOCNT) & 0x40))
-		printk(DC395X_NAME
-		       ": DOP0(%li): %i bytes in SCSI FIFO! (Clear!)\n",
-		       pSRB->pcmd->pid,
-		       DC395x_read8(TRM_S1040_SCSI_FIFOCNT) & 0x1f);
+		dprintkl(KERN_DEBUG,
+			"DOP0(%li): %i bytes in SCSI FIFO! (Clear!)\n",
+			pSRB->pcmd->pid,
+			DC395x_read8(TRM_S1040_SCSI_FIFOCNT) & 0x1f);
 #endif
 	/*DC395x_clrfifo (pACB, "DOP0"); */
 	/*DC395x_write8 (TRM_S1040_DMA_CONTROL, CLRXFIFO | ABORTXFER); */
 #if 1
 	if ((*pscsi_status & PHASEMASK) !=3D PH_DATA_OUT) {
-		/*printk (DC395X_NAME ": Debug: Clean up after Data Out ...\n"); */
+		/*dprintkl(KERN_DEBUG, "Debug: Clean up after Data Out ...\n"); */
 		DC395x_cleanup_after_transfer(pACB, pSRB);
 	}
 #endif
@@ -2875,9 +2817,7 @@
 		     u16 * pscsi_status)
 {
=20
-#ifdef DC395x_DEBUG0
-	printk(KERN_INFO DC395X_NAME ": DC395x_DataOutPhase1.....\n");
-#endif
+	dprintkdbg(DBG_0, "DC395x_DataOutPhase1.....\n");
 	/*1.25 */
 	TRACEPRINTF("DOP1*");
 	DC395x_clrfifo(pACB, "DOP1");
@@ -2906,10 +2846,7 @@
 	/*struct DeviceCtlBlk*   pDCB =3D pSRB->pSRBDCB; */
 	/*u8 bval; */

-#ifdef DC395x_DEBUG0
-	printk(KERN_INFO DC395X_NAME
-	       ": DC395x_DataInPhase0..............\n ");
-#endif
+	dprintkdbg(DBG_0, "DC395x_DataInPhase0..............\n");
 	TRACEPRINTF("DIP0*");
 	scsi_status =3D *pscsi_status;

@@ -2928,8 +2865,8 @@
 	 */
 	if (!(pSRB->SRBState & SRB_XFERPAD)) {
 		if (scsi_status & PARITYERROR) {
-			printk(DC395X_NAME
-			       ": Parity Error (pid %li, target %02i-%i)\n",
+			dprintkl(KERN_INFO,
+			       "Parity Error (pid %li, target %02i-%i)\n",
 			       pSRB->pcmd->pid, pSRB->pcmd->device->id,
 			       pSRB->pcmd->device->lun);
 			pSRB->SRBStatus |=3D PARITY_ERROR;
@@ -2943,8 +2880,8 @@
 		if (!(DC395x_read8(TRM_S1040_DMA_FIFOSTAT) & 0x80)) {
 #if 0
 			int ctr =3D 6000000;
-			printk(DC395X_NAME
-			       ": DIP0: Wait for DMA FIFO to flush ...\n");
+			dprintkl(KERN_DEBUG,
+			       "DIP0: Wait for DMA FIFO to flush ...\n");
 			/*DC395x_write8  (TRM_S1040_DMA_CONTROL, STOPDMAXFER); */
 			/*DC395x_write32 (TRM_S1040_SCSI_COUNTER, 7); */
 			/*DC395x_write8  (TRM_S1040_SCSI_COMMAND, SCMD_DMA_IN); */
@@ -2952,18 +2889,16 @@
 			       (DC395x_read16(TRM_S1040_DMA_FIFOSTAT) &
 				0x80) && --ctr);
 			if (ctr < 6000000 - 1)
-				printk(DC395X_NAME
-				       ": Debug: DIP0: Had to wait for DMA ...\n");
+				dprintkl(KERN_DEBUG
+				       "DIP0: Had to wait for DMA ...\n");
 			if (!ctr)
-				printk(KERN_ERR DC395X_NAME
-				       ": Deadlock in DIP0 waiting for DMA FIFO empty!!\n");
+				dprintkl(KERN_ERR,
+				       "Deadlock in DIP0 waiting for DMA FIFO empty!!\n");
 			/*DC395x_write32 (TRM_S1040_SCSI_COUNTER, 0); */
 #endif
-#ifdef DC395x_DEBUG_KG
-			printk(DC395X_NAME ": DIP0: DMA_FIFO: %02x %02x\n",
+			dprintkdbg(DBG_KG, "DIP0: DMA_FIFO: %02x %02x\n",
 			       DC395x_read8(TRM_S1040_DMA_FIFOCNT),
 			       DC395x_read8(TRM_S1040_DMA_FIFOSTAT));
-#endif
 		}
 		/* Now: Check remainig data: The SCSI counters should tell us ... */
 		dLeftCounter =3D DC395x_read32(TRM_S1040_SCSI_COUNTER)
@@ -2971,42 +2906,34 @@
 		       << ((pSRB->pSRBDCB->SyncPeriod & WIDE_SYNC) ? 1 :
 			   0));
=20
-#ifdef DC395x_DEBUG_KG
-		printk(DC395X_NAME
-		       ": Debug: SCSI FIFO contains %i %s in DIP0\n",
-		       DC395x_read8(TRM_S1040_SCSI_FIFOCNT) & 0x1f,
-		       (pSRB->pSRBDCB->
-			SyncPeriod & WIDE_SYNC) ? "words" : "bytes");
-		printk(DC395X_NAME ": SCSI FIFOCNT %02x, SCSI CTR %08x\n",
-		       DC395x_read8(TRM_S1040_SCSI_FIFOCNT),
-		       DC395x_read32(TRM_S1040_SCSI_COUNTER));
-		printk(DC395X_NAME
-		       ": DMA FIFOCNT %02x,%02x DMA CTR %08x\n",
-		       DC395x_read8(TRM_S1040_DMA_FIFOCNT),
-		       DC395x_read8(TRM_S1040_DMA_FIFOSTAT),
-		       DC395x_read32(TRM_S1040_DMA_CXCNT));
-		printk(DC395X_NAME
-		       ": Remaining: TotXfer: %i, SCSI FIFO+Ctr: %i\n",
-		       pSRB->SRBTotalXferLength, dLeftCounter);
-#endif
+		dprintkdbg(DBG_KG, "SCSI FIFO contains %i %s in DIP0\n",
+			  DC395x_read8(TRM_S1040_SCSI_FIFOCNT) & 0x1f,
+			  (pSRB->pSRBDCB->
+			  SyncPeriod & WIDE_SYNC) ? "words" : "bytes");
+		dprintkdbg(DBG_KG, "SCSI FIFOCNT %02x, SCSI CTR %08x\n",
+			  DC395x_read8(TRM_S1040_SCSI_FIFOCNT),
+			  DC395x_read32(TRM_S1040_SCSI_COUNTER));
+		dprintkdbg(DBG_KG, "DMA FIFOCNT %02x,%02x DMA CTR %08x\n",
+			  DC395x_read8(TRM_S1040_DMA_FIFOCNT),
+			  DC395x_read8(TRM_S1040_DMA_FIFOSTAT),
+			  DC395x_read32(TRM_S1040_DMA_CXCNT));
+		dprintkdbg(DBG_KG, "Remaining: TotXfer: %i, SCSI FIFO+Ctr: %i\n",
+			  pSRB->SRBTotalXferLength, dLeftCounter);
 #if DC395x_LASTPIO
 		/* KG: Less than or equal to 4 bytes can not be transfered via DMA, =
it seems. */
 		if (dLeftCounter
 		    && pSRB->SRBTotalXferLength <=3D DC395x_LASTPIO) {
 			/*u32 addr =3D (pSRB->SegmentX[pSRB->SRBSGIndex].address); */
 			/*DC395x_update_SGlist (pSRB, dLeftCounter); */
-			DEBUGPIO(printk
-				 (DC395X_NAME
-				  ": DIP0: PIO (%i %s) to %p for remaining %i bytes:",
+			dprintkdbg(DBG_PIO, "DIP0: PIO (%i %s) to %p for remaining %i bytes=
:",
 				  DC395x_read8(TRM_S1040_SCSI_FIFOCNT) &
 				  0x1f,
 				  (pSRB->pSRBDCB->
 				   SyncPeriod & WIDE_SYNC) ? "words" :
 				  "bytes", pSRB->virt_addr,
 				  pSRB->SRBTotalXferLength);
-			    )

-			    if (pSRB->pSRBDCB->SyncPeriod & WIDE_SYNC)
+			if (pSRB->pSRBDCB->SyncPeriod & WIDE_SYNC)
 				DC395x_write8(TRM_S1040_SCSI_CONFIG2,
 					      CFG2_WIDEFIFO);

@@ -3015,17 +2942,17 @@
 				u8 byte =3D
 				    DC395x_read8(TRM_S1040_SCSI_FIFO);
 				*(pSRB->virt_addr)++ =3D byte;
-				DEBUGPIO(printk(" %02x", byte);
-				    )
-				    pSRB->SRBTotalXferLength--;
+				if (debug_enabled(DBG_PIO))
+					printk(" %02x", byte);
+				pSRB->SRBTotalXferLength--;
 				dLeftCounter--;
 				pSRB->SegmentX[pSRB->SRBSGIndex].length--;
 				if (pSRB->SRBTotalXferLength
 				    && !pSRB->SegmentX[pSRB->SRBSGIndex].
 				    length) {
-					DEBUGPIO(printk(" (next segment)");
-					    )
-					    pSRB->SRBSGIndex++;
+				    	if (debug_enabled(DBG_PIO))
+						printk(" (next segment)");
+					pSRB->SRBSGIndex++;
 					DC395x_update_SGlist(pSRB,
 							     dLeftCounter);
 				}
@@ -3038,16 +2965,16 @@
 					    (TRM_S1040_SCSI_FIFO);
 					*(pSRB->virt_addr)++ =3D byte;
 					pSRB->SRBTotalXferLength--;
-					DEBUGPIO(printk(" %02x", byte);
-					    )
+					if (debug_enabled(DBG_PIO))
+						printk(" %02x", byte);
 				}
 #endif
 				DC395x_write8(TRM_S1040_SCSI_CONFIG2, 0);
 			}
-			/*printk (" %08x", *(u32*)(bus_to_virt (addr))); */
+			/*printk(" %08x", *(u32*)(bus_to_virt (addr))); */
 			/*pSRB->SRBTotalXferLength =3D 0; */
-			DEBUGPIO(printk("\n");
-			    )
+			if (debug_enabled(DBG_PIO))
+				printk("\n");
 		}
 #endif				/* DC395x_LASTPIO */

@@ -3075,12 +3002,12 @@
 #endif
 		/*dLeftCounter +=3D DC395x_read32(TRM_S1040_SCSI_COUNTER); */
 #if 0
-		printk(DC395X_NAME
-		       ": DIP0: ctr=3D%08x, DMA_FIFO=3D%02x,%02x SCSI_FIFO=3D%02x\n"=
,
+		dprintkl(KERN_DEBUG,
+		       "DIP0: ctr=3D%08x, DMA_FIFO=3D%02x,%02x SCSI_FIFO=3D%02x\n",
 		       dLeftCounter, DC395x_read8(TRM_S1040_DMA_FIFOCNT),
 		       DC395x_read8(TRM_S1040_DMA_FIFOSTAT),
 		       DC395x_read8(TRM_S1040_SCSI_FIFOCNT));
-		printk(DC395X_NAME ": DIP0: DMAStat %02x\n",
+		dprintkl(KERN_DEBUG, "DIP0: DMAStat %02x\n",
 		       DC395x_read8(TRM_S1040_DMA_STATUS));
 #endif
=20
@@ -3095,13 +3022,13 @@
 				    DC395x_read8(TRM_S1040_DMA_STATUS);
 			} while (!(TempDMAstatus & DMAXFERCOMP) && --ctr);
 			if (!ctr)
-				printk(KERN_ERR DC395X_NAME
-				       ": Deadlock in DataInPhase0 waiting for DMA!!\n");
+				dprintkl(KERN_ERR,
+				       "Deadlock in DataInPhase0 waiting for DMA!!\n");
 			pSRB->SRBTotalXferLength =3D 0;
 #endif
-#if 0				/*def DC395x_DEBUG_KG             */
-			printk(DC395X_NAME
-			       ": DIP0: DMA not yet ready: %02x: %i -> %i bytes\n",
+#if 0				/*def DBG_KG             */
+			dprintkl(KERN_DEBUG,
+			       "DIP0: DMA not yet ready: %02x: %i -> %i bytes\n",
 			       DC395x_read8(TRM_S1040_DMA_STATUS),
 			       pSRB->SRBTotalXferLength, dLeftCounter);
 #endif
@@ -3120,7 +3047,7 @@
 	}
 	/* KG: The target may decide to disconnect: Empty FIFO before! */
 	if ((*pscsi_status & PHASEMASK) !=3D PH_DATA_IN) {
-		/*printk (DC395X_NAME ": Debug: Clean up after Data In  ...\n"); */
+		/*dprintkl(KERN_DEBUG, "Debug: Clean up after Data In  ...\n"); */
 		DC395x_cleanup_after_transfer(pACB, pSRB);
 	}
 #if 0

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
