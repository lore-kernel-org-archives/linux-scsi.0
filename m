From: Tony Battersby <tonyb@cybernetics.com>
Subject: Re: Backport of: [SCSI] sg: fix races during device removal--OK?
Date: Fri, 17 Jul 2009 09:29:57 -0400
Message-ID: <4A607CD5.9050206@cybernetics.com>
References: <1247783318.8762.134.camel@psmith-ubeta.netezza.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([98.174.209.230]:4237 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934636AbZGQN5A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jul 2009 09:57:00 -0400
In-Reply-To: <1247783318.8762.134.camel@psmith-ubeta.netezza.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: paul@mad-scientist.net
Cc: linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

Paul Smith wrote:
> Hi all.  We are using the current Linux 2.6.27.26 stable kernel on an
> embedded system.  We are seeing some SCSI issues, and the fix (log entry
> below) that went into 2.6.28.10 seems relevant.  We backported it to our
> version of the kernel, as included below.
>
> Most things applied without any issue but there were a few areas that
> had to be changed for 2.6.27; see the marked diffs for sg_release() and
> sg_common_write().
>
> I wonder if anyone has any comments on this: problems with the backport
> or other issues we might run into.
>
> Thanks!
>
>   
I am also using 2.6.27.26 in an embedded system.  Below is the patch
that I have been using.  It is different from your patch in two ways:

1) Your patch incorrectly removes sg_fasync() from sg_release().
sg_fasync() was removed in 2.6.28 by commit
233e70f4228e78eb2f80dc6650f65d3ae3dbf17c "saner FASYNC handling on
file close", but it should still be present in 2.6.27.

