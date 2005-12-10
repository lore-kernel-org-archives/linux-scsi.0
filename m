From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Ang: Re: [Stgt-devel] Re: [Iscsitarget-devel] stgt a new version
 of iscsi target?
Date: Sat, 10 Dec 2005 12:09:17 -0600
Message-ID: <439B19CD.7020308@cs.wisc.edu>
References: <43987F75.2000301@vlnb.net>	<4398850D.8070102@cs.wisc.edu>	<4399A2BA.1070505@vlnb.net> <20051210174658I.fujita.tomonori@lab.ntt.co.jp> <439AF51E.1080509@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:62339 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1161012AbVLJSJo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Dec 2005 13:09:44 -0500
In-Reply-To: <439AF51E.1080509@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, johan@capvert.se, iscsitarget-devel@lists.sourceforge.net, mingz@ele.uri.edu, stgt-devel@lists.berlios.de, WRWHITEHEAD@novell.com, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, hch@infradead.org

Vladislav Bolkhovitin wrote:
> FUJITA Tomonori wrote:
> 
>> From: Vladislav Bolkhovitin <vst@vlnb.net>
>> Subject: Re: Ang: Re: [Stgt-devel] Re: [Iscsitarget-devel] stgt a new 
>> version of iscsi target?
>> Date: Fri, 09 Dec 2005 18:28:58 +0300
>>
>>
>>>> Also is the page cache comment in reference to us using the page 
>>>> cache for our reads and writes or I am not sure why you wrote that 
>>>> if you do not do it right now.
>>>
>>>
>>> Hm, at first, the page cache already used somehow in fileio dev 
>>> handler (though, with additional mem copy). At the second, fully 
>>> utilize the page cache is one of two major improvements that are 
>>> pending in scst, because it is required changing the kernel, which 
>>> until some moment try to avoid. Although I prepared what is necessary 
>>> for that.
>>>
>>> The idea basically is the following. When READ operation arrives, 
>>> pages for all requested blocks are at first searched in the page 
>>> cache (probably, in SIRQ context, because it isn't expensive 
>>> operation) and if all pages are found, they are referenced and the 
>>> result will be sent to the initiator. Then the pages will be 
>>> dereferenced (so, no pages allocation will be done at all). 
>>> Otherwise, the missed pages will be allocated and the command will be 
>>> rescheduled to the thread, which will read them. Then, after the 
>>> response is sent, the pages will remain in the page cache for future 
>>> accesses. For WRITEs the processing is the similar, the pages with 
>>> the data will be put in the page cache.
>>
>>
>> The Ardis iSCSI target code does the same thing.
> 
> 
> Perfectly. So, why don't do it on the mid-layer level where all targets 
> can benefit from it?
> 

Any target can hook into stgt too? What is your point since neither of 
us are in mainline or even close given the scsi guy's veiwpoint on where 
to do reads and writes?
