From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH v2 3/5] st: get rid of scsi_tapes array
Date: Thu, 17 May 2012 14:20:59 -0700
Message-ID: <4FB56BBB.7050509@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat.nue.novell.com ([195.135.221.2]:3269 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933000Ab2EQVVG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 May 2012 17:21:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kai.makisara@kolumbus.fi, jeffm@suse.com

From: Jeff Mahoney <jeffm@suse.com>

st currently allocates an array to store pointers to all of the
scsi_tape objects. It's used to discover available indexes to use as the
base for the minor number selection and later to look up scsi_tape
devices for character devices.

We switch to using an IDR for minor selection and a pointer from
st_modedef back to scsi_tape for the lookups.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/st.c |  172 ++++++++++++++++++++---------------------------------
 drivers/scsi/st.h |    2 +
 2 files changed, 65 insertions(+), 109 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 40f9d47..9c2c9d9 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -37,6 +37,7 @@ static const char *verstr = "20101219";
 #include <linux/blkdev.h>
 #include <linux/moduleparam.h>
 #include <linux/cdev.h>
+#include <linux/idr.h>
 #include <linux/delay.h>
 #include <linux/mutex.h>
 
@@ -81,9 +82,6 @@ static int try_direct_io = TRY_DIRECT_IO;
 static int try_rdio = 1;
 static int try_wdio = 1;
 
-static int st_dev_max;
-static int st_nr_dev;
-
 extern struct class st_sysfs_class;
 extern struct device_attribute st_dev_attrs[];
 
@@ -174,13 +172,9 @@ static int debugging = DEBUG;
    24 bits) */
 #define SET_DENS_AND_BLK 0x10001
 
-static DEFINE_RWLOCK(st_dev_arr_lock);
-
 static int st_fixed_buffer_size = ST_FIXED_BUFFER_SIZE;
 static int st_max_sg_segs = ST_MAX_SG;
 
-static struct scsi_tape **scsi_tapes = NULL;
-
 static int modes_defined;
 
 static int enlarge_buffer(struct st_buffer *, int, int);
@@ -222,6 +216,10 @@ static void scsi_tape_release(struct kref *);
 #define to_scsi_tape(obj) container_of(obj, struct scsi_tape, kref)
 
 static DEFINE_MUTEX(st_ref_mutex);
+static DEFINE_SPINLOCK(st_index_lock);
+static DEFINE_SPINLOCK(st_use_lock);
+static DEFINE_IDR(st_index_idr);
+
 
 

 #include "osst_detect.h"
@@ -239,10 +237,9 @@ static struct scsi_tape *scsi_tape_get(int dev)
 	struct scsi_tape *STp = NULL;
 
 	mutex_lock(&st_ref_mutex);
-	write_lock(&st_dev_arr_lock);
+	spin_lock(&st_index_lock);
 
-	if (dev < st_dev_max && scsi_tapes != NULL)
-		STp = scsi_tapes[dev];
+	STp = idr_find(&st_index_idr, dev);
 	if (!STp) goto out;
 
 	kref_get(&STp->kref);
@@ -259,7 +256,7 @@ out_put:
 	kref_put(&STp->kref, scsi_tape_release);
 	STp = NULL;
 out:
-	write_unlock(&st_dev_arr_lock);
+	spin_unlock(&st_index_lock);
 	mutex_unlock(&st_ref_mutex);
 	return STp;
 }
@@ -1202,12 +1199,12 @@ static int st_open(struct inode *inode, struct file *filp)
 		return -ENXIO;
 	}
 
-	write_lock(&st_dev_arr_lock);
 	filp->private_data = STp;
 	name = tape_name(STp);
 
+	spin_lock(&st_use_lock);
 	if (STp->in_use) {
-		write_unlock(&st_dev_arr_lock);
+		spin_unlock(&st_use_lock);
 		scsi_tape_put(STp);
 		mutex_unlock(&st_mutex);
 		DEB( printk(ST_DEB_MSG "%s: Device already in use.\n", name); )
@@ -1215,7 +1212,7 @@ static int st_open(struct inode *inode, struct file *filp)
 	}
 
 	STp->in_use = 1;
-	write_unlock(&st_dev_arr_lock);
+	spin_unlock(&st_use_lock);
 	STp->rew_at_close = STp->autorew_dev = (iminor(inode) & 0x80) == 0;
 
 	if (scsi_autopm_get_device(STp->device) < 0) {
@@ -1404,9 +1401,9 @@ static int st_release(struct inode *inode, struct file *filp)
 		do_door_lock(STp, 0);
 
 	normalize_buffer(STp->buffer);
-	write_lock(&st_dev_arr_lock);
+	spin_lock(&st_use_lock);
 	STp->in_use = 0;
-	write_unlock(&st_dev_arr_lock);
+	spin_unlock(&st_use_lock);
 	scsi_autopm_put_device(STp->device);
 	scsi_tape_put(STp);
 
@@ -4029,58 +4026,16 @@ static int st_probe(struct device *dev)
 		goto out_buffer_free;
 	}
 
