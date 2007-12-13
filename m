From: michaelc@cs.wisc.edu
Subject: [PATCH 10/24] libiscsi: fix shutdown
Date: Thu, 13 Dec 2007 12:43:29 -0600
Message-ID: <11975714372848-git-send-email-michaelc@cs.wisc.edu>
References: <11975714233983-git-send-email-michaelc@cs.wisc.edu>
 <1197571428957-git-send-email-michaelc@cs.wisc.edu>
 <11975714291290-git-send-email-michaelc@cs.wisc.edu>
 <11975714303190-git-send-email-michaelc@cs.wisc.edu>
 <11975714323427-git-send-email-michaelc@cs.wisc.edu>
 <11975714333916-git-send-email-michaelc@cs.wisc.edu>
 <11975714342353-git-send-email-michaelc@cs.wisc.edu>
 <1197571435692-git-send-email-michaelc@cs.wisc.edu>
 <119757143673-git-send-email-michaelc@cs.wisc.edu>
 <11975714363904-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758560AbXLMSoE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Dec 2007 13:44:04 -0500
In-Reply-To: <11975714363904-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

We were using the device delete sysfs file to remove each device
then logout. Now in 2.6.21 this will not work because
the sysfs delete file returns immediately and does not wait for
the device removal to complete. This causes a hang if a cache sync
is needed during shutdown. Before .21, that approach had other
problems, so this patch fixes the shutdown code so that we remove the target
and unbind the session before logging out and shut down the session

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c             |    4 +-
 drivers/scsi/qla4xxx/ql4_init.c     |    4 +-
 drivers/scsi/qla4xxx/ql4_os.c       |    7 +-
 drivers/scsi/scsi_transport_iscsi.c |  289 +++++++++++++++++++----------------
 include/scsi/iscsi_if.h             |    7 +
 include/scsi/iscsi_proto.h          |    2 +
 include/scsi/scsi_transport_iscsi.h |    7 +-
 7 files changed, 176 insertions(+), 144 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 441e351..5205ef2 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1662,7 +1662,7 @@ void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
 	struct iscsi_session *session = iscsi_hostdata(shost->hostdata);
 	struct module *owner = cls_session->transport->owner;
 
-	iscsi_unblock_session(cls_session);
+	iscsi_remove_session(cls_session);
 	scsi_remove_host(shost);
 
 	iscsi_pool_free(&session->mgmtpool);
@@ -1677,7 +1677,7 @@ void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
 	kfree(session->hwaddress);
 	kfree(session->initiatorname);
 
-	iscsi_destroy_session(cls_session);
+	iscsi_free_session(cls_session);
 	scsi_host_put(shost);
 	module_put(owner);
 }
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index d692c71..cbe0a17 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -5,6 +5,7 @@
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
 
+#include <scsi/iscsi_if.h>
 #include "ql4_def.h"
 #include "ql4_glbl.h"
 #include "ql4_dbg.h"
@@ -1305,7 +1306,8 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha,
 		atomic_set(&ddb_entry->relogin_timer, 0);
 		clear_bit(DF_RELOGIN, &ddb_entry->flags);
 		clear_bit(DF_NO_RELOGIN, &ddb_entry->flags);
