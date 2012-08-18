From: jeffm@suse.de (Jeff Mahoney)
Subject: [patch 4/5] [PATCH 4/5] st: clean up device file creation and removal
Date: Sat, 18 Aug 2012 15:20:40 -0400
Message-ID: <20120818192044.565011188@suse.com>
References: <20120818192036.751334179@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45114 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415Ab2HRTVv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Aug 2012 15:21:51 -0400
Content-Disposition: inline; filename=st-clean-up-device-file-creation-and-removal
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Kai Makisara <Kai.Makisara@kolumbus.fi>, Lee Duncan <lduncan@suse.com>, Rob Evers <revers@redhat.com>

This patch cleans up the st device file creation and removal.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 drivers/scsi/st.c |  195 ++++++++++++++++++++++++------------------------------
 drivers/scsi/st.h |    1 
 2 files changed, 91 insertions(+), 105 deletions(-)

--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -193,7 +193,6 @@ static int st_remove(struct device *);
 
 static int do_create_sysfs_files(void);
 static void do_remove_sysfs_files(void);
-static int do_create_class_files(struct scsi_tape *, int, int);
 
 static struct scsi_driver st_template = {
 	.owner			= THIS_MODULE,
@@ -3990,16 +3989,98 @@ static const struct file_operations st_f
 	.llseek =	noop_llseek,
 };
 
