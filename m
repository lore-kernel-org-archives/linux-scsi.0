From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH]: New implementation of scsi_execute_async()
Date: Sun, 19 Jul 2009 14:34:31 +0300
Message-ID: <4A6304C7.3070200@panasas.com>
References: <4A563368.5040407@vlnb.net> <4A59DF14.7060807@panasas.com> <4A5CAF66.3090909@vlnb.net> <4A5D9117.2060205@panasas.com> <4A5F6DC2.5040008@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753533AbZGSLei@vger.kernel.org>
In-Reply-To: <4A5F6DC2.5040008@vlnb.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 07/16/2009 09:13 PM, Vladislav Bolkhovitin wrote:
> Boaz Harrosh, on 07/15/2009 12:19 PM wrote:
>>>>>  block/blk-map.c            |  536 +++++++++++++++++++++++++++++++++++++++++++++
>>>>>  drivers/scsi/scsi_lib.c    |  108 ++++++++-
>>>>>  include/linux/blkdev.h     |    6 
>>>>>  include/scsi/scsi_device.h |   11 
>>>>>  4 files changed, 660 insertions(+), 1 deletion(-)
>>>>>
>>>> The scsi bits are not needed and just add complexity. 
>>>> allocate the request, call blk_rq_map_kern_sg() and
>>>> blk_execute_xxx directly from your driver. Since you exacly
>>>> know your code path lots of if(s) and flags are saved and that ugly
>>>> scsi_io_context allocation.
>>> Are you against any helper functions? scsi_lib.c has only scsi_execute_async(),
>>> which is a small helper function, which only hides internal machinery details.
>>> All the flags it has are needed and can't be avoided, especially
>>> SCSI_ASYNC_EXEC_FLAG_HAS_TAIL_SPACE_FOR_PADDING
>> Yes I'm sure. This will not be accepted. Just do it directly in the driver
>> like all other ULD's and block layer users. Use direct blk API. All these little
>> things and flags you are talking about are block specific, there is no single thing
>> SCSI about them.
> 
> Hmm, I don't understand. What's wrong in this small helper function? Are 
> you against any helper functions, so, all users of, e.g., for_each_sg() 
> must instead open code the corresponding functionality?
> 
> Do you want me to move scsi_execute_async() from scsi_lib.c to 
> scst_lib.c and rename it to scst_execute_async()? This is the maximum I 
> can do, because I need this functionality. But it will make all other 
> possible users to duplicate it.
> 

Yes that's what I want, and if you can not save some of it's complexity
by, for example, merging of scsi_io_context with the request structure you
already have at scst level, or save the double-chained-callbacks at the end,
then you've done something wrong.

> Does flag SCSI_ASYNC_EXEC_FLAG_AT_HEAD have nothing to do to SCSI, really?
> 

Exactly, it's just a parameter at the call to blk_execute_nowait() with it's
own defines already. Nothing SCSI.

>>> The allocation of scsi_io_context is unavoidable, because sense buffer should
>>> be allocated anyway.
>>>  
>> NO!, driver needs to do it's job and provide a sense buffer and call blk API
>> just like all the other drivers. this has nothing to do with SCSI.
> 
> What job should a driver do? As I wrote, for SCST allocation of the 
> sense buffer is necessary in any case (in SCST sense is allocated on 
> demand only), so it doesn't matter to allocate few bytes more, if it 
> allows to hide unneeded low level details. The same, I guess, should be 
> true for all other possible users of this functionality.
> 

Easiest, as all users do is: If you already have your scst request or
command, or what ever you call it. So add a sense_buffer array embedded
there, end of story no allocation needed.

How can you be a scsi-target and return the proper errors upstream,
without digging into sense-buffer and error returns to produce the
correct report.

>>>>> +/**
>>>>> + * blk_rq_unmap_kern_sg - "unmaps" data buffers in the request
>>>>> + * @req:	request to unmap
>>>>> + * @do_copy:	sets copy data between buffers, if needed, or not
>>>>> + *
>>>>> + * Description:
>>>>> + *    It frees all additional buffers allocated for SG->BIO mapping.
>>>>> + */
>>>>> +void blk_rq_unmap_kern_sg(struct request *req, int do_copy)
>>>>> +{
>>>>> +	struct scatterlist *hdr = (struct scatterlist *)req->end_io_data;
>>>>> +
>>>> You can't use req->end_io_data  here! req->end_io_data is reserved for
>>>> blk_execute_async callers. It can not be used for private block use.
>>> Why? I see blk_execute_rq() happily uses it. Plus, I implemented stacking of
>>> it in scsi_execute_async().
>>>
>> As I said users of blk_execute_rq_nowait() blk_execute_rq is a user of
>> blk_execute_rq_nowait just as the other guy.
>>
>> "implemented stacking" is exactly the disaster I'm talking about.
>> Also it totaly breaks the blk API. Now I need to to specific code
>> when mapping with this API as opposed to other mappings when I execute
>>
>>> Do you have better suggestion?
>> I have not look at it deeply but you'll need another system. Perhaps
>> like map_user/unmap_user where you give unmap_user the original bio.
>> Each user of map_user needs to keep a pointer to the original bio
>> on mapping. Maybe some other options as well. You can use the bio's
>> private data pointer, when building the first bio from scatter-list.
> 
> I can't see how *well documented* stacking of end_io_data can be/lead to 
> any problem. All the possible alternatives I can see are worse:
> 
> 1. Add in struct request one more field, like "void *blk_end_io_data" 
> and use it.
> 
> 2. Duplicate code of bio's allocation and chaining 
> (__blk_rq_map_kern_sg()) for the copy case with additional code for 
> allocation and copying of the copy buffers on per-bio basis and use 
> bio->bi_private to track the copy info. Tejun Heo used this approach, 
> but he had only one bio without any chaining. With the chaining this 
> approach becomes terribly overcomplicated and ugly with *NO* real gain.
> 
> Do you like any of them? If not, I'd like to see _practical_ suggestions.
> 

Again all this is not needed and should be dropped it is already done
by bio bouncing. All you need to do is add the pages to bios, chain when
full, and call blk_make_request.

> Thanks.
> Vlad

Boaz
