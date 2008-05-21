From: michaelc@cs.wisc.edu
Subject: [PATCH 14/25] libiscsi: rename iscsi_cmd_task to iscsi_task
Date: Wed, 21 May 2008 15:54:09 -0500
Message-ID: <1211403260-5487-15-git-send-email-michaelc@cs.wisc.edu>
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
 <1211403260-5487-12-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-13-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-14-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936924AbYEUUyc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2008 16:54:32 -0400
In-Reply-To: <1211403260-5487-14-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This is the second part of the iscsi task merging, and
all it does it rename iscsi_cmd_task to iscsi_task and
mtask/ctask to just task.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c             |  514 ++++++++++++++++++-----------------
 include/scsi/libiscsi.h             |   22 +-
 include/scsi/scsi_transport_iscsi.h |    8 +-
 3 files changed, 273 insertions(+), 271 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index ef92b1b..92ee6d9 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -88,61 +88,61 @@ iscsi_update_cmdsn(struct iscsi_session *session, struct iscsi_nopin *hdr)
 }
 EXPORT_SYMBOL_GPL(iscsi_update_cmdsn);
 
-void iscsi_prep_unsolicit_data_pdu(struct iscsi_cmd_task *ctask,
+void iscsi_prep_unsolicit_data_pdu(struct iscsi_task *task,
 				   struct iscsi_data *hdr)
 {
-	struct iscsi_conn *conn = ctask->conn;
+	struct iscsi_conn *conn = task->conn;
 
 	memset(hdr, 0, sizeof(struct iscsi_data));
 	hdr->ttt = cpu_to_be32(ISCSI_RESERVED_TAG);
-	hdr->datasn = cpu_to_be32(ctask->unsol_datasn);
-	ctask->unsol_datasn++;
+	hdr->datasn = cpu_to_be32(task->unsol_datasn);
+	task->unsol_datasn++;
 	hdr->opcode = ISCSI_OP_SCSI_DATA_OUT;
-	memcpy(hdr->lun, ctask->hdr->lun, sizeof(hdr->lun));
+	memcpy(hdr->lun, task->hdr->lun, sizeof(hdr->lun));
 
-	hdr->itt = ctask->hdr->itt;
+	hdr->itt = task->hdr->itt;
 	hdr->exp_statsn = cpu_to_be32(conn->exp_statsn);
-	hdr->offset = cpu_to_be32(ctask->unsol_offset);
+	hdr->offset = cpu_to_be32(task->unsol_offset);
 
-	if (ctask->unsol_count > conn->max_xmit_dlength) {
+	if (task->unsol_count > conn->max_xmit_dlength) {
 		hton24(hdr->dlength, conn->max_xmit_dlength);
-		ctask->data_count = conn->max_xmit_dlength;
-		ctask->unsol_offset += ctask->data_count;
+		task->data_count = conn->max_xmit_dlength;
+		task->unsol_offset += task->data_count;
 		hdr->flags = 0;
 	} else {
-		hton24(hdr->dlength, ctask->unsol_count);
-		ctask->data_count = ctask->unsol_count;
+		hton24(hdr->dlength, task->unsol_count);
+		task->data_count = task->unsol_count;
 		hdr->flags = ISCSI_FLAG_CMD_FINAL;
 	}
 }
 EXPORT_SYMBOL_GPL(iscsi_prep_unsolicit_data_pdu);
 
-static int iscsi_add_hdr(struct iscsi_cmd_task *ctask, unsigned len)
+static int iscsi_add_hdr(struct iscsi_task *task, unsigned len)
 {
-	unsigned exp_len = ctask->hdr_len + len;
+	unsigned exp_len = task->hdr_len + len;
 
-	if (exp_len > ctask->hdr_max) {
+	if (exp_len > task->hdr_max) {
 		WARN_ON(1);
 		return -EINVAL;
 	}
 
 	WARN_ON(len & (ISCSI_PAD_LEN - 1)); /* caller must pad the AHS */
-	ctask->hdr_len = exp_len;
+	task->hdr_len = exp_len;
 	return 0;
 }
 
 /*
  * make an extended cdb AHS
  */
-static int iscsi_prep_ecdb_ahs(struct iscsi_cmd_task *ctask)
+static int iscsi_prep_ecdb_ahs(struct iscsi_task *task)
 {
-	struct scsi_cmnd *cmd = ctask->sc;
+	struct scsi_cmnd *cmd = task->sc;
 	unsigned rlen, pad_len;
 	unsigned short ahslength;
 	struct iscsi_ecdb_ahdr *ecdb_ahdr;
 	int rc;
 
-	ecdb_ahdr = iscsi_next_hdr(ctask);
+	ecdb_ahdr = iscsi_next_hdr(task);
 	rlen = cmd->cmd_len - ISCSI_CDB_SIZE;
 
 	BUG_ON(rlen > sizeof(ecdb_ahdr->ecdb));
@@ -150,7 +150,7 @@ static int iscsi_prep_ecdb_ahs(struct iscsi_cmd_task *ctask)
 
 	pad_len = iscsi_padding(rlen);
 
-	rc = iscsi_add_hdr(ctask, sizeof(ecdb_ahdr->ahslength) +
+	rc = iscsi_add_hdr(task, sizeof(ecdb_ahdr->ahslength) +
 	                   sizeof(ecdb_ahdr->ahstype) + ahslength + pad_len);
 	if (rc)
 		return rc;
@@ -165,19 +165,19 @@ static int iscsi_prep_ecdb_ahs(struct iscsi_cmd_task *ctask)
 
 	debug_scsi("iscsi_prep_ecdb_ahs: varlen_cdb_len %d "
 		   "rlen %d pad_len %d ahs_length %d iscsi_headers_size %u\n",
-		   cmd->cmd_len, rlen, pad_len, ahslength, ctask->hdr_len);
+		   cmd->cmd_len, rlen, pad_len, ahslength, task->hdr_len);
 
 	return 0;
 }
 
-static int iscsi_prep_bidi_ahs(struct iscsi_cmd_task *ctask)
+static int iscsi_prep_bidi_ahs(struct iscsi_task *task)
 {
-	struct scsi_cmnd *sc = ctask->sc;
+	struct scsi_cmnd *sc = task->sc;
 	struct iscsi_rlength_ahdr *rlen_ahdr;
 	int rc;
 
-	rlen_ahdr = iscsi_next_hdr(ctask);
-	rc = iscsi_add_hdr(ctask, sizeof(*rlen_ahdr));
+	rlen_ahdr = iscsi_next_hdr(task);
+	rc = iscsi_add_hdr(task, sizeof(*rlen_ahdr));
 	if (rc)
 		return rc;
 
@@ -197,28 +197,28 @@ static int iscsi_prep_bidi_ahs(struct iscsi_cmd_task *ctask)
 
 /**
  * iscsi_prep_scsi_cmd_pdu - prep iscsi scsi cmd pdu
- * @ctask: iscsi task
+ * @task: iscsi task
  *
  * Prep basic iSCSI PDU fields for a scsi cmd pdu. The LLD should set
  * fields like dlength or final based on how much data it sends
  */
-static int iscsi_prep_scsi_cmd_pdu(struct iscsi_cmd_task *ctask)
+static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 {
-	struct iscsi_conn *conn = ctask->conn;
+	struct iscsi_conn *conn = task->conn;
 	struct iscsi_session *session = conn->session;
-	struct iscsi_cmd *hdr = ctask->hdr;
-	struct scsi_cmnd *sc = ctask->sc;
+	struct iscsi_cmd *hdr = task->hdr;
+	struct scsi_cmnd *sc = task->sc;
 	unsigned hdrlength, cmd_len;
 	int rc;
 
-	ctask->hdr_len = 0;
-	rc = iscsi_add_hdr(ctask, sizeof(*hdr));
+	task->hdr_len = 0;
+	rc = iscsi_add_hdr(task, sizeof(*hdr));
 	if (rc)
 		return rc;
 	hdr->opcode = ISCSI_OP_SCSI_CMD;
 	hdr->flags = ISCSI_ATTR_SIMPLE;
 	int_to_scsilun(sc->device->lun, (struct scsi_lun *)hdr->lun);
-	hdr->itt = build_itt(ctask->itt, session->age);
+	hdr->itt = build_itt(task->itt, session->age);
 	hdr->cmdsn = cpu_to_be32(session->cmdsn);
 	session->cmdsn++;
 	hdr->exp_statsn = cpu_to_be32(conn->exp_statsn);
@@ -226,17 +226,17 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_cmd_task *ctask)
 	if (cmd_len < ISCSI_CDB_SIZE)
 		memset(&hdr->cdb[cmd_len], 0, ISCSI_CDB_SIZE - cmd_len);
 	else if (cmd_len > ISCSI_CDB_SIZE) {
-		rc = iscsi_prep_ecdb_ahs(ctask);
+		rc = iscsi_prep_ecdb_ahs(task);
 		if (rc)
 			return rc;
 		cmd_len = ISCSI_CDB_SIZE;
 	}
 	memcpy(hdr->cdb, sc->cmnd, cmd_len);
 
-	ctask->imm_count = 0;
+	task->imm_count = 0;
 	if (scsi_bidi_cmnd(sc)) {
 		hdr->flags |= ISCSI_FLAG_CMD_READ;
-		rc = iscsi_prep_bidi_ahs(ctask);
+		rc = iscsi_prep_bidi_ahs(task);
 		if (rc)
 			return rc;
 	}
@@ -258,28 +258,28 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_cmd_task *ctask)
 		 *
 		 *      pad_count       bytes to be sent as zero-padding
 		 */
-		ctask->unsol_count = 0;
-		ctask->unsol_offset = 0;
-		ctask->unsol_datasn = 0;
+		task->unsol_count = 0;
+		task->unsol_offset = 0;
+		task->unsol_datasn = 0;
 
 		if (session->imm_data_en) {
 			if (out_len >= session->first_burst)
-				ctask->imm_count = min(session->first_burst,
+				task->imm_count = min(session->first_burst,
 							conn->max_xmit_dlength);
 			else
-				ctask->imm_count = min(out_len,
+				task->imm_count = min(out_len,
 							conn->max_xmit_dlength);
-			hton24(hdr->dlength, ctask->imm_count);
+			hton24(hdr->dlength, task->imm_count);
 		} else
 			zero_data(hdr->dlength);
 
 		if (!session->initial_r2t_en) {
-			ctask->unsol_count = min(session->first_burst, out_len)
-							     - ctask->imm_count;
-			ctask->unsol_offset = ctask->imm_count;
+			task->unsol_count = min(session->first_burst, out_len)
+							     - task->imm_count;
+			task->unsol_offset = task->imm_count;
 		}
 
-		if (!ctask->unsol_count)
+		if (!task->unsol_count)
 			/* No unsolicit Data-Out's */
 			hdr->flags |= ISCSI_FLAG_CMD_FINAL;
 	} else {
@@ -292,7 +292,7 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_cmd_task *ctask)
 	}
 
 	/* calculate size of additional header segments (AHSs) */
-	hdrlength = ctask->hdr_len - sizeof(*hdr);
+	hdrlength = task->hdr_len - sizeof(*hdr);
 
 	WARN_ON(hdrlength & (ISCSI_PAD_LEN-1));
 	hdrlength /= ISCSI_PAD_LEN;
@@ -301,17 +301,17 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_cmd_task *ctask)
 	hdr->hlength = hdrlength & 0xFF;
 
 	if (conn->session->tt->init_task &&
-	    conn->session->tt->init_task(ctask))
+	    conn->session->tt->init_task(task))
 		return -EIO;
 
-	ctask->state = ISCSI_TASK_RUNNING;
-	list_move_tail(&ctask->running, &conn->run_list);
+	task->state = ISCSI_TASK_RUNNING;
+	list_move_tail(&task->running, &conn->run_list);
 
 	conn->scsicmd_pdus_cnt++;
 	debug_scsi("iscsi prep [%s cid %d sc %p cdb 0x%x itt 0x%x len %d "
 		   "bidi_len %d cmdsn %d win %d]\n", scsi_bidi_cmnd(sc) ?
 		   "bidirectional" : sc->sc_data_direction == DMA_TO_DEVICE ?
-		   "write" : "read", conn->id, sc, sc->cmnd[0], ctask->itt,
+		   "write" : "read", conn->id, sc, sc->cmnd[0], task->itt,
 		   scsi_bufflen(sc),
 		   scsi_bidi_cmnd(sc) ? scsi_in(sc)->length : 0,
 		   session->cmdsn, session->max_cmdsn - session->exp_cmdsn + 1);
@@ -320,37 +320,37 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_cmd_task *ctask)
 
 /**
  * iscsi_complete_command - finish a task
- * @ctask: iscsi cmd task
+ * @task: iscsi cmd task
  *
  * Must be called with session lock.
  * This function returns the scsi command to scsi-ml or cleans
  * up mgmt tasks then returns the task to the pool.
  */
