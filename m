From: Tony Battersby <tonyb@cybernetics.com>
Subject: Re: [PATCH 0/2] sg: fix races during device removal (v2)
Date: Wed, 14 Jan 2009 15:31:15 -0500
Message-ID: <496E4B93.4000507@cybernetics.com>
References: <49625A67.3000304@cybernetics.com> <20090111022525I.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([98.174.209.230]:4363 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbZANUbS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jan 2009 15:31:18 -0500
In-Reply-To: <20090111022525I.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: dgilbert@interlog.com, James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org, Greg Kroah-Hartman <greg@kroah.com>

[CC: Greg Kroah-Hartman <greg@kroah.com>]

Fujita, your patch results in simpler code than my version 2 patch,
but it still leaves some subtle races and other problems.  The crux
of the problem is that kref_put() needs do be done while holding a
lock if there is still a way for some other CPU to find a reference
to the object in between the time the refcount drops to 0 and the
time the destructor is called.

For example, look at sg_get_dev() and sg_put_dev().  In my patch,
I locked sg_index_lock in sg_put_dev() and called kref_put() while
holding the lock.  In your patch, you moved the lock from sg_put_dev()
to the destructor function.  This introduces a subtle race with
sg_get_dev():

CPU 1:
sg_put_dev()
  kref_put(): refcount 1 -> 0

CPU 2:
sg_get_dev()
  lock sg_index_lock
  idr_find()
  kref_get(): refcount 0 -> 1: bug
  unlock sg_index_lock

CPU 1:
sg_device_release()
  lock sg_index_lock
  idr_remove
  unlock sg_index_lock
  kfree(sdp)

CPU 2:
access sdp which has already been freed
sg_put_dev(): double-free bug

Besides holding the lock during kref_put(), I also considered two
other simple ways to avoid this race:
1) Do idr_remove() from sg_remove().
2) Return NULL in sg_get_dev() if sdp->detached.

