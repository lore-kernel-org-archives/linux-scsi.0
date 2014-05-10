From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH] pm80xx : Fix missing NULL pointer checks and memory leaks
Date: Sat, 10 May 2014 21:04:12 +0200
Message-ID: <536E782C.2090702@redhat.com>
References: <1399615261-15932-1-git-send-email-Suresh.Thiagarajan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbaEJTEW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 May 2014 15:04:22 -0400
In-Reply-To: <1399615261-15932-1-git-send-email-Suresh.Thiagarajan@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>, linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, JBottomley@parallels.com, Vasanthalakshmi.Tharmarajan@pmcs.com, Viswas.G@pmcs.com

On 05/09/2014 08:01 AM, Suresh Thiagarajan wrote:
> Checking return value for the memory allocattion and freeing it
> while exiting the function

The fix seems fine to me.
Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

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

