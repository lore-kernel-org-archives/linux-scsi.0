From: dongsu.park@profitbricks.com
Subject: [PATCH 3/5] ib_srp: hold a mutex when adding a new target port
Date: Fri, 31 Aug 2012 22:00:39 +0200
Message-ID: <1346443241-24844-4-git-send-email-dongsu.park@profitbricks.com>
References: <1346443241-24844-1-git-send-email-dongsu.park@profitbricks.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1346443241-24844-1-git-send-email-dongsu.park@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: bvanassche@acm.org
Cc: dillowda@ornl.gov, roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com, JBottomley@parallels.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Dongsu Park <dongsu.park@profitbricks.com>
List-Id: linux-scsi@vger.kernel.org

From: Dongsu Park <dongsu.park@profitbricks.com>

Unter circumstances, srp_rport_add() can make conflicts with
srp_rport_delete(), dumping the call trace written below.
That does not always occur. But its possible reason is adding
sysfs entries for the SRP target too fast, even before the
deletion hasn't finished yet.

The possible solution is therefore holding a scan_mutex when
calling device_add().

Example call trace:

------------[ cut here ]------------
WARNING: at block/genhd.c:1466 __disk_unblock_events+0x10f/0x120()
Pid: 17238, comm: scsi_id Not tainted 3.2.8-pserver #1
Call Trace:
 [<ffffffff81048dbb>] ? warn_slowpath_common+0x7b/0xc0
 [<ffffffff813879bf>] ? __disk_unblock_events+0x10f/0x120
 [<ffffffff81162b30>] ? __blkdev_get+0x190/0x410
 [<ffffffff811630c0>] ? blkdev_get+0x310/0x310
 [<ffffffff81162dfb>] ? blkdev_get+0x4b/0x310
 [<ffffffff811630c0>] ? blkdev_get+0x310/0x310
 [<ffffffff8112d513>] ? __dentry_open+0x263/0x370
 [<ffffffff8113a0fe>] ? path_get+0x1e/0x30
 [<ffffffff8113b4a0>] ? do_last+0x3e0/0x800
 [<ffffffff8113c21b>] ? path_openat+0xdb/0x400
 [<ffffffff8113c66d>] ? do_filp_open+0x4d/0xc0
 [<ffffffff81148c13>] ? alloc_fd+0x43/0x130
 [<ffffffff8112d915>] ? do_sys_open+0x105/0x1e0
 [<ffffffff8165d512>] ? system_call_fastpath+0x16/0x1b
---[ end trace 4edc2747f936431c ]---
------------[ cut here ]------------
WARNING: at fs/sysfs/inode.c:323 sysfs_hash_and_remove+0xa4/0xb0()
Hardware name: H8DGU
sysfs: can not remove 'bsg', no directory
Pid: 15816, comm: kworker/4:8 Tainted: G        W    3.2.8 #1
Call Trace:
 [<ffffffff81048dbb>] ? warn_slowpath_common+0x7b/0xc0
 [<ffffffff81048eb5>] ? warn_slowpath_fmt+0x45/0x50
 [<ffffffff8119a854>] ? sysfs_hash_and_remove+0xa4/0xb0
 [<ffffffff8138aaaf>] ? bsg_unregister_queue+0x3f/0x80
 [<ffffffffa000eda9>] ? __scsi_remove_device+0x99/0xc0 [scsi_mod]
 [<ffffffffa000b3b4>] ? scsi_forget_host+0x64/0x70 [scsi_mod]
 [<ffffffffa00035b1>] ? scsi_remove_host+0x61/0x100 [scsi_mod]
 [<ffffffffa0643097>] ? srp_remove_work+0x137/0x1c0 [ib_srp]
 [<ffffffffa0642f60>] ? srp_free_req_data+0xd0/0xd0 [ib_srp]
 [<ffffffff81063383>] ? process_one_work+0x113/0x470
 [<ffffffff81065a90>] ? manage_workers+0x180/0x200
 [<ffffffff81065c73>] ? worker_thread+0x163/0x3e0
 [<ffffffff81065b10>] ? manage_workers+0x200/0x200
 [<ffffffff81065b10>] ? manage_workers+0x200/0x200
 [<ffffffff8106a126>] ? kthread+0x96/0xa0
 [<ffffffff8165f674>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff8106a090>] ? kthread_worker_fn+0x180/0x180
 [<ffffffff8165f670>] ? gs_change+0x13/0x13
---[ end trace 4edc2747f936431d ]---
------------[ cut here ]------------

Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
---
 drivers/scsi/scsi_transport_srp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 7f17686..af3cb56 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -407,12 +407,15 @@ struct srp_rport *srp_rport_add(struct Scsi_Host *shost,
 
 	transport_setup_device(&rport->dev);
 
+	mutex_lock(&shost->scan_mutex);
 	ret = device_add(&rport->dev);
 	if (ret) {
+		mutex_unlock(&shost->scan_mutex);
 		transport_destroy_device(&rport->dev);
 		put_device(&rport->dev);
 		return ERR_PTR(ret);
 	}
+	mutex_unlock(&shost->scan_mutex);
 
 	if (shost->active_mode & MODE_TARGET &&
 	    ids->roles == SRP_RPORT_ROLE_INITIATOR) {
-- 
1.7.11.1
