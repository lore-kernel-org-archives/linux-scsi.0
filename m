From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v1 1/1] scsi_debug: check for bigger value first
Date: Fri, 27 Nov 2015 10:32:02 +0100
Message-ID: <1448616722.2877.97.camel@suse.de>
References: <1448562170-122075-1-git-send-email-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39048 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754290AbbK0JcF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Nov 2015 04:32:05 -0500
In-Reply-To: <1448562170-122075-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jbottomley@odin.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>

On Thu, 2015-11-26 at 20:22 +0200, Andy Shevchenko wrote:
> From: Andy Shevchenko <andy.shevchenko@gmail.com>
>=20
> Even for signed types we have to check for bigger positive value firs=
t.
> Otherwise it will be never happened.
>=20
> Acked-by: Douglas Gilbert <dgilbert@interlog.com>
> Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> ---
> =C2=A0drivers/scsi/scsi_debug.c | 6 +++---
> =C2=A01 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index dfcc45b..f773b34 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -4846,10 +4846,10 @@ static int __init scsi_debug_init(void)
> =C2=A0	/* play around with geometry, don't waste too much on track 0 =
*/
> =C2=A0	sdebug_heads =3D 8;
> =C2=A0	sdebug_sectors_per =3D 32;
> -	if (scsi_debug_dev_size_mb >=3D 16)
> -		sdebug_heads =3D 32;
> -	else if (scsi_debug_dev_size_mb >=3D 256)
> +	if (scsi_debug_dev_size_mb >=3D 256)
> =C2=A0		sdebug_heads =3D 64;
> +	else if (scsi_debug_dev_size_mb >=3D 16)
> +		sdebug_heads =3D 32;
> =C2=A0	sdebug_cylinders_per =3D (unsigned long)sdebug_capacity /
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(sdebug_sectors_pe=
r * sdebug_heads);
> =C2=A0	if (sdebug_cylinders_per >=3D 1024) {

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
