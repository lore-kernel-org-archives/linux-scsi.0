From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi: use sector_div instead of do_div
Date: Tue, 24 Nov 2015 13:48:59 +0100
Message-ID: <1448369339.2877.30.camel@suse.de>
References: <24882658.08y4bWL6tn@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53256 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335AbbKXMtB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Nov 2015 07:49:01 -0500
In-Reply-To: <24882658.08y4bWL6tn@wuerfel>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org
Cc: jbottomley@odin.com, martin.petersen@oracle.com, nico@fluxnic.net, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org

On Fri, 2015-11-20 at 17:38 +0100, Arnd Bergmann wrote:
> do_div is the wrong way to divide a sector_t, as it is less
> efficient when sector_t is 32-bit wide. With the upcoming
> do_div optimizations, the kernel starts warning about this:
>=20
> drivers/scsi/scsi_debug.c: In function 'dif_store':
> include/asm-generic/div64.h:207:28: warning: comparison of distinct
> pointer types lacks a cast
>=20
> This changes the code to use sector_div instead, which always
> produces optimal code.
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> Found on the ARM randconfig build today, after I merged Nico's
> patches
> for linux-next
>=20
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index dfcc45bb03b1..ec622ba9864a 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -678,7 +678,7 @@ static void *fake_store(unsigned long long lba)
> =C2=A0
> =C2=A0static struct sd_dif_tuple *dif_store(sector_t sector)
> =C2=A0{
> -	sector =3D do_div(sector, sdebug_store_sectors);
> +	sector =3D sector_div(sector, sdebug_store_sectors);
> =C2=A0
> =C2=A0	return dif_storep + sector;
> =C2=A0}
> @@ -2780,7 +2780,7 @@ static unsigned long lba_to_map_index(sector_t
> lba)
> =C2=A0		lba +=3D scsi_debug_unmap_granularity -
> =C2=A0			scsi_debug_unmap_alignment;
> =C2=A0	}
> -	do_div(lba, scsi_debug_unmap_granularity);
> +	sector_div(lba, scsi_debug_unmap_granularity);
> =C2=A0
> =C2=A0	return lba;
> =C2=A0}
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
=20
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0=C2=A0http://vger.kernel.org/majordomo-in=
fo.html


Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
