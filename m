From: michaelc@cs.wisc.edu
Subject: [PATCH 1/4] iscsi class, qla4xxx and libiscsi: export iscsi session state in sysfs
Date: Wed, 14 Mar 2007 14:52:45 -0500
Message-ID: <11739019693216-git-send-email-michaelc@cs.wisc.edu>
References: <11739019681346-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030866AbXCNTxH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Mar 2007 15:53:07 -0400
In-Reply-To: <11739019681346-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch adds some common iscsi state info to the iscsi class,
so we can view it in sysfs. It also adds a functions to check
the state before we queue IO (like the fc class). libiscsi does
this already internally, so this is moving some libiscsi functionality
to the class so hw iscsi can use it.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c             |   40 +++++++++----
 drivers/scsi/qla4xxx/ql4_os.c       |   13 ++++
 drivers/scsi/scsi_transport_iscsi.c |  111 ++++++++++++++++++++++++++++++++++-
 include/scsi/libiscsi.h             |   18 ++++++
 include/scsi/scsi_transport_iscsi.h |   27 ++++-----
 5 files changed, 180 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 3f5b9b4..f4e1a1b 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -740,6 +740,7 @@ enum {
 	FAILURE_SESSION_TERMINATE,
 	FAILURE_SESSION_IN_RECOVERY,
 	FAILURE_SESSION_RECOVERY_TIMEOUT,
+	FAILURE_SESSION_NOT_READY,
 };
 
 int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
