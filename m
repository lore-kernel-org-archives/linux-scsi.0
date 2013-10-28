From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 3.12-rc7
Date: Mon, 28 Oct 2013 07:42:38 -0700
Message-ID: <1382971358.2161.7.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a set of four patches that revert functionality introduced in
the merge window to sg.  The locking changes turned out to introduce
this bug:

    [  205.372901] [ BUG: lock held when returning to user space! ]
[...]
    [  205.373285]  #0:  (&sdp->o_sem){.+.+..}, at: [<ffffffff8161e650>]
sg_open+0x3a0/0x4d0

The fix is large, so at this late stage we'd like to revert the
functionality and start again in the next merge window.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

James Bottomley (4):
      Revert "sg: use rwsem to solve race during exclusive open"
      Revert "sg: no need sg_open_exclusive_lock"
      Revert "sg: checking sdp->detached isn't protected when open"
      Revert "sg: push file descriptor list locking down to per-device locking"

And the diffstat:

 drivers/scsi/sg.c | 176 +++++++++++++++++++++++++++++-------------------------
 1 file changed, 95 insertions(+), 81 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 5cbc4bb..df5e961 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -105,8 +105,11 @@ static int scatter_elem_sz_prev = SG_SCATTER_SZ;
 static int sg_add(struct device *, struct class_interface *);
 static void sg_remove(struct device *, struct class_interface *);
 
+static DEFINE_SPINLOCK(sg_open_exclusive_lock);
+
 static DEFINE_IDR(sg_index_idr);
-static DEFINE_RWLOCK(sg_index_lock);
+static DEFINE_RWLOCK(sg_index_lock);	/* Also used to lock
+							   file descriptor list for device */
 
 static struct class_interface sg_interface = {
 	.add_dev	= sg_add,
@@ -143,7 +146,8 @@ typedef struct sg_request {	/* SG_MAX_QUEUE requests outstanding per file */
 } Sg_request;
 
 typedef struct sg_fd {		/* holds the state of a file descriptor */
-	struct list_head sfd_siblings; /* protected by sfd_lock of device */
+	/* sfd_siblings is protected by sg_index_lock */
+	struct list_head sfd_siblings;
 	struct sg_device *parentdp;	/* owning device */
 	wait_queue_head_t read_wait;	/* queue read until command done */
 	rwlock_t rq_list_lock;	/* protect access to list in req_arr */
@@ -166,12 +170,13 @@ typedef struct sg_fd {		/* holds the state of a file descriptor */
 
 typedef struct sg_device { /* holds the state of each scsi generic device */
 	struct scsi_device *device;
+	wait_queue_head_t o_excl_wait;	/* queue open() when O_EXCL in use */
 	int sg_tablesize;	/* adapter's max scatter-gather table size */
 	u32 index;		/* device index number */
-	spinlock_t sfd_lock;	/* protect file descriptor list for device */
+	/* sfds is protected by sg_index_lock */
 	struct list_head sfds;
-	struct rw_semaphore o_sem;	/* exclude open should hold this rwsem */
 	volatile char detached;	/* 0->attached, 1->detached pending removal */
+	/* exclude protected by sg_open_exclusive_lock */
 	char exclude;		/* opened for exclusive access */
 	char sgdebug;		/* 0->off, 1->sense, 9->dump dev, 10-> all devs */
 	struct gendisk *disk;
@@ -220,14 +225,35 @@ static int sg_allow_access(struct file *filp, unsigned char *cmd)
 	return blk_verify_command(cmd, filp->f_mode & FMODE_WRITE);
 }
 
+static int get_exclude(Sg_device *sdp)
+{
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&sg_open_exclusive_lock, flags);
+	ret = sdp->exclude;
+	spin_unlock_irqrestore(&sg_open_exclusive_lock, flags);
+	return ret;
+}
+
+static int set_exclude(Sg_device *sdp, char val)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&sg_open_exclusive_lock, flags);
+	sdp->exclude = val;
+	spin_unlock_irqrestore(&sg_open_exclusive_lock, flags);
+	return val;
+}
+
 static int sfds_list_empty(Sg_device *sdp)
 {
 	unsigned long flags;
 	int ret;
 
-	spin_lock_irqsave(&sdp->sfd_lock, flags);
+	read_lock_irqsave(&sg_index_lock, flags);
 	ret = list_empty(&sdp->sfds);
-	spin_unlock_irqrestore(&sdp->sfd_lock, flags);
+	read_unlock_irqrestore(&sg_index_lock, flags);
 	return ret;
 }
 
@@ -239,6 +265,7 @@ sg_open(struct inode *inode, struct file *filp)
 	struct request_queue *q;
 	Sg_device *sdp;
 	Sg_fd *sfp;
