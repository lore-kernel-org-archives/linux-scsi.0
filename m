From: akpm@google.com
Subject: [patch 4/8] drivers/scsi/sd.c: use ida_simple_get() and ida_simple_remove() in place of boilerplate code
Date: Tue, 20 Sep 2011 14:20:14 -0700
Message-ID: <201109202120.p8KLKE0A011806@hpaq5.eem.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:3210 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab1ITVVM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Sep 2011 17:21:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@google.com, jic23@cam.ac.uk, guenter.roeck@ericsson.com, rusty@rustcorp.com.au, tj@kernel.org

From: Jonathan Cameron <jic23@cam.ac.uk>
Subject: drivers/scsi/sd.c: use ida_simple_get() and ida_simple_remove() in place of boilerplate code

Some mangling of errors was necessary to maintain current interface.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 drivers/scsi/sd.c |   32 ++++++++++----------------------
 1 file changed, 10 insertions(+), 22 deletions(-)

diff -puN drivers/scsi/sd.c~drivers-scsi-sdc-use-ida_simple_get-and-ida_simple_remove-in-place-of-boilerplate-code drivers/scsi/sd.c
--- a/drivers/scsi/sd.c~drivers-scsi-sdc-use-ida_simple_get-and-ida_simple_remove-in-place-of-boilerplate-code
+++ a/drivers/scsi/sd.c
@@ -111,7 +111,6 @@ static void scsi_disk_release(struct dev
 static void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
 static void sd_print_result(struct scsi_disk *, int);
 
-static DEFINE_SPINLOCK(sd_index_lock);
 static DEFINE_IDA(sd_index_ida);
 
 /* This semaphore is used to mediate the 0->1 reference get in the
@@ -2581,22 +2580,15 @@ static int sd_probe(struct device *dev)
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
@@ -2634,9 +2626,7 @@ static int sd_probe(struct device *dev)
 	return 0;
 
  out_free_index:
-	spin_lock(&sd_index_lock);
-	ida_remove(&sd_index_ida, index);
-	spin_unlock(&sd_index_lock);
+	ida_simple_remove(&sd_index_ida, index);
  out_put:
 	put_disk(gd);
  out_free:
@@ -2692,9 +2682,7 @@ static void scsi_disk_release(struct dev
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 	struct gendisk *disk = sdkp->disk;
 	
-	spin_lock(&sd_index_lock);
-	ida_remove(&sd_index_ida, sdkp->index);
-	spin_unlock(&sd_index_lock);
+	ida_simple_remove(&sd_index_ida, sdkp->index);
 
 	disk->private_data = NULL;
 	put_disk(disk);
_
