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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 638FAC83019
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 21:31:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BAA920870
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 21:31:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qd0KafeC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389080AbgLAVbL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 16:31:11 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:40964 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727156AbgLAVbG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 16:31:06 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1LSxw7117496;
        Tue, 1 Dec 2020 21:30:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=TTQ2l6JpeRTEZsc0JSxNF1TB5mKjyLCqrKgLCkDxZd4=;
 b=qd0KafeCWmvSjGhxmFDHMU+6v26ffd8wMgH6I75LVb0vDnsBvLMH7FgezW+Vih06q/1o
 RF/a0N/4fTF2ay7ytXQc8Rd1PdWfgQ5ew3S+gBTToyZdyUAbq25tmmB0+lNpaMDjN4jD
 fSR0PVEqB7PcAtJvip3xdwb08rLg1vMYwKlkTNn4d0XzA15mTXWY9dXECAocsPK2NDlD
 cUqr0Zlu+4qw0t3dMl8jj4QMNrA6KUkYePm75OEpGfwdyX9fVs21/7oZiCMxmVOYF9qZ
 +5USeohxUJ7mCMoHhyyiUmIlbTUGNKhKmykg+/C7xN80F6BWE9Brn4nS0P/n7hJ6OzfX 0g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 353c2aw2uk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 21:30:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1LBKkk163781;
        Tue, 1 Dec 2020 21:30:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3540fxkwnh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 21:30:10 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B1LU9r4018335;
        Tue, 1 Dec 2020 21:30:09 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Dec 2020 13:30:09 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     subbu.seetharaman@broadcom.com, ketan.mukadam@broadcom.com,
        jitendra.bhivare@broadcom.com, lduncan@suse.com, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, varun@chelsio.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: [PATCH 07/15] libiscsi: separate itt from task allocation
Date:   Tue,  1 Dec 2020 15:29:48 -0600
Message-Id: <1606858196-5421-8-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1606858196-5421-1-git-send-email-michael.christie@oracle.com>
References: <1606858196-5421-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=2
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010130
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The next patches has libiscsi use the blk/scsi mq scsi cmd preallocation
callouts to allocate the iscsi_task and the LLD's per task data so
libiscsi does not have to add extra locking to manage it's cmd pool
for scsi cmds. This means we need to separate the itt allocation and
lookup from the task allocation. In this patch we just use a sbitmap.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/be2iscsi/be_main.c |   2 +-
 drivers/scsi/libiscsi.c         | 131 ++++++++++++++++++++++++++++++++++------
 include/scsi/libiscsi.h         |   2 +
 3 files changed, 115 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 202ba92..cd3189b 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -306,7 +306,7 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 	spin_lock(&session->back_lock);
 	for (i = 0; i < conn->session->cmds_max; i++) {
 		task = conn->session->cmds[i];
-		if (!task->sc)
+		if (!task || !task->sc)
 			continue;
 
 		if (sc->device->lun != task->sc->device->lun)
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 12bfb5a..5942d2a 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -328,6 +328,43 @@ static int iscsi_check_tmf_restrictions(struct iscsi_task *task, int opcode)
 	return 0;
 }
 
