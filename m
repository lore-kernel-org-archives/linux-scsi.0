From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 01/34] scsi proc_ops: add struct scsi_host_template::proc_ops
Date: Wed, 22 Feb 2012 22:45:52 +0300
Message-ID: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59220 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745Ab2BVTqe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2012 14:46:34 -0500
Received: by bkcjm19 with SMTP id jm19so433763bkc.19
        for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2012 11:46:33 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>

The last user of ->write_proc interface is scsi_proc.c passing through
data to individual drivers. There are still quite a few drivers using
->proc_info interface, so do conversion gradually.

Introduce temporary logic allowing both ->proc_info and ->proc_ops
with ->proc_ops being the first thing to check, convert drivers,
remove ->proc_info interface.

Removing all relevant SCSI proc files is risky because it'd take only one
broken user to revert whole thing and do it right.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/scsi/scsi_proc.c |   20 +++++++++++++++-----
 include/scsi/scsi_host.h |    1 +
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
index ad747dc..31da690 100644
--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -106,7 +106,7 @@ out:
 
 void scsi_proc_hostdir_add(struct scsi_host_template *sht)
 {
-	if (!sht->proc_info)
+	if (!sht->proc_info && !sht->proc_ops)
 		return;
 
 	mutex_lock(&global_host_template_mutex);
@@ -125,7 +125,7 @@ void scsi_proc_hostdir_add(struct scsi_host_template *sht)
  */
 void scsi_proc_hostdir_rm(struct scsi_host_template *sht)
 {
-	if (!sht->proc_info)
+	if (!sht->proc_info && !sht->proc_ops)
 		return;
 
 	mutex_lock(&global_host_template_mutex);
@@ -151,16 +151,26 @@ void scsi_proc_host_add(struct Scsi_Host *shost)
 		return;
 
 	sprintf(name,"%d", shost->host_no);
-	p = create_proc_read_entry(name, S_IFREG | S_IRUGO | S_IWUSR,
+	if (sht->proc_ops) {
+		mode_t mode;
+
+		mode = S_IRUGO;
+		if (sht->proc_ops->write)
+			mode |= S_IWUSR;
+		p = proc_create_data(name, mode, sht->proc_dir,
+				     sht->proc_ops, shost);
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
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 5f7d5b3..f81c80f 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -341,6 +341,7 @@ struct scsi_host_template {
 	 * Status: OBSOLETE
 	 */
 	int (*proc_info)(struct Scsi_Host *, char *, char **, off_t, int, int);
+	const struct file_operations *proc_ops;
 
 	/*
 	 * This is an optional routine that allows the transport to become
-- 
1.7.3.4

