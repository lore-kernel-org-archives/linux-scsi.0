From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/2] block: move the padding adjustment to blk_rq_map_sg
Date: Tue, 08 Apr 2008 08:35:26 +0900
Message-ID: <20080408083526P.fujita.tomonori@lab.ntt.co.jp>
References: <47FA061A.8000107@gmail.com>
	<20080407221103Y.tomof@acm.org>
	<47FA2090.4040005@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:47897 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbYDGXgN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Apr 2008 19:36:13 -0400
In-Reply-To: <47FA2090.4040005@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: htejun@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, tomof@acm.org, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com

On Mon, 07 Apr 2008 22:24:32 +0900
Tejun Heo <htejun@gmail.com> wrote:

> FUJITA Tomonori wrote:
> > On Mon, 07 Apr 2008 20:31:38 +0900
> > Tejun Heo <htejun@gmail.com> wrote:
> > 
> >> FUJITA Tomonori wrote:
> >>>> Maybe we need yet another flag indicating padding space
> >>>> availability?
> >>> How about doing the exact same thing that the drain buffer does? We
> >>> can put pre-allocated buffer to a queue and save one sg entry for it.
> >> Each sg entry should be aligned so extra sg doesn't really help or am I 
> >> missing something?
> > 
> > Sorry, please scratch the previous mail. I think that I misunderstood
> > what you meant.
> > 
> > The current code does padding only for requests that we call
> > __blk_rq_map_user (bio_copy_user) for. You meant that if we create a
> > new flag like REQ_NEED_PADDING and set it in blk_rq_map_user,
> > blk_rq_map_sg can do padding only when it was set.
> 
> Yeap, that's what I meant.

Thanks, I see. Then, I have one question: blk_rq_map_user_iov doesn't
padding, thus libata still needs to adjust scatter list, right?
