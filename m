From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 14/27] drivers/scsi: Use memdup_user
Date: Tue, 25 May 2010 17:15:31 +0300
Message-ID: <4BFBDB83.2090807@panasas.com>
References: <Pine.LNX.4.64.1005221022180.13021@ask.diku.dk>	 <1274538263.4410.38.camel@mulgrave.site>  <4BF94B89.2050101@panasas.com> <1274631752.5894.24.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:33476 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754053Ab0EYOPg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2010 10:15:36 -0400
In-Reply-To: <1274631752.5894.24.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Julia Lawall <julia@diku.dk>, Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

On 05/23/2010 07:22 PM, James Bottomley wrote:
> On Sun, 2010-05-23 at 18:36 +0300, Boaz Harrosh wrote:
>>> This type of transformation has really no value at all.  The code you're
>>> proposing to replace is already correct.  I'm fairly ambivalent on
>>> patterned APIs anyway but I accept they're useful way to prevent new
>>> code getting it wrong. However, it's completely bogus to force
>>> replacement of correctly functioning code throughout the kernel (unless
>>> you're going to argue that everyone who tries to copy from user into a
>>> kmalloc space does a cut and paste from sg?)
>>>
>>> Of infinitely greater service would be finding any places where the
>>> pattern is being incorrectly used.
>>>
>>
>> It looks like it is not done 100% kosher and calling memdup_user should
>> be better.
>>
>> - For 1 memdup_user does a GFP_KERNEL with a comment on how copy_from_user
>>   would eventually sleep, so what's the point of GFP_ATOMIC?
> 
> Well, since you've written a storage driver, I really hope that question
> is rhetorical ...
> 

Not really I do mean it in this case. It is not a storage-driver code
path. Is sg a storage-driver. I was not aware anyone used it for one.

> The reason for using GFP_ATOMIC from user context in storage drivers is
> to avoid writeout deadlock:  you don't want to trigger a swap write
> while you potentially occupy the writeout path.  In all older drivers
> this had to be GFP_ATOMIC because GFP_NOIO wasn't around.
> 

I confess my total swap ignorance. I was under the impression that
swap needs a block device. OK you could do a user-mode filesystem
over sg, under loop device. Does swap work over loop device=>ext2
for example? Or is there a way to directly swap over a filesystem
(Not block based)?

> This also illustrates the problem with design patterns:  The idea that
> if you have user context, you must be able to kmalloc GFP_KERNEL seems
> logical to the people who wrote the pattern, but actually it's
> potentially incorrect for storage.
> 

Again I confess my ignorance but I thought that copy_from_user can sleep
because of a page_fault which will invoke the memory allocation subsystem
anyway, so the out-of-memory condition will apply to copy_from_user as
well. But I don't have a clue, actually, why the copy_from_user might
sleep.

> Now in the particular case of sg, I don't believe we'll ever want to
> swap over sg (famous last words, of course), so in this instance we
> probably could get away with using GFP_KERNEL ... but since it's
> following the storage pattern, GFP_ATOMIC (or GFP_NOIO) is correct.
> 

Again I never considered sg as storage-driver. It is not a block-device
and is only used from user-mode that has it's out-of-memory-sleep problems
without sg.

> Does osd need auditing for this problem (or would no-one ever do swap
> over osd)?
> 

libosd's members all receive a gfp_t parameter and let the caller
determine the sleep policy. For example in osdblk allocations are
done with GFP_ATOMIC. At the exofs level everything is GFP_KERNEL
because that is one of the rules of VFS API. So osdblk should
theoretically be able to swap.

That said, in current kernel an iscsi device cannot be used for swap
because of NET. There was grate progress done to try and swap over
nfs which improved iscsi as well, but it was never seen all the way
through.

>> If this is by design then it surly calls for a comment that explains.
>> (I would like to know)
> 
> This pattern occurs many times in storage ... documenting it at every
> callsite would be a huge waste.
> 

So if this is serious, them maybe call copy_from_user_inatomic to match
the GFP_ATOMIC allocation?

> James
> 

Boaz
