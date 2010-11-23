From: Matthew Dharm <mdharm-kernel-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>
Subject: Re: [PATCH repost 3] [SCSI] Retrieve the Caching mode page
Date: Tue, 23 Nov 2010 06:30:26 -0800
Message-ID: <20101123143026.GM20296@one-eyed-alien.net>
References: <20101123050048.GL20296@one-eyed-alien.net> <589506.10541.qm@web31809.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5V5c01chtBAiSHoy"
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <589506.10541.qm-R7kMla0nNtOvuULXzWHTWIglqE1Y4D90QQ4Iyu8u01E@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Luben Tuikov <ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


--5V5c01chtBAiSHoy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 23, 2010 at 01:25:23AM -0800, Luben Tuikov wrote:
> --- On Mon, 11/22/10, Matthew Dharm <mdharm-kernel-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>
> wrote:
>=20
> > What are the consequences if the device returns what appear to be a
> > Caching Mode Page, but it is actually filled with garbage or otherwise
> > inaccurate data?
>=20
> Data corruption would be no different than when determining whether the
> media is write protected or determining other parameters. A similar
> question would be "What would the consequences be if the device
> misreported the media write-protect bit?" I suppose such a device would
> be quite broken and inoperative.

Not really.  In your example case of the write-protect bit, either the
device would be improperly marked as write-protected when it is not, or we
would improperly send write commands to a protected device.  Neither is a
great tradgedy; commands will fail, errors will be generated, and life will
go on.

However, I don't know what is in the Caching Mode Page.  I don't know how
those bits are used to determine the behavior of the rest of the kernel.
Maybe one of those bits means "only store data in Japanese" or something
equally disturbing.

The old code used to make a "safe" default choice if the caching mode page
was not available (for whatever reason).   What are the implications of not
making the "safe" choice improperly (due to mode page corruption)?

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I need a computer?
					-- Customer
User Friendly, 2/19/1998

--5V5c01chtBAiSHoy
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFM69AC3gL8qCooyc4RAopkAJ9zVEO1kytH7HAIgGI0Q61R4zkmagCdFU64
90jNyG/WDU1bKDzyEVlmgNI=
=xraA
-----END PGP SIGNATURE-----

--5V5c01chtBAiSHoy--
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
