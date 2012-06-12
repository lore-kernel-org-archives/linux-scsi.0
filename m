From: James Smart <james.smart@emulex.com>
Subject: [PATCH 03/10] lpfc 8.3.32: Fix CQ and EQ dump failure for debugfs
Date: Tue, 12 Jun 2012 13:54:20 -0400
Message-ID: <1339523660.2162.3.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:17647 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752495Ab2FLRyh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jun 2012 13:54:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed debug helper routine failed to dump CQ and EQ entries in non-MSI-X mode


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_debugfs.h |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_debugfs.h b/drivers/scsi/lpfc/lpfc_debugfs.h
--- a/drivers/scsi/lpfc/lpfc_debugfs.h	2012-06-08 10:07:43.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_debugfs.h	2012-06-08 11:55:37.000000000 -0400
@@ -395,8 +395,13 @@ lpfc_debug_dump_fcp_cq(struct lpfc_hba *
 	for (fcp_cqidx = 0; fcp_cqidx < phba->cfg_fcp_eq_count; fcp_cqidx++)
 		if (phba->sli4_hba.fcp_cq[fcp_cqidx]->queue_id == fcp_cqid)
 			break;
-	if (fcp_cqidx >= phba->cfg_fcp_eq_count)
-		return;
+	if (phba->intr_type == MSIX) {
+		if (fcp_cqidx >= phba->cfg_fcp_eq_count)
+			return;
+	} else {
+		if (fcp_cqidx > 0)
+			return;
+	}
 
 	printk(KERN_ERR "FCP CQ: WQ[Idx:%d|Qid%d]->CQ[Idx%d|Qid%d]:\n",
 		fcp_wqidx, phba->sli4_hba.fcp_wq[fcp_wqidx]->queue_id,
@@ -426,8 +431,13 @@ lpfc_debug_dump_fcp_eq(struct lpfc_hba *
 	for (fcp_cqidx = 0; fcp_cqidx < phba->cfg_fcp_eq_count; fcp_cqidx++)
 		if (phba->sli4_hba.fcp_cq[fcp_cqidx]->queue_id == fcp_cqid)
 			break;
-	if (fcp_cqidx >= phba->cfg_fcp_eq_count)
-		return;
+	if (phba->intr_type == MSIX) {
+		if (fcp_cqidx >= phba->cfg_fcp_eq_count)
+			return;
+	} else {
+		if (fcp_cqidx > 0)
+			return;
+	}
 
 	if (phba->cfg_fcp_eq_count == 0) {
 		fcp_eqidx = -1;



