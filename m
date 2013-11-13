From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH v3] sg: O_EXCL and other lock handling
Date: Tue, 12 Nov 2013 19:58:28 -0500
Message-ID: <5282CEB4.4050708@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080407090901070303070100"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:36709 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435Ab3KMA6u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Nov 2013 19:58:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>
Cc: vaughan <vaughan.cao@oracle.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, linux-kernel <linux-kernel@vger.kernel.org>

This is a multi-part message in MIME format.
--------------080407090901070303070100
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

After feedback on version 2 and a new report of a failure
in the vicinity of sg_remove() [remove device] during
a shutdown on a large machine, the locking has been
revised again.

ChangeLog v3:
   - change Sg_device::exclude and detached (renamed to
     detaching) to atomic_t
   - introduce atomic_t Sg_device::open_cnt and use for
     open(O_EXCL) logic. Hence stop using list_empty(sfds)
     which decouples the open/release logic from
     sg_remove_device() and other post-release cleanup
     functions
   - use a mutex to stop races between sg_open() and
     sg_release() on the same device
   - reduce the use of driver wide sg_index_lock so now
     it only protects sg_index_idr (the device array)
   - expand cleanups requested by checkpatch.pl to the
     remaining code in the driver

ChangeLog v2:
   - favour non O_EXCL open()s over open(dev, O_EXCL)s
   - wake all open(dev)s if dev is removed (detached)
   - wake all read(dev_fd)s that are waiting for a response
     if dev is removed (detached)
   - other cleanups requested by checkpatch.pl

ChangeLog v1:
   - introduce a finer grain (per device) lock to protect
     access and changes to the file descriptor objects
   - introduce a semaphore for mutual exclusion of co-incident
     open and release calls to the same device
   - improve the O_EXCL handling of sg_open() when multiple
     callers are waiting for an O_EXCL condition to clear
   - change some seq_printf()s to seq_puts()s as requested
     by checkpatch.pl
   - update copyright notice, version number and date


