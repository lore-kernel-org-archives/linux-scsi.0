From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] [SCSI] mpt fusion: Fix 32 bit platforms with 64 bit
 resources.
Date: Thu, 05 Nov 2009 10:07:06 -0600
Message-ID: <1257437226.2753.64.camel@mulgrave.site>
References: <1253053555-25097-1-git-send-email-pbathija@amcc.com>
	 <20091105134330.GA30489@zod.rchland.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:39001 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755896AbZKEQHN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Nov 2009 11:07:13 -0500
In-Reply-To: <20091105134330.GA30489@zod.rchland.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Eric.Moore@lsi.com, pbathija@amcc.com, linux-scsi@vger.kernel.org, benh@kernel.crashing.org, linuxppc-dev@ozlabs.org

On Thu, 2009-11-05 at 08:43 -0500, Josh Boyer wrote:
> On Tue, Sep 15, 2009 at 03:25:55PM -0700, pbathija@amcc.com wrote:
> >From: Pravin Bathija <pbathija@amcc.com>
> >
> >Powerpc 44x uses 36 bit real address while the real address defined
> >in MPT Fusion driver is of type 32 bit. This causes ioremap to fail and driver
> >fails to initialize. This fix changes the data types representing the real
> >address from unsigned long 32-bit types to "phys_addr_t" which is 64-bit. The
> >driver has been tested, the disks get discovered correctly and can do IO. Also,
> >replaced phys_addr_t with resource_size_t as suggested by Ben.
> >
> >Signed-off-by: Pravin Bathija <pbathija@amcc.com>
> >Acked-by: Feng Kan <fkan@amcc.com>
> >Acked-by: Prodyut Hazarika <phazarika@amcc.com>
> >Acked-by: Loc Ho <lho@amcc.com>
> >Acked-by: Tirumala Reddy Marri <tmarri@amcc.com>
> >Acked-by: Victor Gallardo <vgallardo@amcc.com>
> 
> Is this patch included in the scsi tree at all?  I can't seem to find it in
> linux-next and I know it's not in the powerpc tree.  Are there further changes
> needed, or has it simply been missed?

What was the feedback from LSI ... I haven't seen any here?

> josh
> 
> >
> >---
> > drivers/message/fusion/mptbase.c |   34 +++++++++++++++++++++++++---------
> > drivers/message/fusion/mptbase.h |    5 +++--
> > 2 files changed, 28 insertions(+), 11 deletions(-)
> >
> >diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
> >index 5d496a9..e296f2e 100644
> >--- a/drivers/message/fusion/mptbase.c
> >+++ b/drivers/message/fusion/mptbase.c
> >@@ -1510,11 +1510,12 @@ static int
> > mpt_mapresources(MPT_ADAPTER *ioc)
> > {
> > 	u8		__iomem *mem;
> >+	u8		__iomem *port;
> > 	int		 ii;
> >-	unsigned long	 mem_phys;
> >-	unsigned long	 port;
> >-	u32		 msize;
> >-	u32		 psize;
> >+	resource_size_t	 mem_phys;
> >+	resource_size_t	 port_phys;
> >+	resource_size_t	 msize;
> >+	resource_size_t	 psize;
> > 	u8		 revision;
> > 	int		 r = -ENODEV;
> > 	struct pci_dev *pdev;
> >@@ -1552,13 +1553,13 @@ mpt_mapresources(MPT_ADAPTER *ioc)
> > 	}
> >
> > 	mem_phys = msize = 0;
> >-	port = psize = 0;
> >+	port_phys = psize = 0;
> > 	for (ii = 0; ii < DEVICE_COUNT_RESOURCE; ii++) {
> > 		if (pci_resource_flags(pdev, ii) & PCI_BASE_ADDRESS_SPACE_IO) {
> > 			if (psize)
> > 				continue;
> > 			/* Get I/O space! */
> >-			port = pci_resource_start(pdev, ii);
> >+			port_phys = pci_resource_start(pdev, ii);
> > 			psize = pci_resource_len(pdev, ii);
> > 		} else {
> > 			if (msize)
> >@@ -1580,14 +1581,23 @@ mpt_mapresources(MPT_ADAPTER *ioc)
> > 		return -EINVAL;
> > 	}
> > 	ioc->memmap = mem;
> >-	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "mem = %p, mem_phys = %lx\n",
> >-	    ioc->name, mem, mem_phys));
> >+	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "mem = %p, mem_phys = %llx\n",
> >+	    ioc->name, mem, (u64)mem_phys));
> >
> > 	ioc->mem_phys = mem_phys;
> > 	ioc->chip = (SYSIF_REGS __iomem *)mem;
> >
> > 	/* Save Port IO values in case we need to do downloadboot */
> >-	ioc->pio_mem_phys = port;
> >+	port = ioremap(port_phys, psize);
> >+	if (port == NULL) {
> >+		printk(MYIOC_s_ERR_FMT " : ERROR - Unable to map adapter"
> >+			" port !\n", ioc->name);
> >+		return -EINVAL;

So this looks problematic on a few platforms ... what happens to
platforms that have no IO space?  They automatically fail here and it
looks like the adapter never attaches.

James


