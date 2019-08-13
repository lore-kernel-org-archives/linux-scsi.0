Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABF75C433FF
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 07:27:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5819F20578
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 07:27:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="biCW9pDz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbfHMH0Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 03:26:16 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:52450 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727893AbfHMH0P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Aug 2019 03:26:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=g4R7LiZJ/nBrdjhf2WYQjTPNKYXVaoKLbDAalz9PazA=; b=biCW9pDzJBA/+nNGvgyJcJh6A2
        LXmSclv/tnefaiw8Kn9p8JJJaadedr0qUMFOON7PGxKzjLqi6qg75EhxBr/m3qXl51vdUapARghZI
        nq1AKz+/OQLaGcf+f8az6o8/i1ODkN9bAvCWsZ4pP6WkQxYslsCH6J4XX7klpJwuMMBGJUIWRlRDy
        Mfg8rRqqaNg3KkYhjnGjH6r9tI14nDaTHBCF+vnPaS8PwjHQk0D91vA8GAoFNZEbZVLq9a7Qxvcvj
        eAHsGHc5YxuFLpu6VUaM7zRnLKUl1ymkMwewbRd/IYTrLdCKqlss7QHisSf+QswF5MaiO1wwOvi4I
        NYvu/clg==;
Received: from [2001:4bb8:180:1ec3:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hxRC7-0006VB-B3; Tue, 13 Aug 2019 07:26:12 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Mike Travis <mike.travis@hpe.com>,
        Dimitri Sivanich <sivanich@hpe.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-ia64@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 16/28] ia64: remove now unused machvec indirections
Date:   Tue, 13 Aug 2019 09:25:02 +0200
Message-Id: <20190813072514.23299-17-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190813072514.23299-1-hch@lst.de>
References: <20190813072514.23299-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

With the SGI SN2 machvec removal most of the indirections are unused
now, so remove them.  This includes the entire removal of the mmio
read*/write* macros as the generic ones are identical to the
asm-generic/io.h version.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/ia64/include/asm/hw_irq.h       |  22 +--
 arch/ia64/include/asm/io.h           | 221 ++++--------------------
 arch/ia64/include/asm/machvec.h      | 241 ---------------------------
 arch/ia64/include/asm/machvec_init.h |  24 ---
 arch/ia64/include/asm/mmiowb.h       |  12 +-
 arch/ia64/include/asm/pci.h          |   6 +-
 arch/ia64/include/asm/switch_to.h    |   1 -
 arch/ia64/kernel/iosapic.c           |   5 +-
 arch/ia64/kernel/irq.c               |  12 --
 arch/ia64/kernel/irq_ia64.c          |   2 +-
 arch/ia64/kernel/machine_kexec.c     |   1 -
 arch/ia64/kernel/machvec.c           |   7 -
 arch/ia64/kernel/mca.c               |  10 +-
 arch/ia64/kernel/msi_ia64.c          |  21 +--
 arch/ia64/kernel/sal.c               |   2 +-
 arch/ia64/kernel/setup.c             |   1 -
 arch/ia64/kernel/smp.c               |   8 +-
 arch/ia64/kernel/smpboot.c           |   2 +-
 arch/ia64/kernel/time.c              |   2 -
 arch/ia64/lib/io.c                   | 114 -------------
 arch/ia64/mm/discontig.c             |   3 +-
 arch/ia64/mm/tlb.c                   |   6 +-
 arch/ia64/pci/pci.c                  |  13 +-
 23 files changed, 67 insertions(+), 669 deletions(-)

diff --git a/arch/ia64/include/asm/hw_irq.h b/arch/ia64/include/asm/hw_irq.h
index 5dd3c6485c3a..12808111a767 100644
--- a/arch/ia64/include/asm/hw_irq.h
+++ b/arch/ia64/include/asm/hw_irq.h
@@ -137,25 +137,9 @@ static inline void irq_complete_move(unsigned int irq) {}
 
 static inline void ia64_native_resend_irq(unsigned int vector)
 {
-	platform_send_ipi(smp_processor_id(), vector, IA64_IPI_DM_INT, 0);
+	ia64_send_ipi(smp_processor_id(), vector, IA64_IPI_DM_INT, 0);
 }
 
-/*
- * Default implementations for the irq-descriptor API:
- */
-#ifndef CONFIG_IA64_GENERIC
-static inline ia64_vector __ia64_irq_to_vector(int irq)
-{
-	return irq_cfg[irq].vector;
-}
-
-static inline unsigned int
-__ia64_local_vector_to_irq (ia64_vector vec)
-{
-	return __this_cpu_read(vector_irq[vec]);
-}
-#endif
-
 /*
  * Next follows the irq descriptor interface.  On IA-64, each CPU supports 256 interrupt
  * vectors.  On smaller systems, there is a one-to-one correspondence between interrupt
@@ -170,7 +154,7 @@ __ia64_local_vector_to_irq (ia64_vector vec)
 static inline ia64_vector
 irq_to_vector (int irq)
 {
-	return platform_irq_to_vector(irq);
+	return irq_cfg[irq].vector;
 }
 
 /*
@@ -181,7 +165,7 @@ irq_to_vector (int irq)
 static inline unsigned int
 local_vector_to_irq (ia64_vector vec)
 {
-	return platform_local_vector_to_irq(vec);
+	return __this_cpu_read(vector_irq[vec]);
 }
 
 #endif /* _ASM_IA64_HW_IRQ_H */
diff --git a/arch/ia64/include/asm/io.h b/arch/ia64/include/asm/io.h
index a511d62d447a..edd5c262d360 100644
--- a/arch/ia64/include/asm/io.h
+++ b/arch/ia64/include/asm/io.h
@@ -129,25 +129,6 @@ __ia64_mk_io_addr (unsigned long port)
 	return (void *) (space->mmio_base | offset);
 }
 
-#define __ia64_inb	___ia64_inb
-#define __ia64_inw	___ia64_inw
-#define __ia64_inl	___ia64_inl
-#define __ia64_outb	___ia64_outb
-#define __ia64_outw	___ia64_outw
-#define __ia64_outl	___ia64_outl
-#define __ia64_readb	___ia64_readb
-#define __ia64_readw	___ia64_readw
-#define __ia64_readl	___ia64_readl
-#define __ia64_readq	___ia64_readq
-#define __ia64_readb_relaxed	___ia64_readb
-#define __ia64_readw_relaxed	___ia64_readw
-#define __ia64_readl_relaxed	___ia64_readl
-#define __ia64_readq_relaxed	___ia64_readq
-#define __ia64_writeb	___ia64_writeb
-#define __ia64_writew	___ia64_writew
-#define __ia64_writel	___ia64_writel
-#define __ia64_writeq	___ia64_writeq
-
 /*
  * For the in/out routines, we need to do "mf.a" _after_ doing the I/O access to ensure
  * that the access has completed before executing other I/O accesses.  Since we're doing
@@ -156,8 +137,8 @@ __ia64_mk_io_addr (unsigned long port)
  * during optimization, which is why we use "volatile" pointers.
  */
 
