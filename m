From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] block: fix nr_phys_segments miscalculation bug
Date: Sat, 11 Oct 2008 09:04:03 +0200
Message-ID: <20081011070402.GN19428@kernel.dk>
References: <20081011153048E.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpb.tele.dk ([80.160.77.98]:51566 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753842AbYJKHEk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Oct 2008 03:04:40 -0400
Content-Disposition: inline
In-Reply-To: <20081011153048E.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, knikanth@suse.de

On Sat, Oct 11 2008, FUJITA Tomonori wrote:
> This is against the latest git (b922df7383749a1c0b7ea64c50fa839263d3816b).
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] block: fix nr_phys_segments miscalculation bug
> 
> This fixes the bug reported by Nikanth Karthikesan <knikanth@suse.de>:
> 
> http://lkml.org/lkml/2008/10/2/203
> 
> The root cause of the bug is that blk_phys_contig_segment
> miscalculates q->max_segment_size.
> 
> blk_phys_contig_segment checks:
> 
> req->biotail->bi_size + next_req->bio->bi_size > q->max_segment_size
> 
> But blk_recalc_rq_segments might expect that req->biotail and the
> previous bio in the req are supposed be merged into one
> segment. blk_recalc_rq_segments might also expect that next_req->bio
> and the next bio in the next_req are supposed be merged into one
> segment. In such case, we merge two requests that can't be merged
> here. Later, blk_rq_map_sg gives more segments than it should.
> 
> We need to keep track of segment size in blk_recalc_rq_segments and
> use it to see if two requests can be merged. This patch implements it
> in the similar way that we used to do for hw merging (virtual
> merging).

This looks really good, just like I imagined. I'll give it a fuller
review later today and do a bit of targetted testing, if it goes as
planned it'll go in soonish. Thanks a lot!

-- 
Jens Axboe

