From: michaelc@cs.wisc.edu
Subject: [PATCH 11/25] libiscsi: merge iscsi_mgmt_task and iscsi_cmd_task
Date: Wed, 21 May 2008 15:54:06 -0500
Message-ID: <1211403260-5487-12-git-send-email-michaelc@cs.wisc.edu>
References: <1211403260-5487-1-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-2-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-3-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-4-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-5-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-6-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-7-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-8-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-9-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-10-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-11-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936870AbYEUUya (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2008 16:54:30 -0400
In-Reply-To: <1211403260-5487-11-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

There is no need to have the mgmt and cmd tasks separate
structs. It used to save a lot of memory when we overprealocated
memory for tasks, but the next patches will set up the
driver so in the future they can use a mempool or some other
common scsi command allocator and common tagging.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c             |  518 +++++++++++++++++------------------
 include/scsi/libiscsi.h             |   29 +--
 include/scsi/scsi_transport_iscsi.h |   41 ++--
 3 files changed, 272 insertions(+), 316 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 1e605de..ef92b1b 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -197,7 +197,7 @@ static int iscsi_prep_bidi_ahs(struct iscsi_cmd_task *ctask)
 
 /**
  * iscsi_prep_scsi_cmd_pdu - prep iscsi scsi cmd pdu
- * @ctask: iscsi cmd task
+ * @ctask: iscsi task
  *
  * Prep basic iSCSI PDU fields for a scsi cmd pdu. The LLD should set
  * fields like dlength or final based on how much data it sends
@@ -300,31 +300,31 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_cmd_task *ctask)
 	WARN_ON(hdrlength >= 256);
 	hdr->hlength = hdrlength & 0xFF;
 
-	if (conn->session->tt->init_cmd_task &&
-	    conn->session->tt->init_cmd_task(ctask))
+	if (conn->session->tt->init_task &&
+	    conn->session->tt->init_task(ctask))
 		return -EIO;
 
 	ctask->state = ISCSI_TASK_RUNNING;
 	list_move_tail(&ctask->running, &conn->run_list);
 
 	conn->scsicmd_pdus_cnt++;
-	debug_scsi("iscsi prep [%s cid %d sc %p cdb 0x%x itt 0x%x "
-		"len %d bidi_len %d cmdsn %d win %d]\n",
-		scsi_bidi_cmnd(sc) ? "bidirectional" :
-		     sc->sc_data_direction == DMA_TO_DEVICE ? "write" : "read",
-		conn->id, sc, sc->cmnd[0], ctask->itt,
-		scsi_bufflen(sc), scsi_bidi_cmnd(sc) ? scsi_in(sc)->length : 0,
-		session->cmdsn, session->max_cmdsn - session->exp_cmdsn + 1);
+	debug_scsi("iscsi prep [%s cid %d sc %p cdb 0x%x itt 0x%x len %d "
+		   "bidi_len %d cmdsn %d win %d]\n", scsi_bidi_cmnd(sc) ?
+		   "bidirectional" : sc->sc_data_direction == DMA_TO_DEVICE ?
+		   "write" : "read", conn->id, sc, sc->cmnd[0], ctask->itt,
+		   scsi_bufflen(sc),
+		   scsi_bidi_cmnd(sc) ? scsi_in(sc)->length : 0,
+		   session->cmdsn, session->max_cmdsn - session->exp_cmdsn + 1);
 	return 0;
 }
 
 /**
- * iscsi_complete_command - return command back to scsi-ml
+ * iscsi_complete_command - finish a task
  * @ctask: iscsi cmd task
  *
  * Must be called with session lock.
- * This function returns the scsi command to scsi-ml and returns
- * the cmd task to the pool of available cmd tasks.
+ * This function returns the scsi command to scsi-ml or cleans
+ * up mgmt tasks then returns the task to the pool.
  */
 static void iscsi_complete_command(struct iscsi_cmd_task *ctask)
 {
@@ -332,17 +332,34 @@ static void iscsi_complete_command(struct iscsi_cmd_task *ctask)
 	struct iscsi_session *session = conn->session;
 	struct scsi_cmnd *sc = ctask->sc;
 
+	list_del_init(&ctask->running);
 	ctask->state = ISCSI_TASK_COMPLETED;
 	ctask->sc = NULL;
-	/* SCSI eh reuses commands to verify us */
-	sc->SCp.ptr = NULL;
+
 	if (conn->ctask == ctask)
 		conn->ctask = NULL;
-	list_del_init(&ctask->running);
+	/*
+	 * login ctask is preallocated so do not free
+	 */
+	if (conn->login_ctask == ctask)
+		return;
+
 	__kfifo_put(session->cmdpool.queue, (void*)&ctask, sizeof(void*));
 
-	if (sc->scsi_done)
-		sc->scsi_done(sc);
+	if (conn->ping_ctask == ctask)
+		conn->ping_ctask = NULL;
+
+	if (sc) {
+		ctask->sc = NULL;
+		/* SCSI eh reuses commands to verify us */
+		sc->SCp.ptr = NULL;
+		/*
+		 * queue command may call this to free the task, but
+		 * not have setup the sc callback
+		 */
+		if (sc->scsi_done)
+			sc->scsi_done(sc);
+	}
 }
 
 static void __iscsi_get_ctask(struct iscsi_cmd_task *ctask)
@@ -356,6 +373,16 @@ static void __iscsi_put_ctask(struct iscsi_cmd_task *ctask)
 		iscsi_complete_command(ctask);
 }
 
+void iscsi_put_ctask(struct iscsi_cmd_task *ctask)
+{
+	struct iscsi_session *session = ctask->conn->session;
+
+	spin_lock_bh(&session->lock);
+	__iscsi_put_ctask(ctask);
+	spin_unlock_bh(&session->lock);
+}
+EXPORT_SYMBOL_GPL(iscsi_put_ctask);
+
 /*
  * session lock must be held
  */
