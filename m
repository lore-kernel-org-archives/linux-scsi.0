From: Kurt Garloff <garloff@suse.de>
Subject: Re: PATCH 4/5: scsi-scan-dont-att-pq-notcon
Date: Wed, 21 Apr 2004 18:58:48 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040421165848.GC643@tpkurt.garloff.de>
References: <20040420115419.GG4356@tpkurt.garloff.de> <1082471881.1804.34.camel@mulgrave> <20040420160334.GO4356@tpkurt.garloff.de> <20040421134511.GP28633@tpkurt.garloff.de> <20040421141417.GV28633@tpkurt.garloff.de> <20040421160257.A6793@infradead.org> <20040421152436.GD29699@tpkurt.garloff.de> <20040421163336.A7382@infradead.org> <20040421160823.GK29699@tpkurt.garloff.de> <1082564314.1932.22.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w7PDEPdKQumQfZlR"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:41418 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S263544AbUDUQ6w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2004 12:58:52 -0400
Content-Disposition: inline
In-Reply-To: <1082564314.1932.22.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Christoph Hellwig <hch@infradead.org>, Linux SCSI list <linux-scsi@vger.kernel.org>, Patrick Mansfield <patmans@us.ibm.com>, Andrew Morton <akpm@osdl.org>


--w7PDEPdKQumQfZlR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 21, 2004 at 11:18:30AM -0500, James Bottomley wrote:
> There's logic to parsing data where it's needed, but it makes it
> difficult to locate all the places when it changes...

OK, then consider this patch.


diff -uNrp linux-2.6.5/drivers/scsi/scsi_scan.c linux-2.6.5.nooffl/drivers/=
scsi/scsi_scan.c
--- linux-2.6.5/drivers/scsi/scsi_scan.c	2004-04-21 18:53:52.000000000 +0200
+++ linux-2.6.5.nooffl/drivers/scsi/scsi_scan.c	2004-04-21 18:56:02.0000000=
00 +0200
@@ -542,17 +542,12 @@ static int scsi_add_lun(struct scsi_devi
 	 * 011 the same. Stay compatible with previous code, and create a
 	 * Scsi_Device for a PQ of 1
 	 *
-	 * XXX Save the PQ field let the upper layers figure out if they
-	 * want to attach or not to this device, do not set online FALSE;
-	 * otherwise, offline devices still get an sd allocated, and they
-	 * use up an sd slot.
-	 */
-	if (((inq_result[0] >> 5) & 7) =3D=3D 1) {
-		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: peripheral"
-				" qualifier of 1, device offlined\n"));
-		sdev->online =3D FALSE;
-	}
+	 * Don't set the device offline here; rather let the upper
+	 * level drivers eval the PQ to decide whether they should
+	 * attach. So remove ((inq_result[0] >> 5) & 7) =3D=3D 1 check.
+	 */=20
=20
+	sdev->inq_periph_qual =3D (inq_result[0] >> 5) & 7;
 	sdev->removable =3D (0x80 & inq_result[1]) >> 7;
 	sdev->lockable =3D sdev->removable;
 	sdev->soft_reset =3D (inq_result[7] & 1) && ((inq_result[3] & 7) =3D=3D 2=
);
diff -uNrp linux-2.6.5/drivers/scsi/scsi_sysfs.c linux-2.6.5.nooffl/drivers=
/scsi/scsi_sysfs.c
--- linux-2.6.5/drivers/scsi/scsi_sysfs.c	2004-04-04 05:36:26.000000000 +02=
00
+++ linux-2.6.5.nooffl/drivers/scsi/scsi_sysfs.c	2004-04-21 18:56:33.000000=
000 +0200
@@ -155,7 +155,8 @@ struct class sdev_class =3D {
 /* all probing is done in the individual ->probe routines */
 static int scsi_bus_match(struct device *dev, struct device_driver *gendrv)
 {
-	return 1;
+	struct scsi_device *sdp =3D to_scsi_device(dev);
+	return (sdp->inq_periph_qual =3D=3D SCSI_INQ_PQ_CON)? 1: 0;
 }
=20
 struct bus_type scsi_bus_type =3D {
diff -uNrp linux-2.6.5/include/scsi/scsi.h linux-2.6.5.nooffl/include/scsi/=
scsi.h
--- linux-2.6.5/include/scsi/scsi.h	2004-04-21 18:53:51.000000000 +0200
+++ linux-2.6.5.nooffl/include/scsi/scsi.h	2004-04-21 18:54:43.000000000 +0=
200
@@ -365,6 +365,13 @@ struct scsi_lun {
 #define SCSI_2          3
 #define SCSI_3          4
=20
+/*
+ * INQ PERIPHERAL QUALIFIERS
+ */
+#define SCSI_INQ_PQ_CON         0x00
+#define SCSI_INQ_PQ_NOT_CON     0x01
+#define SCSI_INQ_PQ_NOT_CAP     0x03
+
=20
 /*
  * Here are some scsi specific ioctl commands which are sometimes useful.
diff -uNrp linux-2.6.5/include/scsi/scsi_device.h linux-2.6.5.nooffl/includ=
e/scsi/scsi_device.h
--- linux-2.6.5/include/scsi/scsi_device.h	2004-04-21 18:53:45.000000000 +0=
200
+++ linux-2.6.5.nooffl/include/scsi/scsi_device.h	2004-04-21 18:55:21.00000=
0000 +0200
@@ -59,6 +59,7 @@ struct scsi_device {
 	char devfs_name[256];	/* devfs junk */
 	char type;
 	char scsi_level;
+	char inq_periph_qual;	/* PQ from INQUIRY data */=09
 	unsigned char inquiry_len;	/* valid bytes in 'inquiry' */
 	unsigned char * inquiry;	/* INQUIRY response data */
 	char * vendor;		/* [back_compat] point into 'inquiry' ... */

--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--w7PDEPdKQumQfZlR
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAhqhIxmLh6hyYd04RAv+aAJ47plN7DGnrFkWUGymedxumDbKXLACdFbzw
hYbgdvvIKuoZ6z4hzJVhqPI=
=Vazq
-----END PGP SIGNATURE-----

--w7PDEPdKQumQfZlR--