-static void iscsi_complete_command(struct iscsi_cmd_task *ctask)
+static void iscsi_complete_command(struct iscsi_task *task)
 {
-	struct iscsi_conn *conn = ctask->conn;
+	struct iscsi_conn *conn = task->conn;
 	struct iscsi_session *session = conn->session;
-	struct scsi_cmnd *sc = ctask->sc;
+	struct scsi_cmnd *sc = task->sc;
 
-	list_del_init(&ctask->running);
-	ctask->state = ISCSI_TASK_COMPLETED;
-	ctask->sc = NULL;
+	list_del_init(&task->running);
+	task->state = ISCSI_TASK_COMPLETED;
+	task->sc = NULL;
 
-	if (conn->ctask == ctask)
-		conn->ctask = NULL;
+	if (conn->task == task)
+		conn->task = NULL;
 	/*
-	 * login ctask is preallocated so do not free
+	 * login task is preallocated so do not free
 	 */
-	if (conn->login_ctask == ctask)
+	if (conn->login_task == task)
 		return;
 
-	__kfifo_put(session->cmdpool.queue, (void*)&ctask, sizeof(void*));
+	__kfifo_put(session->cmdpool.queue, (void*)&task, sizeof(void*));
 
-	if (conn->ping_ctask == ctask)
-		conn->ping_ctask = NULL;
+	if (conn->ping_task == task)
+		conn->ping_task = NULL;
 
 	if (sc) {
-		ctask->sc = NULL;
+		task->sc = NULL;
 		/* SCSI eh reuses commands to verify us */
 		sc->SCp.ptr = NULL;
 		/*
@@ -362,47 +362,47 @@ static void iscsi_complete_command(struct iscsi_cmd_task *ctask)
 	}
 }
 
-static void __iscsi_get_ctask(struct iscsi_cmd_task *ctask)
+static void __iscsi_get_task(struct iscsi_task *task)
 {
-	atomic_inc(&ctask->refcount);
+	atomic_inc(&task->refcount);
 }
 
-static void __iscsi_put_ctask(struct iscsi_cmd_task *ctask)
+static void __iscsi_put_task(struct iscsi_task *task)
 {
-	if (atomic_dec_and_test(&ctask->refcount))
-		iscsi_complete_command(ctask);
+	if (atomic_dec_and_test(&task->refcount))
+		iscsi_complete_command(task);
 }
 
-void iscsi_put_ctask(struct iscsi_cmd_task *ctask)
+void iscsi_put_task(struct iscsi_task *task)
 {
-	struct iscsi_session *session = ctask->conn->session;
+	struct iscsi_session *session = task->conn->session;
 
 	spin_lock_bh(&session->lock);
-	__iscsi_put_ctask(ctask);
+	__iscsi_put_task(task);
 	spin_unlock_bh(&session->lock);
 }
-EXPORT_SYMBOL_GPL(iscsi_put_ctask);
+EXPORT_SYMBOL_GPL(iscsi_put_task);
 
 /*
  * session lock must be held
  */
-static void fail_command(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
+static void fail_command(struct iscsi_conn *conn, struct iscsi_task *task,
 			 int err)
 {
 	struct scsi_cmnd *sc;
 
-	sc = ctask->sc;
+	sc = task->sc;
 	if (!sc)
 		return;
 
-	if (ctask->state == ISCSI_TASK_PENDING)
+	if (task->state == ISCSI_TASK_PENDING)
 		/*
 		 * cmd never made it to the xmit thread, so we should not count
 		 * the cmd in the sequencing
 		 */
 		conn->session->queued_cmdsn--;
 	else
-		conn->session->tt->cleanup_task(conn, ctask);
+		conn->session->tt->cleanup_task(conn, task);
 
 	sc->result = err;
 
@@ -413,17 +413,17 @@ static void fail_command(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
 		scsi_in(sc)->resid = scsi_in(sc)->length;
 	}
 
-	if (conn->ctask == ctask)
-		conn->ctask = NULL;
+	if (conn->task == task)
+		conn->task = NULL;
 	/* release ref from queuecommand */
-	__iscsi_put_ctask(ctask);
+	__iscsi_put_task(task);
 }
 
 static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
-				struct iscsi_cmd_task *ctask)
+				struct iscsi_task *task)
 {
 	struct iscsi_session *session = conn->session;
-	struct iscsi_hdr *hdr = (struct iscsi_hdr *)ctask->hdr;
+	struct iscsi_hdr *hdr = (struct iscsi_hdr *)task->hdr;
 	struct iscsi_nopout *nop = (struct iscsi_nopout *)hdr;
 
 	if (conn->session->state == ISCSI_STATE_LOGGING_OUT)
@@ -437,7 +437,7 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
 	 */
 	nop->cmdsn = cpu_to_be32(session->cmdsn);
 	if (hdr->itt != RESERVED_ITT) {
-		hdr->itt = build_itt(ctask->itt, session->age);
+		hdr->itt = build_itt(task->itt, session->age);
 		/*
 		 * TODO: We always use immediate, so we never hit this.
 		 * If we start to send tmfs or nops as non-immediate then
@@ -451,24 +451,24 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
 	}
 
 	if (session->tt->init_task)
-		session->tt->init_task(ctask);
+		session->tt->init_task(task);
 
 	if ((hdr->opcode & ISCSI_OPCODE_MASK) == ISCSI_OP_LOGOUT)
 		session->state = ISCSI_STATE_LOGGING_OUT;
 
-	list_move_tail(&ctask->running, &conn->mgmt_run_list);
+	list_move_tail(&task->running, &conn->mgmt_run_list);
 	debug_scsi("mgmtpdu [op 0x%x hdr->itt 0x%x datalen %d]\n",
 		   hdr->opcode & ISCSI_OPCODE_MASK, hdr->itt,
-		   ctask->data_count);
+		   task->data_count);
 	return 0;
 }
 
-static struct iscsi_cmd_task *
+static struct iscsi_task *
 __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		      char *data, uint32_t data_size)
 {
 	struct iscsi_session *session = conn->session;
-	struct iscsi_cmd_task *ctask;
+	struct iscsi_task *task;
 
 	if (session->state == ISCSI_STATE_TERMINATE)
 		return NULL;
@@ -481,18 +481,18 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		 * Same task can be used. Same ITT must be used.
 		 * Note that login_task is preallocated at conn_create().
 		 */
-		ctask = conn->login_ctask;
+		task = conn->login_task;
 	else {
 		BUG_ON(conn->c_stage == ISCSI_CONN_INITIAL_STAGE);
 		BUG_ON(conn->c_stage == ISCSI_CONN_STOPPED);
 
 		if (!__kfifo_get(session->cmdpool.queue,
-				 (void*)&ctask, sizeof(void*)))
+				 (void*)&task, sizeof(void*)))
 			return NULL;
 
 		if ((hdr->opcode == (ISCSI_OP_NOOP_OUT | ISCSI_OP_IMMEDIATE)) &&
 		     hdr->ttt == RESERVED_ITT) {
-			conn->ping_ctask = ctask;
+			conn->ping_task = task;
 			conn->last_ping = jiffies;
 		}
 	}
@@ -501,33 +501,33 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	 * released by the lld when it has transmitted the task for
 	 * pdus we do not expect a response for.
 	 */
-	atomic_set(&ctask->refcount, 1);
-	ctask->conn = conn;
-	ctask->sc = NULL;
+	atomic_set(&task->refcount, 1);
+	task->conn = conn;
+	task->sc = NULL;
 
 	if (data_size) {
-		memcpy(ctask->data, data, data_size);
-		ctask->data_count = data_size;
+		memcpy(task->data, data, data_size);
+		task->data_count = data_size;
 	} else
-		ctask->data_count = 0;
+		task->data_count = 0;
 
-	memcpy(ctask->hdr, hdr, sizeof(struct iscsi_hdr));
-	INIT_LIST_HEAD(&ctask->running);
-	list_add_tail(&ctask->running, &conn->mgmtqueue);
+	memcpy(task->hdr, hdr, sizeof(struct iscsi_hdr));
+	INIT_LIST_HEAD(&task->running);
+	list_add_tail(&task->running, &conn->mgmtqueue);
 
 	if (session->tt->caps & CAP_DATA_PATH_OFFLOAD) {
-		if (iscsi_prep_mgmt_task(conn, ctask)) {
-			__iscsi_put_ctask(ctask);
+		if (iscsi_prep_mgmt_task(conn, task)) {
+			__iscsi_put_task(task);
 			return NULL;
 		}
 
-		if (session->tt->xmit_task(ctask))
-			ctask = NULL;
+		if (session->tt->xmit_task(task))
+			task = NULL;
 
 	} else
 		scsi_queue_work(conn->session->host, &conn->xmitwork);
 
-	return ctask;
+	return task;
 }
 
 int iscsi_conn_send_pdu(struct iscsi_cls_conn *cls_conn, struct iscsi_hdr *hdr,
@@ -549,20 +549,20 @@ EXPORT_SYMBOL_GPL(iscsi_conn_send_pdu);
  * iscsi_cmd_rsp - SCSI Command Response processing
  * @conn: iscsi connection
  * @hdr: iscsi header
- * @ctask: scsi command task
+ * @task: scsi command task
  * @data: cmd data buffer
  * @datalen: len of buffer
  *
  * iscsi_cmd_rsp sets up the scsi_cmnd fields based on the PDU and
- * then completes the command and ctask.
+ * then completes the command and task.
  **/
 static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
-			       struct iscsi_cmd_task *ctask, char *data,
+			       struct iscsi_task *task, char *data,
 			       int datalen)
 {
 	struct iscsi_cmd_rsp *rhdr = (struct iscsi_cmd_rsp *)hdr;
 	struct iscsi_session *session = conn->session;
-	struct scsi_cmnd *sc = ctask->sc;
+	struct scsi_cmnd *sc = task->sc;
 
 	iscsi_update_cmdsn(session, (struct iscsi_nopin*)rhdr);
 	conn->exp_statsn = be32_to_cpu(rhdr->statsn) + 1;
@@ -622,10 +622,10 @@ invalid_datalen:
 	}
 out:
 	debug_scsi("done [sc %lx res %d itt 0x%x]\n",
-		   (long)sc, sc->result, ctask->itt);
+		   (long)sc, sc->result, task->itt);
 	conn->scsirsp_pdus_cnt++;
 
