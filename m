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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41C7BC433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Dec 2020 03:11:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 126142310B
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Dec 2020 03:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390392AbgLMDKn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 12 Dec 2020 22:10:43 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60646 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388644AbgLMDKF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Dec 2020 22:10:05 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BD33bM6156190;
        Sun, 13 Dec 2020 03:09:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=DBFtJeIPwPAfj4iScInw6AHx9TCe7LSBLbAeLQNEmR4=;
 b=V86+yQuhaL4vgsQvIncIzwhaOB1wvJrwEz57a4tvi7W9JdNz2XHVKooZatRXkAPprWbi
 qe/aqKDTDclnGdpH5xbfKP2EX/0Xb5rFTzRBzXfUAyXmOpr1qrZ3gFnFsDOfb2bnp2zG
 iiKVuIpBsUbzvZj6lZsUCBXTmgNSmXXIX3XO43m+Bt+4XU1FUDdiREBRmU4RHUiHrdJK
 NIOUGD9xJOV1sdQ7Y2vhnYxS4Wj1lmmK3ft6r8BfBXjsfW/RCNeTnzkthFL/b7tHSOGh
 84VLzT0KkTotmdfwddsGLJMwLqahYYM4qCxw9zUyE0Gir+qkC4OdEdd4TrWL+qgrykuq 7w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 35ckcb1ph9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 13 Dec 2020 03:09:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BD36ixw181144;
        Sun, 13 Dec 2020 03:09:13 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 35d7rvaej3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 13 Dec 2020 03:09:13 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BD39Cc6013866;
        Sun, 13 Dec 2020 03:09:12 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 12 Dec 2020 19:09:12 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Subject: [RFC PATCH 16/18] libiscsi: drop back_lock requirement for iscsi_put_task
Date:   Sat, 12 Dec 2020 21:08:44 -0600
Message-Id: <1607828926-3658-17-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1607828926-3658-1-git-send-email-michael.christie@oracle.com>
References: <1607828926-3658-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9833 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012130023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9833 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012130023
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
 drivers/scsi/libiscsi.c         | 77 +++++++++++++++++------------------------
 drivers/scsi/libiscsi_tcp.c     |  2 +-
 drivers/scsi/qedi/qedi_fw.c     | 11 ++----
 include/scsi/libiscsi.h         |  4 +--
 6 files changed, 42 insertions(+), 60 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 91bc822..cb86aec 100644
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
@@ -321,7 +321,7 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 		}
 
 		/* get a task ref till FW processes the req for the ICD used */
-		__iscsi_get_task(task);
+		iscsi_get_task(task);
 		io_task = task->dd_data;
 		/* mark WRB invalid which have been not processed by FW yet */
 		if (is_chip_be2_be3r(phba)) {
@@ -1245,7 +1245,7 @@ static struct sgl_handle *alloc_mgmt_sgl_handle(struct beiscsi_hba *phba)
 	spin_lock_bh(&session->back_lock);
 	task = pwrb_handle->pio_handle;
 	if (task)
-		__iscsi_put_task(task);
+		iscsi_put_task(task);
 	spin_unlock_bh(&session->back_lock);
 }
 
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index bad396e..54b9c40 100644
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
index e46f9ea..f4881f0 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -526,7 +526,6 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
  * iscsi_free_task - free a task
  * @task: iscsi cmd task
  *
- * Must be called with session back_lock.
  * This function returns the scsi command to scsi-ml or cleans
  * up mgmt tasks then returns the task to the pool.
  */
@@ -562,7 +561,9 @@ static void iscsi_free_task(struct iscsi_task *task)
 	}
 
 	if (!sc) {
+		spin_lock_bh(&session->mgmt_lock);
 		kfifo_in(&session->mgmt_pool.queue, (void *)&task, sizeof(void *));
+		spin_unlock_bh(&session->mgmt_lock);
 	} else {
 		/* SCSI eh reuses commands to verify us */
 		sc->SCp.ptr = NULL;
@@ -575,28 +576,17 @@ static void iscsi_free_task(struct iscsi_task *task)
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
@@ -625,7 +615,7 @@ static void iscsi_complete_task(struct iscsi_task *task, int state)
 		WRITE_ONCE(conn->ping_task, NULL);
 
 	/* release get from queueing */
-	__iscsi_put_task(task);
+	iscsi_put_task(task);
 }
 
 /**
@@ -672,12 +662,12 @@ static bool cleanup_queued_task(struct iscsi_task *task)
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
@@ -812,17 +802,20 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
 		BUG_ON(conn->c_stage == ISCSI_CONN_INITIAL_STAGE);
 		BUG_ON(conn->c_stage == ISCSI_CONN_STOPPED);
 
+		spin_lock_bh(&session->mgmt_lock);
 		if (!kfifo_out(&session->mgmt_pool.queue, (void *)&task,
-			       sizeof(void *)))
+			       sizeof(void *))) {
+			spin_unlock_bh(&session->mgmt_lock);
 			return NULL;
+		}
 
 		if (iscsi_alloc_itt(session, task)) {
-			spin_lock(&session->back_lock);
 			kfifo_in(&session->mgmt_pool.queue, (void *)&task,
 				 sizeof(void *));
-			spin_unlock(&session->back_lock);
+			spin_unlock_bh(&session->mgmt_lock);
 			return NULL;
 		}
+		spin_unlock_bh(&session->mgmt_lock);
 	}
 	/*
 	 * released in complete pdu for task we expect a response for, and
@@ -878,10 +871,7 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
 	return task;
 
 free_task:
-	/* regular RX path uses back_lock */
-	spin_lock(&session->back_lock);
-	__iscsi_put_task(task);
-	spin_unlock(&session->back_lock);
+	iscsi_put_task(task);
 	return NULL;
 }
 
