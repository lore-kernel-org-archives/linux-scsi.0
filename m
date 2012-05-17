From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH v2 4/5] st: clean up device file creation and removal
Date: Thu, 17 May 2012 14:21:31 -0700
Message-ID: <4FB56BDB.9030309@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kai.makisara@kolumbus.fi, jeffm@suse.com
List-Id: linux-scsi@vger.kernel.org

From: Jeff Mahoney <jeffm@suse.com>

This patch cleans up the st device file creation and removal.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/st.c |  197 +++++++++++++++++++++++++----------------------------
 1 file changed, 91 insertions(+), 106 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 9c2c9d9..98dbae5 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -193,7 +193,6 @@ static int st_remove(struct device *);
 
 static int do_create_sysfs_files(void);
 static void do_remove_sysfs_files(void);
-static int do_create_class_files(struct scsi_tape *, int, int);
 
 static struct scsi_driver st_template = {
 	.owner			= THIS_MODULE,
@@ -3990,16 +3989,99 @@ static const struct file_operations st_fops =
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
+		printk(KERN_ERR "st%d: out of memory. Device not attached.\n",
+		       dev_num);
+		error = -ENOMEM;
+		goto out;
+	}
+	cdev->owner = THIS_MODULE;
+	cdev->ops = &st_fops;
+
+	error = cdev_add(cdev, cdev_devno, 1);
+	if (error) {
+		printk(KERN_ERR "st%d: Can't add %s-rewind mode %d\n",
+		       dev_num, rew ? "non" : "auto", mode);
+		printk(KERN_ERR "st%d: Device not attached.\n", dev_num);
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
+		printk(KERN_WARNING "st%d: device_create failed\n", dev_num);
+		error = PTR_ERR(dev);
+		goto out_free;
+	}
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
+	error = sysfs_create_link(&tape->device->sdev_gendev.kobj,
+				  &tape->modes[0].cdevs[0]->kobj, "tape");
+	return 0;
+}
+
+static void remove_cdevs(struct scsi_tape *tape)
+{
+	int mode, rew;
+	sysfs_remove_link(&tape->device->sdev_gendev.kobj, "tape");
+	for (mode=0; mode < ST_NBR_MODES; mode++) {
+		struct st_modedef *STm = &(tape->modes[mode]);
+		for (rew=0; rew < 2; rew++) {
+			if (STm->cdevs[rew]) {
+				dev_t devno = STm->cdevs[rew]->dev;
+				device_destroy(&st_sysfs_class, devno);
+				cdev_del(STm->cdevs[rew]);
+			}
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
@@ -4126,36 +4208,9 @@ static int st_probe(struct device *dev)
 
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
-
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
@@ -4166,20 +4221,8 @@ static int st_probe(struct device *dev)
 
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
 	idr_remove(&st_index_idr, dev_num);
 out_put_disk:
@@ -4195,24 +4238,10 @@ out:
 static int st_remove(struct device *dev)
 {
 	struct scsi_tape *tpnt = dev_get_drvdata(dev);
-	int rew, mode;
-	dev_t cdev_devno;
-	struct cdev *cdev;
 
 	scsi_autopm_get_device(tpnt->device);
 
-	sysfs_remove_link(&tpnt->device->sdev_gendev.kobj, "tape");
-	for (mode = 0; mode < ST_NBR_MODES; ++mode) {
-		for (rew=0; rew < 2; rew++) {
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
@@ -4458,50 +4487,6 @@ struct device_attribute st_dev_attrs[] = {
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
-- 
1.7.9.2
