From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] target: Avoid that EXTENDED COPY commands triggers lock inversion
Date: Fri,  1 Sep 2017 13:11:53 -0700
Message-ID: <20170901201153.4777-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:52710 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750955AbdIAUMs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Sep 2017 16:12:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Mike Christie <mchristi@redhat.com>

This patch prevents that lockdep reports the following complaint:

======================================================
WARNING: possible circular locking dependency detected
4.12.0-rc1-dbg+ #1 Not tainted
------------------------------------------------------
rmdir/12053 is trying to acquire lock:
 (device_mutex#2){+.+.+.}, at: [<ffffffffa010afce>] target_free_device+0xae/0xf0 [target_core_mod]

but task is already holding lock:
 (&sb->s_type->i_mutex_key#14){++++++}, at: [<ffffffff811c5c30>] vfs_rmdir+0x50/0x140

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (&sb->s_type->i_mutex_key#14){++++++}:
       lock_acquire+0x59/0x80
       down_write+0x36/0x70
       configfs_depend_item+0x3a/0xb0 [configfs]
       target_depend_item+0x13/0x20 [target_core_mod]
       target_xcopy_locate_se_dev_e4_iter+0x87/0x100 [target_core_mod]
       target_devices_idr_iter+0x16/0x20 [target_core_mod]
       idr_for_each+0x39/0xc0
       target_for_each_device+0x36/0x50 [target_core_mod]
       target_xcopy_locate_se_dev_e4+0x28/0x80 [target_core_mod]
       target_xcopy_do_work+0x2e9/0xdd0 [target_core_mod]
       process_one_work+0x1ca/0x3f0
       worker_thread+0x49/0x3b0
       kthread+0x109/0x140
       ret_from_fork+0x31/0x40

-> #0 (device_mutex#2){+.+.+.}:
       __lock_acquire+0x101f/0x11d0
       lock_acquire+0x59/0x80
       __mutex_lock+0x7e/0x950
       mutex_lock_nested+0x16/0x20
       target_free_device+0xae/0xf0 [target_core_mod]
       target_core_dev_release+0x10/0x20 [target_core_mod]
       config_item_put+0x6e/0xb0 [configfs]
       configfs_rmdir+0x1a6/0x300 [configfs]
       vfs_rmdir+0xb7/0x140
       do_rmdir+0x1f4/0x200
       SyS_rmdir+0x11/0x20
       entry_SYSCALL_64_fastpath+0x23/0xc2

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&sb->s_type->i_mutex_key#14);
                               lock(device_mutex#2);
                               lock(&sb->s_type->i_mutex_key#14);
  lock(device_mutex#2);

 *** DEADLOCK ***

3 locks held by rmdir/12053:
 #0:  (sb_writers#10){.+.+.+}, at: [<ffffffff811e223f>] mnt_want_write+0x1f/0x50
 #1:  (&sb->s_type->i_mutex_key#14/1){+.+.+.}, at: [<ffffffff811cb97e>] do_rmdir+0x15e/0x200
 #2:  (&sb->s_type->i_mutex_key#14){++++++}, at: [<ffffffff811c5c30>] vfs_rmdir+0x50/0x140

stack backtrace:
CPU: 3 PID: 12053 Comm: rmdir Not tainted 4.12.0-rc1-dbg+ #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
Call Trace:
 dump_stack+0x86/0xcf
 print_circular_bug+0x1c7/0x220
 __lock_acquire+0x101f/0x11d0
 lock_acquire+0x59/0x80
 __mutex_lock+0x7e/0x950
 mutex_lock_nested+0x16/0x20
 target_free_device+0xae/0xf0 [target_core_mod]
 target_core_dev_release+0x10/0x20 [target_core_mod]
 config_item_put+0x6e/0xb0 [configfs]
 configfs_rmdir+0x1a6/0x300 [configfs]
 vfs_rmdir+0xb7/0x140
 do_rmdir+0x1f4/0x200
 SyS_rmdir+0x11/0x20
 entry_SYSCALL_64_fastpath+0x23/0xc2

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_configfs.c | 18 +++++++++++++++++-
 include/target/target_core_base.h     |  1 +
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 7e87d952bb7a..7d0971789f12 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2251,13 +2251,29 @@ static struct configfs_attribute *target_core_dev_attrs[] = {
 	NULL,
 };
 
+static void target_core_dev_release_work(struct work_struct *release_work)
+{
+	struct se_device *dev =
+		container_of(release_work, struct se_device, release_work);
+
+	target_free_device(dev);
+}
+
 static void target_core_dev_release(struct config_item *item)
 {
 	struct config_group *dev_cg = to_config_group(item);
 	struct se_device *dev =
 		container_of(dev_cg, struct se_device, dev_group);
 
-	target_free_device(dev);
+	/*
+	 * Call target_free_device() asynchronously to avoid lock inversion
+	 * against the configfs_depend_item() call from
+	 * target_xcopy_locate_se_dev_e4_iter(). That call namely occurs with
+	 * device_mutex held. This function is called from inside vfs_rmdir
+	 * and hence is called with i_rwsem held.
+	 */
+	INIT_WORK(&dev->release_work, target_core_dev_release_work);
+	schedule_work(&dev->release_work);
 }
 
 /*
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 516764febeb7..19da905dd2ca 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -793,6 +793,7 @@ struct se_device {
 	struct list_head	dev_tmr_list;
 	struct workqueue_struct *tmr_wq;
 	struct work_struct	qf_work_queue;
+	struct work_struct	release_work;
 	struct list_head	delayed_cmd_list;
 	struct list_head	state_list;
 	struct list_head	qf_cmd_list;
-- 
2.14.1
