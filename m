From: Matthias Urlichs <smurf@smurf.noris.de>
Subject: divide by zero error in initio driver
Date: Wed, 25 Jan 2006 22:28:06 +0100
Message-ID: <20060125212806.GA19590@kiste.smurf.noris.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from run.smurf.noris.de ([192.109.102.41]:38829 "EHLO
	server.smurf.noris.de") by vger.kernel.org with ESMTP
	id S932120AbWAYV22 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jan 2006 16:28:28 -0500
Received: from kiste.smurf.noris.de ([192.109.102.35] ident=mail)
	by server.smurf.noris.de with smtp (Exim 4.50)
	id 1F1sBT-0006Jt-4J
	for linux-scsi@vger.kernel.org; Wed, 25 Jan 2006 22:28:16 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

the initio driver says in *_biosparam:
        info_array[0] =3D pTcb->TCS_DrvHead;
        info_array[1] =3D pTcb->TCS_DrvSector;
        info_array[2] =3D (unsigned long)capacity / pTcb->TCS_DrvHead / pTc=
b- + >TCS_DrvSector;

That causes a nice divide-by-zero error when one of these
happens to contain the right values of garbage -- I just connected
a few disks to my SCSI card, fired it up, and got a segfault fdisk'ing
two of my four new shiny SCA drives. :-/

What should happen in this case?
Fall back to fake 32/16 values?
Return an error?

--=20
Matthias Urlichs   |   {M:U} IT Design @ m-u-it.de   |  smurf@smurf.noris.de
Disclaimer: The quote was selected randomly. Really. | http://smurf.noris.de
 - -
:red wire: n. [IBM] Patch wires installed by programmers who have no
   business mucking with the hardware. It is said that the only thing more
   dangerous than a hardware guy with a code patch is a {softy} with a
   soldering iron.... Compare {blue wire}, {yellow wire}, {purple wire}.

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFD1+1m8+hUANcKr/kRAnFgAJ0RSM2iuxM470eOvyOvw7uQdUOc3QCggz4S
z9RscxDbmc2lhcKy7lgR0y0=
=XYxD
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
