From: Jeremy Cline <jeremy@jcline.org>
Subject: [PATCH] scsi: sd: Keep disk read-only when re-reading partition
Date: Thu, 1 Mar 2018 14:08:10 +0000
Message-ID: <01000161e1e448a5-d54e05d2-58f2-4480-b05b-67185d4ffae7-000000@email.amazonses.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jeremy Cline <jeremy@jcline.org>
List-Id: linux-scsi@vger.kernel.org

If the read-only flag is true on a SCSI disk, re-reading the partition
table sets the flag back to false.

To observe this bug, you can run:

1. blockdev --setro /dev/sda
2. blockdev --rereadpt /dev/sda
3. blockdev --getro /dev/sda

This commit reads the disk's old state and combines it with the device
disk-reported state rather than unconditionally marking it as RW.

Reported-by: Li Ning <lining916740672@icloud.com>
Signed-off-by: Jeremy Cline <jeremy@jcline.org>
---
 drivers/scsi/sd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index bff21e636ddd..7a3a66a7890f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2595,6 +2595,7 @@ sd_read_write_protect_flag(struct scsi_disk *sdkp, unsigned char *buffer)
 	int res;
 	struct scsi_device *sdp = sdkp->device;
 	struct scsi_mode_data data;
+	int disk_ro = get_disk_ro(sdkp->disk);
 	int old_wp = sdkp->write_prot;
 
 	set_disk_ro(sdkp->disk, 0);
@@ -2634,7 +2635,8 @@ sd_read_write_protect_flag(struct scsi_disk *sdkp, unsigned char *buffer)
 		sd_first_printk(KERN_WARNING, sdkp,
 			  "Test WP failed, assume Write Enabled\n");
 	} else {
-		sdkp->write_prot = ((data.device_specific & 0x80) != 0);
+		sdkp->write_prot = ((data.device_specific & 0x80) != 0) ||
+			disk_ro;
 		set_disk_ro(sdkp->disk, sdkp->write_prot);
 		if (sdkp->first_scan || old_wp != sdkp->write_prot) {
 			sd_printk(KERN_NOTICE, sdkp, "Write Protect is %s\n",
-- 
2.16.2
