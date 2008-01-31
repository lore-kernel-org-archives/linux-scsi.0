From: michaelc@cs.wisc.edu
Subject: [PATCH 01/12] iscsi class, libiscsi: add iscsi sysfs session state file
Date: Thu, 31 Jan 2008 13:36:43 -0600
Message-ID: <12018082142447-git-send-email-michaelc@cs.wisc.edu>
References: <12018082143359-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756856AbYAaTg6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jan 2008 14:36:58 -0500
In-Reply-To: <12018082143359-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This adds a iscsi session state file which exports the session
state for both software and hardware iscsi. It also hooks libiscsi
in.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c             |   41 +++++++++-----
 drivers/scsi/scsi_transport_iscsi.c |  107 ++++++++++++++++++++++++++++++++++-
 include/scsi/libiscsi.h             |   19 ++++++
 include/scsi/scsi_transport_iscsi.h |   27 ++++-----
 4 files changed, 161 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 553168a..8c41ddb 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -997,6 +997,7 @@ enum {
 	FAILURE_SESSION_IN_RECOVERY,
 	FAILURE_SESSION_RECOVERY_TIMEOUT,
 	FAILURE_SESSION_LOGGING_OUT,
+	FAILURE_SESSION_NOT_READY,
 };
 
 int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
@@ -1017,6 +1018,12 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 	session = iscsi_hostdata(host->hostdata);
 	spin_lock(&session->lock);
 
+	reason = iscsi_session_chkready(session_to_cls(session));
+	if (reason) {
+		sc->result = reason;
+		goto fault;
+	}
+
 	/*
 	 * ISCSI_STATE_FAILED is a temp. state. The recovery
 	 * code will decide what is best to do with command queued
@@ -1033,18 +1040,23 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 		switch (session->state) {
 		case ISCSI_STATE_IN_RECOVERY:
 			reason = FAILURE_SESSION_IN_RECOVERY;
-			goto reject;
+			sc->result = DID_IMM_RETRY << 16;
+			break;
 		case ISCSI_STATE_LOGGING_OUT:
 			reason = FAILURE_SESSION_LOGGING_OUT;
-			goto reject;
+			sc->result = DID_IMM_RETRY << 16;
+			break;
 		case ISCSI_STATE_RECOVERY_FAILED:
 			reason = FAILURE_SESSION_RECOVERY_TIMEOUT;
+			sc->result = DID_NO_CONNECT << 16;
 			break;
 		case ISCSI_STATE_TERMINATE:
 			reason = FAILURE_SESSION_TERMINATE;
+			sc->result = DID_NO_CONNECT << 16;
 			break;
 		default:
 			reason = FAILURE_SESSION_FREED;
+			sc->result = DID_NO_CONNECT << 16;
 		}
 		goto fault;
 	}
@@ -1052,6 +1064,7 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 	conn = session->leadconn;
 	if (!conn) {
 		reason = FAILURE_SESSION_FREED;
+		sc->result = DID_NO_CONNECT << 16;
 		goto fault;
 	}
 
@@ -1091,9 +1104,7 @@ reject:
 
 fault:
 	spin_unlock(&session->lock);
-	printk(KERN_ERR "iscsi: cmd 0x%x is not queued (%d)\n",
-	       sc->cmnd[0], reason);
-	sc->result = (DID_NO_CONNECT << 16);
+	debug_scsi("iscsi: cmd 0x%x is not queued (%d)\n", sc->cmnd[0], reason);
 	scsi_set_resid(sc, scsi_bufflen(sc));
 	sc->scsi_done(sc);
 	spin_lock(host->host_lock);
@@ -1239,7 +1250,8 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
  * Fail commands. session lock held and recv side suspended and xmit
  * thread flushed
  */
-static void fail_all_commands(struct iscsi_conn *conn, unsigned lun)
+static void fail_all_commands(struct iscsi_conn *conn, unsigned lun,
+			      int error)
 {
 	struct iscsi_cmd_task *ctask, *tmp;
 
@@ -1251,7 +1263,7 @@ static void fail_all_commands(struct iscsi_conn *conn, unsigned lun)
 		if (lun == ctask->sc->device->lun || lun == -1) {
 			debug_scsi("failing pending sc %p itt 0x%x\n",
 				   ctask->sc, ctask->itt);
-			fail_command(conn, ctask, DID_BUS_BUSY << 16);
+			fail_command(conn, ctask, error << 16);
 		}
 	}
 
@@ -1259,7 +1271,7 @@ static void fail_all_commands(struct iscsi_conn *conn, unsigned lun)
 		if (lun == ctask->sc->device->lun || lun == -1) {
 			debug_scsi("failing requeued sc %p itt 0x%x\n",
 				   ctask->sc, ctask->itt);
-			fail_command(conn, ctask, DID_BUS_BUSY << 16);
+			fail_command(conn, ctask, error << 16);
 		}
 	}
 
@@ -1573,7 +1585,7 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 	/* need to grab the recv lock then session lock */
 	write_lock_bh(conn->recv_lock);
 	spin_lock(&session->lock);
