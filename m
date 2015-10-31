From: Paul Menzel <paul.menzel@giantmonkey.de>
Subject: Re: NULL pointer dereference: IP: [<f828a00c>]
 sr_runtime_suspend+0xc/0x20 [sr_mod]
Date: Sat, 31 Oct 2015 10:39:10 +0100
Message-ID: <1446284350.4085.6.camel@giantmonkey.de>
References: <1444957547.1325.2.camel@giantmonkey.de>
	 <1444982077.2350.0.camel@giantmonkey.de>
	 <1445305159.2561.16.camel@decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-KQNz9ybger5UlMALsImV"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:35406 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbbJaJj1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 31 Oct 2015 05:39:27 -0400
Received: by wmll128 with SMTP id l128so27936383wml.0
        for <linux-scsi@vger.kernel.org>; Sat, 31 Oct 2015 02:39:26 -0700 (PDT)
In-Reply-To: <1445305159.2561.16.camel@decadent.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Cc: "James E. J. Bottomley" <JBottomley@odin.com>, AlanStern <stern@rowland.harvard.edu>, linux-scsi@vger.kernel.org, 801925@bugs.debian.org


--=-KQNz9ybger5UlMALsImV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Control: notfound -1 3.19-1~exp1
Control: found -1 4.2.5-1


Am Dienstag, den 20.10.2015, 02:39 +0100 schrieb Ben Hutchings:
> On Fri, 2015-10-16 at 09:54 +0200, Paul Menzel wrote:
> [...]
> > > BUG: unable to handle kernel NULL pointer dereference at 00000014
> > > IP: [] sr_runtime_suspend+0xc/0x20 [sr_mod]
> > > *pdpt =3D 000000003696e001 *pde =3D 000000000000000000
> > > Oops: 0000 [#1] SMB
> > > Modules linked in: sd_mod(+) sr_mod(+) cdrom ata_generic ohci_pci ahc=
i libahci pata_amd firwire_ohci firewire_core crc_iti_t forcedeth libata sc=
si_mod ohci_hcd ehci_pci ehci_hcd usbcore usb_common fan thermal thermal_sy=
s floppy(+)
> > > CPU: 1 PID: 73 Comm: systemd-udevd Not tainted 4.2.0-1-686-pae #1 Deb=
ian 4.2.3-1
> > > Hardware name: Packard Bell imedia S3210/WMCP78M, BIOs P01-B2 11/06/2=
009
> > > task: f68dd040 ti: f6988000 task.ti: f6988000
> > > EIP: 0060:[] EFLAGS: 00010246 CPU: 1
> > > EIP is at sr_runtime_suspend+0xc/0x20 [sr_mod]
> > > EAX: 00000000 EBX: f6a30cd8 ECX: f6c03d2c EDX: 00000000
> > > ESI: 00000000 EDI: f828e100 EBP: f6989ba8 ESP: f6989b88
> > >  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> > > CR0: 8005003b CR2: 00000014 CR3: 3696d780 CR4: 000006f0
> > > Stack:
> > >  af83346c3 00000000 00000001 fffffff5 f6a7d150 f6a30cd8 f6a30d3c 0000=
0000
> > >  f6989bbc c1390cb7 f6a30cd8 f8334660 00000000 f6989bd0 c1390d0f f6a30=
cd8
> > >  f8334660 00000000 f6989c0c c13916cb f694a614 f68dd040 00000000 00000=
008
> > > Call Trace:
> > >  [=E2=80=A6] ? scsi_runtime_suspend+0x63/0xa0 [scsi_mod]
> > >  [=E2=80=A6] ? __rpm_callback+0x27/0x60
> > > [=E2=80=A6]
> [...]
> > Ben Hutchings asked me to test the patch below to get more debug
> > information.
> [...]
>=20
> Well, that didn't help much.  Paul hit another oops, this time in
> sd_mod but again apparently related to runtime PM.  My patch only
> touched sr_mod.
>=20
> This time he sent photos of the complete oops; see
> <https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D801925;filename=3D20=
151020_005.jpg;att=3D4;msg=3D15>
> and
> <https://bugs.debian.org/cgi-bin/bugreport.cgi?filename=3D20151020_006.jp=
g;bug=3D801925;att=3D3;msg=3D15>

after backing up my data, I tested a little bit more, and using Linux
3.19 the drive is detected and the system boots.

Does anything stand out what changed in this area between Linux 3.19 and
4.1?


Thanks

Paul
--=20
go~mus | Besuchermanagement

=E2=96=B6 18. =E2=80=93 20. November 2015 // Messe K=C3=B6ln =E2=80=93 Stan=
d D054

Besuchen Sie uns auf der EXPONATEC und lernen Sie die Software f=C3=BCr
Besuchermanagement kennen, die von f=C3=BChrenden Museumsverb=C3=A4nden in =
Europa
eingesetzt wird.

Mehr Infos =C3=BCber go~mus finden Sie unter https://www.gomus.de

~

GPG-Schl=C3=BCssel: 33623E9B
Fingerabdruck =3D 0EB1 649D 4361 D04F 3C70  6F71 4DD7 BF75 3362 3E9B

Giant Monkey Software Engineering GmbH

Brunnenstr. 7D
10119 Berlin Mitte

Gesch=C3=A4ftsf=C3=BChrer Adrian Fuhrmann, Lion Vollnhals und Paul Menzel

USt-IdNr.: DE281524720
HRB 139495 B Amtsgericht Charlottenburg

--=-KQNz9ybger5UlMALsImV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJWNIxLAAoJEE3Xv3UzYj6bKgUQAIFcoKDfYwiQ62Bprc97W267
dBHQmtgmmQZDB1PO4NXW7QIZzkaA9ZN0BmMl6yI1d5l3YXlqj3KhPsvD5TlA69S0
dnH+4Dni7I+A4P5+gXrgrzWAv4QeHhEJcxYakMl+/HeSa0vD6Vct6aPw4KQT2fqR
sC1yqclIZRSo/Op6zpQKBg3A8iYYDmlRw1lcq3K2BclgOC2V1t9+Yrfnal39cgYr
dbGWjfc6ahiO/7d1OrQ930bsIcZxBncshHdntCPzChC4lz6nTw1b/D6l+tMLa9p+
yW9cUe/6bY1u4QAWxBAjH3fGEAaMw/PsqmFM/BBKjuNP8U9hU02W7B4rB7gncUAd
xAuCuoRZ7aju4s/gYThqMlLloloA9xTNJNC3Ys6uGJqzFSKZyBTidhRNAyAo0Vhw
aXSJlb27nH0BX4AQwuILzt8CsMN9KMKjqk4noEeHp+JWEZ+pYmnhSdbow1nhOT7D
LhhdYVdm0GQlbTQAnv1AykIuMqpUeDFB2IBiqvgarqYtVR3Fh+gfXSCP0/g1/9oF
eChI++LdVjBEB/sVoGHmN6LsEUx48W1qdyqy3PwZXEciMmEVLfN1sZD3x6N6d8Y9
8NlkGIxozH6/MJDum9R/angn54847u/okV/H5npyPaiZkalkgYPOp7HM6qcmTuH/
qnBBIAqrC9UBqTEzyCI2
=GQJu
-----END PGP SIGNATURE-----

--=-KQNz9ybger5UlMALsImV--

