From: Paul Menzel <paul.menzel@giantmonkey.de>
Subject: Re: NULL pointer dereference: IP: [<f828a00c>]
 sr_runtime_suspend+0xc/0x20 [sr_mod]
Date: Fri, 16 Oct 2015 10:52:56 +0200
Message-ID: <1444985576.2703.5.camel@giantmonkey.de>
References: <1444957547.1325.2.camel@giantmonkey.de>
	 <1444982077.2350.0.camel@giantmonkey.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-RBIglsBqkwDR8Xelnuwk"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:32942 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbbJPIxL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Oct 2015 04:53:11 -0400
Received: by wijp11 with SMTP id p11so20466wij.0
        for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2015 01:53:07 -0700 (PDT)
In-Reply-To: <1444982077.2350.0.camel@giantmonkey.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E. J. Bottomley" <JBottomley@odin.com>, 801925@bugs.debian.org


--=-RBIglsBqkwDR8Xelnuwk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Linux SCSI folks,


Am Freitag, den 16.10.2015, 09:54 +0200 schrieb Paul Menzel:
> Package: linux-image-4.2.0-1-686-pae
> Version: 4.2.3-2
> Severity: important

> please don=E2=80=99t include the address submit@bugs.debian.org in your r=
eply.

this issue is now also tracked in the Debian Bug Tracking System [2] and
has the number #801925 [3]. Please keep that address in CC.

> Am Freitag, den 16.10.2015, 03:05 +0200 schrieb Paul Menzel:
>=20
> > using Debian Sid/unstable with Linux 4.2.3-1 upgrading from systemd
> > 227-1 to 227-2 [1] and other packages, the system doesn=E2=80=99t start=
 up
> > anymore and the /dev/md1 device doesn=E2=80=99t seem to be found and I =
am
> > dropped into shell from initramfs (BusyBox).
> >=20
> > Only having wireless LAN and no serial or USB debug capabilities, and
> > mount a USB storage device did not work, I manually copied the beginnin=
g
> > of the Oops.
> >=20
> > ```
> > BUG: unable to handle kernel NULL pointer dereference at 00000014
> > IP: [<f828a00c>] sr_runtime_suspend+0xc/0x20 [sr_mod]
> > *pdpt =3D 000000003696e001 *pde =3D 000000000000000000
> > Oops: 0000 [#1] SMB
> > Modules linked in: sd_mod(+) sr_mod(+) cdrom ata_generic ohci_pci ahci =
libahci pata_amd firwire_ohci firewire_core crc_iti_t forcedeth libata scsi=
_mod ohci_hcd ehci_pci ehci_hcd usbcore usb_common fan thermal thermal_sys =
floppy(+)
> > CPU: 1 PID: 73 Comm: systemd-udevd Not tainted 4.2.0-1-686-pae #1 Debia=
n 4.2.3-1
> > Hardware name: Packard Bell imedia S3210/WMCP78M, BIOs P01-B2 11/06/200=
9
> > task: f68dd040 ti: f6988000 task.ti: f6988000
> > EIP: 0060:[<fh28a00c>] EFLAGS: 00010246 CPU: 1
> > EIP is at sr_runtime_suspend+0xc/0x20 [sr_mod]
> > EAX: 00000000 EBX: f6a30cd8 ECX: f6c03d2c EDX: 00000000
> > ESI: 00000000 EDI: f828e100 EBP: f6989ba8 ESP: f6989b88
> >  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> > CR0: 8005003b CR2: 00000014 CR3: 3696d780 CR4: 000006f0
> > Stack:
> >  af83346c3 00000000 00000001 fffffff5 f6a7d150 f6a30cd8 f6a30d3c 000000=
00
> >  f6989bbc c1390cb7 f6a30cd8 f8334660 00000000 f6989bd0 c1390d0f f6a30cd=
8
> >  f8334660 00000000 f6989c0c c13916cb f694a614 f68dd040 00000000 0000000=
8
> > Call Trace:
> >  [=E2=80=A6] ? scsi_runtime_suspend+0x63/0xa0 [scsi_mod]
> >  [=E2=80=A6] ? __rpm_callback+0x27/0x60
> > [=E2=80=A6]
> > ```
> >=20
> > I tried also to boot with Linux 4.1 and it fails the same way.
> >=20
> > Is that a known problem and has been fixed in the mean time? It=E2=80=
=99d be
> > great if you helped me getting the system to boot again. Please tell me
> > if you need more information to debug this issue and I=E2=80=99ll do my=
 best to
