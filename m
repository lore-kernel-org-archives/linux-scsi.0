From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH] pm80xx : Fix missing NULL pointer checks and memory leaks
Date: Mon, 12 May 2014 10:08:46 +0200
Message-ID: <5370818E.4070601@gmail.com>
References: <1399615261-15932-1-git-send-email-Suresh.Thiagarajan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:56985 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbaELII4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 May 2014 04:08:56 -0400
Received: by mail-ee0-f48.google.com with SMTP id e49so4336985eek.21
        for <linux-scsi@vger.kernel.org>; Mon, 12 May 2014 01:08:54 -0700 (PDT)
In-Reply-To: <1399615261-15932-1-git-send-email-Suresh.Thiagarajan@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com, Vasanthalakshmi.Tharmarajan@pmcs.com, Viswas.G@pmcs.com

On 05/09/2014 08:01 AM, Suresh Thiagarajan wrote:
> Checking return value for the memory allocattion and freeing it
> while exiting the function
> 
> Signed-off-by: Viswas G <Viswas.G@pmcs.com>
> Signed-off-by: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
> ---
>  drivers/scsi/pm8001/pm8001_ctl.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
> index 28b4e81..5f68571 100644
> --- a/drivers/scsi/pm8001/pm8001_ctl.c
> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> @@ -395,6 +395,8 @@ static ssize_t pm8001_ctl_bios_version_show(struct device *cdev,
>  	payload.offset = 0;
>  	payload.length = 4096;
>  	payload.func_specific = kzalloc(4096, GFP_KERNEL);
> +	if (!payload.func_specific)
> +		return -ENOMEM;
>  	PM8001_CHIP_DISP->get_nvmd_req(pm8001_ha, &payload);
>  	wait_for_completion(&completion);
>  	virt_addr = pm8001_ha->memoryMap.region[NVMD].virt_ptr;
> @@ -402,6 +404,7 @@ static ssize_t pm8001_ctl_bios_version_show(struct device *cdev,
>  		bios_index++)
>  		str += sprintf(str, "%c",
>  			*((u8 *)((u8 *)virt_addr+bios_index)));
> +	kfree(payload.func_specific);
>  	return str - buf;
>  }
>  static DEVICE_ATTR(bios_version, S_IRUGO, pm8001_ctl_bios_version_show, NULL);
> 
Thanks, looks good.
Acked-by: Jack Wang <xjtuwjp@gmail.com>
