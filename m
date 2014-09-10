From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 02/11] megaraid_sas : Use writeq for 64bit pci write to
 avoid spinlock overhead
Date: Wed, 10 Sep 2014 13:16:59 +0200
Message-ID: <5410332B.6080408@redhat.com>
References: <201409061328.s86DS4h1012830@palmhbs0.lsi.com> <540F0106.6090702@redhat.com> <d08422c17b133c7f5518ea008af62ddc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbaIJLSX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2014 07:18:23 -0400
In-Reply-To: <d08422c17b133c7f5518ea008af62ddc@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, aradford@gmail.com

On 09/10/2014 12:15 PM, Kashyap Desai wrote:
>> -----Original Message-----
>> From: Tomas Henzl [mailto:thenzl@redhat.com]
>> Sent: Tuesday, September 09, 2014 7:01 PM
>> To: Sumit.Saxena@avagotech.com; linux-scsi@vger.kernel.org
>> Cc: martin.petersen@oracle.com; hch@infradead.org;
>> jbottomley@parallels.com; kashyap.desai@avagotech.com;
>> aradford@gmail.com
>> Subject: Re: [PATCH 02/11] megaraid_sas : Use writeq for 64bit pci write
> to
>> avoid spinlock overhead
>>
>> On 09/06/2014 03:25 PM, Sumit.Saxena@avagotech.com wrote:
>>> Use writeq() for 64bit PCI write instead of writel() to avoid
> additional lock
>> overhead.
>>> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
>>> Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
>>> ---
>>>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 8 ++++++++
>>>  1 file changed, 8 insertions(+)
>>>
>>> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>>> b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>>> index 57b47fe..c69c1ac 100644
>>> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>>> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>>> @@ -1065,6 +1065,13 @@ megasas_fire_cmd_fusion(struct
>> megasas_instance *instance,
>>>  			u32 req_desc_hi,
>>>  			struct megasas_register_set __iomem *regs)
>> Hi Sumit,
>> the fn params are a bit confusing req_desc_lo is of type dma_addr_t and
>> req_desc_hi is u32, is it possible to unite it in the future?
> Agree. We should make changes here. We will do it in separate patch.
> Originally fire_cmd() was written for MFI controller and carry forward for
> all generation.
> In MFI it use second argument as 32 bit address  and third argument as
> frame count, but later in Fusion adapter it started using differently.

ok

>
>>>  {
>>> +#if defined(writeq) && defined(CONFIG_64BIT)
>> On a similar place mpt2sas(_base_writeq) uses only "#ifndef writeq"
>> if it's incorrect fix it there too or remove the CONFIG_64 here
> We would like to change at mpt2sas as we have all the code with below
> check for writeq()
> Original discuss was started when we submitted this change in mpt2sas, but
> we have delta from day-1.
> LSI/Avago internal source has "#if defined(writeq) &&
> defined(CONFIG_64BIT)" check in mpt2sas.
>
> I think now writeq() is implemented in all arch, so we can safely remove
> check for #if writeq().
> But we can keep this check as it is to continue for older Distribution to
> take direct advantage without maintaining any separate patch.

I don't know which combination of writeq and config_64bit is
the right way, I was hoping that someone who knows will help with.
(I'll accept almost any combination you'll post...)

>
>>> +	u64 req_data = 0;
>>> +
>>> +	req_data = req_desc_hi;
>>> +	req_data = ((req_data << 32) | (u32)req_desc_lo);
>> This seems to be critical path (you are removing an spinlock to avoid
>> overhead), so why do you have three consecutive assignments to the same
>> variable?
>> (~(u64 req_data = r_hi << 32 | r_lo))
>
> Agree. We will be doing this change and re-submit the patch to address
> this.

Thanks.

>
>> Cheers,
>> Tomas
>>
>>> +	writeq(le64_to_cpu(req_data), &(regs)-
>>> inbound_low_queue_port);
>>> +#else
>>>  	unsigned long flags;
>>>
>>>  	spin_lock_irqsave(&instance->hba_lock, flags); @@ -1072,6 +1079,7
>> @@
>>> megasas_fire_cmd_fusion(struct megasas_instance *instance,
>>>  	writel(le32_to_cpu(req_desc_lo), &(regs)-
>>> inbound_low_queue_port);
>>>  	writel(le32_to_cpu(req_desc_hi), &(regs)-
>>> inbound_high_queue_port);
>>>  	spin_unlock_irqrestore(&instance->hba_lock, flags);
>>> +#endif
>>>  }
>>>
>>>  /**
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