@@ -375,47 +402,28 @@ static void fail_command(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
 		 */
 		conn->session->queued_cmdsn--;
 	else
-		conn->session->tt->cleanup_cmd_task(conn, ctask);
+		conn->session->tt->cleanup_task(conn, ctask);
 
 	sc->result = err;
+
 	if (!scsi_bidi_cmnd(sc))
 		scsi_set_resid(sc, scsi_bufflen(sc));
 	else {
 		scsi_out(sc)->resid = scsi_out(sc)->length;
 		scsi_in(sc)->resid = scsi_in(sc)->length;
 	}
+
 	if (conn->ctask == ctask)
 		conn->ctask = NULL;
 	/* release ref from queuecommand */
 	__iscsi_put_ctask(ctask);
 }
 
-/**
- * iscsi_free_mgmt_task - return mgmt task back to pool
- * @conn: iscsi connection
- * @mtask: mtask
- *
- * Must be called with session lock.
- */
-void iscsi_free_mgmt_task(struct iscsi_conn *conn,
-			  struct iscsi_mgmt_task *mtask)
-{
-	list_del_init(&mtask->running);
-	if (conn->login_mtask == mtask)
-		return;
-
-	if (conn->ping_mtask == mtask)
-		conn->ping_mtask = NULL;
-	__kfifo_put(conn->session->mgmtpool.queue,
-		    (void*)&mtask, sizeof(void*));
-}
-EXPORT_SYMBOL_GPL(iscsi_free_mgmt_task);
-
-static int iscsi_prep_mtask(struct iscsi_conn *conn,
-			    struct iscsi_mgmt_task *mtask)
+static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
+				struct iscsi_cmd_task *ctask)
 {
 	struct iscsi_session *session = conn->session;
-	struct iscsi_hdr *hdr = mtask->hdr;
+	struct iscsi_hdr *hdr = (struct iscsi_hdr *)ctask->hdr;
 	struct iscsi_nopout *nop = (struct iscsi_nopout *)hdr;
 
 	if (conn->session->state == ISCSI_STATE_LOGGING_OUT)
@@ -429,7 +437,7 @@ static int iscsi_prep_mtask(struct iscsi_conn *conn,
 	 */
 	nop->cmdsn = cpu_to_be32(session->cmdsn);
 	if (hdr->itt != RESERVED_ITT) {
-		hdr->itt = build_itt(mtask->itt, session->age);
+		hdr->itt = build_itt(ctask->itt, session->age);
 		/*
 		 * TODO: We always use immediate, so we never hit this.
 		 * If we start to send tmfs or nops as non-immediate then
@@ -442,25 +450,25 @@ static int iscsi_prep_mtask(struct iscsi_conn *conn,
 		}
 	}
 
-	if (session->tt->init_mgmt_task)
-		session->tt->init_mgmt_task(conn, mtask);
+	if (session->tt->init_task)
+		session->tt->init_task(ctask);
 
 	if ((hdr->opcode & ISCSI_OPCODE_MASK) == ISCSI_OP_LOGOUT)
 		session->state = ISCSI_STATE_LOGGING_OUT;
 
-	list_move_tail(&mtask->running, &conn->mgmt_run_list);
+	list_move_tail(&ctask->running, &conn->mgmt_run_list);
 	debug_scsi("mgmtpdu [op 0x%x hdr->itt 0x%x datalen %d]\n",
 		   hdr->opcode & ISCSI_OPCODE_MASK, hdr->itt,
-		   mtask->data_count);
+		   ctask->data_count);
 	return 0;
 }
 
-static struct iscsi_mgmt_task *
+static struct iscsi_cmd_task *
 __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		      char *data, uint32_t data_size)
 {
 	struct iscsi_session *session = conn->session;
-	struct iscsi_mgmt_task *mtask;
+	struct iscsi_cmd_task *ctask;
 
 	if (session->state == ISCSI_STATE_TERMINATE)
 		return NULL;
@@ -470,48 +478,56 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		/*
 		 * Login and Text are sent serially, in
 		 * request-followed-by-response sequence.
-		 * Same mtask can be used. Same ITT must be used.
-		 * Note that login_mtask is preallocated at conn_create().
+		 * Same task can be used. Same ITT must be used.
+		 * Note that login_task is preallocated at conn_create().
 		 */
-		mtask = conn->login_mtask;
+		ctask = conn->login_ctask;
 	else {
 		BUG_ON(conn->c_stage == ISCSI_CONN_INITIAL_STAGE);
 		BUG_ON(conn->c_stage == ISCSI_CONN_STOPPED);
 
-		if (!__kfifo_get(session->mgmtpool.queue,
-				 (void*)&mtask, sizeof(void*)))
+		if (!__kfifo_get(session->cmdpool.queue,
+				 (void*)&ctask, sizeof(void*)))
 			return NULL;
 
 		if ((hdr->opcode == (ISCSI_OP_NOOP_OUT | ISCSI_OP_IMMEDIATE)) &&
 		     hdr->ttt == RESERVED_ITT) {
-			conn->ping_mtask = mtask;
+			conn->ping_ctask = ctask;
 			conn->last_ping = jiffies;
 		}
 	}
+	/*
+	 * released in complete pdu for task we expect a response for, and
+	 * released by the lld when it has transmitted the task for
+	 * pdus we do not expect a response for.
+	 */
+	atomic_set(&ctask->refcount, 1);
+	ctask->conn = conn;
+	ctask->sc = NULL;
 
 	if (data_size) {
-		memcpy(mtask->data, data, data_size);
-		mtask->data_count = data_size;
+		memcpy(ctask->data, data, data_size);
+		ctask->data_count = data_size;
 	} else
-		mtask->data_count = 0;
+		ctask->data_count = 0;
 
-	memcpy(mtask->hdr, hdr, sizeof(struct iscsi_hdr));
-	INIT_LIST_HEAD(&mtask->running);
-	list_add_tail(&mtask->running, &conn->mgmtqueue);
+	memcpy(ctask->hdr, hdr, sizeof(struct iscsi_hdr));
+	INIT_LIST_HEAD(&ctask->running);
+	list_add_tail(&ctask->running, &conn->mgmtqueue);
 
 	if (session->tt->caps & CAP_DATA_PATH_OFFLOAD) {
-		if (iscsi_prep_mtask(conn, mtask)) {
-			iscsi_free_mgmt_task(conn, mtask);
+		if (iscsi_prep_mgmt_task(conn, ctask)) {
+			__iscsi_put_ctask(ctask);
 			return NULL;
 		}
 
-		if (session->tt->xmit_mgmt_task(conn, mtask))
-			mtask = NULL;
+		if (session->tt->xmit_task(ctask))
+			ctask = NULL;
 
 	} else
 		scsi_queue_work(conn->session->host, &conn->xmitwork);
 
-	return mtask;
+	return ctask;
 }
 
 int iscsi_conn_send_pdu(struct iscsi_cls_conn *cls_conn, struct iscsi_hdr *hdr,
@@ -538,7 +554,7 @@ EXPORT_SYMBOL_GPL(iscsi_conn_send_pdu);
  * @datalen: len of buffer
  *
  * iscsi_cmd_rsp sets up the scsi_cmnd fields based on the PDU and
- * then completes the command and task.
+ * then completes the command and ctask.
  **/
 static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			       struct iscsi_cmd_task *ctask, char *data,
@@ -634,9 +650,9 @@ static void iscsi_tmf_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 static void iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
 {
         struct iscsi_nopout hdr;
-	struct iscsi_mgmt_task *mtask;
+	struct iscsi_cmd_task *ctask;
 
-	if (!rhdr && conn->ping_mtask)
+	if (!rhdr && conn->ping_ctask)
 		return;
 
 	memset(&hdr, 0, sizeof(struct iscsi_nopout));
@@ -650,8 +666,8 @@ static void iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
 	} else
 		hdr.ttt = RESERVED_ITT;
 
-	mtask = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)&hdr, NULL, 0);
-	if (!mtask)
+	ctask = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)&hdr, NULL, 0);
+	if (!ctask)
 		iscsi_conn_printk(KERN_ERR, conn, "Could not send nopout\n");
 }
 
