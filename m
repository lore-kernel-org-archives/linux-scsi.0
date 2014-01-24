From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH 4/6] megaraid_sas: catch errors from
 megasas_get_map_info()
Date: Fri, 24 Jan 2014 08:35:48 +0000
Message-ID: <10fbc3a4068e49be9b0d7d896e68ebc7@BN1PR07MB247.namprd07.prod.outlook.com>
References: <1389867936-118685-1-git-send-email-hare@suse.de>
 <1389867936-118685-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2lp0237.outbound.protection.outlook.com ([207.46.163.237]:45220
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752109AbaAXIfw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jan 2014 03:35:52 -0500
In-Reply-To: <1389867936-118685-5-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Adam Radford <aradford@gmail.com>

Hannes,

This patch really not required, since MR controller can still operate even if ld map info is failed.
We just disable Fast Path IO if LD map info is failed, so we can still continue without ld map.

This patch is not required for megaraid_sas driver.


` Kashyap

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Thursday, January 16, 2014 3:56 PM
> To: James Bottomley
> Cc: linux-scsi@vger.kernel.org; Hannes Reinecke; Desai, Kashyap; Adam
> Radford
> Subject: [PATCH 4/6] megaraid_sas: catch errors from
> megasas_get_map_info()
> 
> megasas_get_map_info() might fail, after which it'll be pointless to call
> megasas_sync_map_info().
> So update megasas_get_map_info() to correctly handle errors and call
> megasas_sync_map_info() only if no error occurred.
> 
> Cc: Kashyap Desai <kashyap.desai@lsi.com>
> Cc: Adam Radford <aradford@gmail.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c   |  5 ++--
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 41 ++++++++++++++++------
> -------
>  2 files changed, 26 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
> b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 95d4e5c..d17a097 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -4689,8 +4689,9 @@ megasas_resume(struct pci_dev *pdev)
>  			megasas_free_cmds_fusion(instance);
>  			goto fail_init_mfi;
>  		}
> -		if (!megasas_get_map_info(instance))
> -			megasas_sync_map_info(instance);
> +		if (megasas_get_map_info(instance) < 0)
> +			goto fail_init_mfi;
> +		megasas_sync_map_info(instance);
>  	}
>  	break;
>  	default:
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index 5c30f9d..be6de80 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -773,15 +773,16 @@ u8
>  megasas_get_map_info(struct megasas_instance *instance)  {
>  	struct fusion_context *fusion = instance->ctrl_context;
> +	int rc;
> 
>  	fusion->fast_path_io = 0;
> -	if (!megasas_get_ld_map_info(instance)) {
> -		if (MR_ValidateMapInfo(instance)) {
> -			fusion->fast_path_io = 1;
> -			return 0;
> -		}
> -	}
> -	return 1;
> +	rc = megasas_get_ld_map_info(instance);
> +	if (rc < 0)
> +		return rc;
> +
> +	if (MR_ValidateMapInfo(instance))
> +		fusion->fast_path_io = 1;
> +	return 0;
>  }
> 
>  /*
> @@ -807,6 +808,14 @@ megasas_sync_map_info(struct megasas_instance
> *instance)
>  	dma_addr_t ci_h = 0;
>  	u32 size_map_info;
> 
> +	fusion = instance->ctrl_context;
> +	if (!fusion)
> +		return -ENXIO;
> +
> +	if (!fusion->fast_path_io)
> +		return 0;
> +
> +
>  	cmd = megasas_get_cmd(instance);
> 
>  	if (!cmd) {
> @@ -815,13 +824,6 @@ megasas_sync_map_info(struct megasas_instance
> *instance)
>  		return -ENOMEM;
>  	}
> 
> -	fusion = instance->ctrl_context;
> -
> -	if (!fusion) {
> -		megasas_return_cmd(instance, cmd);
> -		return 1;
> -	}
> -
>  	map = fusion->ld_map[instance->map_id & 1];
> 
>  	num_lds = le32_to_cpu(map->raidMap.ldCount);
> @@ -1030,8 +1032,10 @@ megasas_init_adapter_fusion(struct
> megasas_instance *instance)
>  		}
>  	}
> 
> -	if (!megasas_get_map_info(instance))
> -		megasas_sync_map_info(instance);
> +	if (megasas_get_map_info(instance) < 0)
> +		goto fail_map_info;
> +
> +	megasas_sync_map_info(instance);
> 
>  	return 0;
> 
> @@ -2457,8 +2461,9 @@ int megasas_reset_fusion(struct Scsi_Host *shost)
>  			       sizeof(struct LD_LOAD_BALANCE_INFO)
>  			       *MAX_LOGICAL_DRIVES);
> 
> -			if (!megasas_get_map_info(instance))
> -				megasas_sync_map_info(instance);
> +			if (megasas_get_map_info(instance) < 0)
> +				break;
> +			megasas_sync_map_info(instance);
> 
>  			/* Adapter reset completed successfully */
>  			printk(KERN_WARNING "megaraid_sas: Reset "
> --
> 1.7.12.4
> 

