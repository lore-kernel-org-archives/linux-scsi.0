From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 06/34] scsi proc_ops: convert drivers/scsi/atp870u.c
Date: Wed, 22 Feb 2012 22:45:57 +0300
Message-ID: <1329939985-26793-6-git-send-email-adobriyan@gmail.com>
References: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59220 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224Ab2BVTqn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2012 14:46:43 -0500
Received: by mail-bk0-f46.google.com with SMTP id jm19so433763bkc.19
        for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2012 11:46:43 -0800 (PST)
In-Reply-To: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/scsi/atp870u.c |   52 +++++++++++++++++++----------------------------
 1 files changed, 21 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 7e6eca4..3102dd1 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -25,6 +25,7 @@
 #include <linux/ioport.h>
 #include <linux/delay.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/spinlock.h>
 #include <linux/pci.h>
 #include <linux/blkdev.h>
@@ -3091,40 +3092,29 @@ static const char *atp870u_info(struct Scsi_Host *notused)
 	return buffer;
 }
 
-#define BLS buffer + len + size
-static int atp870u_proc_info(struct Scsi_Host *HBAptr, char *buffer, 
-			     char **start, off_t offset, int length, int inout)
+static int atp870u_proc_show(struct seq_file *m, void *v)
 {
-	static u8 buff[512];
-	int size = 0;
-	int len = 0;
-	off_t begin = 0;
-	off_t pos = 0;
+	struct Scsi_Host *HBAptr = m->private;
 	
-	if (inout) 	
-		return -EINVAL;
-	if (offset == 0)
-		memset(buff, 0, sizeof(buff));
-	size += sprintf(BLS, "ACARD AEC-671X Driver Version: 2.6+ac\n");
-	len += size;
-	pos = begin + len;
-	size = 0;
-
-	size += sprintf(BLS, "\n");
-	size += sprintf(BLS, "Adapter Configuration:\n");
-	size += sprintf(BLS, "               Base IO: %#.4lx\n", HBAptr->io_port);
-	size += sprintf(BLS, "                   IRQ: %d\n", HBAptr->irq);
-	len += size;
-	pos = begin + len;
-	
-	*start = buffer + (offset - begin);	/* Start of wanted data */
-	len -= (offset - begin);	/* Start slop */
-	if (len > length) {
-		len = length;	/* Ending slop */
-	}
-	return (len);
+	seq_printf(m, "ACARD AEC-671X Driver Version: 2.6+ac\n");
+	seq_printf(m, "\n");
+	seq_printf(m, "Adapter Configuration:\n");
+	seq_printf(m, "               Base IO: %#.4lx\n", HBAptr->io_port);
+	seq_printf(m, "                   IRQ: %d\n", HBAptr->irq);
+	return 0;
 }
 
+static int atp870u_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, atp870u_proc_show, PDE(inode)->data);
+}
+
+static const struct file_operations atp870u_proc_ops = {
+	.open		= atp870u_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 
 static int atp870u_biosparam(struct scsi_device *disk, struct block_device *dev,
 			sector_t capacity, int *ip)
@@ -3169,7 +3159,7 @@ static struct scsi_host_template atp870u_template = {
      .module			= THIS_MODULE,
      .name              	= "atp870u"		/* name */,
      .proc_name			= "atp870u",
-     .proc_info			= atp870u_proc_info,
+     .proc_ops			= &atp870u_proc_ops,
      .info              	= atp870u_info		/* info */,
      .queuecommand      	= atp870u_queuecommand	/* queuecommand */,
      .eh_abort_handler  	= atp870u_abort		/* abort */,
-- 
1.7.3.4

