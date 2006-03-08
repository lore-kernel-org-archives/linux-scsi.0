From: akpm@osdl.org
Subject: [patch 11/28] drivers/scsi/FlashPoint.c: remove ULONG
Date: Wed, 08 Mar 2006 00:14:26 -0800
Message-ID: <200603080816.k288GGq3002185@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:32172 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932489AbWCHIQZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2006 03:16:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, adobriyan@gmail.com


From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/FlashPoint.c |  379 +++++++++++++++++-------------------
 1 files changed, 189 insertions(+), 190 deletions(-)

diff -puN drivers/scsi/FlashPoint.c~drivers-scsi-flashpointc-remove-ulong drivers/scsi/FlashPoint.c
--- 25/drivers/scsi/FlashPoint.c~drivers-scsi-flashpointc-remove-ulong	Mon Feb  6 14:50:04 2006
+++ 25-akpm/drivers/scsi/FlashPoint.c	Mon Feb  6 14:50:04 2006
@@ -40,7 +40,6 @@
 #define FAILURE         0xFFFFFFFFL
 
 
-typedef unsigned long   ULONG;
 
 
 typedef unsigned short          * ushort_ptr;
@@ -67,7 +66,7 @@ typedef void (*CALL_BK_FN)(PSCCB);
 
 
 typedef struct SCCBMgr_info {
-   ULONG    si_baseaddr;
+   unsigned long    si_baseaddr;
    unsigned char    si_present;
    unsigned char    si_intvect;
    unsigned char    si_id;
@@ -84,10 +83,10 @@ typedef struct SCCBMgr_info {
    unsigned char    si_card_model[3];
    unsigned char    si_relative_cardnum;
    unsigned char    si_reserved[4];
-   ULONG    si_OS_reserved;
+   unsigned long    si_OS_reserved;
    unsigned char    si_XlatInfo[4];
-   ULONG    si_reserved2[5];
-   ULONG    si_secondary_range;
+   unsigned long    si_reserved2[5];
+   unsigned long    si_secondary_range;
 } SCCBMGR_INFO;
 
 typedef SCCBMGR_INFO *      PSCCBMGR_INFO;
@@ -123,8 +122,8 @@ typedef struct _SCCB {
    unsigned char ControlByte;
    unsigned char CdbLength;
    unsigned char RequestSenseLength;
-   ULONG DataLength;
-   ULONG DataPointer;
+   unsigned long DataLength;
+   unsigned long DataPointer;
    unsigned char CcbRes[2];
    unsigned char HostStatus;
    unsigned char TargetStatus;
@@ -133,21 +132,21 @@ typedef struct _SCCB {
    unsigned char Cdb[12];
    unsigned char CcbRes1;
    unsigned char Reserved1;
-   ULONG Reserved2;
-   ULONG SensePointer;
+   unsigned long Reserved2;
+   unsigned long SensePointer;
 
 
    CALL_BK_FN SccbCallback;                  /* VOID (*SccbCallback)(); */
-   ULONG  SccbIOPort;                        /* Identifies board base port */
+   unsigned long  SccbIOPort;                        /* Identifies board base port */
    unsigned char  SccbStatus;
    unsigned char  SCCBRes2;
    unsigned short SccbOSFlags;
 
 
-   ULONG   Sccb_XferCnt;            /* actual transfer count */
-   ULONG   Sccb_ATC;
-   ULONG   SccbVirtDataPtr;         /* virtual addr for OS/2 */
-   ULONG   Sccb_res1;
+   unsigned long   Sccb_XferCnt;            /* actual transfer count */
+   unsigned long   Sccb_ATC;
+   unsigned long   SccbVirtDataPtr;         /* virtual addr for OS/2 */
+   unsigned long   Sccb_res1;
    unsigned short  Sccb_MGRFlags;
    unsigned short  Sccb_sgseg;
    unsigned char   Sccb_scsimsg;            /* identify msg for selection */
@@ -156,11 +155,11 @@ typedef struct _SCCB {
    unsigned char   Sccb_idmsg;              /* image of last msg in */
    PSCCB   Sccb_forwardlink;
    PSCCB   Sccb_backlink;
-   ULONG   Sccb_savedATC;
+   unsigned long   Sccb_savedATC;
    unsigned char   Save_Cdb[6];
    unsigned char   Save_CdbLen;
    unsigned char   Sccb_XferState;
-   ULONG   Sccb_SGoffset;
+   unsigned long   Sccb_SGoffset;
    } SCCB;
 
 
@@ -299,7 +298,7 @@ typedef struct SCCBMgr_tar_info {
 typedef struct NVRAMInfo {
 	unsigned char		niModel;								/* Model No. of card */
 	unsigned char		niCardNo;							/* Card no. */
-	ULONG		niBaseAddr;							/* Port Address of card */
+	unsigned long		niBaseAddr;							/* Port Address of card */
 	unsigned char		niSysConf;							/* Adapter Configuration byte - Byte 16 of eeprom map */
 	unsigned char		niScsiConf;							/* SCSI Configuration byte - Byte 17 of eeprom map */
 	unsigned char		niScamConf;							/* SCAM Configuration byte - Byte 20 of eeprom map */
@@ -320,7 +319,7 @@ typedef struct SCCBcard {
    PSCCB currentSCCB;
    PSCCBMGR_INFO cardInfo;
 
-   ULONG ioPort;
+   unsigned long ioPort;
 
    unsigned short cmdCounter;
    unsigned char  discQCount;
@@ -978,31 +977,31 @@ typedef struct SCCBscam_info {
 
 
 
-static unsigned char FPT_sisyncn(ULONG port, unsigned char p_card, unsigned char syncFlag);
-static void  FPT_ssel(ULONG port, unsigned char p_card);
-static void  FPT_sres(ULONG port, unsigned char p_card, PSCCBcard pCurrCard);
-static void  FPT_shandem(ULONG port, unsigned char p_card,PSCCB pCurrSCCB);
-static void  FPT_stsyncn(ULONG port, unsigned char p_card);
-static void  FPT_sisyncr(ULONG port,unsigned char sync_pulse, unsigned char offset);
-static void  FPT_sssyncv(ULONG p_port, unsigned char p_id, unsigned char p_sync_value,
+static unsigned char FPT_sisyncn(unsigned long port, unsigned char p_card, unsigned char syncFlag);
+static void  FPT_ssel(unsigned long port, unsigned char p_card);
+static void  FPT_sres(unsigned long port, unsigned char p_card, PSCCBcard pCurrCard);
+static void  FPT_shandem(unsigned long port, unsigned char p_card,PSCCB pCurrSCCB);
+static void  FPT_stsyncn(unsigned long port, unsigned char p_card);
+static void  FPT_sisyncr(unsigned long port,unsigned char sync_pulse, unsigned char offset);
+static void  FPT_sssyncv(unsigned long p_port, unsigned char p_id, unsigned char p_sync_value,
 			 PSCCBMgr_tar_info currTar_Info);
-static void  FPT_sresb(ULONG port, unsigned char p_card);
-static void  FPT_sxfrp(ULONG p_port, unsigned char p_card);
-static void  FPT_schkdd(ULONG port, unsigned char p_card);
-static unsigned char FPT_RdStack(ULONG port, unsigned char index);
-static void  FPT_WrStack(ULONG portBase, unsigned char index, unsigned char data);
-static unsigned char FPT_ChkIfChipInitialized(ULONG ioPort);
+static void  FPT_sresb(unsigned long port, unsigned char p_card);
+static void  FPT_sxfrp(unsigned long p_port, unsigned char p_card);
+static void  FPT_schkdd(unsigned long port, unsigned char p_card);
+static unsigned char FPT_RdStack(unsigned long port, unsigned char index);
+static void  FPT_WrStack(unsigned long portBase, unsigned char index, unsigned char data);
+static unsigned char FPT_ChkIfChipInitialized(unsigned long ioPort);
 
-static void FPT_SendMsg(ULONG port, unsigned char message);
+static void FPT_SendMsg(unsigned long port, unsigned char message);
 static void  FPT_queueFlushTargSccb(unsigned char p_card, unsigned char thisTarg,
 				    unsigned char error_code);
 
 static void  FPT_sinits(PSCCB p_sccb, unsigned char p_card);
 static void  FPT_RNVRamData(PNVRamInfo pNvRamInfo);
 
-static unsigned char FPT_siwidn(ULONG port, unsigned char p_card);
-static void  FPT_stwidn(ULONG port, unsigned char p_card);
-static void  FPT_siwidr(ULONG port, unsigned char width);
+static unsigned char FPT_siwidn(unsigned long port, unsigned char p_card);
+static void  FPT_stwidn(unsigned long port, unsigned char p_card);
+static void  FPT_siwidr(unsigned long port, unsigned char width);
 
 
 static void  FPT_queueSelectFail(PSCCBcard pCurrCard, unsigned char p_card);
@@ -1018,46 +1017,46 @@ static unsigned short FPT_CalcCrc16(unsi
 static unsigned char  FPT_CalcLrc(unsigned char buffer[]);
 
 
-static void  FPT_Wait1Second(ULONG p_port);
-static void  FPT_Wait(ULONG p_port, unsigned char p_delay);
-static void  FPT_utilEEWriteOnOff(ULONG p_port,unsigned char p_mode);
-static void  FPT_utilEEWrite(ULONG p_port, unsigned short ee_data, unsigned short ee_addr);
-static unsigned short FPT_utilEERead(ULONG p_port, unsigned short ee_addr);
-static unsigned short FPT_utilEEReadOrg(ULONG p_port, unsigned short ee_addr);
-static void  FPT_utilEESendCmdAddr(ULONG p_port, unsigned char ee_cmd, unsigned short ee_addr);
+static void  FPT_Wait1Second(unsigned long p_port);
+static void  FPT_Wait(unsigned long p_port, unsigned char p_delay);
+static void  FPT_utilEEWriteOnOff(unsigned long p_port,unsigned char p_mode);
+static void  FPT_utilEEWrite(unsigned long p_port, unsigned short ee_data, unsigned short ee_addr);
+static unsigned short FPT_utilEERead(unsigned long p_port, unsigned short ee_addr);
+static unsigned short FPT_utilEEReadOrg(unsigned long p_port, unsigned short ee_addr);
+static void  FPT_utilEESendCmdAddr(unsigned long p_port, unsigned char ee_cmd, unsigned short ee_addr);
 
 
 
-static void  FPT_phaseDataOut(ULONG port, unsigned char p_card);
-static void  FPT_phaseDataIn(ULONG port, unsigned char p_card);
-static void  FPT_phaseCommand(ULONG port, unsigned char p_card);
-static void  FPT_phaseStatus(ULONG port, unsigned char p_card);
-static void  FPT_phaseMsgOut(ULONG port, unsigned char p_card);
-static void  FPT_phaseMsgIn(ULONG port, unsigned char p_card);
-static void  FPT_phaseIllegal(ULONG port, unsigned char p_card);
+static void  FPT_phaseDataOut(unsigned long port, unsigned char p_card);
+static void  FPT_phaseDataIn(unsigned long port, unsigned char p_card);
+static void  FPT_phaseCommand(unsigned long port, unsigned char p_card);
+static void  FPT_phaseStatus(unsigned long port, unsigned char p_card);
+static void  FPT_phaseMsgOut(unsigned long port, unsigned char p_card);
+static void  FPT_phaseMsgIn(unsigned long port, unsigned char p_card);
+static void  FPT_phaseIllegal(unsigned long port, unsigned char p_card);
 
-static void  FPT_phaseDecode(ULONG port, unsigned char p_card);
-static void  FPT_phaseChkFifo(ULONG port, unsigned char p_card);
-static void  FPT_phaseBusFree(ULONG p_port, unsigned char p_card);
+static void  FPT_phaseDecode(unsigned long port, unsigned char p_card);
+static void  FPT_phaseChkFifo(unsigned long port, unsigned char p_card);
+static void  FPT_phaseBusFree(unsigned long p_port, unsigned char p_card);
 
 
 
 
-static void  FPT_XbowInit(ULONG port, unsigned char scamFlg);
-static void  FPT_BusMasterInit(ULONG p_port);
-static void  FPT_DiagEEPROM(ULONG p_port);
+static void  FPT_XbowInit(unsigned long port, unsigned char scamFlg);
+static void  FPT_BusMasterInit(unsigned long p_port);
+static void  FPT_DiagEEPROM(unsigned long p_port);
 
 
 
 
-static void  FPT_dataXferProcessor(ULONG port, PSCCBcard pCurrCard);
-static void  FPT_busMstrSGDataXferStart(ULONG port, PSCCB pCurrSCCB);
-static void  FPT_busMstrDataXferStart(ULONG port, PSCCB pCurrSCCB);
-static void  FPT_hostDataXferAbort(ULONG port, unsigned char p_card, PSCCB pCurrSCCB);
+static void  FPT_dataXferProcessor(unsigned long port, PSCCBcard pCurrCard);
+static void  FPT_busMstrSGDataXferStart(unsigned long port, PSCCB pCurrSCCB);
+static void  FPT_busMstrDataXferStart(unsigned long port, PSCCB pCurrSCCB);
+static void  FPT_hostDataXferAbort(unsigned long port, unsigned char p_card, PSCCB pCurrSCCB);
 static void  FPT_hostDataXferRestart(PSCCB currSCCB);
 
 
-static unsigned char FPT_SccbMgr_bad_isr(ULONG p_port, unsigned char p_card,
+static unsigned char FPT_SccbMgr_bad_isr(unsigned long p_port, unsigned char p_card,
 				 PSCCBcard pCurrCard, unsigned short p_int);
 
 static void  FPT_SccbMgrTableInitAll(void);
@@ -1068,25 +1067,25 @@ static void  FPT_SccbMgrTableInitTarget(
 
 static void  FPT_scini(unsigned char p_card, unsigned char p_our_id, unsigned char p_power_up);
 
-static int   FPT_scarb(ULONG p_port, unsigned char p_sel_type);
-static void  FPT_scbusf(ULONG p_port);
-static void  FPT_scsel(ULONG p_port);
-static void  FPT_scasid(unsigned char p_card, ULONG p_port);
-static unsigned char FPT_scxferc(ULONG p_port, unsigned char p_data);
-static unsigned char FPT_scsendi(ULONG p_port, unsigned char p_id_string[]);
-static unsigned char FPT_sciso(ULONG p_port, unsigned char p_id_string[]);
-static void  FPT_scwirod(ULONG p_port, unsigned char p_data_bit);
-static void  FPT_scwiros(ULONG p_port, unsigned char p_data_bit);
+static int   FPT_scarb(unsigned long p_port, unsigned char p_sel_type);
+static void  FPT_scbusf(unsigned long p_port);
+static void  FPT_scsel(unsigned long p_port);
+static void  FPT_scasid(unsigned char p_card, unsigned long p_port);
+static unsigned char FPT_scxferc(unsigned long p_port, unsigned char p_data);
+static unsigned char FPT_scsendi(unsigned long p_port, unsigned char p_id_string[]);
+static unsigned char FPT_sciso(unsigned long p_port, unsigned char p_id_string[]);
+static void  FPT_scwirod(unsigned long p_port, unsigned char p_data_bit);
+static void  FPT_scwiros(unsigned long p_port, unsigned char p_data_bit);
 static unsigned char FPT_scvalq(unsigned char p_quintet);
-static unsigned char FPT_scsell(ULONG p_port, unsigned char targ_id);
-static void  FPT_scwtsel(ULONG p_port);
-static void  FPT_inisci(unsigned char p_card, ULONG p_port, unsigned char p_our_id);
-static void  FPT_scsavdi(unsigned char p_card, ULONG p_port);
+static unsigned char FPT_scsell(unsigned long p_port, unsigned char targ_id);
+static void  FPT_scwtsel(unsigned long p_port);
+static void  FPT_inisci(unsigned char p_card, unsigned long p_port, unsigned char p_our_id);
+static void  FPT_scsavdi(unsigned char p_card, unsigned long p_port);
 static unsigned char FPT_scmachid(unsigned char p_card, unsigned char p_id_string[]);
 
 
-static void  FPT_autoCmdCmplt(ULONG p_port, unsigned char p_card);
-static void  FPT_autoLoadDefaultMap(ULONG p_port);
+static void  FPT_autoCmdCmplt(unsigned long p_port, unsigned char p_card);
+static void  FPT_autoLoadDefaultMap(unsigned long p_port);
 
 
 
@@ -1106,7 +1105,7 @@ static unsigned char FPT_scamHAString[] 
 static unsigned short FPT_default_intena = 0;
 
 
-static void (*FPT_s_PhaseTbl[8]) (ULONG, unsigned char)= { 0 };
+static void (*FPT_s_PhaseTbl[8]) (unsigned long, unsigned char)= { 0 };
 
 
 /*---------------------------------------------------------------------
@@ -1123,7 +1122,7 @@ static int FlashPoint_ProbeHostAdapter(P
 
    unsigned char i,j,id,ScamFlg;
    unsigned short temp,temp2,temp3,temp4,temp5,temp6;
-   ULONG ioport;
+   unsigned long ioport;
 	PNVRamInfo pCurrNvRam;
 
    ioport = pCardInfo->si_baseaddr;
@@ -1395,13 +1394,13 @@ static int FlashPoint_ProbeHostAdapter(P
  *
  *---------------------------------------------------------------------*/
 
-static ULONG FlashPoint_HardwareResetHostAdapter(PSCCBMGR_INFO pCardInfo)
+static unsigned long FlashPoint_HardwareResetHostAdapter(PSCCBMGR_INFO pCardInfo)
 {
    PSCCBcard CurrCard = NULL;
 	PNVRamInfo pCurrNvRam;
    unsigned char i,j,thisCard, ScamFlg;
    unsigned short temp,sync_bit_map,id;
-   ULONG ioport;
+   unsigned long ioport;
 
    ioport = pCardInfo->si_baseaddr;
 
@@ -1573,16 +1572,16 @@ static ULONG FlashPoint_HardwareResetHos
    WR_HARPOON((ioport+hp_semaphore),
       (unsigned char)(RD_HARPOON((ioport+hp_semaphore)) | SCCB_MGR_PRESENT));
 
-   return((ULONG)CurrCard);
+   return((unsigned long)CurrCard);
 }
 
-static void FlashPoint_ReleaseHostAdapter(ULONG pCurrCard)
+static void FlashPoint_ReleaseHostAdapter(unsigned long pCurrCard)
 {
 	unsigned char i;
-	ULONG portBase;
-	ULONG regOffset;
-	ULONG scamData;
-	ULONG *pScamTbl;
+	unsigned long portBase;
+	unsigned long regOffset;
+	unsigned long scamData;
+	unsigned long *pScamTbl;
 	PNVRamInfo pCurrNvRam;
 
 	pCurrNvRam = ((PSCCBcard)pCurrCard)->pNvRamInfo;
@@ -1601,7 +1600,7 @@ static void FlashPoint_ReleaseHostAdapte
 
 		for(i = 0; i < MAX_SCSI_TAR; i++){
 			regOffset = hp_aramBase + 64 + i*4;
-			pScamTbl = (ULONG *) &pCurrNvRam->niScamTbl[i];
+			pScamTbl = (unsigned long *) &pCurrNvRam->niScamTbl[i];
 			scamData = *pScamTbl;
 			WR_HARP32(portBase, regOffset, scamData);
 		}
@@ -1615,10 +1614,10 @@ static void FlashPoint_ReleaseHostAdapte
 static void FPT_RNVRamData(PNVRamInfo pNvRamInfo)
 {
 	unsigned char i;
-	ULONG portBase;
-	ULONG regOffset;
-	ULONG scamData;
-	ULONG *pScamTbl;
+	unsigned long portBase;
+	unsigned long regOffset;
+	unsigned long scamData;
+	unsigned long *pScamTbl;
 
 	pNvRamInfo->niModel    = FPT_RdStack(pNvRamInfo->niBaseAddr, 0);
 	pNvRamInfo->niSysConf  = FPT_RdStack(pNvRamInfo->niBaseAddr, 1);
@@ -1634,26 +1633,26 @@ static void FPT_RNVRamData(PNVRamInfo pN
 	for(i = 0; i < MAX_SCSI_TAR; i++){
 		regOffset = hp_aramBase + 64 + i*4;
 		RD_HARP32(portBase, regOffset, scamData);
-		pScamTbl = (ULONG *) &pNvRamInfo->niScamTbl[i];
+		pScamTbl = (unsigned long *) &pNvRamInfo->niScamTbl[i];
 		*pScamTbl = scamData;
 	}
 
 }
 
-static unsigned char FPT_RdStack(ULONG portBase, unsigned char index)
+static unsigned char FPT_RdStack(unsigned long portBase, unsigned char index)
 {
 	WR_HARPOON(portBase + hp_stack_addr, index);
 	return(RD_HARPOON(portBase + hp_stack_data));
 }
 
-static void FPT_WrStack(ULONG portBase, unsigned char index, unsigned char data)
+static void FPT_WrStack(unsigned long portBase, unsigned char index, unsigned char data)
 {
 	WR_HARPOON(portBase + hp_stack_addr, index);
 	WR_HARPOON(portBase + hp_stack_data, data);
 }
 
 
-static unsigned char FPT_ChkIfChipInitialized(ULONG ioPort)
+static unsigned char FPT_ChkIfChipInitialized(unsigned long ioPort)
 {
 	if((RD_HARPOON(ioPort + hp_arb_id) & 0x0f) != FPT_RdStack(ioPort, 4))
 		return(0);
@@ -1675,9 +1674,9 @@ static unsigned char FPT_ChkIfChipInitia
  *              callback function.
  *
  *---------------------------------------------------------------------*/
-static void FlashPoint_StartCCB(ULONG pCurrCard, PSCCB p_Sccb)
+static void FlashPoint_StartCCB(unsigned long pCurrCard, PSCCB p_Sccb)
 {
-   ULONG ioport;
+   unsigned long ioport;
    unsigned char thisCard, lun;
 	PSCCB pSaveSccb;
    CALL_BK_FN callback;
@@ -1795,9 +1794,9 @@ static void FlashPoint_StartCCB(ULONG pC
  *              callback function.
  *
  *---------------------------------------------------------------------*/
-static int FlashPoint_AbortCCB(ULONG pCurrCard, PSCCB p_Sccb)
+static int FlashPoint_AbortCCB(unsigned long pCurrCard, PSCCB p_Sccb)
 {
-	ULONG ioport;
+	unsigned long ioport;
 
 	unsigned char thisCard;
 	CALL_BK_FN callback;
@@ -1895,9 +1894,9 @@ static int FlashPoint_AbortCCB(ULONG pCu
  *              interrupt for this card and disable the IRQ Pin if so.
  *
  *---------------------------------------------------------------------*/
-static unsigned char FlashPoint_InterruptPending(ULONG pCurrCard)
+static unsigned char FlashPoint_InterruptPending(unsigned long pCurrCard)
 {
-   ULONG ioport;
+   unsigned long ioport;
 
    ioport = ((PSCCBcard)pCurrCard)->ioPort;
 
@@ -1922,13 +1921,13 @@ static unsigned char FlashPoint_Interrup
  *              us.
  *
  *---------------------------------------------------------------------*/
-static int FlashPoint_HandleInterrupt(ULONG pCurrCard)
+static int FlashPoint_HandleInterrupt(unsigned long pCurrCard)
 {
    PSCCB currSCCB;
    unsigned char thisCard,result,bm_status, bm_int_st;
    unsigned short hp_int;
    unsigned char i, target;
-   ULONG ioport;
+   unsigned long ioport;
 
    thisCard = ((PSCCBcard)pCurrCard)->cardIndex;
    ioport = ((PSCCBcard)pCurrCard)->ioPort;
@@ -2167,7 +2166,7 @@ static int FlashPoint_HandleInterrupt(UL
  *              processing time.
  *
  *---------------------------------------------------------------------*/
-static unsigned char FPT_SccbMgr_bad_isr(ULONG p_port, unsigned char p_card,
+static unsigned char FPT_SccbMgr_bad_isr(unsigned long p_port, unsigned char p_card,
 				 PSCCBcard pCurrCard, unsigned short p_int)
 {
    unsigned char temp, ScamFlg;
@@ -2425,7 +2424,7 @@ static void FPT_SccbMgrTableInitTarget(u
  *
  *---------------------------------------------------------------------*/
 
-static unsigned char FPT_sfm(ULONG port, PSCCB pCurrSCCB)
+static unsigned char FPT_sfm(unsigned long port, PSCCB pCurrSCCB)
 {
 	unsigned char message;
 	unsigned short TimeOutLoop;
@@ -2498,12 +2497,12 @@ static unsigned char FPT_sfm(ULONG port,
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_ssel(ULONG port, unsigned char p_card)
+static void FPT_ssel(unsigned long port, unsigned char p_card)
 {
 
    unsigned char auto_loaded, i, target, *theCCB;
 
-   ULONG cdb_reg;
+   unsigned long cdb_reg;
    PSCCBcard CurrCard;
    PSCCB currSCCB;
    PSCCBMgr_tar_info currTar_Info;
@@ -2809,7 +2808,7 @@ static void FPT_ssel(ULONG port, unsigne
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_sres(ULONG port, unsigned char p_card, PSCCBcard pCurrCard)
+static void FPT_sres(unsigned long port, unsigned char p_card, PSCCBcard pCurrCard)
 {
 
    unsigned char our_target, message, lun = 0, tag, msgRetryCount;
@@ -3070,7 +3069,7 @@ static void FPT_sres(ULONG port, unsigne
 	  (RD_HARPOON(port+hp_scsisig) & SCSI_BSY)) ;
 }
 
-static void FPT_SendMsg(ULONG port, unsigned char message)
+static void FPT_SendMsg(unsigned long port, unsigned char message)
 {
 	while(!(RD_HARPOON(port+hp_scsisig) & SCSI_REQ))
 	{
@@ -3119,7 +3118,7 @@ static void FPT_SendMsg(ULONG port, unsi
  *              target device.
  *
  *---------------------------------------------------------------------*/
-static void FPT_sdecm(unsigned char message, ULONG port, unsigned char p_card)
+static void FPT_sdecm(unsigned char message, unsigned long port, unsigned char p_card)
 {
 	PSCCB currSCCB;
 	PSCCBcard CurrCard;
@@ -3298,7 +3297,7 @@ static void FPT_sdecm(unsigned char mess
  * Description: Decide what to do with the extended message.
  *
  *---------------------------------------------------------------------*/
-static void FPT_shandem(ULONG port, unsigned char p_card, PSCCB pCurrSCCB)
+static void FPT_shandem(unsigned long port, unsigned char p_card, PSCCB pCurrSCCB)
 {
 	unsigned char length,message;
 
@@ -3377,7 +3376,7 @@ static void FPT_shandem(ULONG port, unsi
  *
  *---------------------------------------------------------------------*/
 
-static unsigned char FPT_sisyncn(ULONG port, unsigned char p_card, unsigned char syncFlag)
+static unsigned char FPT_sisyncn(unsigned long port, unsigned char p_card, unsigned char syncFlag)
 {
    PSCCB currSCCB;
    PSCCBMgr_tar_info currTar_Info;
@@ -3452,7 +3451,7 @@ static unsigned char FPT_sisyncn(ULONG p
  *              necessary.
  *
  *---------------------------------------------------------------------*/
-static void FPT_stsyncn(ULONG port, unsigned char p_card)
+static void FPT_stsyncn(unsigned long port, unsigned char p_card)
 {
    unsigned char sync_msg,offset,sync_reg,our_sync_msg;
    PSCCB currSCCB;
@@ -3584,7 +3583,7 @@ static void FPT_stsyncn(ULONG port, unsi
  * Description: Answer the targets sync message.
  *
  *---------------------------------------------------------------------*/
-static void FPT_sisyncr(ULONG port,unsigned char sync_pulse, unsigned char offset)
+static void FPT_sisyncr(unsigned long port,unsigned char sync_pulse, unsigned char offset)
 {
    ARAM_ACCESS(port);
    WRW_HARPOON((port+SYNC_MSGS+0), (MPM_OP+AMSG_OUT+SMEXT ));
@@ -3615,7 +3614,7 @@ static void FPT_sisyncr(ULONG port,unsig
  *
  *---------------------------------------------------------------------*/
 
-static unsigned char FPT_siwidn(ULONG port, unsigned char p_card)
+static unsigned char FPT_siwidn(unsigned long port, unsigned char p_card)
 {
    PSCCB currSCCB;
    PSCCBMgr_tar_info currTar_Info;
@@ -3667,7 +3666,7 @@ static unsigned char FPT_siwidn(ULONG po
  *              necessary.
  *
  *---------------------------------------------------------------------*/
-static void FPT_stwidn(ULONG port, unsigned char p_card)
+static void FPT_stwidn(unsigned long port, unsigned char p_card)
 {
    unsigned char width;
    PSCCB currSCCB;
@@ -3747,7 +3746,7 @@ static void FPT_stwidn(ULONG port, unsig
  * Description: Answer the targets Wide nego message.
  *
  *---------------------------------------------------------------------*/
-static void FPT_siwidr(ULONG port, unsigned char width)
+static void FPT_siwidr(unsigned long port, unsigned char width)
 {
    ARAM_ACCESS(port);
    WRW_HARPOON((port+SYNC_MSGS+0), (MPM_OP+AMSG_OUT+SMEXT ));
@@ -3776,7 +3775,7 @@ static void FPT_siwidr(ULONG port, unsig
  *              ID specified.
  *
  *---------------------------------------------------------------------*/
-static void FPT_sssyncv(ULONG p_port, unsigned char p_id, unsigned char p_sync_value,
+static void FPT_sssyncv(unsigned long p_port, unsigned char p_id, unsigned char p_sync_value,
 			PSCCBMgr_tar_info currTar_Info)
 {
    unsigned char index;
@@ -3848,7 +3847,7 @@ static void FPT_sssyncv(ULONG p_port, un
  * Description: Reset the desired card's SCSI bus.
  *
  *---------------------------------------------------------------------*/
-static void FPT_sresb(ULONG port, unsigned char p_card)
+static void FPT_sresb(unsigned long port, unsigned char p_card)
 {
    unsigned char scsiID, i;
 
@@ -3970,7 +3969,7 @@ static void FPT_ssenss(PSCCBcard pCurrCa
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_sxfrp(ULONG p_port, unsigned char p_card)
+static void FPT_sxfrp(unsigned long p_port, unsigned char p_card)
 {
    unsigned char curr_phz;
 
@@ -4052,7 +4051,7 @@ static void FPT_sxfrp(ULONG p_port, unsi
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_schkdd(ULONG port, unsigned char p_card)
+static void FPT_schkdd(unsigned long port, unsigned char p_card)
 {
    unsigned short TimeOutLoop;
 	unsigned char sPhase;
@@ -4245,10 +4244,10 @@ static void FPT_sinits(PSCCB p_sccb, uns
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_phaseDecode(ULONG p_port, unsigned char p_card)
+static void FPT_phaseDecode(unsigned long p_port, unsigned char p_card)
 {
    unsigned char phase_ref;
-   void (*phase) (ULONG, unsigned char);
+   void (*phase) (unsigned long, unsigned char);
 
 
    DISABLE_AUTO(p_port);
@@ -4270,7 +4269,7 @@ static void FPT_phaseDecode(ULONG p_port
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_phaseDataOut(ULONG port, unsigned char p_card)
+static void FPT_phaseDataOut(unsigned long port, unsigned char p_card)
 {
 
    PSCCB currSCCB;
@@ -4314,7 +4313,7 @@ static void FPT_phaseDataOut(ULONG port,
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_phaseDataIn(ULONG port, unsigned char p_card)
+static void FPT_phaseDataIn(unsigned long port, unsigned char p_card)
 {
 
    PSCCB currSCCB;
@@ -4361,10 +4360,10 @@ static void FPT_phaseDataIn(ULONG port, 
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_phaseCommand(ULONG p_port, unsigned char p_card)
+static void FPT_phaseCommand(unsigned long p_port, unsigned char p_card)
 {
    PSCCB currSCCB;
-   ULONG cdb_reg;
+   unsigned long cdb_reg;
    unsigned char i;
 
    currSCCB = FPT_BL_Card[p_card].currentSCCB;
@@ -4413,7 +4412,7 @@ static void FPT_phaseCommand(ULONG p_por
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_phaseStatus(ULONG port, unsigned char p_card)
+static void FPT_phaseStatus(unsigned long port, unsigned char p_card)
 {
    /* Start-up the automation to finish off this command and let the
       isr handle the interrupt for command complete when it comes in.
@@ -4435,7 +4434,7 @@ static void FPT_phaseStatus(ULONG port, 
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_phaseMsgOut(ULONG port, unsigned char p_card)
+static void FPT_phaseMsgOut(unsigned long port, unsigned char p_card)
 {
 	unsigned char message,scsiID;
 	PSCCB currSCCB;
@@ -4583,7 +4582,7 @@ static void FPT_phaseMsgOut(ULONG port, 
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_phaseMsgIn(ULONG port, unsigned char p_card)
+static void FPT_phaseMsgIn(unsigned long port, unsigned char p_card)
 {
 	unsigned char message;
 	PSCCB currSCCB;
@@ -4636,7 +4635,7 @@ static void FPT_phaseMsgIn(ULONG port, u
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_phaseIllegal(ULONG port, unsigned char p_card)
+static void FPT_phaseIllegal(unsigned long port, unsigned char p_card)
 {
    PSCCB currSCCB;
 
@@ -4664,9 +4663,9 @@ static void FPT_phaseIllegal(ULONG port,
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_phaseChkFifo(ULONG port, unsigned char p_card)
+static void FPT_phaseChkFifo(unsigned long port, unsigned char p_card)
 {
-   ULONG xfercnt;
+   unsigned long xfercnt;
    PSCCB currSCCB;
 
    currSCCB = FPT_BL_Card[p_card].currentSCCB;
@@ -4742,7 +4741,7 @@ static void FPT_phaseChkFifo(ULONG port,
  *              because of command complete or from a disconnect.
  *
  *---------------------------------------------------------------------*/
-static void FPT_phaseBusFree(ULONG port, unsigned char p_card)
+static void FPT_phaseBusFree(unsigned long port, unsigned char p_card)
 {
    PSCCB currSCCB;
 
@@ -4840,9 +4839,9 @@ static void FPT_phaseBusFree(ULONG port,
  * Description: Load the Automation RAM with the defualt map values.
  *
  *---------------------------------------------------------------------*/
-static void FPT_autoLoadDefaultMap(ULONG p_port)
+static void FPT_autoLoadDefaultMap(unsigned long p_port)
 {
-   ULONG map_addr;
+   unsigned long map_addr;
 
    ARAM_ACCESS(p_port);
    map_addr = p_port + hp_aramBase;
@@ -4948,7 +4947,7 @@ static void FPT_autoLoadDefaultMap(ULONG
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_autoCmdCmplt(ULONG p_port, unsigned char p_card)
+static void FPT_autoCmdCmplt(unsigned long p_port, unsigned char p_card)
 {
    PSCCB currSCCB;
    unsigned char status_byte;
@@ -5163,7 +5162,7 @@ static void FPT_autoCmdCmplt(ULONG p_por
  *              
  *---------------------------------------------------------------------*/
 
-static void FPT_dataXferProcessor(ULONG port, PSCCBcard pCurrCard)
+static void FPT_dataXferProcessor(unsigned long port, PSCCBcard pCurrCard)
 {
    PSCCB currSCCB;
 
@@ -5201,21 +5200,21 @@ static void FPT_dataXferProcessor(ULONG 
  * Description:
  *
  *---------------------------------------------------------------------*/
-static void FPT_busMstrSGDataXferStart(ULONG p_port, PSCCB pcurrSCCB)
+static void FPT_busMstrSGDataXferStart(unsigned long p_port, PSCCB pcurrSCCB)
 {
-   ULONG count,addr,tmpSGCnt;
+   unsigned long count,addr,tmpSGCnt;
    unsigned int sg_index;
    unsigned char sg_count, i;
-   ULONG reg_offset;
+   unsigned long reg_offset;
 
 
    if (pcurrSCCB->Sccb_XferState & F_HOST_XFER_DIR) {
 
-      count =  ((ULONG) HOST_RD_CMD)<<24;
+      count =  ((unsigned long) HOST_RD_CMD)<<24;
       }
 
    else {
-      count =  ((ULONG) HOST_WRT_CMD)<<24;
+      count =  ((unsigned long) HOST_WRT_CMD)<<24;
       }
 
    sg_count = 0;
@@ -5230,15 +5229,15 @@ static void FPT_busMstrSGDataXferStart(U
 	WR_HARPOON(p_port+hp_page_ctrl, i);
 
    while ((sg_count < (unsigned char)SG_BUF_CNT) &&
-      ((ULONG)(sg_index * (unsigned int)SG_ELEMENT_SIZE) < pcurrSCCB->DataLength) ) {
+      ((unsigned long)(sg_index * (unsigned int)SG_ELEMENT_SIZE) < pcurrSCCB->DataLength) ) {
 
-      tmpSGCnt += *(((ULONG *)pcurrSCCB->DataPointer)+
+      tmpSGCnt += *(((unsigned long *)pcurrSCCB->DataPointer)+
          (sg_index * 2));
 
-      count |= *(((ULONG *)pcurrSCCB->DataPointer)+
+      count |= *(((unsigned long *)pcurrSCCB->DataPointer)+
          (sg_index * 2));
 
-      addr = *(((ULONG *)pcurrSCCB->DataPointer)+
+      addr = *(((unsigned long *)pcurrSCCB->DataPointer)+
          ((sg_index * 2) + 1));
 
 
@@ -5306,15 +5305,15 @@ static void FPT_busMstrSGDataXferStart(U
  * Description: 
  *
  *---------------------------------------------------------------------*/
-static void FPT_busMstrDataXferStart(ULONG p_port, PSCCB pcurrSCCB)
+static void FPT_busMstrDataXferStart(unsigned long p_port, PSCCB pcurrSCCB)
 {
-   ULONG addr,count;
+   unsigned long addr,count;
 
    if (!(pcurrSCCB->Sccb_XferState & F_AUTO_SENSE)) {
 
       count = pcurrSCCB->Sccb_XferCnt;
 
-      addr = (ULONG) pcurrSCCB->DataPointer + pcurrSCCB->Sccb_ATC;
+      addr = (unsigned long) pcurrSCCB->DataPointer + pcurrSCCB->Sccb_ATC;
       }
 
    else {
@@ -5359,9 +5358,9 @@ static void FPT_busMstrDataXferStart(ULO
  *               command busy is also time out, it'll just give up.
  *
  *---------------------------------------------------------------------*/
-static unsigned char FPT_busMstrTimeOut(ULONG p_port)
+static unsigned char FPT_busMstrTimeOut(unsigned long p_port)
 {
-   ULONG timeout;
+   unsigned long timeout;
 
    timeout = LONG_WAIT;
 
@@ -5397,11 +5396,11 @@ static unsigned char FPT_busMstrTimeOut(
  * Description: Abort any in progress transfer.
  *
  *---------------------------------------------------------------------*/
-static void FPT_hostDataXferAbort(ULONG port, unsigned char p_card, PSCCB pCurrSCCB)
+static void FPT_hostDataXferAbort(unsigned long port, unsigned char p_card, PSCCB pCurrSCCB)
 {
 
-   ULONG timeout;
-   ULONG remain_cnt;
+   unsigned long timeout;
+   unsigned long remain_cnt;
    unsigned int sg_ptr;
 
    FPT_BL_Card[p_card].globalFlags &= ~F_HOST_XFER_ACT;
@@ -5464,10 +5463,10 @@ static void FPT_hostDataXferAbort(ULONG 
 
             sg_ptr--;
 
-            if (remain_cnt > (ULONG)(*(((ULONG *)pCurrSCCB->
+            if (remain_cnt > (unsigned long)(*(((unsigned long *)pCurrSCCB->
                DataPointer) + (sg_ptr * 2)))) {
 
-               remain_cnt -= (ULONG)(*(((ULONG *)pCurrSCCB->
+               remain_cnt -= (unsigned long)(*(((unsigned long *)pCurrSCCB->
                   DataPointer) + (sg_ptr * 2)));
                }
 
@@ -5487,7 +5486,7 @@ static void FPT_hostDataXferAbort(ULONG 
             pCurrSCCB->Sccb_sgseg = (unsigned short)sg_ptr;
 
 
-            if ((ULONG)(sg_ptr * SG_ELEMENT_SIZE) == pCurrSCCB->DataLength 
+            if ((unsigned long)(sg_ptr * SG_ELEMENT_SIZE) == pCurrSCCB->DataLength
                 && (remain_cnt == 0))
 
                pCurrSCCB->Sccb_XferState |= F_ALL_XFERRED;
@@ -5624,7 +5623,7 @@ static void FPT_hostDataXferAbort(ULONG 
          pCurrSCCB->Sccb_SGoffset = 0x00; 
 
 
-         if ((ULONG)(pCurrSCCB->Sccb_sgseg * SG_ELEMENT_SIZE) >=
+         if ((unsigned long)(pCurrSCCB->Sccb_sgseg * SG_ELEMENT_SIZE) >=
             pCurrSCCB->DataLength) {
 
             pCurrSCCB->Sccb_XferState |= F_ALL_XFERRED;
@@ -5657,9 +5656,9 @@ static void FPT_hostDataXferAbort(ULONG 
  *---------------------------------------------------------------------*/
 static void FPT_hostDataXferRestart(PSCCB currSCCB)
 {
-   ULONG data_count;
+   unsigned long data_count;
    unsigned int  sg_index;
-   ULONG *sg_ptr;
+   unsigned long *sg_ptr;
 
    if (currSCCB->Sccb_XferState & F_SG_XFER) {
 
@@ -5668,7 +5667,7 @@ static void FPT_hostDataXferRestart(PSCC
       sg_index = 0xffff;         /*Index by long words into sg list. */
       data_count = 0;            /*Running count of SG xfer counts. */
 
-      sg_ptr = (ULONG *)currSCCB->DataPointer;
+      sg_ptr = (unsigned long *)currSCCB->DataPointer;
 
       while (data_count < currSCCB->Sccb_ATC) {
 
@@ -5708,7 +5707,7 @@ static void FPT_scini(unsigned char p_ca
 {
 
    unsigned char loser,assigned_id;
-   ULONG p_port;
+   unsigned long p_port;
 
    unsigned char i,k,ScamFlg ;
    PSCCBcard currCard;
@@ -5900,7 +5899,7 @@ static void FPT_scini(unsigned char p_ca
  *
  *---------------------------------------------------------------------*/
 
-static int FPT_scarb(ULONG p_port, unsigned char p_sel_type)
+static int FPT_scarb(unsigned long p_port, unsigned char p_sel_type)
 {
    if (p_sel_type == INIT_SELTD)
       {
@@ -5961,7 +5960,7 @@ static int FPT_scarb(ULONG p_port, unsig
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_scbusf(ULONG p_port)
+static void FPT_scbusf(unsigned long p_port)
 {
    WR_HARPOON(p_port+hp_page_ctrl,
       (RD_HARPOON(p_port+hp_page_ctrl) | G_INT_DISABLE));
@@ -5997,7 +5996,7 @@ static void FPT_scbusf(ULONG p_port)
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_scasid(unsigned char p_card, ULONG p_port)
+static void FPT_scasid(unsigned char p_card, unsigned long p_port)
 {
    unsigned char temp_id_string[ID_STRING_LENGTH];
 
@@ -6085,7 +6084,7 @@ static void FPT_scasid(unsigned char p_c
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_scsel(ULONG p_port)
+static void FPT_scsel(unsigned long p_port)
 {
 
    WR_HARPOON(p_port+hp_scsisig, SCSI_SEL);
@@ -6119,7 +6118,7 @@ static void FPT_scsel(ULONG p_port)
  *
  *---------------------------------------------------------------------*/
 
-static unsigned char FPT_scxferc(ULONG p_port, unsigned char p_data)
+static unsigned char FPT_scxferc(unsigned long p_port, unsigned char p_data)
 {
    unsigned char curr_data, ret_data;
 
@@ -6170,7 +6169,7 @@ static unsigned char FPT_scxferc(ULONG p
  *
  *---------------------------------------------------------------------*/
 
-static unsigned char FPT_scsendi(ULONG p_port, unsigned char p_id_string[])
+static unsigned char FPT_scsendi(unsigned long p_port, unsigned char p_id_string[])
 {
    unsigned char ret_data,byte_cnt,bit_cnt,defer;
 
@@ -6223,7 +6222,7 @@ static unsigned char FPT_scsendi(ULONG p
  *
  *---------------------------------------------------------------------*/
 
-static unsigned char FPT_sciso(ULONG p_port, unsigned char p_id_string[])
+static unsigned char FPT_sciso(unsigned long p_port, unsigned char p_id_string[])
 {
    unsigned char ret_data,the_data,byte_cnt,bit_cnt;
 
@@ -6284,7 +6283,7 @@ static unsigned char FPT_sciso(ULONG p_p
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_scwirod(ULONG p_port, unsigned char p_data_bit)
+static void FPT_scwirod(unsigned long p_port, unsigned char p_data_bit)
 {
    unsigned char i;
 
@@ -6313,7 +6312,7 @@ static void FPT_scwirod(ULONG p_port, un
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_scwiros(ULONG p_port, unsigned char p_data_bit)
+static void FPT_scwiros(unsigned long p_port, unsigned char p_data_bit)
 {
    unsigned char i;
 
@@ -6367,9 +6366,9 @@ static unsigned char FPT_scvalq(unsigned
  *
  *---------------------------------------------------------------------*/
 
-static unsigned char FPT_scsell(ULONG p_port, unsigned char targ_id)
+static unsigned char FPT_scsell(unsigned long p_port, unsigned char targ_id)
 {
-   ULONG i;
+   unsigned long i;
 
    WR_HARPOON(p_port+hp_page_ctrl,
       (RD_HARPOON(p_port+hp_page_ctrl) | G_INT_DISABLE));
@@ -6446,7 +6445,7 @@ static unsigned char FPT_scsell(ULONG p_
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_scwtsel(ULONG p_port)
+static void FPT_scwtsel(unsigned long p_port)
 {
    while(!(RDW_HARPOON((p_port+hp_intstat)) & SCAM_SEL)) {}
 }
@@ -6460,7 +6459,7 @@ static void FPT_scwtsel(ULONG p_port)
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_inisci(unsigned char p_card, ULONG p_port, unsigned char p_our_id)
+static void FPT_inisci(unsigned char p_card, unsigned long p_port, unsigned char p_our_id)
 {
    unsigned char i,k,max_id;
    unsigned short ee_data;
@@ -6653,7 +6652,7 @@ static unsigned char FPT_scmachid(unsign
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_scsavdi(unsigned char p_card, ULONG p_port)
+static void FPT_scsavdi(unsigned char p_card, unsigned long p_port)
 {
    unsigned char i,k,max_id;
    unsigned short ee_data,sum_data;
@@ -6702,7 +6701,7 @@ static void FPT_scsavdi(unsigned char p_
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_XbowInit(ULONG port, unsigned char ScamFlg)
+static void FPT_XbowInit(unsigned long port, unsigned char ScamFlg)
 {
 unsigned char i;
 
@@ -6752,7 +6751,7 @@ unsigned char i;
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_BusMasterInit(ULONG p_port)
+static void FPT_BusMasterInit(unsigned long p_port)
 {
 
 
@@ -6783,7 +6782,7 @@ static void FPT_BusMasterInit(ULONG p_po
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_DiagEEPROM(ULONG p_port)
+static void FPT_DiagEEPROM(unsigned long p_port)
 {
    unsigned short index,temp,max_wd_cnt;
 
@@ -7416,9 +7415,9 @@ static unsigned char FPT_queueFindSccb(P
 
 static void  FPT_utilUpdateResidual(PSCCB p_SCCB)
 {
-   ULONG partial_cnt;
+   unsigned long partial_cnt;
    unsigned int  sg_index;
-   ULONG *sg_ptr;
+   unsigned long *sg_ptr;
 
    if (p_SCCB->Sccb_XferState & F_ALL_XFERRED) {
 
@@ -7431,7 +7430,7 @@ static void  FPT_utilUpdateResidual(PSCC
 
 		 sg_index = p_SCCB->Sccb_sgseg;
 
-		 sg_ptr = (ULONG *)p_SCCB->DataPointer;
+		 sg_ptr = (unsigned long *)p_SCCB->DataPointer;
 
 		 if (p_SCCB->Sccb_SGoffset) {
 
@@ -7439,7 +7438,7 @@ static void  FPT_utilUpdateResidual(PSCC
 			sg_index++;
 			}
 
-		 while ( ((ULONG)sg_index * (ULONG)SG_ELEMENT_SIZE) <
+		 while ( ((unsigned long)sg_index * (unsigned long)SG_ELEMENT_SIZE) <
 			p_SCCB->DataLength ) {
 
 			partial_cnt += *(sg_ptr+(sg_index * 2));
@@ -7464,7 +7463,7 @@ static void  FPT_utilUpdateResidual(PSCC
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_Wait1Second(ULONG p_port)
+static void FPT_Wait1Second(unsigned long p_port)
 {
    unsigned char i;
 
@@ -7489,7 +7488,7 @@ static void FPT_Wait1Second(ULONG p_port
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_Wait(ULONG p_port, unsigned char p_delay)
+static void FPT_Wait(unsigned long p_port, unsigned char p_delay)
 {
    unsigned char old_timer;
    unsigned char green_flag;
@@ -7537,7 +7536,7 @@ static void FPT_Wait(ULONG p_port, unsig
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_utilEEWriteOnOff(ULONG p_port,unsigned char p_mode)
+static void FPT_utilEEWriteOnOff(unsigned long p_port,unsigned char p_mode)
 {
    unsigned char ee_value;
 
@@ -7566,7 +7565,7 @@ static void FPT_utilEEWriteOnOff(ULONG p
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_utilEEWrite(ULONG p_port, unsigned short ee_data, unsigned short ee_addr)
+static void FPT_utilEEWrite(unsigned long p_port, unsigned short ee_data, unsigned short ee_addr)
 {
 
    unsigned char ee_value;
@@ -7617,7 +7616,7 @@ static void FPT_utilEEWrite(ULONG p_port
  *
  *---------------------------------------------------------------------*/
 
-static unsigned short FPT_utilEERead(ULONG p_port, unsigned short ee_addr)
+static unsigned short FPT_utilEERead(unsigned long p_port, unsigned short ee_addr)
 {
    unsigned short i, ee_data1, ee_data2;
 
@@ -7647,7 +7646,7 @@ static unsigned short FPT_utilEERead(ULO
  *
  *---------------------------------------------------------------------*/
 
-static unsigned short FPT_utilEEReadOrg(ULONG p_port, unsigned short ee_addr)
+static unsigned short FPT_utilEEReadOrg(unsigned long p_port, unsigned short ee_addr)
 {
 
    unsigned char ee_value;
@@ -7695,7 +7694,7 @@ static unsigned short FPT_utilEEReadOrg(
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_utilEESendCmdAddr(ULONG p_port, unsigned char ee_cmd, unsigned short ee_addr)
+static void FPT_utilEESendCmdAddr(unsigned long p_port, unsigned char ee_cmd, unsigned short ee_addr)
 {
    unsigned char ee_value;
    unsigned char narrow_flg;
_
