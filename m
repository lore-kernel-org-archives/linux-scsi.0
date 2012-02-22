From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 16/34] scsi proc_ops: convert drivers/scsi/aha1740.c
Date: Wed, 22 Feb 2012 22:46:07 +0300
Message-ID: <1329939985-26793-16-git-send-email-adobriyan@gmail.com>
References: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59220 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525Ab2BVTrC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2012 14:47:02 -0500
Received: by mail-bk0-f46.google.com with SMTP id jm19so433763bkc.19
        for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2012 11:47:01 -0800 (PST)
In-Reply-To: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/scsi/aha1740.c |   36 +++++++++++++++++-------------------
 1 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index 1c10b79..293f1d3 100644
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
@@ -107,35 +108,32 @@ static inline dma_addr_t ecb_cpu_to_dma (struct Scsi_Host *host, void *cpu)
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
 
+static const struct file_operations aha1740_proc_ops = {
+	.open		= aha1740_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static int aha1740_makecode(unchar *sense, unchar *status)
 {
 	struct statusword
@@ -557,7 +555,7 @@ static int aha1740_eh_abort_handler (Scsi_Cmnd *dummy)
 static struct scsi_host_template aha1740_template = {
 	.module           = THIS_MODULE,
 	.proc_name        = "aha1740",
-	.proc_info        = aha1740_proc_info,
+	.proc_ops         = &aha1740_proc_ops,
 	.name             = "Adaptec 174x (EISA)",
 	.queuecommand     = aha1740_queuecommand,
 	.bios_param       = aha1740_biosparam,
-- 
1.7.3.4

