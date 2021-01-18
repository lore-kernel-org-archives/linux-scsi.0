Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78C9DC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 20:43:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C74C22B39
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 20:43:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394430AbhARUnO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 15:43:14 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:44262 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437943AbhARUlL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 15:41:11 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10IKeAJb088753;
        Mon, 18 Jan 2021 20:40:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=qZ6X1PhkkpKFhCy/QAAPyGD6yYOlfifebmxonTWXKoE=;
 b=bVNGLoALKvu3F61ElfFdEpgNi7Ga0HyV5tavah3FU1HYjkTRQqsZ6lrTLqM/htAUBwaD
 PLRmp3eIuxXAvkoiVCUiNo0gmmi7z35W0bz3rwj7g7FzgSvlSy7ZCiXqFe5ISEsnPGS7
 QHaaox+Wh0AHuuxmiqewFikl2r90BpfNljEFe1wt1S8lHgpvjPWTyHGgPUtEaaaPdZ57
 BYqW2q7bG0zPE01bQOttil7gkJZmgKDihacJK+1ODgwDCAQm0+3wlaBUh0vGDh0sMQsx
 bMd67gtWSdULLOIoLtcB88d5Hpb/e8I1M4EFL93JOw0qfOwZLgwmKCPm4W+3JI6+5gO3 /Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 363r3kphwe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Jan 2021 20:40:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10IKbq3x072016;
        Mon, 18 Jan 2021 20:38:12 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 3649wqetdu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Jan 2021 20:38:12 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10IKYhDG026487;
        Mon, 18 Jan 2021 20:34:43 GMT
Received: from localhost.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 Jan 2021 12:34:42 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com,
        Wu Bo <wubo40@huawei.com>
Subject: [PATCH 3/7] libiscsi: fix iscsi_task use after free
Date:   Mon, 18 Jan 2021 14:34:26 -0600
Message-Id: <20210118203430.4921-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210118203430.4921-1-michael.christie@oracle.com>
References: <20210118203430.4921-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9868 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 spamscore=0 phishscore=0 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101180124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9868 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=0 impostorscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101180125
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

Note that this requires the previous patch, "libiscsi: drop
taskqueuelock" because bnx2i sleeps in its cleanup_task callout if the
cmd is aborted. If the EH/timer and completion path are racing we don't
know which path will do the last put. The previous patch moved the
operations we needed to do under the forward lock to cleanup_queued_task.
Once that has run we can drop the forward lock for the cmd and bnx2i no
longer has to worry about if the EH, timer or completion path did the
ast put and if the forward lock is held or not since it won't be.

Reported-by: Wu Bo <wubo40@huawei.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c |  2 -
 drivers/scsi/libiscsi.c          | 71 ++++++++++++++++++++------------
 2 files changed, 45 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index fdd446765311..1e6d8f62ea3c 100644
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
index 3d74fdd9f31a..ec159bcb7460 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -587,9 +587,8 @@ static bool cleanup_queued_task(struct iscsi_task *task)
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
@@ -597,16 +596,6 @@ static void fail_scsi_task(struct iscsi_task *task, int err)
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
@@ -626,6 +615,7 @@ static void fail_scsi_task(struct iscsi_task *task, int err)
 	else
 		state = ISCSI_TASK_ABRT_TMF;
 
+	sc = task->sc;
 	sc->result = err << 16;
 	scsi_set_resid(sc, scsi_bufflen(sc));
 	iscsi_complete_task(task, state);
@@ -1893,27 +1883,39 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
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
@@ -1991,6 +1993,7 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 	ISCSI_DBG_EH(session, "scsi cmd %p timedout\n", sc);
 
 	spin_lock_bh(&session->frwd_lock);
+	spin_lock(&session->back_lock);
 	task = (struct iscsi_task *)sc->SCp.ptr;
 	if (!task) {
 		/*
@@ -1998,8 +2001,11 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
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
@@ -2058,6 +2064,7 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 		goto done;
 	}
 
+	spin_lock(&session->back_lock);
 	for (i = 0; i < conn->session->cmds_max; i++) {
 		running_task = conn->session->cmds[i];
 		if (!running_task->sc || running_task == task ||
@@ -2090,10 +2097,12 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 				     "last xfer %lu/%lu. Last check %lu.\n",
 				     task->last_xfer, running_task->last_xfer,
 				     task->last_timeout);
+			spin_unlock(&session->back_lock);
 			rc = BLK_EH_RESET_TIMER;
 			goto done;
 		}
 	}
+	spin_unlock(&session->back_lock);
 
 	/* Assumes nop timeout is shorter than scsi cmd timeout */
 	if (task->have_checked_conn)
@@ -2115,9 +2124,12 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
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
@@ -2225,15 +2237,20 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
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
@@ -2295,6 +2312,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 success_unlocked:
 	ISCSI_DBG_EH(session, "abort success [sc %p itt 0x%x]\n",
 		     sc, task->itt);
+	iscsi_put_task(task);
 	mutex_unlock(&session->eh_mutex);
 	return SUCCESS;
 
@@ -2303,6 +2321,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 failed_unlocked:
 	ISCSI_DBG_EH(session, "abort failed [sc %p itt 0x%x]\n", sc,
 		     task ? task->itt : 0);
+	iscsi_put_task(task);
 	mutex_unlock(&session->eh_mutex);
 	return FAILED;
 }
-- 
2.25.1

