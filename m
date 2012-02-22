From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 30/34] scsi proc_ops: convert drivers/scsi/g_NCR5380.c
Date: Wed, 22 Feb 2012 22:46:21 +0300
Message-ID: <1329939985-26793-30-git-send-email-adobriyan@gmail.com>
References: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62313 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621Ab2BVTr1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2012 14:47:27 -0500
Received: by mail-bk0-f46.google.com with SMTP id jm19so434319bkc.19
        for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2012 11:47:26 -0800 (PST)
In-Reply-To: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/scsi/g_NCR5380.c |   79 +++++++++++++++++++--------------------------
 1 files changed, 33 insertions(+), 46 deletions(-)

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 81182ba..cdd8dc2 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -114,6 +114,8 @@
 #include <linux/isapnp.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 
 #define NCR_NOT_SET 0
 static int ncr_irq = NCR_NOT_SET;
@@ -746,24 +748,21 @@ static inline int NCR5380_pwrite(struct Scsi_Host *instance, unsigned char *src,
  
 #include "NCR5380.c"
 
-#define PRINTP(x) len += sprintf(buffer+len, x)
+#define PRINTP(x) seq_printf(m, x)
 #define ANDP ,
 
-static int sprint_opcode(char *buffer, int len, int opcode)
+static void sprint_opcode(struct seq_file *m, int opcode)
 {
-	int start = len;
 	PRINTP("0x%02x " ANDP opcode);
-	return len - start;
 }
 
-static int sprint_command(char *buffer, int len, unsigned char *command)
+static void sprint_command(struct seq_file *m, unsigned char *command)
 {
-	int i, s, start = len;
-	len += sprint_opcode(buffer, len, command[0]);
+	int i, s;
+	sprint_opcode(m, command[0]);
 	for (i = 1, s = COMMAND_SIZE(command[0]); i < s; ++i)
 		PRINTP("%02x " ANDP command[i]);
 	PRINTP("\n");
-	return len - start;
 }
 
 /**
@@ -775,35 +774,16 @@ static int sprint_command(char *buffer, int len, unsigned char *command)
  *	Print out the target and command data in hex
  */
 
-static int sprint_Scsi_Cmnd(char *buffer, int len, Scsi_Cmnd * cmd)
+static void sprint_Scsi_Cmnd(struct seq_file *m, Scsi_Cmnd * cmd)
 {
-	int start = len;
 	PRINTP("host number %d destination target %d, lun %d\n" ANDP cmd->device->host->host_no ANDP cmd->device->id ANDP cmd->device->lun);
 	PRINTP("        command = ");
-	len += sprint_command(buffer, len, cmd->cmnd);
-	return len - start;
+	sprint_command(m, cmd->cmnd);
 }
 
-/**
- *	generic_NCR5380_proc_info	-	/proc for NCR5380 driver
- *	@buffer: buffer to print into
- *	@start: start position
- *	@offset: offset into buffer
- *	@len: length
- *	@hostno: instance to affect
- *	@inout: read/write
- *
- *	Provide the procfs information for the 5380 controller. We fill
- *	this with useful debugging information including the commands
- *	being executed, disconnected command queue and the statistical
- *	data
- *
- *	Locks: global cli/lock for queue walk
- */
- 
-static int generic_NCR5380_proc_info(struct Scsi_Host *scsi_ptr, char *buffer, char **start, off_t offset, int length, int inout)
+static int generic_NCR5380_proc_show(struct seq_file *m, void *v)
 {
-	int len = 0;
+	struct Scsi_Host *scsi_ptr = m->private;
 	NCR5380_local_declare();
 	unsigned long flags;
 	unsigned char status;
@@ -854,16 +834,16 @@ static int generic_NCR5380_proc_info(struct Scsi_Host *scsi_ptr, char *buffer, c
 		PRINTP("  T:%d %s " ANDP dev->id ANDP scsi_device_type(dev->type));
 		for (i = 0; i < 8; i++)
 			if (dev->vendor[i] >= 0x20)
-				*(buffer + (len++)) = dev->vendor[i];
-		*(buffer + (len++)) = ' ';
+				seq_putc(m, dev->vendor[i]);
+		seq_putc(m, ' ');
 		for (i = 0; i < 16; i++)
 			if (dev->model[i] >= 0x20)
-				*(buffer + (len++)) = dev->model[i];
-		*(buffer + (len++)) = ' ';
+				seq_putc(m, dev->model[i]);
+		seq_putc(m, ' ');
 		for (i = 0; i < 4; i++)
 			if (dev->rev[i] >= 0x20)
-				*(buffer + (len++)) = dev->rev[i];
-		*(buffer + (len++)) = ' ';
+				seq_putc(m, dev->rev[i]);
+		seq_putc(m, ' ');
 
 		PRINTP("\n%10ld kb read    in %5ld secs" ANDP br / 1024 ANDP tr);
 		if (tr)
@@ -887,32 +867,39 @@ static int generic_NCR5380_proc_info(struct Scsi_Host *scsi_ptr, char *buffer, c
 	if (!hostdata->connected) {
 		PRINTP("No currently connected command\n");
 	} else {
-		len += sprint_Scsi_Cmnd(buffer, len, (Scsi_Cmnd *) hostdata->connected);
+		sprint_Scsi_Cmnd(m, (Scsi_Cmnd *) hostdata->connected);
 	}
 
 	PRINTP("issue_queue\n");
 
 	for (ptr = (Scsi_Cmnd *) hostdata->issue_queue; ptr; ptr = (Scsi_Cmnd *) ptr->host_scribble)
-		len += sprint_Scsi_Cmnd(buffer, len, ptr);
+		sprint_Scsi_Cmnd(m, ptr);
 
 	PRINTP("disconnected_queue\n");
 
 	for (ptr = (Scsi_Cmnd *) hostdata->disconnected_queue; ptr; ptr = (Scsi_Cmnd *) ptr->host_scribble)
-		len += sprint_Scsi_Cmnd(buffer, len, ptr);
+		sprint_Scsi_Cmnd(m, ptr);
 
-	*start = buffer + offset;
-	len -= offset;
-	if (len > length)
-		len = length;
 	spin_unlock_irqrestore(scsi_ptr->host_lock, flags);
-	return len;
+	return 0;
 }
 
 #undef PRINTP
 #undef ANDP
 
+static int generic_NCR5380_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, generic_NCR5380_proc_show, PDE(inode)->data);
+}
+
+static const struct file_operations generic_NCR5380_proc_ops = {
+	.open		= generic_NCR5380_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 static struct scsi_host_template driver_template = {
-	.proc_info      	= generic_NCR5380_proc_info,
+	.proc_ops		= &generic_NCR5380_proc_ops,
 	.name           	= "Generic NCR5380/NCR53C400 Scsi Driver",
 	.detect         	= generic_NCR5380_detect,
 	.release        	= generic_NCR5380_release_resources,
-- 
1.7.3.4

