From: michaelc@cs.wisc.edu
Subject: [PATCH 02/13] libiscsi: prepare libiscsi for new offload engines by modifying unsol data code
Date: Tue,  2 Dec 2008 00:32:05 -0600
Message-ID: <1228199536-12595-3-git-send-email-michaelc@cs.wisc.edu>
References: <1228199536-12595-1-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-2-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52403 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbYLBGcW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Dec 2008 01:32:22 -0500
In-Reply-To: <1228199536-12595-2-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

cxgb3i offloads data transfers. It does not offload the entire scsi/iscsi
procssing like qla4xxx and it does not offload the iscsi sequence
processing like how bnx2i does. cxgb3i relies on iscsi_tcp for the
seqeunce handling so this changes how we transfer unsolicitied data by
adding a common r2t struct and helpers.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c             |  183 +++++++++++++++++++++++------------
 include/scsi/libiscsi.h             |   34 +++++--
 include/scsi/scsi_transport_iscsi.h |    9 ++-
 3 files changed, 156 insertions(+), 70 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 801c7cf..656e213 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -88,34 +88,47 @@ iscsi_update_cmdsn(struct iscsi_session *session, struct iscsi_nopin *hdr)
 }
 EXPORT_SYMBOL_GPL(iscsi_update_cmdsn);
 
