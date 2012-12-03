From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next v2] [SCSI] csiostor: convert to use simple_open()
Date: Mon, 3 Dec 2012 01:22:39 -0500
Message-ID: <CAPgLHd9L_m1qPO3cjnwOJAWmtWjERd5aGK-qPs-yRd9z3fXXCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:62005 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab2LCGWk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Dec 2012 01:22:40 -0500
Received: by mail-qc0-f174.google.com with SMTP id o22so1330557qcr.19
        for <linux-scsi@vger.kernel.org>; Sun, 02 Dec 2012 22:22:39 -0800 (PST)
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
 drivers/scsi/csiostor/csio_init.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/csio_init.c
index fdd408f..c9336b3 100644
--- a/drivers/scsi/csiostor/csio_init.c
+++ b/drivers/scsi/csiostor/csio_init.c
@@ -60,13 +60,6 @@ static struct scsi_transport_template *csio_fcoe_transport_vport;
 /*
  * debugfs support
  */
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
@@ -110,7 +103,7 @@ csio_mem_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 
 static const struct file_operations csio_mem_debugfs_fops = {
 	.owner   = THIS_MODULE,
-	.open    = csio_mem_open,
+	.open    = simple_open,
 	.read    = csio_mem_read,
 	.llseek  = default_llseek,
 };


