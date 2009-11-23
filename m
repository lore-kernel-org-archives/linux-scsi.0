From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 13/27] scsi proc_fops: convert cciss
Date: Mon, 23 Nov 2009 04:37:40 +0300
Message-ID: <20091123013740.GM31711@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:27063 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbZKWBi4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Nov 2009 20:38:56 -0500
Received: by ey-out-2122.google.com with SMTP id 25so101740eya.5
        for <linux-scsi@vger.kernel.org>; Sun, 22 Nov 2009 17:39:02 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/block/cciss_scsi.c |  129 +++++++++++++++++++++------------------------
 1 file changed, 61 insertions(+), 68 deletions(-)

--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -52,13 +52,7 @@ static int fill_cmd(CommandList_struct *c, __u8 cmd, int ctlr, void *buff,
 static CommandList_struct *cmd_alloc(ctlr_info_t *h, int get_from_pool);
 static void cmd_free(ctlr_info_t *h, CommandList_struct *c, int got_from_pool);
 
-static int cciss_scsi_proc_info(
-		struct Scsi_Host *sh,
-		char *buffer, /* data buffer */
-		char **start, 	   /* where data in buffer starts */
-		off_t offset,	   /* offset from start of imaginary file */
-		int length, 	   /* length of data in buffer */
-		int func);	   /* 0 == read, 1 == write */
+static const struct file_operations cciss_scsi_proc_fops;
 
 static int cciss_scsi_queue_command (struct scsi_cmnd *cmd,
 		void (* done)(struct scsi_cmnd *));
@@ -80,7 +74,7 @@ static struct scsi_host_template cciss_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "cciss",
 	.proc_name		= "cciss",
-	.proc_info		= cciss_scsi_proc_info,
+	.proc_fops		= &cciss_scsi_proc_fops,
 	.queuecommand		= cciss_scsi_queue_command,
 	.can_queue		= SCSI_CCISS_CAN_QUEUE,
 	.this_id		= 7,
@@ -1281,39 +1275,9 @@ out:
 	return;
 }
 
-static int
-is_keyword(char *ptr, int len, char *verb)  // Thanks to ncr53c8xx.c
+static int cciss_scsi_proc_show(struct seq_file *m, void *v)
 {
-	int verb_len = strlen(verb);
-	if (len >= verb_len && !memcmp(verb,ptr,verb_len))
-		return verb_len;
-	else
-		return 0;
-}
-
-static int
-cciss_scsi_user_command(int ctlr, int hostno, char *buffer, int length)
-{
-	int arg_len;
-
-	if ((arg_len = is_keyword(buffer, length, "rescan")) != 0)
-		cciss_update_non_disk_devices(ctlr, hostno);
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
 	ctlr_info_t *ci;
 	int i;
 	int cntl_num;
@@ -1325,21 +1289,20 @@ cciss_scsi_proc_info(struct Scsi_Host *sh,
 
 	cntl_num = ci->ctlr;	/* Get our index into the hba[] array */
 
-	if (func == 0) {	/* User is reading from /proc/scsi/ciss*?/?*  */
-		buflen = sprintf(buffer, "cciss%d: SCSI host: %d\n",
-				cntl_num, sh->host_no);
-
-		/* this information is needed by apps to know which cciss
-		   device corresponds to which scsi host number without
-		   having to open a scsi target device node.  The device
-		   information is not a duplicate of /proc/scsi/scsi because
-		   the two may be out of sync due to scsi hotplug, rather
-		   this info is for an app to be able to use to know how to
-		   get them back in sync. */
-
-		for (i=0;i<ccissscsi[cntl_num].ndevices;i++) {
-			struct cciss_scsi_dev_t *sd = &ccissscsi[cntl_num].dev[i];
-			buflen += sprintf(&buffer[buflen], "c%db%dt%dl%d %02d "
+	seq_printf(m, "cciss%d: SCSI host: %d\n", cntl_num, sh->host_no);
+
+	/* this information is needed by apps to know which cciss
+	   device corresponds to which scsi host number without
+	   having to open a scsi target device node.  The device
+	   information is not a duplicate of /proc/scsi/scsi because
+	   the two may be out of sync due to scsi hotplug, rather
+	   this info is for an app to be able to use to know how to
+	   get them back in sync. */
+
+	for (i = 0; i < ccissscsi[cntl_num].ndevices; i++) {
+		struct cciss_scsi_dev_t *sd = &ccissscsi[cntl_num].dev[i];
+
+		seq_printf(m, "c%db%dt%dl%d %02d "
 				"0x%02x%02x%02x%02x%02x%02x%02x%02x\n",
 				sh->host_no, sd->bus, sd->target, sd->lun,
 				sd->devtype,
@@ -1347,18 +1310,49 @@ cciss_scsi_proc_info(struct Scsi_Host *sh,
 				sd->scsi3addr[2], sd->scsi3addr[3],
 				sd->scsi3addr[4], sd->scsi3addr[5],
 				sd->scsi3addr[6], sd->scsi3addr[7]);
-		}
-		datalen = buflen - offset;
-		if (datalen < 0) { 	/* they're reading past EOF. */
-			datalen = 0;
-			*start = buffer+buflen;	
-		} else
-			*start = buffer + offset;
-		return(datalen);
-	} else 	/* User is writing to /proc/scsi/cciss*?/?*  ... */
-		return cciss_scsi_user_command(cntl_num, sh->host_no,
-			buffer, length);	
-} 
+	}
+
+	return 0;
+}
+
+static int cciss_scsi_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, cciss_scsi_proc_show, PDE(inode)->data);
+}
+
+static ssize_t cciss_scsi_proc_write(struct file *file, const char __user *buf,
+				     size_t count, loff_t *pos)
+{
+	struct Scsi_Host *sh = PDE(file->f_path.dentry->d_inode)->data;
+	ctlr_info_t *ci;
+	char cmd[sizeof("rescan")];
+	size_t len;
+
+	ci = (ctlr_info_t *) sh->hostdata[0];
+	if (ci == NULL)  /* This really shouldn't ever happen. */
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
+	cciss_update_non_disk_devices(ci->ctlr, sh->host_no);
+
+	return count;
+}
+
+static const struct file_operations cciss_scsi_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= cciss_scsi_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= cciss_scsi_proc_write,
+};
 
 /* cciss_scatter_gather takes a struct scsi_cmnd, (cmd), and does the pci 
    dma mapping  and fills in the scatter gather entries of the 
-- 
1.6.5.2

