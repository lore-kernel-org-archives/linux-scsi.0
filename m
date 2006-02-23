From: "erich" <erich@areca.com.tw>
Subject: Re: Areca RAID driver remaining items?
Date: Thu, 23 Feb 2006 19:51:41 +0800
Message-ID: <005a01c6386f$84b30d50$b100a8c0@erich2003>
References: <1140458552.3495.26.camel@mentorng.gurulabs.com> <20060220182045.GA1634@infradead.org> <001401c63779$12e49aa0$b100a8c0@erich2003> <20060222145733.GC16269@infradead.org> <00dc01c63842$381f9a30$b100a8c0@erich2003> <1140683157.2972.6.camel@laptopd505.fenrus.org> <001901c6385e$9aee7d40$b100a8c0@erich2003> <1140688569.4672.24.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="big5";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 220-130-178-142.HINET-IP.hinet.net ([220.130.178.142]:64842
	"EHLO areca.com.tw") by vger.kernel.org with ESMTP id S1750889AbWBWLvq
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Feb 2006 06:51:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: "\"\"Christoph Hellwig\"\"" <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, billion.wu@areca.com.tw, alan@lxorguk.ukuu.org.uk, akpm@osdl.org, oliver@neukum.org

Dear Arjan van de Ven,

Thanks for your answer.
I will remove CONFIG_SCSI_ARCMSR_MSI in next patch.

If Linux can not assurent the contingous memory space allocating of 
"dma_alloc_coherent" .
When arcmsr get a physical ccb address from areca's firmware.
Does linux has any functions for converting of  "bus to virtual" ?

Best Regards
Erich Chen

----- Original Message ----- 
From: "Arjan van de Ven" <arjan@infradead.org>
To: "erich" <erich@areca.com.tw>
Cc: ""Christoph Hellwig"" <hch@infradead.org>; <linux-scsi@vger.kernel.org>; 
<linux-kernel@vger.kernel.org>; <billion.wu@areca.com.tw>; 
<alan@lxorguk.ukuu.org.uk>; <akpm@osdl.org>; <oliver@neukum.org>
Sent: Thursday, February 23, 2006 5:56 PM
Subject: Re: Areca RAID driver remaining items?


> On Thu, 2006-02-23 at 17:50 +0800, erich wrote:
>> Dear Arjan van de Ven,
>>
>> The following contex is coming from comment of Christoph Hellwig.
>>
>> - msi should be a module options if at all, but defintitly not
>>    a config options
>>
>> #ifdef CONFIG_SCSI_ARCMSR_MSI
>>  if (!pci_enable_msi(pci_device))
>>   pACB->acb_flags |= ACB_F_HAVE_MSI;
>> #endif
>>
>> I make an option config for prevent some mainboards hang up if arcmsr 
>> enable
>> msi function.
>> Areca RAID controller is bridged hardware.
>> There were a lots of mainboards had wrong IRQ routing table issue with 
>> it.
>> If somebody meet this issue and people can enable msi function to fix its
>> hardware bug.
>> But unfortunately I found some mainboards will hang up if I always enable
>> this function in my lab.
>> To avoid this issue, I do an option for this case.
>
>
> yes the reason for making this optional is clear, and Christoph also
> understands that.
>
> However the idea that Christoph is proposing is to not make it a compile
> time option, but a runtime option. Compile-time is not very flexible,
> especially not for linux distributions. Making it a module option means
> it becomes runtime behavior, and the user can load the module like
>
> modprobe aerca msi=0
>
> and msi gets turned off. No need to recompile anything! That has many
> advantages over a more inflexible (from the user view) compiletime-only
> option.
>
> 

