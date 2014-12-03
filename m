From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/12] advansys: use 'bool' instead of 'int'
Date: Wed,  3 Dec 2014 12:45:00 +0100
Message-ID: <1417607105-85455-8-git-send-email-hare@suse.de>
References: <1417607105-85455-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55184 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838AbaLCLpM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2014 06:45:12 -0500
In-Reply-To: <1417607105-85455-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Matthew Wilcox <matthew@wil.cx>, Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/advansys.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 0aea820..0d29d0b 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -3820,17 +3820,17 @@ static int AscStopChip(PortAddr iop_base)
 	return (1);
 }
 
-static int AscIsChipHalted(PortAddr iop_base)
+static bool AscIsChipHalted(PortAddr iop_base)
 {
 	if ((AscGetChipStatus(iop_base) & CSW_HALTED) != 0) {
 		if ((AscGetChipControl(iop_base) & CC_HALT) != 0) {
-			return (1);
+			return true;
 		}
 	}
-	return (0);
+	return false;
 }
 
-static int AscResetChipAndScsiBus(ASC_DVC_VAR *asc_dvc)
+static bool AscResetChipAndScsiBus(ASC_DVC_VAR *asc_dvc)
 {
 	PortAddr iop_base;
 	int i = 10;
@@ -6476,11 +6476,11 @@ AscCalSDTRData(ASC_DVC_VAR *asc_dvc, uchar sdtr_period, uchar syn_offset)
 	return byte;
 }
 
-static int AscSetChipSynRegAtID(PortAddr iop_base, uchar id, uchar sdtr_data)
+static bool AscSetChipSynRegAtID(PortAddr iop_base, uchar id, uchar sdtr_data)
 {
 	ASC_SCSI_BIT_ID_TYPE org_id;
 	int i;
-	int sta = TRUE;
+	bool sta = true;
 
 	AscSetBank(iop_base, 1);
 	org_id = AscReadChipDvcID(iop_base);
@@ -6494,10 +6494,10 @@ static int AscSetChipSynRegAtID(PortAddr iop_base, uchar id, uchar sdtr_data)
 		AscSetBank(iop_base, 0);
 		AscSetChipSyn(iop_base, sdtr_data);
 		if (AscGetChipSyn(iop_base) != sdtr_data) {
-			sta = FALSE;
+			sta = false;
 		}
 	} else {
-		sta = FALSE;
+		sta = false;
 	}
 	AscSetBank(iop_base, 1);
 	AscWriteChipDvcID(iop_base, org_id);
@@ -7562,32 +7562,32 @@ static irqreturn_t advansys_interrupt(int irq, void *dev_id)
 	return result;
 }
 
-static int AscHostReqRiscHalt(PortAddr iop_base)
+static bool AscHostReqRiscHalt(PortAddr iop_base)
 {
 	int count = 0;
-	int sta = 0;
+	bool sta = false;
 	uchar saved_stop_code;
 
 	if (AscIsChipHalted(iop_base))
-		return (1);
+		return true;
 	saved_stop_code = AscReadLramByte(iop_base, ASCV_STOP_CODE_B);
 	AscWriteLramByte(iop_base, ASCV_STOP_CODE_B,
 			 ASC_STOP_HOST_REQ_RISC_HALT | ASC_STOP_REQ_RISC_STOP);
 	do {
 		if (AscIsChipHalted(iop_base)) {
-			sta = 1;
+			sta = true;
 			break;
 		}
 		mdelay(100);
 	} while (count++ < 20);
 	AscWriteLramByte(iop_base, ASCV_STOP_CODE_B, saved_stop_code);
-	return (sta);
+	return sta;
 }
 
-static int
+static bool
 AscSetRunChipSynRegAtID(PortAddr iop_base, uchar tid_no, uchar sdtr_data)
 {
-	int sta = FALSE;
+	bool sta = false;
 
 	if (AscHostReqRiscHalt(iop_base)) {
 		sta = AscSetChipSynRegAtID(iop_base, tid_no, sdtr_data);
@@ -9483,7 +9483,7 @@ static ushort AscInitFromEEP(ASC_DVC_VAR *asc_dvc)
 		AscResetChipAndScsiBus(asc_dvc);
 		mdelay(asc_dvc->scsi_reset_wait * 1000); /* XXX: msleep? */
 	}
-	if (AscIsChipHalted(iop_base) == FALSE) {
+	if (!AscIsChipHalted(iop_base)) {
 		asc_dvc->err_code |= ASC_IERR_START_STOP_CHIP;
 		return (warn_code);
 	}
-- 
1.8.5.2

