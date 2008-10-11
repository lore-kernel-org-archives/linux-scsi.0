From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] block: fix nr_phys_segments miscalculation bug
Date: Sat, 11 Oct 2008 17:01:48 +0900
Message-ID: <20081011170124N.fujita.tomonori@lab.ntt.co.jp>
References: <20081011153048E.fujita.tomonori@lab.ntt.co.jp>
	<20081011070402.GN19428@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:39193 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbYJKIDc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Oct 2008 04:03:32 -0400
In-Reply-To: <20081011070402.GN19428@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, knikanth@suse.de

On Sat, 11 Oct 2008 09:04:03 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Sat, Oct 11 2008, FUJITA Tomonori wrote:
> > This is against the latest git (b922df7383749a1c0b7ea64c50fa839263d3816b).
> > 
> > =
> > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Subject: [PATCH] block: fix nr_phys_segments miscalculation bug
> > 
> > This fixes the bug reported by Nikanth Karthikesan <knikanth@suse.de>:
> > 
> > http://lkml.org/lkml/2008/10/2/203
> > 
> > The root cause of the bug is that blk_phys_contig_segment
> > miscalculates q->max_segment_size.
> > 
> > blk_phys_contig_segment checks:
> > 
> > req->biotail->bi_size + next_req->bio->bi_size > q->max_segment_size
> > 
> > But blk_recalc_rq_segments might expect that req->biotail and the
> > previous bio in the req are supposed be merged into one
> > segment. blk_recalc_rq_segments might also expect that next_req->bio
> > and the next bio in the next_req are supposed be merged into one
> > segment. In such case, we merge two requests that can't be merged
> > here. Later, blk_rq_map_sg gives more segments than it should.
> > 
> > We need to keep track of segment size in blk_recalc_rq_segments and
> > use it to see if two requests can be merged. This patch implements it
> > in the similar way that we used to do for hw merging (virtual
> > merging).
> 
> This looks really good, just like I imagined. I'll give it a fuller
> review later today and do a bit of targetted testing, if it goes as
> planned it'll go in soonish. Thanks a lot!

Thanks,

One thing that I thought about fixing is that we could falsely
increase bi_seg_front_size and bi_seg_back_size in
ll_merge_requests_fn() though I chose the same way in which we did for
hw merging.

We might update bi_seg_front_size and bi_seg_back_size if
blk_phys_contig_segment() succeeds. But if total_phys_segments check
fails after blk_phys_contig_segment(), we could falsely increase
bi_seg_front_size and bi_seg_back_size.

But falsely increasing bi_seg_front_size and bi_seg_back_size doesn't
cause any bug. It just means we have less segments. So I let it
alone.


Oh, I forgot to say, I was able to reproduce the bug easily and wow
this patch seems to fix the bug for me.
