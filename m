Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6721C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 06:45:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A048223A6C
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 06:45:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbgLHGpM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 01:45:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:36662 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725881AbgLHGpM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Dec 2020 01:45:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D9B2FAB63;
        Tue,  8 Dec 2020 06:44:30 +0000 (UTC)
Subject: Re: [RFC PATCH v2 0/2] add simple copy support
To:     dgilbert@interlog.com, Christoph Hellwig <hch@lst.de>,
        SelvaKumar S <selvakuma.s1@samsung.com>
Cc:     linux-nvme@lists.infradead.org, kbusch@kernel.org, axboe@kernel.dk,
        damien.lemoal@wdc.com, sagi@grimberg.me,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, snitzer@redhat.com, selvajove@gmail.com,
        nj.shetty@samsung.com, joshi.k@samsung.com,
        javier.gonz@samsung.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        linux-scsi@vger.kernel.org
References: <CGME20201204094719epcas5p23b3c41223897de3840f92ae3c229cda5@epcas5p2.samsung.com>
 <20201204094659.12732-1-selvakuma.s1@samsung.com>
 <20201207141123.GC31159@lst.de>
 <01fe46ac-16a5-d4db-f23d-07a03d3935f3@suse.de>
 <194d7813-8c8c-85c8-e0c8-94aaab7c291e@interlog.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <9b2f5ab2-3358-fcce-678f-982ef79c9252@suse.de>
Date:   Tue, 8 Dec 2020 07:44:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <194d7813-8c8c-85c8-e0c8-94aaab7c291e@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/7/20 11:12 PM, Douglas Gilbert wrote:
> On 2020-12-07 9:56 a.m., Hannes Reinecke wrote:
>> On 12/7/20 3:11 PM, Christoph Hellwig wrote:
>>> So, I'm really worried about:
>>>
>>>   a) a good use case.  GC in f2fs or btrfs seem like good use cases, as
>>>      does accelating dm-kcopyd.  I agree with Damien that lifting 
>>> dm-kcopyd
>>>      to common code would also be really nice.  I'm not 100% sure it 
>>> should
>>>      be a requirement, but it sure would be nice to have
>>>      I don't think just adding an ioctl is enough of a use case for 
>>> complex
>>>      kernel infrastructure.
>>>   b) We had a bunch of different attempts at SCSI XCOPY support form 
>>> IIRC
>>>      Martin, Bart and Mikulas.  I think we need to pull them into this
>>>      discussion, and make sure whatever we do covers the SCSI needs.
>>>
>> And we shouldn't forget that the main issue which killed all previous 
>> implementations was a missing QoS guarantee.
>> It's nice to have simply copy, but if the implementation is _slower_ 
>> than doing it by hand from the OS there is very little point in even 
>> attempting to do so.
>> I can't see any provisions for that in the TPAR, leading me to the 
>> assumption that NVMe simple copy will suffer from the same issue.
>>
>> So if we can't address this I guess this attempt will fail, too.
> 
> I have been doing quite a lot of work and testing in my sg driver rewrite
> in the copy and compare area. The baselines for performance are dd and
> io_uring-cp (in liburing). There are lots of ways to improve on them. Here
> are some:
>     - the user data need never pass through the user space (could
>       mmap it out during the READ if there is a good reason). Only the
>       metadata (e.g. NVMe or SCSI commands) needs to come from the user
>       space and errors, if any, reported back to the user space.
>     - break a large copy (or compare) into segments, with each segment
>       a "comfortable" size for the OS to handle, say 256 KB
>     - there is one constraint: the READ in each segment must complete
>       before its paired WRITE can commence
>       - extra constraint for some zoned disks: WRITEs must be
>         issued in order (assuming they are applied in that order, if
>         not, need to wait until each WRITE completes)
>     - arrange for READ WRITE pair in each segment to share the same bio
>     - have multiple slots each holding a segment (i.e. a bio and
>       metadata to process a READ-WRITE pair)
>     - re-use each slot's bio for the following READ-WRITE pair
>     - issue the READs in each slot asynchronously and do an interleaved
>       (io)poll for completion. Then issue the paired WRITE
>       asynchronously
>     - the above "slot" algorithm runs in one thread, so there can be
>       multiple threads doing the same algorithm. Segment manager needs
>       to be locked (or use an atomics) so that each segment (identified
>       by its starting LBAs) is issued once and only once when the
>       next thread wants a segment to copy
> 
> Running multiple threads gives diminishing or even worsening returns.
> Runtime metrics on lock contention and storage bus capacity may help
> choosing the number of threads. A simpler approach might be add more
> threads until the combined throughput increase is less than 10% say.
> 
> 
> The 'compare' that I mention is based on the SCSI VERIFY(BYTCHK=1) command
> (or NVMe NVM Compare command). Using dd logic, a disk to disk compare can
> be implemented with not much more work than changing the WRITE to a VERIFY
> command. This is a different approach to the Linux cmp utility which
> READs in both sides and does a memcmp() type operation. Using ramdisks
> (from the scsi_debug driver) the compare operation (max ~ 10 GB/s) was
> actually faster than the copy (max ~ 7 GB/s). I put this down to WRITE
> operations taking a write lock over the store while the VERIFY only
> needs a read lock so many VERIFY operations can co-exist on the same
> store. Unfortunately on real SAS and NVMe SSDs that I tested the
> performance of the VERIFY and NVM Compare commands is underwhelming.
> For comparison, using scsi_debug ramdisks, dd copy throughput was
> < 1 GB/s and io_uring-cp was around 2-3 GB/s. The system was Ryzen
> 3600 based.
> 
Which is precisely my concern.
Simple copy might be efficient for one particular implementation, but it 
might be completely off the board for others.
But both will be claiming to support it, and us having no idea whether 
choosing simple copy will speed up matters or not.
Without having a programmatic way to figure out the speed of the 
implementation we have to detect the performance ourselves, like the 
benchmarking loop RAID5 does.
I was hoping to avoid that, and just ask the device/controller; but that 
turned out to be in vain.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
