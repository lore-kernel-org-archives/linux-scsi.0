From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] block: add gfp_mask argument to blk_rq_map_user
	and blk_rq_map_user_iov
Date: Tue, 26 Aug 2008 12:35:45 -0400
Message-ID: <20080826163545.GA26201@infradead.org>
References: <1219716654-27827-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1219716654-27827-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58819 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbYHZQfs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Aug 2008 12:35:48 -0400
Content-Disposition: inline
In-Reply-To: <1219716654-27827-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, jens.axboe@oracle.com, dougg@torque.net, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com

On Tue, Aug 26, 2008 at 11:10:50AM +0900, FUJITA Tomonori wrote:
> Currently, blk_rq_map_user and blk_rq_map_user_iov always do
> GFP_KERNEL allocation.
> 
> This adds gfp_mask argument to blk_rq_map_user and blk_rq_map_user_iov
> so sg can use it (sg always does GFP_ATOMIC allocation).

Most GFP_ATOMIC looks rather spurious to me, and are there probably
for some historic reason.  Do you have a caller that actually needs
GFP_ATOMIC because it's under a spinlock or from irq context, or is this
just to stay as close as possible to the existing sg code?

