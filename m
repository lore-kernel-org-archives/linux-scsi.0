From: Mark Lord <liml@rtr.ca>
Subject: Re: QUEUE_FLAG_CLUSTER: not working in 2.6.24 ?
Date: Thu, 13 Dec 2007 15:14:55 -0500
Message-ID: <476192BF.5050308@rtr.ca>
References: <20071213185326.GQ26334@parisc-linux.org> <4761821F.3050602@rtr.ca> <20071213192633.GD10104@kernel.dk> <4761883A.7050908@rtr.ca> <476188C4.9030802@rtr.ca> <20071213193937.GG10104@kernel.dk> <47618B0B.8020203@rtr.ca> <20071213195350.GH10104@kernel.dk> <20071213200219.GI10104@kernel.dk> <476190BE.9010405@rtr.ca> <20071213200958.GK10104@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20071213200958.GK10104@kernel.dk>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Mark Lord <lkml@rtr.ca>, Matthew Wilcox <matthew@wil.cx>, IDE/ATA development list <linux-ide@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Jens Axboe wrote:
> On Thu, Dec 13 2007, Mark Lord wrote:
>> Jens Axboe wrote:
>>> On Thu, Dec 13 2007, Jens Axboe wrote:
>>>> On Thu, Dec 13 2007, Mark Lord wrote:
>>>>> Jens Axboe wrote:
>>>>>> On Thu, Dec 13 2007, Mark Lord wrote:
>>>>>>> Mark Lord wrote:
>>>>>>>> Jens Axboe wrote:
>>>>>>>>> On Thu, Dec 13 2007, Mark Lord wrote:
>>>>>>>>>> Matthew Wilcox wrote:
>>>>>>>>>>> On Thu, Dec 13, 2007 at 01:48:18PM -0500, Mark Lord wrote:
>>>>>>>>>>>> Problem confirmed.  2.6.23.8 regularly generates segments up to 
>>>>>>>>>>>> 64KB for libata,
>>>>>>>>>>>> but 2.6.24 uses only 4KB segments and a *few* 8KB segments.
>>>>>>>>>>> Just a suspicion ... could this be slab vs slub?  ie check your 
>>>>>>>>>>> configs
>>>>>>>>>>> are the same / similar between the two kernels.
>>>>>>>>>> ..
>>>>>>>>>>
>>>>>>>>>> Mmmm.. a good thought, that one.
>>>>>>>>>> But I just rechecked, and both have CONFIG_SLAB=y
>>>>>>>>>>
>>>>>>>>>> My guess is that something got changed around when Jens
>>>>>>>>>> reworked the block layer for 2.6.24.
>>>>>>>>>> I'm going to dig around in there now.
>>>>>>>>> I didn't rework the block layer for 2.6.24 :-). The core block layer
>>>>>>>>> changes since 2.6.23 are:
>>>>>>>>>
>>>>>>>>> - Support for empty barriers. Not a likely candidate.
>>>>>>>>> - Shared tag queue fixes. Totally unlikely.
>>>>>>>>> - sg chaining support. Not likely.
>>>>>>>>> - The bio changes from Neil. Of the bunch, the most likely suspects 
>>>>>>>>> in
>>>>>>>>> this area, since it changes some of the code involved with merges and
>>>>>>>>> blk_rq_map_sg().
>>>>>>>>> - Lots of simple stuff, again very unlikely.
>>>>>>>>>
>>>>>>>>> Anyway, it sounds odd for this to be a block layer problem if you do 
>>>>>>>>> see
>>>>>>>>> occasional segments being merged. So it sounds more like the input 
>>>>>>>>> data
>>>>>>>>> having changed.
>>>>>>>>>
>>>>>>>>> Why not just bisect it?
>>>>>>>> ..
>>>>>>>>
>>>>>>>> Because the early 2.6.24 series failed to boot on this machine
>>>>>>>> due to bugs in the block layer -- so the code that caused this 
>>>>>>>> regression
>>>>>>>> is probably in the stuff from before the kernels became usable here.
>>>>>>> ..
>>>>>>>
>>>>>>> That sounds more harsh than intended --> the earlier 2.6.24 kernels 
>>>>>>> (up to
>>>>>>> the first couple of -rc* ones failed here because of incompatibilities
>>>>>>> between the block/bio changes and libata.
>>>>>>>
>>>>>>> That's better, I think! 
>>>>>> No worries, I didn't pick it up as harsh just as an odd conclusion :-)
>>>>>>
>>>>>> If I were you, I'd just start from the first -rc that booted for you. If
>>>>>> THAT has the bug, then we'll think of something else. If you don't get
>>>>>> anywhere, I can run some tests tomorrow and see if I can reproduce it
>>>>>> here.
>>>>> ..
>>>>>
>>>>> I believe that *anyone* can reproduce it, since it's broken long before
>>>>> the requests ever get to SCSI or libata.  Which also means that *anyone*
>>>>> who wants to can bisect it, as well.
>>>>>
>>>>> I don't do "bisects".
>>>> It was just a suggestion on how to narrow it down, do as you see fit.
>>>>
>>>>> But I will dig a bit more and see if I can find the culprit.
>>>> Sure, I'll dig around as well.
>>> Just tried something simple. I only see one 12kb segment so far, so not
>>> a lot by any stretch. I also DONT see any missed merges signs, so it
>>> would appear that the pages in the request are simply not contigious
>>> physically.
>>>
>>> diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
>>> index e30b1a4..1e34b6f 100644
>>> --- a/block/ll_rw_blk.c
>>> +++ b/block/ll_rw_blk.c
>>> @@ -1330,6 +1330,8 @@ int blk_rq_map_sg(struct request_queue *q, struct 
>>> request *rq,
>>> 				goto new_segment;
>>>
>>> 			sg->length += nbytes;
>>> +			if (sg->length > 8192)
>>> +				printk("sg_len=%d\n", sg->length);
>>> 		} else {
>>> new_segment:
>>> 			if (!sg)
>>> @@ -1349,6 +1351,8 @@ new_segment:
>>> 				sg = sg_next(sg);
>>> 			}
>>>
>>> +			if (bvprv && (page_address(bvprv->bv_page) + 
>>> bvprv->bv_len == page_address(bvec->bv_page)))
>>> +				printk("missed merge\n");
>>> 			sg_set_page(sg, bvec->bv_page, nbytes, 
>>> 			bvec->bv_offset);
>>> 			nsegs++;
>>> 		}
>>>
>> ..
>>
>> Yeah, the first part is similar to my own hack.
>>
>> For testing, try "dd if=/dev/sda of=/dev/null bs=4096k".
>> That *really* should end up using contiguous pages on most systems.
>>
>> I figured out the git thing, and am now building some in-between kernels to 
>> try.
> 
> OK, it's a vm issue, I have tens of thousand "backward" pages after a
> boot - IOW, bvec->bv_page is the page before bvprv->bv_page, not
> reverse. So it looks like that bug got reintroduced.
...

Mmm.. shouldn't one of the front- or back- merge logics work for either order?