-static inline unsigned int
-___ia64_inb (unsigned long port)
+#define inb inb
+static inline unsigned int inb(unsigned long port)
 {
 	volatile unsigned char *addr = __ia64_mk_io_addr(port);
 	unsigned char ret;
@@ -167,8 +148,8 @@ ___ia64_inb (unsigned long port)
 	return ret;
 }
 
-static inline unsigned int
-___ia64_inw (unsigned long port)
+#define inw inw
+static inline unsigned int inw(unsigned long port)
 {
 	volatile unsigned short *addr = __ia64_mk_io_addr(port);
 	unsigned short ret;
@@ -178,8 +159,8 @@ ___ia64_inw (unsigned long port)
 	return ret;
 }
 
-static inline unsigned int
-___ia64_inl (unsigned long port)
+#define inl inl
+static inline unsigned int inl(unsigned long port)
 {
 	volatile unsigned int *addr = __ia64_mk_io_addr(port);
 	unsigned int ret;
@@ -189,8 +170,8 @@ ___ia64_inl (unsigned long port)
 	return ret;
 }
 
-static inline void
-___ia64_outb (unsigned char val, unsigned long port)
+#define outb outb
+static inline void outb(unsigned char val, unsigned long port)
 {
 	volatile unsigned char *addr = __ia64_mk_io_addr(port);
 
@@ -198,8 +179,8 @@ ___ia64_outb (unsigned char val, unsigned long port)
 	__ia64_mf_a();
 }
 
-static inline void
-___ia64_outw (unsigned short val, unsigned long port)
+#define outw outw
+static inline void outw(unsigned short val, unsigned long port)
 {
 	volatile unsigned short *addr = __ia64_mk_io_addr(port);
 
@@ -207,8 +188,8 @@ ___ia64_outw (unsigned short val, unsigned long port)
 	__ia64_mf_a();
 }
 
-static inline void
-___ia64_outl (unsigned int val, unsigned long port)
+#define outl outl
+static inline void outl(unsigned int val, unsigned long port)
 {
 	volatile unsigned int *addr = __ia64_mk_io_addr(port);
 
@@ -216,199 +197,63 @@ ___ia64_outl (unsigned int val, unsigned long port)
 	__ia64_mf_a();
 }
 
-static inline void
-__insb (unsigned long port, void *dst, unsigned long count)
+#define insb insb
+static inline void insb(unsigned long port, void *dst, unsigned long count)
 {
 	unsigned char *dp = dst;
 
 	while (count--)
-		*dp++ = platform_inb(port);
+		*dp++ = inb(port);
 }
 
-static inline void
-__insw (unsigned long port, void *dst, unsigned long count)
+#define insw insw
+static inline void insw(unsigned long port, void *dst, unsigned long count)
 {
 	unsigned short *dp = dst;
 
 	while (count--)
-		put_unaligned(platform_inw(port), dp++);
+		put_unaligned(inw(port), dp++);
 }
 
-static inline void
-__insl (unsigned long port, void *dst, unsigned long count)
+#define insl insl
+static inline void insl(unsigned long port, void *dst, unsigned long count)
 {
 	unsigned int *dp = dst;
 
 	while (count--)
-		put_unaligned(platform_inl(port), dp++);
+		put_unaligned(inl(port), dp++);
 }
 
-static inline void
-__outsb (unsigned long port, const void *src, unsigned long count)
+#define outsb outsb
+static inline void outsb(unsigned long port, const void *src,
+		unsigned long count)
 {
 	const unsigned char *sp = src;
 
 	while (count--)
-		platform_outb(*sp++, port);
+		outb(*sp++, port);
 }
 
-static inline void
-__outsw (unsigned long port, const void *src, unsigned long count)
+#define outsw outsw
+static inline void outsw(unsigned long port, const void *src,
+		unsigned long count)
 {
 	const unsigned short *sp = src;
 
 	while (count--)
-		platform_outw(get_unaligned(sp++), port);
+		outw(get_unaligned(sp++), port);
 }
 
-static inline void
-__outsl (unsigned long port, const void *src, unsigned long count)
+#define outsl outsl
+static inline void outsl(unsigned long port, const void *src,
+		unsigned long count)
 {
 	const unsigned int *sp = src;
 
 	while (count--)
-		platform_outl(get_unaligned(sp++), port);
+		outl(get_unaligned(sp++), port);
 }
 
-/*
- * Unfortunately, some platforms are broken and do not follow the IA-64 architecture
- * specification regarding legacy I/O support.  Thus, we have to make these operations
- * platform dependent...
- */
-#define __inb		platform_inb
-#define __inw		platform_inw
-#define __inl		platform_inl
-#define __outb		platform_outb
-#define __outw		platform_outw
-#define __outl		platform_outl
-
-#define inb(p)		__inb(p)
-#define inw(p)		__inw(p)
-#define inl(p)		__inl(p)
-#define insb(p,d,c)	__insb(p,d,c)
-#define insw(p,d,c)	__insw(p,d,c)
-#define insl(p,d,c)	__insl(p,d,c)
-#define outb(v,p)	__outb(v,p)
-#define outw(v,p)	__outw(v,p)
-#define outl(v,p)	__outl(v,p)
-#define outsb(p,s,c)	__outsb(p,s,c)
-#define outsw(p,s,c)	__outsw(p,s,c)
-#define outsl(p,s,c)	__outsl(p,s,c)
-
-/*
- * The address passed to these functions are ioremap()ped already.
- *
- * We need these to be machine vectors since some platforms don't provide
- * DMA coherence via PIO reads (PCI drivers and the spec imply that this is
- * a good idea).  Writes are ok though for all existing ia64 platforms (and
- * hopefully it'll stay that way).
- */
-static inline unsigned char
-___ia64_readb (const volatile void __iomem *addr)
-{
-	return *(volatile unsigned char __force *)addr;
-}
-
-static inline unsigned short
-___ia64_readw (const volatile void __iomem *addr)
-{
-	return *(volatile unsigned short __force *)addr;
-}
-
-static inline unsigned int
-___ia64_readl (const volatile void __iomem *addr)
-{
-	return *(volatile unsigned int __force *) addr;
-}
-
-static inline unsigned long
-___ia64_readq (const volatile void __iomem *addr)
-{
-	return *(volatile unsigned long __force *) addr;
-}
-
-static inline void
-__writeb (unsigned char val, volatile void __iomem *addr)
-{
-	*(volatile unsigned char __force *) addr = val;
-}
-
-static inline void
-__writew (unsigned short val, volatile void __iomem *addr)
-{
-	*(volatile unsigned short __force *) addr = val;
-}
-
-static inline void
-__writel (unsigned int val, volatile void __iomem *addr)
-{
-	*(volatile unsigned int __force *) addr = val;
-}
-
-static inline void
-__writeq (unsigned long val, volatile void __iomem *addr)
-{
-	*(volatile unsigned long __force *) addr = val;
-}
-
-#define __readb		platform_readb
-#define __readw		platform_readw
-#define __readl		platform_readl
-#define __readq		platform_readq
-#define __readb_relaxed	platform_readb_relaxed
-#define __readw_relaxed	platform_readw_relaxed
-#define __readl_relaxed	platform_readl_relaxed
-#define __readq_relaxed	platform_readq_relaxed
-
-#define readb(a)	__readb((a))
-#define readw(a)	__readw((a))
-#define readl(a)	__readl((a))
-#define readq(a)	__readq((a))
-#define readb_relaxed(a)	__readb_relaxed((a))
-#define readw_relaxed(a)	__readw_relaxed((a))
-#define readl_relaxed(a)	__readl_relaxed((a))
-#define readq_relaxed(a)	__readq_relaxed((a))
-#define __raw_readb	readb
-#define __raw_readw	readw
-#define __raw_readl	readl
-#define __raw_readq	readq
-#define __raw_readb_relaxed	readb_relaxed
-#define __raw_readw_relaxed	readw_relaxed
-#define __raw_readl_relaxed	readl_relaxed
-#define __raw_readq_relaxed	readq_relaxed
-#define writeb(v,a)	__writeb((v), (a))
-#define writew(v,a)	__writew((v), (a))
-#define writel(v,a)	__writel((v), (a))
-#define writeq(v,a)	__writeq((v), (a))
-#define writeb_relaxed(v,a)	__writeb((v), (a))
-#define writew_relaxed(v,a)	__writew((v), (a))
-#define writel_relaxed(v,a)	__writel((v), (a))
-#define writeq_relaxed(v,a)	__writeq((v), (a))
-#define __raw_writeb	writeb
-#define __raw_writew	writew
-#define __raw_writel	writel
-#define __raw_writeq	writeq
-
-#ifndef inb_p
-# define inb_p		inb
-#endif
-#ifndef inw_p
-# define inw_p		inw
-#endif
-#ifndef inl_p
-# define inl_p		inl
-#endif
-
-#ifndef outb_p
-# define outb_p		outb
-#endif
-#ifndef outw_p
-# define outw_p		outw
-#endif
-#ifndef outl_p
-# define outl_p		outl
-#endif
-
 # ifdef __KERNEL__
 
 extern void __iomem * ioremap(unsigned long offset, unsigned long size);
