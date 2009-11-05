From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Subject: Re: [PATCH] [SCSI] mpt fusion: Fix 32 bit platforms with 64 bit
	resources.
Date: Thu, 5 Nov 2009 08:43:30 -0500
Message-ID: <20091105134330.GA30489@zod.rchland.ibm.com>
References: <1253053555-25097-1-git-send-email-pbathija@amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37783 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755568AbZKENnm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Nov 2009 08:43:42 -0500
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e4.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id nA5DZgMK025270
	for <linux-scsi@vger.kernel.org>; Thu, 5 Nov 2009 08:35:42 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id nA5DhYqF536698
	for <linux-scsi@vger.kernel.org>; Thu, 5 Nov 2009 08:43:35 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id nA5DhXYs024643
	for <linux-scsi@vger.kernel.org>; Thu, 5 Nov 2009 08:43:34 -0500
Content-Disposition: inline
In-Reply-To: <1253053555-25097-1-git-send-email-pbathija@amcc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com
Cc: pbathija@amcc.com, linux-scsi@vger.kernel.org, benh@kernel.crashing.org, linuxppc-dev@ozlabs.org

On Tue, Sep 15, 2009 at 03:25:55PM -0700, pbathija@amcc.com wrote:
>From: Pravin Bathija <pbathija@amcc.com>
>
>Powerpc 44x uses 36 bit real address while the real address defined
>in MPT Fusion driver is of type 32 bit. This causes ioremap to fail and driver
>fails to initialize. This fix changes the data types representing the real
>address from unsigned long 32-bit types to "phys_addr_t" which is 64-bit. The
>driver has been tested, the disks get discovered correctly and can do IO. Also,
>replaced phys_addr_t with resource_size_t as suggested by Ben.
>
>Signed-off-by: Pravin Bathija <pbathija@amcc.com>
>Acked-by: Feng Kan <fkan@amcc.com>
>Acked-by: Prodyut Hazarika <phazarika@amcc.com>
>Acked-by: Loc Ho <lho@amcc.com>
>Acked-by: Tirumala Reddy Marri <tmarri@amcc.com>
>Acked-by: Victor Gallardo <vgallardo@amcc.com>

Is this patch included in the scsi tree at all?  I can't seem to find it in
linux-next and I know it's not in the powerpc tree.  Are there further changes
needed, or has it simply been missed?

josh

