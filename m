From: Camelia Groza <camelia.groza@gmail.com>
Subject: [PATCH] fnic: use simple_open instead of fnic_trace_ctrl_open
Date: Fri, 12 Jul 2013 09:50:08 +0300
Message-ID: <1373611808-4959-1-git-send-email-camelia.groza@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: hiralpat@cisco.com
Cc: sramars@cisco.com, buchino@cisco.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Camelia Groza <camelia.groza@gmail.com>
List-Id: linux-scsi@vger.kernel.org

This removes the open coded fnic_trace_ctrl_open() function
and replaces file operations references to the function
with simple_open() instead.

Found using coccinelle.

Signed-off-by: Camelia Groza <camelia.groza@gmail.com>
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
