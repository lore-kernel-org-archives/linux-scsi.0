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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42DA5C4361B
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Dec 2020 03:12:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A58023108
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Dec 2020 03:12:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392028AbgLMDMS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 12 Dec 2020 22:12:18 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:60524 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391926AbgLMDMD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Dec 2020 22:12:03 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BD34701074800;
        Sun, 13 Dec 2020 03:11:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=PUTWQmNlpUEGWFNlBelQBYuw6eazhJg7zjW4MTAk9yE=;
 b=CTG6ynuQAqU7V/Cr938ussbboF8zFalnO1ktQ6ZBVAVseJLH+6iptWEtpTYtd//90xt1
 hPiVxEgwGvY/I1pbvKxDECkSinm7oyomsi1pVlGcDNMvfLMwMwf7C2/qqA4aEZAfG045
 Kxub4LUBoTt3WCHsQaZ0UZd55d1U1mLTMLU16DYkELJ4Oy21Prjlhfdko4VKPuGeBOMx
 /AaXil0HRI/VF188kP/Py5qTOZup93ECsUqJEBRycsMPbv+V4BZ2NBoL7f28mQDSF8ET
 lVtO89n2P1TRhd+9M4EQvOidIEVKTK+HqV3/s8pWxJSS46wec3xyZypiRiD45FEQinxX +g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 35cn9r1jda-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 13 Dec 2020 03:11:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BD36mYo181298;
        Sun, 13 Dec 2020 03:09:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 35d7rvaehw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 13 Dec 2020 03:09:12 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BD39BdX010272;
        Sun, 13 Dec 2020 03:09:11 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 12 Dec 2020 19:09:11 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Subject: [RFC PATCH 15/18] libiscsi: use blk/scsi-ml mq cmd pre-allocator
Date:   Sat, 12 Dec 2020 21:08:43 -0600
Message-Id: <1607828926-3658-16-git-send-email-michael.christie@oracle.com>
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

This has us use the blk/scsi-ml mq cmd pre-allocator for scsi tasks.
We now do not need the back/frwd locks for scsi task allocation.
We still need it for mgmt tasks, but that will be fixed in the next
patch.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 81 +++++++++++++++++++++----------------------------
 include/scsi/libiscsi.h | 13 +++++---
 2 files changed, 42 insertions(+), 52 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 462a308..e46f9ea 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -550,7 +550,6 @@ static void iscsi_free_task(struct iscsi_task *task)
 		return;
 
 	iscsi_free_itt(session, task);