The patch is against lk 3.12.0 (and should work on lk 3.10
and lk 3.11 as the sg driver hasn't changed).

Testing is ongoing (see the v2 post) with focus on host
removal and shutdown. The driver survives bombarding 4 LUs
with queued requests spread across 6000 scsi_debug LUs.
Some log noise is generated, but it is not from the sg
driver:
   scsi 9:0:33:3: rejecting I/O to offline device
   scsi 9:0:33:3: [sg1000] killing request
<multiple times>

This is not seen when there are only 600 LUs.


Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

--------------080407090901070303070100
Content-Type: text/x-patch;
 name="sg.c_race_excl_dg2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sg.c_race_excl_dg2.patch"

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index df5e961..843c66e 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -7,9 +7,7 @@
  * Original driver (sg.c):
  *        Copyright (C) 1992 Lawrence Foard
  * Version 2 and 3 extensions to driver:
- *        Copyright (C) 1998 - 2005 Douglas Gilbert
- *
- *  Modified  19-JAN-1998  Richard Gooch <rgooch@atnf.csiro.au>  Devfs support
+ *        Copyright (C) 1998 - 2013 Douglas Gilbert
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -18,8 +16,8 @@
  *
  */
 
-static int sg_version_num = 30534;	/* 2 digits for each component */
-#define SG_VERSION_STR "3.5.34"
+static int sg_version_num = 30535;	/* 2 digits for each component */
+#define SG_VERSION_STR "3.5.35"
 
 /*
  *  D. P. Gilbert (dgilbert@interlog.com, dougg@triode.net.au), notes:
@@ -51,6 +49,7 @@ static int sg_version_num = 30534;	/* 2 digits for each component */
 #include <linux/delay.h>
 #include <linux/blktrace_api.h>
 #include <linux/mutex.h>
+#include <linux/atomic.h>
 #include <linux/ratelimit.h>
 
 #include "scsi.h"
@@ -64,7 +63,7 @@ static int sg_version_num = 30534;	/* 2 digits for each component */
 
 #ifdef CONFIG_SCSI_PROC_FS
 #include <linux/proc_fs.h>
-static char *sg_version_date = "20061027";
+static char *sg_version_date = "20131111";
 
 static int sg_proc_init(void);
 static void sg_proc_cleanup(void);
@@ -87,6 +86,8 @@ static void sg_proc_cleanup(void);
 
 #define SG_DEFAULT_TIMEOUT MULDIV(SG_DEFAULT_TIMEOUT_USER, HZ, USER_HZ)
 
+#define SG_LOG(LEVEL, CMD) SCSI_LOG_TIMEOUT(LEVEL, CMD)
+
 int sg_big_buff = SG_DEF_RESERVED_SIZE;
 /* N.B. This variable is readable and writeable via
    /proc/scsi/sg/def_reserved_size . Each time sg_open() is called a buffer
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
+	.add_dev	= sg_add_device,
+	.remove_dev	= sg_remove_device,
 };
 
 typedef struct sg_scatter_hold { /* holding area for scsi scatter gather info */
@@ -146,8 +145,7 @@ typedef struct sg_request {	/* SG_MAX_QUEUE requests outstanding per file */
 } Sg_request;
 
 typedef struct sg_fd {		/* holds the state of a file descriptor */
-	/* sfd_siblings is protected by sg_index_lock */
-	struct list_head sfd_siblings;
+	struct list_head sfd_siblings;	/* protected by device's sfd_lock */
 	struct sg_device *parentdp;	/* owning device */
 	wait_queue_head_t read_wait;	/* queue read until command done */
 	rwlock_t rq_list_lock;	/* protect access to list in req_arr */
@@ -170,14 +168,15 @@ typedef struct sg_fd {		/* holds the state of a file descriptor */
 
 typedef struct sg_device { /* holds the state of each scsi generic device */
 	struct scsi_device *device;
-	wait_queue_head_t o_excl_wait;	/* queue open() when O_EXCL in use */
+	wait_queue_head_t open_wait;	/* queue open() when O_EXCL present */
+	struct mutex open_rel_lock;	/* held when in open() or release() */
 	int sg_tablesize;	/* adapter's max scatter-gather table size */
 	u32 index;		/* device index number */
-	/* sfds is protected by sg_index_lock */
 	struct list_head sfds;
-	volatile char detached;	/* 0->attached, 1->detached pending removal */
-	/* exclude protected by sg_open_exclusive_lock */
-	char exclude;		/* opened for exclusive access */
+	rwlock_t sfd_lock;	/* protect access to sfd list */
+	atomic_t detaching;	/* 0->device usable, 1->device detaching */
+	atomic_t exclude;	/* 1->open(O_EXCL) succeeded and is active */
+	atomic_t open_cnt;	/* count of opens (perhaps < num(sfds) ) */
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
@@ -225,38 +224,19 @@ static int sg_allow_access(struct file *filp, unsigned char *cmd)
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
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&sg_open_exclusive_lock, flags);
-	sdp->exclude = val;
-	spin_unlock_irqrestore(&sg_open_exclusive_lock, flags);
-	return val;
-}
-
-static int sfds_list_empty(Sg_device *sdp)
+static int
+open_wait_event(Sg_device *sdp, int excl_case)
 {
-	unsigned long flags;
-	int ret;
+	int retval;
 
-	read_lock_irqsave(&sg_index_lock, flags);
-	ret = list_empty(&sdp->sfds);
-	read_unlock_irqrestore(&sg_index_lock, flags);
-	return ret;
+	retval = wait_event_interruptible(sdp->open_wait,
+			(atomic_read(&sdp->detaching)) ||
+			 (excl_case ? !atomic_read(&sdp->exclude)
+				    : (atomic_read(&sdp->open_cnt) < 1)));
+	return atomic_read(&sdp->detaching) ? -ENODEV : retval;
 }
 
+/* Returns 0 on success, else a negated errno value */
 static int
 sg_open(struct inode *inode, struct file *filp)
 {
@@ -265,18 +245,19 @@ sg_open(struct inode *inode, struct file *filp)
 	struct request_queue *q;
 	Sg_device *sdp;
 	Sg_fd *sfp;
-	int res;
 	int retval;
 
 	nonseekable_open(inode, filp);
-	SCSI_LOG_TIMEOUT(3, printk("sg_open: dev=%d, flags=0x%x\n", dev, flags));
+	SG_LOG(3, pr_info("%s: dev=%d, flags=0x%x\n", __func__, dev, flags));
+	if ((flags & O_EXCL) && (O_RDONLY == (flags & O_ACCMODE)))
+		return -EPERM; /* Can't lock it with read only access */
+
 	sdp = sg_get_dev(dev);
 	if (IS_ERR(sdp)) {
 		retval = PTR_ERR(sdp);
 		sdp = NULL;
 		goto sg_put;
 	}
-
 	/* This driver's module count bumped by fops_get in <linux/fs.h> */
 	/* Prevent the device driver from vanishing while we sleep */
 	retval = scsi_device_get(sdp->device);
@@ -287,6 +268,9 @@ sg_open(struct inode *inode, struct file *filp)
 	if (retval)
 		goto sdp_put;
 
+	/* scsi_block_when_processing_errors() may block so bypass
+	 * check if O_NONBLOCK. Permits SCSI commands to be issued
+	 * during error recovery. Tread carefully. */
 	if (!((flags & O_NONBLOCK) ||
 	      scsi_block_when_processing_errors(sdp->device))) {
 		retval = -ENXIO;
@@ -294,80 +278,101 @@ sg_open(struct inode *inode, struct file *filp)
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
+	if (atomic_read(&sdp->open_cnt) < 1) {	/* no existing opens */
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
+			atomic_set(&sdp->exclude, 0);	/* undo if error */
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
 
 	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
-	SCSI_LOG_TIMEOUT(3, printk("sg_release: %s\n", sdp->disk->disk_name));
-
-	set_exclude(sdp, 0);
-	wake_up_interruptible(&sdp->o_excl_wait);
+	SG_LOG(3, pr_info("%s: %s\n", __func__, sdp->disk->disk_name));
 
+	mutex_lock(&sdp->open_rel_lock);
 	scsi_autopm_put_device(sdp->device);
 	kref_put(&sfp->f_ref, sg_remove_sfp);
+	rem_open_cnt = atomic_dec_return(&sdp->open_cnt);
+	if (unlikely(rem_open_cnt < 0)) {
+		atomic_set(&sdp->open_cnt, 0);
+		rem_open_cnt = 0;
+		pr_err("%s: open_cnt went negative, fix\n", __func__);
+	}
+	/* possibly many open()s waiting on exlude clearing , start many;
+	 * only open(O_EXCL)s wait on 0==rem_open_cnt so only start one */
+	if (atomic_add_unless(&sdp->exclude, -1, 0))
+		wake_up_interruptible_all(&sdp->open_wait);
+	else if (0 == rem_open_cnt)
+		wake_up_interruptible(&sdp->open_wait);
+	mutex_unlock(&sdp->open_rel_lock);
 	return 0;
 }
 
@@ -384,8 +389,8 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 
 	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
-	SCSI_LOG_TIMEOUT(3, printk("sg_read: %s, count=%d\n",
-				   sdp->disk->disk_name, (int) count));
+	SG_LOG(3, pr_info("%s: %s, count=%d\n", __func__, sdp->disk->disk_name,
+	       (int) count));
 
 	if (!access_ok(VERIFY_WRITE, buf, count))
 		return -EFAULT;
@@ -419,7 +424,7 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 	}
 	srp = sg_get_rq_mark(sfp, req_pack_id);
 	if (!srp) {		/* now wait on packet to arrive */
-		if (sdp->detached) {
+		if (atomic_read(&sdp->detaching)) {
 			retval = -ENODEV;
 			goto free_old_hdr;
 		}
@@ -428,9 +433,9 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
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
@@ -570,9 +575,9 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 
 	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
-	SCSI_LOG_TIMEOUT(3, printk("sg_write: %s, count=%d\n",
-				   sdp->disk->disk_name, (int) count));
-	if (sdp->detached)
+	SG_LOG(3, pr_info("%s: %s, count=%d\n", __func__, sdp->disk->disk_name,
+	       (int) count));
+	if (atomic_read(&sdp->detaching))
 		return -ENODEV;
 	if (!((filp->f_flags & O_NONBLOCK) ||
 	      scsi_block_when_processing_errors(sdp->device)))
@@ -592,14 +597,15 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 		return -EIO;	/* The minimum scsi command length is 6 bytes. */
 
 	if (!(srp = sg_add_request(sfp))) {
-		SCSI_LOG_TIMEOUT(1, printk("sg_write: queue full\n"));
+		SG_LOG(1, pr_info("%s: queue full\n", __func__));
 		return -EDOM;
 	}
 	buf += SZ_SG_HEADER;
 	__get_user(opcode, buf);
 	if (sfp->next_cmd_len > 0) {
 		if (sfp->next_cmd_len > MAX_COMMAND_SIZE) {
-			SCSI_LOG_TIMEOUT(1, printk("sg_write: command length too long\n"));
+			SG_LOG(1, pr_info("%s: command length too long\n",
+			       __func__));
 			sfp->next_cmd_len = 0;
 			sg_remove_request(sfp, srp);
 			return -EIO;
@@ -611,8 +617,8 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 		if ((opcode >= 0xc0) && old_hdr.twelve_byte)
 			cmd_size = 12;
 	}
-	SCSI_LOG_TIMEOUT(4, printk(
-		"sg_write:   scsi opcode=0x%02x, cmd_size=%d\n", (int) opcode, cmd_size));
+	SG_LOG(4, pr_info("%s:   scsi opcode=0x%02x, cmd_size=%d\n", __func__,
+	       (int) opcode, cmd_size));
 /* Determine buffer size.  */
 	input_size = count - cmd_size;
 	mxsize = (input_size > old_hdr.reply_len) ? input_size : old_hdr.reply_len;
@@ -686,7 +692,7 @@ sg_new_write(Sg_fd *sfp, struct file *file, const char __user *buf,
 
 	sfp->cmd_q = 1;	/* when sg_io_hdr seen, set command queuing on */
 	if (!(srp = sg_add_request(sfp))) {
-		SCSI_LOG_TIMEOUT(1, printk("sg_new_write: queue full\n"));
+		SG_LOG(1, pr_info("%s: queue full\n", __func__));
 		return -EDOM;
 	}
 	srp->sg_io_owned = sg_io_owned;
@@ -755,16 +761,16 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
 	hp->host_status = 0;
 	hp->driver_status = 0;
 	hp->resid = 0;
-	SCSI_LOG_TIMEOUT(4, printk("sg_common_write:  scsi opcode=0x%02x, cmd_size=%d\n",
-			  (int) cmnd[0], (int) hp->cmd_len));
+	SG_LOG(4, pr_info("%s:  scsi opcode=0x%02x, cmd_size=%d\n", __func__,
+	       (int) cmnd[0], (int) hp->cmd_len));
 
 	k = sg_start_req(srp, cmnd);
 	if (k) {
-		SCSI_LOG_TIMEOUT(1, printk("sg_common_write: start_req err=%d\n", k));
+		SG_LOG(1, pr_info("%s: start_req err=%d\n", __func__, k));
 		sg_finish_rem_req(srp);
 		return k;	/* probably out of space --> ENOMEM */
 	}
-	if (sdp->detached) {
+	if (atomic_read(&sdp->detaching)) {
 		if (srp->bio)
 			blk_end_request_all(srp->rq, -EIO);
 		sg_finish_rem_req(srp);
@@ -820,13 +826,13 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
 
-	SCSI_LOG_TIMEOUT(3, printk("sg_ioctl: %s, cmd=0x%x\n",
-				   sdp->disk->disk_name, (int) cmd_in));
+	SG_LOG(3, pr_info("%s: %s, cmd=0x%x\n", __func__, sdp->disk->disk_name,
+	       (int) cmd_in));
 	read_only = (O_RDWR != (filp->f_flags & O_ACCMODE));
 
 	switch (cmd_in) {
 	case SG_IO:
-		if (sdp->detached)
+		if (atomic_read(&sdp->detaching))
 			return -ENODEV;
 		if (!scsi_block_when_processing_errors(sdp->device))
 			return -ENXIO;
@@ -837,8 +843,8 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
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
@@ -877,7 +883,7 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 				sg_build_reserve(sfp, val);
 			}
 		} else {
-			if (sdp->detached)
+			if (atomic_read(&sdp->detaching))
 				return -ENODEV;
 			sfp->low_dma = sdp->device->host->unchecked_isa_dma;
 		}
@@ -890,7 +896,7 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 		else {
 			sg_scsi_id_t __user *sg_idp = p;
 
-			if (sdp->detached)
+			if (atomic_read(&sdp->detaching))
 				return -ENODEV;
 			__put_user((int) sdp->device->host->host_no,
 				   &sg_idp->host_no);
@@ -993,7 +999,7 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 			unsigned int ms;
 
 			rinfo = kmalloc(SZ_SG_REQ_INFO * SG_MAX_QUEUE,
-								GFP_KERNEL);
+					GFP_KERNEL);
 			if (!rinfo)
 				return -ENOMEM;
 			read_lock_irqsave(&sfp->rq_list_lock, iflags);
@@ -1032,11 +1038,11 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
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
@@ -1069,7 +1075,7 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 		return (scsi_reset_provider(sdp->device, val) ==
 			SUCCESS) ? 0 : -EIO;
 	case SCSI_IOCTL_SEND_COMMAND:
-		if (sdp->detached)
+		if (atomic_read(&sdp->detaching))
 			return -ENODEV;
 		if (read_only) {
 			unsigned char opcode = WRITE_6;
@@ -1091,7 +1097,7 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 	case SCSI_IOCTL_GET_BUS_NUMBER:
 	case SCSI_IOCTL_PROBE_HOST:
 	case SG_GET_TRANSFORM:
-		if (sdp->detached)
+		if (atomic_read(&sdp->detaching))
 			return -ENODEV;
 		return scsi_ioctl(sdp->device, cmd_in, p);
 	case BLKSECTGET:
@@ -1165,15 +1171,15 @@ sg_poll(struct file *filp, poll_table * wait)
 	}
 	read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 
-	if (sdp->detached)
+	if (atomic_read(&sdp->detaching))
 		res |= POLLHUP;
 	else if (!sfp->cmd_q) {
 		if (0 == count)
 			res |= POLLOUT | POLLWRNORM;
 	} else if (count < SG_MAX_QUEUE)
 		res |= POLLOUT | POLLWRNORM;
-	SCSI_LOG_TIMEOUT(3, printk("sg_poll: %s, res=0x%x\n",
-				   sdp->disk->disk_name, (int) res));
+	SG_LOG(3, pr_info("%s: %s, res=0x%x\n", __func__, sdp->disk->disk_name,
+	       (int) res));
 	return res;
 }
 
@@ -1185,8 +1191,8 @@ sg_fasync(int fd, struct file *filp, int mode)
 
 	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
-	SCSI_LOG_TIMEOUT(3, printk("sg_fasync: %s, mode=%d\n",
-				   sdp->disk->disk_name, mode));
+	SG_LOG(3, pr_info("%s: %s, mode=%d\n", __func__, sdp->disk->disk_name,
+	       mode));
 
 	return fasync_helper(fd, filp, mode, &sfp->async_qp);
 }
@@ -1205,8 +1211,8 @@ sg_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	offset = vmf->pgoff << PAGE_SHIFT;
 	if (offset >= rsv_schp->bufflen)
 		return VM_FAULT_SIGBUS;
-	SCSI_LOG_TIMEOUT(3, printk("sg_vma_fault: offset=%lu, scatg=%d\n",
-				   offset, rsv_schp->k_use_sg));
+	SG_LOG(3, pr_info("%s: offset=%lu, scatg=%d\n", __func__, offset,
+	       rsv_schp->k_use_sg));
 	sa = vma->vm_start;
 	length = 1 << (PAGE_SHIFT + rsv_schp->page_order);
 	for (k = 0; k < rsv_schp->k_use_sg && sa < vma->vm_end; k++) {
@@ -1241,8 +1247,8 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 	if ((!filp) || (!vma) || (!(sfp = (Sg_fd *) filp->private_data)))
 		return -ENXIO;
 	req_sz = vma->vm_end - vma->vm_start;
-	SCSI_LOG_TIMEOUT(3, printk("sg_mmap starting, vm_start=%p, len=%d\n",
-				   (void *) vma->vm_start, (int) req_sz));
+	SG_LOG(3, pr_info("%s: starting, vm_start=%p, len=%d\n", __func__,
+	       (void *) vma->vm_start, (int) req_sz));
 	if (vma->vm_pgoff)
 		return -EINVAL;	/* want no offset */
 	rsv_schp = &sfp->reserve;
@@ -1295,15 +1301,15 @@ static void sg_rq_end_io(struct request *rq, int uptodate)
 		return;
 
 	sdp = sfp->parentdp;
-	if (unlikely(sdp->detached))
-		printk(KERN_INFO "sg_rq_end_io: device detached\n");
+	if (unlikely(atomic_read(&sdp->detaching)))
+		SG_LOG(4, pr_info("%s: device detaching\n", __func__));
 
 	sense = rq->sense;
 	result = rq->errors;
 	resid = rq->resid_len;
 
-	SCSI_LOG_TIMEOUT(4, printk("sg_cmd_done: %s, pack_id=%d, res=0x%x\n",
-		sdp->disk->disk_name, srp->header.pack_id, result));
+	SG_LOG(4, pr_info("%s: %s, pack_id=%d, res=0x%x\n", __func__,
+	       sdp->disk->disk_name, srp->header.pack_id, result));
 	srp->header.resid = resid;
 	ms = jiffies_to_msecs(jiffies);
 	srp->header.duration = (ms > srp->header.duration) ?
@@ -1319,7 +1325,7 @@ static void sg_rq_end_io(struct request *rq, int uptodate)
 		if ((sdp->sgdebug > 0) &&
 		    ((CHECK_CONDITION == srp->header.masked_status) ||
 		     (COMMAND_TERMINATED == srp->header.masked_status)))
-			__scsi_print_sense("sg_cmd_done", sense,
+			__scsi_print_sense("sg_rq_end_io", sense,
 					   SCSI_SENSE_BUFFERSIZE);
 
 		/* Following if statement is a patch supplied by Eric Youngdale */
@@ -1388,7 +1394,7 @@ static Sg_device *sg_alloc(struct gendisk *disk, struct scsi_device *scsidp)
 
 	sdp = kzalloc(sizeof(Sg_device), GFP_KERNEL);
 	if (!sdp) {
-		printk(KERN_WARNING "kmalloc Sg_device failure\n");
+		pr_warn("%s: kmalloc Sg_device failure\n", __func__);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -1403,20 +1409,25 @@ static Sg_device *sg_alloc(struct gendisk *disk, struct scsi_device *scsidp)
 				    scsidp->type, SG_MAX_DEVS - 1);
 			error = -ENODEV;
 		} else {
-			printk(KERN_WARNING
-			       "idr allocation Sg_device failure: %d\n", error);
+			pr_warn("%s: idr allocation Sg_device failure: %d\n",
+				__func__, error);
 		}
 		goto out_unlock;
 	}
 	k = error;
 
-	SCSI_LOG_TIMEOUT(3, printk("sg_alloc: dev=%d \n", k));
+	SG_LOG(3, pr_info("%s: dev=%d\n", __func__, k));
 	sprintf(disk->disk_name, "sg%d", k);
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
@@ -1434,7 +1445,7 @@ out_unlock:
 }
 
 static int
-sg_add(struct device *cl_dev, struct class_interface *cl_intf)
+sg_add_device(struct device *cl_dev, struct class_interface *cl_intf)
 {
 	struct scsi_device *scsidp = to_scsi_device(cl_dev->parent);
 	struct gendisk *disk;
@@ -1445,7 +1456,7 @@ sg_add(struct device *cl_dev, struct class_interface *cl_intf)
 
 	disk = alloc_disk(1);
 	if (!disk) {
-		printk(KERN_WARNING "alloc_disk failed\n");
+		pr_warn("%s: alloc_disk failed\n", __func__);
 		return -ENOMEM;
 	}
 	disk->major = SCSI_GENERIC_MAJOR;
@@ -1453,7 +1464,7 @@ sg_add(struct device *cl_dev, struct class_interface *cl_intf)
 	error = -ENOMEM;
 	cdev = cdev_alloc();
 	if (!cdev) {
-		printk(KERN_WARNING "cdev_alloc failed\n");
+		pr_warn("%s: cdev_alloc failed\n", __func__);
 		goto out;
 	}
 	cdev->owner = THIS_MODULE;
@@ -1461,7 +1472,7 @@ sg_add(struct device *cl_dev, struct class_interface *cl_intf)
 
 	sdp = sg_alloc(disk, scsidp);
 	if (IS_ERR(sdp)) {
-		printk(KERN_WARNING "sg_alloc failed\n");
+		pr_warn("%s: sg_alloc failed\n", __func__);
 		error = PTR_ERR(sdp);
 		goto out;
 	}
@@ -1479,22 +1490,20 @@ sg_add(struct device *cl_dev, struct class_interface *cl_intf)
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
+			pr_err("%s: symlink 'generic' to sg%d failed\n",
+			       __func__, sdp->index);
 	} else
-		printk(KERN_WARNING "sg_add: sg_sys Invalid\n");
+		pr_warn("%s: sg_sys Invalid\n", __func__);
 
-	sdev_printk(KERN_NOTICE, scsidp,
-		    "Attached scsi generic sg%d type %d\n", sdp->index,
-		    scsidp->type);
+	sdev_printk(KERN_NOTICE, scsidp, "Attached scsi generic sg%d type %d\n",
+		    sdp->index, scsidp->type);
 
 	dev_set_drvdata(cl_dev, sdp);
 
@@ -1527,41 +1536,44 @@ static void sg_device_destroy(struct kref *kref)
 	idr_remove(&sg_index_idr, sdp->index);
 	write_unlock_irqrestore(&sg_index_lock, flags);
 
-	SCSI_LOG_TIMEOUT(3,
-		printk("sg_device_destroy: %s\n",
-			sdp->disk->disk_name));
+	SG_LOG(3, pr_info("%s: %s\n", __func__, sdp->disk->disk_name));
 
 	put_disk(sdp->disk);
 	kfree(sdp);
 }
 
-static void sg_remove(struct device *cl_dev, struct class_interface *cl_intf)
+static void sg_remove_device(struct device *cl_dev,
+			     struct class_interface *cl_intf)
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
+		return;	/* only want to do following once per device */
 
-	SCSI_LOG_TIMEOUT(3, printk("sg_remove: %s\n", sdp->disk->disk_name));
+	SG_LOG(3, pr_info("%s: %s\n", __func__, sdp->disk->disk_name));
 
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
@@ -1646,8 +1658,7 @@ static int sg_start_req(Sg_request *srp, unsigned char *cmd)
 	struct rq_map_data *md, map_data;
 	int rw = hp->dxfer_direction == SG_DXFER_TO_DEV ? WRITE : READ;
 
-	SCSI_LOG_TIMEOUT(4, printk(KERN_INFO "sg_start_req: dxfer_len=%d\n",
-				   dxfer_len));
+	SG_LOG(4, pr_info("%s: dxfer_len=%d\n", __func__, dxfer_len));
 
 	rq = blk_get_request(q, rw, GFP_ATOMIC);
 	if (!rq)
@@ -1734,7 +1745,7 @@ static int sg_finish_rem_req(Sg_request * srp)
 	Sg_fd *sfp = srp->parentfp;
 	Sg_scatter_hold *req_schp = &srp->data;
 
-	SCSI_LOG_TIMEOUT(4, printk("sg_finish_rem_req: res_used=%d\n", (int) srp->res_used));
+	SG_LOG(4, pr_info("%s: res_used=%d\n", __func__, (int) srp->res_used));
 	if (srp->rq) {
 		if (srp->bio)
 			ret = blk_rq_unmap_user(srp->bio);
@@ -1779,8 +1790,8 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
 		++blk_size;	/* don't know why */
 	/* round request up to next highest SG_SECTOR_SZ byte boundary */
 	blk_size = ALIGN(blk_size, SG_SECTOR_SZ);
-	SCSI_LOG_TIMEOUT(4, printk("sg_build_indirect: buff_size=%d, blk_size=%d\n",
-				   buff_size, blk_size));
+	SG_LOG(4, pr_info("%s: buff_size=%d, blk_size=%d\n", __func__,
+			  buff_size, blk_size));
 
 	/* N.B. ret_sz carried into this block ... */
 	mx_sc_elems = sg_build_sgat(schp, sfp, sg_tablesize);
@@ -1823,14 +1834,13 @@ retry:
 			}
 		}
 
-		SCSI_LOG_TIMEOUT(5, printk("sg_build_indirect: k=%d, num=%d, "
-				 "ret_sz=%d\n", k, num, ret_sz));
+		SG_LOG(5, pr_info("%s: k=%d, num=%d, ret_sz=%d\n", __func__,
+		       k, num, ret_sz));
 	}		/* end of for loop */
 
 	schp->page_order = order;
 	schp->k_use_sg = k;
-	SCSI_LOG_TIMEOUT(5, printk("sg_build_indirect: k_use_sg=%d, "
-			 "rem_sz=%d\n", k, rem_sz));
+	SG_LOG(5, pr_info("%s: k_use_sg=%d, rem_sz=%d\n", __func__, k, rem_sz));
 
 	schp->bufflen = blk_size;
 	if (rem_sz > 0)	/* must have failed */
@@ -1849,15 +1859,14 @@ out:
 static void
 sg_remove_scat(Sg_scatter_hold * schp)
 {
-	SCSI_LOG_TIMEOUT(4, printk("sg_remove_scat: k_use_sg=%d\n", schp->k_use_sg));
+	SG_LOG(4, pr_info("%s: k_use_sg=%d\n", __func__, schp->k_use_sg));
 	if (schp->pages && schp->sglist_len > 0) {
 		if (!schp->dio_in_use) {
 			int k;
 
 			for (k = 0; k < schp->k_use_sg && schp->pages[k]; k++) {
-				SCSI_LOG_TIMEOUT(5, printk(
-				    "sg_remove_scat: k=%d, pg=0x%p\n",
-				    k, schp->pages[k]));
+				SG_LOG(5, pr_info("%s: k=%d, pg=0x%p\n",
+				       __func__, k, schp->pages[k]));
 				__free_pages(schp->pages[k], schp->page_order);
 			}
 
@@ -1873,8 +1882,7 @@ sg_read_oxfer(Sg_request * srp, char __user *outp, int num_read_xfer)
 	Sg_scatter_hold *schp = &srp->data;
 	int k, num;
 
-	SCSI_LOG_TIMEOUT(4, printk("sg_read_oxfer: num_read_xfer=%d\n",
-				   num_read_xfer));
+	SG_LOG(4, pr_info("%s: num_read_xfer=%d\n", __func__, num_read_xfer));
 	if ((!outp) || (num_read_xfer <= 0))
 		return 0;
 
@@ -1904,7 +1912,7 @@ sg_build_reserve(Sg_fd * sfp, int req_size)
 {
 	Sg_scatter_hold *schp = &sfp->reserve;
 
-	SCSI_LOG_TIMEOUT(4, printk("sg_build_reserve: req_size=%d\n", req_size));
+	SG_LOG(4, pr_info("%s: req_size=%d\n", __func__, req_size));
 	do {
 		if (req_size < PAGE_SIZE)
 			req_size = PAGE_SIZE;
@@ -1924,7 +1932,7 @@ sg_link_reserve(Sg_fd * sfp, Sg_request * srp, int size)
 	int k, num, rem;
 
 	srp->res_used = 1;
-	SCSI_LOG_TIMEOUT(4, printk("sg_link_reserve: size=%d\n", size));
+	SG_LOG(4, pr_info("%s: size=%d\n", __func__, size));
 	rem = size;
 
 	num = 1 << (PAGE_SHIFT + rsv_schp->page_order);
@@ -1942,7 +1950,7 @@ sg_link_reserve(Sg_fd * sfp, Sg_request * srp, int size)
 	}
 
 	if (k >= rsv_schp->k_use_sg)
-		SCSI_LOG_TIMEOUT(1, printk("sg_link_reserve: BAD size\n"));
+		SG_LOG(1, pr_info("%s: BAD size\n", __func__));
 }
 
 static void
@@ -1950,8 +1958,8 @@ sg_unlink_reserve(Sg_fd * sfp, Sg_request * srp)
 {
 	Sg_scatter_hold *req_schp = &srp->data;
 
-	SCSI_LOG_TIMEOUT(4, printk("sg_unlink_reserve: req->k_use_sg=%d\n",
-				   (int) req_schp->k_use_sg));
+	SG_LOG(4, pr_info("%s: req->k_use_sg=%d\n", __func__,
+	       (int) req_schp->k_use_sg));
 	req_schp->k_use_sg = 0;
 	req_schp->bufflen = 0;
 	req_schp->pages = NULL;
@@ -2064,7 +2072,7 @@ sg_add_sfp(Sg_device * sdp, int dev)
 
 	sfp = kzalloc(sizeof(*sfp), GFP_ATOMIC | __GFP_NOWARN);
 	if (!sfp)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	init_waitqueue_head(&sfp->read_wait);
 	rwlock_init(&sfp->rq_list_lock);
@@ -2078,18 +2086,22 @@ sg_add_sfp(Sg_device * sdp, int dev)
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
-	SCSI_LOG_TIMEOUT(3, printk("sg_add_sfp: sfp=0x%p\n", sfp));
+	write_unlock_irqrestore(&sdp->sfd_lock, iflags);
+	SG_LOG(3, pr_info("%s: sfp=0x%p\n", __func__, sfp));
 	if (unlikely(sg_big_buff != def_reserved_size))
 		sg_big_buff = def_reserved_size;
 
 	bufflen = min_t(int, sg_big_buff,
 			queue_max_sectors(sdp->device->request_queue) * 512);
 	sg_build_reserve(sfp, bufflen);
-	SCSI_LOG_TIMEOUT(3, printk("sg_add_sfp:   bufflen=%d, k_use_sg=%d\n",
-			   sfp->reserve.bufflen, sfp->reserve.k_use_sg));
+	SG_LOG(3, pr_info("%s:   bufflen=%d, k_use_sg=%d\n", __func__,
+	       sfp->reserve.bufflen, sfp->reserve.k_use_sg));
 
 	kref_get(&sdp->d_ref);
 	__module_get(THIS_MODULE);
@@ -2106,21 +2118,18 @@ static void sg_remove_sfp_usercontext(struct work_struct *work)
 		sg_finish_rem_req(sfp->headrp);
 
 	if (sfp->reserve.bufflen > 0) {
-		SCSI_LOG_TIMEOUT(6,
-			printk("sg_remove_sfp:    bufflen=%d, k_use_sg=%d\n",
-				(int) sfp->reserve.bufflen,
-				(int) sfp->reserve.k_use_sg));
+		SG_LOG(6, pr_info("%s:    bufflen=%d, k_use_sg=%d\n", __func__,
+				  (int) sfp->reserve.bufflen,
+				  (int) sfp->reserve.k_use_sg));
 		sg_remove_scat(&sfp->reserve);
 	}
 
-	SCSI_LOG_TIMEOUT(6,
-		printk("sg_remove_sfp: %s, sfp=0x%p\n",
-			sdp->disk->disk_name,
-			sfp));
+	SG_LOG(6, pr_info("%s: %s, sfp=0x%p\n", __func__, sdp->disk->disk_name,
+			  sfp));
 	kfree(sfp);
 
 	scsi_device_put(sdp->device);
-	sg_put_dev(sdp);
+	kref_put(&sdp->d_ref, sg_device_destroy);
 	module_put(THIS_MODULE);
 }
 
@@ -2130,10 +2139,9 @@ static void sg_remove_sfp(struct kref *kref)
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
@@ -2193,8 +2201,8 @@ static Sg_device *sg_get_dev(int dev)
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
@@ -2205,11 +2213,6 @@ static Sg_device *sg_get_dev(int dev)
 	return sdp;
 }
 
-static void sg_put_dev(struct sg_device *sdp)
-{
-	kref_put(&sdp->d_ref, sg_device_destroy);
-}
-
 #ifdef CONFIG_SCSI_PROC_FS
 
 static struct proc_dir_entry *sg_proc_sgp = NULL;
@@ -2426,8 +2429,7 @@ static int sg_proc_single_open_version(struct inode *inode, struct file *file)
 
 static int sg_proc_seq_show_devhdr(struct seq_file *s, void *v)
 {
-	seq_printf(s, "host\tchan\tid\tlun\ttype\topens\tqdepth\tbusy\t"
-		   "online\n");
+	seq_puts(s, "host\tchan\tid\tlun\ttype\topens\tqdepth\tbusy\tonline\n");
 	return 0;
 }
 
@@ -2483,7 +2485,11 @@ static int sg_proc_seq_show_dev(struct seq_file *s, void *v)
 
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
@@ -2491,8 +2497,7 @@ static int sg_proc_seq_show_dev(struct seq_file *s, void *v)
 			      (int) scsidp->queue_depth,
 			      (int) scsidp->device_busy,
 			      (int) scsi_device_online(scsidp));
-	else
-		seq_printf(s, "-1\t-1\t-1\t-1\t-1\t-1\t-1\t-1\t-1\n");
+	}
 	read_unlock_irqrestore(&sg_index_lock, iflags);
 	return 0;
 }
@@ -2511,11 +2516,12 @@ static int sg_proc_seq_show_devstrs(struct seq_file *s, void *v)
 
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
@@ -2560,7 +2566,7 @@ static void sg_proc_debug_helper(struct seq_file *s, Sg_device * sdp)
 				else
 					cp = "     ";
 			}
-			seq_printf(s, cp);
+			seq_puts(s, cp);
 			blen = srp->data.bufflen;
 			usg = srp->data.k_use_sg;
 			seq_printf(s, srp->done ? 
@@ -2581,7 +2587,7 @@ static void sg_proc_debug_helper(struct seq_file *s, Sg_device * sdp)
 				   (int) srp->data.cmd_opcode);
 		}
 		if (0 == m)
-			seq_printf(s, "     No requests active\n");
+			seq_puts(s, "     No requests active\n");
 		read_unlock(&fp->rq_list_lock);
 	}
 }
@@ -2597,31 +2603,35 @@ static int sg_proc_seq_show_debug(struct seq_file *s, void *v)
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

--------------080407090901070303070100--
