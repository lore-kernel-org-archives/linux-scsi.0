From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] cleanup FlashPoint_HardwareResetHostAdapter()
Date: Tue, 21 Jul 2009 13:38:12 +0200
Message-ID: <4A65A8A4.2000506@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:38527 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640AbZGULgA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2009 07:36:00 -0400
Received: by ewy26 with SMTP id 26so2956316ewy.37
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2009 04:35:59 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

cleanups for FlashPoint_HardwareResetHostAdapter()

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
This shouldn't cause semantics.

diff --git a/drivers/scsi/FlashPoint.c b/drivers/scsi/FlashPoint.c
index b898d38..b917975 100644
--- a/drivers/scsi/FlashPoint.c
+++ b/drivers/scsi/FlashPoint.c
@@ -1212,32 +1212,25 @@ static unsigned long FlashPoint_HardwareResetHostAdapter(struct sccb_mgr_info
 
 	ioport = pCardInfo->si_baseaddr;
 
-	for (thisCard = 0; thisCard <= MAX_CARDS; thisCard++) {
-
-		if (thisCard == MAX_CARDS) {
-
-			return FAILURE;
-		}
+	for (thisCard = 0; thisCard < MAX_CARDS; thisCard++) {
 
 		if (FPT_BL_Card[thisCard].ioPort == ioport) {
 
 			CurrCard = &FPT_BL_Card[thisCard];
 			FPT_SccbMgrTableInitCard(CurrCard, thisCard);
 			break;
-		}
 
-		else if (FPT_BL_Card[thisCard].ioPort == 0x00) {
+		} else if (FPT_BL_Card[thisCard].ioPort == 0x00) {
 
 			FPT_BL_Card[thisCard].ioPort = ioport;
 			CurrCard = &FPT_BL_Card[thisCard];
 
-			if (FPT_mbCards)
-				for (i = 0; i < FPT_mbCards; i++) {
-					if (CurrCard->ioPort ==
-					    FPT_nvRamInfo[i].niBaseAddr)
-						CurrCard->pNvRamInfo =
-						    &FPT_nvRamInfo[i];
-				}
+			for (i = 0; i < FPT_mbCards; i++) {
+				if (CurrCard->ioPort ==
+						FPT_nvRamInfo[i].niBaseAddr)
+					CurrCard->pNvRamInfo =
+						&FPT_nvRamInfo[i];
+			}
 			FPT_SccbMgrTableInitCard(CurrCard, thisCard);
 			CurrCard->cardIndex = thisCard;
 			CurrCard->cardInfo = pCardInfo;
@@ -1245,23 +1238,23 @@ static unsigned long FlashPoint_HardwareResetHostAdapter(struct sccb_mgr_info
 			break;
 		}
 	}
+	if (thisCard == MAX_CARDS)
+		return FAILURE;
 
 	pCurrNvRam = CurrCard->pNvRamInfo;
 
-	if (pCurrNvRam) {
+	if (pCurrNvRam)
 		ScamFlg = pCurrNvRam->niScamConf;
-	} else {
+	else
 		ScamFlg =
 		    (unsigned char)FPT_utilEERead(ioport, SCAM_CONFIG / 2);
-	}
 
 	FPT_BusMasterInit(ioport);
 	FPT_XbowInit(ioport, ScamFlg);
 
 	FPT_autoLoadDefaultMap(ioport);
 
-	for (i = 0, id = 0x01; i != pCardInfo->si_id; i++, id <<= 1) {
-	}
+	id = 0x01 << pCardInfo->si_id;
 
 	WR_HARPOON(ioport + hp_selfid_0, id);
 	WR_HARPOON(ioport + hp_selfid_1, 0x00);
