From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 4/4] tcm/fileio: Add WriteCache and Forced Unit Access WRITE emulation
Date: Thu, 26 Aug 2010 21:33:19 -0700
Message-ID: <1282883599-10893-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp107.sbc.mail.gq1.yahoo.com ([67.195.14.110]:24832 "HELO
	smtp107.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752810Ab0H0EdX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Aug 2010 00:33:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <teheo@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds support for WriteCache emulation using a struct file backend.
It also adds support for Forced Unit Access WRITE emulation, and using the TCM
callers, can be configured independently via ConfigFS using generic device attributes
added in commit ab60b29471.

For the WriteCache bit, the fd_do_sync_cache() and fd_do_sync_cache_range()
callers for SYNCHRONIZE_CACHE* ops have been added, which are called by
transport_generic_synchronize_cache() using struct se_subsystem_api function
pointers.  For the FUA WRITE struct se_task context case, __fd_do_sync_cache_range()
is called from fd_do_task(), which note currently does *not* return a failed SAM
status, even if the write flush itself using fs/sync.c callers fail.

This patch also supports the SYNCHRONIZE_CACHE* Immed=1 bit to generate CDB status
for the struct se_cmd + struct se_task context with transport_complete_sync_cache()
before doing the actual vfs_fsync() or vfs_fsync_range().

Note that this patch currently does *not* remove the O_SYNC flag from
fd_create_virtdevice(), so Linux buffer cache is still in use unless you manually
disable O_SYNC yourself, which I have been doing to test this series.  Note this
will only be a temporarly measure until O_SYNC can be enabled/disabled dynamically
using:

	/sys/kernel/config/target/core/fileio_$ID/$DEV/attrib/emulate_write_cache

in order to call the equivilent of kernel level fcntl() to enable/disable O_SYNC
the TCM struct file <-> struct se_device mapping, which may contain active fabric
module struct se_task I/O.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_file.c |  159 ++++++++++++++++++++++++++++++++++++-
 1 files changed, 158 insertions(+), 1 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 0ce391b..a7a65f7 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -42,6 +42,18 @@
 
 #include "target_core_file.h"
 
+#if 1
+#define DEBUG_FD_CACHE(x...) printk(x)
+#else
+#define DEBUG_FD_CACHE(x...)
+#endif
+
+#if 1
+#define DEBUG_FD_FUA(x...) printk(x)
+#else
+#define DEBUG_FD_FUA(x...)
+#endif
+
 static struct se_subsystem_api fileio_template;
 
 static void __fd_get_dev_info(struct fd_dev *, char *, int *);
@@ -596,10 +608,130 @@ static int fd_do_writev(struct fd_request *req, struct se_task *task)
 	return 1;
 }
 
