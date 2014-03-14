From: Laura Abbott <lauraa@codeaurora.org>
Subject: [PATCH 1/2] lib/scatterlist: Make ARCH_HAS_SG_CHAIN an actual Kconfig
Date: Fri, 14 Mar 2014 15:58:49 -0700
Message-ID: <1394837930-27731-1-git-send-email-lauraa@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Russell King <linux@arm.linux.org.uk>, "David S. Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Fenghua Yu <fenghua.yu@intel.com>, Tony Luck <tony.luck@intel.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-s390@vger.kernel.org, Laura Abbott <lauraa@codeaurora.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux390@de.ibm.com, sparclinux@vger.kernel.org, linux-ia64@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

Rather than have architectures #define ARCH_HAS_SG_CHAIN in an architecture
specific scatterlist.h, make it a proper Kconfig option and use that
instead. At same time, remove the header files are are now mostly
useless and just include asm-generic/scatterlist.h.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Benjamin Herrenschmidt <benh@kernel.crashing.org>
Paul Mackerras <paulus@samba.org>
Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
---
 arch/arm/Kconfig                       |  1 +
 arch/arm/include/asm/Kbuild            |  1 +
 arch/arm/include/asm/scatterlist.h     | 12 ------------
 arch/arm64/Kconfig                     |  1 +
 arch/ia64/Kconfig                      |  1 +
 arch/ia64/include/asm/Kbuild           |  1 +
 arch/ia64/include/asm/scatterlist.h    |  7 -------
 arch/powerpc/Kconfig                   |  1 +
 arch/powerpc/include/asm/Kbuild        |  1 +
 arch/powerpc/include/asm/scatterlist.h | 17 -----------------
 arch/s390/Kconfig                      |  1 +
 arch/s390/include/asm/Kbuild           |  1 +
 arch/s390/include/asm/scatterlist.h    |  3 ---
 arch/sparc/Kconfig                     |  1 +
 arch/sparc/include/asm/Kbuild          |  1 +
 arch/sparc/include/asm/scatterlist.h   |  8 --------
 arch/x86/Kconfig                       |  1 +
 arch/x86/include/asm/Kbuild            |  1 +
 arch/x86/include/asm/scatterlist.h     |  8 --------
 include/linux/scatterlist.h            |  2 +-
 include/scsi/scsi.h                    |  2 +-
 lib/Kconfig                            |  7 +++++++
 lib/scatterlist.c                      |  4 ++--
 23 files changed, 24 insertions(+), 59 deletions(-)
 delete mode 100644 arch/arm/include/asm/scatterlist.h
 delete mode 100644 arch/ia64/include/asm/scatterlist.h
 delete mode 100644 arch/powerpc/include/asm/scatterlist.h
 delete mode 100644 arch/s390/include/asm/scatterlist.h
 delete mode 100644 arch/sparc/include/asm/scatterlist.h
 delete mode 100644 arch/x86/include/asm/scatterlist.h

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 1594945..8122294 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -82,6 +82,7 @@ config ARM
 	  <http://www.arm.linux.org.uk/>.
 
 config ARM_HAS_SG_CHAIN
+	select ARCH_HAS_SG_CHAIN
 	bool
 
 config NEED_SG_DMA_LENGTH
diff --git a/arch/arm/include/asm/Kbuild b/arch/arm/include/asm/Kbuild
index 3278afe..2357ed6 100644
--- a/arch/arm/include/asm/Kbuild
+++ b/arch/arm/include/asm/Kbuild
@@ -18,6 +18,7 @@ generic-y += param.h
 generic-y += parport.h
 generic-y += poll.h
 generic-y += resource.h
+generic-y += scatterlist.h
 generic-y += sections.h
 generic-y += segment.h
 generic-y += sembuf.h
diff --git a/arch/arm/include/asm/scatterlist.h b/arch/arm/include/asm/scatterlist.h
deleted file mode 100644
index cefdb8f..0000000
--- a/arch/arm/include/asm/scatterlist.h
+++ /dev/null
@@ -1,12 +0,0 @@
-#ifndef _ASMARM_SCATTERLIST_H
-#define _ASMARM_SCATTERLIST_H
-
-#ifdef CONFIG_ARM_HAS_SG_CHAIN
-#define ARCH_HAS_SG_CHAIN
-#endif
-
-#include <asm/memory.h>
-#include <asm/types.h>
-#include <asm-generic/scatterlist.h>
-
-#endif /* _ASMARM_SCATTERLIST_H */
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 27bbcfc..f2f95f4 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2,6 +2,7 @@ config ARM64
 	def_bool y
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select ARCH_USE_CMPXCHG_LOCKREF
+	select ARCH_HAS_SG_CHAIN
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 0c8e553..13e2e8b 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -44,6 +44,7 @@ config IA64
 	select HAVE_MOD_ARCH_SPECIFIC
 	select MODULES_USE_ELF_RELA
 	select ARCH_USE_CMPXCHG_LOCKREF