-		iscsi_if_create_session_done(ddb_entry->conn);
+		iscsi_session_event(ddb_entry->sess,
+				    ISCSI_KEVENT_CREATE_SESSION);
 		/*
 		 * Change the lun state to READY in case the lun TIMEOUT before
 		 * the device came back.
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 89460d2..f55b9f7 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -298,8 +298,7 @@ void qla4xxx_destroy_sess(struct ddb_entry *ddb_entry)
 		return;
 
 	if (ddb_entry->conn) {
-		iscsi_if_destroy_session_done(ddb_entry->conn);
-		iscsi_destroy_conn(ddb_entry->conn);
+		atomic_set(&ddb_entry->state, DDB_STATE_DEAD);
 		iscsi_remove_session(ddb_entry->sess);
 	}
 	iscsi_free_session(ddb_entry->sess);
@@ -309,6 +308,7 @@ int qla4xxx_add_sess(struct ddb_entry *ddb_entry)
 {
 	int err;
 
+	ddb_entry->sess->recovery_tmo = ddb_entry->ha->port_down_retry_count;
 	err = iscsi_add_session(ddb_entry->sess, ddb_entry->fw_ddb_index);
 	if (err) {
 		DEBUG2(printk(KERN_ERR "Could not add session.\n"));
@@ -321,9 +321,6 @@ int qla4xxx_add_sess(struct ddb_entry *ddb_entry)
 		DEBUG2(printk(KERN_ERR "Could not add connection.\n"));
 		return -ENOMEM;
 	}
-
-	ddb_entry->sess->recovery_tmo = ddb_entry->ha->port_down_retry_count;
-	iscsi_if_create_session_done(ddb_entry->conn);
 	return 0;
 }
 
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 9cc2cc8..b82139d 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -116,6 +116,8 @@ static struct attribute_group iscsi_transport_group = {
 	.attrs = iscsi_transport_attrs,
 };
 
+
+
 static int iscsi_setup_host(struct transport_container *tc, struct device *dev,
 			    struct class_device *cdev)
 {
@@ -125,13 +127,30 @@ static int iscsi_setup_host(struct transport_container *tc, struct device *dev,
 	memset(ihost, 0, sizeof(*ihost));
 	INIT_LIST_HEAD(&ihost->sessions);
 	mutex_init(&ihost->mutex);
+
+	snprintf(ihost->unbind_workq_name, KOBJ_NAME_LEN, "iscsi_unbind_%d",
+		shost->host_no);
+	ihost->unbind_workq = create_singlethread_workqueue(
+						ihost->unbind_workq_name);
+	if (!ihost->unbind_workq)
+		return -ENOMEM;
+	return 0;
+}
+
+static int iscsi_remove_host(struct transport_container *tc, struct device *dev,
+			     struct class_device *cdev)
+{
+	struct Scsi_Host *shost = dev_to_shost(dev);
+	struct iscsi_host *ihost = shost->shost_data;
+
+	destroy_workqueue(ihost->unbind_workq);
 	return 0;
 }
 
 static DECLARE_TRANSPORT_CLASS(iscsi_host_class,
 			       "iscsi_host",
 			       iscsi_setup_host,
-			       NULL,
+			       iscsi_remove_host,
 			       NULL);
 
 static DECLARE_TRANSPORT_CLASS(iscsi_session_class,
@@ -266,6 +285,35 @@ void iscsi_block_session(struct iscsi_cls_session *session)
 }
 EXPORT_SYMBOL_GPL(iscsi_block_session);
 
+static void __iscsi_unbind_session(struct work_struct *work)
+{
+	struct iscsi_cls_session *session =
+			container_of(work, struct iscsi_cls_session,
+				     unbind_work);
+	struct Scsi_Host *shost = iscsi_session_to_shost(session);
+	struct iscsi_host *ihost = shost->shost_data;
+
+	/* Prevent new scans and make sure scanning is not in progress */
+	mutex_lock(&ihost->mutex);
+	if (list_empty(&session->host_list)) {
+		mutex_unlock(&ihost->mutex);
+		return;
+	}
+	list_del_init(&session->host_list);
+	mutex_unlock(&ihost->mutex);
+
+	scsi_remove_target(&session->dev);
+	iscsi_session_event(session, ISCSI_KEVENT_UNBIND_SESSION);
+}
+
+static int iscsi_unbind_session(struct iscsi_cls_session *session)
+{
+	struct Scsi_Host *shost = iscsi_session_to_shost(session);
+	struct iscsi_host *ihost = shost->shost_data;
+
+	return queue_work(ihost->unbind_workq, &session->unbind_work);
+}
+
 struct iscsi_cls_session *
 iscsi_alloc_session(struct Scsi_Host *shost,
 		    struct iscsi_transport *transport)
