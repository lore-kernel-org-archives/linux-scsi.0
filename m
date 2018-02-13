From: James Smart <jsmart2021@gmail.com>
Subject: Re: [PATCH v2 04/13] lpfc: Add push-to-adapter support to sli4
Date: Tue, 13 Feb 2018 09:37:35 -0800
Message-ID: <b55fd2fc-7b10-e39c-8212-aeccadbb99a5@gmail.com>
References: <20180207022851.11800-1-jsmart2021@gmail.com>
 <20180207022851.11800-5-jsmart2021@gmail.com>
 <20180207095157.zejjbq6a7eeqmosx@linux-x5ow.site>
 <20180207102759.qzzqleujqhxnenna@linux-x5ow.site>
 <871shpo2fu.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:54685 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965217AbeBMRhm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Feb 2018 12:37:42 -0500
Received: by mail-it0-f66.google.com with SMTP id k131so12028484ith.4
        for <linux-scsi@vger.kernel.org>; Tue, 13 Feb 2018 09:37:42 -0800 (PST)
In-Reply-To: <871shpo2fu.fsf@concordia.ellerman.id.au>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Ellerman <mpe@ellerman.id.au>, Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-scsi@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>, Mark Rutland <mark.rutland@arm.com>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>

On 2/12/2018 9:59 PM, Michael Ellerman wrote:
> Johannes Thumshirn <jthumshirn@suse.de> writes:
> 
>> On Wed, Feb 07, 2018 at 10:51:57AM +0100, Johannes Thumshirn wrote:
>>>> +			/* Enable combined writes for DPP aperture */
>>>> +			pg_addr = (unsigned long)(wq->dpp_regaddr) & PAGE_MASK;
>>>> +#ifdef CONFIG_X86
>>>> +			rc = set_memory_wc(pg_addr, 1);
>>>> +			if (rc) {
>>>> +				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
>>>> +						"3272 Cannot setup Combined "
>>>> +						"Write on WQ[%d] - disable DPP\n",
>>>> +						wq->queue_id);
>>>> +				phba->cfg_enable_dpp = 0;
>>>> +			}
>>>> +#else
>>>> +			phba->cfg_enable_dpp = 0;
>>>> +#endif
>>>> +		} else
>>>> +			wq->db_regaddr = phba->sli4_hba.WQDBregaddr;
>>>
>>> I don't really like the set_memory_wc() call here. Neither do I like the ifdef
>>> CONFIG_X86 special casing.
>>>
>>> If you really need write combining, can't you at least use ioremap_wc()?
>>
>> Coming back to this again (after talking to our ARM/POWER folks internally).
>> Is this really x86 specific here? I know there are servers with other architectures
>> using lpfcs out there.
>>
>> I _think_ write combining should be possible on other architectures (that have
>> PCIe and aren't dead) as well.
>>
>> The ioremap_wc() I suggested is probably wrong.
>>
>> So can you please revisit this? I CCed Mark and Michael, maybe they can help
>> here.
> 
> I'm not much of an I/O guy, but I do know that on powerpc we don't
> implement set_memory_wc(). So if you're using that then you do need the
> ifdef.
> 
> I couldn't easily find the rest of this thread, so I'm not sure if
> ioremap_wc() is an option. We do implement that and on modern CPUs at
> least it will give you something that's not just a plain uncached
> mapping.

I went back and looked at things.  It does appear that we should be 
using ioremap_wc().  There's a pci routine that wrappers it, but as 
we're already are using the other routines in the wrapper, it's not very 
interesting.   Ioremap_wc seems to be supported pretty much anywhere, 
with platforms managing what it resolves to. Granted, some platforms 
may not do write combining but will relax the caching aspects (as 
Michael indicates).

The interesting thing is - when wc is truly on, we see a substantial 
difference. But in cases where wc isn't on and we perform the individual 
writes plus the flush before the doorbell write to synchronize things, 
it turns out it takes longer than if we don't use the feature. So, in 
cases where we don't have real wc, I'm going to turn it off. Based on 
what we've tested so far (includes ppc p8), we'll be leaving it enabled 
on X86 only.

-- james