+	int res;
 	int retval;
 
 	nonseekable_open(inode, filp);
@@ -267,52 +294,54 @@ sg_open(struct inode *inode, struct file *filp)
 		goto error_out;
 	}
 
-	if ((flags & O_EXCL) && (O_RDONLY == (flags & O_ACCMODE))) {
-		retval = -EPERM; /* Can't lock it with read only access */
-		goto error_out;
-	}
-	if (flags & O_NONBLOCK) {
-		if (flags & O_EXCL) {
-			if (!down_write_trylock(&sdp->o_sem)) {
-				retval = -EBUSY;
-				goto error_out;
-			}
-		} else {
-			if (!down_read_trylock(&sdp->o_sem)) {
-				retval = -EBUSY;
-				goto error_out;
-			}
+	if (flags & O_EXCL) {
+		if (O_RDONLY == (flags & O_ACCMODE)) {
+			retval = -EPERM; /* Can't lock it with read only access */
+			goto error_out;
+		}
+		if (!sfds_list_empty(sdp) && (flags & O_NONBLOCK)) {
+			retval = -EBUSY;
+			goto error_out;
+		}
+		res = wait_event_interruptible(sdp->o_excl_wait,
+					   ((!sfds_list_empty(sdp) || get_exclude(sdp)) ? 0 : set_exclude(sdp, 1)));
+		if (res) {
+			retval = res;	/* -ERESTARTSYS because signal hit process */
+			goto error_out;
+		}
+	} else if (get_exclude(sdp)) {	/* some other fd has an exclusive lock on dev */
+		if (flags & O_NONBLOCK) {
+			retval = -EBUSY;
+			goto error_out;
+		}
+		res = wait_event_interruptible(sdp->o_excl_wait, !get_exclude(sdp));
+		if (res) {
+			retval = res;	/* -ERESTARTSYS because signal hit process */
+			goto error_out;
 		}
-	} else {
-		if (flags & O_EXCL)
-			down_write(&sdp->o_sem);
-		else
-			down_read(&sdp->o_sem);
 	}
-	/* Since write lock is held, no need to check sfd_list */
-	if (flags & O_EXCL)
-		sdp->exclude = 1;	/* used by release lock */
-
+	if (sdp->detached) {
+		retval = -ENODEV;
+		goto error_out;
+	}
 	if (sfds_list_empty(sdp)) {	/* no existing opens on this device */
 		sdp->sgdebug = 0;
 		q = sdp->device->request_queue;
 		sdp->sg_tablesize = queue_max_segments(q);
 	}
-	sfp = sg_add_sfp(sdp, dev);
-	if (!IS_ERR(sfp))
+	if ((sfp = sg_add_sfp(sdp, dev)))
 		filp->private_data = sfp;
-		/* retval is already provably zero at this point because of the
-		 * check after retval = scsi_autopm_get_device(sdp->device))
-		 */
 	else {
-		retval = PTR_ERR(sfp);
-
 		if (flags & O_EXCL) {
-			sdp->exclude = 0;	/* undo if error */
-			up_write(&sdp->o_sem);
-		} else
-			up_read(&sdp->o_sem);
+			set_exclude(sdp, 0);	/* undo if error */
+			wake_up_interruptible(&sdp->o_excl_wait);
+		}
+		retval = -ENOMEM;
+		goto error_out;
+	}
+	retval = 0;
 error_out:
+	if (retval) {
 		scsi_autopm_put_device(sdp->device);
 sdp_put:
 		scsi_device_put(sdp->device);
@@ -329,18 +358,13 @@ sg_release(struct inode *inode, struct file *filp)
 {
 	Sg_device *sdp;
 	Sg_fd *sfp;
-	int excl;
 
 	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
 	SCSI_LOG_TIMEOUT(3, printk("sg_release: %s\n", sdp->disk->disk_name));
 
-	excl = sdp->exclude;
-	sdp->exclude = 0;
-	if (excl)
-		up_write(&sdp->o_sem);
-	else
-		up_read(&sdp->o_sem);
+	set_exclude(sdp, 0);
+	wake_up_interruptible(&sdp->o_excl_wait);
 
 	scsi_autopm_put_device(sdp->device);
 	kref_put(&sfp->f_ref, sg_remove_sfp);
@@ -1391,9 +1415,8 @@ static Sg_device *sg_alloc(struct gendisk *disk, struct scsi_device *scsidp)
 	disk->first_minor = k;
 	sdp->disk = disk;
 	sdp->device = scsidp;
-	spin_lock_init(&sdp->sfd_lock);
 	INIT_LIST_HEAD(&sdp->sfds);
-	init_rwsem(&sdp->o_sem);
+	init_waitqueue_head(&sdp->o_excl_wait);
 	sdp->sg_tablesize = queue_max_segments(q);
 	sdp->index = k;
 	kref_init(&sdp->d_ref);
@@ -1526,13 +1549,11 @@ static void sg_remove(struct device *cl_dev, struct class_interface *cl_intf)
 
 	/* Need a write lock to set sdp->detached. */
 	write_lock_irqsave(&sg_index_lock, iflags);
-	spin_lock(&sdp->sfd_lock);
 	sdp->detached = 1;
 	list_for_each_entry(sfp, &sdp->sfds, sfd_siblings) {
 		wake_up_interruptible(&sfp->read_wait);
 		kill_fasync(&sfp->async_qp, SIGPOLL, POLL_HUP);
 	}
-	spin_unlock(&sdp->sfd_lock);
 	write_unlock_irqrestore(&sg_index_lock, iflags);
 
 	sysfs_remove_link(&scsidp->sdev_gendev.kobj, "generic");
@@ -2043,7 +2064,7 @@ sg_add_sfp(Sg_device * sdp, int dev)
 
 	sfp = kzalloc(sizeof(*sfp), GFP_ATOMIC | __GFP_NOWARN);
 	if (!sfp)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
 	init_waitqueue_head(&sfp->read_wait);
 	rwlock_init(&sfp->rq_list_lock);
@@ -2057,13 +2078,9 @@ sg_add_sfp(Sg_device * sdp, int dev)
 	sfp->cmd_q = SG_DEF_COMMAND_Q;
 	sfp->keep_orphan = SG_DEF_KEEP_ORPHAN;
 	sfp->parentdp = sdp;
-	spin_lock_irqsave(&sdp->sfd_lock, iflags);
-	if (sdp->detached) {
-		spin_unlock_irqrestore(&sdp->sfd_lock, iflags);
-		return ERR_PTR(-ENODEV);
-	}
+	write_lock_irqsave(&sg_index_lock, iflags);
 	list_add_tail(&sfp->sfd_siblings, &sdp->sfds);
-	spin_unlock_irqrestore(&sdp->sfd_lock, iflags);
+	write_unlock_irqrestore(&sg_index_lock, iflags);
 	SCSI_LOG_TIMEOUT(3, printk("sg_add_sfp: sfp=0x%p\n", sfp));
 	if (unlikely(sg_big_buff != def_reserved_size))
 		sg_big_buff = def_reserved_size;
@@ -2113,9 +2130,10 @@ static void sg_remove_sfp(struct kref *kref)
 	struct sg_device *sdp = sfp->parentdp;
 	unsigned long iflags;
 
-	spin_lock_irqsave(&sdp->sfd_lock, iflags);
+	write_lock_irqsave(&sg_index_lock, iflags);
 	list_del(&sfp->sfd_siblings);
-	spin_unlock_irqrestore(&sdp->sfd_lock, iflags);
+	write_unlock_irqrestore(&sg_index_lock, iflags);
+	wake_up_interruptible(&sdp->o_excl_wait);
 
 	INIT_WORK(&sfp->ew.work, sg_remove_sfp_usercontext);
 	schedule_work(&sfp->ew.work);
@@ -2502,7 +2520,7 @@ static int sg_proc_seq_show_devstrs(struct seq_file *s, void *v)
 	return 0;
 }
 
-/* must be called while holding sg_index_lock and sfd_lock */
+/* must be called while holding sg_index_lock */
 static void sg_proc_debug_helper(struct seq_file *s, Sg_device * sdp)
 {
 	int k, m, new_interface, blen, usg;
@@ -2587,26 +2605,22 @@ static int sg_proc_seq_show_debug(struct seq_file *s, void *v)
 
 	read_lock_irqsave(&sg_index_lock, iflags);
 	sdp = it ? sg_lookup_dev(it->index) : NULL;
-	if (sdp) {
-		spin_lock(&sdp->sfd_lock);
-		if (!list_empty(&sdp->sfds)) {
-			struct scsi_device *scsidp = sdp->device;
+	if (sdp && !list_empty(&sdp->sfds)) {
+		struct scsi_device *scsidp = sdp->device;
 
-			seq_printf(s, " >>> device=%s ", sdp->disk->disk_name);
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
-			sg_proc_debug_helper(s, sdp);
-		}
-		spin_unlock(&sdp->sfd_lock);
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
+			   sdp->sg_tablesize, get_exclude(sdp));
+		sg_proc_debug_helper(s, sdp);
 	}
 	read_unlock_irqrestore(&sg_index_lock, iflags);
 	return 0;