-	write_lock(&st_dev_arr_lock);
-	if (st_nr_dev >= st_dev_max) {
-		struct scsi_tape **tmp_da;
-		int tmp_dev_max;
-
-		tmp_dev_max = max(st_nr_dev * 2, 8);
-		if (tmp_dev_max > ST_MAX_TAPES)
-			tmp_dev_max = ST_MAX_TAPES;
-		if (tmp_dev_max <= st_nr_dev) {
-			write_unlock(&st_dev_arr_lock);
-			printk(KERN_ERR "st: Too many tape devices (max. %d).\n",
-			       ST_MAX_TAPES);
-			goto out_put_disk;
-		}
-
-		tmp_da = kzalloc(tmp_dev_max * sizeof(struct scsi_tape *), GFP_ATOMIC);
-		if (tmp_da == NULL) {
-			write_unlock(&st_dev_arr_lock);
-			printk(KERN_ERR "st: Can't extend device array.\n");
-			goto out_put_disk;
-		}
-
-		if (scsi_tapes != NULL) {
-			memcpy(tmp_da, scsi_tapes,
-			       st_dev_max * sizeof(struct scsi_tape *));
-			kfree(scsi_tapes);
-		}
-		scsi_tapes = tmp_da;
-
-		st_dev_max = tmp_dev_max;
-	}
-
-	for (i = 0; i < st_dev_max; i++)
-		if (scsi_tapes[i] == NULL)
-			break;
-	if (i >= st_dev_max)
-		panic("scsi_devices corrupt (st)");
-
 	tpnt = kzalloc(sizeof(struct scsi_tape), GFP_ATOMIC);
 	if (tpnt == NULL) {
-		write_unlock(&st_dev_arr_lock);
 		printk(KERN_ERR "st: Can't allocate device descriptor.\n");
 		goto out_put_disk;
 	}
 	kref_init(&tpnt->kref);
 	tpnt->disk = disk;
-	sprintf(disk->disk_name, "st%d", i);
 	disk->private_data = &tpnt->driver;
 	disk->queue = SDp->request_queue;
 	tpnt->driver = &st_template;
-	scsi_tapes[i] = tpnt;
-	dev_num = i;
 
 	tpnt->device = SDp;
 	if (SDp->scsi_level <= 2)
@@ -4126,6 +4081,7 @@ static int st_probe(struct device *dev)
 		STm->default_compression = ST_DONT_TOUCH;
 		STm->default_blksize = (-1);	/* No forced size */
 		STm->default_density = (-1);	/* No forced density */
