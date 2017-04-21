From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v4 4/4] Avoid that __scsi_remove_device() hangs
Date: Fri, 21 Apr 2017 14:26:36 -0700
Message-ID: <20170421212636.14376-5-bart.vanassche@sandisk.com>
References: <20170421212636.14376-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:50048 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1422888AbdDUV05 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2017 17:26:57 -0400
In-Reply-To: <20170421212636.14376-1-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Max Gurtovoy <maxg@mellanox.com>, Hannes Reinecke <hare@suse.de>, Song Liu <songliubraving@fb.com>

Since scsi_target_unblock() uses starget_for_each_device(), since
starget_for_each_device() uses scsi_device_get(), since
scsi_device_get() fails after unloading of the LLD kernel module
has been started scsi_target_unblock() may skip devices that were
affected by scsi_target_block(). Ensure that __scsi_remove_device()
does not hang for blocked SCSI devices. This patch avoids that
unloading the ib_srp kernel module can trigger the following hang:

Call Trace:
 schedule+0x35/0x80
 schedule_timeout+0x237/0x2d0
 io_schedule_timeout+0xa6/0x110
 wait_for_completion_io+0xa3/0x110
 blk_execute_rq+0xdf/0x120
 scsi_execute+0xce/0x150 [scsi_mod]
 scsi_execute_req_flags+0x8f/0xf0 [scsi_mod]
 sd_sync_cache+0xa9/0x190 [sd_mod]
 sd_shutdown+0x6a/0x100 [sd_mod]
 sd_remove+0x64/0xc0 [sd_mod]
 __device_release_driver+0x8d/0x120
 device_release_driver+0x1e/0x30
 bus_remove_device+0xf9/0x170
 device_del+0x127/0x240
 __scsi_remove_device+0xc1/0xd0 [scsi_mod]
 scsi_forget_host+0x57/0x60 [scsi_mod]
 scsi_remove_host+0x72/0x110 [scsi_mod]
 srp_remove_work+0x8b/0x200 [ib_srp]

Reported-by: Israel Rukshin <israelr@mellanox.com>
Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Max Gurtovoy <maxg@mellanox.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Song Liu <songliubraving@fb.com>
---
 drivers/scsi/scsi_sysfs.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 82dfe07b1d47..e090c35ba6ee 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1299,6 +1299,15 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	 * device.
 	 */
 	scsi_device_set_state(sdev, SDEV_DEL);
+	/*
+	 * Since scsi_target_unblock() is a no-op after unloading of the SCSI
+	 * LLD has started, explicitly restart the queue. Do this after the
+	 * device state has been changed into SDEV_DEL because
+	 * scsi_prep_state_check() returns BLKPREP_KILL for the SDEV_DEL state
+	 * Do this before calling blk_cleanup_queue() to avoid that that
+	 * function encounters a stopped queue.
+	 */
+	scsi_start_queue(sdev);
 	blk_cleanup_queue(sdev->request_queue);
 	cancel_work_sync(&sdev->requeue_work);
 
-- 
2.12.2