@@ -282,6 +330,7 @@ iscsi_alloc_session(struct Scsi_Host *shost,
 	INIT_DELAYED_WORK(&session->recovery_work, session_recovery_timedout);
 	INIT_LIST_HEAD(&session->host_list);
 	INIT_LIST_HEAD(&session->sess_list);
+	INIT_WORK(&session->unbind_work, __iscsi_unbind_session);
 
 	/* this is released in the dev's release function */
 	scsi_host_get(shost);
@@ -298,6 +347,7 @@ int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
 {
 	struct Scsi_Host *shost = iscsi_session_to_shost(session);
 	struct iscsi_host *ihost;
+	unsigned long flags;
 	int err;
 
 	ihost = shost->shost_data;
@@ -314,9 +364,15 @@ int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
 	}
 	transport_register_device(&session->dev);
 
+	spin_lock_irqsave(&sesslock, flags);
+	list_add(&session->sess_list, &sesslist);
+	spin_unlock_irqrestore(&sesslock, flags);
+
 	mutex_lock(&ihost->mutex);
 	list_add(&session->host_list, &ihost->sessions);
 	mutex_unlock(&ihost->mutex);
+
+	iscsi_session_event(session, ISCSI_KEVENT_CREATE_SESSION);
 	return 0;
 
 release_host:
@@ -352,19 +408,58 @@ iscsi_create_session(struct Scsi_Host *shost,
 }
 EXPORT_SYMBOL_GPL(iscsi_create_session);
 
+static void iscsi_conn_release(struct device *dev)
+{
+	struct iscsi_cls_conn *conn = iscsi_dev_to_conn(dev);
+	struct device *parent = conn->dev.parent;
+
+	kfree(conn);
+	put_device(parent);
+}
+
+static int iscsi_is_conn_dev(const struct device *dev)
+{
+	return dev->release == iscsi_conn_release;
+}
+
+static int iscsi_iter_destroy_conn_fn(struct device *dev, void *data)
+{
+	if (!iscsi_is_conn_dev(dev))
+		return 0;
+	return iscsi_destroy_conn(iscsi_dev_to_conn(dev));
+}
+
 void iscsi_remove_session(struct iscsi_cls_session *session)
 {
 	struct Scsi_Host *shost = iscsi_session_to_shost(session);
 	struct iscsi_host *ihost = shost->shost_data;
+	unsigned long flags;
+	int err;
+
+	spin_lock_irqsave(&sesslock, flags);
+	list_del(&session->sess_list);
+	spin_unlock_irqrestore(&sesslock, flags);
 
+	/*
+	 * If we are blocked let commands flow again. The lld or iscsi
+	 * layer should set up the queuecommand to fail commands.
+	 */
+	iscsi_unblock_session(session);
+	iscsi_unbind_session(session);
+	/*
+	 * If the session dropped while removing devices then we need to make
+	 * sure it is not blocked
+	 */
 	if (!cancel_delayed_work(&session->recovery_work))
 		flush_workqueue(iscsi_eh_timer_workq);
+	flush_workqueue(ihost->unbind_workq);
 
-	mutex_lock(&ihost->mutex);
-	list_del(&session->host_list);
-	mutex_unlock(&ihost->mutex);
-
-	scsi_remove_target(&session->dev);
+	/* hw iscsi may not have removed all connections from session */
+	err = device_for_each_child(&session->dev, NULL,
+				    iscsi_iter_destroy_conn_fn);
+	if (err)
+		dev_printk(KERN_ERR, &session->dev, "iscsi: Could not delete "
+			   "all connections for session. Error %d.\n", err);
 
 	transport_unregister_device(&session->dev);
 	device_del(&session->dev);
@@ -373,9 +468,9 @@ EXPORT_SYMBOL_GPL(iscsi_remove_session);
 
 void iscsi_free_session(struct iscsi_cls_session *session)
 {
+	iscsi_session_event(session, ISCSI_KEVENT_DESTROY_SESSION);
 	put_device(&session->dev);
 }
-
 EXPORT_SYMBOL_GPL(iscsi_free_session);
 
 /**
@@ -393,20 +488,6 @@ int iscsi_destroy_session(struct iscsi_cls_session *session)
 }
 EXPORT_SYMBOL_GPL(iscsi_destroy_session);
 
-static void iscsi_conn_release(struct device *dev)
-{
-	struct iscsi_cls_conn *conn = iscsi_dev_to_conn(dev);
-	struct device *parent = conn->dev.parent;
-
-	kfree(conn);
-	put_device(parent);
-}
-
-static int iscsi_is_conn_dev(const struct device *dev)
-{
-	return dev->release == iscsi_conn_release;
-}
-
 /**
  * iscsi_create_conn - create iscsi class connection
  * @session: iscsi cls session
@@ -426,6 +507,7 @@ iscsi_create_conn(struct iscsi_cls_session *session, uint32_t cid)
 {
 	struct iscsi_transport *transport = session->transport;
 	struct iscsi_cls_conn *conn;
+	unsigned long flags;
 	int err;
 
 	conn = kzalloc(sizeof(*conn) + transport->conndata_size, GFP_KERNEL);
@@ -454,6 +536,11 @@ iscsi_create_conn(struct iscsi_cls_session *session, uint32_t cid)
 		goto release_parent_ref;
 	}
 	transport_register_device(&conn->dev);
+
+	spin_lock_irqsave(&connlock, flags);
+	list_add(&conn->conn_list, &connlist);
+	conn->active = 1;
+	spin_unlock_irqrestore(&connlock, flags);
 	return conn;
 
 release_parent_ref:
@@ -469,15 +556,21 @@ EXPORT_SYMBOL_GPL(iscsi_create_conn);
  * iscsi_destroy_conn - destroy iscsi class connection
  * @conn: iscsi cls session
  *
- * This can be called from an LLD or iscsi_transport.
+ * This can be called from a LLD or iscsi_transport.
  */
 int iscsi_destroy_conn(struct iscsi_cls_conn *conn)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&connlock, flags);
+	conn->active = 0;
+	list_del(&conn->conn_list);
+	spin_unlock_irqrestore(&connlock, flags);
+
 	transport_unregister_device(&conn->dev);
 	device_unregister(&conn->dev);
 	return 0;
 }