@@ -1522,16 +1512,15 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, bool has_extra_ref)
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
 	 * Do this after dropping the extra ref because the forced dequeue
@@ -1541,8 +1530,6 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, bool has_extra_ref)
 		rc = -ENODATA;
 		goto put_task;
 	}
-	spin_unlock_bh(&conn->session->back_lock);
-
 	spin_unlock_bh(&conn->session->frwd_lock);
 	rc = conn->session->tt->xmit_task(task);
 	spin_lock_bh(&conn->session->frwd_lock);
@@ -1557,12 +1544,13 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, bool has_extra_ref)
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
 
@@ -1633,10 +1621,7 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
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
@@ -2937,6 +2922,7 @@ struct iscsi_cls_session *
 	session->dd_data = cls_session->dd_data + sizeof(*session);
 
 	mutex_init(&session->eh_mutex);
+	spin_lock_init(&session->mgmt_lock);
 	spin_lock_init(&session->frwd_lock);
 	spin_lock_init(&session->back_lock);
 
@@ -3077,13 +3063,13 @@ struct iscsi_cls_conn *
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
 
 	if (iscsi_alloc_itt(session, conn->login_task))
 		goto login_itt_fail;
@@ -3102,10 +3088,10 @@ struct iscsi_cls_conn *
 login_task_data_alloc_fail:
 	iscsi_free_itt(session, conn->login_task);
 login_itt_fail:
-	spin_lock_bh(&session->frwd_lock);
+	spin_lock_bh(&session->mgmt_lock);
 	kfifo_in(&session->mgmt_pool.queue, (void *)&conn->login_task,
 		 sizeof(void *));
-	spin_unlock_bh(&session->frwd_lock);
+	spin_unlock_bh(&session->mgmt_lock);
 login_task_alloc_fail:
 	iscsi_destroy_conn(cls_conn);
 	return NULL;
@@ -3146,12 +3132,13 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
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
 	iscsi_free_itt(session, conn->login_task);
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
index 440ddd2..4f4e089 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -718,11 +718,8 @@ static void qedi_mtask_completion(struct qedi_ctx *qedi,
 
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
@@ -732,9 +729,7 @@ static void qedi_process_nopin_local_cmpl(struct qedi_ctx *qedi,
 	cmd->state = RESPONSE_RECEIVED;
 	qedi_clear_task_idx(qedi, cmd->task_id);
 
-	spin_lock_bh(&session->back_lock);
-	__iscsi_put_task(task);
-	spin_unlock_bh(&session->back_lock);
+	iscsi_put_task(task);
 }
 
 static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
@@ -930,7 +925,7 @@ void qedi_fp_process_cqes(struct qedi_work *work)
 		if ((nopout_hdr->itt == RESERVED_ITT) &&
 		    (cqe->cqe_solicited.itid != (u16)RESERVED_ITT)) {
 			qedi_process_nopin_local_cmpl(qedi, &cqe->cqe_solicited,
-						      task, q_conn);
+						      task);
 		} else {
 			cqe->cqe_solicited.itid =
 					       qedi_get_itt(cqe->cqe_solicited);
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 8a8d491..298ff70 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -336,6 +336,7 @@ struct iscsi_session {
 	spinlock_t		back_lock;	/* protects cmdsn_exp      *
 						 * cmdsn_max,              *
 						 * mgmt_pool kfifo_in      */
+	spinlock_t		mgmt_lock;	/* mgmt pool/cmds lock */
 	int			state;		/* session state           */
 	int			age;		/* counts session re-opens */
 
@@ -459,8 +460,7 @@ extern int __iscsi_complete_pdu(struct iscsi_conn *, struct iscsi_hdr *,
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

