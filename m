From: Mike Anderson <andmike@us.ibm.com>
Subject: [RFC] scsi host sysfs support [4/4]
Date: Mon, 14 Apr 2003 11:42:21 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030414184221.GE4162@beaverton.ibm.com>
References: <20030414183759.GA4162@beaverton.ibm.com> <20030414183918.GB4162@beaverton.ibm.com> <20030414184008.GC4162@beaverton.ibm.com> <20030414184125.GD4162@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:36064 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S263663AbTDNS2h (for <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Apr 2003 14:28:37 -0400
Content-Disposition: inline
In-Reply-To: <20030414184125.GD4162@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, mochel@osdl.org, linux-hotplug-devel@lists.sourceforge.net, mdharm-scsi@one-eyed-alien.net

-andmike
--
Michael Anderson
andmike@us.ibm.com


DESC
Create a scsi_host subsystem under the scsi subsystem. Modified
scsi remove host cleanup.
EDESC


 drivers/scsi/hosts.c      |   24 +----
 drivers/scsi/hosts.h      |   11 +-
 drivers/scsi/scsi_scan.c  |    4 
 drivers/scsi/scsi_sysfs.c |  200 +++++++++++++++++++++++++++++++++-------------
 4 files changed, 160 insertions(+), 79 deletions(-)

diff -puN drivers/scsi/hosts.c~sysfs-scsi-hosts drivers/scsi/hosts.c
--- sysfs-bleed-2.5/drivers/scsi/hosts.c~sysfs-scsi-hosts	Mon Apr 14 10:11:59 2003
+++ sysfs-bleed-2.5-andmike/drivers/scsi/hosts.c	Mon Apr 14 10:11:59 2003
@@ -191,16 +191,6 @@ static int scsi_host_legacy_release(stru
 	return 0;
 }
 
-static int scsi_remove_legacy_host(struct Scsi_Host *shost)
-{
-	int error;
-
-	error = scsi_remove_host(shost);
-	if (!error)
-		(*shost->hostt->release)(shost);
-	return 0;
-}
-
 static int scsi_check_device_busy(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost = sdev->host;
@@ -266,11 +256,8 @@ int scsi_remove_host(struct Scsi_Host *s
 	list_for_each_entry(sdev, &shost->my_devices, siblings)
 		sdev->online = FALSE;
 
-	list_for_each_entry(sdev, &shost->my_devices, siblings)
-		if (scsi_check_device_busy(sdev))
-			return 1;
-
 	scsi_forget_host(shost);
+	scsi_sysfs_remove_host(shost);
 	return 0;
 }
 
@@ -291,10 +278,9 @@ int scsi_add_host(struct Scsi_Host *shos
 	printk(KERN_INFO "scsi%d : %s\n", shost->host_no,
 			sht->info ? sht->info(shost) : sht->name);
 
-	if (dev) {
-		dev->class_data = shost;
-		shost->host_gendev = dev;
-	}
+	error = scsi_sysfs_add_host(shost, dev);
+	if (error)
+		return error;
 
 	scsi_scan_host(shost);
 			
@@ -523,7 +509,7 @@ out_of_space:
  **/
 int scsi_unregister_host(Scsi_Host_Template *shost_tp)
 {
-	scsi_tp_for_each_host(shost_tp, scsi_remove_legacy_host);
+	scsi_tp_for_each_host(shost_tp, scsi_remove_host);
 	return 0;
 
 }
diff -puN drivers/scsi/hosts.h~sysfs-scsi-hosts drivers/scsi/hosts.h
--- sysfs-bleed-2.5/drivers/scsi/hosts.h~sysfs-scsi-hosts	Mon Apr 14 10:11:59 2003
+++ sysfs-bleed-2.5-andmike/drivers/scsi/hosts.h	Mon Apr 14 10:49:25 2003
@@ -487,9 +487,10 @@ struct Scsi_Host
     unsigned int max_host_blocked;
 
     /* 
-     * Support for driverfs filesystem
+     * Support for sysfs
      */
     struct device *host_gendev;
+    struct kobject kobj;
 
     /*
      * We should ensure that this is aligned, both for better performance
@@ -500,8 +501,9 @@ struct Scsi_Host
         __attribute__ ((aligned (sizeof(unsigned long))));
 };
 
-#define	to_scsi_host(d)	d->class_data
-	
+#define	to_scsi_host(d)		\
+	container_of(d, struct Scsi_Host, kobj)
+
 /*
  * These two functions are used to allocate and free a pseudo device
  * which will connect to the host adapter itself rather than any
@@ -537,6 +539,7 @@ static inline struct device *scsi_get_de
  */
 extern void scsi_scan_host(struct Scsi_Host *);
 extern void scsi_forget_host(struct Scsi_Host *);
+extern void scsi_free_sdev(struct scsi_device *);
 
 
 struct Scsi_Device_Template
@@ -611,6 +614,8 @@ static inline Scsi_Device *scsi_find_dev
  */
 extern int scsi_upper_driver_register(struct Scsi_Device_Template *);
 extern void scsi_upper_driver_unregister(struct Scsi_Device_Template *);
+extern int scsi_sysfs_add_host(struct Scsi_Host *, struct device *);
+extern void scsi_sysfs_remove_host(struct Scsi_Host *);
 
 
 #endif
diff -puN drivers/scsi/scsi_sysfs.c~sysfs-scsi-hosts drivers/scsi/scsi_sysfs.c
--- sysfs-bleed-2.5/drivers/scsi/scsi_sysfs.c~sysfs-scsi-hosts	Mon Apr 14 10:11:59 2003
+++ sysfs-bleed-2.5-andmike/drivers/scsi/scsi_sysfs.c	Mon Apr 14 10:27:20 2003
@@ -14,6 +14,20 @@
 #include "scsi.h"
 #include "hosts.h"
 
+struct shost_attribute {
+	struct attribute attr;
+	ssize_t(*show) (struct Scsi_Host *, char *);
+	ssize_t (*store)(struct device *, const char *, size_t);
+};
+
+#define to_shost_attr(_attr) container_of(_attr,struct shost_attribute,attr)
+
+#define SHOST_ATTR(_name,_mode,_show,_store) \
+struct shost_attribute shost_attr_##_name = { 		\
+	.attr = {.name = __stringify(_name), .mode = _mode },	\
+	.show	= _show,				\
+	.store	= _store,				\
+};
 
 /*
  * shost_show_function: macro to create an attr function that can be used to
@@ -21,10 +35,9 @@
  */
 #define shost_show_function(field, format_string)			\
 static ssize_t								\
-show_##field (struct device *dev, char *buf)				\
+show_##field (struct Scsi_Host * shost,  char *buf)			\
 {									\
-	struct Scsi_Host *shost = to_scsi_host(dev);			\
-	return snprintf (buf, 20, format_string, shost->field);	\
+	return snprintf (buf, 20, format_string, shost->field);		\
 }
 
 /*
@@ -32,8 +45,24 @@ show_##field (struct device *dev, char *
  * read only field.
  */
 #define shost_rd_attr(field, format_string)				\
-	shost_show_function(field, format_string)				\
-static DEVICE_ATTR(field, S_IRUGO, show_##field, NULL)
+	shost_show_function(field, format_string)			\
+static SHOST_ATTR(field, S_IRUGO, show_##field, NULL)
+
+static ssize_t
+shost_attr_show(struct kobject * kobj, struct attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = to_scsi_host(kobj);
+	struct shost_attribute *shost_attr = to_shost_attr(attr);
+	ssize_t ret = 0;
+
+	if (shost_attr->show)
+		ret = shost_attr->show(shost, buf);
+	return ret;
+}
+
+static struct sysfs_ops shost_attr_ops = {
+	.show = shost_attr_show,
+};
 
 /*
  * Create the actual show/store functions and data structures.
@@ -44,36 +73,12 @@ shost_rd_attr(cmd_per_lun, "%hd\n");
 shost_rd_attr(sg_tablesize, "%hu\n");
 shost_rd_attr(unchecked_isa_dma, "%d\n");
 
-static struct device_attribute *const shost_attrs[] = {
-	&dev_attr_unique_id,
-	&dev_attr_host_busy,
-	&dev_attr_cmd_per_lun,
-	&dev_attr_sg_tablesize,
-	&dev_attr_unchecked_isa_dma,
-};
-
-static int scsi_host_class_add_dev(struct device * dev)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(shost_attrs); i++)
-		device_create_file(dev, shost_attrs[i]);
-
-	return 0;
-}
-
-static void scsi_host_class_rm_dev(struct device * dev)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(shost_attrs); i++)
-		device_remove_file(dev, shost_attrs[i]);
-}
-
-struct device_class shost_devclass = {
-	.name		= "scsi-host",
-	.add_device	= scsi_host_class_add_dev,
-	.remove_device	= scsi_host_class_rm_dev,
+static struct attribute * shost_attrs[] = {
+	&shost_attr_unique_id.attr,
+	&shost_attr_host_busy.attr,
+	&shost_attr_cmd_per_lun.attr,
+	&shost_attr_sg_tablesize.attr,
+	&shost_attr_unchecked_isa_dma.attr,
 };
 
 /**
@@ -101,29 +106,11 @@ static int scsi_bus_match(struct device 
         return 0;
 }
 
-
 static struct bus_type scsi_bus_type = {
         .name		= "scsi",
         .match		= scsi_bus_match,
 };
 
-static decl_subsys(scsi, NULL);
-
-int scsi_sysfs_register(void)
-{
-	bus_register(&scsi_bus_type);
-	subsystem_register(&scsi_subsys);
-	devclass_register(&shost_devclass);
-
-	return 0;
-}
-
-void scsi_sysfs_unregister(void)
-{
-	devclass_unregister(&shost_devclass);
-	subsystem_unregister(&scsi_subsys);
-	bus_unregister(&scsi_bus_type);
-}
 
 /**
  * scsi_upper_driver_register - register upper level driver.
@@ -272,6 +259,18 @@ static struct device_attribute * const s
 	&dev_attr_rescan,
 };
 
+
+static void scsi_device_release(struct device *dev)
+{
+	struct scsi_device *sdev;
+
+	sdev = to_scsi_device(dev);
+	if (!sdev)
+		return;
+	printk("%s: sdev: %s\n", __FUNCTION__, dev->bus_id);
+	scsi_free_sdev(sdev);	
+}
+
 /**
  * scsi_device_register - register a scsi device with the scsi bus
  * @sdev:	scsi_device to register
@@ -285,8 +284,9 @@ int scsi_device_register(struct scsi_dev
 
 	sprintf(sdev->sdev_driverfs_dev.bus_id,"%d:%d:%d:%d",
 		sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
-	sdev->sdev_driverfs_dev.parent = sdev->host->host_gendev;
+	sdev->sdev_driverfs_dev.kobj.parent = &sdev->host->kobj;
 	sdev->sdev_driverfs_dev.bus = &scsi_bus_type;
+	sdev->sdev_driverfs_dev.release = scsi_device_release;
 
 	error = device_register(&sdev->sdev_driverfs_dev);
 	if (error)
@@ -314,3 +314,95 @@ void scsi_device_unregister(struct scsi_
 		device_remove_file(&sdev->sdev_driverfs_dev, sdev_attrs[i]);
 	device_unregister(&sdev->sdev_driverfs_dev);
 }
+
+static void scsi_host_release(struct kobject *kobj)
+{
+	struct Scsi_Host *shost;
+
+	shost = to_scsi_host(kobj);
+	if (!shost)
+		return;
+	printk("%s: kobj: %s\n", __FUNCTION__, kobj->name);
+	shost->hostt->release(shost);
+}
+
+static struct kobj_type ktype_scsi_host = {
+	.release	= scsi_host_release,
+	.sysfs_ops	= &shost_attr_ops, 
+	.default_attrs	= shost_attrs,
+};
+
+static decl_subsys(scsi_host, &ktype_scsi_host, NULL);
+
+/**
+ * scsi_sysfs_add_host - add scsi host to subsystem
+ * @shost:	scsi host struct to add to subsystem
+ * @dev:	parent struct device pointer
+ *
+ **/
+int scsi_sysfs_add_host(struct Scsi_Host *shost, struct device *dev)
+{
+	int error;
+	struct device *link_dev = (dev) ? dev : shost->host_gendev;
+
+	snprintf(shost->kobj.name, KOBJ_NAME_LEN, "host%d",
+		 shost->host_no);
+	kobj_set_kset_s(shost, scsi_host_subsys);
+	error = kobject_register(&shost->kobj);
+	if (error)
+		return error;
+	if (link_dev) {
+		error = sysfs_create_link(&shost->kobj,
+					  &link_dev->kobj,
+					  "adapter");
+		if (error)
+			goto clean;
+	}
+	return error;
+
+clean:
+	kobject_unregister(&shost->kobj);
+	return error;
+}
+
+/**
+ * scsi_sysfs_remove_host - remove scsi host from subsystem
+ * @shost:	scsi host to remove from subsystem
+ **/
+void scsi_sysfs_remove_host(struct Scsi_Host *shost)
+{
+	kobject_unregister(&shost->kobj);
+}
+
+static decl_subsys(scsi, NULL, NULL);
+
+int scsi_sysfs_register(void)
+{
+	int error;
+
+	error = bus_register(&scsi_bus_type);
+	if (error)
+		return error;
+	error = subsystem_register(&scsi_subsys);
+	if (error)
+		goto cleanup_bus_reg;
+	kset_set_kset_s(&scsi_host_subsys, scsi_subsys);
+	error = subsystem_register(&scsi_host_subsys);
+	if (error)
+		goto cleanup_sub_reg;
+
+	return 0;
+
+cleanup_sub_reg:
+	subsystem_unregister(&scsi_subsys);
+cleanup_bus_reg:
+	bus_unregister(&scsi_bus_type);
+	return error;
+}
+
+void scsi_sysfs_unregister(void)
+{
+	subsystem_unregister(&scsi_host_subsys);
+	subsystem_unregister(&scsi_subsys);
+	bus_unregister(&scsi_bus_type);
+}
diff -puN drivers/scsi/scsi_scan.c~sysfs-scsi-hosts drivers/scsi/scsi_scan.c
--- sysfs-bleed-2.5/drivers/scsi/scsi_scan.c~sysfs-scsi-hosts	Mon Apr 14 10:11:59 2003
+++ sysfs-bleed-2.5-andmike/drivers/scsi/scsi_scan.c	Mon Apr 14 10:11:59 2003
@@ -489,7 +489,7 @@ out:
  *     Undo the actions in scsi_alloc_sdev, including removing @sdev from
  *     the list, and freeing @sdev.
  **/
-static void scsi_free_sdev(struct scsi_device *sdev)
+void scsi_free_sdev(struct scsi_device *sdev)
 {
 	list_del(&sdev->siblings);
 	list_del(&sdev->same_target_siblings);
@@ -1706,8 +1706,6 @@ int scsi_remove_device(struct scsi_devic
 
 	devfs_unregister(sdev->de);
 	scsi_device_unregister(sdev);
-
-	scsi_free_sdev(sdev);
 	return 0;
 }
 

_
