From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 00/12] scsi/NCR5380: fix debugging macros and #include
 structure
Date: Tue, 18 Mar 2014 17:47:52 -0700
Message-ID: <1395190072.8649.2.camel@joe-AO722>
References: <20140318002822.372705594@telegraphics.com.au>
	 <1395112756.20860.1.camel@joe-AO722>
	 <alpine.LNX.2.00.1403182208590.2018@nippy.intranet>
	 <1395146702.2812.47.camel@joe-AO722>
	 <CAMuHMdUMpdp7deL5zC4hUVTHjyNbtkZ2bNFupo5JiDyuyc345w@mail.gmail.com>
	 <1395148051.2812.51.camel@joe-AO722>
	 <alpine.LNX.2.00.1403190925550.6652@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1403190925550.6652@nippy.intranet>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, scsi <linux-scsi@vger.kernel.org>, Sam Creasey <sammy@sammy.net>, Russell King <linux@arm.linux.org.uk>, Michael Schmitz <schmitz@debian.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Linux/m68k <linux-m68k@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On Wed, 2014-03-19 at 10:14 +1100, Finn Thain wrote:
> As for side-effects, chip register accesses would be affected if dprintk() 
> expanded to no_printk() when NDEBUG & flg == 0.
> 
> E.g. NCR5380.c line 1213:
> dprintk(NDEBUG_INTR, "scsi : unknown interrupt, BASR 0x%X, MR 0x%X, SR 0x%x\n",
>                      basr, NCR5380_read(MODE_REG), NCR5380_read(STATUS_REG));
> 
> I don't want to re-introduce side-effects into a dozen different NCR5380 
> drivers on three different architectures when I can test only one of those 
> drivers. It's difficult to get good code coverage even for one driver.

Hi again Finn.

If dprintk expanded directly to no_printk, then true.

But using "if (0)" prevents the no_printk from
occurring at all so there would be no side-effects
and the format & args would still be verified by the
compiler.

So I believe you shouldn't worry about side-effects.

cheers, Joe
