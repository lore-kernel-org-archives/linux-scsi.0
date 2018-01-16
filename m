From: "zhenwei.pi" <zhenwei.pi@youruncloud.com>
Subject: [PATCH] scsi_sysfs: fix list entry double-deletion
Date: Tue, 16 Jan 2018 14:10:50 +0800
Message-ID: <1516083050-11323-1-git-send-email-zhenwei.pi@youruncloud.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out3140-54.mail.aliyun.com ([42.120.140.54]:15553 "EHLO
        out3140-54.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750846AbeAPGLH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 16 Jan 2018 01:11:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: zhenwei.pi@youruncloud.com

Test iscsi performance in unstable network. And hit kernel die.
Here are two different call trace, but they have the same RIP & RCX.
1>
CPU: 15 PID: 23529 Comm: lvm Tainted: G      D W   E 4.14.11 #1
task: ffff91a382b72e00 task.stack: ffffb3928ade8000
RIP: 0010:scsi_device_dev_release_usercontext+0x58/0x200
RSP: 0018:ffffb3928adebb48 EFLAGS: 00010046
RAX: 0000000000000246 RBX: ffff9lad99f95738 RCX: dead000000000100
RDX: dead000000000200 RSI: dead000000000100 RDI: ffff91a3a2e5a030
RBP: ffff9lad99f95138 ROB: 0000000000000101 R09: 00000001810000fe
R10: ffffb3928adebb10 R11: 0000000000000000 R12: ffff9lad99f95000
R13: ffff9lac2614b028 R14: ffffffff91328320 R15: ffff9lacef5e3e98
FS: 00007f1ca63c9840(0000) GS:ffff9lad9f3c0000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CRO: 0000000080050033
CR2:000000c42027d000 CR3:0000000cb5e06002 CR4:00000000003626e0
DRO:0000000000000000 DR1:0000000000000000 DR2:0000000000000000
DR3:0000000000000000 DR6:00000000fffeOff0 DR7:0000000000000400
CallTrace:
table_load+0x360/0x360
execute_in_process_context+0x58/0x60
device_release+Ox2d/0x80
kobject_put+Ox7f/Ox1a0
scsi_disk_put+Ox2b/Ox40
__blkdev_put+Ox19e/Ox1f0
table_load+0x360/0x360
disk_flush_events+0x24/0x60
table_load+0x360/0x360
dm_put_table_device+Ox51/OxbO
dm_put_device+0x75/OxbO
table_load+0x360/0x360
linear_dtr+0x12/0x20
dm_table_destroy+0x66/0x110
table_load+0x360/0x360
dev_suspend+Oxde/0x250
ctl_ioctl+0x1c0/0x480
dm_ctl_ioctl+Oxa/Ox10
do_vfs_ioctl+0x9f/Ox5f0
Sys_ioctl+0x74/0x80

2>
CPU: 25 PIO: 2084 Comm: kworker/u64:6 Tainted: G      W   E 4.14.11 #1
WorkqueLm: scsi_wq_18 __iscsi_unbind_session [scsi_transport_iscsi]
task: ffff91255ed74500 task.stack: ffffad74c97cc000
RIP: 0010:scsi_device_dev_release_usercontext.0x58/0x200
RSP: 0018:f f f fad74c97cfd80 EFLAGS: 00010046
PAX: 0000000000000246  RBX: ffff912695682f38 RCX: dead000000000100
BOX: dead000000000200  RSI: dead000000000100 ROI: ffff9125e9529030
RBP: ffff912695682938  R08: 00000000ffffffff R09: ffff9126967b5220
R10: 000000000000029f  R11: 0000000000000000 R12: ffff912695682800
R13: ffff911f4faef028  R14: ffff912695682800 R15: ffff9125e9529010
FS: 0000000000000000(0000) GS:ffff91269f440000(0000) knIGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CRO: 0000000080050033
CR2: 00007f90027ef020 CR3: 00000002e640a006 CR4: 00000000003626e0
Call Trace:
execute_in_process_context.0x58/0x60
device_release.0x2d/Ox80
kobject_put.0x7f/Ox1a0
scsi_remoue_target.0x171/0x1b0
__iscsi_unbind_session.0x63/0x160 [scsi_transport_iscsi]
process_one_work.0x151/0x3f0
worker_thread.0x4a/Ox440
kthread.Oxfc/Ox130
process_one_work.0x3f0/0x3f0
kthread_create_on_node.0x70/0x70
do_group_exit.0x3a/Oxa0
ret_from_fork.0x1f/Ox30

Both call trace die in the same IP (call list_del(&sdev->siblings)),
and RCX: dead000000000100 means list entry has been deleted.
So, before calling list_del, check list item is empty or not.

Signed-off-by: zhenwei.pi <zhenwei.pi@youruncloud.com>
---
 drivers/scsi/scsi_sysfs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 26ce1717..92463bb 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -439,7 +439,11 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	parent = sdev->sdev_gendev.parent;
 
 	spin_lock_irqsave(sdev->host->host_lock, flags);
-	list_del(&sdev->siblings);
+	if (list_empty(&sdev->siblings)) {
+		spin_unlock_irqrestore(sdev->host->host_lock, flags);
+		return;
+	}
+	list_del_init(&sdev->siblings);
 	list_del(&sdev->same_target_siblings);
 	list_del(&sdev->starved_entry);
 	spin_unlock_irqrestore(sdev->host->host_lock, flags);
-- 
2.7.4
