From: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Subject: RE: Question: how to map SCSI data DMA address to virtual address?
Date: Thu, 2 Mar 2006 14:04:48 -0700
Message-ID: <9738BCBE884FDB42801FAD8A7769C2651420C5@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:30112 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932301AbWCBVEx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Mar 2006 16:04:53 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>, Jens Axboe <axboe@suse.de>
Cc: Linux kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

Hi,

On Thursday, March 02, 2006 3:04 PM Dick Johnson wrote:
> On Thu, 2 Mar 2006, Jens Axboe wrote:
> 
> > On Thu, Mar 02 2006, linux-os (Dick Johnson) wrote:
> >>
> >> On Thu, 2 Mar 2006, Ju, Seokmann wrote:
> >>
> >>> Hi,
> >>>
> >>> In the 'scsi_cmnd' structure, there are two entries 
> holding address
> >>> information for data to be transferred. One is 
> 'request_buffer' and the
> >>> other one is 'buffer'.
> >>> In case of 'use_sg' is non-zero, those entries indicates 
> the address of
> >>> the scatter-gather table.
> >>>
> >>> Is there way to get virtual address (so that the data 
> could be accessed
> >>> by the driver) of the actual data in the case of 'use_sg' 
> is non-zero?
> >>>
> >>> Any comments would be appreciated.
> >>>
> >>>
> >>> Thank you,
> >>>
> >>> Seokmann
> >>> -
> >>
> >> There is a macro for this purpose. However, for experiments, in
> >> the kernel, you can add PAGE_OFFSET (0xC00000000) to get 
> the virtual
> >> address. The macro is __va(a), its inverse is __pa(a).
> >>
> >> Careful. These things can change.
> >
> > Bzzt no, this wont work if an iommu is involved. It also 
> wont work if
> > the page doesn't have a virtual address mapping (think highmem).
> >
> > --
> 
> > Jens Axboe
> >
> 
> Are you going to get DMA-able pages out of high memory? The guy is
> doing scatter-table DMA, i.e., linked DMA. I think you need to
> build that table with pages from get_dma_page(). If you use
> highmem, somebody can program the iommu right out from under
> the DMA engine while a DMA is in progress because the CPU is
> not involved and can be executing lots of code that can do lots
> of bad things.
Thank you for your valueable comment. One good thing is that the system does 2 GB memory so that highmem won't come into picture. I am implementing the feature with suggestions.

Thank you again,

Seokmann

