From: Kurt Garloff <garloff@suse.de>
Subject: PATCH 4/5: scsi-scan-dont-att-pq-notcon
Date: Wed, 21 Apr 2004 16:14:17 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040421141417.GV28633@tpkurt.garloff.de>
References: <20040418185751.GC4868@tpkurt.garloff.de> <1082330192.1969.37.camel@mulgrave> <20040420115419.GG4356@tpkurt.garloff.de> <1082471881.1804.34.camel@mulgrave> <20040420160334.GO4356@tpkurt.garloff.de> <20040421134511.GP28633@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EyuBRJR0MsVMWKTf"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:18096 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S262931AbUDUOOj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2004 10:14:39 -0400
Content-Disposition: inline
In-Reply-To: <20040421134511.GP28633@tpkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>, Patrick Mansfield <patmans@us.ibm.com>


--EyuBRJR0MsVMWKTf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Bugfix

Don't attach high level drivers (except sg) to devices with peripheral
qualifier indicating not connected (1) or not capable (3).
SPC3, 7.4.2.

diff -uNrp linux-2.6.5.nooffline/drivers/scsi/osst.c linux-2.6.5.dontattach=
offl/drivers/scsi/osst.c
--- linux-2.6.5.nooffline/drivers/scsi/osst.c	2004-04-04 05:37:06.000000000=
 +0200
+++ linux-2.6.5.dontattachoffl/drivers/scsi/osst.c	2004-04-21 14:29:38.0000=
00000 +0200
@@ -5433,8 +5433,11 @@ static int osst_probe(struct device *dev
 	OSST_buffer    * buffer;
 	struct gendisk * drive;
 	int              i, mode, dev_num;
+	int 		 pq =3D (SDp->inquiry[0] >> 5) & 7;
=20
-	if (SDp->type !=3D TYPE_TAPE || !osst_supports(SDp))
+	if (SDp->type !=3D TYPE_TAPE ||
+	    !osst_supports(SDp) ||
+	    pq !=3D SCSI_INQ_PQ_CON)
 		return -ENODEV;
=20
 	drive =3D alloc_disk(1);
diff -uNrp linux-2.6.5.nooffline/drivers/scsi/sr.c linux-2.6.5.dontattachof=
fl/drivers/scsi/sr.c
--- linux-2.6.5.nooffline/drivers/scsi/sr.c	2004-04-20 21:51:41.000000000 +=
0200
+++ linux-2.6.5.dontattachoffl/drivers/scsi/sr.c	2004-04-21 14:29:38.000000=
000 +0200
@@ -553,9 +553,11 @@ static int sr_probe(struct device *dev)
 	struct gendisk *disk;
 	struct scsi_cd *cd;
 	int minor, error;
+	int pq =3D (sdev->inquiry[0] >> 5) & 7;
=20
 	error =3D -ENODEV;
-	if (sdev->type !=3D TYPE_ROM && sdev->type !=3D TYPE_WORM)
+	if ((sdev->type !=3D TYPE_ROM && sdev->type !=3D TYPE_WORM) ||
+	    pq !=3D SCSI_INQ_PQ_CON)
 		goto fail;
=20
 	if ((error =3D scsi_device_get(sdev)) !=3D 0)
diff -uNrp linux-2.6.5.nooffline/drivers/scsi/st.c linux-2.6.5.dontattachof=
fl/drivers/scsi/st.c
--- linux-2.6.5.nooffline/drivers/scsi/st.c	2004-04-04 05:37:36.000000000 +=
0200
+++ linux-2.6.5.dontattachoffl/drivers/scsi/st.c	2004-04-21 14:29:38.000000=
000 +0200
@@ -3736,10 +3736,12 @@ static int st_probe(struct device *dev)
 	ST_partstat *STps;
 	ST_buffer *buffer;
 	int i, j, mode, dev_num, error;
+	int pq =3D (SDp->inquiry[0] >> 5) & 7;
 	char *stp;
 	u64 bounce_limit;
=20
-	if (SDp->type !=3D TYPE_TAPE)
+	if (SDp->type !=3D TYPE_TAPE ||
+	    pq !=3D SCSI_INQ_PQ_CON)
 		return -ENODEV;
 	if ((stp =3D st_incompatible(SDp))) {
 		printk(KERN_INFO
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--EyuBRJR0MsVMWKTf
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAhoG5xmLh6hyYd04RAjpOAJ0baYmYctGhy4L9o7imuZ3EC81XKQCfWnvl
ch5V4hT/n+tQFhsD+501yAk=
=eF4e
-----END PGP SIGNATURE-----

--EyuBRJR0MsVMWKTf--