diff --git a/arch/ia64/include/asm/machvec.h b/arch/ia64/include/asm/machvec.h
index d657f59d4fb3..f426a9829595 100644
--- a/arch/ia64/include/asm/machvec.h
+++ b/arch/ia64/include/asm/machvec.h
@@ -13,83 +13,19 @@
 
 #include <linux/types.h>
 
-/* forward declarations: */
 struct device;
-struct pt_regs;
-struct scatterlist;
-struct page;
-struct mm_struct;
-struct pci_bus;
-struct task_struct;
-struct pci_dev;
-struct msi_desc;
 
 typedef void ia64_mv_setup_t (char **);
-typedef void ia64_mv_cpu_init_t (void);
 typedef void ia64_mv_irq_init_t (void);
-typedef void ia64_mv_send_ipi_t (int, int, int, int);
-typedef void ia64_mv_timer_interrupt_t (int, void *);
-typedef void ia64_mv_global_tlb_purge_t (struct mm_struct *, unsigned long, unsigned long, unsigned long);
-typedef u8 ia64_mv_irq_to_vector (int);
-typedef unsigned int ia64_mv_local_vector_to_irq (u8);
-typedef char *ia64_mv_pci_get_legacy_mem_t (struct pci_bus *);
-typedef int ia64_mv_pci_legacy_read_t (struct pci_bus *, u16 port, u32 *val,
-				       u8 size);
-typedef int ia64_mv_pci_legacy_write_t (struct pci_bus *, u16 port, u32 val,
-					u8 size);
-typedef void ia64_mv_migrate_t(struct task_struct * task);
-typedef void ia64_mv_pci_fixup_bus_t (struct pci_bus *);
-typedef void ia64_mv_kernel_launch_event_t(void);
-
-/* DMA-mapping interface: */
 typedef void ia64_mv_dma_init (void);
 typedef const struct dma_map_ops *ia64_mv_dma_get_ops(struct device *);
 
-/*
- * WARNING: The legacy I/O space is _architected_.  Platforms are
- * expected to follow this architected model (see Section 10.7 in the
- * IA-64 Architecture Software Developer's Manual).  Unfortunately,
- * some broken machines do not follow that model, which is why we have
- * to make the inX/outX operations part of the machine vector.
- * Platform designers should follow the architected model whenever
- * possible.
- */
-typedef unsigned int ia64_mv_inb_t (unsigned long);
-typedef unsigned int ia64_mv_inw_t (unsigned long);
-typedef unsigned int ia64_mv_inl_t (unsigned long);
-typedef void ia64_mv_outb_t (unsigned char, unsigned long);
-typedef void ia64_mv_outw_t (unsigned short, unsigned long);
-typedef void ia64_mv_outl_t (unsigned int, unsigned long);
-typedef void ia64_mv_mmiowb_t (void);
-typedef unsigned char ia64_mv_readb_t (const volatile void __iomem *);
-typedef unsigned short ia64_mv_readw_t (const volatile void __iomem *);
-typedef unsigned int ia64_mv_readl_t (const volatile void __iomem *);
-typedef unsigned long ia64_mv_readq_t (const volatile void __iomem *);
-typedef unsigned char ia64_mv_readb_relaxed_t (const volatile void __iomem *);
-typedef unsigned short ia64_mv_readw_relaxed_t (const volatile void __iomem *);
-typedef unsigned int ia64_mv_readl_relaxed_t (const volatile void __iomem *);
-typedef unsigned long ia64_mv_readq_relaxed_t (const volatile void __iomem *);
-
-typedef int ia64_mv_setup_msi_irq_t (struct pci_dev *pdev, struct msi_desc *);
-typedef void ia64_mv_teardown_msi_irq_t (unsigned int irq);
-
 static inline void
 machvec_noop (void)
 {
 }
 
-static inline void
-machvec_noop_task (struct task_struct *task)
-{
-}
-
-static inline void
-machvec_noop_bus (struct pci_bus *bus)
-{
-}
-
 extern void machvec_setup (char **);
-extern void machvec_timer_interrupt (int, void *);
 
 # if defined (CONFIG_IA64_HP_SIM)
 #  include <asm/machvec_hpsim.h>
@@ -110,38 +46,9 @@ extern void machvec_timer_interrupt (int, void *);
 # else
 #  define ia64_platform_name	ia64_mv.name
 #  define platform_setup	ia64_mv.setup
-#  define platform_cpu_init	ia64_mv.cpu_init
 #  define platform_irq_init	ia64_mv.irq_init
-#  define platform_send_ipi	ia64_mv.send_ipi
-#  define platform_timer_interrupt	ia64_mv.timer_interrupt
-#  define platform_global_tlb_purge	ia64_mv.global_tlb_purge
 #  define platform_dma_init		ia64_mv.dma_init
 #  define platform_dma_get_ops		ia64_mv.dma_get_ops
