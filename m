From: Benny Halevy <bhalevy@panasas.com>
Subject: Re: [RFC 4/8] scsi-ml: scsi_sgtable implementation
Date: Wed, 18 Jul 2007 22:21:28 +0300
Message-ID: <469E6838.8070405@panasas.com>
References: <468CDB3C.4060500@panasas.com> <468CF58E.1020901@panasas.com> <46967C78.3070100@cs.wisc.edu> <20070712154739K.tomof@acm.org> <469E1FEE.9060106@panasas.com> <20070718141903.GB11657@kernel.dk> <469E2B17.3050603@panasas.com> <20070718180350.GD11657@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:18541 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762270AbXGRUJ4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jul 2007 16:09:56 -0400
In-Reply-To: <20070718180350.GD11657@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, FUJITA Tomonori <tomof@acm.org>, michaelc@cs.wisc.edu, James.Bottomley@SteelEye.com, fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org, linux-scsi@vger.kernel.org

Jens Axboe wrote:
> On Wed, Jul 18 2007, Boaz Harrosh wrote:
>> Jens Axboe wrote:
>>> On Wed, Jul 18 2007, Boaz Harrosh wrote:
>>>> FUJITA Tomonori wrote:
>>>>> From: Mike Christie <michaelc@cs.wisc.edu>
>>>>> Subject: Re: [RFC 4/8] scsi-ml: scsi_sgtable implementation
>>>>> Date: Thu, 12 Jul 2007 14:09:44 -0500
>>>>>
>>>>>> Boaz Harrosh wrote:
>>>>>>> +/*
>>>>>>> + * Should fit within a single page.
>>>>>>> + */
>>>>>>> +enum { SCSI_MAX_SG_SEGMENTS =
>>>>>>> +	((PAGE_SIZE - sizeof(struct scsi_sgtable)) /
>>>>>>> +	sizeof(struct scatterlist)) };
>>>>>>> +
>>>>>>> +enum { SG_MEMPOOL_NR =
>>>>>>> +	(SCSI_MAX_SG_SEGMENTS >= 7) +
>>>>>>> +	(SCSI_MAX_SG_SEGMENTS >= 15) +
>>>>>>> +	(SCSI_MAX_SG_SEGMENTS >= 31) +
>>>>>>> +	(SCSI_MAX_SG_SEGMENTS >= 63) +
>>>>>>> +	(SCSI_MAX_SG_SEGMENTS >= 127) +
>>>>>>> +	(SCSI_MAX_SG_SEGMENTS >= 255) +
>>>>>>> +	(SCSI_MAX_SG_SEGMENTS >= 511)
>>>>>>> +};
>>>>>>>  
>>>>>> What does SCSI_MAX_SG_SEGMENTS end up being on x86 now? On x86_64 or 
>>>>>> some other arch, we were going over a page when doing 
>>>>>> SCSI_MAX_PHYS_SEGMENTS of 256 right?
>>>>> Seems that 170 with x86 and 127 with x86_64.
>>>>>
>>>> with scsi_sgtable we get one less than now
>>>>
>>>> Arch                      | SCSI_MAX_SG_SEGMENTS =  | sizeof(struct scatterlist)
>>>> --------------------------|-------------------------|---------------------------
>>>> x86_64                    | 127                     |32
>>>> i386 CONFIG_HIGHMEM64G=y  | 204                     |20
>>>> i386 other                | 255                     |16
>>>>
>>>> What's nice about this code is that now finally it is
>>>> automatically calculated in compile time. Arch people
>>>> don't have the headache "did I break SCSI-ml?". 
>>>> For example observe the current bug with i386 
>>>> CONFIG_HIGHMEM64G=y.
>>>>
>>>> The same should be done with BIO's. Than ARCHs with big
>>>> pages can gain even more.
>>>>
>>>>>> What happened to Jens's scatter list chaining and how does this relate 
>>>>>> to it then?
>>>>> With Jens' sglist, we can set SCSI_MAX_SG_SEGMENTS to whatever we
>>>>> want. We can remove the above code.
>>>>>
>>>>> We need to push this and Jens' sglist together in one merge window, I
>>>>> think.
>>>> No Tomo the above does not go away. What goes away is maybe:
>>> It does go away, since we can just set it to some safe value and use
>>> chaining to get us where we want.
>> In my patches SCSI_MAX_PHYS_SEGMENTS has went away it does not exist
>> anymore.
> 
> Sure, I could just kill it as well. The point is that it's a parallel
> development, there's nothing in your patch that helps the sg chaining
> whatsoever. The only "complex" thing in the SCSI layer for sg chaining,
> is chaining when allocating and walking that chain on freeing. That's
> it!

