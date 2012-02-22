From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 12/34] scsi proc_ops: convert drivers/scsi/aha152x.c
Date: Wed, 22 Feb 2012 22:46:03 +0300
Message-ID: <1329939985-26793-12-git-send-email-adobriyan@gmail.com>
References: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59220 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755468Ab2BVTqy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2012 14:46:54 -0500
Received: by mail-bk0-f46.google.com with SMTP id jm19so433763bkc.19
        for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2012 11:46:54 -0800 (PST)
In-Reply-To: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/scsi/aha152x.c |   94 ++++++++++++++++++++++-------------------------
 1 files changed, 44 insertions(+), 50 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index f17c92c..ebe3c9b 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -251,6 +251,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/isapnp.h>
+#include <linux/seq_file.h>
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/list.h>
@@ -2978,11 +2979,10 @@ static void show_queues(struct Scsi_Host *shpnt)
 }
 
 #undef SPRINTF
-#define SPRINTF(args...) pos += sprintf(pos, ## args)
+#define SPRINTF(args...) seq_printf(m, ## args)
 
-static int get_command(char *pos, Scsi_Cmnd * ptr)
+static void get_command(struct seq_file *m, Scsi_Cmnd *ptr)
 {
-	char *start = pos;
 	int i;
 
 	SPRINTF("0x%08x: target=%d; lun=%d; cmnd=( ",
@@ -3012,13 +3012,10 @@ static int get_command(char *pos, Scsi_Cmnd * ptr)
 	if (ptr->SCp.phase & syncneg)
 		SPRINTF("syncneg|");
 	SPRINTF("; next=0x%p\n", SCNEXT(ptr));
-
-	return (pos - start);
 }
 
-static int get_ports(struct Scsi_Host *shpnt, char *pos)
+static void get_ports(struct Scsi_Host *shpnt, struct seq_file *m)
 {
-	char *start = pos;
 	int s;
 
 	SPRINTF("\n%s: %s(%s) ", CURRENT_SC ? "on bus" : "waiting", states[STATE].name, states[PREVSTATE].name);
@@ -3274,26 +3271,37 @@ static int get_ports(struct Scsi_Host *shpnt, char *pos)
 	if (s & ENREQINIT)
 		SPRINTF("ENREQINIT ");
 	SPRINTF(")\n");
-
-	return (pos - start);
 }
 
-static int aha152x_set_info(char *buffer, int length, struct Scsi_Host *shpnt)
+static ssize_t aha152x_proc_write(struct file *file, const char __user *buf,
+				  size_t count, loff_t *pos)
 {
-	if(!shpnt || !buffer || length<8 || strncmp("aha152x ", buffer, 8)!=0)
+	struct Scsi_Host *shpnt = PDE(file->f_path.dentry->d_inode)->data;
+	char cmd[42];
+	size_t len;
+
+	if (!shpnt)
+		return -EINVAL;
+
+	len = min(count, sizeof(cmd) - 1);
+	if (copy_from_user(cmd, buf, len))
+		return -EFAULT;
+	cmd[len] = '\0';
+
+	if (len < 8 || strncmp("aha152x ", cmd, 8) != 0)
 		return -EINVAL;
 
 #if defined(AHA152X_DEBUG)
-	if(length>14 && strncmp("debug ", buffer+8, 6)==0) {
+	if (len > 14 && strncmp("debug ", cmd + 8, 6) == 0) {
 		int debug = HOSTDATA(shpnt)->debug;
 
-		HOSTDATA(shpnt)->debug = simple_strtoul(buffer+14, NULL, 0);
+		HOSTDATA(shpnt)->debug = simple_strtoul(cmd + 14, NULL, 0);
 
 		printk(KERN_INFO "aha152x%d: debugging options set to 0x%04x (were 0x%04x)\n", HOSTNO, HOSTDATA(shpnt)->debug, debug);
 	} else
 #endif
 #if defined(AHA152X_STAT)
-	if(length>13 && strncmp("reset", buffer+8, 5)==0) {
+	if (len > 13 && strncmp("reset", cmd + 8, 5) == 0) {
 		int i;
 
 		HOSTDATA(shpnt)->total_commands=0;
@@ -3317,30 +3325,19 @@ static int aha152x_set_info(char *buffer, int length, struct Scsi_Host *shpnt)
 		return -EINVAL;
 	}
 
-
-	return length;
+	return count;
 }
 
 #undef SPRINTF
 #define SPRINTF(args...) \
-	do { if(pos < buffer + length) pos += sprintf(pos, ## args); } while(0)
+	seq_printf(m, ## args)
 
-static int aha152x_proc_info(struct Scsi_Host *shpnt, char *buffer, char **start,
-		      off_t offset, int length, int inout)
+static int aha152x_proc_show(struct seq_file *m, void *v)
 {
+	struct Scsi_Host *shpnt = m->private;
 	int i;
-	char *pos = buffer;
 	Scsi_Cmnd *ptr;
 	unsigned long flags;
-	int thislength;
-
-	DPRINTK(debug_procinfo, 
-	       KERN_DEBUG "aha152x_proc_info: buffer=%p offset=%ld length=%d hostno=%d inout=%d\n",
-	       buffer, offset, length, shpnt->host_no, inout);
-
-
-	if (inout)
-		return aha152x_set_info(buffer, length, shpnt);
 
 	SPRINTF(AHA152X_REVID "\n");
 
@@ -3393,25 +3390,25 @@ static int aha152x_proc_info(struct Scsi_Host *shpnt, char *buffer, char **start
 	if (ISSUE_SC) {
 		SPRINTF("not yet issued commands:\n");
 		for (ptr = ISSUE_SC; ptr; ptr = SCNEXT(ptr))
-			pos += get_command(pos, ptr);
+			get_command(m, ptr);
 	} else
 		SPRINTF("no not yet issued commands\n");
 	DO_UNLOCK(flags);
 
 	if (CURRENT_SC) {
 		SPRINTF("current command:\n");
-		pos += get_command(pos, CURRENT_SC);
+		get_command(m, CURRENT_SC);
 	} else
 		SPRINTF("no current command\n");
 
 	if (DISCONNECTED_SC) {
 		SPRINTF("disconnected commands:\n");
 		for (ptr = DISCONNECTED_SC; ptr; ptr = SCNEXT(ptr))
-			pos += get_command(pos, ptr);
+			get_command(m, ptr);
 	} else
 		SPRINTF("no disconnected commands\n");
 
-	pos += get_ports(shpnt, pos);
+	get_ports(shpnt, m);
 
 #if defined(AHA152X_STAT)
 	SPRINTF("statistics:\n"
@@ -3442,25 +3439,22 @@ static int aha152x_proc_info(struct Scsi_Host *shpnt, char *buffer, char **start
 	}
 #endif
 
-	DPRINTK(debug_procinfo, KERN_DEBUG "aha152x_proc_info: pos=%p\n", pos);
-
-	thislength = pos - (buffer + offset);
-	DPRINTK(debug_procinfo, KERN_DEBUG "aha152x_proc_info: length=%d thislength=%d\n", length, thislength);
-
-	if(thislength<0) {
-		DPRINTK(debug_procinfo, KERN_DEBUG "aha152x_proc_info: output too short\n");
-		*start = NULL;
-		return 0;
-	}
-
-	thislength = thislength<length ? thislength : length;
-
-	DPRINTK(debug_procinfo, KERN_DEBUG "aha152x_proc_info: return %d\n", thislength);
+	return 0;
+}
 
-	*start = buffer + offset;
-	return thislength < length ? thislength : length;
+static int aha152x_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, aha152x_proc_show, PDE(inode)->data);
 }
 
+static const struct file_operations aha152x_proc_ops = {
+	.open		= aha152x_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= aha152x_proc_write,
+};
+
 static int aha152x_adjust_queue(struct scsi_device *device)
 {
 	blk_queue_bounce_limit(device->request_queue, BLK_BOUNCE_HIGH);
@@ -3471,7 +3465,7 @@ static struct scsi_host_template aha152x_driver_template = {
 	.module				= THIS_MODULE,
 	.name				= AHA152X_REVID,
 	.proc_name			= "aha152x",
-	.proc_info			= aha152x_proc_info,
+	.proc_ops			= &aha152x_proc_ops,
 	.queuecommand			= aha152x_queue,
 	.eh_abort_handler		= aha152x_abort,
 	.eh_device_reset_handler	= aha152x_device_reset,
-- 
1.7.3.4

