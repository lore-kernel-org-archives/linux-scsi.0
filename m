From: michaelc@cs.wisc.edu
Subject: [PATCH 11/24] libiscsi: fix nop handling
Date: Thu, 13 Dec 2007 12:43:30 -0600
Message-ID: <11975714382641-git-send-email-michaelc@cs.wisc.edu>
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
 <11975714372848-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758865AbXLMSoF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Dec 2007 13:44:05 -0500
In-Reply-To: <11975714372848-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

During root boot and shutdown the target could send us nops.
At this time iscsid cannot be running, so the target will drop
the session and the boot or shutdown will hang.

To handle this and allow us to better control when to check the network
this patch moves the nop handling to the kernel.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    4 +-
 drivers/scsi/iscsi_tcp.c                 |    4 +-
 drivers/scsi/libiscsi.c                  |  331 ++++++++++++++++++++++++------
 drivers/scsi/scsi_transport_iscsi.c      |    4 +
 include/scsi/iscsi_if.h                  |   11 +
 include/scsi/libiscsi.h                  |    8 +
 6 files changed, 294 insertions(+), 68 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index a2622f4..2656064 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -577,7 +577,9 @@ static struct iscsi_transport iscsi_iser_transport = {
 				  ISCSI_PERSISTENT_ADDRESS |
 				  ISCSI_TARGET_NAME | ISCSI_TPGT |
 				  ISCSI_USERNAME | ISCSI_PASSWORD |
-				  ISCSI_USERNAME_IN | ISCSI_PASSWORD_IN,
+				  ISCSI_USERNAME_IN | ISCSI_PASSWORD_IN |
+				  ISCSI_FAST_ABORT | ISCSI_ABORT_TMO |
+				  ISCSI_PING_TMO | ISCSI_RECV_TMO,
 	.host_param_mask	= ISCSI_HOST_HWADDRESS |
 				  ISCSI_HOST_NETDEV_NAME |
 				  ISCSI_HOST_INITIATOR_NAME,
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 90eae8e..9b41852 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -2246,7 +2246,9 @@ static struct iscsi_transport iscsi_tcp_transport = {
 				  ISCSI_TARGET_NAME | ISCSI_TPGT |
 				  ISCSI_USERNAME | ISCSI_PASSWORD |
 				  ISCSI_USERNAME_IN | ISCSI_PASSWORD_IN |
-				  ISCSI_FAST_ABORT,
+				  ISCSI_FAST_ABORT | ISCSI_ABORT_TMO |
+				  ISCSI_LU_RESET_TMO |
+				  ISCSI_PING_TMO | ISCSI_RECV_TMO,
 	.host_param_mask	= ISCSI_HOST_HWADDRESS | ISCSI_HOST_IPADDRESS |
 				  ISCSI_HOST_INITIATOR_NAME |
 				  ISCSI_HOST_NETDEV_NAME,
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 5205ef2..9688361 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -313,11 +313,70 @@ void iscsi_free_mgmt_task(struct iscsi_conn *conn,
 	list_del_init(&mtask->running);
 	if (conn->login_mtask == mtask)
 		return;
+
+	if (conn->ping_mtask == mtask)
+		conn->ping_mtask = NULL;
 	__kfifo_put(conn->session->mgmtpool.queue,
 		    (void*)&mtask, sizeof(void*));
 }
 EXPORT_SYMBOL_GPL(iscsi_free_mgmt_task);
 
+static struct iscsi_mgmt_task *
+__iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
+		      char *data, uint32_t data_size)
+{
+	struct iscsi_session *session = conn->session;
+	struct iscsi_mgmt_task *mtask;
+
+	if (session->state == ISCSI_STATE_TERMINATE)
+		return NULL;
+
+	if (hdr->opcode == (ISCSI_OP_LOGIN | ISCSI_OP_IMMEDIATE) ||
+	    hdr->opcode == (ISCSI_OP_TEXT | ISCSI_OP_IMMEDIATE))
+		/*
+		 * Login and Text are sent serially, in
+		 * request-followed-by-response sequence.
+		 * Same mtask can be used. Same ITT must be used.
+		 * Note that login_mtask is preallocated at conn_create().
+		 */
+		mtask = conn->login_mtask;
+	else {
+		BUG_ON(conn->c_stage == ISCSI_CONN_INITIAL_STAGE);
+		BUG_ON(conn->c_stage == ISCSI_CONN_STOPPED);
+
+		if (!__kfifo_get(session->mgmtpool.queue,
+				 (void*)&mtask, sizeof(void*)))
+			return NULL;
+	}
+
+	if (data_size) {
+		memcpy(mtask->data, data, data_size);
+		mtask->data_count = data_size;
+	} else
+		mtask->data_count = 0;
+
+	memcpy(mtask->hdr, hdr, sizeof(struct iscsi_hdr));
+	INIT_LIST_HEAD(&mtask->running);
+	list_add_tail(&mtask->running, &conn->mgmtqueue);
+	return mtask;
+}
+
+int iscsi_conn_send_pdu(struct iscsi_cls_conn *cls_conn, struct iscsi_hdr *hdr,
+			char *data, uint32_t data_size)
+{
+	struct iscsi_conn *conn = cls_conn->dd_data;
+	struct iscsi_session *session = conn->session;
+	int err = 0;
+
+	spin_lock_bh(&session->lock);
+	if (!__iscsi_conn_send_pdu(conn, hdr, data, data_size))
+		err = -EPERM;
+	spin_unlock_bh(&session->lock);
+	scsi_queue_work(session->host, &conn->xmitwork);
+	return err;
+}
+EXPORT_SYMBOL_GPL(iscsi_conn_send_pdu);
+
 /**
  * iscsi_cmd_rsp - SCSI Command Response processing
  * @conn: iscsi connection
@@ -409,6 +468,39 @@ static void iscsi_tmf_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 	wake_up(&conn->ehwait);
 }
 
+static void iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
+{
+        struct iscsi_nopout hdr;
+	struct iscsi_mgmt_task *mtask;
+
+	if (!rhdr && conn->ping_mtask)
+		return;
+
+	memset(&hdr, 0, sizeof(struct iscsi_nopout));
+	hdr.opcode = ISCSI_OP_NOOP_OUT | ISCSI_OP_IMMEDIATE;
+	hdr.flags = ISCSI_FLAG_CMD_FINAL;
+
+	if (rhdr) {
+		memcpy(hdr.lun, rhdr->lun, 8);
+		hdr.ttt = rhdr->ttt;
+		hdr.itt = RESERVED_ITT;
+	} else
+		hdr.ttt = RESERVED_ITT;
+
+	mtask = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)&hdr, NULL, 0);
+	if (!mtask) {
+		printk(KERN_ERR "Could not send nopout\n");
+		return;
+	}
+
+	/* only track our nops */
+	if (!rhdr) {
+		conn->ping_mtask = mtask;
+		conn->last_ping = jiffies;
+	}
+	scsi_queue_work(conn->session->host, &conn->xmitwork);
+}
+
 static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			       char *data, int datalen)
 {
@@ -453,6 +545,7 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	struct iscsi_mgmt_task *mtask;
 	uint32_t itt;
 
+	conn->last_recv = jiffies;
 	if (hdr->itt != RESERVED_ITT)
 		itt = get_itt(hdr->itt);
 	else
@@ -520,14 +613,22 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			iscsi_free_mgmt_task(conn, mtask);
 			break;
 		case ISCSI_OP_NOOP_IN:
-			if (hdr->ttt != cpu_to_be32(ISCSI_RESERVED_TAG) || datalen) {
+			if (hdr->ttt != cpu_to_be32(ISCSI_RESERVED_TAG) ||
+			    datalen) {
 				rc = ISCSI_ERR_PROTO;
 				break;
 			}
 			conn->exp_statsn = be32_to_cpu(hdr->statsn) + 1;
 
-			if (iscsi_recv_pdu(conn->cls_conn, hdr, data, datalen))
-				rc = ISCSI_ERR_CONN_FAILED;
+			if (conn->ping_mtask != mtask) {
+				/*
+				 * If this is not in response to one of our
+				 * nops then it must be from userspace.
+				 */
+				if (iscsi_recv_pdu(conn->cls_conn, hdr, data,
+						   datalen))
+					rc = ISCSI_ERR_CONN_FAILED;
+			}
 			iscsi_free_mgmt_task(conn, mtask);
 			break;
 		default:
@@ -547,8 +648,7 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			if (hdr->ttt == cpu_to_be32(ISCSI_RESERVED_TAG))
 				break;
 
-			if (iscsi_recv_pdu(conn->cls_conn, hdr, NULL, 0))
-				rc = ISCSI_ERR_CONN_FAILED;
+			iscsi_send_nopout(conn, (struct iscsi_nopin*)hdr);
 			break;
 		case ISCSI_OP_REJECT:
 			rc = iscsi_handle_reject(conn, hdr, data, datalen);
@@ -1003,62 +1103,6 @@ int iscsi_change_queue_depth(struct scsi_device *sdev, int depth)
 }
 EXPORT_SYMBOL_GPL(iscsi_change_queue_depth);
 
-static struct iscsi_mgmt_task *
-__iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
-		      char *data, uint32_t data_size)
-{
-	struct iscsi_session *session = conn->session;
-	struct iscsi_mgmt_task *mtask;
-
-	if (session->state == ISCSI_STATE_TERMINATE)
-		return NULL;
-
-	if (hdr->opcode == (ISCSI_OP_LOGIN | ISCSI_OP_IMMEDIATE) ||
-	    hdr->opcode == (ISCSI_OP_TEXT | ISCSI_OP_IMMEDIATE))
-		/*
-		 * Login and Text are sent serially, in
-		 * request-followed-by-response sequence.
-		 * Same mtask can be used. Same ITT must be used.
-		 * Note that login_mtask is preallocated at conn_create().
-		 */
-		mtask = conn->login_mtask;
-	else {
-		BUG_ON(conn->c_stage == ISCSI_CONN_INITIAL_STAGE);
-		BUG_ON(conn->c_stage == ISCSI_CONN_STOPPED);
-
-		if (!__kfifo_get(session->mgmtpool.queue,
-				 (void*)&mtask, sizeof(void*)))
-			return NULL;
-	}
-
-	if (data_size) {
-		memcpy(mtask->data, data, data_size);
-		mtask->data_count = data_size;
-	} else
-		mtask->data_count = 0;
-
-	memcpy(mtask->hdr, hdr, sizeof(struct iscsi_hdr));
-	INIT_LIST_HEAD(&mtask->running);
-	list_add_tail(&mtask->running, &conn->mgmtqueue);
-	return mtask;
-}
-
-int iscsi_conn_send_pdu(struct iscsi_cls_conn *cls_conn, struct iscsi_hdr *hdr,
-			char *data, uint32_t data_size)
-{
-	struct iscsi_conn *conn = cls_conn->dd_data;
-	struct iscsi_session *session = conn->session;
-	int err = 0;
-
-	spin_lock_bh(&session->lock);
-	if (!__iscsi_conn_send_pdu(conn, hdr, data, data_size))
-		err = -EPERM;
-	spin_unlock_bh(&session->lock);
-	scsi_queue_work(session->host, &conn->xmitwork);
-	return err;
-}
-EXPORT_SYMBOL_GPL(iscsi_conn_send_pdu);
-
 void iscsi_session_recovery_timedout(struct iscsi_cls_session *cls_session)
 {
 	struct iscsi_session *session = class_to_transport_session(cls_session);
@@ -1134,7 +1178,8 @@ static void iscsi_tmf_timedout(unsigned long data)
 }
 
 static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
