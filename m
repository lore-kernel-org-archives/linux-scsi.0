Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6996BC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Dec 2021 09:42:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243991AbhLVJmU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Dec 2021 04:42:20 -0500
Received: from verein.lst.de ([213.95.11.211]:49931 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231744AbhLVJmT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Dec 2021 04:42:19 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id D437E68AFE; Wed, 22 Dec 2021 10:42:16 +0100 (CET)
Date:   Wed, 22 Dec 2021 10:42:16 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Baoquan He <bhe@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2] sr: don't use GFP_DMA
Message-ID: <20211222094216.GA28018@lst.de>
References: <20211222090842.920724-1-hch@lst.de> <20211222093707.GA23698@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211222093707.GA23698@MiWiFi-R3L-srv>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 22, 2021 at 05:37:07PM +0800, Baoquan He wrote:
> >  	/* allocate transfer buffer */
> > -	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
> > +	buffer = kmalloc(512, GFP_KERNEL);
> 
> Thanks a lot for doing this. When I browsed the code path, I come to
> blk_rq_map_kern() but I am not sure if blk_queue_may_bounce() is true in
> the sr_probe() case, then it may enter into bio_map_kern().

blk_queue_may_bounce will be entered for the few drives that set
BLK_BOUNCE_HIGH because they can't handle highmem (which is a subset
of the non-ZONE_DMA memory).  The only driver that actually requires
ZONE_DMA based bouncing is ps3rom, and that driver does a manual
and ubconditional bounce buffering.

> Next I will post my original patchset to mute the allocation failure if
> it's requesting page from DMA zone and DMA zone has no managed page. And
> meanwhile, I will try to collect those places of kmalloc(GFP_DMA) into a
> RFC mail, see if we can change them one by one. Anyone can pick one
> place to fix if interested or knowing it well.

I've already sent out patches for all of drivers/scsi/ today, except
for the ps3rom bounce buffer alllocation which is fine but should
probably be changed to use the page allocator directly.

> Finally, we can remove the
> need of dma-kmalloc() as people suggested. Any comment?

Yes.
