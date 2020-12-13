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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02EE6C433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Dec 2020 03:12:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5BAD2310B
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Dec 2020 03:12:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391366AbgLMDMG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 12 Dec 2020 22:12:06 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:60104 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391471AbgLMDLv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Dec 2020 22:11:51 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BD39O1F077777;
        Sun, 13 Dec 2020 03:11:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=k5PtYT2ppqg1BBAG6Q8TLIqhtBhXLu28RGe7hT+6xnM=;
 b=AmUKlzzW6hLijW31wUTSJQMyPPfeHlIcWzN0ZVkHMu1tEc3Y0UB8ULfZquUjQ/rB6NmX
 Q5t9gbQdvkUwqkzJvz/AKOF8mFHgLg0XWHA4lXITJLhaYhpp10v0u1e1zPFbNU4/91+J
 8nDY2D/evuY1P3hYMyd7RWcGj28/y6ukqS20Bds5X+Dklveibb5s7fSUi5jXIvTQ1FVr
 PPudcl3t3eNnhyF6yDLMHYZs7/9M5vPQlt/NLqYPWMm7D3aFWBZItrsh6hkMK0+mOc3g
 ctHSWo6cKGX7Hi8THBsBHnHct0iI1puWsneevnA1BoATeO1Cy5A5RBSGKULYe/OKWA16 LA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 35cn9r1jcw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 13 Dec 2020 03:11:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BD36ihE181162;
        Sun, 13 Dec 2020 03:09:00 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 35d7rvaefj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 13 Dec 2020 03:08:59 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BD38wEt013811;
        Sun, 13 Dec 2020 03:08:58 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 12 Dec 2020 19:08:58 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Subject: [RFC PATCH 02/18] libiscsi: drop taskqueuelock
Date:   Sat, 12 Dec 2020 21:08:30 -0600
Message-Id: <1607828926-3658-3-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1607828926-3658-1-git-send-email-michael.christie@oracle.com>
References: <1607828926-3658-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9833 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012130023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9833 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012130023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The purpose of the taskqueuelock was to handle the issue where a bad
target decides to send a R2T and before it's data has been sent
decides to send a cmd response to complete the cmd. The following
patches fix up the frwd/back locks so they are taken from the
queue/xmit (frwd) and completion (back) paths again. To get there
this patch removes the taskqueuelock which for iscsi xmit wq based
drivers was taken in the queue, xmit and completion paths.

Instead of the lock, we just make sure we have a ref to the task
when we queue a R2T, and then we always remove the task from the
requeue list in the xmit path or the forced cleanup paths.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c     | 170 +++++++++++++++++++++++++++-----------------
 drivers/scsi/libiscsi_tcp.c |  84 ++++++++++++++--------
 include/scsi/libiscsi.h     |   4 +-
 3 files changed, 163 insertions(+), 95 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index ee0786b..0907f2d 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -523,16 +523,6 @@ static void iscsi_complete_task(struct iscsi_task *task, int state)
 	WARN_ON_ONCE(task->state == ISCSI_TASK_FREE);
 	task->state = state;
 
-	spin_lock_bh(&conn->taskqueuelock);
-	if (!list_empty(&task->running)) {
-		pr_debug_once("%s while task on list", __func__);
-		list_del_init(&task->running);
-	}
-	spin_unlock_bh(&conn->taskqueuelock);
-
-	if (conn->task == task)
-		conn->task = NULL;
-
 	if (READ_ONCE(conn->ping_task) == task)
 		WRITE_ONCE(conn->ping_task, NULL);
 
@@ -564,9 +554,39 @@ void iscsi_complete_scsi_task(struct iscsi_task *task,
 }
 EXPORT_SYMBOL_GPL(iscsi_complete_scsi_task);
 
+/*
+ * Must be called with back and frwd lock
+ */
+static bool cleanup_queued_task(struct iscsi_task *task)
+{
+	struct iscsi_conn *conn = task->conn;
+	bool early_complete = false;
+
+	/* Bad target might have completed task while it was still running */
+	if (task->state == ISCSI_TASK_COMPLETED)
+		early_complete = true;
+
+	if (!list_empty(&task->running)) {
+		list_del_init(&task->running);
+
+		/*
+		 * If it's on a list and running then it must be on the requeue
+		 * list
+		 */
+		if (task->state == ISCSI_TASK_RUNNING)
+			__iscsi_put_task(task);
+	}
+
+	if (conn->task == task) {
+		conn->task = NULL;
+		__iscsi_put_task(task);
+	}
+
+	return early_complete;
+}
 
 /*
- * session back_lock must be held and if not called for a task that is
+ * session frwd_lock must be held and if not called for a task that is
  * still pending or from the xmit thread, then xmit thread must
  * be suspended.
  */
