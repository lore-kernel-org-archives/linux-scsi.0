From: Vaughan Cao <vaughan.cao@oracle.com>
Subject: [PATCH v6 4/4] sg: push file descriptor list locking down to per-device locking
Date: Wed, 28 Aug 2013 18:07:52 +0800
Message-ID: <1377684472-7815-5-git-send-email-vaughan.cao@oracle.com>
References: <1377662419.2005.12.camel@dabdike>
 <1377684472-7815-1-git-send-email-vaughan.cao@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1377684472-7815-1-git-send-email-vaughan.cao@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: joern@logfs.org, vaughan.cao@oracle.com, dgilbert@interlog.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Push file descriptor list locking down to per-device locking. Let sg_index_lock
only protect device lookup.
sdp->detached is also set and checked with this lock held.

Changes from v4:
 * Since I use ERR_PTR and friends in sg_add_sfp, this patch should also be
updated to resolve conflict in cherrry-pick.

Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
---
 drivers/scsi/sg.c | 62 ++++++++++++++++++++++++++++++-------------------------
 1 file changed, 34 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 6bffe52..10d6943 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -106,8 +106,7 @@ static int sg_add(struct device *, struct class_interface *);
 static void sg_remove(struct device *, struct class_interface *);
 
 static DEFINE_IDR(sg_index_idr);
-static DEFINE_RWLOCK(sg_index_lock);	/* Also used to lock
-							   file descriptor list for device */
+static DEFINE_RWLOCK(sg_index_lock);
 
 static struct class_interface sg_interface = {
 	.add_dev	= sg_add,
@@ -144,8 +143,7 @@ typedef struct sg_request {	/* SG_MAX_QUEUE requests outstanding per file */
 } Sg_request;
 
 typedef struct sg_fd {		/* holds the state of a file descriptor */
-	/* sfd_siblings is protected by sg_index_lock */
-	struct list_head sfd_siblings;
+	struct list_head sfd_siblings; /* protected by sfd_lock of device */
 	struct sg_device *parentdp;	/* owning device */
 	wait_queue_head_t read_wait;	/* queue read until command done */
 	rwlock_t rq_list_lock;	/* protect access to list in req_arr */
@@ -170,7 +168,7 @@ typedef struct sg_device { /* holds the state of each scsi generic device */
 	struct scsi_device *device;
 	int sg_tablesize;	/* adapter's max scatter-gather table size */
 	u32 index;		/* device index number */
-	/* sfds is protected by sg_index_lock */
+	spinlock_t sfd_lock;	/* protect file descriptor list for device */
 	struct list_head sfds;
 	struct rw_semaphore o_sem;	/* exclude open should hold this rwsem */
 	volatile char detached;	/* 0->attached, 1->detached pending removal */
@@ -227,9 +225,9 @@ static int sfds_list_empty(Sg_device *sdp)
 	unsigned long flags;
 	int ret;
 
-	read_lock_irqsave(&sg_index_lock, flags);
+	spin_lock_irqsave(&sdp->sfd_lock, flags);
 	ret = list_empty(&sdp->sfds);
-	read_unlock_irqrestore(&sg_index_lock, flags);
+	spin_unlock_irqrestore(&sdp->sfd_lock, flags);
 	return ret;
 }
 
@@ -1394,6 +1392,7 @@ static Sg_device *sg_alloc(struct gendisk *disk, struct scsi_device *scsidp)
 	disk->first_minor = k;
 	sdp->disk = disk;
 	sdp->device = scsidp;
+	spin_lock_init(&sdp->sfd_lock);
 	INIT_LIST_HEAD(&sdp->sfds);
 	init_rwsem(&sdp->o_sem);
 	sdp->sg_tablesize = queue_max_segments(q);
@@ -1528,11 +1527,13 @@ static void sg_remove(struct device *cl_dev, struct class_interface *cl_intf)
 
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
@@ -2057,13 +2058,13 @@ sg_add_sfp(Sg_device * sdp, int dev)
 	sfp->cmd_q = SG_DEF_COMMAND_Q;
 	sfp->keep_orphan = SG_DEF_KEEP_ORPHAN;
 	sfp->parentdp = sdp;
-	write_lock_irqsave(&sg_index_lock, iflags);
+	spin_lock_irqsave(&sdp->sfd_lock, iflags);
 	if (sdp->detached) {
-		write_unlock_irqrestore(&sg_index_lock, iflags);
+		spin_unlock_irqrestore(&sdp->sfd_lock, iflags);
 		return ERR_PTR(-ENODEV);
 	}
 	list_add_tail(&sfp->sfd_siblings, &sdp->sfds);
-	write_unlock_irqrestore(&sg_index_lock, iflags);
+	spin_unlock_irqrestore(&sdp->sfd_lock, iflags);
 	SCSI_LOG_TIMEOUT(3, printk("sg_add_sfp: sfp=0x%p\n", sfp));
 	if (unlikely(sg_big_buff != def_reserved_size))
 		sg_big_buff = def_reserved_size;
@@ -2110,11 +2111,12 @@ static void sg_remove_sfp_usercontext(struct work_struct *work)
 static void sg_remove_sfp(struct kref *kref)
 {
 	struct sg_fd *sfp = container_of(kref, struct sg_fd, f_ref);
+	struct sg_device *sdp = sfp->parentdp;
 	unsigned long iflags;
 
-	write_lock_irqsave(&sg_index_lock, iflags);
+	spin_lock_irqsave(&sdp->sfd_lock, iflags);
 	list_del(&sfp->sfd_siblings);
-	write_unlock_irqrestore(&sg_index_lock, iflags);
+	spin_unlock_irqrestore(&sdp->sfd_lock, iflags);
 
 	INIT_WORK(&sfp->ew.work, sg_remove_sfp_usercontext);
 	schedule_work(&sfp->ew.work);
@@ -2501,7 +2503,7 @@ static int sg_proc_seq_show_devstrs(struct seq_file *s, void *v)
 	return 0;
 }
 
-/* must be called while holding sg_index_lock */
+/* must be called while holding sg_index_lock and sfd_lock */
 static void sg_proc_debug_helper(struct seq_file *s, Sg_device * sdp)
 {
 	int k, m, new_interface, blen, usg;
@@ -2586,22 +2588,26 @@ static int sg_proc_seq_show_debug(struct seq_file *s, void *v)
 
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
-			   sdp->sg_tablesize, sdp->exclude);
-		sg_proc_debug_helper(s, sdp);
+			seq_printf(s, " >>> device=%s ", sdp->disk->disk_name);
+			if (sdp->detached)
+				seq_printf(s, "detached pending close ");
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
-- 
1.8.3.1
