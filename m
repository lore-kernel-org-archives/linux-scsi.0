From: pbathija@amcc.com
Subject: [PATCH]  [SCSI] mpt fusion: Fix 32 bit platforms with 64 bit resources.
Date: Tue, 17 Nov 2009 16:16:41 -0800
Message-ID: <1258503401-7779-1-git-send-email-pbathija@amcc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sdcmail02.amcc.com ([198.137.200.90]:33311 "EHLO
	sdcmail02.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbZKRAQg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Nov 2009 19:16:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, benh@kernel.crashing.org, jwboyer@linux.vnet.ibm.com, Eric.Moore@lsi.com, Pravin Bathija <pbathija@amcc.com>

From: Pravin Bathija <pbathija@amcc.com>

  Powerpc 44x uses 36 bit real address while the real address defined
  in MPT Fusion driver is of type 32 bit. This causes ioremap to fail and driver
  fails to initialize. This fix changes the data types representing the real
  address from unsigned long 32-bit types to "phys_addr_t" which is 64-bit. The
  driver has been tested, the disks get discovered correctly and can do IO. Removed
  ioremap and used hose->io_base_virt for IO space to make it platform independent.
Content-Type: text/plain; charset=utf-8

Signed-off-by: Pravin Bathija <pbathija@amcc.com>
Acked-by: Feng Kan <fkan@amcc.com>
Acked-by: Prodyut Hazarika <phazarika@amcc.com>
Acked-by: Loc Ho <lho@amcc.com>
Acked-by: Tirumala Reddy Marri <tmarri@amcc.com>
Acked-by: Victor Gallardo <vgallardo@amcc.com>
---
 drivers/message/fusion/mptbase.c |   38 ++++++++++++++++++++++++++++----------
 drivers/message/fusion/mptbase.h |    5 +++--
 2 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 5d496a9..9bca4bd 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1510,11 +1510,12 @@ static int
 mpt_mapresources(MPT_ADAPTER *ioc)
 {
 	u8		__iomem *mem;
+	u8		__iomem *port;
 	int		 ii;
-	unsigned long	 mem_phys;
-	unsigned long	 port;
-	u32		 msize;
-	u32		 psize;
+	resource_size_t	 mem_phys;
+	resource_size_t	 port_phys;
+	resource_size_t	 msize;
+	resource_size_t	 psize;
 	u8		 revision;
 	int		 r = -ENODEV;
 	struct pci_dev *pdev;
@@ -1552,14 +1553,24 @@ mpt_mapresources(MPT_ADAPTER *ioc)
 	}
 
 	mem_phys = msize = 0;
-	port = psize = 0;
+	port_phys = psize = 0;
 	for (ii = 0; ii < DEVICE_COUNT_RESOURCE; ii++) {
 		if (pci_resource_flags(pdev, ii) & PCI_BASE_ADDRESS_SPACE_IO) {
 			if (psize)
 				continue;
 			/* Get I/O space! */
-			port = pci_resource_start(pdev, ii);
+			port_phys = pci_resource_start(pdev, ii);
 			psize = pci_resource_len(pdev, ii);
+			struct pci_controller *hose =
+						pci_bus_to_host(pdev->bus);
+			port = hose->io_base_virt;
+			if (port == NULL) {
+				printk(MYIOC_s_ERR_FMT " : ERROR - Unable to"
+					"map adapter port !\n", ioc->name);
+				return -EINVAL;
+			}
+			ioc->pio_mem_phys = port_phys;
+			ioc->pio_chip = (SYSIF_REGS __iomem *)port;
 		} else {
 			if (msize)
 				continue;
@@ -1580,15 +1591,16 @@ mpt_mapresources(MPT_ADAPTER *ioc)
 		return -EINVAL;
 	}
 	ioc->memmap = mem;
-	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "mem = %p, mem_phys = %lx\n",
-	    ioc->name, mem, mem_phys));
+	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "mem = %p, mem_phys = %llx\n",
+	    ioc->name, mem, (u64)mem_phys));
 
 	ioc->mem_phys = mem_phys;
 	ioc->chip = (SYSIF_REGS __iomem *)mem;
 
 	/* Save Port IO values in case we need to do downloadboot */
-	ioc->pio_mem_phys = port;
-	ioc->pio_chip = (SYSIF_REGS __iomem *)port;
+	ioc->portmap = port;
+	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "port=%p, port_phys=%llx\n",
+			ioc->name, port, (u64)port_phys));
 
 	return 0;
 }
@@ -1822,6 +1834,7 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 		if (ioc->alt_ioc)
 			ioc->alt_ioc->alt_ioc = NULL;
 		iounmap(ioc->memmap);
+		iounmap(ioc->portmap);
 		if (r != -5)
 			pci_release_selected_regions(pdev, ioc->bars);
 
@@ -2583,6 +2596,11 @@ mpt_adapter_dispose(MPT_ADAPTER *ioc)
 		ioc->memmap = NULL;
 	}
 
+	if (ioc->portmap != NULL) {
+		iounmap(ioc->portmap);
+		ioc->portmap = NULL;
+	}
+
 	pci_disable_device(ioc->pcidev);
 	pci_release_selected_regions(ioc->pcidev, ioc->bars);
 
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index b3e981d..7091f13 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -584,8 +584,8 @@ typedef struct _MPT_ADAPTER
 	SYSIF_REGS __iomem	*chip;		/* == c8817000 (mmap) */
 	SYSIF_REGS __iomem	*pio_chip;	/* Programmed IO (downloadboot) */
 	u8			 bus_type;
-	u32			 mem_phys;	/* == f4020000 (mmap) */
-	u32			 pio_mem_phys;	/* Programmed IO (downloadboot) */
+	resource_size_t		 mem_phys;	/* == f4020000 (mmap) */
+	resource_size_t		 pio_mem_phys;	/* Programmed IO (downloadboot) */
 	int			 mem_size;	/* mmap memory size */
 	int			 number_of_buses;
 	int			 devices_per_bus;
@@ -635,6 +635,7 @@ typedef struct _MPT_ADAPTER
 	int			bars;		/* bitmask of BAR's that must be configured */
 	int			msi_enable;
 	u8			__iomem *memmap;	/* mmap address */
+	u8			__iomem *portmap;	/* mmap port address */
 	struct Scsi_Host	*sh;		/* Scsi Host pointer */
 	SpiCfgData		spi_data;	/* Scsi config. data */
 	RaidCfgData		raid_data;	/* Raid config. data */
-- 
1.5.5

