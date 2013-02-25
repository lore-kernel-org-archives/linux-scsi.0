From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] [SCSI] fnic: convert to use simple_open()
Date: Mon, 25 Feb 2013 21:21:23 +0800
Message-ID: <CAPgLHd9QLWGbHFEz7f7i2Fe3225DB_gqunt-tGU3MwiEUHq87A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:55614 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759189Ab3BYNVZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Feb 2013 08:21:25 -0500
Received: by mail-bk0-f51.google.com with SMTP id ik5so1286655bkc.38
        for <linux-scsi@vger.kernel.org>; Mon, 25 Feb 2013 05:21:23 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hiralpat@cisco.com, sramars@cisco.com, buchino@cisco.com, JBottomley@parallels.com
Cc: yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

This removes an open coded simple_open() function and
replaces file operations references to the function
with simple_open() instead.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/scsi/fnic/fnic_debugfs.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_debugfs.c b/drivers/scsi/fnic/fnic_debugfs.c
index bc06f9b..26db5b5 100644
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
@@ -232,7 +215,7 @@ static int fnic_trace_debugfs_release(struct inode *inode,
 
 static const struct file_operations fnic_trace_ctrl_fops = {
 	.owner = THIS_MODULE,
-	.open = fnic_trace_ctrl_open,
+	.open = simple_open,
 	.read = fnic_trace_ctrl_read,
 	.write = fnic_trace_ctrl_write,
 };

