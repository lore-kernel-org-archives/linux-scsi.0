From: Kurt Garloff <garloff@suse.de>
Subject: Re: PATCH 4/5: scsi-scan-dont-att-pq-notcon
Date: Wed, 21 Apr 2004 17:24:36 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040421152436.GD29699@tpkurt.garloff.de>
References: <20040418185751.GC4868@tpkurt.garloff.de> <1082330192.1969.37.camel@mulgrave> <20040420115419.GG4356@tpkurt.garloff.de> <1082471881.1804.34.camel@mulgrave> <20040420160334.GO4356@tpkurt.garloff.de> <20040421134511.GP28633@tpkurt.garloff.de> <20040421141417.GV28633@tpkurt.garloff.de> <20040421160257.A6793@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VMt1DrMGOVs3KQwf"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:20971 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S263191AbUDUPZS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2004 11:25:18 -0400
Content-Disposition: inline
In-Reply-To: <20040421160257.A6793@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Patrick Mansfield <patmans@us.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>


--VMt1DrMGOVs3KQwf
Content-Type: multipart/mixed; boundary="WplhKdTI2c8ulnbP"
Content-Disposition: inline


--WplhKdTI2c8ulnbP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 21, 2004 at 04:02:58PM +0100, Christoph Hellwig wrote:
> On Wed, Apr 21, 2004 at 04:14:17PM +0200, Kurt Garloff wrote:
> >=20
> > Don't attach high level drivers (except sg) to devices with peripheral
> > qualifier indicating not connected (1) or not capable (3).
> > SPC3, 7.4.2.
>=20
> Please don't duplicate it in every driver but in scsi_bus_match.  sg uses
> a completely different attachment path so it shouldn't be affected by tha=
t.

Is it safe to assume it will stay like this?

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--WplhKdTI2c8ulnbP
Content-Type: text/plain; charset=us-ascii
Content-Description: scsi-scan-nomatch-pq-notcon
Content-Disposition: attachment; filename=scsi-scan-nomatch-pq-notcon
Content-Transfer-Encoding: quoted-printable

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

--WplhKdTI2c8ulnbP--

--VMt1DrMGOVs3KQwf
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAhpI0xmLh6hyYd04RAuC2AJ0eZimT93hSwat/VjLursRQMlGZCQCfXgpi
FVhyb8MObDd912gp/J7dsBI=
=2FyB
-----END PGP SIGNATURE-----

--VMt1DrMGOVs3KQwf--
