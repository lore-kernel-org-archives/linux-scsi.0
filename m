From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] don't create /proc/scsi/ entries for drivers without ->proc_info
Date: Tue, 3 Jun 2003 22:19:16 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030603201916.GB8874@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:61608 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S264078AbTFCUFv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jun 2003 16:05:51 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

Current code just puts the driver name into it which is utterly useless


diff -Nru a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
--- a/drivers/scsi/scsi_proc.c	Tue May 27 14:52:15 2003
+++ b/drivers/scsi/scsi_proc.c	Tue May 27 14:52:15 2003
@@ -42,48 +42,15 @@
 EXPORT_SYMBOL(proc_scsi);
 
 
-/* Used if the driver currently has no own support for /proc/scsi */
-static int generic_proc_info(char *buffer, char **start, off_t offset,
-			     int count, const char *(*info)(struct Scsi_Host *),
-			     struct Scsi_Host *shost)
-{
-	int len, pos, begin = 0;
-	static const char noprocfs[] =
-		"The driver does not yet support the proc-fs\n";
-
-	if (info && shost)
-		len = sprintf(buffer, "%s\n", info(shost));
-	else
-		len = sprintf(buffer, "%s\n", noprocfs);
-
-	pos = len;
-	if (pos < offset) {
-		len = 0;
-		begin = pos;
-	}
-
-	*start = buffer + (offset - begin);
-	len -= (offset - begin);
-	if (len > count)
-		len = count;
-
-	return len;
-}
-
 static int proc_scsi_read(char *buffer, char **start, off_t offset,
 			  int length, int *eof, void *data)
 {
 	struct Scsi_Host *shost = data;
 	int n;
 
-	if (shost->hostt->proc_info == NULL)
-		n = generic_proc_info(buffer, start, offset, length,
-				      shost->hostt->info, shost);
-	else
-		n = shost->hostt->proc_info(shost, buffer, start, offset,
-					   length, 0);
-
+	n = shost->hostt->proc_info(shost, buffer, start, offset, length, 0);
 	*eof = (n < length);
+
 	return n;
 }
 
@@ -95,8 +62,6 @@
 	char *page;
 	char *start;
     
-	if (!shost->hostt->proc_info)
-		return -ENOSYS;
 	if (count > PROC_BLOCK_SIZE)
 		return -EOVERFLOW;
 
@@ -118,6 +83,9 @@
 	struct proc_dir_entry *p;
 	char name[10];
 
+	if (!sht->proc_info)
+		return;
+
 	if (!sht->proc_dir) {
 		sht->proc_dir = proc_mkdir(sht->proc_name, proc_scsi);
         	if (!sht->proc_dir) {
@@ -130,27 +98,29 @@
 
 	sprintf(name,"%d", shost->host_no);
 	p = create_proc_read_entry(name, S_IFREG | S_IRUGO | S_IWUSR,
-			shost->hostt->proc_dir, proc_scsi_read, shost);
+			sht->proc_dir, proc_scsi_read, shost);
 	if (!p) {
 		printk(KERN_ERR "%s: Failed to register host %d in"
 		       "%s\n", __FUNCTION__, shost->host_no,
-		       shost->hostt->proc_name);
+		       sht->proc_name);
 		return;
 	} 
 
 	p->write_proc = proc_scsi_write_proc;
 	p->owner = shost->hostt->module;
-
 }
 
 void scsi_proc_host_rm(struct Scsi_Host *shost)
 {
+	Scsi_Host_Template *sht = shost->hostt;
 	char name[10];
 
-	sprintf(name,"%d", shost->host_no);
-	remove_proc_entry(name, shost->hostt->proc_dir);
-	if (!shost->hostt->present)
-		remove_proc_entry(shost->hostt->proc_name, proc_scsi);
+	if (sht->proc_info) {
+		sprintf(name,"%d", shost->host_no);
+		remove_proc_entry(name, sht->proc_dir);
+		if (!sht->present)
+			remove_proc_entry(sht->proc_name, proc_scsi);
+	}
 }
 
 static int proc_print_scsidevice(struct device *dev, void *data)