-#  define platform_irq_to_vector	ia64_mv.irq_to_vector
-#  define platform_local_vector_to_irq	ia64_mv.local_vector_to_irq
-#  define platform_pci_get_legacy_mem	ia64_mv.pci_get_legacy_mem
-#  define platform_pci_legacy_read	ia64_mv.pci_legacy_read
-#  define platform_pci_legacy_write	ia64_mv.pci_legacy_write
-#  define platform_inb		ia64_mv.inb
-#  define platform_inw		ia64_mv.inw
-#  define platform_inl		ia64_mv.inl
-#  define platform_outb		ia64_mv.outb
-#  define platform_outw		ia64_mv.outw
-#  define platform_outl		ia64_mv.outl
-#  define platform_mmiowb	ia64_mv.mmiowb
-#  define platform_readb        ia64_mv.readb
-#  define platform_readw        ia64_mv.readw
-#  define platform_readl        ia64_mv.readl
-#  define platform_readq        ia64_mv.readq
-#  define platform_readb_relaxed        ia64_mv.readb_relaxed
-#  define platform_readw_relaxed        ia64_mv.readw_relaxed
-#  define platform_readl_relaxed        ia64_mv.readl_relaxed
-#  define platform_readq_relaxed        ia64_mv.readq_relaxed
-#  define platform_migrate		ia64_mv.migrate
-#  define platform_setup_msi_irq	ia64_mv.setup_msi_irq
-#  define platform_teardown_msi_irq	ia64_mv.teardown_msi_irq
-#  define platform_pci_fixup_bus	ia64_mv.pci_fixup_bus
-#  define platform_kernel_launch_event	ia64_mv.kernel_launch_event
 # endif
 
 /* __attribute__((__aligned__(16))) is required to make size of the
@@ -152,76 +59,18 @@ extern void machvec_timer_interrupt (int, void *);
 struct ia64_machine_vector {
 	const char *name;
 	ia64_mv_setup_t *setup;
-	ia64_mv_cpu_init_t *cpu_init;
 	ia64_mv_irq_init_t *irq_init;
-	ia64_mv_send_ipi_t *send_ipi;
-	ia64_mv_timer_interrupt_t *timer_interrupt;
-	ia64_mv_global_tlb_purge_t *global_tlb_purge;
 	ia64_mv_dma_init *dma_init;
 	ia64_mv_dma_get_ops *dma_get_ops;
-	ia64_mv_irq_to_vector *irq_to_vector;
-	ia64_mv_local_vector_to_irq *local_vector_to_irq;
-	ia64_mv_pci_get_legacy_mem_t *pci_get_legacy_mem;
-	ia64_mv_pci_legacy_read_t *pci_legacy_read;
-	ia64_mv_pci_legacy_write_t *pci_legacy_write;
-	ia64_mv_inb_t *inb;
-	ia64_mv_inw_t *inw;
-	ia64_mv_inl_t *inl;
-	ia64_mv_outb_t *outb;
-	ia64_mv_outw_t *outw;
-	ia64_mv_outl_t *outl;
-	ia64_mv_mmiowb_t *mmiowb;
-	ia64_mv_readb_t *readb;
-	ia64_mv_readw_t *readw;
-	ia64_mv_readl_t *readl;
-	ia64_mv_readq_t *readq;
-	ia64_mv_readb_relaxed_t *readb_relaxed;
-	ia64_mv_readw_relaxed_t *readw_relaxed;
-	ia64_mv_readl_relaxed_t *readl_relaxed;
-	ia64_mv_readq_relaxed_t *readq_relaxed;
-	ia64_mv_migrate_t *migrate;
-	ia64_mv_setup_msi_irq_t *setup_msi_irq;
-	ia64_mv_teardown_msi_irq_t *teardown_msi_irq;
-	ia64_mv_pci_fixup_bus_t *pci_fixup_bus;
-	ia64_mv_kernel_launch_event_t *kernel_launch_event;
 } __attribute__((__aligned__(16))); /* align attrib? see above comment */
 
 #define MACHVEC_INIT(name)			\
 {						\
 	#name,					\
 	platform_setup,				\
-	platform_cpu_init,			\
 	platform_irq_init,			\
-	platform_send_ipi,			\
-	platform_timer_interrupt,		\
-	platform_global_tlb_purge,		\
 	platform_dma_init,			\
 	platform_dma_get_ops,			\
-	platform_irq_to_vector,			\
-	platform_local_vector_to_irq,		\
-	platform_pci_get_legacy_mem,		\
-	platform_pci_legacy_read,		\
-	platform_pci_legacy_write,		\
-	platform_inb,				\
-	platform_inw,				\
-	platform_inl,				\
-	platform_outb,				\
-	platform_outw,				\
-	platform_outl,				\
-	platform_mmiowb,			\
-	platform_readb,				\
-	platform_readw,				\
-	platform_readl,				\
-	platform_readq,				\
-	platform_readb_relaxed,			\
-	platform_readw_relaxed,			\
-	platform_readl_relaxed,			\
-	platform_readq_relaxed,			\
-	platform_migrate,			\
-	platform_setup_msi_irq,			\
-	platform_teardown_msi_irq,		\
-	platform_pci_fixup_bus,			\
-	platform_kernel_launch_event            \
 }
 
 extern struct ia64_machine_vector ia64_mv;
@@ -242,104 +91,14 @@ extern const struct dma_map_ops *dma_get_ops(struct device *);
 #ifndef platform_setup
 # define platform_setup			machvec_setup
 #endif
-#ifndef platform_cpu_init
-# define platform_cpu_init		machvec_noop
-#endif
 #ifndef platform_irq_init
 # define platform_irq_init		machvec_noop
 #endif
-
-#ifndef platform_send_ipi
-# define platform_send_ipi		ia64_send_ipi	/* default to architected version */
-#endif
-#ifndef platform_timer_interrupt
-# define platform_timer_interrupt 	machvec_timer_interrupt
-#endif
-#ifndef platform_global_tlb_purge
-# define platform_global_tlb_purge	ia64_global_tlb_purge /* default to architected version */
-#endif
-#ifndef platform_kernel_launch_event
-# define platform_kernel_launch_event	machvec_noop
-#endif
 #ifndef platform_dma_init
 # define platform_dma_init		swiotlb_dma_init
 #endif
 #ifndef platform_dma_get_ops
 # define platform_dma_get_ops		dma_get_ops
 #endif
