From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [PATCH resend 1/4] scsi/sr: add no_read_disc_info scsi_device flag
Date: Tue, 3 Aug 2010 15:42:07 -0700
Message-ID: <20100803224207.GA8682@one-eyed-alien.net>
References: <4C573BFD.8090407@redhat.com> <Pine.LNX.4.44L0.1008031012160.1853-100000@iolanthe.rowland.org> <20100803163730.GA31000@one-eyed-alien.net> <1280854113.11045.37.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:40801
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757073Ab0HCWnI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Aug 2010 18:43:08 -0400
Content-Disposition: inline
In-Reply-To: <1280854113.11045.37.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, Hans de Goede <hdegoede@redhat.com>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 03, 2010 at 11:48:33AM -0500, James Bottomley wrote:
> This is two devices, both identified by their usb (not SCSI) strings.
> The problem is they crash rather than returning illegal command on two
> specific SCSI commands.  I don't see the problem in having the USB
> command filter in usb_stor_control_thread returning this on their
> behalf.  SCSI will do the right thing and it's a lot less fragile.

I'm willing to bet there are more devices out there like this.  Experience
has shown that the more we make the stack issue commands to the device like
one of the "popular" OSes, the fewer problems we have.  Thus, I prefer to
fix these where commands originate.

Also, every time I've tried to take the "filtering" approach in the past,
I've been burned 6-10 months later by a change in the SCSI stack which
brings these sorts of bugs back.  I really prefer these things to stay
fixed.

You have to admit, there is something ill-conceived about a driver which is
basically an HBA trying to second-guess code which actually generates the
commands in the first place.  If we can generate the command stream
"better" (i.e. more compatible with a wider variety of devices), then
everyone benefits.

> It will also prevent the user space tools ... which no amount of SCSI
> init changes can fix ... from crashing the devices.

Granted, this is true.  That said, user-space crashes have very rarely been
an issue in the past.  It does happen, but almost never due to this sort of
thing -- in those cases, the device chokes on something relatively subtle
about the command, which usb-storage would have a very very difficult time
filtering on.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

DP: And judging from the scores, Stef has the sma... =20
T:  LET'S NOT GO THERE!
					-- Dust Puppy and Tanya
User Friendly, 12/11/1997

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFMWJs/3gL8qCooyc4RAqlQAJ9KKIPjQHuVhiByABvGUaFd+JeG5QCbB0l4
Uf2fKXRUoKHQb+SXzz7hKAM=
=w+//
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
