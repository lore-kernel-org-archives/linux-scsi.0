From: Kurt Garloff <garloff@suse.de>
Subject: Re: Patches for SCSI scanning
Date: Wed, 21 Apr 2004 15:45:11 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040421134511.GP28633@tpkurt.garloff.de>
References: <20040418185751.GC4868@tpkurt.garloff.de> <1082330192.1969.37.camel@mulgrave> <20040420115419.GG4356@tpkurt.garloff.de> <1082471881.1804.34.camel@mulgrave> <20040420160334.GO4356@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8N0TQpGUCeEQshoq"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:49551 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S262170AbUDUNpQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2004 09:45:16 -0400
Content-Disposition: inline
In-Reply-To: <20040420160334.GO4356@tpkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>, Linux SCSI list <linux-scsi@vger.kernel.org>


--8N0TQpGUCeEQshoq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 20, 2004 at 06:03:34PM +0200, Kurt Garloff wrote:
> Expect patches later today.

Here we go.

Patch 1: scsi-scan-depr-forcelun
	Document that we don;'t want every single multi-lun device=20
	be listed with FORCELUN. That way lays madness.
Patch 2: scsi-scan-blist-replun
	Drop CONFIG_SCSI_REPORT_LUN config param. Instead provide
	BLIST_NOREPORTLUN, which can be used globally (or per device).
	Also add BLIST_REPORTLUN2, which allows REPORT_LUNS even for=20
	SCSI-2 if the host adapter support more than 8 LUNs.
	Bump default no of supported LUNs to 511 (so the kmalloc fits
	in one 4k page).=20
Patch 3: scsi-scan-no-offl-pq-notcon
	Don't mark devices with PQ 1 or 3 offline. Leave them, so they
	can be accessed via sg. Prevent the sd driver from attachind
	to such devices.
	This is the port of Mike Anderson's patch as suggested by Pat.
Patch 4: scsi-scan-dont-att-pq-notcon
	The other high level drivers (except sg, which is not really=20
	high) should not attach to PQ =3D 1 or 3 devices either.
Patch 5: scsi-scan-inq-timeout
	Make the INQUIRY timeout during SCSI scanning adjustable, so
	users can work around broken devices.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--8N0TQpGUCeEQshoq
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAhnrnxmLh6hyYd04RAks3AJ0ZA/xz/qNvWqm4AWLWY/8CewIJ+ACg1IoW
vg+z79oz8upzv7EXj9KlCnQ=
=NuMW
-----END PGP SIGNATURE-----

--8N0TQpGUCeEQshoq--
