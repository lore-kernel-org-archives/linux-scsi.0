From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] dc395x: Fix support for highmem
Date: Mon, 21 Mar 2005 11:44:20 +0100
Message-ID: <20050321104419.GH23911@suse.de>
References: <20050321075531.GC23911@suse.de> <7044.1111398919@www16.gmx.net> <Pine.LNX.4.56.0503211111290.20956@pcgl.dsa-ac.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from ns.virtualhost.dk ([195.184.98.160]:32409 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261742AbVCUKob (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2005 05:44:31 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.56.0503211111290.20956@pcgl.dsa-ac.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gl@dsa-ac.de
Cc: Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>

On Mon, Mar 21 2005, gl@dsa-ac.de wrote:
> On Mon, 21 Mar 2005, Jens Axboe wrote:
> 
> > On Sun, Mar 20 2005, Guennadi Liakhovetski wrote:
> > >
> > > char *kmap_atomic_sg(struct scatterlist *sg, unsigned int offset, int *mapped);
> > > void kunmap_atomic_sg(struct scatterlist *sg, int mapped);
> > >
> > > The latter would just call the kunmap_atomic with the respective KM_ type.
> > > By "merging of sg list entries" above is meant, that pci_map_sg may return
> > > a number smaller than the number of elements in the original sg list
> > > because some adjacent elements were merged during the mapping?
> >
> > Same problem, you want to map N entries at the time which is simply not
> > easily doable. I made a suggestion earlier in the thread, you need to do
> > something ala
> >
> >         sg_map_each_entry(sglist, entries, sg, ouput_ptr, flags) {
> >                 /* transfer sg_virt_len(sg) to/from output_ptr */
> >         }
> >
> > that maps each entry successively.
> 
> Well, I don't know how and when other drivers use / need this mapping, in
> dc395x and tmscsim you just occasionally need to transfer a couple of
> bytes per PIO, so, it would be a waste to map each sg-entry? If other

So you start at the entry you need, and break after handling the ones
you need to handle. Either pass in a start offset, or just pass in
sglist+offset.

> drivers do always need all, shouldn't we then define 2 APIs - for a single
> mapping and for all. Also, I think, at least am53c974 (tmscsim) does
> sg-processing only semi-automatically, that is you get interrupts and do
> some stuff for each element. So, mapping all sg-entries each time is not
> needed, and you cannot kmap them atomically if you want to keep them
> mapped all the time. In your proposed API, when would you unmap them?

The loop handles the mapping and unmapping for you.

-- 
Jens Axboe