@@ -757,8 +758,14 @@ int iscsi_queuecommand(struct scsi_cmnd 
 	host = sc->device->host;
 	session = iscsi_hostdata(host->hostdata);
 
-	spin_lock(&session->lock);
+	reason = iscsi_session_chkready(session_to_cls(session));
+	if (reason) {
+		sc->result = reason;
+		reason = FAILURE_SESSION_NOT_READY;
+		goto fault;
+	}
 
+	spin_lock(&session->lock);
 	/*
 	 * ISCSI_STATE_FAILED is a temp. state. The recovery
 	 * code will decide what is best to do with command queued
@@ -777,12 +784,16 @@ int iscsi_queuecommand(struct scsi_cmnd 
 			goto reject;
 		}
 
-		if (session->state == ISCSI_STATE_RECOVERY_FAILED)
+		if (session->state == ISCSI_STATE_RECOVERY_FAILED) {
 			reason = FAILURE_SESSION_RECOVERY_TIMEOUT;
-		else if (session->state == ISCSI_STATE_TERMINATE)
+			sc->result = DID_IMM_RETRY << 16;
+		} else if (session->state == ISCSI_STATE_TERMINATE) {
 			reason = FAILURE_SESSION_TERMINATE;
-		else
+			sc->result = DID_NO_CONNECT << 16;
+		} else {
 			reason = FAILURE_SESSION_FREED;
+			sc->result = DID_NO_CONNECT << 16;
+		}
 		goto fault;
 	}
 
@@ -797,6 +808,7 @@ int iscsi_queuecommand(struct scsi_cmnd 
 	conn = session->leadconn;
 	if (!conn) {
 		reason = FAILURE_SESSION_FREED;
+		sc->result = DID_NO_CONNECT << 16;
 		goto fault;
 	}
 
@@ -840,7 +852,6 @@ fault:
 	spin_unlock(&session->lock);
 	printk(KERN_ERR "iscsi: cmd 0x%x is not queued (%d)\n",
 	       sc->cmnd[0], reason);
-	sc->result = (DID_NO_CONNECT << 16);
 	sc->resid = sc->request_bufflen;
 	sc->scsi_done(sc);
 	return 0;
@@ -1425,6 +1436,7 @@ iscsi_session_setup(struct iscsi_transpo
 	cls_session = iscsi_create_session(shost, iscsit, 0);
 	if (!cls_session)
 		goto module_put;
+
 	*(unsigned long*)shost->hostdata = (unsigned long)cls_session;
 
 	return cls_session;
@@ -1638,6 +1650,7 @@ int iscsi_conn_start(struct iscsi_cls_co
 	spin_lock_bh(&session->lock);
 	conn->c_stage = ISCSI_CONN_STARTED;
 	session->state = ISCSI_STATE_LOGGED_IN;
+	iscsi_set_session_logged_in(session_to_cls(session));
 
 	switch(conn->stop_stage) {
 	case STOP_CONN_RECOVER:
@@ -1695,22 +1708,22 @@ flush_control_queues(struct iscsi_sessio
 }
 
 /* Fail commands. Mutex and session lock held and recv side suspended */
-static void fail_all_commands(struct iscsi_conn *conn)
+static void fail_all_commands(struct iscsi_conn *conn, int error)
 {
 	struct iscsi_cmd_task *ctask, *tmp;
 
 	/* flush pending */
 	list_for_each_entry_safe(ctask, tmp, &conn->xmitqueue, running) {
-		debug_scsi("failing pending sc %p itt 0x%x\n", ctask->sc,
-			   ctask->itt);
-		fail_command(conn, ctask, DID_BUS_BUSY << 16);
+		debug_scsi("failing pending sc %p itt 0x%x err %d\n", ctask->sc,
+			   ctask->itt, error);
+		fail_command(conn, ctask, error << 16);
 	}
 
 	/* fail all other running */
 	list_for_each_entry_safe(ctask, tmp, &conn->run_list, running) {
-		debug_scsi("failing in progress sc %p itt 0x%x\n",
-			   ctask->sc, ctask->itt);
-		fail_command(conn, ctask, DID_BUS_BUSY << 16);
+		debug_scsi("failing in progress sc %p itt 0x%x err %d\n",
+			   ctask->sc, ctask->itt, error);
+		fail_command(conn, ctask, error << 16);
 	}
 
 	conn->ctask = NULL;
@@ -1768,7 +1781,8 @@ static void iscsi_start_session_recovery
 	 * flush queues.
 	 */
 	spin_lock_bh(&session->lock);
-	fail_all_commands(conn);
+	fail_all_commands(conn,
+			STOP_CONN_RECOVER ? DID_BUS_BUSY : DID_ERROR);
 	flush_control_queues(session, conn);
 	spin_unlock_bh(&session->lock);
 
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 0bfddf8..053533d 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -283,6 +283,7 @@ int qla4xxx_add_sess(struct ddb_entry *d
 	}
 
 	ddb_entry->sess->recovery_tmo = ddb_entry->ha->port_down_retry_count;
+	iscsi_set_session_logged_in(ddb_entry->sess);
 	iscsi_if_create_session_done(ddb_entry->conn);
 	return 0;
 }
@@ -413,9 +414,21 @@ static int qla4xxx_queuecommand(struct s
 {
 	struct scsi_qla_host *ha = to_qla_host(cmd->device->host);
 	struct ddb_entry *ddb_entry = cmd->device->hostdata;
+	struct iscsi_cls_session *sess = ddb_entry->sess;
 	struct srb *srb;
 	int rval;
 
+	if (!sess) {
+		cmd->result = DID_IMM_RETRY << 16;
+		goto qc_fail_command;
+	}
+
+	rval = iscsi_session_chkready(sess);
+	if (rval) {
+		cmd->result = rval;
+		goto qc_fail_command;
+	}
+
 	if (atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE) {
 		if (atomic_read(&ddb_entry->state) == DDB_STATE_DEAD) {
 			cmd->result = DID_NO_CONNECT << 16;
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index ff05c84..373167b 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -30,7 +30,7 @@ #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_iscsi.h>
 #include <scsi/iscsi_if.h>
 
-#define ISCSI_SESSION_ATTRS 11
+#define ISCSI_SESSION_ATTRS 12
 #define ISCSI_CONN_ATTRS 11
 #define ISCSI_HOST_ATTRS 0
 #define ISCSI_TRANSPORT_VERSION "2.0-724"
@@ -201,6 +201,51 @@ static struct iscsi_cls_conn *iscsi_conn
  * The following functions can be used by LLDs that allocate
  * their own scsi_hosts or by software iscsi LLDs
  */
+static struct {
+	int value;
+	char *name;
+} iscsi_session_state_names[] = {
+	{ ISCSI_SESSION_LOGGED_IN,	"Logged In" },
+	{ ISCSI_SESSION_FAILED,		"Failed" },
+	{ ISCSI_SESSION_FREE,		"Free" },
+};
+
+const char *iscsi_session_state_name(int state)
+{
+	int i;
+	char *name = NULL;
+
+	for (i = 0; i < ARRAY_SIZE(iscsi_session_state_names); i++) {
+		if (iscsi_session_state_names[i].value == state) {
+			name = iscsi_session_state_names[i].name;
+			break;
+		}
+	}
+	return name;
+}
+
+int iscsi_session_chkready(struct iscsi_cls_session *session)
+{
+	int err;
+
+	switch (session->state) {
+	case ISCSI_SESSION_LOGGED_IN:
+		err = 0;
+		break;
+	case ISCSI_SESSION_FAILED:
+		err = DID_IMM_RETRY << 16;
+		break;
+	case ISCSI_SESSION_FREE:
+		err = DID_NO_CONNECT  << 16;
+		break;
+	default:
+		err = DID_NO_CONNECT << 16;
+		break;
+	}
+	return err;
+}
+EXPORT_SYMBOL_GPL(iscsi_session_chkready);
+
 static void iscsi_session_release(struct device *dev)
 {
 	struct iscsi_cls_session *session = iscsi_dev_to_session(dev);
@@ -239,18 +284,53 @@ static void session_recovery_timedout(st
 	struct iscsi_cls_session *session =
 		container_of(work, struct iscsi_cls_session,
 			     recovery_work.work);
+	unsigned long flags;
 
 	dev_printk(KERN_INFO, &session->dev, "iscsi: session recovery timed "
 		  "out after %d secs\n", session->recovery_tmo);
 
+	spin_lock_irqsave(&session->lock, flags);
+	if (session->state == ISCSI_SESSION_FAILED)
+		session->state = ISCSI_SESSION_FREE;
+	else if (session->state == ISCSI_SESSION_LOGGED_IN) {
+		spin_unlock_irqrestore(&session->lock, flags);
+		return;
+	}
+	spin_unlock_irqrestore(&session->lock, flags);
+
 	if (session->transport->session_recovery_timedout)
 		session->transport->session_recovery_timedout(session);
-
 	scsi_target_unblock(&session->dev);
 }
 
+/*
+ * iscsi_set_session_logged_in: set set to logged in
+ * @session: iscsi class session
+ *
+ * This should be called when the LLD has logged in and is ready to
+ * start IO.
+ */
+void iscsi_set_session_logged_in(struct iscsi_cls_session *session)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&session->lock, flags);
+	session->state = ISCSI_SESSION_LOGGED_IN;
+	spin_unlock_irqrestore(&session->lock, flags);
+}
+EXPORT_SYMBOL_GPL(iscsi_set_session_logged_in);
+
+/*
+ * iscsi_unblock_session: run io
+ * @session: iscsi class session
+ *
+ * LLDs should call this when ready to execute IO. It needs to be called
+ * when in response to a blocked call.
+ */
 void iscsi_unblock_session(struct iscsi_cls_session *session)
 {
+	iscsi_set_session_logged_in(session);
+
 	if (!cancel_delayed_work(&session->recovery_work))
 		flush_scheduled_work();
 	scsi_target_unblock(&session->dev);
@@ -259,6 +339,12 @@ EXPORT_SYMBOL_GPL(iscsi_unblock_session)
 
 void iscsi_block_session(struct iscsi_cls_session *session)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&session->lock, flags);
+	session->state = ISCSI_SESSION_FAILED;
+	spin_unlock_irqrestore(&session->lock, flags);
+
 	scsi_target_block(&session->dev);
 	schedule_delayed_work(&session->recovery_work,
 			     session->recovery_tmo * HZ);
@@ -278,9 +364,11 @@ iscsi_alloc_session(struct Scsi_Host *sh
 
 	session->transport = transport;
 	session->recovery_tmo = 120;
+	session->state = ISCSI_SESSION_FREE;
 	INIT_DELAYED_WORK(&session->recovery_work, session_recovery_timedout);
 	INIT_LIST_HEAD(&session->host_list);
 	INIT_LIST_HEAD(&session->sess_list);
+	spin_lock_init(&session->lock);
 
 	/* this is released in the dev's release function */
 	scsi_host_get(shost);
@@ -330,6 +418,8 @@ EXPORT_SYMBOL_GPL(iscsi_add_session);
  * @transport: iscsi transport
  *
  * This can be called from a LLD or iscsi_transport.
+ * It will leave the session in the free state. When ready
+ * to put it in the logged in state run iscsi_set_session_logged_in.
  **/
 struct iscsi_cls_session *
 iscsi_create_session(struct Scsi_Host *shost,
@@ -566,16 +656,23 @@ EXPORT_SYMBOL_GPL(iscsi_recv_pdu);
 
 void iscsi_conn_error(struct iscsi_cls_conn *conn, enum iscsi_err error)
 {
+	struct iscsi_cls_session *session = iscsi_conn_to_session(conn);
 	struct nlmsghdr	*nlh;
 	struct sk_buff	*skb;
 	struct iscsi_uevent *ev;
 	struct iscsi_internal *priv;
 	int len = NLMSG_SPACE(sizeof(*ev));
+	unsigned long flags;
 
 	priv = iscsi_if_transport_lookup(conn->transport);
 	if (!priv)
 		return;
 
+	spin_lock_irqsave(&session->lock, flags);
+	if (session->state == ISCSI_SESSION_LOGGED_IN)
+		session->state = ISCSI_SESSION_FAILED;
+	spin_unlock_irqrestore(&session->lock, flags);
+
 	skb = alloc_skb(len, GFP_ATOMIC);
 	if (!skb) {
 		dev_printk(KERN_ERR, &conn->dev, "iscsi: gracefully ignored "
@@ -1185,6 +1282,15 @@ iscsi_session_attr(data_seq_in_order, IS
 iscsi_session_attr(erl, ISCSI_PARAM_ERL);
 iscsi_session_attr(tpgt, ISCSI_PARAM_TPGT);
 
+static ssize_t
+show_priv_session_state(struct class_device *cdev, char *buf)
+{
+	struct iscsi_cls_session *session = iscsi_cdev_to_session(cdev);
+	return sprintf(buf, "%s\n", iscsi_session_state_name(session->state));
+}
+static ISCSI_CLASS_ATTR(priv_sess, state, S_IRUGO, show_priv_session_state,
+			NULL);
+
 #define iscsi_priv_session_attr_show(field, format)			\
 static ssize_t								\
 show_priv_session_##field(struct class_device *cdev, char *buf)		\
@@ -1365,6 +1471,7 @@ iscsi_register_transport(struct iscsi_tr
 	SETUP_SESSION_RD_ATTR(targetname, ISCSI_TARGET_NAME);
 	SETUP_SESSION_RD_ATTR(tpgt, ISCSI_TPGT);
 	SETUP_PRIV_SESSION_RD_ATTR(recovery_tmo);
+	SETUP_PRIV_SESSION_RD_ATTR(state);
 
 	BUG_ON(count > ISCSI_SESSION_ATTRS);
 	priv->session_attrs[count] = NULL;
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index ea0816d..1e5c00b 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -119,6 +119,14 @@ struct iscsi_cmd_task {
 	void			*dd_data;	/* driver/transport data */
 };
 
+/* Connection's states */
+enum {
+	ISCSI_CONN_INITIAL_STAGE,
+	ISCSI_CONN_STARTED,
+	ISCSI_CONN_STOPPED,
+	ISCSI_CONN_CLEANUP_WAIT,
+};
+
 struct iscsi_conn {
 	struct iscsi_cls_conn	*cls_conn;	/* ptr to class connection */
 	void			*dd_data;	/* iscsi_transport data */
@@ -205,6 +213,16 @@ struct iscsi_queue {
 	int			max;		/* Max number of elements */
 };
 
+/* Session's states */
+enum {
+	ISCSI_STATE_FREE = 1,
+	ISCSI_STATE_LOGGED_IN,
+	ISCSI_STATE_FAILED,
+	ISCSI_STATE_TERMINATE,
+	ISCSI_STATE_IN_RECOVERY,
+	ISCSI_STATE_RECOVERY_FAILED,
+};
+
 struct iscsi_session {
 	/* iSCSI session-wide sequencing */
 	uint32_t		cmdsn;
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index d5c218d..99067b9 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -141,13 +141,6 @@ extern void iscsi_conn_error(struct iscs
 extern int iscsi_recv_pdu(struct iscsi_cls_conn *conn, struct iscsi_hdr *hdr,
 			  char *data, uint32_t data_size);
 
-
-/* Connection's states */
-#define ISCSI_CONN_INITIAL_STAGE	0
-#define ISCSI_CONN_STARTED		1
-#define ISCSI_CONN_STOPPED		2
-#define ISCSI_CONN_CLEANUP_WAIT		3
-
 struct iscsi_cls_conn {
 	struct list_head conn_list;	/* item in connlist */
 	void *dd_data;			/* LLD private data */
@@ -161,18 +154,21 @@ struct iscsi_cls_conn {
 #define iscsi_dev_to_conn(_dev) \
 	container_of(_dev, struct iscsi_cls_conn, dev)
 
-/* Session's states */
-#define ISCSI_STATE_FREE		1
-#define ISCSI_STATE_LOGGED_IN		2
-#define ISCSI_STATE_FAILED		3
-#define ISCSI_STATE_TERMINATE		4
-#define ISCSI_STATE_IN_RECOVERY		5
-#define ISCSI_STATE_RECOVERY_FAILED	6
+#define iscsi_conn_to_session(_conn) \
+	iscsi_dev_to_session(_conn->dev.parent)
+
+/* iscsi class session state */
+enum {
+	ISCSI_SESSION_LOGGED_IN,
+	ISCSI_SESSION_FAILED,
+	ISCSI_SESSION_FREE,
+};
 
 struct iscsi_cls_session {
 	struct list_head sess_list;		/* item in session_list */
 	struct list_head host_list;
 	struct iscsi_transport *transport;
+	spinlock_t lock;			/* protects state */
 
 	/* recovery fields */
 	int recovery_tmo;
@@ -180,6 +176,7 @@ struct iscsi_cls_session {
 
 	int target_id;
 
+	int state;
 	int sid;				/* session id */
 	void *dd_data;				/* LLD private data */
 	struct device dev;	/* sysfs transport/container device */
@@ -202,6 +199,8 @@ struct iscsi_host {
 /*
  * session and connection functions that can be used by HW iSCSI LLDs
  */
+extern void iscsi_set_session_logged_in(struct iscsi_cls_session *session);
+extern int iscsi_session_chkready(struct iscsi_cls_session *session);
 extern struct iscsi_cls_session *iscsi_alloc_session(struct Scsi_Host *shost,
 					struct iscsi_transport *transport);
 extern int iscsi_add_session(struct iscsi_cls_session *session,
-- 
1.4.1.1

