From: Wei Fang <fangwei1@huawei.com>
Subject: [RESEND PATCH] scsi: fix ata_port_wait_eh() hang caused by missing to wake up eh thread
Date: Sun, 9 Oct 2016 22:21:45 +0800
Message-ID: <1476022905-17234-1-git-send-email-fangwei1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:64709 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751798AbcJIOTx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Oct 2016 10:19:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Wei Fang <fangwei1@huawei.com>

->host_eh_schedule and ->shost_state may be accessed simultaneously as
below:

1.In ata port probe path:
ata_std_sched_eh()
	scsi_schedule_eh()
		...
		spin_lock_irqsave(shost->host_lock, flags);
		if (scsi_host_set_state(shost, SHOST_RECOVERY) == 0 ||
		    scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY) == 0) {
			shost->host_eh_scheduled++;
			scsi_eh_wakeup();
		}
		spin_unlock_irqrestore(shost->host_lock, flags);
		...

2.In IO complete path:
scsi_device_unbusy()
	...
	atomic_dec(&shost->host_busy)
	if (unlikely(scsi_host_in_recovery(shost) &&
		(shost->host_failed || shost->host_eh_scheduled))) {
		spin_lock_irqsave(shost->host_lock, flags);
		scsi_eh_wakeup(shost);
		spin_unlock_irqrestore(shost->host_lock, flags);
	}
	...

In the IO complete path, ->host_eh_schedule and ->shost_state are
accessed without ->host_lock, and obsoleted data may be got after
scsi_eh_wakeup() has been called in scsi_schedule_eh().

It's the case that causes the problem:
* One IO hasn't finished when scsi_schedule_eh() has been called
  in ata port probe path
* scsi_eh_wakeup() has been called in scsi_schedule_eh() without
  waking up eh thread because of ->host_busy != ->host_failed
* this IO completes and scsi_device_unbusy() is called
* obsoleted ->host_eh_schedule and ->shost_state are got, and eh
  thread can't be woken up in this path too

Eh thread won't be woken up ever in this case, and a hung task
will happen:

INFO: task kworker/u64:0:6 blocked for more than 120 seconds.
...
Call trace:
[<ffff800000086b04>] __switch_to+0x78/0x90
[<ffff800000bf95bc>] __schedule+0x244/0x79c
[<ffff800000bf9b54>] schedule+0x40/0x98
[<ffff8000006cc990>] ata_port_wait_eh+0x8c/0x110
[<ffff80000064f764>] sas_ata_wait_eh+0x3c/0x44
[<ffff80000064f7e0>] sas_probe_sata_device+0x74/0xf8
[<ffff800000648320>] sas_add_device+0xac/0x1ac
[<ffff8000000d9458>] process_one_work+0x164/0x428
[<ffff8000000d9860>] worker_thread+0x144/0x4a8
[<ffff8000000dfbb0>] kthread+0xfc/0x110

After that, the host is in recovery state, and any IOs to this
host will be blocked.

Fix this by accessing ->host_eh_schedule and ->shost_state in
->host_lock. We have tested the IOPS throughput by fio and found
no performance degradation.

Signed-off-by: Wei Fang <fangwei1@huawei.com>
---
 drivers/scsi/scsi_lib.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 2cca9cf..5a72e1d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -272,23 +272,27 @@ static void scsi_init_cmd_errh(struct scsi_cmnd *cmd)
 		cmd->cmd_len = scsi_command_size(cmd->cmnd);
 }
 
+static void __scsi_eh_wakeup(struct Scsi_Host *shost)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	if (unlikely(scsi_host_in_recovery(shost) &&
+		     (shost->host_failed || shost->host_eh_scheduled)))
+		scsi_eh_wakeup(shost);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+}
+
 void scsi_device_unbusy(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost = sdev->host;
 	struct scsi_target *starget = scsi_target(sdev);
-	unsigned long flags;
 
 	atomic_dec(&shost->host_busy);
 	if (starget->can_queue > 0)
 		atomic_dec(&starget->target_busy);
 
-	if (unlikely(scsi_host_in_recovery(shost) &&
-		     (shost->host_failed || shost->host_eh_scheduled))) {
-		spin_lock_irqsave(shost->host_lock, flags);
-		scsi_eh_wakeup(shost);
-		spin_unlock_irqrestore(shost->host_lock, flags);
-	}
-
+	__scsi_eh_wakeup(shost);
 	atomic_dec(&sdev->device_busy);
 }
 
@@ -1457,6 +1461,7 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
 	spin_unlock_irq(shost->host_lock);
 out_dec:
 	atomic_dec(&shost->host_busy);
+	__scsi_eh_wakeup(shost);
 	return 0;
 }
 
@@ -1931,6 +1936,7 @@ static int scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 out_dec_host_busy:
 	atomic_dec(&shost->host_busy);
+	__scsi_eh_wakeup(shost);
 out_dec_target_busy:
 	if (scsi_target(sdev)->can_queue > 0)
 		atomic_dec(&scsi_target(sdev)->target_busy);
-- 
1.9.3

