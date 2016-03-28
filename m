From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 1/3] kernel/kthread.c: Avoid CPU lockups
Date: Mon, 28 Mar 2016 14:48:45 -0700
Message-ID: <56F9A6BD.8080208@sandisk.com>
References: <56F9A692.2090704@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0095.outbound.protection.outlook.com ([207.46.100.95]:39243
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752252AbcC1Vs5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Mar 2016 17:48:57 -0400
In-Reply-To: <56F9A692.2090704@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@fb.com>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Avoid that complaints similar to the one below are reported against
a debug kernel:

NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [kdmwork-25 4:2:23313]
irq event stamp: 16320042
hardirqs last  enabled at (16320041): [<ffffffff815992c7>] _raw_spin_unlock_irq+0x27/0x40
hardirqs last disabled at (16320042): [<ffff8803ffbe3cd8>] 0xffff8803ffbe3cd8
softirqs last  enabled at (16319960): [<ffffffff8105bcdb>] __do_softirq+0x1cb/0x230
softirqs last disabled at (16319715): [<ffffffff8105bec8>] irq_exit+0xa8/0xb0
CPU: 1 PID: 23313 Comm: kdmwork-254:2
RIP: 0010:[<ffffffff815992cf>]  [<ffffffff815992cf>] _raw_spin_unlock_irq+0x2f/0x40
Call Trace:
 [<ffffffff813f702f>] scsi_request_fn+0x11f/0x630
 [<ffffffff812977fe>] __blk_run_queue+0x2e/0x40
 [<ffffffff81297065>] __elv_add_request+0x75/0x1f0
 [<ffffffff8129ba91>] blk_insert_cloned_request+0x101/0x190
 [<ffffffffa0189f1a>] map_request+0x16a/0x1b0 [dm_mod]
 [<ffffffffa0189f7d>] map_tio_request+0x1d/0x40 [dm_mod]
 [<ffffffff81077812>] kthread_worker_fn+0x82/0x1a0
 [<ffffffff8107771a>] kthread+0xea/0x100
 [<ffffffff81599b72>] ret_from_fork+0x22/0x40

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 kernel/kthread.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 9ff173d..516ca6b 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -593,6 +593,7 @@ repeat:
 	if (work) {
 		__set_current_state(TASK_RUNNING);
 		work->func(work);
+		cond_resched_rcu_qs();
 	} else if (!freezing(current))
 		schedule();
 
-- 
2.7.3

