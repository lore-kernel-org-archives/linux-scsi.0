From: michaelc@cs.wisc.edu
Subject: [PATCH 02/12] qla4xxx: have qla4xxx directly call iscsi recovery functions
Date: Thu, 31 Jan 2008 13:36:44 -0600
Message-ID: <1201808215968-git-send-email-michaelc@cs.wisc.edu>
References: <12018082143359-git-send-email-michaelc@cs.wisc.edu>
 <12018082142447-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758863AbYAaTg6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jan 2008 14:36:58 -0500
In-Reply-To: <12018082142447-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Qla4xxx can just call the iscsi recovery functions directly.
There is no need for userspace to do this for qla4xxx, because
we do not use the mutex to iterate over devices anymore and iscsi_block
/unblock_session can be called from interrupt context or the dpc thread.
And having userspace do this just creates uneeded headaches for qla4xxx root
situations where the session may experience problems. For example
during the kernel shutdown the scsi layer wants to send sync caches, but at
this time userspace is not up (iscsid is not running), so we cannot
recover from the problem.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/qla4xxx/ql4_init.c |    1 +
 drivers/scsi/qla4xxx/ql4_os.c   |   40 +++-----------------------------------
 2 files changed, 5 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index cbe0a17..03e66cb 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -1306,6 +1306,7 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha,
 		atomic_set(&ddb_entry->relogin_timer, 0);
 		clear_bit(DF_RELOGIN, &ddb_entry->flags);
 		clear_bit(DF_NO_RELOGIN, &ddb_entry->flags);
+		iscsi_unblock_session(ddb_entry->sess);
 		iscsi_session_event(ddb_entry->sess,
 				    ISCSI_KEVENT_CREATE_SESSION);
 		/*
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 2e2b9fe..a87fb9f 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -63,8 +63,6 @@ static int qla4xxx_sess_get_param(struct iscsi_cls_session *sess,
 				  enum iscsi_param param, char *buf);
 static int qla4xxx_host_get_param(struct Scsi_Host *shost,
 				  enum iscsi_host_param param, char *buf);
-static void qla4xxx_conn_stop(struct iscsi_cls_conn *conn, int flag);
-static int qla4xxx_conn_start(struct iscsi_cls_conn *conn);
 static void qla4xxx_recovery_timedout(struct iscsi_cls_session *session);
 
 /*
@@ -116,8 +114,6 @@ static struct iscsi_transport qla4xxx_iscsi_transport = {
 	.get_conn_param		= qla4xxx_conn_get_param,
 	.get_session_param	= qla4xxx_sess_get_param,
 	.get_host_param		= qla4xxx_host_get_param,
-	.start_conn		= qla4xxx_conn_start,
-	.stop_conn		= qla4xxx_conn_stop,
 	.session_recovery_timedout = qla4xxx_recovery_timedout,
 };
 
@@ -140,38 +136,6 @@ static void qla4xxx_recovery_timedout(struct iscsi_cls_session *session)
 	queue_work(ha->dpc_thread, &ha->dpc_work);
 }
 
-static int qla4xxx_conn_start(struct iscsi_cls_conn *conn)
-{
-	struct iscsi_cls_session *session;
-	struct ddb_entry *ddb_entry;
-
-	session = iscsi_dev_to_session(conn->dev.parent);
-	ddb_entry = session->dd_data;
-
-	DEBUG2(printk("scsi%ld: %s: index [%d] starting conn\n",
-		      ddb_entry->ha->host_no, __func__,
-		      ddb_entry->fw_ddb_index));
-	iscsi_unblock_session(session);
-	return 0;
-}
-
-static void qla4xxx_conn_stop(struct iscsi_cls_conn *conn, int flag)
-{
-	struct iscsi_cls_session *session;
-	struct ddb_entry *ddb_entry;
-
-	session = iscsi_dev_to_session(conn->dev.parent);
-	ddb_entry = session->dd_data;
-
-	DEBUG2(printk("scsi%ld: %s: index [%d] stopping conn\n",
-		      ddb_entry->ha->host_no, __func__,
-		      ddb_entry->fw_ddb_index));
-	if (flag == STOP_CONN_RECOVER)
-		iscsi_block_session(session);
-	else
-		printk(KERN_ERR "iscsi: invalid stop flag %d\n", flag);
-}
-
 static int qla4xxx_host_get_param(struct Scsi_Host *shost,
 				  enum iscsi_host_param param, char *buf)
 {
@@ -308,6 +272,9 @@ int qla4xxx_add_sess(struct ddb_entry *ddb_entry)
 		DEBUG2(printk(KERN_ERR "Could not add connection.\n"));
 		return -ENOMEM;
 	}
+
+	/* finally ready to go */
+	iscsi_unblock_session(ddb_entry->sess);
 	return 0;
 }
 
@@ -364,6 +331,7 @@ void qla4xxx_mark_device_missing(struct scsi_qla_host *ha,
 	DEBUG3(printk("scsi%d:%d:%d: index [%d] marked MISSING\n",
 		      ha->host_no, ddb_entry->bus, ddb_entry->target,
 		      ddb_entry->fw_ddb_index));
+	iscsi_block_session(ddb_entry->sess);
 	iscsi_conn_error(ddb_entry->conn, ISCSI_ERR_CONN_FAILED);
 }
 
-- 
1.5.2.1

