From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] dc395x: Fix support for highmem
Date: Wed, 30 Mar 2005 23:22:16 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0503302318250.9431@poirot.grange>
References: <20050321075531.GC23911@suse.de> <7044.1111398919@www16.gmx.net>
 <Pine.LNX.4.56.0503211111290.20956@pcgl.dsa-ac.de> <20050321104419.GH23911@suse.de>
 <Pine.LNX.4.56.0503211147420.20956@pcgl.dsa-ac.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:20426 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S262442AbVC3VWY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2005 16:22:24 -0500
In-Reply-To: <Pine.LNX.4.56.0503211147420.20956@pcgl.dsa-ac.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gl@dsa-ac.de
Cc: Jens Axboe <axboe@suse.de>, Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Hi

What is going to happen to this stuff? The current Linus' tree contains a 
broken (by me:-() dc395x, other drivers (including tmscsim) would benefit 
from a generic API. I understand, the drivers are not top importance, but 
still.

I guess, if nothing happens, I'll just have to submit a patch reverting my 
dc395x highmem "fix".

Thanks
Guennadi

On Mon, 21 Mar 2005 gl@dsa-ac.de wrote:

> On Mon, 21 Mar 2005, Jens Axboe wrote:
> 
> > On Mon, Mar 21 2005, gl@dsa-ac.de wrote:
> > > On Mon, 21 Mar 2005, Jens Axboe wrote:
> > >
> > > > easily doable. I made a suggestion earlier in the thread, you need to do
> > > > something ala
> > > >
> > > >         sg_map_each_entry(sglist, entries, sg, ouput_ptr, flags) {
> > > >                 /* transfer sg_virt_len(sg) to/from output_ptr */
> > > >         }
> > > >
> > > > that maps each entry successively.
> > >
> > > Well, I don't know how and when other drivers use / need this mapping, in
> > > dc395x and tmscsim you just occasionally need to transfer a couple of
> > > bytes per PIO, so, it would be a waste to map each sg-entry? If other
> >
> > So you start at the entry you need, and break after handling the ones
> > you need to handle. Either pass in a start offset, or just pass in
> > sglist+offset.
> 
> Yeah, you could do that. I just wanted to automate finding the needed
> sg-entry and offset within based on the number of bytes processed.  Well,
> not a big deal, but if many will have to do this calculation, maybe worth
> defining at least a macro / inline?
> 
> > > drivers do always need all, shouldn't we then define 2 APIs - for a single
> > > mapping and for all. Also, I think, at least am53c974 (tmscsim) does
> > > sg-processing only semi-automatically, that is you get interrupts and do
> > > some stuff for each element. So, mapping all sg-entries each time is not
> > > needed, and you cannot kmap them atomically if you want to keep them
> > > mapped all the time. In your proposed API, when would you unmap them?
> >
> > The loop handles the mapping and unmapping for you.
> 
> Sorry, still don't understand - how do you want to "break" then?
> 
> Thanks
> Guennadi
> ---------------------------------
> Guennadi Liakhovetski, Ph.D.
> DSA Daten- und Systemtechnik GmbH
> Pascalstr. 28
> D-52076 Aachen
> Germany
> 

---
Guennadi Liakhovetski

