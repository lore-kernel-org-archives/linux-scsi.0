From: Gerhard Schneider <gs@ilsb.tuwien.ac.at>
Subject: Re: SCSI tape access on 2.6 kernels?
Date: Tue, 24 Jan 2006 22:01:04 +0100
Message-ID: <43D69590.5050003@ilsb.tuwien.ac.at>
References: <43D604AD.6050607@ilsb.tuwien.ac.at> <Pine.LNX.4.64.0601241251460.23364@localhost.localdomain> <Pine.LNX.4.63.0601242251190.6350@kai.makisara.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig70A47EC1F126287215560BB4"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gh-gw1.ilsb.tuwien.ac.at ([128.130.23.14]:63634 "EHLO
	gh-gw1.ilsb.tuwien.ac.at") by vger.kernel.org with ESMTP
	id S1750708AbWAXVBN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jan 2006 16:01:13 -0500
In-Reply-To: <Pine.LNX.4.63.0601242251190.6350@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig70A47EC1F126287215560BB4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Kai Makisara schrieb:

> The only thing that could be seen in Gerhard's tests with try_direct_io=
=3D0=20
> should be higher CPU load. It probably won't have any effect on the spe=
ed=20
> in these tests.
>=20
> Disabling direct i/o helps in fixed block mode if the application's rea=
d()=20
> and write() byte counts are small, e.g., 10 kB. With 64 kB it should no=
t=20
> have any effect. Additionally, Gerhard is probably using variable block=
=20
> mode and there is no read-ahead. There is write-behind which is disable=
d=20
> when doing direct i/o but this should have no effect since if the HBA i=
s=20
> able to sustain the speed the drive requires.
>=20

I fear you're right. There hasn't been any significant difference in
write/read speed when enabling/disabling direct i/o (significant doesn't
mean a speedup of 20-100% - I want to see more than 40MB/s on a LTO-3
tape drive, and not 1.2)..

Different fixed and variable block sizes didn't show significant speed
increases, too.. - and I still expect a kernel problem, not a tape
problem..

Tomorrow I will compile a kernel < 2.6.12 and redo testing..

                                             GS

--=20
Gerhard Schneider
Institute of Lightweight Design and         e-Mail: gs@ilsb.tuwien.ac.at
Structural Biomechanics (E317)                 Tel.:   +43 1 58801 31716
Vienna University of Technology / Austria      Fax:    +43 1 58801 31799
A-1040 Wien, Gusshausstrasse 27-29     http://www.ilsb.tuwien.ac.at/~gs/



--------------enig70A47EC1F126287215560BB4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFD1pWUE6e53f4wQG4RAs4eAKC6qki5Rlo/h2KOuoM76C1HPYnTNgCeMIRQ
1Bm/Tp7RALulwcU53Hu2hhY=
=kzHe
-----END PGP SIGNATURE-----

--------------enig70A47EC1F126287215560BB4--
