From: Peter Hagervall <hager@cs.umu.se>
Subject: [PATCH] initio.c Make needlessly global functions static
Date: Tue, 20 Dec 2005 18:24:38 +0100
Message-ID: <20051220172438.GA24916@peppar.cs.umu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.umu.se ([130.239.40.25]:22956 "EHLO mail.cs.umu.se")
	by vger.kernel.org with ESMTP id S1750706AbVLTRYn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Dec 2005 12:24:43 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

Make 40+ global functions static.

Signed-off-by: Peter Hagervall <hager@cs.umu.se>

---

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index ea6f3c0..a9cfc6f 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -315,7 +315,7 @@ static void tul_do_pause(unsigned amount
 /*******************************************************************
 	Use memeory refresh time        ~ 15us * 2
 ********************************************************************/
-void tul_se2_wait(void)
+static void tul_se2_wait(void)
 {
 #if 1
 	udelay(30);
@@ -411,7 +411,7 @@ static void tul_se2_instr(WORD CurBase, 
  Function name  : tul_se2_ew_en
  Description    : Enable erase/write state of serial EEPROM
 ******************************************************************/
-void tul_se2_ew_en(WORD CurBase)
+static void tul_se2_ew_en(WORD CurBase)
 {
 	tul_se2_instr(CurBase, 0x30);	/* EWEN */
 	TUL_WR(CurBase + TUL_NVRAM, 0);		/* -CS  */
@@ -423,7 +423,7 @@ void tul_se2_ew_en(WORD CurBase)
 /************************************************************************
  Disable erase/write state of serial EEPROM
 *************************************************************************/
-void tul_se2_ew_ds(WORD CurBase)
+static void tul_se2_ew_ds(WORD CurBase)
 {
 	tul_se2_instr(CurBase, 0);	/* EWDS */
 	TUL_WR(CurBase + TUL_NVRAM, 0);		/* -CS  */
@@ -509,7 +509,7 @@ static void tul_se2_wr(WORD CurBase, UCH
 /***********************************************************************
  Read SCSI H/A configuration parameters from serial EEPROM
 ************************************************************************/
-int tul_se2_rd_all(WORD CurBase)
+static int tul_se2_rd_all(WORD CurBase)
 {
 	int i;
 	ULONG chksum = 0;
@@ -537,7 +537,7 @@ int tul_se2_rd_all(WORD CurBase)
 /***********************************************************************
  Update SCSI H/A configuration parameters from serial EEPROM
 ************************************************************************/
-void tul_se2_update_all(WORD CurBase)
+static void tul_se2_update_all(WORD CurBase)
 {				/* setup default pattern */
 	int i;
 	ULONG chksum = 0;
@@ -566,7 +566,7 @@ void tul_se2_update_all(WORD CurBase)
 /*************************************************************************
  Function name  : read_eeprom
 **************************************************************************/
-void tul_read_eeprom(WORD CurBase)
+static void tul_read_eeprom(WORD CurBase)
 {
 	UCHAR gctrl;
 
@@ -998,7 +998,7 @@ static void tul_unlink_busy_scb(HCS * pC
 }
 
 /***************************************************************************/
-SCB *tul_find_busy_scb(HCS * pCurHcb, WORD tarlun)
+static SCB *tul_find_busy_scb(HCS * pCurHcb, WORD tarlun)
 {
 	SCB *pTmpScb, *pPrevScb;
 	WORD scbp_tarlun;
@@ -1039,7 +1039,7 @@ static void tul_append_done_scb(HCS * pC
 }
 
 /***************************************************************************/
-SCB *tul_find_done_scb(HCS * pCurHcb)
+static SCB *tul_find_done_scb(HCS * pCurHcb)
 {
 	SCB *pTmpScb;
 
@@ -1326,7 +1326,7 @@ static int tul_isr(HCS * pCurHcb)
 }
 
 /***************************************************************************/
-int tulip_main(HCS * pCurHcb)
+static int tulip_main(HCS * pCurHcb)
 {
 	SCB *pCurScb;
 
@@ -1412,7 +1412,7 @@ int tulip_main(HCS * pCurHcb)
 /***************************************************************************/
 
 /***************************************************************************/
-void tulip_scsi(HCS * pCurHcb)
+static void tulip_scsi(HCS * pCurHcb)
 {
 	SCB *pCurScb;
 	TCS *pCurTcb;
@@ -1516,7 +1516,7 @@ void tulip_scsi(HCS * pCurHcb)
 
 
 /***************************************************************************/
-int tul_next_state(HCS * pCurHcb)
+static int tul_next_state(HCS * pCurHcb)
 {
 	int next;
 
@@ -1557,7 +1557,7 @@ int tul_next_state(HCS * pCurHcb)
 
 /***************************************************************************/
 /* sTate after selection with attention & stop */
-int tul_state_1(HCS * pCurHcb)
+static int tul_state_1(HCS * pCurHcb)
 {
 	SCB *pCurScb = pCurHcb->HCS_ActScb;
 	TCS *pCurTcb = pCurHcb->HCS_ActTcs;
@@ -1611,7 +1611,7 @@ int tul_state_1(HCS * pCurHcb)
 /***************************************************************************/
 /* state after selection with attention */
 /* state after selection with attention3 */
-int tul_state_2(HCS * pCurHcb)
+static int tul_state_2(HCS * pCurHcb)
 {
 	SCB *pCurScb = pCurHcb->HCS_ActScb;
 	TCS *pCurTcb = pCurHcb->HCS_ActTcs;
@@ -1634,7 +1634,7 @@ int tul_state_2(HCS * pCurHcb)
 
 /***************************************************************************/
 /* state before CDB xfer is done */
-int tul_state_3(HCS * pCurHcb)
+static int tul_state_3(HCS * pCurHcb)
 {
 	SCB *pCurScb = pCurHcb->HCS_ActScb;
 	TCS *pCurTcb = pCurHcb->HCS_ActTcs;
@@ -1700,7 +1700,7 @@ int tul_state_3(HCS * pCurHcb)
 
 
 /***************************************************************************/
-int tul_state_4(HCS * pCurHcb)
+static int tul_state_4(HCS * pCurHcb)
 {
 	SCB *pCurScb = pCurHcb->HCS_ActScb;
 
@@ -1760,7 +1760,7 @@ int tul_state_4(HCS * pCurHcb)
 
 /***************************************************************************/
 /* state after dma xfer done or phase change before xfer done */
-int tul_state_5(HCS * pCurHcb)
+static int tul_state_5(HCS * pCurHcb)
 {
 	SCB *pCurScb = pCurHcb->HCS_ActScb;
 	long cnt, xcnt;		/* cannot use unsigned !! code: if (xcnt < 0) */
@@ -1846,7 +1846,7 @@ int tul_state_5(HCS * pCurHcb)
 
 /***************************************************************************/
 /* state after Data phase */
-int tul_state_6(HCS * pCurHcb)
+static int tul_state_6(HCS * pCurHcb)
 {
 	SCB *pCurScb = pCurHcb->HCS_ActScb;
 
@@ -1886,7 +1886,7 @@ int tul_state_6(HCS * pCurHcb)
 }
 
 /***************************************************************************/
-int tul_state_7(HCS * pCurHcb)
+static int tul_state_7(HCS * pCurHcb)
 {
 	int cnt, i;
 
@@ -1909,7 +1909,7 @@ int tul_state_7(HCS * pCurHcb)
 }
 
 /***************************************************************************/
-int tul_xfer_data_in(HCS * pCurHcb)
+static int tul_xfer_data_in(HCS * pCurHcb)
 {
 	SCB *pCurScb = pCurHcb->HCS_ActScb;
 
@@ -1935,7 +1935,7 @@ int tul_xfer_data_in(HCS * pCurHcb)
 
 
 /***************************************************************************/
-int tul_xfer_data_out(HCS * pCurHcb)
+static int tul_xfer_data_out(HCS * pCurHcb)
 {
 	SCB *pCurScb = pCurHcb->HCS_ActScb;
 
@@ -1961,7 +1961,7 @@ int tul_xfer_data_out(HCS * pCurHcb)
 
 
 /***************************************************************************/
-int tul_xpad_in(HCS * pCurHcb)
+static int tul_xpad_in(HCS * pCurHcb)
 {
 	SCB *pCurScb = pCurHcb->HCS_ActScb;
 	TCS *pCurTcb = pCurHcb->HCS_ActTcs;
@@ -1987,7 +1987,7 @@ int tul_xpad_in(HCS * pCurHcb)
 	}
 }
 
-int tul_xpad_out(HCS * pCurHcb)
+static int tul_xpad_out(HCS * pCurHcb)
 {
 	SCB *pCurScb = pCurHcb->HCS_ActScb;
 	TCS *pCurTcb = pCurHcb->HCS_ActTcs;
@@ -2016,7 +2016,7 @@ int tul_xpad_out(HCS * pCurHcb)
 
 
 /***************************************************************************/
-int tul_status_msg(HCS * pCurHcb)
+static int tul_status_msg(HCS * pCurHcb)
 {				/* status & MSG_IN */
 	SCB *pCurScb = pCurHcb->HCS_ActScb;
 	BYTE msg;
@@ -2069,7 +2069,7 @@ int tul_status_msg(HCS * pCurHcb)
 
 /***************************************************************************/
 /* scsi bus free */
-int int_tul_busfree(HCS * pCurHcb)
+static int int_tul_busfree(HCS * pCurHcb)
 {
 	SCB *pCurScb = pCurHcb->HCS_ActScb;
 
@@ -2125,7 +2125,7 @@ static int int_tul_scsi_rst(HCS * pCurHc
 
 /***************************************************************************/
 /* scsi reselection */
-int int_tul_resel(HCS * pCurHcb)
+static int int_tul_resel(HCS * pCurHcb)
 {
 	SCB *pCurScb;
 	TCS *pCurTcb;
@@ -2220,7 +2220,7 @@ static int int_tul_bad_seq(HCS * pCurHcb
 
 
 /***************************************************************************/
-int tul_msgout_abort_targ(HCS * pCurHcb)
+static int tul_msgout_abort_targ(HCS * pCurHcb)
 {
 
 	TUL_WR(pCurHcb->HCS_Base + TUL_SSignal, ((TUL_RD(pCurHcb->HCS_Base, TUL_SSignal) & (TSC_SET_ACK | 7)) | TSC_SET_ATN));
@@ -2236,7 +2236,7 @@ int tul_msgout_abort_targ(HCS * pCurHcb)
 }
 
 /***************************************************************************/
-int tul_msgout_abort_tag(HCS * pCurHcb)
+static int tul_msgout_abort_tag(HCS * pCurHcb)
 {
 
 	TUL_WR(pCurHcb->HCS_Base + TUL_SSignal, ((TUL_RD(pCurHcb->HCS_Base, TUL_SSignal) & (TSC_SET_ACK | 7)) | TSC_SET_ATN));
@@ -2253,7 +2253,7 @@ int tul_msgout_abort_tag(HCS * pCurHcb)
 }
 
 /***************************************************************************/
-int tul_msgin(HCS * pCurHcb)
+static int tul_msgin(HCS * pCurHcb)
 {
 	TCS *pCurTcb;
 
@@ -2328,7 +2328,7 @@ int tul_msgin(HCS * pCurHcb)
 
 
 /***************************************************************************/
-int tul_msgout_reject(HCS * pCurHcb)
+static int tul_msgout_reject(HCS * pCurHcb)
 {
 
 	TUL_WR(pCurHcb->HCS_Base + TUL_SSignal, ((TUL_RD(pCurHcb->HCS_Base, TUL_SSignal) & (TSC_SET_ACK | 7)) | TSC_SET_ATN));
@@ -2347,7 +2347,7 @@ int tul_msgout_reject(HCS * pCurHcb)
 
 
 /***************************************************************************/
-int tul_msgout_ide(HCS * pCurHcb)
+static int tul_msgout_ide(HCS * pCurHcb)
 {
 	TUL_WR(pCurHcb->HCS_Base + TUL_SFifo, MSG_IDE);		/* Initiator Detected Error */
 	TUL_WR(pCurHcb->HCS_Base + TUL_SCmd, TSC_XF_FIFO_OUT);
@@ -2356,7 +2356,7 @@ int tul_msgout_ide(HCS * pCurHcb)
 
 
 /***************************************************************************/
-int tul_msgin_extend(HCS * pCurHcb)
+static int tul_msgin_extend(HCS * pCurHcb)
 {
 	BYTE len, idx;
 
@@ -2444,7 +2444,7 @@ int tul_msgin_extend(HCS * pCurHcb)
 }
 
 /***************************************************************************/
-int tul_msgin_sync(HCS * pCurHcb)
+static int tul_msgin_sync(HCS * pCurHcb)
 {
 	char default_period;
 
@@ -2477,7 +2477,7 @@ int tul_msgin_sync(HCS * pCurHcb)
 
 
 /***************************************************************************/
-int wdtr_done(HCS * pCurHcb)
+static int wdtr_done(HCS * pCurHcb)
 {
 	pCurHcb->HCS_ActTcs->TCS_Flags &= ~TCF_SYNC_DONE;
 	pCurHcb->HCS_ActTcs->TCS_Flags |= TCF_WDTR_DONE;
@@ -2494,7 +2494,7 @@ int wdtr_done(HCS * pCurHcb)
 }
 
 /***************************************************************************/
-int tul_sync_done(HCS * pCurHcb)
+static int tul_sync_done(HCS * pCurHcb)
 {
 	int i;
 
@@ -2516,7 +2516,7 @@ int tul_sync_done(HCS * pCurHcb)
 }
 
 
-int tul_post_scsi_rst(HCS * pCurHcb)
+static int tul_post_scsi_rst(HCS * pCurHcb)
 {
 	SCB *pCurScb;
 	TCS *pCurTcb;
@@ -2545,7 +2545,7 @@ int tul_post_scsi_rst(HCS * pCurHcb)
 }
 
 /***************************************************************************/
-void tul_select_atn_stop(HCS * pCurHcb, SCB * pCurScb)
+static void tul_select_atn_stop(HCS * pCurHcb, SCB * pCurScb)
 {
 	pCurScb->SCB_Status |= SCB_SELECT;
 	pCurScb->SCB_NxtStat = 0x1;
@@ -2557,7 +2557,7 @@ void tul_select_atn_stop(HCS * pCurHcb, 
 
 
 /***************************************************************************/
-void tul_select_atn(HCS * pCurHcb, SCB * pCurScb)
+static void tul_select_atn(HCS * pCurHcb, SCB * pCurScb)
 {
 	int i;
 
@@ -2574,7 +2574,7 @@ void tul_select_atn(HCS * pCurHcb, SCB *
 }
 
 /***************************************************************************/
-void tul_select_atn3(HCS * pCurHcb, SCB * pCurScb)
+static void tul_select_atn3(HCS * pCurHcb, SCB * pCurScb)
 {
 	int i;
 
@@ -2594,7 +2594,7 @@ void tul_select_atn3(HCS * pCurHcb, SCB 
 
 /***************************************************************************/
 /* SCSI Bus Device Reset */
-int tul_bus_device_reset(HCS * pCurHcb)
+static int tul_bus_device_reset(HCS * pCurHcb)
 {
 	SCB *pCurScb = pCurHcb->HCS_ActScb;
 	TCS *pCurTcb = pCurHcb->HCS_ActTcs;
@@ -2644,14 +2644,14 @@ int tul_bus_device_reset(HCS * pCurHcb)
 }
 
 /***************************************************************************/
-int tul_msgin_accept(HCS * pCurHcb)
+static int tul_msgin_accept(HCS * pCurHcb)
 {
 	TUL_WR(pCurHcb->HCS_Base + TUL_SCmd, TSC_MSG_ACCEPT);
 	return (wait_tulip(pCurHcb));
 }
 
 /***************************************************************************/
-int wait_tulip(HCS * pCurHcb)
+static int wait_tulip(HCS * pCurHcb)
 {
 
 	while (!((pCurHcb->HCS_JSStatus0 = TUL_RD(pCurHcb->HCS_Base, TUL_SStatus0))
@@ -2700,7 +2700,7 @@ int wait_tulip(HCS * pCurHcb)
 	return (pCurHcb->HCS_Phase);
 }
 /***************************************************************************/
-int tul_wait_disc(HCS * pCurHcb)
+static int tul_wait_disc(HCS * pCurHcb)
 {
 
 	while (!((pCurHcb->HCS_JSStatus0 = TUL_RD(pCurHcb->HCS_Base, TUL_SStatus0))
@@ -2723,7 +2723,7 @@ int tul_wait_disc(HCS * pCurHcb)
 }
 
 /***************************************************************************/
-int tul_wait_done_disc(HCS * pCurHcb)
+static int tul_wait_done_disc(HCS * pCurHcb)
 {
 
 