@@ -585,6 +605,13 @@ static void fail_scsi_task(struct iscsi_task *task, int err)
 	if (!sc)
 		return;
 
+	/* regular RX path uses back_lock */
+	spin_lock_bh(&conn->session->back_lock);
+	if (cleanup_queued_task(task)) {
+		spin_unlock_bh(&conn->session->back_lock);
+		return;
+	}
+
 	if (task->state == ISCSI_TASK_PENDING) {
 		/*
 		 * cmd never made it to the xmit thread, so we should not count
@@ -600,9 +627,6 @@ static void fail_scsi_task(struct iscsi_task *task, int err)
 
 	sc->result = err << 16;
 	scsi_set_resid(sc, scsi_bufflen(sc));
-
-	/* regular RX path uses back_lock */
-	spin_lock_bh(&conn->session->back_lock);
 	iscsi_complete_task(task, state);
 	spin_unlock_bh(&conn->session->back_lock);
 }
@@ -748,9 +772,7 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
 		if (session->tt->xmit_task(task))
 			goto free_task;
 	} else {
-		spin_lock_bh(&conn->taskqueuelock);
 		list_add_tail(&task->running, &conn->mgmtqueue);
-		spin_unlock_bh(&conn->taskqueuelock);
 		iscsi_conn_queue_work(conn);
 	}
 
@@ -1411,31 +1433,51 @@ static int iscsi_check_cmdsn_window_closed(struct iscsi_conn *conn)
 	return 0;
 }
 
-static int iscsi_xmit_task(struct iscsi_conn *conn)
+static int iscsi_xmit_task(struct iscsi_conn *conn, bool has_extra_ref)
 {
 	struct iscsi_task *task = conn->task;
 	int rc;
 
-	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx))
-		return -ENODATA;
-
+	/* Take a ref so we can access it after xmit_task() */
+	__iscsi_get_task(task);
+	conn->task = NULL;
 	spin_lock_bh(&conn->session->back_lock);
-	if (conn->task == NULL) {
-		spin_unlock_bh(&conn->session->back_lock);
-		return -ENODATA;
+	/*
+	 * If this was a requeue for a R2T or we were in the middle of sending
+	 * the task, we have an extra ref on the task in case a bad target
+	 * sends a cmd rsp before we have handled the task.
+	 */
+	if (has_extra_ref)
+		__iscsi_put_task(task);
+
+	/*
+	 * Do this after dropping the extra ref because the forced dequeue
+	 * helper will miss the ref taken during requeue list check.
+	 */
+	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
+		rc = -ENODATA;
+		goto put_task;
 	}
-	__iscsi_get_task(task);
 	spin_unlock_bh(&conn->session->back_lock);
+
 	spin_unlock_bh(&conn->session->frwd_lock);
 	rc = conn->session->tt->xmit_task(task);
 	spin_lock_bh(&conn->session->frwd_lock);
 	if (!rc) {
 		/* done with this task */
 		task->last_xfer = jiffies;
-		conn->task = NULL;
 	}
 	/* regular RX path uses back_lock */
 	spin_lock(&conn->session->back_lock);
+	if (rc && task->state == ISCSI_TASK_RUNNING) {
+		/*
+		 * get an extra ref that is released next time we access it
+		 * as conn->task above.
+		 */
+		__iscsi_get_task(task);
+		conn->task = task;
+	}
+put_task:
 	__iscsi_put_task(task);
 	spin_unlock(&conn->session->back_lock);
 	return rc;
@@ -1445,9 +1487,7 @@ static int iscsi_xmit_task(struct iscsi_conn *conn)
  * iscsi_requeue_task - requeue task to run from session workqueue
  * @task: task to requeue
  *
- * LLDs that need to run a task from the session workqueue should call
- * this. The session frwd_lock must be held. This should only be called
- * by software drivers.
+ * Callers must have taken a ref to the task that is going to be requeued.
  */
 void iscsi_requeue_task(struct iscsi_task *task)
 {
@@ -1457,11 +1497,18 @@ void iscsi_requeue_task(struct iscsi_task *task)
 	 * this may be on the requeue list already if the xmit_task callout
 	 * is handling the r2ts while we are adding new ones
 	 */
-	spin_lock_bh(&conn->taskqueuelock);
-	if (list_empty(&task->running))
+	spin_lock_bh(&conn->session->frwd_lock);
+	if (list_empty(&task->running)) {
 		list_add_tail(&task->running, &conn->requeue);
-	spin_unlock_bh(&conn->taskqueuelock);
+	} else {
+		/*
+		 * Don't need the extra ref since it's already requeued and
+		 * has a ref.
+		 */
+		iscsi_put_task(task);
+	}
 	iscsi_conn_queue_work(conn);
+	spin_unlock_bh(&conn->session->frwd_lock);
 }
 EXPORT_SYMBOL_GPL(iscsi_requeue_task);
 
