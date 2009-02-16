From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] sg: remove the own list management for struct sg_fd
Date: Mon, 16 Feb 2009 13:26:53 +0900
Message-ID: <20090216132630B.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:51193 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755946AbZBPE1I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Feb 2009 23:27:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

This replaces the own list management for struct sg_fd with the
standard list_head structure.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/sg.c |   50 ++++++++++++++------------------------------------
 1 files changed, 14 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index b459864..17d1bd5 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -140,7 +140,7 @@ typedef struct sg_request {	/* SG_MAX_QUEUE requests outstanding per file */
 } Sg_request;
 
 typedef struct sg_fd {		/* holds the state of a file descriptor */
-	struct sg_fd *nextfp;	/* NULL when last opened fd on this device */
+	struct list_head sfd_siblings;
 	struct sg_device *parentdp;	/* owning device */
 	wait_queue_head_t read_wait;	/* queue read until command done */
 	rwlock_t rq_list_lock;	/* protect access to list in req_arr */
@@ -167,7 +167,7 @@ typedef struct sg_device { /* holds the state of each scsi generic device */
 	wait_queue_head_t o_excl_wait;	/* queue open() when O_EXCL in use */
 	int sg_tablesize;	/* adapter's max scatter-gather table size */
 	u32 index;		/* device index number */
-	Sg_fd *headfp;		/* first open fd belonging to this device */
+	struct list_head sfds;
 	volatile char detached;	/* 0->attached, 1->detached pending removal */
 	volatile char exclude;	/* opened for exclusive access */
 	char sgdebug;		/* 0->off, 1->sense, 9->dump dev, 10-> all devs */
@@ -258,13 +258,13 @@ sg_open(struct inode *inode, struct file *filp)
 			retval = -EPERM; /* Can't lock it with read only access */
 			goto error_out;
 		}
-		if (sdp->headfp && (flags & O_NONBLOCK)) {
+		if (!list_empty(&sdp->sfds) && (flags & O_NONBLOCK)) {
 			retval = -EBUSY;
 			goto error_out;
 		}
 		res = 0;
 		__wait_event_interruptible(sdp->o_excl_wait,
-			((sdp->headfp || sdp->exclude) ? 0 : (sdp->exclude = 1)), res);
+					   ((!list_empty(&sdp->sfds) || sdp->exclude) ? 0 : (sdp->exclude = 1)), res);
 		if (res) {
 			retval = res;	/* -ERESTARTSYS because signal hit process */
 			goto error_out;
@@ -286,7 +286,7 @@ sg_open(struct inode *inode, struct file *filp)
 		retval = -ENODEV;
 		goto error_out;
 	}
-	if (!sdp->headfp) {	/* no existing opens on this device */
+	if (list_empty(&sdp->sfds)) {	/* no existing opens on this device */
 		sdp->sgdebug = 0;
 		q = sdp->device->request_queue;
 		sdp->sg_tablesize = min(q->max_hw_segments,
@@ -1375,6 +1375,7 @@ static Sg_device *sg_alloc(struct gendisk *disk, struct scsi_device *scsidp)
 	disk->first_minor = k;
 	sdp->disk = disk;
 	sdp->device = scsidp;
+	INIT_LIST_HEAD(&sdp->sfds);
 	init_waitqueue_head(&sdp->o_excl_wait);
 	sdp->sg_tablesize = min(q->max_hw_segments, q->max_phys_segments);
 	sdp->index = k;
@@ -1517,7 +1518,7 @@ static void sg_remove(struct device *cl_dev, struct class_interface *cl_intf)
 	/* Need a write lock to set sdp->detached. */
 	write_lock_irqsave(&sg_index_lock, iflags);
 	sdp->detached = 1;
-	for (sfp = sdp->headfp; sfp; sfp = sfp->nextfp) {
+	list_for_each_entry(sfp, &sdp->sfds, sfd_siblings) {
 		wake_up_interruptible(&sfp->read_wait);
 		kill_fasync(&sfp->async_qp, SIGPOLL, POLL_HUP);
 	}
@@ -2024,14 +2025,7 @@ sg_add_sfp(Sg_device * sdp, int dev)
 	sfp->keep_orphan = SG_DEF_KEEP_ORPHAN;
 	sfp->parentdp = sdp;
 	write_lock_irqsave(&sg_index_lock, iflags);
-	if (!sdp->headfp)
-		sdp->headfp = sfp;
-	else {			/* add to tail of existing list */
-		Sg_fd *pfp = sdp->headfp;
-		while (pfp->nextfp)
-			pfp = pfp->nextfp;
-		pfp->nextfp = sfp;
-	}
+	list_add_tail(&sfp->sfd_siblings, &sdp->sfds);
 	write_unlock_irqrestore(&sg_index_lock, iflags);
 	SCSI_LOG_TIMEOUT(3, printk("sg_add_sfp: sfp=0x%p\n", sfp));
 	if (unlikely(sg_big_buff != def_reserved_size))
@@ -2080,28 +2074,10 @@ static void sg_remove_sfp(struct kref *kref)
 {
 	struct sg_fd *sfp = container_of(kref, struct sg_fd, f_ref);
 	struct sg_device *sdp = sfp->parentdp;
-	Sg_fd *fp;
-	Sg_fd *prev_fp;
 	unsigned long iflags;
 
-	/* CAUTION!  Note that sfp can still be found by walking sdp->headfp
-	 * even though the refcount is now 0.  Therefore, unlink sfp from
-	 * sdp->headfp BEFORE doing any other cleanup.
-	 */
-
 	write_lock_irqsave(&sg_index_lock, iflags);
-	prev_fp = sdp->headfp;
-	if (sfp == prev_fp)
-		sdp->headfp = prev_fp->nextfp;
-	else {
-		while ((fp = prev_fp->nextfp)) {
-			if (sfp == fp) {
-				prev_fp->nextfp = fp->nextfp;
-				break;
-			}
-			prev_fp = fp;
-		}
-	}
+	list_del(&sfp->sfd_siblings);
 	write_unlock_irqrestore(&sg_index_lock, iflags);
 	wake_up_interruptible(&sdp->o_excl_wait);
 
@@ -2486,10 +2462,12 @@ static void sg_proc_debug_helper(struct seq_file *s, Sg_device * sdp)
 	const char * cp;
 	unsigned int ms;
 
-	for (k = 0, fp = sdp->headfp; fp != NULL; ++k, fp = fp->nextfp) {
+	k = 0;
+	list_for_each_entry(fp, &sdp->sfds, sfd_siblings) {
+		k++;
 		read_lock(&fp->rq_list_lock); /* irqs already disabled */
 		seq_printf(s, "   FD(%d): timeout=%dms bufflen=%d "
-			   "(res)sgat=%d low_dma=%d\n", k + 1,
+			   "(res)sgat=%d low_dma=%d\n", k,
 			   jiffies_to_msecs(fp->timeout),
 			   fp->reserve.bufflen,
 			   (int) fp->reserve.k_use_sg,
@@ -2559,7 +2537,7 @@ static int sg_proc_seq_show_debug(struct seq_file *s, void *v)
 
 	read_lock_irqsave(&sg_index_lock, iflags);
 	sdp = it ? sg_lookup_dev(it->index) : NULL;
-	if (sdp && sdp->headfp) {
+	if (sdp && !list_empty(&sdp->sfds)) {
 		struct scsi_device *scsidp = sdp->device;
 
 		seq_printf(s, " >>> device=%s ", sdp->disk->disk_name);
-- 
1.5.6.5

