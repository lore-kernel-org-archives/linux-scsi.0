From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [regression] CD-DA delay needed after insertion
Date: Mon, 16 Jun 2008 15:30:58 -0500
Message-ID: <1213648258.3420.12.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0806131352360.2141@vixen.sonytel.be>
	 <1213540781.3517.18.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0806161659440.30122@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:54629 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753896AbYFPUbB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jun 2008 16:31:01 -0400
In-Reply-To: <Pine.LNX.4.64.0806161659440.30122@vixen.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>

On Mon, 2008-06-16 at 17:05 +0200, Geert Uytterhoeven wrote:
> 	Hi James,
>=20
> On Sun, 15 Jun 2008, James Bottomley wrote:
> > On Fri, 2008-06-13 at 13:57 +0200, Geert Uytterhoeven wrote:
> > > We've found another regression in 2.6.25 w.r.t. CD media change o=
n PS3.
> > >=20
> > > It can easily be reproduced by:
> > >=20
> > >   1. Inserting an audio CD
> > >   2. Running the following command as soon as the blue CD/DVD/BD =
drive LED
> > >      stops blinking and is lit continuously:
> > >      =20
> > > 	 cdparanoia -Z -q 1-1[:1] /dev/null || echo failed
> > >=20
> > > On 2.6.25 (and current mainline), you have to wait ca. 10 seconds=
 after
> > > insertion, or it will fail.
> > > On 2.6.24 and older, it just works immediately.
> > >=20
> > > It does not matter whether
> > > http://git.kernel.org/?p=3Dlinux%2Fkernel%2Fgit%2Fjejb%2Fscsi-rc-=
fixes-2.6.git;a=3Dcommitdiff_plain;h=3Dd1daeabf0da5bfa1943272ce508e2ba7=
85730bf0
> > > is applied or not.
> > >=20
> > > We haven't bisected it yet.
> >=20
> > There aren't that many commits affecting sr between 2.6.24 and 2.6.=
25,
> > so I'd bet on the previous culprits.
> >=20
> > This time, the taxonomy looks like NOT_READY isn't being waited for
> > properly.  I'd still tend to blame
> > 210ba1d1724f5c4ed87a2ab1a21ca861a915f734 it's just that this time I
>=20
> Reverting that commit doesn't fix the problem.

That's a bit of a problem.  Particularly as:

> > suspect this to be the problem line:
> >=20
> > 	if (sshdr.sense_key =3D=3D NOT_READY && sshdr.asc =3D=3D 0x04)
> > 		return CDS_DISC_OK;
> >=20
> > Previously the code would have returned CDS_NO_DISC for the not rea=
dy
> > case.  The CD would have tried to close the door but (and this is t=
he
> > key) it would have waited for the door to close before trying again=
=2E
>=20
> I tried the patch below.
>=20
> Now the kernel spits out messages every 2 seconds:
>=20
> | G: CDS_NO_DISC
> | G: CDS_NO_DISC
>=20
> Insert CD-DA media
>=20
> Reading from CD using cdparanioa fails
>=20
> | F: CDS_DISC_OK
> | F: CDS_DISC_OK
> | F: CDS_DISC_OK
> | F: CDS_DISC_OK
> | F: CDS_DISC_OK

That's in the two lines I fingered as the source of the problem ...
however, if reversing the apparently bad commit (that introduces those
lines) doesn't work there's something else wrong.

Could you try altering your F: case to return CDS_DRIVE_NOT_READY, but
if that doesn't work, it's going to take a bit of bisection, I'm
afraid ...

Thanks,

James


> Reading from CD starts to work here
>=20
> | B: CDS_DISC_OK
> | B: CDS_DISC_OK
>=20
> I tried changing the return value in the `F' case to CDS_NO_DISC, but=
 that
> doesn't make a difference.
>=20
> --- a/drivers/scsi/sr_ioctl.c	2008-06-16 16:34:01.000000000 +0200
> +++ b/drivers/scsi/sr_ioctl.c	2008-06-16 16:59:28.000000000 +0200
> @@ -304,25 +304,34 @@ int sr_drive_status(struct cdrom_device_
> =20
>  	if (CDSL_CURRENT !=3D slot) {
>  		/* we have no changer support */
> +printk("A: -EINVAL\n");
>  		return -EINVAL;
>  	}
> -	if (0 =3D=3D sr_test_unit_ready(cd->device, &sshdr))
> +	if (0 =3D=3D sr_test_unit_ready(cd->device, &sshdr)) {
> +printk("B: CDS_DISC_OK\n");
>  		return CDS_DISC_OK;
> +	}
> =20
>  	if (!cdrom_get_media_event(cdi, &med)) {
> -		if (med.media_present)
> +		if (med.media_present) {
> +printk("C: CDS_DISC_OK\n");
>  			return CDS_DISC_OK;
> -		else if (med.door_open)
> +		} else if (med.door_open) {
> +printk("D: CDS_TRAY_OPEN\n");
>  			return CDS_TRAY_OPEN;
> -		else
> +		} else {
> +printk("E: CDS_NO_DISC\n");
>  			return CDS_NO_DISC;
> +		}
>  	}
> =20
>  	/*
>  	 * 0x04 is format in progress .. but there must be a disc present!
>  	 */
> -	if (sshdr.sense_key =3D=3D NOT_READY && sshdr.asc =3D=3D 0x04)
> +	if (sshdr.sense_key =3D=3D NOT_READY && sshdr.asc =3D=3D 0x04) {
> +printk("F: CDS_DISC_OK\n");
>  		return CDS_DISC_OK;
> +	}
> =20
>  	/*
>  	 * If not using Mt Fuji extended media tray reports,
> @@ -331,11 +340,15 @@ int sr_drive_status(struct cdrom_device_
>  	 */
>  	if (scsi_sense_valid(&sshdr) &&
>  	    /* 0x3a is medium not present */
> -	    sshdr.asc =3D=3D 0x3a)
> +	    sshdr.asc =3D=3D 0x3a) {
> +printk("G: CDS_NO_DISC\n");
>  		return CDS_NO_DISC;
> -	else
> +	} else {
> +printk("H: CDS_TRAY_OPEN\n");
>  		return CDS_TRAY_OPEN;
> +	}
> =20
> +printk("I: CDS_DRIVE_NOT_READY\n");
>  	return CDS_DRIVE_NOT_READY;
>  }
> =20
>=20
> With kind regards,
>=20
> Geert Uytterhoeven
> Software Architect
>=20
> Sony Techsoft Centre
> The Corporate Village =C2=B7 Da Vincilaan 7-D1 =C2=B7 B-1935 Zaventem=
 =C2=B7 Belgium
>=20
> Phone:    +32 (0)2 700 8453
> Fax:      +32 (0)2 700 8622
> E-mail:   Geert.Uytterhoeven@sonycom.com
> Internet: http://www.sony-europe.com/
>=20
> Sony Technology and Software Centre Europe
> A division of Sony Service Centre (Europe) N.V.
> Registered office: Technologielaan 7 =C2=B7 B-1840 Londerzeel =C2=B7 =
Belgium
> VAT BE 0413.825.160 =C2=B7 RPR Brussels
> Fortis 293-0376800-10 GEBA-BE-BB

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
