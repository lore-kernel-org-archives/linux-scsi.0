From: akpm@osdl.org
Subject: [patch 17/28] drivers/scsi/FlashPoint.c: untypedef struct NVRAMInfo
Date: Wed, 08 Mar 2006 00:14:33 -0800
Message-ID: <200603080816.k288GMaw002207@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:32940 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932471AbWCHIQZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2006 03:16:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, adobriyan@gmail.com


From: Alexey Dobriyan <adobriyan@gmail.com>

* struct NVRAMInfo => struct nvram_info
* PNVRamInfo => struct nvram_info *
* NVRAMINFO => struct nvram_info

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/FlashPoint.c |   27 +++++++++++++--------------
 1 files changed, 13 insertions(+), 14 deletions(-)

diff -puN drivers/scsi/FlashPoint.c~drivers-scsi-flashpointc-untypedef-struct-nvraminfo drivers/scsi/FlashPoint.c
--- 25/drivers/scsi/FlashPoint.c~drivers-scsi-flashpointc-untypedef-struct-nvraminfo	Mon Feb  6 14:50:17 2006
+++ 25-akpm/drivers/scsi/FlashPoint.c	Mon Feb  6 14:50:17 2006
@@ -285,7 +285,7 @@ struct sccb_mgr_tar_info {
    unsigned char    TarLUNBusy[MAX_LUN];
 };
 
-typedef struct NVRAMInfo {
+struct nvram_info {
 	unsigned char		niModel;								/* Model No. of card */
 	unsigned char		niCardNo;							/* Card no. */
 	unsigned long		niBaseAddr;							/* Port Address of card */
@@ -295,9 +295,8 @@ typedef struct NVRAMInfo {
 	unsigned char		niAdapId;							/* Host Adapter ID - Byte 24 of eerpom map */
 	unsigned char		niSyncTbl[MAX_SCSI_TAR / 2];	/* Sync/Wide byte of targets */
 	unsigned char		niScamTbl[MAX_SCSI_TAR][4];	/* Compressed Scam name string of Targets */
-}NVRAMINFO;
+};
 
-typedef NVRAMINFO *PNVRamInfo;
 
 #define	MODEL_LT		1
 #define	MODEL_DL		2
@@ -318,7 +317,7 @@ typedef struct SCCBcard {
    unsigned char scanIndex;
    unsigned char globalFlags;
    unsigned char ourId;
-   PNVRamInfo pNvRamInfo;
+   struct nvram_info * pNvRamInfo;
    struct sccb * discQ_Tbl[QUEUE_DEPTH];
       
 }SCCBCARD;
@@ -987,7 +986,7 @@ static void  FPT_queueFlushTargSccb(unsi
 				    unsigned char error_code);
 
 static void  FPT_sinits(struct sccb * p_sccb, unsigned char p_card);
-static void  FPT_RNVRamData(PNVRamInfo pNvRamInfo);
+static void  FPT_RNVRamData(struct nvram_info * pNvRamInfo);
 
 static unsigned char FPT_siwidn(unsigned long port, unsigned char p_card);
 static void  FPT_stwidn(unsigned long port, unsigned char p_card);
@@ -1083,7 +1082,7 @@ static void  FPT_autoLoadDefaultMap(unsi
 static struct sccb_mgr_tar_info FPT_sccbMgrTbl[MAX_CARDS][MAX_SCSI_TAR] = { { { 0 } } };
 static SCCBCARD FPT_BL_Card[MAX_CARDS] = { { 0 } };
 static SCCBSCAM_INFO FPT_scamInfo[MAX_SCSI_TAR] = { { { 0 } } };
-static NVRAMINFO FPT_nvRamInfo[MAX_MB_CARDS] = { { 0 } };
+static struct nvram_info FPT_nvRamInfo[MAX_MB_CARDS] = { { 0 } };
 
 
 static unsigned char FPT_mbCards = 0;
@@ -1113,7 +1112,7 @@ static int FlashPoint_ProbeHostAdapter(s
    unsigned char i,j,id,ScamFlg;
    unsigned short temp,temp2,temp3,temp4,temp5,temp6;
    unsigned long ioport;
-	PNVRamInfo pCurrNvRam;
+	struct nvram_info * pCurrNvRam;
 
    ioport = pCardInfo->si_baseaddr;
 
@@ -1387,7 +1386,7 @@ static int FlashPoint_ProbeHostAdapter(s
 static unsigned long FlashPoint_HardwareResetHostAdapter(struct sccb_mgr_info * pCardInfo)
 {
    PSCCBcard CurrCard = NULL;
-	PNVRamInfo pCurrNvRam;
+	struct nvram_info * pCurrNvRam;
    unsigned char i,j,thisCard, ScamFlg;
    unsigned short temp,sync_bit_map,id;
    unsigned long ioport;
@@ -1572,7 +1571,7 @@ static void FlashPoint_ReleaseHostAdapte
 	unsigned long regOffset;
 	unsigned long scamData;
 	unsigned long *pScamTbl;
-	PNVRamInfo pCurrNvRam;
+	struct nvram_info * pCurrNvRam;
 
 	pCurrNvRam = ((PSCCBcard)pCurrCard)->pNvRamInfo;
 
@@ -1601,7 +1600,7 @@ static void FlashPoint_ReleaseHostAdapte
 }
 
 
-static void FPT_RNVRamData(PNVRamInfo pNvRamInfo)
+static void FPT_RNVRamData(struct nvram_info * pNvRamInfo)
 {
 	unsigned char i;
 	unsigned long portBase;
@@ -2161,7 +2160,7 @@ static unsigned char FPT_SccbMgr_bad_isr
 {
    unsigned char temp, ScamFlg;
    struct sccb_mgr_tar_info * currTar_Info;
-   PNVRamInfo pCurrNvRam;
+   struct nvram_info * pCurrNvRam;
 
 
    if (RD_HARPOON(p_port+hp_ext_status) &
@@ -5701,7 +5700,7 @@ static void FPT_scini(unsigned char p_ca
 
    unsigned char i,k,ScamFlg ;
    PSCCBcard currCard;
-	PNVRamInfo pCurrNvRam;
+	struct nvram_info * pCurrNvRam;
 
    currCard = &FPT_BL_Card[p_card];
    p_port = currCard->ioPort;
@@ -5992,7 +5991,7 @@ static void FPT_scasid(unsigned char p_c
 
    unsigned char i,k,scam_id;
 	unsigned char crcBytes[3];
-	PNVRamInfo pCurrNvRam;
+	struct nvram_info * pCurrNvRam;
 	unsigned short * pCrcBytes;
 
 	pCurrNvRam = FPT_BL_Card[p_card].pNvRamInfo;
@@ -6453,7 +6452,7 @@ static void FPT_inisci(unsigned char p_c
 {
    unsigned char i,k,max_id;
    unsigned short ee_data;
-	PNVRamInfo pCurrNvRam;
+	struct nvram_info * pCurrNvRam;
 
 	pCurrNvRam = FPT_BL_Card[p_card].pNvRamInfo;
 
_
