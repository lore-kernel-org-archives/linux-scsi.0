From: Kurt Garloff <garloff@suse.de>
Subject: Re: [PATCH] sysfs host name support
Date: Tue, 10 Feb 2004 01:33:32 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040210003332.GF4538@tpkurt.garloff.de>
References: <20040209155046.GP3944@tpkurt.garloff.de> <20040209160526.A23604@infradead.org> <1076342962.1804.14.camel@mulgrave> <20040209162036.A23821@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4eRLI4hEmsdu6Npr"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:52138 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S265663AbUBJAjY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Feb 2004 19:39:24 -0500
Content-Disposition: inline
In-Reply-To: <20040209162036.A23821@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Linux SCSI list <linux-scsi@vger.kernel.org>


--4eRLI4hEmsdu6Npr
Content-Type: multipart/mixed; boundary="4VrXvz3cwkc87Wze"
Content-Disposition: inline


--4VrXvz3cwkc87Wze
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Feb 09, 2004 at 04:20:36PM +0000, Christoph Hellwig wrote:
> On Mon, Feb 09, 2004 at 11:09:20AM -0500, James Bottomley wrote:
> > Actually, no, I'd like to see module name as well.
> > We need a more generic than SCSI solution for this, I think,
>=20
> Agreed, this makes sense in common code.  In fact I remember the
> driver model people were talking about it a while ago.

OK, let's export the proc_name then. It's some name that can be used
to identify the driver, works for code both compiled statically or
as module, is reasonably short and very often resembles the module
name.

For the module_name, let's wait for a generic sysfs solution.=20

Please merge the attached patch.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--4VrXvz3cwkc87Wze
Content-Type: text/plain; charset=us-ascii
Content-Description: scsi_sysfs-addnames2.diff
Content-Disposition: attachment; filename="scsi_sysfs-addnames2.diff"
Content-Transfer-Encoding: quoted-printable

--- drivers/scsi/scsi_sysfs.c.orig	2004-01-09 07:59:10.000000000 +0100
+++ drivers/scsi/scsi_sysfs.c	2004-02-10 01:29:36.903202660 +0100
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

--4VrXvz3cwkc87Wze--

--4eRLI4hEmsdu6Npr
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAKCbbxmLh6hyYd04RAu0oAJ96Sknr1kvBTaGiv3mgIS4RojlPrwCgyHub
R4fIXIEdFJFtd/TMeTBK5Ss=
=VEKz
-----END PGP SIGNATURE-----

--4eRLI4hEmsdu6Npr--
