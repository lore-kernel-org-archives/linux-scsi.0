From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: writable mmc profiles actually are writable
Date: Tue, 7 Oct 2003 00:00:18 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031007000018.B11937@one-eyed-alien.net>
References: <20031006182223.GF972@suse.de> <20031006182510.GG972@suse.de> <1065469831.5185.44.camel@patehci2> <20031006203816.GJ972@suse.de> <1065473899.6835.41.camel@patehci2> <1065478448.2361.1.camel@patehci2> <1065484607.2899.7.camel@patehci2> <20031007053858.GL972@suse.de> <20031006234543.A11937@one-eyed-alien.net> <20031007064829.GQ972@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="rS8CxjVDS/+yyDmU"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:35848 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S261850AbTJGHAX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Oct 2003 03:00:23 -0400
Content-Disposition: inline
In-Reply-To: <20031007064829.GQ972@suse.de>; from axboe@suse.de on Tue, Oct 07, 2003 at 08:48:29AM +0200
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Pat LaVarre <p.lavarre@ieee.org>, linux-scsi@vger.kernel.org


--rS8CxjVDS/+yyDmU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 07, 2003 at 08:48:29AM +0200, Jens Axboe wrote:
> On Mon, Oct 06 2003, Matthew Dharm wrote:
> > On Tue, Oct 07, 2003 at 07:38:58AM +0200, Jens Axboe wrote:
> > > On Mon, Oct 06 2003, Pat LaVarre wrote:
> > > > Yep, still happy, same in -test6 as in -test5 e.g.
> > > >=20
> > > > $ dmesg | grep ^sr
> > > > sr0: scsi3-mmc drive: 125x/125x caddy
> > > > sr0: scsi3-mmc maybe not writeable
> > > > sr0: scsi3-mmc writable profile: 0x0002
> > > > $
> > > > $ grep MMC /proc/sys/dev/cdrom/info
> > > > Can write other MMC-RW: 1 ...
> > >=20
> > > I don't quite agree with this patch. Please add the GET_CONFIGURATION
> > > stuff to cdrom.c instead so it works with ide-cd as well (ide-scsi is
> > > basically dead, and the number of scsi drives out there isn't exactly
> > > big and increasing). GPCMD_GET_CONFIGURATION already exists. Also, ma=
ke
> > > DVD-RAM drives set CDC_MMC_RW as well and only check for that at open.
> >=20
> > While the number of SCSI CD-ROM drives may be shrinking, the ATAPI driv=
es
> > behind a USB/ATAPI bridge is skyrocketing.
>=20
> Doesn't change the picture, if you put it in cdrom.c it will work for
> both.

It will?  I'll have to take your word for that, as I don't immediately see
how that works... then again, much of the higher layers of SCSI are a
mystery to me.

I think I see how this work.... sr.c registers with cdrom.c, and cdrom.c
actually provides the interface to the /dev/scdN node, right?

If that's the case, why is there so much code in sr.c anyway?  The
get_capabilities() function really should be moved, as well as media-change
detection, much of the probe function (dealing with initialization of the
new structre), reading sector sizes, and sr_ioctl.c should probably be
renamed (as it doesn't really do IOCTL processing).

Am I on the right track?  That seems like an awfully long list of things
that suggest against my interpretation....

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

It was a new hope.
					-- Dust Puppy
User Friendly, 12/25/1998

--rS8CxjVDS/+yyDmU
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE/gmSCIjReC7bSPZARAolzAKCrs0z20C0VY7Fea+epvWSfpSuubwCfXKMt
RlcRiHs9SeIiZsNf27wJ88Y=
=LI7l
-----END PGP SIGNATURE-----

--rS8CxjVDS/+yyDmU--
