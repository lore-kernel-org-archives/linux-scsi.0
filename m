From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 12/27] scsi proc_fops: convert fd_mcs
Date: Mon, 23 Nov 2009 04:37:02 +0300
Message-ID: <20091123013702.GL31711@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:56601 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbZKWBiT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Nov 2009 20:38:19 -0500
Received: by ey-out-2122.google.com with SMTP id 4so886098eyf.19
        for <linux-scsi@vger.kernel.org>; Sun, 22 Nov 2009 17:38:24 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/scsi/fd_mcs.c |   48 +++++++++++++++++++++---------------------------
 1 file changed, 21 insertions(+), 27 deletions(-)

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
@@ -528,37 +529,31 @@ static const char *fd_mcs_info(struct Scsi_Host *shpnt)
 
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
+	seq_printf(m, "Future Domain MCS-600/700 Driver %s\n", DRIVER_VERSION);
+	seq_printf(m, "HOST #%d: %s\n", shpnt->host_no, adapter_name);
+	seq_printf(m, "FIFO Size=0x%x, FIFO Count=%d\n", FIFO_Size, FIFO_COUNT);
+	seq_printf(m, "DriverCalls=%d, Interrupts=%d, BytesRead=%d, BytesWrite=%d\n\n", TOTAL_INTR, INTR_Processed, Bytes_Read, Bytes_Written);
 
-	*start = buffer + offset;
-
-	len += sprintf(buffer + len, "Future Domain MCS-600/700 Driver %s\n", DRIVER_VERSION);
-	len += sprintf(buffer + len, "HOST #%d: %s\n", shpnt->host_no, adapter_name);
-	len += sprintf(buffer + len, "FIFO Size=0x%x, FIFO Count=%d\n", FIFO_Size, FIFO_COUNT);
-	len += sprintf(buffer + len, "DriverCalls=%d, Interrupts=%d, BytesRead=%d, BytesWrite=%d\n\n", TOTAL_INTR, INTR_Processed, Bytes_Read, Bytes_Written);
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
 
+static const struct file_operations fd_mcs_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= fd_mcs_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static int fd_mcs_select(struct Scsi_Host *shpnt, int target)
 {
 	int status;
@@ -1333,7 +1328,7 @@ static int fd_mcs_biosparam(struct scsi_device * disk, struct block_device *bdev
 
 static struct scsi_host_template driver_template = {
 	.proc_name			= "fd_mcs",
-	.proc_info			= fd_mcs_proc_info,
+	.proc_fops			= &fd_mcs_proc_fops,
 	.detect				= fd_mcs_detect,
 	.release			= fd_mcs_release,
 	.info				= fd_mcs_info,
-- 
1.6.5.2

