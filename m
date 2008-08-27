From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 0/5] convert sg to use the block layer
Date: Wed, 27 Aug 2008 16:14:24 -0400
Message-ID: <48B5B5A0.3010909@torque.net>
References: <1219716654-27827-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from elrond2.infotech.no ([82.134.31.41]:46119 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbYH0UOj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Aug 2008 16:14:39 -0400
In-Reply-To: <1219716654-27827-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, jens.axboe@oracle.com, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com

FUJITA Tomonori wrote:
> This patchset converts sg to use the block layer functions. That is,
> sg doesn't use scsi_execute_async() any more. This is a part of the
> overdue task to remove scsi_req_map_sg.
> 
> I tested this patchset with sg v3 and the old interface (struct
> sg_header) via SG_IO (v3) and the vfs API.
> 
> 
> Doug,
> 
> 1. I don't demote the sg driver's GFP_ATOMIC to GFP_KERNEL. sg always
> uses GFP_ATOMIC as before.
> 
> 2. I don't remove GFP_DMA allocation. As before, sg allocates reserved
> pages with GFP_DMA (sfp->low_dma case).
> 
> 3. I keep the reserved buffer per struct sg_fd as before.
> 
> 4. I use high-order page allocation for reserved buffer as before. sg
> works well with HBAs that have the limitation of the number of sg
> entries.
> 
> 5. I think that you were concern about the overhead of the block layer
> functions. But if you look at scsi_execute_async() that sg uses now,
> you can find that scsi_execute_async() uses the block layer functions
> internally. So the current sg incurs the overhead (if such overhead
> exists).

Tomo,
Thanks for doing the conversion.

Signed-off-by: Douglas Gilbert <dougg@torque.net>


> Jens,
> 
> I keep the block API changes to a minimum (I might need more changes
> for st/osst but I'd like to progress step by step). I did only two
> things.
> 
> 1. I add gfp_mask argument to blk_rq_map_user and blk_rq_map_user_iov.
> 
> 2. I introduces struct rq_map_data holding pages. sg puts
> pre-allocated pages to it and passes it to bio_copy_user_iov(). The
> current users of bio_copy_user_iov simply passes NULL. blk_rq_map_user
> and blk_rq_map_user_iov take a pointer to struct rq_map_data and in
> the end bio_copy_user_iov gets it.
> 
> 
> This patchset against the for-linus branch in Jens' tree + the two
> patches for 2.6.27:
> 
> http://marc.info/?l=linux-kernel&m=121964251911717&w=2
> http://marc.info/?l=linux-kernel&m=121964241911611&w=2
> 
> After Jens rebases the for-2.6.28 brach, I'll update this patchset
> too.
> 
> This patchset also is available at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git sg-block
> 
> 
> 
> 

