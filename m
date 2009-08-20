From: michaelc@cs.wisc.edu
Subject: [PATCH 5/7] iscsi class: Add logging to scsi_transport_iscsi.c
Date: Thu, 20 Aug 2009 15:11:01 -0500
Message-ID: <1250799063-1843-6-git-send-email-michaelc@cs.wisc.edu>
References: <1250799063-1843-1-git-send-email-michaelc@cs.wisc.edu>
 <1250799063-1843-2-git-send-email-michaelc@cs.wisc.edu>
 <1250799063-1843-3-git-send-email-michaelc@cs.wisc.edu>
 <1250799063-1843-4-git-send-email-michaelc@cs.wisc.edu>
 <1250799063-1843-5-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755264AbZHTULY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Aug 2009 16:11:24 -0400
In-Reply-To: <1250799063-1843-5-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, Erez Zilber <erezzi.list@gmail.com>

From: Mike Christie <michaelc@cs.wisc.edu>

>From Erez:

Logging for connections and sessions in the scsi_transport_iscsi module
is now controlled by module parameters.

Signed-off-by: Erez Zilber <erezzi.list@gmail.com>
[Mike Christie: newline fixups and modification of some dbg statements]
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c |   73 ++++++++++++++++++++++++++++++++++-
 1 files changed, 71 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 783e33c..763f57e 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -36,6 +36,38 @@
 
 #define ISCSI_TRANSPORT_VERSION "2.0-870"
 
