From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: sg: Free data buffers after calling blk_rq_unmap_user
Date: Thu, 17 Sep 2009 15:00:44 +0900
Message-ID: <20090917150001F.fujita.tomonori@lab.ntt.co.jp>
References: <20090915165356.GA2356@schmichrtp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:51497 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007AbZIQGAv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Sep 2009 02:00:51 -0400
In-Reply-To: <20090915165356.GA2356@schmichrtp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: christof.schmitt@de.ibm.com
Cc: linux-scsi@vger.kernel.org, dgilbert@interlog.com

Sorry for the delay,

On Tue, 15 Sep 2009 18:53:57 +0200
Christof Schmitt <christof.schmitt@de.ibm.com> wrote:

> This patch fixes a problem with the sg driver that is only visible
> with the CONFIG_DEBUG_PAGEALLOC kernel config option. The patch works
> for me, but i would appreciate the review of somebody with more
> knowledge about the interactions between the sg driver and the block
> layer.
> 
> Christof
> ---
> sg: Free data buffers after calling blk_rq_unmap_user
> 
> From: Christof Schmitt <christof.schmitt@de.ibm.com>
> 
> Running sg_luns on s390x with CONFIG_DEBUG_PAGEALLOC enabled fails
> with EFAULT from the SG_IO ioctl. The EFAULT is the result from
> copy_to_user failing in this call chain:
> 
> sg_ioctl
> sg_new_read
> sg_finish_rem_req
> blk_rq_unmap_user
> __blk_rq_unmap_user
> bio_uncopy_user
> __bio_copy_iov
> copy_to_user
> 
> The sg driver calls sg_remove_scat to free the memory pages before
> calling blk_rq_unmap_user that tries to copy the data back to
> userspace. Change the order to first call blk_rq_unmap_user before
> freeing the pages in sg_remove_scat.
> 
> Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
> ---
>  drivers/scsi/sg.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

Oops, thanks a lot!

Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

It would be better to add "Cc: stable@kernel.org" tag since this fix
needs to be sent to stable trees.
