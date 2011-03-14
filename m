From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: reusing bios
Date: Mon, 14 Mar 2011 15:10:26 -0700
Message-ID: <AANLkTimBjsDz3gCVvNRsC2R1eq4Um=Hi6dQ0cWF15x-f@mail.gmail.com>
References: <4D7B3CF0.5040102@die-jansens.de>
	<4D7B462D.5000305@kernel.dk>
	<4D7B7636.5010206@die-jansens.de>
	<4D7B7991.2090305@kernel.dk>
	<4D7B7C01.60407@die-jansens.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64239 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099Ab1CNWK2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Mar 2011 18:10:28 -0400
Received: by fxm17 with SMTP id 17so3426409fxm.19
        for <linux-scsi@vger.kernel.org>; Mon, 14 Mar 2011 15:10:27 -0700 (PDT)
In-Reply-To: <4D7B7C01.60407@die-jansens.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arne Jansen <lists@die-jansens.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org

On Sat, Mar 12, 2011 at 5:58 AM, Arne Jansen <lists@die-jansens.de> wrote:
> Jens Axboe wrote:
>>
>> On 2011-03-12 14:33, Arne Jansen wrote:
>>>
>>> Jens Axboe wrote:
>>>>
>>>> On 2011-03-12 10:29, Arne Jansen wrote:
>>>>>
>>>>> Hi,
>>>>>
>>>>> I'm trying to re-use struct bio after completion, including the
>>>>> allocated pages. Normally I re-initialize the fields bi_sector,
>>>>> bi_size, bi_next, bi_flags, bi_comp_cpu and bi_bdev.
>>>>> This works perfectly well, as long as no media errors are encountered.
>>>>> After a media error, all subsequent reads with this bio fail. Are
>>>>> there any more fields that need to get re-initialized? Or, better,
>>>>> is there a function to reset the bio?
>>>>
>>>> bio_init()? Sounds like you are not setting BIO_UPTODATE when resetting
>>>> it.
>>>>
>>> bio_init does way too much, as it discards the io_vec, refcnt,
>>> destructor,
>>> private etc.
>>> I set the flags to 1 << BIO_UPTODATE, but that proved to be fatal, too,
>>> as
>>> it clobbers the POOL_FLAGS, which leads to an oops when the last
>>> reference
>>> drops. These bio-beasts are just not made to be reused. One needs way too
>>> much internal knowledge to reinitialize them properly.
>>> Therefore, I'd really like to have a call like bio_reinit, which keeps
>>> the
>>> io_vec and all the owners private information, but resets the parts that
>>> get used by the stack like bi_next. Would that make sense?
>>
>> The thing is, you can't really reuse without violating the allocator
>> principle of finite life times. Otherwise you risk hanging the system.
>> If you want to reuse, the bio should come out of your own pool or
>> through the bio_kmalloc() interface, not from bio_alloc() with the
>> default pool.
>>
>> So there is no reinit, as there hasn't been a good use case for that.
>> The fact that flags has pool information in the top bits is a sure sign
>> you are violating that.
>>
>
> ok, assuming I allocate them with bio_kmalloc, the problem of reinit would
> remain. Now that I own them, I can't reuse them.
> This particular use case here is a scrub for btrfs. I have a limited set of
> bios and pages, that I reuse as long as the scrub runs. Of course I could
> just free up and reallocate everything after each read, but as I know how
> much work there is ahead, I can just as well keep them.

Have a look at drivers/md/raid5.c::ops_run_io() the stripe_head bios
are allocated once at initialization and reused for the life of the
array.

--
Dan
