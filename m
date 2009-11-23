From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 02/27] scsi proc_fops: convert usb_storage
Date: Mon, 23 Nov 2009 04:31:00 +0300
Message-ID: <20091123013100.GB31711@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:50271 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936AbZKWBcS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Nov 2009 20:32:18 -0500
Received: by ewy19 with SMTP id 19so1398270ewy.21
        for <linux-scsi@vger.kernel.org>; Sun, 22 Nov 2009 17:32:23 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/usb/storage/scsiglue.c |   47 +++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 25 deletions(-)

--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -43,6 +43,8 @@
  * 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
@@ -408,19 +410,14 @@ void usb_stor_report_bus_reset(struct us_data *us)
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
 
@@ -450,30 +447,31 @@ static int proc_info (struct Scsi_Host *host, char *buffer,
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
 
+static const struct file_operations usb_stor_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= usb_stor_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 /***********************************************************************
  * Sysfs interface
  ***********************************************************************/
@@ -516,7 +514,7 @@ struct scsi_host_template usb_stor_host_template = {
 	/* basic userland interface stuff */
 	.name =				"usb-storage",
 	.proc_name =			"usb-storage",
-	.proc_info =			proc_info,
+	.proc_fops =			&usb_stor_proc_fops,
 	.info =				host_info,
 
 	/* command interface -- queued only */
-- 
1.6.5.2

