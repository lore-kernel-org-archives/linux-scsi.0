From: Jens Axboe <axboe@kernel.dk>
Subject: Re: scsi-mq - tag# and can_queue, performance.
Date: Mon, 3 Apr 2017 10:47:37 -0600
Message-ID: <19fb1bcb-6207-d63b-c326-a10991848577@kernel.dk>
References: <alpine.LRH.2.00.1704022326190.727@mvluser05.qlc.com>
 <3fd1ca57-3b0a-9405-0ec8-3be15ba33caf@suse.de>
 <1491232832.2661.1.camel@sandisk.com>
 <alpine.LRH.2.00.1704030931320.727@mvluser05.qlc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:36537 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753365AbdDCQrj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Apr 2017 12:47:39 -0400
Received: by mail-it0-f43.google.com with SMTP id e75so49964080itd.1
        for <linux-scsi@vger.kernel.org>; Mon, 03 Apr 2017 09:47:39 -0700 (PDT)
In-Reply-To: <alpine.LRH.2.00.1704030931320.727@mvluser05.qlc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arun Easi <arun.easi@cavium.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.de" <hare@suse.de>

On 04/03/2017 10:41 AM, Arun Easi wrote:
> On Mon, 3 Apr 2017, 8:20am, Bart Van Assche wrote:
> 
>> On Mon, 2017-04-03 at 09:29 +0200, Hannes Reinecke wrote:
>>> On 04/03/2017 08:37 AM, Arun Easi wrote:
>>>> If the above is true, then for a LLD to get tag# within it's max-tasks 
>>>> range, it has to report max-tasks / number-of-hw-queues in can_queue, and 
>>>> in the I/O path, use the tag and hwq# to arrive at a index# to use. This, 
>>>> though, leads to a poor use of tag resources -- queue reaching it's 
>>>> capacity while LLD can still take it.
>>>
>>> Shared tag sets continue to dog the block-mq on 'legacy' (ie non-NVMe)
>>> HBAs. ATM the only 'real' solution to this problem is indeed have a
>>> static split of the entire tag space by the number of hardware queues.
>>> With the mentioned tag-starvation problem.
>>
>> Hello Arun and Hannes,
>>
>> Apparently the current blk_mq_alloc_tag_set() implementation is well suited
>> for drivers like NVMe and ib_srp but not for traditional SCSI HBA drivers.
>> How about adding a BLK_MQ_F_* flag that tells __blk_mq_alloc_rq_maps() to
>> allocate a single set of tags for all hardware queues and also to add a flag
>> to struct scsi_host_template such that SCSI LLDs can enable this behavior?
>>
> 
> Hi Bart,
> 
> This would certainly be beneficial in my case. Moreover, it certainly 
> makes sense to move the logic up where multiple drivers can leverage. 
> 
> Perhaps, use percpu_ida* interfaces to do that, but I think I read 
> somewhere that, it is not efficient (enough?) and is the reason to go the 
> current way for block tags.

You don't have to change the underlying tag generation to solve this
problem, Bart already pretty much outlined a fix that would work.
percpu_ida works fine if you never use more than roughly half the
available space, it's a poor fit for request tags where we want to
retain good behavior and scaling at or near tag exhaustion. That's why
blk-mq ended up rolling its own, which is now generically available as
lib/sbitmap.c.

-- 
Jens Axboe