+static int iscsi_alloc_itt(struct iscsi_session *session,
+			   struct iscsi_task *task)
+{
+	int itt;
+
+	itt = sbitmap_get(&session->itts, 0, false);
+	if (itt < 0) {
+		iscsi_session_printk(KERN_ERR, session,
+				    "Could not allocate ITT\n");
+		return -ENOMEM;
+	}
+
+	task->itt = itt;
+	session->cmds[itt] = task;
+	/*
+	 * If the code path is not holding the frwd and back locks and doing
+	 * a lookup make sure it sees the update.
+	 */
+	smp_wmb();
+	return 0;
+}
+
+static void iscsi_free_itt(struct iscsi_session *session,
+			   struct iscsi_task *task)
+{
+	/*
+	 * We don't need a barrier in this path because it's run from the
+	 * itt alloc path or from lookup which has the barrier already.
+	 */
+	if (task->itt == ISCSI_RESERVED_TAG)
+		return;
+
+	session->cmds[task->itt] = NULL;
+	sbitmap_clear_bit(&session->itts, task->itt);
+	task->itt = ISCSI_RESERVED_TAG;
+}
+
 /**
  * iscsi_prep_scsi_cmd_pdu - prep iscsi scsi cmd pdu
  * @task: iscsi task
@@ -349,10 +386,14 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 	if (rc)
 		return rc;
 
+	rc = iscsi_alloc_itt(session, task);
+	if (rc)
+		return rc;
+
 	if (conn->session->tt->alloc_pdu) {
 		rc = conn->session->tt->alloc_pdu(task, ISCSI_OP_SCSI_CMD);
 		if (rc)
-			return rc;
+			goto free_itt;
 	}
 	hdr = (struct iscsi_scsi_req *)task->hdr;
 	itt = hdr->itt;
@@ -366,7 +407,7 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 	task->hdr_len = 0;
 	rc = iscsi_add_hdr(task, sizeof(*hdr));
 	if (rc)
-		return rc;
+		goto free_itt;
 	hdr->opcode = ISCSI_OP_SCSI_CMD;
 	hdr->flags = ISCSI_ATTR_SIMPLE;
 	int_to_scsilun(sc->device->lun, &hdr->lun);
@@ -378,7 +419,7 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 	else if (cmd_len > ISCSI_CDB_SIZE) {
 		rc = iscsi_prep_ecdb_ahs(task);
 		if (rc)
-			return rc;
+			goto free_itt;
 		cmd_len = ISCSI_CDB_SIZE;
 	}
 	memcpy(hdr->cdb, sc->cmnd, cmd_len);
@@ -450,8 +491,10 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 	hdr->hlength = hdrlength & 0xFF;
 	hdr->cmdsn = task->cmdsn = cpu_to_be32(session->cmdsn);
 
-	if (session->tt->init_task && session->tt->init_task(task))
-		return -EIO;
+	if (session->tt->init_task && session->tt->init_task(task)) {
+		rc = -EIO;
+		goto free_itt;
+	}
 
 	task->state = ISCSI_TASK_RUNNING;
 	session->cmdsn++;
@@ -466,6 +509,14 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 			  task->itt, transfer_length, session->cmdsn,
 			  session->max_cmdsn - session->exp_cmdsn + 1);
 	return 0;
+
+free_itt:
+	iscsi_free_itt(session, task);
+	/*
+	 * The resources allocated in the LLD callouts will be freed by
+	 * the caller's cleanup_task call.
+	 */
+	return rc;
 }
 
 /**
@@ -495,6 +546,7 @@ static void iscsi_free_task(struct iscsi_task *task)
 	if (conn->login_task == task)
 		return;
 
+	iscsi_free_itt(session, task);
 	kfifo_in(&session->cmdpool.queue, (void*)&task, sizeof(void*));
 
 	if (session->win_opened && !work_pending(&conn->xmitwork)) {
@@ -754,6 +806,14 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
 		if (!kfifo_out(&session->cmdpool.queue,
 				 (void*)&task, sizeof(void*)))
 			return NULL;
+
+		if (iscsi_alloc_itt(session, task)) {
+			spin_lock(&session->back_lock);
+			kfifo_in(&session->cmdpool.queue, (void*)&task,
+				 sizeof(void*));
+			spin_unlock(&session->back_lock);
+			return NULL;
+		}
 	}
 	/*
 	 * released in complete pdu for task we expect a response for, and
@@ -1164,8 +1224,9 @@ struct iscsi_task *iscsi_itt_to_task(struct iscsi_conn *conn, itt_t itt)
 		i = get_itt(itt);
 	if (i >= session->cmds_max)
 		return NULL;
-
-	return session->cmds[i];
+	/* make sure we see the map addition */
+	smp_rmb();
+	return (session->cmds[i]);
 }
 EXPORT_SYMBOL_GPL(iscsi_itt_to_task);
 
