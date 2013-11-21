From: Viswas G <Viswas.G@pmcs.com>
Subject: RE: [PATCH 6/6] pm80xx : Fixed return value issue
Date: Thu, 21 Nov 2013 03:56:34 +0000
Message-ID: <DB8BCD22E410A84DA91083F3479A3DB31C681CEA@BBYEXM01.pmc-sierra.internal>
References: <1384932135-16936-1-git-send-email-Viswas.G@pmcs.com>
 <528CE765.80108@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:34125 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751613Ab3KUD4f convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Nov 2013 22:56:35 -0500
In-Reply-To: <528CE765.80108@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "xjtuwjp@gmail.com" <xjtuwjp@gmail.com>, Vasanthalakshmi Tharmarajan <Vasanthalakshmi.Tharmarajan@pmcs.com>, Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>

Hi Tomas,

Patches 1-4 are submitted with subject "[PATCH V2 0/4]: pm8001 driver bug fixes".

As this patch has to be applied after those four patches, we submitted this as 5/6 and 6/6.

We will resend the modified  patch.

Regards,
Viswas G
 
 
-----Original Message-----
From: Tomas Henzl [mailto:thenzl@redhat.com] 
Sent: Wednesday, November 20, 2013 10:16 PM
To: Viswas G; linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com; Vasanthalakshmi Tharmarajan; Suresh Thiagarajan
Subject: Re: [PATCH 6/6] pm80xx : Fixed return value issue

On 11/20/2013 08:22 AM, Viswas G wrote:
> pm8001_get_gsm_dump() was returning "1" in error case instead of 
> negative error code.

Hi,

the pm8001_get_gsm_dum return value is used here I think:
----------------
static ssize_t pm8001_ctl_gsm_log_show(struct device *cdev,
       struct device_attribute *attr, char *buf) {
       u32 count;

       count = pm8001_get_gsm_dump(cdev, SYSFS_OFFSET, buf);
---------------
could you also change the 'count' from unsigned to a signed type?

Maybe in some cases another errno would make more sense (ENODEV, EIO?), but I'll leave this up to you.

I have noticed in this series only patches 5/6 and 6/6, I miss the 1-4/6, could you help me find them ? What are the subjects of 1-4/6?

Thanks, Tomas

>
> Signed-off-by: Viswas G <Viswas.G@pmcs.com>
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c 
> b/drivers/scsi/pm8001/pm8001_hwi.c
> index f6ea277..e2932ef 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -5020,7 +5020,7 @@ pm8001_get_gsm_dump(struct device *cdev, u32 length, char* buf)
>  	/* check max is 1 Mbytes */
>  	if ((length > 0x100000) || (gsm_dump_offset & 3) ||
>  		((gsm_dump_offset + length) > 0x1000000))
> -			return 1;
> +			return -EINVAL;
>  
>  	if (pm8001_ha->chip_id == chip_8001)
>  		bar = 2;
> @@ -5048,12 +5048,12 @@ pm8001_get_gsm_dump(struct device *cdev, u32 length, char* buf)
>  				gsm_base = GSM_BASE;
>  				if (-1 == pm8001_bar4_shift(pm8001_ha,
>  						(gsm_base + shift_value)))
> -					return 1;
> +					return -EINVAL;
>  			} else {
>  				gsm_base = 0;
>  				if (-1 == pm80xx_bar4_shift(pm8001_ha,
>  						(gsm_base + shift_value)))
> -					return 1;
> +					return -EINVAL;
>  			}
>  			gsm_dump_offset = (gsm_dump_offset + offset) &
>  						0xFFFF0000;
> @@ -5073,7 +5073,7 @@ pm8001_get_gsm_dump(struct device *cdev, u32 length, char* buf)
>  	}
>  	/* Shift back to BAR4 original address */
>  	if (-1 == pm8001_bar4_shift(pm8001_ha, 0))
> -			return 1;
> +			return -EINVAL;
>  	pm8001_ha->fatal_forensic_shift_offset += 1024;
>  
>  	if (pm8001_ha->fatal_forensic_shift_offset >= 0x100000)

