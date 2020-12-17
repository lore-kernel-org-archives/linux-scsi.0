Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BB0EC4361B
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 06:45:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5876023437
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 06:45:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgLQGpd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Dec 2020 01:45:33 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:49318 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgLQGpd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Dec 2020 01:45:33 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BH6Tx41164285;
        Thu, 17 Dec 2020 06:44:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=JQHrQF9jEptUOrZS0oMo+Jp5lqte4w52436RrW65P/U=;
 b=s5UjtoJJY0eZtFr7/p8mf8hY0B9JaaciMO0PXpB733jpPZr4oZ+IM3YoluGMOoGACrDv
 CSRr97aaYHs/tnDDLn5yK8MPwIq5uK6l62i3M8J5riQ23CVM9wZy/leLPaZE8LCtWdHt
 4WVdRrkgPmrxsp7DHRILkh2HcPXSiNRly8Ud66lZNhc/pX92Q9Vzam7La9hxQfOrTps0
 Ddj+8vCWcY4OarYYPsIOXtMfdzBhUZQLtdsrUoY5KRBfpGvNEfZ9E1drOyllj6T9VZ39
 hi2fajM+2jPklnjEp2SLXt1HJAJ/CHhINAMV141o02Bm8CU/+4z2UW3pbVWq9Hnst3WS 7g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35cntmbujp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Dec 2020 06:44:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BH6VFuc178225;
        Thu, 17 Dec 2020 06:42:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 35e6jts21m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Dec 2020 06:42:38 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BH6gbOG018280;
        Thu, 17 Dec 2020 06:42:37 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Dec 2020 22:42:37 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Subject: [PATCH 20/22] libiscsi: rm iscsi_put_task back_lock requirement
Date:   Thu, 17 Dec 2020 00:42:10 -0600
Message-Id: <1608187332-4434-21-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1608187332-4434-1-git-send-email-michael.christie@oracle.com>
References: <1608187332-4434-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9837 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012170047
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9837 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012170047
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds a new lock around the mgmt pool, so we no longer need
the back lock when calling iscsi_put_task. This helps in the xmit path
where we are taking it to drop the refcount. The next patch will allow
us to completely remove the back lock from the xmit path.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/be2iscsi/be_main.c |  6 ++--
 drivers/scsi/bnx2i/bnx2i_hwi.c  |  2 +-
 drivers/scsi/libiscsi.c         | 78 ++++++++++++++++++-----------------------
 drivers/scsi/libiscsi_tcp.c     |  2 +-
 drivers/scsi/qedi/qedi_fw.c     | 11 ++----
 include/scsi/libiscsi.h         | 13 ++++---
 6 files changed, 48 insertions(+), 64 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index bb305ee..dff07962 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -236,7 +236,7 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
 		return SUCCESS;
 	}
 	/* get a task ref till FW processes the req for the ICD used */
-	__iscsi_get_task(abrt_task);
+	iscsi_get_task(abrt_task);
 	abrt_io_task = abrt_task->dd_data;
 	conn = abrt_task->conn;
 	beiscsi_conn = conn->dd_data;
@@ -289,7 +289,7 @@ static bool beiscsi_dev_reset_sc_iter(struct scsi_cmnd *sc, void *data,
 		return false;
 
 	/* get a task ref till FW processes the req for the ICD used */
-	__iscsi_get_task(task);
+	iscsi_get_task(task);
 	io_task = task->dd_data;
 	/* mark WRB invalid which have been not processed by FW yet */
 	if (is_chip_be2_be3r(phba)) {
@@ -1262,7 +1262,7 @@ static struct sgl_handle *alloc_mgmt_sgl_handle(struct beiscsi_hba *phba)
 	spin_lock_bh(&session->back_lock);
 	task = pwrb_handle->pio_handle;
 	if (task)
-		__iscsi_put_task(task);
+		iscsi_put_task(task);
 	spin_unlock_bh(&session->back_lock);
 }
 
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 7e53684..2b28221 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1657,7 +1657,7 @@ static void bnx2i_process_nopin_local_cmpl(struct iscsi_session *session,
 	task = iscsi_itt_to_task(conn,
 				 nop_in->itt & ISCSI_NOP_IN_MSG_INDEX);
 	if (task)
-		__iscsi_put_task(task);
+		iscsi_put_task(task);
 	spin_unlock(&session->back_lock);
 }
 
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index ef9fd93..869c38d 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -475,7 +475,6 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
  * iscsi_free_task - free a task
  * @task: iscsi cmd task
  *
- * Must be called with session back_lock.
  * This function returns the scsi command to scsi-ml or cleans
  * up mgmt tasks then returns the task to the pool.
  */
@@ -509,7 +508,9 @@ static void iscsi_free_task(struct iscsi_task *task)
 	}
 
 	if (!sc) {
+		spin_lock_bh(&session->mgmt_lock);
 		kfifo_in(&session->mgmt_pool.queue, (void *)&task, sizeof(void *));
+		spin_unlock_bh(&session->mgmt_lock);
 	} else {
 		/* SCSI eh reuses commands to verify us */
 		sc->SCp.ptr = NULL;
@@ -522,28 +523,17 @@ static void iscsi_free_task(struct iscsi_task *task)
 	}
 }
 
