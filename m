From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH] x86: Moving probe_roms_32 to probe_roms
Date: Fri, 25 Feb 2011 02:13:42 -0800
Message-ID: <1298628822.11506.21.camel@dwillia2-linux>
References: <20110222201538.15443.81915.stgit@localhost6.localdomain6>
	 <AANLkTikimHCsFmavDoXn3Pka8WWMePqk+hNUK8h=DqSQ@mail.gmail.com>
	 <4D670B07.90005@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4D670B07.90005@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Jiang, Dave" <dave.jiang@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, David Milburn <dmilburn@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2011-02-24 at 17:51 -0800, H. Peter Anvin wrote: 
> On 02/24/2011 05:27 PM, Dan Williams wrote:
> > On Tue, Feb 22, 2011 at 12:16 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> >> From: Dave Jiang <dave.jiang@intel.com>
> >>
> >> Moving the probe_roms_32 code to probe_roms and make available for all x86. The
> >> end result adapter roms data structure is made available read-only to drivers.
> >> The Intel isci SAS driver needs to scan the OROM memory in order to pull OEM
> >> parameters from the OROM.
> >>
> >> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> >> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> >> ---
> >>
> >> We could just export adapter_rom_resources directly and be done with it, but
> >> it seemed reasonable to have a compile time catch for drivers that try to
> >> modify the resources, and that drivers should not assume the number of
> >> available adapter roms.
> >>
> > 
> > Ping?  The "RFC" was probably not needed, just wanted clarification if
> > the interface for modules to retrieve the adapter rom data was in good
> > taste.
> > 
> 
> Rather than exporting the array -- which is functionally what you're
> doing -- I would prefer if the actual probing code can be generalized
> and put into probe_roms.c.  Extra bonus if it can be unified with the
> existing probing code.

Ok, we will still end up searching for a magic string at a random
location in the rom image, but how about the following generic interface
for at least getting us to our correct option-rom.  pci_map_biosrom()
returns the option-rom that matches the given pci device or matches any
device id that the device's driver supports.

diff --git a/arch/x86/include/asm/probe_roms.h b/arch/x86/include/asm/probe_roms.h
index 3e9ea6d..f113ad2 100644
--- a/arch/x86/include/asm/probe_roms.h
+++ b/arch/x86/include/asm/probe_roms.h
@@ -1,7 +1,10 @@
 #ifndef _PROBE_ROMS_H_
 #define _PROBE_ROMS_H_
 
-extern const struct resource *x86_adapter_rom_resources(void);
-extern int x86_num_adapter_roms(void);
+struct pci_dev;
+
+extern void __iomem *pci_map_biosrom(struct pci_dev *pdev);
+extern void pci_unmap_biosrom(void __iomem *rom);
+extern size_t pci_biosrom_size(struct pci_dev *pdev); 
 
 #endif
diff --git a/arch/x86/kernel/probe_roms.c b/arch/x86/kernel/probe_roms.c
index 5dcf53f..9a2fdf2 100644
--- a/arch/x86/kernel/probe_roms.c
+++ b/arch/x86/kernel/probe_roms.c
@@ -73,18 +73,106 @@ static struct resource video_rom_resource = {
 	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
 };
 
-/* grant modules read only access to the adapter rom table */
-const struct resource *x86_adapter_rom_resources(void)
+/* does this oprom support the given pci device, or any of the devices
+ * that the driver supports?
+ */
+static bool match_id(struct pci_dev *pdev, unsigned short vendor, unsigned short device)
 {
-	return adapter_rom_resources;
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
 }
-EXPORT_SYMBOL(x86_adapter_rom_resources);
 
-int x86_num_adapter_roms(void)
+static struct resource *find_oprom(struct pci_dev *pdev)
 {
-	return ARRAY_SIZE(adapter_rom_resources);
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
+		if (probe_kernel_address(rom + offset + 0x8, list) != 0 &&
+		    probe_kernel_address(rom + offset + 0xc, rev) != 0 &&
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
 }
-EXPORT_SYMBOL(x86_num_adapter_roms);
+EXPORT_SYMBOL(pci_biosrom_size);
 
 #define ROMSIGNATURE 0xaa55
 
