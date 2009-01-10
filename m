From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/2] sg: fix races during device removal (v2)
Date: Sun, 11 Jan 2009 02:26:17 +0900
Message-ID: <20090111022525I.fujita.tomonori@lab.ntt.co.jp>
References: <49625A67.3000304@cybernetics.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:58783 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399AbZAJR0j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jan 2009 12:26:39 -0500
In-Reply-To: <49625A67.3000304@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tonyb@cybernetics.com
Cc: dgilbert@interlog.com, fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org

On Mon, 05 Jan 2009 14:07:19 -0500
Tony Battersby <tonyb@cybernetics.com> wrote:

> This is version 2 of my patch, this time using a kref instead of int.
> There are also a lot of other changes since the first version since I
> found even more bugs both through testing and source code analysis.
> I have split the patch up into two parts: the first patch fixes
> races between open, close, device removal, and command completion.
> The second patch fixes some races I spotted in ioctl(SG_IO).
> 
> Below are a list of test cases fixed by the patch.

Thanks for the great work,


> ----------
> 
> test #1
> 
> open /dev/sgX
> send a command that takes a long time (e.g. any tape drive seek
> command)
> before command completes, echo 1 >
> /sys/class/scsi_generic/sgX/device/delete
> 
> without patch:
> oops
> 
> with patch:
> test program gets ENODEV immediately
> keventd sleeps until the cmd is complete
> this is suboptimal since it starves other users of keventd while
> waiting for the command to complete, but it is better than an oops

As you said, we can do better. It's not correct to make
class_interface's remove_dev hook, sg_remove wait for the completion
of all the commands.


> test #2
> 
> open /dev/sgX
> send a command that takes a long time (e.g. any tape drive seek
> command) without waiting for it to complete
> close fd
> before command completes, echo 1 >
> /sys/class/scsi_generic/sgX/device/delete
> 
> without patch:
> oops when the command does complete (sg_rq_end_io() bad pointer deref)
> 
> with patch:
> keventd sleeps until the cmd is complete
> this is suboptimal since it starves other users of keventd while
> waiting for the command to complete, but it is better than an oops

Ditto.


The main problem is about the lifetime of sg_dev and sg_fd. I think
that we can fix it in a simpler and better way.

You use kref for sg_dev. We can use kref for sg_fd too. I think that
that's all we need to do.

A sg_request gets the reference of sg_fd. It makes sure that sg_fd
doesn't go away if any outstanding sg_requests exists.

sg_fd gets the reference of sg_dev (with scsi_device) and makes sure
that the sg module doesn't go away.

Then sg_remove doesn't wait for anything. sg_fd gets the reference of
sg_dev so sg_dev doesn't go away. sg_rq_end_io puts the reference of
sg_fd then sg_fd is freed and sg_dev is freed safely.

Here's a patch to do the above. It's even simpler than the current sg
code. I confirmed that sg can pass the first, second and third tests
with this patch.

I think that 4th and 5th tests fail because of the lifetime of sg_dev
and sg_fd. Can you please try these tests with this patch?

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Sat, 10 Jan 2009 23:25:24 +0900
Subject: [PATCH] sg: fix the lifetime management of sg_dev and sg_fd

To fix the lifetime of sg_dev and sg_fd, this patch adds kref for
sg_dev and sg_fd.

A sg_request gets the reference of sg_fd. It makes sure that sg_fd
doesn't go away if any outstanding sg_requests exists.

sg_fd gets the reference of sg_dev (with scsi_device) and makes sure
that the sg module doesn't go away.


Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/sg.c |  198 +++++++++++++++++++++++++----------------------------
 1 files changed, 93 insertions(+), 105 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 5103855..11b4a56 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -158,6 +158,8 @@ typedef struct sg_fd {		/* holds the state of a file descriptor */
 	char next_cmd_len;	/* 0 -> automatic (def), >0 -> use on next write() */
 	char keep_orphan;	/* 0 -> drop orphan (def), 1 -> keep for read() */
 	char mmap_called;	/* 0 -> mmap() never called on this fd */
+	struct kref f_ref;
+	struct execute_work ew;
 } Sg_fd;
 
 typedef struct sg_device { /* holds the state of each scsi generic device */
@@ -171,6 +173,7 @@ typedef struct sg_device { /* holds the state of each scsi generic device */
 	char sgdebug;		/* 0->off, 1->sense, 9->dump dev, 10-> all devs */
 	struct gendisk *disk;
 	struct cdev * cdev;	/* char_dev [sysfs: /sys/cdev/major/sg<n>] */
+	struct kref d_ref;
 } Sg_device;
 
 static int sg_fasync(int fd, struct file *filp, int mode);
@@ -194,13 +197,13 @@ static void sg_build_reserve(Sg_fd * sfp, int req_size);
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
@@ -238,21 +241,19 @@ sg_open(struct inode *inode, struct file *filp)
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
@@ -308,11 +309,12 @@ sg_open(struct inode *inode, struct file *filp)
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
@@ -327,13 +329,11 @@ sg_release(struct inode *inode, struct file *filp)
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
+	sdp->exclude = 0;
+	wake_up_interruptible(&sdp->o_excl_wait);
+
+	kref_put(&sfp->f_ref, sg_remove_sfp);
 	return 0;
 }
 
