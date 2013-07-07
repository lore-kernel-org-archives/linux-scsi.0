From: vaughan <vaughan.cao@oracle.com>
Subject: [PATCH v3 1/1] [SCSI] sg: fix race condition when do exclusive open
Date: Mon, 08 Jul 2013 03:53:49 +0800
Message-ID: <51D9C74D.6060708@oracle.com>
References: <51AF0269.9070900@oracle.com> <20130605132746.GA1690@logfs.org> <51AF646D.7030903@oracle.com> <20130605154106.GA2737@logfs.org> <51BF0ADD.1080604@oracle.com> <20130705173953.GA15089@logfs.org> <51D852DC.4070808@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <51D852DC.4070808@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: vaughan <vaughan.cao@oracle.com>
Cc: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>, dgilbert@interlog.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use rwsem to aid opens. Exclusive open has to get write lock and non-exclusive open should get read lock.
Replace global sg_open_exclusive_lock with a per device lock - sfd_lock. Since sfds list is now protected by the lock owned by the same sg_device, sg_index_lock becomes a real global lock to only protect sg devices lookup.

Please pay attention to sdp->detached. Previously sg_open may also race with sg_remove. Now there are two points for sg_open to detect detached and finish itself. One is at sg_device lookup and the other is when trying to link new sfp into the sfds list in sg_add_sfp.
I don't think it's necessary to do extra set_exclude and wake_up o_excl_wait in sg_release before, so I remove them and only do the cleanup in sg_remove_sfp.
Although simple testcases are passed, I'm not certain if I've fixed it well, please give me any comments as you wish.

Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
---
  drivers/scsi/sg.c | 187 ++++++++++++++++++++++++++----------------------------
  1 file changed, 89 insertions(+), 98 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 25b5455..3fc8c19 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -103,11 +103,8 @@ static int scatter_elem_sz_prev = SG_SCATTER_SZ;
  static int sg_add(struct device *, struct class_interface *);
  static void sg_remove(struct device *, struct class_interface *);
  
-static DEFINE_SPINLOCK(sg_open_exclusive_lock);
-
  static DEFINE_IDR(sg_index_idr);
