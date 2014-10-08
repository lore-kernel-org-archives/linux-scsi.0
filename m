From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 23/29] atari_scsi: Convert to platform device
Date: Wed, 8 Oct 2014 22:59:16 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1410081443410.15753@nippy.intranet>
References: <20141002065628.256592712@telegraphics.com.au> <20141002065633.766165263@telegraphics.com.au> <CAMuHMdWmxEUMabRrbQpjhWTE1W4WD4CDkmXZNem06C0ScnKkFw@mail.gmail.com> <alpine.LNX.2.00.1410032054150.12643@nippy.intranet> <54308629.6060800@gmail.com>
 <alpine.LNX.2.00.1410061754280.26699@nippy.intranet> <54324F78.6090303@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <54324F78.6090303@gmail.com>
Sender: linux-m68k-owner@vger.kernel.org
To: Michael Schmitz <schmitzmic@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sam Creasey <sammy@sammy.net>, scsi <linux-scsi@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>, Ondrej Zary <linux@rainbow-software.org>
List-Id: linux-scsi@vger.kernel.org


On Mon, 6 Oct 2014, Michael Schmitz wrote:

> > > > > Can these be handled through the platform_device's resources?
> > > > 
> > > > I don't know.
> > > 
> > > Should be possible - I've seen that used in the ISP116x HCD driver 
> > > (arch-dependent post-register access delay function passed via 
> > > platform data).
> >
> > Yes, possible, but is it desirable?
> 
> Only long term, i.e. if we can find a way to fold all the separate 
> *_NCR5380 drivers into a core one.

But would it improve the ISA drivers to paramaterize the core driver using 
platform data? I don't know the answer, so I tend to think of code 
duplication as a separate issue.

> >
> > If there's no third configuration then I see little to be gained from 
> > completely parameterizing the driver using a bunch of resources.
> >
> > What am I missing? Why would it be desirable to have bits of driver 
> > code in arch/m68k/ and other bits of the same driver kept elsewhere in 
> > the tree (in drivers/)?
> 
> Again, only makes sense if the goal is to reduce the driver to a core 
> driver with implementation bits separate.
> 

I think it makes sense if it completely eliminates modules like 
{atari,mac,sun3}_scsi and replaces them with a generic ncr5380 platform 
driver entirely parameterized by mac/atari/sun3 platform data.

Or maybe that would only amount to a complicated renaming, as the 
{atari,mac,sun3}_scsi driver logic would presumably just move from 
drivers/scsi to arch/m68k.

Anyway, that's a long way off. To begin with, it would require the 
elimination of all the macros (e.g. SUN3_SCSI_VME, REAL_DMA etc, and
NCR5380_{read,write,dma_read_setup,etc}) and all the static variables 
(setup_use_tagged_queuing, atari_read_overruns etc).

I have written patches that eliminate static variables because that 
enables atari_NCR5380.c to support multiple chips, and it helps fix a 
compiler warning, and also helps cleanup the *RELEASE macros.

Replacing all the macros with flags and an ops struct/plataform data is 
not too difficult for atari_NCR5380.c at present but will be more 
difficult after sun3_NCR5380.c is merged into it.

The same goes for NCR5380.c and the ISA drivers.

I don't yet see a good way to merge all three core drivers, and if I did, 
I wouldn't be able to test the results. Hence I've taken a more gradual 
approach. This patch set eliminates scsi_register() from 
{atari,mac,sun3}_scsi at least.

-- 
