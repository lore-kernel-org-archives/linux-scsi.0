From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
Subject: Re: [BUG] 2.6.24-git usb reset problems
Date: Tue, 29 Jan 2008 11:37:13 -0800
Message-ID: <20080129193713.GP14375@one-eyed-alien.net>
References: <20080128204935.GI15220@kernel.dk> <479F32E9.10609@panasas.com> <20080129141108.GV15220@kernel.dk> <200801291531.39825.oliver@neukum.org> <20080129143109.GW15220@kernel.dk> <20080129183910.GI15220@kernel.dk> <20080129191024.GO14375@one-eyed-alien.net> <20080129191504.GO15220@kernel.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NJSRbAqOy4NeGDns"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:37779
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753221AbYA2Tjq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jan 2008 14:39:46 -0500
Content-Disposition: inline
In-Reply-To: <20080129191504.GO15220@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Oliver Neukum <oliver@neukum.org>, Boaz Harrosh <bharrosh@panasas.com>, Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org


--NJSRbAqOy4NeGDns
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 29, 2008 at 08:15:04PM +0100, Jens Axboe wrote:
> On Tue, Jan 29 2008, Matthew Dharm wrote:
> > On Tue, Jan 29, 2008 at 07:39:11PM +0100, Jens Axboe wrote:
> > > On Tue, Jan 29 2008, Jens Axboe wrote:
> > > > On Tue, Jan 29 2008, Oliver Neukum wrote:
> > > > > Am Dienstag, 29. Januar 2008 15:11:08 schrieb Jens Axboe:
> > > > > > On Tue, Jan 29 2008, Boaz Harrosh wrote:
> > > > > > > On Tue, Jan 29 2008 at 15:54 +0200, Jens Axboe <jens.axboe@or=
acle.com> wrote:
> > > > > > > > On Tue, Jan 29 2008, Boaz Harrosh wrote:
> > > > > > > >> Greg KH wrote:
> > > > > =20
> > > > > > > > No difference, still just a lot of resets.
> > > > > > > >=20
> > > > > > > Where you able to figure out which usb storage transport is u=
sed?
> > > > > > >=20
> > > > > > > in drivers/usb/storage/usb.c you have get_protocol() and get_=
transport()
> > > > > > > functions. I'm not sure if these get stored in sysfs perhaps.=
 This will
> > > > > > > pinpoint better where to look. Let me research a bit.=20
> > > > > >=20
> > > > > > Did the quick'n easy and dumped it. Protocol is 'Transparent SC=
SI' and
> > > > > > transport is 'Bulk'
> > > > >=20
> > > > > You can recompile your kernel with CONFIG_USB_DEBUG and CONFIG_ST=
ORAGE_DEBUG
> > > > > That should tell the reason for the resets.
> > > >=20
> > > > Sure, I'll do that. Will post the results tonight.
> > >=20
> > > OK, fresh boot with CONFIG_USB_DEBUG and CONFIG_STORAGE_DEBUG. Plugged
> > > in the device, waited 10 seconds or so and pulled it out. These are t=
he
> > > messages.
> > >=20
> > > It all looks good until the MODE_SENSE command, where it only transfe=
rs
> > > 4 of 192 bytes.
> >=20
> > No, that's not the problem.  This is the problem:
>=20
> It's where the problem starts, otherwise there would not be a need to
> sense :-)

MODE_SENSE has nothing to do with it.  A short MODE_SENSE response is
perfectly valid, and the log shows it was handled correctly and subsequent
commands worked just fine.  It's not until the TUR fails that we get the
problem.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

P:  Nine more messages in admin.policy.
M: I know, I'm typing as fast as I can!
					-- Pitr and Mike
User Friendly, 11/27/97

--NJSRbAqOy4NeGDns
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHn4BpHL9iwnUZqnkRAjFhAJ0Zpe7ze1JAMgU+S5cNm3PM0eDCbACfWm4d
MV0Ppy6gr3ZNwXlv53gIkOg=
=CX+K
-----END PGP SIGNATURE-----

--NJSRbAqOy4NeGDns--