>
>---
> drivers/message/fusion/mptbase.c |   34 +++++++++++++++++++++++++---------
> drivers/message/fusion/mptbase.h |    5 +++--
> 2 files changed, 28 insertions(+), 11 deletions(-)
>
>diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
>index 5d496a9..e296f2e 100644
>--- a/drivers/message/fusion/mptbase.c
>+++ b/drivers/message/fusion/mptbase.c
>@@ -1510,11 +1510,12 @@ static int
> mpt_mapresources(MPT_ADAPTER *ioc)
> {
> 	u8		__iomem *mem;
>+	u8		__iomem *port;
> 	int		 ii;
>-	unsigned long	 mem_phys;
>-	unsigned long	 port;
>-	u32		 msize;
>-	u32		 psize;
>+	resource_size_t	 mem_phys;
>+	resource_size_t	 port_phys;
>+	resource_size_t	 msize;
>+	resource_size_t	 psize;
> 	u8		 revision;
> 	int		 r = -ENODEV;
> 	struct pci_dev *pdev;
>@@ -1552,13 +1553,13 @@ mpt_mapresources(MPT_ADAPTER *ioc)
> 	}
>
> 	mem_phys = msize = 0;
>-	port = psize = 0;
>+	port_phys = psize = 0;
> 	for (ii = 0; ii < DEVICE_COUNT_RESOURCE; ii++) {
> 		if (pci_resource_flags(pdev, ii) & PCI_BASE_ADDRESS_SPACE_IO) {
> 			if (psize)
> 				continue;
> 			/* Get I/O space! */
>-			port = pci_resource_start(pdev, ii);
>+			port_phys = pci_resource_start(pdev, ii);
> 			psize = pci_resource_len(pdev, ii);
> 		} else {
> 			if (msize)
>@@ -1580,14 +1581,23 @@ mpt_mapresources(MPT_ADAPTER *ioc)
> 		return -EINVAL;
> 	}
> 	ioc->memmap = mem;
>-	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "mem = %p, mem_phys = %lx\n",
>-	    ioc->name, mem, mem_phys));
>+	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "mem = %p, mem_phys = %llx\n",
>+	    ioc->name, mem, (u64)mem_phys));
>
> 	ioc->mem_phys = mem_phys;
> 	ioc->chip = (SYSIF_REGS __iomem *)mem;
>
> 	/* Save Port IO values in case we need to do downloadboot */
>-	ioc->pio_mem_phys = port;
>+	port = ioremap(port_phys, psize);
>+	if (port == NULL) {
>+		printk(MYIOC_s_ERR_FMT " : ERROR - Unable to map adapter"
>+			" port !\n", ioc->name);
>+		return -EINVAL;
>+	}
>+	ioc->portmap = port;
>+	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "port=%p, port_phys=%llx\n",
>+			ioc->name, port, (u64)port_phys));
>+	ioc->pio_mem_phys = port_phys;
> 	ioc->pio_chip = (SYSIF_REGS __iomem *)port;
>
> 	return 0;
>@@ -1822,6 +1832,7 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
> 		if (ioc->alt_ioc)
> 			ioc->alt_ioc->alt_ioc = NULL;
> 		iounmap(ioc->memmap);
>+		iounmap(ioc->portmap);
> 		if (r != -5)
> 			pci_release_selected_regions(pdev, ioc->bars);
>
>@@ -2583,6 +2594,11 @@ mpt_adapter_dispose(MPT_ADAPTER *ioc)
> 		ioc->memmap = NULL;
> 	}
>
>+	if (ioc->portmap != NULL) {
>+		iounmap(ioc->portmap);
>+		ioc->portmap = NULL;
>+	}
>+
> 	pci_disable_device(ioc->pcidev);
> 	pci_release_selected_regions(ioc->pcidev, ioc->bars);
>
>diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
>index b3e981d..7091f13 100644
>--- a/drivers/message/fusion/mptbase.h
>+++ b/drivers/message/fusion/mptbase.h
>@@ -584,8 +584,8 @@ typedef struct _MPT_ADAPTER
> 	SYSIF_REGS __iomem	*chip;		/* == c8817000 (mmap) */
> 	SYSIF_REGS __iomem	*pio_chip;	/* Programmed IO (downloadboot) */
> 	u8			 bus_type;
>-	u32			 mem_phys;	/* == f4020000 (mmap) */
>-	u32			 pio_mem_phys;	/* Programmed IO (downloadboot) */
>+	resource_size_t		 mem_phys;	/* == f4020000 (mmap) */
>+	resource_size_t		 pio_mem_phys;	/* Programmed IO (downloadboot) */
> 	int			 mem_size;	/* mmap memory size */
> 	int			 number_of_buses;
> 	int			 devices_per_bus;
>@@ -635,6 +635,7 @@ typedef struct _MPT_ADAPTER
> 	int			bars;		/* bitmask of BAR's that must be configured */
> 	int			msi_enable;
> 	u8			__iomem *memmap;	/* mmap address */
>+	u8			__iomem *portmap;	/* mmap port address */
> 	struct Scsi_Host	*sh;		/* Scsi Host pointer */
> 	SpiCfgData		spi_data;	/* Scsi config. data */
> 	RaidCfgData		raid_data;	/* Raid config. data */
>-- 
>1.5.5
>
>_______________________________________________
>Linuxppc-dev mailing list
>Linuxppc-dev@lists.ozlabs.org
>https://lists.ozlabs.org/listinfo/linuxppc-dev
