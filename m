From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Cbe-oss-dev] [regression/bisected] corrupt CD data after
	media change and delay
Date: Tue, 10 Jun 2008 10:22:02 -0500
Message-ID: <1213111322.3440.9.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0806061458300.6228@vixen.sonytel.be>
	 <1212765202.16182.5.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0806091443000.17741@vixen.sonytel.be>
	 <Pine.LNX.4.64.0806091546260.22138@vixen.sonytel.be>
	 <1213023916.3508.23.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0806091721040.22138@vixen.sonytel.be>
	 <1213028647.3508.33.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0806101705150.1797@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:34524 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752682AbYFJPWE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jun 2008 11:22:04 -0400
In-Reply-To: <Pine.LNX.4.64.0806101705150.1797@vixen.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2008-06-10 at 17:11 +0200, Geert Uytterhoeven wrote:
> 	Hi James,
>=20
> On Mon, 9 Jun 2008, James Bottomley wrote:
> > My best guess is that it's something to do with eaten UNIT_ATTENTIO=
N
> > keys.  I theorise that in the successful case, they get processed i=
n
> > scsi_io_completion which sets the changed bit.  In the delay case, =
the
> > unit attention is eaten by sr_test_unit_ready so the changed bit is
> > always kept at zero.  If this is the case, then the patch below sho=
uld
> > fix it.  If not, we're back to more debugging ...
>=20
> Yep, that fixed it. Thanks!

OK, will add to rc-fixes and ask for stable backport; thanks.

James


> Inserting first CD, mounting:
>=20
> | +0+ the_result =3D 0x8000002 (sdev->changed =3D 1)
> | Sense Key : 0x0 [current] [descriptor]
> | +0+ the_result =3D 0x8000002 (sdev->changed =3D 1)
> | Sense Key : 0x0 [current] [descriptor]
> | +0+ the_result =3D 0x8000002 (sdev->changed =3D 1)
> | Sense Key : 0x0 [current] [descriptor]
> | Sense Key : 0x2 [current]=20
> | +5+ CDS_DISC_OK
> | +0+ the_result =3D 0x8000002 (sdev->changed =3D 1)
> | Sense Key : 0x0 [current] [descriptor]
> | +0+ the_result =3D 0x8000002 (sdev->changed =3D 1)
> | Sense Key : 0x0 [current] [descriptor]
> | +0+ the_result =3D 0x8000002 (sdev->changed =3D 1)
> | Sense Key : 0x0 [current] [descriptor]
> | Sense Key : 0x2 [current]=20
> | +5+ CDS_DISC_OK
> | +0+ the_result =3D 0x0 (sdev->changed =3D 1)
> | Sense Key : 0x0 [current] [descriptor]
> | +1+ CDS_DISC_OK
> | +0+ the_result =3D 0x0 (sdev->changed =3D 1)
> | Sense Key : 0x0 [current] [descriptor]
> | +1+ CDS_DISC_OK
> | +0+ the_result =3D 0x0 (sdev->changed =3D 1)
> | Sense Key : 0x0 [current] [descriptor]
> | +11+ Return forcing update is 1
>                                 ^
> 				OK
>=20
> | ISO 9660 Extensions: RRIP_1991A
>=20
> Unmounting first CD:
>=20
> | +0+ the_result =3D 0x0 (sdev->changed =3D 0)
> | Sense Key : 0x0 [current] [descriptor]
> | +1+ CDS_DISC_OK
> | +0+ the_result =3D 0x0 (sdev->changed =3D 0)
> | Sense Key : 0x0 [current] [descriptor]
> | +1+ CDS_DISC_OK
> | +0+ the_result =3D 0x0 (sdev->changed =3D 0)
> | Sense Key : 0x0 [current] [descriptor]
> | +11+ Return forcing update is 0
>=20
> Inserting second CD, mounting after 30 seconds:
>=20
> | +0+ the_result =3D 0x8000002 (sdev->changed =3D 1)
> | Sense Key : 0x0 [current] [descriptor]
> | +0+ the_result =3D 0x0 (sdev->changed =3D 1)
> | Sense Key : 0x0 [current] [descriptor]
> | +1+ CDS_DISC_OK
> | +0+ the_result =3D 0x0 (sdev->changed =3D 1)
> | Sense Key : 0x0 [current] [descriptor]
> | +1+ CDS_DISC_OK
> | +0+ the_result =3D 0x0 (sdev->changed =3D 1)
> | Sense Key : 0x0 [current] [descriptor]
> | +1+ CDS_DISC_OK
> | +0+ the_result =3D 0x0 (sdev->changed =3D 1)
> | Sense Key : 0x0 [current] [descriptor]
> | +1+ CDS_DISC_OK
> | +0+ the_result =3D 0x0 (sdev->changed =3D 1)
> | Sense Key : 0x0 [current] [descriptor]
> | +11+ Return forcing update is 1
>                                 ^
> 				OK!
>=20
> | ISO 9660 Extensions: Microsoft Joliet Level 3
> | ISO 9660 Extensions: RRIP_1991A
>=20
> =3D> success!
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
