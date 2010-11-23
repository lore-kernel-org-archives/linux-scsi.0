From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [usb-storage] xhci: suspend/resume issues
Date: Mon, 22 Nov 2010 20:51:13 -0800
Message-ID: <20101123045113.GJ20296@one-eyed-alien.net>
References: <2DEEA3AB13739D45A22ADDB5086AEA0B914AD4@sshaexmb1.amd.com> <20101111191904.GK4823@redhat.com> <20101111210420.GA9020@xanatos> <20101116154756.GZ4823@redhat.com> <2DEEA3AB13739D45A22ADDB5086AEA0B9A6287@sshaexmb1.amd.com> <20101119185907.GA30923@xanatos> <20101119225602.GP18100@redhat.com> <20101119233046.GA13059@xanatos> <20101122224947.GD18100@redhat.com> <20101122231524.GA26888@xanatos>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="utPK4TBebyzZxMrE"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:40197
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751017Ab0KWEvc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Nov 2010 23:51:32 -0500
Content-Disposition: inline
In-Reply-To: <20101122231524.GA26888@xanatos>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Don Zickus <dzickus@redhat.com>, usb-storage@lists.one-eyed-alien.net, linux-usb@vger.kernel.org, "Xu, Andiry" <Andiry.Xu@amd.com>, linux-scsi@vger.kernel.org


--utPK4TBebyzZxMrE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 22, 2010 at 03:15:24PM -0800, Sarah Sharp wrote:
> Ccing the scsi and USB mass storage devices lists on this issue.
> Background: a USB 3.0 mass storage device shows up as a USB 2.0 device
> after resume, and then migrates back to USB 3.0 speeds after a reset.
>=20
> On Mon, Nov 22, 2010 at 05:49:47PM -0500, Don Zickus wrote:
> > Looking into my previously mounted /mnt directory yields an i/o error
> > (probably because it is now under /dev/sdc).
>=20
> As long as it doesn't produce any kernel oops, that's normal.  The
> kernel has noticed the device went away, but userspace hasn't.  At
> least, that's my general impression.  You'll have to ask the USB mass
> storage guys, or the SCSI folks for the details on how that's supposed
> to work.

That's mostly right.  The USB and SCSI layers know the device has gone
away, but there is no way to signal to the filesystem layers that the
underlying device is gone.  So, all the I/O requests are simply 'failed'
until the device is unmounted, at which point the refcount drops to zero
and the structures are actually deleted.

> > Unmounting everything and remounting 'mount /dev/sdc2 /mnt' (using the =
new
> > letter 'c' instead of 'b') works fine and no data loss seems to occur.
> >=20
> > Just thought it might be annoying and was wondering if you had any ideas
> > on that?
>=20
> There's no way to work around it if the device disconnects, AFAIK.

I'm coming late to the discussion, but Sara is right.  If the device
disconnects, there is no way to know that it is the same device when it
reconnects.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I could always suspend a few hundred accounts and watch what happens.
					-- Tanya
User Friendly, 7/31/1998

--utPK4TBebyzZxMrE
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFM60hB3gL8qCooyc4RAsPaAKCJsFOKHrHofntV7Jh6mhnzM1zL4ACfXcKM
qSbV4jzTR1+aB0BO8+3H1dQ=
=OzEf
-----END PGP SIGNATURE-----

--utPK4TBebyzZxMrE--
