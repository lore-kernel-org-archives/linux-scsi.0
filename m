From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH 6/6] pm80xx : Fixed return value issue
Date: Wed, 20 Nov 2013 10:37:46 +0100
Message-ID: <528C82EA.7060405@gmail.com>
References: <1384932135-16936-1-git-send-email-Viswas.G@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:45577 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab3KTJhc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Nov 2013 04:37:32 -0500
Received: by mail-ea0-f172.google.com with SMTP id q10so1503478ead.17
        for <linux-scsi@vger.kernel.org>; Wed, 20 Nov 2013 01:37:31 -0800 (PST)
In-Reply-To: <1384932135-16936-1-git-send-email-Viswas.G@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Viswas G <Viswas.G@pmcs.com>
Cc: linux-scsi@vger.kernel.org, Vasanthalakshmi.Tharmarajan@pmcs.com, Suresh.Thiagarajan@pmcs.com

On 11/20/2013 08:22 AM, Viswas G wrote:
> pm8001_get_gsm_dump() was returning "1" in error case
> instead of negative error code.
> 
> Signed-off-by: Viswas G <Viswas.G@pmcs.com>
Looks good, thanks
Reviewed-by: Jack Wang <jinpu.wang@profitbricks.com>

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
> 