-	__iscsi_put_ctask(ctask);
+	__iscsi_put_task(task);
 }
 
 static void iscsi_tmf_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
@@ -650,9 +650,9 @@ static void iscsi_tmf_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 static void iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
 {
         struct iscsi_nopout hdr;
-	struct iscsi_cmd_task *ctask;
+	struct iscsi_task *task;
 
-	if (!rhdr && conn->ping_ctask)
+	if (!rhdr && conn->ping_task)
 		return;
 
 	memset(&hdr, 0, sizeof(struct iscsi_nopout));
@@ -666,8 +666,8 @@ static void iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
 	} else
 		hdr.ttt = RESERVED_ITT;
 
-	ctask = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)&hdr, NULL, 0);
-	if (!ctask)
+	task = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)&hdr, NULL, 0);
+	if (!task)
 		iscsi_conn_printk(KERN_ERR, conn, "Could not send nopout\n");
 }
 
@@ -712,7 +712,7 @@ static int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 {
 	struct iscsi_session *session = conn->session;
 	int opcode = hdr->opcode & ISCSI_OPCODE_MASK, rc = 0;
-	struct iscsi_cmd_task *ctask;
+	struct iscsi_task *task;
 	uint32_t itt;
 
 	conn->last_recv = jiffies;
@@ -758,27 +758,27 @@ static int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		goto out;
 	}
 
