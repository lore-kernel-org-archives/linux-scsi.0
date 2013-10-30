From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH v2] sg: O_EXCL and other lock handling
Date: Wed, 30 Oct 2013 18:24:19 -0400
Message-ID: <52718713.7050906@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020305020106010603080204"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>
Cc: vaughan <vaughan.cao@oracle.com>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------020305020106010603080204
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This is v2 of a patch presented a few days ago:
   http://marc.info/?l=linux-scsi&m=138282446708844&w=2
Vaughan Cao's patch is still in lk 3.12-rc7 but it is
assumed that it will be reverted before lk 3.12 release.

Further testing raised some issues when the device was removed
(detached) while being bombarded with open()s.

There is also a move to favour non O_EXCL open()s more
strongly. Rationale: important SCSI commands like INQUIRY and
REPORT LUNS should be answered promptly. They do not need and
should not use open(dev, O_EXCL) to access the pass-through.
Only commands that write to the device or change its state
that might conflict with other users of the device doing
something similar should used open(dev, O_EXCL).

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

Testing:
sg_tst_excl, sg_tst_excl2 and sg_tst_excl3 in the examples
directory of sg3_utils-1.38 beta 1 (see News section of
http://sg.danny.cz/sg ) have been refined to test the
strength of O_EXCL and related mechanisms. Here is a
typical test, each run on separate terminals at the same
time:
   sg_tst_excl -f -t 100 -n 2000 /dev/sg4
   sg_tst_excl2 -f -b -t 100 -n 2000 /dev/sg4
   sg_tst_excl2 -f -t 100 -n 2000 /dev/sg4
   sg_tst_excl3 -f -R -x -t 100 -n 2000 /dev/sg4
See usage messages ('-h') for the meaning of those options.
The last one (reader with no O_EXCL opens()s) runs much
faster than the first three. It is important that /dev/sg4
is either a scsi_debug device or a disk that you don't mind
overwriting LBA 1000.


Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

--------------020305020106010603080204
Content-Type: text/x-patch;
 name="sg.c313excl_dg3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sg.c313excl_dg3.patch"

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index df5e961..99c643f 100644
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
@@ -64,7 +62,7 @@ static int sg_version_num = 30534;	/* 2 digits for each component */
 
 #ifdef CONFIG_SCSI_PROC_FS
 #include <linux/proc_fs.h>
-static char *sg_version_date = "20061027";
+static char *sg_version_date = "20131029";
 
 static int sg_proc_init(void);
 static void sg_proc_cleanup(void);
@@ -105,11 +103,8 @@ static int scatter_elem_sz_prev = SG_SCATTER_SZ;
 static int sg_add(struct device *, struct class_interface *);
 static void sg_remove(struct device *, struct class_interface *);
 
-static DEFINE_SPINLOCK(sg_open_exclusive_lock);
-
 static DEFINE_IDR(sg_index_idr);
-static DEFINE_RWLOCK(sg_index_lock);	/* Also used to lock
-							   file descriptor list for device */
+static DEFINE_RWLOCK(sg_index_lock);
 
 static struct class_interface sg_interface = {
 	.add_dev	= sg_add,
@@ -146,8 +141,7 @@ typedef struct sg_request {	/* SG_MAX_QUEUE requests outstanding per file */
 } Sg_request;
 
 typedef struct sg_fd {		/* holds the state of a file descriptor */
-	/* sfd_siblings is protected by sg_index_lock */
-	struct list_head sfd_siblings;
+	struct list_head sfd_siblings; /* protected by sfd_lock of device */
 	struct sg_device *parentdp;	/* owning device */
 	wait_queue_head_t read_wait;	/* queue read until command done */
 	rwlock_t rq_list_lock;	/* protect access to list in req_arr */
@@ -170,14 +164,14 @@ typedef struct sg_fd {		/* holds the state of a file descriptor */
 
 typedef struct sg_device { /* holds the state of each scsi generic device */
 	struct scsi_device *device;
-	wait_queue_head_t o_excl_wait;	/* queue open() when O_EXCL in use */
 	int sg_tablesize;	/* adapter's max scatter-gather table size */
 	u32 index;		/* device index number */
-	/* sfds is protected by sg_index_lock */
+	spinlock_t sfd_lock;	/* protect file descriptor list for device */
 	struct list_head sfds;
+	struct semaphore or_sem;  /* protect co-incident opens and releases */
+	wait_queue_head_t open_wait;	/* waits associated with O_EXCL */
 	volatile char detached;	/* 0->attached, 1->detached pending removal */
-	/* exclude protected by sg_open_exclusive_lock */
-	char exclude;		/* opened for exclusive access */
+	char exclude;		/* open(O_EXCL) on this device has succeeded */
 	char sgdebug;		/* 0->off, 1->sense, 9->dump dev, 10-> all devs */
 	struct gendisk *disk;
 	struct cdev * cdev;	/* char_dev [sysfs: /sys/cdev/major/sg<n>] */
@@ -225,38 +219,28 @@ static int sg_allow_access(struct file *filp, unsigned char *cmd)
 	return blk_verify_command(cmd, filp->f_mode & FMODE_WRITE);
 }
 
-static int get_exclude(Sg_device *sdp)
+static int sfds_list_empty(Sg_device *sdp)
 {
 	unsigned long flags;
 	int ret;
 
-	spin_lock_irqsave(&sg_open_exclusive_lock, flags);
-	ret = sdp->exclude;
-	spin_unlock_irqrestore(&sg_open_exclusive_lock, flags);
+	spin_lock_irqsave(&sdp->sfd_lock, flags);
+	ret = list_empty(&sdp->sfds);
+	spin_unlock_irqrestore(&sdp->sfd_lock, flags);
 	return ret;
 }
 
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
+	retval = wait_event_interruptible(sdp->open_wait, (sdp->detached ||
+		    (excl_case ? (!sdp->exclude) : sfds_list_empty(sdp))));
+	return sdp->detached ? -ENODEV : retval;
 }
 
+/* Returns 0 on success, else a negated errno value */
 static int
 sg_open(struct inode *inode, struct file *filp)
 {
@@ -265,8 +249,7 @@ sg_open(struct inode *inode, struct file *filp)
 	struct request_queue *q;
 	Sg_device *sdp;
 	Sg_fd *sfp;
-	int res;
-	int retval;
+	int alone, retval;
 
 	nonseekable_open(inode, filp);
 	SCSI_LOG_TIMEOUT(3, printk("sg_open: dev=%d, flags=0x%x\n", dev, flags));
@@ -287,61 +270,77 @@ sg_open(struct inode *inode, struct file *filp)
 	if (retval)
 		goto sdp_put;
 
+	/* scsi_block_when_processing_errors() may block so bypass
+	 * check if O_NONBLOCK. Permits SCSI commands to be issued
+	 * during error recovery. Tread carefully. */
 	if (!((flags & O_NONBLOCK) ||
 	      scsi_block_when_processing_errors(sdp->device))) {
 		retval = -ENXIO;
 		/* we are in error recovery for this device */
-		goto error_out;
+		goto error_after_sem;
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
+	down(&sdp->or_sem);
+	alone = sfds_list_empty(sdp);
+	if ((flags & O_EXCL) && (O_RDONLY == (flags & O_ACCMODE))) {
+		retval = -EPERM; /* Don't allow O_EXCL with read only access */
+		goto error_out;
+	}
+	if (flags & O_NONBLOCK) {
+		if (flags & O_EXCL) {
+			if (!alone) {
+				retval = -EBUSY;
+				goto error_out;
+			}
+		} else {
+			if (sdp->exclude) {
+				retval = -EBUSY;
+				goto error_out;
+			}
 		}
-		res = wait_event_interruptible(sdp->o_excl_wait, !get_exclude(sdp));
-		if (res) {
-			retval = res;	/* -ERESTARTSYS because signal hit process */
-			goto error_out;
+	} else {
+		if (flags & O_EXCL) {
+			while (!alone) {
+				up(&sdp->or_sem);
+				retval = open_wait_event(sdp, 0);
+				if (retval) /* -ERESTARTSYS or -ENODEV */
+					goto error_after_sem;
+				down(&sdp->or_sem);
+				alone = sfds_list_empty(sdp);
+			}
+		} else {
+			while (sdp->exclude) {
+				up(&sdp->or_sem);
+				retval = open_wait_event(sdp, 1);
+				if (retval) /* -ERESTARTSYS or -ENODEV */
+					goto error_after_sem;
+				down(&sdp->or_sem);
+				alone = sfds_list_empty(sdp);
+			}
 		}
 	}
-	if (sdp->detached) {
-		retval = -ENODEV;
-		goto error_out;
-	}
-	if (sfds_list_empty(sdp)) {	/* no existing opens on this device */
+	if (flags & O_EXCL)
+		sdp->exclude = 1;
+
+	if (alone) {	/* no existing opens on this device */
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
+		up(&sdp->or_sem);
+	} else {
+		retval = PTR_ERR(sfp);
 		if (flags & O_EXCL) {
-			set_exclude(sdp, 0);	/* undo if error */
-			wake_up_interruptible(&sdp->o_excl_wait);
+			sdp->exclude = 0;	/* undo if error */
+			wake_up_interruptible(&sdp->open_wait);
 		}
-		retval = -ENOMEM;
-		goto error_out;
-	}
-	retval = 0;
 error_out:
-	if (retval) {
+		up(&sdp->or_sem);
+error_after_sem:
 		scsi_autopm_put_device(sdp->device);
 sdp_put:
 		scsi_device_put(sdp->device);
@@ -352,22 +351,31 @@ sg_put:
 	return retval;
 }
 
-/* Following function was formerly called 'sg_close' */
+/* Release resources associated with a successful sg_open()
+ * Returns 0 on success, else a negated errno value */
 static int
 sg_release(struct inode *inode, struct file *filp)
 {
 	Sg_device *sdp;
 	Sg_fd *sfp;
+	int excl;
 
 	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
+	down(&sdp->or_sem);
 	SCSI_LOG_TIMEOUT(3, printk("sg_release: %s\n", sdp->disk->disk_name));
 
-	set_exclude(sdp, 0);
-	wake_up_interruptible(&sdp->o_excl_wait);
+	excl = sdp->exclude;
+	if (excl)
+		sdp->exclude = 0;
 
 	scsi_autopm_put_device(sdp->device);
 	kref_put(&sfp->f_ref, sg_remove_sfp);
+	if (excl)
+		wake_up_interruptible_all(&sdp->open_wait);
+	else if (sfds_list_empty(sdp))
+		wake_up_interruptible(&sdp->open_wait);
+	up(&sdp->or_sem);
 	return 0;
 }
 
@@ -1296,14 +1304,15 @@ static void sg_rq_end_io(struct request *rq, int uptodate)
 
 	sdp = sfp->parentdp;
 	if (unlikely(sdp->detached))
-		printk(KERN_INFO "sg_rq_end_io: device detached\n");
+		SCSI_LOG_TIMEOUT(1,
+				 pr_info("sg_rq_end_io: device detached\n"));
 
 	sense = rq->sense;
 	result = rq->errors;
 	resid = rq->resid_len;
 
-	SCSI_LOG_TIMEOUT(4, printk("sg_cmd_done: %s, pack_id=%d, res=0x%x\n",
-		sdp->disk->disk_name, srp->header.pack_id, result));
+	SCSI_LOG_TIMEOUT(4, pr_info("sg_rq_end_io: %s, pack_id=%d, res=0x%x\n",
+			 sdp->disk->disk_name, srp->header.pack_id, result));
 	srp->header.resid = resid;
 	ms = jiffies_to_msecs(jiffies);
 	srp->header.duration = (ms > srp->header.duration) ?
@@ -1319,7 +1328,7 @@ static void sg_rq_end_io(struct request *rq, int uptodate)
 		if ((sdp->sgdebug > 0) &&
 		    ((CHECK_CONDITION == srp->header.masked_status) ||
 		     (COMMAND_TERMINATED == srp->header.masked_status)))
-			__scsi_print_sense("sg_cmd_done", sense,
+			__scsi_print_sense("sg_rq_end_io", sense,
 					   SCSI_SENSE_BUFFERSIZE);
 
 		/* Following if statement is a patch supplied by Eric Youngdale */
@@ -1415,8 +1424,10 @@ static Sg_device *sg_alloc(struct gendisk *disk, struct scsi_device *scsidp)
 	disk->first_minor = k;
 	sdp->disk = disk;
 	sdp->device = scsidp;
+	spin_lock_init(&sdp->sfd_lock);
 	INIT_LIST_HEAD(&sdp->sfds);
-	init_waitqueue_head(&sdp->o_excl_wait);
+	sema_init(&sdp->or_sem, 1);
+	init_waitqueue_head(&sdp->open_wait);
 	sdp->sg_tablesize = queue_max_segments(q);
 	sdp->index = k;
 	kref_init(&sdp->d_ref);
@@ -1549,11 +1560,14 @@ static void sg_remove(struct device *cl_dev, struct class_interface *cl_intf)
 
 	/* Need a write lock to set sdp->detached. */
 	write_lock_irqsave(&sg_index_lock, iflags);
+	spin_lock(&sdp->sfd_lock);
 	sdp->detached = 1;
 	list_for_each_entry(sfp, &sdp->sfds, sfd_siblings) {
-		wake_up_interruptible(&sfp->read_wait);
+		wake_up_interruptible_all(&sfp->read_wait);
 		kill_fasync(&sfp->async_qp, SIGPOLL, POLL_HUP);
 	}
+	wake_up_interruptible_all(&sdp->open_wait);
+	spin_unlock(&sdp->sfd_lock);
 	write_unlock_irqrestore(&sg_index_lock, iflags);
 
 	sysfs_remove_link(&scsidp->sdev_gendev.kobj, "generic");
@@ -2064,7 +2078,7 @@ sg_add_sfp(Sg_device * sdp, int dev)
 
 	sfp = kzalloc(sizeof(*sfp), GFP_ATOMIC | __GFP_NOWARN);
 	if (!sfp)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	init_waitqueue_head(&sfp->read_wait);
 	rwlock_init(&sfp->rq_list_lock);
@@ -2078,9 +2092,13 @@ sg_add_sfp(Sg_device * sdp, int dev)
 	sfp->cmd_q = SG_DEF_COMMAND_Q;
 	sfp->keep_orphan = SG_DEF_KEEP_ORPHAN;
 	sfp->parentdp = sdp;
-	write_lock_irqsave(&sg_index_lock, iflags);
+	spin_lock_irqsave(&sdp->sfd_lock, iflags);
+	if (sdp->detached) {
+		spin_unlock_irqrestore(&sdp->sfd_lock, iflags);
+		return ERR_PTR(-ENODEV);
+	}
 	list_add_tail(&sfp->sfd_siblings, &sdp->sfds);
-	write_unlock_irqrestore(&sg_index_lock, iflags);
+	spin_unlock_irqrestore(&sdp->sfd_lock, iflags);
 	SCSI_LOG_TIMEOUT(3, printk("sg_add_sfp: sfp=0x%p\n", sfp));
 	if (unlikely(sg_big_buff != def_reserved_size))
 		sg_big_buff = def_reserved_size;
@@ -2130,10 +2148,9 @@ static void sg_remove_sfp(struct kref *kref)
 	struct sg_device *sdp = sfp->parentdp;
 	unsigned long iflags;
 
-	write_lock_irqsave(&sg_index_lock, iflags);
+	spin_lock_irqsave(&sdp->sfd_lock, iflags);
 	list_del(&sfp->sfd_siblings);
-	write_unlock_irqrestore(&sg_index_lock, iflags);
-	wake_up_interruptible(&sdp->o_excl_wait);
+	spin_unlock_irqrestore(&sdp->sfd_lock, iflags);
 
 	INIT_WORK(&sfp->ew.work, sg_remove_sfp_usercontext);
 	schedule_work(&sfp->ew.work);
@@ -2426,8 +2443,8 @@ static int sg_proc_single_open_version(struct inode *inode, struct file *file)
 
 static int sg_proc_seq_show_devhdr(struct seq_file *s, void *v)
 {
-	seq_printf(s, "host\tchan\tid\tlun\ttype\topens\tqdepth\tbusy\t"
-		   "online\n");
+	seq_puts(s,
+		 "host\tchan\tid\tlun\ttype\topens\tqdepth\tbusy\tonline\n");
 	return 0;
 }
 
@@ -2492,7 +2509,7 @@ static int sg_proc_seq_show_dev(struct seq_file *s, void *v)
 			      (int) scsidp->device_busy,
 			      (int) scsi_device_online(scsidp));
 	else
-		seq_printf(s, "-1\t-1\t-1\t-1\t-1\t-1\t-1\t-1\t-1\n");
+		seq_puts(s, "-1\t-1\t-1\t-1\t-1\t-1\t-1\t-1\t-1\n");
 	read_unlock_irqrestore(&sg_index_lock, iflags);
 	return 0;
 }
@@ -2515,12 +2532,12 @@ static int sg_proc_seq_show_devstrs(struct seq_file *s, void *v)
 		seq_printf(s, "%8.8s\t%16.16s\t%4.4s\n",
 			   scsidp->vendor, scsidp->model, scsidp->rev);
 	else
-		seq_printf(s, "<no active device>\n");
+		seq_puts(s, "<no active device>\n");
 	read_unlock_irqrestore(&sg_index_lock, iflags);
 	return 0;
 }
 
-/* must be called while holding sg_index_lock */
+/* must be called while holding sg_index_lock and sfd_lock */
 static void sg_proc_debug_helper(struct seq_file *s, Sg_device * sdp)
 {
 	int k, m, new_interface, blen, usg;
@@ -2560,12 +2577,12 @@ static void sg_proc_debug_helper(struct seq_file *s, Sg_device * sdp)
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
+				 : "act:");
 			seq_printf(s, " id=%d blen=%d",
 				   srp->header.pack_id, blen);
 			if (srp->done)
@@ -2581,7 +2598,7 @@ static void sg_proc_debug_helper(struct seq_file *s, Sg_device * sdp)
 				   (int) srp->data.cmd_opcode);
 		}
 		if (0 == m)
-			seq_printf(s, "     No requests active\n");
+			seq_puts(s, "     No requests active\n");
 		read_unlock(&fp->rq_list_lock);
 	}
 }
@@ -2605,22 +2622,26 @@ static int sg_proc_seq_show_debug(struct seq_file *s, void *v)
 
 	read_lock_irqsave(&sg_index_lock, iflags);
 	sdp = it ? sg_lookup_dev(it->index) : NULL;
-	if (sdp && !list_empty(&sdp->sfds)) {
-		struct scsi_device *scsidp = sdp->device;
+	if (sdp) {
+		spin_lock(&sdp->sfd_lock);
+		if (!list_empty(&sdp->sfds)) {
+			struct scsi_device *scsidp = sdp->device;
 
-		seq_printf(s, " >>> device=%s ", sdp->disk->disk_name);
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
-		sg_proc_debug_helper(s, sdp);
+			seq_printf(s, " >>> device=%s ", sdp->disk->disk_name);
+			if (sdp->detached)
+				seq_puts(s, "detached pending close ");
+			else
+				seq_printf
+				    (s, "scsi%d chan=%d id=%d lun=%d   em=%d",
+				     scsidp->host->host_no,
+				     scsidp->channel, scsidp->id,
+				     scsidp->lun,
+				     scsidp->host->hostt->emulated);
+			seq_printf(s, " sg_tablesize=%d excl=%d\n",
+				   sdp->sg_tablesize, sdp->exclude);
+			sg_proc_debug_helper(s, sdp);
+		}
+		spin_unlock(&sdp->sfd_lock);
 	}
 	read_unlock_irqrestore(&sg_index_lock, iflags);
 	return 0;

--------------020305020106010603080204--
