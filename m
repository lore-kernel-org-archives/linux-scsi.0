From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: PATCH; make sr.c respect use_10_for_ms
Date: Sat, 21 Jun 2003 17:30:34 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030621173033.J2811@one-eyed-alien.net>
References: <20030621171253.H2811@one-eyed-alien.net> <Pine.LNX.4.44.0306211716110.1980-100000@home.transmeta.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="x0KprKst+ZOYEj2z"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:26897 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S264862AbTFVAQa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Jun 2003 20:16:30 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0306211716110.1980-100000@home.transmeta.com>; from torvalds@transmeta.com on Sat, Jun 21, 2003 at 05:21:53PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>


--x0KprKst+ZOYEj2z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 21, 2003 at 05:21:53PM -0700, Linus Torvalds wrote:
> On Sat, 21 Jun 2003, Matthew Dharm wrote:
> > I mean, this works, it's not difficult to follow, and meets all the
> > operational goals.
>=20
> As far as I can tell, your patch is not actually all that stable.
>=20
> Imagine a flaky SCSI connection (think iscsi or whatever), where your
> commands are getting lost or corrupted. The first mode-sense command goes=
=20
> out, it takes a while to come back, another one goes out for some other=
=20
> reason (like scsi-generic), that other one failes due to something else,=
=20
> and look what happens: two bugs in one schenario:
>=20
>  - your code will clear "use_10_for_ms" even though the failure code=20
>    wasn't due to an unrecognized command, but due to something else=20
>    (timeout, out-of-memory, whatever)

True.  With this scenario and the old code, the code just makes an
assumption and goes on -- I did not aim to improve robustness, only
maintain it.  You can make the same argument about the existing code
falling back to the dumb-assumption condition under a transient error
condition.

So if this is a problem, then this entire section of code needed a rewrite
before I ever looked at it.  Until that rewrite occurs, I think my patch
adds value.

>  - when the other sense command comes back, it was sent with=20
>    "use_10_for_ms" active, but by the time the result comes back it has
>    been cleared, and now we'll use that flag to test what the sense data=
=20
>    means. So now we'll get the size wrong.

I don't see how a sense command sent from the scsi-generic interface will
affect (or be affected by) use_10_for_ms -- if scsi-generic issues the
command, this code path won't try to interpret the data at all.  Perhaps
I'm confused?

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

C:  Like the Furby?
DP: He gives me the creeps.  Think the SPCA will take him?
					-- Cobb and Dust Puppy
User Friendly, 1/2/1999

--x0KprKst+ZOYEj2z
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+9PipIjReC7bSPZARAsQuAJ9hv6s4CwjCIyxqlBPL6Cyc2ydnxACfU5kl
8h7A+8+1rxgIdwkaeLOhYyo=
=7g35
-----END PGP SIGNATURE-----

--x0KprKst+ZOYEj2z--
