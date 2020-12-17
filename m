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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21B6BC3526F
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 06:43:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECA8523884
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 06:43:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgLQGnc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Dec 2020 01:43:32 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44742 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726529AbgLQGn2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Dec 2020 01:43:28 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BH6UU6k135197;
        Thu, 17 Dec 2020 06:42:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=BqnI0bYZXnAxILX4frZsITrJj2FOQ7RWM5BGVIlU5EM=;
 b=HyiI/Mv/5AfcFFqjVF/vNe84iQe5nzmAQkTDQaj9nb37MQrMYCVtL3XK6gzgpZ4RNCvr
 EepVXvLsGu0ww0T2hzpwXaG8ArVGfWOPIB6im4/KfYisNhYWOhSr7Jvau/d0Fy0So9tU
 BIQAAHGrz/0temzFgG4mO7jRDx1lwjyA26WqZ+fiZiqpkMV4I+gvvb1u80sLn/8k3Ihf
 ESVMzVMEAeo3QosbZMYydlD5z6p/Qwm46YE0anPq1KNetLcjpmHWaGkoPUJYvxGMwQf0
 N7Pkv61w6+59mDkvaql38RZy6TYb82fDuPfAq9i6J6zPOhQgGOdJIGF9JwnE8ppWDS5L oA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 35cn9rkvqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Dec 2020 06:42:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BH6VGo9178322;
        Thu, 17 Dec 2020 06:42:38 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 35e6jts217-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Dec 2020 06:42:37 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BH6gabs019189;
        Thu, 17 Dec 2020 06:42:36 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Dec 2020 22:42:36 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Subject: [PATCH 19/22] libiscsi: use blk/scsi-ml mq cmd pre-allocator
Date:   Thu, 17 Dec 2020 00:42:09 -0600
Message-Id: <1608187332-4434-20-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1608187332-4434-1-git-send-email-michael.christie@oracle.com>
References: <1608187332-4434-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9837 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012170047
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9837 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012170047
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has us use the blk/scsi-ml mq cmd pre-allocator and blk tags
for scsi tasks. We now do not need the back/frwd locks for scsi task
allocation. We still need it for mgmt tasks, but that will be fixed
in the next patch.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 124 +++++++++++++++++++++++-------------------------
 include/scsi/libiscsi.h |  26 ++++++----
 2 files changed, 77 insertions(+), 73 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 2b3dd42..ef9fd93 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -498,8 +498,6 @@ static void iscsi_free_task(struct iscsi_task *task)
 	if (conn->login_task == task)
 		return;
 
