From: "David S. Miller" <davem@davemloft.net>
Subject: Re: 2.6.17-rc1+git, Sym2: unknown symbol pcibios_resource_to_bus
 (fwd)
Date: Mon, 17 Apr 2006 13:26:38 -0700 (PDT)
Message-ID: <20060417.132638.84565849.davem@davemloft.net>
References: <Pine.SOC.4.61.0604171849100.21709@math.ut.ee>
	<20060417.131705.40072804.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20060417.131705.40072804.davem@davemloft.net>
Sender: sparclinux-owner@vger.kernel.org
To: mroos@linux.ee
Cc: sparclinux@vger.kernel.org, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: "David S. Miller" <davem@davemloft.net>
Date: Mon, 17 Apr 2006 13:17:05 -0700 (PDT)

> From: Meelis Roos <mroos@linux.ee>
> Date: Mon, 17 Apr 2006 18:49:41 +0300 (EEST)
> 
> Putting linux-scsi and James back on the CC:
> 
> > Forwarded from linux-scsi.
>  ...
> > pcibios_resource_to_bus is a new function which is inline in
> > asm-generic/pci.h.   However, sparc64 overrides it as an external
> > function which is in arch/sparc64/kernel/pci.c, so this looks like some
> > type of sparc issue.
> 
> Why does the SYM2 driver possible even need this symbol?
> That's what I'd like to have explained.

Ok, here is the changeset in question.

If you're going to do stuff like this, being that you're the
first driver to ever make direct usage of this interface,
please double check the exports on all platforms so that you
haven't broken the build of the driver as you have on sparc64.

diff-tree b6d105d7ee188040a6e5eb86101e7476d94b3076 (from 1f61d82490a26dbcde903b33e24f6d11b758b64c)
Author: Matthew Wilcox <matthew@wil.cx>
Date:   Tue Mar 28 11:03:44 2006 -0500

    [SCSI] Use pcibios_resource_to_bus()
    
    We had our own code (pci_get_base_address()) to get the bus address of
    a BAR.  We can get this using pcibios_resource_to_bus() instead.
    
    Signed-off-by: Matthew Wilcox <matthew@wil.cx>
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index ec9d93a..e6ff89a 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -134,45 +134,6 @@ static void sym2_setup_params(void)
 	}
 }
 
-/*
- * We used to try to deal with 64-bit BARs here, but don't any more.
- * There are many parts of this driver which would need to be modified
- * to handle a 64-bit base address, including scripts.  I'm uncomfortable
- * with making those changes when I have no way of testing it, so I'm
- * just going to disable it.
- *
- * Note that some machines (eg HP rx8620 and Superdome) have bus addresses
- * below 4GB and physical addresses above 4GB.  These will continue to work.
- */
-static int __devinit
-pci_get_base_address(struct pci_dev *pdev, int index, unsigned long *basep)
-{
-	u32 tmp;
-	unsigned long base;
-#define PCI_BAR_OFFSET(index) (PCI_BASE_ADDRESS_0 + (index<<2))
-
-	pci_read_config_dword(pdev, PCI_BAR_OFFSET(index++), &tmp);
-	base = tmp;
-	if ((tmp & 0x7) == PCI_BASE_ADDRESS_MEM_TYPE_64) {
-		pci_read_config_dword(pdev, PCI_BAR_OFFSET(index++), &tmp);
-		if (tmp > 0) {
-			dev_err(&pdev->dev,
-				"BAR %d is 64-bit, disabling\n", index - 1);
-			base = 0;
-		}
-	}
-
-	if ((base & PCI_BASE_ADDRESS_SPACE) == PCI_BASE_ADDRESS_SPACE_IO) {
-		base &= PCI_BASE_ADDRESS_IO_MASK;
-	} else {
-		base &= PCI_BASE_ADDRESS_MEM_MASK;
-	}
-
-	*basep = base;
-	return index;
-#undef PCI_BAR_OFFSET
-}
-
 static struct scsi_transport_template *sym2_transport_template = NULL;
 
 /*
@@ -1866,13 +1827,23 @@ static int __devinit sym_set_workarounds
 static void __devinit
 sym_init_device(struct pci_dev *pdev, struct sym_device *device)
 {
-	int i;
+	int i = 2;
+	struct pci_bus_region bus_addr;
 
 	device->host_id = SYM_SETUP_HOST_ID;
 	device->pdev = pdev;
 
-	i = pci_get_base_address(pdev, 1, &device->mmio_base);
-	pci_get_base_address(pdev, i, &device->ram_base);
+	pcibios_resource_to_bus(pdev, &bus_addr, &pdev->resource[1]);
+	device->mmio_base = bus_addr.start;
+
+	/*
+	 * If the BAR is 64-bit, resource 2 will be occupied by the
+	 * upper 32 bits
+	 */
+	if (!pdev->resource[i].flags)
+		i++;
+	pcibios_resource_to_bus(pdev, &bus_addr, &pdev->resource[i]);
+	device->ram_base = bus_addr.start;
 
 #ifdef CONFIG_SCSI_SYM53C8XX_MMIO
 	if (device->mmio_base)
