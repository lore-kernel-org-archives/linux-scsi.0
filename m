From: Kurt Garloff <garloff@suse.de>
Subject: [PATCH] sysfs host name support
Date: Mon, 9 Feb 2004 16:50:46 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040209155046.GP3944@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cxMSjUqMQBJIqbX5"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:23719 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S261877AbUBIPut (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Feb 2004 10:50:49 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>


--cxMSjUqMQBJIqbX5
Content-Type: multipart/mixed; boundary="BnCwdHgQ2ZomtW9r"
Content-Disposition: inline


--BnCwdHgQ2ZomtW9r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

in scsidev, the host adapter name is one of the possible attributes to
match when providing persistent device names.
And the module name is useful to deduce the list of modules that is=20
needed when booting.
The proc_name was used previously for /proc/scsi/PROC_NAME/X/ and is
still part of the host template. We might consider ripping is out
or think about syncing it with the module name.

Unfortunately neither is visible in sysfs currently.

Please apply the attached patch.
It exports the 3 names to sysfs under /sys/classes/scsi_hosts/hostX/
name, proc_name, module_name.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--BnCwdHgQ2ZomtW9r
Content-Type: text/plain; charset=us-ascii
Content-Description: scsi_sysfs-addnames.diff
Content-Disposition: attachment; filename="scsi_sysfs-addnames.diff"
Content-Transfer-Encoding: quoted-printable

--- drivers/scsi/scsi_sysfs.c.orig	2004-01-09 07:59:10.000000000 +0100
+++ drivers/scsi/scsi_sysfs.c	2004-02-09 16:29:30.226170112 +0100
@@ -58,21 +58,24 @@
  * shost_show_function: macro to create an attr function that can be used =
to
  * show a non-bit field.
  */
-#define shost_show_function(field, format_string)			\
+#define shost_show_function(name, field, format_string)			\
 static ssize_t								\
-show_##field (struct class_device *class_dev, char *buf)		\
+show_##name (struct class_device *class_dev, char *buf)			\
 {									\
 	struct Scsi_Host *shost =3D class_to_shost(class_dev);		\
-	return snprintf (buf, 20, format_string, shost->field);	\
+	return snprintf (buf, 20, format_string, shost->field);		\
 }
=20
 /*
  * shost_rd_attr: macro to create a function and attribute variable for a
  * read only field.
  */
-#define shost_rd_attr(field, format_string)				\
-	shost_show_function(field, format_string)			\
-static CLASS_DEVICE_ATTR(field, S_IRUGO, show_##field, NULL)
+#define shost_rd_attr2(name, field, format_string)			\
+	shost_show_function(name, field, format_string)			\
+static CLASS_DEVICE_ATTR(name, S_IRUGO, show_##name, NULL)
+
+#define shost_rd_attr(field, format_string) \
+shost_rd_attr2(field, field, format_string)
=20
 /*
  * Create the actual show/store functions and data structures.
@@ -96,6 +99,9 @@
 shost_rd_attr(cmd_per_lun, "%hd\n");
 shost_rd_attr(sg_tablesize, "%hu\n");
 shost_rd_attr(unchecked_isa_dma, "%d\n");
+shost_rd_attr2(name, hostt->name, "%s\n");
+shost_rd_attr2(proc_name, hostt->proc_name, "%s\n");
+shost_rd_attr2(module_name, hostt->module->name, "%s\n");
=20
 static struct class_device_attribute *scsi_sysfs_shost_attrs[] =3D {
 	&class_device_attr_unique_id,
@@ -103,6 +109,9 @@
 	&class_device_attr_cmd_per_lun,
 	&class_device_attr_sg_tablesize,
 	&class_device_attr_unchecked_isa_dma,
+	&class_device_attr_name,
+	&class_device_attr_proc_name,
+	&class_device_attr_module_name,
 	&class_device_attr_scan,
 	NULL
 };

--BnCwdHgQ2ZomtW9r--

--cxMSjUqMQBJIqbX5
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAJ6xWxmLh6hyYd04RAounAKCw0OvRoHBBRZ+x37am52OzpNQSUgCfd8bE
Eo1x2aQaNionBH0pXMWmKX8=
=IUD0
-----END PGP SIGNATURE-----

--cxMSjUqMQBJIqbX5--
