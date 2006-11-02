From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [RFC PATCH] m68k: switch to 53c700 driver
Date: Thu, 2 Nov 2006 22:34:41 +0100 (CET)
Message-ID: <Pine.LNX.4.62.0611022231590.15876@pademelon.sonytel.be>
References: <Pine.LNX.4.62.0510071024370.26010@numbat.sonytel.be>
 <20051007134232.GA6490@levanta.com> <1128693232.5041.7.camel@laptop-lcs.localdomain>
 <20051115095152.GA23470@infradead.org> <20051115101709.GK7031@2004.bluespice.org>
 <20051115103034.GA24352@infradead.org> <20051115113225.GS5252@levanta.com>
 <20060707124444.GA11199@infradead.org> <20060709111648.GR15414@levanta.com>
 <1152444304.5567.2.camel@kars.perseus.home> <20061030111311.GA756@infradead.org>
 <1162331224.7805.18.camel@kars.perseus.home>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from witte.sonytel.be ([80.88.33.193]:36263 "EHLO witte.sonytel.be")
	by vger.kernel.org with ESMTP id S1752655AbWKBVew (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Nov 2006 16:34:52 -0500
In-Reply-To: <1162331224.7805.18.camel@kars.perseus.home>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kars de Jong <jongk@linux-m68k.org>
Cc: Christoph Hellwig <hch@infradead.org>, Richard Hirst <rhirst@levanta.com>, Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org

On Tue, 31 Oct 2006, Kars de Jong wrote:
> On ma, 2006-10-30 at 11:13 +0000, Christoph Hellwig wrote:
> > Any updates?  Honestly, I do not plan to touch the current 53c7xx/etc
> > mess in the upoming request_buffer transition, and unless the m68k
> > folks provide the new 53c700-based driver I'll just submit a patch to
> > rip 53c7xx and users out without replacement.
> 
> OK, here's the patch, without the m68k generic iomap changes.

Ah, the missing io{read,write}*() stuff :-)

> If there are no objections, I will commit it to our CVS repository so
> Geert can send it upstream (with proper Signed-Off-By: headers and
> everything).
> 
> This patch is relative to the m68k CVS repository, which is at kernel
> version 2.6.18.

You forgot this part, as zorro_module_init was removed in 2.6.17-rc1:

--- linux-m68k-2.6.19-rc4/drivers/scsi/amiga7xx.c.orig	2006-11-02 21:44:14.000000000 +0100
+++ linux-m68k-2.6.19-rc4/drivers/scsi/amiga7xx.c	2006-11-02 21:45:44.000000000 +0100
@@ -273,7 +273,7 @@ static int __init amiga7xx_scsi_init(voi
 	}
 
 #ifdef CONFIG_ZORRO
-	err = zorro_module_init(&amiga7xx_driver);
+	err = zorro_register_driver(&amiga7xx_driver);
 #endif
 
 	return err;

> I have renamed the mvme16x.c and bvme6000.c files to mvme16x_scsi.c and
> bvme6000_scsi.c respectively, I'm not sure if this is a good idea
> though.

I guess that's OK, as it makes the module name more sensible.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
