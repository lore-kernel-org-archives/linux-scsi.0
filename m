From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target/file: Drop O_SYNC in favor of implict
 vfs_fsync_range for writes
Date: Thu, 31 May 2012 01:25:02 -0700
Message-ID: <1338452702.30470.339.camel@haakon2.linux-iscsi.org>
References: <1338422263-19874-1-git-send-email-nab@linux-iscsi.org>
	 <20120531054247.GB29553@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:34680 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757987Ab2EaIZa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 May 2012 04:25:30 -0400
In-Reply-To: <20120531054247.GB29553@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>

On Thu, 2012-05-31 at 07:42 +0200, Christoph Hellwig wrote:
> On Wed, May 30, 2012 at 11:57:43PM +0000, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch converts fd_execute_cmd() code to drop O_SYNC usage
> > (the original default) in favor of always preforming an implict
> > SCSI forced unit access (FUA) operation using vfs_fsync_range()
> > based on LBA + SectorCount after each completed FILEIO backend write.
> > 
> > This conversion was inspired by Linus's thoughts on O_SYNC usage in
> > the thread: http://www.spinics.net/lists/linux-fsdevel/msg55681.html
> > 
> >   "O_SYNC is the absolutely anti-thesis of that kind of "multiple levels
> >    of overlapping IO". Because it requires that the IO is _done_ by the
> >    time you start more, which is against the whole point."
> > 
> > This patch also drops the now unnecessary fd_buffered_io= token usage
> > at createvirtdev time.  Tested with lio-core code using fio writeverify
> > to local tcm_loop + FILEIO <-> scsi_debug backed LUNs.
> 
> If you look at the implementation O_SYNC really just means an implicit
> vfs_fsync_range after each write, thus I can't see how this patch makes any
> difference.
> 

But O_SYNC still means more than just vfs_fsync_range() for writes in
other cases, yes..?  ;)

> 
> 
> For target use with WCE=0 semantics you could at least switch to O_DSYNC, though.

Since we currently need to know the flags for flip_open() at
fd_create_virtdevice() setup time with WCE=0 as the default for all
backends, the emulate_write_cache device attribute function to signal
this to SCSI Initiator LUNs is (already) acting independently of O_SYNC
flag usage.

Based on your comments off-list, here is a v2 to always use O_DSYNC by
default, and continue to allow WCE bit to function independently of
flip_open() flags.. 

WDYT..?

--nab

[PATCH-v2] target/file: Use O_DSYNC by default for FILEIO backends

Convert to use O_DSYNC for all cases at FILEIO backend creation time to
avoid the extra syncing of pure timestamp updates with legacy O_SYNC during
default operation as recommended by hch.  Continue to do this independently of
Write Cache Enable (WCE) bit, as WCE=0 is currently the default for all backend
devices and enabled by user on per device basis via attrib/emulate_write_cache.

This patch drops the now unnecessary fd_buffered_io= token usage that was
originally signaling when to explicitly disable O_SYNC at backend creation
time for buffered I/O operation.  This can end up being dangerous for a number
of reasons during physical node failure, so go ahead and drop this option
for now when O_DSYNC is used as the default.

Also allow explict FUA WRITEs -> vfs_fsync_range() call to function in
fd_execute_cmd() independently of WCE bit setting.

Reported-by: Christoph Hellwig <hch@lst.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_file.c |   70 +++++++++----------------------------
 drivers/target/target_core_file.h |    1 -
 2 files changed, 17 insertions(+), 54 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 686dba1..9f99d04 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -133,16 +133,11 @@ static struct se_device *fd_create_virtdevice(
 		ret = PTR_ERR(dev_p);
 		goto fail;
 	}
-
-	/* O_DIRECT too? */
-	flags = O_RDWR | O_CREAT | O_LARGEFILE;
-
 	/*
-	 * If fd_buffered_io=1 has not been set explicitly (the default),
-	 * use O_SYNC to force FILEIO writes to disk.
+	 * Use O_DSYNC by default instead of O_SYNC to forgo syncing
+	 * of pure timestamp updates.
 	 */
-	if (!(fd_dev->fbd_flags & FDBD_USE_BUFFERED_IO))
-		flags |= O_SYNC;
+	flags = O_RDWR | O_CREAT | O_LARGEFILE | O_DSYNC;
 
 	file = filp_open(dev_p, flags, 0600);
 	if (IS_ERR(file)) {
@@ -380,23 +375,6 @@ static void fd_emulate_sync_cache(struct se_cmd *cmd)
 	}
 }
 
