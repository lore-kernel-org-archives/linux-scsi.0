From: tsbogend@alpha.franken.de (Thomas Bogendoerfer)
Subject: Re: [PATCH] jazz_esp converted to use esp_core
Date: Tue, 22 May 2007 10:04:20 +0200
Message-ID: <20070522080420.GA10316@alpha.franken.de>
References: <20070521210224.GA24573@alpha.franken.de> <20070521230041.GA12090@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from elvis.franken.de ([193.175.24.41]:51737 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754914AbXEVIEa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 May 2007 04:04:30 -0400
Content-Disposition: inline
In-Reply-To: <20070521230041.GA12090@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, davem@davemloft.net

On Tue, May 22, 2007 at 12:00:41AM +0100, Christoph Hellwig wrote:
> On Mon, May 21, 2007 at 11:02:24PM +0200, Thomas Bogendoerfer wrote:
> > after chasing and fixing two jazz platform bugs and one MIPS dma mapping
> > bug, I finally succeeded in using the Dave's new esp_core (great work,
> > thank you Dave). Below is the patch.
> 
> Very nice driver.  The only thing that confused me a little are
> the various helper functions split out of esp_jazz_probe that
> make the code a bit odd to read.  Are these intentional or a carry
> over from the previous driver?

the sparc frontend used them, because most of these helper are
checking for prom properties, which the jazz doesn't have. I've
changed that and folded those little helpers into the probe function.
I'll send a new patch a couple of minutes.

> > --- a/drivers/scsi/Makefile
> > +++ b/drivers/scsi/Makefile
> > @@ -121,7 +121,7 @@ obj-$(CONFIG_BLK_DEV_3W_XXXX_RAID) += 3w-xxxx.o
> >  obj-$(CONFIG_SCSI_3W_9XXX)	+= 3w-9xxx.o
> >  obj-$(CONFIG_SCSI_PPA)		+= ppa.o
> >  obj-$(CONFIG_SCSI_IMM)		+= imm.o
> > -obj-$(CONFIG_JAZZ_ESP)		+= NCR53C9x.o	jazz_esp.o
> > +obj-$(CONFIG_JAZZ_ESP)		+= jazz_esp.o
> 
> Note to Dave:  it probably would be nice to just build esp_scsi.o
> from the makefile like the old NCR53C9x drivers did instead of the
> Kconfig hackery, what do you think?

after seeing no objection to using esp_scsi.o like NCR53C9x.o, I also
changed that.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessary a
good idea.                                                [ RFC1925, 2.3 ]
