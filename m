From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] dc395x: Fix support for highmem
Date: Sun, 20 Mar 2005 09:14:17 +0000
Message-ID: <20050320091417.GC12000@infradead.org>
References: <200503160209.j2G29cAf010870@hera.kernel.org> <20050316075839.GC7842@suse.de> <1110986016.5771.3.camel@mulgrave> <20050316160447.GU7842@suse.de> <20050316164806.GO21986@parcelfarce.linux.theplanet.co.uk> <20050316165338.GX7842@suse.de> <20050316170259.GA25056@infradead.org> <20050316170417.GY7842@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from pentafluge.infradead.org ([213.146.154.40]:14559 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262038AbVCTJOV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Mar 2005 04:14:21 -0500
Content-Disposition: inline
In-Reply-To: <20050316170417.GY7842@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, g.liakhovetski@gmx.de

On Wed, Mar 16, 2005 at 06:04:17PM +0100, Jens Axboe wrote:
> On Wed, Mar 16 2005, Christoph Hellwig wrote:
> > On Wed, Mar 16, 2005 at 05:53:39PM +0100, Jens Axboe wrote:
> > > The list doesn't really need dma mapping at that point, the problem here
> > > is that the driver needs to punt to pio mode because of foo. So calling
> > > pci/dma_map_* is pointless, since the CPU will have to do the transfer
> > > anyways. What the driver is really looking for at this point, is a way
> > > to map the pages in the sglist to a virtual address.
> > 
> > Given that there's quite a few cases of this "problem" it would be nice
> > to have common helpers for it.  Especially as it's really difficult when
> > we allow merging of sg list entries
> 
> I thought about that when writing the above, but is there really more
> than one case for SCSI drivers? If there is, sure lets add the helpers.
> But I would consider it a quite rare occurence, I've never seen it
> before.

There's lots of pio only drivers, aswell as raid drivers that need to
look into the non I/O-path command and things like iscsi.

