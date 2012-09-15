From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 22/24] scsi: eesox: use __iomem pointers for MMIO
Date: Sat, 15 Sep 2012 10:30:43 +0000
Message-ID: <201209151030.44105.arnd@arndb.de>
References: <201209150800.35605.arnd@arndb.de> <20120915085734.GG12245@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:65227 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab2IOKay (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Sep 2012 06:30:54 -0400
In-Reply-To: <20120915085734.GG12245@n2100.arm.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Nicolas Pitre <nico@linaro.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

On Saturday 15 September 2012, Russell King - ARM Linux wrote:
> On Sat, Sep 15, 2012 at 08:00:35AM +0000, Arnd Bergmann wrote:
> > On Friday 14 September 2012, Russell King - ARM Linux wrote:
> > > On Fri, Sep 14, 2012 at 11:34:50PM +0200, Arnd Bergmann wrote:
> > > > ARM is moving to stricter checks on readl/write functions,
> > > > so we need to use the correct types everywhere.
> > > 
> > > There's nothing wrong with const iomem pointers.  If you think
> > > otherwise, patch x86 not to use const in its accessor implementation
> > > and watch the reaction:
> > > 
> > > #define build_mmio_read(name, size, type, reg, barrier) \
> > > static inline type name(const volatile void __iomem *addr) \
> > > { type ret; asm volatile("mov" size " %1,%0":reg (ret) \
> > > :"m" (*(volatile type __force *)addr) barrier); return ret; }
> > > 
> > > build_mmio_read(readb, "b", unsigned char, "=q", :"memory")
> > > build_mmio_read(readw, "w", unsigned short, "=r", :"memory")
> > > build_mmio_read(readl, "l", unsigned int, "=r", :"memory")
> > 
> > Ok, fair enough. Can you fold the patch below into 
> > "ARM: 7500/1: io: avoid writeback addressing modes for __raw_
> > accessors", or apply on top then?
> 
> No - const is not appropriate for the write accessors.  Again, this puts
> us at odds with x86:
> 
> #define build_mmio_write(name, size, type, reg, barrier) \
> static inline void name(type val, volatile void __iomem *addr) \
> { asm volatile("mov" size " %0,%1": :reg (val), \
> "m" (*(volatile type __force *)addr) barrier); }
> 
> build_mmio_write(writeb, "b", unsigned char, "q", :"memory")
> build_mmio_write(writew, "w", unsigned short, "r", :"memory")
> build_mmio_write(writel, "l", unsigned int, "r", :"memory")
> 
> So, readl etc are all const volatile void __iomem *, but writel etc are
> all volatile void __iomem *.
> 
> How they're defined on ARM after 7500/1 copies how they're defined on
> x86.

Well, you have to make up your mind what you want. Right now, we get these
warnings in rpc_defconfig:

  Generating include/generated/mach-types.h
/home/arnd/linux-arm/drivers/net/ethernet/seeq/ether3.c: In function 'ether3_outb':
/home/arnd/linux-arm/drivers/net/ethernet/seeq/ether3.c:104:2: error: passing argument 2 of '__raw_writeb' discards 'const' qualifier from pointer target type [-Werror]
/home/arnd/linux-arm/arch/arm/include/asm/io.h:81:91: note: expected 'volatile void *' but argument is of type 'const void *'
/home/arnd/linux-arm/drivers/scsi/arm/eesox.c: In function 'eesoxscsi_buffer_out':
/home/arnd/linux-arm/drivers/scsi/arm/eesox.c:310:4: error: passing argument 2 of '__raw_writel' discards 'const' qualifier from pointer target type [-Werror]
/home/arnd/linux-arm/arch/arm/include/asm/io.h:88:91: note: expected 'volatile void *' but argument is of type 'const void *'
/home/arnd/linux-arm/drivers/scsi/arm/eesox.c:324:4: error: passing argument 2 of '__raw_writel' discards 'const' qualifier from pointer target type [-Werror]
/home/arnd/linux-arm/arch/arm/include/asm/io.h:88:91: note: expected 'volatile void *' but argument is of type 'const void *'
/home/arnd/linux-arm/drivers/scsi/arm/eesox.c:325:4: error: passing argument 2 of '__raw_writel' discards 'const' qualifier from pointer target type [-Werror]
/home/arnd/linux-arm/arch/arm/include/asm/io.h:88:91: note: expected 'volatile void *' but argument is of type 'const void *'

Either we allow drivers to write to const __iomem pointers or we don't. I
don't care which way we do it, but just saying both patches are wrong is
not very helpful.

	Arnd