@@ -697,7 +713,6 @@ static int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	struct iscsi_session *session = conn->session;
 	int opcode = hdr->opcode & ISCSI_OPCODE_MASK, rc = 0;
 	struct iscsi_cmd_task *ctask;
-	struct iscsi_mgmt_task *mtask;
 	uint32_t itt;
 
 	conn->last_recv = jiffies;
@@ -710,93 +725,10 @@ static int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	else
 		itt = ~0U;
 
-	if (itt < session->cmds_max) {
-		ctask = session->cmds[itt];
-
-		debug_scsi("cmdrsp [op 0x%x cid %d itt 0x%x len %d]\n",
-			   opcode, conn->id, ctask->itt, datalen);
-
-		switch(opcode) {
-		case ISCSI_OP_SCSI_CMD_RSP:
-			BUG_ON((void*)ctask != ctask->sc->SCp.ptr);
-			iscsi_scsi_cmd_rsp(conn, hdr, ctask, data,
-					   datalen);
-			break;
-		case ISCSI_OP_SCSI_DATA_IN:
-			BUG_ON((void*)ctask != ctask->sc->SCp.ptr);
-			if (hdr->flags & ISCSI_FLAG_DATA_STATUS) {
-				conn->scsirsp_pdus_cnt++;
-				__iscsi_put_ctask(ctask);
-			}
-			break;
-		case ISCSI_OP_R2T:
-			/* LLD handles this for now */
-			break;
-		default:
-			rc = ISCSI_ERR_BAD_OPCODE;
-			break;
-		}
-	} else if (itt >= ISCSI_MGMT_ITT_OFFSET &&
-		   itt < ISCSI_MGMT_ITT_OFFSET + session->mgmtpool_max) {
-		mtask = session->mgmt_cmds[itt - ISCSI_MGMT_ITT_OFFSET];
-
-		debug_scsi("immrsp [op 0x%x cid %d itt 0x%x len %d]\n",
-			   opcode, conn->id, mtask->itt, datalen);
+	debug_scsi("[op 0x%x cid %d itt 0x%x len %d]\n",
+		   opcode, conn->id, itt, datalen);
 
-		iscsi_update_cmdsn(session, (struct iscsi_nopin*)hdr);
-		switch(opcode) {
-		case ISCSI_OP_LOGOUT_RSP:
-			if (datalen) {
-				rc = ISCSI_ERR_PROTO;
-				break;
-			}
-			conn->exp_statsn = be32_to_cpu(hdr->statsn) + 1;
-			/* fall through */
-		case ISCSI_OP_LOGIN_RSP:
-		case ISCSI_OP_TEXT_RSP:
-			/*
-			 * login related PDU's exp_statsn is handled in
-			 * userspace
-			 */
-			if (iscsi_recv_pdu(conn->cls_conn, hdr, data, datalen))
-				rc = ISCSI_ERR_CONN_FAILED;
-			iscsi_free_mgmt_task(conn, mtask);
-			break;
-		case ISCSI_OP_SCSI_TMFUNC_RSP:
-			if (datalen) {
-				rc = ISCSI_ERR_PROTO;
-				break;
-			}
-
-			iscsi_tmf_rsp(conn, hdr);
-			iscsi_free_mgmt_task(conn, mtask);
-			break;
-		case ISCSI_OP_NOOP_IN:
-			if (hdr->ttt != cpu_to_be32(ISCSI_RESERVED_TAG) ||
-			    datalen) {
-				rc = ISCSI_ERR_PROTO;
-				break;
-			}
-			conn->exp_statsn = be32_to_cpu(hdr->statsn) + 1;
-
-			if (conn->ping_mtask != mtask) {
-				/*
-				 * If this is not in response to one of our
-				 * nops then it must be from userspace.
-				 */
-				if (iscsi_recv_pdu(conn->cls_conn, hdr, data,
-						   datalen))
-					rc = ISCSI_ERR_CONN_FAILED;
-			} else
-				mod_timer(&conn->transport_timer,
-					  jiffies + conn->recv_timeout);
-			iscsi_free_mgmt_task(conn, mtask);
-			break;
-		default:
-			rc = ISCSI_ERR_BAD_OPCODE;
-			break;
-		}
-	} else if (itt == ~0U) {
+	if (itt == ~0U) {
 		iscsi_update_cmdsn(session, (struct iscsi_nopin*)hdr);
 
 		switch(opcode) {
@@ -823,9 +755,88 @@ static int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			rc = ISCSI_ERR_BAD_OPCODE;
 			break;
 		}
-	} else
-		rc = ISCSI_ERR_BAD_ITT;
+		goto out;
+	}
+
+	ctask = session->cmds[itt];
+	switch(opcode) {
+	case ISCSI_OP_SCSI_CMD_RSP:
+		if (!ctask->sc) {
+			rc = ISCSI_ERR_NO_SCSI_CMD;
+			break;
+		}
+		BUG_ON((void*)ctask != ctask->sc->SCp.ptr);
+		iscsi_scsi_cmd_rsp(conn, hdr, ctask, data, datalen);
+		break;
+	case ISCSI_OP_SCSI_DATA_IN:
+		if (!ctask->sc) {
+			rc = ISCSI_ERR_NO_SCSI_CMD;
+			break;
+		}
+		BUG_ON((void*)ctask != ctask->sc->SCp.ptr);
+		if (hdr->flags & ISCSI_FLAG_DATA_STATUS) {
+			conn->scsirsp_pdus_cnt++;
+			iscsi_update_cmdsn(session,
+					   (struct iscsi_nopin*) hdr);
+			__iscsi_put_ctask(ctask);
+		}
+		break;
+	case ISCSI_OP_R2T:
+		/* LLD handles this for now */
+		break;
+	case ISCSI_OP_LOGOUT_RSP:
+		iscsi_update_cmdsn(session, (struct iscsi_nopin*)hdr);
+		if (datalen) {
+			rc = ISCSI_ERR_PROTO;
+			break;
+		}
+		conn->exp_statsn = be32_to_cpu(hdr->statsn) + 1;
+		goto recv_pdu;
+	case ISCSI_OP_LOGIN_RSP:
+	case ISCSI_OP_TEXT_RSP:
+		iscsi_update_cmdsn(session, (struct iscsi_nopin*)hdr);
+		/*
+		 * login related PDU's exp_statsn is handled in
+		 * userspace
+		 */
+		goto recv_pdu;
+	case ISCSI_OP_SCSI_TMFUNC_RSP:
+		iscsi_update_cmdsn(session, (struct iscsi_nopin*)hdr);
+		if (datalen) {
+			rc = ISCSI_ERR_PROTO;
+			break;
+		}
+
+		iscsi_tmf_rsp(conn, hdr);
+		__iscsi_put_ctask(ctask);
+		break;
+	case ISCSI_OP_NOOP_IN:
+		iscsi_update_cmdsn(session, (struct iscsi_nopin*)hdr);
+		if (hdr->ttt != cpu_to_be32(ISCSI_RESERVED_TAG) || datalen) {
+			rc = ISCSI_ERR_PROTO;
+			break;
+		}
+		conn->exp_statsn = be32_to_cpu(hdr->statsn) + 1;
+
+		if (conn->ping_ctask != ctask)
+			/*
+			 * If this is not in response to one of our
+			 * nops then it must be from userspace.
+			 */
+			goto recv_pdu;
+		__iscsi_put_ctask(ctask);
+		break;
+	default:
+		rc = ISCSI_ERR_BAD_OPCODE;
+		break;
+	}
 
