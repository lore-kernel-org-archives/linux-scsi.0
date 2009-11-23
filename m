From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 22/27] scsi proc_fops: convert aha1740
Date: Mon, 23 Nov 2009 04:44:34 +0300
Message-ID: <20091123014434.GV31711@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:43717 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362AbZKWBpu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Nov 2009 20:45:50 -0500
Received: by ewy19 with SMTP id 19so1404107ewy.21
        for <linux-scsi@vger.kernel.org>; Sun, 22 Nov 2009 17:45:56 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/scsi/aha1740.c |   38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -45,6 +45,7 @@
 #include <linux/string.h>
 #include <linux/ioport.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/stat.h>
 #include <linux/init.h>
 #include <linux/device.h>
@@ -106,35 +107,33 @@ static inline dma_addr_t ecb_cpu_to_dma (struct Scsi_Host *host, void *cpu)
 	return hdata->ecb_dma_addr + offset;
 }
 
-static int aha1740_proc_info(struct Scsi_Host *shpnt, char *buffer,
-			     char **start, off_t offset,
-			     int length, int inout)
+static int aha1740_proc_show(struct seq_file *m, void *v)
 {
-	int len;
+	struct Scsi_Host *shpnt = m->private;
 	struct aha1740_hostdata *host;
 
-	if (inout)
-		return-ENOSYS;
-
 	host = HOSTDATA(shpnt);
 
-	len = sprintf(buffer, "aha174x at IO:%lx, IRQ %d, SLOT %d.\n"
+	seq_printf(m, "aha174x at IO:%lx, IRQ %d, SLOT %d.\n"
 		      "Extended translation %sabled.\n",
 		      shpnt->io_port, shpnt->irq, host->edev->slot,
 		      host->translation ? "en" : "dis");
+	return 0;
+}
 
-	if (offset > len) {
-		*start = buffer;
-		return 0;
-	}
-
-	*start = buffer + offset;
-	len -= offset;
-	if (len > length)
-		len = length;
-	return len;
+static int aha1740_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, aha1740_proc_show, PDE(inode)->data);
 }
 
+static const struct file_operations aha1740_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= aha1740_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static int aha1740_makecode(unchar *sense, unchar *status)
 {
 	struct statusword
@@ -554,7 +553,7 @@ static int aha1740_eh_abort_handler (Scsi_Cmnd *dummy)
 static struct scsi_host_template aha1740_template = {
 	.module           = THIS_MODULE,
 	.proc_name        = "aha1740",
-	.proc_info        = aha1740_proc_info,
+	.proc_fops        = &aha1740_proc_fops,
 	.name             = "Adaptec 174x (EISA)",
 	.queuecommand     = aha1740_queuecommand,
 	.bios_param       = aha1740_biosparam,
-- 
1.6.5.2

