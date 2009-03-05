From: michaelc@cs.wisc.edu
Subject: [PATCH 08/14] iscsi class: fix lock dep warning on logout
Date: Thu,  5 Mar 2009 14:46:02 -0600
Message-ID: <1236285975607-git-send-email-michaelc@cs.wisc.edu>
References: <12362859683749-git-send-email-michaelc@cs.wisc.edu>
 <12362859693831-git-send-email-michaelc@cs.wisc.edu>
 <12362859702687-git-send-email-michaelc@cs.wisc.edu>
 <123628597367-git-send-email-michaelc@cs.wisc.edu>
 <12362859734023-git-send-email-michaelc@cs.wisc.edu>
 <12362859743025-git-send-email-michaelc@cs.wisc.edu>
 <12362859742776-git-send-email-michaelc@cs.wisc.edu>
 <12362859754088-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52808 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754901AbZCEUqV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Mar 2009 15:46:21 -0500
In-Reply-To: <12362859754088-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

We never should hit the lock up that is spit out when
lock dep is on and we logout. But we have been using the
shost work queue in a odd way. This patch has us use the
work queue for scanning instead of creating our own,
and this ends up also killing the lock dep warnings.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c |   38 +++++-----------------------------
 include/scsi/scsi_transport_iscsi.h |    2 -
 2 files changed, 6 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 75c9297..4f22f9e 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -246,30 +246,13 @@ static int iscsi_setup_host(struct transport_container *tc, struct device *dev,
 	memset(ihost, 0, sizeof(*ihost));
 	atomic_set(&ihost->nr_scans, 0);
 	mutex_init(&ihost->mutex);
-
-	snprintf(ihost->scan_workq_name, sizeof(ihost->scan_workq_name),
-		 "iscsi_scan_%d", shost->host_no);
-	ihost->scan_workq = create_singlethread_workqueue(
-						ihost->scan_workq_name);
-	if (!ihost->scan_workq)
-		return -ENOMEM;
-	return 0;
-}
-
-static int iscsi_remove_host(struct transport_container *tc, struct device *dev,
-			     struct device *cdev)
-{
-	struct Scsi_Host *shost = dev_to_shost(dev);
-	struct iscsi_cls_host *ihost = shost->shost_data;
-
-	destroy_workqueue(ihost->scan_workq);
 	return 0;
 }
 
 static DECLARE_TRANSPORT_CLASS(iscsi_host_class,
 			       "iscsi_host",
 			       iscsi_setup_host,
-			       iscsi_remove_host,
+			       NULL,
 			       NULL);
 
 static DECLARE_TRANSPORT_CLASS(iscsi_session_class,
@@ -568,7 +551,7 @@ static void __iscsi_unblock_session(struct work_struct *work)
 	 * scanning from userspace).
 	 */
 	if (shost->hostt->scan_finished) {
-		if (queue_work(ihost->scan_workq, &session->scan_work))
+		if (scsi_queue_work(shost, &session->scan_work))
 			atomic_inc(&ihost->nr_scans);
 	}
 }
@@ -636,14 +619,6 @@ static void __iscsi_unbind_session(struct work_struct *work)
 	iscsi_session_event(session, ISCSI_KEVENT_UNBIND_SESSION);
 }
 
-static int iscsi_unbind_session(struct iscsi_cls_session *session)
-{
-	struct Scsi_Host *shost = iscsi_session_to_shost(session);
-	struct iscsi_cls_host *ihost = shost->shost_data;
-
-	return queue_work(ihost->scan_workq, &session->unbind_work);
-}
-
 struct iscsi_cls_session *
 iscsi_alloc_session(struct Scsi_Host *shost, struct iscsi_transport *transport,
 		    int dd_size)
@@ -796,7 +771,6 @@ static int iscsi_iter_destroy_conn_fn(struct device *dev, void *data)
 void iscsi_remove_session(struct iscsi_cls_session *session)
 {
 	struct Scsi_Host *shost = iscsi_session_to_shost(session);
-	struct iscsi_cls_host *ihost = shost->shost_data;
 	unsigned long flags;
 	int err;
 
@@ -821,7 +795,7 @@ void iscsi_remove_session(struct iscsi_cls_session *session)
 
 	scsi_target_unblock(&session->dev);
 	/* flush running scans then delete devices */
-	flush_workqueue(ihost->scan_workq);
+	scsi_flush_work(shost);
 	__iscsi_unbind_session(&session->unbind_work);
 
 	/* hw iscsi may not have removed all connections from session */
@@ -1447,7 +1421,8 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	case ISCSI_UEVENT_UNBIND_SESSION:
 		session = iscsi_session_lookup(ev->u.d_session.sid);
 		if (session)
-			iscsi_unbind_session(session);
+			scsi_queue_work(iscsi_session_to_shost(session),
+					&session->unbind_work);
 		else
 			err = -EINVAL;
 		break;
@@ -1809,8 +1784,7 @@ iscsi_register_transport(struct iscsi_transport *tt)
 	priv->daemon_pid = -1;
 	priv->iscsi_transport = tt;
 	priv->t.user_scan = iscsi_user_scan;
-	if (!(tt->caps & CAP_DATA_PATH_OFFLOAD))
-		priv->t.create_work_queue = 1;
+	priv->t.create_work_queue = 1;
 
 	priv->dev.class = &iscsi_transport_class;
 	dev_set_name(&priv->dev, "%s", tt->name);
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index b50aabe..ac29fbd 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -206,8 +206,6 @@ struct iscsi_cls_session {
 struct iscsi_cls_host {
 	atomic_t nr_scans;
 	struct mutex mutex;
-	struct workqueue_struct *scan_workq;
-	char scan_workq_name[20];
 };
 
 extern void iscsi_host_for_each_session(struct Scsi_Host *shost,
-- 
1.6.0.6

