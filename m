From: Israel Rukshin <israelr@mellanox.com>
Subject: [PATCH] scsi_sysfs: fix hang when removing scsi device
Date: Thu,  2 Mar 2017 16:45:53 +0200
Message-ID: <1488465953-29832-1-git-send-email-israelr@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:46529 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753302AbdCBPqj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2017 10:46:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Max Gurtovoy <maxg@mellanox.com>, Israel Rukshin <israelr@mellanox.com>

The bug reproduce when unloading srp module with one port down.
device_del() hangs when __scsi_remove_device() get scsi_device with
state SDEV_OFFLINE or SDEV_TRANSPORT_OFFLINE.
It hangs because device_del() is trying to send sync cache command
when the device is offline but with SDEV_CANCEL status.
The status was changed to SDEV_CANCEL by __scsi_remove_device()
before it calls to device_del().

This commit doesn't accept new commands if the original state was offline.

sysrq: SysRq : sysrq: Show Blocked State
task PC stack pid father
kworker/2:0 D ffff88046fa95c00 0 21178 2 0x00000000
Workqueue: srp_remove srp_remove_work [ib_srp]
Call Trace:
[<ffffffff815dd985>] schedule+0x35/0x80
[<ffffffff815e02c7>] schedule_timeout+0x237/0x2d0
[<ffffffff815dcf46>] io_schedule_timeout+0xa6/0x110
[<ffffffff815de2f3>] wait_for_completion_io+0xa3/0x110
[<ffffffff812e66ff>] blk_execute_rq+0xdf/0x120
[<ffffffffa00135de>] scsi_execute+0xce/0x150 [scsi_mod]
[<ffffffffa001548f>] scsi_execute_req_flags+0x8f/0xf0 [scsi_mod]
[<ffffffffa0154849>] sd_sync_cache+0xa9/0x190 [sd_mod]
[<ffffffffa0154c3a>] sd_shutdown+0x6a/0x100 [sd_mod]
[<ffffffffa0154d34>] sd_remove+0x64/0xc0 [sd_mod]
[<ffffffff8144d3fd>] __device_release_driver+0x8d/0x120
[<ffffffff8144d4ae>] device_release_driver+0x1e/0x30
[<ffffffff8144c239>] bus_remove_device+0xf9/0x170
[<ffffffff81448bc7>] device_del+0x127/0x240
[<ffffffffa001c0f1>] __scsi_remove_device+0xc1/0xd0 [scsi_mod]
[<ffffffffa001a5d7>] scsi_forget_host+0x57/0x60 [scsi_mod]
[<ffffffffa000e3d2>] scsi_remove_host+0x72/0x110 [scsi_mod]
[<ffffffffa06f95ab>] srp_remove_work+0x8b/0x200 [ib_srp]
...

Fixes: e619e6cbe (Revert "scsi: Fix a bdi reregistration race")
Signed-off-by: Israel Rukshin <israelr@mellanox.com>
Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
---
 drivers/scsi/scsi_sysfs.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 82dfe07..ed55aac 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1282,6 +1282,8 @@ void __scsi_remove_device(struct scsi_device *sdev)
 		return;
 
 	if (sdev->is_visible) {
+		enum scsi_device_state oldstate = sdev->sdev_state;
+
 		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
 			return;
 
@@ -1289,6 +1291,15 @@ void __scsi_remove_device(struct scsi_device *sdev)
 		device_unregister(&sdev->sdev_dev);
 		transport_remove_device(dev);
 		scsi_dh_remove_device(sdev);
+
+		/*
+		 * Fail new requests if the old state was offline.
+		 * This avoids from device_del() to hang.
+		 */
+		if (oldstate == SDEV_TRANSPORT_OFFLINE ||
+		    oldstate == SDEV_OFFLINE)
+			blk_set_queue_dying(sdev->request_queue);
+
 		device_del(dev);
 	} else
 		put_device(&sdev->sdev_dev);
-- 
2.4.3
