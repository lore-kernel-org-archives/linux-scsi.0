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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0BCBC4361B
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 21:57:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9101722D06
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 21:57:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729733AbgLOV5b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Dec 2020 16:57:31 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:52316 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729926AbgLOV4f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2020 16:56:35 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BFLs6Ud131499;
        Tue, 15 Dec 2020 21:55:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=OJ20F05i7v3FP0rD75zow6tOCDfv6LNJd7ZV3VP8klg=;
 b=fI+ZO93YtWOLmDntOOhw9HfuD0trO9wXC4Cui5JztWv44mwRdlLM5Dj/h4Z4lrGWzxVN
 nptvAOYnENXquS3oq6ymNBPTRrVOPmsIHhGpXQwoib7PYa1wt2QETw2MUN2QPlc4T3On
 gws4RGijtpfP8GinAiiFhQsmjDCuds0UQevFCCg3EH+Dp4tRKrjnTSvPI3gk3ctmn1Oy
 ip75lwbcoIaMDdAsTASsFymv/dVRE2HtLXWcZwepyDINEZ1uNHzVgNYAYKL3oTfS4El4
 c67MUGjGKKNDr+pcH4VvJ3hqUyYPTWYJgskaNIyKR8InN3LR+v6t6iJHb2DvdDxsAXeY ug== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 35ckcbd65u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Dec 2020 21:55:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BFLjD1S121634;
        Tue, 15 Dec 2020 21:53:40 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 35d7enmb7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Dec 2020 21:53:39 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BFLrdS8020435;
        Tue, 15 Dec 2020 21:53:39 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Dec 2020 13:53:39 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com
Subject: [PATCH 3/3] libiscsi: fix iscsi_task use after free
Date:   Tue, 15 Dec 2020 15:53:30 -0600
Message-Id: <1608069210-5755-4-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1608069210-5755-1-git-send-email-michael.christie@oracle.com>
References: <1608069210-5755-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9836 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012150146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9836 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012150147
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following bug was reported and debugged by wubo40@huawei.com:

When testing kernel 4.18 version, NULL pointer dereference problem
occurs
in iscsi_eh_cmd_timed_out function.

I think this bug in the upstream is still exists.

The analysis reasons are as follows:
1)  For some reason, I/O command did not complete within
    the timeout period. The block layer timer works,
    call scsi_times_out() to handle I/O timeout logic.
    At the same time the command just completes.

2)  scsi_times_out() call iscsi_eh_cmd_timed_out()
    to processing timeout logic.  although there is an NULL judgment
        for the task, the task has not been released yet now.

3)  iscsi_complete_task() call __iscsi_put_task(),
    The task reference count reaches zero, the conditions for free task
    is met, then iscsi_free_task () free the task,
    and let sc->SCp.ptr = NULL. After iscsi_eh_cmd_timed_out passes
    the task judgment check, there may be NULL dereference scenarios
    later.

   CPU0                                                CPU3

    |- scsi_times_out()                                 |-
iscsi_complete_task()
    |                                                   |
    |- iscsi_eh_cmd_timed_out()                         |-
__iscsi_put_task()
    |                                                   |
    |- task=sc->SCp.ptr, task is not NUL, check passed  |-
iscsi_free_task(task)
    |                                                   |
    |                                                   |-> sc->SCp.ptr
= NULL
    |                                                   |
    |- task is NULL now, NULL pointer dereference       |
    |                                                   |
   \|/                                                 \|/