+	select ARCH_HAS_SG_CHAIN
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
diff --git a/arch/ia64/include/asm/Kbuild b/arch/ia64/include/asm/Kbuild
index 283a831..3906865 100644
--- a/arch/ia64/include/asm/Kbuild
+++ b/arch/ia64/include/asm/Kbuild
@@ -2,6 +2,7 @@
 generic-y += clkdev.h
 generic-y += exec.h
 generic-y += kvm_para.h
+generic-y += scatterlist.h
 generic-y += trace_clock.h
 generic-y += preempt.h
 generic-y += vtime.h
diff --git a/arch/ia64/include/asm/scatterlist.h b/arch/ia64/include/asm/scatterlist.h
deleted file mode 100644
index 08fd93b..0000000
--- a/arch/ia64/include/asm/scatterlist.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef _ASM_IA64_SCATTERLIST_H
-#define _ASM_IA64_SCATTERLIST_H
-
-#include <asm-generic/scatterlist.h>
-#define ARCH_HAS_SG_CHAIN
-
-#endif /* _ASM_IA64_SCATTERLIST_H */
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 957bf34..659aee2 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -141,6 +141,7 @@ config PPC
 	select HAVE_DEBUG_STACKOVERFLOW
 	select HAVE_IRQ_EXIT_ON_IRQ_STACK
 	select ARCH_USE_CMPXCHG_LOCKREF if PPC64
+	select ARCH_HAS_SG_CHAIN
 
 config GENERIC_CSUM
 	def_bool CPU_LITTLE_ENDIAN
diff --git a/arch/powerpc/include/asm/Kbuild b/arch/powerpc/include/asm/Kbuild
index 6c0a955..ca596ec 100644
--- a/arch/powerpc/include/asm/Kbuild
+++ b/arch/powerpc/include/asm/Kbuild
@@ -1,6 +1,7 @@
 
 generic-y += clkdev.h
 generic-y += rwsem.h
+generic-y += scatterlist.h
 generic-y += trace_clock.h
 generic-y += preempt.h
 generic-y += vtime.h
diff --git a/arch/powerpc/include/asm/scatterlist.h b/arch/powerpc/include/asm/scatterlist.h
deleted file mode 100644
index de1f620..0000000
--- a/arch/powerpc/include/asm/scatterlist.h
+++ /dev/null
@@ -1,17 +0,0 @@
-#ifndef _ASM_POWERPC_SCATTERLIST_H
-#define _ASM_POWERPC_SCATTERLIST_H
-/*
- * Copyright (C) 2001 PPC64 Team, IBM Corp
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#include <asm/dma.h>
-#include <asm-generic/scatterlist.h>
-
-#define ARCH_HAS_SG_CHAIN
-
-#endif /* _ASM_POWERPC_SCATTERLIST_H */
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 65a0775..d6c2059 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -142,6 +142,7 @@ config S390
 	select SYSCTL_EXCEPTION_TRACE
 	select VIRT_CPU_ACCOUNTING
 	select VIRT_TO_BUS
+	select ARCH_HAS_SG_CHAIN
 
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
diff --git a/arch/s390/include/asm/Kbuild b/arch/s390/include/asm/Kbuild
index 8386a4a..14be6d0 100644
--- a/arch/s390/include/asm/Kbuild
+++ b/arch/s390/include/asm/Kbuild
@@ -4,3 +4,4 @@ generic-y += clkdev.h
 generic-y += trace_clock.h
 generic-y += preempt.h
 generic-y += hash.h
+generic-y += scatterlist.h
diff --git a/arch/s390/include/asm/scatterlist.h b/arch/s390/include/asm/scatterlist.h
deleted file mode 100644
index 6d45ef6..0000000
--- a/arch/s390/include/asm/scatterlist.h
+++ /dev/null
@@ -1,3 +0,0 @@
-#include <asm-generic/scatterlist.h>
-
-#define ARCH_HAS_SG_CHAIN
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 7d8b7e9..7a179fe 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -42,6 +42,7 @@ config SPARC
 	select MODULES_USE_ELF_RELA
 	select ODD_RT_SIGACTION
 	select OLD_SIGSUSPEND
+	select ARCH_HAS_SG_CHAIN
 
 config SPARC32
 	def_bool !64BIT
