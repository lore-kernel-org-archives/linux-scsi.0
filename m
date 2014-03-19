From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 00/12] scsi/NCR5380: fix debugging macros and #include
 structure
Date: Wed, 19 Mar 2014 12:46:16 +1100 (EST)
Message-ID: <alpine.LNX.2.00.1403191240001.23002@nippy.intranet>
References: <20140318002822.372705594@telegraphics.com.au>  <1395112756.20860.1.camel@joe-AO722>  <alpine.LNX.2.00.1403182208590.2018@nippy.intranet>  <1395146702.2812.47.camel@joe-AO722>  <CAMuHMdUMpdp7deL5zC4hUVTHjyNbtkZ2bNFupo5JiDyuyc345w@mail.gmail.com>
  <1395148051.2812.51.camel@joe-AO722>  <alpine.LNX.2.00.1403190925550.6652@nippy.intranet> <1395190072.8649.2.camel@joe-AO722>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1395190072.8649.2.camel@joe-AO722>
Sender: linux-m68k-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, scsi <linux-scsi@vger.kernel.org>, Sam Creasey <sammy@sammy.net>, Russell King <linux@arm.linux.org.uk>, Michael Schmitz <schmitz@debian.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Linux/m68k <linux-m68k@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On Tue, 18 Mar 2014, Joe Perches wrote:

> But using "if (0)" prevents the no_printk from occurring at all so there 
> would be no side-effects and the format & args would still be verified 
> by the compiler.

I'd prefer this (for symmetry and clarity):

#if NDEBUG
#define dprintk(flg, fmt, ...) \
        do { if ((NDEBUG) & (flg)) pr_debug(fmt, ## __VA_ARGS__); } while (0)
#else
#define dprintk(flg, fmt, ...) \
        do { if (0) pr_debug(fmt, ## __VA_ARGS__); } while (0)
#endif

But you seem to be asking for this instead:

#if NDEBUG
#define dprintk(flg, fmt, ...) \
        do { if ((NDEBUG) & (flg)) pr_debug(fmt, ## __VA_ARGS__); } while (0)
#else
#define dprintk(flg, fmt, ...) \
        do { if (0) no_printk(fmt, ## __VA_ARGS__); } while (0)
#endif

Why is that better?

-- 
