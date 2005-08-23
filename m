From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] scsi: /proc/scsi/scsi patch for large number of devices
Date: Tue, 23 Aug 2005 09:40:40 -0700
Message-ID: <1124815241.22518.11.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:42467 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1750864AbVHWQkn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Aug 2005 12:40:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>


I'm not sure if people care about /proc/scsi, but here is a patch so you
can cat /proc/scsi/scsi when you have a large number of scsi devices.  I
have over 4000 devices configured and when I would cat /proc/scsi/scsi I
would see a memory allocation error.  I instead used the seq_file
iterator to display the devices.  The patch is a little brute force, but
it only took about 2.5 seconds to display 4000 devices.

Applies to scsi-misc-2.6 git tree

Signed-off-by: Mark Haverkamp <markh@osdl.org>

Index: scsi-misc-aac-2/drivers/scsi/scsi_proc.c
===================================================================
--- scsi-misc-aac-2.orig/drivers/scsi/scsi_proc.c	2005-08-22 11:53:41.000000000 -0700
+++ scsi-misc-aac-2/drivers/scsi/scsi_proc.c	2005-08-23 08:45:09.000000000 -0700
@@ -43,6 +43,10 @@
 /* Protect sht->present and sht->proc_dir */
 static DECLARE_MUTEX(global_host_template_sem);
 
+static struct device *proc_dev;
+static loff_t dev_skip;
+static DECLARE_MUTEX(proc_dev_sem);
+
 static int proc_scsi_read(char *buffer, char **start, off_t offset,
 			  int length, int *eof, void *data)
 {
@@ -142,53 +146,6 @@
 	remove_proc_entry(name, shost->hostt->proc_dir);
 }
 
-static int proc_print_scsidevice(struct device *dev, void *data)
-{
-	struct scsi_device *sdev = to_scsi_device(dev);
-	struct seq_file *s = data;
-	int i;
-
-	seq_printf(s,
-		"Host: scsi%d Channel: %02d Id: %02d Lun: %02d\n  Vendor: ",
-		sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
-	for (i = 0; i < 8; i++) {
-		if (sdev->vendor[i] >= 0x20)
-			seq_printf(s, "%c", sdev->vendor[i]);
-		else
-			seq_printf(s, " ");
-	}
-
-	seq_printf(s, " Model: ");
-	for (i = 0; i < 16; i++) {
-		if (sdev->model[i] >= 0x20)
-			seq_printf(s, "%c", sdev->model[i]);
-		else
-			seq_printf(s, " ");
-	}
-
-	seq_printf(s, " Rev: ");
-	for (i = 0; i < 4; i++) {
-		if (sdev->rev[i] >= 0x20)
-			seq_printf(s, "%c", sdev->rev[i]);
-		else
-			seq_printf(s, " ");
-	}
-
-	seq_printf(s, "\n");
-
-	seq_printf(s, "  Type:   %s ",
-		     sdev->type < MAX_SCSI_DEVICE_CODE ?
-	       scsi_device_types[(int) sdev->type] : "Unknown          ");
-	seq_printf(s, "               ANSI"
-		     " SCSI revision: %02x", (sdev->scsi_level - 1) ?
-		     sdev->scsi_level - 1 : 1);
-	if (sdev->scsi_level == 2)
-		seq_printf(s, " CCS\n");
-	else
-		seq_printf(s, "\n");
-
-	return 0;
-}
 
 static int scsi_add_single_device(uint host, uint channel, uint id, uint lun)
 {
@@ -284,20 +241,101 @@
 	return err;
 }
 
-static int proc_scsi_show(struct seq_file *s, void *p)
+
+static int proc_set_scsidevice(struct device *dev, void *data)
+{
+	if (dev_skip--)
+		return 0;
+
+	proc_dev = dev;
+	return -ENXIO;
+}
+
+static void *proc_dev_start(struct seq_file *s, loff_t *pos)
 {
-	seq_printf(s, "Attached devices:\n");
-	bus_for_each_dev(&scsi_bus_type, NULL, s, proc_print_scsidevice);
+	down(&proc_dev_sem);
+	proc_dev = NULL;
+	dev_skip = *pos;
+	bus_for_each_dev(&scsi_bus_type, NULL,
+			NULL, proc_set_scsidevice);
+	return proc_dev;
+}
+
+static void *proc_dev_next(struct seq_file *part, void *v, loff_t *pos)
+{
+	dev_skip = ++*pos;
+	proc_dev = NULL;
+	bus_for_each_dev(&scsi_bus_type, NULL,
+			NULL, proc_set_scsidevice);
+	return proc_dev;
+}
+
+static void proc_dev_stop(struct seq_file *part, void *v)
+{
+	up(&proc_dev_sem);
+}
+
+static int proc_dev_show(struct seq_file *s, void *data)
+{
+	struct scsi_device *sdev = to_scsi_device((struct device*)data);
+	int i;
+
+	seq_printf(s,
+		"Host: scsi%d Channel: %02d Id: %02d Lun: %02d\n  Vendor: ",
+		sdev->host->host_no, sdev->channel,
+		sdev->id, sdev->lun);
+	for (i = 0; i < 8; i++) {
+		if (sdev->vendor[i] >= 0x20)
+			seq_printf(s, "%c", sdev->vendor[i]);
+		else
+			seq_printf(s, " ");
+	}
+
+	seq_printf(s, " Model: ");
+	for (i = 0; i < 16; i++) {
+		if (sdev->model[i] >= 0x20)
+			seq_printf(s, "%c", sdev->model[i]);
+		else
+			seq_printf(s, " ");
+	}
+
+	seq_printf(s, " Rev: ");
+	for (i = 0; i < 4; i++) {
+		if (sdev->rev[i] >= 0x20)
+			seq_printf(s, "%c", sdev->rev[i]);
+		else
+			seq_printf(s, " ");
+	}
+
+	seq_printf(s, "\n");
+
+	seq_printf(s, "  Type:   %s ",
+		     sdev->type < MAX_SCSI_DEVICE_CODE ?
+	       scsi_device_types[(int) sdev->type] : "Unknown          ");
+	seq_printf(s, "               ANSI"
+		     " SCSI revision: %02x", (sdev->scsi_level - 1) ?
+		     sdev->scsi_level - 1 : 1);
+	if (sdev->scsi_level == 2)
+		seq_printf(s, " CCS\n");
+	else
+		seq_printf(s, "\n");
+
 	return 0;
 }
 
+struct seq_operations proc_dev_op = {
+	.start =proc_dev_start,
+	.next =	proc_dev_next,
+	.stop =	proc_dev_stop,
+	.show =	proc_dev_show
+};
 static int proc_scsi_open(struct inode *inode, struct file *file)
 {
 	/*
 	 * We don't really needs this for the write case but it doesn't
 	 * harm either.
 	 */
-	return single_open(file, proc_scsi_show, NULL);
+	return seq_open(file, &proc_dev_op);
 }
 
 static struct file_operations proc_scsi_operations = {
@@ -305,7 +343,7 @@
 	.read		= seq_read,
 	.write		= proc_scsi_write,
 	.llseek		= seq_lseek,
-	.release	= single_release,
+	.release	= seq_release
 };
 
 int __init scsi_init_procfs(void)

-- 
Mark Haverkamp <markh@osdl.org>

