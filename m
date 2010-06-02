From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] scsi: fix scsi_get_lba helper function for pc command
Date: Wed, 02 Jun 2010 12:23:01 +0300
Message-ID: <4C0622F5.3040903@panasas.com>
References: <4C0612CC.6050602@panasas.com>	<20100602173925H.fujita.tomonori@lab.ntt.co.jp>	<4C061C41.2010104@panasas.com> <20100602180515J.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:58540 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752819Ab0FBJXG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2010 05:23:06 -0400
In-Reply-To: <20100602180515J.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@suse.de, jaxboe@fusionio.com, linux-scsi@vger.kernel.org, Sathya.Prakash@lsi.com

On 06/02/2010 12:05 PM, FUJITA Tomonori wrote:
> On Wed, 02 Jun 2010 11:54:25 +0300
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>>> Some LLDs already use scsi_get_lba(). They don't know scsi command
>>> from pc or fs so they can't use scsi_get_lba() now. Well, they can see
>>> scsi_cmnd->request to know pc or fs but it's layer violation. They
>>> shouldn't access to the block layer stuff.
>>>
>>
>> right, so hide it all under an API that is implemented at the right
>> level, and protect them. The driver should call a single simple
>> API the magic will be done at the generic level
>>
>> 	if (blk_fs_rq(req))
>> 		return blk_rq_pos(req);
>> 	else
>> 		return scsi_somthing();
> 
> The first version that I posted yesterday is something like that. But
> I don't think that it's clean.
> 

I can't find it. I'd like to see

> 
>>>> Only drivers/code that actually cares should call this member.
>>>>
>>>> It should be easy enough to search for __sector and change them
>>>> to a function call.
>>>
>>> I don't think that calling such function in LLDs is a clean design. We
>>> set request->__sector for fs requests. Why not for pc requests? Then
>>> we can use blk_rq_pos() cleanly. 
>>>
>>
>> Because "fs requests" have a defined blk_rq_pos(). But "pc requests"
>> don't necessarily have one. Pretending to invent one is stupid and
>> dangerous. Better keep a -1 for all "pc requests".
> 
> I don't see your logic, why using blk_rq_pos() for pc is dangerous?

I already explained. because you must know the device type before
you assume the presence of lba.

> 
>> scsi LLDs can be pass-through for disks, as well as lots of other
>> type of devices. They should not assume the role of a disk. The use
>> of blk_rq_pos() at LLDs is probably wrong in the first place. Unless
>> it is some kind of scsi emulation driver like scsi_debug.
> 
> Not only scsi_debug. Have you seen how scsi_get_lba() is used? LLDs
> sometime needs to know lba in scsi commands.
> 
> How about calling this function in sd_prep_fn, sr_prep_fn instead of
> scsi_setup_blk_pc_cmnd? Then it doesn't affect OSD.

That's fine because these know that they are disk and ROM/RAM device types.

Watch out with sr because it supports other command sets. there might
be more too it.

Boaz


