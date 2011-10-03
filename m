From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 08/13] qla4xxx: Fixed session destroy issue on link up-down.
Date: Mon, 3 Oct 2011 10:29:22 -0700
Message-ID: <1317662967-30110-9-git-send-email-vikas.chaudhary@qlogic.com>
References: <1317662967-30110-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:40421
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757096Ab1JCRlA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2011 13:41:00 -0400
In-Reply-To: <1317662967-30110-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Manish Rangankar <manish.rangankar@qlogic.com>

From: Manish Rangankar <manish.rangankar@qlogic.com>

During link down, iscsid tries to do re-login to failed session. In case of
link down-up-down, LLD was sending connection login failed event to iscsid,
which is destroying the session, instead we have to continue re-login by
sending connection err event.

JIRA Key: UPSISCSI-134

Signed-off-by: Manish Rangankar <manish.rangankar@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_init.c |   16 ++++++++++++++++
 drivers/scsi/qla4xxx/ql4_os.c   |    6 +++++-
 2 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index ca155bb..cc10bac 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -931,6 +931,22 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
 			break;
 		}
 		break;
+	case DDB_DS_SESSION_FAILED:
+		switch (state) {
+		case DDB_DS_SESSION_ACTIVE:
+		case DDB_DS_DISCOVERY:
+			iscsi_conn_login_event(ddb_entry->conn,
+					       ISCSI_CONN_STATE_LOGGED_IN);
+			qla4xxx_update_session_conn_param(ha, ddb_entry);
+			status = QLA_SUCCESS;
+			break;
+		case DDB_DS_SESSION_FAILED:
+			iscsi_session_failure(ddb_entry->sess->dd_data,
+					      ISCSI_ERR_CONN_FAILED);
+			status = QLA_SUCCESS;
+			break;
+		}
+		break;
 	default:
 		DEBUG2(ql4_printk(KERN_INFO, ha, "%s: Unknown Event\n",
 				__func__));
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index fc3ba29..251358a 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1158,7 +1158,11 @@ static int qla4xxx_conn_start(struct iscsi_cls_conn *cls_conn)
 		goto exit_conn_start;
 	}
 
-	ddb_entry->fw_ddb_device_state = DDB_DS_LOGIN_IN_PROCESS;
+	if (ddb_entry->fw_ddb_device_state == DDB_DS_NO_CONNECTION_ACTIVE)
+		ddb_entry->fw_ddb_device_state = DDB_DS_LOGIN_IN_PROCESS;
+
+	DEBUG2(printk(KERN_INFO "%s: DDB state [%d]\n", __func__,
+		      ddb_entry->fw_ddb_device_state));
 
 exit_set_param:
 	iscsi_conn_start(cls_conn);
-- 
1.7.6


