From: gl@dsa-ac.de
Subject: Re: [PATCH] dc395x: Fix support for highmem
Date: Mon, 21 Mar 2005 11:38:53 +0100 (CET)
Message-ID: <Pine.LNX.4.56.0503211111290.20956@pcgl.dsa-ac.de>
References: <20050321075531.GC23911@suse.de> <7044.1111398919@www16.gmx.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Received: from mail.dsa-ac.de ([62.112.80.99]:25101 "EHLO mail.dsa-ac.de")
	by vger.kernel.org with ESMTP id S261741AbVCUKlq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2005 05:41:46 -0500
In-Reply-To: <7044.1111398919@www16.gmx.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>

On Mon, 21 Mar 2005, Jens Axboe wrote:

> On Sun, Mar 20 2005, Guennadi Liakhovetski wrote:
> >
> > char *kmap_atomic_sg(struct scatterlist *sg, unsigned int offset, int *mapped);
> > void kunmap_atomic_sg(struct scatterlist *sg, int mapped);
> >
> > The latter would just call the kunmap_atomic with the respective KM_ type.
> > By "merging of sg list entries" above is meant, that pci_map_sg may return
> > a number smaller than the number of elements in the original sg list
> > because some adjacent elements were merged during the mapping?
>
> Same problem, you want to map N entries at the time which is simply not
> easily doable. I made a suggestion earlier in the thread, you need to do
> something ala
>
>         sg_map_each_entry(sglist, entries, sg, ouput_ptr, flags) {
>                 /* transfer sg_virt_len(sg) to/from output_ptr */
>         }
>
> that maps each entry successively.

Well, I don't know how and when other drivers use / need this mapping, in
dc395x and tmscsim you just occasionally need to transfer a couple of
bytes per PIO, so, it would be a waste to map each sg-entry? If other
drivers do always need all, shouldn't we then define 2 APIs - for a single
mapping and for all. Also, I think, at least am53c974 (tmscsim) does
sg-processing only semi-automatically, that is you get interrupts and do
some stuff for each element. So, mapping all sg-entries each time is not
needed, and you cannot kmap them atomically if you want to keep them
mapped all the time. In your proposed API, when would you unmap them?

> BTW, wrt your earlier question, it is pretty easy to test highmem on a
> non-highmem machine. Try and google for highmem debug, Andrea had a
> little patch in his -aa kernels for 2.4 that should be easily adoptable
> to 2.6.

Thanks, I'll have a google.

Thanks
Guennadi
---------------------------------
Guennadi Liakhovetski, Ph.D.
DSA Daten- und Systemtechnik GmbH
Pascalstr. 28
D-52076 Aachen
Germany