However, both of these options would have changed the behavior of
the /proc/scsi/sg/* functions that show information for devices that
are in the process of being detached.  I wanted to fix bugs without
changing other behavior, so I chose to call kref_put() under lock in
my previous patches.

A similar problem exists with sg_remove_sfp() in your patch.
The refcount for the sg_fd can drop to 0 while a different CPU can
still find a reference to it by scanning sg_device::headfp.  The good
news is that most places that scan sg_fd's using sdp->headfp never
drop sg_index_lock while still holding a reference, so for most cases
it is safe for the destructor to work the way you have it.  The one
exception is sg_get_nth_sfp(), which needs to kref_get() the sg_fd it
returns (my version 2 patch doesn't fix this problem either since I
just noticed it).  But then the kref_get() would have a race similar
to the one I described above between sg_get_dev() and sg_put_dev().

There are several solutions to this problem:
1) Call kref_put(&sfp->f_ref, sg_remove_sfp) while holding
sg_index_lock, and have the destructor unlink sfp from sdp->headfp
before dropping the lock.  This is ugly since the destructor may want
to drop sg_index_lock (e.g. to call scsi_device_put()), but the saved
irqflags variable is in a different function.
2) Unlink sfp from sdp->headfp in sg_release().  The downside to this
is that the /proc/scsi/sg/* functions no longer show fds that have
been closed but still have commands pending.
3) Set sfp->closed in sg_release() and have sg_get_nth_sfp() return
NULL if sfp->closed.  Same downside as #2.
4) Add a variation of kref_get() that uses atomic_inc_not_zero().

When I was designing my previous patches, I anticipated running into
these complications with kref, which is one reason I avoided it.
Other people have experienced similar problems with the kref interface
(search "kref_get_not_zero" or "cgroups: fix probable race with
put_css_set[_taskexit] and find_css_set").  If you still want to use
kref, I think that we are either going to have to change the behavior
of /proc/scsi/sg/*, or else use atomic_inc_not_zero().  Since I still
prefer not to change valid user-visible behavior in a patch that fixes
so many possible oopses, I will go with atomic_inc_not_zero().  And,
since I am going that route, I will use it for sg_get_dev() also,
so that sg_put_dev() doesn't need to acquire sg_index_lock.

For the purposes of this patch, I added the local function
sg_kref_get_not_zero() to sg.c.  It would be better to add
kref_get_not_zero() to kref.c, but I see in the mailing list archives
that there has been some resistance to that idea because it complicates
the kref interface.  However, since it has come up more than once,
perhaps it would be better to go ahead and make it an official part
of the interface.  If anyone wants to support that idea, I will break
it out into a separate patch.

Your patch also has a problem with management of f_ref.  You do
kref_get() in sg_add_request() and kref_put() in sg_rq_end_io()().
However, an error can occur in between sg_add_request() and sending
the command to the midlevel, so sg_rq_end_io() may never be called.
It is better to do kref_get() just before sending the command to the
midlevel; that way the refcount counts active commands waiting for
the completion callback rather than prepared requests.

Your patch doesn't fix the problem of various functions calling
SCSI_LOG_TIMEOUT with sdp->disk->disk_name after sg_remove() sets
sdp->disk to NULL.  This is why I moved put_disk() from sg_remove()
to sg_device_release().

Your patch doesn't fix the problem of forgetting to do
wake_up_interruptible(&sdp->o_excl_wait) after removing sfp from
sdp->headfp.  This is important if sg_release() is called with
commands still active; the last command that finishes should wake up
any O_EXCL waiters.

So below is version 3 of my patch combining my ideas and your ideas.
For testing with mpt, I commented out mptscsih_synchronize_cache()
in mptscsih.c as a workaround for the bug I mentioned in a previous
message.  This patch still fixes all the test cases previously listed,
but with the additional improvements that it is simpler and it no
longer blocks keventd waiting for commands to complete.

My previously-posted "[PATCH 2/2] sg: fix races with ioctl(SG_IO)"
still needs to be applied after this patch.

=
From: Tony Battersby <tonyb@cybernetics.com>
Date: Wed, 14 Jan 2009 15:30:00 -0500
Subject: [PATCH] sg: fix races during device removal (v3)

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

/proc functions get and put references to sg_fd and sg_device as
needed.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---
 sg.c |  342 ++++++++++++++++++++++++++++++++++++-------------------------------
 1 file changed, 184 insertions(+), 158 deletions(-)
--- linux-2.6.29-rc1-git4/drivers/scsi/sg.c.orig	2009-01-14 14:16:14.000000000 -0500
+++ linux-2.6.29-rc1-git4/drivers/scsi/sg.c	2009-01-14 14:25:45.000000000 -0500
@@ -158,6 +158,8 @@ typedef struct sg_fd {		/* holds the sta
 	char next_cmd_len;	/* 0 -> automatic (def), >0 -> use on next write() */
 	char keep_orphan;	/* 0 -> drop orphan (def), 1 -> keep for read() */
 	char mmap_called;	/* 0 -> mmap() never called on this fd */
