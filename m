From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] revamp legacy host registration
Date: Fri, 6 Jun 2003 10:03:20 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030606080320.GD18838@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:14801 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S265316AbTFFHtv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2003 03:49:51 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

The legacy host registration/unregistration is the last user
of the scsi_host_list but it really wants a per-template list
instead, so switch to one that is maintained in
scsi_register/scsi_unregister.  Also the legacy init/exit code
is small enough now to be self-contained in scsi_module.c now.

This second version also has proper failure handling in the
init_this_scsi_driver


diff -Nru a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c	Thu Jun  5 12:05:44 2003
+++ b/drivers/scsi/hosts.c	Thu Jun  5 12:05:44 2003
@@ -20,16 +20,8 @@
  *  September 04, 2002 Mike Anderson (andmike@us.ibm.com)
  */
 
-
-/*
- *  This file contains the medium level SCSI
- *  host interface initialization, as well as the scsi_hosts list of SCSI
- *  hosts currently present in the system.
- */
-
-#include <linux/config.h>
 #include <linux/module.h>
-#include <linux/blk.h>
+#include <linux/blkdev.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/mm.h>
@@ -45,42 +37,9 @@
 #include "scsi_logging.h"
 
 
-static LIST_HEAD(scsi_host_list);
-static spinlock_t scsi_host_list_lock = SPIN_LOCK_UNLOCKED;
-
 static int scsi_host_next_hn;		/* host_no for next new host */
 
 /**
- * scsi_tp_for_each_host - call function for each scsi host off a template
- * @shost_tp:	a pointer to a scsi host template
- * @callback:	a pointer to callback function
- *
- * Return value:
- * 	0 on Success / 1 on Failure
- **/
-int scsi_tp_for_each_host(Scsi_Host_Template *shost_tp, int
-			    (*callback)(struct Scsi_Host *shost))
-{
-	struct list_head *lh, *lh_sf;
-	struct Scsi_Host *shost;
-
-	spin_lock(&scsi_host_list_lock);
-
-	list_for_each_safe(lh, lh_sf, &scsi_host_list) {
-		shost = list_entry(lh, struct Scsi_Host, sh_list);
-		if (shost->hostt == shost_tp) {
-			spin_unlock(&scsi_host_list_lock);
-			callback(shost);
-			spin_lock(&scsi_host_list_lock);
-		}
-	}
-
-	spin_unlock(&scsi_host_list_lock);
-
-	return 0;
-}
-
-/**
  * scsi_remove_host - check a scsi host for release and release
  * @shost:	a pointer to a scsi host to release
  *
@@ -103,9 +62,6 @@
 	scsi_forget_host(shost);
 	scsi_sysfs_remove_host(shost);
 
-	if (shost->hostt->release)
-		(*shost->hostt->release)(shost);
-
 	return 0;
 }
 
@@ -129,7 +85,7 @@
 	if (!error) {
 		scsi_proc_host_add(shost);
 		scsi_scan_host(shost);
-	};
+	}
 			
 	return error;
 }
@@ -140,14 +96,6 @@
  **/
 void scsi_free_shost(struct Scsi_Host *shost)
 {
-	/* Remove shost from scsi_host_list */
-	spin_lock(&scsi_host_list_lock);
-	list_del(&shost->sh_list);
-	spin_unlock(&scsi_host_list_lock);
-
-	/*
-	 * Next, kill the kernel error recovery thread for this host.
-	 */
 	if (shost->ehandler) {
 		DECLARE_COMPLETION(sem);
 		shost->eh_notify = &sem;
@@ -255,10 +203,6 @@
 	else
 		shost->max_sectors = SCSI_DEFAULT_MAX_SECTORS;
 
-	spin_lock(&scsi_host_list_lock);
-	list_add_tail(&shost->sh_list, &scsi_host_list);
-	spin_unlock(&scsi_host_list_lock);
-
 	rval = scsi_setup_command_freelist(shost);
 	if (rval)
 		goto fail;
@@ -273,85 +217,29 @@
 	shost->hostt->present++;
 	return shost;
  fail:
-	spin_lock(&scsi_host_list_lock);
-	list_del(&shost->sh_list);
-	spin_unlock(&scsi_host_list_lock);
 	kfree(shost);
 	return NULL;
 }
 
 struct Scsi_Host *scsi_register(Scsi_Host_Template *sht, int privsize)
 {
-	return scsi_host_alloc(sht, privsize);
-}
-
-void scsi_unregister(struct Scsi_Host *shost)
-{
-	scsi_host_put(shost);
-}
-
-/**
- * scsi_register_host - register a low level host driver
- * @shost_tp:	pointer to a scsi host driver template
- *
- * Return value:
- * 	0 on Success / 1 on Failure.
- **/
-int scsi_register_host(Scsi_Host_Template *shost_tp)
-{
-	struct Scsi_Host *shost;
+	struct Scsi_Host *shost = scsi_host_alloc(sht, privsize);
 
-	BUG_ON(!shost_tp->detect);
-
-	if (!shost_tp->release) {
-		printk(KERN_WARNING
-		    "scsi HBA driver %s didn't set a release method, "
-		    "please fix the template\n", shost_tp->name);
+	if (!sht->detect) {
+		printk(KERN_WARNING "scsi_register() called on new-style "
+				    "template for driver %s\n", sht->name);
 		dump_stack();
-		return -EINVAL;
-		
 	}
 
-	shost_tp->detect(shost_tp);
-	if (!shost_tp->present)
-		return 0;
-
-	/*
-	 * XXX(hch) use scsi_tp_for_each_host() once it propagates
-	 *	    error returns properly.
-	 */
-	list_for_each_entry(shost, &scsi_host_list, sh_list)
-		if (shost->hostt == shost_tp)
-			if (scsi_add_host(shost, NULL))
-				goto out_of_space;
-
-	return 0;
-
-out_of_space:
-	scsi_unregister_host(shost_tp); /* easiest way to clean up?? */
-	return 1;
+	if (shost)
+		list_add_tail(&shost->sht_legacy_list, &sht->legacy_hosts);
+	return shost;
 }
 
-/**
- * scsi_unregister_host - unregister a low level host adapter driver
- * @shost_tp:	scsi host template to unregister.
- *
- * Description:
- * 	Similarly, this entry point should be called by a loadable module
- * 	if it is trying to remove a low level scsi driver from the system.
- *
- * Return value:
- * 	0 on Success / 1 on Failure
- *
- * Notes:
- * 	rmmod does not care what we return here the module will be
- * 	removed.
- **/
-int scsi_unregister_host(Scsi_Host_Template *shost_tp)
+void scsi_unregister(struct Scsi_Host *shost)
 {
-	scsi_tp_for_each_host(shost_tp, scsi_remove_host);
-	return 0;
-
+	list_del(&shost->sht_legacy_list);
+	scsi_host_put(shost);
 }
 
 /**
diff -Nru a/drivers/scsi/hosts.h b/drivers/scsi/hosts.h
--- a/drivers/scsi/hosts.h	Thu Jun  5 12:05:44 2003
+++ b/drivers/scsi/hosts.h	Thu Jun  5 12:05:44 2003
@@ -366,6 +366,14 @@
      */
     struct device_attribute **sdev_attrs;
 
+    /*
+     * List of hosts per template.
+     *
+     * This is only for use by scsi_module.c for legacy templates.
+     * For these access to it is synchronized implicitly by
+     * module_init/module_exit.
+     */
+    struct list_head legacy_hosts;
 } Scsi_Host_Template;
 
 /*
@@ -384,7 +392,6 @@
      * This information is private to the scsi mid-layer.  Wrapping it in a
      * struct private is a way of marking it in a sort of C++ type of way.
      */
-    struct list_head      sh_list;
     struct list_head	  my_devices;
 
     struct scsi_host_cmd_pool *cmd_pool;
@@ -498,6 +505,15 @@
     struct class_device class_dev;
 
     /*
+     * List of hosts per template.
+     *
+     * This is only for use by scsi_module.c for legacy templates.
+     * For these access to it is synchronized implicitly by
+     * module_init/module_exit.
+     */
+    struct list_head sht_legacy_list;
+
+    /*
      * We should ensure that this is aligned, both for better performance
      * and also because some compilers (m68k) don't automatically force
      * alignment to a long boundary.
@@ -569,11 +585,8 @@
 extern struct Scsi_Host *scsi_host_lookup(unsigned short);
 
 /* legacy interfaces */
-extern int scsi_register_host(Scsi_Host_Template *);
-extern int scsi_unregister_host(Scsi_Host_Template *);
 extern struct Scsi_Host *scsi_register(Scsi_Host_Template *, int);
 extern void scsi_unregister(struct Scsi_Host *);
-
 
 /**
  * scsi_find_device - find a device given the host
diff -Nru a/drivers/scsi/scsi_module.c b/drivers/scsi/scsi_module.c
--- a/drivers/scsi/scsi_module.c	Thu Jun  5 12:05:44 2003
+++ b/drivers/scsi/scsi_module.c	Thu Jun  5 12:05:44 2003
@@ -1,71 +1,73 @@
 /*
- *  scsi_module.c Copyright (1994, 1995) Eric Youngdale.
+ * Copyright (C) 2003 Christoph Hellwig.
+ *	Released under GPL v2.
  *
- * Support for loading low-level scsi drivers using the linux kernel loadable
- * module interface.
+ * Support for old-style host templates.
  *
- * To use, the host adapter should first define and initialize the variable
- * driver_template (datatype Scsi_Host_Template), and then include this file.
- * This should also be wrapped in a #ifdef MODULE/#endif.
- *
- * The low -level driver must also define a release function which will
- * free any irq assignments, release any dma channels, release any I/O
- * address space that might be reserved, and otherwise clean up after itself.
- * The idea is that the same driver should be able to be reloaded without
- * any difficulty.  This makes debugging new drivers easier, as you should
- * be able to load the driver, test it, unload, modify and reload.
- *
- * One *very* important caveat.  If the driver may need to do DMA on the
- * ISA bus, you must have unchecked_isa_dma set in the device template,
- * even if this might be changed during the detect routine.  This is
- * because the shpnt structure will be allocated in a special way so that
- * it will be below the appropriate DMA limit - thus if your driver uses
- * the hostdata field of shpnt, and the board must be able to access this
- * via DMA, the shpnt structure must be in a DMA accessible region of
- * memory.  This comment would be relevant for something like the buslogic
- * driver where there are many boards, only some of which do DMA onto the
- * ISA bus.  There is no convenient way of specifying whether the host
- * needs to be in a ISA DMA accessible region of memory when you call
- * scsi_register.
+ * NOTE:  Do not use this for new drivers ever.
  */
 
-#include <linux/module.h>
 #include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include "scsi.h"
+#include "hosts.h"
+
 
 static int __init init_this_scsi_driver(void)
 {
-	driver_template.module = THIS_MODULE;
-	scsi_register_host(&driver_template);
-	if (driver_template.present)
-		return 0;
-
-	scsi_unregister_host(&driver_template);
-	return -ENODEV;
+	Scsi_Host_Template *sht = &driver_template;
+	struct Scsi_Host *shost;
+	struct list_head *l;
+	int error;
+
+	if (!sht->release) {
+		printk(KERN_ERR
+		    "scsi HBA driver %s didn't set a release method.\n",
+		    sht->name);
+		return -EINVAL;
+	}
+
+	sht->module = THIS_MODULE;
+	INIT_LIST_HEAD(&sht->legacy_hosts);
+
+	sht->detect(sht);
+	if (!sht->present)
+		return -ENODEV;
+
+	list_for_each_entry(shost, &sht->legacy_hosts, sht_legacy_list) {
+		error = scsi_add_host(shost, NULL);
+		if (error)
+			goto fail;
+	}
+	return 0;
+ fail:
+	l = &shost->sht_legacy_list;
+	while ((l = l->prev) != &sht->legacy_hosts)
+		scsi_remove_host(list_entry(l, struct Scsi_Host, sht_legacy_list));
+	return error;
 }
 
 static void __exit exit_this_scsi_driver(void)
 {
-	scsi_unregister_host(&driver_template);
+	Scsi_Host_Template *sht = &driver_template;
+	struct Scsi_Host *shost, *s;
+
+	list_for_each_entry(shost, &sht->legacy_hosts, sht_legacy_list)
+		scsi_remove_host(shost);
+	list_for_each_entry_safe(shost, s, &sht->legacy_hosts, sht_legacy_list)
+		sht->release(shost);
+
+	if (list_empty(&sht->legacy_hosts))
+		return;
+
+	printk(KERN_WARNING "%s did not call scsi_unregister\n", sht->name);
+	dump_stack();
+
+	list_for_each_entry_safe(shost, s, &sht->legacy_hosts, sht_legacy_list)
+		scsi_unregister(shost);
 }
 
 module_init(init_this_scsi_driver);
 module_exit(exit_this_scsi_driver);
-
-/*
- * Overrides for Emacs so that we almost follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-indent-level: 4
- * c-brace-imaginary-offset: 0
- * c-brace-offset: -4
- * c-argdecl-indent: 4
- * c-label-offset: -4
- * c-continued-statement-offset: 4
- * c-continued-brace-offset: 0
- * indent-tabs-mode: nil
- * tab-width: 8
- * End:
- */
--- 1.39/drivers/scsi/scsi_syms.c	Thu Jun  5 11:24:55 2003
+++ edited/drivers/scsi/scsi_syms.c	Thu Jun  5 11:26:04 2003
@@ -31,8 +31,6 @@
  */
 EXPORT_SYMBOL(scsi_register_driver);
 EXPORT_SYMBOL(scsi_register_interface);
-EXPORT_SYMBOL(scsi_register_host);
-EXPORT_SYMBOL(scsi_unregister_host);
 EXPORT_SYMBOL(scsi_host_alloc);
 EXPORT_SYMBOL(scsi_add_host);
 EXPORT_SYMBOL(scsi_remove_host);
