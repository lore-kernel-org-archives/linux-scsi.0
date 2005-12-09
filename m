From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Ang: Re: [Stgt-devel] Re: [Iscsitarget-devel] stgt a new	version
 of iscsi target?
Date: Fri, 09 Dec 2005 18:29:57 +0300
Message-ID: <4399A2F5.1060403@vlnb.net>
References: <OF6932015B.01CF53D9-ONC12570D0.00462028@capvert.ins> <43972C2D.9060500@cs.wisc.edu> <43987F75.2000301@vlnb.net> <4398850D.8070102@cs.wisc.edu> <1134071290.3259.31.camel@mulgrave> <439892FC.8040900@cs.wisc.edu> <20051208213514.GA23039@cs.umn.edu> <4398ABF9.2030404@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay03.infobox.ru ([195.208.235.28]:21953 "EHLO
	relay03.infobox.ru") by vger.kernel.org with ESMTP id S964796AbVLIP3x
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Dec 2005 10:29:53 -0500
In-Reply-To: <4398ABF9.2030404@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: boutcher@cs.umn.edu, James Bottomley <James.Bottomley@SteelEye.com>, johan@capvert.se, iscsitarget-devel@lists.sourceforge.net, mingz@ele.uri.edu, stgt <stgt-devel@lists.berlios.de>, Robert Whitehead <WRWHITEHEAD@novell.com>, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

Mike Christie wrote:
> Dave C Boutcher wrote:
> 
>> On Thu, Dec 08, 2005 at 02:09:32PM -0600, Mike Christie wrote:
>>
>>> James Bottomley wrote:
>>>
>>>> On Thu, 2005-12-08 at 13:10 -0600, Mike Christie wrote:
>>>>
>>>>
>>>>> cleanup. In the end some of the scsi people liked the idea of 
>>>>> throwing the non-read/write command to userspace and to do this we 
>>>>> just decided to start over but I have been cutting and pasting your 
>>>>> code and cleaning it up as I add more stuff.
>>>>
>>>>
>>>>
>>>> To be honest, I'd like to see all command processing at user level
>>>> (including read/write ... for block devices, it shouldn't be that
>>>> inefficient, since you're merely going to say remap an area from one
>>>> device to another; as long as no data transformation ever occurs, the
>>>> user never touches the data and it all remains in the kernel page
>>>> cache).
>>>
>>>
>>> Ok, Tomo and I briefly talked about this when we saw Jeff's post 
>>> about doing block layer drivers in userspace on lkml. I think we were 
>>> somewhat prepared for this given some of your other replies.
>>>
>>> So Vlad and other target guys what do you think? Vlad are you going 
>>> to continue to maintain scst as kernel only, or is there some place 
>>> we can work together on this on - if your feelings are not hurt too 
>>> much that is :) ?
>>
>>
>>
>> Oofff....Architecturally I agree with James...do all command processing
>> in one place.  On the other hand, the processing involved with a read or
>> write in the normal case (no aborts/resets/ordering/timeouts/etc) is
>> almost zero.  Figure out the LBA and length and pass on the I/O.  The
> 
> 
> There is still memory and scatterlist allocations. If we are not going 
> to allocate all the memory for a command buffer and request with 
> GFP_ATOMIC (and can then run from the the HW interrupt or soft irq) we 
> have to pass that on to a thread. I guess there is disagreement whether 
> that part is a feature or bad use of GFP_ATOMIC though so... But I just 
> mean to say there could be a little more to do.

Actually, there is the way to allocate sg vectors with buffers in SIRQ 
and not with GFP_ATOMIC. This is the second major improvement, which is 
pending in scst. I called it sgv_pool. This is a new allocator in the 
kernel similar to mem_pool, but it contains *complete* sg-vectors of 
some size with data buffers (pages). Initiator sends data requests 
usually with some fixed size, like 128K. After a data command completed, 
its sg vector will not be immediately freed, but will be kept in 
sgv_pool until the next request (command) or memory pressure on the 
system. So, all subsequent commands will allocate already built vectors. 
The first allocations will be done in some thread context. This allows 
to allocate huge chunks of memory in SIRQ context as well as save a lot 
of CPU power necessary to always build big sg vectors for each command 
individually.

Vlad
