From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 3/5] SCSI/initio minor cleanups
Date: Sun, 27 May 2007 10:57:06 -0400
Message-ID: <20070527145706.GC17085@havoc.gtf.org>
References: <20070527145200.GA17017@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:33566 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753750AbXE0O5I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 May 2007 10:57:08 -0400
Content-Disposition: inline
In-Reply-To: <20070527145200.GA17017@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>


Two minor cleanups:
* eliminate unused ADPT_Device struct member
* eliminate redundant return statements

Signed-off-by: Jeff Garzik <jeff@garzik.org>

8ce38698fb5c65128621823e34830ed6c738f3be
diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index d25a228..2bc2390 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -402,7 +402,6 @@ static void tul_se2_instr(WORD CurBase, UCHAR instr)
 	}
 	TUL_WR(CurBase + TUL_NVRAM, SE2CS);	/* -CLK */
 	tul_se2_wait();
-	return;
 }
 
 
@@ -415,7 +414,6 @@ void tul_se2_ew_en(WORD CurBase)
 	tul_se2_instr(CurBase, 0x30);	/* EWEN */
 	TUL_WR(CurBase + TUL_NVRAM, 0);		/* -CS  */
 	tul_se2_wait();
-	return;
 }
 
 
@@ -427,7 +425,6 @@ void tul_se2_ew_ds(WORD CurBase)
 	tul_se2_instr(CurBase, 0);	/* EWDS */
 	TUL_WR(CurBase + TUL_NVRAM, 0);		/* -CS  */
 	tul_se2_wait();
-	return;
 }
 
 
@@ -501,7 +498,6 @@ static void tul_se2_wr(WORD CurBase, UCHAR adr, USHORT writeWord)
 			break;	/* write complete */
 	}
 	TUL_WR(CurBase + TUL_NVRAM, 0);		/* -CS */
-	return;
 }
 
 
@@ -559,7 +555,6 @@ void tul_se2_update_all(WORD CurBase)
 	}
 
 	tul_se2_ew_ds(CurBase);	/* Disable write   */
-	return;
 }
 
 /*************************************************************************
@@ -601,12 +596,10 @@ static int Addi91u_into_Adapter_table(WORD wBIOS, struct pci_dev *pci_dev)
 			i91u_adpt[j].ADPT_BASE = i91u_adpt[j - 1].ADPT_BASE;
 			i91u_adpt[j].ADPT_BIOS = i91u_adpt[j - 1].ADPT_BIOS;
 			i91u_adpt[j].ADPT_Bus = i91u_adpt[j - 1].ADPT_Bus;
-			i91u_adpt[j].ADPT_Device = i91u_adpt[j - 1].ADPT_Device;
 		}
 		i91u_adpt[i].ADPT_BASE = wBASE;
 		i91u_adpt[i].ADPT_BIOS = wBIOS;
 		i91u_adpt[i].ADPT_Bus = pci_dev->bus->number;
-		i91u_adpt[i].ADPT_Device = pci_dev->devfn >> 3;
 		i91u_adpt[i].pci_dev = pci_dev;
 		return 0;
 	}
@@ -617,13 +610,12 @@ static void init_i91uAdapter_table(void)
 {
 	int i;
 
-	for (i = 0; i < MAX_SUPPORTED_ADAPTERS; i++) {	/* Initialize adapter structure */
+	/* Initialize adapter structure */
+	for (i = 0; i < MAX_SUPPORTED_ADAPTERS; i++) {
 		i91u_adpt[i].ADPT_BIOS = 0xffff;
 		i91u_adpt[i].ADPT_BASE = 0xffff;
 		i91u_adpt[i].ADPT_Bus = 0xff;
-		i91u_adpt[i].ADPT_Device = 0xff;
 	}
-	return;
 }
 
 static void tul_stop_bm(HCS * pCurHcb)
@@ -915,8 +907,8 @@ static void tul_unlink_pend_scb(HCS * pCurHcb, SCB * pCurScb)
 		pPrevScb = pTmpScb;
 		pTmpScb = pTmpScb->SCB_NxtScb;
 	}
-	return;
 }
+
 /***************************************************************************/
 static void tul_append_busy_scb(HCS * pCurHcb, SCB * scbp)
 {
@@ -990,7 +982,6 @@ static void tul_unlink_busy_scb(HCS * pCurHcb, SCB * pCurScb)
 		pPrevScb = pTmpScb;
 		pTmpScb = pTmpScb->SCB_NxtScb;
 	}
-	return;
 }
 
 /***************************************************************************/
@@ -1297,7 +1288,6 @@ static void tul_exec_scb(HCS * pCurHcb, SCB * pCurScb)
 		TUL_WR(pCurHcb->HCS_Base + TUL_Mask, 0x0F);
 	}
 	spin_unlock_irqrestore(&(pCurHcb->HCS_SemaphLock), flags);
-	return;
 }
 
 /***************************************************************************/
@@ -1507,7 +1497,6 @@ void tulip_scsi(HCS * pCurHcb)
 		pCurScb->SCB_HaStat = 0x16;	/* bad command */
 		tul_append_done_scb(pCurHcb, pCurScb);
 	}
-	return;
 }
 
 
@@ -2548,7 +2537,6 @@ void tul_select_atn_stop(HCS * pCurHcb, SCB * pCurScb)
 	pCurHcb->HCS_ActScb = pCurScb;
 	pCurHcb->HCS_ActTcs = &pCurHcb->HCS_Tcs[pCurScb->SCB_Target];
 	TUL_WR(pCurHcb->HCS_Base + TUL_SCmd, TSC_SELATNSTOP);
-	return;
 }
 
 
@@ -2566,7 +2554,6 @@ void tul_select_atn(HCS * pCurHcb, SCB * pCurScb)
 	pCurHcb->HCS_ActTcs = &pCurHcb->HCS_Tcs[pCurScb->SCB_Target];
 	pCurHcb->HCS_ActScb = pCurScb;
 	TUL_WR(pCurHcb->HCS_Base + TUL_SCmd, TSC_SEL_ATN);
-	return;
 }
 
 /***************************************************************************/
@@ -2585,7 +2572,6 @@ void tul_select_atn3(HCS * pCurHcb, SCB * pCurScb)
 	pCurHcb->HCS_ActTcs = &pCurHcb->HCS_Tcs[pCurScb->SCB_Target];
 	pCurHcb->HCS_ActScb = pCurScb;
 	TUL_WR(pCurHcb->HCS_Base + TUL_SCmd, TSC_SEL_ATN3);
-	return;
 }
 
 /***************************************************************************/
diff --git a/drivers/scsi/initio.h b/drivers/scsi/initio.h
index 817b696..8186d14 100644
--- a/drivers/scsi/initio.h
+++ b/drivers/scsi/initio.h
@@ -527,7 +527,6 @@ typedef struct I91u_Adpt_Struc {
 	UWORD ADPT_BIOS;	/* 0 */
 	UWORD ADPT_BASE;	/* 1 */
 	UBYTE ADPT_Bus;		/* 2 */
-	UBYTE ADPT_Device;	/* 3 */
 	struct pci_dev *pci_dev;
 } INI_ADPT_STRUCT;
 
