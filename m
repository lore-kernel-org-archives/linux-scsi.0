From: Kurt Garloff <garloff@suse.de>
Subject: Re: PATCH 4/5: scsi-scan-dont-att-pq-notcon
Date: Wed, 21 Apr 2004 18:16:05 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040421161605.GA643@tpkurt.garloff.de>
References: <20040418185751.GC4868@tpkurt.garloff.de> <1082330192.1969.37.camel@mulgrave> <20040420115419.GG4356@tpkurt.garloff.de> <1082471881.1804.34.camel@mulgrave> <20040420160334.GO4356@tpkurt.garloff.de> <20040421134511.GP28633@tpkurt.garloff.de> <20040421141417.GV28633@tpkurt.garloff.de> <20040421160257.A6793@infradead.org> <20040421152436.GD29699@tpkurt.garloff.de> <20040421163336.A7382@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:5284 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S263336AbUDUQQR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2004 12:16:17 -0400
Content-Disposition: inline
In-Reply-To: <20040421163336.A7382@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, Patrick Mansfield <patmans@us.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 21, 2004 at 04:33:36PM +0100, Christoph Hellwig wrote:
> (also needs a respin of the sd.c part of the previous patch, btw - and wh=
ile
> you're at it can you kill the date in the scsi_scan.c comment?  Everyone =
can
> see when it was applied in bk annotate or the web interface for it)

OTOH, there's so few to be changed that I can resend right away ;-)

garloff@suse.de

Bugfix

Don't mark devices with PQ =3D 1 (or 3) offline, as they can't be accessed
at all then any more, not even by sg.
Don't attach other upper level drivers if PQ !=3D 0.
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
+	 * Don't set the device offline here; rather let the upper
+	 * level drivers eval the PQ to decide whether they should
+	 * attach. So remove ((inq_result[0] >> 5) & 7) =3D=3D 1 check.
+	 */=20
=20
 	sdev->removable =3D (0x80 & inq_result[1]) >> 7;
 	sdev->lockable =3D sdev->removable;
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
diff -uNrp linux-2.6.5.attach/drivers/scsi/scsi_sysfs.c linux-2.6.5.noattac=
h/drivers/scsi/scsi_sysfs.c
--- linux-2.6.5.attach/drivers/scsi/scsi_sysfs.c	2004-04-04 05:36:26.000000=
000 +0200
+++ linux-2.6.5.noattach/drivers/scsi/scsi_sysfs.c	2004-04-21 17:22:22.0000=
00000 +0200
@@ -155,7 +155,9 @@ struct class sdev_class =3D {
 /* all probing is done in the individual ->probe routines */
 static int scsi_bus_match(struct device *dev, struct device_driver *gendrv)
 {
-	return 1;
+	struct scsi_device *sdp =3D to_scsi_device(dev);
+	int pq =3D (sdp->inquiry[0] >> 5) & 7;
+	return (pq =3D=3D SCSI_INQ_PQ_CON)? 1: 0;
 }
=20
 struct bus_type scsi_bus_type =3D {

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAhp5FxmLh6hyYd04RAvXSAJ96fA2/GrLq9edYkWBHhXavnzz2gACgm3eV
XvShxr0ZT37Bfx83oLX7ccs=
=eaU4
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
