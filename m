From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH] Correct removal of procfs host enteries [1/2]
Date: Fri, 1 Aug 2003 13:10:20 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030801201020.GB3868@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:55717 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S270865AbTHAUYr
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Aug 2003 16:24:47 -0400
Received: from westrelay01.boulder.ibm.com (westrelay01.boulder.ibm.com [9.17.195.10])
	by e34.co.us.ibm.com (8.12.9/8.12.2) with ESMTP id h71KOkEh288494
	for <linux-scsi@vger.kernel.org>; Fri, 1 Aug 2003 16:24:46 -0400
Received: from dyn9-47-17-195 (DYN318028BLD.beaverton.ibm.com [9.47.17.91] (may be forged))
	by westrelay01.boulder.ibm.com (8.12.9/NCO/VER6.5) with ESMTP id h71KOkAp039194
	for <linux-scsi@vger.kernel.org>; Fri, 1 Aug 2003 14:24:46 -0600
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is against scsi-misc-2.5 cset 1.1595.

This is been reposted a few times. Alan Stern just reposted yesterday.
My part 1 patch differs on a few lines, but is functionally the same.

Selecting a different part one will give some offset errors, but
should work. (YMMV).

-andmike
--
Michael Anderson
andmike@us.ibm.com


DESC
This is a refresh of a patch by Alan Stern to correct the removal of scsi
procfs host enteries

http://marc.theaimsgroup.com/?l=linux-scsi&m=105545175600506&w=2
EDESC


 drivers/scsi/hosts.c     |    4 +--
 drivers/scsi/scsi_priv.h |    4 +++
 drivers/scsi/scsi_proc.c |   49 ++++++++++++++++++++++++++++++-----------------
 3 files changed, 38 insertions(+), 19 deletions(-)

diff -puN drivers/scsi/hosts.c~stern_present drivers/scsi/hosts.c
--- patched-scsi-misc-2.5/drivers/scsi/hosts.c~stern_present	Thu Jul 31 07:50:39 2003
+++ patched-scsi-misc-2.5-andmike/drivers/scsi/hosts.c	Thu Jul 31 14:31:51 2003
@@ -108,7 +108,7 @@ void scsi_free_shost(struct Scsi_Host *s
 		shost->eh_notify = NULL;
 	}
 
-	shost->hostt->present--;
+	scsi_proc_hostdir_rm(shost->hostt);
 	scsi_destroy_command_freelist(shost);
 	kfree(shost);
 }
@@ -209,7 +209,7 @@ struct Scsi_Host *scsi_host_alloc(struct
 	kernel_thread((int (*)(void *))scsi_error_handler, shost, 0);
 	wait_for_completion(&complete);
 	shost->eh_notify = NULL;
-	shost->hostt->present++;
+	scsi_proc_hostdir_add(shost->hostt);
 	return shost;
  fail:
 	kfree(shost);
diff -puN drivers/scsi/scsi_priv.h~stern_present drivers/scsi/scsi_priv.h
--- patched-scsi-misc-2.5/drivers/scsi/scsi_priv.h~stern_present	Thu Jul 31 07:50:39 2003
+++ patched-scsi-misc-2.5-andmike/drivers/scsi/scsi_priv.h	Thu Jul 31 14:31:51 2003
@@ -90,11 +90,15 @@ extern void scsi_exit_queue(void);
 
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
diff -puN drivers/scsi/scsi_proc.c~stern_present drivers/scsi/scsi_proc.c
--- patched-scsi-misc-2.5/drivers/scsi/scsi_proc.c~stern_present	Thu Jul 31 07:50:39 2003
+++ patched-scsi-misc-2.5-andmike/drivers/scsi/scsi_proc.c	Thu Jul 31 14:31:51 2003
@@ -41,6 +41,8 @@
 struct proc_dir_entry *proc_scsi;
 EXPORT_SYMBOL(proc_scsi);
 
+/* Protect sht->present and sht->proc_dir */
+static DECLARE_MUTEX(global_host_template_sem);
 
 static int proc_scsi_read(char *buffer, char **start, off_t offset,
 			  int length, int *eof, void *data)
@@ -77,16 +79,10 @@ out:
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
         	if (!sht->proc_dir) {
 			printk(KERN_ERR "%s: proc_mkdir failed for %s\n",
@@ -95,6 +91,27 @@ void scsi_proc_host_add(struct Scsi_Host
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
@@ -107,20 +124,18 @@ void scsi_proc_host_add(struct Scsi_Host
 	} 
 
 	p->write_proc = proc_scsi_write_proc;
-	p->owner = shost->hostt->module;
+	p->owner = sht->module;
 }
 
 void scsi_proc_host_rm(struct Scsi_Host *shost)
 {
-	struct scsi_host_template *sht = shost->hostt;
 	char name[10];
 
-	if (sht->proc_info) {
-		sprintf(name,"%d", shost->host_no);
-		remove_proc_entry(name, sht->proc_dir);
-		if (!sht->present)
-			remove_proc_entry(sht->proc_name, proc_scsi);
-	}
+	if (!shost->hostt->proc_dir)
+		return;
+
+	sprintf(name,"%d", shost->host_no);
+	remove_proc_entry(name, shost->hostt->proc_dir);
 }
 
 static int proc_print_scsidevice(struct device *dev, void *data)

_

