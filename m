From: Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 4/8] [SCSI] use ida_simple_get and ida_simple remove in place of boilerplate code.
Date: Fri, 22 Jul 2011 17:41:13 +0100
Message-ID: <1311352886-4047-5-git-send-email-jic23@cam.ac.uk>
References: <1311352886-4047-1-git-send-email-jic23@cam.ac.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1311352886-4047-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: lm-sensors@lm-sensors.org, rtc-linux@googlegroups.com, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org, jkosina@suse.cz, naota@elisp.net, rusty@rustcorp.com.au, paulmck@linux.vnet.ibm.com, namhyung@gmail.com, randy.dunlap@oracle.com, tj@kernel.org, cabarnes@indesign-llc.com, akpm@linux-foundation.org, airlied@redhat.com, thellstrom@vmware.com, johnpol@2ka.mipt.ru, JBottomley@parallels.com, bhalevy@panasas.com, bharrosh@panasas.com, a.zummo@towertech.it, guenter.roeck@ericsson.com, khali@linux-fr.org, airlied@linux.ie, Jonathan Cameron <jic23@cam.ac.uk>
List-Id: linux-scsi@vger.kernel.org

Some mangling of errors was necessary to maintain current interface.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/scsi/sd.c |   32 ++++++++++----------------------
 1 files changed, 10 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 953773c..c228b3b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -111,7 +111,6 @@ static void scsi_disk_release(struct device *cdev);
 static void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
 static void sd_print_result(struct scsi_disk *, int);
 
-static DEFINE_SPINLOCK(sd_index_lock);
 static DEFINE_IDA(sd_index_ida);
 
 /* This semaphore is used to mediate the 0->1 reference get in the
@@ -2580,22 +2579,15 @@ static int sd_probe(struct device *dev)
 	if (!gd)
 		goto out_free;
 
-	do {
-		if (!ida_pre_get(&sd_index_ida, GFP_KERNEL))
-			goto out_put;
-
-		spin_lock(&sd_index_lock);
-		error = ida_get_new(&sd_index_ida, &index);
-		spin_unlock(&sd_index_lock);
-	} while (error == -EAGAIN);
-
-	if (error)
+	index = ida_simple_get(&sd_index_ida, 0, SD_MAX_DISKS, GFP_KERNEL);
+	if (index < 0) {
+		error = index;
+		if (error == -ENOSPC) {
+			sdev_printk(KERN_WARNING, sdp,
+				    "SCSI disk (sd) name space exhausted.\n");
+			error = -ENODEV;
+		}
 		goto out_put;
-
-	if (index >= SD_MAX_DISKS) {
-		error = -ENODEV;
-		sdev_printk(KERN_WARNING, sdp, "SCSI disk (sd) name space exhausted.\n");
-		goto out_free_index;
 	}
 
 	error = sd_format_disk_name("sd", index, gd->disk_name, DISK_NAME_LEN);
@@ -2633,9 +2625,7 @@ static int sd_probe(struct device *dev)
 	return 0;
 
  out_free_index:
-	spin_lock(&sd_index_lock);
-	ida_remove(&sd_index_ida, index);
-	spin_unlock(&sd_index_lock);
+	ida_simple_remove(&sd_index_ida, index);
  out_put:
 	put_disk(gd);
  out_free:
@@ -2691,9 +2681,7 @@ static void scsi_disk_release(struct device *dev)
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 	struct gendisk *disk = sdkp->disk;
 	
-	spin_lock(&sd_index_lock);
-	ida_remove(&sd_index_ida, sdkp->index);
-	spin_unlock(&sd_index_lock);
+	ida_simple_remove(&sd_index_ida, sdkp->index);
 
 	disk->private_data = NULL;
 	put_disk(disk);
-- 
1.7.3.4
