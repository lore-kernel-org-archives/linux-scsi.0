From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2 06/12] Make __scsi_remove_device go straight from BLOCKED to DEL
Date: Thu, 1 Jun 2017 16:27:05 -0700
Message-ID: <20170601232711.29062-7-bart.vanassche@sandisk.com>
References: <20170601232711.29062-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:64778 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751105AbdFAX1U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jun 2017 19:27:20 -0400
In-Reply-To: <20170601232711.29062-1-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Israel Rukshin <israelr@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Benjamin Block <bblock@linux.vnet.ibm.com>

If a device is blocked, make __scsi_remove_device() cause it to
transition to the DEL state. This means that all the commands
issued in .shutdown() will error in the mid-layer, thus making
the removal proceed without being stopped.

This patch is a slightly modified version of a patch from James
Bottomley. This patch avoids that the following lockup occurs:

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
Reviewed-by: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Israel Rukshin <israelr@mellanox.com>
Cc: Max Gurtovoy <maxg@mellanox.com>
Cc: Benjamin Block <bblock@linux.vnet.ibm.com>
---
 drivers/scsi/scsi_lib.c   |  2 +-
 drivers/scsi/scsi_sysfs.c | 13 +++++++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6a58a124714f..8665eccd2fc8 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2624,7 +2624,6 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 		case SDEV_QUIESCE:
 		case SDEV_OFFLINE:
 		case SDEV_TRANSPORT_OFFLINE:
-		case SDEV_BLOCK:
 			break;
 		default:
 			goto illegal;
@@ -2638,6 +2637,7 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 		case SDEV_OFFLINE:
 		case SDEV_TRANSPORT_OFFLINE:
 		case SDEV_CANCEL:
+		case SDEV_BLOCK:
 		case SDEV_CREATED_BLOCK:
 			break;
 		default:
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index a91537a3abbf..1f243ac16010 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1290,7 +1290,20 @@ void __scsi_remove_device(struct scsi_device *sdev)
 		 * wait until it has finished before changing the device state.
 		 */
 		mutex_lock(&sdev->state_mutex);
+		/*
+		 * If blocked, we go straight to DEL and restart the queue so
+		 * any commands issued during driver shutdown (like sync
+		 * cache) are errored immediately.
+		 */
 		res = scsi_device_set_state(sdev, SDEV_CANCEL);
+		if (res != 0) {
+			res = scsi_device_set_state(sdev, SDEV_DEL);
+			if (res == 0) {
+				scsi_start_queue(sdev);
+				sdev_printk(KERN_DEBUG, sdev,
+				    "Changed state from BLOCKED to DEL\n");
+			}
+		}
 		mutex_unlock(&sdev->state_mutex);
 
 		if (res != 0)
-- 
2.12.2
