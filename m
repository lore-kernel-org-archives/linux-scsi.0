From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCHSET 0/5] Peaceful co-existence of scsi_sgtable and Large
 IO sg-chaining
Date: Thu, 26 Jul 2007 20:33:44 +0900
Message-ID: <20070726203344X.fujita.tomonori@lab.ntt.co.jp>
References: <46A70944.6030005@panasas.com>
	<20070725174258T.fujita.tomonori@lab.ntt.co.jp>
	<46A7A2EC.6040400@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:46469 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbXGZLjJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jul 2007 07:39:09 -0400
In-Reply-To: <46A7A2EC.6040400@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, bhalevy@panasas.com, James.Bottomley@SteelEye.com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCHSET 0/5] Peaceful co-existence of scsi_sgtable and Large IO sg-chaining
Date: Wed, 25 Jul 2007 22:22:20 +0300

> FUJITA Tomonori wrote:
> > From: Benny Halevy <bhalevy@panasas.com>
> > Subject: Re: [PATCHSET 0/5] Peaceful co-existence of scsi_sgtable and Large IO sg-chaining
> > Date: Wed, 25 Jul 2007 11:26:44 +0300
> > 
> >>> However, I'm perfectly happy to go with whatever the empirical evidence
> >>> says is best .. and hopefully, now we don't have to pick this once and
> >>> for all time ... we can alter it if whatever is chosen proves to be
> >>> suboptimal.
> >> I agree.  This isn't a catholic marriage :)
> >> We'll run some performance experiments comparing the sgtable chaining
> >> implementation vs. a scsi_data_buff implementation pointing
> >> at a possibly chained sglist and let's see if we can measure
> >> any difference.  We'll send results as soon as we have them.
> > 
> > I did some tests with your sgtable patchset and the approach to use
> > separate buffer for sglists. As expected, there was no performance
> > difference with small I/Os. I've not tried very large I/Os, which
> > might give some difference.
> > 
> > The patchset to use separate buffer for sglists is available:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-bidi.git simple-sgtable
> > 
> > 
> > Can you clean up your patchset and upload somewhere?
> 
> Sorry sure. Here is scsi_sgtable complete work over linux-block:
> http://www.bhalevy.com/open-osd/download/scsi_sgtable/linux-block
>  
> Here is just scsi_sgtable, no chaining, over scsi-misc + more
> drivers:
> http://www.bhalevy.com/open-osd/download/scsi_sgtable/scsi-misc
> 
> 
> Next week I will try to mount lots of scsi_debug devices and
> use large parallel IO to try and find a difference. I will
> test Jens's sglist-arch tree against above sglist-arch+scsi_sgtable
> 
> I have lots of reservations about Tomo's last patches. For me
> they are a regression. They use 3 allocations per command instead
> of 2. They use an extra pointer and an extra global slab_pool. And
> for what, for grouping some scsi_cmnd members in a substructure.
> If we want to go the "pointing" way, keeping our extra scatterlist
> and our base_2 count on most ARCHs. Than we can just use the 
> scsi_data_buff embedded inside scsi_cmnd. 

Yeah, I changed and tested the patch to embed one sgtable header
structure in struct scsi_cmnd for uni-directional transfers.

Somehow, I uploaded the old patchset to my bidi tree yesterday.


> The second scsi_data_buff for bidi can come either from an extra 
> slab_pool like in Tomo's patch - bidi can pay - or in scsi.c at 
> scsi_setup_command_freelist() the code can inspect Tomo's flag 
> to the request_queue QUEUE_FLAG_BIDI and will than allocate a 
> bigger scsi_cmnd in the free list.
> 
> I have coded that approach and it is very simple:
> http://www.bhalevy.com/open-osd/download/scsi_data_buff
> 
> They are over Jens's sglist-arch branch
> I have revised all scsi-ml places and it all compiles
> But is totally untested.

This is similar to the patch that I tested.


> I will add this branch to the above tests, but I suspect that
> they are identical in every way to current code.

With the large I/Os, there might be some difference.