@@ -1487,7 +1534,7 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 	}
 
 	if (conn->task) {
-		rc = iscsi_xmit_task(conn);
+		rc = iscsi_xmit_task(conn, true);
 	        if (rc)
 		        goto done;
 	}
@@ -1497,49 +1544,43 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 	 * only have one nop-out as a ping from us and targets should not
 	 * overflow us with nop-ins
 	 */
-	spin_lock_bh(&conn->taskqueuelock);
 check_mgmt:
 	while (!list_empty(&conn->mgmtqueue)) {
-		conn->task = list_entry(conn->mgmtqueue.next,
-					 struct iscsi_task, running);
-		list_del_init(&conn->task->running);
-		spin_unlock_bh(&conn->taskqueuelock);
-		if (iscsi_prep_mgmt_task(conn, conn->task)) {
+		task = list_entry(conn->mgmtqueue.next, struct iscsi_task,
+				  running);
+		list_del_init(&task->running);
+		if (iscsi_prep_mgmt_task(conn, task)) {
 			/* regular RX path uses back_lock */
 			spin_lock_bh(&conn->session->back_lock);
-			__iscsi_put_task(conn->task);
+			__iscsi_put_task(task);
 			spin_unlock_bh(&conn->session->back_lock);
-			conn->task = NULL;
-			spin_lock_bh(&conn->taskqueuelock);
 			continue;
 		}
-		rc = iscsi_xmit_task(conn);
+		conn->task = task;
+		rc = iscsi_xmit_task(conn, false);
 		if (rc)
 			goto done;
-		spin_lock_bh(&conn->taskqueuelock);
 	}
 
 	/* process pending command queue */
 	while (!list_empty(&conn->cmdqueue)) {
-		conn->task = list_entry(conn->cmdqueue.next, struct iscsi_task,
-					running);
-		list_del_init(&conn->task->running);
-		spin_unlock_bh(&conn->taskqueuelock);
+		task = list_entry(conn->cmdqueue.next, struct iscsi_task,
+				  running);
+		list_del_init(&task->running);
 		if (conn->session->state == ISCSI_STATE_LOGGING_OUT) {
-			fail_scsi_task(conn->task, DID_IMM_RETRY);
-			spin_lock_bh(&conn->taskqueuelock);
+			fail_scsi_task(task, DID_IMM_RETRY);
 			continue;
 		}
-		rc = iscsi_prep_scsi_cmd_pdu(conn->task);
+		rc = iscsi_prep_scsi_cmd_pdu(task);
 		if (rc) {
 			if (rc == -ENOMEM || rc == -EACCES)
-				fail_scsi_task(conn->task, DID_IMM_RETRY);
+				fail_scsi_task(task, DID_IMM_RETRY);
 			else
-				fail_scsi_task(conn->task, DID_ABORT);
-			spin_lock_bh(&conn->taskqueuelock);
+				fail_scsi_task(task, DID_ABORT);
 			continue;
 		}
-		rc = iscsi_xmit_task(conn);
+		conn->task = task;
+		rc = iscsi_xmit_task(conn, false);
 		if (rc)
 			goto done;
 		/*
@@ -1547,7 +1588,6 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 		 * we need to check the mgmt queue for nops that need to
 		 * be sent to aviod starvation
 		 */
-		spin_lock_bh(&conn->taskqueuelock);
 		if (!list_empty(&conn->mgmtqueue))
 			goto check_mgmt;
 	}
@@ -1561,21 +1601,18 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 
 		task = list_entry(conn->requeue.next, struct iscsi_task,
 				  running);
+
 		if (iscsi_check_tmf_restrictions(task, ISCSI_OP_SCSI_DATA_OUT))
 			break;
 
+		list_del_init(&task->running);
 		conn->task = task;
-		list_del_init(&conn->task->running);
-		conn->task->state = ISCSI_TASK_RUNNING;
-		spin_unlock_bh(&conn->taskqueuelock);
-		rc = iscsi_xmit_task(conn);
+		rc = iscsi_xmit_task(conn, true);
 		if (rc)
 			goto done;
-		spin_lock_bh(&conn->taskqueuelock);
 		if (!list_empty(&conn->mgmtqueue))
 			goto check_mgmt;
 	}
