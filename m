From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] [Target_Core_Mod/pSCSI]: Add optional legacy	scsi_execute_async()
 usage for Linux/SCSI passthrough
Date: Wed, 22 Apr 2009 15:06:13 -0400
Message-ID: <49EF6AA5.80500@interlog.com>
References: <1239930560.4176.577.camel@haakon2.linux-iscsi.org> <49EB036B.8090607@panasas.com> <49EDB8EF.7040503@vlnb.net> <49EF1A88.1040105@panasas.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:53708 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756754AbZDVTGY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2009 15:06:24 -0400
In-Reply-To: <49EF1A88.1040105@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, Tejun Heo <tj@kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <jens.axboe@oracle.com>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, Geoff Levand <geoffrey.levand@am.sony.com>, Christoph Hellwig <hch@lst.de>, Paul Mundt <lethal@linux-sh.org>

Boaz Harrosh wrote:
> On 04/21/2009 03:15 PM, Vladislav Bolkhovitin wrote:
>> Boaz Harrosh, on 04/19/2009 02:56 PM wrote:
>>> On 04/17/2009 04:09 AM, Nicholas A. Bellinger wrote:
>> [..]
>>
>>> Are you aware that scsi_execute_async() has gone in 2.6.30-rc1?
>>>
>>> I'm not sure what would be the best alternative for you. I would say
>>> a bio, but it is still being debated. Your current options are:
>>>
>>> 1. bio_alloc then loop () bio_add_pc_page, and finally blk_rq_append_bio
>>>    (Which block people don't like)
>>> 2. sglist => page-pointers-array translation and blk_rq_map_user with 
>>>    struct rq_map_data mode. (not possible with all kind of sglists)
>>> 2. sglist => iovec translation and blk_rq_map_user_iov()
>>>    (Very very ugly mapping of pages to virtual pointers)
>>>
>>> I have a similar situation with my OSD code.
>> Do you have somewhere in it a need to run an arbitrary CDB with data 
>> pages stored in an sglist? Is that code accepted in the mainline?
>>
> 
> No, I have a direct bio which comes from two sources.
> 1. A bio prepared by a filesystem to describe a write/read to a file (osd object)
> 2. A cloned bio that comes from a stacking block-device over osd-object.
> 
> So I do not have an sglist at all, anywhere in code.
> 
>> If yes, why not to resurrect the necessary bits of scsi_execute_async() 
>> (option (1) above)? It was deleted, because in 2.6.30 there are no users 
>> of it left, but if there are users (OSD), then why not to return it? 
>> Seems nothing better for the sg->bio case can be invented.
>>
> 
> I hate scsi_execute_async() for lots of reasons, 
> 1. The cover-up of an historical abuse of sglists by sg/sr
> 2. Override of use_sg/data-pointer crap

Hate, abuse, crap??
[I believe the author of scsi_execute_async() is cc-ed on
your post.]

It served a purpose when the block layer was taking over
sglist handling and was synchronous. Block error handling
was non-existent or poor at the time. The block layer
wanted to disown the sg and st drivers because they didn't
fit its crude model. So scsi_execute_async() was our
"get out of the !@#$ing block system" card.

Happily the block system has evolved to being able to
provide the async handling and error processing that
it, sg and st need. It is now a non-block system.

So scsi_execute_async() has become superfluous.

> 3. What is data-format got to do with sync/async execution

A fair bit in async. For example I'd like to know when data-out
buffers can be re-used and data-in buffers are ready. If it was
really clever it could alert me when thresholds were met in
the data-in buffer.

Doug Gilbert

> 4. the need of all that scsi_io_context and the re-invention
>    of async_done API.
> 5. ...
> Good riddence
> 
> But you might be looking into an API introduced by an RFC by
> Tejun Heo in the form of blk_rq_map_kern_sgl() which should
> be a more appropriate general API for your use.
> (And is not directly usable for me in OSD)
> 
>> Vlad
> 
> Boaz
> 

