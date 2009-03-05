From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [BUG] 2.6.29-rc6-2450cf in scsi_lib.c (was: Large amount of
	scsi-sgpool)objects
Date: Thu, 5 Mar 2009 20:40:16 +0900
Message-ID: <20090305204054E.fujita.tomonori@lab.ntt.co.jp>
References: <20090305103023.GW11787@kernel.dk>
	<20090305194118A.fujita.tomonori@lab.ntt.co.jp>
	<20090305111040.GZ11787@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:55130 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbZCELko (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Mar 2009 06:40:44 -0500
In-Reply-To: <20090305111040.GZ11787@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, James.Bottomley@HansenPartnership.com, jengelh@medozas.de, bharrosh@panasas.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org

On Thu, 5 Mar 2009 12:10:40 +0100
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Thu, Mar 05 2009, FUJITA Tomonori wrote:
> > On Thu, 5 Mar 2009 11:30:24 +0100
> > Jens Axboe <jens.axboe@oracle.com> wrote:
> > 
> > > > > While merging that, I think we can do better than this. Essentially we
> > > > > just need to have __blk_recalc_rq_segments() track the back bio as well,
> > > > > then we don't have to pass in a pointer for segment sizes.
> > > > > 
> > > > > Totally untested, comments welcome...
> > > > 
> > > > Yeah, I think that updating bi_seg_front_size and bi_seg_back_size at
> > > > one place, __blk_recalc_rq_segments, is better. I thought about the
> > > > same way. But we are already in -rc7 and this must go into mainline
> > > > now. So I chose a less-intrusive way (similar to what we have done in
> > > > the past).
> > > > 
> > > > As you know, the merging code is really complicated and we could
> > > > overlook stuff easily. ;) It might be better to simplify the merging
> > > > code a bit.
> > > 
> > > If someone (Ingo?) is willing to test the last variant, I'd much rather
> > > add that. It does simplify it (imho), and it kills 23 lines while only
> > > adding 9. But a quick response would be nice, then I can ask Linus to
> > > pull it later today.
> > 
> > I prefer to keep your change for 2.6.30 but if you want to push it
> > now, it's fine by me.
> 
> I honestly can't see much of a difference in change complexity, so I
> don't see much point in putting one fix in 2.6.29 and then doing another
> for 2.6.30...

My preference are:

1) simply reverting commit 1e42807918d17e8c93bf14fbb74be84b141334c1
(and blaming ext4 for now).

2) applying my patch, affecting only blk_recount_segments().

3) applying your patch, affecting blk_recount_segments() and
blk_recalc_rq_segments().


But as I said, the third options is fine by me. Your patch looks ok to
me.


> > Ingo, you can quickly hit this bug without the patch?
> > 
> > I've not hit this bug while I've been performing intensive I/Os for
> > the last three hours. And I thought that Thomas took two hours to hit
> > this. So maybe it's too early to give 'Tested-by'. With 
> > max_segment_size decreased, we might hit this easier.
> 
> Yep, that may help. I haven't seen this thread until I was cc'ed on it,
> so I haven't even read up on the generic problem yet...

I think that last night James and Thomas finally found that the block
layer miscalculates nr_phys_segments. And then I figured out exactly
where the bug is, I guess hopefully.