-static DEFINE_RWLOCK(sg_index_lock);	/* Also used to lock
-							   file descriptor list for device */
+static DEFINE_RWLOCK(sg_index_lock);	/* protect sg index */
  
  static struct class_interface sg_interface = {
  	.add_dev	= sg_add,
@@ -144,7 +141,7 @@ typedef struct sg_request {	/* SG_MAX_QUEUE requests outstanding per file */
  } Sg_request;
  
  typedef struct sg_fd {		/* holds the state of a file descriptor */
-	/* sfd_siblings is protected by sg_index_lock */
+	/* sfd_siblings is protected by sfd_lock of sg_device */
  	struct list_head sfd_siblings;
  	struct sg_device *parentdp;	/* owning device */
  	wait_queue_head_t read_wait;	/* queue read until command done */
@@ -168,13 +165,12 @@ typedef struct sg_fd {		/* holds the state of a file descriptor */
  
  typedef struct sg_device { /* holds the state of each scsi generic device */
  	struct scsi_device *device;
-	wait_queue_head_t o_excl_wait;	/* queue open() when O_EXCL in use */
  	int sg_tablesize;	/* adapter's max scatter-gather table size */
  	u32 index;		/* device index number */
-	/* sfds is protected by sg_index_lock */
+	spinlock_t sfd_lock;	/* protect sfds, exclude */
  	struct list_head sfds;
+	struct rw_semaphore o_sem;	/* exclude open should hold this rwsem */
  	volatile char detached;	/* 0->attached, 1->detached pending removal */
-	/* exclude protected by sg_open_exclusive_lock */
  	char exclude;		/* opened for exclusive access */
  	char sgdebug;		/* 0->off, 1->sense, 9->dump dev, 10-> all devs */
  	struct gendisk *disk;
@@ -199,7 +195,7 @@ static void sg_remove_scat(Sg_scatter_hold * schp);
  static void sg_build_reserve(Sg_fd * sfp, int req_size);
  static void sg_link_reserve(Sg_fd * sfp, Sg_request * srp, int size);
  static void sg_unlink_reserve(Sg_fd * sfp, Sg_request * srp);
-static Sg_fd *sg_add_sfp(Sg_device * sdp, int dev);
+static Sg_fd *sg_add_sfp(Sg_device * sdp, int dev, int excl, int * reason);
  static void sg_remove_sfp(struct kref *);
  static Sg_request *sg_get_rq_mark(Sg_fd * sfp, int pack_id);
  static Sg_request *sg_add_request(Sg_fd * sfp);
@@ -224,35 +220,14 @@ static int sg_allow_access(struct file *filp, unsigned char *cmd)
  	return blk_verify_command(q, cmd, filp->f_mode & FMODE_WRITE);
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
  static int sfds_list_empty(Sg_device *sdp)
  {
  	unsigned long flags;
  	int ret;
  
-	read_lock_irqsave(&sg_index_lock, flags);
+	spin_lock_irqsave(&sdp->sfd_lock, flags);
  	ret = list_empty(&sdp->sfds);
-	read_unlock_irqrestore(&sg_index_lock, flags);
+	spin_unlock_irqrestore(&sdp->sfd_lock, flags);
  	return ret;
  }
  
@@ -264,8 +239,8 @@ sg_open(struct inode *inode, struct file *filp)
  	struct request_queue *q;
  	Sg_device *sdp;
  	Sg_fd *sfp;
-	int res;
  	int retval;
+	unsigned long iflags;
  
  	nonseekable_open(inode, filp);
  	SCSI_LOG_TIMEOUT(3, printk("sg_open: dev=%d, flags=0x%x\n", dev, flags));
@@ -293,52 +268,45 @@ sg_open(struct inode *inode, struct file *filp)
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
-		}
-	}
-	if (sdp->detached) {
-		retval = -ENODEV;
+	if ((flags & O_EXCL) && (O_RDONLY == (flags & O_ACCMODE))) {
+		retval = -EPERM; /* Can't lock it with read only access */
  		goto error_out;
  	}
+	if (flags & O_NONBLOCK) {
+		if (flags & O_EXCL) {
+			if (!down_write_trylock(&sdp->o_sem)) {
+				retval = -EBUSY;
+				goto error_out;
+			}
+			/* if write lock is held, there is only one user. */
+		} else {
+			if (!down_read_trylock(&sdp->o_sem)) {
+				retval = -EBUSY;
+				goto error_out;
+			}
+		}
+	} else {
+		if (flags & O_EXCL)
+			down_write(&sdp->o_sem);
+		else
+			down_read(&sdp->o_sem);
+	}
+
  	if (sfds_list_empty(sdp)) {	/* no existing opens on this device */
  		sdp->sgdebug = 0;
  		q = sdp->device->request_queue;
  		sdp->sg_tablesize = queue_max_segments(q);
  	}
-	if ((sfp = sg_add_sfp(sdp, dev)))
-		filp->private_data = sfp;
-	else {
-		if (flags & O_EXCL) {
-			set_exclude(sdp, 0);	/* undo if error */
-			wake_up_interruptible(&sdp->o_excl_wait);
-		}
-		retval = -ENOMEM;
-		goto error_out;
-	}
+	if (!(sfp = sg_add_sfp(sdp, dev, (flags & O_EXCL ? 1 : 0), &retval)))
+		goto sem_out;
+	filp->private_data = sfp;
  	retval = 0;
+sem_out:
+	if (retval)
+		if (flags & O_EXCL)
+			up_write(&sdp->o_sem);
+		else
+			up_read(&sdp->o_sem);
  error_out:
  	if (retval) {
  		scsi_autopm_put_device(sdp->device);
@@ -362,9 +330,6 @@ sg_release(struct inode *inode, struct file *filp)
  		return -ENXIO;
  	SCSI_LOG_TIMEOUT(3, printk("sg_release: %s\n", sdp->disk->disk_name));
  
-	set_exclude(sdp, 0);
-	wake_up_interruptible(&sdp->o_excl_wait);
-
  	scsi_autopm_put_device(sdp->device);
  	kref_put(&sfp->f_ref, sg_remove_sfp);
  	return 0;
@@ -1414,8 +1379,9 @@ static Sg_device *sg_alloc(struct gendisk *disk, struct scsi_device *scsidp)
  	disk->first_minor = k;
  	sdp->disk = disk;
  	sdp->device = scsidp;
+	spin_lock_init(&sdp->sfd_lock);
  	INIT_LIST_HEAD(&sdp->sfds);
-	init_waitqueue_head(&sdp->o_excl_wait);
+	init_rwsem(&sdp->o_sem);
  	sdp->sg_tablesize = queue_max_segments(q);
  	sdp->index = k;
  	kref_init(&sdp->d_ref);
@@ -1556,11 +1522,13 @@ static void sg_remove(struct device *cl_dev, struct class_interface *cl_intf)
  
  	/* Need a write lock to set sdp->detached. */
  	write_lock_irqsave(&sg_index_lock, iflags);
+	spin_lock(&sdp->sfd_lock);
  	sdp->detached = 1;
  	list_for_each_entry(sfp, &sdp->sfds, sfd_siblings) {
  		wake_up_interruptible(&sfp->read_wait);
  		kill_fasync(&sfp->async_qp, SIGPOLL, POLL_HUP);
  	}
+	spin_unlock(&sdp->sfd_lock);
  	write_unlock_irqrestore(&sg_index_lock, iflags);
  
  	sysfs_remove_link(&scsidp->sdev_gendev.kobj, "generic");
@@ -2063,15 +2031,18 @@ sg_remove_request(Sg_fd * sfp, Sg_request * srp)
  }
  
  static Sg_fd *
-sg_add_sfp(Sg_device * sdp, int dev)
+sg_add_sfp(Sg_device * sdp, int dev, int excl, int * reason)
  {
  	Sg_fd *sfp;
  	unsigned long iflags;
  	int bufflen;
  
  	sfp = kzalloc(sizeof(*sfp), GFP_ATOMIC | __GFP_NOWARN);
-	if (!sfp)
+	if (!sfp) {
+		if (reason)
+			*reason = -ENOMEM;
  		return NULL;
+	}
  
  	init_waitqueue_head(&sfp->read_wait);
  	rwlock_init(&sfp->rq_list_lock);
@@ -2085,9 +2056,19 @@ sg_add_sfp(Sg_device * sdp, int dev)
  	sfp->cmd_q = SG_DEF_COMMAND_Q;
  	sfp->keep_orphan = SG_DEF_KEEP_ORPHAN;
  	sfp->parentdp = sdp;
-	write_lock_irqsave(&sg_index_lock, iflags);
+
+	spin_lock_irqsave(&sdp->sfd_lock, iflags);
+	if (sdp->detached) {
+		spin_unlock_irqrestore(&sdp->sfd_lock, iflags);
+		if (reason)
+			*reason = -ENODEV;
+		return NULL;
+	}
  	list_add_tail(&sfp->sfd_siblings, &sdp->sfds);
-	write_unlock_irqrestore(&sg_index_lock, iflags);
+	if (excl)
+		sdp->exclude = 1;
+	spin_unlock_irqrestore(&sdp->sfd_lock, iflags);
+
  	SCSI_LOG_TIMEOUT(3, printk("sg_add_sfp: sfp=0x%p\n", sfp));
  	if (unlikely(sg_big_buff != def_reserved_size))
  		sg_big_buff = def_reserved_size;
@@ -2136,11 +2117,17 @@ static void sg_remove_sfp(struct kref *kref)
  	struct sg_fd *sfp = container_of(kref, struct sg_fd, f_ref);
  	struct sg_device *sdp = sfp->parentdp;
  	unsigned long iflags;
+	int excl;
  
-	write_lock_irqsave(&sg_index_lock, iflags);
+	spin_lock_irqsave(&sdp->sfd_lock, iflags);
  	list_del(&sfp->sfd_siblings);
-	write_unlock_irqrestore(&sg_index_lock, iflags);
-	wake_up_interruptible(&sdp->o_excl_wait);
+	if ((excl = sdp->exclude))
+		sdp->exclude = 0;
+	spin_unlock_irqrestore(&sdp->sfd_lock, iflags);
+	if (excl)
+		up_write(&sdp->o_sem);
+	else
+		up_read(&sdp->o_sem);
  
  	INIT_WORK(&sfp->ew.work, sg_remove_sfp_usercontext);
  	schedule_work(&sfp->ew.work);
@@ -2531,7 +2518,7 @@ static int sg_proc_seq_show_devstrs(struct seq_file *s, void *v)
  	return 0;
  }
  
-/* must be called while holding sg_index_lock */
+/* must be called while holding sg_index_lock and sfd_lock */
  static void sg_proc_debug_helper(struct seq_file *s, Sg_device * sdp)
  {
  	int k, m, new_interface, blen, usg;
@@ -2616,22 +2603,26 @@ static int sg_proc_seq_show_debug(struct seq_file *s, void *v)
  
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
+				seq_printf(s, "detached pending close ");
+			else
+				seq_printf
+					(s, "scsi%d chan=%d id=%d lun=%d   em=%d",
+					 scsidp->host->host_no,
+					 scsidp->channel, scsidp->id,
+					 scsidp->lun,
+					 scsidp->host->hostt->emulated);
+			seq_printf(s, " sg_tablesize=%d excl=%d\n",
+					sdp->sg_tablesize, sdp->exclude);
+			sg_proc_debug_helper(s, sdp);
+		}
+		spin_unlock(&sdp->sfd_lock);
  	}
  	read_unlock_irqrestore(&sg_index_lock, iflags);
  	return 0;
-- 
1.7.11.7