@@ -1259,12 +1259,10 @@ static void sg_rq_end_io(struct request *rq, int uptodate)
 		return;
 	}
 	sfp = srp->parentfp;
-	if (sfp)
-		sdp = sfp->parentdp;
-	if ((NULL == sdp) || sdp->detached) {
+	sdp = sfp->parentdp;
+
+	if (sdp->detached)
 		printk(KERN_INFO "sg_cmd_done: device detached\n");
-		return;
-	}
 
 	sense = rq->sense;
 	result = rq->errors;
@@ -1303,18 +1301,7 @@ static void sg_rq_end_io(struct request *rq, int uptodate)
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
+	if (srp->orphan) {
 		if (sfp->keep_orphan)
 			srp->sg_io_owned = 0;
 		else {
@@ -1322,7 +1309,8 @@ static void sg_rq_end_io(struct request *rq, int uptodate)
 			srp = NULL;
 		}
 	}
-	if (sfp && srp) {
+
+	if (srp) {
 		/* Now wake up any sg_read() that is waiting for this packet. */
 		kill_fasync(&sfp->async_qp, SIGPOLL, POLL_IN);
 		write_lock_irqsave(&sfp->rq_list_lock, iflags);
@@ -1330,6 +1318,8 @@ static void sg_rq_end_io(struct request *rq, int uptodate)
 		wake_up_interruptible(&sfp->read_wait);
 		write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 	}
+
+	kref_put(&sfp->f_ref, sg_remove_sfp);
 }
 
 static struct file_operations sg_fops = {
@@ -1391,6 +1381,7 @@ static Sg_device *sg_alloc(struct gendisk *disk, struct scsi_device *scsidp)
 	init_waitqueue_head(&sdp->o_excl_wait);
 	sdp->sg_tablesize = min(q->max_hw_segments, q->max_phys_segments);
 	sdp->index = k;
+	kref_init(&sdp->d_ref);
 
 	error = 0;
  out:
@@ -1496,41 +1487,18 @@ sg_remove(struct device *cl_dev, struct class_interface *cl_intf)
 	unsigned long iflags;
 	Sg_fd *sfp;
 	Sg_fd *tsfp;
-	Sg_request *srp;
-	Sg_request *tsrp;
-	int delay;
 
 	if (!sdp)
 		return;
 
-	delay = 0;
+	sdp->detached = 1;
+
 	write_lock_irqsave(&sg_index_lock, iflags);
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
+	for (sfp = sdp->headfp; sfp; sfp = tsfp) {
+		tsfp = sfp->nextfp;
+
+		wake_up_interruptible(&sfp->read_wait);
+		kill_fasync(&sfp->async_qp, SIGPOLL, POLL_HUP);
 	}
 	write_unlock_irqrestore(&sg_index_lock, iflags);
 
@@ -1540,11 +1508,8 @@ sg_remove(struct device *cl_dev, struct class_interface *cl_intf)
 	sdp->cdev = NULL;
 	put_disk(sdp->disk);
 	sdp->disk = NULL;
-	if (NULL == sdp->headfp)
-		kfree(sdp);
 
-	if (delay)
-		msleep(10);	/* dirty detach so delay device destruction */
+	sg_put_dev(sdp);
 }
 
 module_param_named(scatter_elem_sz, scatter_elem_sz, int, S_IRUGO | S_IWUSR);
@@ -1993,6 +1958,7 @@ sg_add_request(Sg_fd * sfp)
 	if (resp) {
 		resp->nextrp = NULL;
 		resp->header.duration = jiffies_to_msecs(jiffies);
+		kref_get(&sfp->f_ref);
 	}
 	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 	return resp;
@@ -2060,6 +2026,7 @@ sg_add_sfp(Sg_device * sdp, int dev)
 	init_waitqueue_head(&sfp->read_wait);
 	rwlock_init(&sfp->rq_list_lock);
 
+	kref_init(&sfp->f_ref);
 	sfp->timeout = SG_DEFAULT_TIMEOUT;
 	sfp->timeout_user = SG_DEFAULT_TIMEOUT_USER;
 	sfp->force_packid = SG_DEF_FORCE_PACK_ID;
@@ -2087,6 +2054,9 @@ sg_add_sfp(Sg_device * sdp, int dev)
 	sg_build_reserve(sfp, bufflen);
 	SCSI_LOG_TIMEOUT(3, printk("sg_add_sfp:   bufflen=%d, k_use_sg=%d\n",
 			   sfp->reserve.bufflen, sfp->reserve.k_use_sg));
