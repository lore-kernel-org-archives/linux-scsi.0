From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/5] convert sg to use the block layer
Date: Thu, 28 Aug 2008 08:26:47 +0900
Message-ID: <20080828082047V.fujita.tomonori@lab.ntt.co.jp>
References: <1219716654-27827-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<48B5B5A0.3010909@torque.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:42387 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754621AbYH0X1L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Aug 2008 19:27:11 -0400
In-Reply-To: <48B5B5A0.3010909@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com

On Wed, 27 Aug 2008 16:14:24 -0400
Douglas Gilbert <dougg@torque.net> wrote:

> FUJITA Tomonori wrote:
> > This patchset converts sg to use the block layer functions. That is,
> > sg doesn't use scsi_execute_async() any more. This is a part of the
> > overdue task to remove scsi_req_map_sg.
> > 
> > I tested this patchset with sg v3 and the old interface (struct
> > sg_header) via SG_IO (v3) and the vfs API.
> > 
> > 
> > Doug,
> > 
> > 1. I don't demote the sg driver's GFP_ATOMIC to GFP_KERNEL. sg always
> > uses GFP_ATOMIC as before.
> > 
> > 2. I don't remove GFP_DMA allocation. As before, sg allocates reserved
> > pages with GFP_DMA (sfp->low_dma case).
> > 
> > 3. I keep the reserved buffer per struct sg_fd as before.
> > 
> > 4. I use high-order page allocation for reserved buffer as before. sg
> > works well with HBAs that have the limitation of the number of sg
> > entries.
> > 
> > 5. I think that you were concern about the overhead of the block layer
> > functions. But if you look at scsi_execute_async() that sg uses now,
> > you can find that scsi_execute_async() uses the block layer functions
> > internally. So the current sg incurs the overhead (if such overhead
> > exists).
> 
> Tomo,
> Thanks for doing the conversion.
> 
> Signed-off-by: Douglas Gilbert <dougg@torque.net>

Thanks a lot!
