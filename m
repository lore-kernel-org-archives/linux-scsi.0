From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH] [SCSI] sg: late O_EXCL fix for lk 3.12-rc
Date: Sun, 20 Oct 2013 12:09:09 -0400
Message-ID: <52640025.60709@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010609080400030200040209"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, vaughan <vaughan.cao@oracle.com>, Madper Xie <cxie@redhat.com>, James Bottomley <james.bottomley@hansenpartnership.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------010609080400030200040209
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

The lk 3.12.0-rc series contains a series of patches
from Vaughan Cao introduced by this post:
    [PATCH v7 0/4][SCSI] sg: fix race condition in sg_open
    http://marc.info/?l=linux-scsi&m=137774159020002&w=2

Doubt was thrown on the implementation by Madper Xie in
this thread:
    [Bug] 12.864681  BUG: lock held when returning to user space!
    http://marc.info/?l=linux-kernel&m=138121455020314&w=2

Well it is not a lock, it is a read-write semaphore down-ed
in sg_open() with the reasonable expectation that a
corresponding sg_release() will arrive thereupon that
read-write semaphore is upp-ed. I'm yet to find kernel
documentation that says that is illegal. There are even driver
examples on the 'net showing this same technique but that
doesn't prove it is correct.

Irrespective of 12.864681 while looking at this I noticed
another bug. The semantics of O_EXCL in the sg driver are
modelled on those of a regular file. That means an attempt
to do sg_open(O_EXCL) on a device with an existing open, or
a sg_open() on a device which already has a sg_open(O_EXCL)
active will wait the caller until "the coast is clear".
This assumes O_NONBLOCK is not given, if it is, EBUSY is sent
back. Now that wait needs to be interruptible and was
before Vaughan Cao's patch. In his defence there are no
down_read_interruptible() and down_write_interruptible()
calls available for this purpose.

So I propose the following patch over Vaughan Cao's patch.
It replaces his per-device read-write semaphore with:
   - a normal semaphore (or_sem) to stop co-incident open()s
     and release()s on the same device treading on the same
     data.
   - a wait_queue (open_wait) to handle wait on open() which is
     associated with the use of O_EXCL (when O_NONBLOCK is not
     given). The two wait_event_interruptible() calls are in a
     loop because multiple open()s could be waiting on either
     case. All get woken up but only one will get the down() at
     the bottom of the loop and proceed to complete the open(),
     potentially leaving the other candidates to continue waiting
     until it releases.

Apart from the initializations, all my proposed changes are
in sg_open() and sg_release(). The examples directory in
my sg3_utils version 1.37 package:
    http://sg.danny.cz/sg/sg3_utils.html
contains sg_tst_excl.cpp and sg_tst_excl2.cpp ** which are
designed to stress O_EXCL on the sg driver and friends (bsg
ignores O_EXCL, and the block layer has questionable O_EXCL
semantics). My patch has been successful with these tests and
others on my meagre hardware.


Given that lk 3.12.0 release is not far away, the safest path
may still be to revert Vaughan Cao's patch. I'll leave that
decision to the maintainers.

Doug Gilbert


** C++11 so gcc 4.8 (or late 4.7) needed


--------------010609080400030200040209
Content-Type: text/x-patch;
 name="sg_7vc_dg1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sg_7vc_dg1.diff"

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 5cbc4bb..11c4e94 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -170,7 +170,8 @@ typedef struct sg_device { /* holds the state of each scsi generic device */
 	u32 index;		/* device index number */
 	spinlock_t sfd_lock;	/* protect file descriptor list for device */
 	struct list_head sfds;
-	struct rw_semaphore o_sem;	/* exclude open should hold this rwsem */
+	struct semaphore or_sem;  /* protect co-incidental opens and releases */
+	wait_queue_head_t open_wait;	/* waits associated with O_EXCL */
 	volatile char detached;	/* 0->attached, 1->detached pending removal */
 	char exclude;		/* opened for exclusive access */
 	char sgdebug;		/* 0->off, 1->sense, 9->dump dev, 10-> all devs */
@@ -232,6 +233,16 @@ static int sfds_list_empty(Sg_device *sdp)
 }
 
 static int
