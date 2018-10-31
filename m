From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH 6/9] PCI: consolidate PCI config entry in drivers/pci
Date: Thu, 1 Nov 2018 01:05:26 +0900
Message-ID: <CAK7LNASUArREw1AWUzcOoQCe5=4jyifbs+x2CdCK+qXJ+woAdw@mail.gmail.com>
References: <20181019120952.32763-1-hch@lst.de> <20181019120952.32763-7-hch@lst.de>
 <20181019122228.GJ30658@n2100.armlinux.org.uk> <CAK7LNATZ8LagrTrTae_QCQbSuTW7_y6sDrdTHfTyONPrsYDs4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK7LNATZ8LagrTrTae_QCQbSuTW7_y6sDrdTHfTyONPrsYDs4A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-arch <linux-arch@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, linux-pci@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Alex Bounine <alex.bou9@gmail.com>, mporter@kernel.crashing.org, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Russell King <linux@armlinux.org.uk>
List-Id: linux-scsi@vger.kernel.org

Hi Christoph,


On Fri, Oct 19, 2018 at 9:58 PM Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
>
> On Fri, Oct 19, 2018 at 9:23 PM Russell King - ARM Linux
> <linux@armlinux.org.uk> wrote:
>
> > > index a68b34183107..b185794549be 100644
> > > --- a/arch/arm/mach-pxa/Kconfig
> > > +++ b/arch/arm/mach-pxa/Kconfig
> > > @@ -125,7 +125,7 @@ config MACH_ARMCORE
> > >       bool "CompuLab CM-X255/CM-X270 modules"
> > >       select ARCH_HAS_DMA_SET_COHERENT_MASK if PCI
> > >       select IWMMXT
> > > -     select MIGHT_HAVE_PCI
> > > +     select HAVE_PCI
> > >       select NEED_MACH_IO_H if PCI
> > >       select PXA25x
> > >       select PXA27x
> >
> > This is wrong.  "MIGHT_HAVE_PCI" is _not_ the same as "HAVE_PCI" - we
> > have a bunch of platforms that mandatorily have PCI and these select
> > PCI directly.  "MIGHT_HAVE_PCI" controls the _visibility_ of the PCI
> > menu option, but does not prevent it being selected.  Your patch will
> > cause Kconfig to complain for those which mandatorily have PCI but
> > do not set HAVE_PCI.
>
>
> Good catch!
> But, adding a bunch of 'select HAVE_PCI' along with 'select PCI' is ugly.
>
> Do you have any suggestion?
>
> How about letting CONFIG_ARM to select HAVE_PCI ?
>


I applied 1/9, 3/9, 4/9, 5/9.
(I think 2/9 should be squashed to 9/9)

As Russell pointed out, we need to avoid
the unmet dependency.


Are you planning to send
the updated version for 6/9 through - 9/9 ?

If so, could you please rebase 6/9
so that it is cleanly applicable ?


Thanks.


--
Best Regards
Masahiro Yamada
