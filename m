From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 1/5] scsi_transport_fc: Fix deadlock during
 fc_remove_host
Date: Mon, 25 Apr 2011 12:30:06 -0700
Message-ID: <1303759810-22570-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3661 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758629Ab1DYTa1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Apr 2011 15:30:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, devel@open-fcoe.org
Cc: Nithin Nayak Sujir <nsujir@broadcom.com>, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

From: Nithin Nayak Sujir <nsujir@broadcom.com>

Creating and destroying fcoe interface in a tight loop leads to a system
deadlock with the following call traces:

Call Trace:
[<ffffffff814f4b3d>] schedule_timeout+0x1fd/0x2c0
[<ffffffff814f469f>] ? wait_for_common+0x4f/0x190
[<ffffffff814f469f>] ? wait_for_common+0x4f/0x190
[<ffffffff814f4737>] wait_for_common+0xe7/0x190
[<ffffffff81042fa0>] ? default_wake_function+0x0/0x20
[<ffffffff81082c2d>] ? trace_hardirqs_on+0xd/0x10
[<ffffffff814f48bd>] wait_for_completion+0x1d/0x20
[<ffffffff81066d90>] flush_workqueue+0x290/0x5f0
[<ffffffff81066b00>] ? flush_workqueue+0x0/0x5f0
[<ffffffff81067148>] destroy_workqueue+0x38/0x340
[<ffffffffa0260289>] fc_remove_host+0x1b9/0x1f0 [scsi_transport_fc]
[<ffffffffa02ed195>] bnx2fc_if_destroy+0xc5/0x1f0 [bnx2fc]
[<ffffffffa02ed33a>] bnx2fc_destroy+0x7a/0x100 [bnx2fc]
[<ffffffffa02c789b>] fcoe_transport_destroy+0x9b/0x1b0 [libfcoe]
[<ffffffff81069ec2>] param_attr_store+0x52/0x80
[<ffffffff81069976>] module_attr_store+0x26/0x30
[<ffffffff8119e726>] sysfs_write_file+0xe6/0x170
[<ffffffff81134710>] vfs_write+0xd0/0x1a0
[<ffffffff811348e4>] sys_write+0x54/0xa0
[<ffffffff81002e02>] system_call_fastpath+0x16/0x1b
Call Trace:
[<ffffffff81074865>] async_synchronize_cookie_domain+0x75/0x120
[<ffffffff8106caa0>] ? autoremove_wake_function+0x0/0x40
[<ffffffff81074925>] async_synchronize_cookie+0x15/0x20
[<ffffffff8107494c>] async_synchronize_full+0x1c/0x40
[<ffffffffa0057466>] sd_remove+0x36/0xc0 [sd_mod]
[<ffffffff81358a75>] __device_release_driver+0x75/0xe0
[<ffffffff81358bef>] device_release_driver+0x2f/0x50
[<ffffffff81357aee>] bus_remove_device+0xbe/0x120
[<ffffffff813553ef>] device_del+0x12f/0x1e0
[<ffffffff8137454d>] __scsi_remove_device+0xbd/0xc0
[<ffffffff81374585>] scsi_remove_device+0x35/0x50
[<ffffffff813746a7>] __scsi_remove_target+0xe7/0x110
[<ffffffff81374730>] ? __remove_child+0x0/0x30
[<ffffffff81374753>] __remove_child+0x23/0x30
[<ffffffff81354a2c>] device_for_each_child+0x4c/0x80
[<ffffffff81374703>] scsi_remove_target+0x33/0x60
[<ffffffffa02622c6>] fc_starget_delete+0x26/0x30 [scsi_transport_fc]
[<ffffffffa026271a>] fc_rport_final_delete+0xaa/0x200 [scsi_transport_fc]
[<ffffffff8106585a>] process_one_work+0x1aa/0x540
[<ffffffff810657eb>] ? process_one_work+0x13b/0x540
[<ffffffffa0262670>] ? fc_rport_final_delete+0x0/0x200 [scsi_transport_fc]
[<ffffffff81067ac9>] worker_thread+0x179/0x410
[<ffffffff81067950>] ? worker_thread+0x0/0x410
[<ffffffff8106c546>] kthread+0xb6/0xc0
[<ffffffff8103879b>] ? finish_task_switch+0x4b/0xe0
[<ffffffff81003ca4>] kernel_thread_helper+0x4/0x10
[<ffffffff814f7994>] ? restore_args+0x0/0x30
[<ffffffff8106c490>] ? kthread+0x0/0xc0
[<ffffffff81003ca0>] ? kernel_thread_helper+0x0/0x10

fc_remove_host() waits for flushing the workqueue, but it is stuck at flushing
the first work. The first work doesnt complete, because it is waiting for async
layer to complete the IOs. The async layer cannot complete the IO as the
terminate_rport_io for the second work was not called, which will be called
only when the first work completes. Hence the deadlock.  To resolve this
deadlock, the workqueue allocation has been modified from
create_singlethread_workqueue() to alloc_workqueue().

In addition, fc_terminate_rport_io() should be called before the
scsi_flush_work() to avoid the similar deadlock as above.

scsi fc alloc queue. move terminate rport io before flush

Signed-off-by: Nithin Nayak Sujir <nsujir@broadcom.com>
Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/scsi_transport_fc.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 998c01b..a8b0621 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -422,8 +422,7 @@ static int fc_host_setup(struct transport_container *tc, struct device *dev,
 
 	snprintf(fc_host->work_q_name, sizeof(fc_host->work_q_name),
 		 "fc_wq_%d", shost->host_no);
-	fc_host->work_q = create_singlethread_workqueue(
-					fc_host->work_q_name);
+	fc_host->work_q = alloc_workqueue(fc_host->work_q_name, 0, 0);
 	if (!fc_host->work_q)
 		return -ENOMEM;
 
@@ -431,8 +430,8 @@ static int fc_host_setup(struct transport_container *tc, struct device *dev,
 	snprintf(fc_host->devloss_work_q_name,
 		 sizeof(fc_host->devloss_work_q_name),
 		 "fc_dl_%d", shost->host_no);
-	fc_host->devloss_work_q = create_singlethread_workqueue(
-					fc_host->devloss_work_q_name);
+	fc_host->devloss_work_q =
+			alloc_workqueue(fc_host->devloss_work_q_name, 0, 0);
 	if (!fc_host->devloss_work_q) {
 		destroy_workqueue(fc_host->work_q);
 		fc_host->work_q = NULL;
@@ -2489,6 +2488,8 @@ fc_rport_final_delete(struct work_struct *work)
 	unsigned long flags;
 	int do_callback = 0;
 
+	fc_terminate_rport_io(rport);
+
 	/*
 	 * if a scan is pending, flush the SCSI Host work_q so that
 	 * that we can reclaim the rport scan work element.
@@ -2496,8 +2497,6 @@ fc_rport_final_delete(struct work_struct *work)
 	if (rport->flags & FC_RPORT_SCAN_PENDING)
 		scsi_flush_work(shost);
 
-	fc_terminate_rport_io(rport);
-
 	/*
 	 * Cancel any outstanding timers. These should really exist
 	 * only when rmmod'ing the LLDD and we're asking for
-- 
1.7.0.6


