From: akpm@osdl.org
Subject: [patch 08/28] drivers/scsi/FlashPoint.c: remove UCHAR
Date: Wed, 08 Mar 2006 00:14:24 -0800
Message-ID: <200603080816.k288GDWu002172@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:31660 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932485AbWCHIQZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2006 03:16:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, adobriyan@gmail.com


From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/FlashPoint.c |  675 +++++++++++++++++-------------------
 1 files changed, 337 insertions(+), 338 deletions(-)

diff -puN drivers/scsi/FlashPoint.c~drivers-scsi-flashpointc-remove-uchar drivers/scsi/FlashPoint.c
--- 25/drivers/scsi/FlashPoint.c~drivers-scsi-flashpointc-remove-uchar	Mon Feb  6 14:49:58 2006
+++ 25-akpm/drivers/scsi/FlashPoint.c	Mon Feb  6 14:49:58 2006
@@ -40,7 +40,6 @@
 #define FAILURE         0xFFFFFFFFL
 
 
-typedef unsigned char   UCHAR;
 typedef unsigned short  USHORT;
 typedef unsigned int    UINT;
 typedef unsigned long   ULONG;
@@ -59,7 +58,7 @@ typedef unsigned short          * ushort
 
 
 
-#define BIT(x)          ((UCHAR)(1<<(x)))    /* single-bit mask in bit position x */
+#define BIT(x)          ((unsigned char)(1<<(x)))    /* single-bit mask in bit position x */
 #define BITW(x)          ((USHORT)(1<<(x)))  /* single-bit mask in bit position x */
 
 