-static void fd_emulate_write_fua(struct se_cmd *cmd)
-{
-	struct se_device *dev = cmd->se_dev;
-	struct fd_dev *fd_dev = dev->dev_ptr;
-	loff_t start = cmd->t_task_lba *
-		dev->se_sub_dev->se_dev_attrib.block_size;
-	loff_t end = start + cmd->data_length;
-	int ret;
-
-	pr_debug("FILEIO: FUA WRITE LBA: %llu, bytes: %u\n",
-		cmd->t_task_lba, cmd->data_length);
-
-	ret = vfs_fsync_range(fd_dev->fd_file, start, end, 1);
-	if (ret != 0)
-		pr_err("FILEIO: vfs_fsync_range() failed: %d\n", ret);
-}
-
 static int fd_execute_cmd(struct se_cmd *cmd, struct scatterlist *sgl,
 		u32 sgl_nents, enum dma_data_direction data_direction)
 {
@@ -411,19 +389,21 @@ static int fd_execute_cmd(struct se_cmd *cmd, struct scatterlist *sgl,
 		ret = fd_do_readv(cmd, sgl, sgl_nents);
 	} else {
 		ret = fd_do_writev(cmd, sgl, sgl_nents);
-
+		/*
+		 * Perform implict vfs_fsync_range() for fd_do_writev() ops
+		 * for SCSI WRITEs with Forced Unit Access (FUA) set.
+		 * Allow this to happen independent of WCE=0 setting.
+		 */
 		if (ret > 0 &&
-		    dev->se_sub_dev->se_dev_attrib.emulate_write_cache > 0 &&
 		    dev->se_sub_dev->se_dev_attrib.emulate_fua_write > 0 &&
 		    (cmd->se_cmd_flags & SCF_FUA)) {
-			/*
-			 * We might need to be a bit smarter here
-			 * and return some sense data to let the initiator
-			 * know the FUA WRITE cache sync failed..?
-			 */
-			fd_emulate_write_fua(cmd);
-		}
+			struct fd_dev *fd_dev = dev->dev_ptr;
+			loff_t start = cmd->t_task_lba *
+				dev->se_sub_dev->se_dev_attrib.block_size;
+			loff_t end = start + cmd->data_length;
 
+			vfs_fsync_range(fd_dev->fd_file, start, end, 1);
+		}
 	}
 
 	if (ret < 0) {
@@ -442,7 +422,6 @@ enum {
 static match_table_t tokens = {
 	{Opt_fd_dev_name, "fd_dev_name=%s"},
 	{Opt_fd_dev_size, "fd_dev_size=%s"},
-	{Opt_fd_buffered_io, "fd_buffered_io=%d"},
 	{Opt_err, NULL}
 };
 
@@ -454,7 +433,7 @@ static ssize_t fd_set_configfs_dev_params(
 	struct fd_dev *fd_dev = se_dev->se_dev_su_ptr;
 	char *orig, *ptr, *arg_p, *opts;
 	substring_t args[MAX_OPT_ARGS];
-	int ret = 0, arg, token;
+	int ret = 0, token;
 
 	opts = kstrdup(page, GFP_KERNEL);
 	if (!opts)
@@ -498,19 +477,6 @@ static ssize_t fd_set_configfs_dev_params(
 					" bytes\n", fd_dev->fd_dev_size);
 			fd_dev->fbd_flags |= FBDF_HAS_SIZE;
 			break;
-		case Opt_fd_buffered_io:
-			match_int(args, &arg);
-			if (arg != 1) {
-				pr_err("bogus fd_buffered_io=%d value\n", arg);
-				ret = -EINVAL;
-				goto out;
-			}
-
-			pr_debug("FILEIO: Using buffered I/O"
-				" operations for struct fd_dev\n");
-
-			fd_dev->fbd_flags |= FDBD_USE_BUFFERED_IO;
-			break;
 		default:
 			break;
 		}
@@ -542,10 +508,8 @@ static ssize_t fd_show_configfs_dev_params(
 	ssize_t bl = 0;
 
 	bl = sprintf(b + bl, "TCM FILEIO ID: %u", fd_dev->fd_dev_id);
-	bl += sprintf(b + bl, "        File: %s  Size: %llu  Mode: %s\n",
-		fd_dev->fd_dev_name, fd_dev->fd_dev_size,
-		(fd_dev->fbd_flags & FDBD_USE_BUFFERED_IO) ?
-		"Buffered" : "Synchronous");
+	bl += sprintf(b + bl, "        File: %s  Size: %llu  Mode: O_DSYNC\n",
+		fd_dev->fd_dev_name, fd_dev->fd_dev_size);
 	return bl;
 }
 
diff --git a/drivers/target/target_core_file.h b/drivers/target/target_core_file.h
index fbd59ef..70ce7fd 100644
--- a/drivers/target/target_core_file.h
+++ b/drivers/target/target_core_file.h
@@ -14,7 +14,6 @@
 
 #define FBDF_HAS_PATH		0x01
 #define FBDF_HAS_SIZE		0x02
-#define FDBD_USE_BUFFERED_IO	0x04
 
 struct fd_dev {
 	u32		fbd_flags;
-- 
1.7.2.5





