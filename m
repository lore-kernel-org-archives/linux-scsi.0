From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [BKPATCH] SCSI sync
Date: Sat, 27 Sep 2003 23:29:52 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.21.0309272326060.7085-100000@vervain.sonytel.be>
References: <1064697623.2217.476.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail2.sonytel.be ([195.0.45.172]:4272 "EHLO witte.sonytel.be")
	by vger.kernel.org with ESMTP id S262243AbTI0V37 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Sep 2003 17:29:59 -0400
In-Reply-To: <1064697623.2217.476.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>

On 27 Sep 2003, James Bottomley wrote:
> On Sat, 2003-09-27 at 13:13, Linus Torvalds wrote:
> > what's this? It's the only place in the whole source file that has 
> > "phases". 
> 
> OK, after a bit of a paperchase, this is the problem:
> 
> hangeSet 1.1217.10.7 2003/09/12 09:52:45 geert@linux-m68k.org
>   [PATCH] NCR5380.c warning
>   
>   NCR5380: `phases' is used inside the #ifdef NDEBUG only, so move its
> definition
>   inside as well.
> 
> It wasn't realised that NCR5380.c is #included into g_NCR5380.c and
> provided the phases[] array for that as well.

Oops, sorry, I didn't notice that g_NCR5380.c is the only NCR5380 driver that
uses phases[] beyond debugging.

I think the NCR5380 core and drivers need some clean up. Including other C
sources and #define'ing all the NCR5380_*() routines isn't exacly the cleanest
way to handle abstraction...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

