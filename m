From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] dc395x: Fix support for highmem
Date: Mon, 21 Mar 2005 08:55:32 +0100
Message-ID: <20050321075531.GC23911@suse.de>
References: <200503160209.j2G29cAf010870@hera.kernel.org> <20050316075839.GC7842@suse.de> <1110986016.5771.3.camel@mulgrave> <20050316160447.GU7842@suse.de> <20050316164806.GO21986@parcelfarce.linux.theplanet.co.uk> <20050316165338.GX7842@suse.de> <20050316170259.GA25056@infradead.org> <20050316170417.GY7842@suse.de> <20050320091417.GC12000@infradead.org> <Pine.LNX.4.60.0503202057500.5532@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from ns.virtualhost.dk ([195.184.98.160]:26082 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261644AbVCUHz4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2005 02:55:56 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0503202057500.5532@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, Mar 20 2005, Guennadi Liakhovetski wrote:
> On Sun, 20 Mar 2005, Christoph Hellwig wrote:
> 
> > On Wed, Mar 16, 2005 at 06:04:17PM +0100, Jens Axboe wrote:
> > > On Wed, Mar 16 2005, Christoph Hellwig wrote:
> > > > On Wed, Mar 16, 2005 at 05:53:39PM +0100, Jens Axboe wrote:
> > > > > The list doesn't really need dma mapping at that point, the problem here
> > > > > is that the driver needs to punt to pio mode because of foo. So calling
> > > > > pci/dma_map_* is pointless, since the CPU will have to do the transfer
> > > > > anyways. What the driver is really looking for at this point, is a way
> > > > > to map the pages in the sglist to a virtual address.
> > > > 
> > > > Given that there's quite a few cases of this "problem" it would be nice
> > > > to have common helpers for it.  Especially as it's really difficult when
> > > > we allow merging of sg list entries
> > > 
> > > I thought about that when writing the above, but is there really more
> > > than one case for SCSI drivers? If there is, sure lets add the helpers.
> > > But I would consider it a quite rare occurence, I've never seen it
> > > before.
> > 
> > There's lots of pio only drivers, aswell as raid drivers that need to
> > look into the non I/O-path command and things like iscsi.
> 
> Well, how about something like
> 
> char *kmap_atomic_sg(struct scatterlist *sg, unsigned int offset, int *mapped);
> void kunmap_atomic_sg(struct scatterlist *sg, int mapped);
> 
> The latter would just call the kunmap_atomic with the respective KM_ type. 
> By "merging of sg list entries" above is meant, that pci_map_sg may return 
> a number smaller than the number of elements in the original sg list 
> because some adjacent elements were merged during the mapping?

Same problem, you want to map N entries at the time which is simply not
easily doable. I made a suggestion earlier in the thread, you need to do
something ala

        sg_map_each_entry(sglist, entries, sg, ouput_ptr, flags) {
                /* transfer sg_virt_len(sg) to/from output_ptr */
        }

that maps each entry successively.

BTW, wrt your earlier question, it is pretty easy to test highmem on a
non-highmem machine. Try and google for highmem debug, Andrea had a
little patch in his -aa kernels for 2.4 that should be easily adoptable
to 2.6.

-- 
Jens Axboe

