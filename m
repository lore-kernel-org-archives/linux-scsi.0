From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
Subject: Re: External USB3 disk fails with "Invalid field in cdb"
Date: Fri, 27 Jun 2014 19:55:03 +0200
Message-ID: <20140627195503.49e2dc55@wiggum>
References: <20140626205519.314a71ae@wiggum>
	<20140627101540.GB10042@localhost.localdomain>
	<20140627142223.48c5c18f@wiggum>
	<20140627173432.46ea93bd@marge>
	<1403884081.19382.7.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/.aMnfY+77OnM.BAaK1QGEoG"; protocol="application/pgp-signature"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:49683 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbaF0R4k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2014 13:56:40 -0400
In-Reply-To: <1403884081.19382.7.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Bryn M. Reeves" <bmr@redhat.com>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

--Sig_/.aMnfY+77OnM.BAaK1QGEoG
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 27 Jun 2014 08:48:01 -0700
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Fri, 2014-06-27 at 17:34 +0200, Michael B=C3=BCsch wrote:
> > I tried the following patch:
> >=20
> > Index: linux/drivers/scsi/sd.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux.orig/drivers/scsi/sd.c	2014-06-26 18:40:39.214696552 +0200
> > +++ linux/drivers/scsi/sd.c	2014-06-27 15:52:30.776159456 +0200
> > @@ -2440,7 +2440,7 @@ sd_read_cache_type(struct scsi_disk *sdk
> >  			sdkp->RCD =3D 0;
> >  		}
> > =20
> > -		sdkp->DPOFUA =3D (data.device_specific & 0x10) !=3D 0;
> > +		sdkp->DPOFUA =3D 0;
> >  		if (sdkp->DPOFUA && !sdkp->device->use_10_for_rw) {
> >  			sd_first_printk(KERN_NOTICE, sdkp,
> >  				  "Uses READ/WRITE(6), disabling FUA\n");
> > =20
> >=20
> > This obviously is not the correct thing to do, but it makes the disk us=
able:
> >=20
> > Jun 27 17:26:50 marge kernel: [  523.909815] usb 2-1: new SuperSpeed US=
B device number 2 using xhci_hcd
> > Jun 27 17:26:50 marge kernel: [  523.929246] usb 2-1: New USB device fo=
und, idVendor=3D152d, idProduct=3D0567
> > Jun 27 17:26:50 marge kernel: [  523.929258] usb 2-1: New USB device st=
rings: Mfr=3D1, Product=3D2, SerialNumber=3D3
> > Jun 27 17:26:50 marge kernel: [  523.929265] usb 2-1: Product: USB to A=
TA/ATAPI Bridge
> > Jun 27 17:26:50 marge kernel: [  523.929271] usb 2-1: Manufacturer: JMi=
cron
> > Jun 27 17:26:50 marge kernel: [  523.929276] usb 2-1: SerialNumber: xxx
> > Jun 27 17:26:50 marge kernel: [  523.930999] usb-storage 2-1:1.0: USB M=
ass Storage device detected
> > Jun 27 17:26:50 marge kernel: [  523.931237] scsi12 : usb-storage 2-1:1=
.0
> > Jun 27 17:26:51 marge kernel: [  524.930451] scsi 12:0:0:0: Direct-Acce=
ss     JMicron  Generic          0114 PQ: 0 ANSI: 6
> > Jun 27 17:26:51 marge kernel: [  524.931228] sd 12:0:0:0: Attached scsi=
 generic sg3 type 0
> > Jun 27 17:26:51 marge kernel: [  524.932964] sd 12:0:0:0: [sdd] Spinnin=
g up disk...
> > Jun 27 17:26:53 marge kernel: [  525.937848] ..ready
> > Jun 27 17:26:53 marge kernel: [  526.942395] sd 12:0:0:0: [sdd] 9767731=
68 512-byte logical blocks: (500 GB/465 GiB)
> > Jun 27 17:26:53 marge kernel: [  526.943037] sd 12:0:0:0: [sdd] Write P=
rotect is off
> > Jun 27 17:26:53 marge kernel: [  526.943048] sd 12:0:0:0: [sdd] Mode Se=
nse: 47 00 10 08
> > Jun 27 17:26:53 marge kernel: [  526.943662] sd 12:0:0:0: [sdd] Write c=
ache: enabled, read cache: enabled, doesn't support DPO or FUA
> > Jun 27 17:26:53 marge kernel: [  526.987919]  sdd: sdd1
> > Jun 27 17:26:53 marge kernel: [  526.990055] sd 12:0:0:0: [sdd] Attache=
d SCSI disk
> > Jun 27 17:27:29 marge kernel: [  563.227849] EXT4-fs (sdd1): warning: m=
ounting fs with errors, running e2fsck is recommended
> > Jun 27 17:27:29 marge kernel: [  563.228043] EXT4-fs (sdd1): mounted fi=
lesystem with ordered data mode. Opts: (null)
> >=20
> > (This is on another machine, but it shows the same behavior without the=
 patch.)
> >=20
> > Does somebody have a hint for a real fix?
>=20
> I suspect the problem is in the USB bridge: The device reports FUA
> support in its initial IDENTIFY, which gets translated to the correct
> mode page bits, but when we send a READ/WRITE with the FUA bit set, the
> bridge doesn't know how to translate it and gives us the error.  There's
> probably some way in USB to blacklist the bridge, but we need to
> understand the consequences of the blacklist: The device is claiming a
> writeback cache which means if it won't do either FUA or SYNC CACHE,
> there's going to be a data integrity failure.
>=20
> The fact that your initial hack works suggests that sync cache is
> accepted by it, so we probably just need a USB blacklist fixing the FUA
> problem.
=20

[Added USB lists to Cc]


--=20
Michael

--Sig_/.aMnfY+77OnM.BAaK1QGEoG
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTra/7AAoJEPUyvh2QjYsOTuYP/j4wB226JBX4+/94ASiICnd1
NJup7Ivc+s1pVrGu0ClWb3RRMNLbIGPaqJQBB4DwWB2RAA5An0GDyL9W1MVh2qm5
6tdNcQ8aQuqXlZWj9FRPrpWgu8eInqgIahyaUP7+5C643r70N6mL/vyx1Osytvf6
YFRZRKhRdPE6Oy1Mct8vkyMZiO01ec8W98yrjtTD0yEazZi4SLNnR4b3WWKj4e6o
TXsV1J8pyPYvzGrS6n6AHZvhh69Ry+hGppJDzc7qi0V1ChZeisJtJNLLz1kbXuVm
b6HhsQJ+n1A+RYerW3s2myUEl4uDZcqeM/gFjElc32q9pwMHcPqAk7O0g41Harf7
0pj5sqX0owhnWsABPKRZ4IwezQSnRwysnDEfJS7yihN3c+lCvA5ywLs7E4J3htTk
nTG75SwDxSnDsiP62puppsh8Ux4gI9++lv0L1xZ/rKTb1AvnIf5COermmW3PiwRe
U6OI3KMkFxmS/DSJvvUhjiiGV/bXMqxDMyMFBt5G+7vHY0dpLhvH5fV0rc++j8pm
a4wnE8H2/BAR2IzeUG7Wa/RhyqQL7kOO4GboLZLFsn9fciMz7LY5tV0FBks9K4YZ
359dvlNJP5uyV/aN3I4IbL0iZ+GH5B3ZwoMUdVKKsOuvlcFLDrr4576LaaA055ta
zgtaJ5D9Ajmvt8RFqHYt
=4HL/
-----END PGP SIGNATURE-----

--Sig_/.aMnfY+77OnM.BAaK1QGEoG--
