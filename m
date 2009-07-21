From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH]: New implementation of scsi_execute_async()
Date: Tue, 21 Jul 2009 22:26:28 +0400
Message-ID: <4A660854.6080805@vlnb.net>
References: <4A563368.5040407@vlnb.net> <4A59DF14.7060807@panasas.com> <4A5CAF66.3090909@vlnb.net> <4A5D9117.2060205@panasas.com> <4A5F6DC2.5040008@vlnb.net> <4A6304C7.3070200@panasas.com> <4A64AF63.6050300@vlnb.net> <4A65765A.8040203@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755656AbZGUS0o@vger.kernel.org>
In-Reply-To: <4A65765A.8040203@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Boaz Harrosh, on 07/21/2009 12:03 PM wrote:
>>> Yes that's what I want, and if you can not save some of it's complexity
>>> by, for example, merging of scsi_io_context with the request structure you
>>> already have at scst level, or save the double-chained-callbacks at the end,
>>> then you've done something wrong.
>> Are you sure??
>>
>> As I already wrote, in SCST sense allocated on-demand only. It is done
>> for performance reasons, because the sense is needed _very_ rarely and
>> the buffer for it is quite big, so it's better to save those allocating,
>> zeroing and CPU cache trashing. The fact that Linux SCSI ML requires
>> sense buffer preallocation is for me something rather to be fixed.
>> Pass-through SCST backend is used relatively rarely as well, so it's
>> better to keep the sense preallocation for it in the separate code path.
>> Then, if there is the sense preallocation, it doesn't matter to alloc
>> with it few bytes more.
>>
>> Is it getting clearer now?
> 
> Yes it is now clear to me that scst is a mess.

Sounds impressive. But how much this claim related to the reality? Have 
you even looked at the SCST code?

> you cannot have more then
> can_queue commands in-filght. 256 allocated mem_cache buffers of size 64-bytes
> or size 96+64 bytes does not matter performance. It's the number of allocations
> that count not the size of allocation, usually. If you want you can have a bigger
> mem_cache in the scsi-pass-through case to hold a special-with-sense scst-command-
> structure.

Just FYI: (1) SCST from the very beginning has been designed and 
implemented to have the best possible performance, (2) InfiniBand 
already have 1 mks latency and this doesn't seem to be a limit, (3) the 
maximum sense size defined by SPC is 252 bytes, not 96.

> All drivers that care about sense find a way.
> 
> BTW you can call blk_execute_nowait without a sense buffer at all, it is optional.

And so? To lost this sense, if there is one? Would you do so yourself?

Boaz, what are you doing? Are we discussing a particular implementation 
problem or are you trying by any means to prove how stupid and ignorant 
I am? Let's return to the problem and stop doing nonsense claims!

>>>> Does flag SCSI_ASYNC_EXEC_FLAG_AT_HEAD have nothing to do to SCSI, really?
>>>>
>>> Exactly, it's just a parameter at the call to blk_execute_nowait() with it's
>>> own defines already. Nothing SCSI.
>> Well, going this way we can go too far.. Like, to assertion that SCSI
>> HEAD OF QUEUE task attribute is a property of the Linux block layer as well.
>>
> 
> No "SCSI HEAD OF QUEUE task attribute" is a scsi attribute, none-scsi block
> devices will not understand what it is. It is executed by the scsi-device.
> Your flag will work for all block devices exactly because it is a parameter
> to the block layer.
> 
> If you are implementing the scsi protocol to the letter then you must make sure
> all subsystems comply for example pass the proper flag to the Linux block subsystem.

Again rather a nonsense claim. Of course, in the absolute for full 
support of HEAD OF QUEUE attribute blk should be modified to be aware of 
it to keep the corresponding requests in the head of the queue as well 
as to keep HEAD OF QUEUE attribute set for the corresponding SCSI 
commands. But, from practical POV, if there is a big stuck queue, 
inserting a HEAD OF QUEUE request in the head of it is a _lot_ better, 
than in the tail.

> Hell look at your own code. And answer a simple question what does
> SCSI_ASYNC_EXEC_FLAG_AT_HEAD do, and how does it do it:
> 
> +	blk_execute_rq_nowait(req->q, NULL, req,
> +		flags & SCSI_ASYNC_EXEC_FLAG_AT_HEAD, scsi_end_async);
> 
> I'd say it's just a bit carrier to a boolean parameter at the call to
> blk_execute_rq_nowait

