From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v3 2/5] arcmsr: fixes not release allocated resource
Date: Thu, 26 Nov 2015 14:08:02 +0100
Message-ID: <56570432.40500@redhat.com>
References: <1448451683.4670.35.camel@Centos6.3-64> <5655BDBD.404@redhat.com>
 <1448523150.4724.23.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1448523150.4724.23.camel@Centos6.3-64>
Sender: linux-kernel-owner@vger.kernel.org
To: Ching Huang <ching2048@areca.com.tw>
Cc: hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.de, jthumshirn@suse.de, hch@lst.de
List-Id: linux-scsi@vger.kernel.org

On 26.11.2015 08:32, Ching Huang wrote:
> On Wed, 2015-11-25 at 14:55 +0100, Tomas Henzl wrote:
>> On 25.11.2015 12:41, Ching Huang wrote:
>>> From: Ching Huang <ching2048@areca.com.tw>
>>>
>>> Releasing allocated resource if get configuration data failed.
>>>
>>> Signed-of-by: Ching Huang <ching2048@areca.com.tw>
>>>
>>> ---
>>>
>>> diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
>>> --- a/drivers/scsi/arcmsr/arcmsr_hba.c	2015-11-24 11:35:26.000000000 +0800
>>> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2015-11-25 19:04:44.590970000 +0800
>>> @@ -2664,7 +2664,7 @@ static bool arcmsr_hbaB_get_config(struc
>>>  	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
>>>  		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
>>>  			miscellaneous data' timeout \n", acb->host->host_no);
>>> -		return false;
>>> +		goto err_free_dma;
>>>  	}
>>>  	count = 8;
>>>  	while (count){
>>> @@ -2707,6 +2707,10 @@ static bool arcmsr_hbaB_get_config(struc
>>>  	acb->firm_cfg_version = readl(&reg->message_rwbuffer[25]);  /*firm_cfg_version,25,100-103*/
>>>  	/*firm_ide_channels,4,16-19*/
>>>  	return true;
>>> +err_free_dma:
>>> +	dma_free_coherent(&acb->pdev->dev, acb->roundup_ccbsize,
>>> +			acb->dma_coherent2, acb->dma_coherent_handle2);
>>> +	return false;
>>>  }
>>>  
>> The resource should be released here, that is okay. 
>>
>> How works the resource management when the eh_bus_reset_handler
>> is called ? It looks to me that you allocate a new 
>> acb->dma_coherent2 without releasing it before.
>> Btw. is it needed in that handler to re-read the firmware-spec?
>>
>> Tomas
>>
> You are right. In eh_bus_reset_handler, there may re-allocate a new dma resource if call get_config again.
> I will initiate a new patches for this bug after current 5 patches.
> Thanks Tomas.

ok, so for this patch -

Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Tomas