+	struct kref f_ref;
+	struct execute_work ew;
 } Sg_fd;
 
 typedef struct sg_device { /* holds the state of each scsi generic device */
@@ -171,6 +173,7 @@ typedef struct sg_device { /* holds the 
 	char sgdebug;		/* 0->off, 1->sense, 9->dump dev, 10-> all devs */
 	struct gendisk *disk;
 	struct cdev * cdev;	/* char_dev [sysfs: /sys/cdev/major/sg<n>] */
+	struct kref d_ref;
 } Sg_device;
 
 static int sg_fasync(int fd, struct file *filp, int mode);
@@ -194,13 +197,13 @@ static void sg_build_reserve(Sg_fd * sfp
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
 static Sg_device *sg_get_dev(int dev);
+static void sg_put_dev(struct sg_device *sdp);
 #ifdef CONFIG_SCSI_PROC_FS
 static int sg_last_dev(void);
 #endif
@@ -210,6 +213,37 @@ static int sg_last_dev(void);
 #define SZ_SG_IOVEC sizeof(sg_iovec_t)
 #define SZ_SG_REQ_INFO sizeof(sg_req_info_t)
 
+/**
+ * sg_kref_get_not_zero - increment refcount for object if not already 0.
+ * @kref: object.
+ *
+ * If the object is not being destroyed, then increment the refcount and return
+ * true.  Otherwise, return false without doing anything.
+ *
+ * Depending on how you manage the referenced object, there may be ways of
+ * finding the object in between the time kref_put() decrements the refcount to
+ * 0 and the time the destructor finishes.  For example, if the object can be
+ * found in a lookup table, and the destructor removes the object from that
+ * table, then one CPU may still be able to find the object in that table
+ * for a brief period while a different CPU is running the destructor.  To
+ * prevent problems, either call kref_put() while holding a lock that prevents
+ * another CPU from finding the object, or else use this function instead of
+ * kref_get() when using the lookup table to find the object.
+ *
+ * This function should be called while holding whatever lock is used to
+ * protect the data structure used to find the object.  If this function
+ * returns false, then do not access the object after dropping the lock, and do
+ * not call kref_put().
+ */
+static bool __must_check sg_kref_get_not_zero(struct kref *kref)
+{
+	if (likely(atomic_inc_not_zero(&kref->refcount))) {
+		smp_mb__after_atomic_inc();
+		return true;
+	}
+	return false;
+}
+
 static int sg_allow_access(struct file *filp, unsigned char *cmd)
 {
 	struct sg_fd *sfp = (struct sg_fd *)filp->private_data;
@@ -238,21 +272,19 @@ sg_open(struct inode *inode, struct file
 	SCSI_LOG_TIMEOUT(3, printk("sg_open: dev=%d, flags=0x%x\n", dev, flags));
 	sdp = sg_get_dev(dev);
 	if ((!sdp) || (!sdp->device)) {
-		unlock_kernel();
-		return -ENXIO;
+		retval = -ENXIO;
+		goto sg_put;
 	}
 	if (sdp->detached) {
-		unlock_kernel();
-		return -ENODEV;
+		retval = -ENODEV;
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
@@ -303,16 +335,19 @@ sg_open(struct inode *inode, struct file
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
+	sg_put_dev(sdp);
 	unlock_kernel();
 	return retval;
 }
@@ -327,13 +362,13 @@ sg_release(struct inode *inode, struct f
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
 	return 0;
 }
 
@@ -755,6 +790,7 @@ sg_common_write(Sg_fd * sfp, Sg_request 
 	hp->duration = jiffies_to_msecs(jiffies);
 
 	srp->rq->timeout = timeout;
+	kref_get(&sfp->f_ref); /* sg_rq_end_io() does kref_put(). */
 	blk_execute_rq_nowait(sdp->device->request_queue, sdp->disk,
 			      srp->rq, 1, sg_rq_end_io);
 	return 0;
@@ -1247,25 +1283,28 @@ sg_mmap(struct file *filp, struct vm_are
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
@@ -1303,33 +1342,25 @@ static void sg_rq_end_io(struct request 
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
@@ -1391,6 +1422,7 @@ static Sg_device *sg_alloc(struct gendis
 	init_waitqueue_head(&sdp->o_excl_wait);
 	sdp->sg_tablesize = min(q->max_hw_segments, q->max_phys_segments);
 	sdp->index = k;
+	kref_init(&sdp->d_ref);
 
 	error = 0;
  out:
@@ -1488,63 +1520,33 @@ out:
 	return error;
 }
 
-static void
-sg_remove(struct device *cl_dev, struct class_interface *cl_intf)
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
-	write_lock_irqsave(&sg_index_lock, iflags);
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
+	SCSI_LOG_TIMEOUT(3, printk("sg_remove: %s\n", sdp->disk->disk_name));
+
+	sdp->detached = 1;
+
+	read_lock_irqsave(&sg_index_lock, iflags);
+	for (sfp = sdp->headfp; sfp; sfp = sfp->nextfp) {
+		wake_up_interruptible(&sfp->read_wait);
+		kill_fasync(&sfp->async_qp, SIGPOLL, POLL_HUP);
 	}
-	write_unlock_irqrestore(&sg_index_lock, iflags);
+	read_unlock_irqrestore(&sg_index_lock, iflags);
 
 	sysfs_remove_link(&scsidp->sdev_gendev.kobj, "generic");
 	device_destroy(sg_sysfs_class, MKDEV(SCSI_GENERIC_MAJOR, sdp->index));
 	cdev_del(sdp->cdev);
 	sdp->cdev = NULL;
-	put_disk(sdp->disk);
-	sdp->disk = NULL;
-	if (NULL == sdp->headfp)
-		kfree(sdp);
 
-	if (delay)
-		msleep(10);	/* dirty detach so delay device destruction */
+	sg_put_dev(sdp); /* put initial reference from kref_init. */
 }
 
 module_param_named(scatter_elem_sz, scatter_elem_sz, int, S_IRUGO | S_IWUSR);
@@ -2033,18 +2035,21 @@ sg_remove_request(Sg_fd * sfp, Sg_reques
 }
 
 #ifdef CONFIG_SCSI_PROC_FS
-static Sg_fd *
-sg_get_nth_sfp(Sg_device * sdp, int nth)
+static Sg_fd *sg_get_next_sfp(Sg_device *sdp, Sg_fd *prev_sfp)
 {
-	Sg_fd *resp;
+	Sg_fd *sfp;
 	unsigned long iflags;
-	int k;
 
 	read_lock_irqsave(&sg_index_lock, iflags);
-	for (k = 0, resp = sdp->headfp; resp && (k < nth);
-	     ++k, resp = resp->nextfp) ;
+	sfp = (prev_sfp == NULL) ? sdp->headfp : prev_sfp->nextfp;
+	for ( ; sfp != NULL; sfp = sfp->nextfp) {
+		if (sg_kref_get_not_zero(&sfp->f_ref))
+			break;
+	}
 	read_unlock_irqrestore(&sg_index_lock, iflags);
-	return resp;
+	if (prev_sfp != NULL)
+		kref_put(&prev_sfp->f_ref, sg_remove_sfp);
+	return sfp;
 }
 #endif
 
@@ -2062,6 +2067,7 @@ sg_add_sfp(Sg_device * sdp, int dev)
 	init_waitqueue_head(&sfp->read_wait);
 	rwlock_init(&sfp->rq_list_lock);
 
+	kref_init(&sfp->f_ref);
 	sfp->timeout = SG_DEFAULT_TIMEOUT;
 	sfp->timeout_user = SG_DEFAULT_TIMEOUT_USER;
 	sfp->force_packid = SG_DEF_FORCE_PACK_ID;
@@ -2089,15 +2095,49 @@ sg_add_sfp(Sg_device * sdp, int dev)
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
 {
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
+{
+	struct sg_fd *sfp = container_of(kref, struct sg_fd, f_ref);
+	struct sg_device *sdp = sfp->parentdp;
 	Sg_fd *fp;
 	Sg_fd *prev_fp;
+	unsigned long iflags;
 
+	write_lock_irqsave(&sg_index_lock, iflags);
 	prev_fp = sdp->headfp;
 	if (sfp == prev_fp)
 		sdp->headfp = prev_fp->nextfp;
@@ -2110,54 +2150,10 @@ __sg_remove_sfp(Sg_device * sdp, Sg_fd *
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
@@ -2199,6 +2195,28 @@ sg_last_dev(void)
 }
 #endif
 
+static void sg_device_destroy(struct kref *kref)
+{
+	struct sg_device *sdp = container_of(kref, struct sg_device, d_ref);
+	unsigned long flags;
+
+	SCSI_LOG_TIMEOUT(3,
+		printk("sg_device_destroy: %s\n",
+			sdp->disk->disk_name));
+
+	write_lock_irqsave(&sg_index_lock, flags);
+	idr_remove(&sg_index_idr, sdp->index);
+	write_unlock_irqrestore(&sg_index_lock, flags);
+	put_disk(sdp->disk);
+	kfree(sdp);
+}
+
+static void sg_put_dev(struct sg_device *sdp)
+{
+	if (sdp)
+		kref_put(&sdp->d_ref, sg_device_destroy);
+}
+
 static Sg_device *
 sg_get_dev(int dev)
 {
@@ -2207,6 +2225,9 @@ sg_get_dev(int dev)
 
 	read_lock_irqsave(&sg_index_lock, iflags);
 	sdp = idr_find(&sg_index_idr, dev);
+	if (sdp)
+		if (!sg_kref_get_not_zero(&sdp->d_ref))
+			sdp = NULL;
 	read_unlock_irqrestore(&sg_index_lock, iflags);
 
 	return sdp;
@@ -2480,6 +2501,7 @@ static int sg_proc_seq_show_dev(struct s
 			      (int) scsi_device_online(scsidp));
 	else
 		seq_printf(s, "-1\t-1\t-1\t-1\t-1\t-1\t-1\t-1\t-1\n");
+	sg_put_dev(sdp);
 	return 0;
 }
 
@@ -2500,19 +2522,19 @@ static int sg_proc_seq_show_devstrs(stru
 			   scsidp->vendor, scsidp->model, scsidp->rev);
 	else
 		seq_printf(s, "<no active device>\n");
+	sg_put_dev(sdp);
 	return 0;
 }
 
-static void sg_proc_debug_helper(struct seq_file *s, Sg_device * sdp)
+static void sg_proc_debug_helper(struct seq_file *s, Sg_device *sdp, Sg_fd *fp)
 {
 	int k, m, new_interface, blen, usg;
 	Sg_request *srp;
-	Sg_fd *fp;
 	const sg_io_hdr_t *hp;
 	const char * cp;
 	unsigned int ms;
 
-	for (k = 0; (fp = sg_get_nth_sfp(sdp, k)); ++k) {
+	for (k = 0; fp != NULL; ++k, fp = sg_get_next_sfp(sdp, fp)) {
 		seq_printf(s, "   FD(%d): timeout=%dms bufflen=%d "
 			   "(res)sgat=%d low_dma=%d\n", k + 1,
 			   jiffies_to_msecs(fp->timeout),
@@ -2580,14 +2602,16 @@ static int sg_proc_seq_show_debug(struct
 	sdp = it ? sg_get_dev(it->index) : NULL;
 	if (sdp) {
 		struct scsi_device *scsidp = sdp->device;
+		Sg_fd *fp;
 
 		if (NULL == scsidp) {
 			seq_printf(s, "device %d detached ??\n", 
 				   (int)it->index);
-			return 0;
+			goto out;
 		}
 
-		if (sg_get_nth_sfp(sdp, 0)) {
+		fp = sg_get_next_sfp(sdp, NULL);
+		if (fp) {
 			seq_printf(s, " >>> device=%s ",
 				sdp->disk->disk_name);
 			if (sdp->detached)
@@ -2601,9 +2625,11 @@ static int sg_proc_seq_show_debug(struct
 				     scsidp->host->hostt->emulated);
 			seq_printf(s, " sg_tablesize=%d excl=%d\n",
 				   sdp->sg_tablesize, sdp->exclude);
+			sg_proc_debug_helper(s, sdp, fp);
 		}
-		sg_proc_debug_helper(s, sdp);
 	}
+out:
+	sg_put_dev(sdp);
 	return 0;
 }
 

