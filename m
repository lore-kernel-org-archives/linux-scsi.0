Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB3F5C7EE2A
	for <linux-scsi@archiver.kernel.org>; Tue, 23 May 2023 20:01:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238204AbjEWUBu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 May 2023 16:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjEWUBt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2023 16:01:49 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9DDD119;
        Tue, 23 May 2023 13:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1684872082; i=deller@gmx.de;
        bh=yqpllCHiTLnugUoMdGB3X/ydPYNUkdFiw89CyViJL04=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
        b=dYnylrGVmTSPoTCqsDJFQExY/MCSXytQNFiMUeicc7q3WvWukGN3R4taMuIAvIAhD
         PmsatRbOa0jzBMc76BUXo9ZwuHSbrUV4UnWySO7TWwexWJJ3U8p3vY7zL1UyppL7uJ
         2KNZOKVcQQnzJtIUufXOKQT+KHA410P8oeQy+8Kq+ZakO7xASFOvBeM5Yaj3v+2ZGr
         ZCfGPtCpjWhgAgfzXqEO+GbiigTj19nFlN5RV9J7z02PVrc48+hASJvfvDrMMJRk+g
         vwnV+sCAMbif0DgMCoa5OcuaywsGwUDo4c9pV0j3hksXulwUOdZZINOIBwYsO6WoPz
         8PmYV3at1ifYw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from p100 ([94.134.145.169]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Ml6m4-1qOofe1ffY-00lTjm; Tue, 23
 May 2023 22:01:22 +0200
Date:   Tue, 23 May 2023 22:01:20 +0200
From:   Helge Deller <deller@gmx.de>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Dinh Nguyen <dinguyen@kernel.org>
Cc:     Helge Deller <deller@gmx.de>, Bart Van Assche <bvanassche@acm.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        linux-aio@kvack.org, linux-parisc <linux-parisc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: spinlock recursion in aio_complete()
Message-ID: <ZG0bkNJ5jQC1a3pY@p100>
References: <5057d550-c3f4-be34-d3e6-390790051232@gmx.de>
 <89053bf1-6bc3-3778-7662-14d15bd778a3@acm.org>
 <8bd7faad-abf4-f7b3-03c9-e06f9b5d2148@gmx.de>
 <077b00a6-9587-2e28-3f8a-44871f9428ca@acm.org>
 <5e684a22-dcc1-095f-ac18-fd1b3bf81cd6@gmx.de>
 <4d786f73-8c6f-4fd1-cdd6-42f2d59d6120@gmx.de>
 <ZGyawdtBhNnvvTv3@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <ZGyawdtBhNnvvTv3@shell.armlinux.org.uk>
X-Provags-ID: V03:K1:ywkjnZ3/6o9kt5rcLRcIvc3tKtLjk/IwdQiHNFlPmVC8AEZQfGA
 7SoAp8s9HOv6dIX4PK8UIB3nt/Z22f49TLVCBUo9N1od6noyNK2PMU09jpedqe7u0pLPkzA
 bCH87dEbBQ9nRDEA6KLcMGX9B5sIdDNSGYIRLNc3L52gDOLUIfHr3naZYISoGszy0kv6OOG
 PO1h/iw2fK94037b1Q6Iw==
UI-OutboundReport: notjunk:1;M01:P0:ccYPoZ3TDBQ=;lh+F/zDt4kNv0e0htqc8ZL8392K
 MBXJNIsg+NcK/SJnrlEri8War3j0JUYgL62e2AbraZLbKyA2r4/wI1TXTOC/l2V2uYUZk8VtO
 gfRn+vjcHHOYri7H1cfEca/rp6eK+0bx98HO17LTSgJtB555kWZhgHeD4EzPqENYvBc+qXnpw
 czo4tAQg/I/2hizCLwz0T/UxQRz07SjNDE23mJzxSVX7sMmneKYd7IoGb4WJv6WhFrjxBbcS6
 Y0InxmS+t+G4IvxcrznU5G3X1zz9gg7hBlBfe6HLfa0K/y1n1n5+khXK8dZgSgIOBEVkDsZpS
 aXtCPgkfWTcRX2P9sXcGsbDW997/Ak5Cdvct2lj+isS5XxCvSLtx0YV4otyUzK8fNXJzcHzZD
 1gVI736/ji4+FDFPEsTn0tZDb/4vCaNh/WTzTPwBwzB5QUPEc9dRbmsaSJiNztm7utQpOPzu3
 7Xccl7LzMqMYuOw5hekx0tctpK00SV9a5geVvHW6bWR7K7LSqW8EIheDBiH/Kp9J8EoHBS4yg
 9OEdg0GSs6VdQrtyXeiemSg1eVtFkqgoiEuzUIz44JDp1SIyQ29mCTHxq6/izWSWsTKsVlvEs
 aw8uSoKdKRhzMxBUEEmVy1ou5eF3p0bOvlE8x2cumNNVFhAcjO1Sa9Rrq3/T6KFYpbFprhqrV
 xZp4jY8UKJCmWUWHFHbCgCns9lUXvRFIknfyTjEYjd2u4xKbViMm0Spt8k2RCziEV+bUHLK2z
 rN+fKMzYEIlv4xG9MCGiBOdspd83qSbfZTwnJiT1qr6YRrbPqlVbOstfXZK/dH4F4YQtWsbPh
 DvVJC0tBy/O6GPYD8zSUSiPTSsnQV7yQXliYM1EWrCx4b5HhI91ghjGOB2Mh8X6NRd8ZvDOW5
 cSNM6IjPZ7pEdEOqWq/HnDHB8uNz/YwYuX3LOQSC4S5cOj3a/UJq0mVUX82///GtkHKqkuQ0A
 BVMbRgApZsog9aNdMCoF7+ETm2U=
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

* Russell King (Oracle) <linux@armlinux.org.uk>:
> On Tue, May 23, 2023 at 12:24:04PM +0200, Helge Deller wrote:
> > On 5/22/23 23:22, Helge Deller wrote:
> > > > > It hangs in fs/aio.c:1128, function aio_complete(), in this call=
:
> > > > > =A0=A0=A0=A0=A0spin_lock_irqsave(&ctx->completion_lock, flags);
> > > >
> > > > All code that I found and that obtains ctx->completion_lock disabl=
es IRQs.
> > > > It is not clear to me how this spinlock can be locked recursively?=
 Is it
> > > > sure that the "spinlock recursion" report is correct?
> > >
> > > Yes, it seems correct.
> > > [...]
> >
> > Bart, thanks to your suggestions I was able to narrow down the problem=
!
> >
> > I got LOCKDEP working on parisc, which then reports:
> > 	raw_local_irq_restore() called with IRQs enabled
> > for the spin_unlock_irqrestore() in function aio_complete(), which sho=
uldn't happen.
> >
> > Finally, I found that parisc's flush_dcache_page() re-enables the IRQs
> > which leads to the spinlock hang in aio_complete().
> >
> > So, this is NOT a bug in aio or scsci, but we need fix in the the arch=
 code.
>
> You can find some of the background to this at:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git/commit/=
?id=3D16ceff2d5dc9f0347ab5a08abff3f4647c2fee04
>
> which introduced flush_dcache_mmap_lock(). It looks like Hugh had
> questions over whether this should be _irqsave() rather than _irq()
> but I guess at the time all callers had interrupts enabled, and
> it's only recently that someone came up with the idea of calling
> flush_dcache_page() with interrupts disabled.
>
> Adding another arg to flush_dcache_mmap_lock() to save the flags
> may be doable, but requires a patch that touches not only architectures
> that have a private implementation, but also various code in mm/.

I've tested the attached patch on parisc, and it solves the issue.
I've not compile-tested it on arm and nios2, both seem to be
the only other affected platforms.

Thoughts?

Helge


=46rom 25a96a4211975d46e6f4dac06e144d0fb9f5ed53 Mon Sep 17 00:00:00 2001
From: Helge Deller <deller@gmx.de>
Date: Tue, 23 May 2023 21:48:33 +0200
Subject: [PATCH] Fix flush_dcache_page() for usage in irq context

flush_dcache_page() can be called with IRQs disabled, e.g. from
aio_complete().

Fix flush_dcache_page() on the arm, parisc and nios2 architectures
to not unintentionally re-enable IRQs by using xa_lock_irqsave() instead
of xa_lock_irq() for the flush_dcache_mmap_*lock() functions.

Cc: Russell King (Oracle) <linux@armlinux.org.uk>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Helge Deller <deller@gmx.de>

diff --git a/arch/arm/include/asm/cacheflush.h b/arch/arm/include/asm/cach=
eflush.h
index a094f964c869..5b8a1ef0dc50 100644
=2D-- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -315,6 +315,10 @@ static inline void flush_anon_page(struct vm_area_str=
uct *vma,

 #define flush_dcache_mmap_lock(mapping)		xa_lock_irq(&mapping->i_pages)
 #define flush_dcache_mmap_unlock(mapping)	xa_unlock_irq(&mapping->i_pages=
)
+#define flush_dcache_mmap_lock_irqsave(mapping, flags)		\
+		xa_lock_irqsave(&mapping->i_pages, flags)
+#define flush_dcache_mmap_unlock_irqrestore(mapping, flags)	\
+		xa_unlock_irqrestore(&mapping->i_pages, flags)

 /*
  * We don't appear to need to do anything here.  In fact, if we did, we'd
diff --git a/arch/arm/mm/flush.c b/arch/arm/mm/flush.c
index 7ff9feea13a6..d57ec9165520 100644
=2D-- a/arch/arm/mm/flush.c
+++ b/arch/arm/mm/flush.c
@@ -238,6 +238,7 @@ static void __flush_dcache_aliases(struct address_spac=
e *mapping, struct page *p
 {
 	struct mm_struct *mm =3D current->active_mm;
 	struct vm_area_struct *mpnt;
+	unsigned long flags;
 	pgoff_t pgoff;

 	/*
@@ -248,7 +249,7 @@ static void __flush_dcache_aliases(struct address_spac=
e *mapping, struct page *p
 	 */
 	pgoff =3D page->index;

-	flush_dcache_mmap_lock(mapping);
+	flush_dcache_mmap_lock_irqsave(mapping, flags);
 	vma_interval_tree_foreach(mpnt, &mapping->i_mmap, pgoff, pgoff) {
 		unsigned long offset;

@@ -262,7 +263,7 @@ static void __flush_dcache_aliases(struct address_spac=
e *mapping, struct page *p
 		offset =3D (pgoff - mpnt->vm_pgoff) << PAGE_SHIFT;
 		flush_cache_page(mpnt, mpnt->vm_start + offset, page_to_pfn(page));
 	}
-	flush_dcache_mmap_unlock(mapping);
+	flush_dcache_mmap_unlock_irqrestore(mapping, flags);
 }

 #if __LINUX_ARM_ARCH__ >=3D 6
diff --git a/arch/nios2/include/asm/cacheflush.h b/arch/nios2/include/asm/=
cacheflush.h
index d0b71dd71287..a37242662809 100644
=2D-- a/arch/nios2/include/asm/cacheflush.h
+++ b/arch/nios2/include/asm/cacheflush.h
@@ -48,5 +48,9 @@ extern void invalidate_dcache_range(unsigned long start,=
 unsigned long end);

 #define flush_dcache_mmap_lock(mapping)		xa_lock_irq(&mapping->i_pages)
 #define flush_dcache_mmap_unlock(mapping)	xa_unlock_irq(&mapping->i_pages=
)
+#define flush_dcache_mmap_lock_irqsave(mapping, flags)		\
+		xa_lock_irqsave(&mapping->i_pages, flags)
+#define flush_dcache_mmap_unlock_irqrestore(mapping, flags)	\
+		xa_unlock_irqrestore(&mapping->i_pages, flags)

 #endif /* _ASM_NIOS2_CACHEFLUSH_H */