-	kfifo_in(&session->cmdpool.queue, (void*)&task, sizeof(void*));
 
 	/*
 	 * if the window opened when we processed a data/r2t pdu make sure we
@@ -562,7 +561,9 @@ static void iscsi_free_task(struct iscsi_task *task)
 		iscsi_conn_queue_work(conn);
 	}
 
-	if (sc) {
+	if (!sc) {
+		kfifo_in(&session->mgmt_pool.queue, (void *)&task, sizeof(void *));
+	} else {
 		/* SCSI eh reuses commands to verify us */
 		sc->SCp.ptr = NULL;
 		/*
@@ -811,13 +812,13 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
 		BUG_ON(conn->c_stage == ISCSI_CONN_INITIAL_STAGE);
 		BUG_ON(conn->c_stage == ISCSI_CONN_STOPPED);
 
-		if (!kfifo_out(&session->cmdpool.queue,
-				 (void*)&task, sizeof(void*)))
+		if (!kfifo_out(&session->mgmt_pool.queue, (void *)&task,
+			       sizeof(void *)))
 			return NULL;
 
 		if (iscsi_alloc_itt(session, task)) {
 			spin_lock(&session->back_lock);
-			kfifo_in(&session->cmdpool.queue, (void *)&task,
+			kfifo_in(&session->mgmt_pool.queue, (void *)&task,
 				 sizeof(void *));
 			spin_unlock(&session->back_lock);
 			return NULL;
@@ -1720,14 +1721,10 @@ static void iscsi_xmitworker(struct work_struct *work)
 	} while (rc >= 0 || rc == -EAGAIN);
 }
 
-static inline struct iscsi_task *iscsi_alloc_task(struct iscsi_conn *conn,
-						  struct scsi_cmnd *sc)
+static struct iscsi_task *iscsi_init_scsi_task(struct iscsi_conn *conn,
+					       struct scsi_cmnd *sc)
 {
-	struct iscsi_task *task;
-
-	if (!kfifo_out(&conn->session->cmdpool.queue,
-			 (void *) &task, sizeof(void *)))
-		return NULL;
+	struct iscsi_task *task = scsi_cmd_priv(sc);
 
 	sc->SCp.phase = conn->session->age;
 	sc->SCp.ptr = (char *) task;
@@ -1830,22 +1827,16 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 		goto fault;
 	}
 
-	spin_lock_bh(&session->frwd_lock);
-	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
-		spin_unlock_bh(&session->frwd_lock);
-		reason = FAILURE_SESSION_IN_RECOVERY;
-		sc->result = DID_REQUEUE << 16;
-		goto fault;
-	}
-
-	task = iscsi_alloc_task(conn, sc);
-	if (!task) {
-		spin_unlock_bh(&session->frwd_lock);
-		reason = FAILURE_OOM;
-		goto reject;
-	}
+	task = iscsi_init_scsi_task(conn, sc);
 
+	spin_lock_bh(&session->frwd_lock);
 	if (!ihost->workq) {
+		if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
+			reason = FAILURE_SESSION_IN_RECOVERY;
+			sc->result = DID_REQUEUE << 16;
+			goto prepd_fault;
+		}
+
 		if (iscsi_check_cmdsn_window_closed(conn)) {
 			reason = FAILURE_WINDOW_CLOSED;
 			goto prepd_reject;
@@ -1880,7 +1871,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 	spin_lock_bh(&session->back_lock);
 	iscsi_complete_task(task, ISCSI_TASK_REQUEUE_SCSIQ);
 	spin_unlock_bh(&session->back_lock);
-reject:
+
 	ISCSI_DBG_SESSION(session, "cmd 0x%x rejected (%d)\n",
 			  sc->cmnd[0], reason);
 	return SCSI_MLQUEUE_TARGET_BUSY;
@@ -2958,19 +2949,16 @@ struct iscsi_cls_session *
 	if (!session->cmds)
 		goto cmds_alloc_fail;
 
-	/* initialize SCSI PDU commands pool */
-	if (iscsi_pool_init(&session->cmdpool, session->cmds_max, NULL,
+	/* initialize mgmt PDU pool */
+	if (iscsi_pool_init(&session->mgmt_pool, ISCSI_MGMT_CMDS_MAX,
+			    (void ***)&session->mgmt_cmds,
 			    cmd_task_size + sizeof(struct iscsi_task)))
-		goto cmdpool_alloc_fail;
-
-	for (cmd_i = 0; cmd_i < session->cmds_max; cmd_i++) {
-		struct iscsi_task *task = session->cmds[cmd_i];
+		goto mgmt_pool_alloc_fail;
 
-		if (cmd_task_size)
-			task->dd_data = &task[1];
-		task->state = ISCSI_TASK_FREE;
-		INIT_LIST_HEAD(&task->running);
+	for (cmd_i = 0; cmd_i < ISCSI_MGMT_CMDS_MAX; cmd_i++) {
+		struct iscsi_task *task = session->mgmt_cmds[cmd_i];
 
+		iscsi_init_task(task);
 		if (iscsit->alloc_task_priv) {
 			if (iscsit->alloc_task_priv(session, task))
 				goto free_task_priv;
@@ -2993,8 +2981,8 @@ struct iscsi_cls_session *
 			iscsit->free_task_priv(session, session->cmds[cmd_i]);
 	}
 
-	iscsi_pool_free(&session->cmdpool);
-cmdpool_alloc_fail:
+	iscsi_pool_free(&session->mgmt_pool);
+mgmt_pool_alloc_fail:
 	kfree(session->cmds);
 cmds_alloc_fail:
 	sbitmap_free(&session->itts);
@@ -3023,7 +3011,7 @@ void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
 						    session->cmds[cmd_i]);
 	}
 
-	iscsi_pool_free(&session->cmdpool);
+	iscsi_pool_free(&session->mgmt_pool);
 
 	iscsi_remove_session(cls_session);
 
@@ -3090,9 +3078,8 @@ struct iscsi_cls_conn *
 
 	/* allocate login_task used for the login/text sequences */
 	spin_lock_bh(&session->frwd_lock);
-	if (!kfifo_out(&session->cmdpool.queue,
-                         (void*)&conn->login_task,
-			 sizeof(void*))) {
+	if (!kfifo_out(&session->mgmt_pool.queue, (void *)&conn->login_task,
+		       sizeof(void *))) {
 		spin_unlock_bh(&session->frwd_lock);
 		goto login_task_alloc_fail;
 	}
@@ -3116,8 +3103,8 @@ struct iscsi_cls_conn *
 	iscsi_free_itt(session, conn->login_task);
 login_itt_fail:
 	spin_lock_bh(&session->frwd_lock);
-	kfifo_in(&session->cmdpool.queue, (void*)&conn->login_task,
-		    sizeof(void*));
+	kfifo_in(&session->mgmt_pool.queue, (void *)&conn->login_task,
+		 sizeof(void *));
 	spin_unlock_bh(&session->frwd_lock);
 login_task_alloc_fail:
 	iscsi_destroy_conn(cls_conn);
@@ -3161,8 +3148,8 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 	kfree(conn->local_ipaddr);
 	/* regular RX path uses back_lock */
 	spin_lock_bh(&session->back_lock);
-	kfifo_in(&session->cmdpool.queue, (void*)&conn->login_task,
-		    sizeof(void*));
+	kfifo_in(&session->mgmt_pool.queue, (void *)&conn->login_task,
+		 sizeof(void *));
 	spin_unlock_bh(&session->back_lock);
 	iscsi_free_itt(session, conn->login_task);
 	if (session->leadconn == conn)
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 406e8a2..8a8d491 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -331,19 +331,22 @@ struct iscsi_session {
 						 * in the eh paths, cmdsn  *
 						 * suspend bit and session *
 						 * resources:              *
-						 * - cmdpool kfifo_out ,   *
-						 * - mgmtpool, queues	   */
+						 * - kfifo_out mgmt_pool,  *
+						 * - queues	           */
 	spinlock_t		back_lock;	/* protects cmdsn_exp      *
 						 * cmdsn_max,              *
-						 * cmdpool kfifo_in        */
+						 * mgmt_pool kfifo_in      */
 	int			state;		/* session state           */
 	int			age;		/* counts session re-opens */
 
 	int			scsi_cmds_max; 	/* max scsi commands */
 	int			cmds_max;	/* size of cmds array */
-	struct iscsi_task	**cmds;		/* Original Cmds arr */
-	struct iscsi_pool	cmdpool;	/* PDU's pool */
+	struct iscsi_task	**cmds;		/* Lookup map of all tasks */
 	struct sbitmap		itts;
+
+	struct iscsi_task	**mgmt_cmds;
+	struct iscsi_pool	mgmt_pool;
+
 	void			*dd_data;	/* LLD private data */
 };
 
-- 
1.8.3.1

