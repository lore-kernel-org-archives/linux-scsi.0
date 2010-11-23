From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
Subject: Re: [PATCH repost 3] [SCSI] Retrieve the Caching mode page
Date: Mon, 22 Nov 2010 21:00:48 -0800
Message-ID: <20101123050048.GL20296@one-eyed-alien.net>
References: <AANLkTi=7tW6wqrk8ZkFuTYwmS-wZ4nQ+jkxk8U95H42F@mail.gmail.com> <538170.68988.qm@web31803.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qo7zVO9a9OQ5oQtr"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <538170.68988.qm@web31803.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>, James Bottomley <James.Bottomley@suse.de>
List-Id: linux-scsi@vger.kernel.org


--qo7zVO9a9OQ5oQtr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 22, 2010 at 12:02:26PM -0800, Luben Tuikov wrote:
> --- On Mon, 11/22/10, Linus Torvalds <torvalds@linux-foundation.org>
> wrote:
> > So I don't mind the patch per se, but I think it's potentially way more
> > dangerous than it looks.
>=20
> This patch does not ask for pages that Windows doesn't ask for. The sd
> driver already asks for all pages (page code 0x3F) and then checks if the
> device is write protected. Here is the present code:
>=20
>   2217                  sd_read_write_protect_flag(sdkp, buffer); 2218
>   sd_read_cache_type(sdkp, buffer); 2219
>   sd_read_app_tag_own(sdkp, buffer);
>=20
> Line 2217 asks for page code 0x3F, meaning all mode pages.  Line 2218
> asks for the Caching mode page or not at all if the device flags forbid
> it (all USB storage devices in the Linux kernel).
>=20
> This patch adds processing of the data returned when all mode pages are
> asked for (0x3F) in the function on line 2218. It then parses the data to
> find out if the Caching mode page is present.

As long as you are not changing the command stream that the devices see, I
think this is a reasonable risk to take.

What are the consequences if the device returns what appear to be a Caching
Mode Page, but it is actually filled with garbage or otherwise inaccurate
data?

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

You suck Stef.
					-- Greg=20
User Friendly, 11/29/97

--qo7zVO9a9OQ5oQtr
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFM60qA3gL8qCooyc4RAvjXAJ0Q/1XXXgQnEKftIH230FA1kAcHEQCeNMHx
LGoOvKb0liPwoEBJPy+zoYE=
=E1Yj
-----END PGP SIGNATURE-----

--qo7zVO9a9OQ5oQtr--
