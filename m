From: Arne Jansen <lists@die-jansens.de>
Subject: Re: reusing bios
Date: Sat, 12 Mar 2011 14:58:25 +0100
Message-ID: <4D7B7C01.60407@die-jansens.de>
References: <4D7B3CF0.5040102@die-jansens.de> <4D7B462D.5000305@kernel.dk> <4D7B7636.5010206@die-jansens.de> <4D7B7991.2090305@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:57071 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab1CLN6Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Mar 2011 08:58:24 -0500
In-Reply-To: <4D7B7991.2090305@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-scsi@vger.kernel.org

Jens Axboe wrote:
> On 2011-03-12 14:33, Arne Jansen wrote:
>> Jens Axboe wrote:
>>> On 2011-03-12 10:29, Arne Jansen wrote:
>>>> Hi,
>>>>
>>>> I'm trying to re-use struct bio after completion, including the
>>>> allocated pages. Normally I re-initialize the fields bi_sector,
>>>> bi_size, bi_next, bi_flags, bi_comp_cpu and bi_bdev.
>>>> This works perfectly well, as long as no media errors are encountered.
>>>> After a media error, all subsequent reads with this bio fail. Are
>>>> there any more fields that need to get re-initialized? Or, better,
>>>> is there a function to reset the bio?
>>> bio_init()? Sounds like you are not setting BIO_UPTODATE when resetting
>>> it.
>>>
>> bio_init does way too much, as it discards the io_vec, refcnt, destructor,
>> private etc.
>> I set the flags to 1 << BIO_UPTODATE, but that proved to be fatal, too, as
>> it clobbers the POOL_FLAGS, which leads to an oops when the last reference
>> drops. These bio-beasts are just not made to be reused. One needs way too
>> much internal knowledge to reinitialize them properly.
>> Therefore, I'd really like to have a call like bio_reinit, which keeps the
>> io_vec and all the owners private information, but resets the parts that
>> get used by the stack like bi_next. Would that make sense?
> 
> The thing is, you can't really reuse without violating the allocator
> principle of finite life times. Otherwise you risk hanging the system.
> If you want to reuse, the bio should come out of your own pool or
> through the bio_kmalloc() interface, not from bio_alloc() with the
> default pool.
> 
> So there is no reinit, as there hasn't been a good use case for that.
> The fact that flags has pool information in the top bits is a sure sign
> you are violating that.
> 

ok, assuming I allocate them with bio_kmalloc, the problem of reinit would
remain. Now that I own them, I can't reuse them.
This particular use case here is a scrub for btrfs. I have a limited set of
bios and pages, that I reuse as long as the scrub runs. Of course I could
just free up and reallocate everything after each read, but as I know how
much work there is ahead, I can just as well keep them.

