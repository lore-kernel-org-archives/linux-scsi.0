From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] target: clean up cache flush / FUA handling in the file
 backend
Date: Wed, 10 Nov 2010 16:02:42 -0500
Message-ID: <20101110210242.GB24988@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38166 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab0KJVCm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Nov 2010 16:02:42 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org

There is no need to deal with the immed bit or SYNCHRONIZE CACHE
completions when making FUA writes stable, so just call vfs_fsync_range
directly.  Clean up the SYNCHRONIZE CACHE handling by always calling
vfs_fsync_range directly and dealing with the flush whole cache case
directly.  Fix up the argument to vfs_fsync_range to be correct - it
takes a [start,end] tuple, not [start,len].  Use the datasync = 1
flag to vfs_fsync_range, we don't care if the timestamps make it to
disk.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: lio-core-2.6/drivers/target/target_core_file.c
===================================================================
--- lio-core-2.6.orig/drivers/target/target_core_file.c	2010-11-09 11:49:23.484863013 +0100
+++ lio-core-2.6/drivers/target/target_core_file.c	2010-11-09 12:10:21.074863013 +0100
@@ -463,86 +463,42 @@ static int fd_do_writev(struct fd_reques
 	return 1;
 }
 
-/*
- * Called from transport_generic_synchronize_cache() to flush the entire
- * struct file (and possibly backing struct block_device) using vfs_fsync().
- */
-static int fd_do_sync_cache(struct se_cmd *cmd, int immed)
-{
-	struct fd_dev *fd_dev = cmd->se_dev->dev_ptr;
-	struct file *fd = fd_dev->fd_file;
-	int ret;
-
-	ret = vfs_fsync(fd, 0);
-	if (ret != 0) {
-		printk(KERN_ERR "FILEIO: vfs_fsync(fd, 0) returned: %d\n", ret);
-		return ret;
-	}
-	DEBUG_FD_CACHE("FILEIO: vfs_fsync(fd, 0) called, immed: %d\n", immed);
-	return ret;
-}
-
-/*
- * Called from transport_generic_synchronize_cache() to flush LBA range
- */
-int __fd_do_sync_cache_range(
-	struct se_cmd *cmd,
-	unsigned long long lba,
-	u32 size_in_bytes)
+static void fd_emulate_sync_cache(struct se_task *task)
 {
+	struct se_cmd *cmd = TASK_CMD(task);
 	struct se_device *dev = cmd->se_dev;
 	struct fd_dev *fd_dev = dev->dev_ptr;
-	struct file *fd = fd_dev->fd_file;
-	loff_t start = (lba * DEV_ATTRIB(dev)->block_size);
-	loff_t bytes;
-	int ret, immed = (T_TASK(cmd)->t_task_cdb[1] & 0x2);
+	int immed = (cmd->t_task->t_task_cdb[1] & 0x2);
+	loff_t start, end;
+	int ret;
+
 	/*
 	 * If the Immediate bit is set, queue up the GOOD response
 	 * for this SYNCHRONIZE_CACHE op
 	 */
 	if (immed)
 		transport_complete_sync_cache(cmd, 1);
+
 	/*
 	 * Determine if we will be flushing the entire device.
 	 */
-	if ((T_TASK(cmd)->t_task_lba == 0) && (cmd->data_length == 0)) {
-		ret = fd_do_sync_cache(cmd, immed);		
-		if (!(immed))
-			transport_complete_sync_cache(cmd, (ret == 0) ? 1 : 0);
-		return 0;
-	}
-	/*
-	 * If a explict number of bytes fo flush has been provied by
-	 * the initiator, use this value with vfs_sync_range().  Otherwise
-	 * bytes = LLONG_MAX (matching fs/sync.c:vfs_fsync().
-	 */
-	bytes = (size_in_bytes != 0) ? size_in_bytes : LLONG_MAX;
-	ret = vfs_fsync_range(fd, start, bytes, 0);
-	if (ret != 0) {
-		printk(KERN_ERR "FILEIO: vfs_fsync_range() failed: %d\n", ret);
-		if (!(immed))
-			transport_complete_sync_cache(cmd, 0);
-		return -1;
+	if (cmd->t_task->t_task_lba == 0 && cmd->data_length == 0) {
+		start = 0;
+		end = LLONG_MAX;
+	} else {
+		start = cmd->t_task->t_task_lba * DEV_ATTRIB(dev)->block_size;
+		if (cmd->data_length)
+			end = start + cmd->data_length;
+		else
+			end = LLONG_MAX;
 	}
-	DEBUG_FD_CACHE("FILEIO: vfs_fsync_range(): LBA: %llu Starting offset:"
-		" %llu, bytes: %llu, immed: %d\n", lba, (unsigned long long)start,
-		(unsigned long long)bytes, immed);
 
-	if (!(immed))
-		transport_complete_sync_cache(cmd, 1);
-
-	return 0;
-}
-
-/*
- * Called by target_core_transport():transport_emulate_control_cdb()
- * to emulate SYCHRONIZE_CACHE_*
- */
-void fd_emulate_sync_cache(struct se_task *task)
-{
-	struct se_cmd *cmd = TASK_CMD(task);
+	ret = vfs_fsync_range(fd_dev->fd_file, start, end, 1);
+	if (ret != 0)
+		printk(KERN_ERR "FILEIO: vfs_fsync_range() failed: %d\n", ret);
 
-	__fd_do_sync_cache_range(cmd, T_TASK(cmd)->t_task_lba, cmd->data_length);
+	if (!immed)
+		transport_complete_sync_cache(cmd, ret == 0);
 }
 
 /*
@@ -576,14 +532,20 @@ int fd_emulated_fua_read(struct se_devic
  * WRITE Force Unit Access (FUA) emulation on a per struct se_task
  * LBA range basis..
  */
-static inline int fd_emulate_write_fua(
-	struct se_cmd *cmd,
-	struct se_task *task)
+static void fd_emulate_write_fua(struct se_cmd *cmd, struct se_task *task)
 {
+	struct se_device *dev = cmd->se_dev;
+	struct fd_dev *fd_dev = dev->dev_ptr;
+	loff_t start = task->task_lba * DEV_ATTRIB(dev)->block_size;
+	loff_t end = start + task->task_size;
+	int ret;
+
 	DEBUG_FD_CACHE("FILEIO: FUA WRITE LBA: %llu, bytes: %u\n",
 			task->task_lba, task->task_size);
 
-	return __fd_do_sync_cache_range(cmd, task->task_lba, task->task_size);
+	ret = vfs_fsync_range(fd_dev->fd_file, start, end, 1);
+	if (ret != 0)
+		printk(KERN_ERR "FILEIO: vfs_fsync_range() failed: %d\n", ret);
 }
 
 static int fd_do_task(struct se_task *task)
@@ -620,11 +582,7 @@ static int fd_do_task(struct se_task *ta
 			 * and return some sense data to let the initiator
 			 * know the FUA WRITE cache sync failed..?
 			 */
-			ret = fd_emulate_write_fua(cmd, task);
-			if (ret < 0) {
-				printk(KERN_ERR "FILEIO: fd_emulate"
-					"_write_fua() failed\n");
-			}
+			fd_emulate_write_fua(cmd, task);
 		}
 
 		task->task_scsi_status = GOOD;
