From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [RFC] support for sysfs string based properties for SCSI (2/3)
Date: 03 May 2003 14:25:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1051989937.2308.21.camel@mulgrave>
References: <1051989099.2036.7.camel@mulgrave>
	<1051989565.2036.14.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-dGFwvF+4ouyqldG4OqkC"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:7173 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263394AbTECTNP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 3 May 2003 15:13:15 -0400
In-Reply-To: <1051989565.2036.14.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, Patrick Mochel <mochel@osdl.org>, Greg KH <greg@kroah.com>, Mike Anderson <andmike@us.ibm.com>


--=-dGFwvF+4ouyqldG4OqkC
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


This implements a generic host and device based show/store using
property attributes in SCSI.

I've done it for both LLDs and ULDs, but I'm not convinced that the ULD
one is needed: I think it will probably get subsumed by the driver class
changes.

James
 

--=-dGFwvF+4ouyqldG4OqkC
Content-Disposition: attachment; filename=tmp.diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=tmp.diff; charset=ISO-8859-1

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher=
.
# This patch includes the following deltas:
#	           ChangeSet	1.1197  -> 1.1198=20
#	drivers/scsi/scsi_sysfs.c	1.11    -> 1.12  =20
#	drivers/scsi/hosts.h	1.60    -> 1.61  =20
#	 drivers/scsi/scsi.c	1.109   -> 1.110 =20
#	drivers/scsi/scsi_priv.h	1.1     -> 1.2   =20
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/05/03	jejb@raven.il.steeleye.com	1.1198
# SCSI: add ULD and LLD device/host property show/store
#=20
# This implements a property show/store method for arbitrary string
# based properties which can be exposed through the sysfs interface.
#=20
# The essential problem to be solved here is that properties can be
# read easily enough in the mid-layer but they require co-operation
# from the LLD to set them
# --------------------------------------------
#
diff -Nru a/drivers/scsi/hosts.h b/drivers/scsi/hosts.h
--- a/drivers/scsi/hosts.h	Sat May  3 14:24:25 2003
+++ b/drivers/scsi/hosts.h	Sat May  3 14:24:25 2003
@@ -266,6 +266,22 @@
     int (* bios_param)(struct scsi_device *, struct block_device *,
 		    sector_t, int []);
=20
+    /*=20
+     * Used to show/store generic ASCII properties
+     *
+     * If filled in, it will be called before the generic SCSI driver
+     * processes the properties.
+     */
+    ssize_t (* host_property_show)(struct Scsi_Host *, char *,
+				   struct attribute *);
+    ssize_t (* host_property_store)(struct Scsi_Host *, const char *,
+				    size_t, struct attribute *);
+    ssize_t (* device_property_show)(struct scsi_device *, char *,
+				     struct attribute *);
+    ssize_t (* device_property_store)(struct scsi_device *, const char *,
+				      size_t, struct attribute *);
+
+
     /*
      * This determines if we will use a non-interrupt driven
      * or an interrupt driven scheme,  It is set to the maximum number
@@ -538,6 +554,10 @@
     int (*init_command)(Scsi_Cmnd *);     /* Used by new queueing code.=20
                                            Selects command for blkdevs */
     void (*rescan)(Scsi_Device *);
+    ssize_t (* device_property_show)(struct scsi_device *, char *,
+				     struct attribute *);
+    ssize_t (* device_property_store)(struct scsi_device *, const char *,
+				      size_t, struct attribute *);
     struct device_driver scsi_driverfs_driver;
 };
=20
diff -Nru a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c	Sat May  3 14:24:25 2003
+++ b/drivers/scsi/scsi.c	Sat May  3 14:24:25 2003
@@ -89,7 +89,7 @@
  * List of all highlevel drivers.
  */
 LIST_HEAD(scsi_devicelist);
-static DECLARE_RWSEM(scsi_devicelist_mutex);
+DECLARE_RWSEM(scsi_devicelist_mutex);
=20
 /*
  * Note - the initial logging level can be set here to log events at boot =
time.
diff -Nru a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
--- a/drivers/scsi/scsi_priv.h	Sat May  3 14:24:25 2003
+++ b/drivers/scsi/scsi_priv.h	Sat May  3 14:24:25 2003
@@ -143,4 +143,7 @@
 extern struct list_head scsi_dev_info_list;
 extern int scsi_dev_info_list_add_str(char *);
=20
+extern struct list_head scsi_devicelist;
+extern struct rw_semaphore scsi_devicelist_mutex;
+
 #endif /* _SCSI_PRIV_H */
