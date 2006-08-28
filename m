From: Doug Ledford <dledford@redhat.com>
Subject: Re: aic79xx driver - hotswap error
Date: Mon, 28 Aug 2006 15:45:11 +0000
Message-ID: <1156779911.28832.28.camel@fc6.xsintricity.com>
References: <20060828121542.GA13993@pc000ffe3ca343.math.ku.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7qs6Gac20EMkDVkhlsSb"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:16079 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1751099AbWH1PpX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Aug 2006 11:45:23 -0400
In-Reply-To: <20060828121542.GA13993@pc000ffe3ca343.math.ku.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Zuziak <zuziak@math.ku.dk>
Cc: linux-scsi@vger.kernel.org


--=-7qs6Gac20EMkDVkhlsSb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2006-08-28 at 14:15 +0200, Martin Zuziak wrote:
> Hello all
>=20
> Hot-swapping doesn't seem to work with the aic79xx driver in kernel
> 2.6.17.9. Removing or adding a disk from/to a running system makes i/o
> to any disk on the bus fail.
>=20
> The machine is an IBM x346 server with a x86_64 cpu and a aic7902 scsi
> controller.
>=20
> A copy of the system log is here:
> http://www.math.ku.dk/~zuziak/tmp/aic79xx_error_2.6.17.9.log
>=20
> It shows the result of removing the third disk: the first disk (the only
> one mounted) becomes inaccessible.
>=20
> Kernel 2.6.15.7 seems to work but I have had no luck with newer kernels.
>=20
> Has anyone seen hot-swapping work with the aic79xx driver in recent
> kernels?

Are you sure your system is hot swap safe?  The whole log mess begins
with "someone reset channel A" which means the card detected a bus reset
but it didn't initiate the reset.  That's either going to be because
your system shouldn't be hot swap plugged and it triggered a spike on
the reset pin, or because your hot swap drive setup resets the bus on
unplug intentionally.  Knowing that would help.

So, the driver managed to get into the ahd_pause_and_flushwork()
function, probably while trying to queue the abort SCB, and while there
it detected an infinite loop and printed out the "Infinite interrupt
loop, INTSTAT =3D 8" message.  The INTSTAT value of 0x08 maps to SCSIINT,
so next you would look at the SCSIINT1 and SCSIINT2 registers to see
just *what* is causing the loop.  There you see SSTAT1[0x20]:(SCSIRSTI).
This tells us the driver is *still* getting a SCSI Reset In interrupt
from the card, even over 1 minute after you pulled the drive.  So, the
reason your SCSI bus hung is because everything on the bus is being
subjected to an infinite bus reset condition.  The cause of this
happening is likely either A) your bus isn't hot swap safe and you hot
swapped anyway, and in the process you disconnected the termination
power source or termination itself or just plain flaked other devices on
the bus out or B) something in your hot swap enclosure is broken and
throws an infinite bus reset when the drive is removed.  Either way,
this is not what I would call expected behavior from the aic79xx driver,
I suspect that it is innocent here and that the hardware is to blame.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-7qs6Gac20EMkDVkhlsSb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBE8w+Hg6WylM+/8ZQRArviAJ93tC+qnjDEUn+shQVG+96oyy+OmACdHj2a
dFt5tnik6c0OthQnpEzO5cM=
=sP3d
-----END PGP SIGNATURE-----

--=-7qs6Gac20EMkDVkhlsSb--

