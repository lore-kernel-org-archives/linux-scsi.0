From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 3/3] Ensure that scsi_target_unblock() examines all devices
Date: Thu, 16 Mar 2017 13:56:50 -0700
Message-ID: <20170316205650.3322-4-bart.vanassche@sandisk.com>
References: <20170316205650.3322-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170316205650.3322-1-bart.vanassche@sandisk.com>
Sender: stable-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Israel Rukshin <israelr@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Bart Van Assche <bart.vanassche@sandisk.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Since scsi_target_unblock() uses starget_for_each_device(), since
starget_for_each_device() uses scsi_device_get(), since
scsi_device_get() fails after unloading of the LLD kernel module
has been started scsi_target_unblock() may skip devices that were
affected by scsi_target_block(). Ensure that scsi_target_block()
examines all SCSI devices. This patch avoids that unloading the
ib_srp kernel module can trigger the following hang:

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
Tested-by: Israel Rukshin <israelr@mellanox.com>
Cc: Max Gurtovoy <maxg@mellanox.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/scsi_lib.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 19125d72f322..f03a7867c04f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3071,21 +3071,37 @@ device_unblock(struct scsi_device *sdev, void *data)
 	scsi_internal_device_unblock(sdev, *(enum scsi_device_state *)data);
 }
 
+/**
+ * target_unblock() - unblock all devices associated with a SCSI target
+ *
+ * Notes:
+ * - Do not use scsi_device_get() nor any of the macros that use this
+ *   function from inside scsi_target_block() because otherwise this function
+ *   won't have any effect when called while the SCSI LLD is being unloaded.
+ * - Do not hold the host lock around the device_unblock() calls because at
+ *   least for blk-sq the block layer queue lock is the outer lock and the
+ *   SCSI host lock is the inner lock.
+ */
 static int
 target_unblock(struct device *dev, void *data)
 {
 	if (scsi_is_target_device(dev))
-		starget_for_each_device(to_scsi_target(dev), data,
+		starget_for_all_devices(to_scsi_target(dev), data,
 					device_unblock);
 	return 0;
 }
 
+/**
+ * scsi_target_unblock() - unblock all devices associated with a SCSI target
+ * @dev: Either a pointer to the dev member of struct scsi_target or a pointer
+ *	to the shost_gendev member of struct Scsi_Host.
+ * @new_state: New SCSI device state.
+ */
 void
 scsi_target_unblock(struct device *dev, enum scsi_device_state new_state)
 {
 	if (scsi_is_target_device(dev))
-		starget_for_each_device(to_scsi_target(dev), &new_state,
-					device_unblock);
+		target_unblock(dev, &new_state);
 	else
 		device_for_each_child(dev, &new_state, target_unblock);
 }
-- 
2.12.0