-	fail_all_commands(conn, sc->device->lun);
+	fail_all_commands(conn, sc->device->lun, DID_ERROR);
 	conn->tmf_state = TMF_INITIAL;
 	spin_unlock(&session->lock);
 	write_unlock_bh(conn->recv_lock);
@@ -2019,11 +2031,7 @@ int iscsi_conn_start(struct iscsi_cls_conn *cls_conn)
 		conn->stop_stage = 0;
 		conn->tmf_state = TMF_INITIAL;
 		session->age++;
-		spin_unlock_bh(&session->lock);
-
-		iscsi_unblock_session(session_to_cls(session));
-		wake_up(&conn->ehwait);
-		return 0;
+		break;
 	case STOP_CONN_TERM:
 		conn->stop_stage = 0;
 		break;
@@ -2032,6 +2040,8 @@ int iscsi_conn_start(struct iscsi_cls_conn *cls_conn)
 	}
 	spin_unlock_bh(&session->lock);
 
+	iscsi_unblock_session(session_to_cls(session));
+	wake_up(&conn->ehwait);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_start);
@@ -2123,7 +2133,8 @@ static void iscsi_start_session_recovery(struct iscsi_session *session,
 	 * flush queues.
 	 */
 	spin_lock_bh(&session->lock);
-	fail_all_commands(conn, -1);
+	fail_all_commands(conn, -1,
+			STOP_CONN_RECOVER ? DID_BUS_BUSY : DID_ERROR);
 	flush_control_queues(session, conn);
 	spin_unlock_bh(&session->lock);
 	mutex_unlock(&session->eh_mutex);
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 0d7b4e7..f876b0a 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -30,7 +30,7 @@
 #include <scsi/scsi_transport_iscsi.h>
 #include <scsi/iscsi_if.h>
 
-#define ISCSI_SESSION_ATTRS 18
+#define ISCSI_SESSION_ATTRS 19
 #define ISCSI_CONN_ATTRS 11
 #define ISCSI_HOST_ATTRS 4
 #define ISCSI_TRANSPORT_VERSION "2.0-867"
@@ -221,6 +221,54 @@ static struct iscsi_cls_conn *iscsi_conn_lookup(uint32_t sid, uint32_t cid)
  * The following functions can be used by LLDs that allocate
  * their own scsi_hosts or by software iscsi LLDs
  */
+static struct {
+	int value;
+	char *name;
+} iscsi_session_state_names[] = {
+	{ ISCSI_SESSION_LOGGED_IN,	"LOGGED_IN" },
+	{ ISCSI_SESSION_FAILED,		"FAILED" },
+	{ ISCSI_SESSION_FREE,		"FREE" },
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
+	unsigned long flags;
+	int err;
+
+	spin_lock_irqsave(&session->lock, flags);
+	switch (session->state) {
+	case ISCSI_SESSION_LOGGED_IN:
+		err = 0;
+		break;
+	case ISCSI_SESSION_FAILED:
+		err = DID_IMM_RETRY << 16;
+		break;
+	case ISCSI_SESSION_FREE:
+		err = DID_NO_CONNECT << 16;
+		break;
+	default:
+		err = DID_NO_CONNECT << 16;
+		break;
+	}
+	spin_unlock_irqrestore(&session->lock, flags);
+	return err;
+}
+EXPORT_SYMBOL_GPL(iscsi_session_chkready);
+
 static void iscsi_session_release(struct device *dev)
 {
 	struct iscsi_cls_session *session = iscsi_dev_to_session(dev);
@@ -259,26 +307,57 @@ static void session_recovery_timedout(struct work_struct *work)
 	struct iscsi_cls_session *session =
 		container_of(work, struct iscsi_cls_session,
 			     recovery_work.work);
+	unsigned long flags;
 
 	dev_printk(KERN_INFO, &session->dev, "iscsi: session recovery timed "
 		  "out after %d secs\n", session->recovery_tmo);
 
+	spin_lock_irqsave(&session->lock, flags);
+	switch (session->state) {
+	case ISCSI_SESSION_FAILED:
+		session->state = ISCSI_SESSION_FREE;
+		break;
+	case ISCSI_SESSION_LOGGED_IN:
+	case ISCSI_SESSION_FREE:
+		/* we raced with the unblock's flush */
+		spin_unlock_irqrestore(&session->lock, flags);
+		return;
+	}
+	spin_unlock_irqrestore(&session->lock, flags);
+
 	if (session->transport->session_recovery_timedout)
 		session->transport->session_recovery_timedout(session);
 
 	scsi_target_unblock(&session->dev);
 }
 
-void iscsi_unblock_session(struct iscsi_cls_session *session)
+void __iscsi_unblock_session(struct iscsi_cls_session *session)
 {
 	if (!cancel_delayed_work(&session->recovery_work))
 		flush_workqueue(iscsi_eh_timer_workq);
 	scsi_target_unblock(&session->dev);
 }
+
+void iscsi_unblock_session(struct iscsi_cls_session *session)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&session->lock, flags);
+	session->state = ISCSI_SESSION_LOGGED_IN;
+	spin_unlock_irqrestore(&session->lock, flags);
+
+	__iscsi_unblock_session(session);
+}
 EXPORT_SYMBOL_GPL(iscsi_unblock_session);
 
 void iscsi_block_session(struct iscsi_cls_session *session)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&session->lock, flags);