+out:
+	return rc;
+recv_pdu:
+	if (iscsi_recv_pdu(conn->cls_conn, hdr, data, datalen))
+		rc = ISCSI_ERR_CONN_FAILED;
+	__iscsi_put_ctask(ctask);
 	return rc;
 }
 
@@ -845,6 +856,7 @@ int iscsi_verify_itt(struct iscsi_conn *conn, itt_t itt)
 {
 	struct iscsi_session *session = conn->session;
 	struct iscsi_cmd_task *ctask;
+	uint32_t i;
 
 	if (itt == RESERVED_ITT)
 		return 0;
@@ -858,25 +870,22 @@ int iscsi_verify_itt(struct iscsi_conn *conn, itt_t itt)
 		return ISCSI_ERR_BAD_ITT;
 	}
 
-	if (itt < session->cmds_max) {
-		ctask = session->cmds[itt];
-
-		if (!ctask->sc) {
-			iscsi_conn_printk(KERN_INFO, conn, "dropping ctask "
-					  "with itt 0x%x\n", ctask->itt);
-			/* force drop */
-			return ISCSI_ERR_NO_SCSI_CMD;
-		}
-
-		if (ctask->sc->SCp.phase != session->age) {
-			iscsi_conn_printk(KERN_ERR, conn,
-					  "iscsi: ctask's session age %d, "
-					  "expected %d\n", ctask->sc->SCp.phase,
-					  session->age);
-			return ISCSI_ERR_SESSION_FAILED;
-		}
+	i = get_itt(itt);
+	if (i >= session->cmds_max) {
+		iscsi_conn_printk(KERN_ERR, conn,
+				  "received invalid itt index %u (max cmds "
+				   "%u.\n", i, session->cmds_max);
+		return ISCSI_ERR_BAD_ITT;
 	}
 
+	ctask = session->cmds[i];
+	if (ctask->sc && ctask->sc->SCp.phase != session->age) {
+		iscsi_conn_printk(KERN_ERR, conn,
+				  "iscsi: ctask's session age %d, "
+				  "expected %d\n", ctask->sc->SCp.phase,
+				  session->age);
+		return ISCSI_ERR_SESSION_FAILED;
+	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(iscsi_verify_itt);
@@ -929,20 +938,6 @@ void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err)
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_failure);
 
