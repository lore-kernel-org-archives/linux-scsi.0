From: Luben Tuikov <tluben@rogers.com>
Subject: Re: [PATCH] scsi-misc-2.5 user per-device spare command
Date: Fri, 25 Apr 2003 14:36:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EA98031.2040108@rogers.com>
References: <20030424100229.A32098@beaverton.ibm.com> <20030424100317.A32134@beaverton.ibm.com> <20030425111227.B28577@infradead.org> <3EA94263.1020902@rogers.com> <20030425095055.B8776@beaverton.ibm.com> <3EA97456.9060702@rogers.com> <20030425110002.A9928@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep01-mail.bloor.is.net.cable.rogers.com ([66.185.86.71]:38870
	"EHLO fep01-mail.bloor.is.net.cable.rogers.com") by vger.kernel.org
	with ESMTP id S263577AbTDYSY2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Apr 2003 14:24:28 -0400
In-Reply-To: <20030425110002.A9928@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> On Fri, Apr 25, 2003 at 01:45:58PM -0400, Luben Tuikov wrote:
> 
>>Patrick Mansfield wrote:
> 
> 
>>No, it is NOT different, because I can see your patch deleting
>>the good code which currently impements just that.
>>
>>All we want is for IO to keep going.  It does, so leave it alone.
> 
> 
> It is not clear that the IO will always make forward progress.

It is -- we have one spare per host, which will be used
when the cache fails.

10 When a commands completes, we will keep going.
20 If no command completes then there's something wrong with
the LLDD or the device, in which case the EH will grab it back.
GOTO 10
 
>>>>2. Why spare_cmd is a pointer? Why? Why?
>>>>Wouldn't it be much more *flexible* to be a list_head,
>>>>so that maybe we can hook up more commands in the future?
>>>>I.e. keep your options open...
>>>
>>>
>>>When or if we use more than one spare we can change the code to a
>>>list_head. I don't plan to add such code, so I see no reason to use a
>>>list_head.
>>
>>Yeah, and then you're going to change a WHOLE bunch of code
>>everywhere.
> 
> 
> No, maybe a few lines, maybe less code than is needed to actually
> support dyanmically changing the number of spared/cached commands.

The whole point is where to draw the line -- I say that
free_list is a good thing and free_ptr is a bad thing.
 
>>It's good not to overengineer, but it's even BETTER to know
>>when to do so and when to NOT do so.
> 
> Well we should never overengineer, but the term is subjective.

No, not never. The point is knowing when to do so and when not to do so.
 
>>Ideally, commands come out of cache/free_list, travel through
>>lists as they go about SCSI Core, and go back to the cache/free_list.
>>
>>So the following axiom: scsi command always belongs to a list.
> 
> 
> If they are freed (into cache), they are not on any list.

This is absolutely irrelevant.

BTW, did you really think that *that* was my point???

Just use your imagination... (next time)

(Patterns, consistency, etc.)

-- 
Luben











