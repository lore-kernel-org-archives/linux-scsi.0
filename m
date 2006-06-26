From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: Asynchronous scsi scanning, version 9
Date: Mon, 26 Jun 2006 07:44:42 -0700
Message-ID: <20060626144442.GA13319@one-eyed-alien.net>
References: <20060529031915.GB23405@parisc-linux.org>
	<447AB2F5.2000700@s5r6.in-berlin.de>
	<20060529130515.GE23405@parisc-linux.org>
	<20060531232139.GA3202@us.ibm.com> <447EE81D.2050906@ums.usu.ru>
	<20060601132315.GD32143@parisc-linux.org>
	<1151270127.3617.26.camel@mulgrave.il.steeleye.com>
	<20060625224631.GD1608@parisc-linux.org>
	<1151310285.3185.16.camel@laptopd505.fenrus.org>
	<20060626124001.GG1608@parisc-linux.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0076182148=="
Return-path: <linux-hotplug-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20060626124001.GG1608@parisc-linux.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-hotplug-devel>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-hotplug-devel-bounces@lists.sourceforge.net
Errors-To: linux-hotplug-devel-bounces@lists.sourceforge.net
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Patrick Mansfield <patmans@us.ibm.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, "Alexander E. Patrakov" <patrakov@ums.usu.ru>, Arjan van de Ven <arjan@infradead.org>
List-Id: linux-scsi@vger.kernel.org


--===============0076182148==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 26, 2006 at 06:40:01AM -0600, Matthew Wilcox wrote:
> I'm not 100% sure what the problem is with USB.  If it's that we may not
> have discovered all the USB devices currently plugged in, then I think
> we need to change the way USB works to use one Scsi_Host for all USB
> storage devices, and then make each device either its own target or its
> own channel (probably the former; the latter is less well-tested code).

There are a couple of things which make this difficult for USB.

First, some (many?) USB devices need to be left alone for several seconds
after attachment in order to allow them to initialize to the point where
they are usable.

Second, depending on how many hubs are between the host and target, the
time-to-discover the device is highly variable.

Third, once discovered the device may still take a long time to be "ready".
Think of this as a slow spin-up time.  This is different from my first
point in that the device can actually accept commands, but all commands
will fail with some sort of not-ready type error.

As for using one Scsi_Host... there are several usb-storage devices which
attach to an entire SCSI bus (not just a single target), so can't make each
device it's own target.  Also, at the time this was all written it wasn't
possible to dynamically remove (with any stability) individual targets or
channels.  Perhaps that has changed?

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

You suck Stef.
					-- Greg=20
User Friendly, 11/29/97

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFEn/LaHL9iwnUZqnkRAkOQAJ4zpVMYzAFf6kQfWcyxU//v6QMNKgCgl0/Y
8+Ox6L++ZbNQc1vU+t7Cb10=
=M0vO
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--


--===============0076182148==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Using Tomcat but need to do more? Need to support web services, security?
Get stuff done quickly with pre-integrated technology to make your job easier
Download IBM WebSphere Application Server v.1.0.1 based on Apache Geronimo
http://sel.as-us.falkag.net/sel?cmd=lnk&kid=120709&bid=263057&dat=121642

--===============0076182148==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-hotplug-devel mailing list  http://linux-hotplug.sourceforge.net
Linux-hotplug-devel@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel

--===============0076182148==--
