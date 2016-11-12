From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 2/2] sd: Fix a deadlock between event checking and device
 removal
Date: Fri, 11 Nov 2016 16:40:53 -0800
Message-ID: <ca9fc384-2e27-2516-8463-a84ecaf793ce@sandisk.com>
References: <a8f0ee8f-7b40-2375-47a4-52f78af29d8d@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0063.outbound.protection.outlook.com ([104.47.40.63]:56312
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S938426AbcKLAlC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Nov 2016 19:41:02 -0500
In-Reply-To: <a8f0ee8f-7b40-2375-47a4-52f78af29d8d@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

If sd_check_events() is called for an sd device on top of a
multipath device without paths then the scsi_test_unit_ready()
call from that function will block until one or more paths
have been added to the multipath device. However, if
scsi_remove_host() is called before a path has been added then
a deadlock is triggered. Fix this deadlock by making the
scsi_test_unit_ready() call from sd_check_events() fail if
there are no paths. SysRq-w reported the following call stacks:

sysrq: SysRq : Show Blocked State
  task                        PC stack   pid father
kworker/6:1     D ffff88046346b958     0    95      2 0x00000000
Workqueue: events_freezable_power_ disk_events_workfn
Call Trace:
 [<ffffffff815acf97>] schedule+0x37/0x90
 [<ffffffff815b1487>] schedule_timeout+0x157/0x230
 [<ffffffff815ac61f>] io_schedule_timeout+0x9f/0x110
 [<ffffffff815adba9>] wait_for_completion_io_timeout+0xd9/0x110
 [<ffffffff812aa9f8>] blk_execute_rq+0xa8/0x130
 [<ffffffff81408411>] scsi_execute+0xf1/0x160
 [<ffffffff8140a484>] scsi_execute_req_flags+0x84/0xf0
 [<ffffffff8140aabd>] scsi_test_unit_ready+0x7d/0x130
 [<ffffffff81416fe6>] sd_check_events+0x116/0x1a0
 [<ffffffff812b477f>] disk_check_events+0x4f/0x130
 [<ffffffff812b4877>] disk_events_workfn+0x17/0x20
 [<ffffffff810737ed>] process_one_work+0x19d/0x490
 [<ffffffff81073b29>] worker_thread+0x49/0x490
 [<ffffffff8107a0ea>] kthread+0xea/0x100
 [<ffffffff815b26ef>] ret_from_fork+0x1f/0x40
kworker/2:16    D ffff88006d9a3af0     0  2575      2 0x00000000
Workqueue: srp_remove srp_remove_work [ib_srp]
Call Trace:
 [<ffffffff815acf97>] schedule+0x37/0x90
 [<ffffffff815ad300>] schedule_preempt_disabled+0x10/0x20
 [<ffffffff815af0b5>] mutex_lock_nested+0x145/0x360
 [<ffffffff812b61ce>] disk_block_events+0x2e/0x80
 [<ffffffff812b62e5>] del_gendisk+0x35/0x1d0
 [<ffffffff81416ae6>] sd_remove+0x56/0xc0
 [<ffffffff813e0812>] __device_release_driver+0x82/0x130
 [<ffffffff813e08e0>] device_release_driver+0x20/0x30
 [<ffffffff813dff33>] bus_remove_device+0x113/0x190
 [<ffffffff813dc5bc>] device_del+0x12c/0x230
 [<ffffffff814113a8>] __scsi_remove_device+0xf8/0x130
 [<ffffffff8140f5d4>] scsi_forget_host+0x64/0x70
 [<ffffffff814033c5>] scsi_remove_host+0x75/0x120
 [<ffffffffa05b5e5b>] srp_remove_work+0x8b/0x1f0 [ib_srp]
 [<ffffffff810737ed>] process_one_work+0x19d/0x490
 [<ffffffff81073b29>] worker_thread+0x49/0x490
 [<ffffffff8107a0ea>] kthread+0xea/0x100
 [<ffffffff815b26ef>] ret_from_fork+0x1f/0x40
multipathd      D ffff88046d91fb40     0  2604      1 0x00000000
Call Trace:
 [<ffffffff815acf97>] schedule+0x37/0x90
 [<ffffffff815ad300>] schedule_preempt_disabled+0x10/0x20
 [<ffffffff815af0b5>] mutex_lock_nested+0x145/0x360
 [<ffffffff812b61ce>] disk_block_events+0x2e/0x80
 [<ffffffff811d8953>] __blkdev_get+0x53/0x480
 [<ffffffff811d8ebb>] blkdev_get+0x13b/0x3a0
 [<ffffffff811d9256>] blkdev_open+0x56/0x70
 [<ffffffff81199a46>] do_dentry_open.isra.17+0x146/0x2d0
 [<ffffffff8119ad58>] vfs_open+0x48/0x70
 [<ffffffff811ab213>] path_openat+0x163/0xa10
 [<ffffffff811aca29>] do_filp_open+0x79/0xd0
 [<ffffffff8119b0a6>] do_sys_open+0x116/0x1f0
 [<ffffffff8119b199>] SyS_open+0x19/0x20
 [<ffffffff815b24a9>] entry_SYSCALL_64_fastpath+0x1c/0xac
systemd-udevd   D ffff880419273968     0 10074    475 0x00000004
Call Trace:
 [<ffffffff815acf97>] schedule+0x37/0x90
 [<ffffffff815b14bb>] schedule_timeout+0x18b/0x230
 [<ffffffff815ae261>] wait_for_completion+0xd1/0x110
 [<ffffffff81073036>] flush_work+0x1d6/0x2a0
 [<ffffffff8107339b>] __cancel_work_timer+0xfb/0x1b0
 [<ffffffff8107346e>] cancel_delayed_work_sync+0xe/0x10
 [<ffffffff812b621e>] disk_block_events+0x7e/0x80
 [<ffffffff811d8953>] __blkdev_get+0x53/0x480
 [<ffffffff811d8ebb>] blkdev_get+0x13b/0x3a0
 [<ffffffff811d9256>] blkdev_open+0x56/0x70
 [<ffffffff81199a46>] do_dentry_open.isra.17+0x146/0x2d0
 [<ffffffff8119ad58>] vfs_open+0x48/0x70
 [<ffffffff811ab213>] path_openat+0x163/0xa10
 [<ffffffff811aca29>] do_filp_open+0x79/0xd0
 [<ffffffff8119b0a6>] do_sys_open+0x116/0x1f0
 [<ffffffff8119b199>] SyS_open+0x19/0x20
 [<ffffffff815b24a9>] entry_SYSCALL_64_fastpath+0x1c/0xac
mount           D ffff8803b42b7be8     0 13567  13442 0x00000000
Call Trace:
 [<ffffffff815acf97>] schedule+0x37/0x90
 [<ffffffff815b14bb>] schedule_timeout+0x18b/0x230
 [<ffffffff815ac61f>] io_schedule_timeout+0x9f/0x110
 [<ffffffff815ad786>] bit_wait_io+0x16/0x60
 [<ffffffff815ad408>] __wait_on_bit+0x58/0x90
 [<ffffffff8111e30f>] wait_on_page_bit_killable+0xbf/0xd0
 [<ffffffff8111e450>] generic_file_read_iter+0x130/0x710
 [<ffffffff811d7970>] blkdev_read_iter+0x30/0x40
 [<ffffffff8119c0e9>] __vfs_read+0xb9/0x120
 [<ffffffff8119c4c0>] vfs_read+0x90/0x130
 [<ffffffff8119d884>] SyS_read+0x44/0xa0
 [<ffffffff815b24a9>] entry_SYSCALL_64_fastpath+0x1c/0xac

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_lib.c    | 17 +++++++++++++----
 drivers/scsi/sd.c          |  6 ++++--
 include/scsi/scsi_device.h |  2 ++
 3 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1febc52..d6bcff0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2390,13 +2390,14 @@ EXPORT_SYMBOL(scsi_mode_sense);
  *	@sshdr_external: Optional pointer to struct scsi_sense_hdr for
  *		returning sense. Make sure that this is cleared before passing
  *		in.
+ *	@flags: or-ed into cmd_flags.
  *
  *	Returns zero if unsuccessful or an error if TUR failed.  For
  *	removable media, UNIT_ATTENTION sets ->changed flag.
  **/
 int
-scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries,
-		     struct scsi_sense_hdr *sshdr_external)
+scsi_test_unit_ready_flags(struct scsi_device *sdev, int timeout, int retries,
+			   struct scsi_sense_hdr *sshdr_external, u64 flags)
 {
 	char cmd[] = {
 		TEST_UNIT_READY, 0, 0, 0, 0, 0,
@@ -2411,8 +2412,8 @@ scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries,
 
 	/* try to eat the UNIT_ATTENTION if there are enough retries */
 	do {
-		result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0, sshdr,
-					  timeout, retries, NULL);
+		result = scsi_execute_req_flags(sdev, cmd, DMA_NONE, NULL, 0,
+					sshdr, timeout, retries, NULL, flags);
 		if (sdev->removable && scsi_sense_valid(sshdr) &&
 		    sshdr->sense_key == UNIT_ATTENTION)
 			sdev->changed = 1;
@@ -2423,6 +2424,14 @@ scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries,
 		kfree(sshdr);
 	return result;
 }
+EXPORT_SYMBOL(scsi_test_unit_ready_flags);
+
+int scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries,
+			 struct scsi_sense_hdr *sshdr_external)
+{
+	return scsi_test_unit_ready_flags(sdev, timeout, retries,
+					  sshdr_external, 0);
+}
 EXPORT_SYMBOL(scsi_test_unit_ready);
 
 /**
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 51e5629..e318811 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1440,8 +1440,10 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 
 	if (scsi_block_when_processing_errors(sdp)) {
 		sshdr  = kzalloc(sizeof(*sshdr), GFP_KERNEL);
-		retval = scsi_test_unit_ready(sdp, SD_TIMEOUT, SD_MAX_RETRIES,
-					      sshdr);
+		retval = scsi_test_unit_ready_flags(sdp, SD_TIMEOUT,
+				SD_MAX_RETRIES, sshdr, REQ_FAIL_IF_NO_PATH);
+		if (retval)
+			pr_info("%s: TUR %#x\n", __func__, retval);
 	}
 
 	/* failed to execute TUR, assume media not present */
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 8a95631..840030a 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -379,6 +379,8 @@ extern int scsi_mode_select(struct scsi_device *sdev, int pf, int sp,
 			    int timeout, int retries,
 			    struct scsi_mode_data *data,
 			    struct scsi_sense_hdr *);
+extern int scsi_test_unit_ready_flags(struct scsi_device *sdev, int timeout,
+			int retries, struct scsi_sense_hdr *sshdr, u64 flags);
 extern int scsi_test_unit_ready(struct scsi_device *sdev, int timeout,
 				int retries, struct scsi_sense_hdr *sshdr);
 extern int scsi_get_vpd_page(struct scsi_device *, u8 page, unsigned char *buf,
-- 
2.10.1

