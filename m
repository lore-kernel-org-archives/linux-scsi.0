From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] place host-related LDM code directly in hosts.c
Date: Fri, 8 Aug 2003 21:14:42 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030808191442.GA18187@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:58498 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S272008AbTHHTOr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Aug 2003 15:14:47 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This was in scsi_sysfs.c previously but given that it's not
sysfs-related and the whole scsi code is built around the driver
model now it's better to have it where it belongs.  Also allows
us to reduce the scsi_mod-wide globals.


diff -Nru a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c	Fri Aug  8 11:13:36 2003
+++ b/drivers/scsi/hosts.c	Fri Aug  8 11:13:36 2003
@@ -40,6 +40,16 @@
 static int scsi_host_next_hn;		/* host_no for next new host */
 
 
+static void scsi_host_cls_release(struct class_device *class_dev)
+{
+	put_device(&class_to_shost(class_dev)->shost_gendev);
+}
+
+static struct class shost_class = {
+	.name		= "scsi_host",
+	.release	= scsi_host_cls_release,
+};
+
 /**
  * scsi_host_cancel - cancel outstanding IO to this host
  * @shost:	pointer to struct Scsi_Host
@@ -64,10 +74,18 @@
  **/
 void scsi_remove_host(struct Scsi_Host *shost)
 {
+	unsigned long flags;
+
 	scsi_host_cancel(shost, 0);
 	scsi_proc_host_rm(shost);
 	scsi_forget_host(shost);
-	scsi_sysfs_remove_host(shost);
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	set_bit(SHOST_DEL, &shost->shost_state);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	class_device_unregister(&shost->shost_classdev);
+	device_del(&shost->shost_gendev);
 }
 
 /**
@@ -89,21 +107,45 @@
 	if (!shost->can_queue) {
 		printk(KERN_ERR "%s: can_queue = 0 no longer supported\n",
 				sht->name);
-		error = -EINVAL;
+		return -EINVAL;
 	}
 
-	error = scsi_sysfs_add_host(shost, dev);
-	if (!error)
-		scsi_proc_host_add(shost);
+	if (!shost->shost_gendev.parent)
+		shost->shost_gendev.parent = dev ? dev : &legacy_bus;
+
+	error = device_add(&shost->shost_gendev);
+	if (error)
+		goto out;
+
+	set_bit(SHOST_ADD, &shost->shost_state);
+	get_device(shost->shost_gendev.parent);
+
+	error = class_device_add(&shost->shost_classdev);
+	if (error)
+		goto out_del_gendev;
+
+	get_device(&shost->shost_gendev);
+
+	error = scsi_sysfs_add_host(shost);
+	if (error)
+		goto out_del_classdev;
+
+	scsi_proc_host_add(shost);
+	return error;
+
+ out_del_classdev:
+	class_device_del(&shost->shost_classdev);
+ out_del_gendev:
+	device_del(&shost->shost_gendev);
+ out:
 	return error;
 }
 
-/**
- * scsi_free_sdev - free a scsi hosts resources
- * @shost:	scsi host to free 
- **/
-void scsi_free_shost(struct Scsi_Host *shost)
+static void scsi_host_dev_release(struct device *dev)
 {
+	struct Scsi_Host *shost = dev_to_shost(dev);
+	struct device *parent = dev->parent;
+
 	if (shost->ehandler) {
 		DECLARE_COMPLETION(sem);
 		shost->eh_notify = &sem;
@@ -115,6 +157,8 @@
 
 	scsi_proc_hostdir_rm(shost->hostt);
 	scsi_destroy_command_freelist(shost);
+
+	put_device(parent);
 	kfree(shost);
 }
 
@@ -214,7 +258,18 @@
 	if (rval)
 		goto fail;
 
-	scsi_sysfs_init_host(shost);
+	device_initialize(&shost->shost_gendev);
+	snprintf(shost->shost_gendev.bus_id, BUS_ID_SIZE, "host%d",
+		shost->host_no);
+	snprintf(shost->shost_gendev.name, DEVICE_NAME_SIZE, "%s",
+		shost->hostt->proc_name);
+	shost->shost_gendev.release = scsi_host_dev_release;
+
+	class_device_initialize(&shost->shost_classdev);
+	shost->shost_classdev.dev = &shost->shost_gendev;
+	shost->shost_classdev.class = &shost_class;
+	snprintf(shost->shost_classdev.class_id, BUS_ID_SIZE, "host%d",
+		  shost->host_no);
 
 	shost->eh_notify = &complete;
 	/* XXX(hch): handle error return */
@@ -298,4 +353,14 @@
 void scsi_host_put(struct Scsi_Host *shost)
 {
 	put_device(&shost->shost_gendev);
+}
+
+int scsi_init_hosts(void)
+{
+	return class_register(&shost_class);
+}
+
+void scsi_exit_hosts(void)
+{
+	class_unregister(&shost_class);
 }
diff -Nru a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c	Fri Aug  8 11:13:36 2003
+++ b/drivers/scsi/scsi.c	Fri Aug  8 11:13:36 2003
@@ -1003,9 +1003,12 @@
 	error = scsi_init_devinfo();
 	if (error)
 		goto cleanup_procfs;
-	error = scsi_sysfs_register();
+	error = scsi_init_hosts();
 	if (error)
 		goto cleanup_devlist;
+	error = scsi_sysfs_register();
+	if (error)
+		goto cleanup_hosts;
 
 	for (i = 0; i < NR_CPUS; i++)
 		INIT_LIST_HEAD(&done_q[i]);
@@ -1015,6 +1018,8 @@
 	printk(KERN_NOTICE "SCSI subsystem initialized\n");
 	return 0;
 
+cleanup_hosts:
+	scsi_exit_hosts();
 cleanup_devlist:
 	scsi_exit_devinfo();
 cleanup_procfs:
@@ -1029,6 +1034,7 @@
 static void __exit exit_scsi(void)
 {
 	scsi_sysfs_unregister();
+	scsi_exit_hosts();
 	scsi_exit_devinfo();
 	devfs_remove("scsi");
 	scsi_exit_procfs();
diff -Nru a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
--- a/drivers/scsi/scsi_priv.h	Fri Aug  8 11:13:36 2003
+++ b/drivers/scsi/scsi_priv.h	Fri Aug  8 11:13:36 2003
@@ -51,6 +51,9 @@
 	unsigned int		starget_refcnt;
 };
 
+/* hosts.c */
+extern int scsi_init_hosts(void);
+extern void scsi_exit_hosts(void);
 
 /* scsi.c */
 extern int scsi_dispatch_cmd(struct scsi_cmnd *cmd);
@@ -108,18 +111,14 @@
 /* scsi_scan.c */
 extern void scsi_forget_host(struct Scsi_Host *);
 extern void scsi_free_sdev(struct scsi_device *);
-extern void scsi_free_shost(struct Scsi_Host *);
 extern void scsi_rescan_device(struct device *);
 
 /* scsi_sysfs.c */
 extern int scsi_device_register(struct scsi_device *);
-extern void scsi_sysfs_init_host(struct Scsi_Host *);
-extern int scsi_sysfs_add_host(struct Scsi_Host *, struct device *);
-extern void scsi_sysfs_remove_host(struct Scsi_Host *);
+extern int scsi_sysfs_add_host(struct Scsi_Host *);
 extern int scsi_sysfs_register(void);
 extern void scsi_sysfs_unregister(void);
 
-extern struct class shost_class;
 extern struct class sdev_class;
 extern struct bus_type scsi_bus_type;
 
diff -Nru a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
--- a/drivers/scsi/scsi_sysfs.c	Fri Aug  8 11:13:36 2003
+++ b/drivers/scsi/scsi_sysfs.c	Fri Aug  8 11:13:36 2003
@@ -54,30 +54,6 @@
 	NULL
 };
 
