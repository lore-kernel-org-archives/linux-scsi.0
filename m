From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] rework shost/sdev attribute handling
Date: Mon, 7 Jul 2003 08:21:13 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030707062113.GB27465@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:37023 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S266821AbTGGGGn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jul 2003 02:06:43 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

Hi James,

I've finally found some time to look over the per-driver sdev/shost attribute
handling and I'm not so happy with it.  First it adds new writeable
variables to the host templates which is otherwise almost readonly,
the other thing is that it needs per-template procedure calls in the
drivers wheras we have moved away from that.  Also it looks a bit
coplicated :)

I've attached a patch below that makes the attributes handling a lot
simpler.  Details:

 - the shost_attrs and sdev_attrs in the host template are now used
   to store the attributes overriden or added by the LLDD.
 - the midlayer creates those first and then the generic attributes
   that haven't been overridded and the other way around.
 - the host attributes are properly unregistered now and don't leak
   anymore.

Unlike the first patch the attribute inheritance is back.


diff -Nru a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
--- a/drivers/scsi/53c700.c	Sat Jul  5 22:53:43 2003
+++ b/drivers/scsi/53c700.c	Sat Jul  5 22:53:43 2003
@@ -172,7 +172,7 @@
 STATIC int NCR_700_slave_configure(Scsi_Device *SDpnt);
 STATIC void NCR_700_slave_destroy(Scsi_Device *SDpnt);
 
-static struct device_attribute **NCR_700_dev_attrs = NULL;
+STATIC struct device_attribute *NCR_700_dev_attrs[];
 
 static char *NCR_700_phase[] = {
 	"",
@@ -2027,25 +2027,12 @@
 	.show = NCR_700_show_active_tags,
 };
 
-STATIC int __init
-NCR_700_init(void)
-{
-	scsi_sysfs_modify_sdev_attribute(&NCR_700_dev_attrs,
-					 &NCR_700_queue_depth_attr);
-	scsi_sysfs_modify_sdev_attribute(&NCR_700_dev_attrs,
-					 &NCR_700_active_tags_attr);
-	return 0;
-}
-
-/* NULL exit routine to keep modutils happy */
-STATIC void __exit
-NCR_700_exit(void)
-{
-}
+STATIC struct device_attribute *NCR_700_dev_attrs[] = {
+	&NCR_700_queue_depth_attr,
+	&NCR_700_active_tags_attr,
+	NULL,
+};
 
 EXPORT_SYMBOL(NCR_700_detect);
 EXPORT_SYMBOL(NCR_700_release);
 EXPORT_SYMBOL(NCR_700_intr);
-
-module_init(NCR_700_init);
-module_exit(NCR_700_exit);
diff -Nru a/drivers/scsi/NCR_D700.c b/drivers/scsi/NCR_D700.c
--- a/drivers/scsi/NCR_D700.c	Sat Jul  5 22:53:43 2003
+++ b/drivers/scsi/NCR_D700.c	Sat Jul  5 22:53:43 2003
@@ -387,7 +387,6 @@
 static void __exit NCR_D700_exit(void)
 {
 	mca_unregister_driver(&NCR_D700_driver);
-	scsi_sysfs_release_attributes(&NCR_D700_driver_template);
 }
 
 module_init(NCR_D700_init);
diff -Nru a/drivers/scsi/NCR_Q720.c b/drivers/scsi/NCR_Q720.c
--- a/drivers/scsi/NCR_Q720.c	Sat Jul  5 22:53:43 2003
+++ b/drivers/scsi/NCR_Q720.c	Sat Jul  5 22:53:43 2003
@@ -347,7 +347,6 @@
 NCR_Q720_exit(void)
 {
 	mca_unregister_driver(&NCR_Q720_driver);
-	//scsi_sysfs_release_attributes(&NCR_Q720_driver_template);
 }
 
 module_init(NCR_Q720_init);
