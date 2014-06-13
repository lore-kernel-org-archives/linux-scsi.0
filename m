From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH v4] sg: O_EXCL and other lock handling
Date: Thu, 12 Jun 2014 20:26:39 -0400
Message-ID: <539A453F.5020502@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040701060501020801080806"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:49632 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbaFMA0q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jun 2014 20:26:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Hannes Reinecke <hare@suse.de>, vaughan <vaughan.cao@oracle.com>

This is a multi-part message in MIME format.
--------------040701060501020801080806
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This is a re-presentation of a patch to the sg driver
whose v3 was sent in November 2013:
   http://www.spinics.net/lists/linux-scsi/msg69957.html

It addresses a problem reported by Vaughan Cao concerning
the correctness of the O_EXCL logic in the sg driver. POSIX
doesn't defined O_EXCL semantics on devices but "allow only
one open file descriptor at a time per sg device" is a rough
definition. The sg driver's semantics have been to wait
on an open() when O_NONBLOCK is not given and there are
O_EXCL headwinds. Nasty things can happen during that wait
such as the device being detached (removed). So multiple
locks are reworked in this patch making it large and hard
to break down into digestible bits.

This patch is against Linus's current git repository which
doesn't include any sg patches sent in the last few weeks.
Hence this patch touches as little as possible that it
doesn't need to and strips out most SCSI_LOG_TIMEOUT()
changes in v3 because Hannes said he was going to rework all
that stuff.

The sg3_utils package has several test programs written to
test this patch. See examples/sg_tst_excl*.cpp .

Not all the locks and flags in sg have been re-worked in
this patch, notably sg_request::done . That can wait for
a follow-up patch if this one meets with approval.

ChangeLog v4:
   - based on the current kernel tree: pre 3.16-rc1
   - strip out clean-ups in v3 that others are better
     placed to do (e.g. debug/logging)
   - simplify open_wait_event() logic and add comment

ChangeLog v3 and earlier: see link in the first paragraph.


Could anyone confirm whether v3 of this patch has found its
way into any distro and/or been tested or used more widely?

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>



--------------040701060501020801080806
Content-Type: text/x-patch;
 name="sg.c_race_excl_dg4.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sg.c_race_excl_dg4.patch"

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 53268aa..fc10ed5 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -51,6 +51,7 @@ static int sg_version_num = 30534;	/* 2 digits for each component */
 #include <linux/delay.h>
 #include <linux/blktrace_api.h>
 #include <linux/mutex.h>
+#include <linux/atomic.h>
 #include <linux/ratelimit.h>
 
 #include "scsi.h"
@@ -102,18 +103,16 @@ static int scatter_elem_sz_prev = SG_SCATTER_SZ;
 
 #define SG_SECTOR_SZ 512
 
