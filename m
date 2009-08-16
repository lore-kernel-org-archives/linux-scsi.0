From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Discard support (was Re: [PATCH] swap: send callback when swap
	slot is freed)
Date: Sun, 16 Aug 2009 12:59:43 -0400
Message-ID: <20090816165943.GA26983@infradead.org>
References: <4A85E0DC.9040101@rtr.ca> <f3177b9e0908141621j15ea96c0s26124d03fc2b0acf@mail.gmail.com> <20090814234539.GE27148@parisc-linux.org> <f3177b9e0908141719s658dc79eye92ab46558a97260@mail.gmail.com> <1250341176.4159.2.camel@mulgrave.site> <4A86B69C.7090001@rtr.ca> <1250344518.4159.4.camel@mulgrave.site> <20090816150530.2bae6d1f@lxorguk.ukuu.org.uk> <20090816083434.2ce69859@infradead.org> <1250437927.3856.119.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1250437927.3856.119.camel@mulgrave.site>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Arjan van de Ven <arjan@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Mark Lord <liml@rtr.ca>, Chris Worley <worleys@gmail.com>, Matthew Wilcox <matthew@wil.cx>, Bryan Donlan <bdonlan@gmail.com>, david@lang.hm, Greg Freemyer <greg.freemyer@gmail.com>, Markus Trippelsdorf <markus@trippelsdorf.de>, Matthew Wilcox <willy@linux.intel.com>, Hugh Dickins <hugh.dickins@tiscali.co.uk>, Nitin Gupta <ngupta@vflare.org>, Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, Aug 16, 2009 at 10:52:07AM -0500, James Bottomley wrote:
> However, the enterprise has been doing UNMAP for a while, so we can draw
> inferences from them since the SSD FTL will operate similarly.  For
> them, UNMAP is the same cost in terms of time regardless of the number
> of extents.  The reason is that it's moving the blocks from the global
> in use list to the global free list.  Part of the problem is that this
> involves locking and quiescing, so UNMAP ends up being quite expensive
> to the array but constant in terms of cost (hence they want as few
> unmaps for as many sectors as possible).

How are they doing the unmaps?  Using something similar to Mark's wiper
script and using SG_IO?  Because right now we do not actually implement
UNMAP support in the kernel.  I'd really love to test the XFS batched
discard support with a real UNMAP implementation.

