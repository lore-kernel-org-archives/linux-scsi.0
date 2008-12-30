From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH] sg: fix races during device removal
Date: Tue, 30 Dec 2008 10:40:04 -0500
Message-ID: <495A40D4.5030901@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([98.174.209.230]:1791 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbYL3PkH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Dec 2008 10:40:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

sg has the following races relating to device removal:

1) It is not safe for sg_remove() to access sdp after setting
sdp->detached = 1 and dropping sg_index_lock, since sg_release() or
sg_cmd_done() may call sg_remove_sfp(), which may free sdp.  I have seen
this race cause an oops.

2) It is not safe for sg_open() to access sdp (especially after
sleeping), since sg_remove() may free sdp anytime before sg_add_sfp() is
called.  Similarly, sg_add_sfp() is unsafe because sg_remove() may free
sdp anytime before the new sg_fd is linked into sdp->headfp.

3) It is not safe for sg_release() or sg_cmd_done() to access sdp after
calling sg_remove_sfp() (even if sg_remove_sfp() returns 0), because
once sdp->headfp == NULL, sg_remove() may free sdp.

4) It is not safe for sg_proc_* to access sdp, since sg_remove() may
free it at any time.

5) Various SCSI_LOG_TIMEOUT calls (e.g. in sg_release) use
sdp->disk->disk_name after sg_remove may have set sdp->disk to NULL.

This patch fixes these problems by adding a reference count to
sg_device.  If a function holds a pointer to a sg_device where the
pointer is not associated with a sg_fd that remains linked into headfp
for the entire duration of the function, then that function must
increment refcount while holding a write lock on sg_index_lock.  When
the function is done, sg_put_dev() decrements refcount and frees the
sg_device if there are no remaining references or sg_fd's.  Functions
like sg_read() and sg_write() do not need to increment the refcount
because the corresponding sg_fd will prevent the sg_device from being
freed.

When opening a fd, this patch moves the check for sdp->detached from
sg_open() to sg_add_sfp() so that it can be done while holding a write
lock on sg_index_lock.  This ensures that sg_open() doesn't succeed
after sg_remove() has been called.  Since sg_add_sfp() can now fail in
different ways, it returns an ERR_PTR() instead of NULL.  Also, if there
are multiple processes waiting to open the same device with O_EXCL, and
the device is deleted, then the error path in sg_open() that sets
sdp->exclude = 0 needs to wake up other processes that might be waiting
(this may not be a problem in practice due to lock_kernel() as long as
sg_open() never sleeps in between setting exclude = 1 and exclude = 0,
but it is better to be safe).

Since sg_remove_sfp()/__sg_remove_sfp() remove the sg_fd from sg_device,
any caller of these functions must increment the reference count ahead
of time and then call sg_put_dev() afterward.  This actually makes
things simpler, since there is no longer a need for sg_remove_sfp() to
return a value indicating if sg_device is still valid or not.

scsi_device_get()/scsi_device_put() usage is also simplified.
scsi_device_get() is called only from sg_open(), and scsi_device_put()
is called only from __sg_remove_sfp() and the error path in sg_open().

idr_remove() usage is also simplified; it is now called from
sg_put_dev() just before freeing sg_device.

put_disk() is now called from sg_put_dev() when all fds are closed and
the reference count drops to 0 instead of directly from sg_remove().
This fixes all the places sdp->disk->disk_name might be used after
sg_remove().

sg_get_dev() now uses a write lock on sg_index_lock instead of a read
lock so that it is safe to increment sdp->refcount.  Also, sg_get_dev()
must now be paired with sg_put_dev().

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---

I noticed these problems when running a test program that used the sg
driver to access SAS devices with mptsas.  When the SAS cable is
unplugged, mptsas automatically deletes the devices, and the test also
fails at the same time and closes its sg file descriptors.  Depending
on the timing, this would sometimes produce an oops due to the races
between deleting the device, closing the fds, and commands completing.

