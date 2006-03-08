From: akpm@osdl.org
Subject: [patch 18/28] drivers/scsi/FlashPoint.c: untypedef struct SCCBcard
Date: Wed, 08 Mar 2006 00:14:34 -0800
Message-ID: <200603080816.k288GN6f002210@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:35244 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932494AbWCHIQ2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2006 03:16:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, adobriyan@gmail.com


From: Alexey Dobriyan <adobriyan@gmail.com>

* struct SCCBcard => struct sccb_card
* PSCCBcard => struct sccb_card *
* SCCBCARD => struct sccb_card

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/FlashPoint.c |  143 +++++++++++++++++-------------------
 1 files changed, 71 insertions(+), 72 deletions(-)

diff -puN drivers/scsi/FlashPoint.c~drivers-scsi-flashpointc-untypedef-struct-sccbcard drivers/scsi/FlashPoint.c
--- 25/drivers/scsi/FlashPoint.c~drivers-scsi-flashpointc-untypedef-struct-sccbcard	Mon Feb  6 14:50:19 2006
+++ 25-akpm/drivers/scsi/FlashPoint.c	Mon Feb  6 14:50:19 2006
@@ -304,7 +304,7 @@ struct nvram_info {
 #define	MODEL_DW		4
 
 
-typedef struct SCCBcard {
+struct sccb_card {
    struct sccb * currentSCCB;
    struct sccb_mgr_info * cardInfo;
 
@@ -320,9 +320,8 @@ typedef struct SCCBcard {
    struct nvram_info * pNvRamInfo;
    struct sccb * discQ_Tbl[QUEUE_DEPTH];
       
-}SCCBCARD;
+};
 
-typedef struct SCCBcard *PSCCBcard;
 
 
 #define F_TAG_STARTED		0x01
@@ -968,7 +967,7 @@ typedef struct SCCBscam_info {
 
 static unsigned char FPT_sisyncn(unsigned long port, unsigned char p_card, unsigned char syncFlag);
 static void  FPT_ssel(unsigned long port, unsigned char p_card);
-static void  FPT_sres(unsigned long port, unsigned char p_card, PSCCBcard pCurrCard);
+static void  FPT_sres(unsigned long port, unsigned char p_card, struct sccb_card * pCurrCard);
 static void  FPT_shandem(unsigned long port, unsigned char p_card,struct sccb * pCurrSCCB);
 static void  FPT_stsyncn(unsigned long port, unsigned char p_card);
 static void  FPT_sisyncr(unsigned long port,unsigned char sync_pulse, unsigned char offset);
@@ -993,11 +992,11 @@ static void  FPT_stwidn(unsigned long po
 static void  FPT_siwidr(unsigned long port, unsigned char width);
 
 
-static void  FPT_queueSelectFail(PSCCBcard pCurrCard, unsigned char p_card);
+static void  FPT_queueSelectFail(struct sccb_card * pCurrCard, unsigned char p_card);
 static void  FPT_queueDisconnect(struct sccb * p_SCCB, unsigned char p_card);
-static void  FPT_queueCmdComplete(PSCCBcard pCurrCard, struct sccb * p_SCCB,
+static void  FPT_queueCmdComplete(struct sccb_card * pCurrCard, struct sccb * p_SCCB,
 				  unsigned char p_card);
-static void  FPT_queueSearchSelect(PSCCBcard pCurrCard, unsigned char p_card);
+static void  FPT_queueSearchSelect(struct sccb_card * pCurrCard, unsigned char p_card);
 static void  FPT_queueFlushSccb(unsigned char p_card, unsigned char error_code);
 static void  FPT_queueAddSccb(struct sccb * p_SCCB, unsigned char card);
 static unsigned char FPT_queueFindSccb(struct sccb * p_SCCB, unsigned char p_card);
@@ -1038,7 +1037,7 @@ static void  FPT_DiagEEPROM(unsigned lon
 
 
 
-static void  FPT_dataXferProcessor(unsigned long port, PSCCBcard pCurrCard);
+static void  FPT_dataXferProcessor(unsigned long port, struct sccb_card * pCurrCard);
 static void  FPT_busMstrSGDataXferStart(unsigned long port, struct sccb * pCurrSCCB);
 static void  FPT_busMstrDataXferStart(unsigned long port, struct sccb * pCurrSCCB);
 static void  FPT_hostDataXferAbort(unsigned long port, unsigned char p_card, struct sccb * pCurrSCCB);
@@ -1046,10 +1045,10 @@ static void  FPT_hostDataXferRestart(str
 
 
 static unsigned char FPT_SccbMgr_bad_isr(unsigned long p_port, unsigned char p_card,
-				 PSCCBcard pCurrCard, unsigned short p_int);
+				 struct sccb_card * pCurrCard, unsigned short p_int);
 
 static void  FPT_SccbMgrTableInitAll(void);
-static void  FPT_SccbMgrTableInitCard(PSCCBcard pCurrCard, unsigned char p_card);
+static void  FPT_SccbMgrTableInitCard(struct sccb_card * pCurrCard, unsigned char p_card);
 static void  FPT_SccbMgrTableInitTarget(unsigned char p_card, unsigned char target);
 
 
@@ -1080,7 +1079,7 @@ static void  FPT_autoLoadDefaultMap(unsi
 
 
 static struct sccb_mgr_tar_info FPT_sccbMgrTbl[MAX_CARDS][MAX_SCSI_TAR] = { { { 0 } } };
-static SCCBCARD FPT_BL_Card[MAX_CARDS] = { { 0 } };
+static struct sccb_card FPT_BL_Card[MAX_CARDS] = { { 0 } };
 static SCCBSCAM_INFO FPT_scamInfo[MAX_SCSI_TAR] = { { { 0 } } };
 static struct nvram_info FPT_nvRamInfo[MAX_MB_CARDS] = { { 0 } };
 
@@ -1385,7 +1384,7 @@ static int FlashPoint_ProbeHostAdapter(s
 
 static unsigned long FlashPoint_HardwareResetHostAdapter(struct sccb_mgr_info * pCardInfo)
 {
-   PSCCBcard CurrCard = NULL;
+   struct sccb_card * CurrCard = NULL;
 	struct nvram_info * pCurrNvRam;
    unsigned char i,j,thisCard, ScamFlg;
    unsigned short temp,sync_bit_map,id;
@@ -1573,7 +1572,7 @@ static void FlashPoint_ReleaseHostAdapte
 	unsigned long *pScamTbl;
 	struct nvram_info * pCurrNvRam;
 
-	pCurrNvRam = ((PSCCBcard)pCurrCard)->pNvRamInfo;
+	pCurrNvRam = ((struct sccb_card *)pCurrCard)->pNvRamInfo;
 
 	if(pCurrNvRam){
 		FPT_WrStack(pCurrNvRam->niBaseAddr, 0, pCurrNvRam->niModel);
@@ -1595,7 +1594,7 @@ static void FlashPoint_ReleaseHostAdapte
 		}
 
 	}else{
-		FPT_WrStack(((PSCCBcard)pCurrCard)->ioPort, 0, 0);
+		FPT_WrStack(((struct sccb_card *)pCurrCard)->ioPort, 0, 0);
 	}
 }
 
@@ -1670,8 +1669,8 @@ static void FlashPoint_StartCCB(unsigned
 	struct sccb * pSaveSccb;
    CALL_BK_FN callback;
 
-   thisCard = ((PSCCBcard) pCurrCard)->cardIndex;
-   ioport = ((PSCCBcard) pCurrCard)->ioPort;
+   thisCard = ((struct sccb_card *) pCurrCard)->cardIndex;
+   ioport = ((struct sccb_card *) pCurrCard)->ioPort;
 
 	if((p_Sccb->TargID > MAX_SCSI_TAR) || (p_Sccb->Lun > MAX_LUN))
 	{
@@ -1688,19 +1687,19 @@ static void FlashPoint_StartCCB(unsigned
    FPT_sinits(p_Sccb,thisCard);
 
 
-   if (!((PSCCBcard) pCurrCard)->cmdCounter)
+   if (!((struct sccb_card *) pCurrCard)->cmdCounter)
       {
       WR_HARPOON(ioport+hp_semaphore, (RD_HARPOON(ioport+hp_semaphore)
          | SCCB_MGR_ACTIVE));
 
-      if (((PSCCBcard) pCurrCard)->globalFlags & F_GREEN_PC)
+      if (((struct sccb_card *) pCurrCard)->globalFlags & F_GREEN_PC)
          {
 		 WR_HARPOON(ioport+hp_clkctrl_0, CLKCTRL_DEFAULT);
 		 WR_HARPOON(ioport+hp_sys_ctrl, 0x00);
          }
       }
 
-   ((PSCCBcard)pCurrCard)->cmdCounter++;
+   ((struct sccb_card *)pCurrCard)->cmdCounter++;
 
    if (RD_HARPOON(ioport+hp_semaphore) & BIOS_IN_USE) {
 
@@ -1708,10 +1707,10 @@ static void FlashPoint_StartCCB(unsigned
          | TICKLE_ME));
 		if(p_Sccb->OperationCode == RESET_COMMAND)
 			{
-				pSaveSccb = ((PSCCBcard) pCurrCard)->currentSCCB;
-				((PSCCBcard) pCurrCard)->currentSCCB = p_Sccb;
+				pSaveSccb = ((struct sccb_card *) pCurrCard)->currentSCCB;
+				((struct sccb_card *) pCurrCard)->currentSCCB = p_Sccb;
 				FPT_queueSelectFail(&FPT_BL_Card[thisCard], thisCard);
-				((PSCCBcard) pCurrCard)->currentSCCB = pSaveSccb;
+				((struct sccb_card *) pCurrCard)->currentSCCB = pSaveSccb;
 			}
 		else
 			{
@@ -1723,10 +1722,10 @@ static void FlashPoint_StartCCB(unsigned
 
 			if(p_Sccb->OperationCode == RESET_COMMAND)
 				{
-					pSaveSccb = ((PSCCBcard) pCurrCard)->currentSCCB;
-					((PSCCBcard) pCurrCard)->currentSCCB = p_Sccb;
+					pSaveSccb = ((struct sccb_card *) pCurrCard)->currentSCCB;
+					((struct sccb_card *) pCurrCard)->currentSCCB = p_Sccb;
 					FPT_queueSelectFail(&FPT_BL_Card[thisCard], thisCard);
-					((PSCCBcard) pCurrCard)->currentSCCB = pSaveSccb;
+					((struct sccb_card *) pCurrCard)->currentSCCB = pSaveSccb;
 				}
 			else
 				{
@@ -1738,17 +1737,17 @@ static void FlashPoint_StartCCB(unsigned
 
       MDISABLE_INT(ioport);
 
-		if((((PSCCBcard) pCurrCard)->globalFlags & F_CONLUN_IO) && 
+		if((((struct sccb_card *) pCurrCard)->globalFlags & F_CONLUN_IO) &&
 			((FPT_sccbMgrTbl[thisCard][p_Sccb->TargID].TarStatus & TAR_TAG_Q_MASK) != TAG_Q_TRYING))
 			lun = p_Sccb->Lun;
 		else
 			lun = 0;
-      if ((((PSCCBcard) pCurrCard)->currentSCCB == NULL) &&
+      if ((((struct sccb_card *) pCurrCard)->currentSCCB == NULL) &&
          (FPT_sccbMgrTbl[thisCard][p_Sccb->TargID].TarSelQ_Cnt == 0) &&
          (FPT_sccbMgrTbl[thisCard][p_Sccb->TargID].TarLUNBusy[lun]
          == 0)) {
 
-            ((PSCCBcard) pCurrCard)->currentSCCB = p_Sccb;
+            ((struct sccb_card *) pCurrCard)->currentSCCB = p_Sccb;
 	    FPT_ssel(p_Sccb->SccbIOPort,thisCard);
          }
 
@@ -1756,10 +1755,10 @@ static void FlashPoint_StartCCB(unsigned
 
 			if(p_Sccb->OperationCode == RESET_COMMAND)
 				{
-					pSaveSccb = ((PSCCBcard) pCurrCard)->currentSCCB;
-					((PSCCBcard) pCurrCard)->currentSCCB = p_Sccb;
+					pSaveSccb = ((struct sccb_card *) pCurrCard)->currentSCCB;
+					((struct sccb_card *) pCurrCard)->currentSCCB = p_Sccb;
 					FPT_queueSelectFail(&FPT_BL_Card[thisCard], thisCard);
-					((PSCCBcard) pCurrCard)->currentSCCB = pSaveSccb;
+					((struct sccb_card *) pCurrCard)->currentSCCB = pSaveSccb;
 				}
 			else
 				{
@@ -1794,9 +1793,9 @@ static int FlashPoint_AbortCCB(unsigned 
 	struct sccb_mgr_tar_info * currTar_Info;
 
 
-	ioport = ((PSCCBcard) pCurrCard)->ioPort;
+	ioport = ((struct sccb_card *) pCurrCard)->ioPort;
 
-	thisCard = ((PSCCBcard)pCurrCard)->cardIndex;
+	thisCard = ((struct sccb_card *)pCurrCard)->cardIndex;
 
 	if (!(RD_HARPOON(ioport+hp_page_ctrl) & G_INT_DISABLE))
 	{
@@ -1804,9 +1803,9 @@ static int FlashPoint_AbortCCB(unsigned 
 		if (FPT_queueFindSccb(p_Sccb,thisCard))
 		{
 
-			((PSCCBcard)pCurrCard)->cmdCounter--;
+			((struct sccb_card *)pCurrCard)->cmdCounter--;
 
-			if (!((PSCCBcard)pCurrCard)->cmdCounter)
+			if (!((struct sccb_card *)pCurrCard)->cmdCounter)
 				WR_HARPOON(ioport+hp_semaphore,(RD_HARPOON(ioport+hp_semaphore)
 					& (unsigned char)(~(SCCB_MGR_ACTIVE | TICKLE_ME)) ));
 
@@ -1819,7 +1818,7 @@ static int FlashPoint_AbortCCB(unsigned 
 
 		else
 		{
-			if (((PSCCBcard)pCurrCard)->currentSCCB == p_Sccb)
+			if (((struct sccb_card *)pCurrCard)->currentSCCB == p_Sccb)
 			{
 				p_Sccb->SccbStatus = SCCB_ABORT;
 				return(0);
@@ -1835,23 +1834,23 @@ static int FlashPoint_AbortCCB(unsigned 
 				if(p_Sccb->Sccb_tag)
 				{
 					MDISABLE_INT(ioport);
-					if (((PSCCBcard) pCurrCard)->discQ_Tbl[p_Sccb->Sccb_tag]==p_Sccb)
+					if (((struct sccb_card *) pCurrCard)->discQ_Tbl[p_Sccb->Sccb_tag]==p_Sccb)
 					{
 						p_Sccb->SccbStatus = SCCB_ABORT;
 						p_Sccb->Sccb_scsistat = ABORT_ST;
 						p_Sccb->Sccb_scsimsg = SMABORT_TAG;
 
-						if(((PSCCBcard) pCurrCard)->currentSCCB == NULL)
+						if(((struct sccb_card *) pCurrCard)->currentSCCB == NULL)
 						{
-							((PSCCBcard) pCurrCard)->currentSCCB = p_Sccb;
+							((struct sccb_card *) pCurrCard)->currentSCCB = p_Sccb;
 							FPT_ssel(ioport, thisCard);
 						}
 						else
 						{
-							pSaveSCCB = ((PSCCBcard) pCurrCard)->currentSCCB;
-							((PSCCBcard) pCurrCard)->currentSCCB = p_Sccb;
-							FPT_queueSelectFail((PSCCBcard) pCurrCard, thisCard);
-							((PSCCBcard) pCurrCard)->currentSCCB = pSaveSCCB;
+							pSaveSCCB = ((struct sccb_card *) pCurrCard)->currentSCCB;
+							((struct sccb_card *) pCurrCard)->currentSCCB = p_Sccb;
+							FPT_queueSelectFail((struct sccb_card *) pCurrCard, thisCard);
+							((struct sccb_card *) pCurrCard)->currentSCCB = pSaveSCCB;
 						}
 					}
 					MENABLE_INT(ioport);
@@ -1887,7 +1886,7 @@ static unsigned char FlashPoint_Interrup
 {
    unsigned long ioport;
 
-   ioport = ((PSCCBcard)pCurrCard)->ioPort;
+   ioport = ((struct sccb_card *)pCurrCard)->ioPort;
 
    if (RD_HARPOON(ioport+hp_int_status) & INT_ASSERTED)
    {
@@ -1918,8 +1917,8 @@ static int FlashPoint_HandleInterrupt(un
    unsigned char i, target;
    unsigned long ioport;
 
-   thisCard = ((PSCCBcard)pCurrCard)->cardIndex;
-   ioport = ((PSCCBcard)pCurrCard)->ioPort;
+   thisCard = ((struct sccb_card *)pCurrCard)->cardIndex;
+   ioport = ((struct sccb_card *)pCurrCard)->ioPort;
 
    MDISABLE_INT(ioport);
 
@@ -1934,10 +1933,10 @@ static int FlashPoint_HandleInterrupt(un
 	  bm_status)
      {
 
-       currSCCB = ((PSCCBcard)pCurrCard)->currentSCCB;
+       currSCCB = ((struct sccb_card *)pCurrCard)->currentSCCB;
 
       if (hp_int & (FIFO | TIMEOUT | RESET | SCAM_SEL) || bm_status) {
-         result = FPT_SccbMgr_bad_isr(ioport,thisCard,((PSCCBcard)pCurrCard),hp_int);
+         result = FPT_SccbMgr_bad_isr(ioport,thisCard,((struct sccb_card *)pCurrCard),hp_int);
          WRW_HARPOON((ioport+hp_intstat), (FIFO | TIMEOUT | RESET | SCAM_SEL));
          bm_status = 0;
 
@@ -1960,7 +1959,7 @@ static int FlashPoint_HandleInterrupt(un
 	   while (!(RDW_HARPOON((ioport+hp_intstat)) & (BUS_FREE | RSEL))) ;
 	 }
 
-         if (((PSCCBcard)pCurrCard)->globalFlags & F_HOST_XFER_ACT)
+         if (((struct sccb_card *)pCurrCard)->globalFlags & F_HOST_XFER_ACT)
 
             FPT_phaseChkFifo(ioport, thisCard);
 
@@ -1978,7 +1977,7 @@ static int FlashPoint_HandleInterrupt(un
       else if (hp_int & ITAR_DISC)
          {
 
-         if (((PSCCBcard)pCurrCard)->globalFlags & F_HOST_XFER_ACT) {
+         if (((struct sccb_card *)pCurrCard)->globalFlags & F_HOST_XFER_ACT) {
 
             FPT_phaseChkFifo(ioport, thisCard);
 
@@ -2019,7 +2018,7 @@ static int FlashPoint_HandleInterrupt(un
          WRW_HARPOON((ioport+hp_intstat), (BUS_FREE | ITAR_DISC));
 
 
-         ((PSCCBcard)pCurrCard)->globalFlags |= F_NEW_SCCB_CMD;
+         ((struct sccb_card *)pCurrCard)->globalFlags |= F_NEW_SCCB_CMD;
 
       	}
 
@@ -2030,7 +2029,7 @@ static int FlashPoint_HandleInterrupt(un
 
          if (RDW_HARPOON((ioport+hp_intstat)) & ITAR_DISC)
 		      {
-            if (((PSCCBcard)pCurrCard)->globalFlags & F_HOST_XFER_ACT)
+            if (((struct sccb_card *)pCurrCard)->globalFlags & F_HOST_XFER_ACT)
 			      {
                FPT_phaseChkFifo(ioport, thisCard);
                }
@@ -2047,7 +2046,7 @@ static int FlashPoint_HandleInterrupt(un
             FPT_queueDisconnect(currSCCB,thisCard);
             }
 
-         FPT_sres(ioport,thisCard,((PSCCBcard)pCurrCard));
+         FPT_sres(ioport,thisCard,((struct sccb_card *)pCurrCard));
          FPT_phaseDecode(ioport,thisCard);
 
          }
@@ -2101,7 +2100,7 @@ static int FlashPoint_HandleInterrupt(un
 
          WRW_HARPOON((ioport+hp_intstat), BUS_FREE);
 
-        	if (((PSCCBcard)pCurrCard)->globalFlags & F_HOST_XFER_ACT) {
+        	if (((struct sccb_card *)pCurrCard)->globalFlags & F_HOST_XFER_ACT) {
 
            	FPT_hostDataXferAbort(ioport,thisCard,currSCCB);
 				}
@@ -2113,24 +2112,24 @@ static int FlashPoint_HandleInterrupt(un
       else if (hp_int & ITICKLE) {
 
          WRW_HARPOON((ioport+hp_intstat), ITICKLE);
-         ((PSCCBcard)pCurrCard)->globalFlags |= F_NEW_SCCB_CMD;
+         ((struct sccb_card *)pCurrCard)->globalFlags |= F_NEW_SCCB_CMD;
          }
 
 
 
-      if (((PSCCBcard)pCurrCard)->globalFlags & F_NEW_SCCB_CMD) {
+      if (((struct sccb_card *)pCurrCard)->globalFlags & F_NEW_SCCB_CMD) {
 
 
-         ((PSCCBcard)pCurrCard)->globalFlags &= ~F_NEW_SCCB_CMD;
+         ((struct sccb_card *)pCurrCard)->globalFlags &= ~F_NEW_SCCB_CMD;
 
 
-         if (((PSCCBcard)pCurrCard)->currentSCCB == NULL) {
+         if (((struct sccb_card *)pCurrCard)->currentSCCB == NULL) {
 
-            FPT_queueSearchSelect(((PSCCBcard)pCurrCard),thisCard);
+            FPT_queueSearchSelect(((struct sccb_card *)pCurrCard),thisCard);
             }
 
-         if (((PSCCBcard)pCurrCard)->currentSCCB != NULL) {
-            ((PSCCBcard)pCurrCard)->globalFlags &= ~F_NEW_SCCB_CMD;
+         if (((struct sccb_card *)pCurrCard)->currentSCCB != NULL) {
+            ((struct sccb_card *)pCurrCard)->globalFlags &= ~F_NEW_SCCB_CMD;
             FPT_ssel(ioport,thisCard);
             }
 
@@ -2156,7 +2155,7 @@ static int FlashPoint_HandleInterrupt(un
  *
  *---------------------------------------------------------------------*/
 static unsigned char FPT_SccbMgr_bad_isr(unsigned long p_port, unsigned char p_card,
-				 PSCCBcard pCurrCard, unsigned short p_int)
+				 struct sccb_card * pCurrCard, unsigned short p_int)
 {
    unsigned char temp, ScamFlg;
    struct sccb_mgr_tar_info * currTar_Info;
@@ -2332,7 +2331,7 @@ static void FPT_SccbMgrTableInitAll()
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_SccbMgrTableInitCard(PSCCBcard pCurrCard, unsigned char p_card)
+static void FPT_SccbMgrTableInitCard(struct sccb_card * pCurrCard, unsigned char p_card)
 {
    unsigned char scsiID, qtag;
 
@@ -2492,7 +2491,7 @@ static void FPT_ssel(unsigned long port,
    unsigned char auto_loaded, i, target, *theCCB;
 
    unsigned long cdb_reg;
-   PSCCBcard CurrCard;
+   struct sccb_card * CurrCard;
    struct sccb * currSCCB;
    struct sccb_mgr_tar_info * currTar_Info;
    unsigned char lastTag, lun;
@@ -2797,7 +2796,7 @@ static void FPT_ssel(unsigned long port,
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_sres(unsigned long port, unsigned char p_card, PSCCBcard pCurrCard)
+static void FPT_sres(unsigned long port, unsigned char p_card, struct sccb_card * pCurrCard)
 {
 
    unsigned char our_target, message, lun = 0, tag, msgRetryCount;
@@ -3110,7 +3109,7 @@ static void FPT_SendMsg(unsigned long po
 static void FPT_sdecm(unsigned char message, unsigned long port, unsigned char p_card)
 {
 	struct sccb * currSCCB;
-	PSCCBcard CurrCard;
+	struct sccb_card * CurrCard;
 	struct sccb_mgr_tar_info * currTar_Info;
 
 	CurrCard = &FPT_BL_Card[p_card];
@@ -3909,7 +3908,7 @@ static void FPT_sresb(unsigned long port
  * Description: Setup for the Auto Sense command.
  *
  *---------------------------------------------------------------------*/
-static void FPT_ssenss(PSCCBcard pCurrCard)
+static void FPT_ssenss(struct sccb_card * pCurrCard)
 {
    unsigned char i;
    struct sccb * currSCCB;
@@ -5151,7 +5150,7 @@ static void FPT_autoCmdCmplt(unsigned lo
  *              
  *---------------------------------------------------------------------*/
 
-static void FPT_dataXferProcessor(unsigned long port, PSCCBcard pCurrCard)
+static void FPT_dataXferProcessor(unsigned long port, struct sccb_card * pCurrCard)
 {
    struct sccb * currSCCB;
 
@@ -5699,7 +5698,7 @@ static void FPT_scini(unsigned char p_ca
    unsigned long p_port;
 
    unsigned char i,k,ScamFlg ;
-   PSCCBcard currCard;
+   struct sccb_card * currCard;
 	struct nvram_info * pCurrNvRam;
 
    currCard = &FPT_BL_Card[p_card];
@@ -6931,7 +6930,7 @@ static void FPT_DiagEEPROM(unsigned long
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_queueSearchSelect(PSCCBcard pCurrCard, unsigned char p_card)
+static void FPT_queueSearchSelect(struct sccb_card * pCurrCard, unsigned char p_card)
 {
    unsigned char scan_ptr, lun;
    struct sccb_mgr_tar_info * currTar_Info;
@@ -7062,7 +7061,7 @@ static void FPT_queueSearchSelect(PSCCBc
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_queueSelectFail(PSCCBcard pCurrCard, unsigned char p_card)
+static void FPT_queueSelectFail(struct sccb_card * pCurrCard, unsigned char p_card)
 {
    unsigned char thisTarg;
    struct sccb_mgr_tar_info * currTar_Info;
@@ -7101,7 +7100,7 @@ static void FPT_queueSelectFail(PSCCBcar
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_queueCmdComplete(PSCCBcard pCurrCard, struct sccb * p_sccb,
+static void FPT_queueCmdComplete(struct sccb_card * pCurrCard, struct sccb * p_sccb,
 				 unsigned char p_card)
 {
 
_
