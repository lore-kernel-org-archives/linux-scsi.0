From: Douglas Gilbert <dougg@torque.net>
Subject: Re: requesting advice: oops when doing sg_dd IO and device is removed
Date: Mon, 24 Oct 2005 23:04:51 +1000
Message-ID: <435CDBF3.5020202@torque.net>
References: <92952AEF1F064042B6EF2522E0EEF43702433512@EXNA.corp.stratus.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060706020508000704070807"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:22705 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1750975AbVJXND7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 09:03:59 -0400
In-Reply-To: <92952AEF1F064042B6EF2522E0EEF43702433512@EXNA.corp.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Dailey, Nate" <Nate.Dailey@stratus.com>
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------060706020508000704070807
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Dailey, Nate wrote:
> Doug, I'm attaching a new patch (again, against 2.6.9)... the primary
> difference from my previous patch is that this one now schedules a work
> item from sg_cmd_done. This work item drops the reference on the device,
> so this gets rid of the problems of calling scsi_device_put from
> sg_cmd_done or of sleeping in sg_release. Does this look okay?

Nate,
I haven't had a close look at the logic but I have
been using this patch for several days. So far I have
been testing other things with sg and have detected
no regression from this patch.

Since your patch was against 2.6.9, it needed a few
changes to apply to lk 2.6.14-rc5 . The patch against
2.6.14-rc5 is attached.

Hopefully in the next few days I can focus on
testing this patch.

Doug Gilbert

--------------060706020508000704070807
Content-Type: text/x-patch;
 name="sg_2614rc5nd2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sg_2614rc5nd2.diff"

--- linux/drivers/scsi/sg.c	2005-10-05 12:09:27.000000000 +1000
+++ linux/drivers/scsi/sg.c2614rc5nd2	2005-10-24 12:11:32.000000000 +1000
@@ -49,6 +49,7 @@
 #include <linux/seq_file.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
+#include <linux/kref.h>
 
 #include "scsi.h"
 #include <scsi/scsi_dbg.h>
@@ -174,6 +175,7 @@
 	char sgdebug;		/* 0->off, 1->sense, 9->dump dev, 10-> all devs */
 	struct gendisk *disk;
 	struct cdev * cdev;	/* char_dev [sysfs: /sys/cdev/major/sg<n>] */
+	struct kref kref;
 } Sg_device;
 
 static int sg_fasync(int fd, struct file *filp, int mode);
@@ -219,11 +221,89 @@
 static int sg_dev_max;
 static int sg_nr_dev;
 
+/* This semaphore is used to mediate the 0->1 reference get in the
+ * face of object destruction (i.e. we can't allow a get on an
+ * object after last put) */
+static DECLARE_MUTEX(sg_ref_sem);
+
+static void scsi_generic_release(struct kref *kref);
+#define to_scsi_generic(obj) container_of(obj,Sg_device,kref)
+
 #define SZ_SG_HEADER sizeof(struct sg_header)
 #define SZ_SG_IO_HDR sizeof(sg_io_hdr_t)
 #define SZ_SG_IOVEC sizeof(sg_iovec_t)
 #define SZ_SG_REQ_INFO sizeof(sg_req_info_t)
 
