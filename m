From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 24/34] scsi proc_ops: convert drivers/usb/storage/scsiglue.c
Date: Wed, 22 Feb 2012 22:46:15 +0300
Message-ID: <1329939985-26793-24-git-send-email-adobriyan@gmail.com>
References: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62313 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755606Ab2BVTrQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2012 14:47:16 -0500
Received: by mail-bk0-f46.google.com with SMTP id jm19so434319bkc.19
        for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2012 11:47:16 -0800 (PST)
In-Reply-To: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/usb/storage/scsiglue.c |   45 ++++++++++++++++++---------------------
 1 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 13b8bcd..40376cb 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -45,6 +45,8 @@
 
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -418,19 +420,14 @@ void usb_stor_report_bus_reset(struct us_data *us)
 /* we use this macro to help us write into the buffer */
 #undef SPRINTF
 #define SPRINTF(args...) \
-	do { if (pos < buffer+length) pos += sprintf(pos, ## args); } while (0)
+	seq_printf(m, ## args)
 
-static int proc_info (struct Scsi_Host *host, char *buffer,
-		char **start, off_t offset, int length, int inout)
+static int usb_stor_proc_show(struct seq_file *m, void *v)
 {
+	struct Scsi_Host *host = m->private;
 	struct us_data *us = host_to_us(host);
-	char *pos = buffer;
 	const char *string;
 
-	/* if someone is sending us data, just throw it away */
-	if (inout)
-		return length;
-
 	/* print the controller name */
 	SPRINTF("   Host scsi%d: usb-storage\n", host->host_no);
 
@@ -460,30 +457,30 @@ static int proc_info (struct Scsi_Host *host, char *buffer,
 	SPRINTF("    Transport: %s\n", us->transport_name);
 
 	/* show the device flags */
-	if (pos < buffer + length) {
-		pos += sprintf(pos, "       Quirks:");
+	seq_printf(m, "       Quirks:");
 
 #define US_FLAG(name, value) \
-	if (us->fflags & value) pos += sprintf(pos, " " #name);
+	if (us->fflags & value) seq_printf(m, " " #name);
 US_DO_ALL_FLAGS
 #undef US_FLAG
 
-		*(pos++) = '\n';
-	}
+	seq_putc(m, '\n');
 
-	/*
-	 * Calculate start of next buffer, and return value.
-	 */
-	*start = buffer + offset;
+	return 0;
+}
 
-	if ((pos - buffer) < offset)
-		return (0);
-	else if ((pos - buffer - offset) < length)
-		return (pos - buffer - offset);
-	else
-		return (length);
+static int usb_stor_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, usb_stor_proc_show, PDE(inode)->data);
 }
 
+static const struct file_operations usb_stor_proc_ops = {
+	.open		= usb_stor_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 /***********************************************************************
  * Sysfs interface
  ***********************************************************************/
@@ -526,7 +523,7 @@ struct scsi_host_template usb_stor_host_template = {
 	/* basic userland interface stuff */
 	.name =				"usb-storage",
 	.proc_name =			"usb-storage",
-	.proc_info =			proc_info,
+	.proc_ops =			&usb_stor_proc_ops,
 	.info =				host_info,
 
 	/* command interface -- queued only */
-- 
1.7.3.4

