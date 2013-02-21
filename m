From: Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] SCSI: amd_iommu dma_boundary overflow
Date: Thu, 21 Feb 2013 11:19:29 +0100
Message-ID: <20130221101929.GC26252@8bytes.org>
References: <eddie.wai@broadcom.com>
 <1361327453-1838-1-git-send-email-eddie.wai@broadcom.com>
 <1361353044.2581.16.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 8bytes.org ([85.214.48.195]:56790 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791Ab3BUKTc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Feb 2013 05:19:32 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail.8bytes.org (Postfix) with SMTP id A657212B0BB
	for <linux-scsi@vger.kernel.org>; Thu, 21 Feb 2013 11:19:30 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1361353044.2581.16.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Eddie Wai <eddie.wai@broadcom.com>, Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>

Hi Eddie,

> On Tue, 2013-02-19 at 18:30 -0800, Eddie Wai wrote:
> > The code seems correct as it make sense to impose the same hardware
> > segment boundary limit on both the blk queue and the DMA code.  It would
> > be an easy alternative to simply prevent the shost->dma_boundary from
> > being set to DMA_BIT_MASK(64), but it seems more correct to fix the
> > amd_iommu code itself to detect and handle this max 64-bit mask condition.

Thanks for tracking this problem down. It turns out that this code does
not only exist in the AMD IOMMU driver but also in other ones (Calgary
and GART at least, havn't checked all).

> > --- a/drivers/iommu/amd_iommu.c
> > +++ b/drivers/iommu/amd_iommu.c
> > @@ -1526,11 +1526,14 @@ static unsigned long dma_ops_area_alloc(struct device *dev,
> >  	unsigned long boundary_size;
> >  	unsigned long address = -1;
> >  	unsigned long limit;
> > +	unsigned long mask;
> >  
> >  	next_bit >>= PAGE_SHIFT;
> >  
> > -	boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1,
> > -			PAGE_SIZE) >> PAGE_SHIFT;

Given that there is a BUG_ON() in the iommu-helpers which checks for
!is_power_of_2(boundary_size) I think we can simplify the this macro and
avoid the overflow in a more clever way:

	boundary_size = (dma_get_seg_boundary(dev) >> PAGE_SHIFT) + 1;

This should work because dma_get_seg_boundary(dev) really needs to be a
bitmask which becomes a power_of_2 on incrementing.


Regards,

	Joerg