+static Sg_device *scsi_generic_get(int dev)
+{
+	Sg_device *sdp = NULL;
+
+	down(&sg_ref_sem);
+
+	sdp = sg_get_dev (dev);
+	if (!sdp) goto out;
+
+	if (sdp->detached) {
+		sdp = NULL;
+		goto out;
+	}
+
+	kref_get(&sdp->kref);
+
+	if (!sdp->device)
+		goto out_put;
+
+	if (scsi_device_get(sdp->device))
+		goto out_put;
+
+	goto out;
+
+out_put:
+	kref_put(&sdp->kref, scsi_generic_release);
+	sdp = NULL;
+out:
+	up(&sg_ref_sem);
+	return sdp;
+}
+
+static void scsi_generic_put(Sg_device *sdp)
+{
+	struct scsi_device *sdev = sdp->device;
+
+	down(&sg_ref_sem);
+	kref_put(&sdp->kref, scsi_generic_release);
+	scsi_device_put(sdev);
+	up(&sg_ref_sem);
+}
+
+struct scsi_generic_put_work_item {
+	Sg_device *sdp;
+        struct work_struct work;
+};
+
+void scsi_generic_put_work_handler(void *data)
+{
+	Sg_device *sdp = ((struct scsi_generic_put_work_item*)data)->sdp;
+
+        scsi_generic_put(sdp);
+	kfree(data);
+}
+
+static int scsi_generic_put_schedule_work(Sg_device *sdp)
+{
+	struct scsi_generic_put_work_item *data;
+
+	if ((data = kmalloc(sizeof(*data), GFP_ATOMIC)) == NULL)
+		return -ENOMEM;
+
+	memset(data, 0, sizeof(*data));
+        INIT_WORK(&data->work, scsi_generic_put_work_handler, data);
+	data->sdp = sdp;
+
+        schedule_work(&data->work);
+	return 0;
+}
+
 static int
 sg_open(struct inode *inode, struct file *filp)
 {
@@ -236,17 +316,8 @@
 
 	nonseekable_open(inode, filp);
 	SCSI_LOG_TIMEOUT(3, printk("sg_open: dev=%d, flags=0x%x\n", dev, flags));
-	sdp = sg_get_dev(dev);
-	if ((!sdp) || (!sdp->device))
+	if (!(sdp = scsi_generic_get(dev)))
 		return -ENXIO;
-	if (sdp->detached)
-		return -ENODEV;
-
-	/* This driver's module count bumped by fops_get in <linux/fs.h> */
-	/* Prevent the device driver from vanishing while we sleep */
-	retval = scsi_device_get(sdp->device);
-	if (retval)
-		return retval;
 
 	if (!((flags & O_NONBLOCK) ||
 	      scsi_block_when_processing_errors(sdp->device))) {
@@ -303,7 +374,7 @@
 	return 0;
 
       error_out:
-	scsi_device_put(sdp->device);
+	scsi_generic_put(sdp);
 	return retval;
 }
 
@@ -313,18 +384,21 @@
 {
 	Sg_device *sdp;
 	Sg_fd *sfp;
+	int dirty;
 
 	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
 	SCSI_LOG_TIMEOUT(3, printk("sg_release: %s\n", sdp->disk->disk_name));
 	sg_fasync(-1, filp, 0);	/* remove filp from async notification list */
-	if (0 == sg_remove_sfp(sdp, sfp)) {	/* Returns 1 when sdp gone */
-		if (!sdp->detached) {
-			scsi_device_put(sdp->device);
-		}
-		sdp->exclude = 0;
-		wake_up_interruptible(&sdp->o_excl_wait);
-	}
+	dirty = sg_remove_sfp(sdp, sfp);
+	sdp->exclude = 0;
+	wake_up_interruptible(&sdp->o_excl_wait);
+
+	/* Only drop the reference if sg_remove_sfp returned 0
+	   (otherwise, there's IO outstanding & we must keep the reference). */
+	if (!dirty)
+		scsi_generic_put(sdp);
+
 	return 0;
 }
 
@@ -1328,7 +1402,7 @@
 	sfp = srp->parentfp;
 	if (sfp)
 		sdp = sfp->parentdp;
-	if ((NULL == sdp) || sdp->detached) {
+	if (NULL == sdp) {
 		printk(KERN_INFO "sg_cmd_done: device detached\n");
 		scsi_release_request(SRpnt);
 		return;
@@ -1391,8 +1465,16 @@
 		srp = NULL;
 		if (NULL == sfp->headrp) {
 			SCSI_LOG_TIMEOUT(1, printk("sg...bh: already closed, final cleanup\n"));
-			if (0 == sg_remove_sfp(sdp, sfp)) {	/* device still present */
-				scsi_device_put(sdp->device);
+
+			/* Drop a reference if sg_remove_sfp returns 0
+			   (no IO outstanding). */
+			if (0 == sg_remove_sfp(sdp, sfp)) {
+				if (scsi_generic_put_schedule_work(sdp))
+				{
+					/* Error scheduling the work...
+					   just drop the reference. */
+					scsi_generic_put(sdp);
+				}
 			}
 			sfp = NULL;
 		}
@@ -1537,6 +1619,7 @@
 	}
 	k = error;
 	sdp = sg_dev_arr[k];
+	kref_init(&sdp->kref);
 
 	devfs_mk_cdev(MKDEV(SCSI_GENERIC_MAJOR, k),
 			S_IFCHR | S_IRUSR | S_IWUSR | S_IRGRP,
@@ -1589,45 +1672,33 @@
 	unsigned long iflags;
 	Sg_fd *sfp;
 	Sg_fd *tsfp;
-	Sg_request *srp;
-	Sg_request *tsrp;
-	int k, delay;
+	int k;
 
 	if (NULL == sg_dev_arr)
 		return;
-	delay = 0;
 	write_lock_irqsave(&sg_dev_arr_lock, iflags);
 	for (k = 0; k < sg_dev_max; k++) {
-		sdp = sg_dev_arr[k];
-		if ((NULL == sdp) || (sdp->device != scsidp))
+		if ((NULL == sg_dev_arr[k]) ||
+		    (sg_dev_arr[k]->device != scsidp))
 			continue;	/* dirty but lowers nesting */
+		sdp = sg_dev_arr[k];
+		sdp->detached = 1;
+
 		if (sdp->headfp) {
-			sdp->detached = 1;
 			for (sfp = sdp->headfp; sfp; sfp = tsfp) {
 				tsfp = sfp->nextfp;
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
+				if (!(sfp->closed)) {
 					wake_up_interruptible(&sfp->read_wait);
 					kill_fasync(&sfp->async_qp, SIGPOLL,
 						    POLL_HUP);
 				}
 			}
 			SCSI_LOG_TIMEOUT(3, printk("sg_detach: dev=%d, dirty\n", k));
-			if (NULL == sdp->headfp) {
-				sg_dev_arr[k] = NULL;
-			}
 		} else {	/* nothing active, simple case */
 			SCSI_LOG_TIMEOUT(3, printk("sg_detach: dev=%d\n", k));
-			sg_dev_arr[k] = NULL;
 		}
+
+		sg_dev_arr[k] = NULL;
 		sg_nr_dev--;
 		break;
 	}
@@ -1639,14 +1710,32 @@
 		cdev_del(sdp->cdev);
 		sdp->cdev = NULL;
 		devfs_remove("%s/generic", scsidp->devfs_name);
-		put_disk(sdp->disk);
-		sdp->disk = NULL;
-		if (NULL == sdp->headfp)
-			kfree((char *) sdp);
+
+		down(&sg_ref_sem);
+		kref_put(&sdp->kref, scsi_generic_release);
+		up(&sg_ref_sem);
 	}
+}
 
-	if (delay)
-		msleep(10);	/* dirty detach so delay device destruction */
+/**
+ *      scsi_generic_release - Called to free the Sg_device structure
+ *      @kref: pointer to embedded kref
+ *
+ *      sg_ref_sem must be held entering this routine.  Because it is
+ *      called on last put, you should always use the scsi_generic_get()
+ *      and scsi_generic_put() helpers which manipulate the semaphore
+ *      directly and never do a direct kref_put().
+ **/
+static void scsi_generic_release(struct kref *kref)
+{
+	Sg_device *sdp = to_scsi_generic(kref);
+	struct gendisk *disk = sdp->disk;
+
+	disk->private_data = NULL;
+	put_disk(disk);
+
+	kfree((char *) sdp);
+	return;
 }
 
 /* Set 'perm' (4th argument) to 0 to disable module_param's definition
@@ -1698,6 +1787,9 @@
 static void __exit
 exit_sg(void)
 {
+	/* sg_cmd_done can schedule work... wait for it to complete. */
+	flush_scheduled_work();
+
 #ifdef CONFIG_SCSI_PROC_FS
 	sg_proc_cleanup();
 #endif				/* CONFIG_SCSI_PROC_FS */
@@ -2578,14 +2670,13 @@
 	sg_page_free((char *) sfp, sizeof (Sg_fd));
 }
 
-/* Returns 0 in normal case, 1 when detached and sdp object removed */
+/* Returns a count of IOs still in progress. */
 static int
 sg_remove_sfp(Sg_device * sdp, Sg_fd * sfp)
 {
 	Sg_request *srp;
 	Sg_request *tsrp;
 	int dirty = 0;
-	int res = 0;
 
 	for (srp = sfp->headrp; srp; srp = tsrp) {
 		tsrp = srp->nextrp;
@@ -2599,30 +2690,16 @@
 
 		write_lock_irqsave(&sg_dev_arr_lock, iflags);
 		__sg_remove_sfp(sdp, sfp);
-		if (sdp->detached && (NULL == sdp->headfp)) {
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
-			res = 1;
-		}
 		write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
 	} else {
-		/* MOD_INC's to inhibit unloading sg and associated adapter driver */
-		/* only bump the access_count if we actually succeeded in
-		 * throwing another counter on the host module */
-		scsi_device_get(sdp->device);	/* XXX: retval ignored? */	
+		/* The non-zero dirty count will be returned. This will tell
+		   the caller not to drop the reference on this device. */
+
 		sfp->closed = 1;	/* flag dirty state on this fd */
 		SCSI_LOG_TIMEOUT(1, printk("sg_remove_sfp: worrisome, %d writes pending\n",
 				  dirty));
 	}
-	return res;
+	return dirty;
 }
 
 static int

--------------060706020508000704070807--
