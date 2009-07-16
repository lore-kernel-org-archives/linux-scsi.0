From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH v2]: New implementation of scsi_execute_async()
Date: Thu, 16 Jul 2009 22:17:18 +0400
Message-ID: <4A5F6EAE.8020106@vlnb.net>
References: <4A563368.5040407@vlnb.net> <4A5CAFB5.1000901@vlnb.net> <4A5EDC53.5050902@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:60163 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932416AbZGPSRL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jul 2009 14:17:11 -0400
In-Reply-To: <4A5EDC53.5050902@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>, Joe Eykholt <jeykholt@cisco.com>

Hello, Tejun

Tejun Heo, on 07/16/2009 11:52 AM wrote:
> Hello, Vladislav.
> 
> Sorry about the delay.
> 
> Vladislav Bolkhovitin wrote:
>> This patch reimplements scsi_execute_async(). In the new version
>> it's a lot less hackish and also has additional features. Namely:
> 
> :-)

The "hackish" was not about your work, it was about the original 
implementation, which was too often blamed as "hackish" ;-)

>> 1. Possibility to insert commands both in tail and in head of the queue.
>>
>> 2. Possibility to explicitly specify if the last SG element has
>> space for padding.
>>
>> This patch based on the previous patches posted by Tejun
>> Heo. Comparing to them it has the following improvements:
>>
>> 1. It uses BIOs chaining instead of kmalloc()ing the whole bio.
>>
>> 2. It uses SGs chaining instead of kmalloc()ing one big SG in case
>> if direct mapping failed (e.g. because of DMA alignment or padding).
>>
>> 3. If direct mapping failed, if possible, it copies only the last SG
>> element, not the whole SG.
>>
>> 4. When needed, copy_page() is used instead of memcpy() to copy the
>> whole pages.
>>
>> Also this patch adds and exports functions sg_copy() and
>> sg_copy_elem(), which cop one SG to another and one SG element to
>> another respectively.
>>
>> At the moment SCST is the only user of this functionality. It needs
>> it, because its target drivers, which are, basically, SCSI drivers,
>> can deal only with SGs, not with BIOs. But, according the latest
>> discussions, there are other potential users for of this
>> functionality, so I'm sending this patch in a hope that it will be
>> also useful for them and eventually will be merged in the mainline
>> kernel.
>>
>> This patch requires previously sent patch with subject "[PATCH]:
>> Rename REQ_COPY_USER to more descriptive
>> REQ_HAS_TAIL_SPACE_FOR_PADDING".
> 
> The original patchset was focused more on unifying user and kernel and
> user sg mapping handling.  It seems you implemented the kernel part
> completely separately.  Wouldn't it be better to unify where possible?

I don't see a place where they can be unified from using the existing 
user mapping functionality POV. And in your patchset it was the same. 
Unifying in the opposite direction is possible, i.e. implementing 
blk_rq_map_kern() via blk_rq_map_kern_sg(). But this will save a very 
minor code piece (few tens LOCs). Would you like me to do it?

> Or is there some fundamental reason that can't be done that I missed?

See above.

> Also, code organization-wise, I think good part of the posted code
> belongs to bio.c.

Could you be more specific, please?

> The tail-only copying is nice but I'm not entirely sure whether such
> full-blown approach is necessary.  The tail padding was added
> primarily for dumb ATAPI devices which want to transfer more bytes
> than requested.  Having extra space at the end makes the driver's job
> much easier as it can just overflow into the area.  Some controller do
> have "drain after this" flag in the dma table but some simply can't
> handle such situations properly without explicit overflow area.
> 
> So, being the horrid hack it is and highly unlikely to be used in
> performance sensitive path, I think it would be better to keep the
> implementation simple and dull.  It just isn't something worth
> investing complexity over.  Of course, if you have a use case which
> requires high performance tail padding, it's a different story.

SCST allocates buffers in pages, so there is always a tail space, except 
one relatively rare case of scst_local target driver, which allows usage 
of the SCST-exported devices locally on the same host. For it the tail 
spacing information is lost in the entrails of the block/SCSI 
subsystems. So, why not to have the tail-only copying? Code-wise it's 
quite simple, just few tens lines of code.

Thanks,
Vlad
