From: Ryan Anderson <ryan@autoweb.net>
Subject: Re: Fw: [Bugme-new] [Bug 3651] New: dell poweredge 4600 aacraid
	PERC 3/Di Container goes offline
Date: Tue, 09 Nov 2004 15:22:54 -0500
Message-ID: <1100031774.24635.157.camel@ryan2.internal.autoweb.net>
References: <20041028005302.753a2d52.akpm@osdl.org>
	 <418138B6.2010104@brutsche.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-D0gsKGusi1Fj82e27u4b"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.autoweb.net ([198.172.237.26]:37902 "EHLO mail.autoweb.net")
	by vger.kernel.org with ESMTP id S261633AbUKIUW6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2004 15:22:58 -0500
In-Reply-To: <418138B6.2010104@brutsche.us>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Phil Brutsche <phil@brutsche.us>
Cc: linux-scsi@vger.kernel.org


--=-D0gsKGusi1Fj82e27u4b
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2004-10-28 at 14:21, Phil Brutsche wrote:
> Andrew Morton wrote:
> > Distribution: Debian Sarge
> > Hardware Environment: Dell Poweredge 4600, 5 Disks each 146GB in a Raid=
 5 in=20
> > one container, 8 GB RAM, Dual Xenon 2GHz. The Perc 3/Di Controller is o=
n=20
> > Firmware version 2.80 Build 6092
> > Software Environment: aacraid

I have a Dell 2650, 3 disks, RAID 5, 72GB drives (Fujitsu drives)
4 GB Ram, dual 2.4GHz Xeon

dmesg tells me I have this specific firmware:
AAC0: kernel 2.8.4 build 6092
AAC0: monitor 2.8.4 build 6092
AAC0: bios 2.8.0 build 6092
AAC0: serial 83ac41d3fafaf001
scsi0 : percraid
  Vendor: DELL      Model: PERCRAID RAID5    Rev: V1.0
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: DELL      Model: PERCRAID RAID5    Rev: V1.0
  Type:   Direct-Access                      ANSI SCSI revision: 02


Currently I have 2.6.8 on this machine.  (I believe it's actually
2.6.8.1, Debian sometimes blurs things a little bit in terms of
backporting a patch.)

> > Problem Description:=20
> > The Container on the PERC 3/Di Controller goes offline on heavy I/O Loa=
d with=20
> > the following error message:
> >=20
> > SCSI:0 (0:0): rejecting I/O to offline device
> > Buffer I/O error due to I/O error on sda8

That's what I'm seeing.  It's rather hard to capture because the only
disks on this machine are in the RAID container that keeps going
offline.

> > Steps to reproduce:
> >=20
> > I am using bonnie++ to produce I/O load on the only Volume on the Perc =
3/Di=20
> > Controller with the following parameters bonnie++ -d /var/lib/postgres/=
test -s=20
> > 16000 -n 150 -r 8000 -u nobody:nogroup
>=20
> FYI, I have been seeing this as well.
>=20
> I can trigger this card lockup at will with mkfs.ext3; for other
> filesystems, I may need to extract a kernel source .tar.gz in order to
> cause a lockup.
>=20
> aacraid: Host adapter reset request. SCSI hang ?
> aacraid: Host adapter appears dead
> Device offlined - not ready after error recovery: host 1 channel 0 id 0
> lun 0
> SCSI error : <1 0 0 0> return code =3D 0x6000000
> end_request: I/O error, dev sdb, sector 1667007
> Buffer I/O error on device sdb1, logical block 208368
> lost page write due to I/O error on sdb1
> scsi1 (0:0): rejecting I/O to offline device
> Buffer I/O error on device sdb1, logical block 208369
>=20
> I am using an Adaptec 2120S with a RAID5 of Seagate U320 drives - yes, I
> know about the Seagate firmware timeout problem, these drives are brand
> new with firmware rev 0006 and thus aren't affected.
>=20
> This hardware has no problems with kernel 2.4.x.

I had similar, but not nearly as bad, problems with 2.4.x.
Under 2.4.x, this machine would become unavailable for approximately 20
minutes, and then would recover.  The load would be around 20 when it
came back, and would rapidly drop off.

This was with 2.4.20, using a config modeled off the Debian 2.4.18-bf2.4
config.

Due to this problem, my machine is no longer a production machine, so I
can do whatever testing is necessary to fix this.

I have gone through the hardware diagnostics process with Dell, with the
exception of completing the Elite HD diagnostics on the Fujitsu drives.=20
(The program filled the boot floppy with the log, and I haven't gotten
around to rerunning it yet.)

I can debug and attempt to reproduce as much as is necessary at this
point, if anyone can give me a place to start and/or a patch to apply.


--=20

Ryan Anderson               =20
AutoWeb Communications, Inc.=20
email: ryan@autoweb.net=20

--=-D0gsKGusi1Fj82e27u4b
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBBkScevV/uNaz8d+gRAqWeAJ99+SNy9EjVmfvijHNL7dY7i0HZ9ACdE2u+
JH4MVizrbYlB9UTV9Ks1kRk=
=mJ/B
-----END PGP SIGNATURE-----

--=-D0gsKGusi1Fj82e27u4b--
