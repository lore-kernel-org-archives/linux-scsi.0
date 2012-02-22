From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 07/34] scsi proc_ops: convert drivers/scsi/dc395x.c
Date: Wed, 22 Feb 2012 22:45:58 +0300
Message-ID: <1329939985-26793-7-git-send-email-adobriyan@gmail.com>
References: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44011 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422Ab2BVTqp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2012 14:46:45 -0500
Received: by mail-bk0-f46.google.com with SMTP id jm19so433831bkc.19
        for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2012 11:46:45 -0800 (PST)
In-Reply-To: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/scsi/dc395x.c |   33 ++++++++++++++++++---------------
 1 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 13aeca3..6d0d614 100644
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
@@ -4616,26 +4618,22 @@ static void adapter_uninit(struct AdapterCtlBlk *acb)
 
 
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
 
@@ -4735,22 +4733,27 @@ static int dc395x_proc_info(struct Scsi_Host *host, char *buffer,
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
+static const struct file_operations dc395x_proc_ops = {
+	.open		= dc395x_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 
 static struct scsi_host_template dc395x_driver_template = {
 	.module                 = THIS_MODULE,
 	.proc_name              = DC395X_NAME,
-	.proc_info              = dc395x_proc_info,
+	.proc_ops		= &dc395x_proc_ops,
 	.name                   = DC395X_BANNER " " DC395X_VERSION,
 	.queuecommand           = dc395x_queue_command,
 	.bios_param             = dc395x_bios_param,
-- 
1.7.3.4