-				   struct iscsi_tm *hdr, int age)
+				   struct iscsi_tm *hdr, int age,
+				   int timeout)
 {
 	struct iscsi_session *session = conn->session;
 	struct iscsi_mgmt_task *mtask;
@@ -1149,7 +1194,7 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
 		return -EPERM;
 	}
 	conn->tmfcmd_pdus_cnt++;
-	conn->tmf_timer.expires = 30 * HZ + jiffies;
+	conn->tmf_timer.expires = timeout * HZ + jiffies;
 	conn->tmf_timer.function = iscsi_tmf_timedout;
 	conn->tmf_timer.data = (unsigned long)conn;
 	add_timer(&conn->tmf_timer);
@@ -1233,6 +1278,106 @@ static void iscsi_start_tx(struct iscsi_conn *conn)
 	scsi_queue_work(conn->session->host, &conn->xmitwork);
 }
 
+static enum scsi_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *scmd)
+{
+	struct iscsi_cls_session *cls_session;
+	struct iscsi_session *session;
+	struct iscsi_conn *conn;
+	enum scsi_eh_timer_return rc = EH_NOT_HANDLED;
+
+	cls_session = starget_to_session(scsi_target(scmd->device));
+	session = class_to_transport_session(cls_session);
+
+	debug_scsi("scsi cmd %p timedout\n", scmd);
+
+	spin_lock(&session->lock);
+	if (session->state != ISCSI_STATE_LOGGED_IN) {
+		/*
+		 * We are probably in the middle of iscsi recovery so let
+		 * that complete and handle the error.
+		 */
+		rc = EH_RESET_TIMER;
+		goto done;
+	}
+
+	conn = session->leadconn;
+	if (!conn) {
+		/* In the middle of shuting down */
+		rc = EH_RESET_TIMER;
+		goto done;
+	}
+
+	if (!conn->recv_timeout && !conn->ping_timeout)
+		goto done;
+	/*
+	 * if the ping timedout then we are in the middle of cleaning up
+	 * and can let the iscsi eh handle it
+	 */
+	if (time_before_eq(conn->last_recv + (conn->recv_timeout * HZ) +
+			    (conn->ping_timeout * HZ), jiffies))
+		rc = EH_RESET_TIMER;
+	/*
+	 * if we are about to check the transport then give the command
+	 * more time
+	 */
+	if (time_before_eq(conn->last_recv + (conn->recv_timeout * HZ),
+			   jiffies))
+		rc = EH_RESET_TIMER;
+	/* if in the middle of checking the transport then give us more time */
+	if (conn->ping_mtask)
+		rc = EH_RESET_TIMER;
+done:
+	spin_unlock(&session->lock);
+	debug_scsi("return %s\n", rc == EH_RESET_TIMER ? "timer reset" : "nh");
+	return rc;
+}
+
+static void iscsi_check_transport_timeouts(unsigned long data)
+{
+	struct iscsi_conn *conn = (struct iscsi_conn *)data;
+	struct iscsi_session *session = conn->session;
+	unsigned long timeout, next_timeout = 0, last_recv;
+
+	spin_lock(&session->lock);
+	if (session->state != ISCSI_STATE_LOGGED_IN)
+		goto done;
+
+	timeout = conn->recv_timeout;
+	if (!timeout)
+		goto done;
+
+	timeout *= HZ;
+	last_recv = conn->last_recv;
+	if (time_before_eq(last_recv + timeout + (conn->ping_timeout * HZ),
+			   jiffies)) {
+		printk(KERN_ERR "ping timeout of %d secs expired, "
+		       "last rx %lu, last ping %lu, now %lu\n",
+		       conn->ping_timeout, last_recv,
+		       conn->last_ping, jiffies);
+		spin_unlock(&session->lock);
+		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
+		return;
+	}
+
+	if (time_before_eq(last_recv + timeout, jiffies)) {
+		if (time_before_eq(conn->last_ping, last_recv)) {
+			/* send a ping to try to provoke some traffic */
+			debug_scsi("Sending nopout as ping on conn %p\n", conn);
+			iscsi_send_nopout(conn, NULL);
+		}
+		next_timeout = last_recv + timeout + (conn->ping_timeout * HZ);
+	} else {
+		next_timeout = last_recv + timeout;
+	}
+
+	if (next_timeout) {
+		debug_scsi("Setting next tmo %lu\n", next_timeout);
+		mod_timer(&conn->transport_timer, next_timeout);
+	}
+done:
+	spin_unlock(&session->lock);
+}
+
 static void iscsi_prep_abort_task_pdu(struct iscsi_cmd_task *ctask,
 				      struct iscsi_tm *hdr)
 {
@@ -1304,7 +1449,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	hdr = &conn->tmhdr;
 	iscsi_prep_abort_task_pdu(ctask, hdr);
 
-	if (iscsi_exec_task_mgmt_fn(conn, hdr, age)) {
+	if (iscsi_exec_task_mgmt_fn(conn, hdr, age, session->abort_timeout)) {
 		rc = FAILED;
 		goto failed;
 	}
@@ -1365,7 +1510,7 @@ static void iscsi_prep_lun_reset_pdu(struct scsi_cmnd *sc, struct iscsi_tm *hdr)
 	hdr->flags = ISCSI_TM_FUNC_LOGICAL_UNIT_RESET & ISCSI_FLAG_TM_FUNC_MASK;
 	hdr->flags |= ISCSI_FLAG_CMD_FINAL;
 	int_to_scsilun(sc->device->lun, (struct scsi_lun *)hdr->lun);
-	hdr->rtt = ISCSI_RESERVED_TAG;
+	hdr->rtt = RESERVED_ITT;
 }
 
 int iscsi_eh_device_reset(struct scsi_cmnd *sc)
@@ -1396,7 +1541,8 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 	hdr = &conn->tmhdr;
 	iscsi_prep_lun_reset_pdu(sc, hdr);
 
-	if (iscsi_exec_task_mgmt_fn(conn, hdr, session->age)) {
+	if (iscsi_exec_task_mgmt_fn(conn, hdr, session->age,
+				    session->lu_reset_timeout)) {
 		rc = FAILED;
 		goto unlock;
 	}
@@ -1572,12 +1718,14 @@ iscsi_session_setup(struct iscsi_transport *iscsit,
 	shost->max_cmd_len = iscsit->max_cmd_len;
 	shost->transportt = scsit;
 	shost->transportt->create_work_queue = 1;
+	shost->transportt->eh_timed_out = iscsi_eh_cmd_timed_out;
 	*hostno = shost->host_no;
 
 	session = iscsi_hostdata(shost->hostdata);
 	memset(session, 0, sizeof(struct iscsi_session));
 	session->host = shost;
 	session->state = ISCSI_STATE_FREE;
+	session->fast_abort = 1;
 	session->mgmtpool_max = ISCSI_MGMT_CMDS_MAX;
 	session->cmds_max = cmds_max;
 	session->queued_cmdsn = session->cmdsn = initial_cmdsn;
@@ -1708,6 +1856,11 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, uint32_t conn_idx)
 	conn->id = conn_idx;
 	conn->exp_statsn = 0;
 	conn->tmf_state = TMF_INITIAL;
+
+	init_timer(&conn->transport_timer);
+	conn->transport_timer.data = (unsigned long)conn;
+	conn->transport_timer.function = iscsi_check_transport_timeouts;
+
 	INIT_LIST_HEAD(&conn->run_list);
 	INIT_LIST_HEAD(&conn->mgmt_run_list);
 	INIT_LIST_HEAD(&conn->mgmtqueue);
@@ -1757,6 +1910,8 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 	struct iscsi_session *session = conn->session;
 	unsigned long flags;
 
+	del_timer_sync(&conn->transport_timer);
+
 	spin_lock_bh(&session->lock);
 	conn->c_stage = ISCSI_CONN_CLEANUP_WAIT;
 	if (session->leadconn == conn) {
@@ -1823,11 +1978,29 @@ int iscsi_conn_start(struct iscsi_cls_conn *cls_conn)
 		return -EINVAL;
 	}
 
+	if (conn->ping_timeout && !conn->recv_timeout) {
+		printk(KERN_ERR "iscsi: invalid recv timeout of zero "
+		      "Using 5 seconds\n.");
+		conn->recv_timeout = 5;
+	}
+
+	if (conn->recv_timeout && !conn->ping_timeout) {
+		printk(KERN_ERR "iscsi: invalid ping timeout of zero "
+		      "Using 5 seconds.\n");
+		conn->ping_timeout = 5;
+	}
+
 	spin_lock_bh(&session->lock);
 	conn->c_stage = ISCSI_CONN_STARTED;
 	session->state = ISCSI_STATE_LOGGED_IN;
 	session->queued_cmdsn = session->cmdsn;
 
+	conn->last_recv = jiffies;
+	conn->last_ping = jiffies;
+	if (conn->recv_timeout && conn->ping_timeout)
+		mod_timer(&conn->transport_timer,
+			  jiffies + (conn->recv_timeout * HZ));
+
 	switch(conn->stop_stage) {
 	case STOP_CONN_RECOVER:
 		/*
@@ -1879,6 +2052,8 @@ static void iscsi_start_session_recovery(struct iscsi_session *session,
 {
 	int old_stop_stage;
 
+	del_timer_sync(&conn->transport_timer);
+
 	mutex_lock(&session->eh_mutex);
 	spin_lock_bh(&session->lock);
 	if (conn->stop_stage == STOP_CONN_TERM) {
@@ -1993,6 +2168,18 @@ int iscsi_set_param(struct iscsi_cls_conn *cls_conn,
 	case ISCSI_PARAM_FAST_ABORT:
 		sscanf(buf, "%d", &session->fast_abort);
 		break;
+	case ISCSI_PARAM_ABORT_TMO:
+		sscanf(buf, "%d", &session->abort_timeout);
+		break;
+	case ISCSI_PARAM_LU_RESET_TMO:
+		sscanf(buf, "%d", &session->lu_reset_timeout);
+		break;
+	case ISCSI_PARAM_PING_TMO:
+		sscanf(buf, "%d", &conn->ping_timeout);
+		break;
+	case ISCSI_PARAM_RECV_TMO:
+		sscanf(buf, "%d", &conn->recv_timeout);
+		break;
 	case ISCSI_PARAM_MAX_RECV_DLENGTH:
 		sscanf(buf, "%d", &conn->max_recv_dlength);
 		break;
@@ -2110,6 +2297,12 @@ int iscsi_session_get_param(struct iscsi_cls_session *cls_session,
 	case ISCSI_PARAM_FAST_ABORT:
 		len = sprintf(buf, "%d\n", session->fast_abort);
 		break;
+	case ISCSI_PARAM_ABORT_TMO:
+		len = sprintf(buf, "%d\n", session->abort_timeout);
+		break;
+	case ISCSI_PARAM_LU_RESET_TMO:
+		len = sprintf(buf, "%d\n", session->lu_reset_timeout);
+		break;
 	case ISCSI_PARAM_INITIAL_R2T_EN:
 		len = sprintf(buf, "%d\n", session->initial_r2t_en);
 		break;
@@ -2167,6 +2360,12 @@ int iscsi_conn_get_param(struct iscsi_cls_conn *cls_conn,
 	int len;
 
 	switch(param) {
+	case ISCSI_PARAM_PING_TMO:
+		len = sprintf(buf, "%u\n", conn->ping_timeout);
+		break;
+	case ISCSI_PARAM_RECV_TMO:
+		len = sprintf(buf, "%u\n", conn->recv_timeout);
+		break;
 	case ISCSI_PARAM_MAX_RECV_DLENGTH:
 		len = sprintf(buf, "%u\n", conn->max_recv_dlength);
 		break;
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index b82139d..36aa50e 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1202,6 +1202,8 @@ iscsi_conn_attr(port, ISCSI_PARAM_CONN_PORT);
 iscsi_conn_attr(exp_statsn, ISCSI_PARAM_EXP_STATSN);
 iscsi_conn_attr(persistent_address, ISCSI_PARAM_PERSISTENT_ADDRESS);
 iscsi_conn_attr(address, ISCSI_PARAM_CONN_ADDRESS);
+iscsi_conn_attr(ping_tmo, ISCSI_PARAM_PING_TMO);
+iscsi_conn_attr(recv_tmo, ISCSI_PARAM_RECV_TMO);
 
 #define iscsi_cdev_to_session(_cdev) \
 	iscsi_dev_to_session(_cdev->dev)
@@ -1437,6 +1439,8 @@ iscsi_register_transport(struct iscsi_transport *tt)
 	SETUP_CONN_RD_ATTR(exp_statsn, ISCSI_EXP_STATSN);
 	SETUP_CONN_RD_ATTR(persistent_address, ISCSI_PERSISTENT_ADDRESS);
 	SETUP_CONN_RD_ATTR(persistent_port, ISCSI_PERSISTENT_PORT);
+	SETUP_CONN_RD_ATTR(ping_tmo, ISCSI_PING_TMO);
+	SETUP_CONN_RD_ATTR(recv_tmo, ISCSI_RECV_TMO);
 
 	BUG_ON(count > ISCSI_CONN_ATTRS);
 	priv->conn_attrs[count] = NULL;
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index 8a4426d..e19e584 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -244,6 +244,12 @@ enum iscsi_param {
 	ISCSI_PARAM_PASSWORD_IN,
 
 	ISCSI_PARAM_FAST_ABORT,
+	ISCSI_PARAM_ABORT_TMO,
+	ISCSI_PARAM_LU_RESET_TMO,
+	ISCSI_PARAM_HOST_RESET_TMO,
+
+	ISCSI_PARAM_PING_TMO,
+	ISCSI_PARAM_RECV_TMO,
 	/* must always be last */
 	ISCSI_PARAM_MAX,
 };
@@ -275,6 +281,11 @@ enum iscsi_param {
 #define ISCSI_PASSWORD			(1 << ISCSI_PARAM_PASSWORD)
 #define ISCSI_PASSWORD_IN		(1 << ISCSI_PARAM_PASSWORD_IN)
 #define ISCSI_FAST_ABORT		(1 << ISCSI_PARAM_FAST_ABORT)
+#define ISCSI_ABORT_TMO			(1 << ISCSI_PARAM_ABORT_TMO)
+#define ISCSI_LU_RESET_TMO		(1 << ISCSI_PARAM_LU_RESET_TMO)
+#define ISCSI_HOST_RESET_TMO		(1 << ISCSI_PARAM_HOST_RESET_TMO)
+#define ISCSI_PING_TMO			(1 << ISCSI_PARAM_PING_TMO)
+#define ISCSI_RECV_TMO			(1 << ISCSI_PARAM_RECV_TMO)
 
 /* iSCSI HBA params */
 enum iscsi_host_param {
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index d68f745..889f51f 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -148,6 +148,12 @@ struct iscsi_conn {
 	 * conn_stop() flag: stop to recover, stop to terminate
 	 */
         int			stop_stage;
+	struct timer_list	transport_timer;
+	unsigned long		last_recv;
+	unsigned long		last_ping;
+	int			ping_timeout;
+	int			recv_timeout;
+	struct iscsi_mgmt_task	*ping_mtask;
 
 	/* iSCSI connection-wide sequencing */
 	uint32_t		exp_statsn;
@@ -238,6 +244,8 @@ struct iscsi_session {
 	uint32_t		queued_cmdsn;
 
 	/* configuration */
+	int			abort_timeout;
+	int			lu_reset_timeout;
 	int			initial_r2t_en;
 	unsigned		max_r2t;
 	int			imm_data_en;
-- 
1.5.1.2

