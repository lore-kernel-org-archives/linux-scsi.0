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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AD13C8301D
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 21:31:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1E8A2085B
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 21:31:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ozv2Q0fP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389412AbgLAVbP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 16:31:15 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:46958 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389212AbgLAVbN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 16:31:13 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1LTIvS018605;
        Tue, 1 Dec 2020 21:30:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=QpEbBTHxGM5ChernpIqnG9oejAbMYwibJ3pf0y/zn4k=;
 b=ozv2Q0fPkfJXrbVtMLizdpeJ/5AP51ea9n7U69nfyYpSUunpTkPzyXDIIbpM8tkYUy5E
 EcBSIiKGXPIa6JkmMLx1/cnAPEzq5e+yjX038gjPOrHxHvxzNJ8e3Yk0ePdxMF8FwaeN
 5+C96Ss1DsbFpHSUU8jkJMbvpLnDFSP+gelrJH9EpMxYNfvrPyJTXs/a8EtL91fWS1wY
 HEtScbt5ldkgCVvtC4hfXPYZ7olGJ3LvGg6JNDXbP1BuCz6yyPohwThQS41BJRlBWMJn
 qWH1xU69DKQR6Bz9WYn5R+tlMeDPJF3vure2kw4p1o2H2lVwp9rki56qAEnaMWb+0jSM nw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 353dyqmy2u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 21:30:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1LUIqK131146;
        Tue, 1 Dec 2020 21:30:20 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3540at23ra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 21:30:20 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B1LUDgS021087;
        Tue, 1 Dec 2020 21:30:13 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Dec 2020 13:30:13 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     subbu.seetharaman@broadcom.com, ketan.mukadam@broadcom.com,
        jitendra.bhivare@broadcom.com, lduncan@suse.com, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, varun@chelsio.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: [PATCH 12/15] libiscsi: use blk/scsi-ml mq cmd pre-allocator
Date:   Tue,  1 Dec 2020 15:29:53 -0600
Message-Id: <1606858196-5421-13-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1606858196-5421-1-git-send-email-michael.christie@oracle.com>
References: <1606858196-5421-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=2
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=2 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010130
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has us use the blk/scsi-ml mq cmd pre-allocator for scsi tasks.
We now do not need the back/frwd locks for scsi task allocation.
We still need it for mgmt tasks, but that will be fixed in the next
patch.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 84 ++++++++++++++++++-------------------------------
 include/scsi/libiscsi.h | 13 +++++---
 2 files changed, 38 insertions(+), 59 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index ea1ef77..85c6730 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -547,14 +547,15 @@ static void iscsi_free_task(struct iscsi_task *task)
 		return;
 
 	iscsi_free_itt(session, task);
-	kfifo_in(&session->cmdpool.queue, (void*)&task, sizeof(void*));
 
 	if (session->win_opened && !work_pending(&conn->xmitwork)) {
 		session->win_opened = false;
 		iscsi_conn_queue_work(conn);
 	}
 
