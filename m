From: "erich" <erich@areca.com.tw>
Subject: Re: Areca RAID driver remaining items?
Date: Fri, 24 Feb 2006 11:18:17 +0800
Message-ID: <006101c638f0$f6583440$b100a8c0@erich2003>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="big5";
	reply-type=response
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750795AbWBXDSS@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: erich <erich@areca.com.tw>
Cc: "\"Christoph Hellwig\"" <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, billion.wu@areca.com.tw, alan@lxorguk.ukuu.org.uk, akpm@osdl.org, oliver@neukum.org
List-Id: linux-scsi@vger.kernel.org

Dear Arjan van de Ven,
I had  misconstruction with
>> [Exception is that you can say that you are ok with a bigger mask for
>> this type of memory, but just don't do that if you're not]

it should be "pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK)."

Best Regards
Erich Chen

----- Original Message ----- 
From: "erich" <erich@areca.com.tw>
To: "Arjan van de Ven" <arjan@infradead.org>
Cc: """"Christoph Hellwig"""" <hch@infradead.org>; 
<linux-scsi@vger.kernel.org>; <linux-kernel@vger.kernel.org>; 
<billion.wu@areca.com.tw>; <alan@lxorguk.ukuu.org.uk>; <akpm@osdl.org>; 
<oliver@neukum.org>
Sent: Friday, February 24, 2006 10:08 AM
Subject: Re: Areca RAID driver remaining items?


> Dear Arjan van de Ven,
>
> I would keep dma_alloc_coherent usage.
>
>> [Exception is that you can say that you are ok with a bigger mask for
>> this type of memory, but just don't do that if you're not]
>
> Should I remove "pci_set_dma_mask(pci_device, DMA_64BIT_MASK)" for this 
> case?
>
> Best Regards
> Erich Chen
>
> ----- Original Message ----- 
> From: "Arjan van de Ven" <arjan@infradead.org>
> To: "erich" <erich@areca.com.tw>
> Cc: """Christoph Hellwig""" <hch@infradead.org>; 
> <linux-scsi@vger.kernel.org>; <linux-kernel@vger.kernel.org>; 
> <billion.wu@areca.com.tw>; <alan@lxorguk.ukuu.org.uk>; <akpm@osdl.org>; 
> <oliver@neukum.org>
> Sent: Thursday, February 23, 2006 8:07 PM
> Subject: Re: Areca RAID driver remaining items?
>
>
>> On Thu, 2006-02-23 at 19:51 +0800, erich wrote:
>>> If Linux can not assurent the contingous memory space allocating of
>>> "dma_alloc_coherent" .
>>
>> coherent memory is guaranteed to be in the "lower" 32 bit of memory!
>> So that is good news, I think you are just fine.
>>
>> [Exception is that you can say that you are ok with a bigger mask for
>> this type of memory, but just don't do that if you're not]
>>
>>
>>> When arcmsr get a physical ccb address from areca's firmware.
>>> Does linux has any functions for converting of  "bus to virtual" ?
>>
>> not without using pools. You would have to search the list of memory you
>> gave it to find that out.
>>
>> (USB has a similar problem, afaik they solved it with pools)
>>
>>
> 
