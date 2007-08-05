From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] sg: use idr to replace static arrays
Date: Sun, 05 Aug 2007 13:36:11 -0500
Message-ID: <1186338971.3455.19.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:47981 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751209AbXHESgO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Aug 2007 14:36:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

sg uses a scheme to reallocate a single contiguous array of all its
pointers for lookup and management.  This didn't matter too much when sg
could only attach 256 nodes, but now the maximum has been bumped up to
32k we're starting to push the limits of the maximum allocatable
contiguous memory.  The solution to this is to eliminate the static
array and do everything via idr, which this patch does.

James

Index: BUILD-2.6/drivers/scsi/sg.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/sg.c	2007-08-05 11:26:02.000000000 -0500
+++ BUILD-2.6/drivers/scsi/sg.c	2007-08-05 13:26:04.000000000 -0500
@@ -43,6 +43,7 @@ static int sg_version_num = 30534;	/* 2 
 #include <linux/poll.h>
 #include <linux/moduleparam.h>
 #include <linux/cdev.h>
+#include <linux/idr.h>
 #include <linux/seq_file.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
@@ -99,12 +100,11 @@ static int scatter_elem_sz_prev = SG_SCA
 #define SG_SECTOR_SZ 512
 #define SG_SECTOR_MSK (SG_SECTOR_SZ - 1)
 
-#define SG_DEV_ARR_LUMP 32	/* amount to over allocate sg_dev_arr by */
-
 static int sg_add(struct class_device *, struct class_interface *);
 static void sg_remove(struct class_device *, struct class_interface *);
 
