From: Martin Pitt <martin.pitt@ubuntu.com>
Subject: [PATCH 0/1] Option for scsi_debug to fake removable devices
Date: Tue, 5 Jun 2012 09:25:28 +0200
Message-ID: <20120605072528.GE3043@piware.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="2B/JsCI69OhZNC5r"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.piware.de ([213.9.93.70]:57609 "EHLO mail.piware.de"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752917Ab2FEHeJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Jun 2012 03:34:09 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Zeuthen <zeuthen@gmail.com>, Kay Sievers <kay@vrfy.org>


--2B/JsCI69OhZNC5r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello all,

For the purposes of automatically testing udisks and gvfs automounting
I would like to add a parameter to scsi_debug to control the
"removable" attribute of the created block device. With that, we can
test system-internal and removable drives, as well as CD-ROMs (which
scsi_debug can already emulate). udisks requires different privileges
for mounting system-internal drives vs.  removable/hotpluggable
drives.

I wrote a simple kernel patch for this (against linux-next), and
tested this quite thoroughly.

I ran the style checker, and it reports two problems:

------------ 8< --------------
WARNING: line over 80 characters
#109: FILE: drivers/scsi/scsi_debug.c:3255:
+       ret |=3D driver_create_file(&sdebug_driverfs_driver, &driver_attr_r=
emovable);

WARNING: Prefer pr_err(... to printk(KERN_ERR, ...
#126: FILE: drivers/scsi/scsi_debug.c:3353:
+               printk(KERN_ERR "scsi_debug_init: removable must be 0 or 1\=
n");
------------ 8< --------------

But as the existing code uses this style in the adjacent lines, I
favored consistency over fixing those. If the latter is desired, I'd
rather send a separate patch with just the style cleanup for the whole
file.

I got a signoff from David Zeuthen (the primary udisks maintainer)
already, noted so in the patch.

Thank you in advance for considering,

Martin

--=20
Martin Pitt                        | http://www.piware.de
Ubuntu Developer (www.ubuntu.com)  | Debian Developer  (www.debian.org)

--2B/JsCI69OhZNC5r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPzbRnAAoJEPmIJawmtHufj4gP/A4lX2187drcZrTnHeW15qyX
SZArrZvpfqVOt/mtS+dHBP3iOEsbIr7M4OWTsEdNoXycV93RwPA6O/ukRIGzWp27
3j2Lj7IXobY6lu5GaICaPXsqXYMiDzEQGCoc0cVlqzV3B1+Fv/GrVsTtRxEQGttm
5M9spwGQHVL71RzvPYU3DcW7jeIzOwyeCx1txprRs3U6Ojc05VPI9znJj0gYU3TC
+T2U2nX4GTUQRQYv17uTno5hotgJMMjCLcNtHI7XRdzdoc+VXeRrgw2Qzj+gWMjK
ivEu9TmIjwStOPT8UbINxIJ/Q7yzyrM+68VipXlNdZniiDJTfOoA8AKZkv8bhzOV
GY2qIFu2FHW+k+JJrG99F8mQj8R3mck1lRBnQIdxeTdUbzV/TNpYwJCvsuRUWxO4
wv/4N3S/qDtHgIuaW4MutIhAHJWJ89+OxH8XCaeCmkOgG+Zl/fy8wKtuvWjF14PN
M0y+PNEdmiG95cOeKx39bItgqZ2lLjlrG79AOeNveQZ8+F9urCczMlbmVS02NW0k
y+FfsHEgmzJZzZTVDR9SEx5A/JTWDCmXzGSkKkZbr0VYrftVJZ2Nsf/StryUiKwr
xJAJW+c4vcAFjavdAEHR4rBFDTAC3IAmATLmUfAxqBKJv1Mmih4y+Be4u7gFWOqK
VkwigPKzb8qNy2IID71h
=Da9m
-----END PGP SIGNATURE-----

--2B/JsCI69OhZNC5r--
