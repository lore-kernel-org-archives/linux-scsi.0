From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 01/27] scsi proc_fops: add struct
 scsi_host_template::proc_fops
Date: Mon, 23 Nov 2009 04:30:05 +0300
Message-ID: <20091123013004.GA31711@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:55344 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176AbZKWBbW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Nov 2009 20:31:22 -0500
Received: by ewy19 with SMTP id 19so1397872ewy.21
        for <linux-scsi@vger.kernel.org>; Sun, 22 Nov 2009 17:31:27 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org

Add struct scsi_host_template::proc_fops .

->read_proc and ->write_proc interfaces are going to be removed,
the only big user of them is scsi_proc.c

->proc_fops takes precedence over ->proc_info while conversion is done.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/scsi/scsi_proc.c |   20 +++++++++++++++-----
 include/scsi/scsi_host.h |    1 +
 2 files changed, 16 insertions(+), 5 deletions(-)

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
@@ -151,16 +151,26 @@ void scsi_proc_host_add(struct Scsi_Host *shost)
 		return;
 
 	sprintf(name,"%d", shost->host_no);
-	p = create_proc_read_entry(name, S_IFREG | S_IRUGO | S_IWUSR,
+	if (sht->proc_fops) {
+		mode_t mode;
+
+		mode = S_IRUGO;
+		if (sht->proc_fops->write)
+			mode |= S_IWUSR;
+		p = proc_create_data(name, mode, sht->proc_dir,
+				     sht->proc_fops, shost);
+	} else {
+		p = create_proc_read_entry(name, S_IFREG | S_IRUGO | S_IWUSR,
 			sht->proc_dir, proc_scsi_read, shost);
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
