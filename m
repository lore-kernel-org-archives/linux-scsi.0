From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH] megaraid_sas : Pass driver version to firmware inside IOC
 init frame
Date: Fri, 12 Jun 2015 12:05:52 +0530
Message-ID: <1566c5d9687140d625b18a4ea751a912@mail.gmail.com>
References: <201506101028.t5AASaRN030984@palmhbs0.lsi.com> <5579936C.6010002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:36330 "EHLO
	mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbbFLGfz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jun 2015 02:35:55 -0400
Received: by qkx62 with SMTP id 62so13299626qkx.3
        for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2015 23:35:54 -0700 (PDT)
In-Reply-To: <5579936C.6010002@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, Kashyap Desai <kashyap.desai@avagotech.com>

>-----Original Message-----
>From: Tomas Henzl [mailto:thenzl@redhat.com]
>Sent: Thursday, June 11, 2015 7:26 PM
>To: Sumit.Saxena@avagotech.com; linux-scsi@vger.kernel.org
>Cc: martin.petersen@oracle.com; hch@infradead.org;
>jbottomley@parallels.com; kashyap.desai@avagotech.com
>Subject: Re: [PATCH] megaraid_sas : Pass driver version to firmware
inside
>IOC init frame
>
>On 06/10/2015 12:22 PM, Sumit.Saxena@avagotech.com wrote:
>
>Here should be an explanation why is this needed.
>
>The driver knows the fw version and can adapt to it.
>When sending the version to firmware fails, the driver just logs it and
is able to
>continue.
>Why is the information needed for the fw ?

Intent here is to have driver version string in firmware logs and it can
help to align driver and firmware logs during debugging. One of Avago's
customer has requested driver version to be displayed in firmware logs.
This code has been part of inhouse driver for long time but was missed to
be submitted to upstream. Since this is helpful for debugging not a fatal
in functional area so if memory allocation for version buffer fails still
driver continues.

