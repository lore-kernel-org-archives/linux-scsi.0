From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] x86: introduce pci_map_biosrom()
Date: Tue, 08 Mar 2011 10:36:19 -0800
Message-ID: <20110308183226.6246.90354.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: hpa@zytor.com
Cc: dmilburn@redhat.com, Dave Jiang <dave.jiang@intel.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The isci driver needs to retrieve its preboot orom image which contains
necessary runtime parameters like platform specific sas addresses and
phy configuration.  There is no rom bar associated with this area,
instead we need to scan legacy expansion rom space.

1/ Promote the probe_roms_32 implementation to x86-64
2/ Add a facility to find and map an adapter rom by pci device (according to
   PCI Firmware Specification Revision 3.0)

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

Here is the updated rom scanning implementation as initially presented
here [1].  Dave has been able to verify this implementation on his
platform.  This is modelled loosely on the interface provided by
pci_map_rom().

--
Dan

[1]: http://marc.info/?l=linux-scsi&m=129862745115270&w=2

 arch/x86/include/asm/probe_roms.h |    8 +++
 arch/x86/include/asm/setup.h      |    3 +
 arch/x86/kernel/Makefile          |    2 -
 arch/x86/kernel/head32.c          |    1 
 arch/x86/kernel/probe_roms.c      |  101 +++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/x86_init.c        |    2 -
 6 files changed, 113 insertions(+), 4 deletions(-)
 create mode 100644 arch/x86/include/asm/probe_roms.h
 rename arch/x86/kernel/{probe_roms_32.c => probe_roms.c} (65%)

diff --git a/arch/x86/include/asm/probe_roms.h b/arch/x86/include/asm/probe_roms.h
new file mode 100644
index 0000000..4950a0b
--- /dev/null
+++ b/arch/x86/include/asm/probe_roms.h
@@ -0,0 +1,8 @@
+#ifndef _PROBE_ROMS_H_
+#define _PROBE_ROMS_H_
+struct pci_dev;
+
+extern void __iomem *pci_map_biosrom(struct pci_dev *pdev);
+extern void pci_unmap_biosrom(void __iomem *rom);
+extern size_t pci_biosrom_size(struct pci_dev *pdev);
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
similarity index 65%
rename from arch/x86/kernel/probe_roms_32.c
rename to arch/x86/kernel/probe_roms.c
index 071e7fe..ba0a4cc 100644
--- a/arch/x86/kernel/probe_roms_32.c
+++ b/arch/x86/kernel/probe_roms.c
@@ -73,6 +73,107 @@ static struct resource video_rom_resource = {
 	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
 };
 
+/* does this oprom support the given pci device, or any of the devices
+ * that the driver supports?
+ */
+static bool match_id(struct pci_dev *pdev, unsigned short vendor, unsigned short device)
+{
+	struct pci_driver *drv = pdev->driver;
+	const struct pci_device_id *id;
+
+	if (pdev->vendor == vendor && pdev->device == device)
+		return true;
+
+	for (id = drv ? drv->id_table : NULL; id && id->vendor; id++)
+		if (id->vendor == vendor && id->device == device)
+			break;
+
+	return id && id->vendor;
+}
+
+static bool probe_list(struct pci_dev *pdev, unsigned short vendor,
+		       const unsigned char *rom_list)
+{
+	unsigned short device;
+
+	do {
+		if (probe_kernel_address(rom_list, device) != 0)
+			device = 0;
+
+		if (device && match_id(pdev, vendor, device))
+			break;
+
+		rom_list += 2;
+	} while (device);
+
+	return !!device;
+}
+
+static struct resource *find_oprom(struct pci_dev *pdev)
+{
+	struct resource *oprom = NULL;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(adapter_rom_resources); i++) {
+		struct resource *res = &adapter_rom_resources[i];
+		unsigned short offset, vendor, device, list, rev;
+		const unsigned char *rom;
+
+		if (res->end == 0)
+			break;
+
+		rom = isa_bus_to_virt(res->start);
+		if (probe_kernel_address(rom + 0x18, offset) != 0)
+			continue;
+
+		if (probe_kernel_address(rom + offset + 0x4, vendor) != 0)
+			continue;
+
+		if (probe_kernel_address(rom + offset + 0x6, device) != 0)
+			continue;
+
+		if (match_id(pdev, vendor, device)) {
+			oprom = res;
+			break;
+		}
+
+		if (probe_kernel_address(rom + offset + 0x8, list) == 0 &&
+		    probe_kernel_address(rom + offset + 0xc, rev) == 0 &&
+		    rev >= 3 && list &&
+		    probe_list(pdev, vendor, rom + offset + list)) {
+			oprom = res;
+			break;
+		}
+	}
+
+	return oprom;
+}
+
+void *pci_map_biosrom(struct pci_dev *pdev)
+{
+	struct resource *oprom = find_oprom(pdev);
+
+	if (!oprom)
+		return NULL;
+
+	return ioremap(oprom->start, resource_size(oprom));
+}
+EXPORT_SYMBOL(pci_map_biosrom);
+
+void pci_unmap_biosrom(void __iomem *image)
+{
+	iounmap(image);
+}
+EXPORT_SYMBOL(pci_unmap_biosrom);
+
+size_t pci_biosrom_size(struct pci_dev *pdev)
+{
+	struct resource *oprom = find_oprom(pdev);
+
+	return oprom ? resource_size(oprom) : 0;
+}
+EXPORT_SYMBOL(pci_biosrom_size);
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