+static int dbg_session;
+module_param_named(debug_session, dbg_session, int,
+		   S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(debug_session,
+		 "Turn on debugging for sessions in scsi_transport_iscsi "
+		 "module. Set to 1 to turn on, and zero to turn off. Default "
+		 "is off.");
+
+static int dbg_conn;
+module_param_named(debug_conn, dbg_conn, int,
+		   S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(debug_conn,
+		 "Turn on debugging for connections in scsi_transport_iscsi "
+		 "module. Set to 1 to turn on, and zero to turn off. Default "
+		 "is off.");
+
+#define ISCSI_DBG_TRANS_SESSION(_session, dbg_fmt, arg...)		\
+	do {								\
+		if (dbg_session)					\
+			iscsi_cls_session_printk(KERN_INFO, _session,	\
+						 "%s: " dbg_fmt,	\
+						 __func__, ##arg);	\
+	} while (0);
+
+#define ISCSI_DBG_TRANS_CONN(_conn, dbg_fmt, arg...)			\
+	do {								\
+		if (dbg_conn)						\
+			iscsi_cls_conn_printk(KERN_INFO, _conn,		\
+					      "%s: " dbg_fmt,		\
+					      __func__, ##arg);	\
+	} while (0);
+
 struct iscsi_internal {
 	struct scsi_transport_template t;
 	struct iscsi_transport *iscsi_transport;
@@ -377,6 +409,7 @@ static void iscsi_session_release(struct device *dev)
 
 	shost = iscsi_session_to_shost(session);
 	scsi_host_put(shost);
+	ISCSI_DBG_TRANS_SESSION(session, "Completing session release\n");
 	kfree(session);
 }
 
@@ -441,6 +474,9 @@ static int iscsi_user_scan_session(struct device *dev, void *data)
 		return 0;
 
 	session = iscsi_dev_to_session(dev);
+
+	ISCSI_DBG_TRANS_SESSION(session, "Scanning session\n");
+
 	shost = iscsi_session_to_shost(session);
 	ihost = shost->shost_data;
 
@@ -448,8 +484,7 @@ static int iscsi_user_scan_session(struct device *dev, void *data)
 	spin_lock_irqsave(&session->lock, flags);
 	if (session->state != ISCSI_SESSION_LOGGED_IN) {
 		spin_unlock_irqrestore(&session->lock, flags);
-		mutex_unlock(&ihost->mutex);
-		return 0;
+		goto user_scan_exit;
 	}
 	id = session->target_id;
 	spin_unlock_irqrestore(&session->lock, flags);
@@ -462,7 +497,10 @@ static int iscsi_user_scan_session(struct device *dev, void *data)
 			scsi_scan_target(&session->dev, 0, id,
 					 scan_data->lun, 1);
 	}
+
+user_scan_exit:
 	mutex_unlock(&ihost->mutex);
+	ISCSI_DBG_TRANS_SESSION(session, "Completed session scan\n");
 	return 0;
 }
 
@@ -522,7 +560,9 @@ static void session_recovery_timedout(struct work_struct *work)
 	if (session->transport->session_recovery_timedout)
 		session->transport->session_recovery_timedout(session);
 
+	ISCSI_DBG_TRANS_SESSION(session, "Unblocking SCSI target\n");
 	scsi_target_unblock(&session->dev);
+	ISCSI_DBG_TRANS_SESSION(session, "Completed unblocking SCSI target\n");
 }
 
 static void __iscsi_unblock_session(struct work_struct *work)
@@ -534,6 +574,7 @@ static void __iscsi_unblock_session(struct work_struct *work)
 	struct iscsi_cls_host *ihost = shost->shost_data;
 	unsigned long flags;
 
+	ISCSI_DBG_TRANS_SESSION(session, "Unblocking session\n");
 	/*
 	 * The recovery and unblock work get run from the same workqueue,
 	 * so try to cancel it if it was going to run after this unblock.
@@ -553,6 +594,7 @@ static void __iscsi_unblock_session(struct work_struct *work)
 		if (scsi_queue_work(shost, &session->scan_work))
 			atomic_inc(&ihost->nr_scans);
 	}
+	ISCSI_DBG_TRANS_SESSION(session, "Completed unblocking session\n");
 }
 
 /**
@@ -579,10 +621,12 @@ static void __iscsi_block_session(struct work_struct *work)
 				     block_work);
 	unsigned long flags;
 
+	ISCSI_DBG_TRANS_SESSION(session, "Blocking session\n");
 	spin_lock_irqsave(&session->lock, flags);
 	session->state = ISCSI_SESSION_FAILED;
 	spin_unlock_irqrestore(&session->lock, flags);
 	scsi_target_block(&session->dev);
+	ISCSI_DBG_TRANS_SESSION(session, "Completed SCSI target blocking\n");
 	queue_delayed_work(iscsi_eh_timer_workq, &session->recovery_work,
 			   session->recovery_tmo * HZ);
 }
@@ -602,6 +646,8 @@ static void __iscsi_unbind_session(struct work_struct *work)
 	struct iscsi_cls_host *ihost = shost->shost_data;
 	unsigned long flags;
 
+	ISCSI_DBG_TRANS_SESSION(session, "Unbinding session\n");
+
 	/* Prevent new scans and make sure scanning is not in progress */
 	mutex_lock(&ihost->mutex);
 	spin_lock_irqsave(&session->lock, flags);
@@ -616,6 +662,7 @@ static void __iscsi_unbind_session(struct work_struct *work)
 
 	scsi_remove_target(&session->dev);
 	iscsi_session_event(session, ISCSI_KEVENT_UNBIND_SESSION);
+	ISCSI_DBG_TRANS_SESSION(session, "Completed target removal\n");
 }
 
 struct iscsi_cls_session *
@@ -647,6 +694,8 @@ iscsi_alloc_session(struct Scsi_Host *shost, struct iscsi_transport *transport,
 	device_initialize(&session->dev);
 	if (dd_size)
 		session->dd_data = &session[1];
+
+	ISCSI_DBG_TRANS_SESSION(session, "Completed session allocation\n");
 	return session;
 }
 EXPORT_SYMBOL_GPL(iscsi_alloc_session);
@@ -712,6 +761,7 @@ int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
 	spin_unlock_irqrestore(&sesslock, flags);
 
 	iscsi_session_event(session, ISCSI_KEVENT_CREATE_SESSION);
+	ISCSI_DBG_TRANS_SESSION(session, "Completed session adding\n");
 	return 0;
 
 release_host:
@@ -752,6 +802,7 @@ static void iscsi_conn_release(struct device *dev)
 	struct iscsi_cls_conn *conn = iscsi_dev_to_conn(dev);
 	struct device *parent = conn->dev.parent;
 
