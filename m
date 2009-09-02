From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 2/8] libiscsi, bnx2i: make bound ep check common
Date: Wed, 2 Sep 2009 09:40:02 +0530
Message-ID: <20090902040953.GA18519@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:33246 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750808AbZIBEJu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2009 00:09:50 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

bnx2i currently has a check for if a ep is properly bound, so if
iscsi_queuecommand/xmit_task is called while there is no ep
we will not queue IO.

be2iscsi sends IO from queuecommand/xmit_task like how bnx2i does
and needs a similar test. This patch has us just use the suspend_bit
test for this.

When ep_poll has succeeed iscsid will call conn_bind, the LLD will
then call iscsi_conn_bind which will clear the suspend bit.
When ep_disconnect is called (or if there is a conn error) we set
the suspend bit. For the ep_disconnect case I am adding a helper
in this patch that will take the session lock to make sure
iscsi_queuecommand/xmit_task is not running and it will set
the suspend bit.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |   33 +++++++++++++++++++++++++++++++++
 include/scsi/libiscsi.h |    1 +
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index fc95919..cf54773 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1502,6 +1502,12 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 		goto fault;
 	}
 
+	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
+		reason = FAILURE_SESSION_IN_RECOVERY;
+		sc->result = DID_REQUEUE;
+		goto fault;
+	}
+
 	if (iscsi_check_cmdsn_window_closed(conn)) {
 		reason = FAILURE_WINDOW_CLOSED;
 		goto reject;
@@ -1740,6 +1746,33 @@ static void fail_scsi_tasks(struct iscsi_conn *conn, unsigned lun,
 	}
 }
 
+/**
+ * iscsi_suspend_queue - suspend iscsi_queuecommand
+ * @conn: iscsi conn to stop queueing IO on
+ *
+ * This grabs the session lock to make sure no one is in
+ * xmit_task/queuecommand, and then sets suspend to prevent
+ * new commands from being queued. This only needs to be called
+ * by offload drivers that need to sync a path like ep disconnect
+ * with the iscsi_queuecommand/xmit_task. To start IO again libiscsi
+ * will call iscsi_start_tx and iscsi_unblock_session when in FFP.
+ */
+void iscsi_suspend_queue(struct iscsi_conn *conn)
+{
+	spin_lock_bh(&conn->session->lock);
+	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
+	spin_unlock_bh(&conn->session->lock);
+}
+EXPORT_SYMBOL_GPL(iscsi_suspend_queue);
+
+/**
+ * iscsi_suspend_tx - suspend iscsi_data_xmit
+ * @conn: iscsi conn tp stop processing IO on.
+ *
+ * This function sets the suspend bit to prevent iscsi_data_xmit
+ * from sending new IO, and if work is queued on the xmit thread
+ * it will wait for it to be completed.
+ */
 void iscsi_suspend_tx(struct iscsi_conn *conn)
 {
 	struct Scsi_Host *shost = conn->session->host;
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 439c8b7..887e57e 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -390,6 +390,7 @@ extern void iscsi_session_failure(struct iscsi_session *session,
 extern int iscsi_conn_get_param(struct iscsi_cls_conn *cls_conn,
 				enum iscsi_param param, char *buf);
 extern void iscsi_suspend_tx(struct iscsi_conn *conn);
+extern void iscsi_suspend_queue(struct iscsi_conn *conn);
 extern void iscsi_conn_queue_work(struct iscsi_conn *conn);
 
 #define iscsi_conn_printk(prefix, _c, fmt, a...) \
-- 
1.6.4

