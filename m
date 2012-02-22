From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 02/34] scsi proc_ops: convert drivers/scsi/scsi_debug.c
Date: Wed, 22 Feb 2012 22:45:53 +0300
Message-ID: <1329939985-26793-2-git-send-email-adobriyan@gmail.com>
References: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59220 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798Ab2BVTqf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2012 14:46:35 -0500
Received: by mail-bk0-f46.google.com with SMTP id jm19so433763bkc.19
        for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2012 11:46:35 -0800 (PST)
In-Reply-To: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/scsi/scsi_debug.c |   70 ++++++++++++++++++++++-----------------------
 1 files changed, 34 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 6888b2c..2f3fd1d 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -40,6 +40,7 @@
 #include <linux/vmalloc.h>
 #include <linux/moduleparam.h>
 #include <linux/scatterlist.h>
+#include <linux/seq_file.h>
 #include <linux/blkdev.h>
 #include <linux/crc-t10dif.h>
 
@@ -2803,35 +2804,12 @@ static const char * scsi_debug_info(struct Scsi_Host * shp)
 	return sdebug_info;
 }
 
-/* scsi_debug_proc_info
+/*
  * Used if the driver currently has no own support for /proc/scsi
  */
-static int scsi_debug_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset,
-				int length, int inout)
+static int scsi_debug_proc_show(struct seq_file *m, void *v)
 {
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
-	    "%s [%s]\n"
+	seq_printf(m, "scsi_debug adapter driver, version %s [%s]\n"
 	    "num_tgts=%d, shared (ram) size=%d MB, opts=0x%x, "
 	    "every_nth=%d(curr:%d)\n"
 	    "delay=%d, max_luns=%d, scsi_level=%d\n"
@@ -2845,17 +2823,37 @@ static int scsi_debug_proc_info(struct Scsi_Host *host, char *buffer, char **sta
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
+	int rv;
+
+	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
+		return -EACCES;
+	rv = kstrtoint_from_user(buf, count, 10, &scsi_debug_opts);
+	if (rv < 0)
+		return rv;
+	if (scsi_debug_every_nth != 0)
+		scsi_debug_cmnd_count = 0;
+	return count;
+}
+
+static const struct file_operations scsi_debug_proc_ops = {
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
@@ -3916,7 +3914,7 @@ write:
 static DEF_SCSI_QCMD(scsi_debug_queuecommand)
 
 static struct scsi_host_template sdebug_driver_template = {
-	.proc_info =		scsi_debug_proc_info,
+	.proc_ops =		&scsi_debug_proc_ops,
 	.proc_name =		sdebug_proc_name,
 	.name =			"SCSI DEBUG",
 	.info =			scsi_debug_info,
-- 
1.7.3.4