+/*
+ * Called from transport_generic_synchronize_cache() to flush the entire
+ * struct file (and possibly backing struct block_device) using vfs_fsync().
+ */
+void fd_do_sync_cache(struct se_cmd *cmd)
+{
+	struct fd_dev *fd_dev = (struct fd_dev *)cmd->se_dev->dev_ptr;
+	struct file *fd = fd_dev->fd_file;
+	int ret, immed = (T_TASK(cmd)->t_task_cdb[1] & 0x2);
+	/*
+	 * If the Immediate bit is set, queue up the GOOD response
+	 * for this SYNCHRONIZE_CACHE op
+	 */
+	if (immed)
+		transport_complete_sync_cache(cmd, 1);
+
+	ret = vfs_fsync(fd, 0);
+	if (ret != 0) {
+		printk(KERN_ERR "FILEIO: vfs_fsync(fd, 0) returned: %d\n", ret);
+		if (!(immed))
+			transport_complete_sync_cache(cmd, 0);
+		return;
+	}
+	DEBUG_FD_CACHE("FILEIO: vfs_fsync(fd, 0) called, immed: %d\n", immed);
+
+	transport_complete_sync_cache(cmd, 1);
+}
+
+/*
+ * Called from transport_generic_synchronize_cache() to flush LBA range
+ */
+int __fd_do_sync_cache_range(
+	struct se_cmd *cmd,
+	unsigned long long lba,
+	u32 size_in_bytes)
+{
+	struct se_device *dev = cmd->se_dev;
+	struct fd_dev *fd_dev = (struct fd_dev *)dev->dev_ptr;
+	struct file *fd = fd_dev->fd_file;
+	loff_t start = (lba * DEV_ATTRIB(dev)->block_size);
+	loff_t bytes;
+	int ret, immed = (T_TASK(cmd)->t_task_cdb[1] & 0x2);
+	/*
+	 * If the Immediate bit is set, queue up the GOOD response
+	 * for this SYNCHRONIZE_CACHE op
+	 */
+	if (immed)
+		transport_complete_sync_cache(cmd, 1);
+	/*
+	 * If a explict number of bytes fo flush has been provied by
+	 * the initiator, use this value with vfs_sync_range().  Otherwise
+	 * bytes = LLONG_MAX (matching fs/sync.c:vfs_fsync().
+	 */
+	bytes = (size_in_bytes != 0) ? size_in_bytes : LLONG_MAX;
+	ret = vfs_fsync_range(fd, start, bytes, 0);
+	if (ret != 0) {
+		printk(KERN_ERR "FILEIO: vfs_fsync_range() failed: %d\n", ret);
+		if (!(immed))
+			transport_complete_sync_cache(cmd, 0);
+		return -1;
+	}
+	DEBUG_FD_CACHE("FILEIO: vfs_fsync_range(): LBA: %llu Starting offset:"
+		" %llu, bytes: %llu, immed: %d\n", lba, (unsigned long long)start,
+		(unsigned long long)bytes, immed);
+
+	transport_complete_sync_cache(cmd, 1);
+	return 0;
+}
+
+void fd_do_sync_cache_range(
+	struct se_cmd *cmd,
+	unsigned long long lba,
+	u32 size_in_bytes)
+{
+	__fd_do_sync_cache_range(cmd, lba, size_in_bytes);	
+}
+
+/*
+ * Tell TCM Core that we are capable of WriteCache emulation for
+ * an underlying struct se_device.
+ */
+int fd_emulated_write_cache(struct se_device *dev)
+{
+	return 1;
+}
+
+int fd_emulated_dpo(struct se_device *dev)
+{
+	return 0;
+}
+/*
+ * Tell TCM Core that we will be emulating Forced Unit Access (FUA) for WRITEs
+ * for TYPE_DISK.
+ */
+int fd_emulated_fua_write(struct se_device *dev)
+{
+	return 1;
+}
+
+int fd_emulated_fua_read(struct se_device *dev)
+{
+	return 0;
+}
+
+/*
+ * WRITE Force Unit Access (FUA) emulation on a per struct se_task
+ * LBA range basis..
+ */
+static inline int fd_emulate_write_fua(
+	struct se_cmd *cmd,
+	struct se_task *task)
+{
+	DEBUG_FD_CACHE("FILEIO: FUA WRITE LBA: %llu, bytes: %u\n",
+			task->task_lba, task->task_size);
+
+	return __fd_do_sync_cache_range(cmd, task->task_lba, task->task_size);
+}
+
 static int fd_do_task(struct se_task *task)
 {
-	int ret = 0;
+	struct se_cmd *cmd = task->task_se_cmd;
+	struct se_device *dev = cmd->se_dev;
 	struct fd_request *req = (struct fd_request *) task->transport_req;
+	int ret = 0;
 
 	if (!(TASK_CMD(task)->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB))
 		return fd_emulate_scsi_cdb(task);
@@ -619,6 +751,25 @@ static int fd_do_task(struct se_task *task)
 		return ret;
 
 	if (ret) {
+		/*
+		 * Check for Forced Unit Access WRITE emulation
+		 */
+		if ((DEV_ATTRIB(dev)->emulate_write_cache > 0) &&
+		    (DEV_ATTRIB(dev)->emulate_fua_write > 0) &&
+		    (req->fd_data_direction == FD_DATA_WRITE) &&
+		    (T_TASK(cmd)->t_task_fua)) {
+			/*
+			 * We might need to be a bit smarter here
+			 * and return some sense data to let the initiator
+			 * know the FUA WRITE cache sync failed..?
+			 */
+			ret = fd_emulate_write_fua(cmd, task);
+			if (ret < 0) {
+				printk(KERN_ERR "FILEIO: fd_emulate"
+					"_write_fua() failed\n");
+			}
+		}
+
 		task->task_scsi_status = GOOD;
 		transport_complete_task(task, 1);
 	}
@@ -978,6 +1129,12 @@ static struct se_subsystem_api fileio_template = {
 	.activate_device	= fd_activate_device,
 	.deactivate_device	= fd_deactivate_device,
 	.free_device		= fd_free_device,
+	.do_sync_cache		= fd_do_sync_cache,
+	.do_sync_cache_range	= fd_do_sync_cache_range,
+	.dpo_emulated		= fd_emulated_dpo,
+	.fua_write_emulated	= fd_emulated_fua_write,
+	.fua_read_emulated	= fd_emulated_fua_read,
+	.write_cache_emulated	= fd_emulated_write_cache,
 	.transport_complete	= fd_transport_complete,
 	.allocate_request	= fd_allocate_request,
 	.do_task		= fd_do_task,
-- 
1.5.6.5

