From: Kurt Garloff <garloff@suse.de>
Subject: Re: PATCH 4/5: scsi-scan-dont-att-pq-notcon
Date: Thu, 22 Apr 2004 00:51:37 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040421225137.GE643@tpkurt.garloff.de>
References: <1082471881.1804.34.camel@mulgrave> <20040420160334.GO4356@tpkurt.garloff.de> <20040421134511.GP28633@tpkurt.garloff.de> <20040421141417.GV28633@tpkurt.garloff.de> <20040421160257.A6793@infradead.org> <20040421152436.GD29699@tpkurt.garloff.de> <20040421163336.A7382@infradead.org> <20040421160823.GK29699@tpkurt.garloff.de> <1082564314.1932.22.camel@mulgrave> <20040421095500.A17447@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+JUInw4efm7IfTNU"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:24805 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S262703AbUDUWvl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2004 18:51:41 -0400
Content-Disposition: inline
In-Reply-To: <20040421095500.A17447@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, Linux SCSI list <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>


--+JUInw4efm7IfTNU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 21, 2004 at 09:55:01AM -0700, Patrick Mansfield wrote:
> On Wed, Apr 21, 2004 at 11:18:30AM -0500, James Bottomley wrote:
> > There's logic to parsing data where it's needed, but it makes it
> > difficult to locate all the places when it changes...
>=20
> So add a macro or inline function to parse the data, like a sdev_pq(sdev),
> then we have one location for the parsing, and don't have to duplicate the
> data. And if sdev->inquiry changes or goes away we need only change
> sdev_pq().

#define sdev_pg(sdev) ((sdev->inquiry[0] >> 5) & 7)

Just there is no scsi_scan.h where we could stick this.
So either we have it at some non-obvious place or just once in
scsi_sysfs.c. Or in scsi_scan.c and add one char to struct scsi_dev.
I believe it's a very minor issue.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--+JUInw4efm7IfTNU
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAhvr5xmLh6hyYd04RAnBkAJ0WRSaL3WMJFRbGJWSRRbj5R3uZvQCfeNhm
/d9vLiF4/9yF+U16dqI1woA=
=KPHY
-----END PGP SIGNATURE-----

--+JUInw4efm7IfTNU--
