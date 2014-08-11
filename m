From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH] pm8001: Update nvmd response data to request buffer
Date: Mon, 11 Aug 2014 12:59:39 +0200
Message-ID: <53E8A21B.8030906@redhat.com>
References: <1407738035-3327-1-git-send-email-Suresh.Thiagarajan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbaHKK7u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Aug 2014 06:59:50 -0400
In-Reply-To: <1407738035-3327-1-git-send-email-Suresh.Thiagarajan@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>, linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, JBottomley@parallels.com, Viswas.G@pmcs.com, pmchba@pmcs.com

On 08/11/2014 08:20 AM, Suresh Thiagarajan wrote:
> Instead of using the virt_ptr use request buffer for copying
> back the nvmd response data and use the same in request function also

Patch looks good to me

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

> Signed-off-by: Suresh Thiagarajan <suresh.thiagarajan@pmcs.com>
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
> ---
>  drivers/scsi/pm8001/pm8001_ctl.c |    4 +---
>  drivers/scsi/pm8001/pm8001_hwi.c |    8 ++++++++
>  2 files changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
> index d3a08ae..e871a14 100644
> --- a/drivers/scsi/pm8001/pm8001_ctl.c
> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> @@ -385,7 +385,6 @@ static ssize_t pm8001_ctl_bios_version_show(struct device *cdev,
>  	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
>  	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
>  	char *str = buf;
> -	void *virt_addr;
>  	int bios_index;
>  	DECLARE_COMPLETION_ONSTACK(completion);
>  	struct pm8001_ioctl_payload payload;
> @@ -402,11 +401,10 @@ static ssize_t pm8001_ctl_bios_version_show(struct device *cdev,
>  		return -ENOMEM;
>  	}
>  	wait_for_completion(&completion);
> -	virt_addr = pm8001_ha->memoryMap.region[NVMD].virt_ptr;
>  	for (bios_index = BIOSOFFSET; bios_index < BIOS_OFFSET_LIMIT;
>  		bios_index++)
>  		str += sprintf(str, "%c",
> -			*((u8 *)((u8 *)virt_addr+bios_index)));
> +			*(payload.func_specific+bios_index));
>  	kfree(payload.func_specific);
>  	return str - buf;
>  }
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index 1738310..fd4f507 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -3132,6 +3132,7 @@ void pm8001_mpi_set_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
>  void
>  pm8001_mpi_get_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
>  {
> +	struct fw_control_ex    *fw_control_context;
>  	struct get_nvm_data_resp *pPayload =
>  		(struct get_nvm_data_resp *)(piomb + 4);
>  	u32 tag = le32_to_cpu(pPayload->tag);
> @@ -3140,6 +3141,7 @@ pm8001_mpi_get_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
>  	u32 ir_tds_bn_dps_das_nvm =
>  		le32_to_cpu(pPayload->ir_tda_bn_dps_das_nvm);
>  	void *virt_addr = pm8001_ha->memoryMap.region[NVMD].virt_ptr;
> +	fw_control_context = ccb->fw_control_context;
>  
>  	PM8001_MSG_DBG(pm8001_ha, pm8001_printk("Get nvm data complete!\n"));
>  	if ((dlen_status & NVMD_STAT) != 0) {
> @@ -3180,6 +3182,12 @@ pm8001_mpi_get_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
>  			pm8001_printk("Get NVMD success, IR=0, dataLen=%d\n",
>  			(dlen_status & NVMD_LEN) >> 24));
>  	}
> +	/* Though fw_control_context is freed below, usrAddr still needs
> +	 * to be updated as this holds the response to the request function
> +	 */
> +	memcpy(fw_control_context->usrAddr,
> +		pm8001_ha->memoryMap.region[NVMD].virt_ptr,
> +		fw_control_context->len);
>  	kfree(ccb->fw_control_context);
>  	ccb->task = NULL;
>  	ccb->ccb_tag = 0xFFFFFFFF;

