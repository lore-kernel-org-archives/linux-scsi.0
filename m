From: Jesse Barnes <jbarnes@engr.sgi.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Tue, 21 Sep 2004 13:46:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200409211346.58267.jbarnes@engr.sgi.com>
References: <20040917183029.GW642@parcelfarce.linux.theplanet.co.uk> <200409211303.19110.jbarnes@engr.sgi.com> <1095787216.2507.340.camel@mulgrave>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_SkGUBczlGLgve48"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:58084 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S267928AbUIURrV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 13:47:21 -0400
In-Reply-To: <1095787216.2507.340.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Matthew Wilcox <willy@debian.org>, Grant Grundler <grundler@parisc-linux.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

--Boundary-00=_SkGUBczlGLgve48
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday, September 21, 2004 1:20 pm, James Bottomley wrote:
> On Tue, 2004-09-21 at 13:03, Jesse Barnes wrote:
> > +Driver writers are responsible for ensuring that I/O writes to
> > memory-mapped +addresses on their device arrive when expected and in the
> > order intended.
>
> Really, no.  You're making the document more confusing.  PCI devices
> have *two* types of non DMA accesses (well, three, but lets forget
> configuration space for the moment).
>
> I/O Space accesses (what we call PIO) and memory accesses (what we call
> MMIO)

Right, fixed.

> > +This is typically done by reading a 'safe' device or bridge register,
> > causing +the I/O chipset to flush pending writes to the device before any
> > reads are
>
> Not "bridge register" the specs say this must be an access to the
> device's space.

Fixed.

> > Unfortunately, there's no way to guarantee +that a write has arrived at a
> > device short of a read from the same address
>
> Not same address space, any address space (IO, memory or config) of the
> device will do.

Ok, fixed.

> > +space, so in some cases, udelay() is the only option.  In any case, the
> > driver +should issue an ioflush() call prior to the udelay(), passing in
> > 0 for the
>
> No; using udelay() to try to wait for the flush of posted writes to
> occur is always a bug.

I thought we determined that sometimes there's no other option?  I'll remove 
that sentence anyway.


> > +addr argument if no safe register exists.  This will allow the platform
> > to +make an effort to get the write as close to the device as possible
> > before +allowing the udelay to begin.
>
> What ioflush() call?  There's no such thing in PCI; this is effectively
> our problem.  If there were a nice flush instruction we wouldn't have to
> worry about reading from somewhere on the device.  The problem is that
> there's no a-priori way of knowing what read is safe to do, so there's
> no generic way to extract a posting flush API.

The one I just added with this patch.  It takes a struct device and address 
arguments, the latter is supposed to be a safe register, like config space.

I'm tying together the concepts of write posting and ordering intentionally, 
but I wonder if that's a good idea.  On the one hand, we don't want to 
introduce *two* new driver APIs, but on the other, ensuring ordering and 
actually flushing writes out are two different things.  Maybe we just need to 
tell people 

Jesse

--Boundary-00=_SkGUBczlGLgve48
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="ioflush-ia64-2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="ioflush-ia64-2.patch"

===== Documentation/io_ordering.txt 1.1 vs edited =====
--- 1.1/Documentation/io_ordering.txt	2003-03-18 02:02:11 -08:00
+++ edited/Documentation/io_ordering.txt	2004-09-21 10:32:06 -07:00
@@ -1,24 +1,60 @@
-On some platforms, so-called memory-mapped I/O is weakly ordered.  On such
-platforms, driver writers are responsible for ensuring that I/O writes to
-memory-mapped addresses on their device arrive in the order intended.  This is
-typically done by reading a 'safe' device or bridge register, causing the I/O
-chipset to flush pending writes to the device before any reads are posted.  A
-driver would usually use this technique immediately prior to the exit of a
-critical section of code protected by spinlocks.  This would ensure that
-subsequent writes to I/O space arrived only after all prior writes (much like a
-memory barrier op, mb(), only with respect to I/O).
+Dealing with posted writes
+--------------------------
 
-A more concrete example from a hypothetical device driver:
+Driver writers are responsible for ensuring that I/O writes to their device
+arrive when expected and in the order intended.  This is typically done by
+reading a 'safe' device register, causing the I/O chipset to flush pending
+writes to the device before any reads are sent to the target device.  A driver
+would usually use this technique immediately prior to a read after a card
+reset or the exit of a critical section of code protected by spinlocks.  This
+would ensure that subsequent I/O space accesses arrived only after all prior
+writes.  There are really two issues at play here, one is 'posting', i.e.
+memory-mapped I/O writes not sent to the device immediately, and ordering,
+where on a large system writes from different CPUs may arrive out of order.
 
