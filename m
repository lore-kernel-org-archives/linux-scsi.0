From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [Bug 7026] CD/DVD burning with USB writer doesn't work
Date: Mon, 8 Jan 2007 20:24:40 +0100
Message-ID: <20070108192440.GB11203@kernel.dk>
References: <1165432436.2810.66.camel@mulgrave.il.steeleye.com> <Pine.LNX.4.44L0.0701081112590.4249-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:28522 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030499AbXAHTYK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Jan 2007 14:24:10 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0701081112590.4249-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, Jan 08 2007, Alan Stern wrote:
> On Wed, 6 Dec 2006, James Bottomley wrote:
> 
> > On Wed, 2006-12-06 at 13:58 -0500, Alan Stern wrote:
> > > I'd love to do that -- but blkdev_ioctl() wants inode->i_bdev to be set, 
> > > and blkdev_locked_ioctl() uses it as the argument to bdev_get_queue().  So 
> > > it won't work with sg, which uses character device nodes.
> > 
> > Well, even sg has the queue ... and what we're looking for are the queue
> > parameters.  In block/ioctl.c the bdev is just used for getting the
> > queue parameters (mainly via bdev->bd_disk->queue), so I could see if
> > Jens might be amenable to refactoring the queue ioctls so we can get at
> > them simply with a struct request_queue parameter.
> > 
> > > How about adding BLKSECTGET to the list of commands accepted by 
> > > sg_ioctl()?
> > 
> > That's certainly a possible hack ... although I'd prefer to see the full
> > queue ioctls exposed.
> 
> James:
> 
> Back in December you wrote a patch to expose the queue ioctls, and sent it
> (off-list) to Jens Axboe and to me.  Jens spproved it, but then it
> disappeared and was never applied.  Unfortunately I have lost my copy of
> it.
> 
> If you still have the patch, could you please apply it?  If you don't, I 
> could try to re-create it.  Or maybe Jens still has it in his email 
> records.  Either way, please let me know.

This one?

diff --git a/block/ioctl.c b/block/ioctl.c
index 58aab63..8444d0c 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -135,6 +135,31 @@ static int put_u64(unsigned long arg, u6
 	return put_user(val, (u64 __user *)arg);
 }
 
+static int blk_queue_locked_ioctl(struct request_queue *queue,
+				  unsigned cmd, unsigned long arg)
+{
+	switch (cmd) {
+	case BLKSSZGET: /* get block device hardware sector size */
+		return put_int(arg, queue_hardsect_size(queue));
+	case BLKSECTGET:
+		return put_ushort(arg, queue->max_sectors);
+	}
+	return -ENOIOCTLCMD;
+}
+
+int blk_queue_ioctl(struct request_queue *queue, unsigned cmd,
+		    unsigned long arg)
+{
+	int ret;
+
+	lock_kernel();
+	ret = blk_queue_locked_ioctl(queue, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+EXPORT_SYMBOL(blk_queue_ioctl);
+
 static int blkdev_locked_ioctl(struct file *file, struct block_device *bdev,
 				unsigned cmd, unsigned long arg)
 {
@@ -154,10 +179,6 @@ static int blkdev_locked_ioctl(struct fi
 		return put_int(arg, bdev_read_only(bdev) != 0);
 	case BLKBSZGET: /* get the logical block size (cf. BLKSSZGET) */
 		return put_int(arg, block_size(bdev));
-	case BLKSSZGET: /* get block device hardware sector size */
-		return put_int(arg, bdev_hardsect_size(bdev));
-	case BLKSECTGET:
-		return put_ushort(arg, bdev_get_queue(bdev)->max_sectors);
 	case BLKRASET:
 	case BLKFRASET:
 		if(!capable(CAP_SYS_ADMIN))
@@ -278,6 +299,8 @@ int blkdev_ioctl(struct inode *inode, st
 
 	lock_kernel();
 	ret = blkdev_locked_ioctl(file, bdev, cmd, arg);
+	if (ret == -ENOIOCTLCMD)
+		ret = blk_queue_locked_ioctl(bdev_get_queue(bdev), cmd, arg);
 	unlock_kernel();
 	if (ret != -ENOIOCTLCMD)
 		return ret;
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 81e3bc7..d97244b 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -786,6 +786,11 @@ sg_ioctl(struct inode *inode, struct fil
 				   sdp->disk->disk_name, (int) cmd_in));
 	read_only = (O_RDWR != (filp->f_flags & O_ACCMODE));
 
+	/* block ioctls first */
+	result = blk_queue_ioctl(sdp->device->request_queue, cmd_in, arg);
+	if (result != -ENOIOCTLCMD)
+		return result;
+
 	switch (cmd_in) {
 	case SG_IO:
 		{
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e1c7286..550b04a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -754,6 +754,8 @@ extern void blk_queue_prep_rq(request_qu
 extern void blk_queue_merge_bvec(request_queue_t *, merge_bvec_fn *);
 extern void blk_queue_dma_alignment(request_queue_t *, int);
 extern void blk_queue_softirq_done(request_queue_t *, softirq_done_fn *);
+extern int blk_queue_ioctl(struct request_queue *queue, unsigned cmd,
+			   unsigned long arg);
 extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);
 extern int blk_queue_ordered(request_queue_t *, unsigned, prepare_flush_fn *);
 extern void blk_queue_issue_flush_fn(request_queue_t *, issue_flush_fn *);



-- 
Jens Axboe

