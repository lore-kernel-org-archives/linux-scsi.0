From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH]: Implementation of blk_rq_map_kern_sg() (aka New implementation
  of scsi_execute_async() v3)
Date: Thu, 03 Sep 2009 20:34:58 +0400
Message-ID: <4A9FF032.2020000@vlnb.net>
References: <4A563368.5040407@vlnb.net> <4A830016.5020304@vlnb.net> <20090815082220.GJ12579@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755992AbZICQfm@vger.kernel.org>
In-Reply-To: <20090815082220.GJ12579@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Tejun Heo <tj@kernel.org>, Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Joe Eykholt <jeykholt@cisco.com>
List-Id: linux-scsi@vger.kernel.org

Jens Axboe, on 08/15/2009 12:22 PM wrote:
> On Wed, Aug 12 2009, Vladislav Bolkhovitin wrote:
>> This patch implements function blk_rq_map_kern_sg(), which allows to map
>> a kernel-originated SG vector to a block request. It is necessary to execute
>> SCSI commands with from kernel going SG buffer. At the moment SCST is the only
>> user of this functionality. It needs it, because its target drivers, which
>> are, basically, SCSI drivers, can deal only with SGs, not with BIOs. But,
>> according to the latest discussions, there can be other potential users for of
>> this functionality, so I'm sending this patch in a hope that it will be
>> also useful for them and eventually will be merged in the mainline kernel.
>>
>> In the previous submissions this patch was called "New implementation of
>> scsi_execute_async()", but since in this version scsi_execute_async() was
>> removed from it by request of Boaz Harrosh the name was changed accordingly.
> 
> Generally this patch looks great, I just have one little thing I'd like
> to point out:
> 
>> +	while (hbio != NULL) {
>> +		bio = hbio;
>> +		hbio = hbio->bi_next;
>> +		bio->bi_next = NULL;
>> +
>> +		blk_queue_bounce(q, &bio);
>> +
>> +		res = blk_rq_append_bio(q, rq, bio);
>> +		if (unlikely(res != 0)) {
>> +			bio->bi_next = hbio;
>> +			hbio = bio;
>> +			/* We can have one or more bios bounced */
>> +			goto out_unmap_bios;
>> +		}
>> +	}
> 
> Constructs like this are always dangerous, because of how mempools work.
> __blk_queue_bounce() will internally do:
> 
>         bio = bio_alloc(GFP_NOIO, cnt);
> 
> so you could potentially enter a deadlock if a) you are the only one
> allocating a bio currently, and b) the alloc fails and we wait for a bio
> to be returned to the pool. This is highly unlikely and requires other
> conditions to be dire, but it is a problem. This is not restricted to
> the swap out path, the problem is purely lack of progress. So the golden
> rule is always that you either allocate these units from a private pool
> (which is hard for bouncing, since it does both page and bio allocations
> from a mempool), or that you always ensure that a previously allocated
> bio is in flight before attempting a new alloc.

Sorry for the late reply, I was on vacation.

I see your concerns. Since all the bios in __blk_rq_map_kern_sg() at 
first all allocated and only then submitted for I/O, bio_alloc() in 
__blk_queue_bounce() potentially can deadlock, if it's called with 
GFP_NOIO (i.e. with __GFP_WAIT) and its mempool gets empty. The fact 
that __blk_rq_map_kern_sg() allocates originally bios using 
bio_kmalloc() doesn't fundamentally change that, only low the failure 
probability. (Just to make sure I understand everything correctly.)

Potentially this can be a problem, since SCST nearly always uses 
GFP_KERNEL as the mask, i.e. has __GFP_WAIT set, although, I agree, the 
deadlock is very unlikely.

To address it and other similar cases, which, I guess, should exist, I 
see the following 2 ways:

1. Increase BIO_POOL_SIZE from current 2 to a bigger value to be large 
enough to satisfy such full requests allocations for the maximum 
requests. In ideal, for the worst case it should be something like for 
2MB * NR_CPUS much data, which is 2MB / (BIO_MAX_PAGES * PAGE_SIZE) * 
NR_CPUS = 2NR_CPUS with 4K pages. But on practice, possibly something 
like 10-20 should be sufficient?

2. Modify blk_queue_bounce() that it can fail with bounce buffers 
allocation and graciously process that in __blk_rq_map_kern_sg() and all 
other similar places.

Which way would you prefer? Or do you think the probability for such 
deadlock is so low, so it doesn't worth the effort to do anything with it?

Thanks a lot for review!
Vlad
