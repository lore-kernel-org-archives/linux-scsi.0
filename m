From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] switch /proc/scsi/scsi to seq_file and proper device model lists
Date: Tue, 27 May 2003 13:54:54 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030527115454.GA14043@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:43696 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S263315AbTE0Lln (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 May 2003 07:41:43 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org


--- 1.10/drivers/scsi/scsi_priv.h	Mon May 26 15:38:16 2003
+++ edited/drivers/scsi/scsi_priv.h	Mon May 26 15:41:07 2003
@@ -130,5 +130,6 @@
 extern struct device_attribute *scsi_sysfs_sdev_attrs[];
 
 extern struct class shost_class;
+extern struct bus_type scsi_bus_type;
 
 #endif /* _SCSI_PRIV_H */
--- 1.24/drivers/scsi/scsi_proc.c	Mon May 26 15:38:16 2003
+++ edited/drivers/scsi/scsi_proc.c	Mon May 26 16:04:01 2003
@@ -24,6 +24,7 @@
 #include <linux/proc_fs.h>
 #include <linux/errno.h>
 #include <linux/blk.h>
+#include <linux/seq_file.h>
 #include <asm/uaccess.h>
 
 #include "scsi.h"
@@ -86,7 +87,7 @@
 	return n;
 }
 
-static int proc_scsi_write(struct file *file, const char *buf,
+static int proc_scsi_write_proc(struct file *file, const char *buf,
                            unsigned long count, void *data)
 {
 	struct Scsi_Host *shost = data;
@@ -137,7 +138,7 @@
 		return;
 	} 
 
-	p->write_proc = proc_scsi_write;
+	p->write_proc = proc_scsi_write_proc;
 	p->owner = shost->hostt->module;
 
 }
@@ -152,96 +153,52 @@
 		remove_proc_entry(shost->hostt->proc_name, proc_scsi);
 }
 
