From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: sd: block: Handle cases where devices come online read-only
Date: Fri,  8 Feb 2019 18:38:31 -0500
Message-ID: <20190208233831.31377-1-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Jeremy Cline <jeremy@jcline.org>, Oleksii Kurochko <olkuroch@cisco.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Some devices come online in write protected state and switch to
read-write once they are ready to process I/O requests. These devices
broke with commit 20bd1d026aac ("scsi: sd: Keep disk read-only when
re-reading partition") because we have no way to distinguish between a
user decision to set a block_device read-only and the disk being write
protected as a result of the hardware state.

To overcome this we add a third state to the gendisk read-only
policy. This flag is exlusively used when the user forces a struct
block_device read-only via BLKROSET. We currently don't allow
switching ro state in sysfs so the ioctl is the only entry point for
this new state.

In set_disk_ro() we check whether the user override flag is in effect
for a disk before changing read-only state based on the device
settings. This means that devices that have a delay before going
read-write will now be able to clear the read-only state. And devices
where the admin or udev has forced the disk read-only will not cause
the gendisk policy to reflect the mode reported by the device.

Cc: Jeremy Cline <jeremy@jcline.org>
Cc: Oleksii Kurochko <olkuroch@cisco.com>
Cc: stable@vger.kernel.org # v4.16+
Reported-by: Oleksii Kurochko <olkuroch@cisco.com>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=201221
Fixes: 20bd1d026aac ("scsi: sd: Keep disk read-only when re-reading partition")
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

I have verified that get_disk_ro() and bdev_read_only() callers all
handle the additional value correctly. Same is true for "ro" in
sysfs.

Note that per-partition ro settings are lost on revalidate. This has
been broken for at least a decade and it will require major surgery to
fix. To my knowledge nobody has complained about being unable to make
partition read-only settings stick through a revalidate. So hopefully
this patch will suffice as a simple fix for stable.
---
 block/genhd.c         | 13 ++++++++++++-
 block/ioctl.c         |  3 ++-
 drivers/scsi/sd.c     |  4 +---
 include/linux/genhd.h |  6 ++++++
 4 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 1dd8fd6613b8..e29805bfa989 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1549,11 +1549,22 @@ void set_disk_ro(struct gendisk *disk, int flag)
 	struct disk_part_iter piter;
 	struct hd_struct *part;
 
+	/*
+	 * If the user has forced disk read-only with BLKROSET, ignore
+	 * any device state change requested by the driver.
+	 */
+	if (disk->part0.policy == DISK_POLICY_USER_WRITE_PROTECT)
+		return;
 	if (disk->part0.policy != flag) {
 		set_disk_ro_uevent(disk, flag);
 		disk->part0.policy = flag;
 	}
-
+	/*
+	 * If set_disk_ro() is called from revalidate, all partitions
+	 * have already been dropped at this point and thus any
+	 * per-partition user setting lost. Each partition will
+	 * inherit part0 policy when subsequently re-added.
+	 */
 	disk_part_iter_init(&piter, disk, DISK_PITER_INCL_EMPTY);
 	while ((part = disk_part_iter_next(&piter)))
 		part->policy = flag;
diff --git a/block/ioctl.c b/block/ioctl.c
index 4825c78a6baa..16c42e1b18c8 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -451,7 +451,8 @@ static int blkdev_roset(struct block_device *bdev, fmode_t mode,
 		return ret;
 	if (get_user(n, (int __user *)arg))
 		return -EFAULT;
-	set_device_ro(bdev, n);
+	set_device_ro(bdev, n ? DISK_POLICY_USER_WRITE_PROTECT :
+		      DISK_POLICY_WRITABLE);
 	return 0;
 }
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b2da8a00ec33..9aa409b38765 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2591,10 +2591,8 @@ sd_read_write_protect_flag(struct scsi_disk *sdkp, unsigned char *buffer)
 	int res;
 	struct scsi_device *sdp = sdkp->device;
 	struct scsi_mode_data data;
-	int disk_ro = get_disk_ro(sdkp->disk);
 	int old_wp = sdkp->write_prot;
 
-	set_disk_ro(sdkp->disk, 0);
 	if (sdp->skip_ms_page_3f) {
 		sd_first_printk(KERN_NOTICE, sdkp, "Assuming Write Enabled\n");
 		return;
@@ -2632,7 +2630,7 @@ sd_read_write_protect_flag(struct scsi_disk *sdkp, unsigned char *buffer)
 			  "Test WP failed, assume Write Enabled\n");
 	} else {
 		sdkp->write_prot = ((data.device_specific & 0x80) != 0);
-		set_disk_ro(sdkp->disk, sdkp->write_prot || disk_ro);
+		set_disk_ro(sdkp->disk, sdkp->write_prot);
 		if (sdkp->first_scan || old_wp != sdkp->write_prot) {
 			sd_printk(KERN_NOTICE, sdkp, "Write Protect is %s\n",
 				  sdkp->write_prot ? "on" : "off");
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 06c0fd594097..2bef434d4dff 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -150,6 +150,12 @@ enum {
 	DISK_EVENT_EJECT_REQUEST		= 1 << 1, /* eject requested */
 };
 
+enum {
+	DISK_POLICY_WRITABLE			= 0, /* Default */
+	DISK_POLICY_DEVICE_WRITE_PROTECT	= 1, /* Set by device driver */
+	DISK_POLICY_USER_WRITE_PROTECT		= 2, /* Set via BLKROSET */
+};
+
 struct disk_part_tbl {
 	struct rcu_head rcu_head;
 	int len;
-- 
2.19.2
