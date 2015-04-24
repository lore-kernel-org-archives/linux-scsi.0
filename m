From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/22] advansys: remove 'ERR' definition
Date: Fri, 24 Apr 2015 10:32:45 +0200
Message-ID: <1429864377-67002-11-git-send-email-hare@suse.de>
References: <1429864377-67002-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43148 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966362AbbDXIdN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Apr 2015 04:33:13 -0400
In-Reply-To: <1429864377-67002-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Ondrey Zary <linux@rainbow-software.org>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/advansys.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 9482d4e..9d78faa 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -78,7 +78,6 @@
 
 typedef unsigned char uchar;
 
-#define ERR      (-1)
 #define UW_ERR   (uint)(0xFFFF)
 #define isodd_word(val)   ((((uint)val) & (uint)0x0001) != 0)
 
@@ -7307,7 +7306,7 @@ static int AscISR(ASC_DVC_VAR *asc_dvc)
 		AscAckInterrupt(iop_base);
 		int_pending = ASC_TRUE;
 		if ((chipstat & CSW_HALTED) && (ctrl_reg & CC_SINGLE_STEP)) {
-			if (AscIsrChipHalted(asc_dvc) == ERR) {
+			if (AscIsrChipHalted(asc_dvc) == ASC_ERROR) {
 				goto ISR_REPORT_QDONE_FATAL_ERROR;
 			} else {
 				saved_ctrl_reg &= (uchar)(~CC_HALT);
@@ -8439,7 +8438,7 @@ static int AscExeScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq)
 	iop_base = asc_dvc->iop_base;
 	sg_head = scsiq->sg_head;
 	if (asc_dvc->err_code != 0)
-		return (ERR);
+		return ASC_ERROR;
 	scsiq->q1.q_no = 0;
 	if ((scsiq->q2.tag_code & ASC_TAG_FLAG_EXTRA_BYTES) == 0) {
 		scsiq->q1.extra_bytes = 0;
@@ -8465,18 +8464,18 @@ static int AscExeScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq)
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

