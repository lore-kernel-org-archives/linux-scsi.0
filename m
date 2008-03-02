From: michaelc@cs.wisc.edu
Subject: [PATCH 3/9] iscsi class: add iscsi queueing helper
Date: Sun,  2 Mar 2008 03:03:16 -0600
Message-ID: <1204448602-5435-3-git-send-email-michaelc@cs.wisc.edu>
References: <1204448602-5435-1-git-send-email-michaelc@cs.wisc.edu>
 <1204448602-5435-2-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456AbYCBJEG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Mar 2008 04:04:06 -0500
In-Reply-To: <1204448602-5435-2-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, david.somayajulu@qlogic.com, andrew.vasquez@qlogic.com, James.Smart@Emulex.com, Eric.Moore@lsil.com
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

When we transition to blocked return SCSI_MLQUEUE_TARGET_BUSY
instead of DID_IMM_RETRY, because we do not want the command
to come back around.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c |   35 +++++++++++++++++++++++++++++++++++
 include/scsi/scsi_transport_iscsi.h |    3 +++
 2 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index dfb026b..534a149 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -24,6 +24,7 @@
 #include <linux/mutex.h>
 #include <net/tcp.h>
 #include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_transport.h>
@@ -245,6 +246,40 @@ static const char *iscsi_session_state_name(int state)
 	return name;
 }
 
+/**
+ * iscsi_session_queue_ready - check if a session queue can accpet IO
+ * @session: iscsi session to check
+ * @cmd: scsi command to process
+ *
+ * Returns 0 if IO can be queued or if there the cmd should be
+ * completed by a call to cmd->scsi_done. Caller must check cmd->result.
+ * Returns SCSI_MLQUEUE value if IO cannot be queued.
+ */
+int iscsi_session_queue_ready(struct iscsi_cls_session *session,
+			      struct scsi_cmnd *cmd)
+{
+	unsigned long flags;
+	int err = 0;
+
+	cmd->result = 0;
+	spin_lock_irqsave(&session->lock, flags);
+	switch (session->state) {
+	case ISCSI_SESSION_LOGGED_IN:
+		break;
+	case ISCSI_SESSION_FAILED:
+		err = SCSI_MLQUEUE_TARGET_BUSY;
+		break;
+	case ISCSI_SESSION_FREE:
+		/* fall through */
+	default:
+		cmd->result = DID_NO_CONNECT << 16;
+		break;
+	}
+	spin_unlock_irqrestore(&session->lock, flags);
+	return err;
+}
+EXPORT_SYMBOL_GPL(iscsi_session_queue_ready);
+
 int iscsi_session_chkready(struct iscsi_cls_session *session)
 {
 	unsigned long flags;
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index dbc96ef..5d3ffb3 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -31,6 +31,7 @@
 struct scsi_transport_template;
 struct iscsi_transport;
 struct Scsi_Host;
+struct scsi_cmd;
 struct iscsi_cls_conn;
 struct iscsi_conn;
 struct iscsi_cmd_task;
@@ -218,6 +219,8 @@ struct iscsi_host {
 #define iscsi_cls_conn_printk(prefix, _cls_conn, fmt, a...) \
 	dev_printk(prefix, &(_cls_conn)->dev, fmt, ##a)
 
+extern int iscsi_session_queue_ready(struct iscsi_cls_session *session,
+				     struct scsi_cmnd *cmd);
 extern int iscsi_session_chkready(struct iscsi_cls_session *session);
 extern struct iscsi_cls_session *iscsi_alloc_session(struct Scsi_Host *shost,
 					struct iscsi_transport *transport);
-- 
1.5.4.1

