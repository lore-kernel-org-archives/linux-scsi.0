From: gl@dsa-ac.de
Subject: Re: [PATCH] dc395x: Fix support for highmem
Date: Mon, 21 Mar 2005 12:00:36 +0100 (CET)
Message-ID: <Pine.LNX.4.56.0503211147420.20956@pcgl.dsa-ac.de>
References: <20050321075531.GC23911@suse.de> <7044.1111398919@www16.gmx.net>
 <Pine.LNX.4.56.0503211111290.20956@pcgl.dsa-ac.de> <20050321104419.GH23911@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Received: from mail.dsa-ac.de ([62.112.80.99]:34061 "EHLO mail.dsa-ac.de")
	by vger.kernel.org with ESMTP id S261750AbVCULD1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2005 06:03:27 -0500
In-Reply-To: <20050321104419.GH23911@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>

On Mon, 21 Mar 2005, Jens Axboe wrote:

> On Mon, Mar 21 2005, gl@dsa-ac.de wrote:
> > On Mon, 21 Mar 2005, Jens Axboe wrote:
> >
> > > easily doable. I made a suggestion earlier in the thread, you need to do
> > > something ala
> > >
> > >         sg_map_each_entry(sglist, entries, sg, ouput_ptr, flags) {
> > >                 /* transfer sg_virt_len(sg) to/from output_ptr */
> > >         }
> > >
> > > that maps each entry successively.
> >
> > Well, I don't know how and when other drivers use / need this mapping, in
> > dc395x and tmscsim you just occasionally need to transfer a couple of
> > bytes per PIO, so, it would be a waste to map each sg-entry? If other
>
> So you start at the entry you need, and break after handling the ones
> you need to handle. Either pass in a start offset, or just pass in
> sglist+offset.

Yeah, you could do that. I just wanted to automate finding the needed
sg-entry and offset within based on the number of bytes processed.  Well,
not a big deal, but if many will have to do this calculation, maybe worth
defining at least a macro / inline?

> > drivers do always need all, shouldn't we then define 2 APIs - for a single
> > mapping and for all. Also, I think, at least am53c974 (tmscsim) does
> > sg-processing only semi-automatically, that is you get interrupts and do
> > some stuff for each element. So, mapping all sg-entries each time is not
> > needed, and you cannot kmap them atomically if you want to keep them
> > mapped all the time. In your proposed API, when would you unmap them?
>
> The loop handles the mapping and unmapping for you.

Sorry, still don't understand - how do you want to "break" then?

Thanks
Guennadi
---------------------------------
Guennadi Liakhovetski, Ph.D.
DSA Daten- und Systemtechnik GmbH
Pascalstr. 28
D-52076 Aachen
Germany
