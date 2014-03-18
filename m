From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 00/12] scsi/NCR5380: fix debugging macros and #include structure
Date: Tue, 18 Mar 2014 13:55:12 +0100
Message-ID: <CAMuHMdUMpdp7deL5zC4hUVTHjyNbtkZ2bNFupo5JiDyuyc345w@mail.gmail.com>
References: <20140318002822.372705594@telegraphics.com.au>
	<1395112756.20860.1.camel@joe-AO722>
	<alpine.LNX.2.00.1403182208590.2018@nippy.intranet>
	<1395146702.2812.47.camel@joe-AO722>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:32976 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbaCRMzN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Mar 2014 08:55:13 -0400
In-Reply-To: <1395146702.2812.47.camel@joe-AO722>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@parallels.com>, scsi <linux-scsi@vger.kernel.org>, Sam Creasey <sammy@sammy.net>, Russell King <linux@arm.linux.org.uk>, Michael Schmitz <schmitz@debian.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Linux/m68k <linux-m68k@vger.kernel.org>

On Tue, Mar 18, 2014 at 1:45 PM, Joe Perches <joe@perches.com> wrote:
> NCR does use pr_debug for the dprintk call, but
> it also doesn't verify fmt/arg matching when not
> compiled in
>
> drivers/scsi/NCR5380.h-#if NDEBUG
> drivers/scsi/NCR5380.h:#define dprintk(flg, fmt, args...) \
> drivers/scsi/NCR5380.h- do { if ((NDEBUG) & (flg)) pr_debug(fmt, ## args); } while (0)
> []
> drivers/scsi/NCR5380.h-#else
> drivers/scsi/NCR5380.h:#define dprintk(flg, fmt, args...)     do {} while (0)
>
> It'd be nice to change the last do {} while (0)
> to something like:
>
> #define dprintk(flg, fmt, args...) \
> do { if (0) pr_debug(fmt, ## args); } while (0)
>
> so the compiler can always verify but not emit any
> actual code or format strings.
>
> Also, using macros with ... and __VA_ARGS__ is
> a bit more modern.
>
> #define dprintk(flg, fmt, ...) \
> do { if (0) pr_debug(fmt, ##__VA_ARGS__); } while (0)

Na, no_printk():

#define dprintk(flg, fmt, ...) no_printk(fmt, ##__VA_ARGS__)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
