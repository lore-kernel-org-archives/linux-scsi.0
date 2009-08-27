From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: DIF/DIX updates for 2.6.32
Date: Thu, 27 Aug 2009 17:40:20 +0300
Message-ID: <4A969AD4.7070309@panasas.com>
References: <1251267481-24135-1-git-send-email-martin.petersen@oracle.com>	 <4A95226E.8030504@panasas.com> <yq1my5l934u.fsf@sermon.lab.mkp.net>	 <4A9656B6.5060100@panasas.com> <1251380803.6426.16.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-67.z220-152-67.customer.algx.net ([67.152.220.67]:15861
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751452AbZH0OkU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Aug 2009 10:40:20 -0400
In-Reply-To: <1251380803.6426.16.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org

On 08/27/2009 04:46 PM, James Bottomley wrote:
> On Thu, 2009-08-27 at 12:49 +0300, Boaz Harrosh wrote:
>> On 08/27/2009 09:34 AM, Martin K. Petersen wrote:
>>>>>>>> "Boaz" == Boaz Harrosh <bharrosh@panasas.com> writes:
>>>
>>> Boaz> I know that we also have the above problem with iscsi and
>>> Boaz> data-digest such that when we come to sign the data it might
>>> Boaz> change on us before the target receives it.
>>>
>>> Yep, I have the same problem.  I talked to Andrew Morton a couple of
>>> months ago and he said that modifying pages in flight is "a feature" as
>>> far as ext[234] is concerned.
>>>
>>
>> As you might know, I have a filesystem copied from the ext2 code base.
>> I'm experimenting with altering the behavior so that pages written to
>> while been IOed will page fault, then sleep, until IO is done.
>> Clearly this is a good "feature" until such systems like mirror or signed-
>> data that are forced to reallocate-copy all IO do to the 2% optimization
>> that thing gives you.
> 
> What about reads to the page?  If you allow them, you get the situation
> where something signals a write intent, tries to write and gets put into
> wait, then the readers get the old data still.
> 

Is there any guaranty between a parallel write and read about what's first?
But I think in my case the reads will also page-fault so I'm not sure yet.
Thanks for asking that's a good question that should be taken into
consideration.

>> At the final outcome I hope for a VFS support on a flip of a flag or
>> something. So under laying device can turn that "feature" off when it
>> means grate performance gains in it's operations.
>>
>> If any one has thought about that problem, and as some preliminary strategies,
>> please I'm all hears. I've just started on this subject and currently I do not
>> have a clue.
> 
> The correct way to handle this is simply to dump the page being written.
> It's dirty and was updated after the last write attempt, so it gets
> re-written out.  It costs nothing and it's incredibly fast.
> 

This is not an option on a mirror system, and the performance gain/lose
is dependent on the round trip speed. If for every digest error I have an
error recovery cycle, delays, and stalls. Then no it is not better. Not
to mention some iscsi-targets that reset and the all session must be
re-established.

> What you likely want is a way of telling that the page got re-written so
> you don't need to print out scary warning messages about parity
> problems.
> 

Maybe that is a start. I guess I could signal a fast abort for these. What
would be the cost for this knowledge. I guess O(sglist-size) right? loop
on all pages and check? Anything better we can do?

> James
> 
> 

Thanks
Boaz
