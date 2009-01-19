From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH 1/2] sg: fix races during device removal (v4)
Date: Mon, 19 Jan 2009 18:03:11 -0500
Message-ID: <497506AF.6040109@cybernetics.com>
References: <49625A67.3000304@cybernetics.com>	<20090111022525I.fujita.tomonori@lab.ntt.co.jp>	<496E4B93.4000507@cybernetics.com> <20090119155509Y.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([98.174.209.230]:1458 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbZASXDN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Jan 2009 18:03:13 -0500
In-Reply-To: <20090119155509Y.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, dgilbert@interlog.com, hch@infradead.org, linux-scsi@vger.kernel.org

sg has the following problems related to device removal:

* opening a sg fd races with removing a device
* closing a sg fd races with removing a device
* /proc/scsi/sg/* access races with removing a device
* command completion races with removing a device
* command completion races with closing a sg fd
* can rmmod sg with active commands

These problems can cause kernel oopses, memory-use-after-free, or
double-free errors.  This patch fixes these problems by using krefs
to manage the lifetime of sg_device and sg_fd.

Each command submitted to the midlevel holds a reference to sg_fd
until the completion callback.  This ensures that sg_fd doesn't go
away if the fd is closed with commands still outstanding.

sg_fd gets the reference of sg_device (with scsi_device) and also
makes sure that the sg module doesn't go away.

/proc/scsi/sg/* functions don't play nicely with krefs because they
give information about sg_fds which have been closed but not yet
freed due to still having outstanding commands and sg_devices which
have been removed but not yet freed due to still being referenced
by one or more sg_fds.  To deal with this safely without removing
functionality, /proc functions now access sg_device and sg_fd while
holding a lock instead of using kref_get()/kref_put().

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---

This version implements Fujita's suggestion to use locking instead
of kref_get() for the /proc functions.

This version does not use any controversial extensions to the kref API.

To avoid changing the behavior of the /proc functions, it is still
possible to find a sg_fd or a sg_device with a refcount of 0,
since the last remaining references are removed from the kref_put()
release functions.  However, no one should be doing a kref_get()
under these circumstances, so it shouldn't cause a problem.  I added
some comments warning about this non-standard behavior to reduce the
risk of tripping up someone in the future.

The original sg_open() would return -ENXIO if idr_find() returned
NULL but -ENODEV if sdp->detached.  It would be inconvenient to
keep this behavior without inlining sg_get_dev() into sg_open().
Since sg_open() was the only remaining caller anyway, I went ahead
and inlined it and removed sg_get_dev(), thereby enabling sg_open()
to return the same error codes as before.

This version still passes all the tests listed previously.  However,
mptscsih.c still needs some fixes; I will submit a patch for that
later.

 sg.c |  386 ++++++++++++++++++++++++++++++++-----------------------------------
 1 file changed, 186 insertions(+), 200 deletions(-)

--- linux-2.6.29-rc2/drivers/scsi/sg.c.orig	2009-01-19 16:19:01.000000000 -0500
+++ linux-2.6.29-rc2/drivers/scsi/sg.c	2009-01-19 16:26:21.000000000 -0500
@@ -101,6 +101,7 @@ static int scatter_elem_sz_prev = SG_SCA
 #define SG_SECTOR_MSK (SG_SECTOR_SZ - 1)
 
 static int sg_add(struct device *, struct class_interface *);
+static void sg_device_destroy(struct kref *kref);
 static void sg_remove(struct device *, struct class_interface *);
 
 static DEFINE_IDR(sg_index_idr);
@@ -158,6 +159,12 @@ typedef struct sg_fd {		/* holds the sta
 	char next_cmd_len;	/* 0 -> automatic (def), >0 -> use on next write() */
 	char keep_orphan;	/* 0 -> drop orphan (def), 1 -> keep for read() */
 	char mmap_called;	/* 0 -> mmap() never called on this fd */
+	/* CAUTION!  sfp is unlinked from sdp->headfp AFTER the refcount drops
+	   to 0.  When scanning sdp->headfp, it is not safe to call
+	   kref_get(&sfp->f_ref) if sfp->closed because the refcount may
+	   already be 0. */
+	struct kref f_ref;
+	struct execute_work ew;
 } Sg_fd;
 
 typedef struct sg_device { /* holds the state of each scsi generic device */
@@ -171,6 +178,22 @@ typedef struct sg_device { /* holds the 
 	char sgdebug;		/* 0->off, 1->sense, 9->dump dev, 10-> all devs */
 	struct gendisk *disk;
 	struct cdev * cdev;	/* char_dev [sysfs: /sys/cdev/major/sg<n>] */
+	/* CAUTION!  idr_remove() is called AFTER the refcount drops to 0.
+	   When using idr_find(), it is not safe to call kref_get(&sdp->d_ref)
+	   if sdp->detached because the refcount may already be 0.
+
+	   In order to get a reference safely using idr_find():
+	   1) lock sg_index_lock (either read or write lock)
+	   2) call idr_find()
+	   3) if sdp->detached, pretend that idr_find() returned NULL, and do
+	      not call kref_get()
+	   4) if !sdp->detached, then kref_get(&sdp->d_ref)
+	   5) unlock sg_index_lock
+
+	   Alternately, you can use idr_find() to access the device even if
+	   sdp->detached if you do not drop sg_index_lock, in which case you
+	   should NOT call kref_get(&sdp->d_ref). */
+	struct kref d_ref;
 } Sg_device;
 
 static int sg_fasync(int fd, struct file *filp, int mode);
@@ -194,13 +217,11 @@ static void sg_build_reserve(Sg_fd * sfp
 static void sg_link_reserve(Sg_fd * sfp, Sg_request * srp, int size);
 static void sg_unlink_reserve(Sg_fd * sfp, Sg_request * srp);
 static Sg_fd *sg_add_sfp(Sg_device * sdp, int dev);
-static int sg_remove_sfp(Sg_device * sdp, Sg_fd * sfp);
-static void __sg_remove_sfp(Sg_device * sdp, Sg_fd * sfp);
+static void sg_remove_sfp(struct kref *);
 static Sg_request *sg_get_rq_mark(Sg_fd * sfp, int pack_id);
 static Sg_request *sg_add_request(Sg_fd * sfp);
 static int sg_remove_request(Sg_fd * sfp, Sg_request * srp);
 static int sg_res_in_use(Sg_fd * sfp);
-static Sg_device *sg_get_dev(int dev);
 #ifdef CONFIG_SCSI_PROC_FS
 static int sg_last_dev(void);
 #endif
@@ -236,23 +257,30 @@ sg_open(struct inode *inode, struct file
 	lock_kernel();
 	nonseekable_open(inode, filp);
 	SCSI_LOG_TIMEOUT(3, printk("sg_open: dev=%d, flags=0x%x\n", dev, flags));
-	sdp = sg_get_dev(dev);
-	if ((!sdp) || (!sdp->device)) {
-		unlock_kernel();
-		return -ENXIO;
-	}
-	if (sdp->detached) {
-		unlock_kernel();
-		return -ENODEV;
+
+	retval = -ENXIO;
+	read_lock_irq(&sg_index_lock);
+	sdp = idr_find(&sg_index_idr, dev);
+	if (sdp) {
+		/* See comments about using idr_find() and d_ref.  If
+		   sdp->detached, then the refcount may already be 0, in which
+		   case it would be a bug to do kref_get(). */
+		if (!sdp->detached)
+			kref_get(&sdp->d_ref);
+		else {
+			sdp = NULL;
+			retval = -ENODEV;
+		}
 	}
+	read_unlock_irq(&sg_index_lock);
+	if ((!sdp) || (!sdp->device))
+		goto sg_put;
 
 	/* This driver's module count bumped by fops_get in <linux/fs.h> */
 	/* Prevent the device driver from vanishing while we sleep */
 	retval = scsi_device_get(sdp->device);
-	if (retval) {
-		unlock_kernel();
-		return retval;
-	}
+	if (retval)
+		goto sg_put;
 
 	if (!((flags & O_NONBLOCK) ||
 	      scsi_block_when_processing_errors(sdp->device))) {
@@ -303,16 +331,20 @@ sg_open(struct inode *inode, struct file
 	if ((sfp = sg_add_sfp(sdp, dev)))
 		filp->private_data = sfp;
 	else {
-		if (flags & O_EXCL)
+		if (flags & O_EXCL) {
 			sdp->exclude = 0;	/* undo if error */
+			wake_up_interruptible(&sdp->o_excl_wait);
+		}
 		retval = -ENOMEM;
 		goto error_out;
 	}
-	unlock_kernel();
-	return 0;
-
-      error_out:
-	scsi_device_put(sdp->device);
+	retval = 0;
+error_out:
+	if (retval)
+		scsi_device_put(sdp->device);
+sg_put:
+	if (sdp)
+		kref_put(&sdp->d_ref, sg_device_destroy);
 	unlock_kernel();
 	return retval;
 }
@@ -327,13 +359,14 @@ sg_release(struct inode *inode, struct f
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
+
+	sfp->closed = 1;
+
+	sdp->exclude = 0;
+	wake_up_interruptible(&sdp->o_excl_wait);
+
+	kref_put(&sfp->f_ref, sg_remove_sfp);
+
 	return 0;
 }
 
@@ -755,6 +788,7 @@ sg_common_write(Sg_fd * sfp, Sg_request 
 	hp->duration = jiffies_to_msecs(jiffies);
 
 	srp->rq->timeout = timeout;
+	kref_get(&sfp->f_ref); /* sg_rq_end_io() does kref_put(). */
 	blk_execute_rq_nowait(sdp->device->request_queue, sdp->disk,
 			      srp->rq, 1, sg_rq_end_io);
 	return 0;
@@ -1247,25 +1281,28 @@ sg_mmap(struct file *filp, struct vm_are
 static void sg_rq_end_io(struct request *rq, int uptodate)
 {
 	struct sg_request *srp = rq->end_io_data;
-	Sg_device *sdp = NULL;
+	Sg_device *sdp;
 	Sg_fd *sfp;
 	unsigned long iflags;
 	unsigned int ms;
 	char *sense;
-	int result, resid;
+	int result, resid, done = 1;
 
-	if (NULL == srp) {
-		printk(KERN_ERR "sg_cmd_done: NULL request\n");
+	if (unlikely(NULL == srp)) { /* shouldn't happen */
+		printk(KERN_ERR "sg_rq_end_io: NULL request\n");
 		return;
 	}
+
 	sfp = srp->parentfp;
-	if (sfp)
-		sdp = sfp->parentdp;
-	if ((NULL == sdp) || sdp->detached) {
-		printk(KERN_INFO "sg_cmd_done: device detached\n");
+	if (unlikely(NULL == sfp)) { /* shouldn't happen */
+		printk(KERN_ERR "sg_rq_end_io: NULL sg_fd\n");
 		return;
 	}
 
+	sdp = sfp->parentdp;
+	if (unlikely(sdp->detached))
+		printk(KERN_INFO "sg_rq_end_io: device detached\n");
+
 	sense = rq->sense;
 	result = rq->errors;
 	resid = rq->data_len;
@@ -1303,33 +1340,25 @@ static void sg_rq_end_io(struct request 
 	}
 	/* Rely on write phase to clean out srp status values, so no "else" */
 
-	if (sfp->closed) {	/* whoops this fd already released, cleanup */
-		SCSI_LOG_TIMEOUT(1, printk("sg_cmd_done: already closed, freeing ...\n"));
-		sg_finish_rem_req(srp);
-		srp = NULL;
-		if (NULL == sfp->headrp) {
-			SCSI_LOG_TIMEOUT(1, printk("sg_cmd_done: already closed, final cleanup\n"));
-			if (0 == sg_remove_sfp(sdp, sfp)) {	/* device still present */
-				scsi_device_put(sdp->device);
-			}
-			sfp = NULL;
-		}
-	} else if (srp && srp->orphan) {
+	write_lock_irqsave(&sfp->rq_list_lock, iflags);
+	if (unlikely(srp->orphan)) {
 		if (sfp->keep_orphan)
 			srp->sg_io_owned = 0;
-		else {
-			sg_finish_rem_req(srp);
-			srp = NULL;
-		}
+		else
+			done = 0;
 	}
-	if (sfp && srp) {
-		/* Now wake up any sg_read() that is waiting for this packet. */
-		kill_fasync(&sfp->async_qp, SIGPOLL, POLL_IN);
-		write_lock_irqsave(&sfp->rq_list_lock, iflags);
-		srp->done = 1;
+	srp->done = done;
+	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
+
+	if (likely(done)) {
+		/* Now wake up any sg_read() that is waiting for this
+		   packet. */
 		wake_up_interruptible(&sfp->read_wait);
-		write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
-	}
+		kill_fasync(&sfp->async_qp, SIGPOLL, POLL_IN);
+	} else
+		sg_finish_rem_req(srp); /* call with srp->done == 0 */
+
+	kref_put(&sfp->f_ref, sg_remove_sfp);
 }
 
 static struct file_operations sg_fops = {
@@ -1391,6 +1420,7 @@ static Sg_device *sg_alloc(struct gendis
 	init_waitqueue_head(&sdp->o_excl_wait);
 	sdp->sg_tablesize = min(q->max_hw_segments, q->max_phys_segments);
 	sdp->index = k;
+	kref_init(&sdp->d_ref);
 
 	error = 0;
  out:
@@ -1488,49 +1518,45 @@ out:
 	return error;
 }
 
-static void
-sg_remove(struct device *cl_dev, struct class_interface *cl_intf)
+static void sg_device_destroy(struct kref *kref)
+{
+	struct sg_device *sdp = container_of(kref, struct sg_device, d_ref);
+	unsigned long flags;
+
+	/* CAUTION!  Note that the device can still be found via idr_find()
+	   even though the refcount is 0.  Therefore, do idr_remove() BEFORE
+	   any other cleanup. */
+
+	write_lock_irqsave(&sg_index_lock, flags);
+	idr_remove(&sg_index_idr, sdp->index);
+	write_unlock_irqrestore(&sg_index_lock, flags);
+
+	SCSI_LOG_TIMEOUT(3,
+		printk("sg_device_destroy: %s\n",
+			sdp->disk->disk_name));
+
+	put_disk(sdp->disk);
+	kfree(sdp);
+}
+
+static void sg_remove(struct device *cl_dev, struct class_interface *cl_intf)
 {
 	struct scsi_device *scsidp = to_scsi_device(cl_dev->parent);
 	Sg_device *sdp = dev_get_drvdata(cl_dev);
 	unsigned long iflags;
 	Sg_fd *sfp;
-	Sg_fd *tsfp;
-	Sg_request *srp;
-	Sg_request *tsrp;
-	int delay;
 
-	if (!sdp)
+	if (!sdp || sdp->detached)
 		return;
 
-	delay = 0;
+	SCSI_LOG_TIMEOUT(3, printk("sg_remove: %s\n", sdp->disk->disk_name));
+
+	/* Need a write lock to set sdp->detached. */
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
-		}
-		SCSI_LOG_TIMEOUT(3, printk("sg_remove: dev=%d, dirty\n", sdp->index));
-		if (NULL == sdp->headfp) {
-			idr_remove(&sg_index_idr, sdp->index);
-		}
-	} else {	/* nothing active, simple case */
-		SCSI_LOG_TIMEOUT(3, printk("sg_remove: dev=%d\n", sdp->index));
-		idr_remove(&sg_index_idr, sdp->index);
+	sdp->detached = 1;
+	for (sfp = sdp->headfp; sfp; sfp = sfp->nextfp) {
+		wake_up_interruptible(&sfp->read_wait);
+		kill_fasync(&sfp->async_qp, SIGPOLL, POLL_HUP);
 	}
 	write_unlock_irqrestore(&sg_index_lock, iflags);
 
@@ -1538,13 +1564,8 @@ sg_remove(struct device *cl_dev, struct 
 	device_destroy(sg_sysfs_class, MKDEV(SCSI_GENERIC_MAJOR, sdp->index));
 	cdev_del(sdp->cdev);
 	sdp->cdev = NULL;
-	put_disk(sdp->disk);
-	sdp->disk = NULL;
-	if (NULL == sdp->headfp)
-		kfree(sdp);
 
-	if (delay)
-		msleep(10);	/* dirty detach so delay device destruction */
+	kref_put(&sdp->d_ref, sg_device_destroy);
 }
 
 module_param_named(scatter_elem_sz, scatter_elem_sz, int, S_IRUGO | S_IWUSR);
@@ -1941,22 +1962,6 @@ sg_get_rq_mark(Sg_fd * sfp, int pack_id)
 	return resp;
 }
 
-#ifdef CONFIG_SCSI_PROC_FS
-static Sg_request *
-sg_get_nth_request(Sg_fd * sfp, int nth)
-{
-	Sg_request *resp;
-	unsigned long iflags;
-	int k;
-
-	read_lock_irqsave(&sfp->rq_list_lock, iflags);
-	for (k = 0, resp = sfp->headrp; resp && (k < nth);
-	     ++k, resp = resp->nextrp) ;
-	read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
-	return resp;
-}
-#endif
-
 /* always adds to end of list */
 static Sg_request *
 sg_add_request(Sg_fd * sfp)
@@ -2032,22 +2037,6 @@ sg_remove_request(Sg_fd * sfp, Sg_reques
 	return res;
 }
 
-#ifdef CONFIG_SCSI_PROC_FS
-static Sg_fd *
-sg_get_nth_sfp(Sg_device * sdp, int nth)
-{
-	Sg_fd *resp;
-	unsigned long iflags;
-	int k;
-
-	read_lock_irqsave(&sg_index_lock, iflags);
-	for (k = 0, resp = sdp->headfp; resp && (k < nth);
-	     ++k, resp = resp->nextfp) ;
-	read_unlock_irqrestore(&sg_index_lock, iflags);
-	return resp;
-}
-#endif
-
 static Sg_fd *
 sg_add_sfp(Sg_device * sdp, int dev)
 {
@@ -2062,6 +2051,7 @@ sg_add_sfp(Sg_device * sdp, int dev)
 	init_waitqueue_head(&sfp->read_wait);
 	rwlock_init(&sfp->rq_list_lock);
 
+	kref_init(&sfp->f_ref);
 	sfp->timeout = SG_DEFAULT_TIMEOUT;
 	sfp->timeout_user = SG_DEFAULT_TIMEOUT_USER;
 	sfp->force_packid = SG_DEF_FORCE_PACK_ID;
@@ -2089,15 +2079,53 @@ sg_add_sfp(Sg_device * sdp, int dev)
 	sg_build_reserve(sfp, bufflen);
 	SCSI_LOG_TIMEOUT(3, printk("sg_add_sfp:   bufflen=%d, k_use_sg=%d\n",
 			   sfp->reserve.bufflen, sfp->reserve.k_use_sg));
+
+	kref_get(&sdp->d_ref);
+	__module_get(THIS_MODULE);
 	return sfp;
 }
 
-static void
-__sg_remove_sfp(Sg_device * sdp, Sg_fd * sfp)
+static void sg_remove_sfp_usercontext(struct work_struct *work)
+{
+	struct sg_fd *sfp = container_of(work, struct sg_fd, ew.work);
+	struct sg_device *sdp = sfp->parentdp;
+
+	/* Cleanup any responses which were never read(). */
+	while (sfp->headrp)
+		sg_finish_rem_req(sfp->headrp);
+
+	if (sfp->reserve.bufflen > 0) {
+		SCSI_LOG_TIMEOUT(6,
+			printk("sg_remove_sfp:    bufflen=%d, k_use_sg=%d\n",
+				(int) sfp->reserve.bufflen,
+				(int) sfp->reserve.k_use_sg));
+		sg_remove_scat(&sfp->reserve);
+	}
+
+	SCSI_LOG_TIMEOUT(6,
+		printk("sg_remove_sfp: %s, sfp=0x%p\n",
+			sdp->disk->disk_name,
+			sfp));
+	kfree(sfp);
+
+	scsi_device_put(sdp->device);
+	kref_put(&sdp->d_ref, sg_device_destroy);
+	module_put(THIS_MODULE);
+}
+
+static void sg_remove_sfp(struct kref *kref)
 {
+	struct sg_fd *sfp = container_of(kref, struct sg_fd, f_ref);
+	struct sg_device *sdp = sfp->parentdp;
 	Sg_fd *fp;
 	Sg_fd *prev_fp;
+	unsigned long iflags;
+
+	/* CAUTION!  Note that sfp can still be found by walking sdp->headfp
+	   even though the refcount is now 0.  Therefore, unlink sfp from
+	   sdp->headfp BEFORE doing any other cleanup. */
 
+	write_lock_irqsave(&sg_index_lock, iflags);
 	prev_fp = sdp->headfp;
 	if (sfp == prev_fp)
 		sdp->headfp = prev_fp->nextfp;
@@ -2110,54 +2138,10 @@ __sg_remove_sfp(Sg_device * sdp, Sg_fd *
 			prev_fp = fp;
 		}
 	}
-	if (sfp->reserve.bufflen > 0) {
-		SCSI_LOG_TIMEOUT(6, 
-			printk("__sg_remove_sfp:    bufflen=%d, k_use_sg=%d\n",
-			(int) sfp->reserve.bufflen, (int) sfp->reserve.k_use_sg));
-		sg_remove_scat(&sfp->reserve);
-	}
-	sfp->parentdp = NULL;
-	SCSI_LOG_TIMEOUT(6, printk("__sg_remove_sfp:    sfp=0x%p\n", sfp));
-	kfree(sfp);
-}
-
-/* Returns 0 in normal case, 1 when detached and sdp object removed */
-static int
-sg_remove_sfp(Sg_device * sdp, Sg_fd * sfp)
-{
-	Sg_request *srp;
-	Sg_request *tsrp;
-	int dirty = 0;
-	int res = 0;
-
-	for (srp = sfp->headrp; srp; srp = tsrp) {
-		tsrp = srp->nextrp;
-		if (sg_srp_done(srp, sfp))
-			sg_finish_rem_req(srp);
-		else
-			++dirty;
-	}
-	if (0 == dirty) {
-		unsigned long iflags;
+	write_unlock_irqrestore(&sg_index_lock, iflags);
+	wake_up_interruptible(&sdp->o_excl_wait);
 
-		write_lock_irqsave(&sg_index_lock, iflags);
-		__sg_remove_sfp(sdp, sfp);
-		if (sdp->detached && (NULL == sdp->headfp)) {
-			idr_remove(&sg_index_idr, sdp->index);
-			kfree(sdp);
-			res = 1;
-		}
-		write_unlock_irqrestore(&sg_index_lock, iflags);
-	} else {
-		/* MOD_INC's to inhibit unloading sg and associated adapter driver */
-		/* only bump the access_count if we actually succeeded in
-		 * throwing another counter on the host module */
-		scsi_device_get(sdp->device);	/* XXX: retval ignored? */	
-		sfp->closed = 1;	/* flag dirty state on this fd */
-		SCSI_LOG_TIMEOUT(1, printk("sg_remove_sfp: worrisome, %d writes pending\n",
-				  dirty));
-	}
-	return res;
+	execute_in_process_context(sg_remove_sfp_usercontext, &sfp->ew);
 }
 
 static int
@@ -2199,19 +2183,6 @@ sg_last_dev(void)
 }
 #endif
 
-static Sg_device *
-sg_get_dev(int dev)
-{
-	Sg_device *sdp;
-	unsigned long iflags;
-
-	read_lock_irqsave(&sg_index_lock, iflags);
-	sdp = idr_find(&sg_index_idr, dev);
-	read_unlock_irqrestore(&sg_index_lock, iflags);
-
-	return sdp;
-}
-
 #ifdef CONFIG_SCSI_PROC_FS
 
 static struct proc_dir_entry *sg_proc_sgp = NULL;
@@ -2468,8 +2439,10 @@ static int sg_proc_seq_show_dev(struct s
 	struct sg_proc_deviter * it = (struct sg_proc_deviter *) v;
 	Sg_device *sdp;
 	struct scsi_device *scsidp;
+	unsigned long iflags;
 
-	sdp = it ? sg_get_dev(it->index) : NULL;
+	read_lock_irqsave(&sg_index_lock, iflags);
+	sdp = it ? idr_find(&sg_index_idr, it->index) : NULL;
 	if (sdp && (scsidp = sdp->device) && (!sdp->detached))
 		seq_printf(s, "%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n",
 			      scsidp->host->host_no, scsidp->channel,
@@ -2480,6 +2453,7 @@ static int sg_proc_seq_show_dev(struct s
 			      (int) scsi_device_online(scsidp));
 	else
 		seq_printf(s, "-1\t-1\t-1\t-1\t-1\t-1\t-1\t-1\t-1\n");
+	read_unlock_irqrestore(&sg_index_lock, iflags);
 	return 0;
 }
 
@@ -2493,13 +2467,16 @@ static int sg_proc_seq_show_devstrs(stru
 	struct sg_proc_deviter * it = (struct sg_proc_deviter *) v;
 	Sg_device *sdp;
 	struct scsi_device *scsidp;
+	unsigned long iflags;
 
-	sdp = it ? sg_get_dev(it->index) : NULL;
+	read_lock_irqsave(&sg_index_lock, iflags);
+	sdp = it ? idr_find(&sg_index_idr, it->index) : NULL;
 	if (sdp && (scsidp = sdp->device) && (!sdp->detached))
 		seq_printf(s, "%8.8s\t%16.16s\t%4.4s\n",
 			   scsidp->vendor, scsidp->model, scsidp->rev);
 	else
 		seq_printf(s, "<no active device>\n");
+	read_unlock_irqrestore(&sg_index_lock, iflags);
 	return 0;
 }
 
@@ -2512,7 +2489,8 @@ static void sg_proc_debug_helper(struct 
 	const char * cp;
 	unsigned int ms;
 
-	for (k = 0; (fp = sg_get_nth_sfp(sdp, k)); ++k) {
+	for (k = 0, fp = sdp->headfp; fp != NULL; ++k, fp = fp->nextfp) {
+		read_lock(&fp->rq_list_lock); /* irqs already disabled */
 		seq_printf(s, "   FD(%d): timeout=%dms bufflen=%d "
 			   "(res)sgat=%d low_dma=%d\n", k + 1,
 			   jiffies_to_msecs(fp->timeout),
@@ -2522,7 +2500,9 @@ static void sg_proc_debug_helper(struct 
 		seq_printf(s, "   cmd_q=%d f_packid=%d k_orphan=%d closed=%d\n",
 			   (int) fp->cmd_q, (int) fp->force_packid,
 			   (int) fp->keep_orphan, (int) fp->closed);
-		for (m = 0; (srp = sg_get_nth_request(fp, m)); ++m) {
+		for (m = 0, srp = fp->headrp;
+				srp != NULL;
+				++m, srp = srp->nextrp) {
 			hp = &srp->header;
 			new_interface = (hp->interface_id == '\0') ? 0 : 1;
 			if (srp->res_used) {
@@ -2559,6 +2539,7 @@ static void sg_proc_debug_helper(struct 
 		}
 		if (0 == m)
 			seq_printf(s, "     No requests active\n");
+		read_unlock(&fp->rq_list_lock);
 	}
 }
 
@@ -2571,23 +2552,26 @@ static int sg_proc_seq_show_debug(struct
 {
 	struct sg_proc_deviter * it = (struct sg_proc_deviter *) v;
 	Sg_device *sdp;
+	unsigned long iflags;
 
 	if (it && (0 == it->index)) {
 		seq_printf(s, "max_active_device=%d(origin 1)\n",
 			   (int)it->max);
 		seq_printf(s, " def_reserved_size=%d\n", sg_big_buff);
 	}
-	sdp = it ? sg_get_dev(it->index) : NULL;
+
+	read_lock_irqsave(&sg_index_lock, iflags);
+	sdp = it ? idr_find(&sg_index_idr, it->index) : NULL;
 	if (sdp) {
 		struct scsi_device *scsidp = sdp->device;
 
 		if (NULL == scsidp) {
 			seq_printf(s, "device %d detached ??\n", 
 				   (int)it->index);
-			return 0;
+			goto out;
 		}
 
-		if (sg_get_nth_sfp(sdp, 0)) {
+		if (sdp->headfp) {
 			seq_printf(s, " >>> device=%s ",
 				sdp->disk->disk_name);
 			if (sdp->detached)
@@ -2604,6 +2588,8 @@ static int sg_proc_seq_show_debug(struct
 		}
 		sg_proc_debug_helper(s, sdp);
 	}
+out:
+	read_unlock_irqrestore(&sg_index_lock, iflags);
 	return 0;
 }
 


