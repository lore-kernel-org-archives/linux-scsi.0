From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH V2 04/10] pm80xx: Display controller BIOS version
Date: Thu, 26 Sep 2013 08:50:51 +0200
Message-ID: <5243D94B.3000903@gmail.com>
References: <5243C715.70901@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:54707 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846Ab3IZGum (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Sep 2013 02:50:42 -0400
Received: by mail-ee0-f45.google.com with SMTP id c50so298539eek.4
        for <linux-scsi@vger.kernel.org>; Wed, 25 Sep 2013 23:50:41 -0700 (PDT)
In-Reply-To: <5243C715.70901@pmc-sierra.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anand <anandkumar_santhanam@pmc-sierra.com>
Cc: linux-scsi@vger.kernel.org, Sangeetha.Gnanasekaran@pmcs.com, Nikith.Ganigarakoppal@pmcs.com, Viswas.G@pmcs.com

On 09/26/2013 07:33 AM, Anand wrote:
> From 851461e0998c46ac15fb6eac6e14843e50e9714b Mon Sep 17 00:00:00 2001
> From: Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>
> Date: Wed, 18 Sep 2013 12:54:41 +0530
> Subject: [PATCH V2 04/10] pm80xx: Display controller BIOS version.
> 
> Signed-off-by: Anandkumar.Santhanam@pmcs.com
> 
As I know no all controller with BIOS support, but it's fine to have this.

Reviewed-by: Jack Wang <jinpu.wang@profitbricks.com>
> ---
>  drivers/scsi/pm8001/pm8001_ctl.c |   34 ++++++++++++++++++++++++++++++++++
>  drivers/scsi/pm8001/pm8001_ctl.h |    2 ++
>  2 files changed, 36 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
> index d99f41c..5a19e19 100644
> --- a/drivers/scsi/pm8001/pm8001_ctl.c
> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> @@ -309,6 +309,39 @@ static ssize_t pm8001_ctl_aap_log_show(struct device *cdev,
>  }
>  static DEVICE_ATTR(aap_log, S_IRUGO, pm8001_ctl_aap_log_show, NULL);
>  /**
> + * pm8001_ctl_bios_version_show - Bios version Display
> + * @cdev:pointer to embedded class device
> + * @buf:the buffer returned
> + * A sysfs 'read-only' shost attribute.
> + */
> +static ssize_t pm8001_ctl_bios_version_show(struct device *cdev,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct Scsi_Host *shost = class_to_shost(cdev);
> +	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
> +	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
> +	char *str = buf;
> +	void *virt_addr;
> +	int bios_index;
> +	DECLARE_COMPLETION_ONSTACK(completion);
> +	struct pm8001_ioctl_payload payload;
> +
> +	pm8001_ha->nvmd_completion = &completion;
> +	payload.minor_function = 7;
> +	payload.offset = 0;
> +	payload.length = 4096;
> +	payload.func_specific = kzalloc(4096, GFP_KERNEL);
> +	PM8001_CHIP_DISP->get_nvmd_req(pm8001_ha, &payload);
> +	wait_for_completion(&completion);
> +	virt_addr = pm8001_ha->memoryMap.region[NVMD].virt_ptr;
> +	for (bios_index = BIOSOFFSET; bios_index < BIOS_OFFSET_LIMIT;
> +		bios_index++)
> +		str += sprintf(str, "%c",
> +			*((u8 *)((u8 *)virt_addr+bios_index)));
> +	return str - buf;
> +}
> +static DEVICE_ATTR(bios_version, S_IRUGO, pm8001_ctl_bios_version_show, NULL);
> +/**
>   * pm8001_ctl_aap_log_show - IOP event log
>   * @cdev: pointer to embedded class device
>   * @buf: the buffer returned
> @@ -609,6 +642,7 @@ struct device_attribute *pm8001_host_attrs[] = {
>  	&dev_attr_sas_spec_support,
>  	&dev_attr_logging_level,
>  	&dev_attr_host_sas_address,
> +	&dev_attr_bios_version,
>  	NULL,
>  };
>  
> diff --git a/drivers/scsi/pm8001/pm8001_ctl.h b/drivers/scsi/pm8001/pm8001_ctl.h
> index 63ad4aa..c6d8fdd 100644
> --- a/drivers/scsi/pm8001/pm8001_ctl.h
> +++ b/drivers/scsi/pm8001/pm8001_ctl.h
> @@ -45,6 +45,8 @@
>  #define HEADER_LEN			28
>  #define SIZE_OFFSET			16
>  
> +#define BIOSOFFSET			56
> +#define BIOS_OFFSET_LIMIT		61
>  
>  #define FLASH_OK                        0x000000
>  #define FAIL_OPEN_BIOS_FILE             0x000100
> 