-static void scsi_host_cls_release(struct class_device *class_dev)
-{
-	struct Scsi_Host *shost;
-
-	shost = class_to_shost(class_dev);
-	put_device(&shost->shost_gendev);
-}
-
-static void scsi_host_dev_release(struct device *dev)
-{
-	struct Scsi_Host *shost;
-	struct device *parent;
-
-	parent = dev->parent;
-	shost = dev_to_shost(dev);
-	scsi_free_shost(shost);
-	put_device(parent);
-}
-
-struct class shost_class = {
-	.name		= "scsi_host",
-	.release	= scsi_host_cls_release,
-};
-
 static void scsi_device_cls_release(struct class_device *class_dev)
 {
 	struct scsi_device *sdev;
@@ -119,27 +95,18 @@
 	int error;
 
 	error = bus_register(&scsi_bus_type);
-	if (error)
-		return error;
-	error = class_register(&shost_class);
-	if (error)
-		goto bus_unregister;
-	error = class_register(&sdev_class);
-	if (error)
-		goto class_unregister;
-	return 0;
-
- class_unregister:
-	class_unregister(&shost_class);
- bus_unregister:
-	bus_unregister(&scsi_bus_type);
+	if (!error) {
+		error = class_register(&sdev_class);
+		if (error)
+			bus_unregister(&scsi_bus_type);
+	}
+
 	return error;
 }
 
 void scsi_sysfs_unregister(void)
 {
 	class_unregister(&sdev_class);
-	class_unregister(&shost_class);
 	bus_unregister(&scsi_bus_type);
 }
 
