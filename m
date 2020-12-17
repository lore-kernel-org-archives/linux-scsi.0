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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99DECC3526C
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 06:43:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74F3B2388E
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 06:43:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbgLQGn1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Dec 2020 01:43:27 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:47796 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726529AbgLQGn1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Dec 2020 01:43:27 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BH6UIxG164613;
        Thu, 17 Dec 2020 06:42:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=lASChSrvTm2b/OTpouv3n6Ha2xgXgxmv7BCIjZgAGws=;
 b=x8QmWe3ADU8AQKaXqNGly2WFit+0KHw6uE7C+OEbg3wEBPIwmOhbD1x9Hm/IdXWiDquA
 XDvccVNPBXvTTvwSYTLnJa40gvzGhsORcGr+Xc58ntcQ5mebS8WcXWL1B1N5ZJ654a6K
 Xty3QhGBbhcMH8Stg7rw41eQZfbkHgRZmfxHKX5VlNmpIWbuxoirZNvSy1+M8ojfGv8D
 an1TVFuGLVAcxXu9MAN4+Ewv1yMQIeJxxnAf8CkAIVF4kkVBGxwKv3TZWnMLRZHt8AoX
 FxuUyIHwhOUD/KQiRbgbwk01ynaEIhrX/PwFENXTRBDPWLIEVdMpKqnMlxn/MxqRPKBI 9Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 35cntmbue4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Dec 2020 06:42:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BH6VDgF020086;
        Thu, 17 Dec 2020 06:42:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 35e6esvfv3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Dec 2020 06:42:35 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BH6gXZx006668;
        Thu, 17 Dec 2020 06:42:33 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Dec 2020 22:42:33 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Subject: [PATCH 15/22] libiscsi: use scsi_host_busy_iter
Date:   Thu, 17 Dec 2020 00:42:05 -0600
Message-Id: <1608187332-4434-16-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1608187332-4434-1-git-send-email-michael.christie@oracle.com>
References: <1608187332-4434-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9837 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
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

The next patches remove the session->cmds array for the scsi_cmnd
iscsi tasks. This patch has us use scsi_host_busy_iter instead of
looping over that array for the scsi_cmnd case, so we can remove
it in the next patches when we also switch over to using the blk
layer cmd allocators.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 160 +++++++++++++++++++++++++++++-------------------
 include/scsi/libiscsi.h |  12 ++++
 2 files changed, 110 insertions(+), 62 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 0c9e220..2b3dd42 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1902,39 +1902,66 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
 	return 0;
 }
 
-/*
- * Fail commands. session frwd lock held and xmit thread flushed.
- */
-static void fail_scsi_tasks(struct iscsi_conn *conn, u64 lun, int error)
+static bool fail_scsi_task_iter(struct scsi_cmnd *sc, void *data, bool rsvd)
 {
+	struct iscsi_task *task = (struct iscsi_task *)sc->SCp.ptr;
+	struct iscsi_sc_iter_data *iter_data = data;
+	struct iscsi_conn *conn = iter_data->conn;
 	struct iscsi_session *session = conn->session;
-	struct iscsi_task *task;
-	int i;
+
+	ISCSI_DBG_SESSION(session, "failing sc %p itt 0x%x state %d\n",
+			  task->sc, task->itt, task->state);
+	__iscsi_get_task(task);
+	spin_unlock_bh(&session->back_lock);
+
+	fail_scsi_task(task, *(int *)iter_data->data);
+
+	spin_unlock_bh(&session->frwd_lock);
+	iscsi_put_task(task);
+	spin_lock_bh(&session->frwd_lock);
 
 	spin_lock_bh(&session->back_lock);
-	for (i = 0; i < session->cmds_max; i++) {
-		task = session->cmds[i];
-		if (!task->sc || task->state == ISCSI_TASK_FREE)
-			continue;
+	return true;
+}
 
-		if (lun != -1 && lun != task->sc->device->lun)
-			continue;
+static bool iscsi_sc_iter(struct scsi_cmnd *sc, void *data, bool rsvd)
+{
+	struct iscsi_task *task = (struct iscsi_task *)sc->SCp.ptr;
+	struct iscsi_sc_iter_data *iter_data = data;
 
-		__iscsi_get_task(task);
-		spin_unlock_bh(&session->back_lock);
+	if (!task->sc || task->state == ISCSI_TASK_FREE ||
+	    task->conn != iter_data->conn)
+		return true;
 
-		ISCSI_DBG_SESSION(session,
-				  "failing sc %p itt 0x%x state %d\n",
-				  task->sc, task->itt, task->state);
-		fail_scsi_task(task, error);
+	if (iter_data->lun != -1 && iter_data->lun != task->sc->device->lun)
+		return true;
 
-		spin_unlock_bh(&session->frwd_lock);
-		iscsi_put_task(task);
-		spin_lock_bh(&session->frwd_lock);
+	return iter_data->fn(sc, iter_data, rsvd);
+}
 
-		spin_lock_bh(&session->back_lock);
-	}
+void iscsi_conn_for_each_sc(struct Scsi_Host *shost,
+			    struct iscsi_sc_iter_data *iter_data)
+{
+	scsi_host_busy_iter(shost, iscsi_sc_iter, iter_data);
+}
+EXPORT_SYMBOL_GPL(iscsi_conn_for_each_sc);
+
+/*
+ * Fail commands. session frwd lock held and xmit thread flushed.
+ */
+static void fail_scsi_tasks(struct iscsi_conn *conn, u64 lun, int error)
+{
+	struct iscsi_session *session = conn->session;
+
+	struct iscsi_sc_iter_data iter_data = {
+		.conn = conn,
+		.lun = lun,
+		.fn = fail_scsi_task_iter,
+		.data = &error,
+	};
 
+	spin_lock_bh(&session->back_lock);
+	iscsi_conn_for_each_sc(session->host, &iter_data);
 	spin_unlock_bh(&session->back_lock);
 }
 