-void iscsi_prep_unsolicit_data_pdu(struct iscsi_task *task,
-				   struct iscsi_data *hdr)
+/**
+ * iscsi_prep_data_out_pdu - initialize Data-Out
+ * @task: scsi command task
+ * @r2t: R2T info
+ * @hdr: iscsi data in pdu
+ *
+ * Notes:
+ *	Initialize Data-Out within this R2T sequence and finds
+ *	proper data_offset within this SCSI command.
+ *
+ *	This function is called with connection lock taken.
+ **/
+void iscsi_prep_data_out_pdu(struct iscsi_task *task, struct iscsi_r2t_info *r2t,
+			   struct iscsi_data *hdr)
 {
 	struct iscsi_conn *conn = task->conn;
+	unsigned int left = r2t->data_length - r2t->sent;
+
+	task->hdr_len = sizeof(struct iscsi_data);
 
 	memset(hdr, 0, sizeof(struct iscsi_data));
-	hdr->ttt = cpu_to_be32(ISCSI_RESERVED_TAG);
-	hdr->datasn = cpu_to_be32(task->unsol_datasn);
-	task->unsol_datasn++;
+	hdr->ttt = r2t->ttt;
+	hdr->datasn = cpu_to_be32(r2t->datasn);
+	r2t->datasn++;
 	hdr->opcode = ISCSI_OP_SCSI_DATA_OUT;
-	memcpy(hdr->lun, task->hdr->lun, sizeof(hdr->lun));
-
-	hdr->itt = task->hdr->itt;
-	hdr->exp_statsn = cpu_to_be32(conn->exp_statsn);
-	hdr->offset = cpu_to_be32(task->unsol_offset);
-
-	if (task->unsol_count > conn->max_xmit_dlength) {
+	memcpy(hdr->lun, task->lun, sizeof(hdr->lun));
+	hdr->itt = task->hdr_itt;
+	hdr->exp_statsn = r2t->exp_statsn;
+	hdr->offset = cpu_to_be32(r2t->data_offset + r2t->sent);
+	if (left > conn->max_xmit_dlength) {
 		hton24(hdr->dlength, conn->max_xmit_dlength);
-		task->data_count = conn->max_xmit_dlength;
-		task->unsol_offset += task->data_count;
+		r2t->data_count = conn->max_xmit_dlength;
 		hdr->flags = 0;
 	} else {
-		hton24(hdr->dlength, task->unsol_count);
-		task->data_count = task->unsol_count;
+		hton24(hdr->dlength, left);
+		r2t->data_count = left;
 		hdr->flags = ISCSI_FLAG_CMD_FINAL;
 	}
+	conn->dataout_pdus_cnt++;
 }
-EXPORT_SYMBOL_GPL(iscsi_prep_unsolicit_data_pdu);
+EXPORT_SYMBOL_GPL(iscsi_prep_data_out_pdu);
 
 static int iscsi_add_hdr(struct iscsi_task *task, unsigned len)
 {
@@ -206,11 +219,17 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 {
 	struct iscsi_conn *conn = task->conn;
 	struct iscsi_session *session = conn->session;
-	struct iscsi_cmd *hdr = task->hdr;
 	struct scsi_cmnd *sc = task->sc;
+	struct iscsi_cmd *hdr;
 	unsigned hdrlength, cmd_len;
 	int rc;
 
+	rc = conn->session->tt->alloc_pdu(task);
+	if (rc)
+		return rc;
+	hdr = (struct iscsi_cmd *) task->hdr;
+	memset(hdr, 0, sizeof(*hdr));
+
 	task->hdr_len = 0;
 	rc = iscsi_add_hdr(task, sizeof(*hdr));
 	if (rc)
@@ -218,8 +237,9 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 	hdr->opcode = ISCSI_OP_SCSI_CMD;
 	hdr->flags = ISCSI_ATTR_SIMPLE;
 	int_to_scsilun(sc->device->lun, (struct scsi_lun *)hdr->lun);
-	hdr->itt = build_itt(task->itt, session->age);
-	hdr->cmdsn = cpu_to_be32(session->cmdsn);
+	memcpy(task->lun, hdr->lun, sizeof(task->lun));
+	hdr->itt = task->hdr_itt = build_itt(task->itt, session->age);
+	hdr->cmdsn = task->cmdsn = cpu_to_be32(session->cmdsn);
 	session->cmdsn++;
 	hdr->exp_statsn = cpu_to_be32(conn->exp_statsn);
 	cmd_len = sc->cmd_len;
@@ -242,6 +262,8 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 	}
 	if (sc->sc_data_direction == DMA_TO_DEVICE) {
 		unsigned out_len = scsi_out(sc)->length;
+		struct iscsi_r2t_info *r2t = &task->unsol_r2t;
+
 		hdr->data_length = cpu_to_be32(out_len);
 		hdr->flags |= ISCSI_FLAG_CMD_WRITE;
 		/*
@@ -254,13 +276,11 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 		 *			without	R2T ack right after
 		 *			immediate data
 		 *
-		 *	r2t_data_count	bytes to be sent via R2T ack's
+		 *	r2t data_length bytes to be sent via R2T ack's
 		 *
 		 *      pad_count       bytes to be sent as zero-padding
 		 */
-		task->unsol_count = 0;
-		task->unsol_offset = 0;
-		task->unsol_datasn = 0;
+		memset(r2t, 0, sizeof(*r2t));
 
 		if (session->imm_data_en) {
 			if (out_len >= session->first_burst)
@@ -274,12 +294,14 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 			zero_data(hdr->dlength);
 
 		if (!session->initial_r2t_en) {
-			task->unsol_count = min(session->first_burst, out_len)
-							     - task->imm_count;
-			task->unsol_offset = task->imm_count;
+			r2t->data_length = min(session->first_burst, out_len) -
+					       task->imm_count;
+			r2t->data_offset = task->imm_count;
+			r2t->ttt = cpu_to_be32(ISCSI_RESERVED_TAG);
+			r2t->exp_statsn = cpu_to_be32(conn->exp_statsn);
 		}
 
-		if (!task->unsol_count)
+		if (!task->unsol_r2t.data_length)
 			/* No unsolicit Data-Out's */
 			hdr->flags |= ISCSI_FLAG_CMD_FINAL;
 	} else {
@@ -300,8 +322,7 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 	WARN_ON(hdrlength >= 256);
 	hdr->hlength = hdrlength & 0xFF;
 
-	if (conn->session->tt->init_task &&
-	    conn->session->tt->init_task(task))
+	if (session->tt->init_task && session->tt->init_task(task))
 		return -EIO;
 
 	task->state = ISCSI_TASK_RUNNING;
@@ -332,6 +353,7 @@ static void iscsi_complete_command(struct iscsi_task *task)
 	struct iscsi_session *session = conn->session;
 	struct scsi_cmnd *sc = task->sc;
 
+	session->tt->cleanup_task(task);
 	list_del_init(&task->running);
 	task->state = ISCSI_TASK_COMPLETED;
 	task->sc = NULL;
@@ -402,8 +424,6 @@ static void fail_command(struct iscsi_conn *conn, struct iscsi_task *task,
 		 * the cmd in the sequencing
 		 */
 		conn->session->queued_cmdsn--;
-	else
-		conn->session->tt->cleanup_task(conn, task);
 
 	sc->result = err;
 	if (!scsi_bidi_cmnd(sc))
@@ -423,7 +443,7 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
 				struct iscsi_task *task)
 {
 	struct iscsi_session *session = conn->session;
-	struct iscsi_hdr *hdr = (struct iscsi_hdr *)task->hdr;
+	struct iscsi_hdr *hdr = task->hdr;
 	struct iscsi_nopout *nop = (struct iscsi_nopout *)hdr;
 
 	if (conn->session->state == ISCSI_STATE_LOGGING_OUT)
@@ -456,6 +476,7 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
 	if ((hdr->opcode & ISCSI_OPCODE_MASK) == ISCSI_OP_LOGOUT)
 		session->state = ISCSI_STATE_LOGGING_OUT;
 
+	task->state = ISCSI_TASK_RUNNING;
 	list_move_tail(&task->running, &conn->mgmt_run_list);
 	debug_scsi("mgmtpdu [op 0x%x hdr->itt 0x%x datalen %d]\n",
 		   hdr->opcode & ISCSI_OPCODE_MASK, hdr->itt,
@@ -511,23 +532,38 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	} else
 		task->data_count = 0;
 
+	if (conn->session->tt->alloc_pdu(task)) {
+		iscsi_conn_printk(KERN_ERR, conn, "Could not allocate "
+				 "pdu for mgmt task.\n");
+		goto requeue_task;
+	}
+	task->hdr_len = sizeof(struct iscsi_hdr);
+
 	memcpy(task->hdr, hdr, sizeof(struct iscsi_hdr));
 	INIT_LIST_HEAD(&task->running);
 	list_add_tail(&task->running, &conn->mgmtqueue);
 
 	if (session->tt->caps & CAP_DATA_PATH_OFFLOAD) {
-		if (iscsi_prep_mgmt_task(conn, task)) {
-			__iscsi_put_task(task);
-			return NULL;
-		}
+		if (iscsi_prep_mgmt_task(conn, task))
+			goto free_task;
 
 		if (session->tt->xmit_task(task))
-			task = NULL;
+			goto free_task;
 
 	} else
 		scsi_queue_work(conn->session->host, &conn->xmitwork);
 
 	return task;
+
+free_task:
+	__iscsi_put_task(task);
+	return NULL;
+
+requeue_task:
+	if (task != conn->login_task)
+		__kfifo_put(session->cmdpool.queue, (void*)&task,
+			    sizeof(void*));
+	return NULL;
 }
 
 int iscsi_conn_send_pdu(struct iscsi_cls_conn *cls_conn, struct iscsi_hdr *hdr,
@@ -1137,8 +1173,13 @@ check_mgmt:
 			fail_command(conn, conn->task, DID_IMM_RETRY << 16);
 			continue;
 		}
-		if (iscsi_prep_scsi_cmd_pdu(conn->task)) {
-			fail_command(conn, conn->task, DID_ABORT << 16);
+		rc = iscsi_prep_scsi_cmd_pdu(conn->task);
+		if (rc) {
+			if (rc == -ENOMEM) {
+				conn->task = NULL;
+				goto again;
+			} else
+				fail_command(conn, conn->task, DID_ABORT << 16);
 			continue;
 		}
 		rc = iscsi_xmit_task(conn);
@@ -1196,6 +1237,26 @@ static void iscsi_xmitworker(struct work_struct *work)
 	} while (rc >= 0 || rc == -EAGAIN);
 }
 
+static inline struct iscsi_task *iscsi_alloc_task(struct iscsi_conn *conn,
+						  struct scsi_cmnd *sc)
+{
+	struct iscsi_task *task;
+
+	if (!__kfifo_get(conn->session->cmdpool.queue,
+			 (void *) &task, sizeof(void *)))
+		return NULL;
+
+	sc->SCp.phase = conn->session->age;
+	sc->SCp.ptr = (char *) task;
+
+	atomic_set(&task->refcount, 1);
+	task->state = ISCSI_TASK_PENDING;
+	task->conn = conn;
+	task->sc = sc;
+	INIT_LIST_HEAD(&task->running);
+	return task;
+}
+
 enum {
 	FAILURE_BAD_HOST = 1,
 	FAILURE_SESSION_FAILED,
@@ -1282,33 +1343,27 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 		goto reject;
 	}
 
-	if (!__kfifo_get(session->cmdpool.queue, (void*)&task,
-			 sizeof(void*))) {
+	task = iscsi_alloc_task(conn, sc);
+	if (!task) {
 		reason = FAILURE_OOM;
 		goto reject;
 	}
-	sc->SCp.phase = session->age;
-	sc->SCp.ptr = (char *)task;
-
-	atomic_set(&task->refcount, 1);
-	task->state = ISCSI_TASK_PENDING;
-	task->conn = conn;
-	task->sc = sc;
-	INIT_LIST_HEAD(&task->running);
 	list_add_tail(&task->running, &conn->xmitqueue);
 
 	if (session->tt->caps & CAP_DATA_PATH_OFFLOAD) {
-		if (iscsi_prep_scsi_cmd_pdu(task)) {
-			sc->result = DID_ABORT << 16;
-			sc->scsi_done = NULL;
-			iscsi_complete_command(task);
-			goto fault;
+		reason = iscsi_prep_scsi_cmd_pdu(task);
+		if (reason) {
+			if (reason == -ENOMEM) {
+				reason = FAILURE_OOM;
+				goto prepd_reject;
+			} else {
+				sc->result = DID_ABORT << 16;
+				goto prepd_fault;
+			}
 		}
 		if (session->tt->xmit_task(task)) {
-			sc->scsi_done = NULL;
-			iscsi_complete_command(task);
 			reason = FAILURE_SESSION_NOT_READY;
-			goto reject;
+			goto prepd_reject;
 		}
 	} else
 		scsi_queue_work(session->host, &conn->xmitwork);
@@ -1318,12 +1373,18 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 	spin_lock(host->host_lock);
 	return 0;
 
+prepd_reject:
+	sc->scsi_done = NULL;
+	iscsi_complete_command(task);
 reject:
 	spin_unlock(&session->lock);
 	debug_scsi("cmd 0x%x rejected (%d)\n", sc->cmnd[0], reason);
 	spin_lock(host->host_lock);
 	return SCSI_MLQUEUE_TARGET_BUSY;
 
+prepd_fault:
+	sc->scsi_done = NULL;
+	iscsi_complete_command(task);
 fault:
 	spin_unlock(&session->lock);
 	debug_scsi("iscsi: cmd 0x%x is not queued (%d)\n", sc->cmnd[0], reason);
@@ -1635,9 +1696,9 @@ static void iscsi_prep_abort_task_pdu(struct iscsi_task *task,
 	hdr->opcode = ISCSI_OP_SCSI_TMFUNC | ISCSI_OP_IMMEDIATE;
 	hdr->flags = ISCSI_TM_FUNC_ABORT_TASK & ISCSI_FLAG_TM_FUNC_MASK;
 	hdr->flags |= ISCSI_FLAG_CMD_FINAL;
-	memcpy(hdr->lun, task->hdr->lun, sizeof(hdr->lun));
-	hdr->rtt = task->hdr->itt;
-	hdr->refcmdsn = task->hdr->cmdsn;
+	memcpy(hdr->lun, task->lun, sizeof(hdr->lun));
+	hdr->rtt = task->hdr_itt;
+	hdr->refcmdsn = task->cmdsn;
 }
 
 int iscsi_eh_abort(struct scsi_cmnd *sc)
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 61e53f1..5150057 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -93,24 +93,38 @@ enum {
 	ISCSI_TASK_RUNNING,
 };
 
+struct iscsi_r2t_info {
+	__be32			ttt;		/* copied from R2T */
+	__be32			exp_statsn;	/* copied from R2T */
+	uint32_t		data_length;	/* copied from R2T */
+	uint32_t		data_offset;	/* copied from R2T */
+	int			data_count;	/* DATA-Out payload progress */
+	int			datasn;
+	/* LLDs should set/update these values */
+	int			sent;		/* R2T sequence progress */
+};
+
 struct iscsi_task {
 	/*
 	 * Because LLDs allocate their hdr differently, this is a pointer
 	 * and length to that storage. It must be setup at session
 	 * creation time.
 	 */
-	struct iscsi_cmd	*hdr;
+	struct iscsi_hdr	*hdr;
 	unsigned short		hdr_max;
 	unsigned short		hdr_len;	/* accumulated size of hdr used */
+	/* copied values in case we need to send tmfs */
+	itt_t			hdr_itt;
+	__be32			cmdsn;
+	uint8_t			lun[8];
+
 	int			itt;		/* this ITT */
 
-	uint32_t		unsol_datasn;
 	unsigned		imm_count;	/* imm-data (bytes)   */
-	unsigned		unsol_count;	/* unsolicited (bytes)*/
 	/* offset in unsolicited stream (bytes); */
-	unsigned		unsol_offset;
-	unsigned		data_count;	/* remaining Data-Out */
+	struct iscsi_r2t_info	unsol_r2t;
 	char			*data;		/* mgmt payload */
+	unsigned		data_count;
 	struct scsi_cmnd	*sc;		/* associated SCSI cmd*/
 	struct iscsi_conn	*conn;		/* used connection    */
 
@@ -121,6 +135,11 @@ struct iscsi_task {
 	void			*dd_data;	/* driver/transport data */
 };
 
+static inline int iscsi_task_has_unsol_data(struct iscsi_task *task)
+{
+	return task->unsol_r2t.data_length > task->unsol_r2t.sent;
+}
+
 static inline void* iscsi_next_hdr(struct iscsi_task *task)
 {
 	return (void*)task->hdr + task->hdr_len;
@@ -376,8 +395,9 @@ extern void iscsi_suspend_tx(struct iscsi_conn *conn);
  * pdu and task processing
  */
 extern void iscsi_update_cmdsn(struct iscsi_session *, struct iscsi_nopin *);
-extern void iscsi_prep_unsolicit_data_pdu(struct iscsi_task *,
-					struct iscsi_data *hdr);
+extern void iscsi_prep_data_out_pdu(struct iscsi_task *task,
+				    struct iscsi_r2t_info *r2t,
+				    struct iscsi_data *hdr);
 extern int iscsi_conn_send_pdu(struct iscsi_cls_conn *, struct iscsi_hdr *,
 				char *, uint32_t);
 extern int iscsi_complete_pdu(struct iscsi_conn *, struct iscsi_hdr *,
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index c667cc3..c928234 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -113,10 +113,15 @@ struct iscsi_transport {
 			 char *data, uint32_t data_size);
 	void (*get_stats) (struct iscsi_cls_conn *conn,
 			   struct iscsi_stats *stats);
+
 	int (*init_task) (struct iscsi_task *task);
 	int (*xmit_task) (struct iscsi_task *task);
-	void (*cleanup_task) (struct iscsi_conn *conn,
-				  struct iscsi_task *task);
+	void (*cleanup_task) (struct iscsi_task *task);
+
+	int (*alloc_pdu) (struct iscsi_task *task);
+	int (*xmit_pdu) (struct iscsi_task *task);
+	int (*init_pdu) (struct iscsi_task *task, unsigned int offset,
+			 unsigned int count);
 	void (*session_recovery_timedout) (struct iscsi_cls_session *session);
 	struct iscsi_endpoint *(*ep_connect) (struct sockaddr *dst_addr,
 					      int non_blocking);
-- 
1.5.6.5

