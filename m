From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: Why is AHA152X_CS !64BIT?
Date: Tue, 07 Sep 2010 14:48:16 -0700
Message-ID: <4C86B320.8090709@oracle.com>
References: <4C72D310.4040004@suse.cz> <4C7B924D.6030703@panasas.com> <201009071712.54867.konrad@darnok.org> <4C86B1A4.8030308@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:17632 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab0IGVtd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Sep 2010 17:49:33 -0400
In-Reply-To: <4C86B1A4.8030308@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Jiri Slaby <jslaby@suse.cz>, fischer@linux-buechse.de, linux-scsi@vger.kernel.org

On 09/07/10 14:41, Randy Dunlap wrote:
> On 09/07/10 14:12, Konrad Rzeszutek Wilk wrote:
>> On Monday 30 August 2010 07:13:17 Boaz Harrosh wrote:
>>> On 08/23/2010 10:59 PM, Jiri Slaby wrote:
>>>> Hi,
>>>>
>>>> I see that the aha152x driver for pcmcia is marked as unsupported on
>>>> 64bit. But I also see a patch [1] which removes the restriction based on
>>>> user's testing in bugzilla [2].
>>>>
>>>> Is there a reason why it would have to be marked as !64BIT? I'm asking
>>>> because there is an opensuse user with this card who updated to 64-bit
>>>> distro and lost this driver thereafter.
>>>>
>>>> [1] http://kerneltrap.org/mailarchive/linux-scsi/2010/3/6/6832393
>>>> [2] https://bugzilla.kernel.org/show_bug.cgi?id=14333
>>>>
>>>> thanks,
>>>
>>> If memory serves correctly, it might be that you need more then 4 Gbyte
>>> of memory installed to exercise the bug, something about IO bouncing
>>> addresses > 4G.
>>
>> If the machine is using SWIOTLB, then the bounce buffer would be activated. By 
>> default if your machine has more than 4GB compiled under x86_64 the SWIOTLB 
>> is turned on - but if you have an Intel/AMD IOMMU it gets turned off. Which 
>> is OK as the Intel/AMD IOMMUs would handle the 4GB restricted devices. So as 
>> long as the driver has pci_dma_mask_set.
>>
>> Looking at the git gui blame tool history, the reason that was added was 
>> for 'allow drivers to be built non-modular'.
> 
> 023ae619 (Robert P. J. Day  2007-03-26 16:06:45 -0400 14) 	depends on !64BIT
> 
> That commit just removed the "depends on m" part:
> 
> -	depends on m && !64BIT
> +	depends on !64BIT
> 
> 
>> So, does this driver build if you make it non-modular?
> 
> It shouldn't since it still depends on !64BIT.
> 
> I expect someone thought or had evidence that the driver was not 64-bit clean.
> 
> Is the bitkeeper kernel repo still visible somewhere?
> Looks like we would need to look at it for patch history that far back.
> 

http://linux.bkbits.net:8080/linux-2.6/?PAGE=cset&REV=3fe0bc41KO89ooP68UcrHEMVVAfDnw

but it doesn't quite make sense to me.  Sure, no ISA on x86_64, but that does not
mean no PCMCIA on x86_64.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
