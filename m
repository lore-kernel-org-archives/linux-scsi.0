From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [RFC] add transfer request length?
Date: Thu, 30 May 2002 11:21:10 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020530112110.E32763@one-eyed-alien.net>
References: <20020529230047.D26782@one-eyed-alien.net> <20020530110835.A16069@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="vmttodhTwj0NAgWp"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020530110835.A16069@eng2.beaverton.ibm.com>; from patmans@us.ibm.com on Thu, May 30, 2002 at 11:08:35AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>


--vmttodhTwj0NAgWp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm refering to the 'ask for 36 with buffer of 256' case.  Given that
buffer sizes are tied to page sizes, and that it's not just the mid-layer
we're talking about here, it makes sense to me to just add the requested
transfer length.

That is, unless we expect something else to keep track of 'actual buffer
length' vs. 'reported buffer length'.  But it seems to me that it would be
useful to know both values at the HBA level.

Matt

On Thu, May 30, 2002 at 11:08:35AM -0700, Patrick Mansfield wrote:
> On Wed, May 29, 2002 at 11:00:48PM -0700, Matthew Dharm wrote:
>=20
> > Right now, a low-level SCSI driver (i.e. HBA) can't actually tell in
> > advance how much data will be moved by a command.  The driver can see t=
he
> > buffer and the buffer length, and can enforce that the transfer length =
does
> > not exceed that buffer length, but we can't actually algorithmically
> > determine the amount of data we expect to move....
> >=20
> > For example, imagine an INQUIRY for 36 bytes issued with a buffer for 2=
56
> > bytes.  This actually does happen.
>=20
> You mean the mid-layer asks for 256 bytes (buffer length and cmd are
> 256), but the device returns less than 256 bytes? If so, I don't see
> how setting another field helps.
>=20
> Or, the mid-layer asks for 36, and buffer length is 256? If so, we should
> change the code.
>=20
> -- Patrick Mansfield
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

S:  Another stupid question?
G:  There's no such thing as a stupid question, only stupid people.
					-- Stef and Greg
User Friendly, 7/15/1998

--vmttodhTwj0NAgWp
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE89m2WIjReC7bSPZARAhjFAJ9/T1vlENdVXsXOEBhtFFm6VAskGQCeN8xX
wFc2uwX7KuPkkoc4WLjkjs4=
=UYN4
-----END PGP SIGNATURE-----

--vmttodhTwj0NAgWp--
