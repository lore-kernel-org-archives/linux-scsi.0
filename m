From: Kurt Garloff <garloff@suse.de>
Subject: PATCH 3/5: scsi-scan-no-offl-pq-notcon
Date: Wed, 21 Apr 2004 16:13:33 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040421141333.GU28633@tpkurt.garloff.de>
References: <20040418185751.GC4868@tpkurt.garloff.de> <1082330192.1969.37.camel@mulgrave> <20040420115419.GG4356@tpkurt.garloff.de> <1082471881.1804.34.camel@mulgrave> <20040420160334.GO4356@tpkurt.garloff.de> <20040421134511.GP28633@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1Dvf9Qz7hFaodvwE"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:50863 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S262923AbUDUOOd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2004 10:14:33 -0400
Content-Disposition: inline
In-Reply-To: <20040421134511.GP28633@tpkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>, Patrick Mansfield <patmans@us.ibm.com>


--1Dvf9Qz7hFaodvwE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Bugfix

Don't mark devices with PQ =3D 1 (or 3) offline, as they can't be accessed
at all then any more, not even by sg.
Instead check in sd HL driver not to connect to NOT_CON or NOT_CAP LUNs.
SPC3, 7.4.2.

diff -uNrp linux-2.6.5.replun/drivers/scsi/scsi_scan.c linux-2.6.5.noofflin=
e/drivers/scsi/scsi_scan.c
--- linux-2.6.5.replun/drivers/scsi/scsi_scan.c	2004-04-21 14:26:31.0000000=
00 +0200
+++ linux-2.6.5.nooffline/drivers/scsi/scsi_scan.c	2004-04-21 14:28:13.0000=
00000 +0200
@@ -542,16 +542,10 @@ static int scsi_add_lun(struct scsi_devi
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
+	 * 2004-04-20: Don't set the device offline here; rather let the=20
+	 * upper level drivers eval the PQ to decide whether they should
+	 * attach. So remove ((inq_result[0] >> 5) & 7) =3D=3D 1 check.
+	 */=20
=20
 	sdev->removable =3D (0x80 & inq_result[1]) >> 7;
 	sdev->lockable =3D sdev->removable;
diff -uNrp linux-2.6.5.replun/drivers/scsi/sd.c linux-2.6.5.nooffline/drive=
rs/scsi/sd.c
--- linux-2.6.5.replun/drivers/scsi/sd.c	2004-04-20 21:51:50.000000000 +0200
+++ linux-2.6.5.nooffline/drivers/scsi/sd.c	2004-04-21 14:28:13.000000000 +=
0200
@@ -1383,10 +1383,13 @@ static int sd_probe(struct device *dev)
 	struct gendisk *gd;
 	u32 index;
 	int error, devno;
+	int pq =3D (sdp->inquiry[0] >> 5) & 7;
=20
 	error =3D -ENODEV;
-	if ((sdp->type !=3D TYPE_DISK) && (sdp->type !=3D TYPE_MOD))
+	if (pq !=3D SCSI_INQ_PQ_CON ||
+	    (sdp->type !=3D TYPE_DISK && sdp->type !=3D TYPE_MOD))
 		goto out;
+=09
=20
 	SCSI_LOG_HLQUEUE(3, printk("sd_attach: scsi device: <%d,%d,%d,%d>\n",=20
 			 sdp->host->host_no, sdp->channel, sdp->id, sdp->lun));
diff -uNrp linux-2.6.5.replun/include/scsi/scsi.h linux-2.6.5.nooffline/inc=
lude/scsi/scsi.h
--- linux-2.6.5.replun/include/scsi/scsi.h	2004-04-20 21:51:40.000000000 +0=
200
+++ linux-2.6.5.nooffline/include/scsi/scsi.h	2004-04-21 14:28:13.000000000=
 +0200
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
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--1Dvf9Qz7hFaodvwE
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAhoGMxmLh6hyYd04RAoxqAJ9SHme6oVJLmmNjpCUy4S0Ayl9dBgCeLi5p
H6SoWwI3E81m4RnrjV584nI=
=h8fY
-----END PGP SIGNATURE-----

--1Dvf9Qz7hFaodvwE--
