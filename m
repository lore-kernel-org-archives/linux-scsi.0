From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/3] tcm/fileio: Remove struct se_subsystem_api->do_sync_cache() usage
Date: Fri, 27 Aug 2010 23:53:51 -0700
Message-ID: <1282978431-16926-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:32700 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751925Ab0H1Gxx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Aug 2010 02:53:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <teheo@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts the new TCM/FILEIO SYNCHRONIZE_CACHE emulation to
remove struct se_subsystem_api->do_sync_cache() usage following hch's
recommendation.  It makes __fd_do_sync_cache_range() do an explict check
for a received LBA=0 + DataLength=0, and call fd_do_sync_cache():vfs_fsync()
if necessary to flush the entire device.

This patch also fixes a small bug with the initial commit 0a61c6550da5, where
transport_complete_sync_cache() was being called an unnecessary second time at
the end of __fd_do_sync_cache_range() for the IMMED=0 bit case.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_file.c |   31 ++++++++++++++++---------------
 1 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index a7a65f7..b8e242b 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -612,28 +612,19 @@ static int fd_do_writev(struct fd_request *req, struct se_task *task)
  * Called from transport_generic_synchronize_cache() to flush the entire
  * struct file (and possibly backing struct block_device) using vfs_fsync().
  */
-void fd_do_sync_cache(struct se_cmd *cmd)
+static int fd_do_sync_cache(struct se_cmd *cmd, int immed)
 {
 	struct fd_dev *fd_dev = (struct fd_dev *)cmd->se_dev->dev_ptr;
 	struct file *fd = fd_dev->fd_file;
-	int ret, immed = (T_TASK(cmd)->t_task_cdb[1] & 0x2);
-	/*
-	 * If the Immediate bit is set, queue up the GOOD response
-	 * for this SYNCHRONIZE_CACHE op
-	 */
-	if (immed)
-		transport_complete_sync_cache(cmd, 1);
+	int ret;
 
 	ret = vfs_fsync(fd, 0);
 	if (ret != 0) {
 		printk(KERN_ERR "FILEIO: vfs_fsync(fd, 0) returned: %d\n", ret);
-		if (!(immed))
-			transport_complete_sync_cache(cmd, 0);
-		return;
+		return ret;
 	}
 	DEBUG_FD_CACHE("FILEIO: vfs_fsync(fd, 0) called, immed: %d\n", immed);
-
-	transport_complete_sync_cache(cmd, 1);
+	return ret;
 }
 
 /*
@@ -657,6 +648,15 @@ int __fd_do_sync_cache_range(
 	if (immed)
 		transport_complete_sync_cache(cmd, 1);
 	/*
+	 * Determine if we will be flushing the entire device.
+	 */
+	if ((T_TASK(cmd)->t_task_lba == 0) && (cmd->data_length == 0)) {
+		ret = fd_do_sync_cache(cmd, immed);		
+		if (!(immed))
+			transport_complete_sync_cache(cmd, (ret == 0) ? 1 : 0);
+		return 0;
+	}
+	/*
 	 * If a explict number of bytes fo flush has been provied by
 	 * the initiator, use this value with vfs_sync_range().  Otherwise
 	 * bytes = LLONG_MAX (matching fs/sync.c:vfs_fsync().
@@ -673,7 +673,9 @@ int __fd_do_sync_cache_range(
 		" %llu, bytes: %llu, immed: %d\n", lba, (unsigned long long)start,
 		(unsigned long long)bytes, immed);
 
-	transport_complete_sync_cache(cmd, 1);
+	if (!(immed))
+		transport_complete_sync_cache(cmd, 1);
+
 	return 0;
 }
 
@@ -1129,7 +1131,6 @@ static struct se_subsystem_api fileio_template = {
 	.activate_device	= fd_activate_device,
 	.deactivate_device	= fd_deactivate_device,
 	.free_device		= fd_free_device,
-	.do_sync_cache		= fd_do_sync_cache,
 	.do_sync_cache_range	= fd_do_sync_cache_range,
 	.dpo_emulated		= fd_emulated_dpo,
 	.fua_write_emulated	= fd_emulated_fua_write,
-- 
1.5.6.5

