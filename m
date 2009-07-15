From: michaelc@cs.wisc.edu
Subject: [PATCH 4/6] qla4xxx: Fix Driver Fault Recovery Completion
Date: Wed, 15 Jul 2009 15:03:00 -0500
Message-ID: <1247688182-15764-5-git-send-email-michaelc@cs.wisc.edu>
References: <1247688182-15764-1-git-send-email-michaelc@cs.wisc.edu>
 <1247688182-15764-2-git-send-email-michaelc@cs.wisc.edu>
 <1247688182-15764-3-git-send-email-michaelc@cs.wisc.edu>
 <1247688182-15764-4-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:60935 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756302AbZGOUDJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jul 2009 16:03:09 -0400
In-Reply-To: <1247688182-15764-4-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Karen Higgins <karen.higgins@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Karen Higgins <karen.higgins@qlogic.com>

Fixed driver bug where adapter recovery did not complete if there were
outstanding commands detected on that host adapter.

Patch was made over scsi-rc-fixes.

Signed-off-by: Karen Higgins <karen.higgins@qlogic.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/qla4xxx/ql4_os.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 6841883..e1cc0d2 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -921,18 +921,17 @@ static int qla4xxx_recover_adapter(struct scsi_qla_host *ha,
 	/* Flush any pending ddb changed AENs */
 	qla4xxx_process_aen(ha, FLUSH_DDB_CHANGED_AENS);
 
+	qla4xxx_flush_active_srbs(ha);
+
 	/* Reset the firmware.	If successful, function
 	 * returns with ISP interrupts enabled.
 	 */
-	if (status == QLA_SUCCESS) {
-		DEBUG2(printk("scsi%ld: %s - Performing soft reset..\n",
-			      ha->host_no, __func__));
-		qla4xxx_flush_active_srbs(ha);
-		if (ql4xxx_lock_drvr_wait(ha) == QLA_SUCCESS)
-			status = qla4xxx_soft_reset(ha);
-		else
-			status = QLA_ERROR;
-	}
+	DEBUG2(printk("scsi%ld: %s - Performing soft reset..\n",
+		      ha->host_no, __func__));
+	if (ql4xxx_lock_drvr_wait(ha) == QLA_SUCCESS)
+		status = qla4xxx_soft_reset(ha);
+	else
+		status = QLA_ERROR;
 
 	/* Flush any pending ddb changed AENs */
 	qla4xxx_process_aen(ha, FLUSH_DDB_CHANGED_AENS);
@@ -1661,7 +1660,7 @@ static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd)
 	ha = (struct scsi_qla_host *) cmd->device->host->hostdata;
 
 	dev_info(&ha->pdev->dev,
-		   "scsi(%ld:%d:%d:%d): ADAPTER RESET ISSUED.\n", ha->host_no,
+		   "scsi(%ld:%d:%d:%d): HOST RESET ISSUED.\n", ha->host_no,
 		   cmd->device->channel, cmd->device->id, cmd->device->lun);
 
 	if (qla4xxx_wait_for_hba_online(ha) != QLA_SUCCESS) {
-- 
1.6.0.6

