From: Alan Stern <stern@rowland.harvard.edu>
Subject: PATCH: (as33b) Remove /proc/scsi directory in scsi_remove_host()
Date: Thu, 12 Jun 2003 17:00:35 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0306121653140.709-100000@ida.rowland.org>
References: <20030612065122.GA1877@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:2052 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S264989AbTFLUqv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jun 2003 16:46:51 -0400
In-Reply-To: <20030612065122.GA1877@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI development list <linux-scsi@vger.kernel.org>

Mike:

Here is a more extensive attempt to fix the /proc/scsi problem.  This 
patch should work with LLDDs that use either the legacy or the hotplug 
model.  It should fix the problem you noted of trying to remove the 
directory while there are still hosts present.  And it resolves at least 
one race that exists in the current code.

The major difference between the current code and my patch is that the
patch creates the /proc/scsi/hostname directory during scsi_register() and
removes it during scsi_unregister().  The actual
/proc/scsi/hostname/hostnum files are still created and removed during
scsi_add_host() and scsi_remove_host().  I doubt that change should cause
anybody any problem; it was the only way to reconcile the procfs stuff 
with host probing.

I hope you like this attempt a little better.

Alan Stern


# This is a BitKeeper generated patch for the following project:
# Project Name: greg k-h's linux 2.5 USB kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1649  -> 1.1650 
#	drivers/scsi/scsi_priv.h	1.1     -> 1.2    
#	drivers/scsi/hosts.c	1.26    -> 1.27   
#	drivers/scsi/scsi_proc.c	1.11    -> 1.12   
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/06/12	stern@ida.rowland.org	1.1650
# Fix procfs handling during host unregistration
# --------------------------------------------
#
diff -Nru a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c	Thu Jun 12 16:52:28 2003
+++ b/drivers/scsi/hosts.c	Thu Jun 12 16:52:28 2003
@@ -285,7 +285,7 @@
 		shost->eh_notify = NULL;
 	}
 
-	shost->hostt->present--;
+	scsi_proc_hostdir_rm(shost->hostt);
 	scsi_destroy_command_freelist(shost);
 	kfree(shost);
 }
@@ -417,7 +417,7 @@
 	 */
 	wait_for_completion(&sem);
 	shost->eh_notify = NULL;
-	shost->hostt->present++;
+	scsi_proc_hostdir_add(shost->hostt);
 	return shost;
 
 fail:
diff -Nru a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
--- a/drivers/scsi/scsi_priv.h	Thu Jun 12 16:52:28 2003
+++ b/drivers/scsi/scsi_priv.h	Thu Jun 12 16:52:28 2003
@@ -42,6 +42,7 @@
 	(((scmd)->sense_buffer[0] & 0x70) == 0x70)
 
 struct Scsi_Device_Template;
+struct SHT;
 
 
 /*
@@ -100,11 +101,15 @@
 
 /* scsi_proc.c */
 #ifdef CONFIG_PROC_FS
+extern void scsi_proc_hostdir_add(struct SHT *);
+extern void scsi_proc_hostdir_rm(struct SHT *);
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
--- a/drivers/scsi/scsi_proc.c	Thu Jun 12 16:52:28 2003
+++ b/drivers/scsi/scsi_proc.c	Thu Jun 12 16:52:28 2003
@@ -40,6 +40,8 @@
 struct proc_dir_entry *proc_scsi;
 EXPORT_SYMBOL(proc_scsi);
 
+/* Protect sht->present and sht->proc_dir */
+static DECLARE_MUTEX(global_host_template_sem);
 
 /* Used if the driver currently has no own support for /proc/scsi */
 static int generic_proc_info(char *buffer, char **start, off_t offset,
@@ -112,13 +114,10 @@
 	return ret;
 }
 
-void scsi_proc_host_add(struct Scsi_Host *shost)
+void scsi_proc_hostdir_add(struct SHT *sht)
 {
-	Scsi_Host_Template *sht = shost->hostt;
-	struct proc_dir_entry *p;
-	char name[10];
-
-	if (!sht->proc_dir) {
+	down(&global_host_template_sem);
+	if (!sht->present++) {
 		sht->proc_dir = proc_mkdir(sht->proc_name, proc_scsi);
         	if (!sht->proc_dir) {
 			printk(KERN_ERR "%s: proc_mkdir failed for %s\n",
@@ -127,30 +126,51 @@
 		}
 		sht->proc_dir->owner = sht->module;
 	}
+	up(&global_host_template_sem);
+}
+
+void scsi_proc_hostdir_rm(struct SHT *sht)
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
+	Scsi_Host_Template *sht = shost->hostt;
+	struct proc_dir_entry *p;
+	char name[10];
+
+	if (!sht->proc_dir)
+		return;
 
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
 
 	p->write_proc = proc_scsi_write;
-	p->owner = shost->hostt->module;
-
+	p->owner = sht->module;
 }
 
 void scsi_proc_host_rm(struct Scsi_Host *shost)
 {
 	char name[10];
 
+	if (!shost->hostt->proc_dir)
+		return;
+
 	sprintf(name,"%d", shost->host_no);
 	remove_proc_entry(name, shost->hostt->proc_dir);
-	if (!shost->hostt->present)
-		remove_proc_entry(shost->hostt->proc_name, proc_scsi);
 }
 
 static void proc_print_scsidevice(struct scsi_device* sdev, char *buffer,

