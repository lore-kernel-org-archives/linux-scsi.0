From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: [PATCH 3/5] add sg segment limitation info to device structure
Date: Tue, 2 Oct 2007 17:23:39 +0200
Message-ID: <3ae72650710020823j17219ab5u6c2aefe491884ca6@mail.gmail.com>
References: <20070925142157B.tomof@acm.org> <20070926160558.GA10819@suse.de>
	 <1191281770.3530.24.camel@localhost.localdomain>
	 <20071002013902.GP12049@parisc-linux.org>
	 <20071002042248.GA23399@suse.de>
	 <1191336311.3530.59.camel@localhost.localdomain>
	 <3ae72650710020802r75cc2e39h2f1e7ee1e0a17efb@mail.gmail.com>
	 <1191337528.3530.74.camel@localhost.localdomain>
	 <1191337830.4093.19.camel@lov.localdomain>
	 <1191338072.3530.77.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:57685 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbXJBPXk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 11:23:40 -0400
Received: by wa-out-1112.google.com with SMTP id v27so5029980wah
        for <linux-scsi@vger.kernel.org>; Tue, 02 Oct 2007 08:23:40 -0700 (PDT)
In-Reply-To: <1191338072.3530.77.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Greg KH <gregkh@suse.de>, Matthew Wilcox <matthew@wil.cx>, FUJITA Tomonori <tomof@acm.org>, jens.axboe@oracle.com, hch@infradead.org, jeff@garzik.org, hare@suse.de, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On 10/2/07, James Bottomley <James.Bottomley@steeleye.com> wrote:
> On Tue, 2007-10-02 at 17:10 +0200, Kay Sievers wrote:
> > On Tue, 2007-10-02 at 10:05 -0500, James Bottomley wrote:
> > > On Tue, 2007-10-02 at 17:02 +0200, Kay Sievers wrote:
> > > > On 10/2/07, James Bottomley <James.Bottomley@steeleye.com> wrote:
> > > > > On Mon, 2007-10-01 at 21:22 -0700, Greg KH wrote:
> > > > > > On Mon, Oct 01, 2007 at 07:39:02PM -0600, Matthew Wilcox wrote:
> > > > > > > On Mon, Oct 01, 2007 at 07:36:10PM -0400, James Bottomley wrote:
> > > > > > > > One possibility we could do is to add a
> > > > > > > >
> > > > > > > > struct dma_device {
> > > > > > > >   struct device dev;
> > > > > > > >   u64 dma_mask;
> > > > > > > >   u64 coherent_dma_mask;
> > > > > > > >   unsigned int max_segment_size;
> > > > > > > >   /* plus any other DMA parameters */
> > > > > > > > };
> > > > > > > >
> > > > > > > > but then every bus that can do DMA would need to include a struct
> > > > > > > > dma_device instead of the struct device they do now.  Then the IOMMU
> > > > > > > > would know it could cast out from struct device to struct dma_device,
> > > > > > > > but this would be a lot of work to thread through the current
> > > > > > > > infrastructure.
> > > > > >
> > > > > > Why not just hang these fields off of a struct device, that way if the
> > > > > > device doesn't/can't do dma, it only has the "loss" of a single pointer,
> > > > > > not all of these fields?
> > > > >
> > > > > Well, that's just a bit ugly ... I assume you're thinking of adding a
> > > > > struct device_dma_parameters, and then defining the platform device as
> > > > >
> > > > > struct pci_dev {
> > > > >         ...
> > > > >         struct device dev;
> > > > >         struct device_dma_parameters dma_parms;
> > > > >         ...
> > > > > };
> > > > >
> > > > > and then setting up the pointer?
> > > >
> > > > I guess Greg means:
> > > >   struct device {
> > > >       ...
> > > >       struct device_dma_parameters *dma_parms;
> > > >   }
> > > >
> > > > and allocate dma_parms on demand.
> > >
> > > But they're demanded by every bus (with the possible exception of
> > > PCMCIA) because they'll be holding the dma mask.  Sure, we could do a
> > > separate allocation in every bus device creation routine, but isn't that
> > > even more complex than sticking them in the global allocation of the bus
> > > device because the failure modes are now more complex?
> >
> > Hmm, SCSI devices are bus devices too, will they need it?
>
> Actually, I don't think of SCSI devices as bus devices ... but the
> answer's no, they don't.  Only devices on a DMA'able bus (like PCI,
> parisc, sbus etc.)

Ah, I see. Seems we have far more "struct device" devices on a system
which don't do DMA then. And in some setups also more "struct device"
devices belonging to a "struct bus" without doing any DMA.

Just looking at the number of devices, it seems that allocating it
dynamically would be the better deal. We allocate the name of every
kobject dynamically today, so I guess it's fine to do that with the
DMA data too.

Kay
