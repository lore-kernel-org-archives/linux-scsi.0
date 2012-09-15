From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 22/24] scsi: eesox: use __iomem pointers for MMIO
Date: Sat, 15 Sep 2012 08:00:35 +0000
Message-ID: <201209150800.35605.arnd@arndb.de>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de> <1347658492-11608-23-git-send-email-arnd@arndb.de> <20120914232703.GE12245@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120914232703.GE12245@n2100.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Nicolas Pitre <nico@linaro.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Friday 14 September 2012, Russell King - ARM Linux wrote:
> On Fri, Sep 14, 2012 at 11:34:50PM +0200, Arnd Bergmann wrote:
> > ARM is moving to stricter checks on readl/write functions,
> > so we need to use the correct types everywhere.
> 
> There's nothing wrong with const iomem pointers.  If you think
> otherwise, patch x86 not to use const in its accessor implementation
> and watch the reaction:
> 
> #define build_mmio_read(name, size, type, reg, barrier) \
> static inline type name(const volatile void __iomem *addr) \
> { type ret; asm volatile("mov" size " %1,%0":reg (ret) \
> :"m" (*(volatile type __force *)addr) barrier); return ret; }
> 
> build_mmio_read(readb, "b", unsigned char, "=q", :"memory")
> build_mmio_read(readw, "w", unsigned short, "=r", :"memory")
> build_mmio_read(readl, "l", unsigned int, "=r", :"memory")

Ok, fair enough. Can you fold the patch below into 
"ARM: 7500/1: io: avoid writeback addressing modes for __raw_
accessors", or apply on top then?

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
index 35c1ed8..4c5f708 100644
--- a/arch/arm/include/asm/io.h
+++ b/arch/arm/include/asm/io.h
@@ -39,9 +39,9 @@
  * Generic IO read/write.  These perform native-endian accesses.  Note
  * that some architectures will want to re-define __raw_{read,write}w.
  */
-extern void __raw_writesb(void __iomem *addr, const void *data, int bytelen);
-extern void __raw_writesw(void __iomem *addr, const void *data, int wordlen);
-extern void __raw_writesl(void __iomem *addr, const void *data, int longlen);
+extern void __raw_writesb(const void __iomem *addr, const void *data, int bytelen);
+extern void __raw_writesw(const void __iomem *addr, const void *data, int wordlen);
+extern void __raw_writesl(const void __iomem *addr, const void *data, int longlen);
 
 extern void __raw_readsb(const void __iomem *addr, void *data, int bytelen);
 extern void __raw_readsw(const void __iomem *addr, void *data, int wordlen);
@@ -61,7 +61,7 @@ extern void __raw_readsl(const void __iomem *addr, void *data, int longlen);
  * writeback addressing modes as these incur a significant performance
  * overhead (the address generation must be emulated in software).
  */
-static inline void __raw_writew(u16 val, volatile void __iomem *addr)
+static inline void __raw_writew(u16 val, const volatile void __iomem *addr)
 {
 	asm volatile("strh %1, %0"
 		     : "+Qo" (*(volatile u16 __force *)addr)
@@ -78,14 +78,14 @@ static inline u16 __raw_readw(const volatile void __iomem *addr)
 }
 #endif
 
-static inline void __raw_writeb(u8 val, volatile void __iomem *addr)
+static inline void __raw_writeb(u8 val, const volatile void __iomem *addr)
 {
 	asm volatile("strb %1, %0"
 		     : "+Qo" (*(volatile u8 __force *)addr)
 		     : "r" (val));
 }
 
-static inline void __raw_writel(u32 val, volatile void __iomem *addr)
+static inline void __raw_writel(u32 val, const volatile void __iomem *addr)
 {
 	asm volatile("str %1, %0"
 		     : "+Qo" (*(volatile u32 __force *)addr)
