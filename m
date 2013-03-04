From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RESEND] [PATCH 05/13] pm80xx: MSI-X implementation for using
 64 interrupts
Date: Mon, 04 Mar 2013 11:16:20 +0100
Message-ID: <51347474.6070100@suse.de>
References: <51322D50.7080302@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35558 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756331Ab3CDKQZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Mar 2013 05:16:25 -0500
In-Reply-To: <51322D50.7080302@pmc-sierra.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anand <anandkumar_santhanam@pmc-sierra.com>
Cc: linux-scsi@vger.kernel.org, Harry.Yang@pmcs.com, jack_wang@usish.com, Vishwanath.Maram@pmcs.com, Sangeetha.Gnanasekaran@pmcs.com

On 03/02/2013 05:48 PM, Anand wrote:
>  From c5db2e0b6cf65fbef66fb2f4e345bf6856e242a4 Mon Sep 17 00:00:00 20=
01
> From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
> Date: Wed, 27 Feb 2013 20:32:56 +0530
> Subject: [PATCH 05/13] pm80xx: MSI-X implementation for using 64 inte=
rrupts
>
> Implementation of 64 interrupt handlers and tasklets to support
> upto 64 interrupt for the device.
>
> Signed-off-by: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
> Signed-off-by: Anand Kumar S <AnandKumar.Santhanam@pmcs.com>
> Ack-by: Jack Wang <jack_wang@usish.com>
> ---
>   drivers/scsi/pm8001/pm8001_init.c | 1233 ++++++++++++++++++++++++++=
++++++++++-
>   drivers/scsi/pm8001/pm8001_sas.h  |    3 +-
>   2 files changed, 1205 insertions(+), 31 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/=
pm8001_init.c
> index e8a983f..f0c5075 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -163,7 +163,13 @@ static void pm8001_free(struct pm8001_hba_info *=
pm8001_ha)
>   }
>
>   #ifdef PM8001_USE_TASKLET
> -static void pm8001_tasklet(unsigned long opaque)
> +
> +/**
> + * tasklets for 64 msi-x interrupt handlers
> + * @opaque: the passed general host adapter struct
> + * Note: pm8001_tasklet0 is common for pm8001 & pm80xx
> + */
> +static void pm8001_tasklet0(unsigned long opaque)
>   {
>   	struct pm8001_hba_info *pm8001_ha;
>   	pm8001_ha =3D (struct pm8001_hba_info *)opaque;
> @@ -171,16 +177,521 @@ static void pm8001_tasklet(unsigned long opaqu=
e)
>   		BUG_ON(1);
>   	PM8001_CHIP_DISP->isr(pm8001_ha, 0);
>   }
> +static void pm8001_tasklet1(unsigned long opaque)
> +{
> +	struct pm8001_hba_info *pm8001_ha;
> +	pm8001_ha =3D (struct pm8001_hba_info *)opaque;
> +	if (unlikely(!pm8001_ha))
> +		BUG_ON(1);
> +	PM8001_CHIP_DISP->isr(pm8001_ha, 1);
> +}
> +static void pm8001_tasklet2(unsigned long opaque)
> +{
> +	struct pm8001_hba_info *pm8001_ha;
> +	pm8001_ha =3D (struct pm8001_hba_info *)opaque;
> +	if (unlikely(!pm8001_ha))
> +		BUG_ON(1);
> +	PM8001_CHIP_DISP->isr(pm8001_ha, 2);
> +}
[ ... ]

This is stupid.
Please merge all the individual tasklets etc.

Having 64 identical functions makes the code unreadable and=20
unmaintainable.

Cheers,
Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
