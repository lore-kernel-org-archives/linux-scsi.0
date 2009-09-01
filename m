From: Vitaly Bordug <vitb@kernel.crashing.org>
Subject: [PATCH] mptbase: use resource_size_t instead of unsigned long and
 u32
Date: Wed, 2 Sep 2009 01:08:37 +0400
Message-ID: <20090902010837.5c83cff5@vitb-lp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:47887 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbZIAVH7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Sep 2009 17:07:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <Eric.Moore@lsi.com>
Cc: DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org

From: Yuri Tikhonov <yur@emcraft.com>

    Use resource_size_t for pci_resource_start()/pci_resource_len()
    return values. This makes mptbase driver work correctly on 32
    bit systems with 64 bit resources (e.g. PPC440SPe).

    Do some minor cleanups in mpt_mapresources().

    Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
    Signed-off-by: Ilya Yanok <yanok@emcraft.com>
    Signed-off-by: Vitaly Bordug <vitb@kernel.crashing.org>
---

 drivers/message/fusion/mptbase.c |   38
 ++++++++++++++++++++++++++------------
 drivers/message/fusion/mptbase.h |    5 +++-- 2 files changed, 29
 insertions(+), 14 deletions(-)


diff --git a/drivers/message/fusion/mptbase.c
b/drivers/message/fusion/mptbase.c index 5d0ba4f..d47bd46 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1590,11 +1590,12 @@ static int
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
@@ -1653,13 +1654,13 @@ mpt_mapresources(MPT_ADAPTER *ioc)
 	}
 
 	mem_phys = msize = 0;
-	port = psize = 0;
+	port_phys = psize = 0;
 	for (ii = 0; ii < DEVICE_COUNT_RESOURCE; ii++) {
 		if (pci_resource_flags(pdev, ii) &
PCI_BASE_ADDRESS_SPACE_IO) { if (psize)
 				continue;
 			/* Get I/O space! */
-			port = pci_resource_start(pdev, ii);
+			port_phys = pci_resource_start(pdev, ii);
 			psize = pci_resource_len(pdev, ii);
 		} else {
 			if (msize)
@@ -1669,11 +1670,8 @@ mpt_mapresources(MPT_ADAPTER *ioc)
 			msize = pci_resource_len(pdev, ii);
 		}
 	}
-	ioc->mem_size = msize;
 
-	mem = NULL;
 	/* Get logical ptr for PciMem0 space */
-	/*mem = ioremap(mem_phys, msize);*/
 	mem = ioremap(mem_phys, msize);
 	if (mem == NULL) {
 		printk(MYIOC_s_ERR_FMT ": ERROR - Unable to map
adapter" @@ -1681,14 +1679,24 @@ mpt_mapresources(MPT_ADAPTER *ioc)
 		return -EINVAL;
 	}
 	ioc->memmap = mem;
-	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "mem = %p, mem_phys =
%lx\n",
-	    ioc->name, mem, mem_phys));
+	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "mem=%p,
mem_phys=%llx\n",
+	    ioc->name, mem, (u64)mem_phys));
 
 	ioc->mem_phys = mem_phys;
 	ioc->chip = (SYSIF_REGS __iomem *)mem;
 
 	/* Save Port IO values in case we need to do downloadboot */
-	ioc->pio_mem_phys = port;
+	port = ioremap(port_phys, psize);
+	if (port == NULL) {
+		printk(MYIOC_s_ERR_FMT ": ERROR - Unable to map
adapter"
+			" port!\n", ioc->name);
+		return -EINVAL;
+	}
+	ioc->portmap = port;
+	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "port=%p,
port_phys=%llx\n",
+	    ioc->name, port, (u64)port_phys));
+
+	ioc->pio_mem_phys = port_phys;
 	ioc->pio_chip = (SYSIF_REGS __iomem *)port;
 
 	return 0;
@@ -1949,6 +1957,7 @@ mpt_attach(struct pci_dev *pdev, const struct
pci_device_id *id) list_del(&ioc->list);
 		if (ioc->alt_ioc)
 			ioc->alt_ioc->alt_ioc = NULL;
+		iounmap(ioc->portmap);
 		iounmap(ioc->memmap);
 		if (r != -5)
 			pci_release_selected_regions(pdev, ioc->bars);
@@ -2792,6 +2801,11 @@ mpt_adapter_dispose(MPT_ADAPTER *ioc)
 		ioc->pci_irq = -1;
 	}
 
+	if (ioc->portmap != NULL) {
+		iounmap(ioc->portmap);
+		ioc->portmap = NULL;
+	}
+
 	if (ioc->memmap != NULL) {
 		iounmap(ioc->memmap);
 		ioc->memmap = NULL;
diff --git a/drivers/message/fusion/mptbase.h
b/drivers/message/fusion/mptbase.h index 1c8514d..66bf190 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -604,8 +604,8 @@ typedef struct _MPT_ADAPTER
 	SYSIF_REGS __iomem	*chip;		/* == c8817000
(mmap) */ SYSIF_REGS __iomem	*pio_chip;	/* Programmed IO
(downloadboot) */ u8			 bus_type;
-	u32			 mem_phys;	/* == f4020000
(mmap) */
-	u32			 pio_mem_phys;	/* Programmed
IO (downloadboot) */
+	resource_size_t		 mem_phys;	/* ==
f4020000 (mmap) */
+	resource_size_t		 pio_mem_phys;	/*
Programmed IO (downloadboot) */ int
mem_size;	/* mmap memory size */ int
number_of_buses; int			 devices_per_bus;
@@ -659,6 +659,7 @@ typedef struct _MPT_ADAPTER
 	int			bars;		/* bitmask of
BAR's that must be configured */ int			msi_enable;
 	u8			__iomem *memmap;	/* mmap
address */
+	u8			__iomem *portmap;	/* mmap
address */ struct Scsi_Host	*sh;		/* Scsi Host
pointer */ SpiCfgData		spi_data;	/* Scsi config.
data */ RaidCfgData		raid_data;	/* Raid config.
data */