+	session->state = ISCSI_SESSION_FAILED;
+	spin_unlock_irqrestore(&session->lock, flags);
+
 	scsi_target_block(&session->dev);
 	queue_delayed_work(iscsi_eh_timer_workq, &session->recovery_work,
 			   session->recovery_tmo * HZ);
@@ -327,10 +406,12 @@ iscsi_alloc_session(struct Scsi_Host *shost,
 
 	session->transport = transport;
 	session->recovery_tmo = 120;
+	session->state = ISCSI_SESSION_FREE;
 	INIT_DELAYED_WORK(&session->recovery_work, session_recovery_timedout);
 	INIT_LIST_HEAD(&session->host_list);
 	INIT_LIST_HEAD(&session->sess_list);
 	INIT_WORK(&session->unbind_work, __iscsi_unbind_session);
+	spin_lock_init(&session->lock);
 
 	/* this is released in the dev's release function */
 	scsi_host_get(shost);
@@ -444,7 +525,10 @@ void iscsi_remove_session(struct iscsi_cls_session *session)
 	 * If we are blocked let commands flow again. The lld or iscsi
 	 * layer should set up the queuecommand to fail commands.
 	 */
-	iscsi_unblock_session(session);
+	spin_lock_irqsave(&session->lock, flags);
+	session->state = ISCSI_SESSION_FREE;
+	spin_unlock_irqrestore(&session->lock, flags);
+	__iscsi_unblock_session(session);
 	iscsi_unbind_session(session);
 	/*
 	 * If the session dropped while removing devices then we need to make
@@ -661,16 +745,23 @@ EXPORT_SYMBOL_GPL(iscsi_recv_pdu);
 
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
@@ -1246,6 +1337,15 @@ iscsi_session_attr(fast_abort, ISCSI_PARAM_FAST_ABORT, 0);
 iscsi_session_attr(abort_tmo, ISCSI_PARAM_ABORT_TMO, 0);
 iscsi_session_attr(lu_reset_tmo, ISCSI_PARAM_LU_RESET_TMO, 0);
 
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
@@ -1472,6 +1572,7 @@ iscsi_register_transport(struct iscsi_transport *tt)
 	SETUP_SESSION_RD_ATTR(abort_tmo, ISCSI_ABORT_TMO);
 	SETUP_SESSION_RD_ATTR(lu_reset_tmo,ISCSI_LU_RESET_TMO);
 	SETUP_PRIV_SESSION_RD_ATTR(recovery_tmo);
+	SETUP_PRIV_SESSION_RD_ATTR(state);
 
 	BUG_ON(count > ISCSI_SESSION_ATTRS);
 	priv->session_attrs[count] = NULL;
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 889f51f..53f5909 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -135,6 +135,14 @@ static inline void* iscsi_next_hdr(struct iscsi_cmd_task *ctask)
 	return (void*)ctask->hdr + ctask->hdr_len;
 }
 
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
@@ -227,6 +235,17 @@ struct iscsi_pool {
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
+	ISCSI_STATE_LOGGING_OUT,
+};
+
 struct iscsi_session {
 	/*
 	 * Syncs up the scsi eh thread with the iscsi eh thread when sending
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 404f11d..0e869d9 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -149,13 +149,6 @@ extern void iscsi_conn_error(struct iscsi_cls_conn *conn, enum iscsi_err error);
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
@@ -169,19 +162,21 @@ struct iscsi_cls_conn {
 #define iscsi_dev_to_conn(_dev) \
 	container_of(_dev, struct iscsi_cls_conn, dev)
 
-/* Session's states */
-#define ISCSI_STATE_FREE		1
-#define ISCSI_STATE_LOGGED_IN		2
-#define ISCSI_STATE_FAILED		3
-#define ISCSI_STATE_TERMINATE		4
-#define ISCSI_STATE_IN_RECOVERY		5
-#define ISCSI_STATE_RECOVERY_FAILED	6
-#define ISCSI_STATE_LOGGING_OUT		7
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
+	spinlock_t lock;
 
 	/* recovery fields */
 	int recovery_tmo;
@@ -190,6 +185,7 @@ struct iscsi_cls_session {
 
 	int target_id;
 
+	int state;
 	int sid;				/* session id */
 	void *dd_data;				/* LLD private data */
 	struct device dev;	/* sysfs transport/container device */
@@ -214,6 +210,7 @@ struct iscsi_host {
 /*
  * session and connection functions that can be used by HW iSCSI LLDs
  */
+extern int iscsi_session_chkready(struct iscsi_cls_session *session);
 extern struct iscsi_cls_session *iscsi_alloc_session(struct Scsi_Host *shost,
 					struct iscsi_transport *transport);
 extern int iscsi_add_session(struct iscsi_cls_session *session,
-- 
1.5.2.1

