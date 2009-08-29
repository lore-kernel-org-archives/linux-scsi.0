From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 1/2] scsi: add struct scsi_host_template::proc_fops
Date: Sat, 29 Aug 2009 22:34:31 +0400
Message-ID: <20090829183431.GA30818@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:60332 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbZH2Sec (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Aug 2009 14:34:32 -0400
Received: by ewy2 with SMTP id 2so2967434ewy.17
        for <linux-scsi@vger.kernel.org>; Sat, 29 Aug 2009 11:34:33 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

Add struct scsi_host_template::proc_fops, it's designed to replace
struct scsi_host_template::proc_info which is
a) multiplexed wrt read/write,
b) forces core code to use ->read_proc, ->write_proc interfaces
   which I'm trying to remove.

After conversion of all users, ->proc_info will be removed.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/scsi/scsi_proc.c |   17 +++++++++++------
 include/scsi/scsi_host.h |    1 +
 2 files changed, 12 insertions(+), 6 deletions(-)

--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -106,7 +106,7 @@ out:
 
 void scsi_proc_hostdir_add(struct scsi_host_template *sht)
 {
-	if (!sht->proc_info)
+	if (!sht->proc_info && !sht->proc_fops)
 		return;
 
 	mutex_lock(&global_host_template_mutex);
@@ -125,7 +125,7 @@ void scsi_proc_hostdir_add(struct scsi_host_template *sht)
  */
 void scsi_proc_hostdir_rm(struct scsi_host_template *sht)
 {
-	if (!sht->proc_info)
+	if (!sht->proc_info && !sht->proc_fops)
 		return;
 
 	mutex_lock(&global_host_template_mutex);
@@ -151,16 +151,21 @@ void scsi_proc_host_add(struct Scsi_Host *shost)
 		return;
 
 	sprintf(name,"%d", shost->host_no);
-	p = create_proc_read_entry(name, S_IFREG | S_IRUGO | S_IWUSR,
-			sht->proc_dir, proc_scsi_read, shost);
+	if (sht->proc_fops) {
+		p = proc_create_data(name, S_IRUGO | S_IWUSR, sht->proc_dir,
+				     sht->proc_fops, shost);
+	} else {
+		p = create_proc_read_entry(name, S_IFREG | S_IRUGO | S_IWUSR,
+					sht->proc_dir, proc_scsi_read, shost);
+		if (p)
+			p->write_proc = proc_scsi_write_proc;
+	}
 	if (!p) {
 		printk(KERN_ERR "%s: Failed to register host %d in"
 		       "%s\n", __func__, shost->host_no,
 		       sht->proc_name);
 		return;
 	} 
-
-	p->write_proc = proc_scsi_write_proc;
 }
 
 /**
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -328,6 +328,7 @@ struct scsi_host_template {
 	 * Status: OBSOLETE
 	 */
 	int (*proc_info)(struct Scsi_Host *, char *, char **, off_t, int, int);
+	const struct file_operations *proc_fops;
 
 	/*
 	 * This is an optional routine that allows the transport to become
