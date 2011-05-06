From: vikas.chaudhary@qlogic.com
Subject: [RFC PATCH] iscsi tools: manage qla4xxx iscsi sessions with iscsiadm
Date: Fri,  6 May 2011 05:30:47 -0700
Message-ID: <1304685047-1867-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:36755 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1754884Ab1EFMgz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 May 2011 08:36:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Manish Rangankar <manish.rangankar@qlogic.com>

From: Manish Rangankar <manish.rangankar@qlogic.com>

This patch is based on initial work done by Mike Christie here,
http://groups.google.com/group/open-iscsi/browse_thread/thread/193fe9037f3127da#

This patch modifies iscsiadm so it can control sessions that are accessed
through qla4xxx.

To do discovery using the qla4xxx iscsi class interface first check the
available qla4xxx iface

./iscsiadm -m iface -P 0

will display the different ifaces like this:

qla4xxx.00:0e:1e:04:87:fa qla4xxx,00:0e:1e:04:87:fa,192.168.1.112,\
        <empty>,<empty>
qla4xxx.00:0e:1e:04:87:fe qla4xxx,00:0e:1e:04:87:fe,<empty>,<empty>,<empty>

Issue discovery command
./iscsiadm -m discovery -t sendtargets -I qla4xxx.00:0e:1e:04:87:fa \
                                       -p 192.168.1.10:3260
192.168.1.10:3260,1 iqn.2001-05.com.target:0-7d76ca2b7d54b541-disk2
192.168.1.10:3260,1 iqn.2001-05.com.target:0-46f6ca2b7d84b541-disk3
192.168.1.10:3260,1 iqn.2001-05.com.target:0-4c76ca2b7db4b541-disk4
192.168.1.10:3260,1 iqn.2001-05.com.target:0-7346ca2b6d04b6bb-disk1

To view discovered nodes do

./iscsiadm -m node

To login

./iscsiadm -m node -T iqn.2001-05.com.target:0-7346ca2b6d04b6bb-disk1 \
   -I qla4xxx.00:0e:1e:04:87:fa -p 192.168.1.10:3260 -l

An error or ok message is displayed to indicate login failure or success.

To see the sessions use

./iscsiadm -m session

And then to logout do

./iscsiadm -m node -T iqn.2001-05.com.target:0-7346ca2b6d04b6bb-disk1 \
    -I qla4xxx.00:0e:1e:04:87:fa -p 192.168.1.10:3260 -u

An error or a ok message is displayed to indicate logout failure or success.

Signed-off-by: Manish Rangankar <manish.rangankar@qlogic.com>
Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 include/iscsi_if.h     |    1 +
 usr/discovery.c        |    4 +
 usr/initiator.c        |  325 ++++++++++++++++++++++++++++++++++++------------
 usr/initiator.h        |   12 ++-
 usr/initiator_common.c |    4 +
 usr/io.c               |    7 +-
 usr/iscsi_ipc.h        |    3 -
 usr/iscsi_sysfs.c      |    4 +-
 usr/iscsiadm.c         |   10 --
 usr/iscsid.c           |   19 ---
 usr/mgmt_ipc.c         |    2 +-
 usr/netlink.c          |   28 +++--
 usr/session_mgmt.c     |    1 -
 usr/transport.c        |    4 +
 14 files changed, 294 insertions(+), 130 deletions(-)

