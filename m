From: Rob Evers <revers@redhat.com>
Subject: Re: [PATCH 1/11] mpt2sas: mpt2sas_base sources
Date: Tue, 03 Mar 2009 22:22:42 -0500
Message-ID: <49ADF402.4050504@redhat.com>
References: <660360F4F2570145BD872F298951B17A7689E415@cosmail03.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:43399 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbZCDDYi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Mar 2009 22:24:38 -0500
In-Reply-To: <660360F4F2570145BD872F298951B17A7689E415@cosmail03.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Wilcox <matthew@wil.cx>, Grant Grundler <grundler@google.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Moore, Eric wrote:
> On Tuesday, March 03, 2009 2:29 PM, James Bottomley wrote: 
>   
>> On Wed, 2009-02-25 at 14:12 -0700, Matthew Wilcox wrote:
>>     
>>> On Wed, Feb 25, 2009 at 01:27:00PM -0700, Moore, Eric wrote:
>>>       
>>>> What are you suggesting?   Calling wmb()?
>>>>         
>>> PCI writes can be posted, so the him_register writel() may 
>>>       
>> not complete
>>     
>>> for a few thousand cycles.  wmb() isn't going to solve the 
>>>       
>> problem.  A
>>     
>>> readl() from the device would, as would your current solution of
>>> ignoring subsequent interrupts.
>>>       
>> This seems to be the most serious issue with the current 
>> patch set.  If
>> you repost with that fixed, I can put it into scsi-misc and we can
>> address the other issues later.
>>
>>     
>
> I will repost the patch set tommorrow with the following changes
>
> (1) Add readl following writel from the function that disables interrupts
>   
Is a memory barrier required after the writel and before the readl to ensure that 
the writel executes before the readl on processors other than x86_64 and ia32?

> (2) Replace 0xFFFFFFFFFFFFFFFFULL with ~0ULL
>
> (3) when calling pci_enable_msix, only pass one msix entry (instead of 15).  
>
> (4) remove the "current HW implementation uses..... " comment in the sources
>
> (5) merge in a bug fix for SIGIO/POLLIN notifcation reported by the storlib team.
>
> Eric Moore--
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

