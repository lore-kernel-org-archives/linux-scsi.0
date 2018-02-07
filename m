From: James Smart <jsmart2021@gmail.com>
Subject: Re: [PATCH v2 04/13] lpfc: Add push-to-adapter support to sli4
Date: Wed, 7 Feb 2018 07:42:27 -0800
Message-ID: <d10b5cc0-b1b6-7f36-37fb-e9e40a77ba6d@gmail.com>
References: <20180207022851.11800-1-jsmart2021@gmail.com>
 <20180207022851.11800-5-jsmart2021@gmail.com>
 <20180207095157.zejjbq6a7eeqmosx@linux-x5ow.site>
 <20180207102759.qzzqleujqhxnenna@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:33588 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754091AbeBGPma (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Feb 2018 10:42:30 -0500
Received: by mail-ot0-f195.google.com with SMTP id q9so1194094oti.0
        for <linux-scsi@vger.kernel.org>; Wed, 07 Feb 2018 07:42:30 -0800 (PST)
In-Reply-To: <20180207102759.qzzqleujqhxnenna@linux-x5ow.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-scsi@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>, Michael Ellerman <mpe@ellerman.id.au>, Mark Rutland <mark.rutland@arm.com>James Smart <james.smart@broadcom.com>

On 2/7/2018 2:27 AM, Johannes Thumshirn wrote:
> On Wed, Feb 07, 2018 at 10:51:57AM +0100, Johannes Thumshirn wrote:
>>> +			/* Enable combined writes for DPP aperture */
>>> +			pg_addr = (unsigned long)(wq->dpp_regaddr) & PAGE_MASK;
>>> +#ifdef CONFIG_X86
>>> +			rc = set_memory_wc(pg_addr, 1);
>>> +			if (rc) {
>>> +				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
>>> +						"3272 Cannot setup Combined "
>>> +						"Write on WQ[%d] - disable DPP\n",
>>> +						wq->queue_id);
>>> +				phba->cfg_enable_dpp = 0;
>>> +			}
>>> +#else
>>> +			phba->cfg_enable_dpp = 0;
>>> +#endif
>>> +		} else
>>> +			wq->db_regaddr = phba->sli4_hba.WQDBregaddr;
>>
>> I don't really like the set_memory_wc() call here. Neither do I like the ifdef
>> CONFIG_X86 special casing.
>>
>> If you really need write combining, can't you at least use ioremap_wc()?
> 
> Coming back to this again (after talking to our ARM/POWER folks internally).
> Is this really x86 specific here? I know there are servers with other architectures
> using lpfcs out there.
> 
> I _think_ write combining should be possible on other architectures (that have
> PCIe and aren't dead) as well.
> 
> The ioremap_wc() I suggested is probably wrong.
> 
> So can you please revisit this? I CCed Mark and Michael, maybe they can help
> here.

yes - we really are looking for write combining. We were following the 
lead of a couple of other entities in the kernel and hadn't found the 
right combination for something other than X86. We figured we would come 
back and add the non-86 enablements later when we found the right options.

-- james
