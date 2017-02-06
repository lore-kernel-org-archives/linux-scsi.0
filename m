From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 08/39] megaraid_sas: megasas_get_request_descriptor always
 return valid desc
Date: Mon, 6 Feb 2017 15:06:19 +0100
Message-ID: <e17f9c02-4301-ddfe-aa64-17baf3d31110@redhat.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-9-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41090 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752757AbdBFOG1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 6 Feb 2017 09:06:27 -0500
In-Reply-To: <1486375212-17329-9-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com

On 6.2.2017 10:59, Shivasharan S wrote:
> No functional change. Code clean up. Removing error code which is not
> valid scenario.
>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>

I'm not sure if the part which replaces "return 0;"
with "return ->issue_dcmd" is an improvement - is there
any instance of issue_dcmd which returns anything else but a '0' ?
If not, make it a return void and have a tiny perf improvement.

Other than that I agree with Hannes, please divide this into two patches.

Tomas

> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c   |  4 +---
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 33 +++++------------------------
>  2 files changed, 6 insertions(+), 31 deletions(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 80fcdf5..138d028 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -5602,9 +5602,7 @@ megasas_register_aen(struct megasas_instance *instance, u32 seq_num,
>  	/*
>  	 * Issue the aen registration frame
>  	 */
> -	instance->instancet->issue_dcmd(instance, cmd);
> -
> -	return 0;
> +	return instance->instancet->issue_dcmd(instance, cmd);
>  }
>  
>  /**
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index d25268a..1ec482e 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -974,8 +974,7 @@ megasas_sync_pd_seq_num(struct megasas_instance *instance, bool pend) {
>  		dcmd->mbox.b[0] = MEGASAS_DCMD_MBOX_PEND_FLAG;
>  		dcmd->flags = cpu_to_le16(MFI_FRAME_DIR_WRITE);
>  		instance->jbod_seq_cmd = cmd;
> -		instance->instancet->issue_dcmd(instance, cmd);
> -		return 0;
> +		return instance->instancet->issue_dcmd(instance, cmd);
>  	}
>  
>  	dcmd->flags = cpu_to_le16(MFI_FRAME_DIR_READ);
> @@ -1115,7 +1114,7 @@ megasas_get_map_info(struct megasas_instance *instance)
>  int
>  megasas_sync_map_info(struct megasas_instance *instance)
>  {
> -	int ret = 0, i;
> +	int i;
>  	struct megasas_cmd *cmd;
>  	struct megasas_dcmd_frame *dcmd;
>  	u32 size_sync_info, num_lds;
> @@ -1182,9 +1181,7 @@ megasas_sync_map_info(struct megasas_instance *instance)
>  
>  	instance->map_update_cmd = cmd;
>  
> -	instance->instancet->issue_dcmd(instance, cmd);
> -
> -	return ret;
> +	return instance->instancet->issue_dcmd(instance, cmd);
>  }
>  
>  /*
> @@ -2438,18 +2435,12 @@ megasas_build_io_fusion(struct megasas_instance *instance,
>  	return 0;
>  }
>  
> -union MEGASAS_REQUEST_DESCRIPTOR_UNION *
> +static union MEGASAS_REQUEST_DESCRIPTOR_UNION *
>  megasas_get_request_descriptor(struct megasas_instance *instance, u16 index)
>  {
>  	u8 *p;
>  	struct fusion_context *fusion;
>  
> -	if (index >= instance->max_mpt_cmds) {
> -		dev_err(&instance->pdev->dev, "Invalid SMID (0x%x)request for "
> -		       "descriptor for scsi%d\n", index,
> -			instance->host->host_no);
> -		return NULL;
> -	}
>  	fusion = instance->ctrl_context;
>  	p = fusion->req_frames_desc +
>  		sizeof(union MEGASAS_REQUEST_DESCRIPTOR_UNION) * index;
> @@ -2959,7 +2950,7 @@ build_mpt_mfi_pass_thru(struct megasas_instance *instance,
>  union MEGASAS_REQUEST_DESCRIPTOR_UNION *
>  build_mpt_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
>  {
> -	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
> +	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc = NULL;
>  	u16 index;
>  
>  	if (build_mpt_mfi_pass_thru(instance, cmd)) {
> @@ -2971,9 +2962,6 @@ build_mpt_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
>  
>  	req_desc = megasas_get_request_descriptor(instance, index - 1);
>  
> -	if (!req_desc)
> -		return NULL;
> -
>  	req_desc->Words = 0;
>  	req_desc->SCSIIO.RequestFlags = (MPI2_REQ_DESCRIPT_FLAGS_SCSI_IO <<
>  					 MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
> @@ -2996,11 +2984,6 @@ megasas_issue_dcmd_fusion(struct megasas_instance *instance,
>  	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
>  
>  	req_desc = build_mpt_cmd(instance, cmd);
> -	if (!req_desc) {
> -		dev_info(&instance->pdev->dev, "Failed from %s %d\n",
> -					__func__, __LINE__);
> -		return DCMD_NOT_FIRED;
> -	}
>  
>  	megasas_fire_cmd_fusion(instance, req_desc);
>  	return DCMD_SUCCESS;
> @@ -3437,12 +3420,6 @@ megasas_issue_tm(struct megasas_instance *instance, u16 device_handle,
>  
>  	req_desc = megasas_get_request_descriptor(instance,
>  			(cmd_fusion->index - 1));
> -	if (!req_desc) {
> -		dev_err(&instance->pdev->dev, "Failed from %s %d\n",
> -			__func__, __LINE__);
> -		megasas_return_cmd(instance, cmd_mfi);
> -		return -ENOMEM;
> -	}
>  
>  	cmd_fusion->request_desc = req_desc;
>  	req_desc->Words = 0;
