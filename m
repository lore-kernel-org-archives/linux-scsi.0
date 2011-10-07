From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH v2 10/14] qla4xxx: Fixed device blocked issue on link up-down.
Date: Fri, 7 Oct 2011 16:55:48 -0700
Message-ID: <1318031752-3836-11-git-send-email-vikas.chaudhary@qlogic.com>
References: <1318031752-3836-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:23547
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754825Ab1JHAH3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Oct 2011 20:07:29 -0400
In-Reply-To: <1318031752-3836-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Manish Rangankar <manish.rangankar@qlogic.com>

From: Manish Rangankar <manish.rangankar@qlogic.com>

Devices are getting blocked during continuous link up and down.
Solution is, during relogin unblock the session, using iscsi_conn_start,
before sending connection logged in event.

JIRA Key: UPSISCSI-138

Signed-off-by: Manish Rangankar <manish.rangankar@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_init.c |    2 ++
 drivers/scsi/qla4xxx/ql4_os.c   |    1 -
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index cc10bac..3075fba 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -900,6 +900,7 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
 		switch (state) {
 		case DDB_DS_SESSION_ACTIVE:
 		case DDB_DS_DISCOVERY:
+			iscsi_conn_start(ddb_entry->conn);
 			iscsi_conn_login_event(ddb_entry->conn,
 					       ISCSI_CONN_STATE_LOGGED_IN);
 			qla4xxx_update_session_conn_param(ha, ddb_entry);
@@ -935,6 +936,7 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
 		switch (state) {
 		case DDB_DS_SESSION_ACTIVE:
 		case DDB_DS_DISCOVERY:
+			iscsi_conn_start(ddb_entry->conn);
 			iscsi_conn_login_event(ddb_entry->conn,
 					       ISCSI_CONN_STATE_LOGGED_IN);
 			qla4xxx_update_session_conn_param(ha, ddb_entry);
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index af83e6f..205ecaf 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1165,7 +1165,6 @@ static int qla4xxx_conn_start(struct iscsi_cls_conn *cls_conn)
 		      ddb_entry->fw_ddb_device_state));
 
 exit_set_param:
-	iscsi_conn_start(cls_conn);
 	ret = 0;
 
 exit_conn_start:
-- 
1.7.6