-static int iscsi_xmit_mtask(struct iscsi_conn *conn)
-{
-	int rc;
-
-	spin_unlock_bh(&conn->session->lock);
-	rc = conn->session->tt->xmit_mgmt_task(conn, conn->mtask);
-	spin_lock_bh(&conn->session->lock);
-	if (rc)
-		return rc;
-	/* done with this in-progress mtask */
-	conn->mtask = NULL;
-	return 0;
-}
-
 static int iscsi_check_cmdsn_window_closed(struct iscsi_conn *conn)
 {
 	struct iscsi_session *session = conn->session;
@@ -967,7 +962,7 @@ static int iscsi_xmit_ctask(struct iscsi_conn *conn)
 
 	__iscsi_get_ctask(ctask);
 	spin_unlock_bh(&conn->session->lock);
-	rc = conn->session->tt->xmit_cmd_task(conn, ctask);
+	rc = conn->session->tt->xmit_task(ctask);
 	spin_lock_bh(&conn->session->lock);
 	__iscsi_put_ctask(ctask);
 	if (!rc)
@@ -1015,12 +1010,6 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 
 	if (conn->ctask) {
 		rc = iscsi_xmit_ctask(conn);
-		if (rc)
-			goto again;
-	}
-
-	if (conn->mtask) {
-		rc = iscsi_xmit_mtask(conn);
 	        if (rc)
 		        goto again;
 	}
@@ -1032,14 +1021,14 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 	 */
 check_mgmt:
 	while (!list_empty(&conn->mgmtqueue)) {
-		conn->mtask = list_entry(conn->mgmtqueue.next,
-					 struct iscsi_mgmt_task, running);
-		if (iscsi_prep_mtask(conn, conn->mtask)) {
-			iscsi_free_mgmt_task(conn, conn->mtask);
-			conn->mtask = NULL;
+		conn->ctask = list_entry(conn->mgmtqueue.next,
+					 struct iscsi_cmd_task, running);
+		if (iscsi_prep_mgmt_task(conn, conn->ctask)) {
+			__iscsi_put_ctask(conn->ctask);
+			conn->ctask = NULL;
 			continue;
 		}
-		rc = iscsi_xmit_mtask(conn);
+		rc = iscsi_xmit_ctask(conn);
 		if (rc)
 			goto again;
 	}
@@ -1224,7 +1213,7 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 			iscsi_complete_command(ctask);
 			goto fault;
 		}
-		if (session->tt->xmit_cmd_task(conn, ctask)) {
+		if (session->tt->xmit_task(ctask)) {
 			sc->scsi_done = NULL;
 			iscsi_complete_command(ctask);
 			reason = FAILURE_SESSION_NOT_READY;
@@ -1347,16 +1336,16 @@ static void iscsi_tmf_timedout(unsigned long data)
 	spin_unlock(&session->lock);
 }
 
-static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
+static int iscsi_exec_ctask_mgmt_fn(struct iscsi_conn *conn,
 				   struct iscsi_tm *hdr, int age,
 				   int timeout)
 {
 	struct iscsi_session *session = conn->session;
-	struct iscsi_mgmt_task *mtask;
+	struct iscsi_cmd_task *ctask;
 
-	mtask = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)hdr,
+	ctask = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)hdr,
 				      NULL, 0);
-	if (!mtask) {
+	if (!ctask) {
 		spin_unlock_bh(&session->lock);
 		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
 		spin_lock_bh(&session->lock);
@@ -1390,7 +1379,7 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
 
 	mutex_lock(&session->eh_mutex);
 	spin_lock_bh(&session->lock);
-	/* if the session drops it will clean up the mtask */
+	/* if the session drops it will clean up the ctask */
 	if (age != session->age ||
 	    session->state != ISCSI_STATE_LOGGED_IN)
 		return -ENOTCONN;
@@ -1497,7 +1486,7 @@ static enum scsi_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *scmd)
 			   jiffies))
 		rc = EH_RESET_TIMER;
 	/* if in the middle of checking the transport then give us more time */
-	if (conn->ping_mtask)
+	if (conn->ping_ctask)
 		rc = EH_RESET_TIMER;
 done:
 	spin_unlock(&session->lock);
@@ -1521,7 +1510,7 @@ static void iscsi_check_transport_timeouts(unsigned long data)
 
 	recv_timeout *= HZ;
 	last_recv = conn->last_recv;
