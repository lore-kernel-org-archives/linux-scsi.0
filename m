From: Kurt Garloff <garloff@suse.de>
Subject: Re: Patches for SCSI scanning
Date: Tue, 20 Apr 2004 13:54:19 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040420115419.GG4356@tpkurt.garloff.de>
References: <20040418185751.GC4868@tpkurt.garloff.de> <1082330192.1969.37.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BZaMRJmqxGScZ8Mx"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:14742 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S262756AbUDTLyY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Apr 2004 07:54:24 -0400
Content-Disposition: inline
In-Reply-To: <1082330192.1969.37.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andrew Morton <akpm@osdl.org>, Linux SCSI list <linux-scsi@vger.kernel.org>


--BZaMRJmqxGScZ8Mx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Sun, Apr 18, 2004 at 06:16:31PM -0500, James Bottomley wrote:
> Erm, Kurt, we already have a module load time parameter for altering
> both blacklist entries and scanning defaults.
>=20
> It's dev_flags and default_dev_flags in scsi_devinfo.c
>=20
> Could you first explain why you can't use this existing infrastructure?

I've overlooked that possibility.
default_dev_flags obsoletes patch 1 (sparselun and largelun paramters --=20
almost, but max_sparseluns is probably only useful in corner cases),=20
and dev_flags obsoletes the patch 6 (llun_blklst).

I'll drop them.

What about the others:
* Patch 2: Drop REPORT_LUN config option and introduce=20
  noreportlun and reportlun2 parameters (the latter allowing SCSI-2
  devs to be scanned with REPORT_LUNS).
* Patch 3: Allow host adapters to avoid REPORT_LUNS.
* Patch 4: allow_ghost_devices parameter
* Patch 5: inq_timeout parameter=20

If we introduce two more BLIST flags (BLIST_NOREPORTLUN and
BLIST_REPORTLUN2), we can get rid of patch 2 and 3, if we add another one
(BLIST_LUN0ONLINE), we can get rid off 4.

We have 16 bits left, so it should be possible.

If there's consensus to go that way, I can code it up, no problem.
Only patch 5 will remain then ...

Sidenote: We should drop SCSI_FORCELUN and CONFIG_SCSI_MULTI_LUN, otherwise=
=20
people will misconfigure their kernel (such as the HP guy) and start to wan=
t=20
every multi-lun device listed.

Regards,
--=20
Kurt Garloff                   <kurt@garloff.de>             [Koeln, DE]
Physics:Plasma modeling <garloff@plasimo.phys.tue.nl> [TU Eindhoven, NL]
Linux: SUSE Labs (Head)        <garloff@suse.de>    [SUSE Nuernberg, DE]

--BZaMRJmqxGScZ8Mx
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAhQ9qxmLh6hyYd04RAgP/AJ0bo0xJpDNyKGDoz2cu2MKh2DATlACgznkk
ioLhRiSmkOBsyd14QumSD1U=
=QGY0
-----END PGP SIGNATURE-----

--BZaMRJmqxGScZ8Mx--
