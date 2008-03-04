From: michaelc@cs.wisc.edu
Subject: [PATCH 3/3] iscsi class: regression - fix races with state manipulation and blocking/unblocking
Date: Tue,  4 Mar 2008 13:26:55 -0600
Message-ID: <1204658815-6185-4-git-send-email-michaelc@cs.wisc.edu>
References: <1204658815-6185-1-git-send-email-michaelc@cs.wisc.edu>
 <1204658815-6185-2-git-send-email-michaelc@cs.wisc.edu>
 <1204658815-6185-3-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:41147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762417AbYCDT1A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Mar 2008 14:27:00 -0500
In-Reply-To: <1204658815-6185-3-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

For qla4xxx, we could be starting a session, but some error (network,
target, IO from a device that got started, etc) could cause the session
to fail and curring the block/unblock and state manipulation could race
with each other. This patch just has those operations done in the
single threaded iscsi eh work queue, so that way they are serialized.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c |   76 ++++++++++++++++++++++-------------
 include/scsi/scsi_transport_iscsi.h |    2 +
 2 files changed, 50 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index dfb026b..ca7bb6f 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -373,24 +373,25 @@ static void session_recovery_timedout(struct work_struct *work)
 	scsi_target_unblock(&session->dev);
 }
 
-static void __iscsi_unblock_session(struct iscsi_cls_session *session)
-{
-	if (!cancel_delayed_work(&session->recovery_work))
-		flush_workqueue(iscsi_eh_timer_workq);
-	scsi_target_unblock(&session->dev);
-}
-
-void iscsi_unblock_session(struct iscsi_cls_session *session)
+static void __iscsi_unblock_session(struct work_struct *work)
 {
+	struct iscsi_cls_session *session =
+			container_of(work, struct iscsi_cls_session,
+				     unblock_work);
 	struct Scsi_Host *shost = iscsi_session_to_shost(session);
 	struct iscsi_host *ihost = shost->shost_data;
 	unsigned long flags;
 
+	/*
+	 * The recovery and unblock work get run from the same workqueue,
+	 * so try to cancel it if it was going to run after this unblock.
+	 */
+	cancel_delayed_work(&session->recovery_work);
 	spin_lock_irqsave(&session->lock, flags);
 	session->state = ISCSI_SESSION_LOGGED_IN;
 	spin_unlock_irqrestore(&session->lock, flags);
-
-	__iscsi_unblock_session(session);
+	/* start IO */
+	scsi_target_unblock(&session->dev);
 	/*
 	 * Only do kernel scanning if the driver is properly hooked into
 	 * the async scanning code (drivers like iscsi_tcp do login and
@@ -401,20 +402,43 @@ void iscsi_unblock_session(struct iscsi_cls_session *session)
 			atomic_inc(&ihost->nr_scans);
 	}
 }
+
+/**
+ * iscsi_unblock_session - set a session as logged in and start IO.
+ * @session: iscsi session
+ *
+ * Mark a session as ready to accept IO.
+ */
+void iscsi_unblock_session(struct iscsi_cls_session *session)
+{
+	queue_work(iscsi_eh_timer_workq, &session->unblock_work);
+	/*
+	 * make sure all the events have completed before tell the driver
+	 * it is safe
+	 */
+	flush_workqueue(iscsi_eh_timer_workq);
+}
 EXPORT_SYMBOL_GPL(iscsi_unblock_session);
 
-void iscsi_block_session(struct iscsi_cls_session *session)
+static void __iscsi_block_session(struct work_struct *work)
 {
+	struct iscsi_cls_session *session =
+			container_of(work, struct iscsi_cls_session,
+				     block_work);
 	unsigned long flags;
 
 	spin_lock_irqsave(&session->lock, flags);
 	session->state = ISCSI_SESSION_FAILED;
 	spin_unlock_irqrestore(&session->lock, flags);
-
 	scsi_target_block(&session->dev);
 	queue_delayed_work(iscsi_eh_timer_workq, &session->recovery_work,
 			   session->recovery_tmo * HZ);
 }
+
+void iscsi_block_session(struct iscsi_cls_session *session)
+{
+	queue_work(iscsi_eh_timer_workq, &session->block_work);
+}
 EXPORT_SYMBOL_GPL(iscsi_block_session);
 
 static void __iscsi_unbind_session(struct work_struct *work)
@@ -463,6 +487,8 @@ iscsi_alloc_session(struct Scsi_Host *shost,
 	INIT_DELAYED_WORK(&session->recovery_work, session_recovery_timedout);
 	INIT_LIST_HEAD(&session->host_list);
 	INIT_LIST_HEAD(&session->sess_list);
+	INIT_WORK(&session->unblock_work, __iscsi_unblock_session);
+	INIT_WORK(&session->block_work, __iscsi_block_session);
 	INIT_WORK(&session->unbind_work, __iscsi_unbind_session);
 	INIT_WORK(&session->scan_work, iscsi_scan_session);
 	spin_lock_init(&session->lock);
@@ -575,24 +601,25 @@ void iscsi_remove_session(struct iscsi_cls_session *session)
 	list_del(&session->sess_list);
 	spin_unlock_irqrestore(&sesslock, flags);
 
+	/* make sure there are no blocks/unblocks queued */
+	flush_workqueue(iscsi_eh_timer_workq);
+	/* make sure the timedout callout is not running */
+	if (!cancel_delayed_work(&session->recovery_work))
+		flush_workqueue(iscsi_eh_timer_workq);
 	/*
 	 * If we are blocked let commands flow again. The lld or iscsi
 	 * layer should set up the queuecommand to fail commands.
+	 * We assume that LLD will not be calling block/unblock while
+	 * removing the session.
 	 */
 	spin_lock_irqsave(&session->lock, flags);
 	session->state = ISCSI_SESSION_FREE;
 	spin_unlock_irqrestore(&session->lock, flags);
-	__iscsi_unblock_session(session);
-	__iscsi_unbind_session(&session->unbind_work);
 
-	/* flush running scans */
+	scsi_target_unblock(&session->dev);
+	/* flush running scans then delete devices */
 	flush_workqueue(ihost->scan_workq);
-	/*
-	 * If the session dropped while removing devices then we need to make
-	 * sure it is not blocked
-	 */
-	if (!cancel_delayed_work(&session->recovery_work))
-		flush_workqueue(iscsi_eh_timer_workq);
+	__iscsi_unbind_session(&session->unbind_work);
 
 	/* hw iscsi may not have removed all connections from session */
 	err = device_for_each_child(&session->dev, NULL,
@@ -802,23 +829,16 @@ EXPORT_SYMBOL_GPL(iscsi_recv_pdu);
 
 void iscsi_conn_error(struct iscsi_cls_conn *conn, enum iscsi_err error)
 {
-	struct iscsi_cls_session *session = iscsi_conn_to_session(conn);
 	struct nlmsghdr	*nlh;
 	struct sk_buff	*skb;
 	struct iscsi_uevent *ev;
 	struct iscsi_internal *priv;
 	int len = NLMSG_SPACE(sizeof(*ev));
-	unsigned long flags;
 
 	priv = iscsi_if_transport_lookup(conn->transport);
 	if (!priv)
 		return;
 
-	spin_lock_irqsave(&session->lock, flags);
-	if (session->state == ISCSI_SESSION_LOGGED_IN)
-		session->state = ISCSI_SESSION_FAILED;
-	spin_unlock_irqrestore(&session->lock, flags);
-
 	skb = alloc_skb(len, GFP_ATOMIC);
 	if (!skb) {
 		iscsi_cls_conn_printk(KERN_ERR, conn, "gracefully ignored "
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index dbc96ef..aab1eae 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -177,6 +177,8 @@ struct iscsi_cls_session {
 	struct list_head host_list;
 	struct iscsi_transport *transport;
 	spinlock_t lock;
+	struct work_struct block_work;
+	struct work_struct unblock_work;
 	struct work_struct scan_work;
 	struct work_struct unbind_work;
 
-- 
1.5.4.1

