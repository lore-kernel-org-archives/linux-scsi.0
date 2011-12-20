From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH RESEND] block: warn if tag is greater than real_max_depth.
Date: Tue, 20 Dec 2011 23:21:04 +0800
Message-ID: <4EF0A7E0.6070906@tao.ma>
References: <1315984992-5158-1-git-send-email-tm@tao.ma> <4EA57E40.2020301@tao.ma> <4EA670F9.8030601@kernel.dk> <CAA9_cmeV7uW8Rq_Rsn156SgtT4bBHV3Zip2=NS3kq+JrLm3AEQ@mail.gmail.com> <4EEFE0AE.7040201@tao.ma> <CAA9_cmfRXgwsamx2Q+Wccyfqnz3ePt60Z950pPippJuOnooJLA@mail.gmail.com> <4EF0940D.7070304@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from oproxy9.bluehost.com ([69.89.24.6]:49079 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751414Ab1LTPVW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Dec 2011 10:21:22 -0500
In-Reply-To: <4EF0940D.7070304@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, "edmund.nadolski" <edmund.nadolski@intel.com>, mroos@ut.ee

On 12/20/2011 09:56 PM, Jens Axboe wrote:
> On 2011-12-20 02:45, Dan Williams wrote:
>> On Mon, Dec 19, 2011 at 5:11 PM, Tao Ma <tm@tao.ma> wrote:
>>>>> Looks good, better than what we had. Applied.
>>>>
>>>> This appears to interact badly with scsi_adjust_queue_depth() when the
>>>> tag space shrinks.  I can reproduce a similar crash as reported in
>>>> "3.2-rc2+git: kernel BUG at block/blk-core.c:1000!
>>>> (__scsi_queue_insert)" [1].
>>>>
>>>> I can hit "kernel BUG at block/blk-core.c:2268!" which is the same
>>>> BUG_ON(blk_queued_rq(rq)) check reliably with:
>>>> # for i in $(seq 0 10); do dd if=/dev/zero of=/dev/sdX & done
>>>> # echo 4 > /sys/class/block/sdX/device/queue_depth
>>>>
>>>> The following fixes it for me, if this looks ok (versus reverting
>>>> commit 5e081591) I'll roll it into a formal patch with Ed and Meelis'
>>>> Reported-by.
>>> Interesting. If I read the code correctly, real_max_depth is the maximum
>>> queue depth we ever have and max_depth is the current depth.
>>>
>>> In your fix, we never resize the tag size to be smaller than max_depth.
>>> So I think this patch does expose some problem, but not lead to the BUG.
>>
>> Yes, if we keep the "if (unlikely(tag >= bqt->max_depth))" check in
>> blk_queue_end_tag() then the side effect is that we can never shrink
>> the tag depth, which I don't think was intended.
>>
>>> And in your new comment, you mentioned that "request between new_depth
>>> and max_depth can be in-flight", but max_depth <= real_max_depth, so
>>> what's wrong with the comment? Sorry, but am I missing something here?
>>
>> Prior to the change blk_queue_end_tag() would continue to complete
>> requests with a tag > max_depth, now it silently drops them on the
>> floor leaving BUG_ON(blk_queued_rq(rq)) to trigger when we try to end
>> the request
Oh, I see. So maybe we should modify blk_queue_end_tag instead of it?
> 
> Yeah, that' is just wrong. Tao Ma, which bug was the original fix intended
> to fix?
uh, actually there is no original bug for it.
> 
> The reason we have these two ceilings is exactly for shrinking depth
> situations. It's quite legal to have an inflight request with a tag
> inbetween max_depth and real_max_depth.
yeah, so I guess we should fix that in blk_queue_end_tag instead of
reverting this check.

Thanks
Tao
