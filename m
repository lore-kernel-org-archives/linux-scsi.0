From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH RESEND] block: warn if tag is greater than real_max_depth.
Date: Tue, 20 Dec 2011 09:11:10 +0800
Message-ID: <4EEFE0AE.7040201@tao.ma>
References: <1315984992-5158-1-git-send-email-tm@tao.ma>	<4EA57E40.2020301@tao.ma>	<4EA670F9.8030601@kernel.dk> <CAA9_cmeV7uW8Rq_Rsn156SgtT4bBHV3Zip2=NS3kq+JrLm3AEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:56276 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752124Ab1LTBLY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Dec 2011 20:11:24 -0500
In-Reply-To: <CAA9_cmeV7uW8Rq_Rsn156SgtT4bBHV3Zip2=NS3kq+JrLm3AEQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, "edmund.nadolski" <edmund.nadolski@intel.com>, mroos@ut.ee

On 12/20/2011 08:07 AM, Dan Williams wrote:
> On Tue, Oct 25, 2011 at 1:19 AM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 2011-10-24 17:03, Tao Ma wrote:
>>> Hi Jens,
>>>       any option with this patch?
>>>
>>> Thanks
>>> Tao
>>> On 09/14/2011 03:23 PM, Tao Ma wrote:
>>>> From: Tao Ma <boyu.mt@taobao.com>
>>>>
>>>> In case tag depth is reduced, it is max_depth not real_max_depth.
>>>> So we should allow a request with tag >= max_depth, but for a
>>>> tag >= real_max_depth, there really should be some problem.
>>>>
>>>> Cc: Jens Axboe <jaxboe@fusionio.com>
>>>> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
>>>> ---
>>>>  block/blk-tag.c |    6 ++++--
>>>>  1 files changed, 4 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/block/blk-tag.c b/block/blk-tag.c
>>>> index ece65fc..e74d6d1 100644
>>>> --- a/block/blk-tag.c
>>>> +++ b/block/blk-tag.c
>>>> @@ -286,12 +286,14 @@ void blk_queue_end_tag(struct request_queue *q, struct request *rq)
>>>>
>>>>      BUG_ON(tag == -1);
>>>>
>>>> -    if (unlikely(tag >= bqt->real_max_depth))
>>>> +    if (unlikely(tag >= bqt->max_depth)) {
>>>>              /*
>>>>               * This can happen after tag depth has been reduced.
>>>> -             * FIXME: how about a warning or info message here?
>>>> +             * But tag shouldn't be larger than real_max_depth.
>>>>               */
>>>> +            WARN_ON(tag >= bqt->real_max_depth);
>>>>              return;
>>>> +    }
>>>>
>>>>      list_del_init(&rq->queuelist);
>>>>      rq->cmd_flags &= ~REQ_QUEUED;
>>
>> Looks good, better than what we had. Applied.
> 
> This appears to interact badly with scsi_adjust_queue_depth() when the
> tag space shrinks.  I can reproduce a similar crash as reported in
> "3.2-rc2+git: kernel BUG at block/blk-core.c:1000!
> (__scsi_queue_insert)" [1].
> 
> I can hit "kernel BUG at block/blk-core.c:2268!" which is the same
> BUG_ON(blk_queued_rq(rq)) check reliably with:
> # for i in $(seq 0 10); do dd if=/dev/zero of=/dev/sdX & done
> # echo 4 > /sys/class/block/sdX/device/queue_depth
> 
> The following fixes it for me, if this looks ok (versus reverting
> commit 5e081591) I'll roll it into a formal patch with Ed and Meelis'
> Reported-by.
Interesting. If I read the code correctly, real_max_depth is the maximum
queue depth we ever have and max_depth is the current depth.

In your fix, we never resize the tag size to be smaller than max_depth.
So I think this patch does expose some problem, but not lead to the BUG.
And in your new comment, you mentioned that "request between new_depth
and max_depth can be in-flight", but max_depth <= real_max_depth, so
what's wrong with the comment? Sorry, but am I missing something here?

Having said that, I have tried the test in my machine here, but have no
luck by now. My kernel version is 3.2.0-rc5+.

Thanks
Tao
> 
> diff --git a/block/blk-tag.c b/block/blk-tag.c
> index e74d6d1..09cf867 100644
> --- a/block/blk-tag.c
> +++ b/block/blk-tag.c
> @@ -230,9 +230,12 @@ int blk_queue_resize_tags(struct request_queue
> *q, int new_depth)
>         /*
>          * if we already have large enough real_max_depth.  just
>          * adjust max_depth.  *NOTE* as requests with tag value
> -        * between new_depth and real_max_depth can be in-flight, tag
> +        * between new_depth and max_depth can be in-flight, tag
>          * map can not be shrunk blindly here.
>          */
> +       if (new_depth <= bqt->max_depth)
> +               return 0;
> +
>         if (new_depth <= bqt->real_max_depth) {
>                 bqt->max_depth = new_depth;
>                 return 0;
> 
> --
> Dan
> 
> [1]: http://marc.info/?l=linux-kernel&m=132204370518629&w=2
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