Calltrace:
[380751.840862] BUG: unable to handle kernel NULL pointer dereference at
0000000000000138
[380751.843709] PGD 0 P4D 0
[380751.844770] Oops: 0000 [#1] SMP PTI
[380751.846283] CPU: 0 PID: 403 Comm: kworker/0:1H Kdump: loaded
Tainted: G
[380751.851467] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
[380751.856521] Workqueue: kblockd blk_mq_timeout_work
[380751.858527] RIP: 0010:iscsi_eh_cmd_timed_out+0x15e/0x2e0 [libiscsi]
[380751.861129] Code: 83 ea 01 48 8d 74 d0 08 48 8b 10 48 8b 4a 50 48 85
c9 74 2c 48 39 d5 74
[380751.868811] RSP: 0018:ffffc1e280a5fd58 EFLAGS: 00010246
[380751.870978] RAX: ffff9fd1e84e15e0 RBX: ffff9fd1e84e6dd0 RCX:
0000000116acc580
[380751.873791] RDX: ffff9fd1f97a9400 RSI: ffff9fd1e84e1800 RDI:
ffff9fd1e4d6d420
[380751.876059] RBP: ffff9fd1e4d49000 R08: 0000000116acc580 R09:
0000000116acc580
[380751.878284] R10: 0000000000000000 R11: 0000000000000000 R12:
ffff9fd1e6e931e8
[380751.880500] R13: ffff9fd1e84e6ee0 R14: 0000000000000010 R15:
0000000000000003
[380751.882687] FS:  0000000000000000(0000) GS:ffff9fd1fac00000(0000)
knlGS:0000000000000000
[380751.885236] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[380751.887059] CR2: 0000000000000138 CR3: 000000011860a001 CR4:
00000000003606f0
[380751.889308] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[380751.891523] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[380751.893738] Call Trace:
[380751.894639]  scsi_times_out+0x60/0x1c0
[380751.895861]  blk_mq_check_expired+0x144/0x200
[380751.897302]  ? __switch_to_asm+0x35/0x70
[380751.898551]  blk_mq_queue_tag_busy_iter+0x195/0x2e0
[380751.900091]  ? __blk_mq_requeue_request+0x100/0x100
[380751.901611]  ? __switch_to_asm+0x41/0x70
[380751.902853]  ? __blk_mq_requeue_request+0x100/0x100
[380751.904398]  blk_mq_timeout_work+0x54/0x130
[380751.905740]  process_one_work+0x195/0x390
[380751.907228]  worker_thread+0x30/0x390
[380751.908713]  ? process_one_work+0x390/0x390
[380751.910350]  kthread+0x10d/0x130
[380751.911470]  ? kthread_flush_work_fn+0x10/0x10
[380751.913007]  ret_from_fork+0x35/0x40

crash> dis -l iscsi_eh_cmd_timed_out+0x15e
xxxxx/drivers/scsi/libiscsi.c: 2062

1970 enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd
*sc)
{
...
1984         spin_lock_bh(&session->frwd_lock);
1985         task = (struct iscsi_task *)sc->SCp.ptr;
1986         if (!task) {
1987                 /*
1988                  * Raced with completion. Blk layer has taken
ownership
1989                  * so let timeout code complete it now.
1990                  */
1991                 rc = BLK_EH_DONE;
1992                 goto done;
1993         }

...

2052         for (i = 0; i < conn->session->cmds_max; i++) {
2053                 running_task = conn->session->cmds[i];
2054                 if (!running_task->sc || running_task == task ||
2055                      running_task->state != ISCSI_TASK_RUNNING)
2056                         continue;
2057
2058                 /*
2059                  * Only check if cmds started before this one have
made
2060                  * progress, or this could never fail
2061                  */
2062                 if (time_after(running_task->sc->jiffies_at_alloc,
2063                                task->sc->jiffies_at_alloc))    <---
2064                         continue;
2065
...
}

carsh> struct scsi_cmnd ffff9fd1e6e931e8
struct scsi_cmnd {
  ...
  SCp = {
    ptr = 0x0,   <--- iscsi_task
    this_residual = 0,
    ...
  },
}

To prevent this, we take a ref to the cmd under the back (completion)
lock so if the completion side were to call iscsi_complete_task on the
task while the timer/eh paths are not holding the back_lock it will
not be freed from under us.

Note that this requires the previous patch because bnx2i sleeps in its
cleanup_task callout if the cmd is aborted. If the EH/timer and completion
path are racing we don't know which path will do the last put. The previous
patch moved the operations we needed to do under the forward lock to
cleanup_queued_task. Once that has run we can drop the forward lock for
the cmd and bnx2i no longer has to worry about if the EH, timer or completion
path did the last put and if the forward lock is held or not since it won't
be.

Reported-by: Wu Bo <wubo40@huawei.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c |  2 --
 drivers/scsi/libiscsi.c          | 68 +++++++++++++++++++++++++---------------
 2 files changed, 42 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index fdd4467..1e6d8f6 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1171,10 +1171,8 @@ static void bnx2i_cleanup_task(struct iscsi_task *task)
 		bnx2i_send_cmd_cleanup_req(hba, task->dd_data);
 
 		spin_unlock_bh(&conn->session->back_lock);
-		spin_unlock_bh(&conn->session->frwd_lock);
 		wait_for_completion_timeout(&bnx2i_conn->cmd_cleanup_cmpl,
 				msecs_to_jiffies(ISCSI_CMD_CLEANUP_TIMEOUT));
-		spin_lock_bh(&conn->session->frwd_lock);
 		spin_lock_bh(&conn->session->back_lock);
 	}
 	bnx2i_iscsi_unmap_sg_list(task->dd_data);
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 7efeec9..f57e7f4 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -586,9 +586,8 @@ static bool cleanup_queued_task(struct iscsi_task *task)
 }
 
 /*
- * session frwd_lock must be held and if not called for a task that is
- * still pending or from the xmit thread, then xmit thread must
- * be suspended.
+ * session frwd lock must be held and if not called for a task that is still
+ * pending or from the xmit thread, then xmit thread must be suspended
  */
 static void fail_scsi_task(struct iscsi_task *task, int err)
 {
@@ -596,16 +595,6 @@ static void fail_scsi_task(struct iscsi_task *task, int err)
 	struct scsi_cmnd *sc;
 	int state;
 
-	/*
-	 * if a command completes and we get a successful tmf response
-	 * we will hit this because the scsi eh abort code does not take
-	 * a ref to the task.
-	 */
-	sc = task->sc;
-	if (!sc)
-		return;
-
-	/* regular RX path uses back_lock */
 	spin_lock_bh(&conn->session->back_lock);
 	if (cleanup_queued_task(task)) {
 		spin_unlock_bh(&conn->session->back_lock);
@@ -625,6 +614,7 @@ static void fail_scsi_task(struct iscsi_task *task, int err)
 	else
 		state = ISCSI_TASK_ABRT_TMF;
 
+	sc = task->sc;
 	sc->result = err << 16;
 	scsi_set_resid(sc, scsi_bufflen(sc));
 	iscsi_complete_task(task, state);
@@ -1885,27 +1875,39 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
 }
 
 /*
- * Fail commands. session lock held and recv side suspended and xmit
- * thread flushed
+ * Fail commands. session frwd lock held and xmit thread flushed.
  */
 static void fail_scsi_tasks(struct iscsi_conn *conn, u64 lun, int error)
 {
+	struct iscsi_session *session = conn->session;
 	struct iscsi_task *task;
 	int i;
 
-	for (i = 0; i < conn->session->cmds_max; i++) {
-		task = conn->session->cmds[i];
+	spin_lock_bh(&session->back_lock);
+	for (i = 0; i < session->cmds_max; i++) {
+		task = session->cmds[i];
 		if (!task->sc || task->state == ISCSI_TASK_FREE)
 			continue;
 
 		if (lun != -1 && lun != task->sc->device->lun)
 			continue;
 
-		ISCSI_DBG_SESSION(conn->session,
+		__iscsi_get_task(task);
+		spin_unlock_bh(&session->back_lock);
+
+		ISCSI_DBG_SESSION(session,
 				  "failing sc %p itt 0x%x state %d\n",
 				  task->sc, task->itt, task->state);
 		fail_scsi_task(task, error);
+
+		spin_unlock_bh(&session->frwd_lock);
+		iscsi_put_task(task);
+		spin_lock_bh(&session->frwd_lock);
+
+		spin_lock_bh(&session->back_lock);
 	}
+
+	spin_unlock_bh(&session->back_lock);
 }
 
 /**
@@ -1983,6 +1985,7 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 	ISCSI_DBG_EH(session, "scsi cmd %p timedout\n", sc);
 
 	spin_lock_bh(&session->frwd_lock);
+	spin_lock(&session->back_lock);
 	task = (struct iscsi_task *)sc->SCp.ptr;
 	if (!task) {
 		/*
@@ -1990,8 +1993,11 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 		 * so let timeout code complete it now.
 		 */
 		rc = BLK_EH_DONE;
+		spin_unlock(&session->back_lock);
 		goto done;
 	}
+	__iscsi_get_task(task);
+	spin_unlock(&session->back_lock);
 
 	if (session->state != ISCSI_STATE_LOGGED_IN) {
 		/*
@@ -2107,9 +2113,12 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 	rc = BLK_EH_RESET_TIMER;
 
 done:
-	if (task)
-		task->last_timeout = jiffies;
 	spin_unlock_bh(&session->frwd_lock);
+
+	if (task) {
+		task->last_timeout = jiffies;
+		iscsi_put_task(task);
+	}
 	ISCSI_DBG_EH(session, "return %s\n", rc == BLK_EH_RESET_TIMER ?
 		     "timer reset" : "shutdown or nh");
 	return rc;
@@ -2217,15 +2226,20 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	conn->eh_abort_cnt++;
 	age = session->age;
 
+	spin_lock(&session->back_lock);
 	task = (struct iscsi_task *)sc->SCp.ptr;
-	ISCSI_DBG_EH(session, "aborting [sc %p itt 0x%x]\n",
-		     sc, task->itt);
-
-	/* task completed before time out */
-	if (!task->sc) {
+	if (!task || !task->sc) {
+		/* task completed before time out */
 		ISCSI_DBG_EH(session, "sc completed while abort in progress\n");
-		goto success;
+
+		spin_unlock(&session->back_lock);
+		spin_unlock_bh(&session->frwd_lock);
+		mutex_unlock(&session->eh_mutex);
+		return SUCCESS;
 	}
+	ISCSI_DBG_EH(session, "aborting [sc %p itt 0x%x]\n", sc, task->itt);
+	__iscsi_get_task(task);
+	spin_unlock(&session->back_lock);
 
 	if (task->state == ISCSI_TASK_PENDING) {
 		fail_scsi_task(task, DID_ABORT);
@@ -2287,6 +2301,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 success_unlocked:
 	ISCSI_DBG_EH(session, "abort success [sc %p itt 0x%x]\n",
 		     sc, task->itt);
+	iscsi_put_task(task);
 	mutex_unlock(&session->eh_mutex);
 	return SUCCESS;
 
@@ -2295,6 +2310,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 failed_unlocked:
 	ISCSI_DBG_EH(session, "abort failed [sc %p itt 0x%x]\n", sc,
 		     task ? task->itt : 0);
+	iscsi_put_task(task);
 	mutex_unlock(&session->eh_mutex);
 	return FAILED;
 }
-- 
1.8.3.1

