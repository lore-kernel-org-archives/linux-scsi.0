From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] target/file: Drop O_SYNC in favor of implict vfs_fsync_range for writes
Date: Wed, 30 May 2012 23:57:43 +0000
Message-ID: <1338422263-19874-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts fd_execute_cmd() code to drop O_SYNC usage
(the original default) in favor of always preforming an implict
SCSI forced unit access (FUA) operation using vfs_fsync_range()
based on LBA + SectorCount after each completed FILEIO backend write.

This conversion was inspired by Linus's thoughts on O_SYNC usage in
the thread: http://www.spinics.net/lists/linux-fsdevel/msg55681.html

  "O_SYNC is the absolutely anti-thesis of that kind of "multiple levels
   of overlapping IO". Because it requires that the IO is _done_ by the
   time you start more, which is against the whole point."

This patch also drops the now unnecessary fd_buffered_io= token usage
at createvirtdev time.  Tested with lio-core code using fio writeverify
to local tcm_loop + FILEIO <-> scsi_debug backed LUNs.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_file.c |   68 +++++++------------------------------
 drivers/target/target_core_file.h |    1 -
 2 files changed, 13 insertions(+), 56 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 686dba1..334b01c 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -137,13 +137,6 @@ static struct se_device *fd_create_virtdevice(
 	/* O_DIRECT too? */
 	flags = O_RDWR | O_CREAT | O_LARGEFILE;
 
-	/*
-	 * If fd_buffered_io=1 has not been set explicitly (the default),
-	 * use O_SYNC to force FILEIO writes to disk.
-	 */
-	if (!(fd_dev->fbd_flags & FDBD_USE_BUFFERED_IO))
-		flags |= O_SYNC;
-
 	file = filp_open(dev_p, flags, 0600);
 	if (IS_ERR(file)) {
 		pr_err("filp_open(%s) failed\n", dev_p);
@@ -380,23 +373,6 @@ static void fd_emulate_sync_cache(struct se_cmd *cmd)
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
@@ -410,20 +386,18 @@ static int fd_execute_cmd(struct se_cmd *cmd, struct scatterlist *sgl,
 	if (data_direction == DMA_FROM_DEVICE) {
 		ret = fd_do_readv(cmd, sgl, sgl_nents);
 	} else {
-		ret = fd_do_writev(cmd, sgl, sgl_nents);
-
-		if (ret > 0 &&
-		    dev->se_sub_dev->se_dev_attrib.emulate_write_cache > 0 &&
-		    dev->se_sub_dev->se_dev_attrib.emulate_fua_write > 0 &&
-		    (cmd->se_cmd_flags & SCF_FUA)) {
-			/*
-			 * We might need to be a bit smarter here
-			 * and return some sense data to let the initiator
-			 * know the FUA WRITE cache sync failed..?
-			 */
-			fd_emulate_write_fua(cmd);
-		}
+		struct fd_dev *fd_dev = dev->dev_ptr;
+		loff_t start = cmd->t_task_lba *
+			dev->se_sub_dev->se_dev_attrib.block_size;
+		loff_t end = start + cmd->data_length;
 
+		ret = fd_do_writev(cmd, sgl, sgl_nents);
+		/*
+		 * Perform implict vfs_fsync_range() for fd_do_writev() ops
+		 * instead of having to use O_SYNC for struct file.
+		 */
+		if (ret > 0)
+			vfs_fsync_range(fd_dev->fd_file, start, end, 1);
 	}
 
 	if (ret < 0) {
@@ -442,7 +416,6 @@ enum {
 static match_table_t tokens = {
 	{Opt_fd_dev_name, "fd_dev_name=%s"},
 	{Opt_fd_dev_size, "fd_dev_size=%s"},
-	{Opt_fd_buffered_io, "fd_buffered_io=%d"},
 	{Opt_err, NULL}
 };
 
@@ -498,19 +471,6 @@ static ssize_t fd_set_configfs_dev_params(
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
@@ -542,10 +502,8 @@ static ssize_t fd_show_configfs_dev_params(
 	ssize_t bl = 0;
 
 	bl = sprintf(b + bl, "TCM FILEIO ID: %u", fd_dev->fd_dev_id);
-	bl += sprintf(b + bl, "        File: %s  Size: %llu  Mode: %s\n",
-		fd_dev->fd_dev_name, fd_dev->fd_dev_size,
-		(fd_dev->fbd_flags & FDBD_USE_BUFFERED_IO) ?
-		"Buffered" : "Synchronous");
+	bl += sprintf(b + bl, "        File: %s  Size: %llu  Mode: fsync\n",
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

