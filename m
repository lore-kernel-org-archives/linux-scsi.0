From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] [SCSI] csiostor: convert to use simple_open()
Date: Sun, 2 Dec 2012 06:51:34 -0500
Message-ID: <CAPgLHd93AaLhAxVktx3-PQ8VojVN5AnGfZHFic-hp5O4ceBrxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:55571 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab2LBLvf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Dec 2012 06:51:35 -0500
Received: by mail-qc0-f174.google.com with SMTP id o22so1035853qcr.19
        for <linux-scsi@vger.kernel.org>; Sun, 02 Dec 2012 03:51:34 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, naresh@chelsio.com
Cc: yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

This removes an open coded simple_open() function and
replaces file operations references to the function
with simple_open() instead.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/scsi/csiostor/csio_init.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/csio_init.c
index fdd408f..17cf5e1 100644
--- a/drivers/scsi/csiostor/csio_init.c
+++ b/drivers/scsi/csiostor/csio_init.c
@@ -57,16 +57,6 @@ static struct dentry *csio_debugfs_root;
 static struct scsi_transport_template *csio_fcoe_transport;
 static struct scsi_transport_template *csio_fcoe_transport_vport;
 
-/*
- * debugfs support
- */
-static int
-csio_mem_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t
 csio_mem_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 {
@@ -110,7 +100,7 @@ csio_mem_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 
 static const struct file_operations csio_mem_debugfs_fops = {
 	.owner   = THIS_MODULE,
-	.open    = csio_mem_open,
+	.open = simple_open,
 	.read    = csio_mem_read,
 	.llseek  = default_llseek,
 };