-	spin_unlock_bh(&conn->taskqueuelock);
 	spin_unlock_bh(&conn->session->frwd_lock);
 	return -ENODATA;
 
@@ -1741,9 +1778,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 			goto prepd_reject;
 		}
 	} else {
-		spin_lock_bh(&conn->taskqueuelock);
 		list_add_tail(&task->running, &conn->cmdqueue);
-		spin_unlock_bh(&conn->taskqueuelock);
 		iscsi_conn_queue_work(conn);
 	}
 
@@ -2914,7 +2949,6 @@ struct iscsi_cls_conn *
 	INIT_LIST_HEAD(&conn->mgmtqueue);
 	INIT_LIST_HEAD(&conn->cmdqueue);
 	INIT_LIST_HEAD(&conn->requeue);
-	spin_lock_init(&conn->taskqueuelock);
 	INIT_WORK(&conn->xmitwork, iscsi_xmitworker);
 
 	/* allocate login_task used for the login/text sequences */
@@ -3080,10 +3114,16 @@ int iscsi_conn_start(struct iscsi_cls_conn *cls_conn)
 		ISCSI_DBG_SESSION(conn->session,
 				  "failing mgmt itt 0x%x state %d\n",
 				  task->itt, task->state);
+
+		spin_lock_bh(&session->back_lock);
+		if (cleanup_queued_task(task)) {
+			spin_unlock_bh(&session->back_lock);
+			continue;
+		}
+
 		state = ISCSI_TASK_ABRT_SESS_RECOV;
 		if (task->state == ISCSI_TASK_PENDING)
 			state = ISCSI_TASK_COMPLETED;
-		spin_lock_bh(&session->back_lock);
 		iscsi_complete_task(task, state);
 		spin_unlock_bh(&session->back_lock);
 	}
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 83f14b2..14c9169 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -524,48 +524,79 @@ static int iscsi_tcp_data_in(struct iscsi_conn *conn, struct iscsi_task *task)
 /**
  * iscsi_tcp_r2t_rsp - iSCSI R2T Response processing
  * @conn: iscsi connection
- * @task: scsi command task
+ * @hdr: PDU header
  */
-static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
+static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 {
 	struct iscsi_session *session = conn->session;
-	struct iscsi_tcp_task *tcp_task = task->dd_data;
-	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
-	struct iscsi_r2t_rsp *rhdr = (struct iscsi_r2t_rsp *)tcp_conn->in.hdr;
+	struct iscsi_tcp_task *tcp_task;
+	struct iscsi_tcp_conn *tcp_conn;
+	struct iscsi_r2t_rsp *rhdr;
 	struct iscsi_r2t_info *r2t;
-	int r2tsn = be32_to_cpu(rhdr->r2tsn);
+	struct iscsi_task *task;
 	u32 data_length;
 	u32 data_offset;
+	int r2tsn;
 	int rc;
 
+	spin_lock(&session->back_lock);
+	task = iscsi_itt_to_ctask(conn, hdr->itt);
+	if (!task) {
+		spin_unlock(&session->back_lock);
+		return ISCSI_ERR_BAD_ITT;
+	} else if (task->sc->sc_data_direction != DMA_TO_DEVICE) {
+		spin_unlock(&session->back_lock);
+		return ISCSI_ERR_PROTO;
+	}
+	/*
+	 * A bad target might complete the cmd before we have handled R2Ts
+	 * so get a ref to the task that will be dropped in the xmit path.
+	 */
+	if (task->state != ISCSI_TASK_RUNNING) {
+		spin_unlock(&session->back_lock);
+		/* Let the path that got the early rsp complete it */
+		return 0;
+	}
+	task->last_xfer = jiffies;
+	__iscsi_get_task(task);
+
+	tcp_conn = conn->dd_data;
+	rhdr = (struct iscsi_r2t_rsp *)tcp_conn->in.hdr;
+	/* fill-in new R2T associated with the task */
+	iscsi_update_cmdsn(session, (struct iscsi_nopin *)rhdr);
+	spin_unlock(&session->back_lock);
+
 	if (tcp_conn->in.datalen) {
 		iscsi_conn_printk(KERN_ERR, conn,
 				  "invalid R2t with datalen %d\n",
 				  tcp_conn->in.datalen);
-		return ISCSI_ERR_DATALEN;
+		rc = ISCSI_ERR_DATALEN;
+		goto put_task;
 	}
 
+	tcp_task = task->dd_data;
+	r2tsn = be32_to_cpu(rhdr->r2tsn);
 	if (tcp_task->exp_datasn != r2tsn){
 		ISCSI_DBG_TCP(conn, "task->exp_datasn(%d) != rhdr->r2tsn(%d)\n",
 			      tcp_task->exp_datasn, r2tsn);
-		return ISCSI_ERR_R2TSN;
+		rc = ISCSI_ERR_R2TSN;
+		goto put_task;
 	}
 
-	/* fill-in new R2T associated with the task */
-	iscsi_update_cmdsn(session, (struct iscsi_nopin*)rhdr);
-
 	if (!task->sc || session->state != ISCSI_STATE_LOGGED_IN) {
 		iscsi_conn_printk(KERN_INFO, conn,
 				  "dropping R2T itt %d in recovery.\n",
 				  task->itt);
-		return 0;
+		rc = 0;
+		goto put_task;
 	}
 
 	data_length = be32_to_cpu(rhdr->data_length);
 	if (data_length == 0) {
 		iscsi_conn_printk(KERN_ERR, conn,
 				  "invalid R2T with zero data len\n");
-		return ISCSI_ERR_DATALEN;
+		rc = ISCSI_ERR_DATALEN;
+		goto put_task;
 	}
 
 	if (data_length > session->max_burst)
@@ -579,7 +610,8 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
 				  "invalid R2T with data len %u at offset %u "
 				  "and total length %d\n", data_length,
 				  data_offset, task->sc->sdb.length);
