From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH 6/9] PCI: consolidate PCI config entry in drivers/pci
Date: Thu, 1 Nov 2018 10:24:58 +0000
Message-ID: <20181101102458.GN30658@n2100.armlinux.org.uk>
References: <20181019120952.32763-1-hch@lst.de>
 <20181019120952.32763-7-hch@lst.de>
 <20181019122228.GJ30658@n2100.armlinux.org.uk>
 <CAK7LNATZ8LagrTrTae_QCQbSuTW7_y6sDrdTHfTyONPrsYDs4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK7LNATZ8LagrTrTae_QCQbSuTW7_y6sDrdTHfTyONPrsYDs4A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-arch <linux-arch@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, linux-pci@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Alex Bounine <alex.bou9@gmail.com>, mporter@kernel.crashing.org, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 19, 2018 at 09:58:46PM +0900, Masahiro Yamada wrote:
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

Well, the situation we have on ARM is rather optimal - when the
rest of the configuration supports PCI, PCI is made visible.  When
there's no hardware support for PCI, PCI is hidden.  When PCI is
mandatory, PCI is selected and mostly always hidden.

It seems that with this consolidation, we lose that - we end up
with PCI being visible for every ARM config, not only those where
PCI is "impossible" but also for those where PCI is forcefully
selected.

That said, offering PCI for platforms that do not have any possibility
of PCI hardware shouldn't cause any compile issues, and would increase
build coverage - but I'd say it wouldn't _usefully_ increase build
coverage.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
