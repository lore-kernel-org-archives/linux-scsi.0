From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] scsi/FlashPoint.c: fix off-by-one errors
Date: Wed, 23 Apr 2008 12:51:10 +0300
Message-ID: <20080423095110.GX28933@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp6.pp.htv.fi ([213.243.153.40]:59428 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755547AbYDWJvt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Apr 2008 05:51:49 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This patch fixes off-by-one errors in error checks (the variables are 
used as array indexes for arrays with MAX_SCSI_TAR resp. MAX_LUN 
elements) spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
02fc526feb4e67cfb0008e04f5b797e8315b9cd4 diff --git a/drivers/scsi/FlashPoint.c b/drivers/scsi/FlashPoint.c
index b374e45..b898d38 100644
--- a/drivers/scsi/FlashPoint.c
+++ b/drivers/scsi/FlashPoint.c
@@ -1499,7 +1499,7 @@ static void FlashPoint_StartCCB(unsigned long pCurrCard, struct sccb *p_Sccb)
 	thisCard = ((struct sccb_card *)pCurrCard)->cardIndex;
 	ioport = ((struct sccb_card *)pCurrCard)->ioPort;
 
-	if ((p_Sccb->TargID > MAX_SCSI_TAR) || (p_Sccb->Lun > MAX_LUN)) {
+	if ((p_Sccb->TargID >= MAX_SCSI_TAR) || (p_Sccb->Lun >= MAX_LUN)) {
 
 		p_Sccb->HostStatus = SCCB_COMPLETE;
 		p_Sccb->SccbStatus = SCCB_ERROR;

