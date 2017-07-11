From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v2 09/15] megaraid_sas: use vmalloc for crash dump buffers
 and driver's local RAID map
Date: Tue, 11 Jul 2017 15:21:04 +0200
Message-ID: <3a84b54e-0760-3517-b4fd-76b5fc3c3192@redhat.com>
References: <1499256029-16319-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1499256029-16319-10-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <172ecf69-15b3-b22f-fc14-93350a3b9964@redhat.com>
 <d0a00c6f287c39a06b994b1f0517b4fa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43308 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932467AbdGKNVI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 11 Jul 2017 09:21:08 -0400
In-Reply-To: <d0a00c6f287c39a06b994b1f0517b4fa@mail.gmail.com>
Content-Language: en-MW
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, hare@suse.com, hch@lst.de

On 11.7.2017 12:49, Shivasharan Srikanteshwara wrote:
>> -----Original Message-----
>> From: Tomas Henzl [mailto:thenzl@redhat.com]
>> Sent: Monday, July 10, 2017 7:15 PM
>> To: Shivasharan S; linux-scsi@vger.kernel.org
>> Cc: martin.petersen@oracle.com; jejb@linux.vnet.ibm.com;
>> kashyap.desai@broadcom.com; sumit.saxena@broadcom.com;
>> hare@suse.com; hch@lst.de
>> Subject: Re: [PATCH v2 09/15] megaraid_sas: use vmalloc for crash dump
>> buffers and driver's local RAID map
>>
>> On 5.7.2017 14:00, Shivasharan S wrote:
>>> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
>>> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
>>> Reviewed-by: Hannes Reinecke <hare@suse.com>
>>> ---
>>>  drivers/scsi/megaraid/megaraid_sas.h        |   1 -
>>>  drivers/scsi/megaraid/megaraid_sas_base.c   |  12 ++-
>>>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 121
>>> ++++++++++++++++++----------
>>>  3 files changed, 88 insertions(+), 46 deletions(-)
>>>
>>> diff --git a/drivers/scsi/megaraid/megaraid_sas.h
>>> b/drivers/scsi/megaraid/megaraid_sas.h
>>> index 2b209bb..6d9f111 100644
>>> --- a/drivers/scsi/megaraid/megaraid_sas.h
>>> +++ b/drivers/scsi/megaraid/megaraid_sas.h
>>> @@ -2115,7 +2115,6 @@ struct megasas_instance {
>>>  	u32 *crash_dump_buf;
>>>  	dma_addr_t crash_dump_h;
>>>  	void *crash_buf[MAX_CRASH_DUMP_SIZE];
>>> -	u32 crash_buf_pages;
>>>  	unsigned int    fw_crash_buffer_size;
>>>  	unsigned int    fw_crash_state;
>>>  	unsigned int    fw_crash_buffer_offset;
>>> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>>> b/drivers/scsi/megaraid/megaraid_sas_base.c
>>> index e490272..c63ef88 100644
>>> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
>>> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>>> @@ -49,6 +49,7 @@
>>>  #include <linux/blkdev.h>
>>>  #include <linux/mutex.h>
>>>  #include <linux/poll.h>
>>> +#include <linux/vmalloc.h>
>>>
>>>  #include <scsi/scsi.h>
>>>  #include <scsi/scsi_cmnd.h>
>>> @@ -6672,9 +6673,14 @@ static void megasas_detach_one(struct pci_dev
>> *pdev)
>>>  						  fusion->max_map_sz,
>>>  						  fusion->ld_map[i],
>>>  						  fusion->ld_map_phys[i]);
>>> -			if (fusion->ld_drv_map[i])
>>> -				free_pages((ulong)fusion->ld_drv_map[i],
>>> -					fusion->drv_map_pages);
>>> +			if (fusion->ld_drv_map[i]) {
>>> +				if (is_vmalloc_addr(fusion->ld_drv_map[i]))
>>> +					vfree(fusion->ld_drv_map[i]);
>>> +				else
>>> +					free_pages((ulong)fusion-
>>> ld_drv_map[i],
>>> +						   fusion->drv_map_pages);
>>> +			}
>>> +
>>>  			if (fusion->pd_seq_sync[i])
>>>  				dma_free_coherent(&instance->pdev->dev,
>>>  					pd_seq_map_sz,
>>> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>>> b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>>> index c239762..ff4a3a8 100644
>>> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>>> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>>> @@ -1257,6 +1257,80 @@ static int
>>> megasas_create_sg_sense_fusion(struct megasas_instance *instance)  }
>>>
>>>  /**
>>> + * megasas_allocate_raid_maps -	Allocate memory for RAID maps
>>> + * @instance:				Adapter soft state
>>> + *
>>> + * return:				if success: return 0
>>> + *					failed:  return -ENOMEM
>>> + */
>>> +static inline int megasas_allocate_raid_maps(struct megasas_instance
>>> +*instance) {
>>> +	struct fusion_context *fusion;
>>> +	int i = 0;
>>> +
>>> +	fusion = instance->ctrl_context;
>>> +
>>> +	fusion->drv_map_pages = get_order(fusion->drv_map_sz);
>>> +
>>> +	for (i = 0; i < 2; i++) {
>>> +		fusion->ld_map[i] = NULL;
>> Hi, does this assignment^ mean, that you need a fusion->ld_drv_map[0;1] =
>> NULL setting before this for cycle as well or is it just superfluos ?
>>
> Hi Tomas,
> Initializing ld_map[i] = NULL is not necessary but that got carried over
> from
> earlier code. We do not need to set fusion->ld_drv_map[0:1] to NULL here as
> fusion_context is memset to zero during allocation.
>
>>> +
>>> +		fusion->ld_drv_map[i] = (void *)
>>> +			__get_free_pages(__GFP_ZERO | GFP_KERNEL,
>>> +					 fusion->drv_map_pages);
>> The subject says - 'use vmalloc for ... and driver's local RAID map'
>> in the code here you use vmalloc only if __get_free_pages fails is this
>> intended ?
>> (maybe an explanation in the mail body would be nice)
>>
>> tomash
>>
> I will send out v3 of the series with a more detailed commit description.
> The use of __get_free_pages first for driver's local RAID map is intentional
> as this
> structure is frequently accessed. But we do not want to fail device probe
> due
> to unavailability of contiguous memory.

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

tomash
