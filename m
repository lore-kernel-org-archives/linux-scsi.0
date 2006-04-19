From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: 2.6.17-rc1+git, Sym2: unknown symbol pcibios_resource_to_bus (fwd)
Date: Tue, 18 Apr 2006 21:59:08 -0600
Message-ID: <20060419035908.GH24104@parisc-linux.org>
References: <Pine.SOC.4.61.0604171849100.21709@math.ut.ee> <20060417.131705.40072804.davem@davemloft.net> <20060417.132638.84565849.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060417.132638.84565849.davem@davemloft.net>
Sender: sparclinux-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>
Cc: mroos@linux.ee, sparclinux@vger.kernel.org, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, uclinux-v850@lsi.nec.co.jp, rmk@arm.linux.org.uk
List-Id: linux-scsi@vger.kernel.org

On Mon, Apr 17, 2006 at 01:26:38PM -0700, David S. Miller wrote:
> From: "David S. Miller" <davem@davemloft.net>
> Date: Mon, 17 Apr 2006 13:17:05 -0700 (PDT)
> 
> > > Forwarded from linux-scsi.
> >  ...
> > > pcibios_resource_to_bus is a new function which is inline in
> > > asm-generic/pci.h.   However, sparc64 overrides it as an external
> > > function which is in arch/sparc64/kernel/pci.c, so this looks like some
> > > type of sparc issue.

"new" in the sense of "2 years old"?
2003-03-16 	rmk 	[PCI] pci-8: pci_resource_to_bus()

> > Why does the SYM2 driver possible even need this symbol?
> > That's what I'd like to have explained.

Because the firmware needs to be programmed with the bus address.  It's
not unique in this; the Emulex lpfc driver should also be using this
function.

> If you're going to do stuff like this, being that you're the
> first driver to ever make direct usage of this interface,
> please double check the exports on all platforms so that you
> haven't broken the build of the driver as you have on sparc64.

Er, pcmcia was already using it:

./drivers/pcmcia/i82092.c:      pcibios_resource_to_bus(sock_info->dev,
&region, mem->res);
./drivers/pcmcia/yenta_socket.c:
pcibios_resource_to_bus(socket->dev, &region, mem->res);
./drivers/pcmcia/yenta_socket.c:
pcibios_resource_to_bus(socket->dev, &region, &dev->resource[0]);

I suppose you don't test pci-pcmcia adapters very often on sparc64.

Is there a problem with adding the symbol export?  I noticed that v850
also doesn't export that symbol.
