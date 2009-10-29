From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 4/5] osduld: Use device->release instead of internal kref
Date: Thu, 29 Oct 2009 19:50:35 +0200
Message-ID: <4AE9D5EB.7080202@panasas.com>
References: <4AE5D374.80400@panasas.com>	 <1256576294-10430-1-git-send-email-bharrosh@panasas.com>	 <1256836303.7191.21.camel@mulgrave.site>  <4AE9CFC6.2080404@panasas.com> <1256838073.7191.24.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dip-colo-pa.panasas.com ([67.152.220.67]:40073 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755656AbZJ2Ruc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2009 13:50:32 -0400
In-Reply-To: <1256838073.7191.24.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>

Some thing like below. 

There is to much knolage of device in my opinion. To much fidling
of private device members. What when some new members are added?

I hate it.

(compile tested only)
---
git diff --stat -p drivers/scsi/osd/osd_uld.c
 drivers/scsi/osd/osd_uld.c |   35 ++++++++++++++++++-----------------
 1 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
index 25ef993..5f308be 100644
--- a/drivers/scsi/osd/osd_uld.c
+++ b/drivers/scsi/osd/osd_uld.c
@@ -87,7 +87,7 @@ struct osd_uld_device {
 	struct osd_dev od;
 	struct osd_dev_info odi;
 	struct gendisk *disk;
-	struct device *class_member;
+	struct device class_dev;
 	typeof(((struct device *)NULL)->release) save_release;
 };
 
@@ -316,7 +316,7 @@ void osduld_put_device(struct osd_dev *od)
 		if (odh->file)
 			fput(odh->file);
 		else
-			put_device(oud->class_member);
+			put_device(&oud->class_dev);
 		__uld_put(oud);
 		kfree(odh);
 	}
@@ -378,7 +378,6 @@ static void __remove(struct device *dev)
 	struct scsi_device *scsi_device = oud->od.scsi_device;
 
 	kfree(oud->odi.osdname);
-	oud->save_release(oud->class_member);
 
 	if (oud->cdev.owner)
 		cdev_del(&oud->cdev);
@@ -464,16 +463,20 @@ static int osd_probe(struct device *dev)
 		goto err_put_disk;
 	}
 
-	/* class_member */
-	oud->class_member = device_create(&osd_uld_class, dev,
-		MKDEV(SCSI_OSD_MAJOR, oud->minor), oud, disk->disk_name);
-	if (IS_ERR(oud->class_member)) {
-		OSD_ERR("class_device_create failed\n");
-		error = PTR_ERR(oud->class_member);
+	/* class device member */
+	oud->class_dev.devt = MKDEV(SCSI_OSD_MAJOR, oud->minor);
+	oud->class_dev.class = &osd_uld_class;
+	oud->class_dev.parent = dev;
+	oud->class_dev.release = __remove;
+	dev_set_drvdata(&oud->class_dev, oud);
+
+	error = kobject_set_name(&oud->class_dev.kobj, disk->disk_name);
+	if (error)
+		goto err_put_cdev;
+
+	error = device_register(&oud->class_dev);
+	if (error)
 		goto err_put_cdev;
-	}
-	oud->save_release = oud->class_member->release;
-	oud->class_member->release = __remove;
 
 	__uld_get(oud);
 
@@ -504,9 +507,7 @@ static int osd_remove(struct device *dev)
 			scsi_device);
 	}
 
-	if (oud->class_member)
-		device_destroy(&osd_uld_class,
-			       MKDEV(SCSI_OSD_MAJOR, oud->minor));
+	device_unregister(&oud->class_dev);
 
 	__uld_put(oud);
 	return 0;
@@ -514,12 +515,12 @@ static int osd_remove(struct device *dev)
 
 static void __uld_get(struct osd_uld_device *oud)
 {
-	get_device(oud->class_member);
+	get_device(&oud->class_dev);
 }
 
 static void __uld_put(struct osd_uld_device *oud)
 {
-	put_device(oud->class_member);
+	put_device(&oud->class_dev);
 }
 
 /*