It seems like having the pool index in the sgtable structure simplifies
the implementation a bit for allocation and freeing of linked sgtables.
Boaz will send an example tomorrow (hopefully) showing how the merged
code looks like.

> 
>> The new SCSI_MAX_SG_SEGMENTS (your name by the way) is right there
>> and is calculated to maximize allocation in one page.
> 
> Yes, it's still a good idea to make sure you get good packing in the
> page, it's of course cheaper to have less chaining. But it's not
> critical in the same way as before, when it could impact IO layout and
> performance.
> 
>> (I guess the right name is SCSI_MAX_PHYS_SEGMENTS_IN_A_PAGE)
>> which will be needed in both your patches and mine.
> 
> That would be better name.
> 
>>>>  	blk_queue_max_hw_segments(q, shost->sg_tablesize);
>>>> -	blk_queue_max_phys_segments(q, SCSI_MAX_SG_SEGMENTS);
>>>>  	blk_queue_max_sectors(q, shost->max_sectors);
>>>>
>> The reporting above is not needed and can be what ever block layer
>> considers safe/optimized.
> 
> You still need to set it, you can't just ignore it. Whether you redefine
> SCSI_MAX_SG_SEGMENTS or use (unsigned short) -1 doesn't really matter a
> whole lot.
> 
>>>> I'm working on a convergence patches that will do scsi_sg_pools cleanup
>>>> which is common to both our patches, than scsi_sgtable, and than 
>>>> sg-chaining on top of that. I hope it gets accepted. 
>>>> The sg-chaining is much much simpler over scsi_sgtables.
>>> Sorry, I don't follow this paragraph at all. What is the scsi_sgtables
>>> change you are referring to? And how does it make sg chaining so much
>>> simpler?
>>>
>>> I guess my problem is that I don't know what problem this scsi_sgtables
>>> you refer to is fixing?
>>>
>> scsi_sgtable is a solution proposed by James Bottomley where all I/O
>> members of struct scsi_cmnd and the resid member, which need to be
>> duplicated for bidirectional transfers, can be allocated together with
>> the sg-list they are pointing to. This way when bidi comes, the all
>> structure can be duplicated with minimal change to code, and with no
>> extra baggage when bidi is not used.  This was the all motivation for
>> the data accessors and cleanup, swiping through the entire scsi tree.
>> So when implementation changes drivers do not change with them. Now
>> meanwhile moving over drivers code we (well Tomo mostly) removed the
>> old !use_sg code path, and also abstracted the 2 major hot spots of
>> above usages with scsi_dma_{un,}map, and the scsi_for_each_sg.
>> Actually that one was changed from the original definition to match
>> you macro.
>>
>> Since scsi_sgtable is an encapsulation of the actual scatterlist array
>> together with the sg_count bufflen and pool_index, it gives code a
>> nice clean OO touch, and makes handling very easy, thats all. It only
>> simplifies things at the scsi-ml level.
> 
> So it's a pre-requisite for bidi support, it has no bearing on sg
> chaining. The only thing they have in common is that the touch some of
> the same code, that does not make them dependent or related beyond that
> necessarily.
> 

