From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 2/5] qla4xxx: Limit the ACB Default Timeout value to 12s
Date: Fri, 16 Dec 2011 01:58:56 -0800
Message-ID: <1324029539-26021-3-git-send-email-vikas.chaudhary@qlogic.com>
References: <1324029539-26021-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:6030 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab1LPKNf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Dec 2011 05:13:35 -0500
In-Reply-To: <1324029539-26021-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Nilesh Javali <nilesh.javali@qlogic.com>

From: Nilesh Javali <nilesh.javali@qlogic.com>

JIRA Key: UPSISCSI-205

Signed-off-by: Nilesh Javali <nilesh.javali@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 3642f1f..1221349 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1630,7 +1630,9 @@ void qla4xxx_update_session_conn_param(struct scsi_qla_host *ha,
 
 	/* Update timers after login */
 	ddb_entry->default_relogin_timeout =
-				le16_to_cpu(fw_ddb_entry->def_timeout);
+		(le16_to_cpu(fw_ddb_entry->def_timeout) > LOGIN_TOV) &&
+		 (le16_to_cpu(fw_ddb_entry->def_timeout) < LOGIN_TOV * 10) ?
+		 le16_to_cpu(fw_ddb_entry->def_timeout) : LOGIN_TOV;
 	ddb_entry->default_time2wait =
 				le16_to_cpu(fw_ddb_entry->iscsi_def_time2wait);
 
@@ -3882,6 +3884,8 @@ static int qla4xxx_verify_boot_idx(struct scsi_qla_host *ha, uint16_t idx)
 static void qla4xxx_setup_flash_ddb_entry(struct scsi_qla_host *ha,
 					  struct ddb_entry *ddb_entry)
 {
+	uint16_t def_timeout;
+
 	ddb_entry->ddb_type = FLASH_DDB;
 	ddb_entry->fw_ddb_index = INVALID_ENTRY;
 	ddb_entry->fw_ddb_device_state = DDB_DS_NO_CONNECTION_ACTIVE;
@@ -3892,9 +3896,10 @@ static void qla4xxx_setup_flash_ddb_entry(struct scsi_qla_host *ha,
 	atomic_set(&ddb_entry->retry_relogin_timer, INVALID_ENTRY);
 	atomic_set(&ddb_entry->relogin_timer, 0);
 	atomic_set(&ddb_entry->relogin_retry_count, 0);
-
+	def_timeout = le16_to_cpu(ddb_entry->fw_ddb_entry.def_timeout);
 	ddb_entry->default_relogin_timeout =
-		le16_to_cpu(ddb_entry->fw_ddb_entry.def_timeout);
+		(def_timeout > LOGIN_TOV) && (def_timeout < LOGIN_TOV * 10) ?
+		def_timeout : LOGIN_TOV;
 	ddb_entry->default_time2wait =
 		le16_to_cpu(ddb_entry->fw_ddb_entry.iscsi_def_time2wait);
 }
@@ -4228,7 +4233,10 @@ void qla4xxx_build_ddb_list(struct scsi_qla_host *ha, int is_reset)
 	}
 
 	/* Wait to ensure all sendtargets are done for min 12 sec wait */
-	tmo = ((ha->def_timeout < LOGIN_TOV) ? LOGIN_TOV : ha->def_timeout);
+	tmo = ((ha->def_timeout > LOGIN_TOV) &&
+	       (ha->def_timeout < LOGIN_TOV * 10) ?
+	       ha->def_timeout : LOGIN_TOV);
+
 	DEBUG2(ql4_printk(KERN_INFO, ha,
 			  "Default time to wait for build ddb %d\n", tmo));
 
-- 
1.7.1


