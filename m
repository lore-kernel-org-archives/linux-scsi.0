From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 3/5] add sg segment limitation info to device structure
Date: Mon, 01 Oct 2007 19:36:10 -0400
Message-ID: <1191281770.3530.24.camel@localhost.localdomain>
References: <20070925142157B.tomof@acm.org> <20070926160558.GA10819@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:40128 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752018AbXJAXgT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Oct 2007 19:36:19 -0400
In-Reply-To: <20070926160558.GA10819@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <gregkh@suse.de>
Cc: FUJITA Tomonori <tomof@acm.org>, jens.axboe@oracle.com, hch@infradead.org, jeff@garzik.org, hare@suse.de, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Wed, 2007-09-26 at 09:05 -0700, Greg KH wrote:
> On Wed, Sep 26, 2007 at 05:58:01PM +0900, FUJITA Tomonori wrote:
> > iommu code merges sg segments without considering lld's sg segment
> > restrictions. iommu code can't access to the limitations because they
> > are in request_queue. This patch adds max_segment_size to device
> > structure. seg_boundary_mask will be added too later.
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > ---
> >  include/linux/device.h |    7 +++++++
> >  1 files changed, 7 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/device.h b/include/linux/device.h
> > index 3a38d1f..8046b60 100644
> > --- a/include/linux/device.h
> > +++ b/include/linux/device.h
> > @@ -443,6 +443,13 @@ struct device {
> >  
> >  	struct dma_coherent_mem	*dma_mem; /* internal for coherent mem
> >  					     override */
> > +
> > +	/*
> > +	 * a low level driver may set these to teach IOMMU code about
> > +	 * sg limitations.
> > +	 */
> > +	unsigned int max_segment_size;
> 
> Does this really need to be here?  Can't it go into the bus specific
> device that needs this?

Unfortunately, no.  The IOMMU may not be on the bus for the device (on
HPPA for instance, the IOMMU sits on the runway bus which is plugged
into the parisc bus, which finally plugs into the PCI bus) which means
that the iommu itself can only deal with generic devices (because it
doesn't want to do massive casing on the possible busses).

One possibility we could do is to add a

struct dma_device {
	struct device dev;
	u64 dma_mask;
	u64 coherent_dma_mask;
	unsigned int max_segment_size;
	/* plus any other DMA parameters */
};

but then every bus that can do DMA would need to include a struct
dma_device instead of the struct device they do now.  Then the IOMMU
would know it could cast out from struct device to struct dma_device,
but this would be a lot of work to thread through the current
infrastructure.

James