-		return ISCSI_ERR_DATALEN;
+		rc = ISCSI_ERR_DATALEN;
+		goto put_task;
 	}
 
 	spin_lock(&tcp_task->pool2queue);
@@ -589,7 +621,8 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
 				  "Target has sent more R2Ts than it "
 				  "negotiated for or driver has leaked.\n");
 		spin_unlock(&tcp_task->pool2queue);
-		return ISCSI_ERR_PROTO;
+		rc = ISCSI_ERR_PROTO;
+		goto put_task;
 	}
 
 	r2t->exp_statsn = rhdr->statsn;
@@ -607,6 +640,10 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
 
 	iscsi_requeue_task(task);
 	return 0;
+
+put_task:
+	iscsi_put_task(task);
+	return rc;
 }
 
 /*
@@ -730,20 +767,11 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
 		rc = iscsi_complete_pdu(conn, hdr, NULL, 0);
 		break;
 	case ISCSI_OP_R2T:
-		spin_lock(&conn->session->back_lock);
-		task = iscsi_itt_to_ctask(conn, hdr->itt);
-		spin_unlock(&conn->session->back_lock);
-		if (!task)
-			rc = ISCSI_ERR_BAD_ITT;
-		else if (ahslen)
+		if (ahslen) {
 			rc = ISCSI_ERR_AHSLEN;
-		else if (task->sc->sc_data_direction == DMA_TO_DEVICE) {
-			task->last_xfer = jiffies;
-			spin_lock(&conn->session->frwd_lock);
-			rc = iscsi_tcp_r2t_rsp(conn, task);
-			spin_unlock(&conn->session->frwd_lock);
-		} else
-			rc = ISCSI_ERR_PROTO;
+			break;
+		}
+		rc = iscsi_tcp_r2t_rsp(conn, hdr);
 		break;
 	case ISCSI_OP_LOGIN_RSP:
 	case ISCSI_OP_TEXT_RSP:
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index b3bbd10..44a9554 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -187,7 +187,7 @@ struct iscsi_conn {
 	struct iscsi_task	*task;		/* xmit task in progress */
 
 	/* xmit */
-	spinlock_t		taskqueuelock;  /* protects the next three lists */
+	/* items must be added/deleted under frwd lock */
 	struct list_head	mgmtqueue;	/* mgmt (control) xmit queue */
 	struct list_head	cmdqueue;	/* data-path cmd queue */
 	struct list_head	requeue;	/* tasks needing another run */
@@ -332,7 +332,7 @@ struct iscsi_session {
 						 * cmdsn, queued_cmdsn     *
 						 * session resources:      *
 						 * - cmdpool kfifo_out ,   *
-						 * - mgmtpool,		   */
+						 * - mgmtpool, queues	   */
 	spinlock_t		back_lock;	/* protects cmdsn_exp      *
 						 * cmdsn_max,              *
 						 * cmdpool kfifo_in        */
-- 
1.8.3.1

