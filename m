From: Kars de Jong <jongk@linux-m68k.org>
Subject: Re: Removing BROKEN scsi drivers
Date: Tue, 15 Nov 2005 13:11:47 +0100
Message-ID: <1132056707.6134.11.camel@localhost.localdomain>
References: <20051005113108.GA19437@parisc-linux.org>
	 <20051005113925.GA11202@infradead.org> <20051005123220.GB6490@levanta.com>
	 <1128519034.5063.10.camel@laptop-lcs.localdomain>
	 <Pine.LNX.4.62.0510071024370.26010@numbat.sonytel.be>
	 <20051007134232.GA6490@levanta.com>
	 <1128693232.5041.7.camel@laptop-lcs.localdomain>
	 <20051115095152.GA23470@infradead.org>
	 <20051115101709.GK7031@2004.bluespice.org>
	 <20051115103034.GA24352@infradead.org>  <20051115113225.GS5252@levanta.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:19095 "EHLO
	smtpq2.groni1.gr.home.nl") by vger.kernel.org with ESMTP
	id S932389AbVKOMMG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Nov 2005 07:12:06 -0500
In-Reply-To: <20051115113225.GS5252@levanta.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Richard Hirst <rhirst@levanta.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Juergensmann <ij@2005.bluespice.org>, Matthew Wilcox <matthew@wil.cx>, Andi Kleen <ak@suse.de>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>

On di, 2005-11-15 at 11:32 +0000, Richard Hirst wrote:
> On Tue, Nov 15, 2005 at 10:30:34AM +0000, Christoph Hellwig wrote:
> > On Tue, Nov 15, 2005 at 11:17:09AM +0100, Ingo Juergensmann wrote:
> > > > Did you make any progress on this? 
> > > 
> > > I guess he made... Kars gave me a kernel image for Amiga:
> > > 
> > > 53c700: Version 2.8 By James.Bottomley@HansenPartnership.com
> > > scsi0: 53c710 rev 2
> > > 53c700: dmode=80 dcntl=01 ctest7=02
> > > scsi0 : WarpEngine 40xx
> > > 
> > > spice:/home/ij# uptime
> > >  11:13:14 up 4 days, 14:59,  3 users,  load average: 0.02, 0.20, 0.13
> > > 
> > > So far, I haven't experienced any problems with that new driver. I intend to
> > > try that kernel on an Amiga 4000T with its implementation of that chip
> > > (A4091-alike)...
> > 
> > Very nice.  Kars, could you send your patches to linux-scsi please?
> 
> Between us it seems Kars and I have this driver working on Amiga, MVME,
> and BVME boards.  That is everything that used the old 53c7xx driver.  I
> don't believe there is a combined set of patches yet (at least, I havn't
> seen the patches for Amiga).  One complication is that we're relying on
> some m68k-specific dma support patches from Roman Zippel that are not
> yet integrated.

Indeed, and there's issues with the iomap interface to solve as well. 

Also, I don't know the proper chip register settings for all supported
boards yet (hence the printk() with register settings).

With all m68k 53c700 implementations currently supported there should be
no byteswapping done in io{read,write}32(), but that doesn't hold for
each bus.

So until we can specify in some way how the io{read,write}{16,32}()
function should behave on a certain memory region, I see no way to
integrate this cleanly. For now I am inclined to do something like this
in 53c700.h:

#ifdef CONFIG_M68K
        iowrite32be(bS_to_io(value), hostdata->base + reg);
#else
        iowrite32(bS_to_io(value), hostdata->base + reg);
#endif

etc.

IMHO that's cleaner than hardcoding these functions to do no
byteswapping at all in include/asm-m68k/io.h. Plus that breaks when a
multi-config kernel is built (like one with PCMCIA and this SCSI driver,
because the Amiga PCMCIA implementation does need byteswapping). Much
like what you get now when you build a kernel with APNE and ZORRO8390
drivers for instance.

Comments, anyone?


Kind regards,

Kars.


