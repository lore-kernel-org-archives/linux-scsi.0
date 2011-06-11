From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 1/1] Big endian swap for Marvell 6440 SAS driver
Date: Sun, 12 Jun 2011 08:45:56 +1000
Message-ID: <1307832356.2874.312.camel@pasglop>
References: <4DF2228E.7060806@ic.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:55218 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027Ab1FKWqM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Jun 2011 18:46:12 -0400
In-Reply-To: <4DF2228E.7060806@ic.fr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?C=E9dric?= Cano <ccano@interfaceconcept.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-scsi@vger.kernel.orglinux-scsi@vger.kernel.org

On Fri, 2011-06-10 at 15:56 +0200, C=C3=A9dric Cano wrote:
> Hi,
>=20
> Marvell SAS driver doesn't work on powerpc architecture due to big=20
> endian swap. I've tested it with the MV6440 chip.
> Here you can find the patch for Linux 2.6.39.1.
>=20
> Cedric Cano
>=20
> Signed-off-by: Cedric Cano <ccano@interfaceconcept.com>
> ---
> --- drivers/scsi/mvsas/mv_sas.c    2011-06-10 15:50:04.000000000 +020=
0
> +++ drivers/scsi/mvsas/mv_sas.c    2011-06-10 15:50:12.000000000 +020=
0
> @@ -1143,6 +1143,14 @@
>       MVS_CHIP_DISP->write_port_cfg_addr(mvi, i, PHYR_SATA_SIG0);
>       s[0] =3D MVS_CHIP_DISP->read_port_cfg_data(mvi, i);
>=20
> +    /* swap for big endian devices because of use of these data in b=
ytes */
> +#ifdef __BIG_ENDIAN
> +    s[0] =3D swab32(s[0]);
> +    s[1] =3D swab32(s[1]);
> +    s[2] =3D swab32(s[2]);
> +    s[3] =3D swab32(s[3]);
> +#endif /* __BIG_ENDIAN */

Hi Cedric !

Thanks for this. CC'ing linux-scsi.

Note that it would probably have been better to use le32_to_cpu, which
avoids the ifdef completely.

Cheers,
Ben.

>       /* Workaround: take some ATAPI devices for ATA */
>       if (((s[1] & 0x00FFFFFF) =3D=3D 0x00EB1401) && (*(u8 *)&s[3] =3D=
=3D 0x01))
>           s[1] =3D 0x00EB1401 | (*((u8 *)&s[1] + 3) & 0x10);
>=20
> ---
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
