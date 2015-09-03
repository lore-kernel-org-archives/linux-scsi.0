From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/3] scsi:stex.c Support to Pegasus series.
Date: Thu, 03 Sep 2015 08:49:45 +0200
Message-ID: <mqd8u8oc7zq.fsf@c203.arch.suse.de>
References: <55E7A65C.4090609@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55E7A65C.4090609@gmail.com> (Charles Chiou's message of "Thu, 03
	Sep 2015 09:46:04 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Charles Chiou <ch1102chiou@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, JBottomley@parallels.com, Oliver Neukum <oneukum@suse.de>, ed.lin@promise.com, grace.chang@tw.promise.com, linus.chen@tw.promise.com, victor.p@promise.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Charles Chiou <ch1102chiou@gmail.com> writes:

> From 63f806abc43237285a918f559ce6e5e410d90d85 Mon Sep 17 00:00:00 200=
1
> From: Charles <charles.chiou@tw.promise.com>
> Date: Wed, 2 Sep 2015 20:41:56 +0800
> Subject: [PATCH 1/3] scsi:stex.c Support to Pegasus series.
>
> Pegasus is a high performace hardware RAID solution designed to unlea=
sh
> the raw power of Thunderbolt technology.
>
> 1. Add code to distinct SuperTrack and Pegasus series by sub device I=
D.
>    It should support backward compatibility.
>
> 2. Change the driver version.
>
> Signed-off-by: Charles Chiou <charles.chiou@tw.promise.com>
> ---
>  drivers/scsi/stex.c | 35 +++++++++++++++++++++++++++++------
>  1 file changed, 29 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
> index 98a62bc..657e3ae 100644
> --- a/drivers/scsi/stex.c
> +++ b/drivers/scsi/stex.c
> @@ -1,7 +1,7 @@
>  /*
>   * SuperTrak EX Series Storage Controller driver for Linux
>   *
> - *	Copyright (C) 2005-2009 Promise Technology Inc.
> + *	Copyright (C) 2005-2015 Promise Technology Inc.
>   *
>   *	This program is free software; you can redistribute it and/or
>   *	modify it under the terms of the GNU General Public License
> @@ -37,11 +37,11 @@
>  #include <scsi/scsi_eh.h>
>
>  #define DRV_NAME "stex"
> -#define ST_DRIVER_VERSION "4.6.0000.4"
> -#define ST_VER_MAJOR		4
> -#define ST_VER_MINOR		6
> -#define ST_OEM			0
> -#define ST_BUILD_VER		4
> +#define ST_DRIVER_VERSION	"5.00.0000.01"
> +#define ST_VER_MAJOR		5
> +#define ST_VER_MINOR		00
> +#define ST_OEM				0000
> +#define ST_BUILD_VER		01
>
>  enum {
>  	/* MU register offset */
> @@ -327,6 +327,7 @@ struct st_hba {
>  	u16 rq_count;
>  	u16 rq_size;
>  	u16 sts_count;
> +	u8  supports_pm;
>  };
>
>  struct st_card_info {
> @@ -1566,8 +1567,30 @@ static int stex_probe(struct pci_dev *pdev, co=
nst struct
> pci_device_id *id)
>  		goto out_iounmap;
>  	}
>
> +
> +
> +

Please no quad blank lines, one's enough :-(

>  	hba->cardtype =3D (unsigned int) id->driver_data;
>  	ci =3D &stex_card_info[hba->cardtype];
> +	switch (id->subdevice) {
> +	case 0x4221:
> +	case 0x4222:
> +	case 0x4223:
> +	case 0x4224:
> +	case 0x4225:
> +	case 0x4226:
> +	case 0x4227:
> +	case 0x4261:
> +	case 0x4262:
> +	case 0x4263:
> +	case 0x4264:
> +	case 0x4265:
> +		break;
> +	default:
> +		if (hba->cardtype =3D=3D st_yel)
> +			hba->supports_pm =3D 1;
> +	}
> +
>  	sts_offset =3D scratch_offset =3D (ci->rq_count+1) * ci->rq_size;
>  	if (hba->cardtype =3D=3D st_yel)
>  		sts_offset +=3D (ci->sts_count+1) * sizeof(u32);

--=20
Johannes Thumshirn                                           Storage
jthumshirn@suse.de                                 +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=C3=BCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600  D0D0 0393 969D 2D76 0850