@@ -403,22 +370,6 @@
 }
 
 
-void scsi_sysfs_init_host(struct Scsi_Host *shost)
-{
-	device_initialize(&shost->shost_gendev);
-	snprintf(shost->shost_gendev.bus_id, BUS_ID_SIZE, "host%d",
-		shost->host_no);
-	snprintf(shost->shost_gendev.name, DEVICE_NAME_SIZE, "%s",
-		shost->hostt->proc_name);
-	shost->shost_gendev.release = scsi_host_dev_release;
-
-	class_device_initialize(&shost->shost_classdev);
-	shost->shost_classdev.dev = &shost->shost_gendev;
-	shost->shost_classdev.class = &shost_class;
-	snprintf(shost->shost_classdev.class_id, BUS_ID_SIZE, "host%d",
-		  shost->host_no);
-}
-
 static struct class_device_attribute *class_attr_overridden(
 		struct class_device_attribute **attrs,
 		struct class_device_attribute *attr)
@@ -461,31 +412,16 @@
  * @shost:     scsi host struct to add to subsystem
  * @dev:       parent struct device pointer
  **/
-int scsi_sysfs_add_host(struct Scsi_Host *shost, struct device *dev)
+int scsi_sysfs_add_host(struct Scsi_Host *shost)
 {
 	int error, i;
 
-	if (!shost->shost_gendev.parent)
-		shost->shost_gendev.parent = dev ? dev : &legacy_bus;
-
-	error = device_add(&shost->shost_gendev);
-	if (error)
-		return error;
-
-	set_bit(SHOST_ADD, &shost->shost_state);
-	get_device(shost->shost_gendev.parent);
-
-	error = class_device_add(&shost->shost_classdev);
-	if (error)
-		goto clean_device;
-
-	get_device(&shost->shost_gendev);
 	if (shost->hostt->shost_attrs) {
 		for (i = 0; shost->hostt->shost_attrs[i]; i++) {
 			error = class_attr_add(&shost->shost_classdev,
 					shost->hostt->shost_attrs[i]);
 			if (error)
-				goto clean_class;
+				return error;
 		}
 	}
 
@@ -495,31 +432,9 @@
 			error = class_device_create_file(&shost->shost_classdev,
 					scsi_sysfs_shost_attrs[i]);
 			if (error)
-				goto clean_class;
+				return error;
 		}
 	}
 
-	return error;
-
-clean_class:
-	class_device_del(&shost->shost_classdev);
-clean_device:
-	device_del(&shost->shost_gendev);
-
-	return error;
-}
-
-/**
- * scsi_sysfs_remove_host - remove scsi host from subsystem
- * @shost:     scsi host to remove from subsystem
- **/
-void scsi_sysfs_remove_host(struct Scsi_Host *shost)
-{
-	unsigned long flags;
-	spin_lock_irqsave(shost->host_lock, flags);
-	set_bit(SHOST_DEL, &shost->shost_state);
-	spin_unlock_irqrestore(shost->host_lock, flags);
-
-	class_device_unregister(&shost->shost_classdev);
-	device_del(&shost->shost_gendev);
+	return 0;
 }