-	if (conn->ping_mtask &&
+	if (conn->ping_ctask &&
 	    time_before_eq(conn->last_ping + (conn->ping_timeout * HZ),
 			   jiffies)) {
 		iscsi_conn_printk(KERN_ERR, conn, "ping timeout of %d secs "
@@ -1547,7 +1536,7 @@ done:
 	spin_unlock(&session->lock);
 }
 
-static void iscsi_prep_abort_task_pdu(struct iscsi_cmd_task *ctask,
+static void iscsi_prep_abort_ctask_pdu(struct iscsi_cmd_task *ctask,
 				      struct iscsi_tm *hdr)
 {
 	memset(hdr, 0, sizeof(*hdr));
@@ -1619,9 +1608,9 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	conn->tmf_state = TMF_QUEUED;
 
 	hdr = &conn->tmhdr;
-	iscsi_prep_abort_task_pdu(ctask, hdr);
+	iscsi_prep_abort_ctask_pdu(ctask, hdr);
 
-	if (iscsi_exec_task_mgmt_fn(conn, hdr, age, session->abort_timeout)) {
+	if (iscsi_exec_ctask_mgmt_fn(conn, hdr, age, session->abort_timeout)) {
 		rc = FAILED;
 		goto failed;
 	}
@@ -1631,7 +1620,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		spin_unlock_bh(&session->lock);
 		iscsi_suspend_tx(conn);
 		/*
-		 * clean up task if aborted. grab the recv lock as a writer
+		 * clean up ctask if aborted. grab the recv lock as a writer
 		 */
 		write_lock_bh(conn->recv_lock);
 		spin_lock(&session->lock);
@@ -1716,7 +1705,7 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 	hdr = &conn->tmhdr;
 	iscsi_prep_lun_reset_pdu(sc, hdr);
 
-	if (iscsi_exec_task_mgmt_fn(conn, hdr, session->age,
+	if (iscsi_exec_ctask_mgmt_fn(conn, hdr, session->age,
 				    session->lu_reset_timeout)) {
 		rc = FAILED;
 		goto unlock;
@@ -1897,8 +1886,7 @@ EXPORT_SYMBOL_GPL(iscsi_host_free);
  * @iscsit: iscsi transport template
  * @shost: scsi host
  * @cmds_max: session can queue
- * @cmd_task_size: LLD ctask private data size
- * @mgmt_task_size: LLD mtask private data size
+ * @cmd_ctask_size: LLD ctask private data size
  * @initial_cmdsn: initial CmdSN
  *
  * This can be used by software iscsi_transports that allocate
@@ -1906,22 +1894,26 @@ EXPORT_SYMBOL_GPL(iscsi_host_free);
  */
 struct iscsi_cls_session *
 iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
-		    uint16_t cmds_max, int cmd_task_size, int mgmt_task_size,
+		    uint16_t scsi_cmds_max, int cmd_ctask_size,
 		    uint32_t initial_cmdsn)
 {
 	struct iscsi_session *session;
 	struct iscsi_cls_session *cls_session;
-	int cmd_i;
+	int cmd_i, cmds_max;
 
-	if (!is_power_of_2(cmds_max) || cmds_max >= ISCSI_MGMT_ITT_OFFSET ||
-	    cmds_max < 2) {
-		if (cmds_max != 0)
-			printk(KERN_ERR "iscsi: invalid can_queue of %d. "
-			       "can_queue must be a power of 2 and between "
-			       "2 and %d - setting to %d.\n", cmds_max,
-			       ISCSI_MGMT_ITT_OFFSET, ISCSI_DEF_XMIT_CMDS_MAX);
-		cmds_max = ISCSI_DEF_XMIT_CMDS_MAX;
+	/*
+	 * The iscsi layer needs some ctasks for nop handling and tmfs.
+	 */
+	if (scsi_cmds_max < 1)
+		scsi_cmds_max = ISCSI_MGMT_CMDS_MAX;
+	if ((scsi_cmds_max + ISCSI_MGMT_CMDS_MAX) >= ISCSI_MGMT_ITT_OFFSET) {
+		printk(KERN_ERR "iscsi: invalid can_queue of %d. "
+		       "can_queue must be less than %d.\n",
+		       scsi_cmds_max,
+		       ISCSI_MGMT_ITT_OFFSET - ISCSI_MGMT_CMDS_MAX);
+		scsi_cmds_max = ISCSI_DEF_XMIT_CMDS_MAX;
 	}
+	cmds_max = roundup_pow_of_two(scsi_cmds_max + ISCSI_MGMT_CMDS_MAX);
 
 	cls_session = iscsi_alloc_session(shost, iscsit,
 					  sizeof(struct iscsi_session));
@@ -1934,7 +1926,7 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 	session->fast_abort = 1;
 	session->lu_reset_timeout = 15;
 	session->abort_timeout = 10;
-	session->mgmtpool_max = ISCSI_MGMT_CMDS_MAX;
+	session->scsi_cmds_max = scsi_cmds_max;
 	session->cmds_max = cmds_max;
 	session->queued_cmdsn = session->cmdsn = initial_cmdsn;
 	session->exp_cmdsn = initial_cmdsn + 1;
@@ -1947,36 +1939,19 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 	/* initialize SCSI PDU commands pool */
 	if (iscsi_pool_init(&session->cmdpool, session->cmds_max,
 			    (void***)&session->cmds,
-			    cmd_task_size + sizeof(struct iscsi_cmd_task)))
+			    cmd_ctask_size + sizeof(struct iscsi_cmd_task)))
 		goto cmdpool_alloc_fail;
 
 	/* pre-format cmds pool with ITT */
 	for (cmd_i = 0; cmd_i < session->cmds_max; cmd_i++) {
 		struct iscsi_cmd_task *ctask = session->cmds[cmd_i];
 
-		if (cmd_task_size)
+		if (cmd_ctask_size)
 			ctask->dd_data = &ctask[1];
 		ctask->itt = cmd_i;
 		INIT_LIST_HEAD(&ctask->running);
 	}
 
-	/* initialize immediate command pool */
-	if (iscsi_pool_init(&session->mgmtpool, session->mgmtpool_max,
-			   (void***)&session->mgmt_cmds,
-			   mgmt_task_size + sizeof(struct iscsi_mgmt_task)))
-		goto mgmtpool_alloc_fail;
-
-
-	/* pre-format immediate cmds pool with ITT */
-	for (cmd_i = 0; cmd_i < session->mgmtpool_max; cmd_i++) {
-		struct iscsi_mgmt_task *mtask = session->mgmt_cmds[cmd_i];
-
-		if (mgmt_task_size)
-			mtask->dd_data = &mtask[1];
-		mtask->itt = ISCSI_MGMT_ITT_OFFSET + cmd_i;
-		INIT_LIST_HEAD(&mtask->running);
-	}
-
 	if (!try_module_get(iscsit->owner))
 		goto module_get_fail;
 
@@ -1987,8 +1962,6 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 cls_session_fail:
 	module_put(iscsit->owner);
 module_get_fail:
-	iscsi_pool_free(&session->mgmtpool);
-mgmtpool_alloc_fail:
 	iscsi_pool_free(&session->cmdpool);
 cmdpool_alloc_fail:
 	iscsi_free_session(cls_session);
@@ -2008,7 +1981,6 @@ void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
 	struct iscsi_session *session = cls_session->dd_data;
 	struct module *owner = cls_session->transport->owner;
 
-	iscsi_pool_free(&session->mgmtpool);
 	iscsi_pool_free(&session->cmdpool);
 
 	kfree(session->password);
@@ -2063,30 +2035,30 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
 	INIT_LIST_HEAD(&conn->requeue);
 	INIT_WORK(&conn->xmitwork, iscsi_xmitworker);
 
-	/* allocate login_mtask used for the login/text sequences */
+	/* allocate login_ctask used for the login/text sequences */
 	spin_lock_bh(&session->lock);
-	if (!__kfifo_get(session->mgmtpool.queue,
-                         (void*)&conn->login_mtask,
+	if (!__kfifo_get(session->cmdpool.queue,
+                         (void*)&conn->login_ctask,
 			 sizeof(void*))) {
 		spin_unlock_bh(&session->lock);
-		goto login_mtask_alloc_fail;
+		goto login_ctask_alloc_fail;
 	}
 	spin_unlock_bh(&session->lock);
 
 	data = kmalloc(ISCSI_DEF_MAX_RECV_SEG_LEN, GFP_KERNEL);
 	if (!data)
-		goto login_mtask_data_alloc_fail;
-	conn->login_mtask->data = conn->data = data;
+		goto login_ctask_data_alloc_fail;
+	conn->login_ctask->data = conn->data = data;
 
 	init_timer(&conn->tmf_timer);
 	init_waitqueue_head(&conn->ehwait);
 
 	return cls_conn;
 
-login_mtask_data_alloc_fail:
-	__kfifo_put(session->mgmtpool.queue, (void*)&conn->login_mtask,
+login_ctask_data_alloc_fail:
+	__kfifo_put(session->cmdpool.queue, (void*)&conn->login_ctask,
 		    sizeof(void*));
-login_mtask_alloc_fail:
+login_ctask_alloc_fail:
 	iscsi_destroy_conn(cls_conn);
 	return NULL;
 }
@@ -2146,7 +2118,7 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 	spin_lock_bh(&session->lock);
 	kfree(conn->data);
 	kfree(conn->persistent_address);
-	__kfifo_put(session->mgmtpool.queue, (void*)&conn->login_mtask,
+	__kfifo_put(session->cmdpool.queue, (void*)&conn->login_ctask,
 		    sizeof(void*));
 	if (session->leadconn == conn)
 		session->leadconn = NULL;
@@ -2227,21 +2199,23 @@ EXPORT_SYMBOL_GPL(iscsi_conn_start);
 static void
 flush_control_queues(struct iscsi_session *session, struct iscsi_conn *conn)
 {
-	struct iscsi_mgmt_task *mtask, *tmp;
+	struct iscsi_cmd_task *ctask, *tmp;
 
 	/* handle pending */
-	list_for_each_entry_safe(mtask, tmp, &conn->mgmtqueue, running) {
-		debug_scsi("flushing pending mgmt task itt 0x%x\n", mtask->itt);
-		iscsi_free_mgmt_task(conn, mtask);
+	list_for_each_entry_safe(ctask, tmp, &conn->mgmtqueue, running) {
+		debug_scsi("flushing pending mgmt ctask itt 0x%x\n", ctask->itt);
+		/* release ref from prep ctask */
+		__iscsi_put_ctask(ctask);
 	}
 
 	/* handle running */
-	list_for_each_entry_safe(mtask, tmp, &conn->mgmt_run_list, running) {
-		debug_scsi("flushing running mgmt task itt 0x%x\n", mtask->itt);
-		iscsi_free_mgmt_task(conn, mtask);
+	list_for_each_entry_safe(ctask, tmp, &conn->mgmt_run_list, running) {
+		debug_scsi("flushing running mgmt ctask itt 0x%x\n", ctask->itt);
+		/* release ref from prep ctask */
+		__iscsi_put_ctask(ctask);
 	}
 
-	conn->mtask = NULL;
+	conn->ctask = NULL;
 }
 
 static void iscsi_start_session_recovery(struct iscsi_session *session,
@@ -2272,7 +2246,7 @@ static void iscsi_start_session_recovery(struct iscsi_session *session,
 
 	/*
 	 * When this is called for the in_login state, we only want to clean
-	 * up the login task and connection. We do not need to block and set
+	 * up the login ctask and connection. We do not need to block and set
 	 * the recovery state again
 	 */
 	if (flag == STOP_CONN_TERM)
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 9be6a70..d1c3675 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -85,18 +85,6 @@ enum {
 	ISCSI_DIGEST_SIZE = sizeof(__u32),
 };
 
-struct iscsi_mgmt_task {
-	/*
-	 * Becuae LLDs allocate their hdr differently, this is a pointer to
-	 * that storage. It must be setup at session creation time.
-	 */
-	struct iscsi_hdr	*hdr;
-	char			*data;		/* mgmt payload */
-	unsigned		data_count;	/* counts data to be sent */
-	uint32_t		itt;		/* this ITT */
-	void			*dd_data;	/* driver/transport data */
-	struct list_head	running;
-};
 
 enum {
 	ISCSI_TASK_COMPLETED,
@@ -121,6 +109,7 @@ struct iscsi_cmd_task {
 	/* offset in unsolicited stream (bytes); */
 	unsigned		unsol_offset;
 	unsigned		data_count;	/* remaining Data-Out */
+	char			*data;		/* mgmt payload */
 	struct scsi_cmnd	*sc;		/* associated SCSI cmd*/
 	struct iscsi_conn	*conn;		/* used connection    */
 
@@ -162,7 +151,7 @@ struct iscsi_conn {
 	unsigned long		last_ping;
 	int			ping_timeout;
 	int			recv_timeout;
-	struct iscsi_mgmt_task	*ping_mtask;
+	struct iscsi_cmd_task 	*ping_ctask;
 
 	/* iSCSI connection-wide sequencing */
 	uint32_t		exp_statsn;
@@ -178,9 +167,8 @@ struct iscsi_conn {
 	 * should always fit in this buffer
 	 */
 	char			*data;
-	struct iscsi_mgmt_task	*login_mtask;	/* mtask used for login/text */
-	struct iscsi_mgmt_task	*mtask;		/* xmit mtask in progress */
-	struct iscsi_cmd_task	*ctask;		/* xmit ctask in progress */
+	struct iscsi_cmd_task 	*login_ctask;	/* mtask used for login/text */
+	struct iscsi_cmd_task	*ctask;		/* xmit task in progress */
 
 	/* xmit */
 	struct list_head	mgmtqueue;	/* mgmt (control) xmit queue */
@@ -295,12 +283,10 @@ struct iscsi_session {
 	int			state;		/* session state           */
 	int			age;		/* counts session re-opens */
 
+	int			scsi_cmds_max; 	/* max scsi commands */
 	int			cmds_max;	/* size of cmds array */
 	struct iscsi_cmd_task	**cmds;		/* Original Cmds arr */
 	struct iscsi_pool	cmdpool;	/* PDU's pool */
-	int			mgmtpool_max;	/* size of mgmt array */
-	struct iscsi_mgmt_task	**mgmt_cmds;	/* Original mgmt arr */
-	struct iscsi_pool	mgmtpool;	/* Mgmt PDU's pool */
 };
 
 struct iscsi_host {
@@ -345,7 +331,7 @@ extern void iscsi_host_free(struct Scsi_Host *shost);
  */
 extern struct iscsi_cls_session *
 iscsi_session_setup(struct iscsi_transport *, struct Scsi_Host *shost,
-		    uint16_t, int, int, uint32_t);
+		    uint16_t, int, uint32_t);
 extern void iscsi_session_teardown(struct iscsi_cls_session *);
 extern void iscsi_session_recovery_timedout(struct iscsi_cls_session *);
 extern int iscsi_set_param(struct iscsi_cls_conn *cls_conn,
@@ -388,8 +374,7 @@ extern int iscsi_complete_pdu(struct iscsi_conn *, struct iscsi_hdr *,
 extern int iscsi_verify_itt(struct iscsi_conn *, itt_t);
 extern struct iscsi_cmd_task *iscsi_itt_to_ctask(struct iscsi_conn *, itt_t);
 extern void iscsi_requeue_ctask(struct iscsi_cmd_task *ctask);
-extern void iscsi_free_mgmt_task(struct iscsi_conn *conn,
-				 struct iscsi_mgmt_task *mtask);
+extern void iscsi_put_ctask(struct iscsi_cmd_task *ctask);
 
 /*
  * generic helpers
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 4028f12..3f24503 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -34,7 +34,6 @@ struct Scsi_Host;
 struct iscsi_cls_conn;
 struct iscsi_conn;
 struct iscsi_cmd_task;
-struct iscsi_mgmt_task;
 struct sockaddr;
 
 /**
@@ -58,19 +57,22 @@ struct sockaddr;
  * @stop_conn:		suspend/recover/terminate connection
  * @send_pdu:		send iSCSI PDU, Login, Logout, NOP-Out, Reject, Text.
  * @session_recovery_timedout: notify LLD a block during recovery timed out
- * @init_cmd_task:	Initialize a iscsi_cmd_task and any internal structs.
- *			Called from queuecommand with session lock held.
- * @init_mgmt_task:	Initialize a iscsi_mgmt_task and any internal structs.
- *			Called from iscsi_conn_send_generic with xmitmutex.
- * @xmit_cmd_task:	Requests LLD to transfer cmd task. Returns 0 or the
+ * @init_task:		Initialize a iscsi_task and any internal structs.
+ *			When offloading the data path, this is called from
+ *			queuecommand with the session lock, or from the
+ *			iscsi_conn_send_pdu context with the session lock.
+ *			When not offloading the data path, this is called
+ *			from the scsi work queue without the session lock.
+ * @xmit_task		Requests LLD to transfer cmd task. Returns 0 or the
  *			the number of bytes transferred on success, and -Exyz
- *			value on error.
- * @xmit_mgmt_task:	Requests LLD to transfer mgmt task. Returns 0 or the
- *			the number of bytes transferred on success, and -Exyz
- *			value on error.
- * @cleanup_cmd_task:	requests LLD to fail cmd task. Called with xmitmutex
- *			and session->lock after the connection has been
- *			suspended and terminated during recovery. If called
+ *			value on error. When offloading the data path, this
+ *			is called from queuecommand with the session lock, or
+ *			from the iscsi_conn_send_pdu context with the session
+ *			lock. When not offloading the data path, this is called
+ *			from the scsi work queue without the session lock.
+ * @cleanup_task:	requests LLD to fail task. Called with session lock
+ *			and after the connection has been suspended and
+ *			terminated during recovery. If called
  *			from abort task then connection is not suspended
  *			or terminated but sk_callback_lock is held
  *
@@ -110,15 +112,10 @@ struct iscsi_transport {
 			 char *data, uint32_t data_size);
 	void (*get_stats) (struct iscsi_cls_conn *conn,
 			   struct iscsi_stats *stats);
-	int (*init_cmd_task) (struct iscsi_cmd_task *ctask);
-	void (*init_mgmt_task) (struct iscsi_conn *conn,
-				struct iscsi_mgmt_task *mtask);
-	int (*xmit_cmd_task) (struct iscsi_conn *conn,
-			      struct iscsi_cmd_task *ctask);
-	void (*cleanup_cmd_task) (struct iscsi_conn *conn,
-				  struct iscsi_cmd_task *ctask);
-	int (*xmit_mgmt_task) (struct iscsi_conn *conn,
-			       struct iscsi_mgmt_task *mtask);
+	int (*init_task) (struct iscsi_cmd_task *task);
+	int (*xmit_task) (struct iscsi_cmd_task *task);
+	void (*cleanup_task) (struct iscsi_conn *conn,
+				  struct iscsi_cmd_task *task);
 	void (*session_recovery_timedout) (struct iscsi_cls_session *session);
 	int (*ep_connect) (struct sockaddr *dst_addr, int non_blocking,
 			   uint64_t *ep_handle);
-- 
1.5.4.1