+	ISCSI_DBG_TRANS_CONN(conn, "Releasing conn\n");
 	kfree(conn);
 	put_device(parent);
 }
@@ -774,6 +825,8 @@ void iscsi_remove_session(struct iscsi_cls_session *session)
 	unsigned long flags;
 	int err;
 
+	ISCSI_DBG_TRANS_SESSION(session, "Removing session\n");
+
 	spin_lock_irqsave(&sesslock, flags);
 	list_del(&session->sess_list);
 	spin_unlock_irqrestore(&sesslock, flags);
@@ -807,12 +860,15 @@ void iscsi_remove_session(struct iscsi_cls_session *session)
 					 "for session. Error %d.\n", err);
 
 	transport_unregister_device(&session->dev);
+
+	ISCSI_DBG_TRANS_SESSION(session, "Completing session removal\n");
 	device_del(&session->dev);
 }
 EXPORT_SYMBOL_GPL(iscsi_remove_session);
 
 void iscsi_free_session(struct iscsi_cls_session *session)
 {
+	ISCSI_DBG_TRANS_SESSION(session, "Freeing session\n");
 	iscsi_session_event(session, ISCSI_KEVENT_DESTROY_SESSION);
 	put_device(&session->dev);
 }
@@ -828,6 +884,7 @@ EXPORT_SYMBOL_GPL(iscsi_free_session);
 int iscsi_destroy_session(struct iscsi_cls_session *session)
 {
 	iscsi_remove_session(session);
+	ISCSI_DBG_TRANS_SESSION(session, "Completing session destruction\n");
 	iscsi_free_session(session);
 	return 0;
 }
@@ -885,6 +942,8 @@ iscsi_create_conn(struct iscsi_cls_session *session, int dd_size, uint32_t cid)
 	list_add(&conn->conn_list, &connlist);
 	conn->active = 1;
 	spin_unlock_irqrestore(&connlock, flags);
+
+	ISCSI_DBG_TRANS_CONN(conn, "Completed conn creation\n");
 	return conn;
 
 release_parent_ref:
@@ -912,6 +971,7 @@ int iscsi_destroy_conn(struct iscsi_cls_conn *conn)
 	spin_unlock_irqrestore(&connlock, flags);
 
 	transport_unregister_device(&conn->dev);
+	ISCSI_DBG_TRANS_CONN(conn, "Completing conn destruction\n");
 	device_unregister(&conn->dev);
 	return 0;
 }
@@ -1200,6 +1260,9 @@ int iscsi_session_event(struct iscsi_cls_session *session,
 					 "Cannot notify userspace of session "
 					 "event %u. Check iscsi daemon\n",
 					 event);
+
+	ISCSI_DBG_TRANS_SESSION(session, "Completed handling event %d rc %d\n",
+				event, rc);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(iscsi_session_event);
@@ -1221,6 +1284,8 @@ iscsi_if_create_session(struct iscsi_internal *priv, struct iscsi_endpoint *ep,
 	shost = iscsi_session_to_shost(session);
 	ev->r.c_session_ret.host_no = shost->host_no;
 	ev->r.c_session_ret.sid = session->sid;
+	ISCSI_DBG_TRANS_SESSION(session,
+				"Completed creating transport session\n");
 	return 0;
 }
 
@@ -1246,6 +1311,8 @@ iscsi_if_create_conn(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 
 	ev->r.c_conn_ret.sid = session->sid;
 	ev->r.c_conn_ret.cid = conn->cid;
+
+	ISCSI_DBG_TRANS_CONN(conn, "Completed creating transport conn\n");
 	return 0;
 }
 
@@ -1258,8 +1325,10 @@ iscsi_if_destroy_conn(struct iscsi_transport *transport, struct iscsi_uevent *ev
 	if (!conn)
 		return -EINVAL;
 
+	ISCSI_DBG_TRANS_CONN(conn, "Destroying transport conn\n");
 	if (transport->destroy_conn)
 		transport->destroy_conn(conn);
+
 	return 0;
 }
 
-- 
1.6.2.2

