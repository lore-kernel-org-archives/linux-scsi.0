From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH RESEND 9/18] megaraid_sas : Support for Avago's Single
 server High Availability product
Date: Tue, 21 Apr 2015 18:24:27 +0530
Message-ID: <97df840ba986f1363e1199189601bac6@mail.gmail.com>
References: <201504201236.t3KCa2D0016595@palmhbs0.lsi.com> <55363DE4.2070506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:35883 "EHLO
	mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056AbbDUMy3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2015 08:54:29 -0400
Received: by qku63 with SMTP id 63so209586711qku.3
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2015 05:54:28 -0700 (PDT)
In-Reply-To: <55363DE4.2070506@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, Kashyap Desai <kashyap.desai@avagotech.com>

>-----Original Message-----
>From: Tomas Henzl [mailto:thenzl@redhat.com]
>Sent: Tuesday, April 21, 2015 5:39 PM
>To: Sumit.Saxena@avagotech.com; linux-scsi@vger.kernel.org
>Cc: martin.petersen@oracle.com; hch@infradead.org;
>jbottomley@parallels.com; kashyap.desai@avagotech.com
>Subject: Re: [PATCH RESEND 9/18] megaraid_sas : Support for Avago's
Single
>server High Availability product
>
>On 04/20/2015 02:33 PM, Sumit.Saxena@avagotech.com wrote:
>> This patch will add support for Single Server High Availability(SSHA)
cluster
>support.
>> Here is the short decsription of changes done to add support for SSHA-
>> 1) Host will send system's Unique ID based on DMI_PRODUCT_UUID to
>firmware.
>> 2) Toggle the devhandle in LDIO path for Remote LDs.
>>
>> Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
>> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
>>
>> ---
>>  drivers/scsi/megaraid/megaraid_sas.h        |   17 +++++++++++++++--
>>  drivers/scsi/megaraid/megaraid_sas_base.c   |   15 ++++++++++++++-
>>  drivers/scsi/megaraid/megaraid_sas_fusion.c |   20
>++++++++++++++++++++
>>  3 files changed, 49 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/megaraid/megaraid_sas.h
>> b/drivers/scsi/megaraid/megaraid_sas.h
>> index 680d90b..225d806 100644
>> --- a/drivers/scsi/megaraid/megaraid_sas.h
>> +++ b/drivers/scsi/megaraid/megaraid_sas.h
>> @@ -1272,8 +1272,10 @@ struct megasas_init_frame {
>>  	u32 queue_info_new_phys_addr_hi;	/*1Ch */
>>  	u32 queue_info_old_phys_addr_lo;	/*20h */
>>  	u32 queue_info_old_phys_addr_hi;	/*24h */
>> -
>> -	u32 reserved_4[6];	/*28h */
>> +	u32 reserved_4[2];	/*28h */
>> +	u32 system_info_lo;      /*30h */
>> +	u32 system_info_hi;      /*34h */
>> +	u32 reserved_5[2];	/*38h */
>>
>>  } __attribute__ ((packed));
>>
>> @@ -1650,12 +1652,22 @@ struct megasas_irq_context {
>>  	u32 MSIxIndex;
>>  };
>>
>> +struct MR_DRV_SYSTEM_INFO {
>> +	u8	infoVersion;
>> +	u8	systemIdLength;
>> +	u16	reserved0;
>> +	u8	systemId[64];
>> +	u8	reserved[1980];
>> +};
>> +
>>  struct megasas_instance {
>>
>>  	u32 *producer;
>>  	dma_addr_t producer_h;
>>  	u32 *consumer;
>>  	dma_addr_t consumer_h;
>> +	struct MR_DRV_SYSTEM_INFO *system_info_buf;
>> +	dma_addr_t system_info_h;
>>  	struct MR_LD_VF_AFFILIATION *vf_affiliation;
>>  	dma_addr_t vf_affiliation_h;
>>  	struct MR_LD_VF_AFFILIATION_111 *vf_affiliation_111; @@ -1770,6
>> +1782,7 @@ struct megasas_instance {
>>  	u16 throttlequeuedepth;
>>  	u8 mask_interrupts;
>>  	u8 is_imr;
>> +	bool dev_handle;
>>  };
>>  struct MR_LD_VF_MAP {
>>  	u32 size;
>> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>> b/drivers/scsi/megaraid/megaraid_sas_base.c
>> index 6c84f88..2424ab2 100644
>> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
>> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>> @@ -5246,6 +5246,13 @@ static int megasas_probe_one(struct pci_dev
>*pdev,
>>  		break;
>>  	}
>>
>> +	instance->system_info_buf = pci_alloc_consistent(pdev,
>> +					sizeof(struct
>MR_DRV_SYSTEM_INFO),
>> +					&instance->system_info_h);
>
>I haven't found the place where the driver send the information to
firmware,
>anyway weren't here a pci_zalloc_consistent better?

Yes, better to use pci_zalloc_consistent. Driver send this to
firmware(inside init_frame, this DMA address is passed)  in function -
megasas_ioc_init_fusion(). Please see below line-
 +		init_frame->system_info_lo = instance->system_info_h;

Sumit
>
>Tomas
>
>> +
>> +	if (!instance->system_info_buf)
>> +		dev_info(&instance->pdev->dev, "Can't allocate system info
>> +buffer\n");
>> +
>>  	/* Crash dump feature related initialisation*/
>>  	instance->drv_buf_index = 0;
>>  	instance->drv_buf_alloc = 0;
>> @@ -5673,8 +5680,10 @@ megasas_resume(struct pci_dev *pdev)
>>
&instance->sriov_heartbeat_timer,
>>
megasas_sriov_heartbeat_handler,
>>
>MEGASAS_SRIOV_HEARTBEAT_INTERVAL_VF);
>> -		else
>> +		else {
>>  			instance->skip_heartbeat_timer_del = 1;
>> +			goto fail_init_mfi;
>> +		}
>>  	}
>>
>>  	instance->instancet->enable_intr(instance);
>> @@ -5838,6 +5847,10 @@ static void megasas_detach_one(struct pci_dev
>*pdev)
>>  		pci_free_consistent(pdev, CRASH_DMA_BUF_SIZE,
>>  			    instance->crash_dump_buf, instance-
>>crash_dump_h);
>>
>> +	if (instance->system_info_buf)
>> +		pci_free_consistent(pdev, sizeof(struct
>MR_DRV_SYSTEM_INFO),
>> +				    instance->system_info_buf, instance-
>>system_info_h);
>> +
>>  	scsi_host_put(host);
>>
>>  	pci_disable_device(pdev);
>> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> index 9ce4813..59848e9 100644
>> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> @@ -53,6 +53,7 @@
>>  #include <scsi/scsi_device.h>
>>  #include <scsi/scsi_host.h>
>>  #include <scsi/scsi_dbg.h>
>> +#include <linux/dmi.h>
>>
>>  #include "megaraid_sas_fusion.h"
>>  #include "megaraid_sas.h"
>> @@ -609,6 +610,7 @@ megasas_ioc_init_fusion(struct megasas_instance
>*instance)
>>  	union MEGASAS_REQUEST_DESCRIPTOR_UNION req_desc;
>>  	int i;
>>  	struct megasas_header *frame_hdr;
>> +	const char *sys_info;
>>
>>  	fusion = instance->ctrl_context;
>>
>> @@ -671,6 +673,16 @@ megasas_ioc_init_fusion(struct megasas_instance
>*instance)
>>  	/* Convert capability to LE32 */
>>  	cpu_to_le32s((u32
>> *)&init_frame->driver_operations.mfi_capabilities);
>>
>> +	sys_info = dmi_get_system_info(DMI_PRODUCT_UUID);
>> +	if (instance->system_info_buf && sys_info) {
>> +		memcpy(instance->system_info_buf->systemId, sys_info,
>> +			strlen(sys_info) > 64 ? 64 : strlen(sys_info));
>> +		instance->system_info_buf->systemIdLength =
>> +			strlen(sys_info) > 64 ? 64 : strlen(sys_info);
>> +		init_frame->system_info_lo = instance->system_info_h;
>> +		init_frame->system_info_hi = 0;
>> +	}
>> +
>>  	init_frame->queue_info_new_phys_addr_hi =
>>  		cpu_to_le32(upper_32_bits(ioc_init_handle));
>>  	init_frame->queue_info_new_phys_addr_lo = @@ -1602,6 +1614,14
>@@
>> megasas_build_ldio_fusion(struct megasas_instance *instance,
>>  			cmd->pd_r1_lb = io_info.pd_after_lb;
>>  		} else
>>  			scp->SCp.Status &=
>~MEGASAS_LOAD_BALANCE_FLAG;
>> +
>> +		if ((raidLUN[0] == 1) &&
>> +			(local_map_ptr-
>>raidMap.devHndlInfo[io_info.pd_after_lb].validHandles > 2)) {
>> +			instance->dev_handle = !(instance->dev_handle);
>> +			io_info.devHandle =
>> +				local_map_ptr-
>>raidMap.devHndlInfo[io_info.pd_after_lb].devHandle[instance-
>>dev_handle];
>> +		}
>> +
>>  		cmd->request_desc->SCSIIO.DevHandle = io_info.devHandle;
>>  		io_request->DevHandle = io_info.devHandle;
>>  		/* populate the LUN field */