-static void proc_print_scsidevice(struct scsi_device* sdev, char *buffer,
-				  int *size, int len)
+static int proc_print_scsidevice(struct device *dev, void *data)
 {
-
-	int x, y = *size;
-	extern const char *const scsi_device_types[MAX_SCSI_DEVICE_CODE];
-
-	y = sprintf(buffer + len,
-	     "Host: scsi%d Channel: %02d Id: %02d Lun: %02d\n  Vendor: ",
-		    sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
-	for (x = 0; x < 8; x++) {
-		if (sdev->vendor[x] >= 0x20)
-			y += sprintf(buffer + len + y, "%c", sdev->vendor[x]);
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct seq_file *s = data;
+	int i;
+
+	seq_printf(s,
+		"Host: scsi%d Channel: %02d Id: %02d Lun: %02d\n  Vendor: ",
+		sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
+	for (i = 0; i < 8; i++) {
+		if (sdev->vendor[i] >= 0x20)
+			seq_printf(s, "%c", sdev->vendor[i]);
 		else
-			y += sprintf(buffer + len + y, " ");
+			seq_printf(s, " ");
 	}
-	y += sprintf(buffer + len + y, " Model: ");
-	for (x = 0; x < 16; x++) {
-		if (sdev->model[x] >= 0x20)
-			y += sprintf(buffer + len + y, "%c", sdev->model[x]);
+
+	seq_printf(s, " Model: ");
+	for (i = 0; i < 16; i++) {
+		if (sdev->model[i] >= 0x20)
+			seq_printf(s, "%c", sdev->model[i]);
 		else
-			y += sprintf(buffer + len + y, " ");
+			seq_printf(s, " ");
 	}
-	y += sprintf(buffer + len + y, " Rev: ");
-	for (x = 0; x < 4; x++) {
-		if (sdev->rev[x] >= 0x20)
-			y += sprintf(buffer + len + y, "%c", sdev->rev[x]);
+
+	seq_printf(s, " Rev: ");
+	for (i = 0; i < 4; i++) {
+		if (sdev->rev[i] >= 0x20)
+			seq_printf(s, "%c", sdev->rev[i]);
 		else
-			y += sprintf(buffer + len + y, " ");
+			seq_printf(s, " ");
 	}
-	y += sprintf(buffer + len + y, "\n");
 
-	y += sprintf(buffer + len + y, "  Type:   %s ",
+	seq_printf(s, "\n");
+
+	seq_printf(s, "  Type:   %s ",
 		     sdev->type < MAX_SCSI_DEVICE_CODE ?
 	       scsi_device_types[(int) sdev->type] : "Unknown          ");
-	y += sprintf(buffer + len + y, "               ANSI"
+	seq_printf(s, "               ANSI"
 		     " SCSI revision: %02x", (sdev->scsi_level - 1) ?
 		     sdev->scsi_level - 1 : 1);
 	if (sdev->scsi_level == 2)
-		y += sprintf(buffer + len + y, " CCS\n");
+		seq_printf(s, " CCS\n");
 	else
-		y += sprintf(buffer + len + y, "\n");
+		seq_printf(s, "\n");
 
-	*size = y;
-	return;
-}
-
-static int scsi_proc_info(char *buffer, char **start, off_t offset, int length)
-{
-	struct Scsi_Host *shost;
-	Scsi_Device *sdev;
-	int size, len = 0;
-	off_t begin = 0;
-	off_t pos = 0;
-
-	/*
-	 * First, see if there are any attached devices or not.
-	 */
-	for (shost = scsi_host_get_next(NULL); shost;
-	     shost = scsi_host_get_next(shost)) {
-		if (!list_empty(&shost->my_devices)) {
-			break;
-		}
-	}
-	size = sprintf(buffer + len, "Attached devices: %s\n",
-			(shost) ? "" : "none");
-	len += size;
-	pos = begin + len;
-	for (shost = scsi_host_get_next(NULL); shost;
-	     shost = scsi_host_get_next(shost)) {
-		list_for_each_entry(sdev, &shost->my_devices, siblings) {
-			proc_print_scsidevice(sdev, buffer, &size, len);
-			len += size;
-			pos = begin + len;
-
-			if (pos < offset) {
-				len = 0;
-				begin = pos;
-			}
-			if (pos > offset + length)
-				goto stop_output;
-		}
-	}
-
-stop_output:
-	*start = buffer + (offset - begin);	/* Start of wanted data */
-	len -= (offset - begin);	/* Start slop */
-	if (len > length)
-		len = length;	/* Ending slop */
-	return (len);
+	return 0;
 }
 
 static int scsi_add_single_device(uint host, uint channel, uint id, uint lun)
@@ -287,8 +244,8 @@
 	return error;
 }
 
-static int proc_scsi_gen_write(struct file * file, const char * buf,
-                              unsigned long length, void *data)
+static int proc_scsi_write(struct file *file, const char* buf,
+                           size_t length, loff_t *ppos)
 {
 	int host, channel, id, lun;
 	char *buffer, *p;
@@ -431,6 +388,30 @@
 	return err;
 }
 
+static int proc_scsi_show(struct seq_file *s, void *p)
+{
+	seq_printf(s, "Attached devices:\n");
+	bus_for_each_dev(&scsi_bus_type, NULL, s, proc_print_scsidevice);
+	return 0;
+}
+
+static int proc_scsi_open(struct inode *inode, struct file *file)
+{
+	/*
+	 * We don't really needs this for the write case but it doesn't
+	 * harm either.
+	 */
+	return single_open(file, proc_scsi_show, NULL);
+}
+
+static struct file_operations proc_scsi_operations = {
+	.open		= proc_scsi_open,
+	.read		= seq_read,
+	.write		= proc_scsi_write,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 int __init scsi_init_procfs(void)
 {
 	struct proc_dir_entry *pde;
@@ -439,10 +420,10 @@
 	if (!proc_scsi)
 		goto err1;
 
-	pde = create_proc_info_entry("scsi/scsi", 0, 0, scsi_proc_info);
+	pde = create_proc_entry("scsi/scsi", 0, NULL);
 	if (!pde)
 		goto err2;
-	pde->write_proc = proc_scsi_gen_write;
+	pde->proc_fops = &proc_scsi_operations;
 
 	return 0;
 
--- 1.20/drivers/scsi/scsi_sysfs.c	Mon May 26 15:38:16 2003
+++ edited/drivers/scsi/scsi_sysfs.c	Mon May 26 15:45:44 2003
@@ -68,7 +68,7 @@
 	return 1;
 }
 
-static struct bus_type scsi_bus_type = {
+struct bus_type scsi_bus_type = {
         .name		= "scsi",
         .match		= scsi_bus_match,
 };
