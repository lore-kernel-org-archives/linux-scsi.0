From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH 5/6] pm80xx : Removing redundant code snippets
Date: Wed, 20 Nov 2013 10:38:08 +0100
Message-ID: <528C8300.5050604@gmail.com>
References: <1384932064-16870-1-git-send-email-Viswas.G@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:59030 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab3KTJh4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Nov 2013 04:37:56 -0500
Received: by mail-ea0-f178.google.com with SMTP id d10so3470165eaj.37
        for <linux-scsi@vger.kernel.org>; Wed, 20 Nov 2013 01:37:55 -0800 (PST)
In-Reply-To: <1384932064-16870-1-git-send-email-Viswas.G@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Viswas G <Viswas.G@pmcs.com>
Cc: linux-scsi@vger.kernel.org, Vasanthalakshmi.Tharmarajan@pmcs.com, Suresh.Thiagarajan@pmcs.com

On 11/20/2013 08:21 AM, Viswas G wrote:
> Removed redundant code snipptes in pm8001_hwi.c
> and pm8001_ctl.c
> 
> Signed-off-by: Viswas G <Viswas.G@pmcs.com>
Looks good, thanks
Reviewed-by: Jack Wang <jinpu.wang@profitbricks.com>
> ---
>  drivers/scsi/pm8001/pm8001_ctl.c |   22 ++++++++--------------
>  drivers/scsi/pm8001/pm8001_hwi.c |    7 +------
>  2 files changed, 9 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
> index a04b4ff..1e055ae 100644
> --- a/drivers/scsi/pm8001/pm8001_ctl.c
> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> @@ -323,16 +323,13 @@ static ssize_t pm8001_ctl_ib_queue_log_show(struct device *cdev,
>  	int offset;
>  	char *str = buf;
>  	int start = 0;
> -#define IB_MEMMAP(c)		\
> -		(*(u32 *)((u8 *)pm8001_ha->		\
> -		memoryMap.region[IB].virt_ptr +		\
> +#define IB_MEMMAP(c)	\
> +		(*(u32 *)((u8 *)pm8001_ha->	\
> +		memoryMap.region[IB].virt_ptr +	\
>  		pm8001_ha->evtlog_ib_offset + (c)))
>  
>  	for (offset = 0; offset < IB_OB_READ_TIMES; offset++) {
> -		if (pm8001_ha->chip_id != chip_8001)
> -			str += sprintf(str, "0x%08x\n", IB_MEMMAP(start));
> -		else
> -			str += sprintf(str, "0x%08x\n", IB_MEMMAP(start));
> +		str += sprintf(str, "0x%08x\n", IB_MEMMAP(start));
>  		start = start + 4;
>  	}
>  	pm8001_ha->evtlog_ib_offset += SYSFS_OFFSET;
> @@ -363,16 +360,13 @@ static ssize_t pm8001_ctl_ob_queue_log_show(struct device *cdev,
>  	int offset;
>  	char *str = buf;
>  	int start = 0;
> -#define OB_MEMMAP(c)		\
> -		(*(u32 *)((u8 *)pm8001_ha->		\
> -		memoryMap.region[OB].virt_ptr +		\
> +#define OB_MEMMAP(c)	\
> +		(*(u32 *)((u8 *)pm8001_ha->	\
> +		memoryMap.region[OB].virt_ptr +	\
>  		pm8001_ha->evtlog_ob_offset + (c)))
>  
>  	for (offset = 0; offset < IB_OB_READ_TIMES; offset++) {
> -		if (pm8001_ha->chip_id != chip_8001)
> -			str += sprintf(str, "0x%08x\n", OB_MEMMAP(start));
> -		else
> -			str += sprintf(str, "0x%08x\n", OB_MEMMAP(start));
> +		str += sprintf(str, "0x%08x\n", OB_MEMMAP(start));
>  		start = start + 4;
>  	}
>  	pm8001_ha->evtlog_ob_offset += SYSFS_OFFSET;
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index b23f49d..f6ea277 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -5072,13 +5072,8 @@ pm8001_get_gsm_dump(struct device *cdev, u32 length, char* buf)
>  		direct_data += sprintf(direct_data, "%08x ", value);
>  	}
>  	/* Shift back to BAR4 original address */
> -	if (pm8001_ha->chip_id == chip_8001) {
> -		if (-1 == pm8001_bar4_shift(pm8001_ha, 0))
> +	if (-1 == pm8001_bar4_shift(pm8001_ha, 0))
>  			return 1;
> -	} else {
> -		if (-1 == pm80xx_bar4_shift(pm8001_ha, 0))
> -			return 1;
> -	}
>  	pm8001_ha->fatal_forensic_shift_offset += 1024;
>  
>  	if (pm8001_ha->fatal_forensic_shift_offset >= 0x100000)
> 

