From: Dragos Foianu <dragos.foianu@gmail.com>
Subject: [PATCH] drivers/scsi/fnic: updated fileoperations structure to use simple_open
Date: Tue, 16 Jul 2013 07:37:19 +0100
Message-ID: <1373956639-6187-1-git-send-email-dragos.foianu@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:59912 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab3GPEh1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jul 2013 00:37:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hiralpat@cisco.com
Cc: sramars@cisco.com, buchino@cisco.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Dragos Foianu <dragos.foianu@gmail.com>

The function has the same implementation as simple_open. I removed it and replaced the reference in the fileoperations struct with simple_open.

Found using Coccinelle.

Signed-off-by: Dragos Foianu <dragos.foianu@gmail.com>
---
 drivers/scsi/fnic/fnic_debugfs.c |   19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_debugfs.c b/drivers/scsi/fnic/fnic_debugfs.c
index cbcb012..ddc7e94 100644
--- a/drivers/scsi/fnic/fnic_debugfs.c
+++ b/drivers/scsi/fnic/fnic_debugfs.c
@@ -25,23 +25,6 @@ static struct dentry *fnic_trace_debugfs_file;
 static struct dentry *fnic_trace_enable;
 
 /*
- * fnic_trace_ctrl_open - Open the trace_enable file
- * @inode: The inode pointer.
- * @file: The file pointer to attach the trace enable/disable flag.
- *
- * Description:
- * This routine opens a debugsfs file trace_enable.
- *
- * Returns:
- * This function returns zero if successful.
- */
-static int fnic_trace_ctrl_open(struct inode *inode, struct file *filp)
-{
-	filp->private_data = inode->i_private;
-	return 0;
-}
-
-/*
  * fnic_trace_ctrl_read - Read a trace_enable debugfs file
  * @filp: The file pointer to read from.
  * @ubuf: The buffer to copy the data to.
@@ -222,7 +205,7 @@ static int fnic_trace_debugfs_release(struct inode *inode,
 
 static const struct file_operations fnic_trace_ctrl_fops = {
 	.owner = THIS_MODULE,
-	.open = fnic_trace_ctrl_open,
+	.open = simple_open,
 	.read = fnic_trace_ctrl_read,
 	.write = fnic_trace_ctrl_write,
 };
-- 
1.7.10.4

