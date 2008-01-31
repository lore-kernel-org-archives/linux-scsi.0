From: michaelc@cs.wisc.edu
Subject: [PATCH 04/12] iscsi class: add session scanning
Date: Thu, 31 Jan 2008 13:36:46 -0600
Message-ID: <12018082162624-git-send-email-michaelc@cs.wisc.edu>
References: <12018082143359-git-send-email-michaelc@cs.wisc.edu>
 <12018082142447-git-send-email-michaelc@cs.wisc.edu>
 <1201808215968-git-send-email-michaelc@cs.wisc.edu>
 <1201808215955-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759445AbYAaTg7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jan 2008 14:36:59 -0500
In-Reply-To: <1201808215955-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This just adds iscsi session scanning which works like fc rport scanning.
The future patches will hook the drivers into Mathew Wilcox's async
scanning infrastructure, so userspace does not have to special case
iscsi and so userspace does not have to make a extra special case for
hardware iscsi root scanning.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c |   37 ++++++++++++++++++++++++++++------
 include/scsi/scsi_transport_iscsi.h |    7 +++--
 2 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index f876b0a..af88955 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -128,11 +128,11 @@ static int iscsi_setup_host(struct transport_container *tc, struct device *dev,
 	INIT_LIST_HEAD(&ihost->sessions);
 	mutex_init(&ihost->mutex);
 
-	snprintf(ihost->unbind_workq_name, KOBJ_NAME_LEN, "iscsi_unbind_%d",
+	snprintf(ihost->scan_workq_name, KOBJ_NAME_LEN, "iscsi_scan_%d",
 		shost->host_no);
-	ihost->unbind_workq = create_singlethread_workqueue(
-						ihost->unbind_workq_name);
-	if (!ihost->unbind_workq)
+	ihost->scan_workq = create_singlethread_workqueue(
+						ihost->scan_workq_name);
+	if (!ihost->scan_workq)
 		return -ENOMEM;
 	return 0;
 }
@@ -143,7 +143,7 @@ static int iscsi_remove_host(struct transport_container *tc, struct device *dev,
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct iscsi_host *ihost = shost->shost_data;
 
-	destroy_workqueue(ihost->unbind_workq);
+	destroy_workqueue(ihost->scan_workq);
 	return 0;
 }
 
@@ -302,6 +302,23 @@ static int iscsi_user_scan(struct Scsi_Host *shost, uint channel,
 	return 0;
 }
 
+static void iscsi_scan_session(struct work_struct *work)
+{
+	struct iscsi_cls_session *session =
+			container_of(work, struct iscsi_cls_session, scan_work);
+	unsigned long flags;
+
+	spin_lock_irqsave(&session->lock, flags);
+	if (session->state != ISCSI_SESSION_LOGGED_IN) {
+		spin_unlock_irqrestore(&session->lock, flags);
+		return;
+	}
+	spin_unlock_irqrestore(&session->lock, flags);
+
+	scsi_scan_target(&session->dev, 0, session->target_id,
+			 SCAN_WILD_CARD, 1);
+}
+
 static void session_recovery_timedout(struct work_struct *work)
 {
 	struct iscsi_cls_session *session =
@@ -340,6 +357,8 @@ void __iscsi_unblock_session(struct iscsi_cls_session *session)
 
 void iscsi_unblock_session(struct iscsi_cls_session *session)
 {
+	struct Scsi_Host *shost = iscsi_session_to_shost(session);
+	struct iscsi_host *ihost = shost->shost_data;
 	unsigned long flags;
 
 	spin_lock_irqsave(&session->lock, flags);
@@ -347,6 +366,7 @@ void iscsi_unblock_session(struct iscsi_cls_session *session)
 	spin_unlock_irqrestore(&session->lock, flags);
 
 	__iscsi_unblock_session(session);
+	queue_work(ihost->scan_workq, &session->scan_work);
 }
 EXPORT_SYMBOL_GPL(iscsi_unblock_session);
 
@@ -390,7 +410,7 @@ static int iscsi_unbind_session(struct iscsi_cls_session *session)
 	struct Scsi_Host *shost = iscsi_session_to_shost(session);
 	struct iscsi_host *ihost = shost->shost_data;
 
-	return queue_work(ihost->unbind_workq, &session->unbind_work);
+	return queue_work(ihost->scan_workq, &session->unbind_work);
 }
 
 struct iscsi_cls_session *
@@ -411,6 +431,7 @@ iscsi_alloc_session(struct Scsi_Host *shost,
 	INIT_LIST_HEAD(&session->host_list);
 	INIT_LIST_HEAD(&session->sess_list);
 	INIT_WORK(&session->unbind_work, __iscsi_unbind_session);
+	INIT_WORK(&session->scan_work, iscsi_scan_session);
 	spin_lock_init(&session->lock);
 
 	/* this is released in the dev's release function */
@@ -530,13 +551,15 @@ void iscsi_remove_session(struct iscsi_cls_session *session)
 	spin_unlock_irqrestore(&session->lock, flags);
 	__iscsi_unblock_session(session);
 	iscsi_unbind_session(session);
+
+	/* flush running scans */
+	flush_workqueue(ihost->scan_workq);
 	/*
 	 * If the session dropped while removing devices then we need to make
 	 * sure it is not blocked
 	 */
 	if (!cancel_delayed_work(&session->recovery_work))
 		flush_workqueue(iscsi_eh_timer_workq);
-	flush_workqueue(ihost->unbind_workq);
 
 	/* hw iscsi may not have removed all connections from session */
 	err = device_for_each_child(&session->dev, NULL,
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 0e869d9..1f0ec46 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -177,11 +177,12 @@ struct iscsi_cls_session {
 	struct list_head host_list;
 	struct iscsi_transport *transport;
 	spinlock_t lock;
+	struct work_struct scan_work;
+	struct work_struct unbind_work;
 
 	/* recovery fields */
 	int recovery_tmo;
 	struct delayed_work recovery_work;
-	struct work_struct unbind_work;
 
 	int target_id;
 
@@ -203,8 +204,8 @@ struct iscsi_cls_session {
 struct iscsi_host {
 	struct list_head sessions;
 	struct mutex mutex;
-	struct workqueue_struct *unbind_workq;
-	char unbind_workq_name[KOBJ_NAME_LEN];
+	struct workqueue_struct *scan_workq;
+	char scan_workq_name[KOBJ_NAME_LEN];
 };
 
 /*
-- 
1.5.2.1