-
 EXPORT_SYMBOL_GPL(iscsi_destroy_conn);
 
 /*
@@ -687,132 +780,74 @@ iscsi_if_get_stats(struct iscsi_transport *transport, struct nlmsghdr *nlh)
 }
 
 /**
- * iscsi_if_destroy_session_done - send session destr. completion event
- * @conn: last connection for session
- *
- * This is called by HW iscsi LLDs to notify userpsace that its HW has
- * removed a session.
+ * iscsi_session_event - send session destr. completion event
+ * @session: iscsi class session
+ * @event: type of event
  */
-int iscsi_if_destroy_session_done(struct iscsi_cls_conn *conn)
+int iscsi_session_event(struct iscsi_cls_session *session,
+			enum iscsi_uevent_e event)
 {
 	struct iscsi_internal *priv;
-	struct iscsi_cls_session *session;
 	struct Scsi_Host *shost;
 	struct iscsi_uevent *ev;
 	struct sk_buff  *skb;
 	struct nlmsghdr *nlh;
-	unsigned long flags;
 	int rc, len = NLMSG_SPACE(sizeof(*ev));
 
-	priv = iscsi_if_transport_lookup(conn->transport);
+	priv = iscsi_if_transport_lookup(session->transport);
 	if (!priv)
 		return -EINVAL;
-
-	session = iscsi_dev_to_session(conn->dev.parent);
 	shost = iscsi_session_to_shost(session);
 
 	skb = alloc_skb(len, GFP_KERNEL);
 	if (!skb) {
-		dev_printk(KERN_ERR, &conn->dev, "Cannot notify userspace of "
-			  "session creation event\n");
+		dev_printk(KERN_ERR, &session->dev, "Cannot notify userspace "
+			  "of session event %u\n", event);
 		return -ENOMEM;
 	}
 
 	nlh = __nlmsg_put(skb, priv->daemon_pid, 0, 0, (len - sizeof(*nlh)), 0);
 	ev = NLMSG_DATA(nlh);
-	ev->transport_handle = iscsi_handle(conn->transport);
-	ev->type = ISCSI_KEVENT_DESTROY_SESSION;
-	ev->r.d_session.host_no = shost->host_no;
-	ev->r.d_session.sid = session->sid;
-
-	/*
-	 * this will occur if the daemon is not up, so we just warn
-	 * the user and when the daemon is restarted it will handle it
-	 */
-	rc = iscsi_broadcast_skb(skb, GFP_KERNEL);
-	if (rc < 0)
-		dev_printk(KERN_ERR, &conn->dev, "Cannot notify userspace of "
-			  "session destruction event. Check iscsi daemon\n");
-
-	spin_lock_irqsave(&sesslock, flags);
-	list_del(&session->sess_list);
-	spin_unlock_irqrestore(&sesslock, flags);
-
-	spin_lock_irqsave(&connlock, flags);
-	conn->active = 0;
-	list_del(&conn->conn_list);
-	spin_unlock_irqrestore(&connlock, flags);
-
-	return rc;
-}
-EXPORT_SYMBOL_GPL(iscsi_if_destroy_session_done);
-
-/**
- * iscsi_if_create_session_done - send session creation completion event
- * @conn: leading connection for session
- *
- * This is called by HW iscsi LLDs to notify userpsace that its HW has
- * created a session or a existing session is back in the logged in state.
- */
-int iscsi_if_create_session_done(struct iscsi_cls_conn *conn)
-{
-	struct iscsi_internal *priv;
-	struct iscsi_cls_session *session;
-	struct Scsi_Host *shost;
-	struct iscsi_uevent *ev;
-	struct sk_buff  *skb;
-	struct nlmsghdr *nlh;
-	unsigned long flags;
-	int rc, len = NLMSG_SPACE(sizeof(*ev));
+	ev->transport_handle = iscsi_handle(session->transport);
 
-	priv = iscsi_if_transport_lookup(conn->transport);
-	if (!priv)
+	ev->type = event;
+	switch (event) {
+	case ISCSI_KEVENT_DESTROY_SESSION:
+		ev->r.d_session.host_no = shost->host_no;
+		ev->r.d_session.sid = session->sid;
+		break;
+	case ISCSI_KEVENT_CREATE_SESSION:
+		ev->r.c_session_ret.host_no = shost->host_no;
+		ev->r.c_session_ret.sid = session->sid;
+		break;
+	case ISCSI_KEVENT_UNBIND_SESSION:
+		ev->r.unbind_session.host_no = shost->host_no;
+		ev->r.unbind_session.sid = session->sid;
+		break;
+	default:
+		dev_printk(KERN_ERR, &session->dev, "Invalid event %u.\n",
+			   event);
+		kfree_skb(skb);
 		return -EINVAL;
-
-	session = iscsi_dev_to_session(conn->dev.parent);
-	shost = iscsi_session_to_shost(session);
-
-	skb = alloc_skb(len, GFP_KERNEL);
-	if (!skb) {
-		dev_printk(KERN_ERR, &conn->dev, "Cannot notify userspace of "
-			  "session creation event\n");
-		return -ENOMEM;
 	}
 
-	nlh = __nlmsg_put(skb, priv->daemon_pid, 0, 0, (len - sizeof(*nlh)), 0);
-	ev = NLMSG_DATA(nlh);
-	ev->transport_handle = iscsi_handle(conn->transport);
-	ev->type = ISCSI_UEVENT_CREATE_SESSION;
-	ev->r.c_session_ret.host_no = shost->host_no;
-	ev->r.c_session_ret.sid = session->sid;
-
 	/*
 	 * this will occur if the daemon is not up, so we just warn
 	 * the user and when the daemon is restarted it will handle it
 	 */
 	rc = iscsi_broadcast_skb(skb, GFP_KERNEL);
 	if (rc < 0)
-		dev_printk(KERN_ERR, &conn->dev, "Cannot notify userspace of "
-			  "session creation event. Check iscsi daemon\n");
-
-	spin_lock_irqsave(&sesslock, flags);
-	list_add(&session->sess_list, &sesslist);
-	spin_unlock_irqrestore(&sesslock, flags);
-
-	spin_lock_irqsave(&connlock, flags);
-	list_add(&conn->conn_list, &connlist);
-	conn->active = 1;
-	spin_unlock_irqrestore(&connlock, flags);
+		dev_printk(KERN_ERR, &session->dev, "Cannot notify userspace "
+			  "of session event %u. Check iscsi daemon\n", event);
 	return rc;
 }
-EXPORT_SYMBOL_GPL(iscsi_if_create_session_done);
+EXPORT_SYMBOL_GPL(iscsi_session_event);
 
 static int
 iscsi_if_create_session(struct iscsi_internal *priv, struct iscsi_uevent *ev)
 {
 	struct iscsi_transport *transport = priv->iscsi_transport;
 	struct iscsi_cls_session *session;
-	unsigned long flags;
 	uint32_t hostno;
 
 	session = transport->create_session(transport, &priv->t,
@@ -823,10 +858,6 @@ iscsi_if_create_session(struct iscsi_internal *priv, struct iscsi_uevent *ev)
 	if (!session)
 		return -ENOMEM;
 
-	spin_lock_irqsave(&sesslock, flags);
-	list_add(&session->sess_list, &sesslist);
-	spin_unlock_irqrestore(&sesslock, flags);
-
 	ev->r.c_session_ret.host_no = hostno;
 	ev->r.c_session_ret.sid = session->sid;
 	return 0;
@@ -837,7 +868,6 @@ iscsi_if_create_conn(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 {
 	struct iscsi_cls_conn *conn;
 	struct iscsi_cls_session *session;
-	unsigned long flags;
 
 	session = iscsi_session_lookup(ev->u.c_conn.sid);
 	if (!session) {
@@ -856,28 +886,17 @@ iscsi_if_create_conn(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 
 	ev->r.c_conn_ret.sid = session->sid;
 	ev->r.c_conn_ret.cid = conn->cid;
-
-	spin_lock_irqsave(&connlock, flags);
-	list_add(&conn->conn_list, &connlist);
-	conn->active = 1;
-	spin_unlock_irqrestore(&connlock, flags);
-
 	return 0;
 }
 
 static int
 iscsi_if_destroy_conn(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 {
-	unsigned long flags;
 	struct iscsi_cls_conn *conn;
 
 	conn = iscsi_conn_lookup(ev->u.d_conn.sid, ev->u.d_conn.cid);
 	if (!conn)
 		return -EINVAL;
-	spin_lock_irqsave(&connlock, flags);
-	conn->active = 0;
-	list_del(&conn->conn_list);
-	spin_unlock_irqrestore(&connlock, flags);
 
 	if (transport->destroy_conn)
 		transport->destroy_conn(conn);
@@ -1004,7 +1023,6 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	struct iscsi_internal *priv;
 	struct iscsi_cls_session *session;
 	struct iscsi_cls_conn *conn;
-	unsigned long flags;
 
 	priv = iscsi_if_transport_lookup(iscsi_ptr(ev->transport_handle));
 	if (!priv)
@@ -1022,13 +1040,16 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		break;
 	case ISCSI_UEVENT_DESTROY_SESSION:
 		session = iscsi_session_lookup(ev->u.d_session.sid);
-		if (session) {
-			spin_lock_irqsave(&sesslock, flags);
-			list_del(&session->sess_list);
-			spin_unlock_irqrestore(&sesslock, flags);
-
+		if (session)
 			transport->destroy_session(session);
-		} else
+		else
+			err = -EINVAL;
+		break;
+	case ISCSI_UEVENT_UNBIND_SESSION:
+		session = iscsi_session_lookup(ev->u.d_session.sid);
+		if (session)
+			iscsi_unbind_session(session);
+		else
 			err = -EINVAL;
 		break;
 	case ISCSI_UEVENT_CREATE_CONN:
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index bff0b1f..8a4426d 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -49,12 +49,15 @@ enum iscsi_uevent_e {
 
 	ISCSI_UEVENT_TGT_DSCVR		= UEVENT_BASE + 15,
 	ISCSI_UEVENT_SET_HOST_PARAM	= UEVENT_BASE + 16,
+	ISCSI_UEVENT_UNBIND_SESSION	= UEVENT_BASE + 17,
 
 	/* up events */
 	ISCSI_KEVENT_RECV_PDU		= KEVENT_BASE + 1,
 	ISCSI_KEVENT_CONN_ERROR		= KEVENT_BASE + 2,
 	ISCSI_KEVENT_IF_ERROR		= KEVENT_BASE + 3,
 	ISCSI_KEVENT_DESTROY_SESSION	= KEVENT_BASE + 4,
+	ISCSI_KEVENT_UNBIND_SESSION	= KEVENT_BASE + 5,
+	ISCSI_KEVENT_CREATE_SESSION	= KEVENT_BASE + 6,
 };
 
 enum iscsi_tgt_dscvr {
@@ -156,6 +159,10 @@ struct iscsi_uevent {
 			uint32_t	sid;
 			uint32_t	cid;
 		} c_conn_ret;
+		struct msg_unbind_session {
+			uint32_t	sid;
+			uint32_t	host_no;
+		} unbind_session;
 		struct msg_recv_req {
 			uint32_t	sid;
 			uint32_t	cid;
diff --git a/include/scsi/iscsi_proto.h b/include/scsi/iscsi_proto.h
index 6947082..318a909 100644
--- a/include/scsi/iscsi_proto.h
+++ b/include/scsi/iscsi_proto.h
@@ -21,6 +21,8 @@
 #ifndef ISCSI_PROTO_H
 #define ISCSI_PROTO_H
 
+#include <linux/types.h>
+
 #define ISCSI_DRAFT20_VERSION	0x00
 
 /* default iSCSI listen port for incoming connections */
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index b8d97bd..093b403 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -186,6 +186,7 @@ struct iscsi_cls_session {
 	/* recovery fields */
 	int recovery_tmo;
 	struct delayed_work recovery_work;
+	struct work_struct unbind_work;
 
 	int target_id;
 
@@ -206,6 +207,8 @@ struct iscsi_cls_session {
 struct iscsi_host {
 	struct list_head sessions;
 	struct mutex mutex;
+	struct workqueue_struct *unbind_workq;
+	char unbind_workq_name[KOBJ_NAME_LEN];
 };
 
 /*
@@ -215,8 +218,8 @@ extern struct iscsi_cls_session *iscsi_alloc_session(struct Scsi_Host *shost,
 					struct iscsi_transport *transport);
 extern int iscsi_add_session(struct iscsi_cls_session *session,
 			     unsigned int target_id);
-extern int iscsi_if_create_session_done(struct iscsi_cls_conn *conn);
-extern int iscsi_if_destroy_session_done(struct iscsi_cls_conn *conn);
+extern int iscsi_session_event(struct iscsi_cls_session *session,
+			       enum iscsi_uevent_e event);
 extern struct iscsi_cls_session *iscsi_create_session(struct Scsi_Host *shost,
 						struct iscsi_transport *t,
 						unsigned int target_id);
-- 
1.5.1.2

