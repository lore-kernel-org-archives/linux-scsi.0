From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 14/27] scsi proc_fops: convert mpt fusion
Date: Mon, 23 Nov 2009 04:38:15 +0300
Message-ID: <20091123013815.GN31711@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:49932 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbZKWBjd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Nov 2009 20:39:33 -0500
Received: by ewy19 with SMTP id 19so1401399ewy.21
        for <linux-scsi@vger.kernel.org>; Sun, 22 Nov 2009 17:39:38 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/message/fusion/mptfc.c    |    2 
 drivers/message/fusion/mptsas.c   |    2 
 drivers/message/fusion/mptscsih.c |  110 ++++++--------------------------------
 drivers/message/fusion/mptscsih.h |    2 
 drivers/message/fusion/mptspi.c   |    3 -
 5 files changed, 24 insertions(+), 95 deletions(-)

--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -109,7 +109,7 @@ static int mptfc_host_reset(struct scsi_cmnd *SCpnt);
 static struct scsi_host_template mptfc_driver_template = {
 	.module				= THIS_MODULE,
 	.proc_name			= "mptfc",
-	.proc_info			= mptscsih_proc_info,
+	.proc_fops			= &mptscsih_proc_fops,
 	.name				= "MPT FC Host",
 	.info				= mptscsih_info,
 	.queuecommand			= mptfc_qcmd,
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1877,7 +1877,7 @@ mptsas_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 static struct scsi_host_template mptsas_driver_template = {
 	.module				= THIS_MODULE,
 	.proc_name			= "mptsas",
-	.proc_info			= mptscsih_proc_info,
+	.proc_fops			= &mptscsih_proc_fops,
 	.name				= "MPT SPI Host",
 	.info				= mptscsih_info,
 	.queuecommand			= mptsas_qcmd,
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -53,6 +53,7 @@
 #include <linux/delay.h>	/* for mdelay */
 #include <linux/interrupt.h>	/* needed for in_interrupt() proto */
 #include <linux/reboot.h>	/* notifier code */
+#include <linux/seq_file.h>
 #include <linux/workqueue.h>
 
 #include <scsi/scsi.h>
@@ -1185,102 +1186,32 @@ mptscsih_info(struct Scsi_Host *SChost)
 	return h->info_kbuf;
 }
 
-struct info_str {
-	char *buffer;
-	int   length;
-	int   offset;
-	int   pos;
-};
-
-static void
-mptscsih_copy_mem_info(struct info_str *info, char *data, int len)
+static int mptscsih_proc_show(struct seq_file *m, void *v)
 {
-	if (info->pos + len > info->length)
-		len = info->length - info->pos;
-
-	if (info->pos + len < info->offset) {
-		info->pos += len;
-		return;
-	}
-
-	if (info->pos < info->offset) {
-	        data += (info->offset - info->pos);
-	        len  -= (info->offset - info->pos);
-	}
+	struct Scsi_Host *host = m->private;
+	MPT_SCSI_HOST	*hd = shost_priv(host);
+	MPT_ADAPTER	*ioc = hd->ioc;
 
-	if (len > 0) {
-                memcpy(info->buffer + info->pos, data, len);
-                info->pos += len;
-	}
+	seq_printf(m, "%s: %s, ", ioc->name, ioc->prod_name);
+	seq_printf(m, "%s%08xh, ", MPT_FW_REV_MAGIC_ID_STRING, ioc->facts.FWVersion.Word);
+	seq_printf(m, "Ports=%d, ", ioc->facts.NumberOfPorts);
+	seq_printf(m, "MaxQ=%d\n", ioc->req_depth);
+	return 0;
 }
 
-static int
-mptscsih_copy_info(struct info_str *info, char *fmt, ...)
+static int mptscsih_proc_open(struct inode *inode, struct file *file)
 {
-	va_list args;
-	char buf[81];
-	int len;
-
-	va_start(args, fmt);
-	len = vsprintf(buf, fmt, args);
-	va_end(args);
-
-	mptscsih_copy_mem_info(info, buf, len);
-	return len;
+	return single_open(file, mptscsih_proc_show, PDE(inode)->data);
 }
 
-static int
-mptscsih_host_info(MPT_ADAPTER *ioc, char *pbuf, off_t offset, int len)
-{
-	struct info_str info;
-
-	info.buffer	= pbuf;
-	info.length	= len;
-	info.offset	= offset;
-	info.pos	= 0;
-
-	mptscsih_copy_info(&info, "%s: %s, ", ioc->name, ioc->prod_name);
-	mptscsih_copy_info(&info, "%s%08xh, ", MPT_FW_REV_MAGIC_ID_STRING, ioc->facts.FWVersion.Word);
-	mptscsih_copy_info(&info, "Ports=%d, ", ioc->facts.NumberOfPorts);
-	mptscsih_copy_info(&info, "MaxQ=%d\n", ioc->req_depth);
-
-	return ((info.pos > info.offset) ? info.pos - info.offset : 0);
-}
-
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/**
- *	mptscsih_proc_info - Return information about MPT adapter
- * 	@host:   scsi host struct
- * 	@buffer: if write, user data; if read, buffer for user
- *	@start: returns the buffer address
- * 	@offset: if write, 0; if read, the current offset into the buffer from
- * 		 the previous read.
- * 	@length: if write, return length;
- *	@func:   write = 1; read = 0
- *
- *	(linux scsi_host_template.info routine)
- */
-int
-mptscsih_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset,
-			int length, int func)
-{
-	MPT_SCSI_HOST	*hd = shost_priv(host);
-	MPT_ADAPTER	*ioc = hd->ioc;
-	int size = 0;
-
-	if (func) {
-		/*
-		 * write is not supported
-		 */
-	} else {
-		if (start)
-			*start = buffer;
-
-		size = mptscsih_host_info(ioc, buffer, offset, length);
-	}
-
-	return size;
-}
+const struct file_operations mptscsih_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= mptscsih_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+EXPORT_SYMBOL(mptscsih_proc_fops);
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 #define ADD_INDEX_LOG(req_ent)	do { } while(0)
@@ -3215,7 +3146,6 @@ EXPORT_SYMBOL(mptscsih_shutdown);
 EXPORT_SYMBOL(mptscsih_suspend);
 EXPORT_SYMBOL(mptscsih_resume);
 #endif
-EXPORT_SYMBOL(mptscsih_proc_info);
 EXPORT_SYMBOL(mptscsih_info);
 EXPORT_SYMBOL(mptscsih_qcmd);
 EXPORT_SYMBOL(mptscsih_slave_destroy);
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -111,7 +111,7 @@ extern void mptscsih_shutdown(struct pci_dev *);
 extern int mptscsih_suspend(struct pci_dev *pdev, pm_message_t state);
 extern int mptscsih_resume(struct pci_dev *pdev);
 #endif
-extern int mptscsih_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset, int length, int func);
+extern const struct file_operations mptscsih_proc_fops;
 extern const char * mptscsih_info(struct Scsi_Host *SChost);
 extern int mptscsih_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *));
 extern int mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel,
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -823,7 +823,7 @@ static void mptspi_slave_destroy(struct scsi_device *sdev)
 static struct scsi_host_template mptspi_driver_template = {
 	.module				= THIS_MODULE,
 	.proc_name			= "mptspi",
-	.proc_info			= mptscsih_proc_info,
+	.proc_fops			= &mptscsih_proc_fops,
 	.name				= "MPT SPI Host",
 	.info				= mptscsih_info,
 	.queuecommand			= mptspi_qcmd,
-- 
1.6.5.2

