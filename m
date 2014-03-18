From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 00/12] scsi/NCR5380: fix debugging macros and #include structure
Date: Tue, 18 Mar 2014 14:13:53 +0100
Message-ID: <CAMuHMdVxTQDdpcdjZZRSrvT8cmuT2AkE1q6WaSWey8U+PuVX2w@mail.gmail.com>
References: <20140318002822.372705594@telegraphics.com.au>
	<1395112756.20860.1.camel@joe-AO722>
	<alpine.LNX.2.00.1403182208590.2018@nippy.intranet>
	<1395146702.2812.47.camel@joe-AO722>
	<CAMuHMdUMpdp7deL5zC4hUVTHjyNbtkZ2bNFupo5JiDyuyc345w@mail.gmail.com>
	<1395148051.2812.51.camel@joe-AO722>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1395148051.2812.51.camel@joe-AO722>
Sender: linux-m68k-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@parallels.com>, scsi <linux-scsi@vger.kernel.org>, Sam Creasey <sammy@sammy.net>, Russell King <linux@arm.linux.org.uk>, Michael Schmitz <schmitz@debian.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Linux/m68k <linux-m68k@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Joe,

On Tue, Mar 18, 2014 at 2:07 PM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2014-03-18 at 13:55 +0100, Geert Uytterhoeven wrote:
>> On Tue, Mar 18, 2014 at 1:45 PM, Joe Perches <joe@perches.com> wrote:
>> > #define dprintk(flg, fmt, ...) \
>> > do { if (0) pr_debug(fmt, ##__VA_ARGS__); } while (0)
>>
>> Na, no_printk():
>>
>> #define dprintk(flg, fmt, ...) no_printk(fmt, ##__VA_ARGS__)
>
> Fine, but with a correction.
>
> no_printk keeps all side effects like
> performing any function calls made by the
> statement or accessing any volatiles.

That's true...

> Using
>
> do { if (0) no_printk(fmt, ##__VA_ARGS__); } while (0)
>
> does not have any side-effects.

... but all current users in include/ have the side-effects.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
