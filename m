From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 3/5] add sg segment limitation info to device structure
Date: Tue, 02 Oct 2007 10:05:28 -0500
Message-ID: <1191337528.3530.74.camel@localhost.localdomain>
References: <20070925142157B.tomof@acm.org> <20070926160558.GA10819@suse.de>
	 <1191281770.3530.24.camel@localhost.localdomain>
	 <20071002013902.GP12049@parisc-linux.org> <20071002042248.GA23399@suse.de>
	 <1191336311.3530.59.camel@localhost.localdomain>
	 <3ae72650710020802r75cc2e39h2f1e7ee1e0a17efb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:33378 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752007AbXJBPFa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 11:05:30 -0400
In-Reply-To: <3ae72650710020802r75cc2e39h2f1e7ee1e0a17efb@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <gregkh@suse.de>, Matthew Wilcox <matthew@wil.cx>, FUJITA Tomonori <tomof@acm.org>, jens.axboe@oracle.com, hch@infradead.org, jeff@garzik.org, hare@suse.de, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Tue, 2007-10-02 at 17:02 +0200, Kay Sievers wrote:
> On 10/2/07, James Bottomley <James.Bottomley@steeleye.com> wrote:
> > On Mon, 2007-10-01 at 21:22 -0700, Greg KH wrote:
> > > On Mon, Oct 01, 2007 at 07:39:02PM -0600, Matthew Wilcox wrote:
> > > > On Mon, Oct 01, 2007 at 07:36:10PM -0400, James Bottomley wrote:
> > > > > One possibility we could do is to add a
> > > > >
> > > > > struct dma_device {
> > > > >   struct device dev;
> > > > >   u64 dma_mask;
> > > > >   u64 coherent_dma_mask;
> > > > >   unsigned int max_segment_size;
> > > > >   /* plus any other DMA parameters */
> > > > > };
> > > > >
> > > > > but then every bus that can do DMA would need to include a struct
> > > > > dma_device instead of the struct device they do now.  Then the IOMMU
> > > > > would know it could cast out from struct device to struct dma_device,
> > > > > but this would be a lot of work to thread through the current
> > > > > infrastructure.
> > >
> > > Why not just hang these fields off of a struct device, that way if the
> > > device doesn't/can't do dma, it only has the "loss" of a single pointer,
> > > not all of these fields?
> >
> > Well, that's just a bit ugly ... I assume you're thinking of adding a
> > struct device_dma_parameters, and then defining the platform device as
> >
> > struct pci_dev {
> >         ...
> >         struct device dev;
> >         struct device_dma_parameters dma_parms;
> >         ...
> > };
> >
> > and then setting up the pointer?
> 
> I guess Greg means:
>   struct device {
>       ...
>       struct device_dma_parameters *dma_parms;
>   }
> 
> and allocate dma_parms on demand.

But they're demanded by every bus (with the possible exception of
PCMCIA) because they'll be holding the dma mask.  Sure, we could do a
separate allocation in every bus device creation routine, but isn't that
even more complex than sticking them in the global allocation of the bus
device because the failure modes are now more complex?

James