+static int create_one_cdev(struct scsi_tape *tape, int mode, int rew)
+{
+	int i, error;
+	dev_t cdev_devno;
+	struct cdev *cdev;
+	struct device *dev;
+	struct st_modedef *STm = &(tape->modes[mode]);
+	char name[10];
+	int dev_num = tape->index;
+
+	cdev_devno = MKDEV(SCSI_TAPE_MAJOR, TAPE_MINOR(dev_num, mode, rew));
+
+	cdev = cdev_alloc();
+	if (!cdev) {
+		pr_err("st%d: out of memory. Device not attached.\n", dev_num);
+		error = -ENOMEM;
+		goto out;
+	}
+	cdev->owner = THIS_MODULE;
+	cdev->ops = &st_fops;
+
+	error = cdev_add(cdev, cdev_devno, 1);
+	if (error) {
+		pr_err("st%d: Can't add %s-rewind mode %d\n", dev_num,
+		       rew ? "non" : "auto", mode);
+		pr_err("st%d: Device not attached.\n", dev_num);
+		goto out_free;
+	}
+	STm->cdevs[rew] = cdev;
+
+	i = mode << (4 - ST_NBR_MODE_BITS);
+	snprintf(name, 10, "%s%s%s", rew ? "n" : "",
+		 tape->disk->disk_name, st_formats[i]);
+
+	dev = device_create(&st_sysfs_class, &tape->device->sdev_gendev,
+			    cdev_devno, &tape->modes[mode], "%s", name);
+	if (IS_ERR(dev)) {
+		pr_err("st%d: device_create failed\n", dev_num);
+		error = PTR_ERR(dev);
+		goto out_free;
+	}
+
+	STm->devs[rew] = dev;
+
+	return 0;
+out_free:
+	cdev_del(STm->cdevs[rew]);
+	STm->cdevs[rew] = NULL;
+out:
+	return error;
+}
+
+static int create_cdevs(struct scsi_tape *tape)
+{
+	int mode, error;
+	for (mode = 0; mode < ST_NBR_MODES; ++mode) {
+		error = create_one_cdev(tape, mode, 0);
+		if (error)
+			return error;
+		error = create_one_cdev(tape, mode, 1);
+		if (error)
+			return error;
+	}
+
+	return sysfs_create_link(&tape->device->sdev_gendev.kobj,
+				 &tape->modes[0].devs[0]->kobj, "tape");
+}
+
+static void remove_cdevs(struct scsi_tape *tape)
+{
+	int mode, rew;
+	sysfs_remove_link(&tape->device->sdev_gendev.kobj, "tape");
+	for (mode = 0; mode < ST_NBR_MODES; mode++) {
+		struct st_modedef *STm = &(tape->modes[mode]);
+		for (rew = 0; rew < 2; rew++) {
+			if (STm->cdevs[rew])
+				cdev_del(STm->cdevs[rew]);
+			if (STm->devs[rew])
+				device_unregister(STm->devs[rew]);
+		}
+	}
+}
+
 static int st_probe(struct device *dev)
 {
 	struct scsi_device *SDp = to_scsi_device(dev);
 	struct gendisk *disk = NULL;
-	struct cdev *cdev = NULL;
 	struct scsi_tape *tpnt = NULL;
 	struct st_modedef *STm;
 	struct st_partstat *STps;
 	struct st_buffer *buffer;
-	int i, j, mode, dev_num, error;
+	int i, dev_num, error;
 	char *stp;
 
 	if (SDp->type != TYPE_TAPE)
@@ -4125,36 +4206,10 @@ static int st_probe(struct device *dev)
 
 	dev_set_drvdata(dev, tpnt);
 
-	for (mode = 0; mode < ST_NBR_MODES; ++mode) {
-		STm = &(tpnt->modes[mode]);
-		for (j=0; j < 2; j++) {
-			cdev = cdev_alloc();
-			if (!cdev) {
-				printk(KERN_ERR
-				       "st%d: out of memory. Device not attached.\n",
-				       dev_num);
-				cdev_del(cdev);
-				goto out_free_tape;
-			}
-			cdev->owner = THIS_MODULE;
-			cdev->ops = &st_fops;
 
-			error = cdev_add(cdev,
-					 MKDEV(SCSI_TAPE_MAJOR, TAPE_MINOR(dev_num, mode, j)),
-					 1);
-			if (error) {
-				printk(KERN_ERR "st%d: Can't add %s-rewind mode %d\n",
-				       dev_num, j ? "non" : "auto", mode);
-				printk(KERN_ERR "st%d: Device not attached.\n", dev_num);
-				goto out_free_tape;
-			}
-			STm->cdevs[j] = cdev;
-
-		}
-		error = do_create_class_files(tpnt, dev_num, mode);
-		if (error)
-			goto out_free_tape;
-	}
+	error = create_cdevs(tpnt);
+	if (error)
+		goto out_remove_devs;
 	scsi_autopm_put_device(SDp);
 
 	sdev_printk(KERN_NOTICE, SDp,
@@ -4165,20 +4220,8 @@ static int st_probe(struct device *dev)
 
 	return 0;
 
-out_free_tape:
-	sysfs_remove_link(&tpnt->device->sdev_gendev.kobj,
-			  "tape");
-	for (mode=0; mode < ST_NBR_MODES; mode++) {
-		STm = &(tpnt->modes[mode]);
-		for (j=0; j < 2; j++) {
-			if (STm->cdevs[j]) {
-				device_destroy(&st_sysfs_class,
-					       MKDEV(SCSI_TAPE_MAJOR,
-						     TAPE_MINOR(i, mode, j)));
-				cdev_del(STm->cdevs[j]);
-			}
-		}
-	}
+out_remove_devs:
+	remove_cdevs(tpnt);
 out_put_index:
 	spin_lock(&st_index_lock);
 	idr_remove(&st_index_idr, dev_num);
@@ -4196,24 +4239,10 @@ out:
 static int st_remove(struct device *dev)
 {
 	struct scsi_tape *tpnt = dev_get_drvdata(dev);
-	int rew, mode;
-	dev_t cdev_devno;
-	struct cdev *cdev;
 	int index = tpnt->index;
 
 	scsi_autopm_get_device(to_scsi_device(dev));
-	sysfs_remove_link(&tpnt->device->sdev_gendev.kobj, "tape");
-	for (mode = 0; mode < ST_NBR_MODES; ++mode) {
-		for (rew = 0; rew < 2; rew++) {
-			cdev = tpnt->modes[mode].cdevs[rew];
-			if (!cdev)
-				continue;
-			cdev_devno = cdev->dev;
-			device_destroy(&st_sysfs_class, cdev_devno);
-			cdev_del(tpnt->modes[mode].cdevs[rew]);
-			tpnt->modes[mode].cdevs[rew] = NULL;
-		}
-	}
+	remove_cdevs(tpnt);
 
 	mutex_lock(&st_ref_mutex);
 	kref_put(&tpnt->kref, scsi_tape_release);
@@ -4462,50 +4491,6 @@ static struct device_attribute st_dev_at
 	__ATTR_NULL,
 };
 
-static int do_create_class_files(struct scsi_tape *STp, int dev_num, int mode)
-{
-	int i, rew, error;
-	char name[10];
-	struct device *st_class_member;
-
-	for (rew=0; rew < 2; rew++) {
-		/* Make sure that the minor numbers corresponding to the four
-		   first modes always get the same names */
-		i = mode << (4 - ST_NBR_MODE_BITS);
-		snprintf(name, 10, "%s%s%s", rew ? "n" : "",
-			 STp->disk->disk_name, st_formats[i]);
-		st_class_member =
-			device_create(&st_sysfs_class,
-				      &STp->device->sdev_gendev,
-				      MKDEV(SCSI_TAPE_MAJOR,
-					    TAPE_MINOR(dev_num, mode, rew)),
-				      &STp->modes[mode], "%s", name);
-		if (IS_ERR(st_class_member)) {
-			printk(KERN_WARNING "st%d: device_create failed\n",
-			       dev_num);
-			error = PTR_ERR(st_class_member);
-			goto out;
-		}
-
-		if (mode == 0 && rew == 0) {
-			error = sysfs_create_link(&STp->device->sdev_gendev.kobj,
-						  &st_class_member->kobj,
-						  "tape");
-			if (error) {
-				printk(KERN_ERR
-				       "st%d: Can't create sysfs link from SCSI device.\n",
-				       dev_num);
-				goto out;
-			}
-		}
-	}
-
-	return 0;
-
-out:
-	return error;
-}
-
 /* The following functions may be useful for a larger audience. */
 static int sgl_map_user_pages(struct st_buffer *STbp,
 			      const unsigned int max_pages, unsigned long uaddr,
--- a/drivers/scsi/st.h
+++ b/drivers/scsi/st.h
@@ -67,6 +67,7 @@ struct st_modedef {
 	short default_density;	/* Forced density, -1 = no value */
 	int default_blksize;	/* Forced blocksize, -1 = no value */
 	struct scsi_tape *tape;
+	struct device *devs[2];  /* Auto-rewind and non-rewind devices */
 	struct cdev *cdevs[2];  /* Auto-rewind and non-rewind devices */
 };
 


