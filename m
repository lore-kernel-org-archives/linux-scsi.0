From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 09/34] scsi proc_ops: convert drivers/scsi/wd7000.c
Date: Wed, 22 Feb 2012 22:46:00 +0300
Message-ID: <1329939985-26793-9-git-send-email-adobriyan@gmail.com>
References: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44011 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422Ab2BVTqt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2012 14:46:49 -0500
Received: by mail-bk0-f46.google.com with SMTP id jm19so433831bkc.19
        for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2012 11:46:48 -0800 (PST)
In-Reply-To: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/scsi/wd7000.c |   50 ++++++++++++++++--------------------------------
 1 files changed, 17 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
index 9ee0afe..11673f7 100644
--- a/drivers/scsi/wd7000.c
+++ b/drivers/scsi/wd7000.c
@@ -174,6 +174,7 @@
 #include <linux/spinlock.h>
 #include <linux/ioport.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/blkdev.h>
 #include <linux/init.h>
 #include <linux/stat.h>
@@ -1297,36 +1298,18 @@ static void wd7000_revision(Adapter * host)
 
 
 #undef SPRINTF
-#define SPRINTF(args...) { if (pos < (buffer + length)) pos += sprintf (pos, ## args); }
+#define SPRINTF(args...)	seq_printf(m, ## args)
 
-static int wd7000_set_info(char *buffer, int length, struct Scsi_Host *host)
-{
-	dprintk("Buffer = <%.*s>, length = %d\n", length, buffer, length);
-
-	/*
-	 * Currently this is a no-op
-	 */
-	dprintk("Sorry, this function is currently out of order...\n");
-	return (length);
-}
-
-
-static int wd7000_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset, int length,  int inout)
+static int wd7000_proc_show(struct seq_file *m, void *v)
 {
+	struct Scsi_Host *host = m->private;
 	Adapter *adapter = (Adapter *)host->hostdata;
 	unsigned long flags;
-	char *pos = buffer;
 #ifdef WD7000_DEBUG
 	Mailbox *ogmbs, *icmbs;
 	short count;
 #endif
 
-	/*
-	 * Has data been written to the file ?
-	 */
-	if (inout)
-		return (wd7000_set_info(buffer, length, host));
-
 	spin_lock_irqsave(host->host_lock, flags);
 	SPRINTF("Host scsi%d: Western Digital WD-7000 (rev %d.%d)\n", host->host_no, adapter->rev1, adapter->rev2);
 	SPRINTF("  IO base:      0x%x\n", adapter->iobase);
@@ -1369,19 +1352,20 @@ static int wd7000_proc_info(struct Scsi_Host *host, char *buffer, char **start,
 
 	spin_unlock_irqrestore(host->host_lock, flags);
 
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
+static int wd7000_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, wd7000_proc_show, PDE(inode)->data);
 }
 
+static const struct file_operations wd7000_proc_ops = {
+	.open		= wd7000_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 
 /*
  *  Returns the number of adapters this driver is supporting.
@@ -1414,7 +1398,7 @@ static __init int wd7000_detect(struct scsi_host_template *tpnt)
 	for (i = 0; i < NUM_CONFIGS; biosptr[i++] = -1);
 
 	tpnt->proc_name = "wd7000";
-	tpnt->proc_info = &wd7000_proc_info;
+	tpnt->proc_ops = &wd7000_proc_ops;
 
 	/*
 	 * Set up SCB free list, which is shared by all adapters
@@ -1659,7 +1643,7 @@ MODULE_LICENSE("GPL");
 
 static struct scsi_host_template driver_template = {
 	.proc_name		= "wd7000",
-	.proc_info		= wd7000_proc_info,
+	.proc_ops		= &wd7000_proc_ops,
 	.name			= "Western Digital WD-7000",
 	.detect			= wd7000_detect,
 	.release		= wd7000_release,
-- 
1.7.3.4

