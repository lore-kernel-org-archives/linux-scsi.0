Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1EEDC8301C
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 21:31:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 838362084C
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 21:31:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ubk6P44L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389385AbgLAVbP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 16:31:15 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:57500 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388565AbgLAVbN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 16:31:13 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1LSubc081048;
        Tue, 1 Dec 2020 21:30:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=lvRh++FeI7AFla60Q2AZ1FT88NOlWljp1JQgFJbGBug=;
 b=Ubk6P44LkY57QfFmty/YdQF4lFKdk/FLtb/2JCogUcipCmOGMjy9Rd0xViBTXOcl4pOK
 pvTsvQI6DjQ0ErX2RfBO7U91yoxZY5BOy8MiqG+UNWeZR113mY/PqVPUwypeNW10wHGB
 06aVuC9EoX4gytJHkAVZ80LS8AvfRyNUUF48S6FAod0dq0sIg9eN9XXTIBcv2v40SA6H
 jjAdxAHFLkLut+KcHt665/ly1TDuAjJpdQeWOY3VOYk0Px2t7ecmf0clBpWfxiPKoQdC
 JXDjEVW+Q2hC8Csln/Z+hW6snF9e2Qd6Qys18K1kLkKn2KZqxCGlco/2mSz2AwVUJs9a 5Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 353egkmw5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 21:30:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1LUIqL131146;
        Tue, 1 Dec 2020 21:30:20 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 3540at23r1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 21:30:20 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B1LUETY018430;
        Tue, 1 Dec 2020 21:30:14 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Dec 2020 13:30:14 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     subbu.seetharaman@broadcom.com, ketan.mukadam@broadcom.com,
        jitendra.bhivare@broadcom.com, lduncan@suse.com, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, varun@chelsio.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: [PATCH 13/15] libiscsi: drop back_lock requirement for iscsi_put_task
Date:   Tue,  1 Dec 2020 15:29:54 -0600
Message-Id: <1606858196-5421-14-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1606858196-5421-1-git-send-email-michael.christie@oracle.com>
References: <1606858196-5421-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=2
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=2
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010130
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds a new lock around the mgmt pool, so we no longer need
the back lock when calling iscsi_put_task. This helps in the xmit path
where we are taking it to drop the refcount. The next patch will allow
us to completely remove the back lock from the xmit path.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/be2iscsi/be_main.c |  6 +--
 drivers/scsi/bnx2i/bnx2i_hwi.c  |  2 +-
 drivers/scsi/libiscsi.c         | 84 +++++++++++++++++------------------------
 drivers/scsi/libiscsi_tcp.c     |  2 +-
 drivers/scsi/qedi/qedi_fw.c     | 11 ++----
 include/scsi/libiscsi.h         |  4 +-
 6 files changed, 45 insertions(+), 64 deletions(-)

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
index 85c6730..0643156 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -523,7 +523,6 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
  * iscsi_free_task - free a task
  * @task: iscsi cmd task
  *
- * Must be called with session back_lock.
  * This function returns the scsi command to scsi-ml or cleans
  * up mgmt tasks then returns the task to the pool.
  */
@@ -554,7 +553,9 @@ static void iscsi_free_task(struct iscsi_task *task)
 	}
 
 	if (!sc) {
+		spin_lock_bh(&session->mgmt_lock);
 		kfifo_in(&session->mgmt_pool.queue, (void*)&task, sizeof(void*));
+		spin_unlock_bh(&session->mgmt_lock);
 	} else {
 		/* SCSI eh reuses commands to verify us */
 		sc->SCp.ptr = NULL;
@@ -567,28 +568,17 @@ static void iscsi_free_task(struct iscsi_task *task)
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
@@ -617,7 +607,7 @@ static void iscsi_complete_task(struct iscsi_task *task, int state)
 		WRITE_ONCE(conn->ping_task, NULL);
 
 	/* release get from queueing */
-	__iscsi_put_task(task);
+	iscsi_put_task(task);
 }
 
 /**
@@ -664,12 +654,12 @@ static bool cleanup_queued_task(struct iscsi_task *task)
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
@@ -804,17 +794,20 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
 		BUG_ON(conn->c_stage == ISCSI_CONN_INITIAL_STAGE);
 		BUG_ON(conn->c_stage == ISCSI_CONN_STOPPED);
 
-		if (!kfifo_out(&session->mgmt_pool.queue,
-				 (void*)&task, sizeof(void*)))
+		spin_lock(&session->mgmt_lock);
+		if (!kfifo_out(&session->mgmt_pool.queue, (void *)&task,
+			       sizeof(void *))) {
+			spin_unlock(&session->mgmt_lock);
 			return NULL;
+		}
 
 		if (iscsi_alloc_itt(session, task)) {
-			spin_lock(&session->back_lock);
 			kfifo_in(&session->mgmt_pool.queue, (void*)&task,
 				 sizeof(void*));
-			spin_unlock(&session->back_lock);
+			spin_unlock(&session->mgmt_lock);
 			return NULL;
 		}
+		spin_unlock(&session->mgmt_lock);
 	}
 	/*
 	 * released in complete pdu for task we expect a response for, and
@@ -870,10 +863,7 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
 	return task;
 
 free_task:
-	/* regular RX path uses back_lock */
-	spin_lock(&session->back_lock);
-	__iscsi_put_task(task);
-	spin_unlock(&session->back_lock);
+	iscsi_put_task(task);
 	return NULL;
 }
 