@@ -1664,6 +1725,7 @@ static inline struct iscsi_task *iscsi_alloc_task(struct iscsi_conn *conn,
 	sc->SCp.ptr = (char *) task;
 
 	refcount_set(&task->refcount, 1);
+	task->itt = ISCSI_RESERVED_TAG;
 	task->state = ISCSI_TASK_PENDING;
 	task->conn = conn;
 	task->sc = sc;
@@ -1915,7 +1977,7 @@ static void fail_scsi_tasks(struct iscsi_conn *conn, u64 lun, int error)
 
 	for (i = 0; i < conn->session->cmds_max; i++) {
 		task = conn->session->cmds[i];
-		if (!task->sc || task->state == ISCSI_TASK_FREE)
+		if (!task || !task->sc || task->state == ISCSI_TASK_FREE)
 			continue;
 
 		if (lun != -1 && lun != task->sc->device->lun)
@@ -2072,7 +2134,7 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 
 	for (i = 0; i < conn->session->cmds_max; i++) {
 		running_task = conn->session->cmds[i];
-		if (!running_task->sc || running_task == task ||
+		if (!running_task || !running_task->sc || running_task == task ||
 		     running_task->state != ISCSI_TASK_RUNNING)
 			continue;
 
@@ -2794,6 +2856,7 @@ struct iscsi_cls_session *
 	struct iscsi_session *session;
 	struct iscsi_cls_session *cls_session;
 	int cmd_i, scsi_cmds, total_cmds = cmds_max;
+	struct iscsi_task *task;
 	unsigned long flags;
 
 	spin_lock_irqsave(&ihost->lock, flags);
@@ -2862,23 +2925,41 @@ struct iscsi_cls_session *
 	spin_lock_init(&session->frwd_lock);
 	spin_lock_init(&session->back_lock);
 
+	if (sbitmap_init_node(&session->itts, session->cmds_max, -1,
+			      GFP_KERNEL, NUMA_NO_NODE))
+		goto itts_fail;
+
+	session->cmds = kcalloc(session->cmds_max, sizeof(struct iscsi_task *),
+				GFP_KERNEL);
+	if (!session->cmds)
+		goto cmds_alloc_fail;
+
 	/* initialize SCSI PDU commands pool */
-	if (iscsi_pool_init(&session->cmdpool, session->cmds_max,
-			    (void***)&session->cmds,
+	if (iscsi_pool_init(&session->cmdpool, session->cmds_max, NULL,
 			    cmd_task_size + sizeof(struct iscsi_task)))
 		goto cmdpool_alloc_fail;
 
-	/* pre-format cmds pool with ITT */
-	for (cmd_i = 0; cmd_i < session->cmds_max; cmd_i++) {
-		struct iscsi_task *task = session->cmds[cmd_i];
+	/*
+	 * This is a temp change to allow drivers that prealloc task resources
+	 * during session setup to continue to work. The next patches convert
+	 * the drivers to use the blk/scsi-ml init/exit callouts then this
+	 * will be removed.
+	 */
+	while (kfifo_out(&session->cmdpool.queue, (void *) &task,
+			 sizeof(void *))) {
+		session->cmds[cmd_i++] = task;
 
 		if (cmd_task_size)
 			task->dd_data = &task[1];
-		task->itt = cmd_i;
 		task->state = ISCSI_TASK_FREE;
 		INIT_LIST_HEAD(&task->running);
 	}
 
+	for (cmd_i = 0; cmd_i < session->cmds_max; cmd_i++) {
+		task = session->cmds[cmd_i];
+		kfifo_in(&session->cmdpool.queue, (void*)&task, sizeof(void*));
+	}
+
 	if (!try_module_get(iscsit->owner))
 		goto module_get_fail;
 
@@ -2892,6 +2973,10 @@ struct iscsi_cls_session *
 module_get_fail:
 	iscsi_pool_free(&session->cmdpool);
 cmdpool_alloc_fail:
+	kfree(session->cmds);
+cmds_alloc_fail:
+	sbitmap_free(&session->itts);
+itts_fail:
 	iscsi_free_session(cls_session);
 dec_session_count:
 	iscsi_host_dec_session_cnt(shost);
@@ -2927,6 +3012,9 @@ void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
 	kfree(session->portal_type);
 	kfree(session->discovery_parent_type);
 
+	kfree(session->cmds);
+	sbitmap_free(&session->itts);
+
 	iscsi_free_session(cls_session);
 
 	iscsi_host_dec_session_cnt(shost);
@@ -2981,6 +3069,9 @@ struct iscsi_cls_conn *
 	}
 	spin_unlock_bh(&session->frwd_lock);
 
+	if (iscsi_alloc_itt(session, conn->login_task))
+		goto login_itt_fail;
+
 	data = (char *) __get_free_pages(GFP_KERNEL,
 					 get_order(ISCSI_DEF_MAX_RECV_SEG_LEN));
 	if (!data)
@@ -2993,8 +3084,12 @@ struct iscsi_cls_conn *
 	return cls_conn;
 
 login_task_data_alloc_fail:
+	iscsi_free_itt(session, conn->login_task);
+login_itt_fail:
+	spin_lock_bh(&session->frwd_lock);
 	kfifo_in(&session->cmdpool.queue, (void*)&conn->login_task,
 		    sizeof(void*));
+	spin_unlock_bh(&session->frwd_lock);
 login_task_alloc_fail:
 	iscsi_destroy_conn(cls_conn);
 	return NULL;
@@ -3040,6 +3135,7 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 	kfifo_in(&session->cmdpool.queue, (void*)&conn->login_task,
 		    sizeof(void*));
 	spin_unlock_bh(&session->back_lock);
+	iscsi_free_itt(session, conn->login_task);
 	if (session->leadconn == conn)
 		session->leadconn = NULL;
 	spin_unlock_bh(&session->frwd_lock);
@@ -3124,10 +3220,7 @@ int iscsi_conn_start(struct iscsi_cls_conn *cls_conn)
 
 	for (i = 0; i < conn->session->cmds_max; i++) {
 		task = conn->session->cmds[i];
-		if (task->sc)
-			continue;
-
-		if (task->state == ISCSI_TASK_FREE)
+		if (!task || task->sc || task->state == ISCSI_TASK_FREE)
 			continue;
 
 		ISCSI_DBG_SESSION(conn->session,
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 25dbc5d..e918af7 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -17,6 +17,7 @@
 #include <linux/workqueue.h>
 #include <linux/kfifo.h>
 #include <linux/refcount.h>
+#include <linux/sbitmap.h>
 #include <scsi/iscsi_proto.h>
 #include <scsi/iscsi_if.h>
 #include <scsi/scsi_transport_iscsi.h>
@@ -342,6 +343,7 @@ struct iscsi_session {
 	int			cmds_max;	/* size of cmds array */
 	struct iscsi_task	**cmds;		/* Original Cmds arr */
 	struct iscsi_pool	cmdpool;	/* PDU's pool */
+	struct sbitmap		itts;
 	void			*dd_data;	/* LLD private data */
 };
 
-- 
1.8.3.1

