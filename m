From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/2] block: move the padding adjustment to blk_rq_map_sg
Date: Mon, 7 Apr 2008 22:11:05 +0900
Message-ID: <20080407221103Y.tomof@acm.org>
References: <47F45035.8060003@gmail.com>
	<20080407200756G.fujita.tomonori@lab.ntt.co.jp>
	<47FA061A.8000107@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:40509 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757340AbYDGNOe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Apr 2008 09:14:34 -0400
In-Reply-To: <47FA061A.8000107@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: htejun@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, tomof@acm.org, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com

On Mon, 07 Apr 2008 20:31:38 +0900
Tejun Heo <htejun@gmail.com> wrote:

> FUJITA Tomonori wrote:
> >> Maybe we need yet another flag indicating padding space
> >> availability?
> > 
> > How about doing the exact same thing that the drain buffer does? We
> > can put pre-allocated buffer to a queue and save one sg entry for it.
> 
> Each sg entry should be aligned so extra sg doesn't really help or am I 
> missing something?

Sorry, please scratch the previous mail. I think that I misunderstood
what you meant.

The current code does padding only for requests that we call
__blk_rq_map_user (bio_copy_user) for. You meant that if we create a
new flag like REQ_NEED_PADDING and set it in blk_rq_map_user,
blk_rq_map_sg can do padding only when it was set.

Right?