>
>I fear that after several iterations we will have a table of
corresponding
>driver/fw versions that driver will send down to fw make it work...
>
>Tomas
>
>
>> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
>> ---
>>  drivers/scsi/megaraid/megaraid_sas.h        |   10 +++++++---
>>  drivers/scsi/megaraid/megaraid_sas_base.c   |   18 ++++++++++++++++++
>>  drivers/scsi/megaraid/megaraid_sas_fusion.c |    7 +++++++
>>  3 files changed, 32 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/megaraid/megaraid_sas.h
>> b/drivers/scsi/megaraid/megaraid_sas.h
>> index 20c3754..5bd4d30 100644
>> --- a/drivers/scsi/megaraid/megaraid_sas.h
>> +++ b/drivers/scsi/megaraid/megaraid_sas.h
>> @@ -1038,6 +1038,7 @@ struct megasas_ctrl_info {
>>  #define MEGASAS_MAX_LD_IDS
>	(MEGASAS_MAX_LD_CHANNELS * \
>>
>	MEGASAS_MAX_DEV_PER_CHANNEL)
>>
>> +#define MEGASAS_MAX_NAME                        32
>>  #define MEGASAS_MAX_SECTORS                    (2*1024)
>>  #define MEGASAS_MAX_SECTORS_IEEE		(2*128)
>>  #define MEGASAS_DBG_LVL				1
>> @@ -1264,17 +1265,18 @@ struct megasas_init_frame {
>>  	__le32 pad_0;		/*0Ch */
>>
>>  	__le16 flags;		/*10h */
>> -	__le16 reserved_3;		/*12h */
>> +	__le16 reserved_2;		/*12h */
>>  	__le32 data_xfer_len;	/*14h */
>>
>>  	__le32 queue_info_new_phys_addr_lo;	/*18h */
>>  	__le32 queue_info_new_phys_addr_hi;	/*1Ch */
>>  	__le32 queue_info_old_phys_addr_lo;	/*20h */
>>  	__le32 queue_info_old_phys_addr_hi;	/*24h */
>> -	__le32 reserved_4[2];	/*28h */
>> +	__le32 driver_ver_lo;      /*28h */
>> +	__le32 driver_ver_hi;      /*2Ch */
>>  	__le32 system_info_lo;      /*30h */
>>  	__le32 system_info_hi;      /*34h */
>> -	__le32 reserved_5[2];	/*38h */
>> +	__le32 reserved_3[2];	/*38h */
>>
>>  } __attribute__ ((packed));
>>
>> @@ -1665,6 +1667,8 @@ struct megasas_instance {
>>  	dma_addr_t producer_h;
>>  	__le32 *consumer;
>>  	dma_addr_t consumer_h;
>> +	__le32 *verbuf;
>> +	dma_addr_t verbuf_h;
>>  	struct MR_DRV_SYSTEM_INFO *system_info_buf;
>>  	dma_addr_t system_info_h;
>>  	struct MR_LD_VF_AFFILIATION *vf_affiliation; diff --git
>> a/drivers/scsi/megaraid/megaraid_sas_base.c
>> b/drivers/scsi/megaraid/megaraid_sas_base.c
>> index a022c39..6bfb3eb 100644
>> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
>> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>> @@ -4252,6 +4252,14 @@ megasas_issue_init_mfi(struct megasas_instance
>> *instance)
>>
>>  	init_frame->cmd = MFI_CMD_INIT;
>>  	init_frame->cmd_status = MFI_STAT_INVALID_STATUS;
>> +
>> +	if (instance->verbuf) {
>> +		snprintf((char *)instance->verbuf,
>strlen(MEGASAS_VERSION) + 2, "%s\n",
>> +			MEGASAS_VERSION);
>> +		init_frame->driver_ver_lo = cpu_to_le32(instance-
>>verbuf_h);
>> +		init_frame->driver_ver_hi = 0;
>> +	}
>> +
>>  	init_frame->queue_info_new_phys_addr_lo =
>>  		cpu_to_le32(lower_32_bits(initq_info_h));
>>  	init_frame->queue_info_new_phys_addr_hi = @@ -5257,6 +5265,12
>@@
>> static int megasas_probe_one(struct pci_dev *pdev,
>>  		break;
>>  	}
>>
>> +	instance->verbuf = pci_alloc_consistent(pdev,
>> +						MEGASAS_MAX_NAME *
>sizeof(u32),
>> +						&instance->verbuf_h);
>> +	if (!instance->verbuf)
>> +		dev_info(&instance->pdev->dev, "Can't allocate version
>buffer\n");
>> +
>>  	instance->system_info_buf = pci_zalloc_consistent(pdev,
>>  					sizeof(struct
>MR_DRV_SYSTEM_INFO),
>>  					&instance->system_info_h);
>> @@ -5838,6 +5852,10 @@ static void megasas_detach_one(struct pci_dev
>*pdev)
>>  		pci_free_consistent(pdev, sizeof(struct
>MR_DRV_SYSTEM_INFO),
>>  				    instance->system_info_buf, instance-
>>system_info_h);
>>
>> +	if (instance->verbuf)
>> +		pci_free_consistent(pdev, MEGASAS_MAX_NAME *
>sizeof(u32),
>> +				instance->verbuf, instance->verbuf_h);
>> +
>>  	scsi_host_put(host);
>>
>>  	pci_disable_device(pdev);
>> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> index 0637f42..359d605 100644
>> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> @@ -671,6 +671,13 @@ megasas_ioc_init_fusion(struct megasas_instance
>*instance)
>>  	/* Convert capability to LE32 */
>>  	cpu_to_le32s((u32
>> *)&init_frame->driver_operations.mfi_capabilities);
>>
>> +	if (instance->verbuf) {
>> +		snprintf((char *)instance->verbuf,
>strlen(MEGASAS_VERSION) + 2, "%s\n",
>> +			MEGASAS_VERSION);
>> +		init_frame->driver_ver_lo = cpu_to_le32(instance-
>>verbuf_h);
>> +		init_frame->driver_ver_hi = 0;
>> +	}
>> +
>>  	sys_info = dmi_get_system_info(DMI_PRODUCT_UUID);
>>  	if (instance->system_info_buf && sys_info) {
>>  		memcpy(instance->system_info_buf->systemId, sys_info,
>>
