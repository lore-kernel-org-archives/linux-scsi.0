From: Vaughan Cao <vaughan.cao@oracle.com>
Subject: [PATCH v5 1/4] [SCSI] sg: use rwsem to solve race during exclusive open
Date: Mon, 22 Jul 2013 12:40:30 +0800
Message-ID: <1374468033-8947-2-git-send-email-vaughan.cao@oracle.com>
References: <1374075246-22923-1-git-send-email-vaughan.cao@oracle.com>
 <1374468033-8947-1-git-send-email-vaughan.cao@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1374468033-8947-1-git-send-email-vaughan.cao@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: joern@logfs.org
Cc: dgilbert@interlog.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, vaughan.cao@oracle.com
List-Id: linux-scsi@vger.kernel.org

A race condition may happen if two threads are both trying to open the same sg
with O_EXCL simultaneously. It's possible that they both find fsds list is
empty and get_exclude(sdp) returns 0, then they both call set_exclude() and
break out from wait_event_interruptible and resume open.

Now use rwsem to protect this process. Exclusive open gets write lock and
others get read lock. The lock will be held until file descriptor is closed.
This also leads 'exclude' only a status rather than a check mark.

Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
---
 drivers/scsi/sg.c | 77 ++++++++++++++++++++++++++++++-------------------------
 1 file changed, 42 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 25b5455..edc395a 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -168,11 +168,11 @@ typedef struct sg_fd {		/* holds the state of a file descriptor */
 
 typedef struct sg_device { /* holds the state of each scsi generic device */
 	struct scsi_device *device;
-	wait_queue_head_t o_excl_wait;	/* queue open() when O_EXCL in use */
 	int sg_tablesize;	/* adapter's max scatter-gather table size */
 	u32 index;		/* device index number */
 	/* sfds is protected by sg_index_lock */
 	struct list_head sfds;
+	struct rw_semaphore o_sem;	/* exclude open should hold this rwsem */
 	volatile char detached;	/* 0->attached, 1->detached pending removal */
 	/* exclude protected by sg_open_exclusive_lock */
 	char exclude;		/* opened for exclusive access */
@@ -293,35 +293,35 @@ sg_open(struct inode *inode, struct file *filp)
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
-		}
-		res = wait_event_interruptible(sdp->o_excl_wait, !get_exclude(sdp));
-		if (res) {
-			retval = res;	/* -ERESTARTSYS because signal hit process */
-			goto error_out;
+	if ((flags & O_EXCL) && (O_RDONLY == (flags & O_ACCMODE))) {
+		retval = -EPERM; /* Can't lock it with read only access */
+		goto error_out;
+	}
+	if (flags & O_NONBLOCK) {
+		if (flags & O_EXCL) {
+			if (!down_write_trylock(&sdp->o_sem)) {
+				retval = -EBUSY;
+				goto error_out;
+			}
+		} else {
+			if (!down_read_trylock(&sdp->o_sem)) {
+				retval = -EBUSY;
+				goto error_out;
+			}
 		}
+	} else {
+		if (flags & O_EXCL)
+			down_write(&sdp->o_sem);
+		else
+			down_read(&sdp->o_sem);
 	}
+	/* Since write lock is held, no need to check sfd_list */
+	if (flags & O_EXCL)
+		set_exclude(sdp, 1);
+
 	if (sdp->detached) {
 		retval = -ENODEV;
-		goto error_out;
+		goto sem_out;
 	}
 	if (sfds_list_empty(sdp)) {	/* no existing opens on this device */
 		sdp->sgdebug = 0;
@@ -331,16 +331,19 @@ sg_open(struct inode *inode, struct file *filp)
 	if ((sfp = sg_add_sfp(sdp, dev)))
 		filp->private_data = sfp;
 	else {
-		if (flags & O_EXCL) {
-			set_exclude(sdp, 0);	/* undo if error */
-			wake_up_interruptible(&sdp->o_excl_wait);
-		}
 		retval = -ENOMEM;
-		goto error_out;
+		goto sem_out;
 	}
 	retval = 0;
-error_out:
+
 	if (retval) {
+sem_out:
+		if (flags & O_EXCL) {
+			set_exclude(sdp, 0);	/* undo if error */
+			up_write(&sdp->o_sem);
+		} else
+			up_read(&sdp->o_sem);
+error_out:
 		scsi_autopm_put_device(sdp->device);
 sdp_put:
 		scsi_device_put(sdp->device);
@@ -357,13 +360,18 @@ sg_release(struct inode *inode, struct file *filp)
 {
 	Sg_device *sdp;
 	Sg_fd *sfp;
+	int excl;
 
 	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
 	SCSI_LOG_TIMEOUT(3, printk("sg_release: %s\n", sdp->disk->disk_name));
 
+	excl = get_exclude(sdp);
 	set_exclude(sdp, 0);
-	wake_up_interruptible(&sdp->o_excl_wait);
+	if (excl)
+		up_write(&sdp->o_sem);
+	else
+		up_read(&sdp->o_sem);
 
 	scsi_autopm_put_device(sdp->device);
 	kref_put(&sfp->f_ref, sg_remove_sfp);
@@ -1415,7 +1423,7 @@ static Sg_device *sg_alloc(struct gendisk *disk, struct scsi_device *scsidp)
 	sdp->disk = disk;
 	sdp->device = scsidp;
 	INIT_LIST_HEAD(&sdp->sfds);
-	init_waitqueue_head(&sdp->o_excl_wait);
+	init_rwsem(&sdp->o_sem);
 	sdp->sg_tablesize = queue_max_segments(q);
 	sdp->index = k;
 	kref_init(&sdp->d_ref);
@@ -2140,7 +2148,6 @@ static void sg_remove_sfp(struct kref *kref)
 	write_lock_irqsave(&sg_index_lock, iflags);
 	list_del(&sfp->sfd_siblings);
 	write_unlock_irqrestore(&sg_index_lock, iflags);
-	wake_up_interruptible(&sdp->o_excl_wait);
 
 	INIT_WORK(&sfp->ew.work, sg_remove_sfp_usercontext);
 	schedule_work(&sfp->ew.work);
-- 
1.7.11.7
