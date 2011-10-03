From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 07/13] qla4xxx: Clear DDB map index on the basis of AEN.
Date: Mon, 3 Oct 2011 10:29:21 -0700
Message-ID: <1317662967-30110-8-git-send-email-vikas.chaudhary@qlogic.com>
References: <1317662967-30110-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:44931
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757084Ab1JCRk7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2011 13:40:59 -0400
In-Reply-To: <1317662967-30110-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Manish Rangankar <manish.rangankar@qlogic.com>

From: Manish Rangankar <manish.rangankar@qlogic.com>

Unable to login to session if login-logout issued consecutively for
multiple sessions. Solution is to clear idx in DDB map on the basis
of no-active connection asynchronous event (AEN).

JIRA Key: UPSISCSI-135

Signed-off-by: Manish Rangankar <manish.rangankar@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_init.c |   12 +++++++++++-
 drivers/scsi/qla4xxx/ql4_os.c   |   11 +++--------
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 064a3a3..ca155bb 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -880,6 +880,10 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
 	if (ddb_entry == NULL) {
 		ql4_printk(KERN_ERR, ha, "%s: No ddb_entry at FW index [%d]\n",
 			   __func__, fw_ddb_index);
+
+		if (state == DDB_DS_NO_CONNECTION_ACTIVE)
+			clear_bit(fw_ddb_index, ha->ddb_idx_map);
+
 		goto exit_ddb_event;
 	}
 
@@ -910,7 +914,8 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
 		}
 		break;
 	case DDB_DS_SESSION_ACTIVE:
-		if (state == DDB_DS_SESSION_FAILED) {
+		switch (state) {
+		case DDB_DS_SESSION_FAILED:
 			/*
 			 * iscsi_session failure  will cause userspace to
 			 * stop the connection which in turn would block the
@@ -919,6 +924,11 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
 			iscsi_session_failure(ddb_entry->sess->dd_data,
 					      ISCSI_ERR_CONN_FAILED);
 			status = QLA_SUCCESS;
+			break;
+		case DDB_DS_NO_CONNECTION_ACTIVE:
+			clear_bit(fw_ddb_index, ha->ddb_idx_map);
+			status = QLA_SUCCESS;
+			break;
 		}
 		break;
 	default:
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index c621152..fc3ba29 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1004,6 +1004,7 @@ qla4xxx_session_create(struct iscsi_endpoint *ep,
 	qla_ep = ep->dd_data;
 	dst_addr = (struct sockaddr *)&qla_ep->dst_addr;
 	ha = to_qla_host(qla_ep->host);
+
 get_ddb_index:
 	ddb_index = find_first_zero_bit(ha->ddb_idx_map, MAX_DDB_ENTRIES);
 
@@ -1063,6 +1064,8 @@ static void qla4xxx_session_destroy(struct iscsi_cls_session *cls_sess)
 	ddb_entry = sess->dd_data;
 	ha = ddb_entry->ha;
 
+	qla4xxx_clear_ddb_entry(ha, ddb_entry->fw_ddb_index);
+
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	qla4xxx_free_ddb(ha, ddb_entry);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -1183,14 +1186,6 @@ static void qla4xxx_conn_destroy(struct iscsi_cls_conn *cls_conn)
 	options = LOGOUT_OPTION_CLOSE_SESSION;
 	if (qla4xxx_session_logout_ddb(ha, ddb_entry, options) == QLA_ERROR)
 		ql4_printk(KERN_ERR, ha, "%s: Logout failed\n", __func__);
-	else
-		qla4xxx_clear_ddb_entry(ha, ddb_entry->fw_ddb_index);
-
-	/*
-	 * Clear the DDB bit so that next login can use the bit
-	 * if FW is not clearing the DDB entry then set DDB will fail anyways
-	 */
-	clear_bit(ddb_entry->fw_ddb_index, ha->ddb_idx_map);
 }
 
 static void qla4xxx_task_work(struct work_struct *wdata)
-- 
1.7.6


