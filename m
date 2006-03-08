From: akpm@osdl.org
Subject: [patch 09/28] drivers/scsi/FlashPoint.c: remove USHORT
Date: Wed, 08 Mar 2006 00:14:25 -0800
Message-ID: <200603080816.k288GEUv002179@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:23468 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1752099AbWCHIQT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2006 03:16:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, adobriyan@gmail.com


From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/FlashPoint.c |  117 +++++++++++++++++-------------------
 1 files changed, 58 insertions(+), 59 deletions(-)

diff -puN drivers/scsi/FlashPoint.c~drivers-scsi-flashpointc-remove-ushort drivers/scsi/FlashPoint.c
--- 25/drivers/scsi/FlashPoint.c~drivers-scsi-flashpointc-remove-ushort	Mon Feb  6 14:50:00 2006
+++ 25-akpm/drivers/scsi/FlashPoint.c	Mon Feb  6 14:50:00 2006
@@ -40,7 +40,6 @@
 #define FAILURE         0xFFFFFFFFL
 
 
-typedef unsigned short  USHORT;
 typedef unsigned int    UINT;
 typedef unsigned long   ULONG;
 
@@ -59,7 +58,7 @@ typedef unsigned short          * ushort
 
 
 #define BIT(x)          ((unsigned char)(1<<(x)))    /* single-bit mask in bit position x */
-#define BITW(x)          ((USHORT)(1<<(x)))  /* single-bit mask in bit position x */
+#define BITW(x)          ((unsigned short)(1<<(x)))  /* single-bit mask in bit position x */
 
 
 