2) My patch calls kref_put() if scsi_execute_async() returns an error.
This situation doesn't arise in 2.6.28, since that kernel calls
blk_execute_rq_nowait() (which doesn't fail) instead of
scsi_execute_async() (which can fail).

Tony Battersby
Cybernetics

--- linux-2.6.27.26/drivers/scsi/sg.c.orig	2008-10-09 18:13:53.000000000 -0400
+++ linux-2.6.27.26/drivers/scsi/sg.c	2009-07-17 09:08:55.000000000 -0400
@@ -103,6 +103,7 @@ static int scatter_elem_sz_prev = SG_SCA
 #define SG_SECTOR_MSK (SG_SECTOR_SZ - 1)
 
 static int sg_add(struct device *, struct class_interface *);
+static void sg_device_destroy(struct kref *kref);
 static void sg_remove(struct device *, struct class_interface *);
 
 static DEFINE_IDR(sg_index_idr);
@@ -158,6 +159,8 @@ typedef struct sg_fd {		/* holds the sta
 	char next_cmd_len;	/* 0 -> automatic (def), >0 -> use on next write() */
 	char keep_orphan;	/* 0 -> drop orphan (def), 1 -> keep for read() */
 	char mmap_called;	/* 0 -> mmap() never called on this fd */
+	struct kref f_ref;
+	struct execute_work ew;
 } Sg_fd;
 
 typedef struct sg_device { /* holds the state of each scsi generic device */
@@ -171,6 +174,7 @@ typedef struct sg_device { /* holds the 
 	char sgdebug;		/* 0->off, 1->sense, 9->dump dev, 10-> all devs */
 	struct gendisk *disk;
 	struct cdev * cdev;	/* char_dev [sysfs: /sys/cdev/major/sg<n>] */
+	struct kref d_ref;
 } Sg_device;
 
 static int sg_fasync(int fd, struct file *filp, int mode);
@@ -200,14 +204,15 @@ static void sg_unlink_reserve(Sg_fd * sf
 static struct page *sg_page_malloc(int rqSz, int lowDma, int *retSzp);
 static void sg_page_free(struct page *page, int size);
 static Sg_fd *sg_add_sfp(Sg_device * sdp, int dev);
-static int sg_remove_sfp(Sg_device * sdp, Sg_fd * sfp);
-static void __sg_remove_sfp(Sg_device * sdp, Sg_fd * sfp);
+static void sg_remove_sfp(struct kref *);
 static Sg_request *sg_get_rq_mark(Sg_fd * sfp, int pack_id);
 static Sg_request *sg_add_request(Sg_fd * sfp);
 static int sg_remove_request(Sg_fd * sfp, Sg_request * srp);
 static int sg_res_in_use(Sg_fd * sfp);
 static int sg_build_direct(Sg_request * srp, Sg_fd * sfp, int dxfer_len);
+static Sg_device *sg_lookup_dev(int dev);
 static Sg_device *sg_get_dev(int dev);
+static void sg_put_dev(Sg_device *sdp);
 #ifdef CONFIG_SCSI_PROC_FS
 static int sg_last_dev(void);
 #endif
@@ -244,22 +249,17 @@ sg_open(struct inode *inode, struct file
 	nonseekable_open(inode, filp);
 	SCSI_LOG_TIMEOUT(3, printk("sg_open: dev=%d, flags=0x%x\n", dev, flags));
 	sdp = sg_get_dev(dev);
-	if ((!sdp) || (!sdp->device)) {
-		unlock_kernel();
-		return -ENXIO;
-	}
-	if (sdp->detached) {
-		unlock_kernel();
-		return -ENODEV;
+	if (IS_ERR(sdp)) {
+		retval = PTR_ERR(sdp);
+		sdp = NULL;
+		goto sg_put;
 	}
 
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
@@ -310,16 +310,20 @@ sg_open(struct inode *inode, struct file
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
+		sg_put_dev(sdp);
 	unlock_kernel();
 	return retval;
 }
@@ -335,13 +339,13 @@ sg_release(struct inode *inode, struct f
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
+
+	sfp->closed = 1;
+
+	sdp->exclude = 0;
+	wake_up_interruptible(&sdp->o_excl_wait);
+
+	kref_put(&sfp->f_ref, sg_remove_sfp);
 	return 0;
 }
 
@@ -763,6 +767,7 @@ sg_common_write(Sg_fd * sfp, Sg_request 
 		break;
 	}
 	hp->duration = jiffies_to_msecs(jiffies);
+	kref_get(&sfp->f_ref); /* sg_cmd_done() does kref_put(). */
 /* Now send everything of to mid-level. The next time we hear about this
    packet is when sg_cmd_done() is called (i.e. a callback). */
 	if (scsi_execute_async(sdp->device, cmnd, hp->cmd_len, data_dir, srp->data.buffer,
@@ -774,6 +779,7 @@ sg_common_write(Sg_fd * sfp, Sg_request 
 		 * most likely out of mem, but could also be a bad map
 		 */
 		sg_finish_rem_req(srp);
+		kref_put(&sfp->f_ref, sg_remove_sfp);
 		return -ENOMEM;
 	} else
 		return 0;
@@ -1269,23 +1275,22 @@ static void
 sg_cmd_done(void *data, char *sense, int result, int resid)
 {
 	Sg_request *srp = data;
-	Sg_device *sdp = NULL;
+	Sg_device *sdp;
 	Sg_fd *sfp;
 	unsigned long iflags;
 	unsigned int ms;
+	int done = 1;
 
-	if (NULL == srp) {
-		printk(KERN_ERR "sg_cmd_done: NULL request\n");
+	if (WARN_ON(srp->done != 0))
 		return;
-	}
+
 	sfp = srp->parentfp;
-	if (sfp)
-		sdp = sfp->parentdp;
-	if ((NULL == sdp) || sdp->detached) {
-		printk(KERN_INFO "sg_cmd_done: device detached\n");
+	if (WARN_ON(sfp == NULL))
 		return;
-	}
 
+	sdp = sfp->parentdp;
+	if (unlikely(sdp->detached))
+		printk(KERN_INFO "sg_cmd_done: device detached\n");
 
 	SCSI_LOG_TIMEOUT(4, printk("sg_cmd_done: %s, pack_id=%d, res=0x%x\n",
 		sdp->disk->disk_name, srp->header.pack_id, result));
@@ -1321,33 +1326,26 @@ sg_cmd_done(void *data, char *sense, int
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
+		 * packet.
+		 */
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
@@ -1382,17 +1380,18 @@ static Sg_device *sg_alloc(struct gendis
 		printk(KERN_WARNING "kmalloc Sg_device failure\n");
 		return ERR_PTR(-ENOMEM);
 	}
-	error = -ENOMEM;
+
 	if (!idr_pre_get(&sg_index_idr, GFP_KERNEL)) {
 		printk(KERN_WARNING "idr expansion Sg_device failure\n");
+		error = -ENOMEM;
 		goto out;
 	}
 
 	write_lock_irqsave(&sg_index_lock, iflags);
-	error = idr_get_new(&sg_index_idr, sdp, &k);
-	write_unlock_irqrestore(&sg_index_lock, iflags);
 
+	error = idr_get_new(&sg_index_idr, sdp, &k);
 	if (error) {
+		write_unlock_irqrestore(&sg_index_lock, iflags);
 		printk(KERN_WARNING "idr allocation Sg_device failure: %d\n",
 		       error);
 		goto out;
@@ -1409,6 +1408,9 @@ static Sg_device *sg_alloc(struct gendis
 	init_waitqueue_head(&sdp->o_excl_wait);
 	sdp->sg_tablesize = min(q->max_hw_segments, q->max_phys_segments);
 	sdp->index = k;
+	kref_init(&sdp->d_ref);
+
+	write_unlock_irqrestore(&sg_index_lock, iflags);
 
 	error = 0;
  out:
@@ -1419,6 +1421,8 @@ static Sg_device *sg_alloc(struct gendis
 	return sdp;
 
  overflow:
+	idr_remove(&sg_index_idr, k);
+	write_unlock_irqrestore(&sg_index_lock, iflags);
 	sdev_printk(KERN_WARNING, scsidp,
 		    "Unable to attach sg device type=%d, minor "
 		    "number exceeds %d\n", scsidp->type, SG_MAX_DEVS - 1);
@@ -1508,49 +1512,46 @@ out:
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
+	 * even though the refcount is 0.  Therefore, do idr_remove() BEFORE
+	 * any other cleanup.
+	 */
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
 
@@ -1558,13 +1559,8 @@ sg_remove(struct device *cl_dev, struct 
 	device_destroy(sg_sysfs_class, MKDEV(SCSI_GENERIC_MAJOR, sdp->index));
 	cdev_del(sdp->cdev);
 	sdp->cdev = NULL;
-	put_disk(sdp->disk);
-	sdp->disk = NULL;
-	if (NULL == sdp->headfp)
-		kfree(sdp);
 
-	if (delay)
-		msleep(10);	/* dirty detach so delay device destruction */
+	sg_put_dev(sdp);
 }
 
 module_param_named(scatter_elem_sz, scatter_elem_sz, int, S_IRUGO | S_IWUSR);
@@ -2248,22 +2244,6 @@ sg_get_rq_mark(Sg_fd * sfp, int pack_id)
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
@@ -2339,22 +2319,6 @@ sg_remove_request(Sg_fd * sfp, Sg_reques
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
@@ -2369,6 +2333,7 @@ sg_add_sfp(Sg_device * sdp, int dev)
 	init_waitqueue_head(&sfp->read_wait);
 	rwlock_init(&sfp->rq_list_lock);
 
+	kref_init(&sfp->f_ref);
 	sfp->timeout = SG_DEFAULT_TIMEOUT;
 	sfp->timeout_user = SG_DEFAULT_TIMEOUT_USER;
 	sfp->force_packid = SG_DEF_FORCE_PACK_ID;
@@ -2396,15 +2361,54 @@ sg_add_sfp(Sg_device * sdp, int dev)
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
+	sg_put_dev(sdp);
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
+	 * even though the refcount is now 0.  Therefore, unlink sfp from
+	 * sdp->headfp BEFORE doing any other cleanup.
+	 */
 
+	write_lock_irqsave(&sg_index_lock, iflags);
 	prev_fp = sdp->headfp;
 	if (sfp == prev_fp)
 		sdp->headfp = prev_fp->nextfp;
@@ -2417,54 +2421,10 @@ __sg_remove_sfp(Sg_device * sdp, Sg_fd *
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
@@ -2553,19 +2513,38 @@ sg_last_dev(void)
 }
 #endif
 
-static Sg_device *
-sg_get_dev(int dev)
+/* must be called with sg_index_lock held */
+static Sg_device *sg_lookup_dev(int dev)
 {
-	Sg_device *sdp;
-	unsigned long iflags;
+	return idr_find(&sg_index_idr, dev);
+}
 
-	read_lock_irqsave(&sg_index_lock, iflags);
-	sdp = idr_find(&sg_index_idr, dev);
-	read_unlock_irqrestore(&sg_index_lock, iflags);
+static Sg_device *sg_get_dev(int dev)
+{
+	struct sg_device *sdp;
+	unsigned long flags;
+
+	read_lock_irqsave(&sg_index_lock, flags);
+	sdp = sg_lookup_dev(dev);
+	if (!sdp)
+		sdp = ERR_PTR(-ENXIO);
+	else if (sdp->detached) {
+		/* If sdp->detached, then the refcount may already be 0, in
+		 * which case it would be a bug to do kref_get().
+		 */
+		sdp = ERR_PTR(-ENODEV);
+	} else
+		kref_get(&sdp->d_ref);
+	read_unlock_irqrestore(&sg_index_lock, flags);
 
 	return sdp;
 }
 
+static void sg_put_dev(struct sg_device *sdp)
+{
+	kref_put(&sdp->d_ref, sg_device_destroy);
+}
+
 #ifdef CONFIG_SCSI_PROC_FS
 
 static struct proc_dir_entry *sg_proc_sgp = NULL;
@@ -2822,8 +2801,10 @@ static int sg_proc_seq_show_dev(struct s
 	struct sg_proc_deviter * it = (struct sg_proc_deviter *) v;
 	Sg_device *sdp;
 	struct scsi_device *scsidp;
+	unsigned long iflags;
 
-	sdp = it ? sg_get_dev(it->index) : NULL;
+	read_lock_irqsave(&sg_index_lock, iflags);
+	sdp = it ? sg_lookup_dev(it->index) : NULL;
 	if (sdp && (scsidp = sdp->device) && (!sdp->detached))
 		seq_printf(s, "%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n",
 			      scsidp->host->host_no, scsidp->channel,
@@ -2834,6 +2815,7 @@ static int sg_proc_seq_show_dev(struct s
 			      (int) scsi_device_online(scsidp));
 	else
 		seq_printf(s, "-1\t-1\t-1\t-1\t-1\t-1\t-1\t-1\t-1\n");
+	read_unlock_irqrestore(&sg_index_lock, iflags);
 	return 0;
 }
 
@@ -2847,16 +2829,20 @@ static int sg_proc_seq_show_devstrs(stru
 	struct sg_proc_deviter * it = (struct sg_proc_deviter *) v;
 	Sg_device *sdp;
 	struct scsi_device *scsidp;
+	unsigned long iflags;
 
-	sdp = it ? sg_get_dev(it->index) : NULL;
+	read_lock_irqsave(&sg_index_lock, iflags);
+	sdp = it ? sg_lookup_dev(it->index) : NULL;
 	if (sdp && (scsidp = sdp->device) && (!sdp->detached))
 		seq_printf(s, "%8.8s\t%16.16s\t%4.4s\n",
 			   scsidp->vendor, scsidp->model, scsidp->rev);
 	else
 		seq_printf(s, "<no active device>\n");
+	read_unlock_irqrestore(&sg_index_lock, iflags);
 	return 0;
 }
 
+/* must be called while holding sg_index_lock */
 static void sg_proc_debug_helper(struct seq_file *s, Sg_device * sdp)
 {
 	int k, m, new_interface, blen, usg;
@@ -2866,7 +2852,8 @@ static void sg_proc_debug_helper(struct 
 	const char * cp;
 	unsigned int ms;
 
-	for (k = 0; (fp = sg_get_nth_sfp(sdp, k)); ++k) {
+	for (k = 0, fp = sdp->headfp; fp != NULL; ++k, fp = fp->nextfp) {
+		read_lock(&fp->rq_list_lock); /* irqs already disabled */
 		seq_printf(s, "   FD(%d): timeout=%dms bufflen=%d "
 			   "(res)sgat=%d low_dma=%d\n", k + 1,
 			   jiffies_to_msecs(fp->timeout),
@@ -2876,7 +2863,9 @@ static void sg_proc_debug_helper(struct 
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
@@ -2913,6 +2902,7 @@ static void sg_proc_debug_helper(struct 
 		}
 		if (0 == m)
 			seq_printf(s, "     No requests active\n");
+		read_unlock(&fp->rq_list_lock);
 	}
 }
 
@@ -2925,39 +2915,34 @@ static int sg_proc_seq_show_debug(struct
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
-	if (sdp) {
-		struct scsi_device *scsidp = sdp->device;
 
-		if (NULL == scsidp) {
-			seq_printf(s, "device %d detached ??\n", 
-				   (int)it->index);
-			return 0;
-		}
+	read_lock_irqsave(&sg_index_lock, iflags);
+	sdp = it ? sg_lookup_dev(it->index) : NULL;
+	if (sdp && sdp->headfp) {
+		struct scsi_device *scsidp = sdp->device;
 
-		if (sg_get_nth_sfp(sdp, 0)) {
-			seq_printf(s, " >>> device=%s ",
-				sdp->disk->disk_name);
-			if (sdp->detached)
-				seq_printf(s, "detached pending close ");
-			else
-				seq_printf
-				    (s, "scsi%d chan=%d id=%d lun=%d   em=%d",
-				     scsidp->host->host_no,
-				     scsidp->channel, scsidp->id,
-				     scsidp->lun,
-				     scsidp->host->hostt->emulated);
-			seq_printf(s, " sg_tablesize=%d excl=%d\n",
-				   sdp->sg_tablesize, sdp->exclude);
-		}
+		seq_printf(s, " >>> device=%s ", sdp->disk->disk_name);
+		if (sdp->detached)
+			seq_printf(s, "detached pending close ");
+		else
+			seq_printf
+			    (s, "scsi%d chan=%d id=%d lun=%d   em=%d",
+			     scsidp->host->host_no,
+			     scsidp->channel, scsidp->id,
+			     scsidp->lun,
+			     scsidp->host->hostt->emulated);
+		seq_printf(s, " sg_tablesize=%d excl=%d\n",
+			   sdp->sg_tablesize, sdp->exclude);
 		sg_proc_debug_helper(s, sdp);
 	}
+	read_unlock_irqrestore(&sg_index_lock, iflags);
 	return 0;
 }
 


