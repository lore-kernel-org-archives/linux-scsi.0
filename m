From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 25/34] scsi proc_ops: convert drivers/block/cciss.c
Date: Wed, 22 Feb 2012 22:46:16 +0300
Message-ID: <1329939985-26793-25-git-send-email-adobriyan@gmail.com>
References: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59220 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621Ab2BVTrS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2012 14:47:18 -0500
Received: by mail-bk0-f46.google.com with SMTP id jm19so433763bkc.19
        for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2012 11:47:17 -0800 (PST)
In-Reply-To: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/block/cciss_scsi.c |  123 ++++++++++++++++++++-----------------------
 1 files changed, 57 insertions(+), 66 deletions(-)

diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index e820b68..b55a195 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -54,13 +54,7 @@ static CommandList_struct *cmd_special_alloc(ctlr_info_t *h);
 static void cmd_free(ctlr_info_t *h, CommandList_struct *c);
 static void cmd_special_free(ctlr_info_t *h, CommandList_struct *c);
 
-static int cciss_scsi_proc_info(
-		struct Scsi_Host *sh,
-		char *buffer, /* data buffer */
-		char **start, 	   /* where data in buffer starts */
-		off_t offset,	   /* offset from start of imaginary file */
-		int length, 	   /* length of data in buffer */
-		int func);	   /* 0 == read, 1 == write */
+static const struct file_operations cciss_scsi_proc_ops;
 
 static int cciss_scsi_queue_command (struct Scsi_Host *h,
 				     struct scsi_cmnd *cmd);
@@ -82,7 +76,7 @@ static struct scsi_host_template cciss_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "cciss",
 	.proc_name		= "cciss",
-	.proc_info		= cciss_scsi_proc_info,
+	.proc_ops		= &cciss_scsi_proc_ops,
 	.queuecommand		= cciss_scsi_queue_command,
 	.this_id		= 7,
 	.cmd_per_lun		= 1,
@@ -1287,39 +1281,9 @@ out:
 	return;
 }
 
-static int
-is_keyword(char *ptr, int len, char *verb)  // Thanks to ncr53c8xx.c
-{
-	int verb_len = strlen(verb);
-	if (len >= verb_len && !memcmp(verb,ptr,verb_len))
-		return verb_len;
-	else
-		return 0;
-}
-
-static int
-cciss_scsi_user_command(ctlr_info_t *h, int hostno, char *buffer, int length)
+static int cciss_scsi_proc_show(struct seq_file *m, void *v)
 {
-	int arg_len;
-
-	if ((arg_len = is_keyword(buffer, length, "rescan")) != 0)
-		cciss_update_non_disk_devices(h, hostno);
-	else
-		return -EINVAL;
-	return length;
-}
-
-
-static int
-cciss_scsi_proc_info(struct Scsi_Host *sh,
-		char *buffer, /* data buffer */
-		char **start, 	   /* where data in buffer starts */
-		off_t offset,	   /* offset from start of imaginary file */
-		int length, 	   /* length of data in buffer */
-		int func)	   /* 0 == read, 1 == write */
-{
-
-	int buflen, datalen;
+	struct Scsi_Host *sh = m->private;
 	ctlr_info_t *h;
 	int i;
 
@@ -1327,22 +1291,20 @@ cciss_scsi_proc_info(struct Scsi_Host *sh,
 	if (h == NULL)  /* This really shouldn't ever happen. */
 		return -EINVAL;
 
-	if (func == 0) {	/* User is reading from /proc/scsi/ciss*?/?*  */
-		buflen = sprintf(buffer, "cciss%d: SCSI host: %d\n",
-				h->ctlr, sh->host_no);
-
-		/* this information is needed by apps to know which cciss
-		   device corresponds to which scsi host number without
-		   having to open a scsi target device node.  The device
-		   information is not a duplicate of /proc/scsi/scsi because
-		   the two may be out of sync due to scsi hotplug, rather
-		   this info is for an app to be able to use to know how to
-		   get them back in sync. */
-
-		for (i = 0; i < ccissscsi[h->ctlr].ndevices; i++) {
-			struct cciss_scsi_dev_t *sd =
-				&ccissscsi[h->ctlr].dev[i];
-			buflen += sprintf(&buffer[buflen], "c%db%dt%dl%d %02d "
+	seq_printf(m, "cciss%d: SCSI host: %d\n", h->ctlr, sh->host_no);
+
+	/* this information is needed by apps to know which cciss
+	   device corresponds to which scsi host number without
+	   having to open a scsi target device node.  The device
+	   information is not a duplicate of /proc/scsi/scsi because
+	   the two may be out of sync due to scsi hotplug, rather
+	   this info is for an app to be able to use to know how to
+	   get them back in sync. */
+
+	for (i = 0; i < ccissscsi[h->ctlr].ndevices; i++) {
+		struct cciss_scsi_dev_t *sd = &ccissscsi[h->ctlr].dev[i];
+
+		seq_printf(m, "c%db%dt%dl%d %02d "
 				"0x%02x%02x%02x%02x%02x%02x%02x%02x\n",
 				sh->host_no, sd->bus, sd->target, sd->lun,
 				sd->devtype,
@@ -1351,18 +1313,47 @@ cciss_scsi_proc_info(struct Scsi_Host *sh,
 				sd->scsi3addr[4], sd->scsi3addr[5],
 				sd->scsi3addr[6], sd->scsi3addr[7]);
 		}
-		datalen = buflen - offset;
-		if (datalen < 0) { 	/* they're reading past EOF. */
-			datalen = 0;
-			*start = buffer+buflen;	
-		} else
-			*start = buffer + offset;
-		return(datalen);
-	} else 	/* User is writing to /proc/scsi/cciss*?/?*  ... */
-		return cciss_scsi_user_command(h, sh->host_no,
-			buffer, length);	
+	return 0;
 } 
 
+static int cciss_scsi_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, cciss_scsi_proc_show, PDE(inode)->data);
+}
+
+static ssize_t cciss_scsi_proc_write(struct file *file, const char __user *buf,
+				     size_t count, loff_t *pos)
+{
+	struct Scsi_Host *sh = PDE(file->f_path.dentry->d_inode)->data;
+	ctlr_info_t *h;
+	char cmd[sizeof("rescan")];
+	size_t len;
+
+	h = (ctlr_info_t *)sh->hostdata[0];
+	if (h == NULL)	/* This really shouldn't ever happen. */
+		return -EINVAL;
+
+	len = min(count, sizeof(cmd) - 1);
+	if (copy_from_user(cmd, buf, len))
+		return -EFAULT;
+	cmd[len] = '\0';
+
+	if (strcmp(cmd, "rescan") != 0)
+		return -EINVAL;
+
+	cciss_update_non_disk_devices(h, sh->host_no);
+
+	return count;
+}
+
+static const struct file_operations cciss_scsi_proc_ops = {
+	.open		= cciss_scsi_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= cciss_scsi_proc_write,
+};
+
 /* cciss_scatter_gather takes a struct scsi_cmnd, (cmd), and does the pci 
    dma mapping  and fills in the scatter gather entries of the 
    cciss command, c. */
-- 
1.7.3.4