@@ -74,13 +73,13 @@ typedef struct SCCBMgr_info {
    unsigned char    si_intvect;
    unsigned char    si_id;
    unsigned char    si_lun;
-   USHORT   si_fw_revision;
-   USHORT   si_per_targ_init_sync;
-   USHORT   si_per_targ_fast_nego;
-   USHORT   si_per_targ_ultra_nego;
-   USHORT   si_per_targ_no_disc;
-   USHORT   si_per_targ_wide_nego;
-   USHORT   si_flags;
+   unsigned short   si_fw_revision;
+   unsigned short   si_per_targ_init_sync;
+   unsigned short   si_per_targ_fast_nego;
+   unsigned short   si_per_targ_ultra_nego;
+   unsigned short   si_per_targ_no_disc;
+   unsigned short   si_per_targ_wide_nego;
+   unsigned short   si_flags;
    unsigned char    si_card_family;
    unsigned char    si_bustype;
    unsigned char    si_card_model[3];
@@ -143,15 +142,15 @@ typedef struct _SCCB {
    ULONG  SccbIOPort;                        /* Identifies board base port */
    unsigned char  SccbStatus;
    unsigned char  SCCBRes2;
-   USHORT SccbOSFlags;
+   unsigned short SccbOSFlags;
 
 
    ULONG   Sccb_XferCnt;            /* actual transfer count */
    ULONG   Sccb_ATC;
    ULONG   SccbVirtDataPtr;         /* virtual addr for OS/2 */
    ULONG   Sccb_res1;
-   USHORT  Sccb_MGRFlags;
-   USHORT  Sccb_sgseg;
+   unsigned short  Sccb_MGRFlags;
+   unsigned short  Sccb_sgseg;
    unsigned char   Sccb_scsimsg;            /* identify msg for selection */
    unsigned char   Sccb_tag;
    unsigned char   Sccb_scsistat;
@@ -324,7 +323,7 @@ typedef struct SCCBcard {
 
    ULONG ioPort;
 
-   USHORT cmdCounter;
+   unsigned short cmdCounter;
    unsigned char  discQCount;
    unsigned char  tagQ_Lst;
    unsigned char cardIndex;
@@ -943,13 +942,13 @@ typedef struct SCCBscam_info {
 #define GET_XFER_CNT(port, xfercnt) {RD_HARP32(port,hp_xfercnt_0,xfercnt); xfercnt &= 0xFFFFFF;}
 /* #define GET_XFER_CNT(port, xfercnt) (xfercnt = RD_HARPOON(port+hp_xfercnt_2), \
                                  xfercnt <<= 16,\
-                                 xfercnt |= RDW_HARPOON((USHORT)(port+hp_xfercnt_0)))
+                                 xfercnt |= RDW_HARPOON((unsigned short)(port+hp_xfercnt_0)))
  */
-#define HP_SETUP_ADDR_CNT(port,addr,count) (WRW_HARPOON((port+hp_host_addr_lo), (USHORT)(addr & 0x0000FFFFL)),\
+#define HP_SETUP_ADDR_CNT(port,addr,count) (WRW_HARPOON((port+hp_host_addr_lo), (unsigned short)(addr & 0x0000FFFFL)),\
          addr >>= 16,\
-         WRW_HARPOON((port+hp_host_addr_hmi), (USHORT)(addr & 0x0000FFFFL)),\
+         WRW_HARPOON((port+hp_host_addr_hmi), (unsigned short)(addr & 0x0000FFFFL)),\
          WR_HARP32(port,hp_xfercnt_0,count),\
-         WRW_HARPOON((port+hp_xfer_cnt_lo), (USHORT)(count & 0x0000FFFFL)),\
+         WRW_HARPOON((port+hp_xfer_cnt_lo), (unsigned short)(count & 0x0000FFFFL)),\
          count >>= 16,\
          WR_HARPOON(port+hp_xfer_cnt_hi, (count & 0xFF)))
 
@@ -1016,17 +1015,17 @@ static void  FPT_queueFlushSccb(unsigned
 static void  FPT_queueAddSccb(PSCCB p_SCCB, unsigned char card);
 static unsigned char FPT_queueFindSccb(PSCCB p_SCCB, unsigned char p_card);
 static void  FPT_utilUpdateResidual(PSCCB p_SCCB);
-static USHORT FPT_CalcCrc16(unsigned char buffer[]);
+static unsigned short FPT_CalcCrc16(unsigned char buffer[]);
 static unsigned char  FPT_CalcLrc(unsigned char buffer[]);
 
 
 static void  FPT_Wait1Second(ULONG p_port);
 static void  FPT_Wait(ULONG p_port, unsigned char p_delay);
 static void  FPT_utilEEWriteOnOff(ULONG p_port,unsigned char p_mode);
-static void  FPT_utilEEWrite(ULONG p_port, USHORT ee_data, USHORT ee_addr);
-static USHORT FPT_utilEERead(ULONG p_port, USHORT ee_addr);
-static USHORT FPT_utilEEReadOrg(ULONG p_port, USHORT ee_addr);
-static void  FPT_utilEESendCmdAddr(ULONG p_port, unsigned char ee_cmd, USHORT ee_addr);
+static void  FPT_utilEEWrite(ULONG p_port, unsigned short ee_data, unsigned short ee_addr);
+static unsigned short FPT_utilEERead(ULONG p_port, unsigned short ee_addr);
+static unsigned short FPT_utilEEReadOrg(ULONG p_port, unsigned short ee_addr);
+static void  FPT_utilEESendCmdAddr(ULONG p_port, unsigned char ee_cmd, unsigned short ee_addr);
 
 
 
@@ -1060,7 +1059,7 @@ static void  FPT_hostDataXferRestart(PSC
 
 
 static unsigned char FPT_SccbMgr_bad_isr(ULONG p_port, unsigned char p_card,
-				 PSCCBcard pCurrCard, USHORT p_int);
+				 PSCCBcard pCurrCard, unsigned short p_int);
 
 static void  FPT_SccbMgrTableInitAll(void);
 static void  FPT_SccbMgrTableInitCard(PSCCBcard pCurrCard, unsigned char p_card);
@@ -1105,7 +1104,7 @@ static unsigned char FPT_scamHAString[] 
 				   0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, \
 				   0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20};
 
-static USHORT FPT_default_intena = 0;
+static unsigned short FPT_default_intena = 0;
 
 
 static void (*FPT_s_PhaseTbl[8]) (ULONG, unsigned char)= { 0 };
@@ -1124,7 +1123,7 @@ static int FlashPoint_ProbeHostAdapter(P
    static unsigned char first_time = 1;
 
    unsigned char i,j,id,ScamFlg;
-   USHORT temp,temp2,temp3,temp4,temp5,temp6;
+   unsigned short temp,temp2,temp3,temp4,temp5,temp6;
    ULONG ioport;
 	PNVRamInfo pCurrNvRam;
 
@@ -1203,11 +1202,11 @@ static int FlashPoint_ProbeHostAdapter(P
    for (id = 0; id < (16/2); id++) {
 
 		if(pCurrNvRam){
-			temp = (USHORT) pCurrNvRam->niSyncTbl[id];
+			temp = (unsigned short) pCurrNvRam->niSyncTbl[id];
 			temp = ((temp & 0x03) + ((temp << 4) & 0xc0)) +
 					 (((temp << 4) & 0x0300) + ((temp << 8) & 0xc000));
 		}else
-	      temp = FPT_utilEERead(ioport, (USHORT)((SYNC_RATE_TBL/2)+id));
+	      temp = FPT_utilEERead(ioport, (unsigned short)((SYNC_RATE_TBL/2)+id));
 
       for (i = 0; i < 2; temp >>=8,i++) {
 
@@ -1402,7 +1401,7 @@ static ULONG FlashPoint_HardwareResetHos
    PSCCBcard CurrCard = NULL;
 	PNVRamInfo pCurrNvRam;
    unsigned char i,j,thisCard, ScamFlg;
-   USHORT temp,sync_bit_map,id;
+   unsigned short temp,sync_bit_map,id;
    ULONG ioport;
 
    ioport = pCardInfo->si_baseaddr;
@@ -1532,11 +1531,11 @@ static ULONG FlashPoint_HardwareResetHos
    for (id = 0; id < (MAX_SCSI_TAR/2); id++) {
 
 		if(pCurrNvRam){
-			temp = (USHORT) pCurrNvRam->niSyncTbl[id];
+			temp = (unsigned short) pCurrNvRam->niSyncTbl[id];
 			temp = ((temp & 0x03) + ((temp << 4) & 0xc0)) +
 					 (((temp << 4) & 0x0300) + ((temp << 8) & 0xc000));
 		}else
-	      temp = FPT_utilEERead(ioport, (USHORT)((SYNC_RATE_TBL/2)+id));
+	      temp = FPT_utilEERead(ioport, (unsigned short)((SYNC_RATE_TBL/2)+id));
 
       for (i = 0; i < 2; temp >>=8,i++) {
 
@@ -1928,7 +1927,7 @@ static int FlashPoint_HandleInterrupt(UL
 {
    PSCCB currSCCB;
    unsigned char thisCard,result,bm_status, bm_int_st;
-   USHORT hp_int;
+   unsigned short hp_int;
    unsigned char i, target;
    ULONG ioport;
 
@@ -2170,7 +2169,7 @@ static int FlashPoint_HandleInterrupt(UL
  *
  *---------------------------------------------------------------------*/
 static unsigned char FPT_SccbMgr_bad_isr(ULONG p_port, unsigned char p_card,
-				 PSCCBcard pCurrCard, USHORT p_int)
+				 PSCCBcard pCurrCard, unsigned short p_int)
 {
    unsigned char temp, ScamFlg;
    PSCCBMgr_tar_info currTar_Info;
@@ -2430,7 +2429,7 @@ static void FPT_SccbMgrTableInitTarget(u
 static unsigned char FPT_sfm(ULONG port, PSCCB pCurrSCCB)
 {
 	unsigned char message;
-	USHORT TimeOutLoop;
+	unsigned short TimeOutLoop;
 
 	TimeOutLoop = 0;
 	while( (!(RD_HARPOON(port+hp_scsisig) & SCSI_REQ)) &&
@@ -2775,7 +2774,7 @@ static void FPT_ssel(ULONG port, unsigne
 
       }  /* auto_loaded */
 
-   WRW_HARPOON((port+hp_fiforead), (USHORT) 0x00);
+   WRW_HARPOON((port+hp_fiforead), (unsigned short) 0x00);
    WR_HARPOON(port+hp_xferstat, 0x00);
 
    WRW_HARPOON((port+hp_intstat), (PROG_HLT | TIMEOUT | SEL | BUS_FREE));
@@ -2877,7 +2876,7 @@ static void FPT_sres(ULONG port, unsigne
       FPT_queueSelectFail(&FPT_BL_Card[p_card],p_card);
 	}
 
-	WRW_HARPOON((port+hp_fiforead), (USHORT) 0x00);
+	WRW_HARPOON((port+hp_fiforead), (unsigned short) 0x00);
 
 
 	our_target = (unsigned char)(RD_HARPOON(port+hp_select_id) >> 4);
@@ -4056,7 +4055,7 @@ static void FPT_sxfrp(ULONG p_port, unsi
 
 static void FPT_schkdd(ULONG port, unsigned char p_card)
 {
-   USHORT TimeOutLoop;
+   unsigned short TimeOutLoop;
 	unsigned char sPhase;
 
    PSCCB currSCCB;
@@ -4079,7 +4078,7 @@ static void FPT_schkdd(ULONG port, unsig
       currSCCB->Sccb_XferCnt = 1;
 
       currSCCB->Sccb_XferState &= ~F_ODD_BALL_CNT;
-      WRW_HARPOON((port+hp_fiforead), (USHORT) 0x00);
+      WRW_HARPOON((port+hp_fiforead), (unsigned short) 0x00);
       WR_HARPOON(port+hp_xferstat, 0x00);
       }
 
@@ -5486,7 +5485,7 @@ static void FPT_hostDataXferAbort(ULONG 
 
             pCurrSCCB->Sccb_SGoffset = remain_cnt;
 
-            pCurrSCCB->Sccb_sgseg = (USHORT)sg_ptr;
+            pCurrSCCB->Sccb_sgseg = (unsigned short)sg_ptr;
 
 
             if ((ULONG)(sg_ptr * SG_ELEMENT_SIZE) == pCurrSCCB->DataLength 
@@ -5631,7 +5630,7 @@ static void FPT_hostDataXferAbort(ULONG 
 
             pCurrSCCB->Sccb_XferState |= F_ALL_XFERRED;
 
-            pCurrSCCB->Sccb_sgseg = (USHORT)(pCurrSCCB->DataLength / SG_ELEMENT_SIZE);
+            pCurrSCCB->Sccb_sgseg = (unsigned short)(pCurrSCCB->DataLength / SG_ELEMENT_SIZE);
 
             }
          }
@@ -5688,7 +5687,7 @@ static void FPT_hostDataXferRestart(PSCC
          currSCCB->Sccb_SGoffset = data_count - currSCCB->Sccb_ATC;
          }
 
-      currSCCB->Sccb_sgseg = (USHORT)sg_index;
+      currSCCB->Sccb_sgseg = (unsigned short)sg_index;
       }
 
    else {
@@ -6465,7 +6464,7 @@ static void FPT_scwtsel(ULONG p_port)
 static void FPT_inisci(unsigned char p_card, ULONG p_port, unsigned char p_our_id)
 {
    unsigned char i,k,max_id;
-   USHORT ee_data;
+   unsigned short ee_data;
 	PNVRamInfo pCurrNvRam;
 
 	pCurrNvRam = FPT_BL_Card[p_card].pNvRamInfo;
@@ -6495,8 +6494,8 @@ static void FPT_inisci(unsigned char p_c
    	   {
       	for (k=0; k < ID_STRING_LENGTH; k+=2)
 	         {
-   	      ee_data = FPT_utilEERead(p_port, (USHORT)((EE_SCAMBASE/2) +
-      	     (USHORT) (i*((USHORT)ID_STRING_LENGTH/2)) + (USHORT)(k/2)));
+   	      ee_data = FPT_utilEERead(p_port, (unsigned short)((EE_SCAMBASE/2) +
+      	     (unsigned short) (i*((unsigned short)ID_STRING_LENGTH/2)) + (unsigned short)(k/2)));
          	FPT_scamInfo[i].id_string[k] = (unsigned char) ee_data;
 	         ee_data >>= 8;
    	      FPT_scamInfo[i].id_string[k+1] = (unsigned char) ee_data;
@@ -6658,7 +6657,7 @@ static unsigned char FPT_scmachid(unsign
 static void FPT_scsavdi(unsigned char p_card, ULONG p_port)
 {
    unsigned char i,k,max_id;
-   USHORT ee_data,sum_data;
+   unsigned short ee_data,sum_data;
 
 
    sum_data = 0x0000;
@@ -6686,8 +6685,8 @@ static void FPT_scsavdi(unsigned char p_
          ee_data <<= 8;
          ee_data |= FPT_scamInfo[i].id_string[k];
          sum_data += ee_data;
-         FPT_utilEEWrite(p_port, ee_data, (USHORT)((EE_SCAMBASE/2) +
-            (USHORT)(i*((USHORT)ID_STRING_LENGTH/2)) + (USHORT)(k/2)));
+         FPT_utilEEWrite(p_port, ee_data, (unsigned short)((EE_SCAMBASE/2) +
+            (unsigned short)(i*((unsigned short)ID_STRING_LENGTH/2)) + (unsigned short)(k/2)));
          }
       }
 
@@ -6787,7 +6786,7 @@ static void FPT_BusMasterInit(ULONG p_po
 
 static void FPT_DiagEEPROM(ULONG p_port)
 {
-   USHORT index,temp,max_wd_cnt;
+   unsigned short index,temp,max_wd_cnt;
 
    if (RD_HARPOON(p_port+hp_page_ctrl) & NARROW_SCSI_CARD)
       max_wd_cnt = EEPROM_WD_CNT;
@@ -7568,11 +7567,11 @@ static void FPT_utilEEWriteOnOff(ULONG p
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_utilEEWrite(ULONG p_port, USHORT ee_data, USHORT ee_addr)
+static void FPT_utilEEWrite(ULONG p_port, unsigned short ee_data, unsigned short ee_addr)
 {
 
    unsigned char ee_value;
-   USHORT i;
+   unsigned short i;
 
    ee_value = (unsigned char)((RD_HARPOON(p_port+hp_ee_ctrl) & (EXT_ARB_ACK | SCSI_TERM_ENA_H))|
 		   (SEE_MS | SEE_CS));
@@ -7619,9 +7618,9 @@ static void FPT_utilEEWrite(ULONG p_port
  *
  *---------------------------------------------------------------------*/
 
-static USHORT FPT_utilEERead(ULONG p_port, USHORT ee_addr)
+static unsigned short FPT_utilEERead(ULONG p_port, unsigned short ee_addr)
 {
-   USHORT i, ee_data1, ee_data2;
+   unsigned short i, ee_data1, ee_data2;
 
 	i = 0;
 	ee_data1 = FPT_utilEEReadOrg(p_port, ee_addr);
@@ -7649,11 +7648,11 @@ static USHORT FPT_utilEERead(ULONG p_por
  *
  *---------------------------------------------------------------------*/
 
-static USHORT FPT_utilEEReadOrg(ULONG p_port, USHORT ee_addr)
+static unsigned short FPT_utilEEReadOrg(ULONG p_port, unsigned short ee_addr)
 {
 
    unsigned char ee_value;
-   USHORT i, ee_data;
+   unsigned short i, ee_data;
 
    ee_value = (unsigned char)((RD_HARPOON(p_port+hp_ee_ctrl) & (EXT_ARB_ACK | SCSI_TERM_ENA_H))|
 		   (SEE_MS | SEE_CS));
@@ -7697,12 +7696,12 @@ static USHORT FPT_utilEEReadOrg(ULONG p_
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_utilEESendCmdAddr(ULONG p_port, unsigned char ee_cmd, USHORT ee_addr)
+static void FPT_utilEESendCmdAddr(ULONG p_port, unsigned char ee_cmd, unsigned short ee_addr)
 {
    unsigned char ee_value;
    unsigned char narrow_flg;
 
-   USHORT i;
+   unsigned short i;
 
 
    narrow_flg= (unsigned char)(RD_HARPOON(p_port+hp_page_ctrl) & NARROW_SCSI_CARD);
@@ -7760,14 +7759,14 @@ static void FPT_utilEESendCmdAddr(ULONG 
 	  }
 }
 
-static USHORT FPT_CalcCrc16(unsigned char buffer[])
+static unsigned short FPT_CalcCrc16(unsigned char buffer[])
 {
-   USHORT crc=0;
+   unsigned short crc=0;
 	int i,j;
-   USHORT ch;
+   unsigned short ch;
    for (i=0; i < ID_STRING_LENGTH; i++)
    {
-      ch = (USHORT) buffer[i];
+      ch = (unsigned short) buffer[i];
 	   for(j=0; j < 8; j++)
 	   {
 		   if ((crc ^ ch) & 1)
_
