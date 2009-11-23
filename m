From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 06/27] scsi proc_fops: convert ppa
Date: Mon, 23 Nov 2009 04:33:33 +0300
Message-ID: <20091123013332.GF31711@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:48245 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999AbZKWBet (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Nov 2009 20:34:49 -0500
Received: by mail-ew0-f219.google.com with SMTP id 19so1399180ewy.21
        for <linux-scsi@vger.kernel.org>; Sun, 22 Nov 2009 17:34:55 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/scsi/ppa.c |   87 +++++++++++++++++++++++------------------------------
 1 file changed, 39 insertions(+), 48 deletions(-)

--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -16,6 +16,7 @@
 #include <linux/workqueue.h>
 #include <linux/delay.h>
 #include <linux/jiffies.h>
+#include <linux/seq_file.h>
 #include <asm/io.h>
 
 #include <scsi/scsi.h>
@@ -109,64 +110,55 @@ static inline void ppa_pb_release(ppa_struct *dev)
  * Start of Chipset kludges
  */
 
-/* This is to give the ppa driver a way to modify the timings (and other
- * parameters) by writing to the /proc/scsi/ppa/0 file.
- * Very simple method really... (To simple, no error checking :( )
- * Reason: Kernel hackers HATE having to unload and reload modules for
- * testing...
- * Also gives a method to use a script to obtain optimum timings (TODO)
- */
-
-static inline int ppa_proc_write(ppa_struct *dev, char *buffer, int length)
+static ssize_t ppa_proc_write(struct file *file, const char __user *buf,
+			      size_t count, loff_t *pos)
 {
-	unsigned long x;
-
-	if ((length > 5) && (strncmp(buffer, "mode=", 5) == 0)) {
-		x = simple_strtoul(buffer + 5, NULL, 0);
-		dev->mode = x;
-		return length;
-	}
-	if ((length > 10) && (strncmp(buffer, "recon_tmo=", 10) == 0)) {
-		x = simple_strtoul(buffer + 10, NULL, 0);
-		dev->recon_tmo = x;
-		printk(KERN_INFO "ppa: recon_tmo set to %ld\n", x);
-		return length;
-	}
-	printk(KERN_WARNING "ppa /proc: invalid variable\n");
+	struct Scsi_Host *host = PDE(file->f_path.dentry->d_inode)->data;
+	ppa_struct *dev = ppa_dev(host);
+	char kbuf[42];
+	size_t len;
+
+	len = min(count, sizeof(kbuf) - 1);
+	if (copy_from_user(kbuf, buf, len))
+		return -EFAULT;
+	kbuf[len] = '\0';
+
+	if (sscanf(kbuf, "mode=%i", &dev->mode) == 1)
+		return count;
+	if (sscanf(kbuf, "recon_tmo=%li", &dev->recon_tmo) == 1)
+		return count;
 	return -EINVAL;
 }
 
-static int ppa_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset, int length, int inout)
+
+static int ppa_proc_show(struct seq_file *m, void *v)
 {
-	int len = 0;
+	struct Scsi_Host *host = m->private;
 	ppa_struct *dev = ppa_dev(host);
 
-	if (inout)
-		return ppa_proc_write(dev, buffer, length);
-
-	len += sprintf(buffer + len, "Version : %s\n", PPA_VERSION);
-	len +=
-	    sprintf(buffer + len, "Parport : %s\n",
-		    dev->dev->port->name);
-	len +=
-	    sprintf(buffer + len, "Mode    : %s\n",
-		    PPA_MODE_STRING[dev->mode]);
+	seq_printf(m, "Version : %s\n", PPA_VERSION);
+	seq_printf(m, "Parport : %s\n", dev->dev->port->name);
+	seq_printf(m, "Mode    : %s\n", PPA_MODE_STRING[dev->mode]);
 #if PPA_DEBUG > 0
-	len +=
-	    sprintf(buffer + len, "recon_tmo : %lu\n", dev->recon_tmo);
+	seq_printf(m, "recon_tmo : %lu\n", dev->recon_tmo);
 #endif
+	return 0;
+}
 
-	/* Request for beyond end of buffer */
-	if (offset > length)
-		return 0;
-
-	*start = buffer + offset;
-	len -= offset;
-	if (len > length)
-		len = length;
-	return len;
+static int ppa_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ppa_proc_show, PDE(inode)->data);
 }
 
+static const struct file_operations ppa_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= ppa_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= ppa_proc_write,
+};
+
 static int device_check(ppa_struct *dev);
 
 #if PPA_DEBUG > 0
@@ -978,7 +970,7 @@ static int ppa_adjust_queue(struct scsi_device *device)
 static struct scsi_host_template ppa_template = {
 	.module			= THIS_MODULE,
 	.proc_name		= "ppa",
-	.proc_info		= ppa_proc_info,
+	.proc_fops		= &ppa_proc_fops,
 	.name			= "Iomega VPI0 (ppa) interface",
 	.queuecommand		= ppa_queuecommand,
 	.eh_abort_handler	= ppa_abort,
-- 
1.6.5.2

