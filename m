From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Round II on sysfs attributes
Date: 23 May 2003 12:38:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1053707904.1810.4.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-scwF9tRwYxVdbLNV9QEH"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:43015 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264092AbTEWQZT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 May 2003 12:25:19 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Mike Anderson <andmike@us.ibm.com>


--=-scwF9tRwYxVdbLNV9QEH
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


The attached patch makes the sysfs attributes a property of the host
template (I can't really see a reason why the actual attributes need to
change per host, so I think the template is the better place for them).

I've also provided helper functions to modify the attributes in the LLD
init routines.

An illustration of how this works for the 53c700 will follow.

James


--=-scwF9tRwYxVdbLNV9QEH
Content-Disposition: inline; filename=tmp.diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=tmp.diff; charset=ISO-8859-1

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher=
.
# This patch includes the following deltas:
#	           ChangeSet	1.1185  -> 1.1189=20
#	drivers/scsi/hosts.c	1.65    -> 1.66  =20
#	drivers/scsi/scsi_sysfs.c	1.16    -> 1.19  =20
#	 drivers/scsi/scsi.h	1.79    -> 1.80  =20
#	drivers/scsi/hosts.h	1.64    -> 1.65  =20
#	drivers/scsi/scsi_priv.h	1.7     -> 1.10  =20
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/05/21	jejb@mulgrave.(none)	1.1186
# SCSI: Move shost_attrs and sdev_attrs into the host template
#=20
# This would allow the LLD to clone or modify them at slave_configure time.=
=20
#=20
# Also expose routines to facilitate this
# --------------------------------------------
# 03/05/22	jejb@mulgrave.(none)	1.1187
# Update modify functions to take the template not the host
# --------------------------------------------
# 03/05/23	jejb@mulgrave.(none)	1.1188
# More sysfs attribute updates
# --------------------------------------------
# 03/05/23	jejb@mulgrave.(none)	1.1189
# do a bit more adjusting of what should be in scsi.h and what in scsi_priv=
.h
# --------------------------------------------
#
diff -Nru a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c	Fri May 23 12:35:11 2003
+++ b/drivers/scsi/hosts.c	Fri May 23 12:35:11 2003
@@ -321,7 +321,12 @@
            shost_tp->eh_host_reset_handler =3D=3D NULL) {
 		printk(KERN_ERR "ERROR: SCSI host `%s' has no error handling\nERROR: Thi=
s is not a safe way to run your SCSI host\nERROR: The error handling must b=
e added to this driver\n", shost_tp->proc_name);
 		dump_stack();
-        }=20
+        }
+	if(shost_tp->shost_attrs =3D=3D NULL)
+		/* if its not set in the template, use the default */
+		 shost_tp->shost_attrs =3D scsi_sysfs_shost_attrs;
+	if(shost_tp->sdev_attrs =3D=3D NULL)
+		 shost_tp->sdev_attrs =3D scsi_sysfs_sdev_attrs;
 	gfp_mask =3D GFP_KERNEL;
 	if (shost_tp->unchecked_isa_dma && xtr_bytes)
 		gfp_mask |=3D __GFP_DMA;
diff -Nru a/drivers/scsi/hosts.h b/drivers/scsi/hosts.h
--- a/drivers/scsi/hosts.h	Fri May 23 12:35:11 2003
+++ b/drivers/scsi/hosts.h	Fri May 23 12:35:11 2003
@@ -356,6 +356,16 @@
      * FIXME: This should probably be a value in the template */
     #define SCSI_DEFAULT_HOST_BLOCKED	7
=20
+    /*
+     * pointer to the sysfs class properties for this host
+     */
+    struct class_device_attribute **shost_attrs;
+
+    /*
+     * Pointer to the SCSI device properties for this host
+     */
+    struct device_attribute **sdev_attrs;
+
 } Scsi_Host_Template;
=20
 /*
diff -Nru a/drivers/scsi/scsi.h b/drivers/scsi/scsi.h
--- a/drivers/scsi/scsi.h	Fri May 23 12:35:11 2003
+++ b/drivers/scsi/scsi.h	Fri May 23 12:35:11 2003
@@ -683,4 +683,9 @@
=20
 int scsi_set_medium_removal(Scsi_Device *dev, char state);
=20
+extern int scsi_sysfs_modify_sdev_attribute(struct device_attribute ***dev=
_attrs,
+					    struct device_attribute *attr);
+extern int scsi_sysfs_modify_shost_attribute(struct class_device_attribute=
 ***class_attrs,
+					     struct class_device_attribute *attr);
+
 #endif /* _SCSI_H */
