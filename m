From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/2] block: move the padding adjustment to blk_rq_map_sg
Date: Tue, 08 Apr 2008 11:37:32 +0900
Message-ID: <20080408113732B.fujita.tomonori@lab.ntt.co.jp>
References: <47FA2090.4040005@gmail.com>
	<20080408083526P.fujita.tomonori@lab.ntt.co.jp>
	<47FACF22.4010104@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:39522 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389AbYDHCjG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Apr 2008 22:39:06 -0400
In-Reply-To: <47FACF22.4010104@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: htejun@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, tomof@acm.org, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com

On Tue, 08 Apr 2008 10:49:22 +0900
Tejun Heo <htejun@gmail.com> wrote:

> Hello,
> 
> FUJITA Tomonori wrote:
> >>> The current code does padding only for requests that we call
> >>> __blk_rq_map_user (bio_copy_user) for. You meant that if we create a
> >>> new flag like REQ_NEED_PADDING and set it in blk_rq_map_user,
> >>> blk_rq_map_sg can do padding only when it was set.
> >> Yeap, that's what I meant.
> > 
> > Thanks, I see. Then, I have one question: blk_rq_map_user_iov doesn't
> > padding, thus libata still needs to adjust scatter list, right?
> 
> Yes but it doesn't, so blk_rq_map_user_iov() path is essentially broken 
> regarding padding at the moment.  :-(

I see. So we need to use bounce buffers for blk_rq_map_user_iov like
bio_copy_user does for blk_rq_map_user?
