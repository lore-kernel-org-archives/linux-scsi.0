From: michaelc@cs.wisc.edu
Subject: [PATCH 1/3] qla4xxx: fix host reset dpc race
Date: Tue,  4 Mar 2008 13:26:53 -0600
Message-ID: <1204658815-6185-2-git-send-email-michaelc@cs.wisc.edu>
References: <1204658815-6185-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:41148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761959AbYCDT1A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Mar 2008 14:27:00 -0500
In-Reply-To: <1204658815-6185-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

The host reset callout could be starting to reset the hba at the same
time the dpc thread is. This creates lots of problems because they both
want to do wierd things with the firmware and interrupts, etc.

This patch just has the host reset function fully shutdown the dpc
thread before resetting the hba.

This patch also moves the setting of the session online bit to fix
a potential race with the dpc thread and iscsi recovery thread.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Acked-by: David C Somayajulu <david.somayajulu@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_init.c |    2 +-
 drivers/scsi/qla4xxx/ql4_os.c   |   13 +++++++++----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 10b3b9a..109c5f5 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -1299,9 +1299,9 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha,
 	ddb_entry->fw_ddb_device_state = state;
 	/* Device is back online. */
 	if (ddb_entry->fw_ddb_device_state == DDB_DS_SESSION_ACTIVE) {
+		atomic_set(&ddb_entry->state, DDB_STATE_ONLINE);
 		atomic_set(&ddb_entry->port_down_timer,
 			   ha->port_down_retry_count);
-		atomic_set(&ddb_entry->state, DDB_STATE_ONLINE);
 		atomic_set(&ddb_entry->relogin_retry_count, 0);
 		atomic_set(&ddb_entry->relogin_timer, 0);
 		clear_bit(DF_RELOGIN, &ddb_entry->flags);
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index c3c59d7..10a233e 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -864,8 +864,9 @@ static void qla4xxx_flush_active_srbs(struct scsi_qla_host *ha)
  * qla4xxx_recover_adapter - recovers adapter after a fatal error
  * @ha: Pointer to host adapter structure.
  * @renew_ddb_list: Indicates what to do with the adapter's ddb list
- *	after adapter recovery has completed.
- *	0=preserve ddb list, 1=destroy and rebuild ddb list
+ *
+ * renew_ddb_list value can be 0=preserve ddb list, 1=destroy and rebuild
+ * ddb list.
  **/
 static int qla4xxx_recover_adapter(struct scsi_qla_host *ha,
 				uint8_t renew_ddb_list)
@@ -874,6 +875,7 @@ static int qla4xxx_recover_adapter(struct scsi_qla_host *ha,
 
 	/* Stall incoming I/O until we are done */
 	clear_bit(AF_ONLINE, &ha->flags);
+
 	DEBUG2(printk("scsi%ld: %s calling qla4xxx_cmd_wait\n", ha->host_no,
 		      __func__));
 
@@ -1600,9 +1602,12 @@ static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd)
 		return FAILED;
 	}
 
-	if (qla4xxx_recover_adapter(ha, PRESERVE_DDB_LIST) == QLA_SUCCESS) {
+	/* make sure the dpc thread is stopped while we reset the hba */
+	clear_bit(AF_ONLINE, &ha->flags);
+	flush_workqueue(ha->dpc_thread);
+
+	if (qla4xxx_recover_adapter(ha, PRESERVE_DDB_LIST) == QLA_SUCCESS)
 		return_status = SUCCESS;
-	}
 
 	dev_info(&ha->pdev->dev, "HOST RESET %s.\n",
 		   return_status == FAILED ? "FAILED" : "SUCCEDED");
-- 
1.5.4.1

