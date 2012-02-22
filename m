From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 34/34] scsi proc_ops: remove scsi_host_template::proc_info
Date: Wed, 22 Feb 2012 22:46:25 +0300
Message-ID: <1329939985-26793-34-git-send-email-adobriyan@gmail.com>
References: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62313 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809Ab2BVTre (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2012 14:47:34 -0500
Received: by mail-bk0-f46.google.com with SMTP id jm19so434319bkc.19
        for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2012 11:47:34 -0800 (PST)
In-Reply-To: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>

Now that all users have been converted.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/scsi/scsi_proc.c |   79 ++++-----------------------------------------
 include/scsi/scsi_host.h |    1 -
 2 files changed, 7 insertions(+), 73 deletions(-)

diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
index 31da690..cb72a61 100644
--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -36,68 +36,12 @@
 #include "scsi_priv.h"
 #include "scsi_logging.h"
 
-
-/* 4K page size, but our output routines, use some slack for overruns */
-#define PROC_BLOCK_SIZE (3*1024)
-
 static struct proc_dir_entry *proc_scsi;
 
 /* Protect sht->present and sht->proc_dir */
 static DEFINE_MUTEX(global_host_template_mutex);
 
 /**
- * proc_scsi_read - handle read from /proc by calling host's proc_info() command
- * @buffer: passed to proc_info
- * @start: passed to proc_info
- * @offset: passed to proc_info
- * @length: passed to proc_info
- * @eof: returns whether length read was less than requested
- * @data: pointer to a &struct Scsi_Host
- */
-
-static int proc_scsi_read(char *buffer, char **start, off_t offset,
-			  int length, int *eof, void *data)
-{
-	struct Scsi_Host *shost = data;
-	int n;
-
-	n = shost->hostt->proc_info(shost, buffer, start, offset, length, 0);
-	*eof = (n < length);
-
-	return n;
-}
-
-/**
- * proc_scsi_write_proc - Handle write to /proc by calling host's proc_info()
- * @file: not used
- * @buf: source of data to write.
- * @count: number of bytes (at most PROC_BLOCK_SIZE) to write.
- * @data: pointer to &struct Scsi_Host
- */
-static int proc_scsi_write_proc(struct file *file, const char __user *buf,
-                           unsigned long count, void *data)
-{
-	struct Scsi_Host *shost = data;
-	ssize_t ret = -ENOMEM;
-	char *page;
-	char *start;
-    
-	if (count > PROC_BLOCK_SIZE)
-		return -EOVERFLOW;
-
-	page = (char *)__get_free_page(GFP_KERNEL);
-	if (page) {
-		ret = -EFAULT;
-		if (copy_from_user(page, buf, count))
-			goto out;
-		ret = shost->hostt->proc_info(shost, page, &start, 0, count, 1);
-	}
-out:
-	free_page((unsigned long)page);
-	return ret;
-}
-
-/**
  * scsi_proc_hostdir_add - Create directory in /proc for a scsi host
  * @sht: owner of this directory
  *
@@ -106,7 +50,7 @@ out:
 
 void scsi_proc_hostdir_add(struct scsi_host_template *sht)
 {
-	if (!sht->proc_info && !sht->proc_ops)
+	if (!sht->proc_ops)
 		return;
 
 	mutex_lock(&global_host_template_mutex);
@@ -125,7 +69,7 @@ void scsi_proc_hostdir_add(struct scsi_host_template *sht)
  */
 void scsi_proc_hostdir_rm(struct scsi_host_template *sht)
 {
-	if (!sht->proc_info && !sht->proc_ops)
+	if (!sht->proc_ops)
 		return;
 
 	mutex_lock(&global_host_template_mutex);
@@ -146,25 +90,16 @@ void scsi_proc_host_add(struct Scsi_Host *shost)
 	struct scsi_host_template *sht = shost->hostt;
 	struct proc_dir_entry *p;
 	char name[10];
+	mode_t mode;
 
 	if (!sht->proc_dir)
 		return;
 
 	sprintf(name,"%d", shost->host_no);
-	if (sht->proc_ops) {
-		mode_t mode;
-
-		mode = S_IRUGO;
-		if (sht->proc_ops->write)
-			mode |= S_IWUSR;
-		p = proc_create_data(name, mode, sht->proc_dir,
-				     sht->proc_ops, shost);
-	} else {
-		p = create_proc_read_entry(name, S_IFREG | S_IRUGO | S_IWUSR,
-			sht->proc_dir, proc_scsi_read, shost);
-		if (p)
-			p->write_proc = proc_scsi_write_proc;
-	}
+	mode = S_IRUGO;
+	if (sht->proc_ops->write)
+		mode |= S_IWUSR;
+	p = proc_create_data(name, mode, sht->proc_dir, sht->proc_ops, shost);
 	if (!p) {
 		printk(KERN_ERR "%s: Failed to register host %d in"
 		       "%s\n", __func__, shost->host_no,
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index f81c80f..34fd834 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -340,7 +340,6 @@ struct scsi_host_template {
 	 *
 	 * Status: OBSOLETE
 	 */
-	int (*proc_info)(struct Scsi_Host *, char *, char **, off_t, int, int);
 	const struct file_operations *proc_ops;
 
 	/*
-- 
1.7.3.4