@@ -1998,14 +2025,49 @@ static int iscsi_has_ping_timed_out(struct iscsi_conn *conn)
 		return 0;
 }
 
+static bool check_scsi_task_iter(struct scsi_cmnd *sc, void *data, bool rsvd)
+{
+	struct iscsi_task *task = (struct iscsi_task *)sc->SCp.ptr;
+	struct iscsi_sc_iter_data *iter_data = data;
+	struct iscsi_task *timed_out_task = iter_data->data;
+
+	/*
+	 * Only check if cmds started before this one have made
+	 * progress, or this could never fail
+	 */
+	if (time_after(task->sc->jiffies_at_alloc,
+		       timed_out_task->sc->jiffies_at_alloc))
+		return true;
+
+	if (time_after(task->last_xfer, timed_out_task->last_timeout)) {
+		/*
+		 * The timed out task has not made progress, but a task
+		 * started before us has transferred data since we
+		 * started/last-checked. We could be queueing too many tasks
+		 * or the LU is bad.
+		 *
+		 * If the device is bad the cmds ahead of us on other devs will
+		 * complete, and this loop will eventually fail starting the
+		 * scsi eh.
+		 */
+		ISCSI_DBG_EH(task->conn->session,
+			     "Command has not made progress but commands ahead of it have. Asking scsi-ml for more time to complete. Our last xfer vs running task last xfer %lu/%lu. Last check %lu.\n",
+			     timed_out_task->last_xfer, task->last_xfer,
+			     timed_out_task->last_timeout);
+		iter_data->rc = BLK_EH_RESET_TIMER;
+		return false;
+	}
+	return true;
+}
+
 enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 {
 	enum blk_eh_timer_return rc = BLK_EH_DONE;
-	struct iscsi_task *task = NULL, *running_task;
+	struct iscsi_task *task;
 	struct iscsi_cls_session *cls_session;
+	struct iscsi_sc_iter_data iter_data;
 	struct iscsi_session *session;
 	struct iscsi_conn *conn;
-	int i;
 
 	cls_session = starget_to_session(scsi_target(sc->device));
 	session = cls_session->dd_data;
@@ -2084,45 +2146,19 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 		goto done;
 	}
 
-	spin_lock(&session->back_lock);
-	for (i = 0; i < conn->session->cmds_max; i++) {
-		running_task = conn->session->cmds[i];
-		if (!running_task->sc || running_task == task ||
-		     running_task->state != ISCSI_TASK_RUNNING)
-			continue;
-
-		/*
-		 * Only check if cmds started before this one have made
-		 * progress, or this could never fail
-		 */
-		if (time_after(running_task->sc->jiffies_at_alloc,
-			       task->sc->jiffies_at_alloc))
-			continue;
+	iter_data.conn = conn;
+	iter_data.data = task;
+	iter_data.rc = BLK_EH_DONE;
+	iter_data.fn = check_scsi_task_iter;
+	iter_data.lun = -1;
 
-		if (time_after(running_task->last_xfer, task->last_timeout)) {
-			/*
-			 * This task has not made progress, but a task
-			 * started before us has transferred data since
-			 * we started/last-checked. We could be queueing
-			 * too many tasks or the LU is bad.
-			 *
-			 * If the device is bad the cmds ahead of us on
-			 * other devs will complete, and this loop will
-			 * eventually fail starting the scsi eh.
-			 */
-			ISCSI_DBG_EH(session, "Command has not made progress "
-				     "but commands ahead of it have. "
-				     "Asking scsi-ml for more time to "
-				     "complete. Our last xfer vs running task "
-				     "last xfer %lu/%lu. Last check %lu.\n",
-				     task->last_xfer, running_task->last_xfer,
-				     task->last_timeout);
-			spin_unlock(&session->back_lock);
-			rc = BLK_EH_RESET_TIMER;
-			goto done;
-		}
-	}
+	spin_lock(&session->back_lock);
+	iscsi_conn_for_each_sc(conn->session->host, &iter_data);
 	spin_unlock(&session->back_lock);
+	if (iter_data.rc != BLK_EH_DONE) {
+		rc = iter_data.rc;
+		goto done;
+	}
 
 	/* Assumes nop timeout is shorter than scsi cmd timeout */
 	if (task->have_checked_conn)
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 4f6ca2d..96aaf4b 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -460,6 +460,18 @@ extern void iscsi_complete_scsi_task(struct iscsi_task *task,
 				     uint32_t exp_cmdsn, uint32_t max_cmdsn);
 extern int iscsi_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *cmd);
 
+struct iscsi_sc_iter_data {
+	struct iscsi_conn *conn;
+	/* optional: if set to -1. It will be ignored */
+	u64 lun;
+	void *data;
+	int rc;
+	bool (*fn)(struct scsi_cmnd *sc, void *data, bool rsvd);
+};
+
+extern void iscsi_conn_for_each_sc(struct Scsi_Host *shost,
+				   struct iscsi_sc_iter_data *iter_data);
+
 /*
  * generic helpers
  */
-- 
1.8.3.1

