From: James Smart <jsmart2021@gmail.com>
Subject: Re: [PATCH v3 04/13] lpfc: Add push-to-adapter support to sli4
Date: Fri, 16 Feb 2018 08:53:44 -0800
Message-ID: <e1da721e-8ec4-9e57-9fb2-9141514e8785@gmail.com>
References: <20180213193457.21206-1-jsmart2021@gmail.com>
 <20180213193457.21206-5-jsmart2021@gmail.com>
 <20180214093052.eywwbg36gjnfirnz@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:40853 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161532AbeBPQxt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Feb 2018 11:53:49 -0500
Received: by mail-pl0-f67.google.com with SMTP id g18so1972518plo.7
        for <linux-scsi@vger.kernel.org>; Fri, 16 Feb 2018 08:53:49 -0800 (PST)
In-Reply-To: <20180214093052.eywwbg36gjnfirnz@linux-x5ow.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-scsi@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 2/14/2018 1:30 AM, Johannes Thumshirn wrote:
> On Tue, Feb 13, 2018 at 11:34:48AM -0800, James Smart wrote:
> [...]
>> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
>> index 3bff1f9c5df7..5e03b2c969e5 100644
>> --- a/drivers/scsi/lpfc/lpfc_sli.c
>> +++ b/drivers/scsi/lpfc/lpfc_sli.c
>> @@ -35,6 +35,9 @@
>>   #include <scsi/scsi_transport_fc.h>
>>   #include <scsi/fc/fc_fs.h>
>>   #include <linux/aer.h>
>> +#ifdef CONFIG_X86
>> +#include <asm/set_memory.h>
>> +#endif
> 
> Not needed anymore now you've killed set_memory_wc(), isn't it?

Agree... but, we've done more timing and it turns out the ioremap_wc() 
on X86 isn't behaving quite the same as set_memory_wc().  Works, but 
it's actually slower. I think ioremap_wc() is additionally making it 
cacheable, which seems to be delaying the postings to the io bus (even 
if wc) until the memory barrier. While the set_memory_wc() seems to 
flush as soon as the cacheline is filled.

Given everything we've seen so far - I'm going back to using 
set_memory_wc() as it's the fastest latency option we've measured.


> 
> [...]
> 
>> +	if (q->dpp_enable && q->phba->cfg_enable_dpp) {
>> +		/* write to DPP aperture taking advatage of Combined Writes */
>> +		tmp = (uint8_t *)wqe;
>> +#ifdef CONFIG_64BIT
>> +		for (i = 0; i < q->entry_size; i += sizeof(uint64_t))
>> +			writeq(*((uint64_t *)(tmp + i)), q->dpp_regaddr + i);
>> +#else
>> +		for (i = 0; i < q->entry_size; i += sizeof(uint32_t))
>> +			writel(*((uint32_t *)(tmp + i)), q->dpp_regaddr + i);
>> +#endif
>> +	}
>> +	/* ensure WQE bcopy and DPP flushed before doorbell write */
> 
> Any reason you can't use writeq() on 32 Bit as well? There's a compat version
> in linux/io-64-nonatomic-hi-lo.h.

We actually ran into issues on the existence of writeq() on a 32bit 
platform. Thus this code block.

-- james
