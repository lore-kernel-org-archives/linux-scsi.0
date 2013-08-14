From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
Subject: RE: [PATCH] [SCSI] mpt3sas: Added a driver module parameter
 max_msix_vectors
Date: Wed, 14 Aug 2013 21:08:05 +0530
Message-ID: <DCD177647606E9419ED923E0C8C4AA723006D280C2@inbmail02.lsi.com>
References: <20130814125320.GA3402@lsi.com> <520B9F99.1000003@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:55287
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758380Ab3HNPiO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Aug 2013 11:38:14 -0400
In-Reply-To: <520B9F99.1000003@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: "jejb@kernel.org" <jejb@kernel.org>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>

Hi Tomas,

The crash happens when the kernel couldn't allocate the DMA'able memory that the driver requests for Reply Descriptor post queue. The amount of memory allocated is directly proportional to the HBA queue depth and the number of MSI-X vectors. 

The indirect fix for this issue is to add a module parameter max_msix_vectors to the driver. Using this module parameter the max number of MSI-X vectors could be set. The amount of memory that is allocated could be decreased by reducing the number of MSI-X vectors. Therefore if a crash is seen on a system due to the memory allocation failure, then max_queue_depth and the max_msix_vectors could be set to a lower value during driver load time so that the memory requested by the driver is less and thereby preventing the kernel crash.

So, lower  the value of this variable 'max_msix_vectors' only if  kernel couldn't allocate the DMA'able memory that the driver requests for and crash is observed.

Regards,
Sreekanth

>-----Original Message-----
>From: Tomas Henzl [mailto:thenzl@redhat.com]
>Sent: Wednesday, August 14, 2013 8:48 PM
>To: Reddy, Sreekanth
>Cc: jejb@kernel.org; JBottomley@Parallels.com; linux-scsi@vger.kernel.org;
>Nandigama, Nagalakshmi
>Subject: Re: [PATCH] [SCSI] mpt3sas: Added a driver module parameter
>max_msix_vectors
>
>On 08/14/2013 02:53 PM, Sreekanth Reddy wrote:
>> Added a driver module parameter max_msix_vectors. Using this module
>> parameter the maximum number of MSI-X vectors could be set.
>>
>> The number of MSI-X vectors used would be the minimum of MSI-X vectors
>> supported by the HBA, the number of CPU cores and the value set to
>max_msix_vectors module parameter.
>>
>> The default value of this module parameter is set to 8. The default
>> value of this parameter is set to 8 inorder to reduce the amount of memory
>required for Reply Descriptor Post queue.
>> This is because with the higher MSI-X vectors, some times kernel is
>> not able to allocate the requested amount of memory and crash is
>> observed. To overcome this problem, the default value is set to 8.
>
>Hi Sreekanth,
>I don't know exactly which allocation fails, but wouldn't be for the user better
>to just try to allocate and only when it fails lower the msi-x vectors count?
>Tomas
>
>>
>> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
>> ---
>>
>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c
>> b/drivers/scsi/mpt3sas/mpt3sas_base.c
>> index a32d63b..d40ba0b 100644
>> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
>> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
>> @@ -82,6 +82,10 @@ static int msix_disable = -1;
>> module_param(msix_disable, int, 0);  MODULE_PARM_DESC(msix_disable,
>"
>> disable msix routed interrupts (default=0)");
>>
>> +static int max_msix_vectors = 8;
>> +module_param(max_msix_vectors, int, 0);
>> +MODULE_PARM_DESC(max_msix_vectors,
>> +	" max msix vectors - (default=8)");
>>
>>  static int mpt3sas_fwfault_debug;
>>  MODULE_PARM_DESC(mpt3sas_fwfault_debug,
>> @@ -1723,6 +1727,16 @@ _base_enable_msix(struct MPT3SAS_ADAPTER
>*ioc)
>>  	ioc->reply_queue_count = min_t(int, ioc->cpu_count,
>>  	    ioc->msix_vector_count);
>>
>> +	printk(MPT3SAS_FMT "MSI-X vectors supported: %d, no of cores"
>> +	  ": %d, max_msix_vectors: %d\n", ioc->name, ioc-
>>msix_vector_count,
>> +	  ioc->cpu_count, max_msix_vectors);
>> +
>> +	if (max_msix_vectors > 0) {
>> +		ioc->reply_queue_count = min_t(int, max_msix_vectors,
>> +			ioc->reply_queue_count);
>> +		ioc->msix_vector_count = ioc->reply_queue_count;
>> +	}
>> +
>>  	entries = kcalloc(ioc->reply_queue_count, sizeof(struct msix_entry),
>>  	    GFP_KERNEL);
>>  	if (!entries) {
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
>> in the body of a message to majordomo@vger.kernel.org More majordomo
>> info at  http://vger.kernel.org/majordomo-info.html
>


