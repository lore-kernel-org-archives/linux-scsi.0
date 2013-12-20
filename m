From: michaelc@cs.wisc.edu
Subject: [PATCH 2/6] SCSI/libiscsi: Reduce locking contention in fast path
Date: Fri, 20 Dec 2013 12:53:43 -0600
Message-ID: <1387565627-5218-3-git-send-email-michaelc@cs.wisc.edu>
References: <1387565627-5218-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:33113 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137Ab3LTSx7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Dec 2013 13:53:59 -0500
Received: from localhost.localdomain (c-24-245-27-162.hsd1.mn.comcast.net [24.245.27.162])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.14.1/8.14.1) with ESMTP id rBKIrs2Y010889
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 20 Dec 2013 12:53:58 -0600
In-Reply-To: <1387565627-5218-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Shlomo Pongratz <shlomop@mellanox.com>

Replace the session lock with two locks, a forward lock and
a backwards lock named frwd_lock and back_lock respectively.

The forward lock protects resources that change while sending a
request to the target, such as cmdsn, queued_cmdsn, and allocating
task from the commands' pool with kfifo_out.

The backward lock protects resources that change while processing
a response or in error path, such as cmdsn_exp, cmdsn_max, and
returning tasks to the commands' pool with kfifo_in.

Under a steady state fast-path situation, that is when one
or more processes/threads submit IO to an iscsi device and
a single kernel upcall (e.g softirq) is dealing with processing
of responses without errors, this patch eliminates the contention
between the queuecommand()/request response/scsi_done() flows
associated with iscsi sessions.

Between the forward and the backward locks exists a strict locking
hierarchy.
The mutual exclusion zone protected by the forward lock can enclose the
mutual exclusion zone protected by the backward lock but not vice versa.

For example, in iscsi_conn_teardown or in iscsi_xmit_data when there is
a
failure and __iscsi_put_task is called, the backward lock is taken while
the
forward lock is still taken. On the other hand, if in the RX path a nop
is
to be sent, for example in iscsi_handle_reject or __iscsi_complete_pdu
than
the forward lock is released and the backward lock is taken for the
duration
of iscsi_send_nopout, later the backward lock is released and the
forward
lock is retaken.

libiscsi_tcp uses two kernel fifos the r2t pool and the r2t queue.

The insertion and deletion from these queues didn't corespond to the
assumption taken by the new forward/backwards session locking paradigm.

That is, in iscsi_tcp_clenup_task which belongs to the RX (backwards)
path, r2t is taken out from r2t queue and inserted to the r2t pool.
In iscsi_tcp_get_curr_r2t which belong to the TX (forward) path, r2t
is also inserted to the r2t pool and another r2t is pulled from r2t
queue.

Only in iscsi_tcp_r2t_rsp which is called in the RX path but can requeue
to the TX path, r2t is taken from the r2t pool and inserted to the r2t
queue.

In order to cope with this situation, two spin locks were added,
pool2queue and queue2pool. The former protects extracting from the
r2t pool and inserting to the r2t queue, and the later protects the
extracing from the r2t queue and inserting to the r2t pool.

Signed-off-by: Shlomo Pongratz <shlomop@mellanox.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
[minor fix up to apply cleanly]
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/be2iscsi/be_main.c  |   26 +++---
 drivers/scsi/bnx2i/bnx2i_hwi.c   |   46 +++++-----
 drivers/scsi/bnx2i/bnx2i_iscsi.c |    8 +-
 drivers/scsi/iscsi_tcp.c         |   22 ++--
 drivers/scsi/libiscsi.c          |  192 ++++++++++++++++++++++----------------
 drivers/scsi/libiscsi_tcp.c      |   28 ++++--
 drivers/scsi/qla4xxx/ql4_isr.c   |    4 +-
 include/scsi/libiscsi.h          |   17 +++-
 include/scsi/libiscsi_tcp.h      |    2 +
 9 files changed, 195 insertions(+), 150 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 1f37505..1fb16b1 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -232,20 +232,20 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
 	cls_session = starget_to_session(scsi_target(sc->device));
 	session = cls_session->dd_data;
 
-	spin_lock_bh(&session->lock);
+	spin_lock_bh(&session->frwd_lock);
 	if (!aborted_task || !aborted_task->sc) {
 		/* we raced */
-		spin_unlock_bh(&session->lock);
+		spin_unlock_bh(&session->fwrd_lock);
 		return SUCCESS;
 	}
 
 	aborted_io_task = aborted_task->dd_data;
 	if (!aborted_io_task->scsi_cmnd) {
 		/* raced or invalid command */
-		spin_unlock_bh(&session->lock);
+		spin_unlock_bh(&session->fwrd_lock);
 		return SUCCESS;
 	}
-	spin_unlock_bh(&session->lock);
+	spin_unlock_bh(&session->fwrd_lock);
 	/* Invalidate WRB Posted for this Task */
 	AMAP_SET_BITS(struct amap_iscsi_wrb, invld,
 		      aborted_io_task->pwrb_handle->pwrb,
@@ -307,9 +307,9 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 	/* invalidate iocbs */
 	cls_session = starget_to_session(scsi_target(sc->device));
 	session = cls_session->dd_data;
-	spin_lock_bh(&session->lock);
+	spin_lock_bh(&session->frwd_lock);
 	if (!session->leadconn || session->state != ISCSI_STATE_LOGGED_IN) {
-		spin_unlock_bh(&session->lock);
+		spin_unlock_bh(&session->frwd_lock);
 		return FAILED;
 	}
 	conn = session->leadconn;
@@ -338,7 +338,7 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 		num_invalidate++;
 		inv_tbl++;
 	}
-	spin_unlock_bh(&session->lock);
+	spin_unlock_bh(&session->frwd_lock);
 	inv_tbl = phba->inv_tbl;
 
 	nonemb_cmd.va = pci_alloc_consistent(phba->ctrl.pdev,
@@ -1150,9 +1150,9 @@ beiscsi_process_async_pdu(struct beiscsi_conn *beiscsi_conn,
 		return 1;
 	}
 
-	spin_lock_bh(&session->lock);
+	spin_lock_bh(&session->back_lock);
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)ppdu, pbuffer, buf_len);
-	spin_unlock_bh(&session->lock);
+	spin_unlock_bh(&session->back_lock);
 	return 0;
 }
 
@@ -1568,7 +1568,7 @@ static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
 	pwrb = pwrb_handle->pwrb;
 	type = ((struct beiscsi_io_task *)task->dd_data)->wrb_type;
 
-	spin_lock_bh(&session->lock);
+	spin_lock_bh(&session->back_lock);
 	switch (type) {
 	case HWH_TYPE_IO:
 	case HWH_TYPE_IO_RD:
@@ -1607,7 +1607,7 @@ static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
 		break;
 	}
 
