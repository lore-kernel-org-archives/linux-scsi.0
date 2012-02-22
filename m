From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 32/34] scsi proc_ops: convert drivers/scsi/arm/ drivers
Date: Wed, 22 Feb 2012 22:46:23 +0300
Message-ID: <1329939985-26793-32-git-send-email-adobriyan@gmail.com>
References: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44011 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483Ab2BVTrb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2012 14:47:31 -0500
Received: by mail-bk0-f46.google.com with SMTP id jm19so433831bkc.19
        for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2012 11:47:30 -0800 (PST)
In-Reply-To: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/scsi/arm/acornscsi.c |   70 +++++++++++--------------
 drivers/scsi/arm/arxescsi.c  |   55 +++++++-------------
 drivers/scsi/arm/cumana_2.c  |  117 +++++++++++++++++++-----------------------
 drivers/scsi/arm/eesox.c     |  117 +++++++++++++++++++-----------------------
 drivers/scsi/arm/fas216.c    |   31 ++++-------
 drivers/scsi/arm/fas216.h    |    6 +-
 drivers/scsi/arm/powertec.c  |  116 +++++++++++++++++++-----------------------
 7 files changed, 221 insertions(+), 291 deletions(-)

diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index c454e44..78a57ed 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -135,6 +135,7 @@
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/bitops.h>
+#include <linux/seq_file.h>
 #include <linux/stringify.h>
 #include <linux/io.h>
 
@@ -2837,20 +2838,16 @@ char *acornscsi_info(struct Scsi_Host *host)
     return string;
 }
 
