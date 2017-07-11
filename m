From: Shivasharan Srikanteshwara
        <shivasharan.srikanteshwara@broadcom.com>
Subject: RE: [PATCH v2 09/15] megaraid_sas: use vmalloc for crash dump buffers
 and driver's local RAID map
Date: Tue, 11 Jul 2017 16:19:19 +0530
Message-ID: <d0a00c6f287c39a06b994b1f0517b4fa@mail.gmail.com>
References: <1499256029-16319-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1499256029-16319-10-git-send-email-shivasharan.srikanteshwara@broadcom.com> <172ecf69-15b3-b22f-fc14-93350a3b9964@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:33986 "EHLO
        mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932311AbdGKKtb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2017 06:49:31 -0400
Received: by mail-qk0-f175.google.com with SMTP id d78so97692243qkb.1
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2017 03:49:26 -0700 (PDT)
In-Reply-To: <172ecf69-15b3-b22f-fc14-93350a3b9964@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, hare@suse.com, hch@lst.de

> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com]
> Sent: Monday, July 10, 2017 7:15 PM
> To: Shivasharan S; linux-scsi@vger.kernel.org
> Cc: martin.petersen@oracle.com; jejb@linux.vnet.ibm.com;
> kashyap.desai@broadcom.com; sumit.saxena@broadcom.com;
> hare@suse.com; hch@lst.de
> Subject: Re: [PATCH v2 09/15] megaraid_sas: use vmalloc for crash dump
> buffers and driver's local RAID map
>
> On 5.7.2017 14:00, Shivasharan S wrote:
> > Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> > Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> > Reviewed-by: Hannes Reinecke <hare@suse.com>
> > ---
> >  drivers/scsi/megaraid/megaraid_sas.h        |   1 -
> >  drivers/scsi/megaraid/megaraid_sas_base.c   |  12 ++-
> >  drivers/scsi/megaraid/megaraid_sas_fusion.c | 121
> > ++++++++++++++++++----------
> >  3 files changed, 88 insertions(+), 46 deletions(-)
> >
> > diff --git a/drivers/scsi/megaraid/megaraid_sas.h
> > b/drivers/scsi/megaraid/megaraid_sas.h
> > index 2b209bb..6d9f111 100644
> > --- a/drivers/scsi/megaraid/megaraid_sas.h
> > +++ b/drivers/scsi/megaraid/megaraid_sas.h
> > @@ -2115,7 +2115,6 @@ struct megasas_instance {
> >  	u32 *crash_dump_buf;
> >  	dma_addr_t crash_dump_h;
> >  	void *crash_buf[MAX_CRASH_DUMP_SIZE];
> > -	u32 crash_buf_pages;
> >  	unsigned int    fw_crash_buffer_size;
> >  	unsigned int    fw_crash_state;
> >  	unsigned int    fw_crash_buffer_offset;
> > diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
> > b/drivers/scsi/megaraid/megaraid_sas_base.c
> > index e490272..c63ef88 100644
> > --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> > +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> > @@ -49,6 +49,7 @@
> >  #include <linux/blkdev.h>
> >  #include <linux/mutex.h>
> >  #include <linux/poll.h>
> > +#include <linux/vmalloc.h>
> >
> >  #include <scsi/scsi.h>
> >  #include <scsi/scsi_cmnd.h>
> > @@ -6672,9 +6673,14 @@ static void megasas_detach_one(struct pci_dev
> *pdev)
> >  						  fusion->max_map_sz,
> >  						  fusion->ld_map[i],
> >  						  fusion->ld_map_phys[i]);
> > -			if (fusion->ld_drv_map[i])
> > -				free_pages((ulong)fusion->ld_drv_map[i],
> > -					fusion->drv_map_pages);
> > +			if (fusion->ld_drv_map[i]) {
> > +				if (is_vmalloc_addr(fusion->ld_drv_map[i]))
> > +					vfree(fusion->ld_drv_map[i]);
> > +				else
> > +					free_pages((ulong)fusion-
> >ld_drv_map[i],
> > +						   fusion->drv_map_pages);
> > +			}
> > +
> >  			if (fusion->pd_seq_sync[i])
> >  				dma_free_coherent(&instance->pdev->dev,
> >  					pd_seq_map_sz,
> > diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > index c239762..ff4a3a8 100644
> > --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > @@ -1257,6 +1257,80 @@ static int
> > megasas_create_sg_sense_fusion(struct megasas_instance *instance)  }
> >
> >  /**
> > + * megasas_allocate_raid_maps -	Allocate memory for RAID maps
> > + * @instance:				Adapter soft state
> > + *
> > + * return:				if success: return 0
> > + *					failed:  return -ENOMEM
> > + */
> > +static inline int megasas_allocate_raid_maps(struct megasas_instance
> > +*instance) {
> > +	struct fusion_context *fusion;
> > +	int i = 0;
> > +
> > +	fusion = instance->ctrl_context;
> > +
> > +	fusion->drv_map_pages = get_order(fusion->drv_map_sz);
> > +
> > +	for (i = 0; i < 2; i++) {
> > +		fusion->ld_map[i] = NULL;
>
> Hi, does this assignment^ mean, that you need a fusion->ld_drv_map[0;1] =
> NULL setting before this for cycle as well or is it just superfluos ?
>
Hi Tomas,
Initializing ld_map[i] = NULL is not necessary but that got carried over
from
earlier code. We do not need to set fusion->ld_drv_map[0:1] to NULL here as
fusion_context is memset to zero during allocation.

>
> > +
> > +		fusion->ld_drv_map[i] = (void *)
> > +			__get_free_pages(__GFP_ZERO | GFP_KERNEL,
> > +					 fusion->drv_map_pages);
>
> The subject says - 'use vmalloc for ... and driver's local RAID map'
> in the code here you use vmalloc only if __get_free_pages fails is this
> intended ?
> (maybe an explanation in the mail body would be nice)
>
> tomash
>
I will send out v3 of the series with a more detailed commit description.
The use of __get_free_pages first for driver's local RAID map is intentional
as this
structure is frequently accessed. But we do not want to fail device probe
due
to unavailability of contiguous memory.

Thanks,
Shivasharan

> > +
> > +		if (!fusion->ld_drv_map[i]) {
> > +			fusion->ld_drv_map[i] = vzalloc(fusion->drv_map_sz);
> > +
> > +			if (!fusion->ld_drv_map[i]) {
> > +				dev_err(&instance->pdev->dev,
> > +					"Could not allocate memory for local
> map"
> > +					" size requested: %d\n",
> > +					fusion->drv_map_sz);
> > +				goto ld_drv_map_alloc_fail;
> > +			}
> > +		}
> > +	}
> > +
> > +	for (i = 0; i < 2; i++) {
> > +		fusion->ld_map[i] = dma_alloc_coherent(&instance->pdev-
> >dev,
> > +						       fusion->max_map_sz,
> > +						       &fusion->ld_map_phys[i],
> > +						       GFP_KERNEL);
> > +		if (!fusion->ld_map[i]) {
> > +			dev_err(&instance->pdev->dev,
> > +				"Could not allocate memory for map info
> %s:%d\n",
> > +				__func__, __LINE__);
> > +			goto ld_map_alloc_fail;
> > +		}
> > +	}
> > +
> > +	return 0;
> > +
> > +ld_map_alloc_fail:
> > +	for (i = 0; i < 2; i++) {
> > +		if (fusion->ld_map[i])
> > +			dma_free_coherent(&instance->pdev->dev,
> > +					  fusion->max_map_sz,
> > +					  fusion->ld_map[i],
> > +					  fusion->ld_map_phys[i]);
> > +	}
> > +
> > +ld_drv_map_alloc_fail:
> > +	for (i = 0; i < 2; i++) {
> > +		if (fusion->ld_drv_map[i]) {
> > +			if (is_vmalloc_addr(fusion->ld_drv_map[i]))
> > +				vfree(fusion->ld_drv_map[i]);
> > +			else
> > +				free_pages((ulong)fusion->ld_drv_map[i],
> > +					   fusion->drv_map_pages);
> > +		}
> > +	}
> > +
> > +	return -ENOMEM;
> > +}
> > +
> > +/**
> >   * megasas_init_adapter_fusion -	Initializes the FW
> >   * @instance:		Adapter soft state
> >   *
> > @@ -1375,45 +1449,14 @@ static int
> megasas_create_sg_sense_fusion(struct megasas_instance *instance)
> >  	instance->r1_ldio_hint_default =  MR_R1_LDIO_PIGGYBACK_DEFAULT;
> >  	fusion->fast_path_io = 0;
> >
> > -	fusion->drv_map_pages = get_order(fusion->drv_map_sz);
> > -	for (i = 0; i < 2; i++) {
> > -		fusion->ld_map[i] = NULL;
> > -		fusion->ld_drv_map[i] = (void
> *)__get_free_pages(GFP_KERNEL,
> > -			fusion->drv_map_pages);
> > -		if (!fusion->ld_drv_map[i]) {
> > -			dev_err(&instance->pdev->dev, "Could not allocate "
> > -				"memory for local map info for %d pages\n",
> > -				fusion->drv_map_pages);
> > -			if (i == 1)
> > -				free_pages((ulong)fusion->ld_drv_map[0],
> > -					fusion->drv_map_pages);
> > -			goto fail_ioc_init;
> > -		}
> > -		memset(fusion->ld_drv_map[i], 0,
> > -			((1 << PAGE_SHIFT) << fusion->drv_map_pages));
> > -	}
> > -
> > -	for (i = 0; i < 2; i++) {
> > -		fusion->ld_map[i] = dma_alloc_coherent(&instance->pdev-
> >dev,
> > -						       fusion->max_map_sz,
> > -						       &fusion->ld_map_phys[i],
> > -						       GFP_KERNEL);
> > -		if (!fusion->ld_map[i]) {
> > -			dev_err(&instance->pdev->dev, "Could not allocate
> memory "
> > -			       "for map info\n");
> > -			goto fail_map_info;
> > -		}
> > -	}
> > +	if (megasas_allocate_raid_maps(instance))
> > +		goto fail_ioc_init;
> >
> >  	if (!megasas_get_map_info(instance))
> >  		megasas_sync_map_info(instance);
> >
> >  	return 0;
> >
> > -fail_map_info:
> > -	if (i == 1)
> > -		dma_free_coherent(&instance->pdev->dev, fusion-
> >max_map_sz,
> > -				  fusion->ld_map[0], fusion->ld_map_phys[0]);
> >  fail_ioc_init:
> >  	megasas_free_cmds_fusion(instance);
> >  fail_alloc_cmds:
> > @@ -3365,17 +3408,13 @@ irqreturn_t megasas_isr_fusion(int irq, void
> > *devp)  {
> >  	unsigned int i;
> >
> > -	instance->crash_buf_pages = get_order(CRASH_DMA_BUF_SIZE);
> >  	for (i = 0; i < MAX_CRASH_DUMP_SIZE; i++) {
> > -		instance->crash_buf[i] = (void
> 	*)__get_free_pages(GFP_KERNEL,
> > -				instance->crash_buf_pages);
> > +		instance->crash_buf[i] = vzalloc(CRASH_DMA_BUF_SIZE);
> >  		if (!instance->crash_buf[i]) {
> >  			dev_info(&instance->pdev->dev, "Firmware crash dump
> "
> >  				"memory allocation failed at index %d\n", i);
> >  			break;
> >  		}
> > -		memset(instance->crash_buf[i], 0,
> > -			((1 << PAGE_SHIFT) << instance->crash_buf_pages));
> >  	}
> >  	instance->drv_buf_alloc = i;
> >  }
> > @@ -3387,12 +3426,10 @@ irqreturn_t megasas_isr_fusion(int irq, void
> > *devp)  void  megasas_free_host_crash_buffer(struct megasas_instance
> > *instance)  {
> > -	unsigned int i
> > -;
> > +	unsigned int i;
> >  	for (i = 0; i < instance->drv_buf_alloc; i++) {
> >  		if (instance->crash_buf[i])
> > -			free_pages((ulong)instance->crash_buf[i],
> > -					instance->crash_buf_pages);
> > +			vfree(instance->crash_buf[i]);
> >  	}
> >  	instance->drv_buf_index = 0;
> >  	instance->drv_buf_alloc = 0;
>
