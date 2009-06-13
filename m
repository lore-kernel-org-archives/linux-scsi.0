From: Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] dma-debug: disable DMA_API_DEBUG for now
Date: Sat, 13 Jun 2009 13:10:14 +0200
Message-ID: <20090613111014.GA18638@8bytes.org>
References: <20090605173232N.fujita.tomonori@lab.ntt.co.jp> <20090605104132.GE24836@amd.com> <64bb37e0906101341j341f5179o9abfa888a6b96fc3@mail.gmail.com> <20090611081032.GN5139@amd.com> <64bb37e0906111038h1a5b9f17oec6c6368d2fbd36d@mail.gmail.com> <20090612141346.GY5139@amd.com> <64bb37e0906120751u14cac347hfa2356372e1e0a6a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 8bytes.org ([88.198.83.132]:38243 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbZFMLKN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Jun 2009 07:10:13 -0400
Content-Disposition: inline
In-Reply-To: <64bb37e0906120751u14cac347hfa2356372e1e0a6a@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu, lethal@linux-sh.org, hancockrwd@gmail.com, jens.axboe@oracle.com, bharrosh@panasas.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Jun 12, 2009 at 04:51:01PM +0200, Torsten Kaiser wrote:
> On Fri, Jun 12, 2009 at 4:13 PM, Joerg Roedel<joerg.roedel@amd.com> wrote:
> > On Thu, Jun 11, 2009 at 07:38:47PM +0200, Torsten Kaiser wrote:
> >> DMA-API: device driver tries to free DM
> >> A memory it has not allocated [device address=0x000000011e4c3000]
> >> [size=4096 bytes]
> >
> > Hmm, looking again over the code I've seen that the ref
> > dma_debug_entries are not alway filled with all necessary information
> > for best-fit. Can you please try if you still get false warnings when
> > you apply the two patches attached instead of the one I sent yesterday?
> 
> Hmm... There isn't a get_nr_mapped_entries() in 2.6.30.
> Are these patches again the current linus tree?

Indeed. These patches are against tip/core/iommu but should also apply
against current linus/master too.

> For unfilled information I wanted to complain that for non-sg mapping
> sg_call_ents never gets filled. But as dma_entry_alloc() does a
> memset() to clean the entrys it should not matter.
> And what about dma_debug_entry.paddr? Should this also be compared?

paddr shouldn't matter. We also can't compare against it because it is
not a parameter we get in the unmap path (not always).

Joerg

