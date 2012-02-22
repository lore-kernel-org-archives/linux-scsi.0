From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 13/34] scsi proc_ops: convert drivers/scsi/sym53c8xx_2/sym_glue.c
Date: Wed, 22 Feb 2012 22:46:04 +0300
Message-ID: <1329939985-26793-13-git-send-email-adobriyan@gmail.com>
References: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44011 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422Ab2BVTq4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2012 14:46:56 -0500
Received: by mail-bk0-f46.google.com with SMTP id jm19so433831bkc.19
        for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2012 11:46:55 -0800 (PST)
In-Reply-To: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/scsi/sym53c8xx_2/sym_glue.c |  134 +++++++++++++----------------------
 1 files changed, 50 insertions(+), 84 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 36d1ed7..2507a3e 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -41,6 +41,8 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/spinlock.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_tcq.h>
@@ -1167,116 +1169,80 @@ printk("sym_user_command: data=%ld\n", uc->data);
 	}
 	return length;
 }
+#endif
 
-#endif	/* SYM_LINUX_USER_COMMAND_SUPPORT */
-
-
-#ifdef SYM_LINUX_USER_INFO_SUPPORT
-/*
- *  Informations through the proc file system.
- */
-struct info_str {
-	char *buffer;
-	int length;
-	int offset;
-	int pos;
-};
-
-static void copy_mem_info(struct info_str *info, char *data, int len)
+static ssize_t sym53c8xx_proc_write(struct file *file, const char __user *buf,
+				    size_t count, loff_t *pos)
 {
-	if (info->pos + len > info->length)
-		len = info->length - info->pos;
-
-	if (info->pos + len < info->offset) {
-		info->pos += len;
-		return;
-	}
-	if (info->pos < info->offset) {
-		data += (info->offset - info->pos);
-		len  -= (info->offset - info->pos);
-	}
-
-	if (len > 0) {
-		memcpy(info->buffer + info->pos, data, len);
-		info->pos += len;
+#ifdef SYM_LINUX_USER_COMMAND_SUPPORT
+	struct Scsi_Host *shost = PDE(file->f_path.dentry->d_inode)->data;
+	char *cmd;
+	size_t len;
+	int rv;
+
+	cmd = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+	len = min_t(size_t, count, PAGE_SIZE - 1);
+	if (copy_from_user(cmd, buf, len)) {
+		kfree(cmd);
+		return -EFAULT;
 	}
-}
-
-static int copy_info(struct info_str *info, char *fmt, ...)
-{
-	va_list args;
-	char buf[81];
-	int len;
+	cmd[len] = '\0';
 
-	va_start(args, fmt);
-	len = vsprintf(buf, fmt, args);
-	va_end(args);
-
-	copy_mem_info(info, buf, len);
-	return len;
+	rv = sym_user_command(shost, cmd, len);
+	kfree(cmd);
+	if (rv < 0)
+		return rv;
+	return count;
+#else
+	return -EINVAL;
+#endif
 }
 
 /*
- *  Copy formatted information into the input buffer.
+ *  Informations through the proc file system.
  */
-static int sym_host_info(struct Scsi_Host *shost, char *ptr, off_t offset, int len)
+static int sym53c8xx_proc_show(struct seq_file *m, void *v)
 {
+#ifdef SYM_LINUX_USER_INFO_SUPPORT
+	struct Scsi_Host *shost = m->private;
 	struct sym_data *sym_data = shost_priv(shost);
 	struct pci_dev *pdev = sym_data->pdev;
 	struct sym_hcb *np = sym_data->ncb;
-	struct info_str info;
 
-	info.buffer	= ptr;
-	info.length	= len;
-	info.offset	= offset;
-	info.pos	= 0;
-
-	copy_info(&info, "Chip " NAME53C "%s, device id 0x%x, "
+	seq_printf(m, "Chip " NAME53C "%s, device id 0x%x, "
 			 "revision id 0x%x\n", np->s.chip_name,
 			 pdev->device, pdev->revision);
-	copy_info(&info, "At PCI address %s, IRQ %u\n",
+	seq_printf(m, "At PCI address %s, IRQ %u\n",
 			 pci_name(pdev), pdev->irq);
-	copy_info(&info, "Min. period factor %d, %s SCSI BUS%s\n",
+	seq_printf(m, "Min. period factor %d, %s SCSI BUS%s\n",
 			 (int) (np->minsync_dt ? np->minsync_dt : np->minsync),
 			 np->maxwide ? "Wide" : "Narrow",
 			 np->minsync_dt ? ", DT capable" : "");
 
-	copy_info(&info, "Max. started commands %d, "
+	seq_printf(m, "Max. started commands %d, "
 			 "max. commands per LUN %d\n",
 			 SYM_CONF_MAX_START, SYM_CONF_MAX_TAG);
 
-	return info.pos > info.offset? info.pos - info.offset : 0;
-}
-#endif /* SYM_LINUX_USER_INFO_SUPPORT */
-
-/*
- *  Entry point of the scsi proc fs of the driver.
- *  - func = 0 means read  (returns adapter infos)
- *  - func = 1 means write (not yet merget from sym53c8xx)
- */
-static int sym53c8xx_proc_info(struct Scsi_Host *shost, char *buffer,
-			char **start, off_t offset, int length, int func)
-{
-	int retv;
-
-	if (func) {
-#ifdef	SYM_LINUX_USER_COMMAND_SUPPORT
-		retv = sym_user_command(shost, buffer, length);
-#else
-		retv = -EINVAL;
-#endif
-	} else {
-		if (start)
-			*start = buffer;
-#ifdef SYM_LINUX_USER_INFO_SUPPORT
-		retv = sym_host_info(shost, buffer, offset, length);
+	return 0;
 #else
-		retv = -EINVAL;
+	return -EINVAL;
 #endif
-	}
+}
 
-	return retv;
+static int sym53c8xx_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, sym53c8xx_proc_show, PDE(inode)->data);
 }
+
+static const struct file_operations sym53c8xx_proc_ops = {
+	.open		= sym53c8xx_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= sym53c8xx_proc_write,
+};
 #endif /* SYM_LINUX_PROC_INFO_SUPPORT */
 
 /*
@@ -1744,7 +1710,7 @@ static struct scsi_host_template sym2_template = {
 	.use_clustering		= ENABLE_CLUSTERING,
 	.max_sectors		= 0xFFFF,
 #ifdef SYM_LINUX_PROC_INFO_SUPPORT
-	.proc_info		= sym53c8xx_proc_info,
+	.proc_ops		= &sym53c8xx_proc_ops,
 	.proc_name		= NAME53C8XX,
 #endif
 };
-- 
1.7.3.4

