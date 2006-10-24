From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: Fw: garbled usb storage scsi vendor & model
	in 2.6.19-rc1
Date: Tue, 24 Oct 2006 16:18:16 -0700
Message-ID: <20061024231816.GD9511@one-eyed-alien.net>
References: <Pine.LNX.4.44L0.0610241557500.6203-100000@iolanthe.rowland.org>
	<453E88FA.3070304@ipom.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1851247765=="
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
In-Reply-To: <453E88FA.3070304@ipom.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-devel-bounces@lists.sourceforge.net
Errors-To: linux-usb-devel-bounces@lists.sourceforge.net
To: Phil Dibowitz <phil@ipom.com>
Cc: Andrew Morton <akpm@osdl.org>, Meelis Roos <mroos@linux.ee>, Alan Stern <stern@rowland.harvard.edu>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


--===============1851247765==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bjuZg6miEcdLYP6q"
Content-Disposition: inline


--bjuZg6miEcdLYP6q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 24, 2006 at 02:43:22PM -0700, Phil Dibowitz wrote:
> Alan Stern wrote:
> > There's a comment about this in the source code, asking what should be
> > done if the INQUIRY response is too short (as it is here).  Maybe the b=
est
> > approach would be always to assume the first 36 bytes are valid, even w=
hen
> > the device says they aren't.  It ought to solve your problem, and it's
> > no worse than what we're doing now.
> >=20
> > The patch is below.  This replaces the patch I sent earlier.
>=20
> Perhaps a better approach might be to set the product and vendor to some
> specific string if the device says it isn't providing one? In the new mod=
el,
> can't we still have the chance of showing garbage if the device really is=
n't
> setting anything useful? So what if we show "Unknown" and "Unknown" or
> something similar in the event that the device sets the 'invalid' bit?

US_FL_FIX_INQUIRY used to do this; I don't remember what it does currently.

Regardless, the SCSI core should probably blank those data buffers before
deciding if any data is going to be copied into them.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

C:  Like the Furby?
DP: He gives me the creeps.  Think the SPCA will take him?
					-- Cobb and Dust Puppy
User Friendly, 1/2/1999

--bjuZg6miEcdLYP6q
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFFPp84HL9iwnUZqnkRAiKsAKCuSHcv22UvL7qKKpi8GjKrCygO9ACeKKhL
C464lxSHSM8dFPJfckmR6+I=
=+nA3
-----END PGP SIGNATURE-----

--bjuZg6miEcdLYP6q--


--===============1851247765==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-------------------------------------------------------------------------
Using Tomcat but need to do more? Need to support web services, security?
Get stuff done quickly with pre-integrated technology to make your job easier
Download IBM WebSphere Application Server v.1.0.1 based on Apache Geronimo
http://sel.as-us.falkag.net/sel?cmd=lnk&kid=120709&bid=263057&dat=121642
--===============1851247765==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel

--===============1851247765==--