-        ...
+Some pseudocode to illustrate the problem of write posting:
+
+...
+spin_lock_irqsave(&dev_lock, flags)
+...
+writel(resetval, reset_reg); /* reset the card */
+udelay(10); /* wait for reset (also needs pioflush) */
+val = readl(ring_ptr); /* read initial value */
+spin_unlock_irqrestore(&dev_lock, flags)
+...
+
+In this case, the card is reset by the first write.  The driver attempts to
+wait for the completion of the reset using udelay.  But since the write may be
+delayed and the udelay will probably start executing right away, it may be
+that there's not enough time for the write to actually arrive at the card and
+for the reset to occur before the read is executed.  On some platforms, this
+can result in a machine check.  Unfortunately, there's no way to guarantee
+that a write has arrived at a device short of a read from a safe register.  In
+any case, the driver should issue an ioflush() call prior to the udelay(),
+passing in 0 for the addr argument if no safe register exists or if the driver
+is merely trying to ensure write ordering.  This will allow the platform to
+make an effort to get the write as close to the device as possible before
+allowing the udelay to begin.  Example:
+
+...
+spin_lock_irqsave(&dev_lock, flags)
+...
+writel(resetval, reset_reg); /* reset the card */
+ioflush(dev, config_reg); /* flush out the write */
+udelay(10);
+val = readl(ring_ptr); /* read initial value */
+spin_unlock_irqrestore(&dev_lock, flags)
+...
+
+Here's an example of reordering of writes between CPUs on a NUMA machine:
+
+	...
 CPU A:  spin_lock_irqsave(&dev_lock, flags)
-CPU A:  val = readl(my_status);
 CPU A:  ...
 CPU A:  writel(newval, ring_ptr);
 CPU A:  spin_unlock_irqrestore(&dev_lock, flags)
         ...
 CPU B:  spin_lock_irqsave(&dev_lock, flags)
-CPU B:  val = readl(my_status);
 CPU B:  ...
 CPU B:  writel(newval2, ring_ptr);
 CPU B:  spin_unlock_irqrestore(&dev_lock, flags)
@@ -29,19 +65,21 @@
 
         ...
 CPU A:  spin_lock_irqsave(&dev_lock, flags)
-CPU A:  val = readl(my_status);
 CPU A:  ...
 CPU A:  writel(newval, ring_ptr);
-CPU A:  (void)readl(safe_register); /* maybe a config register? */
+CPU A:  ioflush(dev, 0);
 CPU A:  spin_unlock_irqrestore(&dev_lock, flags)
         ...
 CPU B:  spin_lock_irqsave(&dev_lock, flags)
-CPU B:  val = readl(my_status);
 CPU B:  ...
 CPU B:  writel(newval2, ring_ptr);
-CPU B:  (void)readl(safe_register); /* maybe a config register? */
+CPU B:  ioflush(dev, 0);
 CPU B:  spin_unlock_irqrestore(&dev_lock, flags)
 
-Here, the reads from safe_register will cause the I/O chipset to flush any
-pending writes before actually posting the read to the chipset, preventing
-possible data corruption.
+Here, the ioflush() call will cause the I/O chipset to flush any outstanding
+writes before actually sending the read to the chipset, preventing possible
+data corruption.
+
+inX and outX calls, on the other hand, are strongly ordered and non-postable.
+They do not need special handling.  But this is something to watch out for
+when converting drivers to use MMIO space from IO Port space.
===== arch/ia64/sn/io/machvec/iomv.c 1.9 vs edited =====
--- 1.9/arch/ia64/sn/io/machvec/iomv.c	2004-05-26 06:49:19 -07:00
+++ edited/arch/ia64/sn/io/machvec/iomv.c	2004-09-21 09:34:19 -07:00
@@ -54,23 +54,18 @@
 EXPORT_SYMBOL(sn_io_addr);
 
 /**
- * sn_mmiob - I/O space memory barrier
+ * __sn_ioflush - I/O space write flush
  *
- * Acts as a memory mapped I/O barrier for platforms that queue writes to 
- * I/O space.  This ensures that subsequent writes to I/O space arrive after
- * all previous writes.  For most ia64 platforms, this is a simple
- * 'mf.a' instruction.  For other platforms, mmiob() may have to read
- * a chipset register to ensure ordering.
+ * See include/asm-ia64/io.h and Documentation/io_ordering.txt for details.
  *
  * On SN2, we wait for the PIO_WRITE_STATUS SHub register to clear.
  * See PV 871084 for details about the WAR about zero value.
  *
  */
