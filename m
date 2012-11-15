From: Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] scsi: prevent stack buffer overflow in host_reset
Date: Thu, 15 Nov 2012 15:51:46 -0500
Message-ID: <1353012706-28182-1-git-send-email-sasha.levin@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
List-Id: linux-scsi@vger.kernel.org

store_host_reset() has tried to re-invent the wheel to compare sysfs strings.
Unfortunately it did so poorly and never bothered to check the input from
userspace before overwriting stack with it, so something simple as:

echo "WoopsieWoopsie" >
/sys/devices/pseudo_0/adapter0/host0/scsi_host/host0/host_reset

would result in:

[  316.310101] Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: ffffffff81f5bac7
[  316.310101]
[  316.320051] Pid: 6655, comm: sh Tainted: G        W    3.7.0-rc5-next-20121114-sasha-00016-g5c9d68d-dirty #129
[  316.320051] Call Trace:
[  316.340058] pps pps0: PPS event at 1352918752.620355751
[  316.340062] pps pps0: capture assert seq #303
[  316.320051]  [<ffffffff83b3856b>] panic+0xcd/0x1f4
[  316.320051]  [<ffffffff81f5bac7>] ? store_host_reset+0xd7/0x100
[  316.320051]  [<ffffffff8110b996>] __stack_chk_fail+0x16/0x20
[  316.320051]  [<ffffffff81f5bac7>] store_host_reset+0xd7/0x100
[  316.320051]  [<ffffffff81e55bb3>] dev_attr_store+0x13/0x30
[  316.320051]  [<ffffffff812f7db1>] sysfs_write_file+0x101/0x170
[  316.320051]  [<ffffffff8127acc8>] vfs_write+0xb8/0x180
[  316.320051]  [<ffffffff8127ae80>] sys_write+0x50/0xa0
[  316.320051]  [<ffffffff83c03418>] tracesys+0xe1/0xe6

Fix this by uninventing whatever was going on there and just use sysfs_streq.

Bug introduced by 29443691 ("[SCSI] scsi: Added support for adapter and
firmware reset").

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 drivers/scsi/scsi_sysfs.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index ce5224c..77ba946 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -249,9 +249,9 @@ static DEVICE_ATTR(active_mode, S_IRUGO | S_IWUSR, show_shost_active_mode, NULL)
 
 static int check_reset_type(char *str)
 {
-	if (strncmp(str, "adapter", 10) == 0)
+	if (sysfs_streq(str, "adapter"))
 		return SCSI_ADAPTER_RESET;
-	else if (strncmp(str, "firmware", 10) == 0)
+	else if (sysfs_streq(str, "firmware"))
 		return SCSI_FIRMWARE_RESET;
 	else
 		return 0;
@@ -264,12 +264,9 @@ store_host_reset(struct device *dev, struct device_attribute *attr,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct scsi_host_template *sht = shost->hostt;
 	int ret = -EINVAL;
-	char str[10];
 	int type;
 
-	sscanf(buf, "%s", str);
-	type = check_reset_type(str);
-
+	type = check_reset_type(buf);
 	if (!type)
 		goto exit_store_host_reset;
 
-- 
1.8.0
