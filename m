From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Fw: 2.5.75 - ppa unload PATCH and remaining problem
Date: Mon, 14 Jul 2003 13:35:11 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030714203510.GE1317@beaverton.ibm.com>
References: <20030713141556.13650fdb.akpm@osdl.org> <20030713234523.A7172@infradead.org> <20030713155612.37c7662b.akpm@osdl.org> <20030714153645.GA5969@beaverton.ibm.com> <20030714101041.65de0d72.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:20646 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S270834AbTGNUTi
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jul 2003 16:19:38 -0400
Content-Disposition: inline
In-Reply-To: <20030714101041.65de0d72.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, James.Bottomley@steeleye.com
Cc: hch@infradead.org, linux-scsi@vger.kernel.org, arvidjaar@mail.ru

Here is the patch rediffed against 2.6.0-test1. I also joined Alan Stern's
patch and my reduction of scsi_host present users as this is the way I
have been testing it.

This patch also applies to scsi-misc-2.5 with 2 offset warnings.

-andmike
--
Michael Anderson
andmike@us.ibm.com


DESC
This is a refresh of a patch by Alan Stern to correct the removal of scsi
procfs host enteries

http://marc.theaimsgroup.com/?l=linux-scsi&m=105545175600506&w=2

This patch also contains a join of another patch that reduces the users
of scsi_host present.

EDESC


 drivers/scsi/NCR53c406a.c    |    5 ++--
 drivers/scsi/aacraid/linit.c |    1 
 drivers/scsi/hosts.c         |    4 +--
 drivers/scsi/scsi_module.c   |    2 -
 drivers/scsi/scsi_priv.h     |    4 +++
 drivers/scsi/scsi_proc.c     |   49 ++++++++++++++++++++++++++++---------------
 6 files changed, 42 insertions(+), 23 deletions(-)

diff -puN drivers/scsi/hosts.c~stern_present drivers/scsi/hosts.c
--- remove-bleed-2.5/drivers/scsi/hosts.c~stern_present	Mon Jul 14 11:02:06 2003
+++ remove-bleed-2.5-andmike/drivers/scsi/hosts.c	Mon Jul 14 11:02:06 2003
@@ -112,7 +112,7 @@ void scsi_free_shost(struct Scsi_Host *s
 		shost->eh_notify = NULL;
 	}
 
-	shost->hostt->present--;
+	scsi_proc_hostdir_rm(shost->hostt);
 	scsi_destroy_command_freelist(shost);
 	kfree(shost);
 }
@@ -219,7 +219,7 @@ struct Scsi_Host *scsi_host_alloc(struct
 	kernel_thread((int (*)(void *))scsi_error_handler, shost, 0);
 	wait_for_completion(&complete);
 	shost->eh_notify = NULL;
-	shost->hostt->present++;
+	scsi_proc_hostdir_add(shost->hostt);
 	return shost;
  fail:
 	kfree(shost);
diff -puN drivers/scsi/scsi_priv.h~stern_present drivers/scsi/scsi_priv.h
--- remove-bleed-2.5/drivers/scsi/scsi_priv.h~stern_present	Mon Jul 14 11:02:06 2003
+++ remove-bleed-2.5-andmike/drivers/scsi/scsi_priv.h	Mon Jul 14 11:02:06 2003
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
--- remove-bleed-2.5/drivers/scsi/scsi_proc.c~stern_present	Mon Jul 14 11:02:06 2003
+++ remove-bleed-2.5-andmike/drivers/scsi/scsi_proc.c	Mon Jul 14 11:02:06 2003
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
diff -puN drivers/scsi/aacraid/linit.c~stern_present drivers/scsi/aacraid/linit.c
--- remove-bleed-2.5/drivers/scsi/aacraid/linit.c~stern_present	Mon Jul 14 12:42:29 2003
+++ remove-bleed-2.5-andmike/drivers/scsi/aacraid/linit.c	Mon Jul 14 12:42:29 2003
@@ -295,7 +295,6 @@ static int aac_detect(Scsi_Host_Template
 			printk(KERN_WARNING "aacraid: unable to register \"aac\" device.\n");
 	}
 
-	template->present = aac_count; /* # of cards of this type found */
 	return aac_count;
 }
 
diff -puN drivers/scsi/NCR53c406a.c~stern_present drivers/scsi/NCR53c406a.c
--- remove-bleed-2.5/drivers/scsi/NCR53c406a.c~stern_present	Mon Jul 14 12:42:29 2003
+++ remove-bleed-2.5-andmike/drivers/scsi/NCR53c406a.c	Mon Jul 14 12:42:29 2003
@@ -450,6 +450,7 @@ static __inline__ int NCR53c406a_pio_wri
 
 static int __init NCR53c406a_detect(Scsi_Host_Template * tpnt)
 {
+	int present = 0;
 	struct Scsi_Host *shpnt = NULL;
 #ifndef PORT_BASE
 	int i;
@@ -522,7 +523,7 @@ static int __init NCR53c406a_detect(Scsi
 
 	DEB(printk("NCR53c406a: using port_base 0x%x\n", port_base));
 
-	tpnt->present = 1;
+	present = 1;
 	tpnt->proc_name = "NCR53c406a";
 
 	shpnt = scsi_register(tpnt, 0);
@@ -576,7 +577,7 @@ static int __init NCR53c406a_detect(Scsi
 	sprintf(info_msg, "NCR53c406a at 0x%x, IRQ %d, %s PIO mode.", port_base, irq_level, fast_pio ? "fast" : "slow");
 #endif
 
-	return (tpnt->present);
+	return (present);
 
 #if USE_DMA
       err_free_irq:
diff -puN drivers/scsi/scsi_module.c~stern_present drivers/scsi/scsi_module.c
--- remove-bleed-2.5/drivers/scsi/scsi_module.c~stern_present	Mon Jul 14 12:42:29 2003
+++ remove-bleed-2.5-andmike/drivers/scsi/scsi_module.c	Mon Jul 14 12:42:29 2003
@@ -33,7 +33,7 @@ static int __init init_this_scsi_driver(
 	INIT_LIST_HEAD(&sht->legacy_hosts);
 
 	sht->detect(sht);
-	if (!sht->present)
+	if (list_empty(&sht->legacy_hosts))
 		return -ENODEV;
 
 	list_for_each_entry(shost, &sht->legacy_hosts, sht_legacy_list) {

_