-	if (sc) {
+	if (!sc) {
+		kfifo_in(&session->mgmt_pool.queue, (void*)&task, sizeof(void*));
+	} else {
 		/* SCSI eh reuses commands to verify us */
 		sc->SCp.ptr = NULL;
 		/*
@@ -803,13 +804,13 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
 		BUG_ON(conn->c_stage == ISCSI_CONN_INITIAL_STAGE);
 		BUG_ON(conn->c_stage == ISCSI_CONN_STOPPED);
 
-		if (!kfifo_out(&session->cmdpool.queue,
+		if (!kfifo_out(&session->mgmt_pool.queue,
 				 (void*)&task, sizeof(void*)))
 			return NULL;
 
 		if (iscsi_alloc_itt(session, task)) {
 			spin_lock(&session->back_lock);
-			kfifo_in(&session->cmdpool.queue, (void*)&task,
+			kfifo_in(&session->mgmt_pool.queue, (void*)&task,
 				 sizeof(void*));
 			spin_unlock(&session->back_lock);
 			return NULL;
@@ -1712,14 +1713,10 @@ static void iscsi_xmitworker(struct work_struct *work)
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
@@ -1822,22 +1819,16 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
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
@@ -1872,7 +1863,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 	spin_lock_bh(&session->back_lock);
 	iscsi_complete_task(task, ISCSI_TASK_REQUEUE_SCSIQ);
 	spin_unlock_bh(&session->back_lock);
-reject:
+
 	ISCSI_DBG_SESSION(session, "cmd 0x%x rejected (%d)\n",
 			  sc->cmnd[0], reason);
 	return SCSI_MLQUEUE_TARGET_BUSY;
@@ -2873,7 +2864,6 @@ struct iscsi_cls_session *
 	struct iscsi_session *session;
 	struct iscsi_cls_session *cls_session;
 	int cmd_i, scsi_cmds, total_cmds = cmds_max;
-	struct iscsi_task *task;
 	unsigned long flags;
 
 	spin_lock_irqsave(&ihost->lock, flags);
@@ -2951,30 +2941,16 @@ struct iscsi_cls_session *
 	if (!session->cmds)
 		goto cmds_alloc_fail;
 
-	/* initialize SCSI PDU commands pool */
-	if (iscsi_pool_init(&session->cmdpool, session->cmds_max, NULL,
+	/* initialize mgmt PDU pool */
+	if (iscsi_pool_init(&session->mgmt_pool, ISCSI_MGMT_CMDS_MAX,
+			    (void***)&session->mgmt_cmds,
 			    cmd_task_size + sizeof(struct iscsi_task)))
-		goto cmdpool_alloc_fail;
-
-	/*
-	 * This is a temp change to allow drivers that prealloc task resources
-	 * during session setup to continue to work. The next patches convert
-	 * the drivers to use the blk/scsi-ml init/exit callouts then this
-	 * will be removed.
-	 */
-	while (kfifo_out(&session->cmdpool.queue, (void *) &task,
-			 sizeof(void *))) {
-		session->cmds[cmd_i++] = task;
+		goto mgmt_pool_alloc_fail;
 
-		if (cmd_task_size)
-			task->dd_data = &task[1];
-		task->state = ISCSI_TASK_FREE;
-		INIT_LIST_HEAD(&task->running);
-	}
+	for (cmd_i = 0; cmd_i < ISCSI_MGMT_CMDS_MAX; cmd_i++) {
+		struct iscsi_task *task = session->mgmt_cmds[cmd_i];
 
-	for (cmd_i = 0; cmd_i < session->cmds_max; cmd_i++) {
-		task = session->cmds[cmd_i];
-		kfifo_in(&session->cmdpool.queue, (void*)&task, sizeof(void*));
+		iscsi_init_task(task);
 	}
 
 	if (!try_module_get(iscsit->owner))
@@ -2988,8 +2964,8 @@ struct iscsi_cls_session *
 cls_session_fail:
 	module_put(iscsit->owner);
 module_get_fail:
-	iscsi_pool_free(&session->cmdpool);
-cmdpool_alloc_fail:
+	iscsi_pool_free(&session->mgmt_pool);
+mgmt_pool_alloc_fail:
 	kfree(session->cmds);
 cmds_alloc_fail:
 	sbitmap_free(&session->itts);
@@ -3011,7 +2987,7 @@ void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
 	struct module *owner = cls_session->transport->owner;
 	struct Scsi_Host *shost = session->host;
 
-	iscsi_pool_free(&session->cmdpool);
+	iscsi_pool_free(&session->mgmt_pool);
 
 	iscsi_remove_session(cls_session);
 
@@ -3078,7 +3054,7 @@ struct iscsi_cls_conn *
 
 	/* allocate login_task used for the login/text sequences */
 	spin_lock_bh(&session->frwd_lock);
-	if (!kfifo_out(&session->cmdpool.queue,
+	if (!kfifo_out(&session->mgmt_pool.queue,
                          (void*)&conn->login_task,
 			 sizeof(void*))) {
 		spin_unlock_bh(&session->frwd_lock);
@@ -3104,7 +3080,7 @@ struct iscsi_cls_conn *
 	iscsi_free_itt(session, conn->login_task);
 login_itt_fail:
 	spin_lock_bh(&session->frwd_lock);
-	kfifo_in(&session->cmdpool.queue, (void*)&conn->login_task,
+	kfifo_in(&session->mgmt_pool.queue, (void*)&conn->login_task,
 		    sizeof(void*));
 	spin_unlock_bh(&session->frwd_lock);
 login_task_alloc_fail:
@@ -3149,7 +3125,7 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 	kfree(conn->local_ipaddr);
 	/* regular RX path uses back_lock */
 	spin_lock_bh(&session->back_lock);
-	kfifo_in(&session->cmdpool.queue, (void*)&conn->login_task,
+	kfifo_in(&session->mgmt_pool.queue, (void*)&conn->login_task,
 		    sizeof(void*));
 	spin_unlock_bh(&session->back_lock);
 	iscsi_free_itt(session, conn->login_task);
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index c2283f9..1c851b6 100644
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