-	ctask = session->cmds[itt];
+	task = session->cmds[itt];
 	switch(opcode) {
 	case ISCSI_OP_SCSI_CMD_RSP:
-		if (!ctask->sc) {
+		if (!task->sc) {
 			rc = ISCSI_ERR_NO_SCSI_CMD;
 			break;
 		}
-		BUG_ON((void*)ctask != ctask->sc->SCp.ptr);
-		iscsi_scsi_cmd_rsp(conn, hdr, ctask, data, datalen);
+		BUG_ON((void*)task != task->sc->SCp.ptr);
+		iscsi_scsi_cmd_rsp(conn, hdr, task, data, datalen);
 		break;
 	case ISCSI_OP_SCSI_DATA_IN:
-		if (!ctask->sc) {
+		if (!task->sc) {
 			rc = ISCSI_ERR_NO_SCSI_CMD;
 			break;
 		}
-		BUG_ON((void*)ctask != ctask->sc->SCp.ptr);
+		BUG_ON((void*)task != task->sc->SCp.ptr);
 		if (hdr->flags & ISCSI_FLAG_DATA_STATUS) {
 			conn->scsirsp_pdus_cnt++;
 			iscsi_update_cmdsn(session,
 					   (struct iscsi_nopin*) hdr);
-			__iscsi_put_ctask(ctask);
+			__iscsi_put_task(task);
 		}
 		break;
 	case ISCSI_OP_R2T:
@@ -808,7 +808,7 @@ static int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		}
 
 		iscsi_tmf_rsp(conn, hdr);
-		__iscsi_put_ctask(ctask);
+		__iscsi_put_task(task);
 		break;
 	case ISCSI_OP_NOOP_IN:
 		iscsi_update_cmdsn(session, (struct iscsi_nopin*)hdr);
@@ -818,13 +818,15 @@ static int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		}
 		conn->exp_statsn = be32_to_cpu(hdr->statsn) + 1;
 
-		if (conn->ping_ctask != ctask)
+		if (conn->ping_task != task)
 			/*
 			 * If this is not in response to one of our
 			 * nops then it must be from userspace.
 			 */
 			goto recv_pdu;
-		__iscsi_put_ctask(ctask);
+
+		mod_timer(&conn->transport_timer, jiffies + conn->recv_timeout);
+		__iscsi_put_task(task);
 		break;
 	default:
 		rc = ISCSI_ERR_BAD_OPCODE;
@@ -836,7 +838,7 @@ out:
 recv_pdu:
 	if (iscsi_recv_pdu(conn->cls_conn, hdr, data, datalen))
 		rc = ISCSI_ERR_CONN_FAILED;
-	__iscsi_put_ctask(ctask);
+	__iscsi_put_task(task);
 	return rc;
 }
 
@@ -855,7 +857,7 @@ EXPORT_SYMBOL_GPL(iscsi_complete_pdu);
 int iscsi_verify_itt(struct iscsi_conn *conn, itt_t itt)
 {
 	struct iscsi_session *session = conn->session;
-	struct iscsi_cmd_task *ctask;
+	struct iscsi_task *task;
 	uint32_t i;
 
 	if (itt == RESERVED_ITT)
@@ -878,11 +880,11 @@ int iscsi_verify_itt(struct iscsi_conn *conn, itt_t itt)
 		return ISCSI_ERR_BAD_ITT;
 	}
 
-	ctask = session->cmds[i];
-	if (ctask->sc && ctask->sc->SCp.phase != session->age) {
+	task = session->cmds[i];
+	if (task->sc && task->sc->SCp.phase != session->age) {
 		iscsi_conn_printk(KERN_ERR, conn,
-				  "iscsi: ctask's session age %d, "
-				  "expected %d\n", ctask->sc->SCp.phase,
+				  "iscsi: task's session age %d, "
+				  "expected %d\n", task->sc->SCp.phase,
 				  session->age);
 		return ISCSI_ERR_SESSION_FAILED;
 	}
@@ -890,11 +892,11 @@ int iscsi_verify_itt(struct iscsi_conn *conn, itt_t itt)
 }
 EXPORT_SYMBOL_GPL(iscsi_verify_itt);
 