diff -Nru a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c	Sat Jul  5 22:53:43 2003
+++ b/drivers/scsi/hosts.c	Sat Jul  5 22:53:43 2003
@@ -151,12 +151,6 @@
 		dump_stack();
         }
 
-	/* if its not set in the template, use the default */
-	if (!sht->shost_attrs)
-		 sht->shost_attrs = scsi_sysfs_shost_attrs;
-	if (!sht->sdev_attrs)
-		 sht->sdev_attrs = scsi_sysfs_sdev_attrs;
-
 	shost = kmalloc(sizeof(struct Scsi_Host) + privsize, gfp_mask);
 	if (!shost)
 		return NULL;
diff -Nru a/drivers/scsi/lasi700.c b/drivers/scsi/lasi700.c
--- a/drivers/scsi/lasi700.c	Sat Jul  5 22:53:43 2003
+++ b/drivers/scsi/lasi700.c	Sat Jul  5 22:53:43 2003
@@ -165,7 +165,6 @@
 lasi700_exit(void)
 {
 	unregister_parisc_driver(&lasi700_driver);
-	scsi_sysfs_release_attributes(&lasi700_template);
 }
 
 module_init(lasi700_init);
diff -Nru a/drivers/scsi/scsi.h b/drivers/scsi/scsi.h
--- a/drivers/scsi/scsi.h	Sat Jul  5 22:53:43 2003
+++ b/drivers/scsi/scsi.h	Sat Jul  5 22:53:43 2003
@@ -174,11 +174,6 @@
 #define SCSI_MLQUEUE_DEVICE_BUSY 0x1056
 #define SCSI_MLQUEUE_EH_RETRY    0x1057
 
-extern int scsi_sysfs_modify_sdev_attribute(struct device_attribute ***dev_attrs,
-					    struct device_attribute *attr);
-extern int scsi_sysfs_modify_shost_attribute(struct class_device_attribute ***class_attrs,
-					     struct class_device_attribute *attr);
-
 /*
  * Legacy dma direction interfaces.
  *
diff -Nru a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
--- a/drivers/scsi/scsi_priv.h	Sat Jul  5 22:53:43 2003
+++ b/drivers/scsi/scsi_priv.h	Sat Jul  5 22:53:43 2003
@@ -117,11 +117,6 @@
 extern int scsi_sysfs_register(void);
 extern void scsi_sysfs_unregister(void);
 
-/* definitions for the linker default sections covering the host
- * class and device attributes */
-extern struct class_device_attribute *scsi_sysfs_shost_attrs[];
-extern struct device_attribute *scsi_sysfs_sdev_attrs[];
-
 extern struct class shost_class;
 extern struct bus_type scsi_bus_type;
 
diff -Nru a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
--- a/drivers/scsi/scsi_sysfs.c	Sat Jul  5 22:53:43 2003
+++ b/drivers/scsi/scsi_sysfs.c	Sat Jul  5 22:53:43 2003
@@ -45,7 +45,7 @@
 shost_rd_attr(sg_tablesize, "%hu\n");
 shost_rd_attr(unchecked_isa_dma, "%d\n");
 
