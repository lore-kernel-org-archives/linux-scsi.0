From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Mon, 21 Apr 2003 16:45:31 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030421164531.F12581@one-eyed-alien.net>
References: <20030323230438.E24668@one-eyed-alien.net> <1048519237.1982.16.camel@mulgrave> <20030324093028.A1066@one-eyed-alien.net> <1049556643.1762.16.camel@mulgrave> <20030420143351.C20891@one-eyed-alien.net> <1050942530.1772.12.camel@mulgrave> <20030421100102.A12581@one-eyed-alien.net> <1050953018.2269.140.camel@mulgrave> <20030421123541.C12581@one-eyed-alien.net> <20030421142805.A31533@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="tmoQ0UElFV5VgXgH"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:58118 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S262703AbTDUXdm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Apr 2003 19:33:42 -0400
Content-Disposition: inline
In-Reply-To: <20030421142805.A31533@beaverton.ibm.com>; from patmans@us.ibm.com on Mon, Apr 21, 2003 at 02:28:05PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linus Torvalds <torvalds@transmeta.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>


--tmoQ0UElFV5VgXgH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 21, 2003 at 02:28:05PM -0700, Patrick Mansfield wrote:
> Matthew -
>=20
> On Mon, Apr 21, 2003 at 12:35:41PM -0700, Matthew Dharm wrote:
>=20
> > Then can we have it the way I proposed?   I have tested patches that use
> > this code as I proposed it waiting to be merged as soon as this is
> > accepted.
>=20
> I think it is OK, but as argued before: I was hoping to see attributes and
> code that can be used for all scsi_devices off a particular adapter/LLDD,
> or a specific scsi_device. Then we would not need separate attributes (or
> filters) for adapters/LLDD and for the scsi_devices (the current BFLAGS
> like code accessed via the scsi_dev_info_list; though being able to filter
> any command is certainly more powerful).

I think this is a nice idea, but you're talking about filtering at an
entirely different level from what I'm talking about.  I'm filtering at the
LLDD level, you want to filter in the mid-layer before the command gets out
the door to the LLDD.

> It would be very usefull to allow modification or addition of the filter
> via user land (or at boot/insmod time), eventually via sysfs.  Embedding
> the filter call in the queuecommand prevents such additions for arbitrary
> adapters (i.e. if the adapter does not call the filter, we can't add any
> filtering).

I can see how this would all be useful.  This, of course, assumes that you
can enumerate the device successfully (thus creating a device node) before
needing to tweak the flags, which is exactly NOT the case I'm dealing with.

I won't argue that such an implementation wouldn't be useful.  But it's a
_much_ bigger project than we're talking about here.  And, frankly, I think
it's a project for another day.

> And we would be better off avoiding only the cache page (mode sense page
> 0x8) without blocking all mode sense commands (I assume that is what
> you'll do when using the filter) - so we don't block other pages that
> might be used (via sg), and we don't block the mode sense commands used to
> used to figure out if the device is read only (sd.c sd_read_write_protect=
_flag,
> though I don't understand WTF the second page code 0 is supposed to
> return).

Actually, my plan is to block all MODE_SENSE for TYPE_DISK devices.  I'm
going to have some code that will not apply the filters (any filters) if
the request comes from sg, but that's down the line.  It turns out that a
very large number of USB devices of TYPE_DISK do _not_ support MODE_SENSE
in any form.  Apparently, the 'popular' OSes don't use it.

> > You may recall that my first approach was to set the BLIST flag for 36-=
byte
> > INQUIRY -- Linus shot that down in favor of a command-filter approach.
>=20
> I thought his main objection was using the per-adapter emulated bit to
> determine how to handle all scsi_devices on the adapter.

Yes, which led to a discussion of where and how the filtering should take
place, which led to SCSI core code for filtering which would be applied by
whoever/whatever wanted to.

I agree that some sort of super-flexible multi-layered filtering system
would be great.  It might even use some of the same filter calls that we're
talking about here -- but that's a project for another day.  For now, let's
solve the the problem which has been with us since 2.3.x and get a filter
framework that usb-storage can use into place.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

It's not that hard.  No matter what the problem is, tell the customer=20
to reinstall Windows.
					-- Nurse
User Friendly, 3/22/1998

--tmoQ0UElFV5VgXgH
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+pIKbIjReC7bSPZARAlrqAKCUdDjBafvV8bMeRoRMOPgrqXFmkACeJ+87
xo98bn+E7AjSoeBJ+jgmc2g=
=gb8Z
-----END PGP SIGNATURE-----

--tmoQ0UElFV5VgXgH--
