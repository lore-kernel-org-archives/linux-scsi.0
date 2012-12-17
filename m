From: David Milburn <dmilburn@redhat.com>
Subject: [PATCH] scsi: remove device when state is changed to deleted thru sysfs
Date: Mon, 17 Dec 2012 17:26:52 -0600
Message-ID: <1355786812-17908-1-git-send-email-dmilburn@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416Ab2LQXUp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Dec 2012 18:20:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com

Changing device state to "deleted" through /sys doesn't really delete 
the device, and rescan of the bus can fail. This linux-3.7 patch would insure
sdev_store_delete_callback would remove the device similiar to the path 
taken when "echo 1 > /sys/block/sdd/device/delete" is used, this would
allow subsequent rescan to successfully add the device back.

# modprobe scsi_debug
# echo "deleted" > /sys/block/sdd/device/state
# echo "- - -" > /sys/class/scsi_host/host10/scan

scsi 10:0:0:0: Direct-Access     Linux    scsi_debug       0004 PQ: 0 ANSI: 5
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:536 sysfs_add_one+0xbb/0xe0()
Hardware name: 2012 Client Platform
sysfs: cannot create duplicate filename '/devices/pseudo_0/adapter0/host10/target10:0:0/10:0:0:0'
------------[ cut here ]------------
Call Trace:
 [<ffffffff8105557f>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff81055676>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff81269fe9>] ? strlcat+0x69/0x80
 [<ffffffff811eea4b>] sysfs_add_one+0xbb/0xe0
 [<ffffffff811eebd2>] create_dir+0x82/0xe0
 [<ffffffff811eecba>] sysfs_create_dir+0x8a/0xf0
 [<ffffffff8126423f>] kobject_add_internal+0x9f/0x260
 [<ffffffff812645b8>] kobject_add_varg+0x38/0x60
 [<ffffffff81264694>] kobject_add+0x44/0x70
 [<ffffffff8135e584>] device_add+0xd4/0x560
 [<ffffffff8136d39c>] ? __pm_runtime_resume+0x6c/0x90
 [<ffffffff8138dd13>] scsi_sysfs_add_sdev+0xb3/0x340
 [<ffffffff8138aa98>] scsi_add_lun+0x418/0x520
 [<ffffffff8138b09d>] scsi_probe_and_add_lun+0x20d/0x500
 [<ffffffff8138befe>] __scsi_scan_target+0xde/0x210
 [<ffffffff8138c0b7>] scsi_scan_channel+0x87/0xb0
 [<ffffffff8138c1c9>] scsi_scan_host_selected+0xe9/0x1a0
 [<ffffffff8138d161>] scsi_scan+0xf1/0x100
 [<ffffffff81164613>] ? alloc_pages_current+0xe3/0x1c0
 [<ffffffff8138d190>] store_scan+0x20/0x30
 [<ffffffff8135c240>] dev_attr_store+0x20/0x30
 [<ffffffff811ecdff>] sysfs_write_file+0xef/0x170
 [<ffffffff8117a9d8>] vfs_write+0xc8/0x190
 [<ffffffff8117b20f>] sys_write+0x5f/0xa0
 [<ffffffff81546119>] system_call_fastpath+0x16/0x1b
---[ end trace d8c5fd627d86780b ]---
------------[ cut here ]------------
WARNING: at lib/kobject.c:196 kobject_add_internal+0x204/0x260()
------------[ cut here ]------------
Call Trace:
 [<ffffffff8105557f>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff81055676>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff812643a4>] kobject_add_internal+0x204/0x260
 [<ffffffff812645b8>] kobject_add_varg+0x38/0x60
 [<ffffffff81264694>] kobject_add+0x44/0x70
 [<ffffffff8135e584>] device_add+0xd4/0x560
 [<ffffffff8136d39c>] ? __pm_runtime_resume+0x6c/0x90
 [<ffffffff8138dd13>] scsi_sysfs_add_sdev+0xb3/0x340
 [<ffffffff8138aa98>] scsi_add_lun+0x418/0x520
 [<ffffffff8138b09d>] scsi_probe_and_add_lun+0x20d/0x500
 [<ffffffff8138befe>] __scsi_scan_target+0xde/0x210
 [<ffffffff8138c0b7>] scsi_scan_channel+0x87/0xb0
 [<ffffffff8138c1c9>] scsi_scan_host_selected+0xe9/0x1a0
 [<ffffffff8138d161>] scsi_scan+0xf1/0x100
 [<ffffffff81164613>] ? alloc_pages_current+0xe3/0x1c0
 [<ffffffff8138d190>] store_scan+0x20/0x30
 [<ffffffff8135c240>] dev_attr_store+0x20/0x30
 [<ffffffff811ecdff>] sysfs_write_file+0xef/0x170
 [<ffffffff8117a9d8>] vfs_write+0xc8/0x190
 [<ffffffff8117b20f>] sys_write+0x5f/0xa0
 [<ffffffff81546119>] system_call_fastpath+0x16/0x1b
---[ end trace d8c5fd627d86780c ]---
scsi 10:0:0:0: failed to add device: -17

Signed-off-by: David Milburn <dmilburn@redhat.com>
---
 drivers/scsi/scsi_sysfs.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index ce5224c..6d72abb 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -596,7 +596,7 @@ static ssize_t
 store_state_field(struct device *dev, struct device_attribute *attr,
 		  const char *buf, size_t count)
 {
-	int i;
+	int i, rc;
 	struct scsi_device *sdev = to_scsi_device(dev);
 	enum scsi_device_state state = 0;
 
@@ -611,7 +611,11 @@ store_state_field(struct device *dev, struct device_attribute *attr,
 	if (!state)
 		return -EINVAL;
 
-	if (scsi_device_set_state(sdev, state))
+	if (state == SDEV_DEL) {
+		rc = device_schedule_callback(dev, sdev_store_delete_callback);
+		if (rc)
+			count = rc;
+	} else if (scsi_device_set_state(sdev, state))
 		return -EINVAL;
 	return count;
 }
