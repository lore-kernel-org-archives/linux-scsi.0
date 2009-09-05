From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 1/8] libiscsi: add compeltion function for drivers that do
	not need pdu processing
Date: Sat, 5 Sep 2009 07:34:23 +0530
Message-ID: <20090905020413.GA11786@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:51300 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S934360AbZIECEU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Sep 2009 22:04:20 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

beiscsi does not need the iscsi scsi cmd processing. It does not
even get this info on the completion path. This adds a function
to just update the sequencing numbers and complete a task.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/libiscsi.c |   38 +++++++++++++++++++++++++++++++++-----
 include/scsi/libiscsi.h |    2 ++
 2 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index a751f62..fc95919 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -109,12 +109,9 @@ inline void iscsi_conn_queue_work(struct iscsi_conn *conn)
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_queue_work);
 
-void
-iscsi_update_cmdsn(struct iscsi_session *session, struct iscsi_nopin *hdr)
+static void __iscsi_update_cmdsn(struct iscsi_session *session,
+				 uint32_t exp_cmdsn, uint32_t max_cmdsn)
 {
-	uint32_t max_cmdsn = be32_to_cpu(hdr->max_cmdsn);
-	uint32_t exp_cmdsn = be32_to_cpu(hdr->exp_cmdsn);
-
 	/*
 	 * standard specifies this check for when to update expected and
 	 * max sequence numbers
@@ -138,6 +135,12 @@ iscsi_update_cmdsn(struct iscsi_session *session, struct iscsi_nopin *hdr)
 			iscsi_conn_queue_work(session->leadconn);
 	}
 }
+
+void iscsi_update_cmdsn(struct iscsi_session *session, struct iscsi_nopin *hdr)
+{
+	__iscsi_update_cmdsn(session, be32_to_cpu(hdr->exp_cmdsn),
+			     be32_to_cpu(hdr->max_cmdsn));
+}
 EXPORT_SYMBOL_GPL(iscsi_update_cmdsn);
 
 /**
@@ -499,6 +502,31 @@ static void iscsi_complete_task(struct iscsi_task *task, int state)
 	__iscsi_put_task(task);
 }
 
+/**
+ * iscsi_complete_scsi_task - finish scsi task normally
+ * @task: iscsi task for scsi cmd
+ * @exp_cmdsn: expected cmd sn in cpu format
+ * @max_cmdsn: max cmd sn in cpu format
+ *
+ * This is used when drivers do not need or cannot perform
+ * lower level pdu processing.
+ *
+ * Called with session lock
+ */
+void iscsi_complete_scsi_task(struct iscsi_task *task,
+			      uint32_t exp_cmdsn, uint32_t max_cmdsn)
+{
+	struct iscsi_conn *conn = task->conn;
+
+	ISCSI_DBG_SESSION(conn->session, "[itt 0x%x]\n", task->itt);
+
+	conn->last_recv = jiffies;
+	__iscsi_update_cmdsn(conn->session, exp_cmdsn, max_cmdsn);
+	iscsi_complete_task(task, ISCSI_TASK_COMPLETED);
+}
+EXPORT_SYMBOL_GPL(iscsi_complete_scsi_task);
+
+
 /*
  * session lock must be held and if not called for a task that is
  * still pending or from the xmit thread, then xmit thread must
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 61afeb5..439c8b7 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -415,6 +415,8 @@ extern struct iscsi_task *iscsi_itt_to_task(struct iscsi_conn *, itt_t);
 extern void iscsi_requeue_task(struct iscsi_task *task);
 extern void iscsi_put_task(struct iscsi_task *task);
 extern void __iscsi_get_task(struct iscsi_task *task);
+extern void iscsi_complete_scsi_task(struct iscsi_task *task,
+				     uint32_t exp_cmdsn, uint32_t max_cmdsn);
 
 /*
  * generic helpers
-- 
1.6.4