diff -Nru a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
--- a/drivers/scsi/scsi_priv.h	Fri May 23 12:35:11 2003
+++ b/drivers/scsi/scsi_priv.h	Fri May 23 12:35:11 2003
@@ -131,4 +131,9 @@
 extern int scsi_sysfs_register(void);
 extern void scsi_sysfs_unregister(void);
=20
+/* definitions for the linker default sections covering the host
+ * class and device attributes */
+extern struct class_device_attribute *scsi_sysfs_shost_attrs[];
+extern struct device_attribute *scsi_sysfs_sdev_attrs[];
+
 #endif /* _SCSI_PRIV_H */
diff -Nru a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
--- a/drivers/scsi/scsi_sysfs.c	Fri May 23 12:35:11 2003
+++ b/drivers/scsi/scsi_sysfs.c	Fri May 23 12:35:11 2003
@@ -45,12 +45,13 @@
 shost_rd_attr(sg_tablesize, "%hu\n");
 shost_rd_attr(unchecked_isa_dma, "%d\n");
=20
-static struct class_device_attribute *const shost_attrs[] =3D {
+struct class_device_attribute *scsi_sysfs_shost_attrs[] =3D {
 	&class_device_attr_unique_id,
 	&class_device_attr_host_busy,
 	&class_device_attr_cmd_per_lun,
 	&class_device_attr_sg_tablesize,
 	&class_device_attr_unchecked_isa_dma,
+	NULL
 };
=20
 static struct class shost_class =3D {
@@ -243,7 +244,8 @@
=20
 static DEVICE_ATTR(rescan, S_IRUGO | S_IWUSR, show_rescan_field, store_res=
can_field)
=20
-static struct device_attribute * const sdev_attrs[] =3D {
+/* Default template for device attributes.  May NOT be modified */
+struct device_attribute *scsi_sysfs_sdev_attrs[] =3D {
 	&dev_attr_device_blocked,
 	&dev_attr_queue_depth,
 	&dev_attr_type,
@@ -254,6 +256,7 @@
 	&dev_attr_rev,
 	&dev_attr_online,
 	&dev_attr_rescan,
+	NULL
 };
=20
 static void scsi_device_release(struct device *dev)
@@ -287,9 +290,9 @@
 	if (error)
 		return error;
=20
-	for (i =3D 0; !error && i < ARRAY_SIZE(sdev_attrs); i++)
+	for (i =3D 0; !error && sdev->host->hostt->sdev_attrs[i] !=3D NULL; i++)
 		error =3D device_create_file(&sdev->sdev_driverfs_dev,
-					   sdev_attrs[i]);
+					   sdev->host->hostt->sdev_attrs[i]);
=20
 	if (error)
 		scsi_device_unregister(sdev);
@@ -305,8 +308,8 @@
 {
 	int i;
=20
-	for (i =3D 0; i < ARRAY_SIZE(sdev_attrs); i++)
-		device_remove_file(&sdev->sdev_driverfs_dev, sdev_attrs[i]);
+	for (i =3D 0; sdev->host->hostt->sdev_attrs[i] !=3D NULL; i++)
+		device_remove_file(&sdev->sdev_driverfs_dev, sdev->host->hostt->sdev_att=
rs[i]);
 	device_unregister(&sdev->sdev_driverfs_dev);
 }
=20
@@ -357,9 +360,9 @@
 	if (error)
 		goto clean_device;
=20
-	for (i =3D 0; !error && i < ARRAY_SIZE(shost_attrs); i++)
+	for (i =3D 0; !error && shost->hostt->shost_attrs[i] !=3D NULL; i++)
 		error =3D class_device_create_file(&shost->class_dev,
-					   shost_attrs[i]);
+					   shost->hostt->shost_attrs[i]);
 	if (error)
 		goto clean_class;
=20
@@ -383,3 +386,104 @@
 	device_del(&shost->host_gendev);
 }