-void
-sn_mmiob (void)
+void __sn_ioflush(struct device *dev, unsigned long addr)
 {
 	while ((((volatile unsigned long) (*pda->pio_write_status_addr)) & SH_PIO_WRITE_STATUS_0_PENDING_WRITE_COUNT_MASK) != 
 				SH_PIO_WRITE_STATUS_0_PENDING_WRITE_COUNT_MASK)
 		cpu_relax();
 }
-EXPORT_SYMBOL(sn_mmiob);
+EXPORT_SYMBOL(__sn_ioflush);
===== include/asm-ia64/io.h 1.19 vs edited =====
--- 1.19/include/asm-ia64/io.h	2004-02-03 21:31:10 -08:00
+++ edited/include/asm-ia64/io.h	2004-09-21 10:30:16 -07:00
@@ -91,6 +91,27 @@
  */
 #define __ia64_mf_a()	ia64_mfa()
 
+/**
+ * __ia64_ioflush - I/O write flush
+ * @dev: device we're flushing
+ * @addr: safe register to read
+ *
+ * Flush I/O space writes out to their target device to ensure ordering.
+ * all previous writes.  For most ia64 platforms, this is a simple
+ * 'mf.a' instruction, so the address is ignored.  For other platforms,
+ * the address may be required to ensure proper ordering of writes to I/O space
+ * since a 'dummy' read might be necessary to barrier the write operation.
+ *
+ * If either @dev or @addr is 0, don't use it.  @addr should be 0 if the driver
+ * is just trying to make sure writes arrive in order.
+ *
+ * See Documentation/io_ordering.txt for more information.
+ */
+static inline void __ia64_ioflush (struct device *dev, unsigned long addr)
+{
+	ia64_mfa();
+}
+
 static inline const unsigned long
 __ia64_get_io_port_base (void)
 {
@@ -267,6 +288,7 @@
 #define __outb		platform_outb
 #define __outw		platform_outw
 #define __outl		platform_outl
+#define __ioflush	platform_ioflush
 
 #define inb(p)		__inb(p)
 #define inw(p)		__inw(p)
@@ -280,6 +302,7 @@
 #define outsb(p,s,c)	__outsb(p,s,c)
 #define outsw(p,s,c)	__outsw(p,s,c)
 #define outsl(p,s,c)	__outsl(p,s,c)
+#define ioflush(d,a)	__ioflush(d,a)
 
 /*
  * The address passed to these functions are ioremap()ped already.
===== include/asm-ia64/machvec.h 1.26 vs edited =====
--- 1.26/include/asm-ia64/machvec.h	2004-08-03 16:05:22 -07:00
+++ edited/include/asm-ia64/machvec.h	2004-09-21 09:35:32 -07:00
@@ -62,6 +62,7 @@
 typedef void ia64_mv_outb_t (unsigned char, unsigned long);
 typedef void ia64_mv_outw_t (unsigned short, unsigned long);
 typedef void ia64_mv_outl_t (unsigned int, unsigned long);
+typedef void ia64_mv_ioflush_t (struct device *, unsigned long);
 typedef unsigned char ia64_mv_readb_t (void *);
 typedef unsigned short ia64_mv_readw_t (void *);
 typedef unsigned int ia64_mv_readl_t (void *);
@@ -130,6 +131,7 @@
 #  define platform_outb		ia64_mv.outb
 #  define platform_outw		ia64_mv.outw
 #  define platform_outl		ia64_mv.outl
+#  define platform_ioflush	ia64_mv.ioflush
 #  define platform_readb        ia64_mv.readb
 #  define platform_readw        ia64_mv.readw
 #  define platform_readl        ia64_mv.readl
@@ -176,6 +178,7 @@
 	ia64_mv_outb_t *outb;
 	ia64_mv_outw_t *outw;
 	ia64_mv_outl_t *outl;
+	ia64_mv_ioflush_t *ioflush;
 	ia64_mv_readb_t *readb;
 	ia64_mv_readw_t *readw;
 	ia64_mv_readl_t *readl;
@@ -218,6 +221,7 @@
 	platform_outb,				\
 	platform_outw,				\
 	platform_outl,				\
+	platform_ioflush,			\
 	platform_readb,				\
 	platform_readw,				\
 	platform_readl,				\
@@ -343,6 +347,9 @@
 #endif
 #ifndef platform_outl
 # define platform_outl		__ia64_outl
+#endif
+#ifndef platform_ioflush
+# define platform_ioflush	__ia64_ioflush
 #endif
 #ifndef platform_readb
 # define platform_readb		__ia64_readb
===== include/asm-ia64/machvec_init.h 1.7 vs edited =====
--- 1.7/include/asm-ia64/machvec_init.h	2004-02-06 00:30:24 -08:00
+++ edited/include/asm-ia64/machvec_init.h	2004-09-21 09:35:47 -07:00
@@ -12,6 +12,7 @@
 extern ia64_mv_outb_t __ia64_outb;
 extern ia64_mv_outw_t __ia64_outw;
 extern ia64_mv_outl_t __ia64_outl;
+extern ia64_mv_ioflush_t __ia64_ioflush;
 extern ia64_mv_readb_t __ia64_readb;
 extern ia64_mv_readw_t __ia64_readw;
 extern ia64_mv_readl_t __ia64_readl;
===== include/asm-ia64/machvec_sn2.h 1.14 vs edited =====
--- 1.14/include/asm-ia64/machvec_sn2.h	2004-07-10 17:14:00 -07:00
+++ edited/include/asm-ia64/machvec_sn2.h	2004-09-21 09:36:14 -07:00
@@ -49,6 +49,7 @@
 extern ia64_mv_outb_t __sn_outb;
 extern ia64_mv_outw_t __sn_outw;
 extern ia64_mv_outl_t __sn_outl;
+extern ia64_mv_ioflush_t __sn_ioflush;
 extern ia64_mv_readb_t __sn_readb;
 extern ia64_mv_readw_t __sn_readw;
 extern ia64_mv_readl_t __sn_readl;
@@ -92,6 +93,7 @@
 #define platform_outb			__sn_outb
 #define platform_outw			__sn_outw
 #define platform_outl			__sn_outl
+#define platform_ioflush		__sn_ioflush
 #define platform_readb			__sn_readb
 #define platform_readw			__sn_readw
 #define platform_readl			__sn_readl
===== include/asm-ia64/sn/io.h 1.7 vs edited =====
--- 1.7/include/asm-ia64/sn/io.h	2004-02-13 07:00:22 -08:00
+++ edited/include/asm-ia64/sn/io.h	2004-09-21 09:38:27 -07:00
@@ -58,8 +58,8 @@
 #include <asm/sn/sn2/shubio.h>
 
 /*
- * Used to ensure write ordering (like mb(), but for I/O space)
+ * Used to ensure write ordering
  */
-extern void sn_mmiob(void);
+extern void __sn_ioflush(struct device *dev, unsigned long addr);
 
 #endif /* _ASM_IA64_SN_IO_H */
===== include/asm-ia64/sn/sn2/io.h 1.6 vs edited =====
--- 1.6/include/asm-ia64/sn/sn2/io.h	2004-07-22 17:00:00 -07:00
+++ edited/include/asm-ia64/sn/sn2/io.h	2004-09-21 09:31:56 -07:00
@@ -11,8 +11,10 @@
 #include <linux/compiler.h>
 #include <asm/intrinsics.h>
 
-extern void * sn_io_addr(unsigned long port) __attribute_const__; /* Forward definition */
-extern void sn_mmiob(void); /* Forward definition */
+/* Forward declarations */
+struct device;
+extern void *sn_io_addr(unsigned long port) __attribute_const__;
+extern void __sn_ioflush(struct device *dev, unsigned long addr);
 
 #define __sn_mf_a()   ia64_mfa()
 
@@ -91,7 +93,7 @@
 
 	if ((addr = sn_io_addr(port))) {
 		*addr = val;
-		sn_mmiob();
+		__sn_ioflush(0, 0);
 	}
 }
 
@@ -102,7 +104,7 @@
 
 	if ((addr = sn_io_addr(port))) {
 		*addr = val;
-		sn_mmiob();
+		__sn_ioflush(0, 0);
 	}
 }
 
@@ -113,7 +115,7 @@
 
 	if ((addr = sn_io_addr(port))) {
 		*addr = val;
-		sn_mmiob();
+		__sn_ioflush(0, 0);
 	}
 }
 

--Boundary-00=_SkGUBczlGLgve48--
