From: Kurt Garloff <garloff@suse.de>
Subject: Re: [PATCH] sysfs host name support
Date: Mon, 1 Mar 2004 00:37:09 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040229233709.GD13934@tpkurt.garloff.de>
References: <20040209155046.GP3944@tpkurt.garloff.de> <20040209160526.A23604@infradead.org> <1076342962.1804.14.camel@mulgrave> <20040209162036.A23821@infradead.org> <20040210003332.GF4538@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DrWhICOqskFTAXiy"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:28323 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S262185AbUB2XhM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Feb 2004 18:37:12 -0500
Content-Disposition: inline
In-Reply-To: <20040210003332.GF4538@tpkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, Linux SCSI list <linux-scsi@vger.kernel.org>


--DrWhICOqskFTAXiy
Content-Type: multipart/mixed; boundary="jousvV0MzM2p6OtC"
Content-Disposition: inline


--jousvV0MzM2p6OtC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 10, 2004 at 01:33:32AM +0100, Kurt Garloff wrote:
> OK, let's export the proc_name then. It's some name that can be used
> to identify the driver, works for code both compiled statically or
> as module, is reasonably short and very often resembles the module
> name.
>=20
> For the module_name, let's wait for a generic sysfs solution.=20
>=20
> Please merge the attached patch.

Any consensus about this one?

I'd certainly like to see it merged.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--jousvV0MzM2p6OtC
Content-Type: text/plain; charset=us-ascii
Content-Description: scsi_sysfs-procname-2.diff
Content-Disposition: attachment; filename=scsi_sysfs-procname-2
Content-Transfer-Encoding: quoted-printable

--- linux/drivers/scsi/scsi_sysfs.c.orig	2004-01-09 07:59:10.000000000 +0100
+++ linux/drivers/scsi/scsi_sysfs.c	2004-02-10 01:29:36.903202660 +0100
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
@@ -96,6 +99,7 @@
 shost_rd_attr(cmd_per_lun, "%hd\n");
 shost_rd_attr(sg_tablesize, "%hu\n");
 shost_rd_attr(unchecked_isa_dma, "%d\n");
+shost_rd_attr2(proc_name, hostt->proc_name, "%s\n");
=20
 static struct class_device_attribute *scsi_sysfs_shost_attrs[] =3D {
 	&class_device_attr_unique_id,
@@ -103,6 +107,7 @@
 	&class_device_attr_cmd_per_lun,
 	&class_device_attr_sg_tablesize,
 	&class_device_attr_unchecked_isa_dma,
+	&class_device_attr_proc_name,
 	&class_device_attr_scan,
 	NULL
 };

--jousvV0MzM2p6OtC--

--DrWhICOqskFTAXiy
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAQnekxmLh6hyYd04RAmY7AJ9dGgtoaA4F6X2reiMO52+zsXOOpgCfWOAz
EMudUA1a5+bJxNuEG8wAm6o=
=ErL4
-----END PGP SIGNATURE-----

--DrWhICOqskFTAXiy--
