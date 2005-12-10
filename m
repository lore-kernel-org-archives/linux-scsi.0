From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Ang: Re: [Stgt-devel] Re: [Iscsitarget-devel] stgt a new	version
 of iscsi target?
Date: Sat, 10 Dec 2005 18:31:13 +0300
Message-ID: <439AF4C1.9030800@vlnb.net>
References: <OF6932015B.01CF53D9-ONC12570D0.00462028@capvert.ins> <43972C2D.9060500@cs.wisc.edu> <43987F75.2000301@vlnb.net> <4398850D.8070102@cs.wisc.edu> <1134071290.3259.31.camel@mulgrave> <439892FC.8040900@cs.wisc.edu> <20051208213514.GA23039@cs.umn.edu> <4398ABF9.2030404@cs.wisc.edu> <4399A2F5.1060403@vlnb.net> <439A05AC.7070501@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay03.infobox.ru ([195.208.235.28]:26300 "EHLO
	relay03.infobox.ru") by vger.kernel.org with ESMTP id S932518AbVLJPbK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Dec 2005 10:31:10 -0500
In-Reply-To: <439A05AC.7070501@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: boutcher@cs.umn.edu, James Bottomley <James.Bottomley@SteelEye.com>, johan@capvert.se, iscsitarget-devel@lists.sourceforge.net, mingz@ele.uri.edu, stgt <stgt-devel@lists.berlios.de>, Robert Whitehead <WRWHITEHEAD@novell.com>, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

Mike Christie wrote:
>>> There is still memory and scatterlist allocations. If we are not 
>>> going to allocate all the memory for a command buffer and request 
>>> with GFP_ATOMIC (and can then run from the the HW interrupt or soft 
>>> irq) we have to pass that on to a thread. I guess there is 
>>> disagreement whether that part is a feature or bad use of GFP_ATOMIC 
>>> though so... But I just mean to say there could be a little more to do.
>>
>>
>>
>> Actually, there is the way to allocate sg vectors with buffers in SIRQ 
>> and not with GFP_ATOMIC. This is the second major improvement, which 
>> is pending in scst. I called it sgv_pool. This is a new allocator in 
>> the kernel similar to mem_pool, but it contains *complete* sg-vectors 
>> of some size with data buffers (pages). Initiator sends data requests 
>> usually with some fixed size, like 128K. After a data command 
>> completed, its sg vector will not be immediately freed, but will be 
>> kept in 
> 
> 
> We considered this, but what did you decide is the upper limit size for 
> the pool? Is it dynmaic? We also wanted something that the SCSI ULDs 
> could use for their allocations which could go up to 6 MB.

Why do you think it needs any upper limit size? Would you like also any 
upper limits on sizes of the page or slab caches? I don't see any 
difference between them and sgv_pool. Let it allocate and keep unused as 
much memory as possible until it would be notified about memory pressure 
and ask to free some. Similarly as slab does.

BTW, from our experience, initiators tend to send commands without limit 
and in case if actual SCSI device isn't so fast to serve all of them 
with the rate, which they arrive, incoming queued commands very quickly 
eat all system memory with obvious consequences. So, there must be some 
kind of IO-throttling, when after some watermark the initiators start 
receiving TASK QUEUE FULL, which calm them down. I implemented very 
stupid one: don't let more than 32 commands per session. This let scst 
survive under extreme loads. You can think about something smarter  :-)

Vlad