-struct iscsi_cmd_task *
+struct iscsi_task *
 iscsi_itt_to_ctask(struct iscsi_conn *conn, itt_t itt)
 {
 	struct iscsi_session *session = conn->session;
-	struct iscsi_cmd_task *ctask;
+	struct iscsi_task *task;
 	uint32_t i;
 
 	if (iscsi_verify_itt(conn, itt))
@@ -907,14 +909,14 @@ iscsi_itt_to_ctask(struct iscsi_conn *conn, itt_t itt)
 	if (i >= session->cmds_max)
 		return NULL;
 
-	ctask = session->cmds[i];
-	if (!ctask->sc)
+	task = session->cmds[i];
+	if (!task->sc)
 		return NULL;
 
-	if (ctask->sc->SCp.phase != session->age)
+	if (task->sc->SCp.phase != session->age)
 		return NULL;
 
-	return ctask;
+	return task;
 }
 EXPORT_SYMBOL_GPL(iscsi_itt_to_ctask);
 
@@ -955,38 +957,38 @@ static int iscsi_check_cmdsn_window_closed(struct iscsi_conn *conn)
 	return 0;
 }
 
-static int iscsi_xmit_ctask(struct iscsi_conn *conn)
+static int iscsi_xmit_task(struct iscsi_conn *conn)
 {
-	struct iscsi_cmd_task *ctask = conn->ctask;
+	struct iscsi_task *task = conn->task;
 	int rc;
 
-	__iscsi_get_ctask(ctask);
+	__iscsi_get_task(task);
 	spin_unlock_bh(&conn->session->lock);
-	rc = conn->session->tt->xmit_task(ctask);
+	rc = conn->session->tt->xmit_task(task);
 	spin_lock_bh(&conn->session->lock);
-	__iscsi_put_ctask(ctask);
+	__iscsi_put_task(task);
 	if (!rc)
-		/* done with this ctask */
-		conn->ctask = NULL;
+		/* done with this task */
+		conn->task = NULL;
 	return rc;
 }
 
 /**
- * iscsi_requeue_ctask - requeue ctask to run from session workqueue
- * @ctask: ctask to requeue
+ * iscsi_requeue_task - requeue task to run from session workqueue
+ * @task: task to requeue
  *
- * LLDs that need to run a ctask from the session workqueue should call
+ * LLDs that need to run a task from the session workqueue should call
  * this. The session lock must be held. This should only be called
  * by software drivers.
  */
-void iscsi_requeue_ctask(struct iscsi_cmd_task *ctask)
+void iscsi_requeue_task(struct iscsi_task *task)
 {
-	struct iscsi_conn *conn = ctask->conn;
+	struct iscsi_conn *conn = task->conn;
 
-	list_move_tail(&ctask->running, &conn->requeue);
+	list_move_tail(&task->running, &conn->requeue);
 	scsi_queue_work(conn->session->host, &conn->xmitwork);
 }