-static DEFINE_RWLOCK(sg_dev_arr_lock);	/* Also used to lock
+static DEFINE_IDR(sg_index_idr);
+static DEFINE_RWLOCK(sg_index_lock);	/* Also used to lock
 							   file descriptor list for device */
 
 static struct class_interface sg_interface = {
@@ -162,6 +162,7 @@ typedef struct sg_device { /* holds the 
 	struct scsi_device *device;
 	wait_queue_head_t o_excl_wait;	/* queue open() when O_EXCL in use */
 	int sg_tablesize;	/* adapter's max scatter-gather table size */
+	u32 index;		/* device index number */
 	Sg_fd *headfp;		/* first open fd belonging to this device */
 	volatile char detached;	/* 0->attached, 1->detached pending removal */
 	volatile char exclude;	/* opened for exclusive access */
@@ -209,10 +210,6 @@ static Sg_device *sg_get_dev(int dev);
 static int sg_last_dev(void);
 #endif
 
-static Sg_device **sg_dev_arr = NULL;
-static int sg_dev_max;
-static int sg_nr_dev;
-
 #define SZ_SG_HEADER sizeof(struct sg_header)
 #define SZ_SG_IO_HDR sizeof(sg_io_hdr_t)
 #define SZ_SG_IOVEC sizeof(sg_iovec_t)
@@ -1331,40 +1328,35 @@ static struct class *sg_sysfs_class;
 
 static int sg_sysfs_valid = 0;
 
-static int sg_alloc(struct gendisk *disk, struct scsi_device *scsidp)
+static Sg_device *sg_alloc(struct gendisk *disk, struct scsi_device *scsidp)
 {
 	struct request_queue *q = scsidp->request_queue;
 	Sg_device *sdp;
 	unsigned long iflags;
-	void *old_sg_dev_arr = NULL;
-	int k, error;
+	int error;
+	u32 k;
 
 	sdp = kzalloc(sizeof(Sg_device), GFP_KERNEL);
 	if (!sdp) {
 		printk(KERN_WARNING "kmalloc Sg_device failure\n");
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
+	}
+	error = -ENOMEM;
+	if (!idr_pre_get(&sg_index_idr, GFP_KERNEL)) {
+		printk(KERN_WARNING "idr expansion Sg_device failure\n");
+		goto out;
 	}
 
-	write_lock_irqsave(&sg_dev_arr_lock, iflags);
-	if (unlikely(sg_nr_dev >= sg_dev_max)) {	/* try to resize */
-		Sg_device **tmp_da;
-		int tmp_dev_max = sg_nr_dev + SG_DEV_ARR_LUMP;
-		write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
-
-		tmp_da = kzalloc(tmp_dev_max * sizeof(Sg_device *), GFP_KERNEL);
-		if (unlikely(!tmp_da))
-			goto expand_failed;
-
-		write_lock_irqsave(&sg_dev_arr_lock, iflags);
-		memcpy(tmp_da, sg_dev_arr, sg_dev_max * sizeof(Sg_device *));
-		old_sg_dev_arr = sg_dev_arr;
-		sg_dev_arr = tmp_da;
-		sg_dev_max = tmp_dev_max;
+	write_lock_irqsave(&sg_index_lock, iflags);
+	error = idr_get_new(&sg_index_idr, sdp, &k);
+	write_unlock_irqrestore(&sg_index_lock, iflags);
+
+	if (error) {
+		printk(KERN_WARNING "idr allocation Sg_device failure: %d\n",
+		       error);
+		goto out;
 	}
 
-	for (k = 0; k < sg_dev_max; k++)
-		if (!sg_dev_arr[k])
-			break;
 	if (unlikely(k >= SG_MAX_DEVS))
 		goto overflow;
 
@@ -1375,25 +1367,17 @@ static int sg_alloc(struct gendisk *disk
 	sdp->device = scsidp;
 	init_waitqueue_head(&sdp->o_excl_wait);
 	sdp->sg_tablesize = min(q->max_hw_segments, q->max_phys_segments);
+	sdp->index = k;
 
-	sg_nr_dev++;
-	sg_dev_arr[k] = sdp;
-	write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
-	error = k;
-
+	error = 0;
  out:
-	if (error < 0)
+	if (error) {
 		kfree(sdp);
-	kfree(old_sg_dev_arr);
-	return error;
-
- expand_failed:
-	printk(KERN_WARNING "sg_alloc: device array cannot be resized\n");
-	error = -ENOMEM;
-	goto out;
+		return ERR_PTR(error);
+	}
+	return sdp;
 
  overflow:
-	write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
 	sdev_printk(KERN_WARNING, scsidp,
 		    "Unable to attach sg device type=%d, minor "
 		    "number exceeds %d\n", scsidp->type, SG_MAX_DEVS - 1);
@@ -1408,7 +1392,7 @@ sg_add(struct class_device *cl_dev, stru
 	struct gendisk *disk;
 	Sg_device *sdp = NULL;
 	struct cdev * cdev = NULL;
-	int error, k;
+	int error;
 	unsigned long iflags;
 
 	disk = alloc_disk(1);
@@ -1427,15 +1411,15 @@ sg_add(struct class_device *cl_dev, stru
 	cdev->owner = THIS_MODULE;
 	cdev->ops = &sg_fops;
 
-	error = sg_alloc(disk, scsidp);
-	if (error < 0) {
+	sdp = sg_alloc(disk, scsidp);
+	if (IS_ERR(sdp)) {
 		printk(KERN_WARNING "sg_alloc failed\n");
+		error = PTR_ERR(sdp);
 		goto out;
 	}
-	k = error;
-	sdp = sg_dev_arr[k];
 
-	error = cdev_add(cdev, MKDEV(SCSI_GENERIC_MAJOR, k), 1);
+	class_set_devdata(cl_dev, sdp);
+	error = cdev_add(cdev, MKDEV(SCSI_GENERIC_MAJOR, sdp->index), 1);
 	if (error)
 		goto cdev_add_err;
 
@@ -1444,8 +1428,8 @@ sg_add(struct class_device *cl_dev, stru
 		struct class_device * sg_class_member;
 
 		sg_class_member = class_device_create(sg_sysfs_class, NULL,
-				MKDEV(SCSI_GENERIC_MAJOR, k), 
-				cl_dev->dev, "%s", 
+				MKDEV(SCSI_GENERIC_MAJOR, sdp->index),
+				cl_dev->dev, "%s",
 				disk->disk_name);
 		if (IS_ERR(sg_class_member))
 			printk(KERN_WARNING "sg_add: "
@@ -1455,21 +1439,21 @@ sg_add(struct class_device *cl_dev, stru
 					  &sg_class_member->kobj, "generic");
 		if (error)
 			printk(KERN_ERR "sg_add: unable to make symlink "
-					"'generic' back to sg%d\n", k);
+					"'generic' back to sg%d\n", sdp->index);
 	} else
-		printk(KERN_WARNING "sg_add: sg_sys INvalid\n");
+		printk(KERN_WARNING "sg_add: sg_sys Invalid\n");
 
 	sdev_printk(KERN_NOTICE, scsidp,
-		    "Attached scsi generic sg%d type %d\n", k,scsidp->type);
+		    "Attached scsi generic sg%d type %d\n", sdp->index,
+		    scsidp->type);
 
 	return 0;
 
 cdev_add_err:
-	write_lock_irqsave(&sg_dev_arr_lock, iflags);
-	kfree(sg_dev_arr[k]);
-	sg_dev_arr[k] = NULL;
-	sg_nr_dev--;
-	write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
+	write_lock_irqsave(&sg_index_lock, iflags);
+	idr_remove(&sg_index_idr, sdp->index);
+	write_unlock_irqrestore(&sg_index_lock, iflags);
+	kfree(sdp);
 
 out:
 	put_disk(disk);
@@ -1482,64 +1466,56 @@ static void
 sg_remove(struct class_device *cl_dev, struct class_interface *cl_intf)
 {
 	struct scsi_device *scsidp = to_scsi_device(cl_dev->dev);
-	Sg_device *sdp = NULL;
+	Sg_device *sdp = class_get_devdata(cl_dev);
 	unsigned long iflags;
 	Sg_fd *sfp;
 	Sg_fd *tsfp;
 	Sg_request *srp;
 	Sg_request *tsrp;
-	int k, delay;
+	int delay;
 
-	if (NULL == sg_dev_arr)
+	if (!sdp)
 		return;
+
 	delay = 0;
-	write_lock_irqsave(&sg_dev_arr_lock, iflags);
-	for (k = 0; k < sg_dev_max; k++) {
-		sdp = sg_dev_arr[k];
-		if ((NULL == sdp) || (sdp->device != scsidp))
-			continue;	/* dirty but lowers nesting */
-		if (sdp->headfp) {
-			sdp->detached = 1;
-			for (sfp = sdp->headfp; sfp; sfp = tsfp) {
-				tsfp = sfp->nextfp;
-				for (srp = sfp->headrp; srp; srp = tsrp) {
-					tsrp = srp->nextrp;
-					if (sfp->closed || (0 == sg_srp_done(srp, sfp)))
-						sg_finish_rem_req(srp);
-				}
-				if (sfp->closed) {
-					scsi_device_put(sdp->device);
-					__sg_remove_sfp(sdp, sfp);
-				} else {
-					delay = 1;
-					wake_up_interruptible(&sfp->read_wait);
-					kill_fasync(&sfp->async_qp, SIGPOLL,
-						    POLL_HUP);
-				}
-			}
-			SCSI_LOG_TIMEOUT(3, printk("sg_remove: dev=%d, dirty\n", k));
-			if (NULL == sdp->headfp) {
-				sg_dev_arr[k] = NULL;
+	write_lock_irqsave(&sg_index_lock, iflags);
+	if (sdp->headfp) {
+		sdp->detached = 1;
+		for (sfp = sdp->headfp; sfp; sfp = tsfp) {
+			tsfp = sfp->nextfp;
+			for (srp = sfp->headrp; srp; srp = tsrp) {
+				tsrp = srp->nextrp;
+				if (sfp->closed || (0 == sg_srp_done(srp, sfp)))
+					sg_finish_rem_req(srp);
 			}
-		} else {	/* nothing active, simple case */
-			SCSI_LOG_TIMEOUT(3, printk("sg_remove: dev=%d\n", k));
-			sg_dev_arr[k] = NULL;
-		}
-		sg_nr_dev--;
-		break;
-	}
-	write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
-
-	if (sdp) {
-		sysfs_remove_link(&scsidp->sdev_gendev.kobj, "generic");
-		class_device_destroy(sg_sysfs_class, MKDEV(SCSI_GENERIC_MAJOR, k));
-		cdev_del(sdp->cdev);
-		sdp->cdev = NULL;
-		put_disk(sdp->disk);
-		sdp->disk = NULL;
-		if (NULL == sdp->headfp)
-			kfree((char *) sdp);
-	}
+			if (sfp->closed) {
+				scsi_device_put(sdp->device);
+				__sg_remove_sfp(sdp, sfp);
+			} else {
+				delay = 1;
+				wake_up_interruptible(&sfp->read_wait);
+				kill_fasync(&sfp->async_qp, SIGPOLL,
+					    POLL_HUP);
+			}
+		}
+		SCSI_LOG_TIMEOUT(3, printk("sg_remove: dev=%d, dirty\n", sdp->index));
+		if (NULL == sdp->headfp) {
+			idr_remove(&sg_index_idr, sdp->index);
+		}
+	} else {	/* nothing active, simple case */
+		SCSI_LOG_TIMEOUT(3, printk("sg_remove: dev=%d\n", sdp->index));
+		idr_remove(&sg_index_idr, sdp->index);
+	}
+	write_unlock_irqrestore(&sg_index_lock, iflags);
+
+	sysfs_remove_link(&scsidp->sdev_gendev.kobj, "generic");
+	class_device_destroy(sg_sysfs_class, MKDEV(SCSI_GENERIC_MAJOR, sdp->index));
+	cdev_del(sdp->cdev);
+	sdp->cdev = NULL;
+	put_disk(sdp->disk);
+	sdp->disk = NULL;
+	if (NULL == sdp->headfp)
+		kfree(sdp);
 
 	if (delay)
 		msleep(10);	/* dirty detach so delay device destruction */
@@ -1609,9 +1585,7 @@ exit_sg(void)
 	sg_sysfs_valid = 0;
 	unregister_chrdev_region(MKDEV(SCSI_GENERIC_MAJOR, 0),
 				 SG_MAX_DEVS);
-	kfree((char *)sg_dev_arr);
-	sg_dev_arr = NULL;
-	sg_dev_max = 0;
+	idr_destroy(&sg_index_idr);
 }
 
 static int
@@ -2331,10 +2305,10 @@ sg_get_nth_sfp(Sg_device * sdp, int nth)
 	unsigned long iflags;
 	int k;
 
-	read_lock_irqsave(&sg_dev_arr_lock, iflags);
+	read_lock_irqsave(&sg_index_lock, iflags);
 	for (k = 0, resp = sdp->headfp; resp && (k < nth);
 	     ++k, resp = resp->nextfp) ;
-	read_unlock_irqrestore(&sg_dev_arr_lock, iflags);
+	read_unlock_irqrestore(&sg_index_lock, iflags);
 	return resp;
 }
 #endif
@@ -2361,7 +2335,7 @@ sg_add_sfp(Sg_device * sdp, int dev)
 	sfp->cmd_q = SG_DEF_COMMAND_Q;
 	sfp->keep_orphan = SG_DEF_KEEP_ORPHAN;
 	sfp->parentdp = sdp;
-	write_lock_irqsave(&sg_dev_arr_lock, iflags);
+	write_lock_irqsave(&sg_index_lock, iflags);
 	if (!sdp->headfp)
 		sdp->headfp = sfp;
 	else {			/* add to tail of existing list */
@@ -2370,7 +2344,7 @@ sg_add_sfp(Sg_device * sdp, int dev)
 			pfp = pfp->nextfp;
 		pfp->nextfp = sfp;
 	}
-	write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
+	write_unlock_irqrestore(&sg_index_lock, iflags);
 	SCSI_LOG_TIMEOUT(3, printk("sg_add_sfp: sfp=0x%p\n", sfp));
 	if (unlikely(sg_big_buff != def_reserved_size))
 		sg_big_buff = def_reserved_size;
@@ -2431,22 +2405,14 @@ sg_remove_sfp(Sg_device * sdp, Sg_fd * s
 	if (0 == dirty) {
 		unsigned long iflags;
 
-		write_lock_irqsave(&sg_dev_arr_lock, iflags);
+		write_lock_irqsave(&sg_index_lock, iflags);
 		__sg_remove_sfp(sdp, sfp);
 		if (sdp->detached && (NULL == sdp->headfp)) {
-			int k, maxd;
-
-			maxd = sg_dev_max;
-			for (k = 0; k < maxd; ++k) {
-				if (sdp == sg_dev_arr[k])
-					break;
-			}
-			if (k < maxd)
-				sg_dev_arr[k] = NULL;
-			kfree((char *) sdp);
+			idr_remove(&sg_index_idr, sdp->index);
+			kfree(sdp);
 			res = 1;
 		}
-		write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
+		write_unlock_irqrestore(&sg_index_lock, iflags);
 	} else {
 		/* MOD_INC's to inhibit unloading sg and associated adapter driver */
 		/* only bump the access_count if we actually succeeded in
@@ -2546,16 +2512,25 @@ sg_allow_access(unsigned char opcode, ch
 
 #ifdef CONFIG_SCSI_PROC_FS
 static int
+sg_idr_max_id(int id, void *p, void *data)
+{
+	int *k = data;
+
+	if (*k < id)
+		*k = id;
+
+	return 0;
+}
+
+static int
 sg_last_dev(void)
 {
-	int k;
+	int k = 0;
 	unsigned long iflags;
 
-	read_lock_irqsave(&sg_dev_arr_lock, iflags);
-	for (k = sg_dev_max - 1; k >= 0; --k)
-		if (sg_dev_arr[k] && sg_dev_arr[k]->device)
-			break;
-	read_unlock_irqrestore(&sg_dev_arr_lock, iflags);
+	read_lock_irqsave(&sg_index_lock, iflags);
+	idr_for_each(&sg_index_idr, sg_idr_max_id, &k);
+	read_unlock_irqrestore(&sg_index_lock, iflags);
 	return k + 1;		/* origin 1 */
 }
 #endif
@@ -2563,15 +2538,13 @@ sg_last_dev(void)
 static Sg_device *
 sg_get_dev(int dev)
 {
-	Sg_device *sdp = NULL;
+	Sg_device *sdp;
 	unsigned long iflags;
 
-	if (sg_dev_arr && (dev >= 0)) {
-		read_lock_irqsave(&sg_dev_arr_lock, iflags);
-		if (dev < sg_dev_max)
-			sdp = sg_dev_arr[dev];
-		read_unlock_irqrestore(&sg_dev_arr_lock, iflags);
-	}
+	read_lock_irqsave(&sg_index_lock, iflags);
+	sdp = idr_find(&sg_index_idr, dev);
+	read_unlock_irqrestore(&sg_index_lock, iflags);
+
 	return sdp;
 }
 
@@ -2805,8 +2778,6 @@ static void * dev_seq_start(struct seq_f
 	if (! it)
 		return NULL;
 
-	if (NULL == sg_dev_arr)
-		return NULL;
 	it->index = *pos;
 	it->max = sg_last_dev();
 	if (it->index >= it->max)
@@ -2942,8 +2913,8 @@ static int sg_proc_seq_show_debug(struct
 	Sg_device *sdp;
 
 	if (it && (0 == it->index)) {
-		seq_printf(s, "dev_max(currently)=%d max_active_device=%d "
-			   "(origin 1)\n", sg_dev_max, (int)it->max);
+		seq_printf(s, "max_active_device=%d(origin 1)\n",
+			   (int)it->max);
 		seq_printf(s, " def_reserved_size=%d\n", sg_big_buff);
 	}
 	sdp = it ? sg_get_dev(it->index) : NULL;


