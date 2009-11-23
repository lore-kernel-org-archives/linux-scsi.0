From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 08/27] scsi proc_fops: convert dc395x
Date: Mon, 23 Nov 2009 04:34:49 +0300
Message-ID: <20091123013449.GH31711@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:40919 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016AbZKWBgH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Nov 2009 20:36:07 -0500
Received: by ewy19 with SMTP id 19so1399892ewy.21
        for <linux-scsi@vger.kernel.org>; Sun, 22 Nov 2009 17:36:11 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/scsi/dc395x.c |   35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -53,6 +53,8 @@
 #include <linux/blkdev.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/spinlock.h>
 #include <linux/pci.h>
 #include <linux/list.h>
@@ -4615,26 +4617,22 @@ static void adapter_uninit(struct AdapterCtlBlk *acb)
 
 
 #undef SPRINTF
-#define SPRINTF(args...) pos += sprintf(pos, args)
+#define SPRINTF(args...) seq_printf(m, args)
 
 #undef YESNO
 #define YESNO(YN) \
  if (YN) SPRINTF(" Yes ");\
  else SPRINTF(" No  ")
 
-static int dc395x_proc_info(struct Scsi_Host *host, char *buffer,
-		char **start, off_t offset, int length, int inout)
+static int dc395x_proc_show(struct seq_file *m, void *v)
 {
+	struct Scsi_Host *host = m->private;
 	struct AdapterCtlBlk *acb = (struct AdapterCtlBlk *)host->hostdata;
 	int spd, spd1;
-	char *pos = buffer;
 	struct DeviceCtlBlk *dcb;
 	unsigned long flags;
 	int dev;
 
-	if (inout)		/* Has data been written to the file ? */
-		return -EPERM;
-
 	SPRINTF(DC395X_BANNER " PCI SCSI Host Adapter\n");
 	SPRINTF(" Driver Version " DC395X_VERSION "\n");
 
@@ -4734,22 +4732,28 @@ static int dc395x_proc_info(struct Scsi_Host *host, char *buffer,
 		SPRINTF("END\n");
 	}
 
-	*start = buffer + offset;
 	DC395x_UNLOCK_IO(acb->scsi_host, flags);
 
-	if (pos - buffer < offset)
-		return 0;
-	else if (pos - buffer - offset < length)
-		return pos - buffer - offset;
-	else
-		return length;
+	return 0;
 }
 
+static int dc395x_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, dc395x_proc_show, PDE(inode)->data);
+}
+
+static const struct file_operations dc395x_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= dc395x_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 
 static struct scsi_host_template dc395x_driver_template = {
 	.module                 = THIS_MODULE,
 	.proc_name              = DC395X_NAME,
-	.proc_info              = dc395x_proc_info,
+	.proc_fops		= &dc395x_proc_fops,
 	.name                   = DC395X_BANNER " " DC395X_VERSION,
 	.queuecommand           = dc395x_queue_command,
 	.bios_param             = dc395x_bios_param,
-- 
1.6.5.2