-struct class_device_attribute *scsi_sysfs_shost_attrs[] = {
+static struct class_device_attribute *scsi_sysfs_shost_attrs[] = {
 	&class_device_attr_unique_id,
 	&class_device_attr_host_busy,
 	&class_device_attr_cmd_per_lun,
@@ -204,7 +204,7 @@
 static DEVICE_ATTR(rescan, S_IWUSR, NULL, store_rescan_field)
 
 /* Default template for device attributes.  May NOT be modified */
-struct device_attribute *scsi_sysfs_sdev_attrs[] = {
+static struct device_attribute *scsi_sysfs_sdev_attrs[] = {
 	&dev_attr_device_blocked,
 	&dev_attr_queue_depth,
 	&dev_attr_type,
@@ -228,6 +228,42 @@
 	scsi_free_sdev(sdev);
 }
 
+static struct device_attribute *attr_overridden(
+		struct device_attribute **attrs,
+		struct device_attribute *attr)
+{
+	int i;
+
+	if (!attrs)
+		return NULL;
+	for (i = 0; attrs[i]; i++)
+		if (!strcmp(attrs[i]->attr.name, attr->attr.name))
+			return attrs[i];
+	return NULL;
+}
+
+static int attr_add(struct device *dev, struct device_attribute *attr)
+{
+	struct device_attribute *base_attr;
+
+	/*
+	 * Spare the caller from having to copy things it's not interested in.
+	 */
+	base_attr = attr_overridden(scsi_sysfs_sdev_attrs, attr);
+	if (base_attr) {
+		/* extend permissions */
+		attr->attr.mode |= base_attr->attr.mode;
+
+		/* override null show/store with default */
+		if (!attr->show)
+			attr->show = base_attr->show;
+		if (!attr->store)
+			attr->store = base_attr->store;
+	}
+
+	return device_create_file(dev, attr);
+}
+
 /**
  * scsi_device_register - register a scsi device with the scsi bus
  * @sdev:	scsi_device to register
@@ -264,12 +300,24 @@
 		return error;
 	}
 
-	for (i = 0; !error && sdev->host->hostt->sdev_attrs[i] != NULL; i++)
-		error = device_create_file(&sdev->sdev_gendev,
-					   sdev->host->hostt->sdev_attrs[i]);
-
-	if (error)
-		scsi_device_unregister(sdev);
+	if (sdev->host->hostt->sdev_attrs) {
+		for (i = 0; sdev->host->hostt->sdev_attrs[i]; i++) {
+			error = attr_add(&sdev->sdev_gendev,
+					sdev->host->hostt->sdev_attrs[i]);
+			if (error)
+				scsi_device_unregister(sdev);
+		}
+	}
+	
+	for (i = 0; scsi_sysfs_sdev_attrs[i]; i++) {
+		if (!attr_overridden(sdev->host->hostt->sdev_attrs,
+					scsi_sysfs_sdev_attrs[i])) {
+			error = device_create_file(&sdev->sdev_gendev,
+					scsi_sysfs_sdev_attrs[i]);
+			if (error)
+				scsi_device_unregister(sdev);
+		}
+	}
 
 	return error;
 }
@@ -280,10 +328,6 @@
  **/
 void scsi_device_unregister(struct scsi_device *sdev)
 {
-	int i;
-
-	for (i = 0; sdev->host->hostt->sdev_attrs[i] != NULL; i++)
-		device_remove_file(&sdev->sdev_gendev, sdev->host->hostt->sdev_attrs[i]);
 	class_device_unregister(&sdev->sdev_classdev);
 	device_unregister(&sdev->sdev_gendev);
 }
@@ -329,6 +373,43 @@
 		  shost->host_no);
 }
 
+static struct class_device_attribute *class_attr_overridden(
+		struct class_device_attribute **attrs,
+		struct class_device_attribute *attr)
+{
+	int i;
+
+	if (!attrs)
+		return NULL;
+	for (i = 0; attrs[i]; i++)
+		if (!strcmp(attrs[i]->attr.name, attr->attr.name))
+			return attrs[i];
+	return NULL;
+}
+
+static int class_attr_add(struct class_device *classdev,
+		struct class_device_attribute *attr)
+{
+	struct class_device_attribute *base_attr;
+
+	/*
+	 * Spare the caller from having to copy things it's not interested in.
+	 */
+	base_attr = class_attr_overridden(scsi_sysfs_shost_attrs, attr);
+	if (base_attr) {
+		/* extend permissions */
+		attr->attr.mode |= base_attr->attr.mode;
+
+		/* override null show/store with default */
+		if (!attr->show)
+			attr->show = base_attr->show;
+		if (!attr->store)
+			attr->store = base_attr->store;
+	}
+
+	return class_device_create_file(classdev, attr);
+}
+
 /**
  * scsi_sysfs_add_host - add scsi host to subsystem
  * @shost:     scsi host struct to add to subsystem
@@ -336,7 +417,7 @@
  **/
 int scsi_sysfs_add_host(struct Scsi_Host *shost, struct device *dev)
 {
-	int i, error;
+	int error, i;
 
 	if (!shost->shost_gendev.parent)
 		shost->shost_gendev.parent = dev ? dev : &legacy_bus;
@@ -349,11 +430,24 @@
 	if (error)
 		goto clean_device;
 
-	for (i = 0; !error && shost->hostt->shost_attrs[i] != NULL; i++)
-		error = class_device_create_file(&shost->shost_classdev,
-					   shost->hostt->shost_attrs[i]);
-	if (error)
-		goto clean_class;
+	if (shost->hostt->shost_attrs) {
+		for (i = 0; shost->hostt->shost_attrs[i]; i++) {
+			error = class_attr_add(&shost->shost_classdev,
+					shost->hostt->shost_attrs[i]);
+			if (error)
+				goto clean_class;
+		}
+	}
+
+	for (i = 0; scsi_sysfs_shost_attrs[i]; i++) {
+		if (!class_attr_overridden(shost->hostt->shost_attrs,
+					scsi_sysfs_shost_attrs[i])) {
+			error = class_device_create_file(&shost->shost_classdev,
+					scsi_sysfs_shost_attrs[i]);
+			if (error)
+				goto clean_class;
+		}
+	}
 
 	return error;
 
@@ -374,130 +468,3 @@
 	class_device_del(&shost->shost_classdev);
 	device_del(&shost->shost_gendev);
 }
-
-/** scsi_sysfs_modify_shost_attribute - modify or add a host class attribute
- *
- * @class_attrs:host class attribute list to be added to or modified
- * @attr:	individual attribute to change or added
- *
- * returns zero if successful or error if not
- **/
-int scsi_sysfs_modify_shost_attribute(
-			struct class_device_attribute ***class_attrs,
-			struct class_device_attribute *attr)
-{
-	int modify = -1;
-	int num_attrs;
-
-	if(*class_attrs == NULL)
-		*class_attrs = scsi_sysfs_shost_attrs;
-
-	for(num_attrs=0; (*class_attrs)[num_attrs] != NULL; num_attrs++)
-		if(strcmp((*class_attrs)[num_attrs]->attr.name,
-				attr->attr.name) == 0)
-			modify = num_attrs;
-
-	if(*class_attrs == scsi_sysfs_shost_attrs || modify < 0) {
-		/* note: need space for null at the end as well */
-		struct class_device_attribute **tmp_attrs =
-				kmalloc(sizeof(*tmp_attrs) *
-					  (num_attrs + (modify >= 0 ? 1 : 2)),
-					GFP_KERNEL);
-		if(tmp_attrs == NULL)
-			return -ENOMEM;
-		memcpy(tmp_attrs, *class_attrs, sizeof(*tmp_attrs) *
-				(num_attrs + 1));
-		if(*class_attrs != scsi_sysfs_shost_attrs)
-			kfree(*class_attrs);
-		*class_attrs = tmp_attrs;
-	}
-	if(modify >= 0) {
-		/* spare the caller from having to copy things it's
-		 * not interested in */
-		struct class_device_attribute *old_attr =
-			(*class_attrs)[modify];
-		/* extend permissions */
-		attr->attr.mode |= old_attr->attr.mode;
-
-		/* override null show/store with default */
-		if(attr->show == NULL)
-			attr->show = old_attr->show;
-		if(attr->store == NULL)
-			attr->store = old_attr->store;
-		(*class_attrs)[modify] = attr;
-	} else {
-		(*class_attrs)[num_attrs++] = attr;
-		(*class_attrs)[num_attrs] = NULL;
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL(scsi_sysfs_modify_shost_attribute);
-
-/** scsi_sysfs_modify_sdev_attribute - modify or add a host device attribute
- *
- * @dev_attrs:	pointer to the attribute list to be added to or modified
- * @attr:	individual attribute to change or added
- *
- * returns zero if successful or error if not
- **/
-int scsi_sysfs_modify_sdev_attribute(struct device_attribute ***dev_attrs,
-				     struct device_attribute *attr)
-{
-	int modify = -1;
-	int num_attrs;
-
-	if(*dev_attrs == NULL)
-		*dev_attrs = scsi_sysfs_sdev_attrs;
-
-	for(num_attrs=0; (*dev_attrs)[num_attrs] != NULL; num_attrs++)
-		if(strcmp((*dev_attrs)[num_attrs]->attr.name,
-				attr->attr.name) == 0)
-			modify = num_attrs;
-
-	if(*dev_attrs == scsi_sysfs_sdev_attrs || modify < 0) {
-		/* note: need space for null at the end as well */
-		struct device_attribute **tmp_attrs =
-				kmalloc(sizeof(*tmp_attrs) *
-					  (num_attrs + (modify >= 0 ? 1 : 2)),
-					GFP_KERNEL);
-		if(tmp_attrs == NULL)
-			return -ENOMEM;
-		memcpy(tmp_attrs, *dev_attrs, sizeof(*tmp_attrs) *
-				(num_attrs + 1));
-		if(*dev_attrs != scsi_sysfs_sdev_attrs)
-			kfree(*dev_attrs);
-		*dev_attrs = tmp_attrs;
-	}
-	if(modify >= 0) {
-		/* spare the caller from having to copy things it's
-		 * not interested in */
-		struct device_attribute *old_attr =
-			(*dev_attrs)[modify];
-		/* extend permissions */
-		attr->attr.mode |= old_attr->attr.mode;
-
-		/* override null show/store with default */
-		if(attr->show == NULL)
-			attr->show = old_attr->show;
-		if(attr->store == NULL)
-			attr->store = old_attr->store;
-		(*dev_attrs)[modify] = attr;
-	} else {
-		(*dev_attrs)[num_attrs++] = attr;
-		(*dev_attrs)[num_attrs] = NULL;
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL(scsi_sysfs_modify_sdev_attribute);
-
-void scsi_sysfs_release_attributes(struct scsi_host_template *hostt)
-{
-	if(hostt->sdev_attrs != scsi_sysfs_sdev_attrs)
-		kfree(hostt->sdev_attrs);
-
-	if(hostt->shost_attrs != scsi_sysfs_shost_attrs)
-		kfree(hostt->shost_attrs);
-}
-EXPORT_SYMBOL(scsi_sysfs_release_attributes);
diff -Nru a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
--- a/include/scsi/scsi_host.h	Sat Jul  5 22:53:43 2003
+++ b/include/scsi/scsi_host.h	Sat Jul  5 22:53:43 2003
@@ -329,12 +329,12 @@
 #define SCSI_DEFAULT_HOST_BLOCKED	7
 
 	/*
-	 * Pointer to the sysfs class properties for this host
+	 * Pointer to the sysfs class properties for this host, NULL terminated.
 	 */
 	struct class_device_attribute **shost_attrs;
 
 	/*
-	 * Pointer to the SCSI device properties for this host
+	 * Pointer to the SCSI device properties for this host, NULL terminated.
 	 */
 	struct device_attribute **sdev_attrs;
 
@@ -499,8 +499,6 @@
 {
         return shost->shost_gendev.parent;
 }
-
-extern void scsi_sysfs_release_attributes(struct scsi_host_template *);
 
 extern void scsi_unblock_requests(struct Scsi_Host *);
 extern void scsi_block_requests(struct Scsi_Host *);
