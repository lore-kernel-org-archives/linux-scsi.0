Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88601C4361B
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 08:22:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C368229C7
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 08:22:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbgLNIWI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Dec 2020 03:22:08 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9197 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726241AbgLNIWH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2020 03:22:07 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CvZ8K479tzkrZB;
        Mon, 14 Dec 2020 16:20:33 +0800 (CST)
Received: from huawei.com (10.175.124.27) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.498.0; Mon, 14 Dec 2020
 16:21:09 +0800
From:   Wu Bo <wubo40@huawei.com>
To:     <lduncan@suse.com>, <cleech@redhat.com>, <michaelc@cs.wisc.edu>,
        <linux-scsi@vger.kernel.org>, <open-iscsi@googlegroups.com>
CC:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>,
        <lutianxiong@huawei.com>, <linfeilong@huawei.com>,
        <liuzhiqiang26@huawei.com>, <wubo40@huawei.com>,
        <haowenchao@huawei.com>
Subject: [RFC PATCH] scsi:libiscsi:Fix possible NULL dereference in iscsi_eh_cmd_timed_out
Date:   Mon, 14 Dec 2020 16:41:57 +0800
Message-ID: <1607935317-263599-1-git-send-email-wubo40@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.27]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When testing kernel 4.18 version, NULL pointer dereference problem occurs
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
	
   CPU0                                       	       CPU3

    |- scsi_times_out()                        		|- iscsi_complete_task()
    |                                       		|
    |- iscsi_eh_cmd_timed_out()                 	|- __iscsi_put_task()
    |                                       		|
    |- task=sc->SCp.ptr, task is not NUL, check passed  |- iscsi_free_task(task) 
    |                                       		|
    | 							|-> sc->SCp.ptr = NULL
    |                                                   |
    |- task is NULL now, NULL pointer dereference       |
    |                                           	| 
   \|/                                     	       \|/

Calltrace:
[380751.840862] BUG: unable to handle kernel NULL pointer dereference at 0000000000000138
[380751.843709] PGD 0 P4D 0
[380751.844770] Oops: 0000 [#1] SMP PTI
[380751.846283] CPU: 0 PID: 403 Comm: kworker/0:1H Kdump: loaded Tainted: G
[380751.851467] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
[380751.856521] Workqueue: kblockd blk_mq_timeout_work
[380751.858527] RIP: 0010:iscsi_eh_cmd_timed_out+0x15e/0x2e0 [libiscsi]
[380751.861129] Code: 83 ea 01 48 8d 74 d0 08 48 8b 10 48 8b 4a 50 48 85 c9 74 2c 48 39 d5 74
[380751.868811] RSP: 0018:ffffc1e280a5fd58 EFLAGS: 00010246
[380751.870978] RAX: ffff9fd1e84e15e0 RBX: ffff9fd1e84e6dd0 RCX: 0000000116acc580
[380751.873791] RDX: ffff9fd1f97a9400 RSI: ffff9fd1e84e1800 RDI: ffff9fd1e4d6d420
[380751.876059] RBP: ffff9fd1e4d49000 R08: 0000000116acc580 R09: 0000000116acc580
[380751.878284] R10: 0000000000000000 R11: 0000000000000000 R12: ffff9fd1e6e931e8
[380751.880500] R13: ffff9fd1e84e6ee0 R14: 0000000000000010 R15: 0000000000000003
[380751.882687] FS:  0000000000000000(0000) GS:ffff9fd1fac00000(0000) knlGS:0000000000000000
[380751.885236] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[380751.887059] CR2: 0000000000000138 CR3: 000000011860a001 CR4: 00000000003606f0
[380751.889308] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[380751.891523] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
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

1970 enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
{
...
1984         spin_lock_bh(&session->frwd_lock);
1985         task = (struct iscsi_task *)sc->SCp.ptr;
1986         if (!task) {    
1987                 /*
1988                  * Raced with completion. Blk layer has taken ownership
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
2059                  * Only check if cmds started before this one have made
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

Fixes: 3e5c28ad03 ("libiscsi: merge iscsi_mgmt_task and iscsi_cmd_task")
Signed-off-by: Wu Bo <wubo40@huawei.com>
---
 drivers/scsi/libiscsi.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 0bb5d76..e2cacdd 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -876,7 +876,9 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	ISCSI_DBG_SESSION(session, "cmd rsp done [sc %p res %d itt 0x%x]\n",
 			  sc, sc->result, task->itt);
 	conn->scsirsp_pdus_cnt++;
+	spin_lock_bh(&session->frwd_lock);
 	iscsi_complete_task(task, ISCSI_TASK_COMPLETED);
+	spin_unlock_bh(&session->frwd_lock);
 }
 
 /**
@@ -917,7 +919,9 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			  "[sc %p res %d itt 0x%x]\n",
 			  sc, sc->result, task->itt);
 	conn->scsirsp_pdus_cnt++;
+	spin_lock_bh(&conn->session->frwd_lock);
 	iscsi_complete_task(task, ISCSI_TASK_COMPLETED);
+	spin_unlock_bh(&conn->session->frwd_lock);
 }
 
 static void iscsi_tmf_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
@@ -1001,7 +1005,10 @@ static int iscsi_nop_out_rsp(struct iscsi_task *task,
 			rc = ISCSI_ERR_CONN_FAILED;
 	} else
 		mod_timer(&conn->transport_timer, jiffies + conn->recv_timeout);
+	spin_lock_bh(&conn->session->frwd_lock);
 	iscsi_complete_task(task, ISCSI_TASK_COMPLETED);
+	spin_unlock_bh(&conn->session->frwd_lock);
+
 	return rc;
 }
 
@@ -1241,7 +1248,9 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		}
 
 		iscsi_tmf_rsp(conn, hdr);
+		spin_lock_bh(&session->frwd_lock);
 		iscsi_complete_task(task, ISCSI_TASK_COMPLETED);
+		spin_unlock_bh(&session->frwd_lock);
 		break;
 	case ISCSI_OP_NOOP_IN:
 		iscsi_update_cmdsn(session, (struct iscsi_nopin*)hdr);
@@ -1264,7 +1273,10 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 recv_pdu:
 	if (iscsi_recv_pdu(conn->cls_conn, hdr, data, datalen))
 		rc = ISCSI_ERR_CONN_FAILED;
+	spin_lock_bh(&session->frwd_lock);
 	iscsi_complete_task(task, ISCSI_TASK_COMPLETED);
+	spin_unlock_bh(&session->frwd_lock);
+
 	return rc;
 }
 EXPORT_SYMBOL_GPL(__iscsi_complete_pdu);
-- 
1.8.3.1

