From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 28/34] scsi proc_ops: convert drivers/scsi/eata_pio.c
Date: Wed, 22 Feb 2012 22:46:19 +0300
Message-ID: <1329939985-26793-28-git-send-email-adobriyan@gmail.com>
References: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44011 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755665Ab2BVTrY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2012 14:47:24 -0500
Received: by mail-bk0-f46.google.com with SMTP id jm19so433831bkc.19
        for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2012 11:47:23 -0800 (PST)
In-Reply-To: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>

BROKEN, but convert anyway.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/scsi/eata_pio.c |   69 ++++++++++++++++------------------------------
 1 files changed, 24 insertions(+), 45 deletions(-)

diff --git a/drivers/scsi/eata_pio.c b/drivers/scsi/eata_pio.c
index d5f8362..7d601e7 100644
--- a/drivers/scsi/eata_pio.c
+++ b/drivers/scsi/eata_pio.c
@@ -55,6 +55,7 @@
 #include <linux/proc_fs.h>
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
+#include <linux/seq_file.h>
 #include <linux/spinlock.h>
 #include <linux/delay.h>
 
@@ -92,60 +93,38 @@ static unsigned long queue_counter;
 
 static struct scsi_host_template driver_template;
 
-/*
- * eata_proc_info
- * inout : decides on the direction of the dataflow and the meaning of the 
- *         variables
- * buffer: If inout==FALSE data is being written to it else read from it
- * *start: If inout==FALSE start of the valid data in the buffer
- * offset: If inout==FALSE offset from the beginning of the imaginary file 
- *         from which we start writing into the buffer
- * length: If inout==FALSE max number of bytes to be written into the buffer 
- *         else number of bytes in the buffer
- */
-static int eata_pio_proc_info(struct Scsi_Host *shost, char *buffer, char **start, off_t offset,
-			      int length, int rw)
+static int eata_pio_proc_show(struct seq_file *m, void *v)
 {
-	int len = 0;
-	off_t begin = 0, pos = 0;
+	struct Scsi_Host *shost = m->private;
 
-	if (rw)
-		return -ENOSYS;
-
-	len += sprintf(buffer+len, "EATA (Extended Attachment) PIO driver version: "
+	seq_printf(m, "EATA (Extended Attachment) PIO driver version: "
 		   "%d.%d%s\n",VER_MAJOR, VER_MINOR, VER_SUB);
-	len += sprintf(buffer + len, "queued commands:     %10ld\n"
+	seq_printf(m, "queued commands:     %10ld\n"
 		   "processed interrupts:%10ld\n", queue_counter, int_counter);
-	len += sprintf(buffer + len, "\nscsi%-2d: HBA %.10s\n",
+	seq_printf(m, "\nscsi%-2d: HBA %.10s\n",
 		   shost->host_no, SD(shost)->name);
-	len += sprintf(buffer + len, "Firmware revision: v%s\n",
+	seq_printf(m, "Firmware revision: v%s\n",
 		   SD(shost)->revision);
-	len += sprintf(buffer + len, "IO: PIO\n");
-	len += sprintf(buffer + len, "Base IO : %#.4x\n", (u32) shost->base);
-	len += sprintf(buffer + len, "Host Bus: %s\n",
+	seq_printf(m, "IO: PIO\n");
+	seq_printf(m, "Base IO : %#.4x\n", (u32) shost->base);
+	seq_printf(m, "Host Bus: %s\n",
 		   (SD(shost)->bustype == 'P')?"PCI ":
 		   (SD(shost)->bustype == 'E')?"EISA":"ISA ");
-    
-	pos = begin + len;
-    
-	if (pos < offset) {
-		len = 0;
-		begin = pos;
-	}
-	if (pos > offset + length)
-		goto stop_output;
-    
-stop_output:
-	DBG(DBG_PROC, printk("2pos: %ld offset: %ld len: %d\n", pos, offset, len));
-	*start = buffer + (offset - begin);   /* Start of wanted data */
-	len -= (offset - begin);            /* Start slop */
-	if (len > length)
-		len = length;               /* Ending slop */
-	DBG(DBG_PROC, printk("3pos: %ld offset: %ld len: %d\n", pos, offset, len));
-    
-	return len;
+	return 0;
+}
+
+static int eata_pio_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, eata_pio_proc_show, PDE(inode)->data);
 }
 
+static const struct file_operations eata_pio_proc_ops = {
+	.open		= eata_pio_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static int eata_pio_release(struct Scsi_Host *sh)
 {
 	hostdata *hd = SD(sh);
@@ -985,7 +964,7 @@ static int eata_pio_detect(struct scsi_host_template *tpnt)
 static struct scsi_host_template driver_template = {
 	.proc_name		= "eata_pio",
 	.name              	= "EATA (Extended Attachment) PIO driver",
-	.proc_info         	= eata_pio_proc_info,
+	.proc_ops		= &eata_pio_proc_ops,
 	.detect            	= eata_pio_detect,
 	.release           	= eata_pio_release,
 	.queuecommand      	= eata_pio_queue,
-- 
1.7.3.4

