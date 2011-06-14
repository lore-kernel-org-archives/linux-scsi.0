From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 1/1] Big endian swap for Marvell 6440 SAS driver
Date: Tue, 14 Jun 2011 17:05:23 +1000
Message-ID: <1308035123.2874.1055.camel@pasglop>
References: <4DF2228E.7060806@ic.fr> <1307832356.2874.312.camel@pasglop>
	 <4DF702F3.704@interfaceconcept.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:40080 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234Ab1FNHFd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jun 2011 03:05:33 -0400
In-Reply-To: <4DF702F3.704@interfaceconcept.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?C=E9dric?= Cano <ccano@interfaceconcept.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-scsi@vger.kernel.org

On Tue, 2011-06-14 at 08:42 +0200, C=C3=A9dric Cano wrote:
> Hi Ben,
>=20
> You're alright! I hadn't thought to use le32_to_cpu.
> Do you want I make a new patch?

Well, I'm not the maintainer of the subsystem or of the driver, so I'm
not going to be the one accepting/merging it :-)

I'm just reviewing the patch, but yes, I think you should, and you
should send it to the right people, ie, I think at least linux-scsi and
possibly the author/maintainer of the driver itself.

Cheers,
Ben.

> Cedric
>=20
> Le 12/06/2011 00:45, Benjamin Herrenschmidt a =C3=A9crit :
> > On Fri, 2011-06-10 at 15:56 +0200, C=C3=A9dric Cano wrote:
> >> Hi,
> >>
> >> Marvell SAS driver doesn't work on powerpc architecture due to big
> >> endian swap. I've tested it with the MV6440 chip.
> >> Here you can find the patch for Linux 2.6.39.1.
> >>
> >> Cedric Cano
> >>
> >> Signed-off-by: Cedric Cano<ccano@interfaceconcept.com>
> >> ---
> >> --- drivers/scsi/mvsas/mv_sas.c    2011-06-10 15:50:04.000000000 +=
0200
> >> +++ drivers/scsi/mvsas/mv_sas.c    2011-06-10 15:50:12.000000000 +=
0200
> >> @@ -1143,6 +1143,14 @@
> >>        MVS_CHIP_DISP->write_port_cfg_addr(mvi, i, PHYR_SATA_SIG0);
> >>        s[0] =3D MVS_CHIP_DISP->read_port_cfg_data(mvi, i);
> >>
> >> +    /* swap for big endian devices because of use of these data i=
n bytes */
> >> +#ifdef __BIG_ENDIAN
> >> +    s[0] =3D swab32(s[0]);
> >> +    s[1] =3D swab32(s[1]);
> >> +    s[2] =3D swab32(s[2]);
> >> +    s[3] =3D swab32(s[3]);
> >> +#endif /* __BIG_ENDIAN */
> > Hi Cedric !
> >
> > Thanks for this. CC'ing linux-scsi.
> >
> > Note that it would probably have been better to use le32_to_cpu, wh=
ich
> > avoids the ifdef completely.
> >
> > Cheers,
> > Ben.
> >
> >>        /* Workaround: take some ATAPI devices for ATA */
> >>        if (((s[1]&  0x00FFFFFF) =3D=3D 0x00EB1401)&&  (*(u8 *)&s[3=
] =3D=3D 0x01))
> >>            s[1] =3D 0x00EB1401 | (*((u8 *)&s[1] + 3)&  0x10);
> >>
> >> ---
> >> _______________________________________________
> >> Linuxppc-dev mailing list
> >> Linuxppc-dev@lists.ozlabs.org
> >> https://lists.ozlabs.org/listinfo/linuxppc-dev
> >
> >


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