diff --git a/arch/nios2/mm/cacheflush.c b/arch/nios2/mm/cacheflush.c
index 6aa9257c3ede..35f3b599187f 100644
=2D-- a/arch/nios2/mm/cacheflush.c
+++ b/arch/nios2/mm/cacheflush.c
@@ -75,11 +75,12 @@ static void flush_aliases(struct address_space *mappin=
g, struct page *page)
 {
 	struct mm_struct *mm =3D current->active_mm;
 	struct vm_area_struct *mpnt;
+	unsigned long flags;
 	pgoff_t pgoff;

 	pgoff =3D page->index;

-	flush_dcache_mmap_lock(mapping);
+	flush_dcache_mmap_lock_irqsave(mapping, flags);
 	vma_interval_tree_foreach(mpnt, &mapping->i_mmap, pgoff, pgoff) {
 		unsigned long offset;

@@ -92,7 +93,7 @@ static void flush_aliases(struct address_space *mapping,=
 struct page *page)
 		flush_cache_page(mpnt, mpnt->vm_start + offset,
 			page_to_pfn(page));
 	}
-	flush_dcache_mmap_unlock(mapping);
+	flush_dcache_mmap_unlock_irqrestore(mapping, flags);
 }

 void flush_cache_all(void)
diff --git a/arch/parisc/include/asm/cacheflush.h b/arch/parisc/include/as=
m/cacheflush.h
index 0bdee6724132..c8b6928cee1e 100644
=2D-- a/arch/parisc/include/asm/cacheflush.h
+++ b/arch/parisc/include/asm/cacheflush.h
@@ -48,6 +48,10 @@ void flush_dcache_page(struct page *page);

 #define flush_dcache_mmap_lock(mapping)		xa_lock_irq(&mapping->i_pages)
 #define flush_dcache_mmap_unlock(mapping)	xa_unlock_irq(&mapping->i_pages=
)
+#define flush_dcache_mmap_lock_irqsave(mapping, flags)		\
+		xa_lock_irqsave(&mapping->i_pages, flags)
+#define flush_dcache_mmap_unlock_irqrestore(mapping, flags)	\
+		xa_unlock_irqrestore(&mapping->i_pages, flags)

 #define flush_icache_page(vma,page)	do { 		\
 	flush_kernel_dcache_page_addr(page_address(page)); \
