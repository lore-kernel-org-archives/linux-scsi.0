From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: Thu, 24 Apr 2003 13:59:32 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030424135932.D10511@one-eyed-alien.net>
References: <UTC200304241859.h3OIxjh16776.aeb@smtp.cwi.nl> <20030424121409.C10511@one-eyed-alien.net> <1051215651.1754.71.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="EY/WZ/HvNxOox07X"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:63241 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S263938AbTDXUrb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Apr 2003 16:47:31 -0400
Content-Disposition: inline
In-Reply-To: <1051215651.1754.71.camel@mulgrave>; from James.Bottomley@SteelEye.com on Thu, Apr 24, 2003 at 04:20:50PM -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andries.Brouwer@cwi.nl, afafc@rnl.ist.utl.pt, Alan Cox <alan@lxorguk.ukuu.org.uk>, greg@kroah.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net, mike@hingston.demon.co.uk, stelian@popies.net, torvalds@transmeta.com


--EY/WZ/HvNxOox07X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 24, 2003 at 04:20:50PM -0400, James Bottomley wrote:
> > And, as for the need for filtering, I know we have such a need.  I have
> > several devices on my desk which choke at INQUIRY EVPD -- so right now I
> > filter it in the usb-storage driver.  I also have devices that report b=
ogus
> > INQUIRY data lengths, but (luckily) the sanity checks in the INQUIRY
> > probing code generally catch those cases and save us.
>=20
> I think the evpd code can be thrown out into user land (where the rules
> governing how it's used can be much more flexible).  All we really use
> it for is to get a unique name.  However, even WWN inquiries don't
> always guarantee even that...

Well, I'd love to see a patch to do that.  But I seem to recall someone
being opposed to that idea.... maybe I'm just imagining that.

> > I've seen devices that choke on START_STOP, unless that START_STOP is an
> > eject command.  I fixed this by eliminating the only non-eject use of
> > START_STOP in sd.c -- but how long is it before someone decides they ne=
ed
> > to use START_STOP for something?
>=20
> sd.c uses START_STOP to spin up an inactive disc (but only if we get a
> check condition/NOT READY). sr_ioctl.c uses it to eject or close a cd
> tray.

sd.c used to send START_STOP to check for inactive disk... I changed that
to use TUR instead.

Tho, the point of my comment is really that people keep changing the SCSI
layer, and it keeps having significant and far-reaching effects, and
without command filtering I'm at their mercy.

But it looks like I've lost that battle.

> > We may have fixed MODE_SENSE, but what about the other cases?
>=20
> I think we just have to identify them and tackle them in the same way.
>=20
> Do you have any other current bug reports you'd like to share with us?

Well, let's see....

(o) If the second INQUIRY during probing fails, the device is dropped on
the floor.
(o) INQUIRY for anything other than 36-bytes crashes some devices (tho they
are few, since the sanity checking code for length is in place -- the
failure mode here is a bit unusual)
(o) You already know about EVPD....
(o) MODE_SENSE for cache-type for TYPE_DISK crashes quite a few devices

I'm also still waiting for the patches to SCSI to support hot-unplugging,
which is being worked on (but the first version was rejected quite
soundly).

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

What, are you one of those Microsoft-bashing Linux freaks?
					-- Customer to Greg
User Friendly, 2/10/1999

--EY/WZ/HvNxOox07X
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+qFA0IjReC7bSPZARAnaNAJ9Hwa4yf1R36DChGaEMMWymRhJrWwCgvFab
cGArnR3t5omDkNF4pPTpGoM=
=pKVs
-----END PGP SIGNATURE-----

--EY/WZ/HvNxOox07X--