diff -Nru a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
--- a/drivers/scsi/scsi_sysfs.c	Sat May  3 14:24:25 2003
+++ b/drivers/scsi/scsi_sysfs.c	Sat May  3 14:24:25 2003
@@ -16,41 +16,20 @@
=20
 #include "scsi_priv.h"
=20
-/*
- * shost_show_function: macro to create an attr function that can be used =
to
- * show a non-bit field.
- */
-#define shost_show_function(field, format_string)			\
-static ssize_t								\
-show_##field (struct device *dev, char *buf)				\
-{									\
-	struct Scsi_Host *shost =3D to_scsi_host(dev);			\
-	return snprintf (buf, 20, format_string, shost->field);	\
-}
-
-/*
- * shost_rd_attr: macro to create a function and attribute variable for a
- * read only field.
- */
-#define shost_rd_attr(field, format_string)				\
-	shost_show_function(field, format_string)				\
-static DEVICE_ATTR(field, S_IRUGO, show_##field, NULL)
-
-/*
- * Create the actual show/store functions and data structures.
- */
-shost_rd_attr(unique_id, "%u\n");
-shost_rd_attr(host_busy, "%hu\n");
-shost_rd_attr(cmd_per_lun, "%hd\n");
-shost_rd_attr(sg_tablesize, "%hu\n");
-shost_rd_attr(unchecked_isa_dma, "%d\n");
-
-static struct device_attribute *const shost_attrs[] =3D {
-	&dev_attr_unique_id,
-	&dev_attr_host_busy,
-	&dev_attr_cmd_per_lun,
-	&dev_attr_sg_tablesize,
-	&dev_attr_unchecked_isa_dma,
+/* FIXME: need generic attributes for the host */
+
+/* generic attributes to appear in device directory */
+struct device_attribute sdev_attrs[] =3D {
+	{ .attr =3D { .name =3D "device_blocked", .mode =3D S_IRUGO }, },
+	{ .attr =3D { .name =3D "queue_depth", .mode =3D S_IRUGO | S_IWUSR }, },
+	{ .attr =3D { .name =3D "type", .mode =3D S_IRUGO }, },
+	{ .attr =3D { .name =3D "scsi_level", .mode =3D S_IRUGO }, },
+	{ .attr =3D { .name =3D "access_count", .mode =3D S_IRUGO }, },
+	{ .attr =3D { .name =3D "vendor", .mode =3D S_IRUGO }, },
+	{ .attr =3D { .name =3D "model", .mode =3D S_IRUGO }, },
+	{ .attr =3D { .name =3D "rev", .mode =3D S_IRUGO }, },
+	{ .attr =3D { .name =3D "online", .mode =3D S_IRUGO }, },
+	{ .attr =3D { .name =3D "rescan", .mode =3D S_IRUGO | S_IWUSR }, },
 };
=20
 /**
@@ -105,10 +84,154 @@
         return 0;
 }
=20
+#define SCSI_SYSFS_MAX_BUF	20
+
+static ssize_t scsi_sysfs_device_show(struct device * dev, char * buf,
+				      struct attribute *attr)
+{
+	char *name =3D attr->name;
+	struct scsi_device *sdev =3D to_scsi_device(dev);
+	struct Scsi_Device_Template *tpnt;
+	int ret =3D 0;
+
+	/* process any host based overrides */
+
+	if(sdev->host->hostt->device_property_show) {
+		ret =3D sdev->host->hostt->device_property_show(sdev, buf, attr);
+		if(ret !=3D 0)
+			return ret;
+	}
+
+	/* pass to every upper level driver.  ULDs must check to see
+	 * if they're interested in the device type *before* doing
+	 * anything with the property */
+
+	down_read(&scsi_devicelist_mutex);
+	list_for_each_entry(tpnt, &scsi_devicelist, list) {
+		if(tpnt->device_property_show) {
+			ret =3D tpnt->device_property_show(sdev, buf, attr);
+
+			if(ret !=3D 0) {
+				up_read(&scsi_devicelist_mutex);
+				return ret;
+			}
+		}
+
+	}
+	up_read(&scsi_devicelist_mutex);
+
+	/* generic processing */
+
+	if (strcmp(name, "device_blocked") =3D=3D 0) {
+		ret =3D snprintf(buf, SCSI_SYSFS_MAX_BUF, "%d\n",
+			       sdev->device_blocked);
+	} else if (strcmp(name, "queue_depth") =3D=3D 0) {
+		ret =3D snprintf(buf, SCSI_SYSFS_MAX_BUF, "%d\n",
+			       sdev->queue_depth);
+	} else if (strcmp(name, "type") =3D=3D 0) {
+		ret  =3D snprintf(buf, SCSI_SYSFS_MAX_BUF, "%d\n",
+				sdev->type);
+	} else if (strcmp(name, "scsi_level") =3D=3D 0) {
+		ret =3D snprintf(buf, SCSI_SYSFS_MAX_BUF, "%d\n",
+			       sdev->scsi_level);
+	} else if (strcmp(name, "access_count") =3D=3D 0) {
+		ret =3D snprintf(buf, SCSI_SYSFS_MAX_BUF, "%d\n",
+			       sdev->access_count);
+	} else if (strcmp(name, "vendor") =3D=3D 0) {
+		ret =3D snprintf(buf, SCSI_SYSFS_MAX_BUF, "%.8s\n",
+			       sdev->vendor);
+	} else if (strcmp(name, "model") =3D=3D 0) {
+		ret =3D snprintf(buf, SCSI_SYSFS_MAX_BUF, "%.16s\n",
+			       sdev->model);
+	} else if (strcmp(name, "rev") =3D=3D 0) {
+		ret =3D snprintf(buf, SCSI_SYSFS_MAX_BUF, "%.4s\n",
+			       sdev->rev);
+	} else if (strcmp(name, "online") =3D=3D 0) {
+		ret =3D snprintf(buf, SCSI_SYSFS_MAX_BUF, "%d\n",
+			       sdev->online);
+	}
+
+	return ret;
+}
+
+static size_t scsi_sysfs_device_store(struct device * dev, const char * bu=
f,
+				      size_t count, struct attribute *attr)
+{
+	char *name =3D attr->name;
+	struct scsi_device *sdev =3D to_scsi_device(dev);
+	struct Scsi_Device_Template *tpnt;
+	int ret =3D 0;
+
+	/* process any host based overrides */
+
+	if(sdev->host->hostt->device_property_store) {
+		ret =3D sdev->host->hostt->device_property_store(sdev, buf,
+							       count, attr);
+		if(ret < 0)
+			return ret;
+
+	}
+	/* pass to every upper level driver.  ULDs must check to see
+	 * if they're interested in the device type *before* doing
+	 * anything with the property */
+
+	down_read(&scsi_devicelist_mutex);
+	list_for_each_entry(tpnt, &scsi_devicelist, list) {
+		if(tpnt->device_property_store) {
+			ret =3D tpnt->device_property_store(sdev, buf,
+							  count, attr);
+
+			if(ret < 0) {
+				up_read(&scsi_devicelist_mutex);
+				return ret;
+			}
+		}
+			=09
+	}
+	up_read(&scsi_devicelist_mutex);
+
+	/* generic processing */
+
+	if (strcmp(name, "rescan") =3D=3D 0) {
+		ret =3D count;
+		scsi_rescan_device(sdev);
+	} else if (strcmp(name, "online") =3D=3D 0) {
+		/* FIXME: will do online/offline here when available */
+	}
+	=09
+	return ret;
+}
+=09
+static ssize_t scsi_sysfs_show(struct device * dev, char * buf,
+			       struct attribute *attr)
+{
+	/* FIXME: If we actually had a device type corresponding to a
+	 * host, we'd check for it here and then do host stuff=20
+	if(0)
+		return scsi_sysfs_host_show(dev, buf, attr);
+	else
+	*/
+		return scsi_sysfs_device_show(dev, buf, attr);
+}
+
+static ssize_t scsi_sysfs_store(struct device * dev, const char * buf,
+			       size_t count, struct attribute *attr)
+{
+	/* FIXME: If we actually had a device type corresponding to a
+	 * host, we'd check for it here and then do host stuff
+	if(0)
+		return scsi_sysfs_host_store(dev, buf, count, attr);
+	else
+	*/
+		return scsi_sysfs_device_store(dev, buf, count, attr);
+}
+
=20
 static struct bus_type scsi_bus_type =3D {
         .name		=3D "scsi",
         .match		=3D scsi_bus_match,
+	.show		=3D scsi_sysfs_show,
+	.store		=3D scsi_sysfs_store,
 };
=20
=20
@@ -154,125 +277,6 @@
 }
