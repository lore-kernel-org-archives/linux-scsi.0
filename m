From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Fri, 17 Jan 2003 10:54:14 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030117105414.E359@one-eyed-alien.net>
References: <10426732153816@kroah.com> <200301170043.36577.oliver@neukum.name> <20030117085047.GB2531@beaverton.ibm.com> <200301171155.36452.oliver@neukum.name>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="dFWYt1i2NyOo1oI9"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200301171155.36452.oliver@neukum.name>; from oliver@neukum.name on Fri, Jan 17, 2003 at 11:55:36AM +0100
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>
Cc: Mike Anderson <andmike@us.ibm.com>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>


--dFWYt1i2NyOo1oI9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 17, 2003 at 11:55:36AM +0100, Oliver Neukum wrote:
> That is simply wrong. Reporting somebody having pulled a plug must
> not fail. What are you supposed to do with an error here?
>=20
> There must be a way for a LLD to report that reliably.
> If the answer is, take that lock, call that function, error all pending
> requests, release that lock and call that function, it's OK.
>=20
> But it must work in all cases.

I absolutely agree.  The device is gone.  I can't do anything about it.
If the SCSI layer decides it can't let go, what am I supposed to do about
it?

In a separate discussion with Mike, he mentioned that you can't
scsi_remove_device() unless there are no pending commands.

How the hell is an LLD supposed to assure that!?!?

The minute I error a command and call scsi_done(), I can get a new one.
Unless I lock out requests with scsi_block_requests(), but that comes with
major warnings about needing to get unblocked.

The way this should work is that the LLD calls scsi_remove_device(), and
that cuts off the flow of commands.  The LLD can promise to error-out any
pending commands in the device command queue.

That is, unless scsi_block_requests() and scsi_unblock_requests() are more
useful than the documentation suggests... block(), error all commands,=20
unregister()... that would make some sense.  We could call
scsi_block_request() as soon as we know the unit is gone, and unregister()
as soon as the queue is empty.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

A:  The most ironic oxymoron wins ...
DP: "Microsoft Works"
A:  Uh, okay, you win.
					-- A.J. & Dust Puppy
User Friendly, 1/18/1998

--dFWYt1i2NyOo1oI9
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+KFFVIjReC7bSPZARAtpdAJ4x3B/64NkeM+GgEEUWidOC3Vg2jgCfYtZP
5JZVTq3XHLZ7QdDQ1JVNAxU=
=doLO
-----END PGP SIGNATURE-----

--dFWYt1i2NyOo1oI9--
