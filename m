From: "Anand Kumar Santhanam" <AnandKumar.Santhanam@pmcs.com>
Subject: RE: [RESEND] [PATCH 05/13] pm80xx: MSI-X implementation for using 64 interrupts
Date: Thu, 14 Mar 2013 04:09:13 -0700
Message-ID: <E5DEE6F468524847995699AD11E808850158619C@BBY1EXM11.pmc_nt.nt.pmc-sierra.bc.ca>
References: <51322D50.7080302@pmc-sierra.com> <51347474.6070100@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:39682 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756200Ab3CNLJW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Mar 2013 07:09:22 -0400
Content-class: urn:content-classes:message
In-Reply-To: <51347474.6070100@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, Harry Yang <Harry.Yang@pmcs.com>, jack_wang@usish.com, Vishwanath Maram <Vishwanath.Maram@pmcs.com>, Sangeetha Gnanasekaran <Sangeetha.Gnanasekaran@pmcs.com>

Hi Hannes,

I have addressed your comment and merged individual tasklet to one and =
have resubmitted the patchset.

Regards
Anand

-----Original Message-----
=46rom: Hannes Reinecke [mailto:hare@suse.de]=20
Sent: Monday, March 04, 2013 3:46 PM
To: Anand Kumar Santhanam
Cc: linux-scsi@vger.kernel.org; Harry Yang; jack_wang@usish.com; Vishwa=
nath Maram; Sangeetha Gnanasekaran
Subject: Re: [RESEND] [PATCH 05/13] pm80xx: MSI-X implementation for us=
ing 64 interrupts

On 03/02/2013 05:48 PM, Anand wrote:
>  From c5db2e0b6cf65fbef66fb2f4e345bf6856e242a4 Mon Sep 17 00:00:00=20
> 2001
> From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
> Date: Wed, 27 Feb 2013 20:32:56 +0530
> Subject: [PATCH 05/13] pm80xx: MSI-X implementation for using 64=20
> interrupts
>
> Implementation of 64 interrupt handlers and tasklets to support upto=20
> 64 interrupt for the device.
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
> diff --git a/drivers/scsi/pm8001/pm8001_init.c=20
> b/drivers/scsi/pm8001/pm8001_init.c
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
> + * Note: pm8001_tasklet0 is common for pm8001 & pm80xx  */ static=20
> +void pm8001_tasklet0(unsigned long opaque)
>   {
>   	struct pm8001_hba_info *pm8001_ha;
>   	pm8001_ha =3D (struct pm8001_hba_info *)opaque; @@ -171,16 +177,52=
1=20
> @@ static void pm8001_tasklet(unsigned long opaque)
>   		BUG_ON(1);
>   	PM8001_CHIP_DISP->isr(pm8001_ha, 0);
>   }
> +static void pm8001_tasklet1(unsigned long opaque) {
> +	struct pm8001_hba_info *pm8001_ha;
> +	pm8001_ha =3D (struct pm8001_hba_info *)opaque;
> +	if (unlikely(!pm8001_ha))
> +		BUG_ON(1);
> +	PM8001_CHIP_DISP->isr(pm8001_ha, 1); } static void=20
> +pm8001_tasklet2(unsigned long opaque) {
> +	struct pm8001_hba_info *pm8001_ha;
> +	pm8001_ha =3D (struct pm8001_hba_info *)opaque;
> +	if (unlikely(!pm8001_ha))
> +		BUG_ON(1);
> +	PM8001_CHIP_DISP->isr(pm8001_ha, 2); }
[ ... ]

This is stupid.
Please merge all the individual tasklets etc.

Having 64 identical functions makes the code unreadable and unmaintaina=
ble.

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
