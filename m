From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [RFC] support for sysfs string based properties for SCSI (3/3)
Date: 03 May 2003 14:30:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1051990255.2308.26.camel@mulgrave>
References: <1051989099.2036.7.camel@mulgrave>
	<1051989565.2036.14.camel@mulgrave>  <1051989937.2308.21.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-97T+vJm+IOXnltYZg8Md"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:19206 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263391AbTECTSd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 3 May 2003 15:18:33 -0400
In-Reply-To: <1051989937.2308.21.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, Patrick Mochel <mochel@osdl.org>, Greg KH <greg@kroah.com>, Mike Anderson <andmike@us.ibm.com>


--=-97T+vJm+IOXnltYZg8Md
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

This illustrates how the new show/store interface may be used for adding
and setting properties.

The attached patch implements a store method in 53c700 which allows the
setting of the queue_depth parameter.

It also adds an "outstanding_tags" attribute which provides all the
information that the 53c700 procfs_info routine now provides.

Hopefully, this interface will be simple and flexible enough to allow us
to migrate all of the SCSI drivers away from proc and on to sysfs.

James


--=-97T+vJm+IOXnltYZg8Md
Content-Disposition: attachment; filename=tmp.diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=tmp.diff; charset=ISO-8859-1

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher=
.
# This patch includes the following deltas:
#	           ChangeSet	1.1198  -> 1.1199=20
#	drivers/scsi/53c700.c	1.29    -> 1.30  =20
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/05/03	jejb@raven.il.steeleye.com	1.1199
# SCSI: implement properties in the 53c700 driver
#=20
# Add a store for the queue_depth setting, and a show for a new
# property called outstanding tags (this is the information currently
# shown by the drivers procfs routine).
# --------------------------------------------
#
diff -Nru a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
--- a/drivers/scsi/53c700.c	Sat May  3 14:27:29 2003
+++ b/drivers/scsi/53c700.c	Sat May  3 14:27:29 2003
@@ -172,6 +172,17 @@
 STATIC void NCR_700_chip_reset(struct Scsi_Host *host);
 STATIC int NCR_700_slave_configure(Scsi_Device *SDpnt);
 STATIC void NCR_700_slave_destroy(Scsi_Device *SDpnt);
+STATIC ssize_t NCR_700_device_property_show(struct scsi_device * dev,
+					    char * buf,
+					    struct attribute *attr);
+STATIC ssize_t NCR_700_device_property_store(struct scsi_device * dev,
+					     const char * buf,
+					     size_t count,
+					     struct attribute *attr);
+
+struct device_attribute NCR_700_sdev_attrs[] =3D {
+	{ .attr =3D { .name =3D "outstanding_tags", .mode =3D S_IRUGO }, },
+};
=20
 static char *NCR_700_phase[] =3D {
 	"",
@@ -278,6 +289,8 @@
 	tpnt->proc_info =3D NCR_700_proc_directory_info;
 	tpnt->slave_configure =3D NCR_700_slave_configure;
 	tpnt->slave_destroy =3D NCR_700_slave_destroy;
+	tpnt->device_property_show =3D NCR_700_device_property_show;
+	tpnt->device_property_store =3D NCR_700_device_property_store;
 	tpnt->use_blk_tcq =3D 1;
 	tpnt->highmem_io =3D 1;
 =09
@@ -2007,6 +2020,8 @@
 STATIC int
 NCR_700_slave_configure(Scsi_Device *SDp)
 {
+	int i;
+
 	/* to do here: allocate memory; build a queue_full list */
 	if(SDp->tagged_supported) {
 		/* do TCQ stuff here */
@@ -2014,14 +2029,63 @@
 		/* initialise to default depth */
 		scsi_adjust_queue_depth(SDp, 0, SDp->host->cmd_per_lun);
 	}
+
+	for (i =3D 0; i < ARRAY_SIZE(NCR_700_sdev_attrs); i++)
+		device_create_file(&SDp->sdev_driverfs_dev,
+				   &NCR_700_sdev_attrs[i]);
 	return 0;
 }
=20
 STATIC void
 NCR_700_slave_destroy(Scsi_Device *SDp)
 {
-	/* to do here: deallocate memory */
+	int i;
+
+	/* FIXME: slave_destroy can be called if no driverfs entry
+	 * has been created.  We really need a slave_unconfigure for
+	 * this type of thing */
+	if(SDp->sdev_driverfs_dev.node.next !=3D NULL)
+		for (i =3D 0; i < ARRAY_SIZE(NCR_700_sdev_attrs); i++)
+			device_remove_file(&SDp->sdev_driverfs_dev,
+					   &NCR_700_sdev_attrs[i]);
+
+}
+
+STATIC ssize_t
+NCR_700_device_property_show(struct scsi_device * sdev, char * buf,
+			     struct attribute *attr)
+{
+	char *name =3D attr->name;
+	int ret =3D 0;
+
+	if (strcmp(name, "outstanding_tags") =3D=3D 0) {
+		ret =3D snprintf(buf, 20, "%d\n", NCR_700_get_depth(sdev));
+	}
+	return ret;
 }
+
+STATIC ssize_t
+NCR_700_device_property_store(struct scsi_device * sdev, const char * buf,
+			      size_t count, struct attribute *attr)
+{
+	char *name =3D attr->name;
+
+	if (strcmp(name, "queue_depth") =3D=3D 0) {
+		long new_depth =3D simple_strtol(buf, NULL, 0);
+		if (new_depth > NCR_700_MAX_TAGS) {
+			return -EINVAL;
+		} else if (new_depth < 0) {
+			/* FIXME: turn off tags need to quiesce the
+			 * device to do this */
+			return -EINVAL;
+		} else {
+			scsi_adjust_queue_depth(sdev, 0, new_depth);
+		}
+	}
+	return 0;
+}
+
+
=20
 EXPORT_SYMBOL(NCR_700_detect);
 EXPORT_SYMBOL(NCR_700_release);

--=-97T+vJm+IOXnltYZg8Md--

