From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/12] advansys: Remove 'ERR' definition
Date: Wed,  3 Dec 2014 12:45:03 +0100
Message-ID: <1417607105-85455-11-git-send-email-hare@suse.de>
References: <1417607105-85455-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55173 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233AbaLCLpK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2014 06:45:10 -0500
In-Reply-To: <1417607105-85455-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Matthew Wilcox <matthew@wil.cx>, Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/advansys.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 42e9dc6..14a4571 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -78,7 +78,6 @@
 
 typedef unsigned char uchar;
 
-#define ERR      (-1)
 #define UW_ERR   (uint)(0xFFFF)
 #define isodd_word(val)   ((((uint)val) & (uint)0x0001) != 0)
 
@@ -7276,33 +7275,33 @@ static int AscIsrQDone(ASC_DVC_VAR *asc_dvc)
 	return (0);
 }
 
-static int AscISR(ASC_DVC_VAR *asc_dvc)
+static void AscISR(ASC_DVC_VAR *asc_dvc)
 {
 	ASC_CS_TYPE chipstat;
 	PortAddr iop_base;
 	ushort saved_ram_addr;
 	uchar ctrl_reg;
 	uchar saved_ctrl_reg;
-	int int_pending;
+	bool int_pending;
 	int status;
 	uchar host_flag;
 
 	iop_base = asc_dvc->iop_base;
-	int_pending = ASC_FALSE;
+	int_pending = false;
 
 	if (AscIsIntPending(iop_base) == 0)
-		return int_pending;
+		return;
 
 	if ((asc_dvc->init_state & ASC_INIT_STATE_END_LOAD_MC) == 0) {
-		return ASC_ERROR;
+		return;
 	}
 	if (asc_dvc->in_critical_cnt != 0) {
 		AscSetLibErrorCode(asc_dvc, ASCQ_ERR_ISR_ON_CRITICAL);
-		return ASC_ERROR;
+		return;
 	}
 	if (asc_dvc->is_in_int) {
 		AscSetLibErrorCode(asc_dvc, ASCQ_ERR_ISR_RE_ENTRY);
-		return ASC_ERROR;
+		return;
 	}
 	asc_dvc->is_in_int = true;
 	ctrl_reg = AscGetChipControl(iop_base);
@@ -7312,7 +7311,7 @@ static int AscISR(ASC_DVC_VAR *asc_dvc)
 	if (chipstat & CSW_SCSI_RESET_LATCH) {
 		if (!(asc_dvc->bus_type & (ASC_IS_VL | ASC_IS_EISA))) {
 			int i = 10;
-			int_pending = ADV_TRUE;
+			int_pending = true;
 			asc_dvc->sdtr_done = 0;
 			saved_ctrl_reg &= (uchar)(~CC_HALT);
 			while ((AscGetChipStatus(iop_base) &
@@ -7334,9 +7333,9 @@ static int AscISR(ASC_DVC_VAR *asc_dvc)
 			 (uchar)(host_flag | (uchar)ASC_HOST_FLAG_IN_ISR));
 	if ((chipstat & CSW_INT_PENDING) || (int_pending)) {
 		AscAckInterrupt(iop_base);
-		int_pending = ADV_TRUE;
+		int_pending = true;
 		if ((chipstat & CSW_HALTED) && (ctrl_reg & CC_SINGLE_STEP)) {
-			if (AscIsrChipHalted(asc_dvc) == ERR) {
+			if (AscIsrChipHalted(asc_dvc) == ASC_ERROR) {
 				goto ISR_REPORT_QDONE_FATAL_ERROR;
 			} else {
 				saved_ctrl_reg &= (uchar)(~CC_HALT);
@@ -7356,14 +7355,13 @@ static int AscISR(ASC_DVC_VAR *asc_dvc)
 				} while (status == 0x11);
 			}
 			if ((status & 0x80) != 0)
-				int_pending = ASC_ERROR;
+				printk("advansys: AscISR: interrupt still pending, status 0x%x\n", status);
 		}
 	}
 	AscWriteLramByte(iop_base, ASCV_HOST_FLAG_B, host_flag);
 	AscSetChipLramAddr(iop_base, saved_ram_addr);
 	AscSetChipControl(iop_base, saved_ctrl_reg);
 	asc_dvc->is_in_int = false;
-	return int_pending;
 }
 
 /*
@@ -8471,7 +8469,7 @@ static int AscExeScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq)
 	iop_base = asc_dvc->iop_base;
 	sg_head = scsiq->sg_head;
 	if (asc_dvc->err_code != 0)
-		return (ERR);
+		return ASC_ERROR;
 	scsiq->q1.q_no = 0;
 	if ((scsiq->q2.tag_code & ASC_TAG_FLAG_EXTRA_BYTES) == 0) {
 		scsiq->q1.extra_bytes = 0;
@@ -8497,18 +8495,18 @@ static int AscExeScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq)
 	}
 	if (asc_dvc->in_critical_cnt != 0) {
 		AscSetLibErrorCode(asc_dvc, ASCQ_ERR_CRITICAL_RE_ENTRY);
-		return (ERR);
+		return ASC_ERROR;
 	}
 	asc_dvc->in_critical_cnt++;
 	if ((scsiq->q1.cntl & QC_SG_HEAD) != 0) {
 		if ((sg_entry_cnt = sg_head->entry_cnt) == 0) {
 			asc_dvc->in_critical_cnt--;
-			return (ERR);
+			return ASC_ERROR;
 		}
 #if !CC_VERY_LONG_SG_LIST
 		if (sg_entry_cnt > ASC_MAX_SG_LIST) {
 			asc_dvc->in_critical_cnt--;
-			return (ERR);
+			return ASC_ERROR;
 		}
 #endif /* !CC_VERY_LONG_SG_LIST */
 		if (sg_entry_cnt == 1) {
-- 
1.8.5.2