-#ifndef platform_irq_to_vector
-# define platform_irq_to_vector		__ia64_irq_to_vector
-#endif
-#ifndef platform_local_vector_to_irq
-# define platform_local_vector_to_irq	__ia64_local_vector_to_irq
-#endif
-#ifndef platform_pci_get_legacy_mem
-# define platform_pci_get_legacy_mem	ia64_pci_get_legacy_mem
-#endif
-#ifndef platform_pci_legacy_read
-# define platform_pci_legacy_read	ia64_pci_legacy_read
-extern int ia64_pci_legacy_read(struct pci_bus *bus, u16 port, u32 *val, u8 size);
-#endif
-#ifndef platform_pci_legacy_write
-# define platform_pci_legacy_write	ia64_pci_legacy_write
-extern int ia64_pci_legacy_write(struct pci_bus *bus, u16 port, u32 val, u8 size);
-#endif
-#ifndef platform_inb
-# define platform_inb		__ia64_inb
-#endif
-#ifndef platform_inw
-# define platform_inw		__ia64_inw
-#endif
-#ifndef platform_inl
-# define platform_inl		__ia64_inl
-#endif
-#ifndef platform_outb
-# define platform_outb		__ia64_outb
-#endif
-#ifndef platform_outw
-# define platform_outw		__ia64_outw
-#endif
-#ifndef platform_outl
-# define platform_outl		__ia64_outl
-#endif
-#ifndef platform_mmiowb
-# define platform_mmiowb	__ia64_mmiowb
-#endif
-#ifndef platform_readb
-# define platform_readb		__ia64_readb
-#endif
-#ifndef platform_readw
-# define platform_readw		__ia64_readw
-#endif
-#ifndef platform_readl
-# define platform_readl		__ia64_readl
-#endif
-#ifndef platform_readq
-# define platform_readq		__ia64_readq
-#endif
-#ifndef platform_readb_relaxed
-# define platform_readb_relaxed	__ia64_readb_relaxed
-#endif
-#ifndef platform_readw_relaxed
-# define platform_readw_relaxed	__ia64_readw_relaxed
-#endif
-#ifndef platform_readl_relaxed
-# define platform_readl_relaxed	__ia64_readl_relaxed
-#endif
-#ifndef platform_readq_relaxed
-# define platform_readq_relaxed	__ia64_readq_relaxed
-#endif
-#ifndef platform_migrate
-# define platform_migrate machvec_noop_task
-#endif
-#ifndef platform_setup_msi_irq
-# define platform_setup_msi_irq		((ia64_mv_setup_msi_irq_t*)NULL)
-#endif
-#ifndef platform_teardown_msi_irq
-# define platform_teardown_msi_irq	((ia64_mv_teardown_msi_irq_t*)NULL)
-#endif
-#ifndef platform_pci_fixup_bus
-# define platform_pci_fixup_bus	machvec_noop_bus
-#endif
 
 #endif /* _ASM_IA64_MACHVEC_H */
diff --git a/arch/ia64/include/asm/machvec_init.h b/arch/ia64/include/asm/machvec_init.h
index 2aafb69a3787..7a82e3ea0aff 100644
--- a/arch/ia64/include/asm/machvec_init.h
+++ b/arch/ia64/include/asm/machvec_init.h
@@ -2,30 +2,6 @@
 #include <asm/iommu.h>
 #include <asm/machvec.h>
 
-extern ia64_mv_send_ipi_t ia64_send_ipi;
-extern ia64_mv_global_tlb_purge_t ia64_global_tlb_purge;
-extern ia64_mv_irq_to_vector __ia64_irq_to_vector;
-extern ia64_mv_local_vector_to_irq __ia64_local_vector_to_irq;
-extern ia64_mv_pci_get_legacy_mem_t ia64_pci_get_legacy_mem;
-extern ia64_mv_pci_legacy_read_t ia64_pci_legacy_read;
-extern ia64_mv_pci_legacy_write_t ia64_pci_legacy_write;
-
-extern ia64_mv_inb_t __ia64_inb;
-extern ia64_mv_inw_t __ia64_inw;
-extern ia64_mv_inl_t __ia64_inl;
-extern ia64_mv_outb_t __ia64_outb;
-extern ia64_mv_outw_t __ia64_outw;
-extern ia64_mv_outl_t __ia64_outl;
-extern ia64_mv_mmiowb_t __ia64_mmiowb;
-extern ia64_mv_readb_t __ia64_readb;
-extern ia64_mv_readw_t __ia64_readw;
-extern ia64_mv_readl_t __ia64_readl;
-extern ia64_mv_readq_t __ia64_readq;
-extern ia64_mv_readb_t __ia64_readb_relaxed;
-extern ia64_mv_readw_t __ia64_readw_relaxed;
-extern ia64_mv_readl_t __ia64_readl_relaxed;
-extern ia64_mv_readq_t __ia64_readq_relaxed;
-
 #define MACHVEC_HELPER(name)									\
  struct ia64_machine_vector machvec_##name __attribute__ ((unused, __section__ (".machvec")))	\
 	= MACHVEC_INIT(name);
diff --git a/arch/ia64/include/asm/mmiowb.h b/arch/ia64/include/asm/mmiowb.h
index 297b85ac84a0..d67aab4ea3b4 100644
--- a/arch/ia64/include/asm/mmiowb.h
+++ b/arch/ia64/include/asm/mmiowb.h
@@ -3,22 +3,14 @@
 #ifndef _ASM_IA64_MMIOWB_H
 #define _ASM_IA64_MMIOWB_H
 
-#include <asm/machvec.h>
-
 /**
- * ___ia64_mmiowb - I/O write barrier
+ * mmiowb - I/O write barrier
  *
  * Ensure ordering of I/O space writes.  This will make sure that writes
  * following the barrier will arrive after all previous writes.  For most
  * ia64 platforms, this is a simple 'mf.a' instruction.
  */
-static inline void ___ia64_mmiowb(void)
-{
-	ia64_mfa();
-}
-
-#define __ia64_mmiowb	___ia64_mmiowb
-#define mmiowb()	platform_mmiowb()
+#define mmiowb()	ia64_mfa()
 
 #include <asm-generic/mmiowb.h>
 
diff --git a/arch/ia64/include/asm/pci.h b/arch/ia64/include/asm/pci.h
index 780e8744ba85..ef91b780a3f2 100644
--- a/arch/ia64/include/asm/pci.h
+++ b/arch/ia64/include/asm/pci.h
@@ -39,9 +39,9 @@ extern int pci_mmap_legacy_page_range(struct pci_bus *bus,
 				      struct vm_area_struct *vma,
 				      enum pci_mmap_state mmap_state);
 
-#define pci_get_legacy_mem platform_pci_get_legacy_mem
-#define pci_legacy_read platform_pci_legacy_read
-#define pci_legacy_write platform_pci_legacy_write
+char *pci_get_legacy_mem(struct pci_bus *bus);
+int pci_legacy_read(struct pci_bus *bus, u16 port, u32 *val, u8 size);
+int pci_legacy_write(struct pci_bus *bus, u16 port, u32 val, u8 size);
 
 struct pci_controller {
 	struct acpi_device *companion;
diff --git a/arch/ia64/include/asm/switch_to.h b/arch/ia64/include/asm/switch_to.h
index b10f31ec522c..9011e90a6b97 100644
--- a/arch/ia64/include/asm/switch_to.h
+++ b/arch/ia64/include/asm/switch_to.h
@@ -69,7 +69,6 @@ extern void ia64_load_extra (struct task_struct *task);
 	if (unlikely((current->thread.flags & IA64_THREAD_MIGRATION) &&	       \
 		     (task_cpu(current) !=				       \
 		      		      task_thread_info(current)->last_cpu))) { \
-		platform_migrate(current);				       \
 		task_thread_info(current)->last_cpu = task_cpu(current);       \
 	}								       \
 } while (0)
diff --git a/arch/ia64/kernel/iosapic.c b/arch/ia64/kernel/iosapic.c
index fe6e4946672e..9e49fd006859 100644
--- a/arch/ia64/kernel/iosapic.c
+++ b/arch/ia64/kernel/iosapic.c
@@ -67,10 +67,7 @@
  *     used as architecture-independent interrupt handling mechanism in Linux.
  *     As an IRQ is a number, we have to have
  *     IA-64 interrupt vector number <-> IRQ number mapping.  On smaller