-static int sg_add(struct device *, struct class_interface *);
-static void sg_remove(struct device *, struct class_interface *);
-
-static DEFINE_SPINLOCK(sg_open_exclusive_lock);
+static int sg_add_device(struct device *, struct class_interface *);
+static void sg_remove_device(struct device *, struct class_interface *);
 
 static DEFINE_IDR(sg_index_idr);
 static DEFINE_RWLOCK(sg_index_lock);	/* Also used to lock
 							   file descriptor list for device */
 
 static struct class_interface sg_interface = {
-	.add_dev	= sg_add,
-	.remove_dev	= sg_remove,
+	.add_dev        = sg_add_device,
+	.remove_dev     = sg_remove_device,
 };
 
 typedef struct sg_scatter_hold { /* holding area for scsi scatter gather info */
@@ -146,8 +145,7 @@ typedef struct sg_request {	/* SG_MAX_QUEUE requests outstanding per file */
 } Sg_request;
 
 typedef struct sg_fd {		/* holds the state of a file descriptor */
-	/* sfd_siblings is protected by sg_index_lock */
-	struct list_head sfd_siblings;
+	struct list_head sfd_siblings;  /* protected by device's sfd_lock */
 	struct sg_device *parentdp;	/* owning device */
 	wait_queue_head_t read_wait;	/* queue read until command done */
 	rwlock_t rq_list_lock;	/* protect access to list in req_arr */
@@ -170,14 +168,15 @@ typedef struct sg_fd {		/* holds the state of a file descriptor */
 
 typedef struct sg_device { /* holds the state of each scsi generic device */
 	struct scsi_device *device;
-	wait_queue_head_t o_excl_wait;	/* queue open() when O_EXCL in use */
+	wait_queue_head_t open_wait;    /* queue open() when O_EXCL present */
+	struct mutex open_rel_lock;     /* held when in open() or release() */
 	int sg_tablesize;	/* adapter's max scatter-gather table size */
 	u32 index;		/* device index number */
-	/* sfds is protected by sg_index_lock */
 	struct list_head sfds;
-	volatile char detached;	/* 0->attached, 1->detached pending removal */
-	/* exclude protected by sg_open_exclusive_lock */
-	char exclude;		/* opened for exclusive access */
+	rwlock_t sfd_lock;      /* protect access to sfd list */
+	atomic_t detaching;     /* 0->device usable, 1->device detaching */
+	atomic_t exclude;       /* 1->open(O_EXCL) succeeded and is active */
+	atomic_t open_cnt;      /* count of opens (perhaps < num(sfds) ) */
 	char sgdebug;		/* 0->off, 1->sense, 9->dump dev, 10-> all devs */
 	struct gendisk *disk;
 	struct cdev * cdev;	/* char_dev [sysfs: /sys/cdev/major/sg<n>] */
@@ -208,7 +207,7 @@ static Sg_request *sg_add_request(Sg_fd * sfp);
 static int sg_remove_request(Sg_fd * sfp, Sg_request * srp);
 static int sg_res_in_use(Sg_fd * sfp);
 static Sg_device *sg_get_dev(int dev);
-static void sg_put_dev(Sg_device *sdp);
+static void sg_device_destroy(struct kref *kref);
 
 #define SZ_SG_HEADER sizeof(struct sg_header)
 #define SZ_SG_IO_HDR sizeof(sg_io_hdr_t)
@@ -225,38 +224,23 @@ static int sg_allow_access(struct file *filp, unsigned char *cmd)
 	return blk_verify_command(cmd, filp->f_mode & FMODE_WRITE);
 }
 
-static int get_exclude(Sg_device *sdp)
-{
-	unsigned long flags;
-	int ret;
-
-	spin_lock_irqsave(&sg_open_exclusive_lock, flags);
-	ret = sdp->exclude;
-	spin_unlock_irqrestore(&sg_open_exclusive_lock, flags);
-	return ret;
-}
-
-static int set_exclude(Sg_device *sdp, char val)
+static int
+open_wait_event(Sg_device *sdp, int other_has_exclude)
 {
-	unsigned long flags;
+	int retval;
 
-	spin_lock_irqsave(&sg_open_exclusive_lock, flags);
-	sdp->exclude = val;
-	spin_unlock_irqrestore(&sg_open_exclusive_lock, flags);
-	return val;
-}
-
-static int sfds_list_empty(Sg_device *sdp)
-{
-	unsigned long flags;
-	int ret;
-
-	read_lock_irqsave(&sg_index_lock, flags);
-	ret = list_empty(&sdp->sfds);
-	read_unlock_irqrestore(&sg_index_lock, flags);
-	return ret;
+	if (other_has_exclude)
+		retval = wait_event_interruptible(sdp->open_wait,
+				(atomic_read(&sdp->detaching)) ||
+				 !atomic_read(&sdp->exclude));
+	else	/* my caller wants O_EXCL */
+		retval = wait_event_interruptible(sdp->open_wait,
+				(atomic_read(&sdp->detaching)) ||
+				 (atomic_read(&sdp->open_cnt) < 1));
+	return atomic_read(&sdp->detaching) ? -ENODEV : retval;
 }
 
+/* Returns 0 on success, else a negated errno value */
 static int
 sg_open(struct inode *inode, struct file *filp)
 {
@@ -265,11 +249,12 @@ sg_open(struct inode *inode, struct file *filp)
 	struct request_queue *q;
 	Sg_device *sdp;
 	Sg_fd *sfp;
-	int res;
 	int retval;
 
 	nonseekable_open(inode, filp);
 	SCSI_LOG_TIMEOUT(3, printk("sg_open: dev=%d, flags=0x%x\n", dev, flags));
+	if ((flags & O_EXCL) && (O_RDONLY == (flags & O_ACCMODE)))
+		return -EPERM; /* Can't lock it with read only access */
 	sdp = sg_get_dev(dev);
 	if (IS_ERR(sdp)) {
 		retval = PTR_ERR(sdp);
@@ -287,6 +272,9 @@ sg_open(struct inode *inode, struct file *filp)
 	if (retval)
 		goto sdp_put;
 
+	/* scsi_block_when_processing_errors() may block so bypass
+	 * check if O_NONBLOCK. Permits SCSI commands to be issued
+	 * during error recovery. Tread carefully. */
 	if (!((flags & O_NONBLOCK) ||
 	      scsi_block_when_processing_errors(sdp->device))) {
 		retval = -ENXIO;
@@ -294,68 +282,78 @@ sg_open(struct inode *inode, struct file *filp)
 		goto error_out;
 	}
 
-	if (flags & O_EXCL) {
-		if (O_RDONLY == (flags & O_ACCMODE)) {
-			retval = -EPERM; /* Can't lock it with read only access */
-			goto error_out;
-		}
-		if (!sfds_list_empty(sdp) && (flags & O_NONBLOCK)) {
-			retval = -EBUSY;
-			goto error_out;
-		}
-		res = wait_event_interruptible(sdp->o_excl_wait,
-					   ((!sfds_list_empty(sdp) || get_exclude(sdp)) ? 0 : set_exclude(sdp, 1)));
-		if (res) {
-			retval = res;	/* -ERESTARTSYS because signal hit process */
-			goto error_out;
-		}
-	} else if (get_exclude(sdp)) {	/* some other fd has an exclusive lock on dev */
-		if (flags & O_NONBLOCK) {
-			retval = -EBUSY;
-			goto error_out;
+	mutex_lock(&sdp->open_rel_lock);
+	if (flags & O_NONBLOCK) {
+		if (flags & O_EXCL) {
+			if (atomic_read(&sdp->open_cnt) > 0) {
+				retval = -EBUSY;
+				goto error_mutex_locked;
+			}
+		} else {
+			if (atomic_read(&sdp->exclude)) {
+				retval = -EBUSY;
+				goto error_mutex_locked;
+			}
 		}
-		res = wait_event_interruptible(sdp->o_excl_wait, !get_exclude(sdp));
-		if (res) {
-			retval = res;	/* -ERESTARTSYS because signal hit process */
-			goto error_out;
+	} else {
+		if (flags & O_EXCL) {
+			while (atomic_read(&sdp->open_cnt) > 0) {
+				mutex_unlock(&sdp->open_rel_lock);
+				retval = open_wait_event(sdp, 0);
+				if (retval) /* -ERESTARTSYS or -ENODEV */
+					goto error_out;
+				mutex_lock(&sdp->open_rel_lock);
+			}
+		} else {
+			while (atomic_read(&sdp->exclude)) {
+				mutex_unlock(&sdp->open_rel_lock);
+				retval = open_wait_event(sdp, 1);
+				if (retval) /* -ERESTARTSYS or -ENODEV */
+					goto error_out;
+				mutex_lock(&sdp->open_rel_lock);
+			}
 		}
 	}
-	if (sdp->detached) {
-		retval = -ENODEV;
-		goto error_out;
-	}
-	if (sfds_list_empty(sdp)) {	/* no existing opens on this device */
+	/* N.B. at this point we are holding the open_rel_lock */
+	if (flags & O_EXCL)
+		atomic_set(&sdp->exclude, 1);
+
+	if (atomic_read(&sdp->open_cnt) < 1) {  /* no existing opens */
 		sdp->sgdebug = 0;
 		q = sdp->device->request_queue;
 		sdp->sg_tablesize = queue_max_segments(q);
 	}
-	if ((sfp = sg_add_sfp(sdp, dev)))
+	sfp = sg_add_sfp(sdp, dev);
+	if (!IS_ERR(sfp)) {
 		filp->private_data = sfp;
-	else {
+		retval = 0;
+		atomic_inc(&sdp->open_cnt);
+		mutex_unlock(&sdp->open_rel_lock);
+	} else {
+		retval = PTR_ERR(sfp);
 		if (flags & O_EXCL) {
-			set_exclude(sdp, 0);	/* undo if error */
-			wake_up_interruptible(&sdp->o_excl_wait);
+			atomic_set(&sdp->exclude, 0);   /* undo if error */
+			wake_up_interruptible(&sdp->open_wait);
 		}
-		retval = -ENOMEM;
-		goto error_out;
-	}
-	retval = 0;
+error_mutex_locked:
+		mutex_unlock(&sdp->open_rel_lock);
 error_out:
-	if (retval) {
 		scsi_autopm_put_device(sdp->device);
 sdp_put:
 		scsi_device_put(sdp->device);
 	}
 sg_put:
 	if (sdp)
-		sg_put_dev(sdp);
+		kref_put(&sdp->d_ref, sg_device_destroy);
 	return retval;
 }
 
-/* Following function was formerly called 'sg_close' */
+/* Release resources associated with a successful sg_open()
+ * Returns 0 on success, else a negated errno value */
 static int
 sg_release(struct inode *inode, struct file *filp)
 {
+	int rem_open_cnt;
 	Sg_device *sdp;
 	Sg_fd *sfp;
 
@@ -363,11 +361,22 @@ sg_release(struct inode *inode, struct file *filp)
 		return -ENXIO;
 	SCSI_LOG_TIMEOUT(3, printk("sg_release: %s\n", sdp->disk->disk_name));
 
-	set_exclude(sdp, 0);
-	wake_up_interruptible(&sdp->o_excl_wait);
-
+	mutex_lock(&sdp->open_rel_lock);
 	scsi_autopm_put_device(sdp->device);
 	kref_put(&sfp->f_ref, sg_remove_sfp);
+	rem_open_cnt = atomic_dec_return(&sdp->open_cnt);
+	if (unlikely(rem_open_cnt < 0)) {
+		atomic_set(&sdp->open_cnt, 0);
+		rem_open_cnt = 0;
+		pr_err("%s: open_cnt went negative, fix\n", __func__);
+	}
+	/* possibly many open()s waiting on exlude clearing, start many;
+	 * only open(O_EXCL)s wait on 0==rem_open_cnt so only start one */
+	if (atomic_add_unless(&sdp->exclude, -1, 0))
+		wake_up_interruptible_all(&sdp->open_wait);
+	else if (0 == rem_open_cnt)
+		wake_up_interruptible(&sdp->open_wait);
+	mutex_unlock(&sdp->open_rel_lock);
 	return 0;
 }
 
@@ -419,7 +428,7 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 	}
 	srp = sg_get_rq_mark(sfp, req_pack_id);
 	if (!srp) {		/* now wait on packet to arrive */
-		if (sdp->detached) {
+		if (atomic_read(&sdp->detaching)) {
 			retval = -ENODEV;
 			goto free_old_hdr;
 		}
@@ -428,9 +437,9 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 			goto free_old_hdr;
 		}
 		retval = wait_event_interruptible(sfp->read_wait,
-			(sdp->detached ||
+			(atomic_read(&sdp->detaching) ||
 			(srp = sg_get_rq_mark(sfp, req_pack_id))));
-		if (sdp->detached) {
+		if (atomic_read(&sdp->detaching)) {
 			retval = -ENODEV;
 			goto free_old_hdr;
 		}
@@ -572,7 +581,7 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 		return -ENXIO;
 	SCSI_LOG_TIMEOUT(3, printk("sg_write: %s, count=%d\n",
 				   sdp->disk->disk_name, (int) count));
-	if (sdp->detached)
+	if (atomic_read(&sdp->detaching))
 		return -ENODEV;
 	if (!((filp->f_flags & O_NONBLOCK) ||
 	      scsi_block_when_processing_errors(sdp->device)))
@@ -764,7 +773,7 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
 		sg_finish_rem_req(srp);
 		return k;	/* probably out of space --> ENOMEM */
 	}
-	if (sdp->detached) {
+	if (atomic_read(&sdp->detaching)) {
 		if (srp->bio)
 			blk_end_request_all(srp->rq, -EIO);
 		sg_finish_rem_req(srp);
@@ -826,7 +835,7 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 
 	switch (cmd_in) {
 	case SG_IO:
-		if (sdp->detached)
+		if (atomic_read(&sdp->detaching))
 			return -ENODEV;
 		if (!scsi_block_when_processing_errors(sdp->device))
 			return -ENXIO;
@@ -837,8 +846,8 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 		if (result < 0)
 			return result;
 		result = wait_event_interruptible(sfp->read_wait,
-			(srp_done(sfp, srp) || sdp->detached));
-		if (sdp->detached)
+			(srp_done(sfp, srp) || atomic_read(&sdp->detaching)));
+		if (atomic_read(&sdp->detaching))
 			return -ENODEV;
 		write_lock_irq(&sfp->rq_list_lock);
 		if (srp->done) {
@@ -877,7 +886,7 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 				sg_build_reserve(sfp, val);
 			}
 		} else {
-			if (sdp->detached)
+			if (atomic_read(&sdp->detaching))
 				return -ENODEV;
 			sfp->low_dma = sdp->device->host->unchecked_isa_dma;
 		}
@@ -890,7 +899,7 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 		else {
 			sg_scsi_id_t __user *sg_idp = p;
 
-			if (sdp->detached)
+			if (atomic_read(&sdp->detaching))
 				return -ENODEV;
 			__put_user((int) sdp->device->host->host_no,
 				   &sg_idp->host_no);
@@ -1032,11 +1041,11 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 			return result;
 		}
 	case SG_EMULATED_HOST:
-		if (sdp->detached)
+		if (atomic_read(&sdp->detaching))
 			return -ENODEV;
 		return put_user(sdp->device->host->hostt->emulated, ip);
 	case SG_SCSI_RESET:
-		if (sdp->detached)
+		if (atomic_read(&sdp->detaching))
 			return -ENODEV;
 		if (filp->f_flags & O_NONBLOCK) {
 			if (scsi_host_in_recovery(sdp->device->host))
@@ -1069,7 +1078,7 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 		return (scsi_reset_provider(sdp->device, val) ==
 			SUCCESS) ? 0 : -EIO;
 	case SCSI_IOCTL_SEND_COMMAND:
-		if (sdp->detached)
+		if (atomic_read(&sdp->detaching))
 			return -ENODEV;
 		if (read_only) {
 			unsigned char opcode = WRITE_6;
@@ -1091,7 +1100,7 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 	case SCSI_IOCTL_GET_BUS_NUMBER:
 	case SCSI_IOCTL_PROBE_HOST:
 	case SG_GET_TRANSFORM:
-		if (sdp->detached)
+		if (atomic_read(&sdp->detaching))
 			return -ENODEV;
 		return scsi_ioctl(sdp->device, cmd_in, p);
 	case BLKSECTGET:
@@ -1165,7 +1174,7 @@ sg_poll(struct file *filp, poll_table * wait)
 	}
 	read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 
-	if (sdp->detached)
+	if (atomic_read(&sdp->detaching))
 		res |= POLLHUP;
 	else if (!sfp->cmd_q) {
 		if (0 == count)
@@ -1264,7 +1273,8 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 	return 0;
 }
 
-static void sg_rq_end_io_usercontext(struct work_struct *work)
+static void
+sg_rq_end_io_usercontext(struct work_struct *work)
 {
 	struct sg_request *srp = container_of(work, struct sg_request, ew.work);
 	struct sg_fd *sfp = srp->parentfp;
@@ -1277,7 +1287,8 @@ static void sg_rq_end_io_usercontext(struct work_struct *work)
  * This function is a "bottom half" handler that is called by the mid
  * level when a command is completed (or has failed).
  */
-static void sg_rq_end_io(struct request *rq, int uptodate)
+static void
+sg_rq_end_io(struct request *rq, int uptodate)
 {
 	struct sg_request *srp = rq->end_io_data;
 	Sg_device *sdp;
@@ -1295,8 +1306,8 @@ static void sg_rq_end_io(struct request *rq, int uptodate)
 		return;
 
 	sdp = sfp->parentdp;
-	if (unlikely(sdp->detached))
-		printk(KERN_INFO "sg_rq_end_io: device detached\n");
+	if (unlikely(atomic_read(&sdp->detaching)))
+		pr_info("%s: device detaching\n", __func__);
 
 	sense = rq->sense;
 	result = rq->errors;
@@ -1319,7 +1330,7 @@ static void sg_rq_end_io(struct request *rq, int uptodate)
 		if ((sdp->sgdebug > 0) &&
 		    ((CHECK_CONDITION == srp->header.masked_status) ||
 		     (COMMAND_TERMINATED == srp->header.masked_status)))
-			__scsi_print_sense("sg_cmd_done", sense,
+			__scsi_print_sense(__func__, sense,
 					   SCSI_SENSE_BUFFERSIZE);
 
 		/* Following if statement is a patch supplied by Eric Youngdale */
@@ -1378,7 +1389,8 @@ static struct class *sg_sysfs_class;
 
 static int sg_sysfs_valid = 0;
 
-static Sg_device *sg_alloc(struct gendisk *disk, struct scsi_device *scsidp)
+static Sg_device *
+sg_alloc(struct gendisk *disk, struct scsi_device *scsidp)
 {
 	struct request_queue *q = scsidp->request_queue;
 	Sg_device *sdp;
@@ -1388,7 +1400,8 @@ static Sg_device *sg_alloc(struct gendisk *disk, struct scsi_device *scsidp)
 
 	sdp = kzalloc(sizeof(Sg_device), GFP_KERNEL);
 	if (!sdp) {
-		printk(KERN_WARNING "kmalloc Sg_device failure\n");
+		sdev_printk(KERN_WARNING, scsidp, "%s: kmalloc Sg_device "
+			    "failure\n", __func__);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -1403,8 +1416,9 @@ static Sg_device *sg_alloc(struct gendisk *disk, struct scsi_device *scsidp)
 				    scsidp->type, SG_MAX_DEVS - 1);
 			error = -ENODEV;
 		} else {
-			printk(KERN_WARNING
-			       "idr allocation Sg_device failure: %d\n", error);
+			sdev_printk(KERN_WARNING, scsidp, "%s: idr "
+				    "allocation Sg_device failure: %d\n",
+				    __func__, error);
 		}
 		goto out_unlock;
 	}
@@ -1415,8 +1429,13 @@ static Sg_device *sg_alloc(struct gendisk *disk, struct scsi_device *scsidp)
 	disk->first_minor = k;
 	sdp->disk = disk;
 	sdp->device = scsidp;
+	mutex_init(&sdp->open_rel_lock);
 	INIT_LIST_HEAD(&sdp->sfds);
-	init_waitqueue_head(&sdp->o_excl_wait);
+	init_waitqueue_head(&sdp->open_wait);
+	atomic_set(&sdp->detaching, 0);
+	atomic_set(&sdp->exclude, 0);
+	atomic_set(&sdp->open_cnt, 0);
+	rwlock_init(&sdp->sfd_lock);
 	sdp->sg_tablesize = queue_max_segments(q);
 	sdp->index = k;
 	kref_init(&sdp->d_ref);
@@ -1434,7 +1453,7 @@ out_unlock:
 }
 
 static int
-sg_add(struct device *cl_dev, struct class_interface *cl_intf)
+sg_add_device(struct device *cl_dev, struct class_interface *cl_intf)
 {
 	struct scsi_device *scsidp = to_scsi_device(cl_dev->parent);
 	struct gendisk *disk;
@@ -1445,7 +1464,7 @@ sg_add(struct device *cl_dev, struct class_interface *cl_intf)
 
 	disk = alloc_disk(1);
 	if (!disk) {
-		printk(KERN_WARNING "alloc_disk failed\n");
+		pr_warn("%s: alloc_disk failed\n", __func__);
 		return -ENOMEM;
 	}
 	disk->major = SCSI_GENERIC_MAJOR;
@@ -1453,7 +1472,7 @@ sg_add(struct device *cl_dev, struct class_interface *cl_intf)
 	error = -ENOMEM;
 	cdev = cdev_alloc();
 	if (!cdev) {
-		printk(KERN_WARNING "cdev_alloc failed\n");
+		pr_warn("%s: cdev_alloc failed\n", __func__);
 		goto out;
 	}
 	cdev->owner = THIS_MODULE;
@@ -1461,7 +1480,7 @@ sg_add(struct device *cl_dev, struct class_interface *cl_intf)
 
 	sdp = sg_alloc(disk, scsidp);
 	if (IS_ERR(sdp)) {
-		printk(KERN_WARNING "sg_alloc failed\n");
+		pr_warn("%s: sg_alloc failed\n", __func__);
 		error = PTR_ERR(sdp);
 		goto out;
 	}
@@ -1479,22 +1498,20 @@ sg_add(struct device *cl_dev, struct class_interface *cl_intf)
 						      sdp->index),
 						sdp, "%s", disk->disk_name);
 		if (IS_ERR(sg_class_member)) {
-			printk(KERN_ERR "sg_add: "
-			       "device_create failed\n");
+			pr_err("%s: device_create failed\n", __func__);
 			error = PTR_ERR(sg_class_member);
 			goto cdev_add_err;
 		}
 		error = sysfs_create_link(&scsidp->sdev_gendev.kobj,
 					  &sg_class_member->kobj, "generic");
 		if (error)
-			printk(KERN_ERR "sg_add: unable to make symlink "
-					"'generic' back to sg%d\n", sdp->index);
+			pr_err("%s: unable to make symlink 'generic' back "
+			       "to sg%d\n", __func__, sdp->index);
 	} else
-		printk(KERN_WARNING "sg_add: sg_sys Invalid\n");
+		pr_warn("%s: sg_sys Invalid\n", __func__);
 
-	sdev_printk(KERN_NOTICE, scsidp,
-		    "Attached scsi generic sg%d type %d\n", sdp->index,
-		    scsidp->type);
+	sdev_printk(KERN_NOTICE, scsidp, "Attached scsi generic sg%d "
+		    "type %d\n", sdp->index, scsidp->type);
 
 	dev_set_drvdata(cl_dev, sdp);
 
@@ -1513,7 +1530,8 @@ out:
 	return error;
 }
 
-static void sg_device_destroy(struct kref *kref)
+static void
+sg_device_destroy(struct kref *kref)
 {
 	struct sg_device *sdp = container_of(kref, struct sg_device, d_ref);
 	unsigned long flags;
@@ -1535,33 +1553,39 @@ static void sg_device_destroy(struct kref *kref)
 	kfree(sdp);
 }
 
-static void sg_remove(struct device *cl_dev, struct class_interface *cl_intf)
+static void
+sg_remove_device(struct device *cl_dev, struct class_interface *cl_intf)
 {
 	struct scsi_device *scsidp = to_scsi_device(cl_dev->parent);
 	Sg_device *sdp = dev_get_drvdata(cl_dev);
 	unsigned long iflags;
 	Sg_fd *sfp;
+	int val;
 
-	if (!sdp || sdp->detached)
+	if (!sdp)
 		return;
+	/* want sdp->detaching non-zero as soon as possible */
+	val = atomic_inc_return(&sdp->detaching);
+	if (val > 1)
+		return; /* only want to do following once per device */
 
-	SCSI_LOG_TIMEOUT(3, printk("sg_remove: %s\n", sdp->disk->disk_name));
+	SCSI_LOG_TIMEOUT(3, printk("%s: %s\n", __func__,
+			 sdp->disk->disk_name));
 
-	/* Need a write lock to set sdp->detached. */
-	write_lock_irqsave(&sg_index_lock, iflags);
-	sdp->detached = 1;
+	read_lock_irqsave(&sdp->sfd_lock, iflags);
 	list_for_each_entry(sfp, &sdp->sfds, sfd_siblings) {
-		wake_up_interruptible(&sfp->read_wait);
+		wake_up_interruptible_all(&sfp->read_wait);
 		kill_fasync(&sfp->async_qp, SIGPOLL, POLL_HUP);
 	}
-	write_unlock_irqrestore(&sg_index_lock, iflags);
+	wake_up_interruptible_all(&sdp->open_wait);
+	read_unlock_irqrestore(&sdp->sfd_lock, iflags);
 
 	sysfs_remove_link(&scsidp->sdev_gendev.kobj, "generic");
 	device_destroy(sg_sysfs_class, MKDEV(SCSI_GENERIC_MAJOR, sdp->index));
 	cdev_del(sdp->cdev);
 	sdp->cdev = NULL;
 
-	sg_put_dev(sdp);
+	kref_put(&sdp->d_ref, sg_device_destroy);
 }
 
 module_param_named(scatter_elem_sz, scatter_elem_sz, int, S_IRUGO | S_IWUSR);
@@ -1631,7 +1655,8 @@ exit_sg(void)
 	idr_destroy(&sg_index_idr);
 }
 
-static int sg_start_req(Sg_request *srp, unsigned char *cmd)
+static int
+sg_start_req(Sg_request *srp, unsigned char *cmd)
 {
 	int res;
 	struct request *rq;
@@ -1726,7 +1751,8 @@ static int sg_start_req(Sg_request *srp, unsigned char *cmd)
 	return res;
 }
 
-static int sg_finish_rem_req(Sg_request * srp)
+static int
+sg_finish_rem_req(Sg_request *srp)
 {
 	int ret = 0;
 
@@ -2063,7 +2089,7 @@ sg_add_sfp(Sg_device * sdp, int dev)
 
 	sfp = kzalloc(sizeof(*sfp), GFP_ATOMIC | __GFP_NOWARN);
 	if (!sfp)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	init_waitqueue_head(&sfp->read_wait);
 	rwlock_init(&sfp->rq_list_lock);
@@ -2077,9 +2103,13 @@ sg_add_sfp(Sg_device * sdp, int dev)
 	sfp->cmd_q = SG_DEF_COMMAND_Q;
 	sfp->keep_orphan = SG_DEF_KEEP_ORPHAN;
 	sfp->parentdp = sdp;
-	write_lock_irqsave(&sg_index_lock, iflags);
+	write_lock_irqsave(&sdp->sfd_lock, iflags);
+	if (atomic_read(&sdp->detaching)) {
+		write_unlock_irqrestore(&sdp->sfd_lock, iflags);
+		return ERR_PTR(-ENODEV);
+	}
 	list_add_tail(&sfp->sfd_siblings, &sdp->sfds);
-	write_unlock_irqrestore(&sg_index_lock, iflags);
+	write_unlock_irqrestore(&sdp->sfd_lock, iflags);
 	SCSI_LOG_TIMEOUT(3, printk("sg_add_sfp: sfp=0x%p\n", sfp));
 	if (unlikely(sg_big_buff != def_reserved_size))
 		sg_big_buff = def_reserved_size;
@@ -2095,7 +2125,8 @@ sg_add_sfp(Sg_device * sdp, int dev)
 	return sfp;
 }
 
-static void sg_remove_sfp_usercontext(struct work_struct *work)
+static void
+sg_remove_sfp_usercontext(struct work_struct *work)
 {
 	struct sg_fd *sfp = container_of(work, struct sg_fd, ew.work);
 	struct sg_device *sdp = sfp->parentdp;
@@ -2119,20 +2150,20 @@ static void sg_remove_sfp_usercontext(struct work_struct *work)
 	kfree(sfp);
 
 	scsi_device_put(sdp->device);
-	sg_put_dev(sdp);
+	kref_put(&sdp->d_ref, sg_device_destroy);
 	module_put(THIS_MODULE);
 }
 
-static void sg_remove_sfp(struct kref *kref)
+static void
+sg_remove_sfp(struct kref *kref)
 {
 	struct sg_fd *sfp = container_of(kref, struct sg_fd, f_ref);
 	struct sg_device *sdp = sfp->parentdp;
 	unsigned long iflags;
 
-	write_lock_irqsave(&sg_index_lock, iflags);
+	write_lock_irqsave(&sdp->sfd_lock, iflags);
 	list_del(&sfp->sfd_siblings);
-	write_unlock_irqrestore(&sg_index_lock, iflags);
-	wake_up_interruptible(&sdp->o_excl_wait);
+	write_unlock_irqrestore(&sdp->sfd_lock, iflags);
 
 	INIT_WORK(&sfp->ew.work, sg_remove_sfp_usercontext);
 	schedule_work(&sfp->ew.work);
@@ -2183,7 +2214,8 @@ static Sg_device *sg_lookup_dev(int dev)
 	return idr_find(&sg_index_idr, dev);
 }
 
-static Sg_device *sg_get_dev(int dev)
+static Sg_device *
+sg_get_dev(int dev)
 {
 	struct sg_device *sdp;
 	unsigned long flags;
@@ -2192,8 +2224,8 @@ static Sg_device *sg_get_dev(int dev)
 	sdp = sg_lookup_dev(dev);
 	if (!sdp)
 		sdp = ERR_PTR(-ENXIO);
-	else if (sdp->detached) {
-		/* If sdp->detached, then the refcount may already be 0, in
+	else if (atomic_read(&sdp->detaching)) {
+		/* If sdp->detaching, then the refcount may already be 0, in
 		 * which case it would be a bug to do kref_get().
 		 */
 		sdp = ERR_PTR(-ENODEV);
@@ -2204,11 +2236,6 @@ static Sg_device *sg_get_dev(int dev)
 	return sdp;
 }
 
-static void sg_put_dev(struct sg_device *sdp)
-{
-	kref_put(&sdp->d_ref, sg_device_destroy);
-}
-
 #ifdef CONFIG_SCSI_PROC_FS
 
 static struct proc_dir_entry *sg_proc_sgp = NULL;
@@ -2425,8 +2452,7 @@ static int sg_proc_single_open_version(struct inode *inode, struct file *file)
 
 static int sg_proc_seq_show_devhdr(struct seq_file *s, void *v)
 {
-	seq_printf(s, "host\tchan\tid\tlun\ttype\topens\tqdepth\tbusy\t"
-		   "online\n");
+	seq_puts(s, "host\tchan\tid\tlun\ttype\topens\tqdepth\tbusy\tonline\n");
 	return 0;
 }
 
@@ -2482,7 +2508,11 @@ static int sg_proc_seq_show_dev(struct seq_file *s, void *v)
 
 	read_lock_irqsave(&sg_index_lock, iflags);
 	sdp = it ? sg_lookup_dev(it->index) : NULL;
-	if (sdp && (scsidp = sdp->device) && (!sdp->detached))
+	if ((NULL == sdp) || (NULL == sdp->device) ||
+	    (atomic_read(&sdp->detaching)))
+		seq_puts(s, "-1\t-1\t-1\t-1\t-1\t-1\t-1\t-1\t-1\n");
+	else {
+		scsidp = sdp->device;
 		seq_printf(s, "%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n",
 			      scsidp->host->host_no, scsidp->channel,
 			      scsidp->id, scsidp->lun, (int) scsidp->type,
@@ -2490,8 +2520,7 @@ static int sg_proc_seq_show_dev(struct seq_file *s, void *v)
 			      (int) scsidp->queue_depth,
 			      (int) scsidp->device_busy,
 			      (int) scsi_device_online(scsidp));
-	else
-		seq_printf(s, "-1\t-1\t-1\t-1\t-1\t-1\t-1\t-1\t-1\n");
+	}
 	read_unlock_irqrestore(&sg_index_lock, iflags);
 	return 0;
 }
@@ -2510,11 +2539,12 @@ static int sg_proc_seq_show_devstrs(struct seq_file *s, void *v)
 
 	read_lock_irqsave(&sg_index_lock, iflags);
 	sdp = it ? sg_lookup_dev(it->index) : NULL;
-	if (sdp && (scsidp = sdp->device) && (!sdp->detached))
+	scsidp = sdp ? sdp->device : NULL;
+	if (sdp && scsidp && (!atomic_read(&sdp->detaching)))
 		seq_printf(s, "%8.8s\t%16.16s\t%4.4s\n",
 			   scsidp->vendor, scsidp->model, scsidp->rev);
 	else
-		seq_printf(s, "<no active device>\n");
+		seq_puts(s, "<no active device>\n");
 	read_unlock_irqrestore(&sg_index_lock, iflags);
 	return 0;
 }
@@ -2559,12 +2589,12 @@ static void sg_proc_debug_helper(struct seq_file *s, Sg_device * sdp)
 				else
 					cp = "     ";
 			}
-			seq_printf(s, cp);
+			seq_puts(s, cp);
 			blen = srp->data.bufflen;
 			usg = srp->data.k_use_sg;
-			seq_printf(s, srp->done ? 
-				   ((1 == srp->done) ?  "rcv:" : "fin:")
-				   : "act:");
+			seq_puts(s, srp->done ?
+				 ((1 == srp->done) ?  "rcv:" : "fin:")
+				  : "act:");
 			seq_printf(s, " id=%d blen=%d",
 				   srp->header.pack_id, blen);
 			if (srp->done)
@@ -2580,7 +2610,7 @@ static void sg_proc_debug_helper(struct seq_file *s, Sg_device * sdp)
 				   (int) srp->data.cmd_opcode);
 		}
 		if (0 == m)
-			seq_printf(s, "     No requests active\n");
+			seq_puts(s, "     No requests active\n");
 		read_unlock(&fp->rq_list_lock);
 	}
 }
@@ -2596,31 +2626,35 @@ static int sg_proc_seq_show_debug(struct seq_file *s, void *v)
 	Sg_device *sdp;
 	unsigned long iflags;
 
-	if (it && (0 == it->index)) {
-		seq_printf(s, "max_active_device=%d(origin 1)\n",
-			   (int)it->max);
-		seq_printf(s, " def_reserved_size=%d\n", sg_big_buff);
-	}
+	if (it && (0 == it->index))
+		seq_printf(s, "max_active_device=%d  def_reserved_size=%d\n",
+			   (int)it->max, sg_big_buff);
 
 	read_lock_irqsave(&sg_index_lock, iflags);
 	sdp = it ? sg_lookup_dev(it->index) : NULL;
-	if (sdp && !list_empty(&sdp->sfds)) {
-		struct scsi_device *scsidp = sdp->device;
-
+	if (NULL == sdp)
+		goto skip;
+	read_lock(&sdp->sfd_lock);
+	if (!list_empty(&sdp->sfds)) {
 		seq_printf(s, " >>> device=%s ", sdp->disk->disk_name);
-		if (sdp->detached)
-			seq_printf(s, "detached pending close ");
-		else
-			seq_printf
-			    (s, "scsi%d chan=%d id=%d lun=%d   em=%d",
-			     scsidp->host->host_no,
-			     scsidp->channel, scsidp->id,
-			     scsidp->lun,
-			     scsidp->host->hostt->emulated);
-		seq_printf(s, " sg_tablesize=%d excl=%d\n",
-			   sdp->sg_tablesize, get_exclude(sdp));
+		if (atomic_read(&sdp->detaching))
+			seq_puts(s, "detaching pending close ");
+		else if (sdp->device) {
+			struct scsi_device *scsidp = sdp->device;
+
+			seq_printf(s, "%d:%d:%d:%d   em=%d",
+				   scsidp->host->host_no,
+				   scsidp->channel, scsidp->id,
+				   scsidp->lun,
+				   scsidp->host->hostt->emulated);
+		}
+		seq_printf(s, " sg_tablesize=%d excl=%d open_cnt=%d\n",
+			   sdp->sg_tablesize, atomic_read(&sdp->exclude),
+			   atomic_read(&sdp->open_cnt));
 		sg_proc_debug_helper(s, sdp);
 	}
+	read_unlock(&sdp->sfd_lock);
+skip:
 	read_unlock_irqrestore(&sg_index_lock, iflags);
 	return 0;
 }

--------------040701060501020801080806--
