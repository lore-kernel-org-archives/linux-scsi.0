From: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] get rid of ->detect for upper layer drivers
Date: Thu, 07 Nov 2002 14:02:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211071902.gA7J2gU04498@localhost.localdomain>
References: <adam@yggdrasil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id LAA04117
	for <linux-scsi@vger.kernel.org>; Thu, 7 Nov 2002 11:02:49 -0800
In-Reply-To: Message from "Adam J. Richter" <adam@yggdrasil.com>
   of "Thu, 07 Nov 2002 10:42:56 PST." <200211071842.KAA30050@adam.yggdrasil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Adam J. Richter" <adam@yggdrasil.com>
Cc: andmike@us.ibm.com, hch@lst.de, linux-scsi@vger.kernel.org

adam@yggdrasil.com said:
> 	All of the drivers that I've looked at abort if the initial
> pci_alloc_consistent fails.  Those are the drivers that I had in mind
> to use this facility. 

That's OK on x86, or other fully consistent arch, because it means that 
__get_free_pages failed and we're out of memory.

My worry is that by making this into a mid layer API we're implying that we 
"get it right", rather than get it right for only x86.

> 	I'd be interested in pointers to drivers that soldier on after
> {pci,sbus}_alloc_consistent fails (I think those are the only two
> versions in 2.5.46). 

You're welcome to look through 53c700.c.  It drives the lasi chips on PA-RISC 
and also some odd controllers under x86.  It's actually got a compile flag 
(CONFIG_53C700_USE_CONSISTENT) to check whether it's supposed to do consistent 
allocations (it also has the full fallback stuff for if it fails).  The real 
design of the flag is to optimize out the unnecessary fallback checks on x86.

You can see from the sync points peppering the driver how difficult it would 
be to do a full abstraction.

The ncr8xxx driver is another one used for the Zalon controller in parisc, so 
it will eventually have the same issues.

> 	If there really are a number of device drivers that want to be able
> to continue on if the initial dma_alloc_consistent fails, especially
> if they all do the same thing, like, say, try vmalloc, then, yes I
> would like add a flag to support and a flag in struct device or
> something to communicate the result of the memory allocation, rather
> than have the same logic replicated over N device drivers. It could be
> conditionally compiled and probably put into a separate inline routine
> in drivers/base/bus.c if needed for cleanliness. 

A full abstraction would require the sync point functions that the 53c700 uses 
so that they can optimize away on unnecessary architectures.  If you're 
signing up to do this right, then I can try it out in the 53c700.  I still 
have two parisc machines, one which cannot do consistent allocations and one 
which can.

James


