From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Mon, 21 Apr 2003 16:37:09 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030421163709.D12581@one-eyed-alien.net>
References: <20030323230438.E24668@one-eyed-alien.net> <1048519237.1982.16.camel@mulgrave> <20030324093028.A1066@one-eyed-alien.net> <1049556643.1762.16.camel@mulgrave> <20030420143351.C20891@one-eyed-alien.net> <1050942530.1772.12.camel@mulgrave> <20030421100102.A12581@one-eyed-alien.net> <1050953018.2269.140.camel@mulgrave> <20030421123541.C12581@one-eyed-alien.net> <1050960465.1772.168.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="7DO5AaGCk89r4vaK"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:37638 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S262682AbTDUXZU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Apr 2003 19:25:20 -0400
Content-Disposition: inline
In-Reply-To: <1050960465.1772.168.camel@mulgrave>; from James.Bottomley@SteelEye.com on Mon, Apr 21, 2003 at 04:27:42PM -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linus Torvalds <torvalds@transmeta.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>


--7DO5AaGCk89r4vaK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

James, I think we're misunderstanding each other here... I am in no way
advocating the removal of the BLIST_INQUIRY flag.

We've been through several variants of INQUIRY in the scanning code.
Nothing seems to make everyone happy.  My primary concern is that the SCSI
layer will send commands (a long INQUIRY being one of them) which will
crash the firmware of many devices.

All I want is a way to easily filter out those commands which devices on my
bus are likely (very likely) to choke over.  It's not just INQUIRY we're
talking about.

BLIST_INQUIRY serves some sort of alternate purpose.  It's never been
exactly clear to me what that is, but it seems to be related to firmware on
'real' SCSI devices being borked.

Besides, even if you fix this for INQUIRY, then we have to worry about
EVPD, MODE_SENSE for WP, 6-byte commands in general, etc. etc. etc.

Don't bother touching the flags.  Let's just settle on a filter
implementation.

Matt

On Mon, Apr 21, 2003 at 04:27:42PM -0500, James Bottomley wrote:
> On Mon, 2003-04-21 at 14:35, Matthew Dharm wrote:
> > I think takers may be waiting in the wings to see this code merged.
> > Honestly, tho, I don't think I can send you such strings.  I work pretty
> > closely with some vendors, so most of the devices in my possession have
> > 'fixed' firmware (to report meaningful INQUIRY length).  However, I get
> > report after report of devices that blow this in new and creative ways =
from
> > end-users.
> >=20
> > You may recall that my first approach was to set the BLIST flag for 36-=
byte
> > INQUIRY -- Linus shot that down in favor of a command-filter approach.
>=20
> You mean we can junk the BLIST_INQUIRY flags?  Does the 58 byte inquiry
> serve any purpose then (i.e. do you have a device that lies about its
> inquiry length but can return 58 bytes?).  The 58 bytes is useful
> because SPI fields lie in the 57th byte (information for the higher
> ultra speeds), but on the other hand those bits are only defined for a
> parallel bus.
>=20
> If I junk the flags, we'll send a 36 byte inquiry and then one sized
> from the inquiry return (unless we have to do an intermediate 58 byte
> one) and let you filter them.  Does that sound OK?
>=20
> James
>=20

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

You were using cheat codes too.  You guys suck.
					-- Greg to General Studebaker
User Friendly, 12/16/1997

--7DO5AaGCk89r4vaK
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+pIClIjReC7bSPZARAlkcAJ0XdlfBJhUWNBpKJXcz2gWUXFcB0gCgiJJl
tqc+dcFKgj0vpXGDWxwqjJ4=
=Jop/
-----END PGP SIGNATURE-----

--7DO5AaGCk89r4vaK--
