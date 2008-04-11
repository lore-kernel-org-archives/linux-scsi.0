From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/3] block: adds padding support to blk_rq_map_user_iov
Date: Fri, 11 Apr 2008 23:57:46 +0900
Message-ID: <20080411235743H.tomof@acm.org>
References: <1207837033-23835-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20080411105517.GR12774@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:41891 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758882AbYDKO6M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2008 10:58:12 -0400
In-Reply-To: <20080411105517.GR12774@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, htejun@gmail.com, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com

On Fri, 11 Apr 2008 12:55:18 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Thu, Apr 10 2008, FUJITA Tomonori wrote:
> > As discussed [*1], blk_rq_map_user_iov path is broken regarding
> > padding at the moment. In 2.6.24, libata did padding but libata's
> > padding code was removed and now libata expects the block layer to do
> > that.
> > 
> > blk_rq_map_user does padding but blk_rq_map_user_iov doesn't so
> > blk_rq_map_user_iov doesn't work in case libata needs padding (so far
> > nobody has complained, maybe nobody uses blk_rq_map_user_iov
> > interface).
> > 
> > This patchset adds padding support to blk_rq_map_user_iov. I converted
> > convert bio_copy_user to bio_copy_user_iov, which uses a temporary
> > kernel buffers.  blk_rq_map_user_iov uses bio_copy_user_iov when a low
> > level driver needs padding or a buffer in sg_iovec isn't aligned. We
> > can safely do padding in blk_rq_map_sg.
> > 
> > In the long run, I want to integrate several mapping APIs for PC
> > commands (and new API should be useful for sg/st/osst) but I need more
> > time to finish that work.
> > 
> > This is against the latest Linus tree. Can we merge this after 2.6.25?
> 
> Thanks Tomo, this looks good to me know. I'll queue it up.

My pleasure!

BTW, what do you think about a patch to change blk_rq_unmap_user to
take a request instead of a bio?

http://marc.info/?l=linux-scsi&m=120716475703416&w=2

I know that you are unwilling to add somthing to struct request (a
pointer to bio in this case) but symmetrical mapping APIs are more
handy (the patch also cleans ups the users of the mapping APIs like
bsg) and less error prone...
