From: Kurt Garloff <garloff@suse.de>
Subject: Re: Patches for SCSI scanning
Date: Tue, 20 Apr 2004 18:03:34 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040420160334.GO4356@tpkurt.garloff.de>
References: <20040418185751.GC4868@tpkurt.garloff.de> <1082330192.1969.37.camel@mulgrave> <20040420115419.GG4356@tpkurt.garloff.de> <1082471881.1804.34.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WuedheRyq6FDfQ9j"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:20965 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S263045AbUDTQGA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Apr 2004 12:06:00 -0400
Content-Disposition: inline
In-Reply-To: <1082471881.1804.34.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andrew Morton <akpm@osdl.org>, Linux SCSI list <linux-scsi@vger.kernel.org>


--WuedheRyq6FDfQ9j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 20, 2004 at 09:38:00AM -0500, James Bottomley wrote:
> Agree, but should be a blacklist flag to force the use of report luns in
> the scan.

Sure, I favour that solution as well.

> > * Patch 3: Allow host adapters to avoid REPORT_LUNS.
>=20
> This should be a black list flag too, but first explain why we need it.=
=20
> The only devices we do REPORT_LUNS for are SCSI 3 ones.  Which SCSI 3
> device is so badly implemented as to respond incorrectly?  I mean these
> are recent devices, so the implementors should have learned from past
> mistakes, right ?

Linux maps 8 byte LUNs to a 32bit number in scsilun_to_int().
There are several ways to use the 8 bytes, but the mapping assumes
a particular model which is often used and the mapping is nice in
that it results in LUNs being 0, 1, 2, ...
However, there are other possibilities. And as soon as the last
four bytes are non-zero, the mapping will break down :-/
The S/390 folks seem to have such devices.

Anyway, we get the BLIST flag for free when we replace patch 2
with BLIST_NOREPORTLUN and BLIST_REPORTLUN2.

> > * Patch 4: allow_ghost_devices parameter
>=20
> Blacklist flag again (oh and "Yuk!!!" by the way).

OK.

> > * Patch 5: inq_timeout parameter
>=20
> OK, just remove the arch gating of the default (ppc64 will have to have
> a permanent boot/module flag).

Sure, I already agreed to remove that ugly part.

> > If we introduce two more BLIST flags (BLIST_NOREPORTLUN and
> > BLIST_REPORTLUN2), we can get rid of patch 2 and 3, if we add another o=
ne
> > (BLIST_LUN0ONLINE), we can get rid off 4.
> >=20
> > We have 16 bits left, so it should be possible.
> >=20
> > If there's consensus to go that way, I can code it up, no problem.
> > Only patch 5 will remain then ...
>=20
> Yes, I'm fine with that (as long as the arch specific code from patch 5
> goes).

Expect patches later today.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--WuedheRyq6FDfQ9j
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAhUnWxmLh6hyYd04RAi0oAKCBMVQz50lWKG3uOFb74uKSsFZkxgCdF9gW
wv9e6k4tnR6zDKboThkijNQ=
=cANJ
-----END PGP SIGNATURE-----

--WuedheRyq6FDfQ9j--
