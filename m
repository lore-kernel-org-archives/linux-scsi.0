From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Ang: Re: [Stgt-devel] Re: [Iscsitarget-devel] stgt a new	version
 of iscsi target?
Date: Fri, 09 Dec 2005 16:31:08 -0600
Message-ID: <439A05AC.7070501@cs.wisc.edu>
References: <OF6932015B.01CF53D9-ONC12570D0.00462028@capvert.ins> <43972C2D.9060500@cs.wisc.edu> <43987F75.2000301@vlnb.net> <4398850D.8070102@cs.wisc.edu> <1134071290.3259.31.camel@mulgrave> <439892FC.8040900@cs.wisc.edu> <20051208213514.GA23039@cs.umn.edu> <4398ABF9.2030404@cs.wisc.edu> <4399A2F5.1060403@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:16110 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932476AbVLIWcm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2005 17:32:42 -0500
In-Reply-To: <4399A2F5.1060403@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: boutcher@cs.umn.edu, James Bottomley <James.Bottomley@SteelEye.com>, johan@capvert.se, iscsitarget-devel@lists.sourceforge.net, mingz@ele.uri.edu, stgt <stgt-devel@lists.berlios.de>, Robert Whitehead <WRWHITEHEAD@novell.com>, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

Vladislav Bolkhovitin wrote:
> Mike Christie wrote:
> 
>> Dave C Boutcher wrote:
>>
>>> On Thu, Dec 08, 2005 at 02:09:32PM -0600, Mike Christie wrote:
>>>
>>>> James Bottomley wrote:
>>>>
>>>>> On Thu, 2005-12-08 at 13:10 -0600, Mike Christie wrote:
>>>>>
>>>>>
>>>>>> cleanup. In the end some of the scsi people liked the idea of 
>>>>>> throwing the non-read/write command to userspace and to do this we 
>>>>>> just decided to start over but I have been cutting and pasting 
>>>>>> your code and cleaning it up as I add more stuff.
>>>>>
>>>>>
>>>>>
>>>>>
>>>>> To be honest, I'd like to see all command processing at user level
>>>>> (including read/write ... for block devices, it shouldn't be that
>>>>> inefficient, since you're merely going to say remap an area from one
>>>>> device to another; as long as no data transformation ever occurs, the
>>>>> user never touches the data and it all remains in the kernel page
>>>>> cache).
>>>>
>>>>
>>>>
>>>> Ok, Tomo and I briefly talked about this when we saw Jeff's post 
>>>> about doing block layer drivers in userspace on lkml. I think we 
>>>> were somewhat prepared for this given some of your other replies.
>>>>
>>>> So Vlad and other target guys what do you think? Vlad are you going 
>>>> to continue to maintain scst as kernel only, or is there some place 
>>>> we can work together on this on - if your feelings are not hurt too 
>>>> much that is :) ?
>>>
>>>
>>>
>>>
>>> Oofff....Architecturally I agree with James...do all command processing
>>> in one place.  On the other hand, the processing involved with a read or
>>> write in the normal case (no aborts/resets/ordering/timeouts/etc) is
>>> almost zero.  Figure out the LBA and length and pass on the I/O.  The
>>
>>
>>
>> There is still memory and scatterlist allocations. If we are not going 
>> to allocate all the memory for a command buffer and request with 
>> GFP_ATOMIC (and can then run from the the HW interrupt or soft irq) we 
>> have to pass that on to a thread. I guess there is disagreement 
>> whether that part is a feature or bad use of GFP_ATOMIC though so... 
>> But I just mean to say there could be a little more to do.
> 
> 
> Actually, there is the way to allocate sg vectors with buffers in SIRQ 
> and not with GFP_ATOMIC. This is the second major improvement, which is 
> pending in scst. I called it sgv_pool. This is a new allocator in the 
> kernel similar to mem_pool, but it contains *complete* sg-vectors of 
> some size with data buffers (pages). Initiator sends data requests 
> usually with some fixed size, like 128K. After a data command completed, 
> its sg vector will not be immediately freed, but will be kept in 

We considered this, but what did you decide is the upper limit size for 
the pool? Is it dynmaic? We also wanted something that the SCSI ULDs 
could use for their allocations which could go up to 6 MB.