=20
+/** scsi_sysfs_modify_shost_attribute - modify or add a host class attribu=
te
+ *
+ * @class_attrs:host class attribute list to be added to or modified
+ * @attr:	individual attribute to change or added
+ *
+ * returns zero if successful or error if not
+ **/
+int scsi_sysfs_modify_shost_attribute(struct class_device_attribute ***cla=
ss_attrs,
+				      struct class_device_attribute *attr)
+{
+	int modify =3D 0;
+	int num_attrs;
+
+	if(*class_attrs =3D=3D NULL)
+		*class_attrs =3D scsi_sysfs_shost_attrs;
+
+	for(num_attrs=3D0; (*class_attrs)[num_attrs] !=3D NULL; num_attrs++)
+		if(strcmp((*class_attrs)[num_attrs]->attr.name, attr->attr.name) =3D=3D =
0)
+			modify =3D num_attrs;
+
+	if(*class_attrs =3D=3D scsi_sysfs_shost_attrs || !modify) {
+		struct class_device_attribute **tmp_attrs =3D kmalloc(sizeof(struct clas=
s_device_attribute)*(num_attrs + (modify ? 0 : 1)), GFP_KERNEL);
+		if(tmp_attrs =3D=3D NULL)
+			return -ENOMEM;
+		memcpy(tmp_attrs, *class_attrs, sizeof(struct class_device_attribute)*nu=
m_attrs);
+		if(*class_attrs !=3D scsi_sysfs_shost_attrs)
+			kfree(*class_attrs);
+		*class_attrs =3D tmp_attrs;
+	}
+	if(modify) {
+		/* spare the caller from having to copy things it's
+		 * not interested in */
+		struct class_device_attribute *old_attr =3D
+			(*class_attrs)[modify];
+		/* extend permissions */
+		attr->attr.mode |=3D old_attr->attr.mode;
+
+		/* override null show/store with default */
+		if(attr->show =3D=3D NULL)
+			attr->show =3D old_attr->show;
+		if(attr->store =3D=3D NULL)
+			attr->store =3D old_attr->store;
+		(*class_attrs)[modify] =3D attr;
+	} else {
+		(*class_attrs)[num_attrs] =3D attr;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(scsi_sysfs_modify_shost_attribute);
+
+/** scsi_sysfs_modify_sdev_attribute - modify or add a host device attribu=
te
+ *
+ * @dev_attrs:	pointer to the attribute list to be added to or modified
+ * @attr:	individual attribute to change or added
+ *
+ * returns zero if successful or error if not
+ **/
+int scsi_sysfs_modify_sdev_attribute(struct device_attribute ***dev_attrs,
+				     struct device_attribute *attr)
+{
+	int modify =3D 0;
+	int num_attrs;
+
+	if(*dev_attrs =3D=3D NULL)
+		*dev_attrs =3D scsi_sysfs_sdev_attrs;
+
+	for(num_attrs=3D0; (*dev_attrs)[num_attrs] !=3D NULL; num_attrs++)
+		if(strcmp((*dev_attrs)[num_attrs]->attr.name, attr->attr.name) =3D=3D 0)
+			modify =3D num_attrs;
+
+	if(*dev_attrs =3D=3D scsi_sysfs_sdev_attrs || !modify) {
+		struct device_attribute **tmp_attrs =3D kmalloc(sizeof(struct device_att=
ribute)*(num_attrs + (modify ? 0 : 1)), GFP_KERNEL);
+		if(tmp_attrs =3D=3D NULL)
+			return -ENOMEM;
+		memcpy(tmp_attrs, *dev_attrs, sizeof(struct device_attribute)*num_attrs)=
;
+		if(*dev_attrs !=3D scsi_sysfs_sdev_attrs)
+			kfree(*dev_attrs);
+		*dev_attrs =3D tmp_attrs;
+	}
+	if(modify) {
+		/* spare the caller from having to copy things it's
+		 * not interested in */
+		struct device_attribute *old_attr =3D
+			(*dev_attrs)[modify];
+		/* extend permissions */
+		attr->attr.mode |=3D old_attr->attr.mode;
+
+		/* override null show/store with default */
+		if(attr->show =3D=3D NULL)
+			attr->show =3D old_attr->show;
+		if(attr->store =3D=3D NULL)
+			attr->store =3D old_attr->store;
+		(*dev_attrs)[modify] =3D attr;
+	} else {
+		(*dev_attrs)[num_attrs] =3D attr;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(scsi_sysfs_modify_sdev_attribute);

--=-scwF9tRwYxVdbLNV9QEH--

