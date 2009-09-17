From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: sg: Free data buffers after calling blk_rq_unmap_user
Date: Thu, 17 Sep 2009 08:53:00 +0200
Message-ID: <20090917065259.GA5594@schmichrtp>
References: <20090915165356.GA2356@schmichrtp> <20090917150001F.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.17.164]:36346 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788AbZIQGw6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2009 02:52:58 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate4.de.ibm.com (8.13.1/8.13.1) with ESMTP id n8H6r1A8017794
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2009 06:53:01 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n8H6r0b12609266
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2009 08:53:00 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n8H6r0u7025317
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2009 08:53:00 +0200
Content-Disposition: inline
In-Reply-To: <20090917150001F.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, dgilbert@interlog.com

On Thu, Sep 17, 2009 at 03:00:44PM +0900, FUJITA Tomonori wrote:
> Sorry for the delay,
> 
> On Tue, 15 Sep 2009 18:53:57 +0200
> Christof Schmitt <christof.schmitt@de.ibm.com> wrote:
> 
> > This patch fixes a problem with the sg driver that is only visible
> > with the CONFIG_DEBUG_PAGEALLOC kernel config option. The patch works
> > for me, but i would appreciate the review of somebody with more
> > knowledge about the interactions between the sg driver and the block
> > layer.
> > 
> > Christof
> > ---
> > sg: Free data buffers after calling blk_rq_unmap_user
> > 
> > From: Christof Schmitt <christof.schmitt@de.ibm.com>
> > 
> > Running sg_luns on s390x with CONFIG_DEBUG_PAGEALLOC enabled fails
> > with EFAULT from the SG_IO ioctl. The EFAULT is the result from
> > copy_to_user failing in this call chain:
> > 
> > sg_ioctl
> > sg_new_read
> > sg_finish_rem_req
> > blk_rq_unmap_user
> > __blk_rq_unmap_user
> > bio_uncopy_user
> > __bio_copy_iov
> > copy_to_user
> > 
> > The sg driver calls sg_remove_scat to free the memory pages before
> > calling blk_rq_unmap_user that tries to copy the data back to
> > userspace. Change the order to first call blk_rq_unmap_user before
> > freeing the pages in sg_remove_scat.
> > 
> > Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
> > ---
> >  drivers/scsi/sg.c |   10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> Oops, thanks a lot!
> 
> Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> 
> It would be better to add "Cc: stable@kernel.org" tag since this fix
> needs to be sent to stable trees.

Thanks for the review. I will resend the patch with the added acked-by
and cc.

--
Christof
