From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 11/34] scsi proc_ops: convert drivers/scsi/fd_mcs.c
Date: Wed, 22 Feb 2012 22:46:02 +0300
Message-ID: <1329939985-26793-11-git-send-email-adobriyan@gmail.com>
References: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44011 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461Ab2BVTqw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2012 14:46:52 -0500
Received: by mail-bk0-f46.google.com with SMTP id jm19so433831bkc.19
        for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2012 11:46:52 -0800 (PST)
In-Reply-To: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/scsi/fd_mcs.c |   47 ++++++++++++++++++++---------------------------
 1 files changed, 20 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/fd_mcs.c b/drivers/scsi/fd_mcs.c
index a2c6135..ff6175d 100644
--- a/drivers/scsi/fd_mcs.c
+++ b/drivers/scsi/fd_mcs.c
@@ -85,6 +85,7 @@
 #include <linux/string.h>
 #include <linux/ioport.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/delay.h>
 #include <linux/mca.h>
 #include <linux/spinlock.h>
@@ -529,37 +530,29 @@ static const char *fd_mcs_info(struct Scsi_Host *shpnt)
 
 static int TOTAL_INTR = 0;
 
-/*
- * inout : decides on the direction of the dataflow and the meaning of the 
- *         variables
- * buffer: If inout==FALSE data is being written to it else read from it
- * *start: If inout==FALSE start of the valid data in the buffer
- * offset: If inout==FALSE offset from the beginning of the imaginary file 
- *         from which we start writing into the buffer
- * length: If inout==FALSE max number of bytes to be written into the buffer 
- *         else number of bytes in the buffer
- */
-static int fd_mcs_proc_info(struct Scsi_Host *shpnt, char *buffer, char **start, off_t offset, int length, int inout)
+static int fd_mcs_proc_show(struct seq_file *m, void *v)
 {
-	int len = 0;
+	struct Scsi_Host *shpnt = m->private;
 
-	if (inout)
-		return (-ENOSYS);
-
-	*start = buffer + offset;
-
-	len += sprintf(buffer + len, "Future Domain MCS-600/700 Driver %s\n", DRIVER_VERSION);
-	len += sprintf(buffer + len, "HOST #%d: %s\n", shpnt->host_no, adapter_name);
-	len += sprintf(buffer + len, "FIFO Size=0x%x, FIFO Count=%d\n", FIFO_Size, FIFO_COUNT);
-	len += sprintf(buffer + len, "DriverCalls=%d, Interrupts=%d, BytesRead=%d, BytesWrite=%d\n\n", TOTAL_INTR, INTR_Processed, Bytes_Read, Bytes_Written);
+	seq_printf(m, "Future Domain MCS-600/700 Driver %s\n", DRIVER_VERSION);
+	seq_printf(m, "HOST #%d: %s\n", shpnt->host_no, adapter_name);
+	seq_printf(m, "FIFO Size=0x%x, FIFO Count=%d\n", FIFO_Size, FIFO_COUNT);
+	seq_printf(m, "DriverCalls=%d, Interrupts=%d, BytesRead=%d, BytesWrite=%d\n\n", TOTAL_INTR, INTR_Processed, Bytes_Read, Bytes_Written);
+	return 0;
+}
 
-	if ((len -= offset) <= 0)
-		return 0;
-	if (len > length)
-		len = length;
-	return len;
+static int fd_mcs_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, fd_mcs_proc_show, PDE(inode)->data);
 }
 
+static const struct file_operations fd_mcs_proc_ops = {
+	.open		= fd_mcs_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static int fd_mcs_select(struct Scsi_Host *shpnt, int target)
 {
 	int status;
@@ -1336,7 +1329,7 @@ static int fd_mcs_biosparam(struct scsi_device * disk, struct block_device *bdev
 
 static struct scsi_host_template driver_template = {
 	.proc_name			= "fd_mcs",
-	.proc_info			= fd_mcs_proc_info,
+	.proc_ops			= &fd_mcs_proc_ops,
 	.detect				= fd_mcs_detect,
 	.release			= fd_mcs_release,
 	.info				= fd_mcs_info,
-- 
1.7.3.4