-EXPORT_SYMBOL_GPL(iscsi_requeue_ctask);
+EXPORT_SYMBOL_GPL(iscsi_requeue_task);
 
 /**
  * iscsi_data_xmit - xmit any command into the scheduled connection
@@ -1008,8 +1010,8 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 		return -ENODATA;
 	}
 
-	if (conn->ctask) {
-		rc = iscsi_xmit_ctask(conn);
+	if (conn->task) {
+		rc = iscsi_xmit_task(conn);
 	        if (rc)
 		        goto again;
 	}
@@ -1021,14 +1023,14 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 	 */
 check_mgmt:
 	while (!list_empty(&conn->mgmtqueue)) {
-		conn->ctask = list_entry(conn->mgmtqueue.next,
-					 struct iscsi_cmd_task, running);
-		if (iscsi_prep_mgmt_task(conn, conn->ctask)) {
-			__iscsi_put_ctask(conn->ctask);
-			conn->ctask = NULL;
+		conn->task = list_entry(conn->mgmtqueue.next,
+					 struct iscsi_task, running);
+		if (iscsi_prep_mgmt_task(conn, conn->task)) {
+			__iscsi_put_task(conn->task);
+			conn->task = NULL;
 			continue;
 		}
-		rc = iscsi_xmit_ctask(conn);
+		rc = iscsi_xmit_task(conn);
 		if (rc)
 			goto again;
 	}
@@ -1038,21 +1040,21 @@ check_mgmt:
 		if (conn->tmf_state == TMF_QUEUED)
 			break;
 
-		conn->ctask = list_entry(conn->xmitqueue.next,
-					 struct iscsi_cmd_task, running);
+		conn->task = list_entry(conn->xmitqueue.next,
+					 struct iscsi_task, running);
 		if (conn->session->state == ISCSI_STATE_LOGGING_OUT) {
-			fail_command(conn, conn->ctask, DID_IMM_RETRY << 16);
+			fail_command(conn, conn->task, DID_IMM_RETRY << 16);
 			continue;
 		}
-		if (iscsi_prep_scsi_cmd_pdu(conn->ctask)) {
-			fail_command(conn, conn->ctask, DID_ABORT << 16);
+		if (iscsi_prep_scsi_cmd_pdu(conn->task)) {
+			fail_command(conn, conn->task, DID_ABORT << 16);
 			continue;
 		}
-		rc = iscsi_xmit_ctask(conn);
+		rc = iscsi_xmit_task(conn);
 		if (rc)
 			goto again;
 		/*
-		 * we could continuously get new ctask requests so
+		 * we could continuously get new task requests so
 		 * we need to check the mgmt queue for nops that need to
 		 * be sent to aviod starvation
 		 */
@@ -1070,11 +1072,11 @@ check_mgmt:
 		if (conn->session->state == ISCSI_STATE_LOGGING_OUT)
 			break;
 
-		conn->ctask = list_entry(conn->requeue.next,
-					 struct iscsi_cmd_task, running);
-		conn->ctask->state = ISCSI_TASK_RUNNING;
+		conn->task = list_entry(conn->requeue.next,
+					 struct iscsi_task, running);
+		conn->task->state = ISCSI_TASK_RUNNING;
 		list_move_tail(conn->requeue.next, &conn->run_list);
-		rc = iscsi_xmit_ctask(conn);
+		rc = iscsi_xmit_task(conn);
 		if (rc)
 			goto again;
 		if (!list_empty(&conn->mgmtqueue))
@@ -1123,7 +1125,7 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 	int reason = 0;
 	struct iscsi_session *session;
 	struct iscsi_conn *conn;
-	struct iscsi_cmd_task *ctask = NULL;
+	struct iscsi_task *task = NULL;
 
 	sc->scsi_done = done;
 	sc->result = 0;
@@ -1191,31 +1193,31 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 		goto reject;
 	}
 
-	if (!__kfifo_get(session->cmdpool.queue, (void*)&ctask,
+	if (!__kfifo_get(session->cmdpool.queue, (void*)&task,
 			 sizeof(void*))) {
 		reason = FAILURE_OOM;
 		goto reject;
 	}
 	sc->SCp.phase = session->age;
-	sc->SCp.ptr = (char *)ctask;
+	sc->SCp.ptr = (char *)task;
 
-	atomic_set(&ctask->refcount, 1);
-	ctask->state = ISCSI_TASK_PENDING;
-	ctask->conn = conn;
-	ctask->sc = sc;
-	INIT_LIST_HEAD(&ctask->running);
-	list_add_tail(&ctask->running, &conn->xmitqueue);
+	atomic_set(&task->refcount, 1);
+	task->state = ISCSI_TASK_PENDING;
+	task->conn = conn;
+	task->sc = sc;
+	INIT_LIST_HEAD(&task->running);
+	list_add_tail(&task->running, &conn->xmitqueue);
 
 	if (session->tt->caps & CAP_DATA_PATH_OFFLOAD) {
-		if (iscsi_prep_scsi_cmd_pdu(ctask)) {
+		if (iscsi_prep_scsi_cmd_pdu(task)) {
 			sc->result = DID_ABORT << 16;
 			sc->scsi_done = NULL;
-			iscsi_complete_command(ctask);
+			iscsi_complete_command(task);
 			goto fault;
 		}
-		if (session->tt->xmit_task(ctask)) {
+		if (session->tt->xmit_task(task)) {
 			sc->scsi_done = NULL;
-			iscsi_complete_command(ctask);
+			iscsi_complete_command(task);
 			reason = FAILURE_SESSION_NOT_READY;
 			goto reject;
 		}
@@ -1336,16 +1338,16 @@ static void iscsi_tmf_timedout(unsigned long data)
 	spin_unlock(&session->lock);
 }
 
-static int iscsi_exec_ctask_mgmt_fn(struct iscsi_conn *conn,
+static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
 				   struct iscsi_tm *hdr, int age,
 				   int timeout)
 {
 	struct iscsi_session *session = conn->session;
-	struct iscsi_cmd_task *ctask;
+	struct iscsi_task *task;
 
-	ctask = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)hdr,
+	task = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)hdr,
 				      NULL, 0);
-	if (!ctask) {
+	if (!task) {
 		spin_unlock_bh(&session->lock);
 		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
 		spin_lock_bh(&session->lock);
@@ -1379,7 +1381,7 @@ static int iscsi_exec_ctask_mgmt_fn(struct iscsi_conn *conn,
 
 	mutex_lock(&session->eh_mutex);
 	spin_lock_bh(&session->lock);
-	/* if the session drops it will clean up the ctask */
+	/* if the session drops it will clean up the task */
 	if (age != session->age ||
 	    session->state != ISCSI_STATE_LOGGED_IN)
 		return -ENOTCONN;
@@ -1393,34 +1395,34 @@ static int iscsi_exec_ctask_mgmt_fn(struct iscsi_conn *conn,
 static void fail_all_commands(struct iscsi_conn *conn, unsigned lun,
 			      int error)
 {
-	struct iscsi_cmd_task *ctask, *tmp;
+	struct iscsi_task *task, *tmp;
 
-	if (conn->ctask && (conn->ctask->sc->device->lun == lun || lun == -1))
-		conn->ctask = NULL;
+	if (conn->task && (conn->task->sc->device->lun == lun || lun == -1))
+		conn->task = NULL;
 
 	/* flush pending */
-	list_for_each_entry_safe(ctask, tmp, &conn->xmitqueue, running) {
-		if (lun == ctask->sc->device->lun || lun == -1) {
+	list_for_each_entry_safe(task, tmp, &conn->xmitqueue, running) {
+		if (lun == task->sc->device->lun || lun == -1) {
 			debug_scsi("failing pending sc %p itt 0x%x\n",
-				   ctask->sc, ctask->itt);
-			fail_command(conn, ctask, error << 16);
+				   task->sc, task->itt);
+			fail_command(conn, task, error << 16);
 		}
 	}
 
-	list_for_each_entry_safe(ctask, tmp, &conn->requeue, running) {
-		if (lun == ctask->sc->device->lun || lun == -1) {
+	list_for_each_entry_safe(task, tmp, &conn->requeue, running) {
+		if (lun == task->sc->device->lun || lun == -1) {
 			debug_scsi("failing requeued sc %p itt 0x%x\n",
-				   ctask->sc, ctask->itt);
-			fail_command(conn, ctask, error << 16);
+				   task->sc, task->itt);
+			fail_command(conn, task, error << 16);
 		}
 	}
 
 	/* fail all other running */
-	list_for_each_entry_safe(ctask, tmp, &conn->run_list, running) {
-		if (lun == ctask->sc->device->lun || lun == -1) {
+	list_for_each_entry_safe(task, tmp, &conn->run_list, running) {
+		if (lun == task->sc->device->lun || lun == -1) {
 			debug_scsi("failing in progress sc %p itt 0x%x\n",
-				   ctask->sc, ctask->itt);
-			fail_command(conn, ctask, DID_BUS_BUSY << 16);
+				   task->sc, task->itt);
+			fail_command(conn, task, DID_BUS_BUSY << 16);
 		}
 	}
 }
@@ -1486,7 +1488,7 @@ static enum scsi_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *scmd)
 			   jiffies))
 		rc = EH_RESET_TIMER;
 	/* if in the middle of checking the transport then give us more time */
-	if (conn->ping_ctask)
+	if (conn->ping_task)
 		rc = EH_RESET_TIMER;
 done:
 	spin_unlock(&session->lock);
@@ -1510,7 +1512,7 @@ static void iscsi_check_transport_timeouts(unsigned long data)
 
 	recv_timeout *= HZ;
 	last_recv = conn->last_recv;
-	if (conn->ping_ctask &&
+	if (conn->ping_task &&
 	    time_before_eq(conn->last_ping + (conn->ping_timeout * HZ),
 			   jiffies)) {
 		iscsi_conn_printk(KERN_ERR, conn, "ping timeout of %d secs "
@@ -1536,16 +1538,16 @@ done:
 	spin_unlock(&session->lock);
 }
 
-static void iscsi_prep_abort_ctask_pdu(struct iscsi_cmd_task *ctask,
+static void iscsi_prep_abort_task_pdu(struct iscsi_task *task,
 				      struct iscsi_tm *hdr)
 {
 	memset(hdr, 0, sizeof(*hdr));
 	hdr->opcode = ISCSI_OP_SCSI_TMFUNC | ISCSI_OP_IMMEDIATE;
 	hdr->flags = ISCSI_TM_FUNC_ABORT_TASK & ISCSI_FLAG_TM_FUNC_MASK;
 	hdr->flags |= ISCSI_FLAG_CMD_FINAL;
-	memcpy(hdr->lun, ctask->hdr->lun, sizeof(hdr->lun));
-	hdr->rtt = ctask->hdr->itt;
-	hdr->refcmdsn = ctask->hdr->cmdsn;
+	memcpy(hdr->lun, task->hdr->lun, sizeof(hdr->lun));
+	hdr->rtt = task->hdr->itt;
+	hdr->refcmdsn = task->hdr->cmdsn;
 }
 
 int iscsi_eh_abort(struct scsi_cmnd *sc)
@@ -1553,7 +1555,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	struct iscsi_cls_session *cls_session;
 	struct iscsi_session *session;
 	struct iscsi_conn *conn;
-	struct iscsi_cmd_task *ctask;
+	struct iscsi_task *task;
 	struct iscsi_tm *hdr;
 	int rc, age;
 
@@ -1588,17 +1590,17 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	conn->eh_abort_cnt++;
 	age = session->age;
 
-	ctask = (struct iscsi_cmd_task *)sc->SCp.ptr;
-	debug_scsi("aborting [sc %p itt 0x%x]\n", sc, ctask->itt);
+	task = (struct iscsi_task *)sc->SCp.ptr;
+	debug_scsi("aborting [sc %p itt 0x%x]\n", sc, task->itt);
 
-	/* ctask completed before time out */
-	if (!ctask->sc) {
+	/* task completed before time out */
+	if (!task->sc) {
 		debug_scsi("sc completed while abort in progress\n");
 		goto success;
 	}
 
-	if (ctask->state == ISCSI_TASK_PENDING) {
-		fail_command(conn, ctask, DID_ABORT << 16);
+	if (task->state == ISCSI_TASK_PENDING) {
+		fail_command(conn, task, DID_ABORT << 16);
 		goto success;
 	}
 
@@ -1608,9 +1610,9 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	conn->tmf_state = TMF_QUEUED;
 
 	hdr = &conn->tmhdr;
-	iscsi_prep_abort_ctask_pdu(ctask, hdr);
+	iscsi_prep_abort_task_pdu(task, hdr);
 
-	if (iscsi_exec_ctask_mgmt_fn(conn, hdr, age, session->abort_timeout)) {
+	if (iscsi_exec_task_mgmt_fn(conn, hdr, age, session->abort_timeout)) {
 		rc = FAILED;
 		goto failed;
 	}
@@ -1620,11 +1622,11 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		spin_unlock_bh(&session->lock);
 		iscsi_suspend_tx(conn);
 		/*
-		 * clean up ctask if aborted. grab the recv lock as a writer
+		 * clean up task if aborted. grab the recv lock as a writer
 		 */
 		write_lock_bh(conn->recv_lock);
 		spin_lock(&session->lock);
-		fail_command(conn, ctask, DID_ABORT << 16);
+		fail_command(conn, task, DID_ABORT << 16);
 		conn->tmf_state = TMF_INITIAL;
 		spin_unlock(&session->lock);
 		write_unlock_bh(conn->recv_lock);
@@ -1637,7 +1639,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	case TMF_NOT_FOUND:
 		if (!sc->SCp.ptr) {
 			conn->tmf_state = TMF_INITIAL;
-			/* ctask completed before tmf abort response */
+			/* task completed before tmf abort response */
 			debug_scsi("sc completed while abort in progress\n");
 			goto success;
 		}
@@ -1650,7 +1652,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 success:
 	spin_unlock_bh(&session->lock);
 success_unlocked:
-	debug_scsi("abort success [sc %lx itt 0x%x]\n", (long)sc, ctask->itt);
+	debug_scsi("abort success [sc %lx itt 0x%x]\n", (long)sc, task->itt);
 	mutex_unlock(&session->eh_mutex);
 	return SUCCESS;
 
@@ -1658,7 +1660,7 @@ failed:
 	spin_unlock_bh(&session->lock);
 failed_unlocked:
 	debug_scsi("abort failed [sc %p itt 0x%x]\n", sc,
-		    ctask ? ctask->itt : 0);
+		    task ? task->itt : 0);
 	mutex_unlock(&session->eh_mutex);
 	return FAILED;
 }
@@ -1705,7 +1707,7 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 	hdr = &conn->tmhdr;
 	iscsi_prep_lun_reset_pdu(sc, hdr);
 
-	if (iscsi_exec_ctask_mgmt_fn(conn, hdr, session->age,
+	if (iscsi_exec_task_mgmt_fn(conn, hdr, session->age,
 				    session->lu_reset_timeout)) {
 		rc = FAILED;
 		goto unlock;
@@ -1886,7 +1888,7 @@ EXPORT_SYMBOL_GPL(iscsi_host_free);
  * @iscsit: iscsi transport template
  * @shost: scsi host
  * @cmds_max: session can queue
- * @cmd_ctask_size: LLD ctask private data size
+ * @cmd_task_size: LLD task private data size
  * @initial_cmdsn: initial CmdSN
  *
  * This can be used by software iscsi_transports that allocate
@@ -1894,7 +1896,7 @@ EXPORT_SYMBOL_GPL(iscsi_host_free);
  */
 struct iscsi_cls_session *
 iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
-		    uint16_t scsi_cmds_max, int cmd_ctask_size,
+		    uint16_t scsi_cmds_max, int cmd_task_size,
 		    uint32_t initial_cmdsn)
 {
 	struct iscsi_session *session;
@@ -1902,7 +1904,7 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 	int cmd_i, cmds_max;
 
 	/*
-	 * The iscsi layer needs some ctasks for nop handling and tmfs.
+	 * The iscsi layer needs some tasks for nop handling and tmfs.
 	 */
 	if (scsi_cmds_max < 1)
 		scsi_cmds_max = ISCSI_MGMT_CMDS_MAX;
@@ -1939,17 +1941,17 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 	/* initialize SCSI PDU commands pool */
 	if (iscsi_pool_init(&session->cmdpool, session->cmds_max,
 			    (void***)&session->cmds,
-			    cmd_ctask_size + sizeof(struct iscsi_cmd_task)))
+			    cmd_task_size + sizeof(struct iscsi_task)))
 		goto cmdpool_alloc_fail;
 
 	/* pre-format cmds pool with ITT */
 	for (cmd_i = 0; cmd_i < session->cmds_max; cmd_i++) {
-		struct iscsi_cmd_task *ctask = session->cmds[cmd_i];
+		struct iscsi_task *task = session->cmds[cmd_i];
 
-		if (cmd_ctask_size)
-			ctask->dd_data = &ctask[1];
-		ctask->itt = cmd_i;
-		INIT_LIST_HEAD(&ctask->running);
+		if (cmd_task_size)
+			task->dd_data = &task[1];
+		task->itt = cmd_i;
+		INIT_LIST_HEAD(&task->running);
 	}
 
 	if (!try_module_get(iscsit->owner))
@@ -2035,30 +2037,30 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
 	INIT_LIST_HEAD(&conn->requeue);
 	INIT_WORK(&conn->xmitwork, iscsi_xmitworker);
 
-	/* allocate login_ctask used for the login/text sequences */
+	/* allocate login_task used for the login/text sequences */
 	spin_lock_bh(&session->lock);
 	if (!__kfifo_get(session->cmdpool.queue,
-                         (void*)&conn->login_ctask,
+                         (void*)&conn->login_task,
 			 sizeof(void*))) {
 		spin_unlock_bh(&session->lock);
-		goto login_ctask_alloc_fail;
+		goto login_task_alloc_fail;
 	}
 	spin_unlock_bh(&session->lock);
 
 	data = kmalloc(ISCSI_DEF_MAX_RECV_SEG_LEN, GFP_KERNEL);
 	if (!data)
-		goto login_ctask_data_alloc_fail;
-	conn->login_ctask->data = conn->data = data;
+		goto login_task_data_alloc_fail;
+	conn->login_task->data = conn->data = data;
 
 	init_timer(&conn->tmf_timer);
 	init_waitqueue_head(&conn->ehwait);
 
 	return cls_conn;
 
-login_ctask_data_alloc_fail:
-	__kfifo_put(session->cmdpool.queue, (void*)&conn->login_ctask,
+login_task_data_alloc_fail:
+	__kfifo_put(session->cmdpool.queue, (void*)&conn->login_task,
 		    sizeof(void*));
-login_ctask_alloc_fail:
+login_task_alloc_fail:
 	iscsi_destroy_conn(cls_conn);
 	return NULL;
 }
@@ -2118,7 +2120,7 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 	spin_lock_bh(&session->lock);
 	kfree(conn->data);
 	kfree(conn->persistent_address);
-	__kfifo_put(session->cmdpool.queue, (void*)&conn->login_ctask,
+	__kfifo_put(session->cmdpool.queue, (void*)&conn->login_task,
 		    sizeof(void*));
 	if (session->leadconn == conn)
 		session->leadconn = NULL;
@@ -2199,23 +2201,23 @@ EXPORT_SYMBOL_GPL(iscsi_conn_start);
 static void
 flush_control_queues(struct iscsi_session *session, struct iscsi_conn *conn)
 {
-	struct iscsi_cmd_task *ctask, *tmp;
+	struct iscsi_task *task, *tmp;
 
 	/* handle pending */
-	list_for_each_entry_safe(ctask, tmp, &conn->mgmtqueue, running) {
-		debug_scsi("flushing pending mgmt ctask itt 0x%x\n", ctask->itt);
-		/* release ref from prep ctask */
-		__iscsi_put_ctask(ctask);
+	list_for_each_entry_safe(task, tmp, &conn->mgmtqueue, running) {
+		debug_scsi("flushing pending mgmt task itt 0x%x\n", task->itt);
+		/* release ref from prep task */
+		__iscsi_put_task(task);
 	}
 
 	/* handle running */
-	list_for_each_entry_safe(ctask, tmp, &conn->mgmt_run_list, running) {
-		debug_scsi("flushing running mgmt ctask itt 0x%x\n", ctask->itt);
-		/* release ref from prep ctask */
-		__iscsi_put_ctask(ctask);
+	list_for_each_entry_safe(task, tmp, &conn->mgmt_run_list, running) {
+		debug_scsi("flushing running mgmt task itt 0x%x\n", task->itt);
+		/* release ref from prep task */
+		__iscsi_put_task(task);
 	}
 
-	conn->ctask = NULL;
+	conn->task = NULL;
 }
 
 static void iscsi_start_session_recovery(struct iscsi_session *session,
@@ -2246,7 +2248,7 @@ static void iscsi_start_session_recovery(struct iscsi_session *session,
 
 	/*
 	 * When this is called for the in_login state, we only want to clean
-	 * up the login ctask and connection. We do not need to block and set
+	 * up the login task and connection. We do not need to block and set
 	 * the recovery state again
 	 */
 	if (flag == STOP_CONN_TERM)
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index d1c3675..176353c 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -92,7 +92,7 @@ enum {
 	ISCSI_TASK_RUNNING,
 };
 
-struct iscsi_cmd_task {
+struct iscsi_task {
 	/*
 	 * Because LLDs allocate their hdr differently, this is a pointer
 	 * and length to that storage. It must be setup at session
@@ -120,9 +120,9 @@ struct iscsi_cmd_task {
 	void			*dd_data;	/* driver/transport data */
 };
 
-static inline void* iscsi_next_hdr(struct iscsi_cmd_task *ctask)
+static inline void* iscsi_next_hdr(struct iscsi_task *task)
 {
-	return (void*)ctask->hdr + ctask->hdr_len;
+	return (void*)task->hdr + task->hdr_len;
 }
 
 /* Connection's states */
@@ -151,7 +151,7 @@ struct iscsi_conn {
 	unsigned long		last_ping;
 	int			ping_timeout;
 	int			recv_timeout;
-	struct iscsi_cmd_task 	*ping_ctask;
+	struct iscsi_task 	*ping_task;
 
 	/* iSCSI connection-wide sequencing */
 	uint32_t		exp_statsn;
@@ -167,8 +167,8 @@ struct iscsi_conn {
 	 * should always fit in this buffer
 	 */
 	char			*data;
-	struct iscsi_cmd_task 	*login_ctask;	/* mtask used for login/text */
-	struct iscsi_cmd_task	*ctask;		/* xmit task in progress */
+	struct iscsi_task 	*login_task;	/* mtask used for login/text */
+	struct iscsi_task	*task;		/* xmit task in progress */
 
 	/* xmit */
 	struct list_head	mgmtqueue;	/* mgmt (control) xmit queue */
@@ -285,7 +285,7 @@ struct iscsi_session {
 
 	int			scsi_cmds_max; 	/* max scsi commands */
 	int			cmds_max;	/* size of cmds array */
-	struct iscsi_cmd_task	**cmds;		/* Original Cmds arr */
+	struct iscsi_task	**cmds;		/* Original Cmds arr */
 	struct iscsi_pool	cmdpool;	/* PDU's pool */
 };
 
@@ -365,16 +365,16 @@ extern void iscsi_suspend_tx(struct iscsi_conn *conn);
  * pdu and task processing
  */
 extern void iscsi_update_cmdsn(struct iscsi_session *, struct iscsi_nopin *);
-extern void iscsi_prep_unsolicit_data_pdu(struct iscsi_cmd_task *,
+extern void iscsi_prep_unsolicit_data_pdu(struct iscsi_task *,
 					struct iscsi_data *hdr);
 extern int iscsi_conn_send_pdu(struct iscsi_cls_conn *, struct iscsi_hdr *,
 				char *, uint32_t);
 extern int iscsi_complete_pdu(struct iscsi_conn *, struct iscsi_hdr *,
 			      char *, int);
 extern int iscsi_verify_itt(struct iscsi_conn *, itt_t);
-extern struct iscsi_cmd_task *iscsi_itt_to_ctask(struct iscsi_conn *, itt_t);
-extern void iscsi_requeue_ctask(struct iscsi_cmd_task *ctask);
-extern void iscsi_put_ctask(struct iscsi_cmd_task *ctask);
+extern struct iscsi_task *iscsi_itt_to_ctask(struct iscsi_conn *, itt_t);
+extern void iscsi_requeue_task(struct iscsi_task *task);
+extern void iscsi_put_task(struct iscsi_task *task);
 
 /*
  * generic helpers
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 3f24503..0553240 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -33,7 +33,7 @@ struct iscsi_transport;
 struct Scsi_Host;
 struct iscsi_cls_conn;
 struct iscsi_conn;
-struct iscsi_cmd_task;
+struct iscsi_task;
 struct sockaddr;
 
 /**
@@ -112,10 +112,10 @@ struct iscsi_transport {
 			 char *data, uint32_t data_size);
 	void (*get_stats) (struct iscsi_cls_conn *conn,
 			   struct iscsi_stats *stats);
-	int (*init_task) (struct iscsi_cmd_task *task);
-	int (*xmit_task) (struct iscsi_cmd_task *task);
+	int (*init_task) (struct iscsi_task *task);
+	int (*xmit_task) (struct iscsi_task *task);
 	void (*cleanup_task) (struct iscsi_conn *conn,
-				  struct iscsi_cmd_task *task);
+				  struct iscsi_task *task);
 	void (*session_recovery_timedout) (struct iscsi_cls_session *session);
 	int (*ep_connect) (struct sockaddr *dst_addr, int non_blocking,
 			   uint64_t *ep_handle);
-- 
1.5.4.1

