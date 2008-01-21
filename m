From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] remove use_sg_chaining
Date: Mon, 21 Jan 2008 10:32:33 +0200
Message-ID: <479458A1.90009@panasas.com>
References: <1200419579.9273.39.camel@localhost.localdomain>	 <47939E9B.9020906@panasas.com>	 <1200857062.3105.15.camel@localhost.localdomain>	 <20080120192942.GW6258@kernel.dk> <4793A78A.6000604@panasas.com>	 <20080120195956.GY6258@kernel.dk>  <20080120200117.GZ6258@kernel.dk> <1200862756.3105.26.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:18371 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758015AbYAUIct (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Jan 2008 03:32:49 -0500
In-Reply-To: <1200862756.3105.26.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Sun, Jan 20 2008 at 22:59 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Sun, 2008-01-20 at 21:01 +0100, Jens Axboe wrote:
>> On Sun, Jan 20 2008, Jens Axboe wrote:
>>> On Sun, Jan 20 2008, Boaz Harrosh wrote:
>>>> On Sun, Jan 20 2008 at 21:29 +0200, Jens Axboe <jens.axboe@oracle.com> wrote:
>>>>> On Sun, Jan 20 2008, James Bottomley wrote:
>>>>>> On Sun, 2008-01-20 at 21:18 +0200, Boaz Harrosh wrote:
>>>>>>> On Tue, Jan 15 2008 at 19:52 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
>>>>>>>> this patch depends on the sg branch of the block tree
>>>>>>>>
>>>>>>>> James
>>>>>>>>
>>>>>>>> ---
>>>>>>>> From: James Bottomley <James.Bottomley@HansenPartnership.com>
>>>>>>>> Date: Tue, 15 Jan 2008 11:11:46 -0600
>>>>>>>> Subject: remove use_sg_chaining
>>>>>>>>
>>>>>>>> With the sg table code, every SCSI driver is now either chain capable
>>>>>>>> or broken, so there's no need to have a check in the host template.
>>>>>>>>
>>>>>>>> Also tidy up the code by moving the scatterlist size defines into the
>>>>>>>> SCSI includes and permit the last entry of the scatterlist pools not
>>>>>>>> to be a power of two.
>>>>>>>> ---
>>>>>>> I have a theoretical problem that BUGed me from the beginning.
>>>>>>>
>>>>>>> Could it happen that a memory critical IO, (that is needed to free
>>>>>>> memory), be collected into an sg-chained large IO, and the allocation 
>>>>>>> of the multiple sg-pool-allocations fail, thous dead locking on
>>>>>>> out-of-memory? Is there a mechanism in place that will split large IO's 
>>>>>>> into smaller chunks in the event of out-of-memory condition in prep_fn?
>>>>>>>
>>>>>>> Is it possible to call blk_rq_map_sg() with less then what is present
>>>>>>> at request to only map the starting portion?
>>>>>> Obviously, that's why I was worrying about mempool size and default
>>>>>> blocks a while ago.
>>>>>>
>>>>>> However, the deadlock only occurs if the device is swap or backing a
>>>>>> filesystem with memory mapped files.  The use cases for this are really
>>>>>> tapes and other entities that need huge buffers.  That's why we're
>>>>>> keeping the system sector size at 1024 unless you alter it through sysfs
>>>>>> (here gun, there foot ...)
>>>>> Alternatively (and much safer, imho), we allow blk_rq_map_sg() return
>>>>> smaller than nr_phys_segments and just ensure that the request is
>>>>> continued nicely through the normal 'request if residual' logic.
>>>>>
>>>> Thats a grate Idea. I will Q it on my todo list. Thanks
>>> ok good, thanks :-)
>> btw, the above is full of typos, my apologies. it should read "requeue
>> if residual", but I guess you already guessed as much.
> 
> Something like ...
> 
> It looks to me like it would make sense to have something like a
> BLKPREP_SGALLOCFAIL return so the block layer can do this for us ...
> Alternatively, we'll have to find a way of adjusting the sector count as
> it goes into the ULD prep functions.
> 
> James

By luck this is no problem because it happens exactly before the ULD actually
prepares the command. sd and sr are already doing these adjustments based on
bufflen. For BLOCK_PC we will need to fail with perhaps a new BLKPREP_SGALLOCFAIL,
like you said, and let the initiator take care of it.

Boaz