-int acornscsi_proc_info(struct Scsi_Host *instance, char *buffer, char **start, off_t offset,
-			int length, int inout)
+static int acornscsi_proc_show(struct seq_file *m, void *v)
 {
-    int pos, begin = 0, devidx;
+	struct Scsi_Host *instance = m->private;
+    int devidx;
     struct scsi_device *scd;
     AS_Host *host;
-    char *p = buffer;
-
-    if (inout == 1)
-	return -EINVAL;
 
     host  = (AS_Host *)instance->hostdata;
     
-    p += sprintf(p, "AcornSCSI driver v%d.%d.%d"
+    seq_printf(m, "AcornSCSI driver v%d.%d.%d"
 #ifdef CONFIG_SCSI_ACORNSCSI_SYNC
     " SYNC"
 #endif
@@ -2865,14 +2862,14 @@ int acornscsi_proc_info(struct Scsi_Host *instance, char *buffer, char **start,
 #endif
 		"\n\n", VER_MAJOR, VER_MINOR, VER_PATCH);
 
-    p += sprintf(p,	"SBIC: WD33C93A  Address: %p    IRQ : %d\n",
+    seq_printf(m,	"SBIC: WD33C93A  Address: %p    IRQ : %d\n",
 			host->base + SBIC_REGIDX, host->scsi.irq);
 #ifdef USE_DMAC
-    p += sprintf(p,	"DMAC: uPC71071  Address: %p  IRQ : %d\n\n",
+    seq_printf(m,	"DMAC: uPC71071  Address: %p  IRQ : %d\n\n",
 			host->base + DMAC_OFFSET, host->scsi.irq);
 #endif
 
-    p += sprintf(p,	"Statistics:\n"
+    seq_printf(m,	"Statistics:\n"
 			"Queued commands: %-10u    Issued commands: %-10u\n"
 			"Done commands  : %-10u    Reads          : %-10u\n"
 			"Writes         : %-10u    Others         : %-10u\n"
@@ -2887,7 +2884,7 @@ int acornscsi_proc_info(struct Scsi_Host *instance, char *buffer, char **start,
     for (devidx = 0; devidx < 9; devidx ++) {
 	unsigned int statptr, prev;
 
-	p += sprintf(p, "\n%c:", devidx == 8 ? 'H' : ('0' + devidx));
+	seq_printf(m, "\n%c:", devidx == 8 ? 'H' : ('0' + devidx));
 	statptr = host->status_ptr[devidx] - 10;
 
 	if ((signed int)statptr < 0)
@@ -2897,7 +2894,7 @@ int acornscsi_proc_info(struct Scsi_Host *instance, char *buffer, char **start,
 
 	for (; statptr != host->status_ptr[devidx]; statptr = (statptr + 1) & (STATUS_BUFFER_SIZE - 1)) {
 	    if (host->status[devidx][statptr].when) {
-		p += sprintf(p, "%c%02X:%02X+%2ld",
+		seq_printf(m, "%c%02X:%02X+%2ld",
 			host->status[devidx][statptr].irq ? '-' : ' ',
 			host->status[devidx][statptr].ph,
 			host->status[devidx][statptr].ssr,
@@ -2908,51 +2905,44 @@ int acornscsi_proc_info(struct Scsi_Host *instance, char *buffer, char **start,
 	}
     }
 
-    p += sprintf(p, "\nAttached devices:\n");
+    seq_printf(m, "\nAttached devices:\n");
 
     shost_for_each_device(scd, instance) {
-	p += sprintf(p, "Device/Lun TaggedQ      Sync\n");
-	p += sprintf(p, "     %d/%d   ", scd->id, scd->lun);
+	seq_printf(m, "Device/Lun TaggedQ      Sync\n");
+	seq_printf(m, "     %d/%d   ", scd->id, scd->lun);
 	if (scd->tagged_supported)
-		p += sprintf(p, "%3sabled(%3d) ",
+		seq_printf(m, "%3sabled(%3d) ",
 			     scd->simple_tags ? "en" : "dis",
 			     scd->current_tag);
 	else
-		p += sprintf(p, "unsupported  ");
+		seq_printf(m, "unsupported  ");
 
 	if (host->device[scd->id].sync_xfer & 15)
-		p += sprintf(p, "offset %d, %d ns\n",
+		seq_printf(m, "offset %d, %d ns\n",
 			     host->device[scd->id].sync_xfer & 15,
 			     acornscsi_getperiod(host->device[scd->id].sync_xfer));
 	else
-		p += sprintf(p, "async\n");
-
-	pos = p - buffer;
-	if (pos + begin < offset) {
-	    begin += pos;
-	    p = buffer;
-	}
-	pos = p - buffer;
-	if (pos + begin > offset + length) {
-	    scsi_device_put(scd);
-	    break;
-	}
+		seq_printf(m, "async\n");
     }
 
-    pos = p - buffer;
-
-    *start = buffer + (offset - begin);
-    pos -= offset - begin;
-
-    if (pos > length)
-	pos = length;
+    return 0;
+}
 
-    return pos;
+static int acornscsi_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, acornscsi_proc_show, PDE(inode)->data);
 }
 
+static const struct file_operations acornscsi_proc_ops = {
+	.open		= acornscsi_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static struct scsi_host_template acornscsi_template = {
 	.module			= THIS_MODULE,
-	.proc_info		= acornscsi_proc_info,
+	.proc_ops		= &acornscsi_proc_ops,
 	.name			= "AcornSCSI",
 	.info			= acornscsi_info,
 	.queuecommand		= acornscsi_queuecmd,
diff --git a/drivers/scsi/arm/arxescsi.c b/drivers/scsi/arm/arxescsi.c
index a750aa7..5f016b1 100644
--- a/drivers/scsi/arm/arxescsi.c
+++ b/drivers/scsi/arm/arxescsi.c
@@ -220,47 +220,32 @@ static const char *arxescsi_info(struct Scsi_Host *host)
 	return string;
 }
 
-/*
- * Function: int arxescsi_proc_info(char *buffer, char **start, off_t offset,
- *					 int length, int host_no, int inout)
- * Purpose : Return information about the driver to a user process accessing
- *	     the /proc filesystem.
- * Params  : buffer - a buffer to write information to
- *	     start  - a pointer into this buffer set by this routine to the start
- *		      of the required information.
- *	     offset - offset into information that we have read up to.
- *	     length - length of buffer
- *	     host_no - host number to return information for
- *	     inout  - 0 for reading, 1 for writing.
- * Returns : length of data written to buffer.
- */
-static int
-arxescsi_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset, int length,
-		   int inout)
+static int arxescsi_proc_show(struct seq_file *m, void *v)
 {
-	struct arxescsi_info *info;
-	char *p = buffer;
-	int pos;
-
-	info = (struct arxescsi_info *)host->hostdata;
-	if (inout == 1)
-		return -EINVAL;
-
-	p += sprintf(p, "ARXE 16-bit SCSI driver v%s\n", VERSION);
-	p += fas216_print_host(&info->info, p);
-	p += fas216_print_stats(&info->info, p);
-	p += fas216_print_devices(&info->info, p);
+	struct Scsi_Host *host = m->private;
+	struct arxescsi_info *info = (struct arxescsi_info *)host->hostdata;
 
-	*start = buffer + offset;
-	pos = p - buffer - offset;
-	if (pos > length)
-		pos = length;
+	seq_printf(m, "ARXE 16-bit SCSI driver v%s\n", VERSION);
+	fas216_print_host(&info->info, m);
+	fas216_print_stats(&info->info, m);
+	fas216_print_devices(&info->info, m);
+	return 0;
+}
 
-	return pos;
+static int arxescsi_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, arxescsi_proc_show, PDE(inode)->data);
 }
 
+static const struct file_operations arxescsi_proc_ops = {
+	.open		= arxescsi_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static struct scsi_host_template arxescsi_template = {
-	.proc_info			= arxescsi_proc_info,
+	.proc_ops			= &arxescsi_proc_ops,
 	.name				= "ARXE SCSI card",
 	.info				= arxescsi_info,
 	.queuecommand			= fas216_noqueue_command,
diff --git a/drivers/scsi/arm/cumana_2.c b/drivers/scsi/arm/cumana_2.c
index 547987b..d986cbf 100644
--- a/drivers/scsi/arm/cumana_2.c
+++ b/drivers/scsi/arm/cumana_2.c
@@ -306,81 +306,68 @@ const char *cumanascsi_2_info(struct Scsi_Host *host)
 	return string;
 }
 
-/* Prototype: int cumanascsi_2_set_proc_info(struct Scsi_Host *host, char *buffer, int length)
- * Purpose  : Set a driver specific function
- * Params   : host   - host to setup
- *          : buffer - buffer containing string describing operation
- *          : length - length of string
- * Returns  : -EINVAL, or 0
- */
-static int
-cumanascsi_2_set_proc_info(struct Scsi_Host *host, char *buffer, int length)
-{
-	int ret = length;
-
-	if (length >= 11 && strncmp(buffer, "CUMANASCSI2", 11) == 0) {
-		buffer += 11;
-		length -= 11;
-
-		if (length >= 5 && strncmp(buffer, "term=", 5) == 0) {
-			if (buffer[5] == '1')
-				cumanascsi_2_terminator_ctl(host, 1);
-			else if (buffer[5] == '0')
-				cumanascsi_2_terminator_ctl(host, 0);
-			else
-				ret = -EINVAL;
-		} else
-			ret = -EINVAL;
-	} else
-		ret = -EINVAL;
-
-	return ret;
-}
-
-/* Prototype: int cumanascsi_2_proc_info(char *buffer, char **start, off_t offset,
- *					 int length, int host_no, int inout)
- * Purpose  : Return information about the driver to a user process accessing
- *	      the /proc filesystem.
- * Params   : buffer - a buffer to write information to
- *	      start  - a pointer into this buffer set by this routine to the start
- *		       of the required information.
- *	      offset - offset into information that we have read up to.
- *	      length - length of buffer
- *	      host_no - host number to return information for
- *	      inout  - 0 for reading, 1 for writing.
- * Returns  : length of data written to buffer.
- */
-int cumanascsi_2_proc_info (struct Scsi_Host *host, char *buffer, char **start, off_t offset,
-			    int length, int inout)
+static int cumanascsi_2_proc_show(struct seq_file *m, void *v)
 {
-	struct cumanascsi2_info *info;
-	char *p = buffer;
-	int pos;
-
-	if (inout == 1)
-		return cumanascsi_2_set_proc_info(host, buffer, length);
-
-	info = (struct cumanascsi2_info *)host->hostdata;
+	struct Scsi_Host *host = m->private;
+	struct cumanascsi2_info *info = (struct cumanascsi2_info *)host->hostdata;
 
-	p += sprintf(p, "Cumana SCSI II driver v%s\n", VERSION);
-	p += fas216_print_host(&info->info, p);
-	p += sprintf(p, "Term    : o%s\n",
+	seq_printf(m, "Cumana SCSI II driver v%s\n", VERSION);
+	fas216_print_host(&info->info, m);
+	seq_printf(m, "Term    : o%s\n",
 			info->terms ? "n" : "ff");
 
-	p += fas216_print_stats(&info->info, p);
-	p += fas216_print_devices(&info->info, p);
+	fas216_print_stats(&info->info, m);
+	fas216_print_devices(&info->info, m);
+	return 0;
+}
 
-	*start = buffer + offset;
-	pos = p - buffer - offset;
-	if (pos > length)
-		pos = length;
+static int cumanascsi_2_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, cumanascsi_2_proc_show, PDE(inode)->data);
+}
 
-	return pos;
+static ssize_t cumanascsi_2_proc_write(struct file *file, const char __user *buf, size_t count, loff_t *pos)
+{
+	struct Scsi_Host *host = PDE(file->f_path.dentry->d_inode)->data;
+	char kbuf[42], *p;
+	size_t len;
+
+	len = min(count, sizeof(kbuf) - 1);
+	if (copy_from_user(kbuf, buf, len))
+		return -EFAULT;
+	kbuf[len] = '\0';
+
+	p = kbuf;
+	if (strncmp(p, "CUMANASCSI2", 11) != 0)
+		return -EINVAL;
+	p += 11;
+	if (strncmp(p, "term=", 5) != 0)
+		return -EINVAL;
+	p += 5;
+	switch (*p) {
+	case '0':
+		cumanascsi_2_terminator_ctl(host, 0);
+		break;
+	case '1':
+		cumanascsi_2_terminator_ctl(host, 1);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return count;
 }
 
+static const struct file_operations cumanascsi_2_proc_ops = {
+	.open		= cumanascsi_2_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= cumanascsi_2_proc_write,
+};
+
 static struct scsi_host_template cumanascsi2_template = {
 	.module				= THIS_MODULE,
-	.proc_info			= cumanascsi_2_proc_info,
+	.proc_ops			= &cumanascsi_2_proc_ops,
 	.name				= "Cumana SCSI II",
 	.info				= cumanascsi_2_info,
 	.queuecommand			= fas216_queue_command,
diff --git a/drivers/scsi/arm/eesox.c b/drivers/scsi/arm/eesox.c
index edfd12b..468e686 100644
--- a/drivers/scsi/arm/eesox.c
+++ b/drivers/scsi/arm/eesox.c
@@ -391,78 +391,65 @@ const char *eesoxscsi_info(struct Scsi_Host *host)
 	return string;
 }
 
-/* Prototype: int eesoxscsi_set_proc_info(struct Scsi_Host *host, char *buffer, int length)
- * Purpose  : Set a driver specific function
- * Params   : host   - host to setup
- *          : buffer - buffer containing string describing operation
- *          : length - length of string
- * Returns  : -EINVAL, or 0
- */
-static int
-eesoxscsi_set_proc_info(struct Scsi_Host *host, char *buffer, int length)
-{
-	int ret = length;
-
-	if (length >= 9 && strncmp(buffer, "EESOXSCSI", 9) == 0) {
-		buffer += 9;
-		length -= 9;
-
-		if (length >= 5 && strncmp(buffer, "term=", 5) == 0) {
-			if (buffer[5] == '1')
-				eesoxscsi_terminator_ctl(host, 1);
-			else if (buffer[5] == '0')
-				eesoxscsi_terminator_ctl(host, 0);
-			else
-				ret = -EINVAL;
-		} else
-			ret = -EINVAL;
-	} else
-		ret = -EINVAL;
-
-	return ret;
-}
-
-/* Prototype: int eesoxscsi_proc_info(char *buffer, char **start, off_t offset,
- *				      int length, int host_no, int inout)
- * Purpose  : Return information about the driver to a user process accessing
- *	      the /proc filesystem.
- * Params   : buffer - a buffer to write information to
- *	      start  - a pointer into this buffer set by this routine to the start
- *		       of the required information.
- *	      offset - offset into information that we have read up to.
- *	      length - length of buffer
- *	      host_no - host number to return information for
- *	      inout  - 0 for reading, 1 for writing.
- * Returns  : length of data written to buffer.
- */
-int eesoxscsi_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset,
-			    int length, int inout)
+static int eesoxscsi_proc_show(struct seq_file *m, void *v)
 {
-	struct eesoxscsi_info *info;
-	char *p = buffer;
-	int pos;
-
-	if (inout == 1)
-		return eesoxscsi_set_proc_info(host, buffer, length);
-
-	info = (struct eesoxscsi_info *)host->hostdata;
+	struct Scsi_Host *host = m->private;
+	struct eesoxscsi_info *info = (struct eesoxscsi_info *)host->hostdata;
 
-	p += sprintf(p, "EESOX SCSI driver v%s\n", VERSION);
-	p += fas216_print_host(&info->info, p);
-	p += sprintf(p, "Term    : o%s\n",
+	seq_printf(m, "EESOX SCSI driver v%s\n", VERSION);
+	fas216_print_host(&info->info, m);
+	seq_printf(m, "Term    : o%s\n",
 			info->control & EESOX_TERM_ENABLE ? "n" : "ff");
 
-	p += fas216_print_stats(&info->info, p);
-	p += fas216_print_devices(&info->info, p);
+	fas216_print_stats(&info->info, m);
+	fas216_print_devices(&info->info, m);
+	return 0;
+}
 
-	*start = buffer + offset;
-	pos = p - buffer - offset;
-	if (pos > length)
-		pos = length;
+static int eesoxscsi_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, eesoxscsi_proc_show, PDE(inode)->data);
+}
 
-	return pos;
+static ssize_t eesoxscsi_proc_write(struct file *file, const char __user *buf, size_t count, loff_t *pos)
+{
+	struct Scsi_Host *host = PDE(file->f_path.dentry->d_inode)->data;
+	char kbuf[42], *p;
+	size_t len;
+
+	len = min(count, sizeof(kbuf) - 1);
+	if (copy_from_user(kbuf, buf, len))
+		return -EFAULT;
+	kbuf[len] = '\0';
+
+	p = kbuf;
+	if (strncmp(p, "EESOXSCSI", 9) != 0)
+		return -EINVAL;
+	p += 9;
+	if (strncmp(p, "term=", 5) != 0)
+		return -EINVAL;
+	p += 5;
+	switch (*p) {
+	case '0':
+		eesoxscsi_terminator_ctl(host, 0);
+		break;
+	case '1':
+		eesoxscsi_terminator_ctl(host, 1);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return count;
 }
 
+static const struct file_operations eesoxscsi_proc_ops = {
+	.open		= eesoxscsi_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= eesoxscsi_proc_write,
+};
+
 static ssize_t eesoxscsi_show_term(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct expansion_card *ec = ECARD_DEV(dev);
@@ -498,7 +485,7 @@ static DEVICE_ATTR(bus_term, S_IRUGO | S_IWUSR,
 
 static struct scsi_host_template eesox_template = {
 	.module				= THIS_MODULE,
-	.proc_info			= eesoxscsi_proc_info,
+	.proc_ops			= &eesoxscsi_proc_ops,
 	.name				= "EESOX SCSI",
 	.info				= eesoxscsi_info,
 	.queuecommand			= fas216_queue_command,
diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index e85c40b..eb02a11 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -2958,9 +2958,9 @@ void fas216_release(struct Scsi_Host *host)
 	queue_free(&info->queues.issue);
 }
 
-int fas216_print_host(FAS216_Info *info, char *buffer)
+void fas216_print_host(FAS216_Info *info, struct seq_file *m)
 {
-	return sprintf(buffer,
+	seq_printf(m,
 			"\n"
 			"Chip    : %s\n"
 			" Address: 0x%p\n"
@@ -2970,11 +2970,9 @@ int fas216_print_host(FAS216_Info *info, char *buffer)
 			info->scsi.irq, info->scsi.dma);
 }
 
-int fas216_print_stats(FAS216_Info *info, char *buffer)
+void fas216_print_stats(FAS216_Info *info, struct seq_file *m)
 {
-	char *p = buffer;
-
-	p += sprintf(p, "\n"
+	seq_printf(m, "\n"
 			"Command Statistics:\n"
 			" Queued     : %u\n"
 			" Issued     : %u\n"
@@ -2991,38 +2989,33 @@ int fas216_print_stats(FAS216_Info *info, char *buffer)
 			info->stats.writes,	 info->stats.miscs,
 			info->stats.disconnects, info->stats.aborts,
 			info->stats.bus_resets,	 info->stats.host_resets);
-
-	return p - buffer;
 }
 
-int fas216_print_devices(FAS216_Info *info, char *buffer)
+void fas216_print_devices(FAS216_Info *info, struct seq_file *m)
 {
 	struct fas216_device *dev;
 	struct scsi_device *scd;
-	char *p = buffer;
 
-	p += sprintf(p, "Device/Lun TaggedQ       Parity   Sync\n");
+	seq_printf(m, "Device/Lun TaggedQ       Parity   Sync\n");
 
 	shost_for_each_device(scd, info->host) {
 		dev = &info->device[scd->id];
-		p += sprintf(p, "     %d/%d   ", scd->id, scd->lun);
+		seq_printf(m, "     %d/%d   ", scd->id, scd->lun);
 		if (scd->tagged_supported)
-			p += sprintf(p, "%3sabled(%3d) ",
+			seq_printf(m, "%3sabled(%3d) ",
 				     scd->simple_tags ? "en" : "dis",
 				     scd->current_tag);
 		else
-			p += sprintf(p, "unsupported   ");
+			seq_printf(m, "unsupported   ");
 
-		p += sprintf(p, "%3sabled ", dev->parity_enabled ? "en" : "dis");
+		seq_printf(m, "%3sabled ", dev->parity_enabled ? "en" : "dis");
 
 		if (dev->sof)
-			p += sprintf(p, "offset %d, %d ns\n",
+			seq_printf(m, "offset %d, %d ns\n",
 				     dev->sof, dev->period * 4);
 		else
-			p += sprintf(p, "async\n");
+			seq_printf(m, "async\n");
 	}
-
-	return p - buffer;
 }
 
 EXPORT_SYMBOL(fas216_init);
diff --git a/drivers/scsi/arm/fas216.h b/drivers/scsi/arm/fas216.h
index 84b7127..914b4e4 100644
--- a/drivers/scsi/arm/fas216.h
+++ b/drivers/scsi/arm/fas216.h
@@ -362,9 +362,9 @@ extern void fas216_remove (struct Scsi_Host *instance);
  */
 extern void fas216_release (struct Scsi_Host *instance);
 
-extern int fas216_print_host(FAS216_Info *info, char *buffer);
-extern int fas216_print_stats(FAS216_Info *info, char *buffer);
-extern int fas216_print_devices(FAS216_Info *info, char *buffer);
+extern void fas216_print_host(FAS216_Info *info, struct seq_file *m);
+extern void fas216_print_stats(FAS216_Info *info, struct seq_file *m);
+extern void fas216_print_devices(FAS216_Info *info, struct seq_file *m);
 
 /* Function: int fas216_eh_abort(struct scsi_cmnd *SCpnt)
  * Purpose : abort this command
diff --git a/drivers/scsi/arm/powertec.c b/drivers/scsi/arm/powertec.c
index 9274c06..e854fad 100644
--- a/drivers/scsi/arm/powertec.c
+++ b/drivers/scsi/arm/powertec.c
@@ -194,77 +194,65 @@ const char *powertecscsi_info(struct Scsi_Host *host)
 	return string;
 }
 
-/* Prototype: int powertecscsi_set_proc_info(struct Scsi_Host *host, char *buffer, int length)
- * Purpose  : Set a driver specific function
- * Params   : host   - host to setup
- *          : buffer - buffer containing string describing operation
- *          : length - length of string
- * Returns  : -EINVAL, or 0
- */
-static int
-powertecscsi_set_proc_info(struct Scsi_Host *host, char *buffer, int length)
-{
-	int ret = length;
-
-	if (length >= 12 && strncmp(buffer, "POWERTECSCSI", 12) == 0) {
-		buffer += 12;
-		length -= 12;
-
-		if (length >= 5 && strncmp(buffer, "term=", 5) == 0) {
-			if (buffer[5] == '1')
-				powertecscsi_terminator_ctl(host, 1);
-			else if (buffer[5] == '0')
-				powertecscsi_terminator_ctl(host, 0);
-			else
-				ret = -EINVAL;
-		} else
-			ret = -EINVAL;
-	} else
-		ret = -EINVAL;
-
-	return ret;
-}
-
-/* Prototype: int powertecscsi_proc_info(char *buffer, char **start, off_t offset,
- *					int length, int host_no, int inout)
- * Purpose  : Return information about the driver to a user process accessing
- *	      the /proc filesystem.
- * Params   : buffer  - a buffer to write information to
- *	      start   - a pointer into this buffer set by this routine to the start
- *		        of the required information.
- *	      offset  - offset into information that we have read up to.
- *	      length  - length of buffer
- *	      inout   - 0 for reading, 1 for writing.
- * Returns  : length of data written to buffer.
- */
-int powertecscsi_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset,
-			    int length, int inout)
+static int powertecscsi_proc_show(struct seq_file *m, void *v)
 {
-	struct powertec_info *info;
-	char *p = buffer;
-	int pos;
-
-	if (inout == 1)
-		return powertecscsi_set_proc_info(host, buffer, length);
-
-	info = (struct powertec_info *)host->hostdata;
+	struct Scsi_Host *host = m->private;
+	struct powertec_info *info = (struct powertec_info *)host->hostdata;
 
-	p += sprintf(p, "PowerTec SCSI driver v%s\n", VERSION);
-	p += fas216_print_host(&info->info, p);
-	p += sprintf(p, "Term    : o%s\n",
+	seq_printf(m, "PowerTec SCSI driver v%s\n", VERSION);
+	fas216_print_host(&info->info, m);
+	seq_printf(m, "Term    : o%s\n",
 			info->term_ctl ? "n" : "ff");
 
-	p += fas216_print_stats(&info->info, p);
-	p += fas216_print_devices(&info->info, p);
+	fas216_print_stats(&info->info, m);
+	fas216_print_devices(&info->info, m);
+	return 0;
+}
 
-	*start = buffer + offset;
-	pos = p - buffer - offset;
-	if (pos > length)
-		pos = length;
+static int powertecscsi_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, powertecscsi_proc_show, PDE(inode)->data);
+}
 
-	return pos;
+static ssize_t powertecscsi_proc_write(struct file *file, const char __user *buf, size_t count, loff_t *pos)
+{
+	struct Scsi_Host *host = PDE(file->f_path.dentry->d_inode)->data;
+	char kbuf[42], *p;
+	size_t len;
+
+	len = min(count, sizeof(kbuf) - 1);
+	if (copy_from_user(kbuf, buf, len))
+		return -EFAULT;
+	kbuf[len] = '\0';
+
+	p = kbuf;
+	if (strncmp(p, "POWERTECSCSI", 12) != 0)
+		return -EINVAL;
+	p += 12;
+	if (strncmp(p, "term=", 5) != 0)
+		return -EINVAL;
+	p += 5;
+	switch (*p) {
+		case '0':
+			powertecscsi_terminator_ctl(host, 0);
+			break;
+		case '1':
+			powertecscsi_terminator_ctl(host, 1);
+			break;
+		default:
+			return -EINVAL;
+	}
+	return count;
 }
 
+static const struct file_operations powertecscsi_proc_ops = {
+	.open		= powertecscsi_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= powertecscsi_proc_write,
+};
+
 static ssize_t powertecscsi_show_term(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct expansion_card *ec = ECARD_DEV(dev);
@@ -291,7 +279,7 @@ static DEVICE_ATTR(bus_term, S_IRUGO | S_IWUSR,
 
 static struct scsi_host_template powertecscsi_template = {
 	.module				= THIS_MODULE,
-	.proc_info			= powertecscsi_proc_info,
+	.proc_ops			= &powertecscsi_proc_ops,
 	.name				= "PowerTec SCSI",
 	.info				= powertecscsi_info,
 	.queuecommand			= fas216_queue_command,
-- 
1.7.3.4

