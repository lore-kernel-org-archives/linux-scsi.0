From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 14/17] scsi: replace custom rq mapping with	blk_rq_map_kern_sgl()
Date: Wed, 15 Apr 2009 13:25:04 +0900
Message-ID: <49E561A0.7040607@kernel.org>
References: <20090413125912.GA16337@liondog.tnic>	<20090414093401V.fujita.tomonori@lab.ntt.co.jp>	<20090414100131.GA14646@liondog.tnic> <20090415084431H.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:48906 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbZDOEZT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Apr 2009 00:25:19 -0400
In-Reply-To: <20090415084431H.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: petkovbb@gmail.com, bharrosh@panasas.com, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, axboe@kernel.dk, bzolnier@gmail.com, linux-kernel@vger.kernel.org

Hello,

Sorry about the delay.

FUJITA Tomonori wrote:
>> Basically, I opted for preallocating a sense request in the ->do_request
>> routine and do that only on demand, i.e. I reinitialize it only if it
>> got used in the irq handler. So in case you want to shove a rq sense in
>> front of the queue, you simply use the already prepared one. Then in the
>> irq handler it is being finished the usual ways (blk_end_request). Next
>> time around you ->do_request, you reallocate it again since it got eaten
>> in the last round.
> 
> Sounds a workable solution.

Haven't actually looked at the code but sweeeeeet.

>> The good thing is that now I don't need all those static block layer
>> structs in the driver (bio, bio_vec, etc) and do the preferred dynamic
>> allocation instead.
> 
> That's surely good.
> 
> Well, if you could remove the usage of request structure that are not
> came from blk_get_request, it will be super. But it's a different
> topic and Tejun can go forward without such change.
> 
>> The patch is ontop of Tejun's series at
>> http://git.kernel.org/?p=linux/kernel/git/tj/misc.git;a=shortlog;h=ide-phase1
>> with some small modifications in commit 15783b1443f810ae72cb5ccb3a3a3ccc3aeb8729
>> wrt proper sense buffer length.
> 
> I think that Tejun will drop some of the patchset. At least, we don't
> need blk_rq_map_kern_prealloc stuff. I think that Tejun doesn't need
> to play with the mapping API. Well, we need to play with the mapping
> API for OSD but it's not directly related with the block layer
> cleanups necessary for the libata SCSI separation.

Yeah, the blk_rq_map_kern_prealloc() was basically shifting rq map
from ide to blk/bio so that at least codes are all in one place.  If
it's not necessary, super.  :-)

I'll drop stuff from this and the other patchset and repost them with
Borislav's patch in a few hours.  Thanks guys.

-- 
tejun