- *     systems, we use one-to-one mapping between IA-64 vector and IRQ.  A
- *     platform can implement platform_irq_to_vector(irq) and
- *     platform_local_vector_to_irq(vector) APIs to differentiate the mapping.
- *     Please see also arch/ia64/include/asm/hw_irq.h for those APIs.
+ *     systems, we use one-to-one mapping between IA-64 vector and IRQ.
  *
  * To sum up, there are three levels of mappings involved:
  *
diff --git a/arch/ia64/kernel/irq.c b/arch/ia64/kernel/irq.c
index 6d17d26caf98..0a8e5e585edc 100644
--- a/arch/ia64/kernel/irq.c
+++ b/arch/ia64/kernel/irq.c
@@ -35,18 +35,6 @@ void ack_bad_irq(unsigned int irq)
 	printk(KERN_ERR "Unexpected irq vector 0x%x on CPU %u!\n", irq, smp_processor_id());
 }
 
-#ifdef CONFIG_IA64_GENERIC
-ia64_vector __ia64_irq_to_vector(int irq)
-{
-	return irq_cfg[irq].vector;
-}
-
-unsigned int __ia64_local_vector_to_irq (ia64_vector vec)
-{
-	return __this_cpu_read(vector_irq[vec]);
-}
-#endif
-
 /*
  * Interrupt statistics:
  */
diff --git a/arch/ia64/kernel/irq_ia64.c b/arch/ia64/kernel/irq_ia64.c
index ab87d6c25b15..1c81ec752b04 100644
--- a/arch/ia64/kernel/irq_ia64.c
+++ b/arch/ia64/kernel/irq_ia64.c
@@ -314,7 +314,7 @@ void irq_complete_move(unsigned irq)
 	cpumask_and(&cleanup_mask, &cfg->old_domain, cpu_online_mask);
 	cfg->move_cleanup_count = cpumask_weight(&cleanup_mask);
 	for_each_cpu(i, &cleanup_mask)
-		platform_send_ipi(i, IA64_IRQ_MOVE_VECTOR, IA64_IPI_DM_INT, 0);
+		ia64_send_ipi(i, IA64_IRQ_MOVE_VECTOR, IA64_IPI_DM_INT, 0);
 	cfg->move_in_progress = 0;
 }
 
diff --git a/arch/ia64/kernel/machine_kexec.c b/arch/ia64/kernel/machine_kexec.c
index 3b1dd5496d08..efc9b568401c 100644
--- a/arch/ia64/kernel/machine_kexec.c
+++ b/arch/ia64/kernel/machine_kexec.c
@@ -127,7 +127,6 @@ static void ia64_machine_kexec(struct unw_frame_info *info, void *arg)
 	ia64_srlz_d();
 	while (ia64_get_ivr() != IA64_SPURIOUS_INT_VECTOR)
 		ia64_eoi();
-	platform_kernel_launch_event();
 	rnk = (relocate_new_kernel_t)&code_addr;
 	(*rnk)(image->head, image->start, ia64_boot_param,
 		     GRANULEROUNDDOWN((unsigned long) pal_addr));
diff --git a/arch/ia64/kernel/machvec.c b/arch/ia64/kernel/machvec.c
index ebd82535f51b..3db3be7aaae5 100644
--- a/arch/ia64/kernel/machvec.c
+++ b/arch/ia64/kernel/machvec.c
@@ -11,7 +11,6 @@
 #include <asm/page.h>
 
 struct ia64_machine_vector ia64_mv = {
-	.mmiowb	= ___ia64_mmiowb
 };
 EXPORT_SYMBOL(ia64_mv);
 
@@ -69,9 +68,3 @@ machvec_setup (char **arg)
 {
 }
 EXPORT_SYMBOL(machvec_setup);
