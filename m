From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] rename struct SHT to something sensible
Date: Fri, 6 Jun 2003 16:41:55 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030606144155.GA23608@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:47317 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261568AbTFFO2Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2003 10:28:25 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

namely struct scsi_host_template and make the scsi core use this
instead of the typedef everywhere.


diff -Nru a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c	Thu Jun  5 18:52:51 2003
+++ b/drivers/scsi/hosts.c	Thu Jun  5 18:52:51 2003
@@ -75,7 +75,7 @@
  **/
 int scsi_add_host(struct Scsi_Host *shost, struct device *dev)
 {
-	Scsi_Host_Template *sht = shost->hostt;
+	struct scsi_host_template *sht = shost->hostt;
 	int error;
 
 	printk(KERN_INFO "scsi%d : %s\n", shost->host_no,
@@ -123,7 +123,7 @@
  * Return value:
  * 	Pointer to a new Scsi_Host
  **/
-struct Scsi_Host *scsi_host_alloc(Scsi_Host_Template *sht, int privsize)
+struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 {
 	struct Scsi_Host *shost;
 	int gfp_mask = GFP_KERNEL, rval;
@@ -219,7 +219,7 @@
 	return NULL;
 }
 
-struct Scsi_Host *scsi_register(Scsi_Host_Template *sht, int privsize)
+struct Scsi_Host *scsi_register(struct scsi_host_template *sht, int privsize)
 {
 	struct Scsi_Host *shost = scsi_host_alloc(sht, privsize);
 
diff -Nru a/drivers/scsi/hosts.h b/drivers/scsi/hosts.h
--- a/drivers/scsi/hosts.h	Thu Jun  5 18:52:51 2003
+++ b/drivers/scsi/hosts.h	Thu Jun  5 18:52:51 2003
@@ -49,14 +49,7 @@
  *	 used in one scatter-gather request.
  */
 
-/*
- * The Scsi_Host_Template type has all that is needed to interface with a SCSI
- * host in a device independent matter.	 There is one entry for each different
- * type of host adapter that is supported on the system.
- */
-
-typedef struct	SHT
-{
+struct scsi_host_template {
     /* Used with loadable modules so that we know when it is safe to unload */
     struct module * module;
 
@@ -91,7 +84,7 @@
      * passed to scsi.c in the processing of the command.  Note
      * especially that scsi_malloc/scsi_free must not be called.
      */
-    int (* detect)(struct SHT *);
+    int (* detect)(struct scsi_host_template *);
 
     /* Used with loadable modules to unload the host structures.  Note:
      * there is a default action built into the modules code which may
@@ -374,16 +367,9 @@
      * module_init/module_exit.
      */
     struct list_head legacy_hosts;
-} Scsi_Host_Template;
+};
 
-/*
- * The scsi_hosts array is the array containing the data for all
- * possible <supported> scsi hosts.   This is similar to the
- * Scsi_Host_Template, except that we have one entry for each
- * actual physical host adapter on the system, stored as a linked
- * list.  Note that if there are 2 aha1542 boards, then there will
- * be two Scsi_Host entries, but only 1 Scsi_Host_Template entry.
- */
+typedef struct scsi_host_template Scsi_Host_Template;
 
 struct Scsi_Host
 {
@@ -413,7 +399,7 @@
                                           this is true. */
     unsigned int            eh_kill:1; /* set when killing the eh thread */
     wait_queue_head_t       host_wait;
-    Scsi_Host_Template    * hostt;
+    struct scsi_host_template *hostt;
     volatile unsigned short host_busy;   /* commands actually active on low-level */
     volatile unsigned short host_failed; /* commands that failed. */
     
@@ -577,7 +563,7 @@
 	class_interface_unregister(intf)
 
 
-extern struct Scsi_Host *scsi_host_alloc(Scsi_Host_Template *, int);
+extern struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *, int);
 extern int scsi_add_host(struct Scsi_Host *, struct device *);
 extern int scsi_remove_host(struct Scsi_Host *);
 extern void scsi_host_get(struct Scsi_Host *);
@@ -585,7 +571,7 @@
 extern struct Scsi_Host *scsi_host_lookup(unsigned short);
 
 /* legacy interfaces */
-extern struct Scsi_Host *scsi_register(Scsi_Host_Template *, int);
+extern struct Scsi_Host *scsi_register(struct scsi_host_template *, int);
 extern void scsi_unregister(struct Scsi_Host *);
 
 /**
@@ -606,6 +592,6 @@
         return NULL;
 }
 
-extern void scsi_sysfs_release_attributes(struct SHT *hostt);
+extern void scsi_sysfs_release_attributes(struct scsi_host_template *hostt);
 
 #endif
diff -Nru a/drivers/scsi/scsi_module.c b/drivers/scsi/scsi_module.c
--- a/drivers/scsi/scsi_module.c	Thu Jun  5 18:52:51 2003
+++ b/drivers/scsi/scsi_module.c	Thu Jun  5 18:52:51 2003
@@ -17,7 +17,7 @@
 
 static int __init init_this_scsi_driver(void)
 {
-	Scsi_Host_Template *sht = &driver_template;
+	struct scsi_host_template *sht = &driver_template;
 	struct Scsi_Host *shost;
 	struct list_head *l;
 	int error;
@@ -51,7 +51,7 @@
 
 static void __exit exit_this_scsi_driver(void)
 {
-	Scsi_Host_Template *sht = &driver_template;
+	struct scsi_host_template *sht = &driver_template;
 	struct Scsi_Host *shost, *s;
 
 	list_for_each_entry(shost, &sht->legacy_hosts, sht_legacy_list)
diff -Nru a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
--- a/drivers/scsi/scsi_proc.c	Thu Jun  5 18:52:51 2003
+++ b/drivers/scsi/scsi_proc.c	Thu Jun  5 18:52:51 2003
@@ -79,7 +79,7 @@
 
 void scsi_proc_host_add(struct Scsi_Host *shost)
 {
-	Scsi_Host_Template *sht = shost->hostt;
+	struct scsi_host_template *sht = shost->hostt;
 	struct proc_dir_entry *p;
 	char name[10];
 
@@ -112,7 +112,7 @@
 
 void scsi_proc_host_rm(struct Scsi_Host *shost)
 {
-	Scsi_Host_Template *sht = shost->hostt;
+	struct scsi_host_template *sht = shost->hostt;
 	char name[10];
 
 	if (sht->proc_info) {
diff -Nru a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
--- a/drivers/scsi/scsi_sysfs.c	Thu Jun  5 18:52:51 2003
+++ b/drivers/scsi/scsi_sysfs.c	Thu Jun  5 18:52:51 2003
@@ -487,7 +487,7 @@
 }
 EXPORT_SYMBOL(scsi_sysfs_modify_sdev_attribute);
 
-void scsi_sysfs_release_attributes(struct SHT *hostt)
+void scsi_sysfs_release_attributes(struct scsi_host_template *hostt)
 {
 	if(hostt->sdev_attrs != scsi_sysfs_sdev_attrs)
 		kfree(hostt->sdev_attrs);
diff -Nru a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
--- a/drivers/usb/storage/scsiglue.c	Thu Jun  5 18:52:51 2003
+++ b/drivers/usb/storage/scsiglue.c	Thu Jun  5 18:52:51 2003
@@ -360,7 +360,7 @@
  * this defines our host template, with which we'll allocate hosts
  */
 
-struct SHT usb_stor_host_template = {
+struct scsi_host_template usb_stor_host_template = {
 	/* basic userland interface stuff */
 	.name =				"usb-storage",
 	.proc_name =			"usb-storage",
diff -Nru a/drivers/usb/storage/scsiglue.h b/drivers/usb/storage/scsiglue.h
--- a/drivers/usb/storage/scsiglue.h	Thu Jun  5 18:52:51 2003
+++ b/drivers/usb/storage/scsiglue.h	Thu Jun  5 18:52:51 2003
@@ -47,7 +47,7 @@
 
 extern unsigned char usb_stor_sense_notready[18];
 extern unsigned char usb_stor_sense_invalidCDB[18];
-extern struct SHT usb_stor_host_template;
+extern struct scsi_host_template usb_stor_host_template;
 extern int usb_stor_scsiSense10to6(Scsi_Cmnd*);
 extern int usb_stor_scsiSense6to10(Scsi_Cmnd*);
 
