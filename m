From: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [RFC PATCH] m68k: switch to 53c700 driver
Date: Tue, 19 Dec 2006 03:09:19 +0000
Message-ID: <20061219030919.GG17561@ftp.linux.org.uk>
References: <20051115101709.GK7031@2004.bluespice.org> <20051115103034.GA24352@infradead.org> <20051115113225.GS5252@levanta.com> <20060707124444.GA11199@infradead.org> <20060709111648.GR15414@levanta.com> <1152444304.5567.2.camel@kars.perseus.home> <20061030111311.GA756@infradead.org> <1162331224.7805.18.camel@kars.perseus.home> <1166394517.9647.22.camel@mulgrave.il.steeleye.com> <Pine.LNX.4.62.0612181032080.24587@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:59411 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbWLSDm1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Dec 2006 22:42:27 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0612181032080.24587@pademelon.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Kars de Jong <jongk@linux-m68k.org>, Christoph Hellwig <hch@infradead.org>, Richard Hirst <rhirst@levanta.com>, Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org

On Mon, Dec 18, 2006 at 10:34:21AM +0100, Geert Uytterhoeven wrote:
> On Sun, 17 Dec 2006, James Bottomley wrote:
> > On Tue, 2006-10-31 at 22:47 +0100, Kars de Jong wrote:
> > > On ma, 2006-10-30 at 11:13 +0000, Christoph Hellwig wrote:
> > > > Any updates?  Honestly, I do not plan to touch the current 53c7xx/etc
> > > > mess in the upoming request_buffer transition, and unless the m68k
> > > > folks provide the new 53c700-based driver I'll just submit a patch to
> > > > rip 53c7xx and users out without replacement.
> > > 
> > > OK, here's the patch, without the m68k generic iomap changes.
> > 
> > Could you regenerate this against the current git-head?  I've tried
> > several merge points and I still can't get it to apply ... I suspect it
> > had additional m68k fixes in the original file.
> 
> Yes, it was against the m68k tree.
> 
> If Kars doesn't respond, you can try
> 
> m68k-generic-io.diff

Hmm...  That breaks when you have ISA && !PCI (e.g. amiga or q40 defconfig):

lib/built-in.o: In function `ioread32_rep':
(.text+0xc31a): undefined reference to `insl'
lib/built-in.o: In function `iowrite32_rep':
(.text+0xc43e): undefined reference to `outsl'
lib/built-in.o: In function `ioread32':
(.text+0xc7da): undefined reference to `readl'
lib/built-in.o: In function `iowrite32':
(.text+0xca6a): undefined reference to `writel'
