From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH] [Target_Core_Mod/pSCSI]: Add optional legacy scsi_execute_async()
 usage for Linux/SCSI passthrough
Date: Fri, 24 Apr 2009 23:17:50 +0400
Message-ID: <49F2105E.8010001@vlnb.net>
References: <1239930560.4176.577.camel@haakon2.linux-iscsi.org> <49EB036B.8090607@panasas.com> <49EDB8EF.7040503@vlnb.net> <49EF1A88.1040105@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:60276 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbZDXTSL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Apr 2009 15:18:11 -0400
In-Reply-To: <49EF1A88.1040105@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Tejun Heo <tj@kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <jens.axboe@oracle.com>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, Geoff Levand <geoffrey.levand@am.sony.com>, Douglas Gilbert <dgilbert@interlog.com>, Christoph Hellwig <hch@lst.de>, Paul Mundt <lethal@linux-sh.org>

Boaz Harrosh, on 04/22/2009 05:24 PM wrote:
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
> 3. What is data-format got to do with sync/async execution
> 4. the need of all that scsi_io_context and the re-invention
>    of async_done API.
> 5. ...
> Good riddence

Removal of what can be removed from the above I meant under "the 
necessary bits".

> But you might be looking into an API introduced by an RFC by
> Tejun Heo in the form of blk_rq_map_kern_sgl() which should
> be a more appropriate general API for your use.

Yes, it looks like what's needed.

> (And is not directly usable for me in OSD)
> 
>> Vlad
> 
> Boaz
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