+open_wait_event(Sg_device *sdp, int excl_case)
+{
+	int retval;
+
+	retval = wait_event_interruptible(sdp->open_wait, (sdp->detached ||
+		    (excl_case ? (! sdp->exclude) : sfds_list_empty(sdp))));
+	return sdp->detached ? -ENODEV : retval;
+}
+
+static int
 sg_open(struct inode *inode, struct file *filp)
 {
 	int dev = iminor(inode);
@@ -239,7 +250,7 @@ sg_open(struct inode *inode, struct file *filp)
 	struct request_queue *q;
 	Sg_device *sdp;
 	Sg_fd *sfp;
-	int retval;
+	int alone, retval;
 
 	nonseekable_open(inode, filp);
 	SCSI_LOG_TIMEOUT(3, printk("sg_open: dev=%d, flags=0x%x\n", dev, flags));
@@ -260,6 +271,8 @@ sg_open(struct inode *inode, struct file *filp)
 	if (retval)
 		goto sdp_put;
 
+	down(&sdp->or_sem);
+	alone = sfds_list_empty(sdp);
 	if (!((flags & O_NONBLOCK) ||
 	      scsi_block_when_processing_errors(sdp->device))) {
 		retval = -ENXIO;
@@ -273,46 +286,63 @@ sg_open(struct inode *inode, struct file *filp)
 	}
 	if (flags & O_NONBLOCK) {
 		if (flags & O_EXCL) {
-			if (!down_write_trylock(&sdp->o_sem)) {
+			if (! alone) {
 				retval = -EBUSY;
 				goto error_out;
-			}
+                        }
 		} else {
-			if (!down_read_trylock(&sdp->o_sem)) {
+			if (sdp->exclude) {
 				retval = -EBUSY;
 				goto error_out;
 			}
 		}
 	} else {
-		if (flags & O_EXCL)
-			down_write(&sdp->o_sem);
-		else
-			down_read(&sdp->o_sem);
+		if (flags & O_EXCL) {
+			while (! alone) {
+				up(&sdp->or_sem);
+				retval = open_wait_event(sdp, 0);
+				if (retval) /* -ERESTARTSYS or -ENODEV */
+					goto error_upped;
+				down(&sdp->or_sem);
+				alone = sfds_list_empty(sdp);
+			}
+		} else {
+			while (sdp->exclude) {
+				up(&sdp->or_sem);
+				retval = open_wait_event(sdp, 1);
+				if (retval) /* -ERESTARTSYS or -ENODEV */
+					goto error_upped;
+				down(&sdp->or_sem);
+				alone = sfds_list_empty(sdp);
+			}
+		}
 	}
 	/* Since write lock is held, no need to check sfd_list */
 	if (flags & O_EXCL)
 		sdp->exclude = 1;	/* used by release lock */
 
-	if (sfds_list_empty(sdp)) {	/* no existing opens on this device */
+	if (alone) {	/* no existing opens on this device */
 		sdp->sgdebug = 0;
 		q = sdp->device->request_queue;
 		sdp->sg_tablesize = queue_max_segments(q);
 	}
 	sfp = sg_add_sfp(sdp, dev);
-	if (!IS_ERR(sfp))
+	if (!IS_ERR(sfp)) {
 		filp->private_data = sfp;
 		/* retval is already provably zero at this point because of the
 		 * check after retval = scsi_autopm_get_device(sdp->device))
 		 */
-	else {
+		up(&sdp->or_sem);
+	} else {
 		retval = PTR_ERR(sfp);
 
 		if (flags & O_EXCL) {
 			sdp->exclude = 0;	/* undo if error */
-			up_write(&sdp->o_sem);
-		} else
-			up_read(&sdp->o_sem);
+			wake_up_interruptible(&sdp->open_wait);
+		}
 error_out:
+		up(&sdp->or_sem);
+error_upped:
 		scsi_autopm_put_device(sdp->device);
 sdp_put:
 		scsi_device_put(sdp->device);
@@ -333,17 +363,18 @@ sg_release(struct inode *inode, struct file *filp)
 
 	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
+	down(&sdp->or_sem);
 	SCSI_LOG_TIMEOUT(3, printk("sg_release: %s\n", sdp->disk->disk_name));
 
 	excl = sdp->exclude;
-	sdp->exclude = 0;
 	if (excl)
-		up_write(&sdp->o_sem);
-	else
-		up_read(&sdp->o_sem);
+		sdp->exclude = 0;
 
 	scsi_autopm_put_device(sdp->device);
 	kref_put(&sfp->f_ref, sg_remove_sfp);
+	if (excl || sfds_list_empty(sdp))
+	    wake_up_interruptible(&sdp->open_wait);
+	up(&sdp->or_sem);
 	return 0;
 }
 
@@ -1393,7 +1424,8 @@ static Sg_device *sg_alloc(struct gendisk *disk, struct scsi_device *scsidp)
 	sdp->device = scsidp;
 	spin_lock_init(&sdp->sfd_lock);
 	INIT_LIST_HEAD(&sdp->sfds);
-	init_rwsem(&sdp->o_sem);
+	sema_init(&sdp->or_sem, 1);
+	init_waitqueue_head(&sdp->open_wait);
 	sdp->sg_tablesize = queue_max_segments(q);
 	sdp->index = k;
 	kref_init(&sdp->d_ref);

--------------010609080400030200040209--