-	kfifo_in(&session->cmdpool.queue, (void*)&task, sizeof(void*));
-
 	/*
 	 * if the window opened when we processed a data/r2t pdu make sure we
 	 * see the updated win_opened value.
@@ -510,7 +508,9 @@ static void iscsi_free_task(struct iscsi_task *task)
 		iscsi_conn_queue_work(conn);
 	}
 
-	if (sc) {
+	if (!sc) {
+		kfifo_in(&session->mgmt_pool.queue, (void *)&task, sizeof(void *));
+	} else {
 		/* SCSI eh reuses commands to verify us */
 		sc->SCp.ptr = NULL;
 		/*
@@ -749,8 +749,8 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
 		BUG_ON(conn->c_stage == ISCSI_CONN_INITIAL_STAGE);
 		BUG_ON(conn->c_stage == ISCSI_CONN_STOPPED);
 
-		if (!kfifo_out(&session->cmdpool.queue,
-				 (void*)&task, sizeof(void*)))
+		if (!kfifo_out(&session->mgmt_pool.queue, (void *)&task,
+			       sizeof(void *)))
 			return NULL;
 	}
 	/*
@@ -1160,10 +1160,12 @@ struct iscsi_task *iscsi_itt_to_task(struct iscsi_conn *conn, itt_t itt)
 		session->tt->parse_pdu_itt(conn, itt, &i, NULL);
 	else
 		i = get_itt(itt);
-	if (i >= session->cmds_max)
+	i = i >> ISCSI_MGMT_SHIFT;
+
+	if (i >= ISCSI_MGMT_CMDS_MAX)
 		return NULL;
 
-	return session->cmds[i];
+	return session->mgmt_cmds[i];
 }
 EXPORT_SYMBOL_GPL(iscsi_itt_to_task);
 
@@ -1353,12 +1355,6 @@ int iscsi_verify_itt(struct iscsi_conn *conn, itt_t itt)
 		return ISCSI_ERR_BAD_ITT;
 	}
 
-	if (i >= session->cmds_max) {
-		iscsi_conn_printk(KERN_ERR, conn,
-				  "received invalid itt index %u (max cmds "
-				   "%u.\n", i, session->cmds_max);
-		return ISCSI_ERR_BAD_ITT;
-	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(iscsi_verify_itt);
@@ -1374,19 +1370,30 @@ int iscsi_verify_itt(struct iscsi_conn *conn, itt_t itt)
  */
 struct iscsi_task *iscsi_itt_to_ctask(struct iscsi_conn *conn, itt_t itt)
 {
+	struct iscsi_session *session = conn->session;
 	struct iscsi_task *task;
+	struct scsi_cmnd *sc;
+	int tag;
 
 	if (iscsi_verify_itt(conn, itt))
 		return NULL;
 
-	task = iscsi_itt_to_task(conn, itt);
-	if (!task || !task->sc)
+	if (session->tt->parse_pdu_itt)
+		session->tt->parse_pdu_itt(conn, itt, &tag, NULL);
+	else
+		tag = get_itt(itt);
+	sc = scsi_host_find_tag(session->host, tag);
+	if (!sc)
+		return NULL;
+
+	task = scsi_cmd_priv(sc);
+	if (!task->sc)
 		return NULL;
 
-	if (task->sc->SCp.phase != conn->session->age) {
+	if (task->sc->SCp.phase != session->age) {
 		iscsi_session_printk(KERN_ERR, conn->session,
 				  "task's session age %d, expected %d\n",
-				  task->sc->SCp.phase, conn->session->age);
+				  task->sc->SCp.phase, session->age);
 		return NULL;
 	}
 
@@ -1649,19 +1656,16 @@ static void iscsi_xmitworker(struct work_struct *work)
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
 
 	refcount_set(&task->refcount, 1);
+	task->itt = blk_mq_unique_tag(sc->request);
 	task->state = ISCSI_TASK_PENDING;
 	task->conn = conn;
 	task->sc = sc;
@@ -1758,22 +1762,16 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
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
@@ -1808,7 +1806,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 	spin_lock_bh(&session->back_lock);
 	iscsi_complete_task(task, ISCSI_TASK_REQUEUE_SCSIQ);
 	spin_unlock_bh(&session->back_lock);
-reject:
+
 	ISCSI_DBG_SESSION(session, "cmd 0x%x rejected (%d)\n",
 			  sc->cmnd[0], reason);
 	return SCSI_MLQUEUE_TARGET_BUSY;
@@ -2942,21 +2940,18 @@ struct iscsi_cls_session *
 	spin_lock_init(&session->frwd_lock);
 	spin_lock_init(&session->back_lock);
 
-	/* initialize SCSI PDU commands pool */
-	if (iscsi_pool_init(&session->cmdpool, session->cmds_max,
-			    (void***)&session->cmds,
+	/* initialize mgmt task pool */
+	if (iscsi_pool_init(&session->mgmt_pool, ISCSI_MGMT_CMDS_MAX,
+			    (void ***)&session->mgmt_cmds,
 			    cmd_task_size + sizeof(struct iscsi_task)))
-		goto cmdpool_alloc_fail;
+		goto mgmt_pool_alloc_fail;
 
 	/* pre-format cmds pool with ITT */
-	for (cmd_i = 0; cmd_i < session->cmds_max; cmd_i++) {
-		struct iscsi_task *task = session->cmds[cmd_i];
+	for (cmd_i = 0; cmd_i < ISCSI_MGMT_CMDS_MAX; cmd_i++) {
+		struct iscsi_task *task = session->mgmt_cmds[cmd_i];
 
-		if (cmd_task_size)
-			task->dd_data = &task[1];
-		task->itt = cmd_i;
-		task->state = ISCSI_TASK_FREE;
-		INIT_LIST_HEAD(&task->running);
+		iscsi_init_task(task);
+		task->itt = cmd_i << ISCSI_MGMT_SHIFT;
 
 		if (iscsit->alloc_task_priv) {
 			if (iscsit->alloc_task_priv(session, task))
@@ -2977,11 +2972,11 @@ struct iscsi_cls_session *
 free_task_priv:
 	for (cmd_i--; cmd_i >= 0; cmd_i--) {
 		if (iscsit->free_task_priv)
-			iscsit->free_task_priv(session, session->cmds[cmd_i]);
+			iscsit->free_task_priv(session, session->mgmt_cmds[cmd_i]);
 	}
 
-	iscsi_pool_free(&session->cmdpool);
-cmdpool_alloc_fail:
+	iscsi_pool_free(&session->mgmt_pool);
+mgmt_pool_alloc_fail:
 	iscsi_free_session(cls_session);
 dec_session_count:
 	iscsi_host_dec_session_cnt(shost);
@@ -3000,13 +2995,13 @@ void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
 	struct Scsi_Host *shost = session->host;
 	int cmd_i;
 
-	for (cmd_i = 0; cmd_i < session->cmds_max; cmd_i++) {
+	for (cmd_i = 0; cmd_i < ISCSI_MGMT_CMDS_MAX; cmd_i++) {
 		if (session->tt->free_task_priv)
 			session->tt->free_task_priv(session,
-						    session->cmds[cmd_i]);
+						    session->mgmt_cmds[cmd_i]);
 	}
 
-	iscsi_pool_free(&session->cmdpool);
+	iscsi_pool_free(&session->mgmt_pool);
 
 	iscsi_remove_session(cls_session);
 
@@ -3070,9 +3065,8 @@ struct iscsi_cls_conn *
 
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
@@ -3090,8 +3084,8 @@ struct iscsi_cls_conn *
 	return cls_conn;
 
 login_task_data_alloc_fail:
-	kfifo_in(&session->cmdpool.queue, (void*)&conn->login_task,
-		    sizeof(void*));
+	kfifo_in(&session->mgmt_pool.queue, (void*)&conn->login_task,
+		 sizeof(void *));
 login_task_alloc_fail:
 	iscsi_destroy_conn(cls_conn);
 	return NULL;
@@ -3134,8 +3128,8 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 	kfree(conn->local_ipaddr);
 	/* regular RX path uses back_lock */
 	spin_lock_bh(&session->back_lock);
-	kfifo_in(&session->cmdpool.queue, (void*)&conn->login_task,
-		    sizeof(void*));
+	kfifo_in(&session->mgmt_pool.queue, (void *)&conn->login_task,
+		 sizeof(void *));
 	spin_unlock_bh(&session->back_lock);
 	if (session->leadconn == conn)
 		session->leadconn = NULL;
@@ -3219,8 +3213,8 @@ int iscsi_conn_start(struct iscsi_cls_conn *cls_conn)
 	struct iscsi_task *task;
 	int i, state;
 
-	for (i = 0; i < conn->session->cmds_max; i++) {
-		task = conn->session->cmds[i];
+	for (i = 0; i < ISCSI_MGMT_CMDS_MAX; i++) {
+		task = conn->session->mgmt_cmds[i];
 		if (task->sc)
 			continue;
 
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 96aaf4b..7be30e0 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -36,7 +36,7 @@
 struct device;
 
 #define ISCSI_DEF_XMIT_CMDS_MAX	128	/* must be power of 2 */
-#define ISCSI_MGMT_CMDS_MAX	15
+#define ISCSI_MGMT_CMDS_MAX	4
 
 #define ISCSI_DEF_CMD_PER_LUN	32
 
@@ -55,8 +55,18 @@ enum {
 /* Connection suspend "bit" */
 #define ISCSI_SUSPEND_BIT		1
 
-#define ISCSI_ITT_MASK			0x1fff
-#define ISCSI_TOTAL_CMDS_MAX		4096
+/*
+ * Note:
+ * qedi uses 16 bits for it's tag.
+ * bnx2i needs the tag to be <= 0x3FFF to fit in its fw req.
+ * cxgbi assumes the tag will be at most 0x7fff.
+ * qla4xxx/be2iscsi ignore/fake the libiscsi tag.
+ */
+#define ISCSI_ITT_MASK			(ISCSI_ITT_CMD_MASK | ISCSI_MGMT_ITT_MASK)
+#define ISCSI_ITT_CMD_MASK		0x3fff
+#define ISCSI_TOTAL_CMDS_MAX		16384
+#define ISCSI_MGMT_ITT_MASK		0x3000
+#define ISCSI_MGMT_SHIFT		12
 /* this must be a power of two greater than ISCSI_MGMT_CMDS_MAX */
 #define ISCSI_TOTAL_CMDS_MIN		16
 #define ISCSI_AGE_SHIFT			28
@@ -330,18 +340,18 @@ struct iscsi_session {
 						 * in the eh paths, cmdsn  *
 						 * suspend bit and session *
 						 * resources:              *
-						 * - cmdpool kfifo_out ,   *
-						 * - mgmtpool, queues	   */
+						 * - mgmt_pool, kfifo_out, *
+						 * - queues	   */
 	spinlock_t		back_lock;	/* protects cmdsn_exp      *
 						 * cmdsn_max,              *
-						 * cmdpool kfifo_in        */
+						 * mgmt_pool kfifo_i       */
 	int			state;		/* session state           */
 	int			age;		/* counts session re-opens */
 
 	int			scsi_cmds_max; 	/* max scsi commands */
 	int			cmds_max;	/* size of cmds array */
-	struct iscsi_task	**cmds;		/* Original Cmds arr */
-	struct iscsi_pool	cmdpool;	/* PDU's pool */
+	struct iscsi_task	**mgmt_cmds;	/* mgmt task arr */
+	struct iscsi_pool	mgmt_pool;	/* mgmt task pool */
 	void			*dd_data;	/* LLD private data */
 };
 
-- 
1.8.3.1

