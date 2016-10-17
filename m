From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/7] megaraid_sas: Send SYNCHRONIZE_CACHE command to
 firmware
Date: Mon, 17 Oct 2016 13:34:20 +0200
Message-ID: <d9e79049-b4ce-588f-263d-dad015b3368d@suse.de>
References: <1476699850-25083-1-git-send-email-sumit.saxena@broadcom.com>
 <1476699850-25083-5-git-send-email-sumit.saxena@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34036 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935113AbcJQLfQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 17 Oct 2016 07:35:16 -0400
In-Reply-To: <1476699850-25083-5-git-send-email-sumit.saxena@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com

On 10/17/2016 12:24 PM, Sumit Saxena wrote:
> megaraid_sas driver returns SYNCHRONIZE_CACHE command back to SCSI layer
> without sending it to firmware as firmware takes care of flushing cache.
> This patch will change the driver behavior wrt SYNCHRONIZE_CACHE handling.
> If underlying firmware has support to handle the SYNCHORNIZE_CACHE, driver
> will send it for firmware otherwise complete it back to SCSI layer with
> SUCCESS immediately.
> If  Firmware  handle SYNCHORNIZE_CACHE for both VD and JBOD
> "canHandleSyncCache" bit in scratch pad register(offset 0x00B4) will be
> set.
> 
> This behavior can be controlled via module parameter and user can fallback
> to old behavior of returning SYNCHRONIZE_CACHE by driver only without
> sending it to firmware.
> 
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas.h        |  3 +++
>  drivers/scsi/megaraid/megaraid_sas_base.c   | 14 ++++++--------
>  drivers/scsi/megaraid/megaraid_sas_fusion.c |  3 +++
>  drivers/scsi/megaraid/megaraid_sas_fusion.h |  2 ++
>  4 files changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
> index ca86c88..43fd14f 100644
> --- a/drivers/scsi/megaraid/megaraid_sas.h
> +++ b/drivers/scsi/megaraid/megaraid_sas.h
> @@ -1429,6 +1429,8 @@ enum FW_BOOT_CONTEXT {
>  #define MR_MAX_REPLY_QUEUES_EXT_OFFSET_SHIFT    14
>  #define MR_MAX_MSIX_REG_ARRAY                   16
>  #define MR_RDPQ_MODE_OFFSET			0X00800000
> +#define MR_CAN_HANDLE_SYNC_CACHE_OFFSET		0X01000000
> +
>  /*
>  * register set for both 1068 and 1078 controllers
>  * structure extended for 1078 registers
> @@ -2140,6 +2142,7 @@ struct megasas_instance {
>  	u8 is_imr;
>  	u8 is_rdpq;
>  	bool dev_handle;
> +	bool fw_sync_cache_support;
>  };
>  struct MR_LD_VF_MAP {
>  	u32 size;
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 092387f..a4a8e2f 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -104,6 +104,10 @@ unsigned int scmd_timeout = MEGASAS_DEFAULT_CMD_TIMEOUT;
>  module_param(scmd_timeout, int, S_IRUGO);
>  MODULE_PARM_DESC(scmd_timeout, "scsi command timeout (10-90s), default 90s. See megasas_reset_timer.");
>  
> +bool block_sync_cache;
> +module_param(block_sync_cache, bool, S_IRUGO);
> +MODULE_PARM_DESC(block_sync_cache, "Block SYNC CACHE by driver Default: 0(Send it to firmware)");
> +
>  MODULE_LICENSE("GPL");
>  MODULE_VERSION(MEGASAS_VERSION);
>  MODULE_AUTHOR("megaraidlinux.pdl@avagotech.com");
> @@ -1700,16 +1704,10 @@ megasas_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
>  		goto out_done;
>  	}
>  
> -	switch (scmd->cmnd[0]) {
> -	case SYNCHRONIZE_CACHE:
> -		/*
> -		 * FW takes care of flush cache on its own
> -		 * No need to send it down
> -		 */
> +	if ((scmd->cmnd[0] == SYNCHRONIZE_CACHE) &&
> +		(!instance->fw_sync_cache_support)) {
>  		scmd->result = DID_OK << 16;
>  		goto out_done;
> -	default:
> -		break;
>  	}
>  
>  	return instance->instancet->build_and_issue_cmd(instance, scmd);
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index 2159f6a..8237580 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -747,6 +747,9 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
>  		ret = 1;
>  		goto fail_fw_init;
>  	}
> +	if (!block_sync_cache)
> +		instance->fw_sync_cache_support = (scratch_pad_2 &
> +			MR_CAN_HANDLE_SYNC_CACHE_OFFSET) ? 1 : 0;
>  
>  	IOCInitMessage =
>  	  dma_alloc_coherent(&instance->pdev->dev,
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
> index e3bee04..2857154 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
> @@ -72,6 +72,8 @@
>  #define MPI2_SUP_REPLY_POST_HOST_INDEX_OFFSET   (0x0000030C)
>  #define MPI2_REPLY_POST_HOST_INDEX_OFFSET	(0x0000006C)
>  
> +extern bool block_sync_cache;
> +
>  /*
>   * Raid context flags
>   */
> 
Be extra careful with that.

SYNCHRONIZE_CACHE has (potentially) a global scope, as there might be an
array-wide cache, and a cache flush would affect the entire cache.
Linux is using SYNCHRONIZE_CACHE as a per device setting, ie it assumes
that the effects of a cache flush is restricted to the device in question.

If this is _not_ the case I'd rather not enable it.
Have you checked that enabling this functionality doesn't have negative
performance impact?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