=20
=20
-/*
- * sdev_show_function: macro to create an attr function that can be used t=
o
- * show a non-bit field.
- */
-#define sdev_show_function(field, format_string)				\
-static ssize_t								\
-show_##field (struct device *dev, char *buf)				\
-{									\
-	struct scsi_device *sdev;					\
-	sdev =3D to_scsi_device(dev);					\
-	return snprintf (buf, 20, format_string, sdev->field);		\
-}									\
-
-/*
- * sdev_rd_attr: macro to create a function and attribute variable for a
- * read only field.
- */
-#define sdev_rd_attr(field, format_string)				\
-	sdev_show_function(field, format_string)				\
-static DEVICE_ATTR(field, S_IRUGO, show_##field, NULL)
-
-
-/*
- * sdev_rd_attr: create a function and attribute variable for a
- * read/write field.
- */
-#define sdev_rw_attr(field, format_string)				\
-	sdev_show_function(field, format_string)				\
-									\
-static ssize_t								\
-sdev_store_##field (struct device *dev, const char *buf, size_t count)	\
-{									\
-	struct scsi_device *sdev;					\
-	sdev =3D to_scsi_device(dev);					\
-	snscanf (buf, 20, format_string, &sdev->field);			\
-	return count;							\
-}									\
-static DEVICE_ATTR(field, S_IRUGO | S_IWUSR, show_##field, sdev_store_##fi=
eld)
-
-/*
- * sdev_rd_attr: create a function and attribute variable for a
- * read/write bit field.
- */
-#define sdev_rw_attr_bit(field)						\
-	sdev_show_function(field, "%d\n")					\
-									\
-static ssize_t								\
-sdev_store_##field (struct device *dev, const char *buf, size_t count)	\
-{									\
-	int ret;							\
-	struct scsi_device *sdev;					\
-	ret =3D scsi_sdev_check_buf_bit(buf);				\
-	if (ret >=3D 0)	{						\
-		sdev =3D to_scsi_device(dev);				\
-		sdev->field =3D ret;					\
-		ret =3D count;						\
-	}								\
-	return ret;							\
-}									\
-static DEVICE_ATTR(field, S_IRUGO | S_IWUSR, show_##field, sdev_store_##fi=
eld)
-
-/*
- * scsi_sdev_check_buf_bit: return 0 if buf is "0", return 1 if buf is "1"=
,
- * else return -EINVAL.
- */
-static int scsi_sdev_check_buf_bit(const char *buf)
-{
-	if ((buf[1] =3D=3D '\0') || ((buf[1] =3D=3D '\n') && (buf[2] =3D=3D '\0')=
)) {
-		if (buf[0] =3D=3D '1')
-			return 1;
-		else if (buf[0] =3D=3D '0')
-			return 0;
-		else=20
-			return -EINVAL;
-	} else
-		return -EINVAL;
-}
-
-/*
- * Create the actual show/store functions and data structures.
- */
-sdev_rd_attr (device_blocked, "%d\n");
-sdev_rd_attr (queue_depth, "%d\n");
-sdev_rd_attr (type, "%d\n");
-sdev_rd_attr (scsi_level, "%d\n");
-sdev_rd_attr (access_count, "%d\n");
-sdev_rd_attr (vendor, "%.8s\n");
-sdev_rd_attr (model, "%.16s\n");
-sdev_rd_attr (rev, "%.4s\n");
-sdev_rw_attr_bit (online);
-
-static ssize_t
-show_rescan_field (struct device *dev, char *buf)
-{
-	return 0;=20
-}
-
-static ssize_t
-store_rescan_field (struct device *dev, const char *buf, size_t count)=20
-{
-	scsi_rescan_device(to_scsi_device(dev));
-	return 0;
-}
-
-static DEVICE_ATTR(rescan, S_IRUGO | S_IWUSR, show_rescan_field, store_res=
can_field)
-
-static struct device_attribute * const sdev_attrs[] =3D {
-	&dev_attr_device_blocked,
-	&dev_attr_queue_depth,
-	&dev_attr_type,
-	&dev_attr_scsi_level,
-	&dev_attr_access_count,
-	&dev_attr_vendor,
-	&dev_attr_model,
-	&dev_attr_rev,
-	&dev_attr_online,
-	&dev_attr_rescan,
-};
-
 /**
  * scsi_device_register - register a scsi device with the scsi bus
  * @sdev:	scsi_device to register
@@ -295,7 +299,7 @@
=20
 	for (i =3D 0; !error && i < ARRAY_SIZE(sdev_attrs); i++)
 		error =3D device_create_file(&sdev->sdev_driverfs_dev,
-					   sdev_attrs[i]);
+					   &sdev_attrs[i]);
=20
 	if (error)
 		scsi_device_unregister(sdev);
@@ -312,6 +316,6 @@
 	int i;
=20
 	for (i =3D 0; i < ARRAY_SIZE(sdev_attrs); i++)
-		device_remove_file(&sdev->sdev_driverfs_dev, sdev_attrs[i]);
+		device_remove_file(&sdev->sdev_driverfs_dev, &sdev_attrs[i]);
 	device_unregister(&sdev->sdev_driverfs_dev);
 }

--=-dGFwvF+4ouyqldG4OqkC--

