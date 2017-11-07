From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] SCSI: don't get target/host busy_count in
 scsi_mq_get_budget()
Date: Tue, 7 Nov 2017 15:39:16 -0700
Message-ID: <a147bd8a-a55b-8643-9aa2-facb805fb1d3@kernel.dk>
References: <20171104015534.32684-1-ming.lei@redhat.com>
 <adb7f6bd-bf0d-8176-808b-32a84ac4273a@kernel.dk>
 <1509997522.2409.58.camel@wdc.com> <20171107021125.GB15090@ming.t460p>
 <1510071607.2656.17.camel@wdc.com>
 <74925156-b425-de0e-de39-0a166ef5c5f3@kernel.dk>
 <49b5c202-0303-85f7-102a-fcc013e7256e@kernel.dk>
 <292e3f7d-cfe3-840a-5a5e-d00e01239152@kernel.dk>
 <a6a505f5-d374-2878-6c55-116255795346@kernel.dk>
 <1510094074.2656.39.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:43259 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750704AbdKGWjT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Nov 2017 17:39:19 -0500
Received: by mail-it0-f43.google.com with SMTP id k70so7550867itk.0
        for <linux-scsi@vger.kernel.org>; Tue, 07 Nov 2017 14:39:19 -0800 (PST)
In-Reply-To: <1510094074.2656.39.camel@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "john.garry@huawei.com" <john.garry@huawei.com>, "loberman@redhat.com" <loberman@redhat.com>

On 11/07/2017 03:34 PM, Bart Van Assche wrote:
> On Tue, 2017-11-07 at 15:06 -0700, Jens Axboe wrote:
>> Just to keep everyone in the loop, this bug is not new to
>> for-4.15/block, nor is it new to the current 4.14-rc or 4.13. So it's
>> probably different to what Bart is hitting, but it's a bug none the
>> less...
> 
> Hello Jens,
> 
> There are several reasons why I think that patch "blk-mq: don't handle
> TAG_SHARED in restart" really should be reverted:
> * That patch is based on the assumption that only the SCSI driver uses shared
>   tags. That assumption is not correct. null_blk and nvme also use shared tags.
> * As my tests have shown, the algorithm for restarting queues based on the
>   SCSI starved list is flawed. So using that mechanism instead of the blk-mq
>   shared queue restarting algorithm is wrong.
> * We are close to the merge window. It is too late for trying to fix the
>   "blk-mq: don't handle TAG_SHARED in restart" patch.
> 
> My proposal is to make sure that what will be sent to Linus during the v4.15
> merge window works reliably. That means using the v4.13/v4.14 algorithm for
> queue restarting which is an algorithm that is trusted by the community. If
> Roman Penyaev's patch could get applied that would be even better.

I'm fine with reverting a single patch, that's still a far cry from the
giant list. I'd rather get a fix in though, if at all possible. The code
it removed wasn't exactly the fastest or prettiest solution. But the
most important part is that we have something that works. If you have a
test case that is runnable AND reproduces the problem, I'd love to have
it. I've seen comments to that effect spread over several messages,
would be nice to have it summarized and readily available for all that
want to work on it.

The issue above is NOT a new bug, I ran into it by accident trying to
reproduce your case. Debugging that one right now, hopefully we'll have
some closure on that tomorrow and we can move forward on the shared tag
restart/loop. It smells like a TAG_WAITING race, or a restart race.

-- 
Jens Axboe
