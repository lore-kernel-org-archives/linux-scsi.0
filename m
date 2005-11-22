From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Removing BROKEN scsi drivers
Date: Tue, 22 Nov 2005 08:36:31 +0000
Message-ID: <20051122083631.GA21523@infradead.org>
References: <20051005123220.GB6490@levanta.com> <1128519034.5063.10.camel@laptop-lcs.localdomain> <Pine.LNX.4.62.0510071024370.26010@numbat.sonytel.be> <20051007134232.GA6490@levanta.com> <1128693232.5041.7.camel@laptop-lcs.localdomain> <20051115095152.GA23470@infradead.org> <20051115101709.GK7031@2004.bluespice.org> <20051115103034.GA24352@infradead.org> <20051115113225.GS5252@levanta.com> <1132056707.6134.11.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:42976 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751069AbVKVIgu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Nov 2005 03:36:50 -0500
Content-Disposition: inline
In-Reply-To: <1132056707.6134.11.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kars de Jong <jongk@linux-m68k.org>
Cc: Richard Hirst <rhirst@levanta.com>, Christoph Hellwig <hch@infradead.org>, Ingo Juergensmann <ij@2005.bluespice.org>, Matthew Wilcox <matthew@wil.cx>, Andi Kleen <ak@suse.de>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>

On Tue, Nov 15, 2005 at 01:11:47PM +0100, Kars de Jong wrote:
> Indeed, and there's issues with the iomap interface to solve as well. 
> 
> Also, I don't know the proper chip register settings for all supported
> boards yet (hence the printk() with register settings).
> 
> With all m68k 53c700 implementations currently supported there should be
> no byteswapping done in io{read,write}32(), but that doesn't hold for
> each bus.
> 
> So until we can specify in some way how the io{read,write}{16,32}()
> function should behave on a certain memory region, I see no way to
> integrate this cleanly. For now I am inclined to do something like this
> in 53c700.h:
> 
> #ifdef CONFIG_M68K
>         iowrite32be(bS_to_io(value), hostdata->base + reg);
> #else
>         iowrite32(bS_to_io(value), hostdata->base + reg);
> #endif

The 53c700 already has a rather awkward mechanism to deal with different
bus byte orders, I'd suggest you use that now and switch the driver to
use ioread*be later, without introducing arch-specific config symbols.

Anyway, could you folks please submit what you have now? The 53c7xx hasn't
worked ever in 2.6.x, and we're gonna remove it for 2.6.16.  It would be
nice to keep the m68k glue drivers switched over to use 53c700 even if there's
still some odd hacks required to actually make it work - we'll surely sort
them out once the basics are in.