-
-void
-machvec_timer_interrupt (int irq, void *dev_id)
-{
-}
-EXPORT_SYMBOL(machvec_timer_interrupt);
diff --git a/arch/ia64/kernel/mca.c b/arch/ia64/kernel/mca.c
index 79190d877fa7..f72b05fe918b 100644
--- a/arch/ia64/kernel/mca.c
+++ b/arch/ia64/kernel/mca.c
@@ -744,7 +744,7 @@ ia64_mca_cmc_vector_enable_keventd(struct work_struct *unused)
 static void
 ia64_mca_wakeup(int cpu)
 {
-	platform_send_ipi(cpu, IA64_MCA_WAKEUP_VECTOR, IA64_IPI_DM_INT, 0);
+	ia64_send_ipi(cpu, IA64_MCA_WAKEUP_VECTOR, IA64_IPI_DM_INT, 0);
 }
 
 /*
@@ -1490,7 +1490,7 @@ ia64_mca_cmc_int_caller(int cmc_irq, void *arg)
 	cpuid = cpumask_next(cpuid+1, cpu_online_mask);
 
 	if (cpuid < nr_cpu_ids) {
-		platform_send_ipi(cpuid, IA64_CMCP_VECTOR, IA64_IPI_DM_INT, 0);
+		ia64_send_ipi(cpuid, IA64_CMCP_VECTOR, IA64_IPI_DM_INT, 0);
 	} else {
 		/* If no log record, switch out of polling mode */
 		if (start_count == IA64_LOG_COUNT(SAL_INFO_TYPE_CMC)) {
@@ -1523,7 +1523,7 @@ static void
 ia64_mca_cmc_poll (struct timer_list *unused)
 {
 	/* Trigger a CMC interrupt cascade  */
-	platform_send_ipi(cpumask_first(cpu_online_mask), IA64_CMCP_VECTOR,
+	ia64_send_ipi(cpumask_first(cpu_online_mask), IA64_CMCP_VECTOR,
 							IA64_IPI_DM_INT, 0);
 }
 
@@ -1560,7 +1560,7 @@ ia64_mca_cpe_int_caller(int cpe_irq, void *arg)
 	cpuid = cpumask_next(cpuid+1, cpu_online_mask);
 
 	if (cpuid < NR_CPUS) {
-		platform_send_ipi(cpuid, IA64_CPEP_VECTOR, IA64_IPI_DM_INT, 0);
+		ia64_send_ipi(cpuid, IA64_CPEP_VECTOR, IA64_IPI_DM_INT, 0);
 	} else {
 		/*
 		 * If a log was recorded, increase our polling frequency,
@@ -1600,7 +1600,7 @@ static void
 ia64_mca_cpe_poll (struct timer_list *unused)
 {
 	/* Trigger a CPE interrupt cascade  */
-	platform_send_ipi(cpumask_first(cpu_online_mask), IA64_CPEP_VECTOR,
+	ia64_send_ipi(cpumask_first(cpu_online_mask), IA64_CPEP_VECTOR,
 							IA64_IPI_DM_INT, 0);
 }
 
diff --git a/arch/ia64/kernel/msi_ia64.c b/arch/ia64/kernel/msi_ia64.c
index 519d9432f407..df5c28f252e3 100644
--- a/arch/ia64/kernel/msi_ia64.c
+++ b/arch/ia64/kernel/msi_ia64.c
@@ -43,7 +43,7 @@ static int ia64_set_msi_irq_affinity(struct irq_data *idata,
 }
 #endif /* CONFIG_SMP */
 
-int ia64_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
+int arch_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
 {
 	struct msi_msg	msg;
 	unsigned long	dest_phys_id;
@@ -77,7 +77,7 @@ int ia64_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
 	return 0;
 }
 
-void ia64_teardown_msi_irq(unsigned int irq)
+void arch_teardown_msi_irq(unsigned int irq)
 {
 	destroy_irq(irq);
 }
@@ -111,23 +111,6 @@ static struct irq_chip ia64_msi_chip = {
 	.irq_retrigger		= ia64_msi_retrigger_irq,
 };
 
-
-int arch_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
-{
-	if (platform_setup_msi_irq)
-		return platform_setup_msi_irq(pdev, desc);
-
-	return ia64_setup_msi_irq(pdev, desc);
-}
-
-void arch_teardown_msi_irq(unsigned int irq)
-{
-	if (platform_teardown_msi_irq)
-		return platform_teardown_msi_irq(irq);
-
-	return ia64_teardown_msi_irq(irq);
-}
-
 #ifdef CONFIG_INTEL_IOMMU
 #ifdef CONFIG_SMP
 static int dmar_msi_set_affinity(struct irq_data *data,
diff --git a/arch/ia64/kernel/sal.c b/arch/ia64/kernel/sal.c
index 17085a8078fe..c455ece977ad 100644
--- a/arch/ia64/kernel/sal.c
+++ b/arch/ia64/kernel/sal.c
@@ -249,7 +249,7 @@ check_sal_cache_flush (void)
 	 * Send ourselves a timer interrupt, wait until it's reported, and see
 	 * if SAL_CACHE_FLUSH drops it.
 	 */
-	platform_send_ipi(cpu, IA64_TIMER_VECTOR, IA64_IPI_DM_INT, 0);
+	ia64_send_ipi(cpu, IA64_TIMER_VECTOR, IA64_IPI_DM_INT, 0);
 
 	while (!ia64_get_irr(IA64_TIMER_VECTOR))
 		cpu_relax();
diff --git a/arch/ia64/kernel/setup.c b/arch/ia64/kernel/setup.c
index 78d0d22dd17e..4dc74500eac5 100644
--- a/arch/ia64/kernel/setup.c
+++ b/arch/ia64/kernel/setup.c
@@ -1039,7 +1039,6 @@ cpu_init (void)
 		ia64_patch_phys_stack_reg(num_phys_stacked*8 + 8);
 		max_num_phys_stacked = num_phys_stacked;
 	}
-	platform_cpu_init();
 }
 
 void __init
diff --git a/arch/ia64/kernel/smp.c b/arch/ia64/kernel/smp.c
index 133b63355814..4825b0b41d49 100644
--- a/arch/ia64/kernel/smp.c
+++ b/arch/ia64/kernel/smp.c
@@ -146,7 +146,7 @@ static inline void
 send_IPI_single (int dest_cpu, int op)
 {
 	set_bit(op, &per_cpu(ipi_operation, dest_cpu));
-	platform_send_ipi(dest_cpu, IA64_IPI_VECTOR, IA64_IPI_DM_INT, 0);
+	ia64_send_ipi(dest_cpu, IA64_IPI_VECTOR, IA64_IPI_DM_INT, 0);
 }
 
 /*
@@ -213,7 +213,7 @@ kdump_smp_send_init(void)
 	for_each_online_cpu(cpu) {
 		if (cpu != self_cpu) {
 			if(kdump_status[cpu] == 0)
-				platform_send_ipi(cpu, 0, IA64_IPI_DM_INIT, 0);
+				ia64_send_ipi(cpu, 0, IA64_IPI_DM_INIT, 0);
 		}
 	}
 }
@@ -224,7 +224,7 @@ kdump_smp_send_init(void)
 void
 smp_send_reschedule (int cpu)
 {
-	platform_send_ipi(cpu, IA64_IPI_RESCHEDULE, IA64_IPI_DM_INT, 0);
+	ia64_send_ipi(cpu, IA64_IPI_RESCHEDULE, IA64_IPI_DM_INT, 0);
 }
 EXPORT_SYMBOL_GPL(smp_send_reschedule);
 
@@ -234,7 +234,7 @@ EXPORT_SYMBOL_GPL(smp_send_reschedule);
 static void
 smp_send_local_flush_tlb (int cpu)
 {
-	platform_send_ipi(cpu, IA64_IPI_LOCAL_TLB_FLUSH, IA64_IPI_DM_INT, 0);
+	ia64_send_ipi(cpu, IA64_IPI_LOCAL_TLB_FLUSH, IA64_IPI_DM_INT, 0);
 }
 
 void
diff --git a/arch/ia64/kernel/smpboot.c b/arch/ia64/kernel/smpboot.c
index df56f739dd11..f7058659526c 100644
--- a/arch/ia64/kernel/smpboot.c
+++ b/arch/ia64/kernel/smpboot.c
@@ -467,7 +467,7 @@ do_boot_cpu (int sapicid, int cpu, struct task_struct *idle)
 	Dprintk("Sending wakeup vector %lu to AP 0x%x/0x%x.\n", ap_wakeup_vector, cpu, sapicid);
 
 	set_brendez_area(cpu);
-	platform_send_ipi(cpu, ap_wakeup_vector, IA64_IPI_DM_INT, 0);
+	ia64_send_ipi(cpu, ap_wakeup_vector, IA64_IPI_DM_INT, 0);
 
 	/*
 	 * Wait 10s total for the AP to start
diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 4ecd81b0e8ec..d9ad93a6d825 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -167,8 +167,6 @@ timer_interrupt (int irq, void *dev_id)
 		return IRQ_HANDLED;
 	}
 
-	platform_timer_interrupt(irq, dev_id);
-
 	new_itm = local_cpu_data->itm_next;
 
 	if (!time_after(ia64_get_itc(), new_itm))
diff --git a/arch/ia64/lib/io.c b/arch/ia64/lib/io.c
index d107eaf3790d..c3e02462ed16 100644
--- a/arch/ia64/lib/io.c
+++ b/arch/ia64/lib/io.c
@@ -49,117 +49,3 @@ void memset_io(volatile void __iomem *dst, int c, long count)
 	}
 }
 EXPORT_SYMBOL(memset_io);
-
-#ifdef CONFIG_IA64_GENERIC
-
-#undef __ia64_inb
-#undef __ia64_inw
-#undef __ia64_inl
-#undef __ia64_outb
-#undef __ia64_outw
-#undef __ia64_outl
-#undef __ia64_readb
-#undef __ia64_readw
-#undef __ia64_readl
-#undef __ia64_readq
-#undef __ia64_readb_relaxed
-#undef __ia64_readw_relaxed
-#undef __ia64_readl_relaxed
-#undef __ia64_readq_relaxed
-#undef __ia64_writeb
-#undef __ia64_writew
-#undef __ia64_writel
-#undef __ia64_writeq
-#undef __ia64_mmiowb
-
-unsigned int
-__ia64_inb (unsigned long port)
-{
-	return ___ia64_inb(port);
-}
-
-unsigned int
-__ia64_inw (unsigned long port)
-{
-	return ___ia64_inw(port);
-}
-
-unsigned int
-__ia64_inl (unsigned long port)
-{
-	return ___ia64_inl(port);
-}
-
-void
-__ia64_outb (unsigned char val, unsigned long port)
-{
-	___ia64_outb(val, port);
-}
-
-void
-__ia64_outw (unsigned short val, unsigned long port)
-{
-	___ia64_outw(val, port);
-}
-
-void
-__ia64_outl (unsigned int val, unsigned long port)
-{
-	___ia64_outl(val, port);
-}
-
-unsigned char
-__ia64_readb (void __iomem *addr)
-{
-	return ___ia64_readb (addr);
-}
-
-unsigned short
-__ia64_readw (void __iomem *addr)
-{
-	return ___ia64_readw (addr);
-}
-
-unsigned int
-__ia64_readl (void __iomem *addr)
-{
-	return ___ia64_readl (addr);
-}
-
-unsigned long
-__ia64_readq (void __iomem *addr)
-{
-	return ___ia64_readq (addr);
-}
-
-unsigned char
-__ia64_readb_relaxed (void __iomem *addr)
-{
-	return ___ia64_readb (addr);
-}
-
-unsigned short
-__ia64_readw_relaxed (void __iomem *addr)
-{
-	return ___ia64_readw (addr);
-}
-
-unsigned int
-__ia64_readl_relaxed (void __iomem *addr)
-{
-	return ___ia64_readl (addr);
-}
-
-unsigned long
-__ia64_readq_relaxed (void __iomem *addr)
-{
-	return ___ia64_readq (addr);
-}
-
-void
-__ia64_mmiowb(void)
-{
-	___ia64_mmiowb();
-}
-
-#endif /* CONFIG_IA64_GENERIC */
diff --git a/arch/ia64/mm/discontig.c b/arch/ia64/mm/discontig.c
index 05490dd073e6..921f3efe3538 100644
--- a/arch/ia64/mm/discontig.c
+++ b/arch/ia64/mm/discontig.c
@@ -396,8 +396,7 @@ static void __meminit scatter_node_data(void)
  *
  * Each node's per-node area has a copy of the global pg_data_t list, so
  * we copy that to each node here, as well as setting the per-cpu pointer
- * to the local node data structure.  The active_cpus field of the per-node
- * structure gets setup by the platform_cpu_init() function later.
+ * to the local node data structure.
  */
 static void __init initialize_pernode_data(void)
 {
diff --git a/arch/ia64/mm/tlb.c b/arch/ia64/mm/tlb.c
index 0714df1b7854..72cc568bc841 100644
--- a/arch/ia64/mm/tlb.c
+++ b/arch/ia64/mm/tlb.c
@@ -245,7 +245,8 @@ setup_ptcg_sem(int max_purges, int nptcg_from)
 	spinaphore_init(&ptcg_sem, max_purges);
 }
 
-void
+#ifdef CONFIG_SMP
+static void
 ia64_global_tlb_purge (struct mm_struct *mm, unsigned long start,
 		       unsigned long end, unsigned long nbits)
 {
@@ -282,6 +283,7 @@ ia64_global_tlb_purge (struct mm_struct *mm, unsigned long start,
                 activate_context(active_mm);
         }
 }
+#endif /* CONFIG_SMP */
 
 void
 local_flush_tlb_all (void)
@@ -332,7 +334,7 @@ __flush_tlb_range (struct vm_area_struct *vma, unsigned long start,
 	preempt_disable();
 #ifdef CONFIG_SMP
 	if (mm != current->active_mm || cpumask_weight(mm_cpumask(mm)) != 1) {
-		platform_global_tlb_purge(mm, start, end, nbits);
+		ia64_global_tlb_purge(mm, start, end, nbits);
 		preempt_enable();
 		return;
 	}
diff --git a/arch/ia64/pci/pci.c b/arch/ia64/pci/pci.c
index 165e561dc81a..89c9f36dc94d 100644
--- a/arch/ia64/pci/pci.c
+++ b/arch/ia64/pci/pci.c
@@ -372,7 +372,6 @@ void pcibios_fixup_bus(struct pci_bus *b)
 	}
 	list_for_each_entry(dev, &b->devices, bus_list)
 		pcibios_fixup_device_resources(dev);
-	platform_pci_fixup_bus(b);
 }
 
 void pcibios_add_bus(struct pci_bus *bus)
@@ -413,7 +412,7 @@ pcibios_disable_device (struct pci_dev *dev)
 }
 
 /**
- * ia64_pci_get_legacy_mem - generic legacy mem routine
+ * pci_get_legacy_mem - generic legacy mem routine
  * @bus: bus to get legacy memory base address for
  *
  * Find the base of legacy memory for @bus.  This is typically the first
@@ -424,7 +423,7 @@ pcibios_disable_device (struct pci_dev *dev)
  * This is the ia64 generic version of this routine.  Other platforms
  * are free to override it with a machine vector.
  */
