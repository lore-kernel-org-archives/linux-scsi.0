From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 07/27] scsi proc_fops: convert atp870u
Date: Mon, 23 Nov 2009 04:34:12 +0300
Message-ID: <20091123013412.GG31711@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:47761 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004AbZKWBf3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Nov 2009 20:35:29 -0500
Received: by ey-out-2122.google.com with SMTP id 4so885853eyf.19
        for <linux-scsi@vger.kernel.org>; Sun, 22 Nov 2009 17:35:34 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/scsi/atp870u.c |   54 +++++++++++++++++++------------------------------
 1 file changed, 22 insertions(+), 32 deletions(-)

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
@@ -3088,40 +3089,30 @@ static const char *atp870u_info(struct Scsi_Host *notused)
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
+static const struct file_operations atp870u_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= atp870u_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 
 static int atp870u_biosparam(struct scsi_device *disk, struct block_device *dev,
 			sector_t capacity, int *ip)
@@ -3166,7 +3157,7 @@ static struct scsi_host_template atp870u_template = {
      .module			= THIS_MODULE,
      .name              	= "atp870u"		/* name */,
      .proc_name			= "atp870u",
-     .proc_info			= atp870u_proc_info,
+     .proc_fops			= &atp870u_proc_fops,
      .info              	= atp870u_info		/* info */,
      .queuecommand      	= atp870u_queuecommand	/* queuecommand */,
      .eh_abort_handler  	= atp870u_abort		/* abort */,
-- 
1.6.5.2

