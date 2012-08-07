From: vikas.chaudhary@qlogic.com
Subject: [PATCH 3/5] qla4xxx: Fix multiple conn login event issue during session recovery.
Date: Tue,  7 Aug 2012 07:57:15 -0400
Message-ID: <1344340637-25526-4-git-send-email-vikas.chaudhary@qlogic.com>
References: <1344340637-25526-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:12491 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754511Ab2HGMPO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Aug 2012 08:15:14 -0400
In-Reply-To: <1344340637-25526-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Manish Rangankar <manish.rangankar@qlogic.com>

From: Manish Rangankar <manish.rangankar@qlogic.com>

During iscsid session recovery driver sends multiple ISCSI_CONN_STATE_LOGGED_IN
event from qla4xxx_conn_start() and qla4xxx_ddb_change(), which causes iscsid
to crash.

Signed-off-by: Manish Rangankar <manish.rangankar@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 77a969a..9c3442d 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -3168,6 +3168,7 @@ int qla4xxx_unblock_ddb(struct iscsi_cls_session *cls_session)
 	struct iscsi_session *sess;
 	struct ddb_entry *ddb_entry;
 	struct scsi_qla_host *ha;
+	int status = QLA_SUCCESS;
 
 	sess = cls_session->dd_data;
 	ddb_entry = sess->dd_data;
@@ -3175,11 +3176,20 @@ int qla4xxx_unblock_ddb(struct iscsi_cls_session *cls_session)
 	ql4_printk(KERN_INFO, ha, "scsi%ld: %s: ddb[%d]"
 		   " unblock user space session\n", ha->host_no, __func__,
 		   ddb_entry->fw_ddb_index);
-	iscsi_conn_start(ddb_entry->conn);
-	iscsi_conn_login_event(ddb_entry->conn,
-			       ISCSI_CONN_STATE_LOGGED_IN);
 
-	return QLA_SUCCESS;
+	if (!iscsi_is_session_online(cls_session)) {
+		iscsi_conn_start(ddb_entry->conn);
+		iscsi_conn_login_event(ddb_entry->conn,
+				       ISCSI_CONN_STATE_LOGGED_IN);
+	} else {
+		ql4_printk(KERN_INFO, ha,
+			   "scsi%ld: %s: ddb[%d] session [%d] already logged in\n",
+			   ha->host_no, __func__, ddb_entry->fw_ddb_index,
+			   cls_session->sid);
+		status = QLA_ERROR;
+	}
+
+	return status;
 }
 
 static void qla4xxx_relogin_all_devices(struct scsi_qla_host *ha)
-- 
1.7.8.GIT

