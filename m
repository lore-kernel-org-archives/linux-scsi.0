From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 6/6] pm80xx : Fixed return value issue
Date: Wed, 20 Nov 2013 17:46:29 +0100
Message-ID: <528CE765.80108@redhat.com>
References: <1384932135-16936-1-git-send-email-Viswas.G@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754498Ab3KTQqd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Nov 2013 11:46:33 -0500
In-Reply-To: <1384932135-16936-1-git-send-email-Viswas.G@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Viswas G <Viswas.G@pmcs.com>, linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, Vasanthalakshmi.Tharmarajan@pmcs.com, Suresh.Thiagarajan@pmcs.com

On 11/20/2013 08:22 AM, Viswas G wrote:
> pm8001_get_gsm_dump() was returning "1" in error case
> instead of negative error code.

Hi,

the pm8001_get_gsm_dum return value is used here I think:
----------------
static ssize_t pm8001_ctl_gsm_log_show(struct device *cdev,
       struct device_attribute *attr, char *buf)
{
       u32 count;

       count = pm8001_get_gsm_dump(cdev, SYSFS_OFFSET, buf);
---------------
could you also change the 'count' from unsigned to a signed type?

Maybe in some cases another errno would make more sense (ENODEV, EIO?),
but I'll leave this up to you.

I have noticed in this series only patches 5/6 and 6/6, I miss the
1-4/6, could you help me find them ? What are the subjects of 1-4/6?

Thanks, Tomas

>
> Signed-off-by: Viswas G <Viswas.G@pmcs.com>
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
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

