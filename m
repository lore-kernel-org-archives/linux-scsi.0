From: michaelc@cs.wisc.edu
Subject: [PATCH 06/12] iscsi class: add async scan helper
Date: Thu, 31 Jan 2008 13:36:48 -0600
Message-ID: <1201808216137-git-send-email-michaelc@cs.wisc.edu>
References: <12018082143359-git-send-email-michaelc@cs.wisc.edu>
 <12018082142447-git-send-email-michaelc@cs.wisc.edu>
 <1201808215968-git-send-email-michaelc@cs.wisc.edu>
 <1201808215955-git-send-email-michaelc@cs.wisc.edu>
 <12018082162624-git-send-email-michaelc@cs.wisc.edu>
 <12018082161847-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759668AbYAaThA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jan 2008 14:37:00 -0500
In-Reply-To: <12018082161847-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

In qla4xxx's probe it will call the iscsi session setup functions
for session that got setup on the initial start. This then makes
it easy for the iscsi class to export a helper which indicates
when those scans are done.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c |   38 ++++++++++++++++++++++++++++++++--
 include/scsi/scsi_transport_iscsi.h |    3 +-
 2 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index af88955..af17997 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -127,6 +127,7 @@ static int iscsi_setup_host(struct transport_container *tc, struct device *dev,
 	memset(ihost, 0, sizeof(*ihost));
 	INIT_LIST_HEAD(&ihost->sessions);
 	mutex_init(&ihost->mutex);
+	atomic_set(&ihost->nr_scans, 0);
 
 	snprintf(ihost->scan_workq_name, KOBJ_NAME_LEN, "iscsi_scan_%d",
 		shost->host_no);
@@ -284,6 +285,25 @@ static int iscsi_is_session_dev(const struct device *dev)
 	return dev->release == iscsi_session_release;
 }
 
+/**
+ * iscsi_scan_finished - helper to report when running scans are done
+ * @shost: scsi host
+ * @time: scan run time
+ *
+ * This function can be used by drives like qla4xxx to report to the scsi
+ * layer when the scans it kicked off at module load time are done.
+ */
+int iscsi_scan_finished(struct Scsi_Host *shost, unsigned long time)
+{
+	struct iscsi_host *ihost = shost->shost_data;
+	/*
+	 * qla4xxx will have kicked off some session unblocks before calling
+	 * scsi_scan_host, so just wait for them to complete.
+	 */
+	return !atomic_read(&ihost->nr_scans);
+}
+EXPORT_SYMBOL_GPL(iscsi_scan_finished);
+
 static int iscsi_user_scan(struct Scsi_Host *shost, uint channel,
 			   uint id, uint lun)
 {
@@ -306,17 +326,21 @@ static void iscsi_scan_session(struct work_struct *work)
 {
 	struct iscsi_cls_session *session =
 			container_of(work, struct iscsi_cls_session, scan_work);
+	struct Scsi_Host *shost = iscsi_session_to_shost(session);
+	struct iscsi_host *ihost = shost->shost_data;
 	unsigned long flags;
 
 	spin_lock_irqsave(&session->lock, flags);
 	if (session->state != ISCSI_SESSION_LOGGED_IN) {
 		spin_unlock_irqrestore(&session->lock, flags);
-		return;
+		goto done;
 	}
 	spin_unlock_irqrestore(&session->lock, flags);
 
 	scsi_scan_target(&session->dev, 0, session->target_id,
 			 SCAN_WILD_CARD, 1);
+done:
+	atomic_dec(&ihost->nr_scans);
 }
 
 static void session_recovery_timedout(struct work_struct *work)
@@ -366,7 +390,15 @@ void iscsi_unblock_session(struct iscsi_cls_session *session)
 	spin_unlock_irqrestore(&session->lock, flags);
 
 	__iscsi_unblock_session(session);
-	queue_work(ihost->scan_workq, &session->scan_work);
+	/*
+	 * Only do kernel scanning if the driver is properly hooked into
+	 * the async scanning code (drivers like iscsi_tcp do login and
+	 * scanning from userspace).
+	 */
+	if (shost->hostt->scan_finished) {
+		if (queue_work(ihost->scan_workq, &session->scan_work))
+			atomic_inc(&ihost->nr_scans);
+	}
 }
 EXPORT_SYMBOL_GPL(iscsi_unblock_session);
 
@@ -550,7 +582,7 @@ void iscsi_remove_session(struct iscsi_cls_session *session)
 	session->state = ISCSI_SESSION_FREE;
 	spin_unlock_irqrestore(&session->lock, flags);
 	__iscsi_unblock_session(session);
-	iscsi_unbind_session(session);
+	__iscsi_unbind_session(&session->unbind_work);
 
 	/* flush running scans */
 	flush_workqueue(ihost->scan_workq);
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 1f0ec46..83693ba 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -203,6 +203,7 @@ struct iscsi_cls_session {
 
 struct iscsi_host {
 	struct list_head sessions;
+	atomic_t nr_scans;
 	struct mutex mutex;
 	struct workqueue_struct *scan_workq;
 	char scan_workq_name[KOBJ_NAME_LEN];
@@ -229,6 +230,6 @@ extern struct iscsi_cls_conn *iscsi_create_conn(struct iscsi_cls_session *sess,
 extern int iscsi_destroy_conn(struct iscsi_cls_conn *conn);
 extern void iscsi_unblock_session(struct iscsi_cls_session *session);
 extern void iscsi_block_session(struct iscsi_cls_session *session);
-
+extern int iscsi_scan_finished(struct Scsi_Host *shost, unsigned long time);
 
 #endif
-- 
1.5.2.1

