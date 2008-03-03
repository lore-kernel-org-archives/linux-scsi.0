From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Mon, 3 Mar 2008 23:52:04 +0900
Message-ID: <20080303235207S.tomof@acm.org>
References: <47CC036C.2060902@gmail.com>
	<20080303230121M.tomof@acm.org>
	<47CC09B6.6090709@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:53670 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756763AbYCCOyv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Mar 2008 09:54:51 -0500
In-Reply-To: <47CC09B6.6090709@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: htejun@gmail.com, jens.axboe@oracle.com
Cc: tomof@acm.org, fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, efault@gmx.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com

On Mon, 03 Mar 2008 23:22:46 +0900
Tejun Heo <htejun@gmail.com> wrote:

> FUJITA Tomonori wrote:
> >> At the end of blk_rq_map_user() together with data_len / extra_len
> >> mangling or were you talking about James' original patch?
> > 
> > With my patch, at the end of blk_rq_map_user, we have:
> > 
> > 	if (len & queue_dma_alignment(q)) {
> > 		unsigned int pad_len = (queue_dma_alignment(q) & ~len) + 1;
> > 
> > 		rq->extra_len += pad_len;
> > 	}
> > 
> > 
> > So no change as compared with 2.6.24?
> 
> Oh.. you killed sg list manipulation.  Many controllers do allow odd
> bytes as the last sg entry but not all.  Also, if you append drain

Until 2.6.24, these drivers have taken care about the issue by
themselves. There is no change as compared with 2.6.24.


> buffer after it, it ends up with unaligned sg entry in the middle and
> rq->data_len + rq->extra_len will overrun the sg entry after the drain
> page which is really dangerous.

The drivers know that they use drain buffer. They can take care about
themselves on this too. If we want to do explicitly, we could have
rq->pad_len and rq->drain_len instead of rq->extra_len, though I think
that we are fine without these values because these drivers already
tell the block layer what they want and know that the block layer
gives it.


Jens, want's your verdict on this?
