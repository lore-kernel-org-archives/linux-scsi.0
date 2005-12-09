From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Ang: Re: [Stgt-devel] Re: [Iscsitarget-devel] stgt a new	version
 of iscsi target?
Date: Fri, 09 Dec 2005 18:30:15 +0300
Message-ID: <4399A307.5080803@vlnb.net>
References: <OF6932015B.01CF53D9-ONC12570D0.00462028@capvert.ins> <43972C2D.9060500@cs.wisc.edu> <43987F75.2000301@vlnb.net> <4398850D.8070102@cs.wisc.edu> <1134071290.3259.31.camel@mulgrave> <439892FC.8040900@cs.wisc.edu> <20051208213514.GA23039@cs.umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay03.infobox.ru ([195.208.235.28]:32193 "EHLO
	relay03.infobox.ru") by vger.kernel.org with ESMTP id S964783AbVLIPaK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Dec 2005 10:30:10 -0500
In-Reply-To: <20051208213514.GA23039@cs.umn.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: boutcher@cs.umn.edu
Cc: Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@SteelEye.com>, johan@capvert.se, iscsitarget-devel@lists.sourceforge.net, mingz@ele.uri.edu, stgt <stgt-devel@lists.berlios.de>, Robert Whitehead <WRWHITEHEAD@novell.com>, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

Dave C Boutcher wrote:
> On Thu, Dec 08, 2005 at 02:09:32PM -0600, Mike Christie wrote:
> 
>>James Bottomley wrote:
>>
>>>On Thu, 2005-12-08 at 13:10 -0600, Mike Christie wrote:
>>>
>>>
>>>>cleanup. In the end some of the scsi people liked the idea of throwing 
>>>>the non-read/write command to userspace and to do this we just decided 
>>>>to start over but I have been cutting and pasting your code and cleaning 
>>>>it up as I add more stuff.
>>>
>>>
>>>To be honest, I'd like to see all command processing at user level
>>>(including read/write ... for block devices, it shouldn't be that
>>>inefficient, since you're merely going to say remap an area from one
>>>device to another; as long as no data transformation ever occurs, the
>>>user never touches the data and it all remains in the kernel page
>>>cache).
>>
>>Ok, Tomo and I briefly talked about this when we saw Jeff's post about 
>>doing block layer drivers in userspace on lkml. I think we were somewhat 
>>prepared for this given some of your other replies.
>>
>>So Vlad and other target guys what do you think? Vlad are you going to 
>>continue to maintain scst as kernel only, or is there some place we can 
>>work together on this on - if your feelings are not hurt too much that 
>>is :) ?
> 
> 
> Oofff....Architecturally I agree with James...do all command processing
> in one place.  On the other hand, the processing involved with a read or
> write in the normal case (no aborts/resets/ordering/timeouts/etc) is
> almost zero.  Figure out the LBA and length and pass on the I/O.  The
> overhead of passing it up and down across the kernel boundary is likely
> to be orders of magnitude larger than the actual processing.  I would
> personally rather not fix this decision in concrete until we could do
> some actual measurements of a SCSI target under heavy load.

Totally agree.

Vlad