@@ -71,10 +70,10 @@ typedef void (*CALL_BK_FN)(PSCCB);
 
 typedef struct SCCBMgr_info {
    ULONG    si_baseaddr;
-   UCHAR    si_present;
-   UCHAR    si_intvect;
-   UCHAR    si_id;
-   UCHAR    si_lun;
+   unsigned char    si_present;
+   unsigned char    si_intvect;
+   unsigned char    si_id;
+   unsigned char    si_lun;
    USHORT   si_fw_revision;
    USHORT   si_per_targ_init_sync;
    USHORT   si_per_targ_fast_nego;
@@ -82,13 +81,13 @@ typedef struct SCCBMgr_info {
    USHORT   si_per_targ_no_disc;
    USHORT   si_per_targ_wide_nego;
    USHORT   si_flags;
-   UCHAR    si_card_family;
-   UCHAR    si_bustype;
-   UCHAR    si_card_model[3];
-   UCHAR    si_relative_cardnum;
-   UCHAR    si_reserved[4];
+   unsigned char    si_card_family;
+   unsigned char    si_bustype;
+   unsigned char    si_card_model[3];
+   unsigned char    si_relative_cardnum;
+   unsigned char    si_reserved[4];
    ULONG    si_OS_reserved;
-   UCHAR    si_XlatInfo[4];
+   unsigned char    si_XlatInfo[4];
    ULONG    si_reserved2[5];
    ULONG    si_secondary_range;
 } SCCBMGR_INFO;
@@ -122,28 +121,28 @@ typedef SCCBMGR_INFO *      PSCCBMGR_INF
 
 #pragma pack(1)
 typedef struct _SCCB {
-   UCHAR OperationCode;
-   UCHAR ControlByte;
-   UCHAR CdbLength;
-   UCHAR RequestSenseLength;
+   unsigned char OperationCode;
+   unsigned char ControlByte;
+   unsigned char CdbLength;
+   unsigned char RequestSenseLength;
    ULONG DataLength;
    ULONG DataPointer;
-   UCHAR CcbRes[2];
-   UCHAR HostStatus;
-   UCHAR TargetStatus;
-   UCHAR TargID;
-   UCHAR Lun;
-   UCHAR Cdb[12];
-   UCHAR CcbRes1;
-   UCHAR Reserved1;
+   unsigned char CcbRes[2];
+   unsigned char HostStatus;
+   unsigned char TargetStatus;
+   unsigned char TargID;
+   unsigned char Lun;
+   unsigned char Cdb[12];
+   unsigned char CcbRes1;
+   unsigned char Reserved1;
    ULONG Reserved2;
    ULONG SensePointer;
 
 
    CALL_BK_FN SccbCallback;                  /* VOID (*SccbCallback)(); */
    ULONG  SccbIOPort;                        /* Identifies board base port */
-   UCHAR  SccbStatus;
-   UCHAR  SCCBRes2;
+   unsigned char  SccbStatus;
+   unsigned char  SCCBRes2;
    USHORT SccbOSFlags;
 
 
@@ -153,16 +152,16 @@ typedef struct _SCCB {
    ULONG   Sccb_res1;
    USHORT  Sccb_MGRFlags;
    USHORT  Sccb_sgseg;
-   UCHAR   Sccb_scsimsg;            /* identify msg for selection */
-   UCHAR   Sccb_tag;
-   UCHAR   Sccb_scsistat;
-   UCHAR   Sccb_idmsg;              /* image of last msg in */
+   unsigned char   Sccb_scsimsg;            /* identify msg for selection */
+   unsigned char   Sccb_tag;
+   unsigned char   Sccb_scsistat;
+   unsigned char   Sccb_idmsg;              /* image of last msg in */
    PSCCB   Sccb_forwardlink;
    PSCCB   Sccb_backlink;
    ULONG   Sccb_savedATC;
-   UCHAR   Save_Cdb[6];
-   UCHAR   Save_CdbLen;
-   UCHAR   Sccb_XferState;
+   unsigned char   Save_Cdb[6];
+   unsigned char   Save_CdbLen;
+   unsigned char   Sccb_XferState;
    ULONG   Sccb_SGoffset;
    } SCCB;
 
@@ -288,27 +287,27 @@ typedef struct SCCBMgr_tar_info {
 
    PSCCB    TarSelQ_Head;
    PSCCB    TarSelQ_Tail;
-   UCHAR    TarLUN_CA;        /*Contingent Allgiance */
-   UCHAR    TarTagQ_Cnt;
-   UCHAR    TarSelQ_Cnt;
-   UCHAR    TarStatus;
-   UCHAR    TarEEValue;
-   UCHAR 	TarSyncCtrl;
-   UCHAR 	TarReserved[2];			/* for alignment */ 
-   UCHAR 	LunDiscQ_Idx[MAX_LUN];
-   UCHAR    TarLUNBusy[MAX_LUN];
+   unsigned char    TarLUN_CA;        /*Contingent Allgiance */
+   unsigned char    TarTagQ_Cnt;
+   unsigned char    TarSelQ_Cnt;
+   unsigned char    TarStatus;
+   unsigned char    TarEEValue;
+   unsigned char 	TarSyncCtrl;
+   unsigned char 	TarReserved[2];			/* for alignment */
+   unsigned char 	LunDiscQ_Idx[MAX_LUN];
+   unsigned char    TarLUNBusy[MAX_LUN];
 } SCCBMGR_TAR_INFO;
 
 typedef struct NVRAMInfo {
-	UCHAR		niModel;								/* Model No. of card */
-	UCHAR		niCardNo;							/* Card no. */
+	unsigned char		niModel;								/* Model No. of card */
+	unsigned char		niCardNo;							/* Card no. */
 	ULONG		niBaseAddr;							/* Port Address of card */
-	UCHAR		niSysConf;							/* Adapter Configuration byte - Byte 16 of eeprom map */
-	UCHAR		niScsiConf;							/* SCSI Configuration byte - Byte 17 of eeprom map */
-	UCHAR		niScamConf;							/* SCAM Configuration byte - Byte 20 of eeprom map */
-	UCHAR		niAdapId;							/* Host Adapter ID - Byte 24 of eerpom map */
-	UCHAR		niSyncTbl[MAX_SCSI_TAR / 2];	/* Sync/Wide byte of targets */
-	UCHAR		niScamTbl[MAX_SCSI_TAR][4];	/* Compressed Scam name string of Targets */
+	unsigned char		niSysConf;							/* Adapter Configuration byte - Byte 16 of eeprom map */
+	unsigned char		niScsiConf;							/* SCSI Configuration byte - Byte 17 of eeprom map */
+	unsigned char		niScamConf;							/* SCAM Configuration byte - Byte 20 of eeprom map */
+	unsigned char		niAdapId;							/* Host Adapter ID - Byte 24 of eerpom map */
+	unsigned char		niSyncTbl[MAX_SCSI_TAR / 2];	/* Sync/Wide byte of targets */
+	unsigned char		niScamTbl[MAX_SCSI_TAR][4];	/* Compressed Scam name string of Targets */
 }NVRAMINFO;
 
 typedef NVRAMINFO *PNVRamInfo;
@@ -326,12 +325,12 @@ typedef struct SCCBcard {
    ULONG ioPort;
 
    USHORT cmdCounter;
-   UCHAR  discQCount;
-   UCHAR  tagQ_Lst; 
-   UCHAR cardIndex;
-   UCHAR scanIndex;
-   UCHAR globalFlags;
-   UCHAR ourId;
+   unsigned char  discQCount;
+   unsigned char  tagQ_Lst;
+   unsigned char cardIndex;
+   unsigned char scanIndex;
+   unsigned char globalFlags;
+   unsigned char ourId;
    PNVRamInfo pNvRamInfo;
    PSCCB discQ_Tbl[QUEUE_DEPTH]; 
       
@@ -379,7 +378,7 @@ enum scam_id_st { ID0,ID1,ID2,ID3,ID4,ID
 
 typedef struct SCCBscam_info {
 
-   UCHAR    id_string[ID_STRING_LENGTH];
+   unsigned char    id_string[ID_STRING_LENGTH];
    enum scam_id_st state;
     
 } SCCBSCAM_INFO;
@@ -981,72 +980,72 @@ typedef struct SCCBscam_info {
 
 
 
-static UCHAR FPT_sisyncn(ULONG port, UCHAR p_card, UCHAR syncFlag);
-static void  FPT_ssel(ULONG port, UCHAR p_card);
-static void  FPT_sres(ULONG port, UCHAR p_card, PSCCBcard pCurrCard);
-static void  FPT_shandem(ULONG port, UCHAR p_card,PSCCB pCurrSCCB);
-static void  FPT_stsyncn(ULONG port, UCHAR p_card);
-static void  FPT_sisyncr(ULONG port,UCHAR sync_pulse, UCHAR offset);
-static void  FPT_sssyncv(ULONG p_port, UCHAR p_id, UCHAR p_sync_value,
+static unsigned char FPT_sisyncn(ULONG port, unsigned char p_card, unsigned char syncFlag);
+static void  FPT_ssel(ULONG port, unsigned char p_card);
+static void  FPT_sres(ULONG port, unsigned char p_card, PSCCBcard pCurrCard);
+static void  FPT_shandem(ULONG port, unsigned char p_card,PSCCB pCurrSCCB);
+static void  FPT_stsyncn(ULONG port, unsigned char p_card);
+static void  FPT_sisyncr(ULONG port,unsigned char sync_pulse, unsigned char offset);
+static void  FPT_sssyncv(ULONG p_port, unsigned char p_id, unsigned char p_sync_value,
 			 PSCCBMgr_tar_info currTar_Info);
-static void  FPT_sresb(ULONG port, UCHAR p_card);
-static void  FPT_sxfrp(ULONG p_port, UCHAR p_card);
-static void  FPT_schkdd(ULONG port, UCHAR p_card);
-static UCHAR FPT_RdStack(ULONG port, UCHAR index);
-static void  FPT_WrStack(ULONG portBase, UCHAR index, UCHAR data);
-static UCHAR FPT_ChkIfChipInitialized(ULONG ioPort);
-
-static void FPT_SendMsg(ULONG port, UCHAR message);
-static void  FPT_queueFlushTargSccb(UCHAR p_card, UCHAR thisTarg,
-				    UCHAR error_code);
+static void  FPT_sresb(ULONG port, unsigned char p_card);
+static void  FPT_sxfrp(ULONG p_port, unsigned char p_card);
+static void  FPT_schkdd(ULONG port, unsigned char p_card);
+static unsigned char FPT_RdStack(ULONG port, unsigned char index);
+static void  FPT_WrStack(ULONG portBase, unsigned char index, unsigned char data);
+static unsigned char FPT_ChkIfChipInitialized(ULONG ioPort);
+
+static void FPT_SendMsg(ULONG port, unsigned char message);
+static void  FPT_queueFlushTargSccb(unsigned char p_card, unsigned char thisTarg,
+				    unsigned char error_code);
 
-static void  FPT_sinits(PSCCB p_sccb, UCHAR p_card);
+static void  FPT_sinits(PSCCB p_sccb, unsigned char p_card);
 static void  FPT_RNVRamData(PNVRamInfo pNvRamInfo);
 
-static UCHAR FPT_siwidn(ULONG port, UCHAR p_card);
-static void  FPT_stwidn(ULONG port, UCHAR p_card);
-static void  FPT_siwidr(ULONG port, UCHAR width);
+static unsigned char FPT_siwidn(ULONG port, unsigned char p_card);
+static void  FPT_stwidn(ULONG port, unsigned char p_card);
+static void  FPT_siwidr(ULONG port, unsigned char width);
 
 
-static void  FPT_queueSelectFail(PSCCBcard pCurrCard, UCHAR p_card);
-static void  FPT_queueDisconnect(PSCCB p_SCCB, UCHAR p_card);
+static void  FPT_queueSelectFail(PSCCBcard pCurrCard, unsigned char p_card);
+static void  FPT_queueDisconnect(PSCCB p_SCCB, unsigned char p_card);
 static void  FPT_queueCmdComplete(PSCCBcard pCurrCard, PSCCB p_SCCB,
-				  UCHAR p_card);
-static void  FPT_queueSearchSelect(PSCCBcard pCurrCard, UCHAR p_card);
-static void  FPT_queueFlushSccb(UCHAR p_card, UCHAR error_code);
-static void  FPT_queueAddSccb(PSCCB p_SCCB, UCHAR card);
-static UCHAR FPT_queueFindSccb(PSCCB p_SCCB, UCHAR p_card);
+				  unsigned char p_card);
+static void  FPT_queueSearchSelect(PSCCBcard pCurrCard, unsigned char p_card);
+static void  FPT_queueFlushSccb(unsigned char p_card, unsigned char error_code);
+static void  FPT_queueAddSccb(PSCCB p_SCCB, unsigned char card);
+static unsigned char FPT_queueFindSccb(PSCCB p_SCCB, unsigned char p_card);
 static void  FPT_utilUpdateResidual(PSCCB p_SCCB);
-static USHORT FPT_CalcCrc16(UCHAR buffer[]);
-static UCHAR  FPT_CalcLrc(UCHAR buffer[]);
+static USHORT FPT_CalcCrc16(unsigned char buffer[]);
+static unsigned char  FPT_CalcLrc(unsigned char buffer[]);
 
 
 static void  FPT_Wait1Second(ULONG p_port);
-static void  FPT_Wait(ULONG p_port, UCHAR p_delay);
-static void  FPT_utilEEWriteOnOff(ULONG p_port,UCHAR p_mode);
+static void  FPT_Wait(ULONG p_port, unsigned char p_delay);
+static void  FPT_utilEEWriteOnOff(ULONG p_port,unsigned char p_mode);
 static void  FPT_utilEEWrite(ULONG p_port, USHORT ee_data, USHORT ee_addr);
 static USHORT FPT_utilEERead(ULONG p_port, USHORT ee_addr);
 static USHORT FPT_utilEEReadOrg(ULONG p_port, USHORT ee_addr);
-static void  FPT_utilEESendCmdAddr(ULONG p_port, UCHAR ee_cmd, USHORT ee_addr);
+static void  FPT_utilEESendCmdAddr(ULONG p_port, unsigned char ee_cmd, USHORT ee_addr);
 
 
 
-static void  FPT_phaseDataOut(ULONG port, UCHAR p_card);
-static void  FPT_phaseDataIn(ULONG port, UCHAR p_card);
-static void  FPT_phaseCommand(ULONG port, UCHAR p_card);
-static void  FPT_phaseStatus(ULONG port, UCHAR p_card);
-static void  FPT_phaseMsgOut(ULONG port, UCHAR p_card);
-static void  FPT_phaseMsgIn(ULONG port, UCHAR p_card);
-static void  FPT_phaseIllegal(ULONG port, UCHAR p_card);
+static void  FPT_phaseDataOut(ULONG port, unsigned char p_card);
+static void  FPT_phaseDataIn(ULONG port, unsigned char p_card);
+static void  FPT_phaseCommand(ULONG port, unsigned char p_card);
+static void  FPT_phaseStatus(ULONG port, unsigned char p_card);
+static void  FPT_phaseMsgOut(ULONG port, unsigned char p_card);
+static void  FPT_phaseMsgIn(ULONG port, unsigned char p_card);
+static void  FPT_phaseIllegal(ULONG port, unsigned char p_card);
 
-static void  FPT_phaseDecode(ULONG port, UCHAR p_card);
-static void  FPT_phaseChkFifo(ULONG port, UCHAR p_card);
-static void  FPT_phaseBusFree(ULONG p_port, UCHAR p_card);
+static void  FPT_phaseDecode(ULONG port, unsigned char p_card);
+static void  FPT_phaseChkFifo(ULONG port, unsigned char p_card);
+static void  FPT_phaseBusFree(ULONG p_port, unsigned char p_card);
 
 
 
 
-static void  FPT_XbowInit(ULONG port, UCHAR scamFlg);
+static void  FPT_XbowInit(ULONG port, unsigned char scamFlg);
 static void  FPT_BusMasterInit(ULONG p_port);
 static void  FPT_DiagEEPROM(ULONG p_port);
 
@@ -1056,39 +1055,39 @@ static void  FPT_DiagEEPROM(ULONG p_port
 static void  FPT_dataXferProcessor(ULONG port, PSCCBcard pCurrCard);
 static void  FPT_busMstrSGDataXferStart(ULONG port, PSCCB pCurrSCCB);
 static void  FPT_busMstrDataXferStart(ULONG port, PSCCB pCurrSCCB);
-static void  FPT_hostDataXferAbort(ULONG port, UCHAR p_card, PSCCB pCurrSCCB);
+static void  FPT_hostDataXferAbort(ULONG port, unsigned char p_card, PSCCB pCurrSCCB);
 static void  FPT_hostDataXferRestart(PSCCB currSCCB);
 
 
-static UCHAR FPT_SccbMgr_bad_isr(ULONG p_port, UCHAR p_card,
+static unsigned char FPT_SccbMgr_bad_isr(ULONG p_port, unsigned char p_card,
 				 PSCCBcard pCurrCard, USHORT p_int);
 
 static void  FPT_SccbMgrTableInitAll(void);
-static void  FPT_SccbMgrTableInitCard(PSCCBcard pCurrCard, UCHAR p_card);
-static void  FPT_SccbMgrTableInitTarget(UCHAR p_card, UCHAR target);
+static void  FPT_SccbMgrTableInitCard(PSCCBcard pCurrCard, unsigned char p_card);
+static void  FPT_SccbMgrTableInitTarget(unsigned char p_card, unsigned char target);
 
 
 
-static void  FPT_scini(UCHAR p_card, UCHAR p_our_id, UCHAR p_power_up);
+static void  FPT_scini(unsigned char p_card, unsigned char p_our_id, unsigned char p_power_up);
 
-static int   FPT_scarb(ULONG p_port, UCHAR p_sel_type);
+static int   FPT_scarb(ULONG p_port, unsigned char p_sel_type);
 static void  FPT_scbusf(ULONG p_port);
 static void  FPT_scsel(ULONG p_port);
-static void  FPT_scasid(UCHAR p_card, ULONG p_port);
-static UCHAR FPT_scxferc(ULONG p_port, UCHAR p_data);
-static UCHAR FPT_scsendi(ULONG p_port, UCHAR p_id_string[]);
-static UCHAR FPT_sciso(ULONG p_port, UCHAR p_id_string[]);
-static void  FPT_scwirod(ULONG p_port, UCHAR p_data_bit);
-static void  FPT_scwiros(ULONG p_port, UCHAR p_data_bit);
-static UCHAR FPT_scvalq(UCHAR p_quintet);
-static UCHAR FPT_scsell(ULONG p_port, UCHAR targ_id);
+static void  FPT_scasid(unsigned char p_card, ULONG p_port);
+static unsigned char FPT_scxferc(ULONG p_port, unsigned char p_data);
+static unsigned char FPT_scsendi(ULONG p_port, unsigned char p_id_string[]);
+static unsigned char FPT_sciso(ULONG p_port, unsigned char p_id_string[]);
+static void  FPT_scwirod(ULONG p_port, unsigned char p_data_bit);
+static void  FPT_scwiros(ULONG p_port, unsigned char p_data_bit);
+static unsigned char FPT_scvalq(unsigned char p_quintet);
+static unsigned char FPT_scsell(ULONG p_port, unsigned char targ_id);
 static void  FPT_scwtsel(ULONG p_port);
-static void  FPT_inisci(UCHAR p_card, ULONG p_port, UCHAR p_our_id);
-static void  FPT_scsavdi(UCHAR p_card, ULONG p_port);
-static UCHAR FPT_scmachid(UCHAR p_card, UCHAR p_id_string[]);
+static void  FPT_inisci(unsigned char p_card, ULONG p_port, unsigned char p_our_id);
+static void  FPT_scsavdi(unsigned char p_card, ULONG p_port);
+static unsigned char FPT_scmachid(unsigned char p_card, unsigned char p_id_string[]);
 
 
-static void  FPT_autoCmdCmplt(ULONG p_port, UCHAR p_card);
+static void  FPT_autoCmdCmplt(ULONG p_port, unsigned char p_card);
 static void  FPT_autoLoadDefaultMap(ULONG p_port);
 
 
@@ -1100,8 +1099,8 @@ static SCCBSCAM_INFO FPT_scamInfo[MAX_SC
 static NVRAMINFO FPT_nvRamInfo[MAX_MB_CARDS] = { { 0 } };
 
 
-static UCHAR FPT_mbCards = 0;
-static UCHAR FPT_scamHAString[] = {0x63, 0x07, 'B', 'U', 'S', 'L', 'O', 'G', 'I', 'C', \
+static unsigned char FPT_mbCards = 0;
+static unsigned char FPT_scamHAString[] = {0x63, 0x07, 'B', 'U', 'S', 'L', 'O', 'G', 'I', 'C', \
 				   ' ', 'B', 'T', '-', '9', '3', '0', \
 				   0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, \
 				   0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20};
@@ -1109,7 +1108,7 @@ static UCHAR FPT_scamHAString[] = {0x63,
 static USHORT FPT_default_intena = 0;
 
 
-static void (*FPT_s_PhaseTbl[8]) (ULONG, UCHAR)= { 0 };
+static void (*FPT_s_PhaseTbl[8]) (ULONG, unsigned char)= { 0 };
 
 
 /*---------------------------------------------------------------------
@@ -1122,9 +1121,9 @@ static void (*FPT_s_PhaseTbl[8]) (ULONG,
 
 static int FlashPoint_ProbeHostAdapter(PSCCBMGR_INFO pCardInfo)
 {
-   static UCHAR first_time = 1;
+   static unsigned char first_time = 1;
 
-   UCHAR i,j,id,ScamFlg;
+   unsigned char i,j,id,ScamFlg;
    USHORT temp,temp2,temp3,temp4,temp5,temp6;
    ULONG ioport;
 	PNVRamInfo pCurrNvRam;
@@ -1190,8 +1189,8 @@ static int FlashPoint_ProbeHostAdapter(P
 	if(pCurrNvRam)
 		pCardInfo->si_id = pCurrNvRam->niAdapId;
 	else
-	   pCardInfo->si_id = (UCHAR)(FPT_utilEERead(ioport, (ADAPTER_SCSI_ID/2)) &
-   	   (UCHAR)0x0FF);
+	   pCardInfo->si_id = (unsigned char)(FPT_utilEERead(ioport, (ADAPTER_SCSI_ID/2)) &
+   	   (unsigned char)0x0FF);
 
    pCardInfo->si_lun = 0x00;
    pCardInfo->si_fw_revision = ORION_FW_REV;
@@ -1247,12 +1246,12 @@ static int FlashPoint_ProbeHostAdapter(P
 	if(pCurrNvRam)
 		i = pCurrNvRam->niSysConf;
 	else
-	   i = (UCHAR)(FPT_utilEERead(ioport, (SYSTEM_CONFIG/2)));
+	   i = (unsigned char)(FPT_utilEERead(ioport, (SYSTEM_CONFIG/2)));
 
 	if(pCurrNvRam)
 		ScamFlg = pCurrNvRam->niScamConf;
 	else
-	   ScamFlg = (UCHAR) FPT_utilEERead(ioport, SCAM_CONFIG/2);
+	   ScamFlg = (unsigned char) FPT_utilEERead(ioport, SCAM_CONFIG/2);
 
    pCardInfo->si_flags = 0x0000;
 
@@ -1312,11 +1311,11 @@ static int FlashPoint_ProbeHostAdapter(P
 		}
 	}else{
 	   temp = FPT_utilEERead(ioport, (MODEL_NUMB_0/2));
-   	pCardInfo->si_card_model[0] = (UCHAR)(temp >> 8);
+   	pCardInfo->si_card_model[0] = (unsigned char)(temp >> 8);
 	   temp = FPT_utilEERead(ioport, (MODEL_NUMB_2/2));
 
-   	pCardInfo->si_card_model[1] = (UCHAR)(temp & 0x00FF);
-	   pCardInfo->si_card_model[2] = (UCHAR)(temp >> 8);
+   	pCardInfo->si_card_model[1] = (unsigned char)(temp & 0x00FF);
+	   pCardInfo->si_card_model[2] = (unsigned char)(temp >> 8);
 	}
 
    if (pCardInfo->si_card_model[1] == '3')
@@ -1371,7 +1370,7 @@ static int FlashPoint_ProbeHostAdapter(P
 	   logical card number sorted by BIOS (zero-based) */
 
 	pCardInfo->si_relative_cardnum =
-	(UCHAR)(RD_HARPOON(ioport+hp_aramBase+BIOS_RELATIVE_CARD)-1);
+	(unsigned char)(RD_HARPOON(ioport+hp_aramBase+BIOS_RELATIVE_CARD)-1);
 
    SGRAM_ACCESS(ioport);
 
@@ -1402,7 +1401,7 @@ static ULONG FlashPoint_HardwareResetHos
 {
    PSCCBcard CurrCard = NULL;
 	PNVRamInfo pCurrNvRam;
-   UCHAR i,j,thisCard, ScamFlg;
+   unsigned char i,j,thisCard, ScamFlg;
    USHORT temp,sync_bit_map,id;
    ULONG ioport;
 
@@ -1446,7 +1445,7 @@ static ULONG FlashPoint_HardwareResetHos
 		ScamFlg = pCurrNvRam->niScamConf;
 	}
 	else{
-	   ScamFlg = (UCHAR) FPT_utilEERead(ioport, SCAM_CONFIG/2);
+	   ScamFlg = (unsigned char) FPT_utilEERead(ioport, SCAM_CONFIG/2);
 	}
 
 
@@ -1463,7 +1462,7 @@ static ULONG FlashPoint_HardwareResetHos
    WR_HARPOON(ioport+hp_arb_id, pCardInfo->si_id);
    CurrCard->ourId = pCardInfo->si_id;
 
-   i = (UCHAR) pCardInfo->si_flags;
+   i = (unsigned char) pCardInfo->si_flags;
    if (i & SCSI_PARITY_ENA)
        WR_HARPOON(ioport+hp_portctrl_1,(HOST_MODE8 | CHK_SCSI_P));
 
@@ -1543,13 +1542,13 @@ static ULONG FlashPoint_HardwareResetHos
 
          if (pCardInfo->si_per_targ_init_sync & sync_bit_map) {
 
-            FPT_sccbMgrTbl[thisCard][id*2+i].TarEEValue = (UCHAR)temp;
+            FPT_sccbMgrTbl[thisCard][id*2+i].TarEEValue = (unsigned char)temp;
             }
 
          else {
 	    FPT_sccbMgrTbl[thisCard][id*2+i].TarStatus |= SYNC_SUPPORTED;
             FPT_sccbMgrTbl[thisCard][id*2+i].TarEEValue =
-               (UCHAR)(temp & ~EE_SYNC_MASK);
+               (unsigned char)(temp & ~EE_SYNC_MASK);
             }
 
 /*         if ((pCardInfo->si_per_targ_wide_nego & sync_bit_map) ||
@@ -1574,14 +1573,14 @@ static ULONG FlashPoint_HardwareResetHos
       }
 
    WR_HARPOON((ioport+hp_semaphore),
-      (UCHAR)(RD_HARPOON((ioport+hp_semaphore)) | SCCB_MGR_PRESENT));
+      (unsigned char)(RD_HARPOON((ioport+hp_semaphore)) | SCCB_MGR_PRESENT));
 
    return((ULONG)CurrCard);
 }
 
 static void FlashPoint_ReleaseHostAdapter(ULONG pCurrCard)
 {
-	UCHAR i;
+	unsigned char i;
 	ULONG portBase;
 	ULONG regOffset;
 	ULONG scamData;
@@ -1598,7 +1597,7 @@ static void FlashPoint_ReleaseHostAdapte
 		FPT_WrStack(pCurrNvRam->niBaseAddr, 4, pCurrNvRam->niAdapId);
 
 		for(i = 0; i < MAX_SCSI_TAR / 2; i++)
-			FPT_WrStack(pCurrNvRam->niBaseAddr, (UCHAR)(i+5), pCurrNvRam->niSyncTbl[i]);
+			FPT_WrStack(pCurrNvRam->niBaseAddr, (unsigned char)(i+5), pCurrNvRam->niSyncTbl[i]);
 
 		portBase = pCurrNvRam->niBaseAddr;
 
@@ -1617,7 +1616,7 @@ static void FlashPoint_ReleaseHostAdapte
 
 static void FPT_RNVRamData(PNVRamInfo pNvRamInfo)
 {
-	UCHAR i;
+	unsigned char i;
 	ULONG portBase;
 	ULONG regOffset;
 	ULONG scamData;
@@ -1630,7 +1629,7 @@ static void FPT_RNVRamData(PNVRamInfo pN
 	pNvRamInfo->niAdapId   = FPT_RdStack(pNvRamInfo->niBaseAddr, 4);
 
 	for(i = 0; i < MAX_SCSI_TAR / 2; i++)
-		pNvRamInfo->niSyncTbl[i] = FPT_RdStack(pNvRamInfo->niBaseAddr, (UCHAR)(i+5));
+		pNvRamInfo->niSyncTbl[i] = FPT_RdStack(pNvRamInfo->niBaseAddr, (unsigned char)(i+5));
 
 	portBase = pNvRamInfo->niBaseAddr;
 
@@ -1643,20 +1642,20 @@ static void FPT_RNVRamData(PNVRamInfo pN
 
 }
 
-static UCHAR FPT_RdStack(ULONG portBase, UCHAR index)
+static unsigned char FPT_RdStack(ULONG portBase, unsigned char index)
 {
 	WR_HARPOON(portBase + hp_stack_addr, index);
 	return(RD_HARPOON(portBase + hp_stack_data));
 }
 
-static void FPT_WrStack(ULONG portBase, UCHAR index, UCHAR data)
+static void FPT_WrStack(ULONG portBase, unsigned char index, unsigned char data)
 {
 	WR_HARPOON(portBase + hp_stack_addr, index);
 	WR_HARPOON(portBase + hp_stack_data, data);
 }
 
 
-static UCHAR FPT_ChkIfChipInitialized(ULONG ioPort)
+static unsigned char FPT_ChkIfChipInitialized(ULONG ioPort)
 {
 	if((RD_HARPOON(ioPort + hp_arb_id) & 0x0f) != FPT_RdStack(ioPort, 4))
 		return(0);
@@ -1681,7 +1680,7 @@ static UCHAR FPT_ChkIfChipInitialized(UL
 static void FlashPoint_StartCCB(ULONG pCurrCard, PSCCB p_Sccb)
 {
    ULONG ioport;
-   UCHAR thisCard, lun;
+   unsigned char thisCard, lun;
 	PSCCB pSaveSccb;
    CALL_BK_FN callback;
 
@@ -1802,9 +1801,9 @@ static int FlashPoint_AbortCCB(ULONG pCu
 {
 	ULONG ioport;
 
-	UCHAR thisCard;
+	unsigned char thisCard;
 	CALL_BK_FN callback;
-	UCHAR TID;
+	unsigned char TID;
 	PSCCB pSaveSCCB;
 	PSCCBMgr_tar_info currTar_Info;
 
@@ -1823,7 +1822,7 @@ static int FlashPoint_AbortCCB(ULONG pCu
 
 			if (!((PSCCBcard)pCurrCard)->cmdCounter)
 				WR_HARPOON(ioport+hp_semaphore,(RD_HARPOON(ioport+hp_semaphore)
-					& (UCHAR)(~(SCCB_MGR_ACTIVE | TICKLE_ME)) ));
+					& (unsigned char)(~(SCCB_MGR_ACTIVE | TICKLE_ME)) ));
 
 			p_Sccb->SccbStatus = SCCB_ABORT;
 			callback = p_Sccb->SccbCallback;
@@ -1898,7 +1897,7 @@ static int FlashPoint_AbortCCB(ULONG pCu
  *              interrupt for this card and disable the IRQ Pin if so.
  *
  *---------------------------------------------------------------------*/
-static UCHAR FlashPoint_InterruptPending(ULONG pCurrCard)
+static unsigned char FlashPoint_InterruptPending(ULONG pCurrCard)
 {
    ULONG ioport;
 
@@ -1928,9 +1927,9 @@ static UCHAR FlashPoint_InterruptPending
 static int FlashPoint_HandleInterrupt(ULONG pCurrCard)
 {
    PSCCB currSCCB;
-   UCHAR thisCard,result,bm_status, bm_int_st;
+   unsigned char thisCard,result,bm_status, bm_int_st;
    USHORT hp_int;
-   UCHAR i, target;
+   unsigned char i, target;
    ULONG ioport;
 
    thisCard = ((PSCCBcard)pCurrCard)->cardIndex;
@@ -1939,7 +1938,7 @@ static int FlashPoint_HandleInterrupt(UL
    MDISABLE_INT(ioport);
 
    if ((bm_int_st=RD_HARPOON(ioport+hp_int_status)) & EXT_STATUS_ON)
-		bm_status = RD_HARPOON(ioport+hp_ext_status) & (UCHAR)BAD_EXT_STATUS;
+		bm_status = RD_HARPOON(ioport+hp_ext_status) & (unsigned char)BAD_EXT_STATUS;
    else
       bm_status = 0;
 
@@ -2080,7 +2079,7 @@ static int FlashPoint_HandleInterrupt(UL
       else if ( (hp_int & IUNKWN) || (hp_int & PROG_HLT) )
 		   {
 	 	   WRW_HARPOON((ioport+hp_intstat), (PHASE | IUNKWN | PROG_HLT));
-	 	   if ((RD_HARPOON(ioport+hp_prgmcnt_0) & (UCHAR)0x3f)< (UCHAR)SELCHK)
+	 	   if ((RD_HARPOON(ioport+hp_prgmcnt_0) & (unsigned char)0x3f)< (unsigned char)SELCHK)
 	    		{
 	    		FPT_phaseDecode(ioport,thisCard);
 	    		}
@@ -2093,11 +2092,11 @@ static int FlashPoint_HandleInterrupt(UL
    reg. (0x53) also increment the FIFO write addr reg (0x6f), thus we
    need to read this reg first then restore it later. After update to 0x53 */
 
-	    		i = (UCHAR)(RD_HARPOON(ioport+hp_fifowrite));
-	    		target = (UCHAR)(RD_HARPOON(ioport+hp_gp_reg_3));
-	    		WR_HARPOON(ioport+hp_xfer_pad, (UCHAR) ID_UNLOCK);
-	    		WR_HARPOON(ioport+hp_select_id, (UCHAR)(target | target<<4));
-	    		WR_HARPOON(ioport+hp_xfer_pad, (UCHAR) 0x00);
+	    		i = (unsigned char)(RD_HARPOON(ioport+hp_fifowrite));
+	    		target = (unsigned char)(RD_HARPOON(ioport+hp_gp_reg_3));
+	    		WR_HARPOON(ioport+hp_xfer_pad, (unsigned char) ID_UNLOCK);
+	    		WR_HARPOON(ioport+hp_select_id, (unsigned char)(target | target<<4));
+	    		WR_HARPOON(ioport+hp_xfer_pad, (unsigned char) 0x00);
 	    		WR_HARPOON(ioport+hp_fifowrite, i);
 	    		WR_HARPOON(ioport+hp_autostart_3, (AUTO_IMMED+TAG_STRT));
 	    		}
@@ -2170,10 +2169,10 @@ static int FlashPoint_HandleInterrupt(UL
  *              processing time.
  *
  *---------------------------------------------------------------------*/
-static UCHAR FPT_SccbMgr_bad_isr(ULONG p_port, UCHAR p_card,
+static unsigned char FPT_SccbMgr_bad_isr(ULONG p_port, unsigned char p_card,
 				 PSCCBcard pCurrCard, USHORT p_int)
 {
-   UCHAR temp, ScamFlg;
+   unsigned char temp, ScamFlg;
    PSCCBMgr_tar_info currTar_Info;
    PNVRamInfo pCurrNvRam;
 
@@ -2206,9 +2205,9 @@ static UCHAR FPT_SccbMgr_bad_isr(ULONG p
 
          FPT_sxfrp(p_port,p_card);
 
-	     temp = (UCHAR)(RD_HARPOON(p_port+hp_ee_ctrl) &
+	     temp = (unsigned char)(RD_HARPOON(p_port+hp_ee_ctrl) &
 							(EXT_ARB_ACK | SCSI_TERM_ENA_H));
-      	WR_HARPOON(p_port+hp_ee_ctrl, ((UCHAR)temp | SEE_MS | SEE_CS));
+      	WR_HARPOON(p_port+hp_ee_ctrl, ((unsigned char)temp | SEE_MS | SEE_CS));
          WR_HARPOON(p_port+hp_ee_ctrl, temp);
 
          if (!(RDW_HARPOON((p_port+hp_intstat)) & (BUS_FREE | RESET)))
@@ -2243,7 +2242,7 @@ static UCHAR FPT_SccbMgr_bad_isr(ULONG p
 					ScamFlg = pCurrNvRam->niScamConf;
 				}
 				else{
-				   ScamFlg = (UCHAR) FPT_utilEERead(p_port, SCAM_CONFIG/2);
+				   ScamFlg = (unsigned char) FPT_utilEERead(p_port, SCAM_CONFIG/2);
 				}
 
            FPT_XbowInit(p_port, ScamFlg);
@@ -2324,7 +2323,7 @@ static UCHAR FPT_SccbMgr_bad_isr(ULONG p
 
 static void FPT_SccbMgrTableInitAll()
 {
-   UCHAR thisCard;
+   unsigned char thisCard;
 
    for (thisCard = 0; thisCard < MAX_CARDS; thisCard++)
       {
@@ -2347,9 +2346,9 @@ static void FPT_SccbMgrTableInitAll()
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_SccbMgrTableInitCard(PSCCBcard pCurrCard, UCHAR p_card)
+static void FPT_SccbMgrTableInitCard(PSCCBcard pCurrCard, unsigned char p_card)
 {
-   UCHAR scsiID, qtag;
+   unsigned char scsiID, qtag;
 
 	for (qtag = 0; qtag < QUEUE_DEPTH; qtag++)
 	{
@@ -2382,10 +2381,10 @@ static void FPT_SccbMgrTableInitCard(PSC
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_SccbMgrTableInitTarget(UCHAR p_card, UCHAR target)
+static void FPT_SccbMgrTableInitTarget(unsigned char p_card, unsigned char target)
 {
 
-	UCHAR lun, qtag;
+	unsigned char lun, qtag;
 	PSCCBMgr_tar_info currTar_Info;
 
 	currTar_Info = &FPT_sccbMgrTbl[p_card][target];
@@ -2428,9 +2427,9 @@ static void FPT_SccbMgrTableInitTarget(U
  *
  *---------------------------------------------------------------------*/
 
-static UCHAR FPT_sfm(ULONG port, PSCCB pCurrSCCB)
+static unsigned char FPT_sfm(ULONG port, PSCCB pCurrSCCB)
 {
-	UCHAR message;
+	unsigned char message;
 	USHORT TimeOutLoop;
 
 	TimeOutLoop = 0;
@@ -2501,16 +2500,16 @@ static UCHAR FPT_sfm(ULONG port, PSCCB p
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_ssel(ULONG port, UCHAR p_card)
+static void FPT_ssel(ULONG port, unsigned char p_card)
 {
 
-   UCHAR auto_loaded, i, target, *theCCB;
+   unsigned char auto_loaded, i, target, *theCCB;
 
    ULONG cdb_reg;
    PSCCBcard CurrCard;
    PSCCB currSCCB;
    PSCCBMgr_tar_info currTar_Info;
-   UCHAR lastTag, lun;
+   unsigned char lastTag, lun;
 
    CurrCard = &FPT_BL_Card[p_card];
    currSCCB = CurrCard->currentSCCB;
@@ -2656,8 +2655,8 @@ static void FPT_ssel(ULONG port, UCHAR p
       WRW_HARPOON((port+ID_MSG_STRT+2),BRH_OP+ALWAYS+CMDPZ);
 
 			WRW_HARPOON((port+SYNC_MSGS+0), (MPM_OP+AMSG_OUT+
-								(((UCHAR)(currSCCB->ControlByte & TAG_TYPE_MASK)
-								>> 6) | (UCHAR)0x20)));
+								(((unsigned char)(currSCCB->ControlByte & TAG_TYPE_MASK)
+								>> 6) | (unsigned char)0x20)));
 			WRW_HARPOON((port+SYNC_MSGS+2),
 							(MPM_OP+AMSG_OUT+currSCCB->Sccb_tag));
 			WRW_HARPOON((port+SYNC_MSGS+4), (BRH_OP+ALWAYS+NP ));
@@ -2713,8 +2712,8 @@ static void FPT_ssel(ULONG port, UCHAR p
             WRW_HARPOON((port+ID_MSG_STRT), (MPM_OP+AMSG_OUT+currSCCB->Sccb_idmsg));
 
             WRW_HARPOON((port+ID_MSG_STRT+2), (MPM_OP+AMSG_OUT+
-                        (((UCHAR)(currSCCB->ControlByte & TAG_TYPE_MASK)
-                        >> 6) | (UCHAR)0x20)));
+                        (((unsigned char)(currSCCB->ControlByte & TAG_TYPE_MASK)
+                        >> 6) | (unsigned char)0x20)));
 
 				for (i = 1; i < QUEUE_DEPTH; i++)
 				{
@@ -2760,7 +2759,7 @@ static void FPT_ssel(ULONG port, UCHAR p
          }
 
 
-      theCCB = (UCHAR *)&currSCCB->Cdb[0];
+      theCCB = (unsigned char *)&currSCCB->Cdb[0];
 
       cdb_reg = port + CMD_STRT;
 
@@ -2791,7 +2790,7 @@ static void FPT_ssel(ULONG port, UCHAR p
    else
       {
 
-/*      auto_loaded =  (RD_HARPOON(port+hp_autostart_3) & (UCHAR)0x1F);
+/*      auto_loaded =  (RD_HARPOON(port+hp_autostart_3) & (unsigned char)0x1F);
       auto_loaded |= AUTO_IMMED; */
       auto_loaded = AUTO_IMMED;
 
@@ -2812,10 +2811,10 @@ static void FPT_ssel(ULONG port, UCHAR p
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_sres(ULONG port, UCHAR p_card, PSCCBcard pCurrCard)
+static void FPT_sres(ULONG port, unsigned char p_card, PSCCBcard pCurrCard)
 {
 
-   UCHAR our_target, message, lun = 0, tag, msgRetryCount;
+   unsigned char our_target, message, lun = 0, tag, msgRetryCount;
 
 
    PSCCBMgr_tar_info currTar_Info;
@@ -2881,7 +2880,7 @@ static void FPT_sres(ULONG port, UCHAR p
 	WRW_HARPOON((port+hp_fiforead), (USHORT) 0x00);
 
 
-	our_target = (UCHAR)(RD_HARPOON(port+hp_select_id) >> 4);
+	our_target = (unsigned char)(RD_HARPOON(port+hp_select_id) >> 4);
 	currTar_Info = &FPT_sccbMgrTbl[p_card][our_target];
 
 
@@ -2913,7 +2912,7 @@ static void FPT_sres(ULONG port, UCHAR p
 
 				if (message <= (0x80 | LUN_MASK))
 				{
-					lun = message & (UCHAR)LUN_MASK;
+					lun = message & (unsigned char)LUN_MASK;
 
 					if ((currTar_Info->TarStatus & TAR_TAG_Q_MASK) == TAG_Q_TRYING)
 					{
@@ -3073,7 +3072,7 @@ static void FPT_sres(ULONG port, UCHAR p
 	  (RD_HARPOON(port+hp_scsisig) & SCSI_BSY)) ;
 }
 
-static void FPT_SendMsg(ULONG port, UCHAR message)
+static void FPT_SendMsg(ULONG port, unsigned char message)
 {
 	while(!(RD_HARPOON(port+hp_scsisig) & SCSI_REQ))
 	{
@@ -3122,7 +3121,7 @@ static void FPT_SendMsg(ULONG port, UCHA
  *              target device.
  *
  *---------------------------------------------------------------------*/
-static void FPT_sdecm(UCHAR message, ULONG port, UCHAR p_card)
+static void FPT_sdecm(unsigned char message, ULONG port, unsigned char p_card)
 {
 	PSCCB currSCCB;
 	PSCCBcard CurrCard;
@@ -3152,8 +3151,8 @@ static void FPT_sdecm(UCHAR message, ULO
 
 		if (currSCCB->Sccb_scsistat == SELECT_Q_ST)
 		{
-			currTar_Info->TarStatus &= ~(UCHAR)TAR_TAG_Q_MASK;
-			currTar_Info->TarStatus |= (UCHAR)TAG_Q_REJECT;
+			currTar_Info->TarStatus &= ~(unsigned char)TAR_TAG_Q_MASK;
+			currTar_Info->TarStatus |= (unsigned char)TAG_Q_REJECT;
 		}
 
 		ACCEPT_MSG(port);
@@ -3190,7 +3189,7 @@ static void FPT_sdecm(UCHAR message, ULO
 				if ((currSCCB->Sccb_scsistat == SELECT_SN_ST))
 				{
 
-					currTar_Info->TarStatus |= (UCHAR)SYNC_SUPPORTED;
+					currTar_Info->TarStatus |= (unsigned char)SYNC_SUPPORTED;
 
 					currTar_Info->TarEEValue &= ~EE_SYNC_MASK;
 				}
@@ -3209,7 +3208,7 @@ static void FPT_sdecm(UCHAR message, ULO
 				else if ((currTar_Info->TarStatus & TAR_TAG_Q_MASK) == TAG_Q_TRYING )
 				{
 					currTar_Info->TarStatus = (currTar_Info->TarStatus &
-													~(UCHAR)TAR_TAG_Q_MASK) | TAG_Q_REJECT;
+													~(unsigned char)TAR_TAG_Q_MASK) | TAG_Q_REJECT;
 
 
 					currSCCB->ControlByte &= ~F_USE_CMD_Q;
@@ -3241,7 +3240,7 @@ static void FPT_sdecm(UCHAR message, ULO
 					currTar_Info->TarLUNBusy[0] = 1;
 
 
-				currSCCB->ControlByte &= ~(UCHAR)F_USE_CMD_Q;
+				currSCCB->ControlByte &= ~(unsigned char)F_USE_CMD_Q;
 
 				WR_HARPOON(port+hp_autostart_1, (AUTO_IMMED+DISCONNECT_START));
 
@@ -3301,9 +3300,9 @@ static void FPT_sdecm(UCHAR message, ULO
  * Description: Decide what to do with the extended message.
  *
  *---------------------------------------------------------------------*/
-static void FPT_shandem(ULONG port, UCHAR p_card, PSCCB pCurrSCCB)
+static void FPT_shandem(ULONG port, unsigned char p_card, PSCCB pCurrSCCB)
 {
-	UCHAR length,message;
+	unsigned char length,message;
 
 	length = FPT_sfm(port,pCurrSCCB);
 	if (length) 
@@ -3380,7 +3379,7 @@ static void FPT_shandem(ULONG port, UCHA
  *
  *---------------------------------------------------------------------*/
 
-static UCHAR FPT_sisyncn(ULONG port, UCHAR p_card, UCHAR syncFlag)
+static unsigned char FPT_sisyncn(ULONG port, unsigned char p_card, unsigned char syncFlag)
 {
    PSCCB currSCCB;
    PSCCBMgr_tar_info currTar_Info;
@@ -3392,7 +3391,7 @@ static UCHAR FPT_sisyncn(ULONG port, UCH
 
 
       WRW_HARPOON((port+ID_MSG_STRT),
-                 (MPM_OP+AMSG_OUT+(currSCCB->Sccb_idmsg & ~(UCHAR)DISC_PRIV)));
+                 (MPM_OP+AMSG_OUT+(currSCCB->Sccb_idmsg & ~(unsigned char)DISC_PRIV)));
 
       WRW_HARPOON((port+ID_MSG_STRT+2),BRH_OP+ALWAYS+CMDPZ);
 
@@ -3426,7 +3425,7 @@ static UCHAR FPT_sisyncn(ULONG port, UCH
 		{
 		   WR_HARPOON(port+hp_autostart_3, (SELECT+SELCHK_STRT));
 	      currTar_Info->TarStatus = ((currTar_Info->TarStatus &
-   	      ~(UCHAR)TAR_SYNC_MASK) | (UCHAR)SYNC_TRYING);
+   	      ~(unsigned char)TAR_SYNC_MASK) | (unsigned char)SYNC_TRYING);
 		}
 		else
 		{
@@ -3439,7 +3438,7 @@ static UCHAR FPT_sisyncn(ULONG port, UCH
 
    else {
 
-      currTar_Info->TarStatus |=	 (UCHAR)SYNC_SUPPORTED;
+      currTar_Info->TarStatus |=	 (unsigned char)SYNC_SUPPORTED;
       currTar_Info->TarEEValue &= ~EE_SYNC_MASK;
       return(0);
       }
@@ -3455,9 +3454,9 @@ static UCHAR FPT_sisyncn(ULONG port, UCH
  *              necessary.
  *
  *---------------------------------------------------------------------*/
-static void FPT_stsyncn(ULONG port, UCHAR p_card)
+static void FPT_stsyncn(ULONG port, unsigned char p_card)
 {
-   UCHAR sync_msg,offset,sync_reg,our_sync_msg;
+   unsigned char sync_msg,offset,sync_reg,our_sync_msg;
    PSCCB currSCCB;
    PSCCBMgr_tar_info currTar_Info;
 
@@ -3562,7 +3561,7 @@ static void FPT_stsyncn(ULONG port, UCHA
       ACCEPT_MSG(port);
 
       currTar_Info->TarStatus = ((currTar_Info->TarStatus &
-         ~(UCHAR)TAR_SYNC_MASK) | (UCHAR)SYNC_SUPPORTED);
+         ~(unsigned char)TAR_SYNC_MASK) | (unsigned char)SYNC_SUPPORTED);
 
       WR_HARPOON(port+hp_autostart_1, (AUTO_IMMED+DISCONNECT_START));
       }
@@ -3575,7 +3574,7 @@ static void FPT_stsyncn(ULONG port, UCHA
       FPT_sisyncr(port,sync_msg,offset);
 
       currTar_Info->TarStatus = ((currTar_Info->TarStatus &
-         ~(UCHAR)TAR_SYNC_MASK) | (UCHAR)SYNC_SUPPORTED);
+         ~(unsigned char)TAR_SYNC_MASK) | (unsigned char)SYNC_SUPPORTED);
       }
 }
 
@@ -3587,7 +3586,7 @@ static void FPT_stsyncn(ULONG port, UCHA
  * Description: Answer the targets sync message.
  *
  *---------------------------------------------------------------------*/
-static void FPT_sisyncr(ULONG port,UCHAR sync_pulse, UCHAR offset)
+static void FPT_sisyncr(ULONG port,unsigned char sync_pulse, unsigned char offset)
 {
    ARAM_ACCESS(port);
    WRW_HARPOON((port+SYNC_MSGS+0), (MPM_OP+AMSG_OUT+SMEXT ));
@@ -3618,7 +3617,7 @@ static void FPT_sisyncr(ULONG port,UCHAR
  *
  *---------------------------------------------------------------------*/
 
-static UCHAR FPT_siwidn(ULONG port, UCHAR p_card)
+static unsigned char FPT_siwidn(ULONG port, unsigned char p_card)
 {
    PSCCB currSCCB;
    PSCCBMgr_tar_info currTar_Info;
@@ -3630,7 +3629,7 @@ static UCHAR FPT_siwidn(ULONG port, UCHA
 
 
       WRW_HARPOON((port+ID_MSG_STRT),
-	              (MPM_OP+AMSG_OUT+(currSCCB->Sccb_idmsg & ~(UCHAR)DISC_PRIV)));
+	              (MPM_OP+AMSG_OUT+(currSCCB->Sccb_idmsg & ~(unsigned char)DISC_PRIV)));
 
       WRW_HARPOON((port+ID_MSG_STRT+2),BRH_OP+ALWAYS+CMDPZ);
 
@@ -3645,7 +3644,7 @@ static UCHAR FPT_siwidn(ULONG port, UCHA
 
 
       currTar_Info->TarStatus = ((currTar_Info->TarStatus &
-         ~(UCHAR)TAR_WIDE_MASK) | (UCHAR)WIDE_ENABLED);
+         ~(unsigned char)TAR_WIDE_MASK) | (unsigned char)WIDE_ENABLED);
 
       return(1);
       }
@@ -3653,7 +3652,7 @@ static UCHAR FPT_siwidn(ULONG port, UCHA
    else {
 
       currTar_Info->TarStatus = ((currTar_Info->TarStatus &
-               ~(UCHAR)TAR_WIDE_MASK) | WIDE_NEGOCIATED);
+               ~(unsigned char)TAR_WIDE_MASK) | WIDE_NEGOCIATED);
 
       currTar_Info->TarEEValue &= ~EE_WIDE_SCSI;
       return(0);
@@ -3670,9 +3669,9 @@ static UCHAR FPT_siwidn(ULONG port, UCHA
  *              necessary.
  *
  *---------------------------------------------------------------------*/
-static void FPT_stwidn(ULONG port, UCHAR p_card)
+static void FPT_stwidn(ULONG port, unsigned char p_card)
 {
-   UCHAR width;
+   unsigned char width;
    PSCCB currSCCB;
    PSCCBMgr_tar_info currTar_Info;
 
@@ -3750,7 +3749,7 @@ static void FPT_stwidn(ULONG port, UCHAR
  * Description: Answer the targets Wide nego message.
  *
  *---------------------------------------------------------------------*/
-static void FPT_siwidr(ULONG port, UCHAR width)
+static void FPT_siwidr(ULONG port, unsigned char width)
 {
    ARAM_ACCESS(port);
    WRW_HARPOON((port+SYNC_MSGS+0), (MPM_OP+AMSG_OUT+SMEXT ));
@@ -3779,10 +3778,10 @@ static void FPT_siwidr(ULONG port, UCHAR
  *              ID specified.
  *
  *---------------------------------------------------------------------*/
-static void FPT_sssyncv(ULONG p_port, UCHAR p_id, UCHAR p_sync_value,
+static void FPT_sssyncv(ULONG p_port, unsigned char p_id, unsigned char p_sync_value,
 			PSCCBMgr_tar_info currTar_Info)
 {
-   UCHAR index;
+   unsigned char index;
 
    index = p_id;
 
@@ -3851,9 +3850,9 @@ static void FPT_sssyncv(ULONG p_port, UC
  * Description: Reset the desired card's SCSI bus.
  *
  *---------------------------------------------------------------------*/
-static void FPT_sresb(ULONG port, UCHAR p_card)
+static void FPT_sresb(ULONG port, unsigned char p_card)
 {
-   UCHAR scsiID, i;
+   unsigned char scsiID, i;
 
    PSCCBMgr_tar_info currTar_Info;
 
@@ -3926,7 +3925,7 @@ static void FPT_sresb(ULONG port, UCHAR 
  *---------------------------------------------------------------------*/
 static void FPT_ssenss(PSCCBcard pCurrCard)
 {
-   UCHAR i;
+   unsigned char i;
    PSCCB currSCCB;
 
    currSCCB = pCurrCard->currentSCCB;
@@ -3941,7 +3940,7 @@ static void FPT_ssenss(PSCCBcard pCurrCa
 
    currSCCB->CdbLength = SIX_BYTE_CMD;
    currSCCB->Cdb[0]    = SCSI_REQUEST_SENSE;
-   currSCCB->Cdb[1]    = currSCCB->Cdb[1] & (UCHAR)0xE0; /*Keep LUN. */
+   currSCCB->Cdb[1]    = currSCCB->Cdb[1] & (unsigned char)0xE0; /*Keep LUN. */
    currSCCB->Cdb[2]    = 0x00;
    currSCCB->Cdb[3]    = 0x00;
    currSCCB->Cdb[4]    = currSCCB->RequestSenseLength;
@@ -3955,7 +3954,7 @@ static void FPT_ssenss(PSCCBcard pCurrCa
 
    currSCCB->Sccb_XferState &= ~F_SG_XFER;
 
-   currSCCB->Sccb_idmsg = currSCCB->Sccb_idmsg & ~(UCHAR)DISC_PRIV;
+   currSCCB->Sccb_idmsg = currSCCB->Sccb_idmsg & ~(unsigned char)DISC_PRIV;
 
    currSCCB->ControlByte = 0x00;
 
@@ -3973,9 +3972,9 @@ static void FPT_ssenss(PSCCBcard pCurrCa
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_sxfrp(ULONG p_port, UCHAR p_card)
+static void FPT_sxfrp(ULONG p_port, unsigned char p_card)
 {
-   UCHAR curr_phz;
+   unsigned char curr_phz;
 
 
    DISABLE_AUTO(p_port);
@@ -3994,7 +3993,7 @@ static void FPT_sxfrp(ULONG p_port, UCHA
 
    WR_HARPOON(p_port+hp_xfercnt_0, 0x00);
 
-   curr_phz = RD_HARPOON(p_port+hp_scsisig) & (UCHAR)S_SCSI_PHZ;
+   curr_phz = RD_HARPOON(p_port+hp_scsisig) & (unsigned char)S_SCSI_PHZ;
 
    WRW_HARPOON((p_port+hp_intstat), XFER_CNT_0);
 
@@ -4002,9 +4001,9 @@ static void FPT_sxfrp(ULONG p_port, UCHA
    WR_HARPOON(p_port+hp_scsisig, curr_phz);
 
    while ( !(RDW_HARPOON((p_port+hp_intstat)) & (BUS_FREE | RESET)) &&
-      (curr_phz == (RD_HARPOON(p_port+hp_scsisig) & (UCHAR)S_SCSI_PHZ)) )
+      (curr_phz == (RD_HARPOON(p_port+hp_scsisig) & (unsigned char)S_SCSI_PHZ)) )
       {
-      if (curr_phz & (UCHAR)SCSI_IOBIT)
+      if (curr_phz & (unsigned char)SCSI_IOBIT)
          {
       	WR_HARPOON(p_port+hp_portctrl_0, (SCSI_PORT | HOST_PORT | SCSI_INBIT));
 
@@ -4055,10 +4054,10 @@ static void FPT_sxfrp(ULONG p_port, UCHA
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_schkdd(ULONG port, UCHAR p_card)
+static void FPT_schkdd(ULONG port, unsigned char p_card)
 {
    USHORT TimeOutLoop;
-	UCHAR sPhase;
+	unsigned char sPhase;
 
    PSCCB currSCCB;
 
@@ -4112,7 +4111,7 @@ static void FPT_schkdd(ULONG port, UCHAR
       if (RDW_HARPOON((port+hp_intstat)) & BUS_FREE) {
 	      return;
    	   }
-      if (RD_HARPOON(port+hp_offsetctr) & (UCHAR)0x1F) {
+      if (RD_HARPOON(port+hp_offsetctr) & (unsigned char)0x1F) {
 	      break;
    	   }
       if (RDW_HARPOON((port+hp_intstat)) & RESET) {
@@ -4124,7 +4123,7 @@ static void FPT_schkdd(ULONG port, UCHAR
 
 	sPhase = RD_HARPOON(port+hp_scsisig) & (SCSI_BSY | S_SCSI_PHZ);
    if ((!(RD_HARPOON(port+hp_xferstat) & FIFO_EMPTY))                     ||
-      (RD_HARPOON(port+hp_offsetctr) & (UCHAR)0x1F)                       ||
+      (RD_HARPOON(port+hp_offsetctr) & (unsigned char)0x1F)                       ||
       (sPhase == (SCSI_BSY | S_DATAO_PH)) ||
       (sPhase == (SCSI_BSY | S_DATAI_PH)))
       {
@@ -4168,7 +4167,7 @@ static void FPT_schkdd(ULONG port, UCHAR
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_sinits(PSCCB p_sccb, UCHAR p_card)
+static void FPT_sinits(PSCCB p_sccb, unsigned char p_card)
 {
    PSCCBMgr_tar_info currTar_Info;
 
@@ -4213,12 +4212,12 @@ static void FPT_sinits(PSCCB p_sccb, UCH
 */
    if ((currTar_Info->TarStatus & TAR_ALLOW_DISC) ||
       (currTar_Info->TarStatus & TAG_Q_TRYING)) {
-      p_sccb->Sccb_idmsg      = (UCHAR)(SMIDENT | DISC_PRIV) | p_sccb->Lun;
+      p_sccb->Sccb_idmsg      = (unsigned char)(SMIDENT | DISC_PRIV) | p_sccb->Lun;
       }
 
    else {
 
-      p_sccb->Sccb_idmsg      = (UCHAR)SMIDENT | p_sccb->Lun;
+      p_sccb->Sccb_idmsg      = (unsigned char)SMIDENT | p_sccb->Lun;
       }
 
    p_sccb->HostStatus         = 0x00;
@@ -4248,15 +4247,15 @@ static void FPT_sinits(PSCCB p_sccb, UCH
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_phaseDecode(ULONG p_port, UCHAR p_card)
+static void FPT_phaseDecode(ULONG p_port, unsigned char p_card)
 {
    unsigned char phase_ref;
-   void (*phase) (ULONG, UCHAR);
+   void (*phase) (ULONG, unsigned char);
 
 
    DISABLE_AUTO(p_port);
 
-   phase_ref = (UCHAR) (RD_HARPOON(p_port+hp_scsisig) & S_SCSI_PHZ);
+   phase_ref = (unsigned char) (RD_HARPOON(p_port+hp_scsisig) & S_SCSI_PHZ);
 
    phase = FPT_s_PhaseTbl[phase_ref];
 
@@ -4273,7 +4272,7 @@ static void FPT_phaseDecode(ULONG p_port
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_phaseDataOut(ULONG port, UCHAR p_card)
+static void FPT_phaseDataOut(ULONG port, unsigned char p_card)
 {
 
    PSCCB currSCCB;
@@ -4317,7 +4316,7 @@ static void FPT_phaseDataOut(ULONG port,
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_phaseDataIn(ULONG port, UCHAR p_card)
+static void FPT_phaseDataIn(ULONG port, unsigned char p_card)
 {
 
    PSCCB currSCCB;
@@ -4364,11 +4363,11 @@ static void FPT_phaseDataIn(ULONG port, 
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_phaseCommand(ULONG p_port, UCHAR p_card)
+static void FPT_phaseCommand(ULONG p_port, unsigned char p_card)
 {
    PSCCB currSCCB;
    ULONG cdb_reg;
-   UCHAR i;
+   unsigned char i;
 
    currSCCB = FPT_BL_Card[p_card].currentSCCB;
 
@@ -4416,7 +4415,7 @@ static void FPT_phaseCommand(ULONG p_por
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_phaseStatus(ULONG port, UCHAR p_card)
+static void FPT_phaseStatus(ULONG port, unsigned char p_card)
 {
    /* Start-up the automation to finish off this command and let the
       isr handle the interrupt for command complete when it comes in.
@@ -4438,9 +4437,9 @@ static void FPT_phaseStatus(ULONG port, 
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_phaseMsgOut(ULONG port, UCHAR p_card)
+static void FPT_phaseMsgOut(ULONG port, unsigned char p_card)
 {
-	UCHAR message,scsiID;
+	unsigned char message,scsiID;
 	PSCCB currSCCB;
 	PSCCBMgr_tar_info currTar_Info;
 
@@ -4586,9 +4585,9 @@ static void FPT_phaseMsgOut(ULONG port, 
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_phaseMsgIn(ULONG port, UCHAR p_card)
+static void FPT_phaseMsgIn(ULONG port, unsigned char p_card)
 {
-	UCHAR message;
+	unsigned char message;
 	PSCCB currSCCB;
 
 	currSCCB = FPT_BL_Card[p_card].currentSCCB;
@@ -4639,7 +4638,7 @@ static void FPT_phaseMsgIn(ULONG port, U
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_phaseIllegal(ULONG port, UCHAR p_card)
+static void FPT_phaseIllegal(ULONG port, unsigned char p_card)
 {
    PSCCB currSCCB;
 
@@ -4667,7 +4666,7 @@ static void FPT_phaseIllegal(ULONG port,
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_phaseChkFifo(ULONG port, UCHAR p_card)
+static void FPT_phaseChkFifo(ULONG port, unsigned char p_card)
 {
    ULONG xfercnt;
    PSCCB currSCCB;
@@ -4745,7 +4744,7 @@ static void FPT_phaseChkFifo(ULONG port,
  *              because of command complete or from a disconnect.
  *
  *---------------------------------------------------------------------*/
-static void FPT_phaseBusFree(ULONG port, UCHAR p_card)
+static void FPT_phaseBusFree(ULONG port, unsigned char p_card)
 {
    PSCCB currSCCB;
 
@@ -4775,7 +4774,7 @@ static void FPT_phaseBusFree(ULONG port,
       else if(currSCCB->Sccb_scsistat == SELECT_SN_ST)
 	      {
 	      FPT_sccbMgrTbl[p_card][currSCCB->TargID].TarStatus |=
-			         (UCHAR)SYNC_SUPPORTED;
+			         (unsigned char)SYNC_SUPPORTED;
 	      FPT_sccbMgrTbl[p_card][currSCCB->TargID].TarEEValue &= ~EE_SYNC_MASK;
 	      }
 
@@ -4951,10 +4950,10 @@ static void FPT_autoLoadDefaultMap(ULONG
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_autoCmdCmplt(ULONG p_port, UCHAR p_card)
+static void FPT_autoCmdCmplt(ULONG p_port, unsigned char p_card)
 {
    PSCCB currSCCB;
-   UCHAR status_byte;
+   unsigned char status_byte;
 
    currSCCB = FPT_BL_Card[p_card].currentSCCB;
 
@@ -5001,7 +5000,7 @@ static void FPT_autoCmdCmplt(ULONG p_por
       if(currSCCB->Sccb_scsistat == SELECT_SN_ST)
          {
          FPT_sccbMgrTbl[p_card][currSCCB->TargID].TarStatus |=
-            (UCHAR)SYNC_SUPPORTED;
+            (unsigned char)SYNC_SUPPORTED;
 
 	      FPT_sccbMgrTbl[p_card][currSCCB->TargID].TarEEValue &= ~EE_SYNC_MASK;
          FPT_BL_Card[p_card].globalFlags |= F_NEW_SCCB_CMD;
@@ -5177,7 +5176,7 @@ static void FPT_dataXferProcessor(ULONG 
 			if (pCurrCard->globalFlags & F_HOST_XFER_ACT)
 
 				{
-		   	currSCCB->Sccb_sgseg += (UCHAR)SG_BUF_CNT;
+		   	currSCCB->Sccb_sgseg += (unsigned char)SG_BUF_CNT;
          	currSCCB->Sccb_SGoffset = 0x00; 
  				}
 			pCurrCard->globalFlags |= F_HOST_XFER_ACT;
@@ -5208,7 +5207,7 @@ static void FPT_busMstrSGDataXferStart(U
 {
    ULONG count,addr,tmpSGCnt;
    UINT sg_index;
-   UCHAR sg_count, i;
+   unsigned char sg_count, i;
    ULONG reg_offset;
 
 
@@ -5227,12 +5226,12 @@ static void FPT_busMstrSGDataXferStart(U
    reg_offset = hp_aramBase;
 
 
-	i = (UCHAR) (RD_HARPOON(p_port+hp_page_ctrl) & ~(SGRAM_ARAM|SCATTER_EN));
+	i = (unsigned char) (RD_HARPOON(p_port+hp_page_ctrl) & ~(SGRAM_ARAM|SCATTER_EN));
 
 
 	WR_HARPOON(p_port+hp_page_ctrl, i);
 
-   while ((sg_count < (UCHAR)SG_BUF_CNT) &&
+   while ((sg_count < (unsigned char)SG_BUF_CNT) &&
       ((ULONG)(sg_index * (UINT)SG_ELEMENT_SIZE) < pcurrSCCB->DataLength) ) {
 
       tmpSGCnt += *(((ULONG *)pcurrSCCB->DataPointer)+
@@ -5297,7 +5296,7 @@ static void FPT_busMstrSGDataXferStart(U
       }
 
 
-   WR_HARPOON(p_port+hp_page_ctrl, (UCHAR) (i | SCATTER_EN));
+   WR_HARPOON(p_port+hp_page_ctrl, (unsigned char) (i | SCATTER_EN));
 
 }
 
@@ -5362,7 +5361,7 @@ static void FPT_busMstrDataXferStart(ULO
  *               command busy is also time out, it'll just give up.
  *
  *---------------------------------------------------------------------*/
-static UCHAR FPT_busMstrTimeOut(ULONG p_port)
+static unsigned char FPT_busMstrTimeOut(ULONG p_port)
 {
    ULONG timeout;
 
@@ -5400,7 +5399,7 @@ static UCHAR FPT_busMstrTimeOut(ULONG p_
  * Description: Abort any in progress transfer.
  *
  *---------------------------------------------------------------------*/
-static void FPT_hostDataXferAbort(ULONG port, UCHAR p_card, PSCCB pCurrSCCB)
+static void FPT_hostDataXferAbort(ULONG port, unsigned char p_card, PSCCB pCurrSCCB)
 {
 
    ULONG timeout;
@@ -5707,13 +5706,13 @@ static void FPT_hostDataXferRestart(PSCC
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_scini(UCHAR p_card, UCHAR p_our_id, UCHAR p_power_up)
+static void FPT_scini(unsigned char p_card, unsigned char p_our_id, unsigned char p_power_up)
 {
 
-   UCHAR loser,assigned_id;
+   unsigned char loser,assigned_id;
    ULONG p_port;
 
-   UCHAR i,k,ScamFlg ;
+   unsigned char i,k,ScamFlg ;
    PSCCBcard currCard;
 	PNVRamInfo pCurrNvRam;
 
@@ -5727,8 +5726,8 @@ static void FPT_scini(UCHAR p_card, UCHA
 		i = pCurrNvRam->niSysConf;
 	}
 	else{
-	   ScamFlg = (UCHAR) FPT_utilEERead(p_port, SCAM_CONFIG/2);
-	   i = (UCHAR)(FPT_utilEERead(p_port, (SYSTEM_CONFIG/2)));
+	   ScamFlg = (unsigned char) FPT_utilEERead(p_port, SCAM_CONFIG/2);
+	   i = (unsigned char)(FPT_utilEERead(p_port, (SYSTEM_CONFIG/2)));
 	}
 	if(!(i & 0x02))	/* check if reset bus in AutoSCSI parameter set */
 		return;
@@ -5846,7 +5845,7 @@ static void FPT_scini(UCHAR p_card, UCHA
                      if (FPT_scvalq(k))
                         {
                         currCard->ourId =
-                           ((UCHAR)(i<<3)+(k & (UCHAR)7)) & (UCHAR) 0x3F;
+                           ((unsigned char)(i<<3)+(k & (unsigned char)7)) & (unsigned char) 0x3F;
                         FPT_inisci(p_card, p_port, p_our_id);
                         FPT_scamInfo[currCard->ourId].state = ID_ASSIGNED;
                         FPT_scamInfo[currCard->ourId].id_string[0]
@@ -5903,7 +5902,7 @@ static void FPT_scini(UCHAR p_card, UCHA
  *
  *---------------------------------------------------------------------*/
 
-static int FPT_scarb(ULONG p_port, UCHAR p_sel_type)
+static int FPT_scarb(ULONG p_port, unsigned char p_sel_type)
 {
    if (p_sel_type == INIT_SELTD)
       {
@@ -6000,12 +5999,12 @@ static void FPT_scbusf(ULONG p_port)
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_scasid(UCHAR p_card, ULONG p_port)
+static void FPT_scasid(unsigned char p_card, ULONG p_port)
 {
-   UCHAR temp_id_string[ID_STRING_LENGTH];
+   unsigned char temp_id_string[ID_STRING_LENGTH];
 
-   UCHAR i,k,scam_id;
-	UCHAR crcBytes[3];
+   unsigned char i,k,scam_id;
+	unsigned char crcBytes[3];
 	PNVRamInfo pCurrNvRam;
 	ushort_ptr pCrcBytes;
 
@@ -6018,7 +6017,7 @@ static void FPT_scasid(UCHAR p_card, ULO
 
       for (k=0; k < ID_STRING_LENGTH; k++)
          {
-         temp_id_string[k] = (UCHAR) 0x00;
+         temp_id_string[k] = (unsigned char) 0x00;
          }
 
       FPT_scxferc(p_port,SYNC_PTRN);
@@ -6034,7 +6033,7 @@ static void FPT_scasid(UCHAR p_card, ULO
 				temp_id_string[2] = crcBytes[0];
 				temp_id_string[3] = crcBytes[1];
 				for(k = 4; k < ID_STRING_LENGTH; k++)
-					temp_id_string[k] = (UCHAR) 0x00;
+					temp_id_string[k] = (unsigned char) 0x00;
 			}
          i = FPT_scmachid(p_card,temp_id_string);
 
@@ -6052,7 +6051,7 @@ static void FPT_scasid(UCHAR p_card, ULO
             else
                FPT_scxferc(p_port,ID_8_F);
 
-            scam_id = (i & (UCHAR) 0x07);
+            scam_id = (i & (unsigned char) 0x07);
 
 
             for (k=1; k < 0x08; k <<= 1)
@@ -6098,15 +6097,15 @@ static void FPT_scsel(ULONG p_port)
 
 
    WR_HARPOON(p_port+hp_scsisig, (SCSI_SEL | SCSI_BSY | SCSI_IOBIT | SCSI_CD));
-   WR_HARPOON(p_port+hp_scsidata_0, (UCHAR)(RD_HARPOON(p_port+hp_scsidata_0) |
-      (UCHAR)(BIT(7)+BIT(6))));
+   WR_HARPOON(p_port+hp_scsidata_0, (unsigned char)(RD_HARPOON(p_port+hp_scsidata_0) |
+      (unsigned char)(BIT(7)+BIT(6))));
 
 
    WR_HARPOON(p_port+hp_scsisig, (SCSI_BSY | SCSI_IOBIT | SCSI_CD));
    FPT_scwiros(p_port, SCSI_SEL);
 
-   WR_HARPOON(p_port+hp_scsidata_0, (UCHAR)(RD_HARPOON(p_port+hp_scsidata_0) &
-      ~(UCHAR)BIT(6)));
+   WR_HARPOON(p_port+hp_scsidata_0, (unsigned char)(RD_HARPOON(p_port+hp_scsidata_0) &
+      ~(unsigned char)BIT(6)));
    FPT_scwirod(p_port, BIT(6));
 
    WR_HARPOON(p_port+hp_scsisig, (SCSI_SEL | SCSI_BSY | SCSI_IOBIT | SCSI_CD));
@@ -6122,9 +6121,9 @@ static void FPT_scsel(ULONG p_port)
  *
  *---------------------------------------------------------------------*/
 
-static UCHAR FPT_scxferc(ULONG p_port, UCHAR p_data)
+static unsigned char FPT_scxferc(ULONG p_port, unsigned char p_data)
 {
-   UCHAR curr_data, ret_data;
+   unsigned char curr_data, ret_data;
 
    curr_data = p_data | BIT(7) | BIT(5);   /*Start with DB7 & DB5 asserted. */
 
@@ -6137,7 +6136,7 @@ static UCHAR FPT_scxferc(ULONG p_port, U
    FPT_scwirod(p_port,BIT(7));              /*Wait for DB7 to be released. */
 	while (!(RD_HARPOON(p_port+hp_scsidata_0) & BIT(5)));
 
-   ret_data = (RD_HARPOON(p_port+hp_scsidata_0) & (UCHAR) 0x1F);
+   ret_data = (RD_HARPOON(p_port+hp_scsidata_0) & (unsigned char) 0x1F);
 
    curr_data |= BIT(6);
 
@@ -6173,9 +6172,9 @@ static UCHAR FPT_scxferc(ULONG p_port, U
  *
  *---------------------------------------------------------------------*/
 
-static UCHAR FPT_scsendi(ULONG p_port, UCHAR p_id_string[])
+static unsigned char FPT_scsendi(ULONG p_port, unsigned char p_id_string[])
 {
-   UCHAR ret_data,byte_cnt,bit_cnt,defer;
+   unsigned char ret_data,byte_cnt,bit_cnt,defer;
 
    defer = 0;
 
@@ -6226,9 +6225,9 @@ static UCHAR FPT_scsendi(ULONG p_port, U
  *
  *---------------------------------------------------------------------*/
 
-static UCHAR FPT_sciso(ULONG p_port, UCHAR p_id_string[])
+static unsigned char FPT_sciso(ULONG p_port, unsigned char p_id_string[])
 {
-   UCHAR ret_data,the_data,byte_cnt,bit_cnt;
+   unsigned char ret_data,the_data,byte_cnt,bit_cnt;
 
    the_data = 0;
 
@@ -6287,9 +6286,9 @@ static UCHAR FPT_sciso(ULONG p_port, UCH
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_scwirod(ULONG p_port, UCHAR p_data_bit)
+static void FPT_scwirod(ULONG p_port, unsigned char p_data_bit)
 {
-   UCHAR i;
+   unsigned char i;
 
    i = 0;
    while ( i < MAX_SCSI_TAR ) {
@@ -6316,9 +6315,9 @@ static void FPT_scwirod(ULONG p_port, UC
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_scwiros(ULONG p_port, UCHAR p_data_bit)
+static void FPT_scwiros(ULONG p_port, unsigned char p_data_bit)
 {
-   UCHAR i;
+   unsigned char i;
 
    i = 0;
    while ( i < MAX_SCSI_TAR ) {
@@ -6343,9 +6342,9 @@ static void FPT_scwiros(ULONG p_port, UC
  *
  *---------------------------------------------------------------------*/
 
-static UCHAR FPT_scvalq(UCHAR p_quintet)
+static unsigned char FPT_scvalq(unsigned char p_quintet)
 {
-   UCHAR count;
+   unsigned char count;
 
    for (count=1; count < 0x08; count<<=1) {
       if (!(p_quintet & count))
@@ -6370,7 +6369,7 @@ static UCHAR FPT_scvalq(UCHAR p_quintet)
  *
  *---------------------------------------------------------------------*/
 
-static UCHAR FPT_scsell(ULONG p_port, UCHAR targ_id)
+static unsigned char FPT_scsell(ULONG p_port, unsigned char targ_id)
 {
    ULONG i;
 
@@ -6463,9 +6462,9 @@ static void FPT_scwtsel(ULONG p_port)
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_inisci(UCHAR p_card, ULONG p_port, UCHAR p_our_id)
+static void FPT_inisci(unsigned char p_card, ULONG p_port, unsigned char p_our_id)
 {
-   UCHAR i,k,max_id;
+   unsigned char i,k,max_id;
    USHORT ee_data;
 	PNVRamInfo pCurrNvRam;
 
@@ -6483,7 +6482,7 @@ static void FPT_inisci(UCHAR p_card, ULO
 			for(k = 0; k < 4; k++)
 				FPT_scamInfo[i].id_string[k] = pCurrNvRam->niScamTbl[i][k];
 			for(k = 4; k < ID_STRING_LENGTH; k++)
-				FPT_scamInfo[i].id_string[k] = (UCHAR) 0x00;
+				FPT_scamInfo[i].id_string[k] = (unsigned char) 0x00;
 
 	      if(FPT_scamInfo[i].id_string[0] == 0x00)
       	   FPT_scamInfo[i].state = ID_UNUSED;  /*Default to unused ID. */
@@ -6498,9 +6497,9 @@ static void FPT_inisci(UCHAR p_card, ULO
 	         {
    	      ee_data = FPT_utilEERead(p_port, (USHORT)((EE_SCAMBASE/2) +
       	     (USHORT) (i*((USHORT)ID_STRING_LENGTH/2)) + (USHORT)(k/2)));
-         	FPT_scamInfo[i].id_string[k] = (UCHAR) ee_data;
+         	FPT_scamInfo[i].id_string[k] = (unsigned char) ee_data;
 	         ee_data >>= 8;
-   	      FPT_scamInfo[i].id_string[k+1] = (UCHAR) ee_data;
+   	      FPT_scamInfo[i].id_string[k+1] = (unsigned char) ee_data;
       	   }
 
 	      if ((FPT_scamInfo[i].id_string[0] == 0x00) ||
@@ -6527,10 +6526,10 @@ static void FPT_inisci(UCHAR p_card, ULO
  *
  *---------------------------------------------------------------------*/
 
-static UCHAR FPT_scmachid(UCHAR p_card, UCHAR p_id_string[])
+static unsigned char FPT_scmachid(unsigned char p_card, unsigned char p_id_string[])
 {
 
-   UCHAR i,k,match;
+   unsigned char i,k,match;
 
 
    for (i=0; i < MAX_SCSI_TAR; i++) {
@@ -6559,7 +6558,7 @@ static UCHAR FPT_scmachid(UCHAR p_card, 
       i = MAX_SCSI_TAR;
 
    if (((p_id_string[0] & 0x06) == 0x02) || ((p_id_string[0] & 0x06) == 0x04))
-      match = p_id_string[1] & (UCHAR) 0x1F;
+      match = p_id_string[1] & (unsigned char) 0x1F;
    else
       match = 7;
 
@@ -6608,7 +6607,7 @@ static UCHAR FPT_scmachid(UCHAR p_card, 
       i = MAX_SCSI_TAR;
 
    if (((p_id_string[0] & 0x06) == 0x02) || ((p_id_string[0] & 0x06) == 0x04))
-      match = p_id_string[1] & (UCHAR) 0x1F;
+      match = p_id_string[1] & (unsigned char) 0x1F;
    else
       match = 7;
 
@@ -6656,9 +6655,9 @@ static UCHAR FPT_scmachid(UCHAR p_card, 
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_scsavdi(UCHAR p_card, ULONG p_port)
+static void FPT_scsavdi(unsigned char p_card, ULONG p_port)
 {
-   UCHAR i,k,max_id;
+   unsigned char i,k,max_id;
    USHORT ee_data,sum_data;
 
 
@@ -6705,12 +6704,12 @@ static void FPT_scsavdi(UCHAR p_card, UL
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_XbowInit(ULONG port, UCHAR ScamFlg)
+static void FPT_XbowInit(ULONG port, unsigned char ScamFlg)
 {
-UCHAR i;
+unsigned char i;
 
 	i = RD_HARPOON(port+hp_page_ctrl);
-	WR_HARPOON(port+hp_page_ctrl, (UCHAR) (i | G_INT_DISABLE));
+	WR_HARPOON(port+hp_page_ctrl, (unsigned char) (i | G_INT_DISABLE));
 
    WR_HARPOON(port+hp_scsireset,0x00);
    WR_HARPOON(port+hp_portctrl_1,HOST_MODE8);
@@ -6812,7 +6811,7 @@ static void FPT_DiagEEPROM(ULONG p_port)
       }
 
 
-   FPT_utilEEWriteOnOff(p_port,(UCHAR)1);
+   FPT_utilEEWriteOnOff(p_port,(unsigned char)1);
 
    for (index = 0; index < max_wd_cnt; index++) {
 
@@ -6933,7 +6932,7 @@ static void FPT_DiagEEPROM(ULONG p_port)
 
    FPT_utilEEWrite(p_port, temp, EEPROM_CHECK_SUM/2);
 
-   FPT_utilEEWriteOnOff(p_port,(UCHAR)0);
+   FPT_utilEEWriteOnOff(p_port,(unsigned char)0);
 
 }
 
@@ -6946,9 +6945,9 @@ static void FPT_DiagEEPROM(ULONG p_port)
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_queueSearchSelect(PSCCBcard pCurrCard, UCHAR p_card)
+static void FPT_queueSearchSelect(PSCCBcard pCurrCard, unsigned char p_card)
 {
-   UCHAR scan_ptr, lun;
+   unsigned char scan_ptr, lun;
    PSCCBMgr_tar_info currTar_Info;
 	PSCCB pOldSccb;
 
@@ -7077,14 +7076,14 @@ static void FPT_queueSearchSelect(PSCCBc
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_queueSelectFail(PSCCBcard pCurrCard, UCHAR p_card)
+static void FPT_queueSelectFail(PSCCBcard pCurrCard, unsigned char p_card)
 {
-   UCHAR thisTarg;
+   unsigned char thisTarg;
    PSCCBMgr_tar_info currTar_Info;
 
    if (pCurrCard->currentSCCB != NULL)
 	  {
-	  thisTarg = (UCHAR)(((PSCCB)(pCurrCard->currentSCCB))->TargID);
+	  thisTarg = (unsigned char)(((PSCCB)(pCurrCard->currentSCCB))->TargID);
       currTar_Info = &FPT_sccbMgrTbl[p_card][thisTarg];
 
       pCurrCard->currentSCCB->Sccb_backlink = (PSCCB)NULL;
@@ -7117,10 +7116,10 @@ static void FPT_queueSelectFail(PSCCBcar
  *---------------------------------------------------------------------*/
 
 static void FPT_queueCmdComplete(PSCCBcard pCurrCard, PSCCB p_sccb,
-				 UCHAR p_card)
+				 unsigned char p_card)
 {
 
-   UCHAR i, SCSIcmd;
+   unsigned char i, SCSIcmd;
    CALL_BK_FN callback;
    PSCCBMgr_tar_info currTar_Info;
 
@@ -7218,7 +7217,7 @@ static void FPT_queueCmdComplete(PSCCBca
  * Description: Add SCCB to our disconnect array.
  *
  *---------------------------------------------------------------------*/
-static void FPT_queueDisconnect(PSCCB p_sccb, UCHAR p_card)
+static void FPT_queueDisconnect(PSCCB p_sccb, unsigned char p_card)
 {
    PSCCBMgr_tar_info currTar_Info;
 
@@ -7253,16 +7252,16 @@ static void FPT_queueDisconnect(PSCCB p_
  *
  *---------------------------------------------------------------------*/
 
-static void  FPT_queueFlushSccb(UCHAR p_card, UCHAR error_code)
+static void  FPT_queueFlushSccb(unsigned char p_card, unsigned char error_code)
 {
-   UCHAR qtag,thisTarg;
+   unsigned char qtag,thisTarg;
    PSCCB currSCCB;
    PSCCBMgr_tar_info currTar_Info;
 
    currSCCB = FPT_BL_Card[p_card].currentSCCB;
 	if(currSCCB != NULL)
 	{
-	   thisTarg = (UCHAR)currSCCB->TargID;
+	   thisTarg = (unsigned char)currSCCB->TargID;
    	currTar_Info = &FPT_sccbMgrTbl[p_card][thisTarg];
 
 	   for (qtag=0; qtag<QUEUE_DEPTH; qtag++) {
@@ -7271,7 +7270,7 @@ static void  FPT_queueFlushSccb(UCHAR p_
 					(FPT_BL_Card[p_card].discQ_Tbl[qtag]->TargID == thisTarg))
 			 {
 
-			 FPT_BL_Card[p_card].discQ_Tbl[qtag]->HostStatus = (UCHAR)error_code;
+			 FPT_BL_Card[p_card].discQ_Tbl[qtag]->HostStatus = (unsigned char)error_code;
 			
 			 FPT_queueCmdComplete(&FPT_BL_Card[p_card],FPT_BL_Card[p_card].discQ_Tbl[qtag], p_card);
 
@@ -7292,10 +7291,10 @@ static void  FPT_queueFlushSccb(UCHAR p_
  *
  *---------------------------------------------------------------------*/
 
-static void  FPT_queueFlushTargSccb(UCHAR p_card, UCHAR thisTarg,
-				    UCHAR error_code)
+static void  FPT_queueFlushTargSccb(unsigned char p_card, unsigned char thisTarg,
+				    unsigned char error_code)
 {
-   UCHAR qtag;
+   unsigned char qtag;
    PSCCBMgr_tar_info currTar_Info;
 
    currTar_Info = &FPT_sccbMgrTbl[p_card][thisTarg];
@@ -7306,7 +7305,7 @@ static void  FPT_queueFlushTargSccb(UCHA
 				(FPT_BL_Card[p_card].discQ_Tbl[qtag]->TargID == thisTarg))
 		 {
 
-		 FPT_BL_Card[p_card].discQ_Tbl[qtag]->HostStatus = (UCHAR)error_code;
+		 FPT_BL_Card[p_card].discQ_Tbl[qtag]->HostStatus = (unsigned char)error_code;
 
 		 FPT_queueCmdComplete(&FPT_BL_Card[p_card],FPT_BL_Card[p_card].discQ_Tbl[qtag], p_card);
 
@@ -7322,7 +7321,7 @@ static void  FPT_queueFlushTargSccb(UCHA
 
 
 
-static void FPT_queueAddSccb(PSCCB p_SCCB, UCHAR p_card)
+static void FPT_queueAddSccb(PSCCB p_SCCB, unsigned char p_card)
 {
    PSCCBMgr_tar_info currTar_Info;
    currTar_Info = &FPT_sccbMgrTbl[p_card][p_SCCB->TargID];
@@ -7356,7 +7355,7 @@ static void FPT_queueAddSccb(PSCCB p_SCC
  *
  *---------------------------------------------------------------------*/
 
-static UCHAR FPT_queueFindSccb(PSCCB p_SCCB, UCHAR p_card)
+static unsigned char FPT_queueFindSccb(PSCCB p_SCCB, unsigned char p_card)
 {
    PSCCB q_ptr;
    PSCCBMgr_tar_info currTar_Info;
@@ -7469,7 +7468,7 @@ static void  FPT_utilUpdateResidual(PSCC
 
 static void FPT_Wait1Second(ULONG p_port)
 {
-   UCHAR i;
+   unsigned char i;
 
    for(i=0; i < 4; i++) {
 
@@ -7492,10 +7491,10 @@ static void FPT_Wait1Second(ULONG p_port
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_Wait(ULONG p_port, UCHAR p_delay)
+static void FPT_Wait(ULONG p_port, unsigned char p_delay)
 {
-   UCHAR old_timer;
-   UCHAR green_flag;
+   unsigned char old_timer;
+   unsigned char green_flag;
 
    old_timer = RD_HARPOON(p_port+hp_seltimeout);
 
@@ -7540,11 +7539,11 @@ static void FPT_Wait(ULONG p_port, UCHAR
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_utilEEWriteOnOff(ULONG p_port,UCHAR p_mode)
+static void FPT_utilEEWriteOnOff(ULONG p_port,unsigned char p_mode)
 {
-   UCHAR ee_value;
+   unsigned char ee_value;
 
-   ee_value = (UCHAR)(RD_HARPOON(p_port+hp_ee_ctrl) & (EXT_ARB_ACK | SCSI_TERM_ENA_H));
+   ee_value = (unsigned char)(RD_HARPOON(p_port+hp_ee_ctrl) & (EXT_ARB_ACK | SCSI_TERM_ENA_H));
 
    if (p_mode)
 
@@ -7572,10 +7571,10 @@ static void FPT_utilEEWriteOnOff(ULONG p
 static void FPT_utilEEWrite(ULONG p_port, USHORT ee_data, USHORT ee_addr)
 {
 
-   UCHAR ee_value;
+   unsigned char ee_value;
    USHORT i;
 
-   ee_value = (UCHAR)((RD_HARPOON(p_port+hp_ee_ctrl) & (EXT_ARB_ACK | SCSI_TERM_ENA_H))|
+   ee_value = (unsigned char)((RD_HARPOON(p_port+hp_ee_ctrl) & (EXT_ARB_ACK | SCSI_TERM_ENA_H))|
 		   (SEE_MS | SEE_CS));
 
 
@@ -7653,10 +7652,10 @@ static USHORT FPT_utilEERead(ULONG p_por
 static USHORT FPT_utilEEReadOrg(ULONG p_port, USHORT ee_addr)
 {
 
-   UCHAR ee_value;
+   unsigned char ee_value;
    USHORT i, ee_data;
 
-   ee_value = (UCHAR)((RD_HARPOON(p_port+hp_ee_ctrl) & (EXT_ARB_ACK | SCSI_TERM_ENA_H))|
+   ee_value = (unsigned char)((RD_HARPOON(p_port+hp_ee_ctrl) & (EXT_ARB_ACK | SCSI_TERM_ENA_H))|
 		   (SEE_MS | SEE_CS));
 
 
@@ -7698,15 +7697,15 @@ static USHORT FPT_utilEEReadOrg(ULONG p_
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_utilEESendCmdAddr(ULONG p_port, UCHAR ee_cmd, USHORT ee_addr)
+static void FPT_utilEESendCmdAddr(ULONG p_port, unsigned char ee_cmd, USHORT ee_addr)
 {
-   UCHAR ee_value;
-   UCHAR narrow_flg;
+   unsigned char ee_value;
+   unsigned char narrow_flg;
 
    USHORT i;
 
 
-   narrow_flg= (UCHAR)(RD_HARPOON(p_port+hp_page_ctrl) & NARROW_SCSI_CARD);
+   narrow_flg= (unsigned char)(RD_HARPOON(p_port+hp_page_ctrl) & NARROW_SCSI_CARD);
 
 
    ee_value = SEE_MS;
@@ -7761,7 +7760,7 @@ static void FPT_utilEESendCmdAddr(ULONG 
 	  }
 }
 
-static USHORT FPT_CalcCrc16(UCHAR buffer[])
+static USHORT FPT_CalcCrc16(unsigned char buffer[])
 {
    USHORT crc=0;
 	int i,j;
@@ -7781,10 +7780,10 @@ static USHORT FPT_CalcCrc16(UCHAR buffer
 	return(crc);
 }
 
-static UCHAR FPT_CalcLrc(UCHAR buffer[])
+static unsigned char FPT_CalcLrc(unsigned char buffer[])
 {
 	int i;
-	UCHAR lrc;
+	unsigned char lrc;
 	lrc = 0;
 	for(i = 0; i < ID_STRING_LENGTH; i++)
 		lrc ^= buffer[i];
_
