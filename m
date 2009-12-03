From: Wolfgang Denk <wd@denx.de>
Subject: Re: [PATCH] [SCSI] mpt fusion: Fix 32 bit platforms with 64 bit resources.
Date: Thu, 03 Dec 2009 09:56:28 +0100
Message-ID: <20091203085628.5140FE6D391@gemini.denx.de>
References: <1259805106-23636-1-git-send-email-pbathija@amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:36832 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362AbZLCI40 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2009 03:56:26 -0500
In-reply-to: <1259805106-23636-1-git-send-email-pbathija@amcc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pravin Bathija <pbathija@amcc.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org, Eric.Moore@lsi.com

Dear Pravin Bathija,

In message <1259805106-23636-1-git-send-email-pbathija@amcc.com> you wrote:
>     Powerpc 44x uses 36 bit real address while the real address defined
>     in MPT Fusion driver is of type 32 bit. This causes ioremap to fail and driver
>     fails to initialize. This fix changes the data types representing the real
>     address from unsigned long 32-bit types to resource_size_t which is 64-bit. The
>     driver has been tested, the disks get discovered correctly and can do IO.
...
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -1511,7 +1511,7 @@ mpt_mapresources(MPT_ADAPTER *ioc)
>  {
>  	u8		__iomem *mem;
>  	int		 ii;
> -	unsigned long	 mem_phys;
> +	resource_size_t	 mem_phys;
>  	unsigned long	 port;
>  	u32		 msize;
>  	u32		 psize;

I'm not sure if this one-liner really covers all the related issues.
We submitted a similar (but apparently more complete) patch more than
a year ago. Dunno why it has never been picked up. See
http://thread.gmane.org/gmane.linux.scsi/46082 for reference.


> From: Yuri Tikhonov <yur@emcraft.com>
To: linux-scsi@vger.kernel.org
Subject: [PATCH] mptbase: use resource_size_t instead of unsigned long and u32
Date: Thu, 13 Nov 2008 11:33:16 +0300

 Hello,

 The following patch adds using resource_size_t for the
pci_resource_start()/pci_resource_len() return values. This
makes mptbase driver work correctly on 32 bit systems with
64 bit resources (e.g. PPC440SPe).

Do some minor cleanups in mpt_mapresources() as well.

Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
Signed-off-by: Ilya Yanok <yanok@emcraft.com>
---
 drivers/message/fusion/mptbase.c |   38 ++++++++++++++++++++++++++------------
 drivers/message/fusion/mptbase.h |    5 +++--
 2 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index d6a0074..9daf844 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1488,11 +1488,12 @@ static int
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
@@ -1530,13 +1531,13 @@ mpt_mapresources(MPT_ADAPTER *ioc)
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
 		} else {
 			if (msize)
@@ -1546,11 +1547,8 @@ mpt_mapresources(MPT_ADAPTER *ioc)
 			msize = pci_resource_len(pdev, ii);
 		}
 	}
-	ioc->mem_size = msize;
 
-	mem = NULL;
 	/* Get logical ptr for PciMem0 space */
-	/*mem = ioremap(mem_phys, msize);*/
 	mem = ioremap(mem_phys, msize);
 	if (mem == NULL) {
 		printk(MYIOC_s_ERR_FMT ": ERROR - Unable to map adapter"
@@ -1558,14 +1556,24 @@ mpt_mapresources(MPT_ADAPTER *ioc)
 		return -EINVAL;
 	}
 	ioc->memmap = mem;
-	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "mem = %p, mem_phys = %lx\n",
-	    ioc->name, mem, mem_phys));
+	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "mem=%p, mem_phys=%llx\n",
+	    ioc->name, mem, (u64)mem_phys));
 
 	ioc->mem_phys = mem_phys;
 	ioc->chip = (SYSIF_REGS __iomem *)mem;
 
 	/* Save Port IO values in case we need to do downloadboot */
-	ioc->pio_mem_phys = port;
+	port = ioremap(port_phys, psize);
+	if (port == NULL) {
+		printk(MYIOC_s_ERR_FMT ": ERROR - Unable to map adapter"
+			" port!\n", ioc->name);
+		return -EINVAL;
+	}
+	ioc->portmap = port;
+	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "port=%p, port_phys=%llx\n",
+	    ioc->name, port, (u64)port_phys));
+
+	ioc->pio_mem_phys = port_phys;
 	ioc->pio_chip = (SYSIF_REGS __iomem *)port;
 
 	return 0;
@@ -1790,6 +1798,7 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 		list_del(&ioc->list);
 		if (ioc->alt_ioc)
 			ioc->alt_ioc->alt_ioc = NULL;
+		iounmap(ioc->portmap);
 		iounmap(ioc->memmap);
 		if (r != -5)
 			pci_release_selected_regions(pdev, ioc->bars);
@@ -2547,6 +2556,11 @@ mpt_adapter_dispose(MPT_ADAPTER *ioc)
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
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index dff048c..17826b3 100644
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
+	u8			__iomem *portmap;	/* mmap address */
 	struct Scsi_Host	*sh;		/* Scsi Host pointer */
 	SpiCfgData		spi_data;	/* Scsi config. data */
 	RaidCfgData		raid_data;	/* Raid config. data */
-- 
1.5.6.1


-- 
Yuri Tikhonov, Senior Software Engineer
Emcraft Systems, www.emcraft.com






Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
"I haven't lost my mind - it's backed up on tape somewhere."
