From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH stable 3/4] block: fail SCSI passthrough ioctls on
 partition devices
Date: Wed, 18 Jan 2012 16:04:36 +0000
Message-ID: <1326902676.3271.10.camel@deadeye>
References: <1326772723.2819.167.camel@deadeye>
	 <1326773222.2819.172.camel@deadeye> <4F1545A4.3000809@redhat.com>
	 <1326862077.2819.210.camel@deadeye> <4F168A49.8000606@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-iRPf7VBMQwTUe3FIl8dG"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F168A49.8000606@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: stable@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, Petr Matousek <pmatouse@redhat.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org


--=-iRPf7VBMQwTUe3FIl8dG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-01-18 at 10:00 +0100, Paolo Bonzini wrote:
> On 01/18/2012 05:47 AM, Ben Hutchings wrote:
> > >     Changes with respect to 3.3: return -ENOTTY from scsi_verify_blk_=
ioctl
> > >     and -ENOIOCTLCMD from sd_compat_ioctl. ]
> >
> > But in 2.6.32, compat_sys_ioctl will end up returning EINVAL rather tha=
n
> > ENOTTY for an unhandled ioctl number.
>=20
> No, it won't.  The ioctl will percolate up the non-compat path and then=
=20
> sd_ioctl will return ENOTTY.

Ah, yes.

> > Also, since we're denying ioctls
> > for security reasons rather than because we don't know how to handle
> > them, I don't think there's any harm in doing this.
>=20
> There is harm.  You'll be blacklisting also the standard block device=20
> ioctls, and those won't work on 32-on-64 anymore.  A system with 32-bit=
=20
> userland will likely not boot anymore.

It does (yes, I tested that myself now).  The standard block device
ioctls are handled without calling the driver's compat_ioctl.

> This is also somewhat exchanged in my original exchange with Linus.

Anyway, I agree that it is not necessary to differ from mainline here.

Ben.

--=20
Ben Hutchings
When in doubt, use brute force. - Ken Thompson


--=-iRPf7VBMQwTUe3FIl8dG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATxbtlOe/yOyVhhEJAQoN4hAAgOnelAuU47CyXox96eKB6Sg0kGFWg7mf
wwpN8EH/eICZV9OBu3MTySjbOnDE6W4Lvy4wWUfJWwarY9i+U82EsuwXRbIzLL//
cyFgyKvnAuN2yg9bzAVOaNnDL1UwQ8dxlqyNEsQzMZYXHxHckKXJryngSReXNVP2
XhdiAYeLMZXk/iHKSY+Zb0mRlG04SU81ruWIyTgPI20wk50Sc8Cso71skoyOgO+l
Tm87ZjyUKhiWP9ufoM2N818LTsjnFm2cHGnMEDkW7zt7VP0Rs01xqkUe5vMzx66B
GGFW/lAtAtq91FnSXCH4WEyF33pr/SKATpEjxwq5pOAsTfFBAIGozjD9Y+pY6ydK
BPGzkZbaYLG4cXJdUV9CF63jWy3D0M7o3FNCzTYQaVPVZ2uCwTU3nBHtyG1tmT5h
QfKgOXsIx6M7Cs97phnmBx1xiQlTpH47oucak85kudbj1CxaC2XIbUEZ0epacD5W
Uum6xQZbXRNRME/+vVzcItLj0t4vZ9vIKWQJ7Hg06xWBMEOZBA6gWwt906BQzv5I
XWyWRYwaTgYM0zIlU2voyQYuPLvoLgr4NPqfpx1dZPv1/CIcY7hU/HqZmwTly0BZ
c/iKwnVHUW4qQg6bSwiq37AzjWJLsutNT6pS+rKrA5X+1ZWzH4KNT5KQUTEsTHtD
5grShIsjwoE=
=SShS
-----END PGP SIGNATURE-----

--=-iRPf7VBMQwTUe3FIl8dG--
