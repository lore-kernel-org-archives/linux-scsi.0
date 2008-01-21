From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] remove use_sg_chaining
Date: Mon, 21 Jan 2008 12:31:08 +0200
Message-ID: <4794746C.6000807@panasas.com>
References: <1200419579.9273.39.camel@localhost.localdomain> <47939E9B.9020906@panasas.com> <1200857062.3105.15.camel@localhost.localdomain> <20080120192942.GW6258@kernel.dk> <4793A78A.6000604@panasas.com> <20080120195956.GY6258@kernel.dk> <20080120200117.GZ6258@kernel.dk> <1200862756.3105.26.camel@localhost.localdomain> <479458A1.90009@panasas.com> <20080121093112.GG6258@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:48567 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758555AbYAUKbc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Jan 2008 05:31:32 -0500
In-Reply-To: <20080121093112.GG6258@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, Jan 21 2008 at 11:31 +0200, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Mon, Jan 21 2008, Boaz Harrosh wrote:
>> On Sun, Jan 20 2008 at 22:59 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
>>> On Sun, 2008-01-20 at 21:01 +0100, Jens Axboe wrote:
>>>> On Sun, Jan 20 2008, Jens Axboe wrote:
>>>>> On Sun, Jan 20 2008, Boaz Harrosh wrote:
>>>>>> On Sun, Jan 20 2008 at 21:29 +0200, Jens Axboe <jens.axboe@oracle.com> wrote:
>>>>>>> On Sun, Jan 20 2008, James Bottomley wrote:
>>>>>>>> On Sun, 2008-01-20 at 21:18 +0200, Boaz Harrosh wrote:
>>>>>>>>> On Tue, Jan 15 2008 at 19:52 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
>>>>>>>>>> this patch depends on the sg branch of the block tree
>>>>>>>>>>
>>>>>>>>>> James
>>>>>>>>>>
>>>>>>>>>> ---
>>>>>>>>>> From: James Bottomley <James.Bottomley@HansenPartnership.com>
>>>>>>>>>> Date: Tue, 15 Jan 2008 11:11:46 -0600
>>>>>>>>>> Subject: remove use_sg_chaining
>>>>>>>>>>
>>>>>>>>>> With the sg table code, every SCSI driver is now either chain capable
>>>>>>>>>> or broken, so there's no need to have a check in the host template.
>>>>>>>>>>
>>>>>>>>>> Also tidy up the code by moving the scatterlist size defines into the
>>>>>>>>>> SCSI includes and permit the last entry of the scatterlist pools not
>>>>>>>>>> to be a power of two.
>>>>>>>>>> ---
>>>>>>>>> I have a theoretical problem that BUGed me from the beginning.
>>>>>>>>>
>>>>>>>>> Could it happen that a memory critical IO, (that is needed to free
>>>>>>>>> memory), be collected into an sg-chained large IO, and the allocation 
>>>>>>>>> of the multiple sg-pool-allocations fail, thous dead locking on
>>>>>>>>> out-of-memory? Is there a mechanism in place that will split large IO's 
>>>>>>>>> into smaller chunks in the event of out-of-memory condition in prep_fn?
>>>>>>>>>
>>>>>>>>> Is it possible to call blk_rq_map_sg() with less then what is present
>>>>>>>>> at request to only map the starting portion?
>>>>>>>> Obviously, that's why I was worrying about mempool size and default
>>>>>>>> blocks a while ago.
>>>>>>>>
>>>>>>>> However, the deadlock only occurs if the device is swap or backing a
>>>>>>>> filesystem with memory mapped files.  The use cases for this are really
>>>>>>>> tapes and other entities that need huge buffers.  That's why we're
>>>>>>>> keeping the system sector size at 1024 unless you alter it through sysfs
>>>>>>>> (here gun, there foot ...)
>>>>>>> Alternatively (and much safer, imho), we allow blk_rq_map_sg() return
>>>>>>> smaller than nr_phys_segments and just ensure that the request is
>>>>>>> continued nicely through the normal 'request if residual' logic.
>>>>>>>
>>>>>> Thats a grate Idea. I will Q it on my todo list. Thanks
>>>>> ok good, thanks :-)
>>>> btw, the above is full of typos, my apologies. it should read "requeue
>>>> if residual", but I guess you already guessed as much.
>>> Something like ...
>>>
>>> It looks to me like it would make sense to have something like a
>>> BLKPREP_SGALLOCFAIL return so the block layer can do this for us ...
>>> Alternatively, we'll have to find a way of adjusting the sector count as
>>> it goes into the ULD prep functions.
>>>
>>> James
>> By luck this is no problem because it happens exactly before the ULD
>> actually prepares the command. sd and sr are already doing these
>> adjustments based on bufflen. For BLOCK_PC we will need to fail with
>> perhaps a new BLKPREP_SGALLOCFAIL, like you said, and let the
>> initiator take care of it.
> 
> Right, the scsi_init_io() takes care of it and adjusts the buflen as
> needed, no need to pass this "erro"r back. As far as I'm concerned,
> blocking for BLOCK_PC requests should be fine (is anyone using these for
> swap?).
> 
I was also thinking of a live-lock as opposed to dead-lock, where thousands
of requests are issued to tens/hundreds of devices all large chained IO, so each
fails to allocate second order chain segment and all are stuck in a traffic jam.
Maybe BLKPREP_SGALLOCFAIL could mean wait for normal BLOCK_PC commands and return
if FAIL_FAST. But I guess we can do that much later, after the picture settles.
(And some experiments are do)

Thanks Jens
Boaz