diff --git a/arch/parisc/kernel/cache.c b/arch/parisc/kernel/cache.c
index 1d3b8bc8a623..ca4a302d4365 100644
=2D-- a/arch/parisc/kernel/cache.c
+++ b/arch/parisc/kernel/cache.c
@@ -399,6 +399,7 @@ void flush_dcache_page(struct page *page)
 	unsigned long offset;
 	unsigned long addr, old_addr =3D 0;
 	unsigned long count =3D 0;
+	unsigned long flags;
 	pgoff_t pgoff;

 	if (mapping && !mapping_mapped(mapping)) {
@@ -420,7 +421,7 @@ void flush_dcache_page(struct page *page)
 	 * to flush one address here for them all to become coherent
 	 * on machines that support equivalent aliasing
 	 */
-	flush_dcache_mmap_lock(mapping);
+	flush_dcache_mmap_lock_irqsave(mapping, flags);
 	vma_interval_tree_foreach(mpnt, &mapping->i_mmap, pgoff, pgoff) {
 		offset =3D (pgoff - mpnt->vm_pgoff) << PAGE_SHIFT;
 		addr =3D mpnt->vm_start + offset;
@@ -460,7 +461,7 @@ void flush_dcache_page(struct page *page)
 		}
 		WARN_ON(++count =3D=3D 4096);
 	}
-	flush_dcache_mmap_unlock(mapping);
+	flush_dcache_mmap_unlock_irqrestore(mapping, flags);
 }
 EXPORT_SYMBOL(flush_dcache_page);

