From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 1/2] block: export __blk_complete_request
Date: Fri, 15 Jun 2018 10:56:03 +0800
Message-ID: <CACVXFVMRCM6AvNJjAESbwOeJ_P5AZ+1C-7RfhE9L4u0T=_5h4Q@mail.gmail.com>
References: <1529027847-29085-1-git-send-email-jianchao.w.wang@oracle.com>
 <CACVXFVMe4zSvfXfuSn0NFayeQqbmDwBBy1kcso=5iznT6EfpSA@mail.gmail.com>
 <3dd3f82a-5b68-f039-3a8a-7c5fe4e24c3e@oracle.com> <e5344293-b0b7-d2e0-f2e7-c0700efdfbe4@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e5344293-b0b7-d2e0-f2e7-c0700efdfbe4@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "jianchao.wang" <jianchao.w.wang@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-block <linux-block@vger.kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 15, 2018 at 10:44 AM, jianchao.wang
<jianchao.w.wang@oracle.com> wrote:
>
>
> On 06/15/2018 10:22 AM, jianchao.wang wrote:
>> Hi Ming
>>
>> On 06/15/2018 10:17 AM, Ming Lei wrote:
>>> On Fri, Jun 15, 2018 at 9:57 AM, Jianchao Wang
>>> <jianchao.w.wang@oracle.com> wrote:
>>>> After f6e7d48 (block: remove BLK_EH_HANDLED), LLDD is responsible
>>>> to complete the timed out request, however, for blk-legacy, the
>>>> 'complete' is still marked, blk_complete_request will do nothing,
>>>> we export __blk_complete_request for LLDD to complete the request
>>>> in timeout path.
>>>>
>>>> Signed-off-by: Jianchao Wang <jianchao.w.wang@oracle.com>
>>>> ---
>>>>  block/blk-softirq.c | 1 +
>>>>  1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/block/blk-softirq.c b/block/blk-softirq.c
>>>> index 01e2b35..15c1f5e 100644
>>>> --- a/block/blk-softirq.c
>>>> +++ b/block/blk-softirq.c
>>>> @@ -144,6 +144,7 @@ void __blk_complete_request(struct request *req)
>>>>
>>>>         local_irq_restore(flags);
>>>>  }
>>>> +EXPORT_SYMBOL(__blk_complete_request);
>>>>
>>>>  /**
>>>>   * blk_complete_request - end I/O on a request
>>>> --
>>>> 2.7.4
>>>>
>>>
>>> Looks non-blk-mq timeout code need to convert to ref-counter
>>> based approach too?
>>
>> IMO, ref-counter is just to fix the blk-mq req life recycle issue.
>> It cannot replace the blk_mark_rq_complete which could avoid the race between
>> timeout and io completion path.
>
> The .timeout return BLK_EH_DONE doesn't always mean the request has been completed.
> Such as scsi-mid layer, its .timeout callback return BLK_EH_DONE but the timed out
> request is still in abort or eh process. What if a completion irq come during that ?

For blk-mq, it is avoided by the atomic state change in
__blk_mq_complete_request(),
that is why I mentioned the question in my last reply.

But what if the timed-out request has been freed by EH? Then seems
req's ref_counter
is still needed for non-mq?


Thanks,
Ming Lei
