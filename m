From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: Fusion-MPT with 53C1030 and no flash?
Date: Sat, 9 Oct 2004 17:12:09 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041010001209.GA8117@one-eyed-alien.net>
References: <BBB2B829DCAA204D9BA39DAE37CD05A1630FEF@mail01.midstream.com> <000c01c4adb3$19aac630$1a1015ac@ericmoore>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from multivac.one-eyed-alien.net ([64.169.228.101]:48553 "EHLO
	multivac.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S267765AbUJJAMU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 9 Oct 2004 20:12:20 -0400
Content-Disposition: inline
In-Reply-To: <000c01c4adb3$19aac630$1a1015ac@ericmoore>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <emoore@lsil.com>
Cc: Brian Eng <brian@midstream.com>, Linux SCSI list <linux-scsi@vger.kernel.org>


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 08, 2004 at 09:50:20PM -0600, Moore, Eric Dean wrote:
> On Friday, October 08, 2004 12:57 PM, Matthew Dharm wrote:
>=20
> > Has anyone ever used an LSI 53C1030 chip WITHOUT attached flash?
>=20
> Yes this works. In embedded environment w/o flash, the firmware is
> packaged with the system bios, and downloaded to the part via the 1030
> option rom.

That's assuming we have an x86-like BIOS..... as least, given the files
I've seen on the LSI web page which are all x86-oriented.  I'm working on a
PPC64 embedded target where by loader/boot code won't (for various reasons
which are not all technical) touch this chip.

> > As I read the technical docs, it's possible... but it requires a driver
> > which can download the firmware to the ARM processor.  It looks like the
> > current 2.6.x driver can't do that.
>=20
> Look at mpt_downloadboot in mptbase.c
> http://lxr.linux.no/source/drivers/message/fusion/mptbase.c?v=3D2.6.8.1

Did that already.  The references to mpt_downloadboot are:
	1) in the disable routine
	2) the hard reset routine

If this is called by some code path I don't immediately see (and I'll admit
that's a very real possibility), mpt_downloadboot wants the firmware in the
ioc->cached_fw pointer.

I don't see a way to get it there except by downloading it from a running
adaptor (before doing a reset, I presume).

> > In fact, I can't seem to locate a suitable firmware image anywhere...
> >
>=20
> http://www.lsilogic.com/downloads/selectDownload.do
> Step 1: Storage Adapters
> Step 2: Ultra 320 Host Bus Adapters
> Step 3: LSI 22320-R

I've also been to this page before.  The driver download doesn't seem to
contain the firmware, either.

The BIOS/Firmware download contains a couple of binaries, but no
information on how to use them except with the DOS tool to program them
into an option ROM.

Without information on the firmware file map, at the least, I don't see how
that binary is useful.  Heck, that firmware image might not even be useable
if loaded directly into the part's internal RAM.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

E:  You run this ship with Windows?!  YOU IDIOT!
L:  Give me a break, it came bundled with the computer!
					-- ESR and Lan Solaris
User Friendly, 12/8/1998

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFBaH5ZIjReC7bSPZARAqgCAKCEf1Q6l8OAbyQsoHP+VwjjRk5NwwCghuAQ
vLRMozkN2FbwUV5/IKkOpVI=
=NM3C
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