--- linux-2.6.28/drivers/scsi/sg.c.orig	2008-12-24 18:26:37.000000000 -0500
+++ linux-2.6.28/drivers/scsi/sg.c	2008-12-30 09:59:56.000000000 -0500
@@ -166,6 +166,13 @@ typedef struct sg_device { /* holds the 
 	int sg_tablesize;	/* adapter's max scatter-gather table size */
 	u32 index;		/* device index number */
 	Sg_fd *headfp;		/* first open fd belonging to this device */
+	/* To prevent races with device removal (sg_remove), if a function
+	   holds a pointer to a sg_device where the pointer is not associated
+	   with a sg_fd that remains linked into headfp for the entire duration
+	   of the function, then that function must increment refcount while
+	   holding a write lock on sg_index_lock.  When the function is done,
+	   call sg_put_dev(). */
+	int refcount;
 	volatile char detached;	/* 0->attached, 1->detached pending removal */
 	volatile char exclude;	/* opened for exclusive access */
 	char sgdebug;		/* 0->off, 1->sense, 9->dump dev, 10-> all devs */
@@ -194,13 +201,14 @@ static void sg_build_reserve(Sg_fd * sfp
 static void sg_link_reserve(Sg_fd * sfp, Sg_request * srp, int size);
 static void sg_unlink_reserve(Sg_fd * sfp, Sg_request * srp);
 static Sg_fd *sg_add_sfp(Sg_device * sdp, int dev);
-static int sg_remove_sfp(Sg_device * sdp, Sg_fd * sfp);
+static void sg_remove_sfp(Sg_device * sdp, Sg_fd * sfp);
 static void __sg_remove_sfp(Sg_device * sdp, Sg_fd * sfp);
 static Sg_request *sg_get_rq_mark(Sg_fd * sfp, int pack_id);
 static Sg_request *sg_add_request(Sg_fd * sfp);
 static int sg_remove_request(Sg_fd * sfp, Sg_request * srp);
 static int sg_res_in_use(Sg_fd * sfp);
 static Sg_device *sg_get_dev(int dev);
+static void sg_put_dev(Sg_device *sdp);
 #ifdef CONFIG_SCSI_PROC_FS
 static int sg_last_dev(void);
 #endif
@@ -238,10 +246,12 @@ sg_open(struct inode *inode, struct file
 	SCSI_LOG_TIMEOUT(3, printk("sg_open: dev=%d, flags=0x%x\n", dev, flags));
 	sdp = sg_get_dev(dev);
 	if ((!sdp) || (!sdp->device)) {
+		sg_put_dev(sdp);
 		unlock_kernel();
 		return -ENXIO;
 	}
 	if (sdp->detached) {
+		sg_put_dev(sdp);
 		unlock_kernel();
 		return -ENODEV;
 	}
@@ -250,6 +260,7 @@ sg_open(struct inode *inode, struct file
 	/* Prevent the device driver from vanishing while we sleep */
 	retval = scsi_device_get(sdp->device);
 	if (retval) {
+		sg_put_dev(sdp);
 		unlock_kernel();
 		return retval;
 	}
@@ -290,29 +301,30 @@ sg_open(struct inode *inode, struct file
 			goto error_out;
 		}
 	}
-	if (sdp->detached) {
-		retval = -ENODEV;
-		goto error_out;
-	}
 	if (!sdp->headfp) {	/* no existing opens on this device */
 		sdp->sgdebug = 0;
 		q = sdp->device->request_queue;
 		sdp->sg_tablesize = min(q->max_hw_segments,
 					q->max_phys_segments);
 	}
-	if ((sfp = sg_add_sfp(sdp, dev)))
+	sfp = sg_add_sfp(sdp, dev);
+	if (!IS_ERR(sfp))
 		filp->private_data = sfp;
 	else {
-		if (flags & O_EXCL)
+		if (flags & O_EXCL) {
 			sdp->exclude = 0;	/* undo if error */
-		retval = -ENOMEM;
+			wake_up_interruptible(&sdp->o_excl_wait);
+		}
+		retval = PTR_ERR(sfp);
 		goto error_out;
 	}
+	sg_put_dev(sdp);
 	unlock_kernel();
 	return 0;
 
       error_out:
 	scsi_device_put(sdp->device);
+	sg_put_dev(sdp);
 	unlock_kernel();
 	return retval;
 }
@@ -323,17 +335,18 @@ sg_release(struct inode *inode, struct f
 {
 	Sg_device *sdp;
 	Sg_fd *sfp;
+	unsigned long iflags;
 
 	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
 	SCSI_LOG_TIMEOUT(3, printk("sg_release: %s\n", sdp->disk->disk_name));
-	if (0 == sg_remove_sfp(sdp, sfp)) {	/* Returns 1 when sdp gone */
-		if (!sdp->detached) {
-			scsi_device_put(sdp->device);
-		}
-		sdp->exclude = 0;
-		wake_up_interruptible(&sdp->o_excl_wait);
-	}
+	write_lock_irqsave(&sg_index_lock, iflags);
+	sdp->refcount++;
+	write_unlock_irqrestore(&sg_index_lock, iflags);
+	sg_remove_sfp(sdp, sfp);
+	sdp->exclude = 0;
+	wake_up_interruptible(&sdp->o_excl_wait);
+	sg_put_dev(sdp);
 	return 0;
 }
 
@@ -1309,9 +1322,11 @@ static void sg_rq_end_io(struct request 
 		srp = NULL;
 		if (NULL == sfp->headrp) {
 			SCSI_LOG_TIMEOUT(1, printk("sg_cmd_done: already closed, final cleanup\n"));
-			if (0 == sg_remove_sfp(sdp, sfp)) {	/* device still present */
-				scsi_device_put(sdp->device);
-			}
+			write_lock_irqsave(&sg_index_lock, iflags);
+			sdp->refcount++;
+			write_unlock_irqrestore(&sg_index_lock, iflags);
+			sg_remove_sfp(sdp, sfp);
+			sg_put_dev(sdp);
 			sfp = NULL;
 		}
 	} else if (srp && srp->orphan) {
@@ -1500,48 +1515,39 @@ sg_remove(struct device *cl_dev, struct 
 	Sg_request *tsrp;
 	int delay;
 
-	if (!sdp)
+	if (!sdp || sdp->detached)
 		return;
 
 	delay = 0;
 	write_lock_irqsave(&sg_index_lock, iflags);
-	if (sdp->headfp) {
-		sdp->detached = 1;
-		for (sfp = sdp->headfp; sfp; sfp = tsfp) {
-			tsfp = sfp->nextfp;
-			for (srp = sfp->headrp; srp; srp = tsrp) {
-				tsrp = srp->nextrp;
-				if (sfp->closed || (0 == sg_srp_done(srp, sfp)))
-					sg_finish_rem_req(srp);
-			}
-			if (sfp->closed) {
-				scsi_device_put(sdp->device);
-				__sg_remove_sfp(sdp, sfp);
-			} else {
-				delay = 1;
-				wake_up_interruptible(&sfp->read_wait);
-				kill_fasync(&sfp->async_qp, SIGPOLL,
-					    POLL_HUP);
-			}
+	sdp->refcount++;
+	sdp->detached = 1;
+	for (sfp = sdp->headfp; sfp; sfp = tsfp) {
+		tsfp = sfp->nextfp;
+		for (srp = sfp->headrp; srp; srp = tsrp) {
+			tsrp = srp->nextrp;
+			if (sfp->closed || (0 == sg_srp_done(srp, sfp)))
+				sg_finish_rem_req(srp);
 		}
-		SCSI_LOG_TIMEOUT(3, printk("sg_remove: dev=%d, dirty\n", sdp->index));
-		if (NULL == sdp->headfp) {
-			idr_remove(&sg_index_idr, sdp->index);
+		if (sfp->closed) {
+			__sg_remove_sfp(sdp, sfp);
+		} else {
+			delay = 1;
+			wake_up_interruptible(&sfp->read_wait);
+			kill_fasync(&sfp->async_qp, SIGPOLL,
+				    POLL_HUP);
 		}
-	} else {	/* nothing active, simple case */
-		SCSI_LOG_TIMEOUT(3, printk("sg_remove: dev=%d\n", sdp->index));
-		idr_remove(&sg_index_idr, sdp->index);
 	}
+	SCSI_LOG_TIMEOUT(3, printk("sg_remove: dev=%d%s\n",
+				   sdp->index,
+				   (NULL == sdp->headfp) ? "" : ", dirty"));
 	write_unlock_irqrestore(&sg_index_lock, iflags);
 
 	sysfs_remove_link(&scsidp->sdev_gendev.kobj, "generic");
 	device_destroy(sg_sysfs_class, MKDEV(SCSI_GENERIC_MAJOR, sdp->index));
 	cdev_del(sdp->cdev);
 	sdp->cdev = NULL;
-	put_disk(sdp->disk);
-	sdp->disk = NULL;
-	if (NULL == sdp->headfp)
-		kfree(sdp);
+	sg_put_dev(sdp);
 
 	if (delay)
 		msleep(10);	/* dirty detach so delay device destruction */
@@ -2055,7 +2061,7 @@ sg_add_sfp(Sg_device * sdp, int dev)
 
 	sfp = kzalloc(sizeof(*sfp), GFP_ATOMIC | __GFP_NOWARN);
 	if (!sfp)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	init_waitqueue_head(&sfp->read_wait);
 	rwlock_init(&sfp->rq_list_lock);
@@ -2069,6 +2075,11 @@ sg_add_sfp(Sg_device * sdp, int dev)
 	sfp->keep_orphan = SG_DEF_KEEP_ORPHAN;
 	sfp->parentdp = sdp;
 	write_lock_irqsave(&sg_index_lock, iflags);
+	if (sdp->detached) {
+		write_unlock_irqrestore(&sg_index_lock, iflags);
+		kfree(sfp);
+		return ERR_PTR(-ENODEV);
+	}
 	if (!sdp->headfp)
 		sdp->headfp = sfp;
 	else {			/* add to tail of existing list */
@@ -2090,6 +2101,8 @@ sg_add_sfp(Sg_device * sdp, int dev)
 	return sfp;
 }
 
+/* note: increment sdp->refcount before calling this function and then call
+   sg_put_dev() afterward. */
 static void
 __sg_remove_sfp(Sg_device * sdp, Sg_fd * sfp)
 {
@@ -2114,19 +2127,20 @@ __sg_remove_sfp(Sg_device * sdp, Sg_fd *
 			(int) sfp->reserve.bufflen, (int) sfp->reserve.k_use_sg));
 		sg_remove_scat(&sfp->reserve);
 	}
+	scsi_device_put(sdp->device);
 	sfp->parentdp = NULL;
 	SCSI_LOG_TIMEOUT(6, printk("__sg_remove_sfp:    sfp=0x%p\n", sfp));
 	kfree(sfp);
 }
 
-/* Returns 0 in normal case, 1 when detached and sdp object removed */
-static int
+/* note: increment sdp->refcount before calling this function and then call
+   sg_put_dev() afterward. */
+static void
 sg_remove_sfp(Sg_device * sdp, Sg_fd * sfp)
 {
 	Sg_request *srp;
 	Sg_request *tsrp;
 	int dirty = 0;
-	int res = 0;
 
 	for (srp = sfp->headrp; srp; srp = tsrp) {
 		tsrp = srp->nextrp;
@@ -2140,22 +2154,12 @@ sg_remove_sfp(Sg_device * sdp, Sg_fd * s
 
 		write_lock_irqsave(&sg_index_lock, iflags);
 		__sg_remove_sfp(sdp, sfp);
-		if (sdp->detached && (NULL == sdp->headfp)) {
-			idr_remove(&sg_index_idr, sdp->index);
-			kfree(sdp);
-			res = 1;
-		}
 		write_unlock_irqrestore(&sg_index_lock, iflags);
 	} else {
-		/* MOD_INC's to inhibit unloading sg and associated adapter driver */
-		/* only bump the access_count if we actually succeeded in
-		 * throwing another counter on the host module */
-		scsi_device_get(sdp->device);	/* XXX: retval ignored? */	
 		sfp->closed = 1;	/* flag dirty state on this fd */
 		SCSI_LOG_TIMEOUT(1, printk("sg_remove_sfp: worrisome, %d writes pending\n",
 				  dirty));
 	}
-	return res;
 }
 
 static int
@@ -2203,13 +2207,33 @@ sg_get_dev(int dev)
 	Sg_device *sdp;
 	unsigned long iflags;
 
-	read_lock_irqsave(&sg_index_lock, iflags);
+	/* Need a write lock to increment refcount without using atomic ops. */
+	write_lock_irqsave(&sg_index_lock, iflags);
 	sdp = idr_find(&sg_index_idr, dev);
-	read_unlock_irqrestore(&sg_index_lock, iflags);
+	if (sdp != NULL)
+		sdp->refcount++;
+	write_unlock_irqrestore(&sg_index_lock, iflags);
 
 	return sdp;
 }
 
+static void
+sg_put_dev(Sg_device *sdp)
+{
+	unsigned long iflags;
+
+	if (sdp == NULL)
+		return;
+
+	write_lock_irqsave(&sg_index_lock, iflags);
+	if (--sdp->refcount == 0 && sdp->detached && NULL == sdp->headfp) {
+		idr_remove(&sg_index_idr, sdp->index);
+		put_disk(sdp->disk);
+		kfree(sdp);
+	}
+	write_unlock_irqrestore(&sg_index_lock, iflags);
+}
+
 #ifdef CONFIG_SCSI_PROC_FS
 
 static struct proc_dir_entry *sg_proc_sgp = NULL;
@@ -2478,6 +2502,7 @@ static int sg_proc_seq_show_dev(struct s
 			      (int) scsi_device_online(scsidp));
 	else
 		seq_printf(s, "-1\t-1\t-1\t-1\t-1\t-1\t-1\t-1\t-1\n");
+	sg_put_dev(sdp);
 	return 0;
 }
 
@@ -2498,6 +2523,7 @@ static int sg_proc_seq_show_devstrs(stru
 			   scsidp->vendor, scsidp->model, scsidp->rev);
 	else
 		seq_printf(s, "<no active device>\n");
+	sg_put_dev(sdp);
 	return 0;
 }
 
@@ -2582,7 +2608,7 @@ static int sg_proc_seq_show_debug(struct
 		if (NULL == scsidp) {
 			seq_printf(s, "device %d detached ??\n", 
 				   (int)it->index);
-			return 0;
+			goto err_out;
 		}
 
 		if (sg_get_nth_sfp(sdp, 0)) {
@@ -2602,6 +2628,8 @@ static int sg_proc_seq_show_debug(struct
 		}
 		sg_proc_debug_helper(s, sdp);
 	}
+err_out:
+	sg_put_dev(sdp);
 	return 0;
 }
 