-void __iscsi_get_task(struct iscsi_task *task)
+void iscsi_get_task(struct iscsi_task *task)
 {
 	refcount_inc(&task->refcount);
 }
-EXPORT_SYMBOL_GPL(__iscsi_get_task);
+EXPORT_SYMBOL_GPL(iscsi_get_task);
 
-void __iscsi_put_task(struct iscsi_task *task)
+void iscsi_put_task(struct iscsi_task *task)
 {
 	if (refcount_dec_and_test(&task->refcount))
 		iscsi_free_task(task);
 }
-EXPORT_SYMBOL_GPL(__iscsi_put_task);
-
-void iscsi_put_task(struct iscsi_task *task)
-{
-	struct iscsi_session *session = task->conn->session;
-
-	/* regular RX path uses back_lock */
-	spin_lock_bh(&session->back_lock);
-	__iscsi_put_task(task);
-	spin_unlock_bh(&session->back_lock);
-}
 EXPORT_SYMBOL_GPL(iscsi_put_task);
 
 /**
@@ -572,7 +562,7 @@ static void iscsi_complete_task(struct iscsi_task *task, int state)
 		WRITE_ONCE(conn->ping_task, NULL);
 
 	/* release get from queueing */
-	__iscsi_put_task(task);
+	iscsi_put_task(task);
 }
 
 /**
@@ -619,12 +609,12 @@ static bool cleanup_queued_task(struct iscsi_task *task)
 		 * list
 		 */
 		if (task->state == ISCSI_TASK_RUNNING)
-			__iscsi_put_task(task);
+			iscsi_put_task(task);
 	}
 
 	if (conn->task == task) {
 		conn->task = NULL;
-		__iscsi_put_task(task);
+		iscsi_put_task(task);
 	}
 
 	return early_complete;
@@ -749,9 +739,13 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
 		BUG_ON(conn->c_stage == ISCSI_CONN_INITIAL_STAGE);
 		BUG_ON(conn->c_stage == ISCSI_CONN_STOPPED);
 
+		spin_lock_bh(&session->mgmt_lock);
 		if (!kfifo_out(&session->mgmt_pool.queue, (void *)&task,
-			       sizeof(void *)))
+			       sizeof(void *))) {
+			spin_unlock_bh(&session->mgmt_lock);
 			return NULL;
+		}
+		spin_unlock_bh(&session->mgmt_lock);
 	}
 	/*
 	 * released in complete pdu for task we expect a response for, and
@@ -807,10 +801,7 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
 	return task;
 
 free_task:
-	/* regular RX path uses back_lock */
-	spin_lock(&session->back_lock);
-	__iscsi_put_task(task);
-	spin_unlock(&session->back_lock);
+	iscsi_put_task(task);
 	return NULL;
 }
 
@@ -1457,16 +1448,15 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, bool has_extra_ref)
 	int rc;
 
 	/* Take a ref so we can access it after xmit_task() */
-	__iscsi_get_task(task);
+	iscsi_get_task(task);
 	conn->task = NULL;
-	spin_lock_bh(&conn->session->back_lock);
 	/*
 	 * If this was a requeue for a R2T or we were in the middle of sending
 	 * the task, we have an extra ref on the task in case a bad target
 	 * sends a cmd rsp before we have handled the task.
 	 */
 	if (has_extra_ref)