> > get it.
>=20
> Ben Hutchings asked me to test the patch below to get more debug
> information.
>=20
> ```
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index 8bd54a6..dd5b5b2 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -144,6 +144,12 @@ static int sr_runtime_suspend(struct device *dev)
>  {
>  	struct scsi_cd *cd =3D dev_get_drvdata(dev);
> =20
> +	if (WARN_ON(!cd)) {
> +		pr_info("%s: cd =3D=3D NULL; power.usage_count =3D %d\n",
> +			__func__, atomic_read(&dev->power.usage_count));
> +		return 0;
> +	}
> +
>  	if (cd->media_present)
>  		return -EBUSY;
>  	else
> @@ -652,7 +658,13 @@ static int sr_probe(struct device *dev)
>  	struct scsi_cd *cd;
>  	int minor, error;
> =20
> -	scsi_autopm_get_device(sdev);
> +	error =3D scsi_autopm_get_device(sdev);
> +	if (error) {
> +		pr_err("%s: scsi_autopm_get_device returned %d\n",
> +		       __func__, error);
> +		return error;
> +	}
> +
>  	error =3D -ENODEV;
>  	if (sdev->type !=3D TYPE_ROM && sdev->type !=3D TYPE_WORM)
>  		goto fail;
> @@ -719,6 +731,9 @@ static int sr_probe(struct device *dev)
>  	if (register_cdrom(&cd->cdi))
>  		goto fail_put;
> =20
> +	pr_info("%s: power.usage_count =3D %d\n",
> +		__func__, atomic_read(&dev->power.usage_count));
> +
>  	/*
>  	 * Initialize block layer runtime PM stuffs before the
>  	 * periodic event checking request gets started in add_disk.
> ```
>=20
> I=E2=80=99ll try that as soon as a spare drive has arrived, where I can c=
opy the
> data to as a backup.
>=20
> More thoughts are welcome! Especially, if that error suggests a failing
> drive or not.


Thanks,

Paul


> > [1] http://metadata.ftp-master.debian.org/changelogs//main/s/systemd/sy=
stemd_227-2_changelog
[2] https://www.debian.org/Bugs/
[3] https://bugs.debian.org/801925
--=20
GPG-Schl=C3=BCssel: 33623E9B
Fingerabdruck =3D 0EB1 649D 4361 D04F 3C70  6F71 4DD7 BF75 3362 3E9B

Giant Monkey Software Engineering GmbH

Brunnenstr. 7D
10119 Berlin Mitte

Gesch=C3=A4ftsf=C3=BChrer Adrian Fuhrmann, Lion Vollnhals und Paul Menzel

USt-IdNr.: DE281524720
HRB 139495 B Amtsgericht Charlottenburg

--=-RBIglsBqkwDR8Xelnuwk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJWILrxAAoJEE3Xv3UzYj6bwysQALE/G35p1eV/NwTC1BKTHj3z
0lsVpvEVeBPHP3laXmQxma8vtGLtKTGsuPrbpYtcCnCerDYhmVp6xVpb3do5+1Gg
nN+mgXejPo85LpAQINOULYAS6UtT+BVjSGF5aopbwwdPXf9QqhfP9rdA3HrID/W5
BbpLu4jhtiwIQ2V0nWF1X+24dZXz5hq2YHey8m1nAMYO2HRkEpKTboBwmWtlgGJ8
Hm/xcfCZaei+jtBEzaqYHQmRyPbbh6JpB+1yT+6uH/6itszJPFxe6s5savbe7htL
LQOAAAAz530FgZGsTx/2qPhB1iwoUJqYZoNmPEl64co1BRiZWLChYiEaV+KIex72
dtjVZJvD8NtsxjQw0DcxfExeRm/f1xhPXGetIuo+sJj1DhyIVZuXJy1Jv+wN9l6i
Xb/J4HrCnY9pnKJaccmEbhkGrCsawfGJ28eoz99fTxk2KSVPGqiYw8cpougzCk22
VwepdFIiEFvvrz1mx0veJ6MvpYHhGAafILkiQzYPPeKwMfsgEpUPtDV1lUdQfXT3
7a7c5QbnYSI2LYshnPNrpqRb264xk60CpqY0o2/Wron5b4Ti019MzVhUkEOGSHLr
CVIs7OOobQV6KiqcM1Iy/2sAZNSzhEGn9I+ownsEK4x6yg7ZHgXN5r2eVAUy5yBk
9xwuEsjWBbixueVYo5WQ
=JisI
-----END PGP SIGNATURE-----

--=-RBIglsBqkwDR8Xelnuwk--

