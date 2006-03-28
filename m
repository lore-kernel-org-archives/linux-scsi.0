From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 02/10] Use pcibios_resource_to_bus()
Date: Tue, 28 Mar 2006 11:03:44 -0500
Message-ID: <11435618241244-git-send-email-matthew@wil.cx>
Reply-To: Matthew Wilcox <matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.magma.ca ([206.191.0.250]:34742 "EHLO mx2.magma.ca")
	by vger.kernel.org with ESMTP id S1751191AbWC1QDa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Mar 2006 11:03:30 -0500
In-Reply-To: 20060328160156.GJ3486@parisc-linux.org
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

We had our own code (pci_get_base_address()) to get the bus address of
a BAR.  We can get this using pcibios_resource_to_bus() instead.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

---

 drivers/scsi/sym53c8xx_2/sym_glue.c |   55 ++++++++---------------------------
 1 files changed, 13 insertions(+), 42 deletions(-)

d7e27761615786472c84e10c93116c716bae13ce
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
-- 
1.2.4.g375a5


