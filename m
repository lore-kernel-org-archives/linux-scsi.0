From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 05/27] scsi proc_fops: convert imm
Date: Mon, 23 Nov 2009 04:33:04 +0300
Message-ID: <20091123013304.GE31711@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:48245 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885AbZKWBeV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Nov 2009 20:34:21 -0500
Received: by ewy19 with SMTP id 19so1399180ewy.21
        for <linux-scsi@vger.kernel.org>; Sun, 22 Nov 2009 17:34:26 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/scsi/imm.c |   75 ++++++++++++++++++++++++-----------------------------
 1 file changed, 35 insertions(+), 40 deletions(-)

--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/blkdev.h>
 #include <linux/parport.h>
+#include <linux/seq_file.h>
 #include <linux/workqueue.h>
 #include <linux/delay.h>
 #include <asm/io.h>
@@ -113,54 +114,49 @@ static inline void imm_pb_release(imm_struct *dev)
 	parport_release(dev->dev);
 }
 
-/* This is to give the imm driver a way to modify the timings (and other
- * parameters) by writing to the /proc/scsi/imm/0 file.
- * Very simple method really... (Too simple, no error checking :( )
- * Reason: Kernel hackers HATE having to unload and reload modules for
- * testing...
- * Also gives a method to use a script to obtain optimum timings (TODO)
- */
-static inline int imm_proc_write(imm_struct *dev, char *buffer, int length)
+static int imm_proc_show(struct seq_file *m, void *v)
 {
-	unsigned long x;
+	struct Scsi_Host *host = m->private;
+	imm_struct *dev = imm_dev(host);
 
-	if ((length > 5) && (strncmp(buffer, "mode=", 5) == 0)) {
-		x = simple_strtoul(buffer + 5, NULL, 0);
-		dev->mode = x;
-		return length;
-	}
-	printk("imm /proc: invalid variable\n");
-	return (-EINVAL);
+	seq_printf(m, "Version : %s\n", IMM_VERSION);
+	seq_printf(m, "Parport : %s\n", dev->dev->port->name);
+	seq_printf(m, "Mode    : %s\n", IMM_MODE_STRING[dev->mode]);
+
+	return 0;
 }
 
-static int imm_proc_info(struct Scsi_Host *host, char *buffer, char **start,
-			off_t offset, int length, int inout)
+static int imm_proc_open(struct inode *inode, struct file *file)
 {
-	imm_struct *dev = imm_dev(host);
-	int len = 0;
-
-	if (inout)
-		return imm_proc_write(dev, buffer, length);
+	return single_open(file, imm_proc_show, PDE(inode)->data);
+}
 
-	len += sprintf(buffer + len, "Version : %s\n", IMM_VERSION);
-	len +=
-	    sprintf(buffer + len, "Parport : %s\n",
-		    dev->dev->port->name);
-	len +=
-	    sprintf(buffer + len, "Mode    : %s\n",
-		    IMM_MODE_STRING[dev->mode]);
+static ssize_t imm_proc_write(struct file *file, const char __user *buf, size_t count, loff_t *pos)
+{
+	struct Scsi_Host *host = PDE(file->f_path.dentry->d_inode)->data;
+	imm_struct *dev = imm_dev(host);
+	char kbuf[42];
+	size_t len;
 
-	/* Request for beyond end of buffer */
-	if (offset > len)
-		return 0;
+	len = min(count, sizeof(kbuf) - 1);
+	if (copy_from_user(kbuf, buf, len))
+		return -EFAULT;
+	kbuf[len] = '\0';
 
-	*start = buffer + offset;
-	len -= offset;
-	if (len > length)
-		len = length;
-	return len;
+	if (sscanf(kbuf, "mode=%i", &dev->mode) != 1)
+		return -EINVAL;
+	return count;
 }
 
+static const struct file_operations imm_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= imm_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= imm_proc_write,
+};
+
 #if IMM_DEBUG > 0
 #define imm_fail(x,y) printk("imm: imm_fail(%i) from %s at line %d\n",\
 	   y, __func__, __LINE__); imm_fail_func(x,y);
@@ -1115,7 +1111,7 @@ static int imm_adjust_queue(struct scsi_device *device)
 static struct scsi_host_template imm_template = {
 	.module			= THIS_MODULE,
 	.proc_name		= "imm",
-	.proc_info		= imm_proc_info,
+	.proc_fops		= &imm_proc_fops,
 	.name			= "Iomega VPI2 (imm) interface",
 	.queuecommand		= imm_queuecommand,
 	.eh_abort_handler	= imm_abort,
-- 
1.6.5.2

