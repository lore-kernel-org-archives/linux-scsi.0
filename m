From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: Discard support (was Re: [PATCH] swap: send callback when swap
 slot is freed)
Date: Mon, 17 Aug 2009 08:56:12 -0500
Message-ID: <1250517372.3844.3.camel@mulgrave.site>
References: <4A85E0DC.9040101@rtr.ca>
	 <f3177b9e0908141621j15ea96c0s26124d03fc2b0acf@mail.gmail.com>
	 <20090814234539.GE27148@parisc-linux.org>
	 <f3177b9e0908141719s658dc79eye92ab46558a97260@mail.gmail.com>
	 <1250341176.4159.2.camel@mulgrave.site> <4A86B69C.7090001@rtr.ca>
	 <1250344518.4159.4.camel@mulgrave.site>
	 <20090816150530.2bae6d1f@lxorguk.ukuu.org.uk>
	 <20090816083434.2ce69859@infradead.org>
	 <1250437927.3856.119.camel@mulgrave.site>
	 <20090816165943.GA26983@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20090816165943.GA26983@infradead.org>
Sender: owner-linux-mm@kvack.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Arjan van de Ven <arjan@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Mark Lord <liml@rtr.ca>, Chris Worley <worleys@gmail.com>, Matthew Wilcox <matthew@wil.cx>, Bryan Donlan <bdonlan@gmail.com>, david@lang.hm, Greg Freemyer <greg.freemyer@gmail.com>, Markus Trippelsdorf <markus@trippelsdorf.de>, Matthew Wilcox <willy@linux.intel.com>, Hugh Dickins <hugh.dickins@tiscali.co.uk>, Nitin Gupta <ngupta@vflare.org>, Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2009-08-16 at 12:59 -0400, Christoph Hellwig wrote:
> On Sun, Aug 16, 2009 at 10:52:07AM -0500, James Bottomley wrote:
> > However, the enterprise has been doing UNMAP for a while, so we can draw
> > inferences from them since the SSD FTL will operate similarly.  For
> > them, UNMAP is the same cost in terms of time regardless of the number
> > of extents.  The reason is that it's moving the blocks from the global
> > in use list to the global free list.  Part of the problem is that this
> > involves locking and quiescing, so UNMAP ends up being quite expensive
> > to the array but constant in terms of cost (hence they want as few
> > unmaps for as many sectors as possible).
> 
> How are they doing the unmaps?  Using something similar to Mark's wiper
> script and using SG_IO?  Because right now we do not actually implement
> UNMAP support in the kernel.  I'd really love to test the XFS batched
> discard support with a real UNMAP implementation.

You mean how is the array vendor testing their implementation?  Using
SG_IO ... without any filesystem, I believe.

The testing was initially done to see if the initial maximal discard
proposal from LSF09 was a viable approach (which it wasn't given the
time taken to UNMAP).

James


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