-	spin_unlock_bh(&session->lock);
+	spin_unlock_bh(&session->back_lock);
 }
 
 static struct list_head *hwi_get_async_busy_list(struct hwi_async_pdu_context
@@ -4646,9 +4646,9 @@ beiscsi_offload_connection(struct beiscsi_conn *beiscsi_conn,
 	 * login/startup related tasks.
 	 */
 	beiscsi_conn->login_in_progress = 0;
-	spin_lock_bh(&session->lock);
+	spin_lock_bh(&session->back_lock);
 	beiscsi_cleanup_task(task);
-	spin_unlock_bh(&session->lock);
+	spin_unlock_bh(&session->back_lock);
 
 	pwrb_handle = alloc_wrb_handle(phba, beiscsi_conn->beiscsi_conn_cid);
 
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index e4cf23d..da9cf04 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1361,7 +1361,7 @@ int bnx2i_process_scsi_cmd_resp(struct iscsi_session *session,
 	u32 datalen = 0;
 
 	resp_cqe = (struct bnx2i_cmd_response *)cqe;
-	spin_lock_bh(&session->lock);
+	spin_lock_bh(&session->back_lock);
 	task = iscsi_itt_to_task(conn,
 				 resp_cqe->itt & ISCSI_CMD_RESPONSE_INDEX);
 	if (!task)
@@ -1432,7 +1432,7 @@ done:
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr,
 			     conn->data, datalen);
 fail:
-	spin_unlock_bh(&session->lock);
+	spin_unlock_bh(&session->back_lock);
 	return 0;
 }
 
@@ -1457,7 +1457,7 @@ static int bnx2i_process_login_resp(struct iscsi_session *session,
 	int pad_len;
 
 	login = (struct bnx2i_login_response *) cqe;
-	spin_lock(&session->lock);
+	spin_lock(&session->back_lock);
 	task = iscsi_itt_to_task(conn,
 				 login->itt & ISCSI_LOGIN_RESPONSE_INDEX);
 	if (!task)
@@ -1500,7 +1500,7 @@ static int bnx2i_process_login_resp(struct iscsi_session *session,
 		bnx2i_conn->gen_pdu.resp_buf,
 		bnx2i_conn->gen_pdu.resp_wr_ptr - bnx2i_conn->gen_pdu.resp_buf);
 done:
-	spin_unlock(&session->lock);
+	spin_unlock(&session->back_lock);
 	return 0;
 }
 
@@ -1525,7 +1525,7 @@ static int bnx2i_process_text_resp(struct iscsi_session *session,
 	int pad_len;
 
 	text = (struct bnx2i_text_response *) cqe;
-	spin_lock(&session->lock);
+	spin_lock(&session->back_lock);
 	task = iscsi_itt_to_task(conn, text->itt & ISCSI_LOGIN_RESPONSE_INDEX);
 	if (!task)
 		goto done;
@@ -1561,7 +1561,7 @@ static int bnx2i_process_text_resp(struct iscsi_session *session,
 			     bnx2i_conn->gen_pdu.resp_wr_ptr -
 			     bnx2i_conn->gen_pdu.resp_buf);
 done:
-	spin_unlock(&session->lock);
+	spin_unlock(&session->back_lock);
 	return 0;
 }
 
@@ -1584,7 +1584,7 @@ static int bnx2i_process_tmf_resp(struct iscsi_session *session,
 	struct iscsi_tm_rsp *resp_hdr;
 
 	tmf_cqe = (struct bnx2i_tmf_response *)cqe;
-	spin_lock(&session->lock);
+	spin_lock(&session->back_lock);
 	task = iscsi_itt_to_task(conn,
 				 tmf_cqe->itt & ISCSI_TMF_RESPONSE_INDEX);
 	if (!task)
@@ -1600,7 +1600,7 @@ static int bnx2i_process_tmf_resp(struct iscsi_session *session,
 
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr, NULL, 0);
 done:
-	spin_unlock(&session->lock);
+	spin_unlock(&session->back_lock);
 	return 0;
 }
 
@@ -1623,7 +1623,7 @@ static int bnx2i_process_logout_resp(struct iscsi_session *session,
 	struct iscsi_logout_rsp *resp_hdr;
 
 	logout = (struct bnx2i_logout_response *) cqe;
-	spin_lock(&session->lock);
+	spin_lock(&session->back_lock);
 	task = iscsi_itt_to_task(conn,
 				 logout->itt & ISCSI_LOGOUT_RESPONSE_INDEX);
 	if (!task)
@@ -1647,7 +1647,7 @@ static int bnx2i_process_logout_resp(struct iscsi_session *session,
 
 	bnx2i_conn->ep->state = EP_STATE_LOGOUT_RESP_RCVD;
 done:
-	spin_unlock(&session->lock);
+	spin_unlock(&session->back_lock);
 	return 0;
 }
 
@@ -1668,12 +1668,12 @@ static void bnx2i_process_nopin_local_cmpl(struct iscsi_session *session,
 	struct iscsi_task *task;
 
 	nop_in = (struct bnx2i_nop_in_msg *)cqe;
-	spin_lock(&session->lock);
+	spin_lock(&session->back_lock);
 	task = iscsi_itt_to_task(conn,
 				 nop_in->itt & ISCSI_NOP_IN_MSG_INDEX);
 	if (task)
 		__iscsi_put_task(task);
-	spin_unlock(&session->lock);
+	spin_unlock(&session->back_lock);
 }
 
 /**
@@ -1712,7 +1712,7 @@ static int bnx2i_process_nopin_mesg(struct iscsi_session *session,
 
 	nop_in = (struct bnx2i_nop_in_msg *)cqe;
 
-	spin_lock(&session->lock);
+	spin_lock(&session->back_lock);
 	hdr = (struct iscsi_nopin *)&bnx2i_conn->gen_pdu.resp_hdr;
 	memset(hdr, 0, sizeof(struct iscsi_hdr));
 	hdr->opcode = nop_in->op_code;
@@ -1738,7 +1738,7 @@ static int bnx2i_process_nopin_mesg(struct iscsi_session *session,
 	}
 done:
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr, NULL, 0);
-	spin_unlock(&session->lock);
+	spin_unlock(&session->back_lock);
 
 	return tgt_async_nop;
 }
@@ -1771,7 +1771,7 @@ static void bnx2i_process_async_mesg(struct iscsi_session *session,
 		return;
 	}
 
-	spin_lock(&session->lock);
+	spin_lock(&session->back_lock);
 	resp_hdr = (struct iscsi_async *) &bnx2i_conn->gen_pdu.resp_hdr;
 	memset(resp_hdr, 0, sizeof(struct iscsi_hdr));
 	resp_hdr->opcode = async_cqe->op_code;
@@ -1790,7 +1790,7 @@ static void bnx2i_process_async_mesg(struct iscsi_session *session,
 
 	__iscsi_complete_pdu(bnx2i_conn->cls_conn->dd_data,
 			     (struct iscsi_hdr *)resp_hdr, NULL, 0);
-	spin_unlock(&session->lock);
+	spin_unlock(&session->back_lock);
 }
 
 
@@ -1817,7 +1817,7 @@ static void bnx2i_process_reject_mesg(struct iscsi_session *session,
 	} else
 		bnx2i_unsol_pdu_adjust_rq(bnx2i_conn);
 
-	spin_lock(&session->lock);
+	spin_lock(&session->back_lock);
 	hdr = (struct iscsi_reject *) &bnx2i_conn->gen_pdu.resp_hdr;
 	memset(hdr, 0, sizeof(struct iscsi_hdr));
 	hdr->opcode = reject->op_code;
@@ -1828,7 +1828,7 @@ static void bnx2i_process_reject_mesg(struct iscsi_session *session,
 	hdr->ffffffff = cpu_to_be32(RESERVED_ITT);
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr, conn->data,
 			     reject->data_length);
-	spin_unlock(&session->lock);
+	spin_unlock(&session->back_lock);
 }
 
 /**
@@ -1848,13 +1848,13 @@ static void bnx2i_process_cmd_cleanup_resp(struct iscsi_session *session,
 	struct iscsi_task *task;
 
 	cmd_clean_rsp = (struct bnx2i_cleanup_response *)cqe;
-	spin_lock(&session->lock);
+	spin_lock(&session->back_lock);
 	task = iscsi_itt_to_task(conn,
 			cmd_clean_rsp->itt & ISCSI_CLEANUP_RESPONSE_INDEX);
 	if (!task)
 		printk(KERN_ALERT "bnx2i: cmd clean ITT %x not active\n",
 			cmd_clean_rsp->itt & ISCSI_CLEANUP_RESPONSE_INDEX);
-	spin_unlock(&session->lock);
+	spin_unlock(&session->back_lock);
 	complete(&bnx2i_conn->cmd_cleanup_cmpl);
 }
 
@@ -1921,11 +1921,11 @@ static int bnx2i_queue_scsi_cmd_resp(struct iscsi_session *session,
 	int rc = 0;
 	int cpu;
 
-	spin_lock(&session->lock);
+	spin_lock(&session->back_lock);
 	task = iscsi_itt_to_task(bnx2i_conn->cls_conn->dd_data,
 				 cqe->itt & ISCSI_CMD_RESPONSE_INDEX);
 	if (!task || !task->sc) {
-		spin_unlock(&session->lock);
+		spin_unlock(&session->back_lock);
 		return -EINVAL;
 	}
 	sc = task->sc;
@@ -1935,7 +1935,7 @@ static int bnx2i_queue_scsi_cmd_resp(struct iscsi_session *session,
 	else
 		cpu = sc->request->cpu;
 
-	spin_unlock(&session->lock);
+	spin_unlock(&session->back_lock);
 
 	p = &per_cpu(bnx2i_percpu, cpu);
 	spin_lock(&p->p_work_lock);
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 854dad7..c00642f 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1169,10 +1169,10 @@ static void bnx2i_cleanup_task(struct iscsi_task *task)
 	if (task->state == ISCSI_TASK_ABRT_TMF) {
 		bnx2i_send_cmd_cleanup_req(hba, task->dd_data);
 
-		spin_unlock_bh(&conn->session->lock);
+		spin_unlock_bh(&conn->session->back_lock);
 		wait_for_completion_timeout(&bnx2i_conn->cmd_cleanup_cmpl,
 				msecs_to_jiffies(ISCSI_CMD_CLEANUP_TIMEOUT));
-		spin_lock_bh(&conn->session->lock);
+		spin_lock_bh(&conn->session->back_lock);
 	}
 	bnx2i_iscsi_unmap_sg_list(task->dd_data);
 }
@@ -2059,7 +2059,7 @@ int bnx2i_hw_ep_disconnect(struct bnx2i_endpoint *bnx2i_ep)
 		goto out;
 
 	if (session) {
-		spin_lock_bh(&session->lock);
+		spin_lock_bh(&session->frwd_lock);
 		if (bnx2i_ep->state != EP_STATE_TCP_FIN_RCVD) {
 			if (session->state == ISCSI_STATE_LOGGING_OUT) {
 				if (bnx2i_ep->state == EP_STATE_LOGOUT_SENT) {
@@ -2075,7 +2075,7 @@ int bnx2i_hw_ep_disconnect(struct bnx2i_endpoint *bnx2i_ep)
 		} else
 			close = 1;
 
-		spin_unlock_bh(&session->lock);
+		spin_unlock_bh(&session->frwd_lock);
 	}
 
 	bnx2i_ep->state = EP_STATE_DISCONN_START;
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index add6d15..12b3512 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -593,9 +593,9 @@ static void iscsi_sw_tcp_release_conn(struct iscsi_conn *conn)
 	iscsi_sw_tcp_conn_restore_callbacks(conn);
 	sock_put(sock->sk);
 
-	spin_lock_bh(&session->lock);
+	spin_lock_bh(&session->frwd_lock);
 	tcp_sw_conn->sock = NULL;
-	spin_unlock_bh(&session->lock);
+	spin_unlock_bh(&session->frwd_lock);
 	sockfd_put(sock);
 }
 
@@ -663,10 +663,10 @@ iscsi_sw_tcp_conn_bind(struct iscsi_cls_session *cls_session,
 	if (err)
 		goto free_socket;
 
-	spin_lock_bh(&session->lock);
+	spin_lock_bh(&session->frwd_lock);
 	/* bind iSCSI connection and socket */
 	tcp_sw_conn->sock = sock;
-	spin_unlock_bh(&session->lock);
+	spin_unlock_bh(&session->frwd_lock);
 
 	/* setup Socket parameters */
 	sk = sock->sk;
@@ -726,14 +726,14 @@ static int iscsi_sw_tcp_conn_get_param(struct iscsi_cls_conn *cls_conn,
 	switch(param) {
 	case ISCSI_PARAM_CONN_PORT:
 	case ISCSI_PARAM_CONN_ADDRESS:
-		spin_lock_bh(&conn->session->lock);
+		spin_lock_bh(&conn->session->frwd_lock);
 		if (!tcp_sw_conn || !tcp_sw_conn->sock) {
-			spin_unlock_bh(&conn->session->lock);
+			spin_unlock_bh(&conn->session->frwd_lock);
 			return -ENOTCONN;
 		}
 		rc = kernel_getpeername(tcp_sw_conn->sock,
 					(struct sockaddr *)&addr, &len);
-		spin_unlock_bh(&conn->session->lock);
+		spin_unlock_bh(&conn->session->frwd_lock);
 		if (rc)
 			return rc;
 
@@ -759,23 +759,23 @@ static int iscsi_sw_tcp_host_get_param(struct Scsi_Host *shost,
 
 	switch (param) {
 	case ISCSI_HOST_PARAM_IPADDRESS:
-		spin_lock_bh(&session->lock);
+		spin_lock_bh(&session->frwd_lock);
 		conn = session->leadconn;
 		if (!conn) {
-			spin_unlock_bh(&session->lock);
+			spin_unlock_bh(&session->frwd_lock);
 			return -ENOTCONN;
 		}
 		tcp_conn = conn->dd_data;
 
 		tcp_sw_conn = tcp_conn->dd_data;
 		if (!tcp_sw_conn->sock) {
-			spin_unlock_bh(&session->lock);
+			spin_unlock_bh(&session->frwd_lock);
 			return -ENOTCONN;
 		}
 
 		rc = kernel_getsockname(tcp_sw_conn->sock,
 					(struct sockaddr *)&addr, &len);
-		spin_unlock_bh(&session->lock);
+		spin_unlock_bh(&session->frwd_lock);
 		if (rc)
 			return rc;
 
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 4046241..e77c41f 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -481,7 +481,7 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
  * iscsi_free_task - free a task
  * @task: iscsi cmd task
  *
- * Must be called with session lock.
+ * Must be called with session back_lock.
  * This function returns the scsi command to scsi-ml or cleans
  * up mgmt tasks then returns the task to the pool.
  */
@@ -535,9 +535,10 @@ void iscsi_put_task(struct iscsi_task *task)
 {
 	struct iscsi_session *session = task->conn->session;
 
-	spin_lock_bh(&session->lock);
+	/* regular RX path uses back_lock */
+	spin_lock_bh(&session->back_lock);
 	__iscsi_put_task(task);
-	spin_unlock_bh(&session->lock);
+	spin_unlock_bh(&session->back_lock);
 }
 EXPORT_SYMBOL_GPL(iscsi_put_task);
 
@@ -546,7 +547,7 @@ EXPORT_SYMBOL_GPL(iscsi_put_task);
  * @task: iscsi cmd task
  * @state: state to complete task with
  *
- * Must be called with session lock.
+ * Must be called with session back_lock.
  */
 static void iscsi_complete_task(struct iscsi_task *task, int state)
 {
@@ -585,7 +586,7 @@ static void iscsi_complete_task(struct iscsi_task *task, int state)
  * This is used when drivers do not need or cannot perform
  * lower level pdu processing.
  *
- * Called with session lock
+ * Called with session back_lock
  */
 void iscsi_complete_scsi_task(struct iscsi_task *task,
 			      uint32_t exp_cmdsn, uint32_t max_cmdsn)
@@ -602,7 +603,7 @@ EXPORT_SYMBOL_GPL(iscsi_complete_scsi_task);
 
 
 /*
- * session lock must be held and if not called for a task that is
+ * session back_lock must be held and if not called for a task that is
  * still pending or from the xmit thread, then xmit thread must
  * be suspended.
  */
@@ -642,7 +643,10 @@ static void fail_scsi_task(struct iscsi_task *task, int err)
 		scsi_in(sc)->resid = scsi_in(sc)->length;
 	}
 
+	/* regular RX path uses back_lock */
+	spin_lock_bh(&conn->session->back_lock);
 	iscsi_complete_task(task, state);
+	spin_unlock_bh(&conn->session->back_lock);
 }
 
 static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
@@ -780,7 +784,10 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	return task;
 
 free_task:
+	/* regular RX path uses back_lock */
+	spin_lock_bh(&session->back_lock);
 	__iscsi_put_task(task);
+	spin_unlock_bh(&session->back_lock);
 	return NULL;
 }
 
@@ -791,10 +798,10 @@ int iscsi_conn_send_pdu(struct iscsi_cls_conn *cls_conn, struct iscsi_hdr *hdr,
 	struct iscsi_session *session = conn->session;
 	int err = 0;
 
-	spin_lock_bh(&session->lock);
+	spin_lock_bh(&session->frwd_lock);
 	if (!__iscsi_conn_send_pdu(conn, hdr, data, data_size))
 		err = -EPERM;
-	spin_unlock_bh(&session->lock);
+	spin_unlock_bh(&session->frwd_lock);
 	return err;
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_send_pdu);
@@ -1031,14 +1038,19 @@ static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		if (opcode != ISCSI_OP_NOOP_OUT)
 			return 0;
 
-		 if (rejected_pdu.itt == cpu_to_be32(ISCSI_RESERVED_TAG))
+		 if (rejected_pdu.itt == cpu_to_be32(ISCSI_RESERVED_TAG)) {
 			/*
 			 * nop-out in response to target's nop-out rejected.
 			 * Just resend.
 			 */
+			/* In RX path we are under back lock */
+			spin_unlock(&conn->session->back_lock);
+			spin_lock(&conn->session->frwd_lock);
 			iscsi_send_nopout(conn,
 					  (struct iscsi_nopin*)&rejected_pdu);
-		else {
+			spin_unlock(&conn->session->frwd_lock);
+			spin_lock(&conn->session->back_lock);
+		} else {
 			struct iscsi_task *task;
 			/*
 			 * Our nop as ping got dropped. We know the target
@@ -1074,7 +1086,7 @@ static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
  * This should be used for mgmt tasks like login and nops, or if
  * the LDD's itt space does not include the session age.
  *
- * The session lock must be held.
+ * The session back_lock must be held.
  */
 struct iscsi_task *iscsi_itt_to_task(struct iscsi_conn *conn, itt_t itt)
 {
@@ -1103,7 +1115,7 @@ EXPORT_SYMBOL_GPL(iscsi_itt_to_task);
  * @datalen: len of data buffer
  *
  * Completes pdu processing by freeing any resources allocated at
- * queuecommand or send generic. session lock must be held and verify
+ * queuecommand or send generic. session back_lock must be held and verify
  * itt must have been called.
  */
 int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
@@ -1140,7 +1152,12 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			if (hdr->ttt == cpu_to_be32(ISCSI_RESERVED_TAG))
 				break;
 
+			/* In RX path we are under back lock */
+			spin_unlock(&session->back_lock);
+			spin_lock(&session->frwd_lock);
 			iscsi_send_nopout(conn, (struct iscsi_nopin*)hdr);
+			spin_unlock(&session->frwd_lock);
+			spin_lock(&session->back_lock);
 			break;
 		case ISCSI_OP_REJECT:
 			rc = iscsi_handle_reject(conn, hdr, data, datalen);
@@ -1247,9 +1264,9 @@ int iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 {
 	int rc;
 
-	spin_lock(&conn->session->lock);
+	spin_lock(&conn->session->back_lock);
 	rc = __iscsi_complete_pdu(conn, hdr, data, datalen);
-	spin_unlock(&conn->session->lock);
+	spin_unlock(&conn->session->back_lock);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(iscsi_complete_pdu);
@@ -1293,7 +1310,7 @@ EXPORT_SYMBOL_GPL(iscsi_verify_itt);
  *
  * This should be used for cmd tasks.
  *
- * The session lock must be held.
+ * The session back_lock must be held.
  */
 struct iscsi_task *iscsi_itt_to_ctask(struct iscsi_conn *conn, itt_t itt)
 {
@@ -1323,15 +1340,15 @@ void iscsi_session_failure(struct iscsi_session *session,
 	struct iscsi_conn *conn;
 	struct device *dev;
 
-	spin_lock_bh(&session->lock);
+	spin_lock_bh(&session->frwd_lock);
 	conn = session->leadconn;
 	if (session->state == ISCSI_STATE_TERMINATE || !conn) {
-		spin_unlock_bh(&session->lock);
+		spin_unlock_bh(&session->frwd_lock);
 		return;
 	}
 
 	dev = get_device(&conn->cls_conn->dev);
-	spin_unlock_bh(&session->lock);
+	spin_unlock_bh(&session->frwd_lock);
 	if (!dev)
 	        return;
 	/*
@@ -1351,15 +1368,15 @@ void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err)
 {
 	struct iscsi_session *session = conn->session;
 
-	spin_lock_bh(&session->lock);
+	spin_lock_bh(&session->frwd_lock);
 	if (session->state == ISCSI_STATE_FAILED) {
-		spin_unlock_bh(&session->lock);
+		spin_unlock_bh(&session->frwd_lock);
 		return;
 	}
 
 	if (conn->stop_stage == 0)
 		session->state = ISCSI_STATE_FAILED;
-	spin_unlock_bh(&session->lock);
+	spin_unlock_bh(&session->frwd_lock);
 
 	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
 	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
@@ -1393,15 +1410,18 @@ static int iscsi_xmit_task(struct iscsi_conn *conn)
 		return -ENODATA;
 
 	__iscsi_get_task(task);
-	spin_unlock_bh(&conn->session->lock);
+	spin_unlock_bh(&conn->session->frwd_lock);
 	rc = conn->session->tt->xmit_task(task);
-	spin_lock_bh(&conn->session->lock);
+	spin_lock_bh(&conn->session->frwd_lock);
 	if (!rc) {
 		/* done with this task */
 		task->last_xfer = jiffies;
 		conn->task = NULL;
 	}
+	/* regular RX path uses back_lock */
+	spin_lock_bh(&conn->session->back_lock);
 	__iscsi_put_task(task);
+	spin_unlock_bh(&conn->session->back_lock);
 	return rc;
 }
 
@@ -1410,7 +1430,7 @@ static int iscsi_xmit_task(struct iscsi_conn *conn)
  * @task: task to requeue
  *
  * LLDs that need to run a task from the session workqueue should call
- * this. The session lock must be held. This should only be called
+ * this. The session frwd_lock must be held. This should only be called
  * by software drivers.
  */
 void iscsi_requeue_task(struct iscsi_task *task)
@@ -1441,10 +1461,10 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 	struct iscsi_task *task;
 	int rc = 0;
 
-	spin_lock_bh(&conn->session->lock);
+	spin_lock_bh(&conn->session->frwd_lock);
 	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
 		ISCSI_DBG_SESSION(conn->session, "Tx suspended!\n");
-		spin_unlock_bh(&conn->session->lock);
+		spin_unlock_bh(&conn->session->frwd_lock);
 		return -ENODATA;
 	}
 
@@ -1465,7 +1485,10 @@ check_mgmt:
 					 struct iscsi_task, running);
 		list_del_init(&conn->task->running);
 		if (iscsi_prep_mgmt_task(conn, conn->task)) {
+			/* regular RX path uses back_lock */
+			spin_lock_bh(&conn->session->back_lock);
 			__iscsi_put_task(conn->task);
+			spin_unlock_bh(&conn->session->back_lock);
 			conn->task = NULL;
 			continue;
 		}
@@ -1527,11 +1550,11 @@ check_mgmt:
 		if (!list_empty(&conn->mgmtqueue))
 			goto check_mgmt;
 	}
-	spin_unlock_bh(&conn->session->lock);
+	spin_unlock_bh(&conn->session->frwd_lock);
 	return -ENODATA;
 
 done:
-	spin_unlock_bh(&conn->session->lock);
+	spin_unlock_bh(&conn->session->frwd_lock);
 	return rc;
 }
 
@@ -1600,7 +1623,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 
 	cls_session = starget_to_session(scsi_target(sc->device));
 	session = cls_session->dd_data;
-	spin_lock_bh(&session->lock);
+	spin_lock_bh(&session->frwd_lock);
 
 	reason = iscsi_session_chkready(cls_session);
 	if (reason) {
@@ -1686,13 +1709,13 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 	}
 
 	session->queued_cmdsn++;
-	spin_unlock_bh(&session->lock);
+	spin_unlock_bh(&session->frwd_lock);
 	return 0;
 
 prepd_reject:
 	iscsi_complete_task(task, ISCSI_TASK_REQUEUE_SCSIQ);
 reject:
-	spin_unlock_bh(&session->lock);
+	spin_unlock_bh(&session->frwd_lock);
 	ISCSI_DBG_SESSION(session, "cmd 0x%x rejected (%d)\n",
 			  sc->cmnd[0], reason);
 	return SCSI_MLQUEUE_TARGET_BUSY;
@@ -1700,7 +1723,7 @@ reject:
 prepd_fault:
 	iscsi_complete_task(task, ISCSI_TASK_REQUEUE_SCSIQ);
 fault:
-	spin_unlock_bh(&session->lock);
+	spin_unlock_bh(&session->frwd_lock);
 	ISCSI_DBG_SESSION(session, "iscsi: cmd 0x%x is not queued (%d)\n",
 			  sc->cmnd[0], reason);
 	if (!scsi_bidi_cmnd(sc))
@@ -1748,14 +1771,14 @@ static void iscsi_tmf_timedout(unsigned long data)
 	struct iscsi_conn *conn = (struct iscsi_conn *)data;
 	struct iscsi_session *session = conn->session;
 
-	spin_lock(&session->lock);
+	spin_lock(&session->frwd_lock);
 	if (conn->tmf_state == TMF_QUEUED) {
 		conn->tmf_state = TMF_TIMEDOUT;
 		ISCSI_DBG_EH(session, "tmf timedout\n");
 		/* unblock eh_abort() */
 		wake_up(&conn->ehwait);
 	}
-	spin_unlock(&session->lock);
+	spin_unlock(&session->frwd_lock);
 }
 
 static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
@@ -1768,10 +1791,10 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
 	task = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)hdr,
 				      NULL, 0);
 	if (!task) {
-		spin_unlock_bh(&session->lock);
+		spin_unlock_bh(&session->frwd_lock);
 		iscsi_conn_printk(KERN_ERR, conn, "Could not send TMF.\n");
 		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
-		spin_lock_bh(&session->lock);
+		spin_lock_bh(&session->frwd_lock);
 		return -EPERM;
 	}
 	conn->tmfcmd_pdus_cnt++;
@@ -1781,7 +1804,7 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
 	add_timer(&conn->tmf_timer);
 	ISCSI_DBG_EH(session, "tmf set timeout\n");
 
-	spin_unlock_bh(&session->lock);
+	spin_unlock_bh(&session->frwd_lock);
 	mutex_unlock(&session->eh_mutex);
 
 	/*
@@ -1800,7 +1823,7 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
 	del_timer_sync(&conn->tmf_timer);
 
 	mutex_lock(&session->eh_mutex);
-	spin_lock_bh(&session->lock);
+	spin_lock_bh(&session->frwd_lock);
 	/* if the session drops it will clean up the task */
 	if (age != session->age ||
 	    session->state != ISCSI_STATE_LOGGED_IN)
@@ -1837,7 +1860,7 @@ static void fail_scsi_tasks(struct iscsi_conn *conn, unsigned lun,
  * iscsi_suspend_queue - suspend iscsi_queuecommand
  * @conn: iscsi conn to stop queueing IO on
  *
- * This grabs the session lock to make sure no one is in
+ * This grabs the session frwd_lock to make sure no one is in
  * xmit_task/queuecommand, and then sets suspend to prevent
  * new commands from being queued. This only needs to be called
  * by offload drivers that need to sync a path like ep disconnect
@@ -1846,9 +1869,9 @@ static void fail_scsi_tasks(struct iscsi_conn *conn, unsigned lun,
  */
 void iscsi_suspend_queue(struct iscsi_conn *conn)
 {
-	spin_lock_bh(&conn->session->lock);
+	spin_lock_bh(&conn->session->frwd_lock);
 	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
-	spin_unlock_bh(&conn->session->lock);
+	spin_unlock_bh(&conn->session->frwd_lock);
 }
 EXPORT_SYMBOL_GPL(iscsi_suspend_queue);
 
@@ -1907,7 +1930,7 @@ static enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 
 	ISCSI_DBG_EH(session, "scsi cmd %p timedout\n", sc);
 
-	spin_lock(&session->lock);
+	spin_lock(&session->frwd_lock);
 	task = (struct iscsi_task *)sc->SCp.ptr;
 	if (!task) {
 		/*
@@ -2021,7 +2044,7 @@ static enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 done:
 	if (task)
 		task->last_timeout = jiffies;
-	spin_unlock(&session->lock);
+	spin_unlock(&session->frwd_lock);
 	ISCSI_DBG_EH(session, "return %s\n", rc == BLK_EH_RESET_TIMER ?
 		     "timer reset" : "nh");
 	return rc;
@@ -2033,7 +2056,7 @@ static void iscsi_check_transport_timeouts(unsigned long data)
 	struct iscsi_session *session = conn->session;
 	unsigned long recv_timeout, next_timeout = 0, last_recv;
 
-	spin_lock(&session->lock);
+	spin_lock(&session->frwd_lock);
 	if (session->state != ISCSI_STATE_LOGGED_IN)
 		goto done;
 
@@ -2050,7 +2073,7 @@ static void iscsi_check_transport_timeouts(unsigned long data)
 				  "last ping %lu, now %lu\n",
 				  conn->ping_timeout, conn->recv_timeout,
 				  last_recv, conn->last_ping, jiffies);
-		spin_unlock(&session->lock);
+		spin_unlock(&session->frwd_lock);
 		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
 		return;
 	}
@@ -2066,7 +2089,7 @@ static void iscsi_check_transport_timeouts(unsigned long data)
 	ISCSI_DBG_CONN(conn, "Setting next tmo %lu\n", next_timeout);
 	mod_timer(&conn->transport_timer, next_timeout);
 done:
-	spin_unlock(&session->lock);
+	spin_unlock(&session->frwd_lock);
 }
 
 static void iscsi_prep_abort_task_pdu(struct iscsi_task *task,
@@ -2096,7 +2119,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	ISCSI_DBG_EH(session, "aborting sc %p\n", sc);
 
 	mutex_lock(&session->eh_mutex);
-	spin_lock_bh(&session->lock);
+	spin_lock_bh(&session->frwd_lock);
 	/*
 	 * if session was ISCSI_STATE_IN_RECOVERY then we may not have
 	 * got the command.
@@ -2104,7 +2127,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	if (!sc->SCp.ptr) {
 		ISCSI_DBG_EH(session, "sc never reached iscsi layer or "
 				      "it completed.\n");
-		spin_unlock_bh(&session->lock);
+		spin_unlock_bh(&session->frwd_lock);
 		mutex_unlock(&session->eh_mutex);
 		return SUCCESS;
 	}
@@ -2115,7 +2138,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	 */
 	if (!session->leadconn || session->state != ISCSI_STATE_LOGGED_IN ||
 	    sc->SCp.phase != session->age) {
-		spin_unlock_bh(&session->lock);
+		spin_unlock_bh(&session->frwd_lock);
 		mutex_unlock(&session->eh_mutex);
 		ISCSI_DBG_EH(session, "failing abort due to dropped "
 				  "session.\n");
@@ -2156,7 +2179,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 
 	switch (conn->tmf_state) {
 	case TMF_SUCCESS:
-		spin_unlock_bh(&session->lock);
+		spin_unlock_bh(&session->frwd_lock);
 		/*
 		 * stop tx side incase the target had sent a abort rsp but
 		 * the initiator was still writing out data.
@@ -2167,15 +2190,15 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		 * good and have never sent us a successful tmf response
 		 * then sent more data for the cmd.
 		 */
-		spin_lock_bh(&session->lock);
+		spin_lock_bh(&session->frwd_lock);
 		fail_scsi_task(task, DID_ABORT);
 		conn->tmf_state = TMF_INITIAL;
 		memset(hdr, 0, sizeof(*hdr));
-		spin_unlock_bh(&session->lock);
+		spin_unlock_bh(&session->frwd_lock);
 		iscsi_start_tx(conn);
 		goto success_unlocked;
 	case TMF_TIMEDOUT:
-		spin_unlock_bh(&session->lock);
+		spin_unlock_bh(&session->frwd_lock);
 		iscsi_conn_failure(conn, ISCSI_ERR_SCSI_EH_SESSION_RST);
 		goto failed_unlocked;
 	case TMF_NOT_FOUND:
@@ -2194,7 +2217,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	}
 
 success:
-	spin_unlock_bh(&session->lock);
+	spin_unlock_bh(&session->frwd_lock);
 success_unlocked:
 	ISCSI_DBG_EH(session, "abort success [sc %p itt 0x%x]\n",
 		     sc, task->itt);
@@ -2202,7 +2225,7 @@ success_unlocked:
 	return SUCCESS;
 
 failed:
-	spin_unlock_bh(&session->lock);
+	spin_unlock_bh(&session->frwd_lock);
 failed_unlocked:
 	ISCSI_DBG_EH(session, "abort failed [sc %p itt 0x%x]\n", sc,
 		     task ? task->itt : 0);
@@ -2235,7 +2258,7 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 	ISCSI_DBG_EH(session, "LU Reset [sc %p lun %u]\n", sc, sc->device->lun);
 
 	mutex_lock(&session->eh_mutex);
-	spin_lock_bh(&session->lock);
+	spin_lock_bh(&session->frwd_lock);
 	/*
 	 * Just check if we are not logged in. We cannot check for
 	 * the phase because the reset could come from a ioctl.
@@ -2262,7 +2285,7 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 	case TMF_SUCCESS:
 		break;
 	case TMF_TIMEDOUT:
-		spin_unlock_bh(&session->lock);
+		spin_unlock_bh(&session->frwd_lock);
 		iscsi_conn_failure(conn, ISCSI_ERR_SCSI_EH_SESSION_RST);
 		goto done;
 	default:
@@ -2271,21 +2294,21 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 	}
 
 	rc = SUCCESS;
-	spin_unlock_bh(&session->lock);
+	spin_unlock_bh(&session->frwd_lock);
 
 	iscsi_suspend_tx(conn);
 
-	spin_lock_bh(&session->lock);
+	spin_lock_bh(&session->frwd_lock);
 	memset(hdr, 0, sizeof(*hdr));
 	fail_scsi_tasks(conn, sc->device->lun, DID_ERROR);
 	conn->tmf_state = TMF_INITIAL;
-	spin_unlock_bh(&session->lock);
+	spin_unlock_bh(&session->frwd_lock);
 
 	iscsi_start_tx(conn);
 	goto done;
 
 unlock:
-	spin_unlock_bh(&session->lock);
+	spin_unlock_bh(&session->frwd_lock);
 done:
 	ISCSI_DBG_EH(session, "dev reset result = %s\n",
 		     rc == SUCCESS ? "SUCCESS" : "FAILED");
@@ -2298,13 +2321,13 @@ void iscsi_session_recovery_timedout(struct iscsi_cls_session *cls_session)
 {
 	struct iscsi_session *session = cls_session->dd_data;
 
-	spin_lock_bh(&session->lock);
+	spin_lock_bh(&session->frwd_lock);
 	if (session->state != ISCSI_STATE_LOGGED_IN) {
 		session->state = ISCSI_STATE_RECOVERY_FAILED;
 		if (session->leadconn)
 			wake_up(&session->leadconn->ehwait);
 	}
-	spin_unlock_bh(&session->lock);
+	spin_unlock_bh(&session->frwd_lock);
 }
 EXPORT_SYMBOL_GPL(iscsi_session_recovery_timedout);
 
@@ -2326,19 +2349,19 @@ int iscsi_eh_session_reset(struct scsi_cmnd *sc)
 	conn = session->leadconn;
 
 	mutex_lock(&session->eh_mutex);
-	spin_lock_bh(&session->lock);
+	spin_lock_bh(&session->frwd_lock);
 	if (session->state == ISCSI_STATE_TERMINATE) {
 failed:
 		ISCSI_DBG_EH(session,
 			     "failing session reset: Could not log back into "
 			     "%s, %s [age %d]\n", session->targetname,
 			     conn->persistent_address, session->age);
-		spin_unlock_bh(&session->lock);
+		spin_unlock_bh(&session->frwd_lock);
 		mutex_unlock(&session->eh_mutex);
 		return FAILED;
 	}
 
-	spin_unlock_bh(&session->lock);
+	spin_unlock_bh(&session->frwd_lock);
 	mutex_unlock(&session->eh_mutex);
 	/*
 	 * we drop the lock here but the leadconn cannot be destoyed while
@@ -2355,14 +2378,14 @@ failed:
 		flush_signals(current);
 
 	mutex_lock(&session->eh_mutex);
-	spin_lock_bh(&session->lock);
+	spin_lock_bh(&session->frwd_lock);
 	if (session->state == ISCSI_STATE_LOGGED_IN) {
 		ISCSI_DBG_EH(session,
 			     "session reset succeeded for %s,%s\n",
 			     session->targetname, conn->persistent_address);
 	} else
 		goto failed;
-	spin_unlock_bh(&session->lock);
+	spin_unlock_bh(&session->frwd_lock);
 	mutex_unlock(&session->eh_mutex);
 	return SUCCESS;
 }
@@ -2398,7 +2421,7 @@ int iscsi_eh_target_reset(struct scsi_cmnd *sc)
 		     session->targetname);
 
 	mutex_lock(&session->eh_mutex);
-	spin_lock_bh(&session->lock);
+	spin_lock_bh(&session->frwd_lock);
 	/*
 	 * Just check if we are not logged in. We cannot check for
 	 * the phase because the reset could come from a ioctl.
@@ -2425,7 +2448,7 @@ int iscsi_eh_target_reset(struct scsi_cmnd *sc)
 	case TMF_SUCCESS:
 		break;
 	case TMF_TIMEDOUT:
-		spin_unlock_bh(&session->lock);
+		spin_unlock_bh(&session->frwd_lock);
 		iscsi_conn_failure(conn, ISCSI_ERR_SCSI_EH_SESSION_RST);
 		goto done;
 	default:
@@ -2434,21 +2457,21 @@ int iscsi_eh_target_reset(struct scsi_cmnd *sc)
 	}
 
 	rc = SUCCESS;
-	spin_unlock_bh(&session->lock);
+	spin_unlock_bh(&session->frwd_lock);
 
 	iscsi_suspend_tx(conn);
 
-	spin_lock_bh(&session->lock);
+	spin_lock_bh(&session->frwd_lock);
 	memset(hdr, 0, sizeof(*hdr));
 	fail_scsi_tasks(conn, -1, DID_ERROR);
 	conn->tmf_state = TMF_INITIAL;
-	spin_unlock_bh(&session->lock);
+	spin_unlock_bh(&session->frwd_lock);
 
 	iscsi_start_tx(conn);
 	goto done;
 
 unlock:
-	spin_unlock_bh(&session->lock);
+	spin_unlock_bh(&session->frwd_lock);
 done:
 	ISCSI_DBG_EH(session, "tgt %s reset result = %s\n", session->targetname,
 		     rc == SUCCESS ? "SUCCESS" : "FAILED");
@@ -2746,8 +2769,10 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 	session->max_r2t = 1;
 	session->tt = iscsit;
 	session->dd_data = cls_session->dd_data + sizeof(*session);
+
 	mutex_init(&session->eh_mutex);
-	spin_lock_init(&session->lock);
+	spin_lock_init(&session->frwd_lock);
+	spin_lock_init(&session->back_lock);
 
 	/* initialize SCSI PDU commands pool */
 	if (iscsi_pool_init(&session->cmdpool, session->cmds_max,
@@ -2861,14 +2886,14 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
 	INIT_WORK(&conn->xmitwork, iscsi_xmitworker);
 
 	/* allocate login_task used for the login/text sequences */
-	spin_lock_bh(&session->lock);
+	spin_lock_bh(&session->frwd_lock);
 	if (!kfifo_out(&session->cmdpool.queue,
                          (void*)&conn->login_task,
 			 sizeof(void*))) {
-		spin_unlock_bh(&session->lock);
+		spin_unlock_bh(&session->frwd_lock);
 		goto login_task_alloc_fail;
 	}
-	spin_unlock_bh(&session->lock);
+	spin_unlock_bh(&session->frwd_lock);
 
 	data = (char *) __get_free_pages(GFP_KERNEL,
 					 get_order(ISCSI_DEF_MAX_RECV_SEG_LEN));
@@ -2905,7 +2930,7 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 
 	del_timer_sync(&conn->transport_timer);
 
-	spin_lock_bh(&session->lock);
+	spin_lock_bh(&session->frwd_lock);
 	conn->c_stage = ISCSI_CONN_CLEANUP_WAIT;
 	if (session->leadconn == conn) {
 		/*
@@ -2914,7 +2939,7 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 		session->state = ISCSI_STATE_TERMINATE;
 		wake_up(&conn->ehwait);
 	}
-	spin_unlock_bh(&session->lock);
+	spin_unlock_bh(&session->frwd_lock);
 
 	/*
 	 * Block until all in-progress commands for this connection
@@ -2941,16 +2966,19 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 	/* flush queued up work because we free the connection below */
 	iscsi_suspend_tx(conn);
 
-	spin_lock_bh(&session->lock);
+	spin_lock_bh(&session->frwd_lock);
 	free_pages((unsigned long) conn->data,
 		   get_order(ISCSI_DEF_MAX_RECV_SEG_LEN));
 	kfree(conn->persistent_address);
 	kfree(conn->local_ipaddr);
+	/* regular RX path uses back_lock */
+	spin_lock_bh(&session->back_lock);
 	kfifo_in(&session->cmdpool.queue, (void*)&conn->login_task,
 		    sizeof(void*));
+	spin_unlock_bh(&session->back_lock);
 	if (session->leadconn == conn)
 		session->leadconn = NULL;
-	spin_unlock_bh(&session->lock);
+	spin_unlock_bh(&session->frwd_lock);
 
 	iscsi_destroy_conn(cls_conn);
 }
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 7f59073..e4bec58 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -446,7 +446,7 @@ iscsi_tcp_data_recv_prep(struct iscsi_tcp_conn *tcp_conn)
  * iscsi_tcp_cleanup_task - free tcp_task resources
  * @task: iscsi task
  *
- * must be called with session lock
+ * must be called with session back_lock
  */
 void iscsi_tcp_cleanup_task(struct iscsi_task *task)
 {
@@ -457,6 +457,7 @@ void iscsi_tcp_cleanup_task(struct iscsi_task *task)
 	if (!task->sc)
 		return;
 
+	spin_lock_bh(&tcp_task->queue2pool);
 	/* flush task's r2t queues */
 	while (kfifo_out(&tcp_task->r2tqueue, (void*)&r2t, sizeof(void*))) {
 		kfifo_in(&tcp_task->r2tpool.queue, (void*)&r2t,
@@ -470,6 +471,7 @@ void iscsi_tcp_cleanup_task(struct iscsi_task *task)
 			    sizeof(void*));
 		tcp_task->r2t = NULL;
 	}
+	spin_unlock_bh(&tcp_task->queue2pool);
 }
 EXPORT_SYMBOL_GPL(iscsi_tcp_cleanup_task);
 
@@ -577,11 +579,13 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
 		return ISCSI_ERR_DATALEN;
 	}
 
+	spin_lock(&tcp_task->pool2queue);
 	rc = kfifo_out(&tcp_task->r2tpool.queue, (void*)&r2t, sizeof(void*));
 	if (!rc) {
 		iscsi_conn_printk(KERN_ERR, conn, "Could not allocate R2T. "
 				  "Target has sent more R2Ts than it "
 				  "negotiated for or driver has leaked.\n");
+		spin_unlock(&tcp_task->pool2queue);
 		return ISCSI_ERR_PROTO;
 	}
 
@@ -596,6 +600,7 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
 	tcp_task->exp_datasn = r2tsn + 1;
 	kfifo_in(&tcp_task->r2tqueue, (void*)&r2t, sizeof(void*));
 	conn->r2t_pdus_cnt++;
+	spin_unlock(&tcp_task->pool2queue);
 
 	iscsi_requeue_task(task);
 	return 0;
@@ -668,14 +673,14 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 
 	switch(opcode) {
 	case ISCSI_OP_SCSI_DATA_IN:
-		spin_lock(&conn->session->lock);
+		spin_lock(&conn->session->back_lock);
 		task = iscsi_itt_to_ctask(conn, hdr->itt);
 		if (!task)
 			rc = ISCSI_ERR_BAD_ITT;
 		else
 			rc = iscsi_tcp_data_in(conn, task);
 		if (rc) {
-			spin_unlock(&conn->session->lock);
+			spin_unlock(&conn->session->back_lock);
 			break;
 		}
 
@@ -708,11 +713,11 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 						   tcp_conn->in.datalen,
 						   iscsi_tcp_process_data_in,
 						   rx_hash);
-			spin_unlock(&conn->session->lock);
+			spin_unlock(&conn->session->back_lock);
 			return rc;
 		}
 		rc = __iscsi_complete_pdu(conn, hdr, NULL, 0);
-		spin_unlock(&conn->session->lock);
+		spin_unlock(&conn->session->back_lock);
 		break;
 	case ISCSI_OP_SCSI_CMD_RSP:
 		if (tcp_conn->in.datalen) {
@@ -722,18 +727,20 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 		rc = iscsi_complete_pdu(conn, hdr, NULL, 0);
 		break;
 	case ISCSI_OP_R2T:
-		spin_lock(&conn->session->lock);
+		spin_lock(&conn->session->back_lock);
 		task = iscsi_itt_to_ctask(conn, hdr->itt);
+		spin_unlock(&conn->session->back_lock);
 		if (!task)
 			rc = ISCSI_ERR_BAD_ITT;
 		else if (ahslen)
 			rc = ISCSI_ERR_AHSLEN;
 		else if (task->sc->sc_data_direction == DMA_TO_DEVICE) {
 			task->last_xfer = jiffies;
+			spin_lock(&conn->session->frwd_lock);
 			rc = iscsi_tcp_r2t_rsp(conn, task);
+			spin_unlock(&conn->session->frwd_lock);
 		} else
 			rc = ISCSI_ERR_PROTO;
-		spin_unlock(&conn->session->lock);
 		break;
 	case ISCSI_OP_LOGIN_RSP:
 	case ISCSI_OP_TEXT_RSP:
@@ -981,14 +988,13 @@ EXPORT_SYMBOL_GPL(iscsi_tcp_task_init);
 
 static struct iscsi_r2t_info *iscsi_tcp_get_curr_r2t(struct iscsi_task *task)
 {
-	struct iscsi_session *session = task->conn->session;
 	struct iscsi_tcp_task *tcp_task = task->dd_data;
 	struct iscsi_r2t_info *r2t = NULL;
 
 	if (iscsi_task_has_unsol_data(task))
 		r2t = &task->unsol_r2t;
 	else {
-		spin_lock_bh(&session->lock);
+		spin_lock_bh(&tcp_task->queue2pool);
 		if (tcp_task->r2t) {
 			r2t = tcp_task->r2t;
 			/* Continue with this R2T? */
@@ -1010,7 +1016,7 @@ static struct iscsi_r2t_info *iscsi_tcp_get_curr_r2t(struct iscsi_task *task)
 			else
 				r2t = tcp_task->r2t;
 		}
-		spin_unlock_bh(&session->lock);
+		spin_unlock_bh(&tcp_task->queue2pool);
 	}
 
 	return r2t;
@@ -1140,6 +1146,8 @@ int iscsi_tcp_r2tpool_alloc(struct iscsi_session *session)
 			iscsi_pool_free(&tcp_task->r2tpool);
 			goto r2t_alloc_fail;
 		}
+		spin_lock_init(&tcp_task->pool2queue);
+		spin_lock_init(&tcp_task->queue2pool);
 	}
 
 	return 0;
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index a3c8bc7..dc05c37 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -385,9 +385,9 @@ static void qla4xxx_passthru_status_entry(struct scsi_qla_host *ha,
 
 	cls_conn = ddb_entry->conn;
 	conn = cls_conn->dd_data;
-	spin_lock(&conn->session->lock);
+	spin_lock(&conn->session->back_lock);
 	task = iscsi_itt_to_task(conn, itt);
-	spin_unlock(&conn->session->lock);
+	spin_unlock(&conn->session->back_lock);
 
 	if (task == NULL) {
 		ql4_printk(KERN_ERR, ha, "%s: Task is NULL\n", __func__);
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 309f513..7221a24 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -327,12 +327,19 @@ struct iscsi_session {
 	struct iscsi_transport	*tt;
 	struct Scsi_Host	*host;
 	struct iscsi_conn	*leadconn;	/* leading connection */
-	spinlock_t		lock;		/* protects session state, *
-						 * sequence numbers,       *
+	/* Between the forward and the backward locks exists a strict locking
+	 * hierarchy. The mutual exclusion zone protected by the forward lock
+	 * can enclose the mutual exclusion zone protected by the backward lock
+	 * but not vice versa.
+	 */
+	spinlock_t		frwd_lock;	/* protects session state, *
+						 * cmdsn, queued_cmdsn     *
 						 * session resources:      *
-						 * - cmdpool,		   *
-						 * - mgmtpool,		   *
-						 * - r2tpool		   */
+						 * - cmdpool kfifo_out ,   *
+						 * - mgmtpool,		   */
+	spinlock_t		back_lock;	/* protects cmdsn_exp      *
+						 * cmdsn_max,              *
+						 * cmdpool kfifo_in        */
 	int			state;		/* session state           */
 	int			age;		/* counts session re-opens */
 
diff --git a/include/scsi/libiscsi_tcp.h b/include/scsi/libiscsi_tcp.h
index 215469a..2a7aa75 100644
--- a/include/scsi/libiscsi_tcp.h
+++ b/include/scsi/libiscsi_tcp.h
@@ -83,6 +83,8 @@ struct iscsi_tcp_task {
 	struct iscsi_pool	r2tpool;
 	struct kfifo		r2tqueue;
 	void			*dd_data;
+	spinlock_t		pool2queue;
+	spinlock_t		queue2pool;
 };
 
 enum {
-- 
1.7.1

