From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH v2] add bidi support for block pc requests
Date: Thu, 17 May 2007 11:49:37 +0300
Message-ID: <464C1721.8030009@panasas.com>
References: <20070516175322.GS23798@kernel.dk>	<20070517115722T.fujita.tomonori@lab.ntt.co.jp>	<20070517054811.GV23798@kernel.dk> <20070517145958P.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:37178 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752347AbXEQIvc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 May 2007 04:51:32 -0400
In-Reply-To: <20070517145958P.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jens.axboe@oracle.com, James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, bhalevy@panasas.com, hch@infradead.org, akpm@linux-foundation.org, michaelc@cs.wisc.edu

FUJITA Tomonori wrote:
> From: Jens Axboe <jens.axboe@oracle.com>
> Subject: Re: [PATCH v2] add bidi support for block pc requests
> Date: Thu, 17 May 2007 07:48:13 +0200
> 
>> On Thu, May 17 2007, FUJITA Tomonori wrote:
>>> From: Jens Axboe <jens.axboe@oracle.com>
>>> Subject: Re: [PATCH v2] add bidi support for block pc requests
>>> Date: Wed, 16 May 2007 19:53:22 +0200
>>>
>>>> On Wed, May 16 2007, Boaz Harrosh wrote:
>>>>> now there are 2 issues with this:
>>>>> 1. Even if I do blk_queue_max_phys_segments(q, 127); I still get
>>>>>    requests for use_sg=128 which will crash the kernel.
>>>> That sounds like a serious issue, it should definitely not happen. Stuff
>>>> like that would bite other drivers as well, are you absolutely sure that
>>>> is happening? Power-of-2 bug in your code, or in the SCSI code?
>>> Boaz, how do you send requests to the scsi-ml, via fs, sg, or bsg?

These are regular fs (ext3) requests during bootup. The machine will not
boot. (Usually from the read ahead code)
Don't believe me look at the second patch Over Tomo's cleanup.
If I define SCSI_MAX_SG_SEGMENTS to 127 it will crash even when I
did in code:
	blk_queue_max_phys_segments(q, SCSI_MAX_SG_SEGMENTS);
I suppose someone is looking at a different definition. Or there is
another call I need to do for this to work.

>>>
>>>
>>>>> If anyone wants to see I have done 2 versions of this work. One on top
>>>>> of Jens's sg-chaining work (ver 5). And one on top of Tomo's cleanup
>>>>> git. both can be found here:
>>>>>   http://www.bhalevy.com/open-osd/download/scsi_sg_table/
>>>> +#define scsi_for_each_sg(cmd, sg, nseg, __i)                   \
>>>> +       for (__i = 0, sg = scsi_sglist(cmd); __i < (nseg); __i++, (sg)++)
>>>>
Yes leftovers from Tomos branch. Sorry for the noise. This is in no way
finished work Just experimenting. Any way in this git tree no one is
using this macro. (git-pull of Linus tree, apply ver5, and this patch)
This branch will work fine because I have not touched the numbers yet
Just screwed allocations.
>>>> Hmm?
>>> When for_each_sg is ready, we convert scsi_for_each_sg to use
>>> for_each_sg. I finished the cleanups on more than 40 drivers on the
>>> top of your patches.
>> But this is from the patch that is based on my sglist branch, so it
>> looked somewhat odd.
> 
> Oops, I didn't see the patch based on the sglist branch. Yeah, it's
> odd though it isn't used, I guess.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Boaz