And so? Does it let us have a good approximation to what we need for 
HEAD OF QUEUE commands? Yes, it does. This is a regular practice to pass 
flags down to a call stack and it's used in a million of places.

>>>>>>>> +/**
>>>>>>>> + * blk_rq_unmap_kern_sg - "unmaps" data buffers in the request
>>>>>>>> + * @req:	request to unmap
>>>>>>>> + * @do_copy:	sets copy data between buffers, if needed, or not
>>>>>>>> + *
>>>>>>>> + * Description:
>>>>>>>> + *    It frees all additional buffers allocated for SG->BIO mapping.
>>>>>>>> + */
>>>>>>>> +void blk_rq_unmap_kern_sg(struct request *req, int do_copy)
>>>>>>>> +{
>>>>>>>> +	struct scatterlist *hdr = (struct scatterlist *)req->end_io_data;
>>>>>>>> +
>>>>>>> You can't use req->end_io_data  here! req->end_io_data is reserved for
>>>>>>> blk_execute_async callers. It can not be used for private block use.
>>>>>> Why? I see blk_execute_rq() happily uses it. Plus, I implemented stacking of
>>>>>> it in scsi_execute_async().
>>>>>>
>>>>> As I said users of blk_execute_rq_nowait() blk_execute_rq is a user of
>>>>> blk_execute_rq_nowait just as the other guy.
>>>>>
>>>>> "implemented stacking" is exactly the disaster I'm talking about.
>>>>> Also it totaly breaks the blk API. Now I need to to specific code
>>>>> when mapping with this API as opposed to other mappings when I execute
>>>>>
>>>>>> Do you have better suggestion?
>>>>> I have not look at it deeply but you'll need another system. Perhaps
>>>>> like map_user/unmap_user where you give unmap_user the original bio.
>>>>> Each user of map_user needs to keep a pointer to the original bio
>>>>> on mapping. Maybe some other options as well. You can use the bio's
>>>>> private data pointer, when building the first bio from scatter-list.
>>>> I can't see how *well documented* stacking of end_io_data can be/lead to 
>>>> any problem. All the possible alternatives I can see are worse:
>>>>
>>>> 1. Add in struct request one more field, like "void *blk_end_io_data" 
>>>> and use it.
>>>>
>>>> 2. Duplicate code of bio's allocation and chaining 
>>>> (__blk_rq_map_kern_sg()) for the copy case with additional code for 
>>>> allocation and copying of the copy buffers on per-bio basis and use 
>>>> bio->bi_private to track the copy info. Tejun Heo used this approach, 
>>>> but he had only one bio without any chaining. With the chaining this 
>>>> approach becomes terribly overcomplicated and ugly with *NO* real gain.
>>>>
>>>> Do you like any of them? If not, I'd like to see _practical_ suggestions.
>>>>
>>> Again all this is not needed and should be dropped it is already done
>>> by bio bouncing. All you need to do is add the pages to bios, chain when
>>> full, and call blk_make_request.
>> Can you show me a place where the bio bouncing, i.e.
>> blk_queue_bounce(), does bouncing of misaligned buffers?
>>
> 
> It's there look harder

Could you point to the exact lines of code, please?

>> I don't see such places. Instead, I see that all users of the block API,
>> who cares about the alignment (sg, st, sr, etc.), directly or indirectly
>> take care about it, by, e.g., switching to copying functions, before
>> calling blk_queue_bounce(). See blk_rq_map_user_iov(), for instance.
>> This is exactly what I implemented: handling of misaligned buffers on
>> the layer upper blk_queue_bounce().
>>
> 
> Read the code again, I agree it is a grate mess but ...
> 
> For example what about filesystems they just put buffers on a bio and call
> generic_make_request. sg st sr all do grate stupid things because of historical
> reasons.
> 
> See the old scsi_execute_async of scsi_lib.c where was that alignment and
> padding? there was not! did it work?
> 
> Look at blk_map_kern, where is alignment and padding handling? does it work?

Of course, it works. From blk_rq_map_kern() from 2.6.30.1:

do_copy = !blk_rq_aligned(q, kbuf, len) || object_is_on_stack(kbuf);
if (do_copy)
	bio = bio_copy_kern(q, kbuf, len, gfp_mask, reading);
else
	bio = bio_map_kern(q, kbuf, len, gfp_mask);
...
blk_queue_bounce(q, &rq->bio);
...
return 0;

Vlad