diff --git a/arch/sparc/include/asm/Kbuild b/arch/sparc/include/asm/Kbuild
index 4b60a0c..437f0c6 100644
--- a/arch/sparc/include/asm/Kbuild
+++ b/arch/sparc/include/asm/Kbuild
@@ -18,3 +18,4 @@ generic-y += types.h
 generic-y += word-at-a-time.h
 generic-y += preempt.h
 generic-y += hash.h
+generic-y += scatterlist.h
diff --git a/arch/sparc/include/asm/scatterlist.h b/arch/sparc/include/asm/scatterlist.h
deleted file mode 100644
index 92bb638..0000000
--- a/arch/sparc/include/asm/scatterlist.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef _SPARC_SCATTERLIST_H
-#define _SPARC_SCATTERLIST_H
-
-#include <asm-generic/scatterlist.h>
-
-#define ARCH_HAS_SG_CHAIN
-
-#endif /* !(_SPARC_SCATTERLIST_H) */
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0af5250..76997dc 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -127,6 +127,7 @@ config X86
 	select HAVE_DEBUG_STACKOVERFLOW
 	select HAVE_IRQ_EXIT_ON_IRQ_STACK if X86_64
 	select HAVE_CC_STACKPROTECTOR
+	select ARCH_HAS_SG_CHAIN
 
 config INSTRUCTION_DECODER
 	def_bool y
diff --git a/arch/x86/include/asm/Kbuild b/arch/x86/include/asm/Kbuild
index 7f66985..9b3d749 100644
--- a/arch/x86/include/asm/Kbuild
+++ b/arch/x86/include/asm/Kbuild
@@ -5,3 +5,4 @@ genhdr-y += unistd_64.h
 genhdr-y += unistd_x32.h
 
 generic-y += clkdev.h
+generic-y += scatterlist.h
diff --git a/arch/x86/include/asm/scatterlist.h b/arch/x86/include/asm/scatterlist.h
deleted file mode 100644
index 4240878..0000000
--- a/arch/x86/include/asm/scatterlist.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef _ASM_X86_SCATTERLIST_H
-#define _ASM_X86_SCATTERLIST_H
-
-#include <asm-generic/scatterlist.h>
-
-#define ARCH_HAS_SG_CHAIN
-
-#endif /* _ASM_X86_SCATTERLIST_H */
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index a964f72..4b152c8 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -136,7 +136,7 @@ static inline void sg_set_buf(struct scatterlist *sg, const void *buf,
 static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
 			    struct scatterlist *sgl)
 {
-#ifndef ARCH_HAS_SG_CHAIN
+#ifndef CONFIG_ARCH_HAS_SG_CHAIN
 	BUG();
 #endif
 
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 0a4edfe..d34cf2d 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -31,7 +31,7 @@ enum scsi_timeouts {
  * Like SCSI_MAX_SG_SEGMENTS, but for archs that have sg chaining. This limit
  * is totally arbitrary, a setting of 2048 will get you at least 8mb ios.
  */
-#ifdef ARCH_HAS_SG_CHAIN
+#ifdef CONFIG_ARCH_HAS_SG_CHAIN
 #define SCSI_MAX_SG_CHAIN_SEGMENTS	2048
 #else
 #define SCSI_MAX_SG_CHAIN_SEGMENTS	SCSI_MAX_SG_SEGMENTS
diff --git a/lib/Kconfig b/lib/Kconfig
index 991c98b..32c68d3 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -451,4 +451,11 @@ config UCS2_STRING
 
 source "lib/fonts/Kconfig"
 
+#
+# sg chaining option
+#
+
+config ARCH_HAS_SG_CHAIN
+	def_bool n
+
 endmenu
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 3a8e8e8..4251cbd 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -73,7 +73,7 @@ EXPORT_SYMBOL(sg_nents);
  **/
 struct scatterlist *sg_last(struct scatterlist *sgl, unsigned int nents)
 {
-#ifndef ARCH_HAS_SG_CHAIN
+#ifndef CONFIG_ARCH_HAS_SG_CHAIN
 	struct scatterlist *ret = &sgl[nents - 1];
 #else
 	struct scatterlist *sg, *ret = NULL;
@@ -251,7 +251,7 @@ int __sg_alloc_table(struct sg_table *table, unsigned int nents,
 
 	if (nents == 0)
 		return -EINVAL;
-#ifndef ARCH_HAS_SG_CHAIN
+#ifndef CONFIG_ARCH_HAS_SG_CHAIN
 	if (WARN_ON_ONCE(nents > max_ents))
 		return -EINVAL;
 #endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
