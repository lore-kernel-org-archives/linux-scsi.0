From: Alan Stern <stern@rowland.harvard.edu>
Subject: PATCH: (as33e) Fix removal of /proc/scsi/hostdir on hot-unplug
Date: Thu, 31 Jul 2003 15:38:55 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0307311532050.8053-100000@ida.rowland.org>
References: <20030709144410.GA3544@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:18436 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S274859AbTGaTi5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jul 2003 15:38:57 -0400
In-Reply-To: <20030709144410.GA3544@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Mike:

I sent this patch to you some time ago, and now that 2.6.0 is coming maybe
it's time to submit it again.  This fixes the problem that
/proc/scsi/hostdir isn't removed when the host adapter is hot-unplugged.
It accomplishes this by creating the directory and the files within it at
separate times, and it should work with drivers using either the legacy or
the hot-plugging model.

The patch applies to 2.6.0-test2.

Alan Stern


# This is a BitKeeper generated patch for the following project:
# Project Name: greg k-h's linux 2.5 USB kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1656  -> 1.1657 
#	drivers/scsi/scsi_priv.h	1.6     -> 1.7    
#	drivers/scsi/hosts.c	1.30    -> 1.31   
#	drivers/scsi/scsi_proc.c	1.15    -> 1.16   
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/07/31	stern@ida.rowland.org	1.1657
# Make sure /proc/scsi/hostdir is removed upon hot-unplug.
# Separate the creation of /proc/scsi/hostdir and /proc/scsi/hostdir/device.
# --------------------------------------------
#
diff -Nru a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c	Thu Jul 31 15:28:30 2003
+++ b/drivers/scsi/hosts.c	Thu Jul 31 15:28:30 2003
@@ -108,7 +108,7 @@
 		shost->eh_notify = NULL;
 	}
 
-	shost->hostt->present--;
+	scsi_proc_hostdir_rm(shost->hostt);
 	scsi_destroy_command_freelist(shost);
 	kfree(shost);
 }
@@ -209,7 +209,7 @@
 	kernel_thread((int (*)(void *))scsi_error_handler, shost, 0);
 	wait_for_completion(&complete);
 	shost->eh_notify = NULL;
-	shost->hostt->present++;
+	scsi_proc_hostdir_add(shost->hostt);
 	return shost;
  fail:
 	kfree(shost);
diff -Nru a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
--- a/drivers/scsi/scsi_priv.h	Thu Jul 31 15:28:30 2003
+++ b/drivers/scsi/scsi_priv.h	Thu Jul 31 15:28:30 2003
@@ -41,6 +41,8 @@
 #define SCSI_SENSE_VALID(scmd) \
 	(((scmd)->sense_buffer[0] & 0x70) == 0x70)
 
+struct scsi_host_template;
+
 /*
  * scsi_target: representation of a scsi target, for now, this is only
  * used for single_lun devices. If no one has active IO to the target,
@@ -90,11 +92,15 @@
 
 /* scsi_proc.c */
 #ifdef CONFIG_PROC_FS
+extern void scsi_proc_hostdir_add(struct scsi_host_template *);
+extern void scsi_proc_hostdir_rm(struct scsi_host_template *);
 extern void scsi_proc_host_add(struct Scsi_Host *);
 extern void scsi_proc_host_rm(struct Scsi_Host *);
 extern int scsi_init_procfs(void);
 extern void scsi_exit_procfs(void);
 #else
+# define scsi_proc_hostdir_add(sht)	do { } while (0)
+# define scsi_proc_hostdir_rm(sht)	do { } while (0)
 # define scsi_proc_host_add(shost)	do { } while (0)
 # define scsi_proc_host_rm(shost)	do { } while (0)
 # define scsi_init_procfs()		(0)
diff -Nru a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
--- a/drivers/scsi/scsi_proc.c	Thu Jul 31 15:28:30 2003
+++ b/drivers/scsi/scsi_proc.c	Thu Jul 31 15:28:30 2003
@@ -41,6 +41,9 @@
 struct proc_dir_entry *proc_scsi;
 EXPORT_SYMBOL(proc_scsi);
 
+/* Protect sht->present and sht->proc_dir */
+static DECLARE_MUTEX(global_host_template_sem);
+
 
 static int proc_scsi_read(char *buffer, char **start, off_t offset,
 			  int length, int *eof, void *data)
@@ -77,24 +80,39 @@
 	return ret;
 }
 
-void scsi_proc_host_add(struct Scsi_Host *shost)
+void scsi_proc_hostdir_add(struct scsi_host_template *sht)
 {
-	struct scsi_host_template *sht = shost->hostt;
-	struct proc_dir_entry *p;
-	char name[10];
-
-	if (!sht->proc_info)
-		return;
-
-	if (!sht->proc_dir) {
+	down(&global_host_template_sem);
+	if (!sht->present++) {
 		sht->proc_dir = proc_mkdir(sht->proc_name, proc_scsi);
-        	if (!sht->proc_dir) {
+		if (!sht->proc_dir) {
 			printk(KERN_ERR "%s: proc_mkdir failed for %s\n",
 			       __FUNCTION__, sht->proc_name);
 			return;
 		}
 		sht->proc_dir->owner = sht->module;
 	}
+	up(&global_host_template_sem);
+}
+
+void scsi_proc_hostdir_rm(struct scsi_host_template *sht)
+{
+	down(&global_host_template_sem);
+	if (!--sht->present && sht->proc_dir) {
+		remove_proc_entry(sht->proc_name, proc_scsi);
+		sht->proc_dir = NULL;
+	}
+	up(&global_host_template_sem);
+}
+
+void scsi_proc_host_add(struct Scsi_Host *shost)
+{
+	struct scsi_host_template *sht = shost->hostt;
+	struct proc_dir_entry *p;
+	char name[10];
+
+	if (!sht->proc_dir)
+		return;
 
 	sprintf(name,"%d", shost->host_no);
 	p = create_proc_read_entry(name, S_IFREG | S_IRUGO | S_IWUSR,
@@ -107,7 +125,7 @@
 	} 
 
 	p->write_proc = proc_scsi_write_proc;
-	p->owner = shost->hostt->module;
+	p->owner = sht->module;
 }
 
 void scsi_proc_host_rm(struct Scsi_Host *shost)
@@ -115,12 +133,11 @@
 	struct scsi_host_template *sht = shost->hostt;
 	char name[10];
 
-	if (sht->proc_info) {
-		sprintf(name,"%d", shost->host_no);
-		remove_proc_entry(name, sht->proc_dir);
-		if (!sht->present)
-			remove_proc_entry(sht->proc_name, proc_scsi);
-	}
+	if (!sht->proc_dir)
+		return;
+
+	sprintf(name,"%d", shost->host_no);
+	remove_proc_entry(name, sht->proc_dir);
 }
 
 static int proc_print_scsidevice(struct device *dev, void *data)

