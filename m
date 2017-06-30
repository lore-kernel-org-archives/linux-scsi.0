From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 09/15] megaraid_sas: use vmalloc for crash dump buffers
 and driver's local RAID map
Date: Fri, 30 Jun 2017 16:30:40 +0200
Message-ID: <c4a74546-20d3-7dcd-4e7b-2071d18b6c9c@redhat.com>
References: <1498811409-11157-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1498811409-11157-10-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45478 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751560AbdF3Oao (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Jun 2017 10:30:44 -0400
In-Reply-To: <1498811409-11157-10-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Language: en-MW
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de

On 30.6.2017 10:30, Shivasharan S wrote:
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas.h        |   1 -
>  drivers/scsi/megaraid/megaraid_sas_base.c   |  12 ++-
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 113 +++++++++++++++++-----------
>  3 files changed, 80 insertions(+), 46 deletions(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
> index 2b209bb..6d9f111 100644
> --- a/drivers/scsi/megaraid/megaraid_sas.h
> +++ b/drivers/scsi/megaraid/megaraid_sas.h
> @@ -2115,7 +2115,6 @@ struct megasas_instance {
>  	u32 *crash_dump_buf;
>  	dma_addr_t crash_dump_h;
>  	void *crash_buf[MAX_CRASH_DUMP_SIZE];
> -	u32 crash_buf_pages;
>  	unsigned int    fw_crash_buffer_size;
>  	unsigned int    fw_crash_state;
>  	unsigned int    fw_crash_buffer_offset;
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index e490272..c63ef88 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -49,6 +49,7 @@
>  #include <linux/blkdev.h>
>  #include <linux/mutex.h>
>  #include <linux/poll.h>
> +#include <linux/vmalloc.h>
>  
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_cmnd.h>
> @@ -6672,9 +6673,14 @@ static void megasas_detach_one(struct pci_dev *pdev)
>  						  fusion->max_map_sz,
>  						  fusion->ld_map[i],
>  						  fusion->ld_map_phys[i]);
> -			if (fusion->ld_drv_map[i])
> -				free_pages((ulong)fusion->ld_drv_map[i],
> -					fusion->drv_map_pages);
> +			if (fusion->ld_drv_map[i]) {
> +				if (is_vmalloc_addr(fusion->ld_drv_map[i]))
> +					vfree(fusion->ld_drv_map[i]);
> +				else
> +					free_pages((ulong)fusion->ld_drv_map[i],
> +						   fusion->drv_map_pages);
> +			}
> +
>  			if (fusion->pd_seq_sync[i])
>  				dma_free_coherent(&instance->pdev->dev,
>  					pd_seq_map_sz,
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index c239762..2f5212d 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -1257,6 +1257,72 @@ megasas_display_intel_branding(struct megasas_instance *instance)
>  }
>  
>  /**
> + * megasas_allocate_raid_maps -	Allocate memory for RAID maps
> + * @instance:				Adapter soft state
> + *
> + * return:				if success: return 0
> + *					failed:  return -ENOMEM
> + */
> +static inline int megasas_allocate_raid_maps(struct megasas_instance *instance)
> +{
> +	struct fusion_context *fusion;
> +	int i = 0;
> +
> +	fusion = instance->ctrl_context;
> +
> +	fusion->drv_map_pages = get_order(fusion->drv_map_sz);
> +
> +	for (i = 0; i < 2; i++) {
> +		fusion->ld_map[i] = NULL;
> +
> +		fusion->ld_drv_map[i] = (void *)
> +			__get_free_pages(__GFP_ZERO | GFP_KERNEL,
> +					 fusion->drv_map_pages);
> +
> +		if (!fusion->ld_drv_map[i]) {
> +			fusion->ld_drv_map[i] = vzalloc(fusion->drv_map_sz);
> +
> +			if (!fusion->ld_drv_map[i]) {
> +				dev_err(&instance->pdev->dev,
> +					"Could not allocate memory for local map"
> +					" size requested: %d\n",
> +					fusion->drv_map_sz);
> +
> +				if (fusion->ld_drv_map[0]) {
> +					if (is_vmalloc_addr(fusion->ld_drv_map[0]))
> +						vfree(fusion->ld_drv_map[0]);
> +					else
> +						free_pages((ulong)fusion->ld_drv_map[0],
> +							   fusion->drv_map_pages);
> +				}
> +				return -ENOMEM;
> +			}
> +		}
> +	}
> +
> +	for (i = 0; i < 2; i++) {
> +		fusion->ld_map[i] = dma_alloc_coherent(&instance->pdev->dev,
> +						       fusion->max_map_sz,
> +						       &fusion->ld_map_phys[i],
> +						       GFP_KERNEL);
> +		if (!fusion->ld_map[i]) {
> +			dev_err(&instance->pdev->dev,
> +				"Could not allocate memory for map info %s:%d\n",
> +				__func__, __LINE__);
> +
> +			if (fusion->ld_map[0])
> +				dma_free_coherent(&instance->pdev->dev,
> +						  fusion->max_map_sz,
> +						  fusion->ld_map[0],
> +						  fusion->ld_map_phys[0]);

Hi Shivasharan,
isn't a fusion->ld_drv_map clean up missing here ?
tomash

> +			return -ENOMEM;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +/**
>   * megasas_init_adapter_fusion -	Initializes the FW
>   * @instance:		Adapter soft state
>   *
> @@ -1375,45 +1441,14 @@ megasas_init_adapter_fusion(struct megasas_instance *instance)
>  	instance->r1_ldio_hint_default =  MR_R1_LDIO_PIGGYBACK_DEFAULT;
>  	fusion->fast_path_io = 0;
>  
> -	fusion->drv_map_pages = get_order(fusion->drv_map_sz);
> -	for (i = 0; i < 2; i++) {
> -		fusion->ld_map[i] = NULL;
> -		fusion->ld_drv_map[i] = (void *)__get_free_pages(GFP_KERNEL,
> -			fusion->drv_map_pages);
> -		if (!fusion->ld_drv_map[i]) {
> -			dev_err(&instance->pdev->dev, "Could not allocate "
> -				"memory for local map info for %d pages\n",
> -				fusion->drv_map_pages);
> -			if (i == 1)
> -				free_pages((ulong)fusion->ld_drv_map[0],
> -					fusion->drv_map_pages);
> -			goto fail_ioc_init;
> -		}
> -		memset(fusion->ld_drv_map[i], 0,
> -			((1 << PAGE_SHIFT) << fusion->drv_map_pages));
> -	}
> -
> -	for (i = 0; i < 2; i++) {
> -		fusion->ld_map[i] = dma_alloc_coherent(&instance->pdev->dev,
> -						       fusion->max_map_sz,
> -						       &fusion->ld_map_phys[i],
> -						       GFP_KERNEL);
> -		if (!fusion->ld_map[i]) {
> -			dev_err(&instance->pdev->dev, "Could not allocate memory "
> -			       "for map info\n");
> -			goto fail_map_info;
> -		}
> -	}
> +	if (megasas_allocate_raid_maps(instance))
> +		goto fail_ioc_init;
>  
>  	if (!megasas_get_map_info(instance))
>  		megasas_sync_map_info(instance);
>  
>  	return 0;
>  
> -fail_map_info:
> -	if (i == 1)
> -		dma_free_coherent(&instance->pdev->dev, fusion->max_map_sz,
> -				  fusion->ld_map[0], fusion->ld_map_phys[0]);
>  fail_ioc_init:
>  	megasas_free_cmds_fusion(instance);
>  fail_alloc_cmds:
> @@ -3365,17 +3400,13 @@ megasas_alloc_host_crash_buffer(struct megasas_instance *instance)
>  {
>  	unsigned int i;
>  
> -	instance->crash_buf_pages = get_order(CRASH_DMA_BUF_SIZE);
>  	for (i = 0; i < MAX_CRASH_DUMP_SIZE; i++) {
> -		instance->crash_buf[i] = (void	*)__get_free_pages(GFP_KERNEL,
> -				instance->crash_buf_pages);
> +		instance->crash_buf[i] = vzalloc(CRASH_DMA_BUF_SIZE);
>  		if (!instance->crash_buf[i]) {
>  			dev_info(&instance->pdev->dev, "Firmware crash dump "
>  				"memory allocation failed at index %d\n", i);
>  			break;
>  		}
> -		memset(instance->crash_buf[i], 0,
> -			((1 << PAGE_SHIFT) << instance->crash_buf_pages));
>  	}
>  	instance->drv_buf_alloc = i;
>  }
> @@ -3387,12 +3418,10 @@ megasas_alloc_host_crash_buffer(struct megasas_instance *instance)
>  void
>  megasas_free_host_crash_buffer(struct megasas_instance *instance)
>  {
> -	unsigned int i
> -;
> +	unsigned int i;
>  	for (i = 0; i < instance->drv_buf_alloc; i++) {
>  		if (instance->crash_buf[i])
> -			free_pages((ulong)instance->crash_buf[i],
> -					instance->crash_buf_pages);
> +			vfree(instance->crash_buf[i]);
>  	}
>  	instance->drv_buf_index = 0;
>  	instance->drv_buf_alloc = 0;