+		STm->tape = tpnt;
 	}
 
 	for (i = 0; i < ST_NBR_PARTITIONS; i++) {
@@ -4145,8 +4101,30 @@ static int st_probe(struct device *dev)
 	    tpnt->blksize_changed = 0;
 	mutex_init(&tpnt->lock);
 
-	st_nr_dev++;
-	write_unlock(&st_dev_arr_lock);
+	if (!idr_pre_get(&st_index_idr, GFP_KERNEL)) {
+		printk(KERN_WARNING "st: idr expansion failed\n");
+		error = -ENOMEM;
+		goto out_put_disk;
+	}
+
+	spin_lock(&st_index_lock);
+	error = idr_get_new(&st_index_idr, tpnt, &dev_num);
+	spin_unlock(&st_index_lock);
+	if (error) {
+		printk(KERN_WARNING "st: idr allocation failed: %d\n", error);
+		goto out_put_disk;
+	}
+
+	if (dev_num > ST_MAX_TAPES) {
+		printk(KERN_ERR "st: Too many tape devices (max. %d).\n",
+		       ST_MAX_TAPES);
+		goto out_put_index;
+	}
+
+	tpnt->index = dev_num;
+	sprintf(disk->disk_name, "st%d", dev_num);
+
+	dev_set_drvdata(dev, tpnt);
 
 	for (mode = 0; mode < ST_NBR_MODES; ++mode) {
 		STm = &(tpnt->modes[mode]);
@@ -4189,10 +4167,10 @@ static int st_probe(struct device *dev)
 	return 0;
 
 out_free_tape:
+	sysfs_remove_link(&tpnt->device->sdev_gendev.kobj,
+			  "tape");
 	for (mode=0; mode < ST_NBR_MODES; mode++) {
 		STm = &(tpnt->modes[mode]);
-		sysfs_remove_link(&tpnt->device->sdev_gendev.kobj,
-				  "tape");
 		for (j=0; j < 2; j++) {
 			if (STm->cdevs[j]) {
 				device_destroy(&st_sysfs_class,
@@ -4202,10 +4180,8 @@ out_free_tape:
 			}
 		}
 	}
-	write_lock(&st_dev_arr_lock);
-	scsi_tapes[dev_num] = NULL;
-	st_nr_dev--;
-	write_unlock(&st_dev_arr_lock);
+out_put_index:
+	idr_remove(&st_index_idr, dev_num);
 out_put_disk:
 	put_disk(disk);
 	kfree(tpnt);
@@ -4218,38 +4194,29 @@ out:
 
 static int st_remove(struct device *dev)
 {
-	struct scsi_device *SDp = to_scsi_device(dev);
-	struct scsi_tape *tpnt;
-	int i, j, mode;
-
-	scsi_autopm_get_device(SDp);
-	write_lock(&st_dev_arr_lock);
-	for (i = 0; i < st_dev_max; i++) {
-		tpnt = scsi_tapes[i];
-		if (tpnt != NULL && tpnt->device == SDp) {
-			scsi_tapes[i] = NULL;
-			st_nr_dev--;
-			write_unlock(&st_dev_arr_lock);
-			sysfs_remove_link(&tpnt->device->sdev_gendev.kobj,
-					  "tape");
-			for (mode = 0; mode < ST_NBR_MODES; ++mode) {
-				for (j=0; j < 2; j++) {
-					device_destroy(&st_sysfs_class,
-						       MKDEV(SCSI_TAPE_MAJOR,
-							     TAPE_MINOR(i, mode, j)));
-					cdev_del(tpnt->modes[mode].cdevs[j]);
-					tpnt->modes[mode].cdevs[j] = NULL;
-				}
-			}
+	struct scsi_tape *tpnt = dev_get_drvdata(dev);
+	int rew, mode;
+	dev_t cdev_devno;
+	struct cdev *cdev;
 
-			mutex_lock(&st_ref_mutex);
-			kref_put(&tpnt->kref, scsi_tape_release);
-			mutex_unlock(&st_ref_mutex);
-			return 0;
+	scsi_autopm_get_device(tpnt->device);
+
+	sysfs_remove_link(&tpnt->device->sdev_gendev.kobj, "tape");
+	for (mode = 0; mode < ST_NBR_MODES; ++mode) {
+		for (rew=0; rew < 2; rew++) {
+			cdev = tpnt->modes[mode].cdevs[rew];
+			if (!cdev)
+				continue;
+			cdev_devno = cdev->dev;
+			device_destroy(&st_sysfs_class, cdev_devno);
+			cdev_del(tpnt->modes[mode].cdevs[rew]);
+			tpnt->modes[mode].cdevs[rew] = NULL;
 		}
 	}
 
-	write_unlock(&st_dev_arr_lock);
+	mutex_lock(&st_ref_mutex);
+	kref_put(&tpnt->kref, scsi_tape_release);
+	mutex_unlock(&st_ref_mutex);
 	return 0;
 }
 
@@ -4336,7 +4303,6 @@ static void __exit exit_st(void)
 	unregister_chrdev_region(MKDEV(SCSI_TAPE_MAJOR, 0),
 				 ST_MAX_TAPE_ENTRIES);
 	class_unregister(&st_sysfs_class);
-	kfree(scsi_tapes);
 	printk(KERN_INFO "st: Unloaded.\n");
 }
 
@@ -4459,22 +4425,10 @@ static ssize_t
 options_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct st_modedef *STm = dev_get_drvdata(dev);
-	struct scsi_tape *STp;
-	int i, j, options;
+	struct scsi_tape *STp = STm->tape;
+	int options;
 	ssize_t l = 0;
 
-	for (i=0; i < st_dev_max; i++) {
-		for (j=0; j < ST_NBR_MODES; j++)
-			if (&scsi_tapes[i]->modes[j] == STm)
-				break;
-		if (j < ST_NBR_MODES)
-			break;
-	}
-	if (i == st_dev_max)
-		return 0;  /* should never happen */
-
-	STp = scsi_tapes[i];
-
 	options = STm->do_buffer_writes ? MT_ST_BUFFER_WRITES : 0;
 	options |= STm->do_async_writes ? MT_ST_ASYNC_WRITES : 0;
 	options |= STm->do_read_ahead ? MT_ST_READ_AHEAD : 0;
diff --git a/drivers/scsi/st.h b/drivers/scsi/st.h
index ea35632..4456735 100644
--- a/drivers/scsi/st.h
+++ b/drivers/scsi/st.h
@@ -66,6 +66,7 @@ struct st_modedef {
 	unsigned char default_compression;	/* 0 = don't touch, etc */
 	short default_density;	/* Forced density, -1 = no value */
 	int default_blksize;	/* Forced blocksize, -1 = no value */
+	struct scsi_tape *tape;
 	struct cdev *cdevs[2];  /* Auto-rewind and non-rewind devices */
 };
 
@@ -99,6 +100,7 @@ struct scsi_tape {
 	struct mutex lock;	/* For serialization */
 	struct completion wait;	/* For SCSI commands */
 	struct st_buffer *buffer;
+	int index;
 
 	/* Drive characteristics */
 	unsigned char omit_blklims;
-- 
1.7.9.2