diff --git a/include/iscsi_if.h b/include/iscsi_if.h
index d31c681..f38697f 100644
--- a/include/iscsi_if.h
+++ b/include/iscsi_if.h
@@ -488,6 +488,7 @@ enum iscsi_host_param {
 #define CAP_DIGEST_OFFLOAD	0x1000	/* offload hdr and data digests */
 #define CAP_PADDING_OFFLOAD	0x2000	/* offload padding insertion, removal,
 					 and verification */
+#define CAP_LOGIN_OFFLOAD      0x4000  /* offload normal session login */
 
 /*
  * These flags describes reason of stop_conn() call
diff --git a/usr/discovery.c b/usr/discovery.c
index 3c49aff..7b13500 100644
--- a/usr/discovery.c
+++ b/usr/discovery.c
@@ -1318,6 +1318,9 @@ redirect_reconnect:
 	iscsi_copy_operational_params(&session->conn[0], &config->session_conf,
 				      &config->conn_conf);
 
+	if ((session->t->caps & CAP_LOGIN_OFFLOAD))
+		goto start_conn;
+
 	status_class = 0;
 	status_detail = 0;
 	rc = ISCSI_ERR_LOGIN;
@@ -1420,6 +1423,7 @@ redirect_reconnect:
 	if (!(t->caps & CAP_TEXT_NEGO))
 		return 0;
 
+start_conn:
 	log_debug(2, "%s discovery set params\n", __FUNCTION__);
 	rc = iscsi_session_set_params(conn);
 	if (rc) {
diff --git a/usr/initiator.c b/usr/initiator.c
index 5eb05b5..412fb54 100644
--- a/usr/initiator.c
+++ b/usr/initiator.c
@@ -451,7 +451,8 @@ session_conn_shutdown(iscsi_conn_t *conn, queue_task_t *qtask,
 
 	log_debug(2, "disconnect conn");
 	/* this will check for a valid interconnect connection */
-	conn->session->t->template->ep_disconnect(conn);
+	if (session->t->template->ep_disconnect)
+		session->t->template->ep_disconnect(conn);
 
 	if (session->id == -1)
 		goto cleanup;
@@ -481,7 +482,9 @@ session_conn_shutdown(iscsi_conn_t *conn, queue_task_t *qtask,
 cleanup:
 	if (session->id != -1) {
 		log_debug(2, "kdestroy session %u", session->id);
-		if (ipc->destroy_session(session->t->handle, session->id)) {
+		session->r_stage = R_STAGE_SESSION_DESTOYED;
+		err = ipc->destroy_session(session->t->handle, session->id);
+		if (err) {
 			log_error("can not safely destroy session %d",
 				  session->id);
 			return ISCSI_ERR_INTERNAL;
@@ -806,8 +809,8 @@ __conn_error_handle(iscsi_session_t *session, iscsi_conn_t *conn)
 		if (session->r_stage == R_STAGE_SESSION_REOPEN) {
 			queue_task_t *qtask;
 
-			if (session->sync_qtask)
-				qtask = session->sync_qtask;
+			if (session->notify_qtask)
+				qtask = session->notify_qtask;
 			else
 				qtask = &session->reopen_qtask;
 			iscsi_login_eh(conn, qtask, ISCSI_ERR_TRANS);
@@ -1039,9 +1042,11 @@ setup_full_feature_phase(iscsi_conn_t *conn)
 			    session->nrec.conn[conn->id].port,
 			    session->nrec.iface.name);
 	} else {
-		session->sync_qtask = NULL;
+		session->notify_qtask = NULL;
+
+		if (!(session->t->caps & CAP_LOGIN_OFFLOAD))
+			session_online_devs(session->hostno, session->id);
 
-		session_online_devs(session->hostno, session->id);
 		mgmt_ipc_write_rsp(c->qtask, ISCSI_SUCCESS);
 		log_warning("connection%d:%d is operational after recovery "
 			    "(%d attempts)", session->id, conn->id,
@@ -1119,8 +1124,10 @@ static void iscsi_stop(void *data)
 
 	iscsi_ev_context_put(ev_context);
 
-	if (!iscsi_send_logout(conn))
-		return;
+	if (!(conn->session->t->caps & CAP_LOGIN_OFFLOAD)) {
+		if (!iscsi_send_logout(conn))
+			return;
+	}
 
 	rc = session_conn_shutdown(conn, conn->logout_qtask, ISCSI_SUCCESS);
 	if (rc)
@@ -1491,8 +1498,9 @@ static void session_conn_poll(void *data)
 			log_debug(3, "created new iSCSI session sid %d host "
 				  "no %u", session->id, session->hostno);
 
-			if (ipc->create_conn(session->t->handle,
-					session->id, conn->id, &conn->id)) {
+			err = ipc->create_conn(session->t->handle,
+					session->id, conn->id, &conn->id);
+			if (err) {
 				log_error("Can't create connection.");
 				err = ISCSI_ERR_INTERNAL;
 				goto cleanup;
@@ -1529,6 +1537,11 @@ static void session_conn_poll(void *data)
 
 		conn->exp_statsn = iscsi_sysfs_get_exp_statsn(session->id);
 
+		if (session->t->caps & CAP_LOGIN_OFFLOAD) {
+			setup_full_feature_phase(conn);
+			return;
+		}
+
 		if (iscsi_login_begin(session, c)) {
 			iscsi_login_eh(conn, qtask, ISCSI_ERR_LOGIN);
 			return;
@@ -1550,6 +1563,65 @@ cleanup:
 	session_conn_shutdown(conn, qtask, err);
 }
 
+/*
+ * LLD like qla4xxx notify the userspace that a login succeeded, the next
+ * step will be from userspace to trigger the LUN discovery.
+ */
+static void iscsi_session_created(void *data)
+{
+	struct iscsi_ev_context *ev_context = data;
+	struct iscsi_conn *conn = ev_context->conn;
+	struct iscsi_session *session = conn->session;
+	queue_task_t *qtask;
+
+	iscsi_ev_context_put(ev_context);
+
+	if (!(session->t->caps & CAP_LOGIN_OFFLOAD))
+		return;
+
+	if (conn->state != STATE_IN_LOGIN)
+		/* just a notification that the session struct was created */
+		return;
+	conn->state = STATE_LOGGED_IN;
+	/*
+	 * ok we were in_login and now we got the notification that we are
+	 * logged in
+	 */
+	log_debug(3, "session created sid %u host no %d", session->id,
+		  session->hostno);
+	qtask = session->notify_qtask;
+	session->notify_qtask = NULL;
+	session_scan_host(session, session->hostno, qtask);
+}
+
+static void iscsi_session_destroyed(void *data)
+{
+	struct iscsi_ev_context *ev_context = data;
+	struct iscsi_conn *conn = ev_context->conn;
+	struct iscsi_session *session = conn->session;
+
+	iscsi_ev_context_put(ev_context);
+
+	if (session->r_stage == R_STAGE_SESSION_DESTOYED)
+		/*
+		 * session destruction was initiated by iscsid and this is
+		 * just an async notice that the kernel destruction has
+		 * been completed. We can ignore this.
+		 */
+		return;
+
+	/*
+	 * session destruction was initiated by the kernel.
+	 * The kernel part is done and so we must clean up iscsid bits.
+	 */
+	log_debug(3, "session destroyed sid %u host no %d", session->id,
+		  session->hostno);
+
+	if (session_conn_shutdown(conn, NULL, ISCSI_SUCCESS))
+		log_error("BUG: Could not shutdown session.");
+}
+
+
 static int iscsi_sched_ev_context(struct iscsi_ev_context *ev_context,
 				  struct iscsi_conn *conn, unsigned long tmo,
 				  int event)
@@ -1561,6 +1633,17 @@ static int iscsi_sched_ev_context(struct iscsi_ev_context *ev_context,
 
 	ev_context->conn = conn;
 	switch (event) {
+	case EV_SESSION_CREATED:
+		actor_new(&ev_context->actor, iscsi_session_created,
+			  ev_context);
+		actor_schedule(&ev_context->actor);
+		break;
+	case EV_SESSION_DESTROYED:
+		actor_new(&ev_context->actor, iscsi_session_destroyed,
+			  ev_context);
+		actor_schedule(&ev_context->actor);
+		break;
+
 	case EV_CONN_RECV_PDU:
 		actor_new(&ev_context->actor, session_conn_recv_pdu,
 			  ev_context);
@@ -1635,8 +1718,136 @@ static int session_is_running(node_rec_t *rec)
 	return 0;
 }
 
+static int iscsi_sw_session_login(struct node_rec *rec, queue_task_t *qtask,
+				  struct iscsi_session *session)
+{
+	struct iscsi_conn *conn = &session->conn[0];
+
+	if (iscsi_host_set_net_params(&rec->iface, session))
+		return ISCSI_ERR_LOGIN;
+
+	conn->state = STATE_XPT_WAIT;
+	if (iscsi_conn_connect(conn, qtask))
+		return ISCSI_ERR_TRANS;
+
+	if (gettimeofday(&conn->initial_connect_time, NULL))
+		log_error("Could not get initial connect time. If "
+			  "login errors iscsid may give up the initial "
+			  "login early. You should manually login.");
+
+	qtask->rsp.command = MGMT_IPC_SESSION_LOGIN;
+	qtask->rsp.err = ISCSI_SUCCESS;
+	return ISCSI_SUCCESS;
+}
+
+static int iscsi_session_offload_login(struct node_rec *rec,
+				       queue_task_t *qtask,
+				       struct iscsi_session *session)
+{
+	struct iscsi_conn *conn = &session->conn[0];
+	int err = 0, rc = 0, sleep_count = 0;
+	uint32_t host_no, host_no_ret;
+	struct iscsi_transport *t = session->t;
+
+	host_no = iscsi_sysfs_get_host_no_from_hwinfo(&rec->iface, &err);
+	if (rc) {
+		log_error("Could not get host no for iface %s.\n",
+			rec->iface.name);
+		return ISCSI_ERR_LOGIN;
+	}
+
+	log_debug(2, "match iface %s to hostno %u\n", rec->iface.name, host_no);
+
+	rc = t->template->ep_connect(conn, 1);
+	if (rc < 0) {
+		rc = ENOTCONN;
+		return ISCSI_ERR_LOGIN;
+	}
+
+	do {
+		rc = t->template->ep_poll(conn, 1);
+		if (rc < 0) {
+			rc = ENOTCONN;
+			return ISCSI_ERR_LOGIN;
+		} else if (rc == 0) {
+			if (sleep_count == conn->login_timeout) {
+				rc = ETIMEDOUT;
+				return ISCSI_ERR_LOGIN;
+			}
+			sleep_count++;
+			sleep(1);
+		} else
+			break;
+	} while (1);
+
+	conn->state = STATE_XPT_WAIT;
+	err = ipc->create_session(session->t->handle, conn->transport_ep_handle,
+			0, session->nrec.session.cmds_max,
+			session->nrec.session.queue_depth,
+			&session->id, &host_no_ret);
+	if (err) {
+		log_error("Could not create hw session (err %d).\n", err);
+		return ISCSI_ERR_LOGIN;
+	}
+
+	if (host_no_ret != host_no)
+		log_error("Host no mismatch got %u. Expected %u.\n",
+				host_no_ret, host_no);
+	session->hostno = host_no_ret;
+
+	err = ipc->create_conn(session->t->handle, session->id, conn->id,
+			&conn->id);
+	if (err) {
+		log_error("Can't create connection (%d)", err);
+		err = ISCSI_ERR_INTERNAL;
+		goto destroy_kern_session;
+	}
+	log_debug(3, "created new iSCSI connection "
+		"%d:%d", session->id, conn->id);
+
+	iscsi_copy_operational_params(conn,
+			&session->nrec.session.iscsi,
+			&session->nrec.conn[conn->id].iscsi);
+
+	iscsi_session_set_params(conn);
+	iscsi_host_set_params(session);
+	iscsi_host_set_net_params(&rec->iface, session);
+
+	if (ipc->bind_conn(session->t->handle, session->id, conn->id,
+	    conn->transport_ep_handle, (conn->id == 0), &rc) ||
+	    rc) {
+		log_error("Could not bind conn %d:%d to session %d, "
+			"(err %d)", session->id, conn->id,
+			session->id, rc);
+		goto destroy_kern_conn;
+	}
+
+	conn->state = STATE_IN_LOGIN;
+	err = ipc->start_conn(session->t->handle, session->id, conn->id, &rc);
+	if (err || rc) {
+		log_error("can't start connection %d:%d retcode %d.",
+			session->id, conn->id, rc);
+		err = ISCSI_ERR_INTERNAL;
+		goto destroy_kern_conn;
+	}
+
+	session->notify_qtask = qtask;
+	qtask->rsp.command = MGMT_IPC_SESSION_LOGIN;
+	qtask->rsp.err = ISCSI_SUCCESS;
+	return ISCSI_SUCCESS;
+
+destroy_kern_conn:
+	if (ipc->destroy_conn(session->t->handle, session->id, conn->id))
+		log_error("can not safely destroy connection %d", conn->id);
+destroy_kern_session:
+	if (ipc->destroy_session(session->t->handle, session->id))
+		log_error("can not safely destroy session %d",
+			session->id);
+	return err;
+}
+
 int
-session_login_task(node_rec_t *rec, queue_task_t *qtask)
+iscsi_session_login_task(node_rec_t *rec, queue_task_t *qtask)
 {
 	iscsi_session_t *session;
 	iscsi_conn_t *conn;
@@ -1661,12 +1872,12 @@ session_login_task(node_rec_t *rec, queue_task_t *qtask)
 	}
 
 	if (!(t->caps & CAP_MULTI_R2T) &&
-	    rec->session.iscsi.MaxOutstandingR2T) {
+	    rec->session.iscsi.MaxOutstandingR2T > 1) {
 		log_error("Transport '%s' does not support "
 			  "MaxOutstandingR2T %d. Setting "
 			  "MaxOutstandingR2T to 1.", t->name,
 			  rec->session.iscsi.MaxOutstandingR2T);
-		rec->session.iscsi.MaxOutstandingR2T = 1;		
+		rec->session.iscsi.MaxOutstandingR2T = 1;
 	}
 
 	if (!(t->caps & CAP_HDRDGST) &&
@@ -1708,34 +1919,20 @@ session_login_task(node_rec_t *rec, queue_task_t *qtask)
 	/* create leading connection */
 	rc = __session_conn_create(session, 0);
 	if (rc) {
-		__session_destroy(session);
-		return rc;
-	}
-	conn = &session->conn[0];
-	qtask->conn = conn;
-
-	if (iscsi_host_set_net_params(&rec->iface, session)) {
-		__session_destroy(session);
-		return ISCSI_ERR_LOGIN;
+		goto destroy_session;
 	}
 
-	if (gettimeofday(&conn->initial_connect_time, NULL))
-		log_error("Could not get initial connect time. If "
-			  "login errors iscsid may give up the initial "
-			  "login early. You should manually login.");
-
-	conn->state = STATE_XPT_WAIT;
-	qtask->rsp.command = MGMT_IPC_SESSION_LOGIN;
-	qtask->rsp.err = ISCSI_SUCCESS;
-
-	if (iscsi_conn_connect(conn, qtask)) {
-		log_debug(4, "Initial connect failed. Waiting %u seconds "
-			  "before trying to reconnect.\n",
-			  ISCSI_CONN_ERR_REOPEN_DELAY);
-		queue_delayed_reopen(qtask, ISCSI_CONN_ERR_REOPEN_DELAY);
-	}
+	qtask->conn = &session->conn[0];
+	if (t->caps & CAP_LOGIN_OFFLOAD)
+		rc = iscsi_session_offload_login(rec, qtask, session);
+	else
+		rc = iscsi_sw_session_login(rec, qtask, session);
+	if (rc == ISCSI_SUCCESS)
+		return ISCSI_SUCCESS;
 
-	return ISCSI_SUCCESS;
+destroy_session:
+	__session_destroy(session);
+	return rc;
 }
 
 static int
@@ -1782,11 +1979,13 @@ iscsi_sync_session(node_rec_t *rec, queue_task_t *qtask, uint32_t sid)
 	if (err)
 		goto destroy_session;
 
-	session->sync_qtask = qtask;
 	qtask->rsp.command = MGMT_IPC_SESSION_SYNC;
 
-	session_conn_reopen(&session->conn[0], qtask, STOP_CONN_RECOVER);
 	log_debug(3, "Started sync iSCSI session %d", session->id);
+	session->notify_qtask = qtask;
+	session_conn_reopen(&session->conn[0], qtask,
+			STOP_CONN_RECOVER);
+
 	return 0;
 
 destroy_session:
@@ -1806,8 +2005,7 @@ static int session_unbind(struct iscsi_session *session)
 	return err;
 }
 
-int
-session_logout_task(int sid, queue_task_t *qtask)
+int session_logout_task(int sid, queue_task_t *qtask)
 {
 	iscsi_session_t *session;
 	iscsi_conn_t *conn;
@@ -1823,7 +2021,7 @@ session_logout_task(int sid, queue_task_t *qtask)
 	 * If syncing up or if this is the initial login and mgmt_ipc
 	 * has not been notified of that result fail the logout request
 	 */
-	if (session->sync_qtask ||
+	if (session->notify_qtask ||
 	    ((conn->state == STATE_XPT_WAIT ||
 	      conn->state == STATE_IN_LOGIN) &&
 	    (session->r_stage == R_STAGE_NO_CHANGE ||
@@ -1836,7 +2034,6 @@ invalid_state:
 
 	/* FIXME: logout all active connections */
 	conn = &session->conn[0];
-	/* FIXME: implement Logout Request */
 	if (conn->logout_qtask)
 		goto invalid_state;
 
@@ -1849,9 +2046,13 @@ invalid_state:
 		if (!session_unbind(session))
 			return ISCSI_SUCCESS;
 
-		/* unbind is not supported so just do old logout */
-		if (!iscsi_send_logout(conn))
-			return ISCSI_SUCCESS;
+		/* LLDs that offload login also offload logout */
+		if (!(session->t->caps & CAP_LOGIN_OFFLOAD)) {
+			/* unbind is not supported so just do old logout */
+			if (!iscsi_send_logout(conn))
+				return ISCSI_SUCCESS;
+		}
+
 		log_error("Could not send logout pdu. Dropping session\n");
 		/* fallthrough */
 	default:
@@ -1882,37 +2083,7 @@ iscsi_host_send_targets(queue_task_t *qtask, int host_no, int do_login,
 	return ISCSI_SUCCESS;
 }
 
-/*
- * HW drivers like qla4xxx present a interface that hides most of the iscsi
- * details. Userspace sends down a discovery event then it gets notified
- * if the sessions that were logged in as a result asynchronously, or
- * the card will have sessions preset in the FLASH and will log into them
- * automaotically then send us notification that a session is setup.
- */
-static void iscsi_async_session_creation(uint32_t host_no, uint32_t sid)
-{
-	struct iscsi_transport *transport;
-
-	transport = iscsi_sysfs_get_transport_by_hba(host_no);
-	if (!transport)
-		return;
-
-	if (!(transport->caps & CAP_FW_DB))
-		return;
-
-	log_debug(3, "session created sid %u host no %d", sid, host_no);
-	session_online_devs(host_no, sid);
-	session_scan_host(NULL, host_no, NULL);
-}
-
-static void iscsi_async_session_destruction(uint32_t host_no, uint32_t sid)
-{
-	log_debug(3, "session destroyed sid %u host no %d", sid, host_no);
-}
-
 static struct iscsi_ipc_ev_clbk ipc_clbk = {
-	.create_session		= iscsi_async_session_creation,
-	.destroy_session	= iscsi_async_session_destruction,
 	.get_ev_context		= iscsi_ev_context_get,
 	.put_ev_context		= iscsi_ev_context_put,
 	.sched_ev_context	= iscsi_sched_ev_context,
diff --git a/usr/initiator.h b/usr/initiator.h
index 93e9b3b..39715c3 100644
--- a/usr/initiator.h
+++ b/usr/initiator.h
@@ -58,6 +58,7 @@ typedef enum iscsi_session_r_stage_e {
 	R_STAGE_SESSION_CLEANUP,
 	R_STAGE_SESSION_REOPEN,
 	R_STAGE_SESSION_REDIRECT,
+	R_STAGE_SESSION_DESTOYED,
 } iscsi_session_r_stage_e;
 
 typedef enum conn_login_status_e {
@@ -89,6 +90,8 @@ typedef enum iscsi_event_e {
 	EV_CONN_ERROR,
 	EV_CONN_LOGOUT_TIMER,
 	EV_CONN_STOP,
+	EV_SESSION_CREATED,
+	EV_SESSION_DESTROYED,
 } iscsi_event_e;
 
 struct queue_task;
@@ -262,8 +265,11 @@ typedef struct iscsi_session {
 	int lu_reset_timeout;
 	int abort_timeout;
 
-	/* sync up fields */
-	queue_task_t *sync_qtask;
+	/*
+	 * used for hw and sync up to notify caller that the operation
+	 * is complete
+	 */
+	queue_task_t *notify_qtask;
 } iscsi_session_t;
 
 /* login.c */
@@ -334,7 +340,7 @@ extern int iscsi_io_recv_pdu(iscsi_conn_t *conn, struct iscsi_hdr *hdr,
 	int timeout);
 
 /* initiator.c */
-extern int session_login_task(node_rec_t *rec, queue_task_t *qtask);
+extern int iscsi_session_login_task(node_rec_t *rec, queue_task_t *qtask);
 extern int session_logout_task(int sid, queue_task_t *qtask);
 extern iscsi_session_t *session_find_by_sid(uint32_t sid);
 extern int iscsi_sync_session(node_rec_t *rec, queue_task_t
diff --git a/usr/initiator_common.c b/usr/initiator_common.c
index 8e4e519..201819c 100644
--- a/usr/initiator_common.c
+++ b/usr/initiator_common.c
@@ -509,6 +509,10 @@ int iscsi_session_set_params(struct iscsi_conn *conn)
 		session->param_mask &= ~ISCSI_IFMARKER_EN;
 		session->param_mask &= ~ISCSI_OFMARKER_EN;
 	}
+	if (t->caps & CAP_LOGIN_OFFLOAD) {
+		session->param_mask &= ~ISCSI_PING_TMO;
+		session->param_mask &= ~ISCSI_RECV_TMO;
+	}
 
 	/* Entered full-feature phase! */
 	for (i = 0; i < MAX_SESSION_PARAMS; i++) {
diff --git a/usr/io.c b/usr/io.c
index aa81941..0b05445 100644
--- a/usr/io.c
+++ b/usr/io.c
@@ -361,7 +361,12 @@ iscsi_io_tcp_connect(iscsi_conn_t *conn, int non_blocking)
 		return -1;
 	}
 
-	if (conn->session) {
+	/*
+	 * No need to bind for discovery sessions. If using offload
+	 * we actually do not want to try and bind.
+	 */
+	if (conn->session &&
+			conn->session->type != ISCSI_SESSION_TYPE_DISCOVERY) {
 		if (bind_conn_to_iface(conn, &conn->session->nrec.iface))
 			return -1;
 	}
diff --git a/usr/iscsi_ipc.h b/usr/iscsi_ipc.h
index 695ee63..0d9e5fd 100644
--- a/usr/iscsi_ipc.h
+++ b/usr/iscsi_ipc.h
@@ -42,9 +42,6 @@ struct iscsi_ev_context;
  * code to call into the initiator to shedule handling.
  */
 struct iscsi_ipc_ev_clbk {
-	void (*create_session) (uint32_t host_no, uint32_t sid);
-	void (*destroy_session) (uint32_t host_no, uint32_t sid);
-
 	struct iscsi_ev_context *(*get_ev_context) (struct iscsi_conn *conn,
 						    int ev_size);
 	void (*put_ev_context) (struct iscsi_ev_context *ev_context);
diff --git a/usr/iscsi_sysfs.c b/usr/iscsi_sysfs.c
index e82fe80..dd526db 100644
--- a/usr/iscsi_sysfs.c
+++ b/usr/iscsi_sysfs.c
@@ -148,7 +148,6 @@ static int read_transports(void)
 		 */
 		if (!strcmp(t->name, "qla4xxx")) {
 			t->caps |= CAP_DATA_PATH_OFFLOAD;
-			t->caps |= CAP_FW_DB;
 		}
 
 		if (list_empty(&t->list))
@@ -1111,7 +1110,8 @@ void iscsi_sysfs_set_queue_depth(void *data, int hostno, int target, int lun)
 	err = sysfs_set_param(id, SCSI_SUBSYS, "queue_depth", write_buf,
 			      strlen(write_buf));
 	if (err && err != EINVAL)
-		log_error("Could not queue depth for LUN %d err %d.", lun, err);
+		log_error("Could not queue depth for LUN %d err %d.",
+			  lun, err);
 }
 
 void iscsi_sysfs_set_device_online(void *data, int hostno, int target, int lun)
diff --git a/usr/iscsiadm.c b/usr/iscsiadm.c
index a4b75af..f776de9 100644
--- a/usr/iscsiadm.c
+++ b/usr/iscsiadm.c
@@ -467,15 +467,6 @@ static int iscsi_logout_matched_portal(void *data, struct list_head *list,
 	if (!iscsi_match_session(pattern_rec, info))
 		return -1;
 
-	/* we do not support this yet */
-	if (t->caps & CAP_FW_DB) {
-		log_error("Could not logout session of [sid: %d, "
-			  "target: %s, portal: %s,%d].", info->sid,
-			  info->targetname, info->persistent_address,
-			  info->port);
-		log_error("Logout not supported for driver: %s.", t->name);
-		return -1;
-	}
 	return iscsi_logout_portal(info, list);
 }
 
@@ -1002,7 +993,6 @@ do_sendtargets(discovery_rec_t *drec, struct list_head *ifaces,
 			free(iface);
 			continue;
 		}
-
 		host_no = iscsi_sysfs_get_host_no_from_hwinfo(iface, &rc);
 		if (rc || host_no == -1) {
 			log_debug(1, "Could not match iface" iface_fmt " to "
diff --git a/usr/iscsid.c b/usr/iscsid.c
index 67a6944..fb60c7d 100644
--- a/usr/iscsid.c
+++ b/usr/iscsid.c
@@ -200,25 +200,6 @@ static int sync_session(void *data, struct session_info *info)
 	if (!t)
 		return 0;
 
-	/*
-	 * Just rescan the device in case this is the first startup.
-	 * (TODO: should do this async and check for state).
-	 */
-	if (t->caps & CAP_FW_DB) {
-		uint32_t host_no;
-		int err;
-
-		host_no = iscsi_sysfs_get_host_no_from_sid(info->sid, &err);
-		if (err) {
-			log_error("Could not get host no from sid %u. Can not "
-				  "sync session: %s", info->sid,
-				  iscsi_err_to_str(err));
-			return 0;
-		}
-		iscsi_sysfs_scan_host(host_no, 0);
-		return 0;
-	}
-
 	memset(&rec, 0, sizeof(node_rec_t));
 	/*
 	 * We might get the local ip address for software. We do not
diff --git a/usr/mgmt_ipc.c b/usr/mgmt_ipc.c
index 3e4d2ef..055e5e4 100644
--- a/usr/mgmt_ipc.c
+++ b/usr/mgmt_ipc.c
@@ -83,7 +83,7 @@ mgmt_ipc_close(int fd)
 static int 
 mgmt_ipc_session_login(queue_task_t *qtask)
 {
-	return session_login_task(&qtask->req.u.session.rec, qtask);
+	return iscsi_session_login_task(&qtask->req.u.session.rec, qtask);
 }
 
 static int
diff --git a/usr/netlink.c b/usr/netlink.c
index 1d2a0fd..b218da0 100644
--- a/usr/netlink.c
+++ b/usr/netlink.c
@@ -1044,7 +1044,7 @@ static int ctldev_handle(void)
 	char nlm_ev[NLMSG_SPACE(sizeof(struct iscsi_uevent))];
 	struct nlmsghdr *nlh;
 	struct iscsi_ev_context *ev_context;
-	uint32_t sid = 0, cid = 0;
+	uint32_t sid = 0, cid = 0, host_no = -1;
 
 	log_debug(7, "in %s", __FUNCTION__);
 
@@ -1060,19 +1060,13 @@ static int ctldev_handle(void)
 	/* drivers like qla4xxx can be inserted after iscsid is started */
 	switch (ev->type) {
 	case ISCSI_KEVENT_CREATE_SESSION:
-	/* old kernels sent ISCSI_UEVENT_CREATE_SESSION on creation */
-	case ISCSI_UEVENT_CREATE_SESSION:
-		drop_data(nlh);
-		if (ipc_ev_clbk->create_session)
-			ipc_ev_clbk->create_session(ev->r.c_session_ret.host_no,
-						    ev->r.c_session_ret.sid);
-		return 0;
+		sid = ev->r.c_session_ret.sid;
+		host_no = ev->r.c_session_ret.host_no;
+		break;
 	case ISCSI_KEVENT_DESTROY_SESSION:
-		drop_data(nlh);
-		if (ipc_ev_clbk->destroy_session)
-			ipc_ev_clbk->destroy_session(ev->r.d_session.host_no,
-						     ev->r.d_session.sid);
-		return 0;
+		sid = ev->r.d_session.sid;
+		host_no = ev->r.d_session.host_no;
+		break;
 	case ISCSI_KEVENT_RECV_PDU:
 		sid = ev->r.recv_req.sid;
 		cid = ev->r.recv_req.cid;
@@ -1142,6 +1136,14 @@ static int ctldev_handle(void)
 	 * into ctldev_handle
 	 */
 	switch (ev->type) {
+	case ISCSI_KEVENT_CREATE_SESSION:
+		rc = ipc_ev_clbk->sched_ev_context(ev_context, conn, 0,
+						   EV_SESSION_CREATED);
+		break;
+	case ISCSI_KEVENT_DESTROY_SESSION:
+		rc = ipc_ev_clbk->sched_ev_context(ev_context, conn, 0,
+				EV_SESSION_DESTROYED);
+		break;
 	case ISCSI_KEVENT_RECV_PDU:
 		rc = ipc_ev_clbk->sched_ev_context(ev_context, conn, 0,
 						   EV_CONN_RECV_PDU);
diff --git a/usr/session_mgmt.c b/usr/session_mgmt.c
index 0bfa205..fe90f25 100644
--- a/usr/session_mgmt.c
+++ b/usr/session_mgmt.c
@@ -151,7 +151,6 @@ int iscsi_login_portal_nowait(struct node_rec *rec)
 	int err;
 
 	INIT_LIST_HEAD(&list);
-
 	err = iscsi_login_portal(NULL, &list, rec);
 	if (err > 0)
 		return err;
diff --git a/usr/transport.c b/usr/transport.c
index 7a0cde1..5d6bea4 100644
--- a/usr/transport.c
+++ b/usr/transport.c
@@ -79,6 +79,10 @@ struct iscsi_transport_template be2iscsi = {
 
 struct iscsi_transport_template qla4xxx = {
 	.name		= "qla4xxx",
+	.set_host_ip	= 0,
+	.ep_connect	= ktransport_ep_connect,
+	.ep_poll	= ktransport_ep_poll,
+	.ep_disconnect	= ktransport_ep_disconnect,
 };
 
 static struct iscsi_transport_template *iscsi_transport_templates[] = {
-- 
1.7.3.2