-		__iscsi_put_task(task);
+		iscsi_put_task(task);
 
 	/*
 	 * Do this after dropping the extra ref because if this was a requeue
@@ -1476,8 +1466,6 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, bool has_extra_ref)
 		rc = -ENODATA;
 		goto put_task;
 	}
-	spin_unlock_bh(&conn->session->back_lock);
-
 	spin_unlock_bh(&conn->session->frwd_lock);
 	rc = conn->session->tt->xmit_task(task);
 	spin_lock_bh(&conn->session->frwd_lock);
@@ -1492,12 +1480,13 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, bool has_extra_ref)
 		 * get an extra ref that is released next time we access it
 		 * as conn->task above.
 		 */
-		__iscsi_get_task(task);
+		iscsi_get_task(task);
 		conn->task = task;
 	}
-put_task:
-	__iscsi_put_task(task);
 	spin_unlock(&conn->session->back_lock);
+
+put_task:
+	iscsi_put_task(task);
 	return rc;
 }
 
@@ -1568,10 +1557,7 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 				  running);
 		list_del_init(&task->running);
 		if (iscsi_prep_mgmt_task(conn, task)) {
-			/* regular RX path uses back_lock */
-			spin_lock_bh(&conn->session->back_lock);
-			__iscsi_put_task(task);
-			spin_unlock_bh(&conn->session->back_lock);
+			iscsi_put_task(task);
 			continue;
 		}
 		conn->task = task;
@@ -1909,7 +1895,7 @@ static bool fail_scsi_task_iter(struct scsi_cmnd *sc, void *data, bool rsvd)
 
 	ISCSI_DBG_SESSION(session, "failing sc %p itt 0x%x state %d\n",
 			  task->sc, task->itt, task->state);
-	__iscsi_get_task(task);
+	iscsi_get_task(task);
 	spin_unlock_bh(&session->back_lock);
 
 	fail_scsi_task(task, *(int *)iter_data->data);
@@ -2084,7 +2070,7 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 		spin_unlock(&session->back_lock);
 		goto done;
 	}
-	__iscsi_get_task(task);
+	iscsi_get_task(task);
 	spin_unlock(&session->back_lock);
 
 	if (session->state != ISCSI_STATE_LOGGED_IN) {
@@ -2303,7 +2289,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		return SUCCESS;
 	}
 	ISCSI_DBG_EH(session, "aborting [sc %p itt 0x%x]\n", sc, task->itt);
-	__iscsi_get_task(task);
+	iscsi_get_task(task);
 	spin_unlock(&session->back_lock);
 
 	if (task->state == ISCSI_TASK_PENDING) {
@@ -2937,6 +2923,7 @@ struct iscsi_cls_session *
 	session->dd_data = cls_session->dd_data + sizeof(*session);
 
 	mutex_init(&session->eh_mutex);
+	spin_lock_init(&session->mgmt_lock);
 	spin_lock_init(&session->frwd_lock);
 	spin_lock_init(&session->back_lock);
 
@@ -3064,13 +3051,13 @@ struct iscsi_cls_conn *
 	INIT_WORK(&conn->xmitwork, iscsi_xmitworker);
 
 	/* allocate login_task used for the login/text sequences */
-	spin_lock_bh(&session->frwd_lock);
+	spin_lock_bh(&session->mgmt_lock);
 	if (!kfifo_out(&session->mgmt_pool.queue, (void *)&conn->login_task,
 		       sizeof(void *))) {
-		spin_unlock_bh(&session->frwd_lock);
+		spin_unlock_bh(&session->mgmt_lock);
 		goto login_task_alloc_fail;
 	}
-	spin_unlock_bh(&session->frwd_lock);
+	spin_unlock_bh(&session->mgmt_lock);
 
 	data = (char *) __get_free_pages(GFP_KERNEL,
 					 get_order(ISCSI_DEF_MAX_RECV_SEG_LEN));
@@ -3084,8 +3071,10 @@ struct iscsi_cls_conn *
 	return cls_conn;
 
 login_task_data_alloc_fail:
+	spin_lock_bh(&session->mgmt_lock);
 	kfifo_in(&session->mgmt_pool.queue, (void*)&conn->login_task,
 		 sizeof(void *));
+	spin_unlock_bh(&session->mgmt_lock);
 login_task_alloc_fail:
 	iscsi_destroy_conn(cls_conn);
 	return NULL;
@@ -3126,11 +3115,12 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 		   get_order(ISCSI_DEF_MAX_RECV_SEG_LEN));
 	kfree(conn->persistent_address);
 	kfree(conn->local_ipaddr);
