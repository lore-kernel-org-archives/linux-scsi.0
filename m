From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Removing BROKEN scsi drivers
Date: Tue, 15 Nov 2005 06:05:40 -0700
Message-ID: <20051115130540.GA32158@parisc-linux.org>
References: <20051005123220.GB6490@levanta.com> <1128519034.5063.10.camel@laptop-lcs.localdomain> <Pine.LNX.4.62.0510071024370.26010@numbat.sonytel.be> <20051007134232.GA6490@levanta.com> <1128693232.5041.7.camel@laptop-lcs.localdomain> <20051115095152.GA23470@infradead.org> <20051115101709.GK7031@2004.bluespice.org> <20051115103034.GA24352@infradead.org> <20051115113225.GS5252@levanta.com> <1132056707.6134.11.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:31716 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S932467AbVKONFq
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Nov 2005 08:05:46 -0500
Content-Disposition: inline
In-Reply-To: <1132056707.6134.11.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kars de Jong <jongk@linux-m68k.org>
Cc: Richard Hirst <rhirst@levanta.com>, Christoph Hellwig <hch@infradead.org>, Ingo Juergensmann <ij@2005.bluespice.org>, Andi Kleen <ak@suse.de>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>

On Tue, Nov 15, 2005 at 01:11:47PM +0100, Kars de Jong wrote:
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
> 
> etc.
> 
> IMHO that's cleaner than hardcoding these functions to do no
> byteswapping at all in include/asm-m68k/io.h. Plus that breaks when a
> multi-config kernel is built (like one with PCMCIA and this SCSI driver,
> because the Amiga PCMCIA implementation does need byteswapping). Much
> like what you get now when you build a kernel with APNE and ZORRO8390
> drivers for instance.

I thought that was what the bS_to_io() and friends were for.

In any case, I agree with you.  The iomap call should let you specify
whether this is a big-endian or little-endian region.  Unfortunately,
James Bottomley disagreed and we now have the ioread16be family of
functions.
