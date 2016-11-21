From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 5/5] megaraid_sas: add mmio barrier after register writes
Date: Mon, 21 Nov 2016 16:57:16 +0100
Message-ID: <3c317f7a-f82e-a531-1056-ead1ec7eda5a@redhat.com>
References: <1478857492-4581-1-git-send-email-hare@suse.de>
 <1478857492-4581-6-git-send-email-hare@suse.de>
 <5f6fcc3e-a48f-7909-c409-1d265ea9135c@redhat.com>
 <67e94cdd16a9f55f3a73a12a13330ed0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47782 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753882AbcKUP5T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Nov 2016 10:57:19 -0500
In-Reply-To: <67e94cdd16a9f55f3a73a12a13330ed0@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Sumit Saxena <sumit.saxena@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 18.11.2016 17:48, Kashyap Desai wrote:
>> -----Original Message-----
>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>> owner@vger.kernel.org] On Behalf Of Tomas Henzl
>> Sent: Friday, November 18, 2016 9:23 PM
>> To: Hannes Reinecke; Martin K. Petersen
>> Cc: Christoph Hellwig; James Bottomley; Sumit Saxena; linux-
>> scsi@vger.kernel.org; Hannes Reinecke
>> Subject: Re: [PATCH 5/5] megaraid_sas: add mmio barrier after register
> writes
>> On 11.11.2016 10:44, Hannes Reinecke wrote:
>>> The megaraid_sas HBA only has a single register for I/O submission,
>>> which will be hit pretty hard with scsi-mq. To ensure that the PCI
>>> writes have made it across we need to add a mmio barrier after each
>>> write; otherwise I've been seeing spurious command completions and I/O
>>> stalls.
>> Why is it needed that the PCI write reaches the hw exactly at this
> point?
>> Is it possible that this is a hw deficiency like that the hw can't
> handle
>> communication without tiny pauses, and so possible to remove in next
>> generation?
>> Thanks,
>> Tomas
> I think this is good to have mmiowb as we are already doing  for writel()
> version of megasas_return_cmd_fusion.
> May be not for x86, but for some other CPU arch it is useful. I think it
> become more evident while scs-mq support for more than one submission
> queue patch of Hannes expose this issue.
>
> Probably this patch is good. Intermediate PCI device (PCI bridge ?)  may
> cache PCI packet and eventually out of order PCI packet to MegaRAID HBA
> can cause this type of spurious completion.

Usually drivers do not add a write barrier after every pci write, unless
like here in megasas_fire_cmd_fusion in the 32bit part where are two paired writes
and it must be ensured that the pair arrives without any other write in between.

Why is it wrong when a pci write is overtaken by another write or when happens
a bit later and if it is wrong - don't we need an additional locking too ?
The execution of  megasas_fire_cmd_fusion might be interrupted and a delay 
can happen at any time.

tomash

>
>>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>>> ---
>>>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>>> b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>>> index aba53c0..729a654 100644
>>> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>>> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>>> @@ -196,6 +196,7 @@ inline void megasas_return_cmd_fusion(struct
>> megasas_instance *instance,
>>>  			le32_to_cpu(req_desc->u.low));
>>>
>>>  	writeq(req_data, &instance->reg_set->inbound_low_queue_port);
>>> +	mmiowb();
>>>  #else
>>>  	unsigned long flags;
>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of
>> a message to majordomo@vger.kernel.org More majordomo info at
>> http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