+
+	kref_get(&sdp->d_ref);
+	__module_get(THIS_MODULE);
 	return sfp;
 }
 
@@ -2114,48 +2084,38 @@ __sg_remove_sfp(Sg_device * sdp, Sg_fd * sfp)
 			(int) sfp->reserve.bufflen, (int) sfp->reserve.k_use_sg));
 		sg_remove_scat(&sfp->reserve);
 	}
-	sfp->parentdp = NULL;
 	SCSI_LOG_TIMEOUT(6, printk("__sg_remove_sfp:    sfp=0x%p\n", sfp));
 	kfree(sfp);
 }
 
-/* Returns 0 in normal case, 1 when detached and sdp object removed */
-static int
-sg_remove_sfp(Sg_device * sdp, Sg_fd * sfp)
+static void sg_remove_sfp_usercontext(struct work_struct *work)
 {
+	struct sg_fd *sfp = container_of(work, struct sg_fd, ew.work);
+	struct sg_device *sdp = sfp->parentdp;
+	unsigned long iflags;
 	Sg_request *srp;
 	Sg_request *tsrp;
-	int dirty = 0;
-	int res = 0;
 
 	for (srp = sfp->headrp; srp; srp = tsrp) {
 		tsrp = srp->nextrp;
-		if (sg_srp_done(srp, sfp))
-			sg_finish_rem_req(srp);
-		else
-			++dirty;
+		sg_finish_rem_req(srp);
 	}
-	if (0 == dirty) {
-		unsigned long iflags;
 
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
+	write_lock_irqsave(&sg_index_lock, iflags);
+	__sg_remove_sfp(sdp, sfp);
+	write_unlock_irqrestore(&sg_index_lock, iflags);
+
+	scsi_device_put(sdp->device);
+
+	sg_put_dev(sdp);
+
+	module_put(THIS_MODULE);
+}
+
+static void sg_remove_sfp(struct kref *kref)
+{
+	struct sg_fd *sfp = container_of(kref, struct sg_fd, f_ref);
+	execute_in_process_context(sg_remove_sfp_usercontext, &sfp->ew);
 }
 
 static int
@@ -2197,6 +2157,28 @@ sg_last_dev(void)
 }
 #endif
 
+static void sg_device_release(struct kref *kref)
+{
+	struct sg_device *sdp = container_of(kref, struct sg_device, d_ref);
+	unsigned long flags;
+
+	SCSI_LOG_TIMEOUT(3, printk("sg_remove: dev=%d\n", sdp->index));
+
+	write_lock_irqsave(&sg_index_lock, flags);
+	idr_remove(&sg_index_idr, sdp->index);
+	write_unlock_irqrestore(&sg_index_lock, flags);
+
+	kfree(sdp);
+}
+
+static void sg_put_dev(struct sg_device *sdp)
+{
+	if (!sdp)
+		return;
+
+	kref_put(&sdp->d_ref, sg_device_release);
+}
+
 static Sg_device *
 sg_get_dev(int dev)
 {
@@ -2205,6 +2187,8 @@ sg_get_dev(int dev)
 
 	read_lock_irqsave(&sg_index_lock, iflags);
 	sdp = idr_find(&sg_index_idr, dev);
+	if (sdp)
+		kref_get(&sdp->d_ref);
 	read_unlock_irqrestore(&sg_index_lock, iflags);
 
 	return sdp;
@@ -2478,6 +2462,7 @@ static int sg_proc_seq_show_dev(struct seq_file *s, void *v)
 			      (int) scsi_device_online(scsidp));
 	else
 		seq_printf(s, "-1\t-1\t-1\t-1\t-1\t-1\t-1\t-1\t-1\n");
+	sg_put_dev(sdp);
 	return 0;
 }
 
@@ -2498,6 +2483,7 @@ static int sg_proc_seq_show_devstrs(struct seq_file *s, void *v)
 			   scsidp->vendor, scsidp->model, scsidp->rev);
 	else
 		seq_printf(s, "<no active device>\n");
+	sg_put_dev(sdp);
 	return 0;
 }
 
@@ -2582,7 +2568,7 @@ static int sg_proc_seq_show_debug(struct seq_file *s, void *v)
 		if (NULL == scsidp) {
 			seq_printf(s, "device %d detached ??\n", 
 				   (int)it->index);
-			return 0;
+			goto out;
 		}
 
 		if (sg_get_nth_sfp(sdp, 0)) {
@@ -2602,6 +2588,8 @@ static int sg_proc_seq_show_debug(struct seq_file *s, void *v)
 		}
 		sg_proc_debug_helper(s, sdp);
 	}
+out:
+	sg_put_dev(sdp);
 	return 0;
 }
 
-- 
1.6.0.6

