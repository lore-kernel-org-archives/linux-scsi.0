From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] sg: avoid blk_put_request/blk_rq_unmap_user in
 interrupt
Date: Thu, 5 Feb 2009 18:17:14 +0900
Message-ID: <20090205181708F.fujita.tomonori@lab.ntt.co.jp>
References: <20090204113613R.fujita.tomonori@lab.ntt.co.jp>
	<498A5E7B.5030008@interlog.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:34425 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbZBEJRk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Feb 2009 04:17:40 -0500
In-Reply-To: <498A5E7B.5030008@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, jens.axboe@oracle.com

On Wed, 04 Feb 2009 22:35:23 -0500
Douglas Gilbert <dgilbert@interlog.com> wrote:

> FUJITA Tomonori wrote:
> > This is against scsi-misc.
> > 
> > =
> > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Subject: [PATCH] sg: avoid blk_put_request/blk_rq_unmap_user in interrupt
> > 
> > This fixes the following oops:
> > 
> > http://marc.info/?l=linux-kernel&m=123316111415677&w=2
> > 
> > You can reproduce this bug by interrupting a program before a sg
> > response completes. This leads to the special sg state (the orphan
> > state), then sg calls blk_put_request in interrupt (rq->end_io).
> > 
> > The above bug report shows the recursive lock problem because sg calls
> > blk_put_request in interrupt. We could call __blk_put_request here
> > instead however we also need to handle blk_rq_unmap_user here, which
> > can't be called in interrupt too.
> > 
> > In the orphan state, we don't need to care about the data transfer
> > (the program revoked the command) so adding 'just free the resource'
> > mode to blk_rq_unmap_user is a possible option.
> > 
> > I prefer to avoid complicating the blk mapping API when possible. I
> > change the orphan state to call sg_finish_rem_req via
> > execute_in_process_context. We hold sg_fd->kref so sg_fd doesn't go
> > away until keventd_wq finishes our work. copy_from_user/to_user fails
> > so blk_rq_unmap_user just frees the resource without the data
> > transfer.
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> 
> Interesting technique.

Yeah, I must say that it's hacky.

But I'd like to avoid adding something new to the block layer mapping
API for only sg. st (and osst) also calls blk_rq_unmap_user in
interrupt but they should be fine since the maping API doesn't do data
transfer for them (always use BIO_NULL_MAPPED flag).

Thanks,