-	/* regular RX path uses back_lock */
-	spin_lock_bh(&session->back_lock);
+
+	spin_lock_bh(&session->mgmt_lock);
 	kfifo_in(&session->mgmt_pool.queue, (void *)&conn->login_task,
 		 sizeof(void *));
-	spin_unlock_bh(&session->back_lock);
+	spin_unlock_bh(&session->mgmt_lock);
+
 	if (session->leadconn == conn)
 		session->leadconn = NULL;
 	spin_unlock_bh(&session->frwd_lock);
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 9619097..6bd1e95 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -558,7 +558,7 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 		return 0;
 	}
 	task->last_xfer = jiffies;
-	__iscsi_get_task(task);
+	iscsi_get_task(task);
 
 	tcp_conn = conn->dd_data;
 	rhdr = (struct iscsi_r2t_rsp *)tcp_conn->in.hdr;
diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index d93a6b2..2a40c42 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -727,11 +727,8 @@ static void qedi_mtask_completion(struct qedi_ctx *qedi,
 
 static void qedi_process_nopin_local_cmpl(struct qedi_ctx *qedi,
 					  struct iscsi_cqe_solicited *cqe,
-					  struct iscsi_task *task,
-					  struct qedi_conn *qedi_conn)
+					  struct iscsi_task *task)
 {
-	struct iscsi_conn *conn = qedi_conn->cls_conn->dd_data;
-	struct iscsi_session *session = conn->session;
 	struct qedi_cmd *cmd = task->dd_data;
 
 	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_UNSOL,
@@ -741,9 +738,7 @@ static void qedi_process_nopin_local_cmpl(struct qedi_ctx *qedi,
 	cmd->state = RESPONSE_RECEIVED;
 	qedi_clear_task_idx(qedi, cmd->task_id);
 
-	spin_lock_bh(&session->back_lock);
-	__iscsi_put_task(task);
-	spin_unlock_bh(&session->back_lock);
+	iscsi_put_task(task);
 }
 
 static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
@@ -935,7 +930,7 @@ void qedi_fp_process_cqes(struct qedi_work *work)
 		if ((nopout_hdr->itt == RESERVED_ITT) &&
 		    (cqe->cqe_solicited.itid != (u16)RESERVED_ITT)) {
 			qedi_process_nopin_local_cmpl(qedi, &cqe->cqe_solicited,
-						      task, q_conn);
+						      task);
 		} else {
 			cqe->cqe_solicited.itid =
 					       qedi_get_itt(cqe->cqe_solicited);
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 7be30e0..3fa7d90 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -339,19 +339,19 @@ struct iscsi_session {
 	spinlock_t		frwd_lock;	/* protects session state  *
 						 * in the eh paths, cmdsn  *
 						 * suspend bit and session *
-						 * resources:              *
-						 * - mgmt_pool, kfifo_out, *
-						 * - queues	   */
+						 * queues                  */
 	spinlock_t		back_lock;	/* protects cmdsn_exp      *
-						 * cmdsn_max,              *
-						 * mgmt_pool kfifo_i       */
+						 * cmdsn_max,              */
 	int			state;		/* session state           */
 	int			age;		/* counts session re-opens */
 
 	int			scsi_cmds_max; 	/* max scsi commands */
 	int			cmds_max;	/* size of cmds array */
+
 	struct iscsi_task	**mgmt_cmds;	/* mgmt task arr */
 	struct iscsi_pool	mgmt_pool;	/* mgmt task pool */
+	spinlock_t		mgmt_lock;	/* protects mgmt pool/arr */
+
 	void			*dd_data;	/* LLD private data */
 };
 
@@ -464,8 +464,7 @@ extern int __iscsi_complete_pdu(struct iscsi_conn *, struct iscsi_hdr *,
 extern struct iscsi_task *iscsi_itt_to_task(struct iscsi_conn *, itt_t);
 extern void iscsi_requeue_task(struct iscsi_task *task);
 extern void iscsi_put_task(struct iscsi_task *task);
-extern void __iscsi_put_task(struct iscsi_task *task);
-extern void __iscsi_get_task(struct iscsi_task *task);
+extern void iscsi_get_task(struct iscsi_task *task);
 extern void iscsi_complete_scsi_task(struct iscsi_task *task,
 				     uint32_t exp_cmdsn, uint32_t max_cmdsn);
 extern int iscsi_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *cmd);
-- 
1.8.3.1

