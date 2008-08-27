From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/5] block: add gfp_mask argument to blk_rq_map_user
	and blk_rq_map_user_iov
Date: Wed, 27 Aug 2008 10:30:11 +0900
Message-ID: <20080827100311C.fujita.tomonori@lab.ntt.co.jp>
References: <1219716654-27827-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1219716654-27827-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20080826163545.GA26201@infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mfo11.iij4u.or.jp ([210.138.174.81]:36981 "EHLO
	mfo11.iij4u.or.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbYH0BhB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Aug 2008 21:37:01 -0400
In-Reply-To: <20080826163545.GA26201@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, dougg@torque.net, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com

On Tue, 26 Aug 2008 12:35:45 -0400
Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, Aug 26, 2008 at 11:10:50AM +0900, FUJITA Tomonori wrote:
> > Currently, blk_rq_map_user and blk_rq_map_user_iov always do
> > GFP_KERNEL allocation.
> > 
> > This adds gfp_mask argument to blk_rq_map_user and blk_rq_map_user_iov
> > so sg can use it (sg always does GFP_ATOMIC allocation).
> 
> Most GFP_ATOMIC looks rather spurious to me, and are there probably
> for some historic reason.  Do you have a caller that actually needs
> GFP_ATOMIC because it's under a spinlock or from irq context,

No, we don't have.

> or is this just to stay as close as possible to the existing sg
> code?

Yes, I don't change sg behavior.

GFP_NOWAIT would be more appropriate than GFP_ATOMIC for sg, I guess.

But let me finish the conversion without changing sg behavior. I know
changing the behavior makes it more difficult to get Doug's ACK on
these patches.
