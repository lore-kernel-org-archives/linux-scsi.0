From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 03/27] scsi proc_fops: convert scsi_debug.c
Date: Mon, 23 Nov 2009 04:31:59 +0300
Message-ID: <20091123013159.GC31711@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:60691 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956AbZKWBdS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Nov 2009 20:33:18 -0500
Received: by ewy19 with SMTP id 19so1398726ewy.21
        for <linux-scsi@vger.kernel.org>; Sun, 22 Nov 2009 17:33:21 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/scsi/scsi_debug.c |   81 ++++++++++++++++++++++++----------------------
 1 file changed, 44 insertions(+), 37 deletions(-)

--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -39,6 +39,7 @@
 #include <linux/vmalloc.h>
 #include <linux/moduleparam.h>
 #include <linux/scatterlist.h>
+#include <linux/seq_file.h>
 #include <linux/blkdev.h>
 #include <linux/crc-t10dif.h>
 
@@ -2470,34 +2471,12 @@ static const char * scsi_debug_info(struct Scsi_Host * shp)
 	return sdebug_info;
 }
 
-/* scsi_debug_proc_info
+/*
  * Used if the driver currently has no own support for /proc/scsi
  */
-static int scsi_debug_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset,
-				int length, int inout)
-{
-	int len, pos, begin;
-	int orig_length;
-
-	orig_length = length;
-
-	if (inout == 1) {
-		char arr[16];
-		int minLen = length > 15 ? 15 : length;
-
-		if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
-			return -EACCES;
-		memcpy(arr, buffer, minLen);
-		arr[minLen] = '\0';
-		if (1 != sscanf(arr, "%d", &pos))
-			return -EINVAL;
-		scsi_debug_opts = pos;
-		if (scsi_debug_every_nth != 0)
-                        scsi_debug_cmnd_count = 0;
-		return length;
-	}
-	begin = 0;
-	pos = len = sprintf(buffer, "scsi_debug adapter driver, version "
+static int scsi_debug_proc_show(struct seq_file *m, void *v)
+{
+	seq_printf(m, "scsi_debug adapter driver, version "
 	    "%s [%s]\n"
 	    "num_tgts=%d, shared (ram) size=%d MB, opts=0x%x, "
 	    "every_nth=%d(curr:%d)\n"
@@ -2512,17 +2491,46 @@ static int scsi_debug_proc_info(struct Scsi_Host *host, char *buffer, char **sta
 	    scsi_debug_sector_size, sdebug_cylinders_per, sdebug_heads,
 	    sdebug_sectors_per, num_aborts, num_dev_resets, num_bus_resets,
 	    num_host_resets, dix_reads, dix_writes, dif_errors);
-	if (pos < offset) {
-		len = 0;
-		begin = pos;
-	}
-	*start = buffer + (offset - begin);	/* Start of wanted data */
-	len -= (offset - begin);
-	if (len > length)
-		len = length;
-	return len;
+	return 0;
 }
 
+static int scsi_debug_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, scsi_debug_proc_show, NULL);
+}
+
+static ssize_t scsi_debug_proc_write(struct file *file, const char __user *buf,
+				     size_t count, loff_t *pos)
+{
+	char kbuf[16];
+	size_t len;
+
+	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
+		return -EACCES;
+
+	len = min(count, sizeof(kbuf) - 1);
+	if (copy_from_user(kbuf, buf, len))
+		return -EFAULT;
+	kbuf[len] = '\0';
+
+	if (sscanf(kbuf, "%d", &scsi_debug_opts) != 1)
+		return -EINVAL;
+
+	if (scsi_debug_every_nth != 0)
+		scsi_debug_cmnd_count = 0;
+
+	return count;
+}
+
+static const struct file_operations scsi_debug_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= scsi_debug_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= scsi_debug_proc_write,
+};
+
 static ssize_t sdebug_delay_show(struct device_driver * ddp, char * buf)
 {
         return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_delay);
@@ -3459,7 +3467,7 @@ write:
 }
 
 static struct scsi_host_template sdebug_driver_template = {
-	.proc_info =		scsi_debug_proc_info,
+	.proc_fops =		&scsi_debug_proc_fops,
 	.proc_name =		sdebug_proc_name,
 	.name =			"SCSI DEBUG",
 	.info =			scsi_debug_info,
-- 
1.6.5.2

