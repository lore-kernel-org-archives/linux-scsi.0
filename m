From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 1/2] DMA buffer alignment annotations
Date: Fri, 21 Dec 2007 13:30:07 +1100
Message-ID: <20071221023010.C56B7DDDF3@ozlabs.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:35983 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753161AbXLUCaM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Dec 2007 21:30:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, rdreier@cisco.com, linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk, davem@davemloft.net, james.bottomley@steeleye.com, ralf@linux-mips.org

This patch based on some earlier work by Roland Dreier introduces
a pair of annotations that can be used to enforce alignment of
objects that can be DMA'ed into, and to enforce that an DMA'able
object within a structure isn't sharing a cache line with some
other object.

Such sharing of a data structure between DMA and non-DMA objects
isn't a recommended practice, but it does happen and in some case
might even make sense, so we now have a way to make it work
propertly.

The current patch only enables such alignment for some PowerPC
platforms that do not have coherent caches. Other platforms such
as ARM, MIPS, etc... can define ARCH_MIN_DMA_ALIGNMENT if they
want to benefit from this, I don't know them well enough to do
it myself.

The initial issue I'm fixing (in a second patch) by using these
is the SCSI sense buffer which is currently part of the scsi
command structure and can be DMA'ed to. On non-coherent platforms,
this causes various corruptions as this cache line is shared with
various other fields of the scsi_cmnd data structure.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

 Documentation/DMA-mapping.txt |   32 ++++++++++++++++++++++++++++++++
 include/asm-generic/page.h    |   10 ++++++++++
 include/asm-powerpc/page.h    |    8 ++++++++
 3 files changed, 50 insertions(+)

--- linux-merge.orig/include/asm-generic/page.h	2007-07-27 13:44:45.000000000 +1000
+++ linux-merge/include/asm-generic/page.h	2007-12-21 13:07:28.000000000 +1100
@@ -20,6 +20,16 @@ static __inline__ __attribute_const__ in
 	return order;
 }
 
+#ifndef ARCH_MIN_DMA_ALIGNMENT
+#define __dma_aligned
+#define __dma_buffer
+#else
+#define __dma_aligned	  	__attribute__((aligned(ARCH_MIN_DMA_ALIGNMENT)))
+#define __dma_buffer		__dma_buffer_line(__LINE__)
+#define __dma_buffer_line(line)	__dma_aligned;\
+				char __dma_pad_##line[0] __dma_aligned
+#endif
+
 #endif	/* __ASSEMBLY__ */
 #endif	/* __KERNEL__ */
 
Index: linux-merge/include/asm-powerpc/page.h
===================================================================
--- linux-merge.orig/include/asm-powerpc/page.h	2007-09-28 11:42:10.000000000 +1000
+++ linux-merge/include/asm-powerpc/page.h	2007-12-21 13:15:02.000000000 +1100
@@ -77,6 +77,14 @@
 #define VM_DATA_DEFAULT_FLAGS64	(VM_READ | VM_WRITE | \
 				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 
+/*
+ * On non cache coherent platforms, we enforce cache aligned DMA
+ * buffers inside of structures
+ */
+#ifdef CONFIG_NOT_COHERENT_CACHE
+#define ARCH_MIN_DMA_ALIGNMENT	L1_CACHE_BYTES
+#endif
+
 #ifdef __powerpc64__
 #include <asm/page_64.h>
 #else
Index: linux-merge/Documentation/DMA-mapping.txt
===================================================================
--- linux-merge.orig/Documentation/DMA-mapping.txt	2007-12-21 13:17:14.000000000 +1100
+++ linux-merge/Documentation/DMA-mapping.txt	2007-12-21 13:20:00.000000000 +1100
@@ -75,6 +75,38 @@ What about block I/O and networking buff
 networking subsystems make sure that the buffers they use are valid
 for you to DMA from/to.
 
+Note that on non-cache-coherent architectures, having a DMA buffer
+that shares a cache line with other data can lead to memory
+corruption.
+
+The __dma_buffer macro exists to allow safe DMA buffers to be declared
+easily and portably as part of larger structures without causing bloat
+on cache-coherent architectures. To get this macro, architectures have
+to define ARCH_MIN_DMA_ALIGNMENT to the requested alignment value in
+their asm/page.h before including asm-generic/page.h
+
+Of course these structures must be contained in memory that can be
+used for DMA as described above.
+
+To use __dma_buffer, just declare a struct like:
+
+	struct mydevice {
+		    int field1;
+		    char buffer[BUFFER_SIZE] __dma_buffer;
+		    int field2;
+	};
+
+If this is used in code like:
+
+	struct mydevice *dev;
+	dev = kmalloc(sizeof *dev, GFP_KERNEL);
+
+then dev->buffer will be safe for DMA on all architectures.  On a
+cache-coherent architecture the members of dev will be aligned exactly
+as they would have been without __dma_buffer; on a non-cache-coherent
+architecture buffer and field2 will be aligned so that buffer does not
+share a cache line with any other data.
+
 			DMA addressing limitations
 
 Does your device have any DMA addressing limitations?  For example, is
