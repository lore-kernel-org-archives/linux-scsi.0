From: Khalid Aziz <khalid.aziz@oracle.com>
Subject: [PATCH 2/2] scsi: 64-bit port of buslogic driver
Date: Thu, 16 May 2013 12:27:59 -0600
Message-ID: <63dc1592d3c0c7f3914144dea7cc00c9f5a5c6f8.1368725030.git.khalid.aziz@oracle.com>
References: <cover.1368725030.git.khalid.aziz@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:35911 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752299Ab3EPSfM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 May 2013 14:35:12 -0400
In-Reply-To: <cover.1368725030.git.khalid.aziz@oracle.com>
In-Reply-To: <cover.1368725030.git.khalid.aziz@oracle.com>
References: <cover.1368725030.git.khalid.aziz@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: Khalid Aziz <khalid.aziz@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Khalid Aziz <khalid@gonehiking.org>

Port buslogic driver to 64-bit.

Signed-off-by: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Khalid Aziz <khalid@gonehiking.org>
---
 drivers/scsi/BusLogic.c   |    7 +-
 drivers/scsi/BusLogic.h   |   43 ++--
 drivers/scsi/FlashPoint.c |  618 +++++++++++++++++++++------------------------
 drivers/scsi/Kconfig      |    2 +-
 4 files changed, 309 insertions(+), 361 deletions(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index b6d6ac1..625ec07 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -1203,7 +1203,7 @@ static bool blogic_hwreset(struct blogic_adapter *adapter, bool hard_reset)
 		fpinfo->report_underrun = true;
 		adapter->cardhandle =
 			FlashPoint_HardwareResetHostAdapter(fpinfo);
-		if (adapter->cardhandle == FPOINT_BADCARD_HANDLE)
+		if (adapter->cardhandle == (void *)FPOINT_BADCARD_HANDLE)
 			return false;
 		/*
 		   Indicate the Host Adapter Hard Reset completed successfully.
@@ -2360,8 +2360,7 @@ static int __init blogic_init(void)
 		return -ENOMEM;
 	}
 
-	adapter =
-	    kzalloc(sizeof(struct blogic_adapter), GFP_KERNEL);
+	adapter = kzalloc(sizeof(struct blogic_adapter), GFP_KERNEL);
 	if (adapter == NULL) {
 		kfree(blogic_probeinfo_list);
 		blogic_err("BusLogic: Unable to allocate Prototype Host Adapter\n", NULL);
@@ -3069,7 +3068,7 @@ static int blogic_qcmd_lck(struct scsi_cmnd *command,
 		if (blogic_multimaster_type(adapter))
 			ccb->data = (unsigned int) ccb->dma_handle + ((unsigned long) &ccb->sglist - (unsigned long) ccb);
 		else
-			ccb->data = virt_to_32bit_virt(ccb->sglist);
+			ccb->data = ccb->sglist;
 
 		scsi_for_each_sg(command, sg, count, i) {
 			ccb->sglist[i].segbytes = sg_dma_len(sg);
diff --git a/drivers/scsi/BusLogic.h b/drivers/scsi/BusLogic.h
index ef7b280..b089756 100644
--- a/drivers/scsi/BusLogic.h
+++ b/drivers/scsi/BusLogic.h
@@ -821,7 +821,7 @@ struct blogic_ccb {
 	unsigned char cdblen;				/* Byte 2 */
 	unsigned char sense_datalen;			/* Byte 3 */
 	u32 datalen;					/* Bytes 4-7 */
-	u32 data;					/* Bytes 8-11 */
+	void *data;					/* Bytes 8-11 */
 	unsigned char:8;				/* Byte 12 */
 	unsigned char:8;				/* Byte 13 */
 	enum blogic_adapter_status adapter_status;	/* Byte 14 */
@@ -833,7 +833,7 @@ struct blogic_ccb {
 	unsigned char cdb[BLOGIC_CDB_MAXLEN];		/* Bytes 18-29 */
 	unsigned char:8;				/* Byte 30 */
 	unsigned char:8;				/* Byte 31 */
-	unsigned int:32;				/* Bytes 32-35 */
+	u32 rsvd_int;					/* Bytes 32-35 */
 	u32 sensedata;					/* Bytes 36-39 */
 	/*
 	   FlashPoint SCCB Manager Defined Portion.
@@ -843,8 +843,11 @@ struct blogic_ccb {
 	enum blogic_cmplt_code comp_code;		/* Byte 48 */
 #ifdef CONFIG_SCSI_FLASHPOINT
 	unsigned char:8;				/* Byte 49 */
-	unsigned short os_flags;			/* Bytes 50-51 */
-	unsigned char private[48];			/* Bytes 52-99 */
+	u16 os_flags;					/* Bytes 50-51 */
+	unsigned char private[24];			/* Bytes 52-99 */
+	void *rsvd1;
+	void *rsvd2;
+	unsigned char private2[16];
 #endif
 	/*
 	   BusLogic Linux Driver Defined Portion.
@@ -867,7 +870,7 @@ struct blogic_ccb {
 
 struct blogic_outbox {
 	u32 ccb;			/* Bytes 0-3 */
-	unsigned int:24;		/* Bytes 4-6 */
+	u32:24;				/* Bytes 4-6 */
 	enum blogic_action action;	/* Byte 7 */
 };
 
@@ -876,11 +879,11 @@ struct blogic_outbox {
 */
 
 struct blogic_inbox {
-	u32 ccb;		/* Bytes 0-3 */
+	u32 ccb;					/* Bytes 0-3 */
 	enum blogic_adapter_status adapter_status;	/* Byte 4 */
-	enum blogic_tgt_status tgt_status;	/* Byte 5 */
-	unsigned char:8;	/* Byte 6 */
-	enum blogic_cmplt_code comp_code;	/* Byte 7 */
+	enum blogic_tgt_status tgt_status;		/* Byte 5 */
+	unsigned char:8;				/* Byte 6 */
+	enum blogic_cmplt_code comp_code;		/* Byte 7 */
 };
 
 
@@ -941,7 +944,7 @@ struct blogic_tgt_stats {
   Define the FlashPoint Card Handle data type.
 */
 
-#define FPOINT_BADCARD_HANDLE		0xFFFFFFFF
+#define FPOINT_BADCARD_HANDLE		0xFFFFFFFFL
 
 
 /*
@@ -955,12 +958,12 @@ struct fpoint_info {
 	unsigned char irq_ch;			/* Byte 5 */
 	unsigned char scsi_id;			/* Byte 6 */
 	unsigned char scsi_lun;			/* Byte 7 */
-	unsigned short fw_rev;			/* Bytes 8-9 */
-	unsigned short sync_ok;			/* Bytes 10-11 */
-	unsigned short fast_ok;			/* Bytes 12-13 */
-	unsigned short ultra_ok;		/* Bytes 14-15 */
-	unsigned short discon_ok;		/* Bytes 16-17 */
-	unsigned short wide_ok;			/* Bytes 18-19 */
+	u16 fw_rev;				/* Bytes 8-9 */
+	u16 sync_ok;				/* Bytes 10-11 */
+	u16 fast_ok;				/* Bytes 12-13 */
+	u16 ultra_ok;				/* Bytes 14-15 */
+	u16 discon_ok;				/* Bytes 16-17 */
+	u16 wide_ok;				/* Bytes 18-19 */
 	bool parity:1;				/* Byte 20 Bit 0 */
 	bool wide:1;				/* Byte 20 Bit 1 */
 	bool softreset:1;			/* Byte 20 Bit 2 */
@@ -976,10 +979,10 @@ struct fpoint_info {
 	unsigned char model[3];			/* Bytes 24-26 */
 	unsigned char relative_cardnum;		/* Byte 27 */
 	unsigned char rsvd[4];			/* Bytes 28-31 */
-	unsigned int os_rsvd;			/* Bytes 32-35 */
+	u32 os_rsvd;				/* Bytes 32-35 */
 	unsigned char translation_info[4];	/* Bytes 36-39 */
-	unsigned int rsvd2[5];			/* Bytes 40-59 */
-	unsigned int sec_range;			/* Bytes 60-63 */
+	u32 rsvd2[5];				/* Bytes 40-59 */
+	u32 sec_range;				/* Bytes 60-63 */
 };
 
 /*
@@ -1052,7 +1055,7 @@ struct blogic_adapter {
 	u32 bios_addr;
 	struct blogic_drvr_options *drvr_opts;
 	struct fpoint_info fpinfo;
-	unsigned int cardhandle;
+	void *cardhandle;
 	struct list_head host_list;
 	struct blogic_ccb *all_ccbs;
 	struct blogic_ccb *free_ccbs;
diff --git a/drivers/scsi/FlashPoint.c b/drivers/scsi/FlashPoint.c
index 9029720..64ed8cc 100644
--- a/drivers/scsi/FlashPoint.c
+++ b/drivers/scsi/FlashPoint.c
@@ -29,27 +29,27 @@ struct sccb;
 typedef void (*CALL_BK_FN) (struct sccb *);
 
 struct sccb_mgr_info {
-	unsigned long si_baseaddr;
+	u32 si_baseaddr;
 	unsigned char si_present;
 	unsigned char si_intvect;
 	unsigned char si_id;
 	unsigned char si_lun;
-	unsigned short si_fw_revision;
-	unsigned short si_per_targ_init_sync;
-	unsigned short si_per_targ_fast_nego;
-	unsigned short si_per_targ_ultra_nego;
-	unsigned short si_per_targ_no_disc;
-	unsigned short si_per_targ_wide_nego;
-	unsigned short si_flags;
+	u16 si_fw_revision;
+	u16 si_per_targ_init_sync;
+	u16 si_per_targ_fast_nego;
+	u16 si_per_targ_ultra_nego;
+	u16 si_per_targ_no_disc;
+	u16 si_per_targ_wide_nego;
+	u16 si_flags;
 	unsigned char si_card_family;
 	unsigned char si_bustype;
 	unsigned char si_card_model[3];
 	unsigned char si_relative_cardnum;
 	unsigned char si_reserved[4];
-	unsigned long si_OS_reserved;
+	u32 si_OS_reserved;
 	unsigned char si_XlatInfo[4];
-	unsigned long si_reserved2[5];
-	unsigned long si_secondary_range;
+	u32 si_reserved2[5];
+	u32 si_secondary_range;
 };
 
 #define SCSI_PARITY_ENA		  0x0001
@@ -70,14 +70,14 @@ struct sccb_mgr_info {
  * The UCB Manager treats the SCCB as it's 'native hardware structure' 
  */
 
-#pragma pack(1)
+/*#pragma pack(1)*/
 struct sccb {
 	unsigned char OperationCode;
 	unsigned char ControlByte;
 	unsigned char CdbLength;
 	unsigned char RequestSenseLength;
-	unsigned long DataLength;
-	unsigned long DataPointer;
+	u32 DataLength;
+	void *DataPointer;
 	unsigned char CcbRes[2];
 	unsigned char HostStatus;
 	unsigned char TargetStatus;
@@ -86,32 +86,32 @@ struct sccb {
 	unsigned char Cdb[12];
 	unsigned char CcbRes1;
 	unsigned char Reserved1;
-	unsigned long Reserved2;
-	unsigned long SensePointer;
+	u32 Reserved2;
+	u32 SensePointer;
 
 	CALL_BK_FN SccbCallback;	/* VOID (*SccbCallback)(); */
-	unsigned long SccbIOPort;	/* Identifies board base port */
+	u32 SccbIOPort;			/* Identifies board base port */
 	unsigned char SccbStatus;
 	unsigned char SCCBRes2;
-	unsigned short SccbOSFlags;
-
-	unsigned long Sccb_XferCnt;	/* actual transfer count */
-	unsigned long Sccb_ATC;
-	unsigned long SccbVirtDataPtr;	/* virtual addr for OS/2 */
-	unsigned long Sccb_res1;
-	unsigned short Sccb_MGRFlags;
-	unsigned short Sccb_sgseg;
+	u16 SccbOSFlags;
+
+	u32 Sccb_XferCnt;	/* actual transfer count */
+	u32 Sccb_ATC;
+	u32 SccbVirtDataPtr;	/* virtual addr for OS/2 */
+	u32 Sccb_res1;
+	u16 Sccb_MGRFlags;
+	u16 Sccb_sgseg;
 	unsigned char Sccb_scsimsg;	/* identify msg for selection */
 	unsigned char Sccb_tag;
 	unsigned char Sccb_scsistat;
 	unsigned char Sccb_idmsg;	/* image of last msg in */
 	struct sccb *Sccb_forwardlink;
 	struct sccb *Sccb_backlink;
-	unsigned long Sccb_savedATC;
+	u32 Sccb_savedATC;
 	unsigned char Save_Cdb[6];
 	unsigned char Save_CdbLen;
 	unsigned char Sccb_XferState;
-	unsigned long Sccb_SGoffset;
+	u32 Sccb_SGoffset;
 };
 
 #pragma pack()
@@ -223,15 +223,21 @@ struct sccb_mgr_tar_info {
 };
 
 struct nvram_info {
-	unsigned char niModel;	/* Model No. of card */
-	unsigned char niCardNo;	/* Card no. */
-	unsigned long niBaseAddr;	/* Port Address of card */
-	unsigned char niSysConf;	/* Adapter Configuration byte - Byte 16 of eeprom map */
-	unsigned char niScsiConf;	/* SCSI Configuration byte - Byte 17 of eeprom map */
-	unsigned char niScamConf;	/* SCAM Configuration byte - Byte 20 of eeprom map */
-	unsigned char niAdapId;	/* Host Adapter ID - Byte 24 of eerpom map */
-	unsigned char niSyncTbl[MAX_SCSI_TAR / 2];	/* Sync/Wide byte of targets */
-	unsigned char niScamTbl[MAX_SCSI_TAR][4];	/* Compressed Scam name string of Targets */
+	unsigned char niModel;		/* Model No. of card */
+	unsigned char niCardNo;		/* Card no. */
+	u32 niBaseAddr;			/* Port Address of card */
+	unsigned char niSysConf;	/* Adapter Configuration byte -
+					   Byte 16 of eeprom map */
+	unsigned char niScsiConf;	/* SCSI Configuration byte -
+					   Byte 17 of eeprom map */
+	unsigned char niScamConf;	/* SCAM Configuration byte -
+					   Byte 20 of eeprom map */
+	unsigned char niAdapId;		/* Host Adapter ID -
+					   Byte 24 of eerpom map */
+	unsigned char niSyncTbl[MAX_SCSI_TAR / 2];	/* Sync/Wide byte
+							   of targets */
+	unsigned char niScamTbl[MAX_SCSI_TAR][4];	/* Compressed Scam name
+							   string of Targets */
 };
 
 #define	MODEL_LT		1
@@ -243,7 +249,7 @@ struct sccb_card {
 	struct sccb *currentSCCB;
 	struct sccb_mgr_info *cardInfo;
 
-	unsigned long ioPort;
+	u32 ioPort;
 
 	unsigned short cmdCounter;
 	unsigned char discQCount;
@@ -780,37 +786,37 @@ typedef struct SCCBscam_info {
 #define MENABLE_INT(p_port) (WR_HARPOON(p_port+hp_page_ctrl, \
                              (RD_HARPOON(p_port+hp_page_ctrl) & ~G_INT_DISABLE)))
 
-static unsigned char FPT_sisyncn(unsigned long port, unsigned char p_card,
+static unsigned char FPT_sisyncn(u32 port, unsigned char p_card,
 				 unsigned char syncFlag);
-static void FPT_ssel(unsigned long port, unsigned char p_card);
-static void FPT_sres(unsigned long port, unsigned char p_card,
+static void FPT_ssel(u32 port, unsigned char p_card);
+static void FPT_sres(u32 port, unsigned char p_card,
 		     struct sccb_card *pCurrCard);
-static void FPT_shandem(unsigned long port, unsigned char p_card,
+static void FPT_shandem(u32 port, unsigned char p_card,
 			struct sccb *pCurrSCCB);
-static void FPT_stsyncn(unsigned long port, unsigned char p_card);
-static void FPT_sisyncr(unsigned long port, unsigned char sync_pulse,
+static void FPT_stsyncn(u32 port, unsigned char p_card);
+static void FPT_sisyncr(u32 port, unsigned char sync_pulse,
 			unsigned char offset);
-static void FPT_sssyncv(unsigned long p_port, unsigned char p_id,
+static void FPT_sssyncv(u32 p_port, unsigned char p_id,
 			unsigned char p_sync_value,
 			struct sccb_mgr_tar_info *currTar_Info);
-static void FPT_sresb(unsigned long port, unsigned char p_card);
-static void FPT_sxfrp(unsigned long p_port, unsigned char p_card);
-static void FPT_schkdd(unsigned long port, unsigned char p_card);
-static unsigned char FPT_RdStack(unsigned long port, unsigned char index);
-static void FPT_WrStack(unsigned long portBase, unsigned char index,
+static void FPT_sresb(u32 port, unsigned char p_card);
+static void FPT_sxfrp(u32 p_port, unsigned char p_card);
+static void FPT_schkdd(u32 port, unsigned char p_card);
+static unsigned char FPT_RdStack(u32 port, unsigned char index);
+static void FPT_WrStack(u32 portBase, unsigned char index,
 			unsigned char data);
-static unsigned char FPT_ChkIfChipInitialized(unsigned long ioPort);
+static unsigned char FPT_ChkIfChipInitialized(u32 ioPort);
 
-static void FPT_SendMsg(unsigned long port, unsigned char message);
+static void FPT_SendMsg(u32 port, unsigned char message);
 static void FPT_queueFlushTargSccb(unsigned char p_card, unsigned char thisTarg,
 				   unsigned char error_code);
 
 static void FPT_sinits(struct sccb *p_sccb, unsigned char p_card);
 static void FPT_RNVRamData(struct nvram_info *pNvRamInfo);
 
-static unsigned char FPT_siwidn(unsigned long port, unsigned char p_card);
-static void FPT_stwidn(unsigned long port, unsigned char p_card);
-static void FPT_siwidr(unsigned long port, unsigned char width);
+static unsigned char FPT_siwidn(u32 port, unsigned char p_card);
+static void FPT_stwidn(u32 port, unsigned char p_card);
+static void FPT_siwidr(u32 port, unsigned char width);
 
 static void FPT_queueSelectFail(struct sccb_card *pCurrCard,
 				unsigned char p_card);
@@ -827,45 +833,45 @@ static void FPT_utilUpdateResidual(struct sccb *p_SCCB);
 static unsigned short FPT_CalcCrc16(unsigned char buffer[]);
 static unsigned char FPT_CalcLrc(unsigned char buffer[]);
 
-static void FPT_Wait1Second(unsigned long p_port);
-static void FPT_Wait(unsigned long p_port, unsigned char p_delay);
-static void FPT_utilEEWriteOnOff(unsigned long p_port, unsigned char p_mode);
-static void FPT_utilEEWrite(unsigned long p_port, unsigned short ee_data,
+static void FPT_Wait1Second(u32 p_port);
+static void FPT_Wait(u32 p_port, unsigned char p_delay);
+static void FPT_utilEEWriteOnOff(u32 p_port, unsigned char p_mode);
+static void FPT_utilEEWrite(u32 p_port, unsigned short ee_data,
 			    unsigned short ee_addr);
-static unsigned short FPT_utilEERead(unsigned long p_port,
+static unsigned short FPT_utilEERead(u32 p_port,
 				     unsigned short ee_addr);
-static unsigned short FPT_utilEEReadOrg(unsigned long p_port,
+static unsigned short FPT_utilEEReadOrg(u32 p_port,
 					unsigned short ee_addr);
-static void FPT_utilEESendCmdAddr(unsigned long p_port, unsigned char ee_cmd,
+static void FPT_utilEESendCmdAddr(u32 p_port, unsigned char ee_cmd,
 				  unsigned short ee_addr);
 
-static void FPT_phaseDataOut(unsigned long port, unsigned char p_card);
-static void FPT_phaseDataIn(unsigned long port, unsigned char p_card);
-static void FPT_phaseCommand(unsigned long port, unsigned char p_card);
-static void FPT_phaseStatus(unsigned long port, unsigned char p_card);
-static void FPT_phaseMsgOut(unsigned long port, unsigned char p_card);
-static void FPT_phaseMsgIn(unsigned long port, unsigned char p_card);
-static void FPT_phaseIllegal(unsigned long port, unsigned char p_card);
+static void FPT_phaseDataOut(u32 port, unsigned char p_card);
+static void FPT_phaseDataIn(u32 port, unsigned char p_card);
+static void FPT_phaseCommand(u32 port, unsigned char p_card);
+static void FPT_phaseStatus(u32 port, unsigned char p_card);
+static void FPT_phaseMsgOut(u32 port, unsigned char p_card);
+static void FPT_phaseMsgIn(u32 port, unsigned char p_card);
+static void FPT_phaseIllegal(u32 port, unsigned char p_card);
 
-static void FPT_phaseDecode(unsigned long port, unsigned char p_card);
-static void FPT_phaseChkFifo(unsigned long port, unsigned char p_card);
-static void FPT_phaseBusFree(unsigned long p_port, unsigned char p_card);
+static void FPT_phaseDecode(u32 port, unsigned char p_card);
+static void FPT_phaseChkFifo(u32 port, unsigned char p_card);
+static void FPT_phaseBusFree(u32 p_port, unsigned char p_card);
 
-static void FPT_XbowInit(unsigned long port, unsigned char scamFlg);
-static void FPT_BusMasterInit(unsigned long p_port);
-static void FPT_DiagEEPROM(unsigned long p_port);
+static void FPT_XbowInit(u32 port, unsigned char scamFlg);
+static void FPT_BusMasterInit(u32 p_port);
+static void FPT_DiagEEPROM(u32 p_port);
 
-static void FPT_dataXferProcessor(unsigned long port,
+static void FPT_dataXferProcessor(u32 port,
 				  struct sccb_card *pCurrCard);
-static void FPT_busMstrSGDataXferStart(unsigned long port,
+static void FPT_busMstrSGDataXferStart(u32 port,
 				       struct sccb *pCurrSCCB);
-static void FPT_busMstrDataXferStart(unsigned long port,
+static void FPT_busMstrDataXferStart(u32 port,
 				     struct sccb *pCurrSCCB);
-static void FPT_hostDataXferAbort(unsigned long port, unsigned char p_card,
+static void FPT_hostDataXferAbort(u32 port, unsigned char p_card,
 				  struct sccb *pCurrSCCB);
 static void FPT_hostDataXferRestart(struct sccb *currSCCB);
 
-static unsigned char FPT_SccbMgr_bad_isr(unsigned long p_port,
+static unsigned char FPT_SccbMgr_bad_isr(u32 p_port,
 					 unsigned char p_card,
 					 struct sccb_card *pCurrCard,
 					 unsigned short p_int);
@@ -879,28 +885,28 @@ static void FPT_SccbMgrTableInitTarget(unsigned char p_card,
 static void FPT_scini(unsigned char p_card, unsigned char p_our_id,
 		      unsigned char p_power_up);
 
-static int FPT_scarb(unsigned long p_port, unsigned char p_sel_type);
-static void FPT_scbusf(unsigned long p_port);
-static void FPT_scsel(unsigned long p_port);
-static void FPT_scasid(unsigned char p_card, unsigned long p_port);
-static unsigned char FPT_scxferc(unsigned long p_port, unsigned char p_data);
-static unsigned char FPT_scsendi(unsigned long p_port,
+static int FPT_scarb(u32 p_port, unsigned char p_sel_type);
+static void FPT_scbusf(u32 p_port);
+static void FPT_scsel(u32 p_port);
+static void FPT_scasid(unsigned char p_card, u32 p_port);
+static unsigned char FPT_scxferc(u32 p_port, unsigned char p_data);
+static unsigned char FPT_scsendi(u32 p_port,
 				 unsigned char p_id_string[]);
-static unsigned char FPT_sciso(unsigned long p_port,
+static unsigned char FPT_sciso(u32 p_port,
 			       unsigned char p_id_string[]);
-static void FPT_scwirod(unsigned long p_port, unsigned char p_data_bit);
-static void FPT_scwiros(unsigned long p_port, unsigned char p_data_bit);
+static void FPT_scwirod(u32 p_port, unsigned char p_data_bit);
+static void FPT_scwiros(u32 p_port, unsigned char p_data_bit);
 static unsigned char FPT_scvalq(unsigned char p_quintet);
-static unsigned char FPT_scsell(unsigned long p_port, unsigned char targ_id);
-static void FPT_scwtsel(unsigned long p_port);
-static void FPT_inisci(unsigned char p_card, unsigned long p_port,
+static unsigned char FPT_scsell(u32 p_port, unsigned char targ_id);
+static void FPT_scwtsel(u32 p_port);
+static void FPT_inisci(unsigned char p_card, u32 p_port,
 		       unsigned char p_our_id);
-static void FPT_scsavdi(unsigned char p_card, unsigned long p_port);
+static void FPT_scsavdi(unsigned char p_card, u32 p_port);
 static unsigned char FPT_scmachid(unsigned char p_card,
 				  unsigned char p_id_string[]);
 
-static void FPT_autoCmdCmplt(unsigned long p_port, unsigned char p_card);
-static void FPT_autoLoadDefaultMap(unsigned long p_port);
+static void FPT_autoCmdCmplt(u32 p_port, unsigned char p_card);
+static void FPT_autoLoadDefaultMap(u32 p_port);
 
 static struct sccb_mgr_tar_info FPT_sccbMgrTbl[MAX_CARDS][MAX_SCSI_TAR] =
     { {{0}} };
@@ -918,7 +924,7 @@ static unsigned char FPT_scamHAString[] =
 
 static unsigned short FPT_default_intena = 0;
 
-static void (*FPT_s_PhaseTbl[8]) (unsigned long, unsigned char) = {
+static void (*FPT_s_PhaseTbl[8]) (u32, unsigned char) = {
 0};
 
 /*---------------------------------------------------------------------
@@ -935,7 +941,7 @@ static int FlashPoint_ProbeHostAdapter(struct sccb_mgr_info *pCardInfo)
 
 	unsigned char i, j, id, ScamFlg;
 	unsigned short temp, temp2, temp3, temp4, temp5, temp6;
-	unsigned long ioport;
+	u32 ioport;
 	struct nvram_info *pCurrNvRam;
 
 	ioport = pCardInfo->si_baseaddr;
@@ -1201,23 +1207,21 @@ static int FlashPoint_ProbeHostAdapter(struct sccb_mgr_info *pCardInfo)
  *
  *---------------------------------------------------------------------*/
 
-static unsigned long FlashPoint_HardwareResetHostAdapter(struct sccb_mgr_info
+static void *FlashPoint_HardwareResetHostAdapter(struct sccb_mgr_info
 							 *pCardInfo)
 {
 	struct sccb_card *CurrCard = NULL;
 	struct nvram_info *pCurrNvRam;
 	unsigned char i, j, thisCard, ScamFlg;
 	unsigned short temp, sync_bit_map, id;
-	unsigned long ioport;
+	u32 ioport;
 
 	ioport = pCardInfo->si_baseaddr;
 
 	for (thisCard = 0; thisCard <= MAX_CARDS; thisCard++) {
 
-		if (thisCard == MAX_CARDS) {
-
-			return FAILURE;
-		}
+		if (thisCard == MAX_CARDS)
+			return (void *)FAILURE;
 
 		if (FPT_BL_Card[thisCard].ioPort == ioport) {
 
@@ -1384,16 +1388,16 @@ static unsigned long FlashPoint_HardwareResetHostAdapter(struct sccb_mgr_info
 		   (unsigned char)(RD_HARPOON((ioport + hp_semaphore)) |
 				   SCCB_MGR_PRESENT));
 
-	return (unsigned long)CurrCard;
+	return (void *)CurrCard;
 }
 
-static void FlashPoint_ReleaseHostAdapter(unsigned long pCurrCard)
+static void FlashPoint_ReleaseHostAdapter(void *pCurrCard)
 {
 	unsigned char i;
-	unsigned long portBase;
-	unsigned long regOffset;
-	unsigned long scamData;
-	unsigned long *pScamTbl;
+	u32 portBase;
+	u32 regOffset;
+	u32 scamData;
+	u32 *pScamTbl;
 	struct nvram_info *pCurrNvRam;
 
 	pCurrNvRam = ((struct sccb_card *)pCurrCard)->pNvRamInfo;
@@ -1414,7 +1418,7 @@ static void FlashPoint_ReleaseHostAdapter(unsigned long pCurrCard)
 
 		for (i = 0; i < MAX_SCSI_TAR; i++) {
 			regOffset = hp_aramBase + 64 + i * 4;
-			pScamTbl = (unsigned long *)&pCurrNvRam->niScamTbl[i];
+			pScamTbl = (u32 *)&pCurrNvRam->niScamTbl[i];
 			scamData = *pScamTbl;
 			WR_HARP32(portBase, regOffset, scamData);
 		}
@@ -1427,10 +1431,10 @@ static void FlashPoint_ReleaseHostAdapter(unsigned long pCurrCard)
 static void FPT_RNVRamData(struct nvram_info *pNvRamInfo)
 {
 	unsigned char i;
-	unsigned long portBase;
-	unsigned long regOffset;
-	unsigned long scamData;
-	unsigned long *pScamTbl;
+	u32 portBase;
+	u32 regOffset;
+	u32 scamData;
+	u32 *pScamTbl;
 
 	pNvRamInfo->niModel = FPT_RdStack(pNvRamInfo->niBaseAddr, 0);
 	pNvRamInfo->niSysConf = FPT_RdStack(pNvRamInfo->niBaseAddr, 1);
@@ -1447,26 +1451,25 @@ static void FPT_RNVRamData(struct nvram_info *pNvRamInfo)
 	for (i = 0; i < MAX_SCSI_TAR; i++) {
 		regOffset = hp_aramBase + 64 + i * 4;
 		RD_HARP32(portBase, regOffset, scamData);
-		pScamTbl = (unsigned long *)&pNvRamInfo->niScamTbl[i];
+		pScamTbl = (u32 *)&pNvRamInfo->niScamTbl[i];
 		*pScamTbl = scamData;
 	}
 
 }
 
-static unsigned char FPT_RdStack(unsigned long portBase, unsigned char index)
+static unsigned char FPT_RdStack(u32 portBase, unsigned char index)
 {
 	WR_HARPOON(portBase + hp_stack_addr, index);
 	return RD_HARPOON(portBase + hp_stack_data);
 }
 
-static void FPT_WrStack(unsigned long portBase, unsigned char index,
-			unsigned char data)
+static void FPT_WrStack(u32 portBase, unsigned char index, unsigned char data)
 {
 	WR_HARPOON(portBase + hp_stack_addr, index);
 	WR_HARPOON(portBase + hp_stack_data, data);
 }
 
-static unsigned char FPT_ChkIfChipInitialized(unsigned long ioPort)
+static unsigned char FPT_ChkIfChipInitialized(u32 ioPort)
 {
 	if ((RD_HARPOON(ioPort + hp_arb_id) & 0x0f) != FPT_RdStack(ioPort, 4))
 		return 0;
@@ -1489,15 +1492,16 @@ static unsigned char FPT_ChkIfChipInitialized(unsigned long ioPort)
  *              callback function.
  *
  *---------------------------------------------------------------------*/
-static void FlashPoint_StartCCB(unsigned long pCurrCard, struct sccb *p_Sccb)
+static void FlashPoint_StartCCB(void *curr_card, struct sccb *p_Sccb)
 {
-	unsigned long ioport;
+	u32 ioport;
 	unsigned char thisCard, lun;
 	struct sccb *pSaveSccb;
 	CALL_BK_FN callback;
+	struct sccb_card *pCurrCard = curr_card;
 
-	thisCard = ((struct sccb_card *)pCurrCard)->cardIndex;
-	ioport = ((struct sccb_card *)pCurrCard)->ioPort;
+	thisCard = pCurrCard->cardIndex;
+	ioport = pCurrCard->ioPort;
 
 	if ((p_Sccb->TargID >= MAX_SCSI_TAR) || (p_Sccb->Lun >= MAX_LUN)) {
 
@@ -1512,18 +1516,18 @@ static void FlashPoint_StartCCB(unsigned long pCurrCard, struct sccb *p_Sccb)
 
 	FPT_sinits(p_Sccb, thisCard);
 
-	if (!((struct sccb_card *)pCurrCard)->cmdCounter) {
+	if (!pCurrCard->cmdCounter) {
 		WR_HARPOON(ioport + hp_semaphore,
 			   (RD_HARPOON(ioport + hp_semaphore)
 			    | SCCB_MGR_ACTIVE));
 
-		if (((struct sccb_card *)pCurrCard)->globalFlags & F_GREEN_PC) {
+		if (pCurrCard->globalFlags & F_GREEN_PC) {
 			WR_HARPOON(ioport + hp_clkctrl_0, CLKCTRL_DEFAULT);
 			WR_HARPOON(ioport + hp_sys_ctrl, 0x00);
 		}
 	}
 
-	((struct sccb_card *)pCurrCard)->cmdCounter++;
+	pCurrCard->cmdCounter++;
 
 	if (RD_HARPOON(ioport + hp_semaphore) & BIOS_IN_USE) {
 
@@ -1532,10 +1536,10 @@ static void FlashPoint_StartCCB(unsigned long pCurrCard, struct sccb *p_Sccb)
 			    | TICKLE_ME));
 		if (p_Sccb->OperationCode == RESET_COMMAND) {
 			pSaveSccb =
-			    ((struct sccb_card *)pCurrCard)->currentSCCB;
-			((struct sccb_card *)pCurrCard)->currentSCCB = p_Sccb;
+			    pCurrCard->currentSCCB;
+			pCurrCard->currentSCCB = p_Sccb;
 			FPT_queueSelectFail(&FPT_BL_Card[thisCard], thisCard);
-			((struct sccb_card *)pCurrCard)->currentSCCB =
+			pCurrCard->currentSCCB =
 			    pSaveSccb;
 		} else {
 			FPT_queueAddSccb(p_Sccb, thisCard);
@@ -1546,10 +1550,10 @@ static void FlashPoint_StartCCB(unsigned long pCurrCard, struct sccb *p_Sccb)
 
 		if (p_Sccb->OperationCode == RESET_COMMAND) {
 			pSaveSccb =
-			    ((struct sccb_card *)pCurrCard)->currentSCCB;
-			((struct sccb_card *)pCurrCard)->currentSCCB = p_Sccb;
+			    pCurrCard->currentSCCB;
+			pCurrCard->currentSCCB = p_Sccb;
 			FPT_queueSelectFail(&FPT_BL_Card[thisCard], thisCard);
-			((struct sccb_card *)pCurrCard)->currentSCCB =
+			pCurrCard->currentSCCB =
 			    pSaveSccb;
 		} else {
 			FPT_queueAddSccb(p_Sccb, thisCard);
@@ -1560,34 +1564,29 @@ static void FlashPoint_StartCCB(unsigned long pCurrCard, struct sccb *p_Sccb)
 
 		MDISABLE_INT(ioport);
 
-		if ((((struct sccb_card *)pCurrCard)->globalFlags & F_CONLUN_IO)
-		    &&
+		if ((pCurrCard->globalFlags & F_CONLUN_IO) &&
 		    ((FPT_sccbMgrTbl[thisCard][p_Sccb->TargID].
 		      TarStatus & TAR_TAG_Q_MASK) != TAG_Q_TRYING))
 			lun = p_Sccb->Lun;
 		else
 			lun = 0;
-		if ((((struct sccb_card *)pCurrCard)->currentSCCB == NULL) &&
+		if ((pCurrCard->currentSCCB == NULL) &&
 		    (FPT_sccbMgrTbl[thisCard][p_Sccb->TargID].TarSelQ_Cnt == 0)
 		    && (FPT_sccbMgrTbl[thisCard][p_Sccb->TargID].TarLUNBusy[lun]
 			== 0)) {
 
-			((struct sccb_card *)pCurrCard)->currentSCCB = p_Sccb;
+			pCurrCard->currentSCCB = p_Sccb;
 			FPT_ssel(p_Sccb->SccbIOPort, thisCard);
 		}
 
 		else {
 
 			if (p_Sccb->OperationCode == RESET_COMMAND) {
-				pSaveSccb =
-				    ((struct sccb_card *)pCurrCard)->
-				    currentSCCB;
-				((struct sccb_card *)pCurrCard)->currentSCCB =
-				    p_Sccb;
+				pSaveSccb = pCurrCard->currentSCCB;
+				pCurrCard->currentSCCB = p_Sccb;
 				FPT_queueSelectFail(&FPT_BL_Card[thisCard],
 						    thisCard);
-				((struct sccb_card *)pCurrCard)->currentSCCB =
-				    pSaveSccb;
+				pCurrCard->currentSCCB = pSaveSccb;
 			} else {
 				FPT_queueAddSccb(p_Sccb, thisCard);
 			}
@@ -1607,9 +1606,9 @@ static void FlashPoint_StartCCB(unsigned long pCurrCard, struct sccb *p_Sccb)
  *              callback function.
  *
  *---------------------------------------------------------------------*/
-static int FlashPoint_AbortCCB(unsigned long pCurrCard, struct sccb *p_Sccb)
+static int FlashPoint_AbortCCB(void *pCurrCard, struct sccb *p_Sccb)
 {
-	unsigned long ioport;
+	u32 ioport;
 
 	unsigned char thisCard;
 	CALL_BK_FN callback;
@@ -1715,9 +1714,9 @@ static int FlashPoint_AbortCCB(unsigned long pCurrCard, struct sccb *p_Sccb)
  *              interrupt for this card and disable the IRQ Pin if so.
  *
  *---------------------------------------------------------------------*/
-static unsigned char FlashPoint_InterruptPending(unsigned long pCurrCard)
+static unsigned char FlashPoint_InterruptPending(void *pCurrCard)
 {
-	unsigned long ioport;
+	u32 ioport;
 
 	ioport = ((struct sccb_card *)pCurrCard)->ioPort;
 
@@ -1739,38 +1738,36 @@ static unsigned char FlashPoint_InterruptPending(unsigned long pCurrCard)
  *              us.
  *
  *---------------------------------------------------------------------*/
-static int FlashPoint_HandleInterrupt(unsigned long pCurrCard)
+static int FlashPoint_HandleInterrupt(void *pcard)
 {
 	struct sccb *currSCCB;
 	unsigned char thisCard, result, bm_status, bm_int_st;
 	unsigned short hp_int;
 	unsigned char i, target;
-	unsigned long ioport;
+	struct sccb_card *pCurrCard = pcard;
+	u32 ioport;
 
-	thisCard = ((struct sccb_card *)pCurrCard)->cardIndex;
-	ioport = ((struct sccb_card *)pCurrCard)->ioPort;
+	thisCard = pCurrCard->cardIndex;
+	ioport = pCurrCard->ioPort;
 
 	MDISABLE_INT(ioport);
 
 	if ((bm_int_st = RD_HARPOON(ioport + hp_int_status)) & EXT_STATUS_ON)
-		bm_status =
-		    RD_HARPOON(ioport +
-			       hp_ext_status) & (unsigned char)BAD_EXT_STATUS;
+		bm_status = RD_HARPOON(ioport + hp_ext_status) &
+					(unsigned char)BAD_EXT_STATUS;
 	else
 		bm_status = 0;
 
 	WR_HARPOON(ioport + hp_int_mask, (INT_CMD_COMPL | SCSI_INTERRUPT));
 
-	while ((hp_int =
-		RDW_HARPOON((ioport +
-			     hp_intstat)) & FPT_default_intena) | bm_status) {
+	while ((hp_int = RDW_HARPOON((ioport + hp_intstat)) &
+				FPT_default_intena) | bm_status) {
 
-		currSCCB = ((struct sccb_card *)pCurrCard)->currentSCCB;
+		currSCCB = pCurrCard->currentSCCB;
 
 		if (hp_int & (FIFO | TIMEOUT | RESET | SCAM_SEL) || bm_status) {
 			result =
-			    FPT_SccbMgr_bad_isr(ioport, thisCard,
-						((struct sccb_card *)pCurrCard),
+			    FPT_SccbMgr_bad_isr(ioport, thisCard, pCurrCard,
 						hp_int);
 			WRW_HARPOON((ioport + hp_intstat),
 				    (FIFO | TIMEOUT | RESET | SCAM_SEL));
@@ -1796,8 +1793,7 @@ static int FlashPoint_HandleInterrupt(unsigned long pCurrCard)
 					(BUS_FREE | RSEL))) ;
 			}
 
-			if (((struct sccb_card *)pCurrCard)->
-			    globalFlags & F_HOST_XFER_ACT)
+			if (pCurrCard->globalFlags & F_HOST_XFER_ACT)
 
 				FPT_phaseChkFifo(ioport, thisCard);
 
@@ -1813,14 +1809,11 @@ static int FlashPoint_HandleInterrupt(unsigned long pCurrCard)
 
 		else if (hp_int & ITAR_DISC) {
 
-			if (((struct sccb_card *)pCurrCard)->
-			    globalFlags & F_HOST_XFER_ACT) {
-
+			if (pCurrCard->globalFlags & F_HOST_XFER_ACT)
 				FPT_phaseChkFifo(ioport, thisCard);
 
-			}
-
-			if (RD_HARPOON(ioport + hp_gp_reg_1) == SMSAVE_DATA_PTR) {
+			if (RD_HARPOON(ioport + hp_gp_reg_1) ==
+					SMSAVE_DATA_PTR) {
 
 				WR_HARPOON(ioport + hp_gp_reg_1, 0x00);
 				currSCCB->Sccb_XferState |= F_NO_DATA_YET;
@@ -1859,8 +1852,7 @@ static int FlashPoint_HandleInterrupt(unsigned long pCurrCard)
 			WRW_HARPOON((ioport + hp_intstat),
 				    (BUS_FREE | ITAR_DISC));
 
-			((struct sccb_card *)pCurrCard)->globalFlags |=
-			    F_NEW_SCCB_CMD;
+			pCurrCard->globalFlags |= F_NEW_SCCB_CMD;
 
 		}
 
@@ -1870,10 +1862,8 @@ static int FlashPoint_HandleInterrupt(unsigned long pCurrCard)
 				    (PROG_HLT | RSEL | PHASE | BUS_FREE));
 
 			if (RDW_HARPOON((ioport + hp_intstat)) & ITAR_DISC) {
-				if (((struct sccb_card *)pCurrCard)->
-				    globalFlags & F_HOST_XFER_ACT) {
+				if (pCurrCard->globalFlags & F_HOST_XFER_ACT)
 					FPT_phaseChkFifo(ioport, thisCard);
-				}
 
 				if (RD_HARPOON(ioport + hp_gp_reg_1) ==
 				    SMSAVE_DATA_PTR) {
@@ -1890,8 +1880,7 @@ static int FlashPoint_HandleInterrupt(unsigned long pCurrCard)
 				FPT_queueDisconnect(currSCCB, thisCard);
 			}
 
-			FPT_sres(ioport, thisCard,
-				 ((struct sccb_card *)pCurrCard));
+			FPT_sres(ioport, thisCard, pCurrCard);
 			FPT_phaseDecode(ioport, thisCard);
 
 		}
@@ -1948,8 +1937,7 @@ static int FlashPoint_HandleInterrupt(unsigned long pCurrCard)
 
 			WRW_HARPOON((ioport + hp_intstat), BUS_FREE);
 
-			if (((struct sccb_card *)pCurrCard)->
-			    globalFlags & F_HOST_XFER_ACT) {
+			if (pCurrCard->globalFlags & F_HOST_XFER_ACT) {
 
 				FPT_hostDataXferAbort(ioport, thisCard,
 						      currSCCB);
@@ -1961,27 +1949,19 @@ static int FlashPoint_HandleInterrupt(unsigned long pCurrCard)
 		else if (hp_int & ITICKLE) {
 
 			WRW_HARPOON((ioport + hp_intstat), ITICKLE);
-			((struct sccb_card *)pCurrCard)->globalFlags |=
-			    F_NEW_SCCB_CMD;
+			pCurrCard->globalFlags |= F_NEW_SCCB_CMD;
 		}
 
 		if (((struct sccb_card *)pCurrCard)->
 		    globalFlags & F_NEW_SCCB_CMD) {
 
-			((struct sccb_card *)pCurrCard)->globalFlags &=
-			    ~F_NEW_SCCB_CMD;
+			pCurrCard->globalFlags &= ~F_NEW_SCCB_CMD;
 
-			if (((struct sccb_card *)pCurrCard)->currentSCCB ==
-			    NULL) {
-
-				FPT_queueSearchSelect(((struct sccb_card *)
-						       pCurrCard), thisCard);
-			}
+			if (pCurrCard->currentSCCB == NULL)
+				FPT_queueSearchSelect(pCurrCard, thisCard);
 
-			if (((struct sccb_card *)pCurrCard)->currentSCCB !=
-			    NULL) {
-				((struct sccb_card *)pCurrCard)->globalFlags &=
-				    ~F_NEW_SCCB_CMD;
+			if (pCurrCard->currentSCCB != NULL) {
+				pCurrCard->globalFlags &= ~F_NEW_SCCB_CMD;
 				FPT_ssel(ioport, thisCard);
 			}
 
@@ -2006,8 +1986,7 @@ static int FlashPoint_HandleInterrupt(unsigned long pCurrCard)
  *              processing time.
  *
  *---------------------------------------------------------------------*/
-static unsigned char FPT_SccbMgr_bad_isr(unsigned long p_port,
-					 unsigned char p_card,
+static unsigned char FPT_SccbMgr_bad_isr(u32 p_port, unsigned char p_card,
 					 struct sccb_card *pCurrCard,
 					 unsigned short p_int)
 {
@@ -2254,7 +2233,7 @@ static void FPT_SccbMgrTableInitTarget(unsigned char p_card,
  *
  *---------------------------------------------------------------------*/
 
-static unsigned char FPT_sfm(unsigned long port, struct sccb *pCurrSCCB)
+static unsigned char FPT_sfm(u32 port, struct sccb *pCurrSCCB)
 {
 	unsigned char message;
 	unsigned short TimeOutLoop;
@@ -2322,12 +2301,12 @@ static unsigned char FPT_sfm(unsigned long port, struct sccb *pCurrSCCB)
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_ssel(unsigned long port, unsigned char p_card)
+static void FPT_ssel(u32 port, unsigned char p_card)
 {
 
 	unsigned char auto_loaded, i, target, *theCCB;
 
-	unsigned long cdb_reg;
+	u32 cdb_reg;
 	struct sccb_card *CurrCard;
 	struct sccb *currSCCB;
 	struct sccb_mgr_tar_info *currTar_Info;
@@ -2621,7 +2600,7 @@ static void FPT_ssel(unsigned long port, unsigned char p_card)
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_sres(unsigned long port, unsigned char p_card,
+static void FPT_sres(u32 port, unsigned char p_card,
 		     struct sccb_card *pCurrCard)
 {
 
@@ -2857,7 +2836,7 @@ static void FPT_sres(unsigned long port, unsigned char p_card,
 	       (RD_HARPOON(port + hp_scsisig) & SCSI_BSY)) ;
 }
 
-static void FPT_SendMsg(unsigned long port, unsigned char message)
+static void FPT_SendMsg(u32 port, unsigned char message)
 {
 	while (!(RD_HARPOON(port + hp_scsisig) & SCSI_REQ)) {
 		if (!(RD_HARPOON(port + hp_scsisig) & SCSI_BSY)) {
@@ -2904,8 +2883,7 @@ static void FPT_SendMsg(unsigned long port, unsigned char message)
  *              target device.
  *
  *---------------------------------------------------------------------*/
-static void FPT_sdecm(unsigned char message, unsigned long port,
-		      unsigned char p_card)
+static void FPT_sdecm(unsigned char message, u32 port, unsigned char p_card)
 {
 	struct sccb *currSCCB;
 	struct sccb_card *CurrCard;
@@ -3085,8 +3063,7 @@ static void FPT_sdecm(unsigned char message, unsigned long port,
  * Description: Decide what to do with the extended message.
  *
  *---------------------------------------------------------------------*/
-static void FPT_shandem(unsigned long port, unsigned char p_card,
-			struct sccb *pCurrSCCB)
+static void FPT_shandem(u32 port, unsigned char p_card, struct sccb *pCurrSCCB)
 {
 	unsigned char length, message;
 
@@ -3153,7 +3130,7 @@ static void FPT_shandem(unsigned long port, unsigned char p_card,
  *
  *---------------------------------------------------------------------*/
 
-static unsigned char FPT_sisyncn(unsigned long port, unsigned char p_card,
+static unsigned char FPT_sisyncn(u32 port, unsigned char p_card,
 				 unsigned char syncFlag)
 {
 	struct sccb *currSCCB;
@@ -3234,7 +3211,7 @@ static unsigned char FPT_sisyncn(unsigned long port, unsigned char p_card,
  *              necessary.
  *
  *---------------------------------------------------------------------*/
-static void FPT_stsyncn(unsigned long port, unsigned char p_card)
+static void FPT_stsyncn(u32 port, unsigned char p_card)
 {
 	unsigned char sync_msg, offset, sync_reg, our_sync_msg;
 	struct sccb *currSCCB;
@@ -3363,7 +3340,7 @@ static void FPT_stsyncn(unsigned long port, unsigned char p_card)
  * Description: Answer the targets sync message.
  *
  *---------------------------------------------------------------------*/
-static void FPT_sisyncr(unsigned long port, unsigned char sync_pulse,
+static void FPT_sisyncr(u32 port, unsigned char sync_pulse,
 			unsigned char offset)
 {
 	ARAM_ACCESS(port);
@@ -3394,7 +3371,7 @@ static void FPT_sisyncr(unsigned long port, unsigned char sync_pulse,
  *
  *---------------------------------------------------------------------*/
 
-static unsigned char FPT_siwidn(unsigned long port, unsigned char p_card)
+static unsigned char FPT_siwidn(u32 port, unsigned char p_card)
 {
 	struct sccb *currSCCB;
 	struct sccb_mgr_tar_info *currTar_Info;
@@ -3449,7 +3426,7 @@ static unsigned char FPT_siwidn(unsigned long port, unsigned char p_card)
  *              necessary.
  *
  *---------------------------------------------------------------------*/
-static void FPT_stwidn(unsigned long port, unsigned char p_card)
+static void FPT_stwidn(u32 port, unsigned char p_card)
 {
 	unsigned char width;
 	struct sccb *currSCCB;
@@ -3520,7 +3497,7 @@ static void FPT_stwidn(unsigned long port, unsigned char p_card)
  * Description: Answer the targets Wide nego message.
  *
  *---------------------------------------------------------------------*/
-static void FPT_siwidr(unsigned long port, unsigned char width)
+static void FPT_siwidr(u32 port, unsigned char width)
 {
 	ARAM_ACCESS(port);
 	WRW_HARPOON((port + SYNC_MSGS + 0), (MPM_OP + AMSG_OUT + SMEXT));
@@ -3548,7 +3525,7 @@ static void FPT_siwidr(unsigned long port, unsigned char width)
  *              ID specified.
  *
  *---------------------------------------------------------------------*/
-static void FPT_sssyncv(unsigned long p_port, unsigned char p_id,
+static void FPT_sssyncv(u32 p_port, unsigned char p_id,
 			unsigned char p_sync_value,
 			struct sccb_mgr_tar_info *currTar_Info)
 {
@@ -3620,7 +3597,7 @@ static void FPT_sssyncv(unsigned long p_port, unsigned char p_id,
  * Description: Reset the desired card's SCSI bus.
  *
  *---------------------------------------------------------------------*/
-static void FPT_sresb(unsigned long port, unsigned char p_card)
+static void FPT_sresb(u32 port, unsigned char p_card)
 {
 	unsigned char scsiID, i;
 
@@ -3713,7 +3690,7 @@ static void FPT_ssenss(struct sccb_card *pCurrCard)
 	currSCCB->Cdb[4] = currSCCB->RequestSenseLength;
 	currSCCB->Cdb[5] = 0x00;
 
-	currSCCB->Sccb_XferCnt = (unsigned long)currSCCB->RequestSenseLength;
+	currSCCB->Sccb_XferCnt = (u32)currSCCB->RequestSenseLength;
 
 	currSCCB->Sccb_ATC = 0x00;
 
@@ -3737,7 +3714,7 @@ static void FPT_ssenss(struct sccb_card *pCurrCard)
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_sxfrp(unsigned long p_port, unsigned char p_card)
+static void FPT_sxfrp(u32 p_port, unsigned char p_card)
 {
 	unsigned char curr_phz;
 
@@ -3819,7 +3796,7 @@ static void FPT_sxfrp(unsigned long p_port, unsigned char p_card)
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_schkdd(unsigned long port, unsigned char p_card)
+static void FPT_schkdd(u32 port, unsigned char p_card)
 {
 	unsigned short TimeOutLoop;
 	unsigned char sPhase;
@@ -3998,10 +3975,10 @@ static void FPT_sinits(struct sccb *p_sccb, unsigned char p_card)
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_phaseDecode(unsigned long p_port, unsigned char p_card)
+static void FPT_phaseDecode(u32 p_port, unsigned char p_card)
 {
 	unsigned char phase_ref;
-	void (*phase) (unsigned long, unsigned char);
+	void (*phase) (u32, unsigned char);
 
 	DISABLE_AUTO(p_port);
 
@@ -4021,7 +3998,7 @@ static void FPT_phaseDecode(unsigned long p_port, unsigned char p_card)
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_phaseDataOut(unsigned long port, unsigned char p_card)
+static void FPT_phaseDataOut(u32 port, unsigned char p_card)
 {
 
 	struct sccb *currSCCB;
@@ -4062,7 +4039,7 @@ static void FPT_phaseDataOut(unsigned long port, unsigned char p_card)
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_phaseDataIn(unsigned long port, unsigned char p_card)
+static void FPT_phaseDataIn(u32 port, unsigned char p_card)
 {
 
 	struct sccb *currSCCB;
@@ -4106,10 +4083,10 @@ static void FPT_phaseDataIn(unsigned long port, unsigned char p_card)
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_phaseCommand(unsigned long p_port, unsigned char p_card)
+static void FPT_phaseCommand(u32 p_port, unsigned char p_card)
 {
 	struct sccb *currSCCB;
-	unsigned long cdb_reg;
+	u32 cdb_reg;
 	unsigned char i;
 
 	currSCCB = FPT_BL_Card[p_card].currentSCCB;
@@ -4157,7 +4134,7 @@ static void FPT_phaseCommand(unsigned long p_port, unsigned char p_card)
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_phaseStatus(unsigned long port, unsigned char p_card)
+static void FPT_phaseStatus(u32 port, unsigned char p_card)
 {
 	/* Start-up the automation to finish off this command and let the
 	   isr handle the interrupt for command complete when it comes in.
@@ -4178,7 +4155,7 @@ static void FPT_phaseStatus(unsigned long port, unsigned char p_card)
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_phaseMsgOut(unsigned long port, unsigned char p_card)
+static void FPT_phaseMsgOut(u32 port, unsigned char p_card)
 {
 	unsigned char message, scsiID;
 	struct sccb *currSCCB;
@@ -4317,7 +4294,7 @@ static void FPT_phaseMsgOut(unsigned long port, unsigned char p_card)
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_phaseMsgIn(unsigned long port, unsigned char p_card)
+static void FPT_phaseMsgIn(u32 port, unsigned char p_card)
 {
 	unsigned char message;
 	struct sccb *currSCCB;
@@ -4364,7 +4341,7 @@ static void FPT_phaseMsgIn(unsigned long port, unsigned char p_card)
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_phaseIllegal(unsigned long port, unsigned char p_card)
+static void FPT_phaseIllegal(u32 port, unsigned char p_card)
 {
 	struct sccb *currSCCB;
 
@@ -4390,9 +4367,9 @@ static void FPT_phaseIllegal(unsigned long port, unsigned char p_card)
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_phaseChkFifo(unsigned long port, unsigned char p_card)
+static void FPT_phaseChkFifo(u32 port, unsigned char p_card)
 {
-	unsigned long xfercnt;
+	u32 xfercnt;
 	struct sccb *currSCCB;
 
 	currSCCB = FPT_BL_Card[p_card].currentSCCB;
@@ -4461,7 +4438,7 @@ static void FPT_phaseChkFifo(unsigned long port, unsigned char p_card)
  *              because of command complete or from a disconnect.
  *
  *---------------------------------------------------------------------*/
-static void FPT_phaseBusFree(unsigned long port, unsigned char p_card)
+static void FPT_phaseBusFree(u32 port, unsigned char p_card)
 {
 	struct sccb *currSCCB;
 
@@ -4557,9 +4534,9 @@ static void FPT_phaseBusFree(unsigned long port, unsigned char p_card)
  * Description: Load the Automation RAM with the defualt map values.
  *
  *---------------------------------------------------------------------*/
-static void FPT_autoLoadDefaultMap(unsigned long p_port)
+static void FPT_autoLoadDefaultMap(u32 p_port)
 {
-	unsigned long map_addr;
+	u32 map_addr;
 
 	ARAM_ACCESS(p_port);
 	map_addr = p_port + hp_aramBase;
@@ -4663,7 +4640,7 @@ static void FPT_autoLoadDefaultMap(unsigned long p_port)
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_autoCmdCmplt(unsigned long p_port, unsigned char p_card)
+static void FPT_autoCmdCmplt(u32 p_port, unsigned char p_card)
 {
 	struct sccb *currSCCB;
 	unsigned char status_byte;
@@ -4936,8 +4913,7 @@ static void FPT_autoCmdCmplt(unsigned long p_port, unsigned char p_card)
  *              
  *---------------------------------------------------------------------*/
 
-static void FPT_dataXferProcessor(unsigned long port,
-				  struct sccb_card *pCurrCard)
+static void FPT_dataXferProcessor(u32 port, struct sccb_card *pCurrCard)
 {
 	struct sccb *currSCCB;
 
@@ -4970,22 +4946,18 @@ static void FPT_dataXferProcessor(unsigned long port,
  * Description:
  *
  *---------------------------------------------------------------------*/
-static void FPT_busMstrSGDataXferStart(unsigned long p_port,
-				       struct sccb *pcurrSCCB)
+static void FPT_busMstrSGDataXferStart(u32 p_port, struct sccb *pcurrSCCB)
 {
-	unsigned long count, addr, tmpSGCnt;
+	u32 count, addr, tmpSGCnt;
 	unsigned int sg_index;
 	unsigned char sg_count, i;
-	unsigned long reg_offset;
-
-	if (pcurrSCCB->Sccb_XferState & F_HOST_XFER_DIR) {
+	u32 reg_offset;
+	struct blogic_sg_seg *segp;
 
-		count = ((unsigned long)HOST_RD_CMD) << 24;
-	}
-
-	else {
-		count = ((unsigned long)HOST_WRT_CMD) << 24;
-	}
+	if (pcurrSCCB->Sccb_XferState & F_HOST_XFER_DIR)
+		count = ((u32)HOST_RD_CMD) << 24;
+	else
+		count = ((u32)HOST_WRT_CMD) << 24;
 
 	sg_count = 0;
 	tmpSGCnt = 0;
@@ -4998,25 +4970,20 @@ static void FPT_busMstrSGDataXferStart(unsigned long p_port,
 	WR_HARPOON(p_port + hp_page_ctrl, i);
 
 	while ((sg_count < (unsigned char)SG_BUF_CNT) &&
-	       ((unsigned long)(sg_index * (unsigned int)SG_ELEMENT_SIZE) <
-		pcurrSCCB->DataLength)) {
-
-		tmpSGCnt += *(((unsigned long *)pcurrSCCB->DataPointer) +
-			      (sg_index * 2));
-
-		count |= *(((unsigned long *)pcurrSCCB->DataPointer) +
-			   (sg_index * 2));
+			((sg_index * (unsigned int)SG_ELEMENT_SIZE) <
+			pcurrSCCB->DataLength)) {
 
-		addr = *(((unsigned long *)pcurrSCCB->DataPointer) +
-			 ((sg_index * 2) + 1));
+		segp = (struct blogic_sg_seg *)(pcurrSCCB->DataPointer) +
+				sg_index;
+		tmpSGCnt += segp->segbytes;
+		count |= segp->segbytes;
+		addr = segp->segdata;
 
 		if ((!sg_count) && (pcurrSCCB->Sccb_SGoffset)) {
-
 			addr +=
 			    ((count & 0x00FFFFFFL) - pcurrSCCB->Sccb_SGoffset);
 			count =
 			    (count & 0xFF000000L) | pcurrSCCB->Sccb_SGoffset;
-
 			tmpSGCnt = count & 0x00FFFFFFL;
 		}
 
@@ -5072,17 +5039,16 @@ static void FPT_busMstrSGDataXferStart(unsigned long p_port,
  * Description: 
  *
  *---------------------------------------------------------------------*/
-static void FPT_busMstrDataXferStart(unsigned long p_port,
-				     struct sccb *pcurrSCCB)
+static void FPT_busMstrDataXferStart(u32 p_port, struct sccb *pcurrSCCB)
 {
-	unsigned long addr, count;
+	u32 addr, count;
 
 	if (!(pcurrSCCB->Sccb_XferState & F_AUTO_SENSE)) {
 
 		count = pcurrSCCB->Sccb_XferCnt;
 
 		addr =
-		    (unsigned long)pcurrSCCB->DataPointer + pcurrSCCB->Sccb_ATC;
+		    (u32)pcurrSCCB->DataPointer + pcurrSCCB->Sccb_ATC;
 	}
 
 	else {
@@ -5127,7 +5093,7 @@ static void FPT_busMstrDataXferStart(unsigned long p_port,
  *               command busy is also time out, it'll just give up.
  *
  *---------------------------------------------------------------------*/
-static unsigned char FPT_busMstrTimeOut(unsigned long p_port)
+static unsigned char FPT_busMstrTimeOut(u32 p_port)
 {
 	unsigned long timeout;
 
@@ -5166,13 +5132,14 @@ static unsigned char FPT_busMstrTimeOut(unsigned long p_port)
  * Description: Abort any in progress transfer.
  *
  *---------------------------------------------------------------------*/
-static void FPT_hostDataXferAbort(unsigned long port, unsigned char p_card,
+static void FPT_hostDataXferAbort(u32 port, unsigned char p_card,
 				  struct sccb *pCurrSCCB)
 {
 
 	unsigned long timeout;
 	unsigned long remain_cnt;
-	unsigned int sg_ptr;
+	u32 sg_ptr;
+	struct blogic_sg_seg *segp;
 
 	FPT_BL_Card[p_card].globalFlags &= ~F_HOST_XFER_ACT;
 
@@ -5236,9 +5203,8 @@ static void FPT_hostDataXferAbort(unsigned long port, unsigned char p_card,
 			    (unsigned int)(pCurrSCCB->DataLength /
 					   SG_ELEMENT_SIZE)) {
 
-				sg_ptr =
-				    (unsigned int)(pCurrSCCB->DataLength /
-						   SG_ELEMENT_SIZE);
+				sg_ptr = (u32)(pCurrSCCB->DataLength /
+							SG_ELEMENT_SIZE);
 			}
 
 			remain_cnt = pCurrSCCB->Sccb_XferCnt;
@@ -5246,23 +5212,13 @@ static void FPT_hostDataXferAbort(unsigned long port, unsigned char p_card,
 			while (remain_cnt < 0x01000000L) {
 
 				sg_ptr--;
-
-				if (remain_cnt >
-				    (unsigned
-				     long)(*(((unsigned long *)pCurrSCCB->
-					      DataPointer) + (sg_ptr * 2)))) {
-
+				segp = (struct blogic_sg_seg *)(pCurrSCCB->
+						DataPointer) + (sg_ptr * 2);
+				if (remain_cnt > (unsigned long)segp->segbytes)
 					remain_cnt -=
-					    (unsigned
-					     long)(*(((unsigned long *)
-						      pCurrSCCB->DataPointer) +
-						     (sg_ptr * 2)));
-				}
-
-				else {
-
+						(unsigned long)segp->segbytes;
+				else
 					break;
-				}
 			}
 
 			if (remain_cnt < 0x01000000L) {
@@ -5418,23 +5374,18 @@ static void FPT_hostDataXferAbort(unsigned long port, unsigned char p_card,
 
 			pCurrSCCB->Sccb_SGoffset = 0x00;
 
-			if ((unsigned long)(pCurrSCCB->Sccb_sgseg *
-					    SG_ELEMENT_SIZE) >=
-			    pCurrSCCB->DataLength) {
+			if ((u32)(pCurrSCCB->Sccb_sgseg * SG_ELEMENT_SIZE) >=
+					pCurrSCCB->DataLength) {
 
 				pCurrSCCB->Sccb_XferState |= F_ALL_XFERRED;
-
 				pCurrSCCB->Sccb_sgseg =
 				    (unsigned short)(pCurrSCCB->DataLength /
 						     SG_ELEMENT_SIZE);
-
 			}
 		}
 
 		else {
-
 			if (!(pCurrSCCB->Sccb_XferState & F_AUTO_SENSE))
-
 				pCurrSCCB->Sccb_XferState |= F_ALL_XFERRED;
 		}
 	}
@@ -5454,21 +5405,22 @@ static void FPT_hostDataXferRestart(struct sccb *currSCCB)
 {
 	unsigned long data_count;
 	unsigned int sg_index;
-	unsigned long *sg_ptr;
+	struct blogic_sg_seg *segp;
 
 	if (currSCCB->Sccb_XferState & F_SG_XFER) {
 
 		currSCCB->Sccb_XferCnt = 0;
 
 		sg_index = 0xffff;	/*Index by long words into sg list. */
-		data_count = 0;	/*Running count of SG xfer counts. */
+		data_count = 0;		/*Running count of SG xfer counts. */
 
-		sg_ptr = (unsigned long *)currSCCB->DataPointer;
 
 		while (data_count < currSCCB->Sccb_ATC) {
 
 			sg_index++;
-			data_count += *(sg_ptr + (sg_index * 2));
+			segp = (struct blogic_sg_seg *)(currSCCB->DataPointer) +
+						(sg_index * 2);
+			data_count += segp->segbytes;
 		}
 
 		if (data_count == currSCCB->Sccb_ATC) {
@@ -5504,7 +5456,7 @@ static void FPT_scini(unsigned char p_card, unsigned char p_our_id,
 {
 
 	unsigned char loser, assigned_id;
-	unsigned long p_port;
+	u32 p_port;
 
 	unsigned char i, k, ScamFlg;
 	struct sccb_card *currCard;
@@ -5709,7 +5661,7 @@ static void FPT_scini(unsigned char p_card, unsigned char p_our_id,
  *
  *---------------------------------------------------------------------*/
 
-static int FPT_scarb(unsigned long p_port, unsigned char p_sel_type)
+static int FPT_scarb(u32 p_port, unsigned char p_sel_type)
 {
 	if (p_sel_type == INIT_SELTD) {
 
@@ -5771,7 +5723,7 @@ static int FPT_scarb(unsigned long p_port, unsigned char p_sel_type)
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_scbusf(unsigned long p_port)
+static void FPT_scbusf(u32 p_port)
 {
 	WR_HARPOON(p_port + hp_page_ctrl,
 		   (RD_HARPOON(p_port + hp_page_ctrl) | G_INT_DISABLE));
@@ -5803,7 +5755,7 @@ static void FPT_scbusf(unsigned long p_port)
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_scasid(unsigned char p_card, unsigned long p_port)
+static void FPT_scasid(unsigned char p_card, u32 p_port)
 {
 	unsigned char temp_id_string[ID_STRING_LENGTH];
 
@@ -5880,7 +5832,7 @@ static void FPT_scasid(unsigned char p_card, unsigned long p_port)
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_scsel(unsigned long p_port)
+static void FPT_scsel(u32 p_port)
 {
 
 	WR_HARPOON(p_port + hp_scsisig, SCSI_SEL);
@@ -5914,7 +5866,7 @@ static void FPT_scsel(unsigned long p_port)
  *
  *---------------------------------------------------------------------*/
 
-static unsigned char FPT_scxferc(unsigned long p_port, unsigned char p_data)
+static unsigned char FPT_scxferc(u32 p_port, unsigned char p_data)
 {
 	unsigned char curr_data, ret_data;
 
@@ -5964,8 +5916,7 @@ static unsigned char FPT_scxferc(unsigned long p_port, unsigned char p_data)
  *
  *---------------------------------------------------------------------*/
 
-static unsigned char FPT_scsendi(unsigned long p_port,
-				 unsigned char p_id_string[])
+static unsigned char FPT_scsendi(u32 p_port, unsigned char p_id_string[])
 {
 	unsigned char ret_data, byte_cnt, bit_cnt, defer;
 
@@ -6016,8 +5967,7 @@ static unsigned char FPT_scsendi(unsigned long p_port,
  *
  *---------------------------------------------------------------------*/
 
-static unsigned char FPT_sciso(unsigned long p_port,
-			       unsigned char p_id_string[])
+static unsigned char FPT_sciso(u32 p_port, unsigned char p_id_string[])
 {
 	unsigned char ret_data, the_data, byte_cnt, bit_cnt;
 
@@ -6075,7 +6025,7 @@ static unsigned char FPT_sciso(unsigned long p_port,
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_scwirod(unsigned long p_port, unsigned char p_data_bit)
+static void FPT_scwirod(u32 p_port, unsigned char p_data_bit)
 {
 	unsigned char i;
 
@@ -6102,7 +6052,7 @@ static void FPT_scwirod(unsigned long p_port, unsigned char p_data_bit)
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_scwiros(unsigned long p_port, unsigned char p_data_bit)
+static void FPT_scwiros(u32 p_port, unsigned char p_data_bit)
 {
 	unsigned char i;
 
@@ -6154,7 +6104,7 @@ static unsigned char FPT_scvalq(unsigned char p_quintet)
  *
  *---------------------------------------------------------------------*/
 
-static unsigned char FPT_scsell(unsigned long p_port, unsigned char targ_id)
+static unsigned char FPT_scsell(u32 p_port, unsigned char targ_id)
 {
 	unsigned long i;
 
@@ -6236,7 +6186,7 @@ static unsigned char FPT_scsell(unsigned long p_port, unsigned char targ_id)
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_scwtsel(unsigned long p_port)
+static void FPT_scwtsel(u32 p_port)
 {
 	while (!(RDW_HARPOON((p_port + hp_intstat)) & SCAM_SEL)) {
 	}
@@ -6250,8 +6200,7 @@ static void FPT_scwtsel(unsigned long p_port)
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_inisci(unsigned char p_card, unsigned long p_port,
-		       unsigned char p_our_id)
+static void FPT_inisci(unsigned char p_card, u32 p_port, unsigned char p_our_id)
 {
 	unsigned char i, k, max_id;
 	unsigned short ee_data;
@@ -6437,7 +6386,7 @@ static unsigned char FPT_scmachid(unsigned char p_card,
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_scsavdi(unsigned char p_card, unsigned long p_port)
+static void FPT_scsavdi(unsigned char p_card, u32 p_port)
 {
 	unsigned char i, k, max_id;
 	unsigned short ee_data, sum_data;
@@ -6482,7 +6431,7 @@ static void FPT_scsavdi(unsigned char p_card, unsigned long p_port)
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_XbowInit(unsigned long port, unsigned char ScamFlg)
+static void FPT_XbowInit(u32 port, unsigned char ScamFlg)
 {
 	unsigned char i;
 
@@ -6531,7 +6480,7 @@ static void FPT_XbowInit(unsigned long port, unsigned char ScamFlg)
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_BusMasterInit(unsigned long p_port)
+static void FPT_BusMasterInit(u32 p_port)
 {
 
 	WR_HARPOON(p_port + hp_sys_ctrl, DRVR_RST);
@@ -6558,7 +6507,7 @@ static void FPT_BusMasterInit(unsigned long p_port)
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_DiagEEPROM(unsigned long p_port)
+static void FPT_DiagEEPROM(u32 p_port)
 {
 	unsigned short index, temp, max_wd_cnt;
 
@@ -7206,7 +7155,7 @@ static void FPT_utilUpdateResidual(struct sccb *p_SCCB)
 {
 	unsigned long partial_cnt;
 	unsigned int sg_index;
-	unsigned long *sg_ptr;
+	struct blogic_sg_seg *segp;
 
 	if (p_SCCB->Sccb_XferState & F_ALL_XFERRED) {
 
@@ -7219,7 +7168,6 @@ static void FPT_utilUpdateResidual(struct sccb *p_SCCB)
 
 		sg_index = p_SCCB->Sccb_sgseg;
 
-		sg_ptr = (unsigned long *)p_SCCB->DataPointer;
 
 		if (p_SCCB->Sccb_SGoffset) {
 
@@ -7229,8 +7177,9 @@ static void FPT_utilUpdateResidual(struct sccb *p_SCCB)
 
 		while (((unsigned long)sg_index *
 			(unsigned long)SG_ELEMENT_SIZE) < p_SCCB->DataLength) {
-
-			partial_cnt += *(sg_ptr + (sg_index * 2));
+			segp = (struct blogic_sg_seg *)(p_SCCB->DataPointer) +
+					(sg_index * 2);
+			partial_cnt += segp->segbytes;
 			sg_index++;
 		}
 
@@ -7251,7 +7200,7 @@ static void FPT_utilUpdateResidual(struct sccb *p_SCCB)
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_Wait1Second(unsigned long p_port)
+static void FPT_Wait1Second(u32 p_port)
 {
 	unsigned char i;
 
@@ -7275,7 +7224,7 @@ static void FPT_Wait1Second(unsigned long p_port)
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_Wait(unsigned long p_port, unsigned char p_delay)
+static void FPT_Wait(u32 p_port, unsigned char p_delay)
 {
 	unsigned char old_timer;
 	unsigned char green_flag;
@@ -7321,7 +7270,7 @@ static void FPT_Wait(unsigned long p_port, unsigned char p_delay)
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_utilEEWriteOnOff(unsigned long p_port, unsigned char p_mode)
+static void FPT_utilEEWriteOnOff(u32 p_port, unsigned char p_mode)
 {
 	unsigned char ee_value;
 
@@ -7350,7 +7299,7 @@ static void FPT_utilEEWriteOnOff(unsigned long p_port, unsigned char p_mode)
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_utilEEWrite(unsigned long p_port, unsigned short ee_data,
+static void FPT_utilEEWrite(u32 p_port, unsigned short ee_data,
 			    unsigned short ee_addr)
 {
 
@@ -7401,7 +7350,7 @@ static void FPT_utilEEWrite(unsigned long p_port, unsigned short ee_data,
  *
  *---------------------------------------------------------------------*/
 
-static unsigned short FPT_utilEERead(unsigned long p_port,
+static unsigned short FPT_utilEERead(u32 p_port,
 				     unsigned short ee_addr)
 {
 	unsigned short i, ee_data1, ee_data2;
@@ -7431,8 +7380,7 @@ static unsigned short FPT_utilEERead(unsigned long p_port,
  *
  *---------------------------------------------------------------------*/
 
-static unsigned short FPT_utilEEReadOrg(unsigned long p_port,
-					unsigned short ee_addr)
+static unsigned short FPT_utilEEReadOrg(u32 p_port, unsigned short ee_addr)
 {
 
 	unsigned char ee_value;
@@ -7479,7 +7427,7 @@ static unsigned short FPT_utilEEReadOrg(unsigned long p_port,
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_utilEESendCmdAddr(unsigned long p_port, unsigned char ee_cmd,
+static void FPT_utilEESendCmdAddr(u32 p_port, unsigned char ee_cmd,
 				  unsigned short ee_addr)
 {
 	unsigned char ee_value;
@@ -7579,7 +7527,7 @@ FlashPoint__ProbeHostAdapter(struct fpoint_info *FlashPointInfo)
 					   FlashPointInfo);
 }
 
-static inline unsigned int
+static inline void *
 FlashPoint__HardwareResetHostAdapter(struct fpoint_info *FlashPointInfo)
 {
 	return FlashPoint_HardwareResetHostAdapter((struct sccb_mgr_info *)
@@ -7587,33 +7535,31 @@ FlashPoint__HardwareResetHostAdapter(struct fpoint_info *FlashPointInfo)
 }
 
 static inline void
-FlashPoint__ReleaseHostAdapter(unsigned int CardHandle)
+FlashPoint__ReleaseHostAdapter(void *CardHandle)
 {
 	FlashPoint_ReleaseHostAdapter(CardHandle);
 }
 
 static inline void
-FlashPoint__StartCCB(unsigned int CardHandle,
-		     struct blogic_ccb *CCB)
+FlashPoint__StartCCB(void *CardHandle, struct blogic_ccb *CCB)
 {
 	FlashPoint_StartCCB(CardHandle, (struct sccb *)CCB);
 }
 
 static inline void
-FlashPoint__AbortCCB(unsigned int CardHandle,
-		     struct blogic_ccb *CCB)
+FlashPoint__AbortCCB(void *CardHandle, struct blogic_ccb *CCB)
 {
 	FlashPoint_AbortCCB(CardHandle, (struct sccb *)CCB);
 }
 
 static inline bool
-FlashPoint__InterruptPending(unsigned int CardHandle)
+FlashPoint__InterruptPending(void *CardHandle)
 {
 	return FlashPoint_InterruptPending(CardHandle);
 }
 
 static inline int
-FlashPoint__HandleInterrupt(unsigned int CardHandle)
+FlashPoint__HandleInterrupt(void *CardHandle)
 {
 	return FlashPoint_HandleInterrupt(CardHandle);
 }
@@ -7633,11 +7579,11 @@ FlashPoint__HandleInterrupt(unsigned int CardHandle)
 */
 
 extern unsigned char FlashPoint_ProbeHostAdapter(struct fpoint_info *);
-extern unsigned int FlashPoint_HardwareResetHostAdapter(struct fpoint_info *);
-extern void FlashPoint_StartCCB(unsigned int, struct blogic_ccb *);
-extern int FlashPoint_AbortCCB(unsigned int, struct blogic_ccb *);
-extern bool FlashPoint_InterruptPending(unsigned int);
-extern int FlashPoint_HandleInterrupt(unsigned int);
-extern void FlashPoint_ReleaseHostAdapter(unsigned int);
+extern void *FlashPoint_HardwareResetHostAdapter(struct fpoint_info *);
+extern void FlashPoint_StartCCB(void *, struct blogic_ccb *);
+extern int FlashPoint_AbortCCB(void *, struct blogic_ccb *);
+extern bool FlashPoint_InterruptPending(void *);
+extern int FlashPoint_HandleInterrupt(void *);
+extern void FlashPoint_ReleaseHostAdapter(void *);
 
 #endif				/* CONFIG_SCSI_FLASHPOINT */
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index db95c54..c25597e 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -633,7 +633,7 @@ config SCSI_BUSLOGIC
 
 config SCSI_FLASHPOINT
 	bool "FlashPoint support"
-	depends on SCSI_BUSLOGIC && PCI && X86_32
+	depends on SCSI_BUSLOGIC && PCI
 	help
 	  This option allows you to add FlashPoint support to the
 	  BusLogic SCSI driver. The FlashPoint SCCB Manager code is
-- 
1.7.10.4