-char *ia64_pci_get_legacy_mem(struct pci_bus *bus)
+char *pci_get_legacy_mem(struct pci_bus *bus)
 {
 	return (char *)__IA64_UNCACHED_OFFSET;
 }
@@ -473,7 +472,7 @@ pci_mmap_legacy_page_range(struct pci_bus *bus, struct vm_area_struct *vma,
 }
 
 /**
- * ia64_pci_legacy_read - read from legacy I/O space
+ * pci_legacy_read - read from legacy I/O space
  * @bus: bus to read
  * @port: legacy port value
  * @val: caller allocated storage for returned value
@@ -485,7 +484,7 @@ pci_mmap_legacy_page_range(struct pci_bus *bus, struct vm_area_struct *vma,
  * overridden by the platform.  This is necessary on platforms that don't
  * support legacy I/O routing or that hard fail on legacy I/O timeouts.
  */
-int ia64_pci_legacy_read(struct pci_bus *bus, u16 port, u32 *val, u8 size)
+int pci_legacy_read(struct pci_bus *bus, u16 port, u32 *val, u8 size)
 {
 	int ret = size;
 
@@ -508,7 +507,7 @@ int ia64_pci_legacy_read(struct pci_bus *bus, u16 port, u32 *val, u8 size)
 }
 
 /**
- * ia64_pci_legacy_write - perform a legacy I/O write
+ * pci_legacy_write - perform a legacy I/O write
  * @bus: bus pointer
  * @port: port to write
  * @val: value to write
@@ -516,7 +515,7 @@ int ia64_pci_legacy_read(struct pci_bus *bus, u16 port, u32 *val, u8 size)
  *
  * Simply writes @size bytes of @val to @port.
  */
-int ia64_pci_legacy_write(struct pci_bus *bus, u16 port, u32 val, u8 size)
+int pci_legacy_write(struct pci_bus *bus, u16 port, u32 val, u8 size)
 {
 	int ret = size;
 
-- 
2.20.1

