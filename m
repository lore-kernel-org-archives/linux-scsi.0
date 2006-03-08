From: akpm@osdl.org
Subject: [patch 16/28] drivers/scsi/FlashPoint.c: untypedef struct SCCBMgr_tar_info
Date: Wed, 08 Mar 2006 00:14:31 -0800
Message-ID: <200603080816.k288GLYZ002200@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:32684 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932493AbWCHIQZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2006 03:16:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, adobriyan@gmail.com


From: Alexey Dobriyan <adobriyan@gmail.com>

* struct SCCBMgr_tar_info => struct sccb_mgr_tar_info
* PSCCBMgr_tar_info => struct sccb_mgr_tar_info *
* SCCBMGR_TAR_INFO => struct sccb_mgr_tar_info

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/FlashPoint.c |   53 +++++++++++++++++-------------------
 1 files changed, 26 insertions(+), 27 deletions(-)

diff -puN drivers/scsi/FlashPoint.c~drivers-scsi-flashpointc-untypedef-struct-sccbmgr_tar_info drivers/scsi/FlashPoint.c
--- 25/drivers/scsi/FlashPoint.c~drivers-scsi-flashpointc-untypedef-struct-sccbmgr_tar_info	Mon Feb  6 14:50:15 2006
+++ 25-akpm/drivers/scsi/FlashPoint.c	Mon Feb  6 14:50:15 2006
@@ -268,10 +268,9 @@ struct sccb {
 #define  EE_WIDE_SCSI      BIT(7)
 
 
-typedef struct SCCBMgr_tar_info *PSCCBMgr_tar_info;
 
 
-typedef struct SCCBMgr_tar_info {
+struct sccb_mgr_tar_info {
 
    struct sccb *    TarSelQ_Head;
    struct sccb *    TarSelQ_Tail;
@@ -284,7 +283,7 @@ typedef struct SCCBMgr_tar_info {
    unsigned char 	TarReserved[2];			/* for alignment */
    unsigned char 	LunDiscQ_Idx[MAX_LUN];
    unsigned char    TarLUNBusy[MAX_LUN];
-} SCCBMGR_TAR_INFO;
+};
 
 typedef struct NVRAMInfo {
 	unsigned char		niModel;								/* Model No. of card */
@@ -975,7 +974,7 @@ static void  FPT_shandem(unsigned long p
 static void  FPT_stsyncn(unsigned long port, unsigned char p_card);
 static void  FPT_sisyncr(unsigned long port,unsigned char sync_pulse, unsigned char offset);
 static void  FPT_sssyncv(unsigned long p_port, unsigned char p_id, unsigned char p_sync_value,
-			 PSCCBMgr_tar_info currTar_Info);
+			 struct sccb_mgr_tar_info * currTar_Info);
 static void  FPT_sresb(unsigned long port, unsigned char p_card);
 static void  FPT_sxfrp(unsigned long p_port, unsigned char p_card);
 static void  FPT_schkdd(unsigned long port, unsigned char p_card);
@@ -1081,7 +1080,7 @@ static void  FPT_autoLoadDefaultMap(unsi
 
 
 
-static SCCBMGR_TAR_INFO FPT_sccbMgrTbl[MAX_CARDS][MAX_SCSI_TAR] = { { { 0 } } };
+static struct sccb_mgr_tar_info FPT_sccbMgrTbl[MAX_CARDS][MAX_SCSI_TAR] = { { { 0 } } };
 static SCCBCARD FPT_BL_Card[MAX_CARDS] = { { 0 } };
 static SCCBSCAM_INFO FPT_scamInfo[MAX_SCSI_TAR] = { { { 0 } } };
 static NVRAMINFO FPT_nvRamInfo[MAX_MB_CARDS] = { { 0 } };
@@ -1793,7 +1792,7 @@ static int FlashPoint_AbortCCB(unsigned 
 	CALL_BK_FN callback;
 	unsigned char TID;
 	struct sccb * pSaveSCCB;
-	PSCCBMgr_tar_info currTar_Info;
+	struct sccb_mgr_tar_info * currTar_Info;
 
 
 	ioport = ((PSCCBcard) pCurrCard)->ioPort;
@@ -2161,7 +2160,7 @@ static unsigned char FPT_SccbMgr_bad_isr
 				 PSCCBcard pCurrCard, unsigned short p_int)
 {
    unsigned char temp, ScamFlg;
-   PSCCBMgr_tar_info currTar_Info;
+   struct sccb_mgr_tar_info * currTar_Info;
    PNVRamInfo pCurrNvRam;
 
 
@@ -2373,7 +2372,7 @@ static void FPT_SccbMgrTableInitTarget(u
 {
 
 	unsigned char lun, qtag;
-	PSCCBMgr_tar_info currTar_Info;
+	struct sccb_mgr_tar_info * currTar_Info;
 
 	currTar_Info = &FPT_sccbMgrTbl[p_card][target];
 
@@ -2496,7 +2495,7 @@ static void FPT_ssel(unsigned long port,
    unsigned long cdb_reg;
    PSCCBcard CurrCard;
    struct sccb * currSCCB;
-   PSCCBMgr_tar_info currTar_Info;
+   struct sccb_mgr_tar_info * currTar_Info;
    unsigned char lastTag, lun;
 
    CurrCard = &FPT_BL_Card[p_card];
@@ -2805,7 +2804,7 @@ static void FPT_sres(unsigned long port,
    unsigned char our_target, message, lun = 0, tag, msgRetryCount;
 
 
-   PSCCBMgr_tar_info currTar_Info;
+   struct sccb_mgr_tar_info * currTar_Info;
 	struct sccb * currSCCB;
 
 
@@ -3113,7 +3112,7 @@ static void FPT_sdecm(unsigned char mess
 {
 	struct sccb * currSCCB;
 	PSCCBcard CurrCard;
-	PSCCBMgr_tar_info currTar_Info;
+	struct sccb_mgr_tar_info * currTar_Info;
 
 	CurrCard = &FPT_BL_Card[p_card];
 	currSCCB = CurrCard->currentSCCB;
@@ -3370,7 +3369,7 @@ static void FPT_shandem(unsigned long po
 static unsigned char FPT_sisyncn(unsigned long port, unsigned char p_card, unsigned char syncFlag)
 {
    struct sccb * currSCCB;
-   PSCCBMgr_tar_info currTar_Info;
+   struct sccb_mgr_tar_info * currTar_Info;
 
    currSCCB = FPT_BL_Card[p_card].currentSCCB;
    currTar_Info = &FPT_sccbMgrTbl[p_card][currSCCB->TargID];
@@ -3446,7 +3445,7 @@ static void FPT_stsyncn(unsigned long po
 {
    unsigned char sync_msg,offset,sync_reg,our_sync_msg;
    struct sccb * currSCCB;
-   PSCCBMgr_tar_info currTar_Info;
+   struct sccb_mgr_tar_info * currTar_Info;
 
    currSCCB = FPT_BL_Card[p_card].currentSCCB;
    currTar_Info = &FPT_sccbMgrTbl[p_card][currSCCB->TargID];
@@ -3608,7 +3607,7 @@ static void FPT_sisyncr(unsigned long po
 static unsigned char FPT_siwidn(unsigned long port, unsigned char p_card)
 {
    struct sccb * currSCCB;
-   PSCCBMgr_tar_info currTar_Info;
+   struct sccb_mgr_tar_info * currTar_Info;
 
    currSCCB = FPT_BL_Card[p_card].currentSCCB;
    currTar_Info = &FPT_sccbMgrTbl[p_card][currSCCB->TargID];
@@ -3661,7 +3660,7 @@ static void FPT_stwidn(unsigned long por
 {
    unsigned char width;
    struct sccb * currSCCB;
-   PSCCBMgr_tar_info currTar_Info;
+   struct sccb_mgr_tar_info * currTar_Info;
 
    currSCCB = FPT_BL_Card[p_card].currentSCCB;
    currTar_Info = &FPT_sccbMgrTbl[p_card][currSCCB->TargID];
@@ -3767,7 +3766,7 @@ static void FPT_siwidr(unsigned long por
  *
  *---------------------------------------------------------------------*/
 static void FPT_sssyncv(unsigned long p_port, unsigned char p_id, unsigned char p_sync_value,
-			PSCCBMgr_tar_info currTar_Info)
+			struct sccb_mgr_tar_info * currTar_Info)
 {
    unsigned char index;
 
@@ -3842,7 +3841,7 @@ static void FPT_sresb(unsigned long port
 {
    unsigned char scsiID, i;
 
-   PSCCBMgr_tar_info currTar_Info;
+   struct sccb_mgr_tar_info * currTar_Info;
 
    WR_HARPOON(port+hp_page_ctrl,
       (RD_HARPOON(port+hp_page_ctrl) | G_INT_DISABLE));
@@ -4157,7 +4156,7 @@ static void FPT_schkdd(unsigned long por
 
 static void FPT_sinits(struct sccb * p_sccb, unsigned char p_card)
 {
-   PSCCBMgr_tar_info currTar_Info;
+   struct sccb_mgr_tar_info * currTar_Info;
 
 	if((p_sccb->TargID > MAX_SCSI_TAR) || (p_sccb->Lun > MAX_LUN))
 	{
@@ -4429,7 +4428,7 @@ static void FPT_phaseMsgOut(unsigned lon
 {
 	unsigned char message,scsiID;
 	struct sccb * currSCCB;
-	PSCCBMgr_tar_info currTar_Info;
+	struct sccb_mgr_tar_info * currTar_Info;
 
 	currSCCB = FPT_BL_Card[p_card].currentSCCB;
 
@@ -6936,7 +6935,7 @@ static void FPT_DiagEEPROM(unsigned long
 static void FPT_queueSearchSelect(PSCCBcard pCurrCard, unsigned char p_card)
 {
    unsigned char scan_ptr, lun;
-   PSCCBMgr_tar_info currTar_Info;
+   struct sccb_mgr_tar_info * currTar_Info;
 	struct sccb * pOldSccb;
 
    scan_ptr = pCurrCard->scanIndex;
@@ -7067,7 +7066,7 @@ static void FPT_queueSearchSelect(PSCCBc
 static void FPT_queueSelectFail(PSCCBcard pCurrCard, unsigned char p_card)
 {
    unsigned char thisTarg;
-   PSCCBMgr_tar_info currTar_Info;
+   struct sccb_mgr_tar_info * currTar_Info;
 
    if (pCurrCard->currentSCCB != NULL)
 	  {
@@ -7109,7 +7108,7 @@ static void FPT_queueCmdComplete(PSCCBca
 
    unsigned char i, SCSIcmd;
    CALL_BK_FN callback;
-   PSCCBMgr_tar_info currTar_Info;
+   struct sccb_mgr_tar_info * currTar_Info;
 
    SCSIcmd = p_sccb->Cdb[0];
 
@@ -7207,7 +7206,7 @@ static void FPT_queueCmdComplete(PSCCBca
  *---------------------------------------------------------------------*/
 static void FPT_queueDisconnect(struct sccb * p_sccb, unsigned char p_card)
 {
-   PSCCBMgr_tar_info currTar_Info;
+   struct sccb_mgr_tar_info * currTar_Info;
 
 	currTar_Info = &FPT_sccbMgrTbl[p_card][p_sccb->TargID];
 
@@ -7244,7 +7243,7 @@ static void  FPT_queueFlushSccb(unsigned
 {
    unsigned char qtag,thisTarg;
    struct sccb * currSCCB;
-   PSCCBMgr_tar_info currTar_Info;
+   struct sccb_mgr_tar_info * currTar_Info;
 
    currSCCB = FPT_BL_Card[p_card].currentSCCB;
 	if(currSCCB != NULL)
@@ -7283,7 +7282,7 @@ static void  FPT_queueFlushTargSccb(unsi
 				    unsigned char error_code)
 {
    unsigned char qtag;
-   PSCCBMgr_tar_info currTar_Info;
+   struct sccb_mgr_tar_info * currTar_Info;
 
    currTar_Info = &FPT_sccbMgrTbl[p_card][thisTarg];
 
@@ -7311,7 +7310,7 @@ static void  FPT_queueFlushTargSccb(unsi
 
 static void FPT_queueAddSccb(struct sccb * p_SCCB, unsigned char p_card)
 {
-   PSCCBMgr_tar_info currTar_Info;
+   struct sccb_mgr_tar_info * currTar_Info;
    currTar_Info = &FPT_sccbMgrTbl[p_card][p_SCCB->TargID];
 
    p_SCCB->Sccb_forwardlink = NULL;
@@ -7346,7 +7345,7 @@ static void FPT_queueAddSccb(struct sccb
 static unsigned char FPT_queueFindSccb(struct sccb * p_SCCB, unsigned char p_card)
 {
    struct sccb * q_ptr;
-   PSCCBMgr_tar_info currTar_Info;
+   struct sccb_mgr_tar_info * currTar_Info;
 
    currTar_Info = &FPT_sccbMgrTbl[p_card][p_SCCB->TargID];
 
_
