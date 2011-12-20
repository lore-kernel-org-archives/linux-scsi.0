From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH RESEND] block: warn if tag is greater than real_max_depth.
Date: Tue, 20 Dec 2011 14:56:29 +0100
Message-ID: <4EF0940D.7070304@kernel.dk>
References: <1315984992-5158-1-git-send-email-tm@tao.ma> <4EA57E40.2020301@tao.ma> <4EA670F9.8030601@kernel.dk> <CAA9_cmeV7uW8Rq_Rsn156SgtT4bBHV3Zip2=NS3kq+JrLm3AEQ@mail.gmail.com> <4EEFE0AE.7040201@tao.ma> <CAA9_cmfRXgwsamx2Q+Wccyfqnz3ePt60Z950pPippJuOnooJLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:57823 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab1LTN4e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Dec 2011 08:56:34 -0500
In-Reply-To: <CAA9_cmfRXgwsamx2Q+Wccyfqnz3ePt60Z950pPippJuOnooJLA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Tao Ma <tm@tao.ma>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, "edmund.nadolski" <edmund.nadolski@intel.com>, mroos@ut.ee

On 2011-12-20 02:45, Dan Williams wrote:
> On Mon, Dec 19, 2011 at 5:11 PM, Tao Ma <tm@tao.ma> wrote:
>>>> Looks good, better than what we had. Applied.
>>>
>>> This appears to interact badly with scsi_adjust_queue_depth() when the
>>> tag space shrinks.  I can reproduce a similar crash as reported in
>>> "3.2-rc2+git: kernel BUG at block/blk-core.c:1000!
>>> (__scsi_queue_insert)" [1].
>>>
>>> I can hit "kernel BUG at block/blk-core.c:2268!" which is the same
>>> BUG_ON(blk_queued_rq(rq)) check reliably with:
>>> # for i in $(seq 0 10); do dd if=/dev/zero of=/dev/sdX & done
>>> # echo 4 > /sys/class/block/sdX/device/queue_depth
>>>
>>> The following fixes it for me, if this looks ok (versus reverting
>>> commit 5e081591) I'll roll it into a formal patch with Ed and Meelis'
>>> Reported-by.
>> Interesting. If I read the code correctly, real_max_depth is the maximum
>> queue depth we ever have and max_depth is the current depth.
>>
>> In your fix, we never resize the tag size to be smaller than max_depth.
>> So I think this patch does expose some problem, but not lead to the BUG.
> 
> Yes, if we keep the "if (unlikely(tag >= bqt->max_depth))" check in
> blk_queue_end_tag() then the side effect is that we can never shrink
> the tag depth, which I don't think was intended.
> 
>> And in your new comment, you mentioned that "request between new_depth
>> and max_depth can be in-flight", but max_depth <= real_max_depth, so
>> what's wrong with the comment? Sorry, but am I missing something here?
> 
> Prior to the change blk_queue_end_tag() would continue to complete
> requests with a tag > max_depth, now it silently drops them on the
> floor leaving BUG_ON(blk_queued_rq(rq)) to trigger when we try to end
> the request

Yeah, that's just wrong. Tao Ma, which bug was the original fix intended
to fix?

The reason we have these two ceilings is exactly for shrinking depth
situations. It's quite legal to have an inflight request with a tag
inbetween max_depth and real_max_depth.

-- 
Jens Axboe

