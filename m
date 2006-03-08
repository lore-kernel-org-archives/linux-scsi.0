From: akpm@osdl.org
Subject: [patch 14/28] drivers/scsi/FlashPoint.c: untypedef struct _SCCB
Date: Wed, 08 Mar 2006 00:14:29 -0800
Message-ID: <200603080816.k288GIZm002194@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:32428 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932492AbWCHIQZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2006 03:16:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, adobriyan@gmail.com


From: Alexey Dobriyan <adobriyan@gmail.com>

* struct _SCCB => struct sccb
* PSCCB => struct sccb *
* SCCB => struct sccb

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/FlashPoint.c |  143 +++++++++++++++++-------------------
 1 files changed, 71 insertions(+), 72 deletions(-)

diff -puN drivers/scsi/FlashPoint.c~drivers-scsi-flashpointc-untypedef-struct-_sccb drivers/scsi/FlashPoint.c
--- 25/drivers/scsi/FlashPoint.c~drivers-scsi-flashpointc-untypedef-struct-_sccb	Mon Feb  6 14:50:10 2006
+++ 25-akpm/drivers/scsi/FlashPoint.c	Mon Feb  6 14:50:10 2006
@@ -53,9 +53,8 @@
 
 
 
-
-typedef struct _SCCB *PSCCB;
-typedef void (*CALL_BK_FN)(PSCCB);
+struct sccb;
+typedef void (*CALL_BK_FN)(struct sccb *);
 
 
 typedef struct SCCBMgr_info {
@@ -110,7 +109,7 @@ typedef SCCBMGR_INFO *      PSCCBMGR_INF
 
 
 #pragma pack(1)
-typedef struct _SCCB {
+struct sccb {
    unsigned char OperationCode;
    unsigned char ControlByte;
    unsigned char CdbLength;
@@ -146,14 +145,14 @@ typedef struct _SCCB {
    unsigned char   Sccb_tag;
    unsigned char   Sccb_scsistat;
    unsigned char   Sccb_idmsg;              /* image of last msg in */
-   PSCCB   Sccb_forwardlink;
-   PSCCB   Sccb_backlink;
+   struct sccb *   Sccb_forwardlink;
+   struct sccb *   Sccb_backlink;
    unsigned long   Sccb_savedATC;
    unsigned char   Save_Cdb[6];
    unsigned char   Save_CdbLen;
    unsigned char   Sccb_XferState;
    unsigned long   Sccb_SGoffset;
-   } SCCB;
+   };
 
 
 #pragma pack()
@@ -275,8 +274,8 @@ typedef struct SCCBMgr_tar_info *PSCCBMg
 
 typedef struct SCCBMgr_tar_info {
 
-   PSCCB    TarSelQ_Head;
-   PSCCB    TarSelQ_Tail;
+   struct sccb *    TarSelQ_Head;
+   struct sccb *    TarSelQ_Tail;
    unsigned char    TarLUN_CA;        /*Contingent Allgiance */
    unsigned char    TarTagQ_Cnt;
    unsigned char    TarSelQ_Cnt;
@@ -309,7 +308,7 @@ typedef NVRAMINFO *PNVRamInfo;
 
 
 typedef struct SCCBcard {
-   PSCCB currentSCCB;
+   struct sccb * currentSCCB;
    PSCCBMGR_INFO cardInfo;
 
    unsigned long ioPort;
@@ -322,7 +321,7 @@ typedef struct SCCBcard {
    unsigned char globalFlags;
    unsigned char ourId;
    PNVRamInfo pNvRamInfo;
-   PSCCB discQ_Tbl[QUEUE_DEPTH]; 
+   struct sccb * discQ_Tbl[QUEUE_DEPTH];
       
 }SCCBCARD;
 
@@ -973,7 +972,7 @@ typedef struct SCCBscam_info {
 static unsigned char FPT_sisyncn(unsigned long port, unsigned char p_card, unsigned char syncFlag);
 static void  FPT_ssel(unsigned long port, unsigned char p_card);
 static void  FPT_sres(unsigned long port, unsigned char p_card, PSCCBcard pCurrCard);
-static void  FPT_shandem(unsigned long port, unsigned char p_card,PSCCB pCurrSCCB);
+static void  FPT_shandem(unsigned long port, unsigned char p_card,struct sccb * pCurrSCCB);
 static void  FPT_stsyncn(unsigned long port, unsigned char p_card);
 static void  FPT_sisyncr(unsigned long port,unsigned char sync_pulse, unsigned char offset);
 static void  FPT_sssyncv(unsigned long p_port, unsigned char p_id, unsigned char p_sync_value,
@@ -989,7 +988,7 @@ static void FPT_SendMsg(unsigned long po
 static void  FPT_queueFlushTargSccb(unsigned char p_card, unsigned char thisTarg,
 				    unsigned char error_code);
 
-static void  FPT_sinits(PSCCB p_sccb, unsigned char p_card);
+static void  FPT_sinits(struct sccb * p_sccb, unsigned char p_card);
 static void  FPT_RNVRamData(PNVRamInfo pNvRamInfo);
 
 static unsigned char FPT_siwidn(unsigned long port, unsigned char p_card);
@@ -998,14 +997,14 @@ static void  FPT_siwidr(unsigned long po
 
 
 static void  FPT_queueSelectFail(PSCCBcard pCurrCard, unsigned char p_card);
-static void  FPT_queueDisconnect(PSCCB p_SCCB, unsigned char p_card);
-static void  FPT_queueCmdComplete(PSCCBcard pCurrCard, PSCCB p_SCCB,
+static void  FPT_queueDisconnect(struct sccb * p_SCCB, unsigned char p_card);
+static void  FPT_queueCmdComplete(PSCCBcard pCurrCard, struct sccb * p_SCCB,
 				  unsigned char p_card);
 static void  FPT_queueSearchSelect(PSCCBcard pCurrCard, unsigned char p_card);
 static void  FPT_queueFlushSccb(unsigned char p_card, unsigned char error_code);
-static void  FPT_queueAddSccb(PSCCB p_SCCB, unsigned char card);
-static unsigned char FPT_queueFindSccb(PSCCB p_SCCB, unsigned char p_card);
-static void  FPT_utilUpdateResidual(PSCCB p_SCCB);
+static void  FPT_queueAddSccb(struct sccb * p_SCCB, unsigned char card);
+static unsigned char FPT_queueFindSccb(struct sccb * p_SCCB, unsigned char p_card);
+static void  FPT_utilUpdateResidual(struct sccb * p_SCCB);
 static unsigned short FPT_CalcCrc16(unsigned char buffer[]);
 static unsigned char  FPT_CalcLrc(unsigned char buffer[]);
 
@@ -1043,10 +1042,10 @@ static void  FPT_DiagEEPROM(unsigned lon
 
 
 static void  FPT_dataXferProcessor(unsigned long port, PSCCBcard pCurrCard);
-static void  FPT_busMstrSGDataXferStart(unsigned long port, PSCCB pCurrSCCB);
-static void  FPT_busMstrDataXferStart(unsigned long port, PSCCB pCurrSCCB);
-static void  FPT_hostDataXferAbort(unsigned long port, unsigned char p_card, PSCCB pCurrSCCB);
-static void  FPT_hostDataXferRestart(PSCCB currSCCB);
+static void  FPT_busMstrSGDataXferStart(unsigned long port, struct sccb * pCurrSCCB);
+static void  FPT_busMstrDataXferStart(unsigned long port, struct sccb * pCurrSCCB);
+static void  FPT_hostDataXferAbort(unsigned long port, unsigned char p_card, struct sccb * pCurrSCCB);
+static void  FPT_hostDataXferRestart(struct sccb * currSCCB);
 
 
 static unsigned char FPT_SccbMgr_bad_isr(unsigned long p_port, unsigned char p_card,
@@ -1667,11 +1666,11 @@ static unsigned char FPT_ChkIfChipInitia
  *              callback function.
  *
  *---------------------------------------------------------------------*/
-static void FlashPoint_StartCCB(unsigned long pCurrCard, PSCCB p_Sccb)
+static void FlashPoint_StartCCB(unsigned long pCurrCard, struct sccb * p_Sccb)
 {
    unsigned long ioport;
    unsigned char thisCard, lun;
-	PSCCB pSaveSccb;
+	struct sccb * pSaveSccb;
    CALL_BK_FN callback;
 
    thisCard = ((PSCCBcard) pCurrCard)->cardIndex;
@@ -1787,14 +1786,14 @@ static void FlashPoint_StartCCB(unsigned
  *              callback function.
  *
  *---------------------------------------------------------------------*/
-static int FlashPoint_AbortCCB(unsigned long pCurrCard, PSCCB p_Sccb)
+static int FlashPoint_AbortCCB(unsigned long pCurrCard, struct sccb * p_Sccb)
 {
 	unsigned long ioport;
 
 	unsigned char thisCard;
 	CALL_BK_FN callback;
 	unsigned char TID;
-	PSCCB pSaveSCCB;
+	struct sccb * pSaveSCCB;
 	PSCCBMgr_tar_info currTar_Info;
 
 
@@ -1916,7 +1915,7 @@ static unsigned char FlashPoint_Interrup
  *---------------------------------------------------------------------*/
 static int FlashPoint_HandleInterrupt(unsigned long pCurrCard)
 {
-   PSCCB currSCCB;
+   struct sccb * currSCCB;
    unsigned char thisCard,result,bm_status, bm_int_st;
    unsigned short hp_int;
    unsigned char i, target;
@@ -2417,7 +2416,7 @@ static void FPT_SccbMgrTableInitTarget(u
  *
  *---------------------------------------------------------------------*/
 
-static unsigned char FPT_sfm(unsigned long port, PSCCB pCurrSCCB)
+static unsigned char FPT_sfm(unsigned long port, struct sccb * pCurrSCCB)
 {
 	unsigned char message;
 	unsigned short TimeOutLoop;
@@ -2497,7 +2496,7 @@ static void FPT_ssel(unsigned long port,
 
    unsigned long cdb_reg;
    PSCCBcard CurrCard;
-   PSCCB currSCCB;
+   struct sccb * currSCCB;
    PSCCBMgr_tar_info currTar_Info;
    unsigned char lastTag, lun;
 
@@ -2808,7 +2807,7 @@ static void FPT_sres(unsigned long port,
 
 
    PSCCBMgr_tar_info currTar_Info;
-	PSCCB currSCCB;
+	struct sccb * currSCCB;
 
 
 
@@ -3113,7 +3112,7 @@ static void FPT_SendMsg(unsigned long po
  *---------------------------------------------------------------------*/
 static void FPT_sdecm(unsigned char message, unsigned long port, unsigned char p_card)
 {
-	PSCCB currSCCB;
+	struct sccb * currSCCB;
 	PSCCBcard CurrCard;
 	PSCCBMgr_tar_info currTar_Info;
 
@@ -3290,7 +3289,7 @@ static void FPT_sdecm(unsigned char mess
  * Description: Decide what to do with the extended message.
  *
  *---------------------------------------------------------------------*/
-static void FPT_shandem(unsigned long port, unsigned char p_card, PSCCB pCurrSCCB)
+static void FPT_shandem(unsigned long port, unsigned char p_card, struct sccb * pCurrSCCB)
 {
 	unsigned char length,message;
 
@@ -3371,7 +3370,7 @@ static void FPT_shandem(unsigned long po
 
 static unsigned char FPT_sisyncn(unsigned long port, unsigned char p_card, unsigned char syncFlag)
 {
-   PSCCB currSCCB;
+   struct sccb * currSCCB;
    PSCCBMgr_tar_info currTar_Info;
 
    currSCCB = FPT_BL_Card[p_card].currentSCCB;
@@ -3447,7 +3446,7 @@ static unsigned char FPT_sisyncn(unsigne
 static void FPT_stsyncn(unsigned long port, unsigned char p_card)
 {
    unsigned char sync_msg,offset,sync_reg,our_sync_msg;
-   PSCCB currSCCB;
+   struct sccb * currSCCB;
    PSCCBMgr_tar_info currTar_Info;
 
    currSCCB = FPT_BL_Card[p_card].currentSCCB;
@@ -3609,7 +3608,7 @@ static void FPT_sisyncr(unsigned long po
 
 static unsigned char FPT_siwidn(unsigned long port, unsigned char p_card)
 {
-   PSCCB currSCCB;
+   struct sccb * currSCCB;
    PSCCBMgr_tar_info currTar_Info;
 
    currSCCB = FPT_BL_Card[p_card].currentSCCB;
@@ -3662,7 +3661,7 @@ static unsigned char FPT_siwidn(unsigned
 static void FPT_stwidn(unsigned long port, unsigned char p_card)
 {
    unsigned char width;
-   PSCCB currSCCB;
+   struct sccb * currSCCB;
    PSCCBMgr_tar_info currTar_Info;
 
    currSCCB = FPT_BL_Card[p_card].currentSCCB;
@@ -3916,7 +3915,7 @@ static void FPT_sresb(unsigned long port
 static void FPT_ssenss(PSCCBcard pCurrCard)
 {
    unsigned char i;
-   PSCCB currSCCB;
+   struct sccb * currSCCB;
 
    currSCCB = pCurrCard->currentSCCB;
 
@@ -4049,7 +4048,7 @@ static void FPT_schkdd(unsigned long por
    unsigned short TimeOutLoop;
 	unsigned char sPhase;
 
-   PSCCB currSCCB;
+   struct sccb * currSCCB;
 
    currSCCB = FPT_BL_Card[p_card].currentSCCB;
 
@@ -4157,7 +4156,7 @@ static void FPT_schkdd(unsigned long por
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_sinits(PSCCB p_sccb, unsigned char p_card)
+static void FPT_sinits(struct sccb * p_sccb, unsigned char p_card)
 {
    PSCCBMgr_tar_info currTar_Info;
 
@@ -4265,7 +4264,7 @@ static void FPT_phaseDecode(unsigned lon
 static void FPT_phaseDataOut(unsigned long port, unsigned char p_card)
 {
 
-   PSCCB currSCCB;
+   struct sccb * currSCCB;
 
    currSCCB = FPT_BL_Card[p_card].currentSCCB;
    if (currSCCB == NULL)
@@ -4309,7 +4308,7 @@ static void FPT_phaseDataOut(unsigned lo
 static void FPT_phaseDataIn(unsigned long port, unsigned char p_card)
 {
 
-   PSCCB currSCCB;
+   struct sccb * currSCCB;
 
    currSCCB = FPT_BL_Card[p_card].currentSCCB;
 
@@ -4355,7 +4354,7 @@ static void FPT_phaseDataIn(unsigned lon
 
 static void FPT_phaseCommand(unsigned long p_port, unsigned char p_card)
 {
-   PSCCB currSCCB;
+   struct sccb * currSCCB;
    unsigned long cdb_reg;
    unsigned char i;
 
@@ -4430,7 +4429,7 @@ static void FPT_phaseStatus(unsigned lon
 static void FPT_phaseMsgOut(unsigned long port, unsigned char p_card)
 {
 	unsigned char message,scsiID;
-	PSCCB currSCCB;
+	struct sccb * currSCCB;
 	PSCCBMgr_tar_info currTar_Info;
 
 	currSCCB = FPT_BL_Card[p_card].currentSCCB;
@@ -4578,7 +4577,7 @@ static void FPT_phaseMsgOut(unsigned lon
 static void FPT_phaseMsgIn(unsigned long port, unsigned char p_card)
 {
 	unsigned char message;
-	PSCCB currSCCB;
+	struct sccb * currSCCB;
 
 	currSCCB = FPT_BL_Card[p_card].currentSCCB;
 
@@ -4630,7 +4629,7 @@ static void FPT_phaseMsgIn(unsigned long
 
 static void FPT_phaseIllegal(unsigned long port, unsigned char p_card)
 {
-   PSCCB currSCCB;
+   struct sccb * currSCCB;
 
    currSCCB = FPT_BL_Card[p_card].currentSCCB;
 
@@ -4659,7 +4658,7 @@ static void FPT_phaseIllegal(unsigned lo
 static void FPT_phaseChkFifo(unsigned long port, unsigned char p_card)
 {
    unsigned long xfercnt;
-   PSCCB currSCCB;
+   struct sccb * currSCCB;
 
    currSCCB = FPT_BL_Card[p_card].currentSCCB;
 
@@ -4736,7 +4735,7 @@ static void FPT_phaseChkFifo(unsigned lo
  *---------------------------------------------------------------------*/
 static void FPT_phaseBusFree(unsigned long port, unsigned char p_card)
 {
-   PSCCB currSCCB;
+   struct sccb * currSCCB;
 
    currSCCB = FPT_BL_Card[p_card].currentSCCB;
 
@@ -4942,7 +4941,7 @@ static void FPT_autoLoadDefaultMap(unsig
 
 static void FPT_autoCmdCmplt(unsigned long p_port, unsigned char p_card)
 {
-   PSCCB currSCCB;
+   struct sccb * currSCCB;
    unsigned char status_byte;
 
    currSCCB = FPT_BL_Card[p_card].currentSCCB;
@@ -5157,7 +5156,7 @@ static void FPT_autoCmdCmplt(unsigned lo
 
 static void FPT_dataXferProcessor(unsigned long port, PSCCBcard pCurrCard)
 {
-   PSCCB currSCCB;
+   struct sccb * currSCCB;
 
    currSCCB = pCurrCard->currentSCCB;
 
@@ -5193,7 +5192,7 @@ static void FPT_dataXferProcessor(unsign
  * Description:
  *
  *---------------------------------------------------------------------*/
-static void FPT_busMstrSGDataXferStart(unsigned long p_port, PSCCB pcurrSCCB)
+static void FPT_busMstrSGDataXferStart(unsigned long p_port, struct sccb * pcurrSCCB)
 {
    unsigned long count,addr,tmpSGCnt;
    unsigned int sg_index;
@@ -5298,7 +5297,7 @@ static void FPT_busMstrSGDataXferStart(u
  * Description: 
  *
  *---------------------------------------------------------------------*/
-static void FPT_busMstrDataXferStart(unsigned long p_port, PSCCB pcurrSCCB)
+static void FPT_busMstrDataXferStart(unsigned long p_port, struct sccb * pcurrSCCB)
 {
    unsigned long addr,count;
 
@@ -5389,7 +5388,7 @@ static unsigned char FPT_busMstrTimeOut(
  * Description: Abort any in progress transfer.
  *
  *---------------------------------------------------------------------*/
-static void FPT_hostDataXferAbort(unsigned long port, unsigned char p_card, PSCCB pCurrSCCB)
+static void FPT_hostDataXferAbort(unsigned long port, unsigned char p_card, struct sccb * pCurrSCCB)
 {
 
    unsigned long timeout;
@@ -5647,7 +5646,7 @@ static void FPT_hostDataXferAbort(unsign
  *              pointers message.
  *
  *---------------------------------------------------------------------*/
-static void FPT_hostDataXferRestart(PSCCB currSCCB)
+static void FPT_hostDataXferRestart(struct sccb * currSCCB)
 {
    unsigned long data_count;
    unsigned int  sg_index;
@@ -6939,7 +6938,7 @@ static void FPT_queueSearchSelect(PSCCBc
 {
    unsigned char scan_ptr, lun;
    PSCCBMgr_tar_info currTar_Info;
-	PSCCB pOldSccb;
+	struct sccb * pOldSccb;
 
    scan_ptr = pCurrCard->scanIndex;
 	do 
@@ -6967,22 +6966,22 @@ static void FPT_queueSearchSelect(PSCCBc
 								 (lun != pCurrCard->currentSCCB->Lun))
 						{
 							pOldSccb = pCurrCard->currentSCCB;
-							pCurrCard->currentSCCB = (PSCCB)(pCurrCard->currentSCCB)->
+							pCurrCard->currentSCCB = (struct sccb *)(pCurrCard->currentSCCB)->
 																	Sccb_forwardlink;
 						}
 						if(pCurrCard->currentSCCB == NULL)
 							continue;
 						if(pOldSccb != NULL)
 						{
-							pOldSccb->Sccb_forwardlink = (PSCCB)(pCurrCard->currentSCCB)->
+							pOldSccb->Sccb_forwardlink = (struct sccb *)(pCurrCard->currentSCCB)->
 																	Sccb_forwardlink;
-							pOldSccb->Sccb_backlink = (PSCCB)(pCurrCard->currentSCCB)->
+							pOldSccb->Sccb_backlink = (struct sccb *)(pCurrCard->currentSCCB)->
 																	Sccb_backlink;
 							currTar_Info->TarSelQ_Cnt--;
 						}
 						else
 						{
-							currTar_Info->TarSelQ_Head = (PSCCB)(pCurrCard->currentSCCB)->Sccb_forwardlink;
+							currTar_Info->TarSelQ_Head = (struct sccb *)(pCurrCard->currentSCCB)->Sccb_forwardlink;
 					
 							if (currTar_Info->TarSelQ_Head == NULL)
 							{
@@ -6992,7 +6991,7 @@ static void FPT_queueSearchSelect(PSCCBc
 							else
 							{
 								currTar_Info->TarSelQ_Cnt--;
-								currTar_Info->TarSelQ_Head->Sccb_backlink = (PSCCB)NULL;
+								currTar_Info->TarSelQ_Head->Sccb_backlink = (struct sccb *)NULL;
 							}
 						}
 					pCurrCard->scanIndex = scan_ptr;
@@ -7021,7 +7020,7 @@ static void FPT_queueSearchSelect(PSCCBc
 
 				pCurrCard->currentSCCB = currTar_Info->TarSelQ_Head;
 
-				currTar_Info->TarSelQ_Head = (PSCCB)(pCurrCard->currentSCCB)->Sccb_forwardlink;
+				currTar_Info->TarSelQ_Head = (struct sccb *)(pCurrCard->currentSCCB)->Sccb_forwardlink;
 
 				if (currTar_Info->TarSelQ_Head == NULL)
 				{
@@ -7031,7 +7030,7 @@ static void FPT_queueSearchSelect(PSCCBc
 				else
 				{
 					currTar_Info->TarSelQ_Cnt--;
-					currTar_Info->TarSelQ_Head->Sccb_backlink = (PSCCB)NULL;
+					currTar_Info->TarSelQ_Head->Sccb_backlink = (struct sccb *)NULL;
 				}
 
 				scan_ptr++;
@@ -7073,10 +7072,10 @@ static void FPT_queueSelectFail(PSCCBcar
 
    if (pCurrCard->currentSCCB != NULL)
 	  {
-	  thisTarg = (unsigned char)(((PSCCB)(pCurrCard->currentSCCB))->TargID);
+	  thisTarg = (unsigned char)(((struct sccb *)(pCurrCard->currentSCCB))->TargID);
       currTar_Info = &FPT_sccbMgrTbl[p_card][thisTarg];
 
-      pCurrCard->currentSCCB->Sccb_backlink = (PSCCB)NULL;
+      pCurrCard->currentSCCB->Sccb_backlink = (struct sccb *)NULL;
 
       pCurrCard->currentSCCB->Sccb_forwardlink = currTar_Info->TarSelQ_Head;
 
@@ -7105,7 +7104,7 @@ static void FPT_queueSelectFail(PSCCBcar
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_queueCmdComplete(PSCCBcard pCurrCard, PSCCB p_sccb,
+static void FPT_queueCmdComplete(PSCCBcard pCurrCard, struct sccb * p_sccb,
 				 unsigned char p_card)
 {
 
@@ -7207,7 +7206,7 @@ static void FPT_queueCmdComplete(PSCCBca
  * Description: Add SCCB to our disconnect array.
  *
  *---------------------------------------------------------------------*/
-static void FPT_queueDisconnect(PSCCB p_sccb, unsigned char p_card)
+static void FPT_queueDisconnect(struct sccb * p_sccb, unsigned char p_card)
 {
    PSCCBMgr_tar_info currTar_Info;
 
@@ -7245,7 +7244,7 @@ static void FPT_queueDisconnect(PSCCB p_
 static void  FPT_queueFlushSccb(unsigned char p_card, unsigned char error_code)
 {
    unsigned char qtag,thisTarg;
-   PSCCB currSCCB;
+   struct sccb * currSCCB;
    PSCCBMgr_tar_info currTar_Info;
 
    currSCCB = FPT_BL_Card[p_card].currentSCCB;
@@ -7311,7 +7310,7 @@ static void  FPT_queueFlushTargSccb(unsi
 
 
 
-static void FPT_queueAddSccb(PSCCB p_SCCB, unsigned char p_card)
+static void FPT_queueAddSccb(struct sccb * p_SCCB, unsigned char p_card)
 {
    PSCCBMgr_tar_info currTar_Info;
    currTar_Info = &FPT_sccbMgrTbl[p_card][p_SCCB->TargID];
@@ -7345,9 +7344,9 @@ static void FPT_queueAddSccb(PSCCB p_SCC
  *
  *---------------------------------------------------------------------*/
 
-static unsigned char FPT_queueFindSccb(PSCCB p_SCCB, unsigned char p_card)
+static unsigned char FPT_queueFindSccb(struct sccb * p_SCCB, unsigned char p_card)
 {
-   PSCCB q_ptr;
+   struct sccb * q_ptr;
    PSCCBMgr_tar_info currTar_Info;
 
    currTar_Info = &FPT_sccbMgrTbl[p_card][p_SCCB->TargID];
@@ -7406,7 +7405,7 @@ static unsigned char FPT_queueFindSccb(P
  *
  *---------------------------------------------------------------------*/
 
-static void  FPT_utilUpdateResidual(PSCCB p_SCCB)
+static void  FPT_utilUpdateResidual(struct sccb * p_SCCB)
 {
    unsigned long partial_cnt;
    unsigned int  sg_index;
@@ -7809,14 +7808,14 @@ FlashPoint__ReleaseHostAdapter(FlashPoin
 static inline void
 FlashPoint__StartCCB(FlashPoint_CardHandle_T CardHandle, struct BusLogic_CCB *CCB)
 {
-  FlashPoint_StartCCB(CardHandle, (PSCCB) CCB);
+  FlashPoint_StartCCB(CardHandle, (struct sccb *) CCB);
 }
 
 
 static inline void
 FlashPoint__AbortCCB(FlashPoint_CardHandle_T CardHandle, struct BusLogic_CCB *CCB)
 {
-  FlashPoint_AbortCCB(CardHandle, (PSCCB) CCB);
+  FlashPoint_AbortCCB(CardHandle, (struct sccb *) CCB);
 }
 
 
_
