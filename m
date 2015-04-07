From: James Smart <james.smart@emulex.com>
Subject: [PATCH v3 12/20] lpfc: Fix null ndlp dereference in
 target_reset_handler
Date: Tue, 7 Apr 2015 15:07:20 -0400
Message-ID: <55242ae8.iPgf9V8Qv7GiCdCP%james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.emulex.com ([138.239.224.100]:27592 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbbDGTIU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2015 15:08:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix null ndlp dereference in target_reset_handler

Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index f623299..5612ba6 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5202,10 +5202,12 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 	if (status == FAILED) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
 			"0722 Target Reset rport failure: rdata x%p\n", rdata);
-		spin_lock_irq(shost->host_lock);
-		pnode->nlp_flag &= ~NLP_NPR_ADISC;
-		pnode->nlp_fcp_info &= ~NLP_FCP_2_DEVICE;
-		spin_unlock_irq(shost->host_lock);
+		if (pnode) {
+			spin_lock_irq(shost->host_lock);
+			pnode->nlp_flag &= ~NLP_NPR_ADISC;
+			pnode->nlp_fcp_info &= ~NLP_FCP_2_DEVICE;
+			spin_unlock_irq(shost->host_lock);
+		}
 		lpfc_reset_flush_io_context(vport, tgt_id, lun_id,
 					  LPFC_CTX_TGT);
 		return FAST_IO_FAIL;
-- 
1.7.11.7

