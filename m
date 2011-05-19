From: Roland Dreier <roland@kernel.org>
Subject: [PATCH] x86: Remove 32-bit versions of readq()/writeq()
Date: Thu, 19 May 2011 16:54:53 -0700
Message-ID: <1305849293-25437-1-git-send-email-roland@kernel.org>
References: <20110519181500.GF6139@elte.hu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110519181500.GF6139@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Milton Miller <miltonm@bga.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Hitoshi Mitake <h.mitake@gmail.com>, Kashyap Desai <Kashyap.Desai@lsi.com>, Len Brown <lenb@kernel.org>, Ravi Anand <ravi.anand@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Matthew Garrett <mjg@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

The presense of a writeq() implementation on 32-bit x86 that splits
the 64-bit write into two 32-bit writes turns out to break the mpt2sas
driver (and in general is risky for drivers as was discussed in
<http://lkml.kernel.org/r/adaab6c1h7c.fsf@cisco.com>).  To fix this,
revert 2c5643b1c5c7 ("x86: provide readq()/writeq() on 32-bit too")
and follow-on cleanups.

This unfortunately leads to pushing non-atomic definitions of readq()
and write() to various x86-only drivers that in the mean time started
using the definitions in the x86 version of <asm/io.h>.  However as
discussed exhaustively, this is actually the right thing to do,
because the right way to split a 64-bit transaction is hardware
dependent and therefore belongs in the hardware driver (eg mpt2sas
needs a spinlock to make sure no other accesses occur in between the
two halves of the access).

Build tested on 32- and 64-bit x86 allmodconfig.

Link: http://lkml.kernel.org/r/x86-32-writeq-is-broken@mdm.bga.com
Cc: Hitoshi Mitake <h.mitake@gmail.com>
Cc: Kashyap Desai <Kashyap.Desai@lsi.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Ravi Anand <ravi.anand@qlogic.com>
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 arch/x86/Kconfig                 |    2 --
 arch/x86/include/asm/io.h        |   24 ++----------------------
 drivers/acpi/apei/einj.c         |    8 ++++++++
 drivers/acpi/atomicio.c          |    4 ++++
 drivers/edac/i3200_edac.c        |   13 +++++++++++++
 drivers/platform/x86/ibm_rtl.c   |   13 +++++++++++++
 drivers/platform/x86/intel_ips.c |   13 +++++++++++++
 drivers/scsi/qla4xxx/ql4_nx.c    |   21 +++++++++++++++++++++
 8 files changed, 74 insertions(+), 24 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cc6c53a..ceb41f3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -16,8 +16,6 @@ config X86_64
 config X86
 	def_bool y
 	select HAVE_AOUT if X86_32
-	select HAVE_READQ
-	select HAVE_WRITEQ
 	select HAVE_UNSTABLE_SCHED_CLOCK
 	select HAVE_IDE
 	select HAVE_OPROFILE
diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 0722730..d02804d 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -38,7 +38,6 @@
 
 #include <linux/string.h>
 #include <linux/compiler.h>
-#include <asm-generic/int-ll64.h>
 #include <asm/page.h>
 
 #include <xen/xen.h>
@@ -87,27 +86,6 @@ build_mmio_write(__writel, "l", unsigned int, "r", )
 build_mmio_read(readq, "q", unsigned long, "=r", :"memory")
 build_mmio_write(writeq, "q", unsigned long, "r", :"memory")
 
-#else
-
-static inline __u64 readq(const volatile void __iomem *addr)
-{
-	const volatile u32 __iomem *p = addr;
-	u32 low, high;
-
-	low = readl(p);
-	high = readl(p + 1);
-
-	return low + ((u64)high << 32);
-}
-
-static inline void writeq(__u64 val, volatile void __iomem *addr)
-{
-	writel(val, addr);
-	writel(val >> 32, addr+4);
-}
-
-#endif
-
 #define readq_relaxed(a)	readq(a)
 
 #define __raw_readq(a)		readq(a)
@@ -117,6 +95,8 @@ static inline void writeq(__u64 val, volatile void __iomem *addr)
 #define readq			readq
 #define writeq			writeq
 
+#endif
+
 /**
  *	virt_to_phys	-	map virtual addresses to physical
  *	@address: address to remap
diff --git a/drivers/acpi/apei/einj.c b/drivers/acpi/apei/einj.c
index 096aebf..f74b2ea 100644
--- a/drivers/acpi/apei/einj.c
+++ b/drivers/acpi/apei/einj.c
@@ -101,6 +101,14 @@ static DEFINE_MUTEX(einj_mutex);
 
 static struct einj_parameter *einj_param;
 
+#ifndef writeq
+static inline void writeq(__u64 val, volatile void __iomem *addr)
+{
+	writel(val, addr);
+	writel(val >> 32, addr+4);
+}
+#endif
+
 static void einj_exec_ctx_init(struct apei_exec_context *ctx)
 {
 	apei_exec_ctx_init(ctx, einj_ins_type, ARRAY_SIZE(einj_ins_type),
diff --git a/drivers/acpi/atomicio.c b/drivers/acpi/atomicio.c
index 542e539..7489b89 100644
--- a/drivers/acpi/atomicio.c
+++ b/drivers/acpi/atomicio.c
@@ -280,9 +280,11 @@ static int acpi_atomic_read_mem(u64 paddr, u64 *val, u32 width)
 	case 32:
 		*val = readl(addr);
 		break;
+#ifdef readq
 	case 64:
 		*val = readq(addr);
 		break;
+#endif
 	default:
 		return -EINVAL;
 	}
@@ -307,9 +309,11 @@ static int acpi_atomic_write_mem(u64 paddr, u64 val, u32 width)
 	case 32:
 		writel(val, addr);
 		break;
+#ifdef writeq
 	case 64:
 		writeq(val, addr);
 		break;
+#endif
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/edac/i3200_edac.c b/drivers/edac/i3200_edac.c
index d41f900..aa08497 100644
--- a/drivers/edac/i3200_edac.c
+++ b/drivers/edac/i3200_edac.c
@@ -101,6 +101,19 @@ struct i3200_priv {
 
 static int nr_channels;
 
+#ifndef readq
+static inline __u64 readq(const volatile void __iomem *addr)
+{
+	const volatile u32 __iomem *p = addr;
+	u32 low, high;
+
+	low = readl(p);
+	high = readl(p + 1);
+
+	return low + ((u64)high << 32);
+}
+#endif
+
 static int how_many_channels(struct pci_dev *pdev)
 {
 	unsigned char capid0_8b; /* 8th byte of CAPID0 */
diff --git a/drivers/platform/x86/ibm_rtl.c b/drivers/platform/x86/ibm_rtl.c
index 94a114a..b1396e5 100644
--- a/drivers/platform/x86/ibm_rtl.c
+++ b/drivers/platform/x86/ibm_rtl.c
@@ -81,6 +81,19 @@ static void __iomem *rtl_cmd_addr;
 static u8 rtl_cmd_type;
 static u8 rtl_cmd_width;
 
+#ifndef readq
+static inline __u64 readq(const volatile void __iomem *addr)
+{
+	const volatile u32 __iomem *p = addr;
+	u32 low, high;
+
+	low = readl(p);
+	high = readl(p + 1);
+
+	return low + ((u64)high << 32);
+}
+#endif
+
 static void __iomem *rtl_port_map(phys_addr_t addr, unsigned long len)
 {
 	if (rtl_cmd_type == RTL_ADDR_TYPE_MMIO)
diff --git a/drivers/platform/x86/intel_ips.c b/drivers/platform/x86/intel_ips.c
index 85c8ad4..5ffe7c3 100644
--- a/drivers/platform/x86/intel_ips.c
+++ b/drivers/platform/x86/intel_ips.c
@@ -344,6 +344,19 @@ struct ips_driver {
 static bool
 ips_gpu_turbo_enabled(struct ips_driver *ips);
 
+#ifndef readq
+static inline __u64 readq(const volatile void __iomem *addr)
+{
+	const volatile u32 __iomem *p = addr;
+	u32 low, high;
+
+	low = readl(p);
+	high = readl(p + 1);
+
+	return low + ((u64)high << 32);
+}
+#endif
+
 /**
  * ips_cpu_busy - is CPU busy?
  * @ips: IPS driver struct
diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 35381cb..03e522b 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -655,6 +655,27 @@ static int qla4_8xxx_pci_is_same_window(struct scsi_qla_host *ha,
 	return 0;
 }
 
+#ifndef readq
+static inline __u64 readq(const volatile void __iomem *addr)
+{
+	const volatile u32 __iomem *p = addr;
+	u32 low, high;
+
+	low = readl(p);
+	high = readl(p + 1);
+
+	return low + ((u64)high << 32);
+}
+#endif
+
+#ifndef writeq
+static inline void writeq(__u64 val, volatile void __iomem *addr)
+{
+	writel(val, addr);
+	writel(val >> 32, addr+4);
+}
+#endif
+
 static int qla4_8xxx_pci_mem_read_direct(struct scsi_qla_host *ha,
 		u64 off, void *data, int size)
 {
