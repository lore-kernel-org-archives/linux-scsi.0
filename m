From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH] block: fix ext_devt_idr handling
Date: Tue, 29 Jan 2013 15:20:37 +0100
Message-ID: <5107DAB5.2060206@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

While adding and removing a lot of disks disks and partitions this sometimes
shows up -
WARNING: at fs/sysfs/dir.c:512 sysfs_add_one+0xc9/0x130() (Not tainted)
Hardware name:
sysfs: cannot create duplicate filename '/dev/block/259:751'
Modules linked in: raid1 autofs4 bnx2fc cnic uio fcoe libfcoe libfc 8021q scsi_transport_fc scsi_tgt garp stp llc sunrpc cpufreq_ondemand powernow_k8 freq_table mperf ipv6 dm_mirror dm_region_hash dm_log power_meter microcode dcdbas serio_raw amd64_edac_mod edac_core edac_mce_amd i2c_piix4 i2c_core k10temp bnx2 sg ixgbe dca mdio ext4 mbcache jbd2 dm_round_robin sr_mod cdrom sd_mod crc_t10dif ata_generic pata_acpi pata_atiixp ahci mptsas mptscsih mptbase scsi_transport_sas dm_multipath dm_mod [last unloaded: scsi_wait_scan]
Pid: 44103, comm: async/16 Not tainted 2.6.32-195.el6.x86_64 #1
Call Trace:
 [<ffffffff81069b17>] ? warn_slowpath_common+0x87/0xc0
 [<ffffffff81069c06>] ? warn_slowpath_fmt+0x46/0x50
 [<ffffffff811ecf09>] ? sysfs_add_one+0xc9/0x130
 [<ffffffff811ed3eb>] ? sysfs_do_create_link+0x12b/0x170
 [<ffffffff811ed463>] ? sysfs_create_link+0x13/0x20
 [<ffffffff81343177>] ? device_add+0x317/0x650
 [<ffffffff8126bd03>] ? idr_get_new+0x13/0x50
 [<ffffffff811e6adc>] ? add_partition+0x21c/0x390
 [<ffffffff811e759b>] ? rescan_partitions+0x32b/0x470
 [<ffffffffa008e341>] ? sd_open+0x81/0x1f0 [sd_mod]
 [<ffffffff811afa56>] ? __blkdev_get+0x1b6/0x3c0
 [<ffffffff811afc70>] ? blkdev_get+0x10/0x20
 [<ffffffff811e68a5>] ? register_disk+0x155/0x170
 [<ffffffff81258706>] ? add_disk+0xa6/0x160
 [<ffffffffa00919db>] ? sd_probe_async+0x13b/0x210 [sd_mod]
 [<ffffffff81090ed6>] ? add_wait_queue+0x46/0x60
 [<ffffffff81098dd2>] ? async_thread+0x102/0x250
 [<ffffffff8105f740>] ? default_wake_function+0x0/0x20
 [<ffffffff81098cd0>] ? async_thread+0x0/0x250
 [<ffffffff81090806>] ? kthread+0x96/0xa0
 [<ffffffff8100c10a>] ? child_rip+0xa/0x20
 [<ffffffff81090770>] ? kthread+0x0/0xa0
 [<ffffffff8100c100>] ? child_rip+0x0/0x20
This most likely happens because dev_t is freed before while the number is still used
and idr_get_new is not protected on every use. The fix adds a mutex where
it wasn't before and moves the dev_t free function so it is called after
device del.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 block/genhd.c             | 6 +++++-
 block/partition-generic.c | 2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 9cf5583..9433636 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -420,14 +420,18 @@ int blk_alloc_devt(struct hd_struct *part, dev_t *devt)
 	do {
 		if (!idr_pre_get(&ext_devt_idr, GFP_KERNEL))
 			return -ENOMEM;
+		mutex_lock(&ext_devt_mutex);
 		rc = idr_get_new(&ext_devt_idr, part, &idx);
+		mutex_unlock(&ext_devt_mutex);
 	} while (rc == -EAGAIN);
 
 	if (rc)
 		return rc;
 
 	if (idx > MAX_EXT_DEVT) {
+		mutex_lock(&ext_devt_mutex);
 		idr_remove(&ext_devt_idr, idx);
+		mutex_unlock(&ext_devt_mutex);
 		return -EBUSY;
 	}
 
@@ -644,7 +648,6 @@ void del_gendisk(struct gendisk *disk)
 	disk_part_iter_exit(&piter);
 
 	invalidate_partition(disk, 0);
-	blk_free_devt(disk_to_dev(disk)->devt);
 	set_capacity(disk, 0);
 	disk->flags &= ~GENHD_FL_UP;
 
@@ -662,6 +665,7 @@ void del_gendisk(struct gendisk *disk)
 	if (!sysfs_deprecated)
 		sysfs_remove_link(block_depr, dev_name(disk_to_dev(disk)));
 	device_del(disk_to_dev(disk));
+	blk_free_devt(disk_to_dev(disk)->devt);
 }
 EXPORT_SYMBOL(del_gendisk);
 
diff --git a/block/partition-generic.c b/block/partition-generic.c
index 6df5d69..7b8b8d1 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -249,11 +249,11 @@ void delete_partition(struct gendisk *disk, int partno)
 	if (!part)
 		return;
 
-	blk_free_devt(part_devt(part));
 	rcu_assign_pointer(ptbl->part[partno], NULL);
 	rcu_assign_pointer(ptbl->last_lookup, NULL);
 	kobject_put(part->holder_dir);
 	device_del(part_to_dev(part));
+	blk_free_devt(part_devt(part));
 
 	hd_struct_put(part);
 }
-- 
1.7.11.7
