From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 16 of 16] Add support for data integrity to MD
Date: Fri, 25 Apr 2008 19:12:18 -0400
Message-ID: <927db99c5b35d00d7f09.1209165138@sermon.lab.mkp.net>
References: <patchbomb.1209165122@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:44322 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761169AbYDYXRa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2008 19:17:30 -0400
In-Reply-To: <patchbomb.1209165122@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

1 file changed, 28 insertions(+), 1 deletion(-)
drivers/md/md.c |   29 ++++++++++++++++++++++++++++-


If all subdevices support the same protection format the MD device is
flagged as capable.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff -r 49afddbc7220 -r 927db99c5b35 drivers/md/md.c
--- a/drivers/md/md.c	Fri Apr 25 17:39:29 2008 -0400
+++ b/drivers/md/md.c	Fri Apr 25 17:39:29 2008 -0400
@@ -3284,7 +3284,7 @@
 	int err;
 	int chunk_size;
 	struct list_head *tmp;
-	mdk_rdev_t *rdev;
+	mdk_rdev_t *rdev, *prev;
 	struct gendisk *disk;
 	struct mdk_personality *pers;
 	char b[BDEVNAME_SIZE];
@@ -3541,6 +3541,32 @@
 	mddev->changed = 1;
 	md_new_event(mddev);
 	kobject_uevent(&mddev->gendisk->dev.kobj, KOBJ_CHANGE);
+
+	prev = NULL;
+
+	/* Data Integrity */
+	rdev_for_each(rdev, tmp, mddev) {
+
+		if (prev && blk_integrity_compare(prev->bdev, rdev->bdev) < 0) {
+			printk(KERN_ERR "%s: %s %s Integrity mismatch!\n",
+			       __func__, prev->bdev->bd_disk->disk_name,
+			       rdev->bdev->bd_disk->disk_name);
+			return 0;
+		}
+
+		prev = rdev;
+	}
+
+	if (prev && bdev_get_integrity(prev->bdev)) {
+
+		if (blk_integrity_register(disk, prev->bdev->bd_disk->integrity))
+			printk(KERN_ERR "%s: %s Could not register integrity!\n",
+			       __func__, disk->disk_name);
+		else
+			printk(KERN_INFO "Enabling data integrity on %s\n",
+			       disk->disk_name);
+	}
+
 	return 0;
 }
 
@@ -3716,6 +3742,7 @@
 		printk(KERN_INFO "md: %s switched to read-only mode.\n",
 			mdname(mddev));
 	err = 0;
+	blk_integrity_unregister(disk);
 	md_new_event(mddev);
 out:
 	return err;