@@ -1514,16 +1504,15 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, bool has_extra_ref)
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
@@ -1533,8 +1522,6 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, bool has_extra_ref)
 		rc = -ENODATA;
 		goto put_task;
 	}
-	spin_unlock_bh(&conn->session->back_lock);
-
 	spin_unlock_bh(&conn->session->frwd_lock);
 	rc = conn->session->tt->xmit_task(task);
 	spin_lock_bh(&conn->session->frwd_lock);
@@ -1549,12 +1536,13 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, bool has_extra_ref)
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
 
@@ -1625,10 +1613,7 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
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
@@ -2929,6 +2914,7 @@ struct iscsi_cls_session *
 	session->dd_data = cls_session->dd_data + sizeof(*session);
 
 	mutex_init(&session->eh_mutex);
+	spin_lock_init(&session->mgmt_lock);
 	spin_lock_init(&session->frwd_lock);
 	spin_lock_init(&session->back_lock);
 
@@ -3053,14 +3039,13 @@ struct iscsi_cls_conn *
 	INIT_WORK(&conn->xmitwork, iscsi_xmitworker);
 
 	/* allocate login_task used for the login/text sequences */
-	spin_lock_bh(&session->frwd_lock);
-	if (!kfifo_out(&session->mgmt_pool.queue,
-                         (void*)&conn->login_task,
-			 sizeof(void*))) {
-		spin_unlock_bh(&session->frwd_lock);
+	spin_lock_bh(&session->mgmt_lock);
+	if (!kfifo_out(&session->mgmt_pool.queue, (void*)&conn->login_task,
+		       sizeof(void*))) {
+		spin_unlock_bh(&session->mgmt_lock);
 		goto login_task_alloc_fail;
 	}
-	spin_unlock_bh(&session->frwd_lock);
+	spin_unlock_bh(&session->mgmt_lock);
 
 	if (iscsi_alloc_itt(session, conn->login_task))
 		goto login_itt_fail;
@@ -3079,10 +3064,10 @@ struct iscsi_cls_conn *
 login_task_data_alloc_fail:
 	iscsi_free_itt(session, conn->login_task);
 login_itt_fail:
-	spin_lock_bh(&session->frwd_lock);
+	spin_lock_bh(&session->mgmt_lock);
 	kfifo_in(&session->mgmt_pool.queue, (void*)&conn->login_task,
 		    sizeof(void*));
-	spin_unlock_bh(&session->frwd_lock);
+	spin_unlock_bh(&session->mgmt_lock);
 login_task_alloc_fail:
 	iscsi_destroy_conn(cls_conn);
 	return NULL;
@@ -3123,12 +3108,13 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 		   get_order(ISCSI_DEF_MAX_RECV_SEG_LEN));
 	kfree(conn->persistent_address);
 	kfree(conn->local_ipaddr);
-	/* regular RX path uses back_lock */
-	spin_lock_bh(&session->back_lock);
+
+	spin_lock_bh(&session->mgmt_lock);
 	kfifo_in(&session->mgmt_pool.queue, (void*)&conn->login_task,
 		    sizeof(void*));
-	spin_unlock_bh(&session->back_lock);
+	spin_unlock_bh(&session->mgmt_lock);
 	iscsi_free_itt(session, conn->login_task);
+
 	if (session->leadconn == conn)
 		session->leadconn = NULL;
 	spin_unlock_bh(&session->frwd_lock);
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 081b2b6..cada8b8 100644
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
index 1c851b6..d0a6834 100644
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

