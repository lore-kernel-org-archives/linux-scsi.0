From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC PATCH] x86: Moving probe_roms_32 to probe_roms
Date: Tue, 22 Feb 2011 12:16:32 -0800
Message-ID: <20110222201538.15443.81915.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: hpa@zytor.com
Cc: Dave Jiang <dave.jiang@intel.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

Moving the probe_roms_32 code to probe_roms and make available for all x86. The
end result adapter roms data structure is made available read-only to drivers.
The Intel isci SAS driver needs to scan the OROM memory in order to pull OEM
parameters from the OROM.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---

We could just export adapter_rom_resources directly and be done with it, but
it seemed reasonable to have a compile time catch for drivers that try to
modify the resources, and that drivers should not assume the number of
available adapter roms.

--
Dan

 arch/x86/include/asm/probe_roms.h |    7 +++++++
 arch/x86/include/asm/setup.h      |    3 ++-
 arch/x86/kernel/Makefile          |    2 +-
 arch/x86/kernel/head32.c          |    1 -
 arch/x86/kernel/probe_roms.c      |   13 +++++++++++++
 arch/x86/kernel/x86_init.c        |    2 +-
 6 files changed, 24 insertions(+), 4 deletions(-)
 create mode 100644 arch/x86/include/asm/probe_roms.h
 rename arch/x86/kernel/{probe_roms_32.c => probe_roms.c} (93%)

diff --git a/arch/x86/include/asm/probe_roms.h b/arch/x86/include/asm/probe_roms.h
new file mode 100644
index 0000000..3e9ea6d
--- /dev/null
+++ b/arch/x86/include/asm/probe_roms.h
@@ -0,0 +1,7 @@
+#ifndef _PROBE_ROMS_H_
+#define _PROBE_ROMS_H_
+
+extern const struct resource *x86_adapter_rom_resources(void);
+extern int x86_num_adapter_roms(void);
+
+#endif
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index ef292c7..52edb6d 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -93,10 +93,11 @@ void *extend_brk(size_t size, size_t align);
 			: : "i" (sz));					\
 	}
 
+extern void probe_roms(void);
+
 #ifdef __i386__
 
 void __init i386_start_kernel(void);
-extern void probe_roms(void);
 
 #else
 void __init x86_64_start_kernel(char *real_mode);
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index fedf32a..f31ae9b 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -36,7 +36,7 @@ obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
 obj-y			+= time.o ioport.o ldt.o dumpstack.o
 obj-y			+= setup.o x86_init.o i8259.o irqinit.o
 obj-$(CONFIG_X86_VISWS)	+= visws_quirks.o
-obj-$(CONFIG_X86_32)	+= probe_roms_32.o
+obj-y			+= probe_roms.o
 obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
 obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o
diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index 784360c..e7605ed 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -21,7 +21,6 @@
 static void __init i386_default_early_setup(void)
 {
 	/* Initialize 32bit specific setup functions */
-	x86_init.resources.probe_roms = probe_roms;
 	x86_init.resources.reserve_resources = i386_reserve_resources;
 	x86_init.mpparse.setup_ioapic_ids = setup_ioapic_ids_from_mpc;
 
diff --git a/arch/x86/kernel/probe_roms_32.c b/arch/x86/kernel/probe_roms.c
similarity index 93%
rename from arch/x86/kernel/probe_roms_32.c
rename to arch/x86/kernel/probe_roms.c
index 071e7fe..5dcf53f 100644
--- a/arch/x86/kernel/probe_roms_32.c
+++ b/arch/x86/kernel/probe_roms.c
@@ -73,6 +73,19 @@ static struct resource video_rom_resource = {
 	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
 };
 
+/* grant modules read only access to the adapter rom table */
+const struct resource *x86_adapter_rom_resources(void)
+{
+	return adapter_rom_resources;
+}
+EXPORT_SYMBOL(x86_adapter_rom_resources);
+
+int x86_num_adapter_roms(void)
+{
+	return ARRAY_SIZE(adapter_rom_resources);
+}
+EXPORT_SYMBOL(x86_num_adapter_roms);
+
 #define ROMSIGNATURE 0xaa55
 
 static int __init romsignature(const unsigned char *rom)
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index cd6da6b..1bc104f 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -33,7 +33,7 @@ void iommu_shutdown_noop(void) { }
 struct x86_init_ops x86_init __initdata = {
 
 	.resources = {
-		.probe_roms		= x86_init_noop,
+		.probe_roms		= probe_roms,
 		.reserve_resources	= reserve_standard_io_resources,
 		.memory_setup		= default_machine_specific_memory_setup,
 	},
