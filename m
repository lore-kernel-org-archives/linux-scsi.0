From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: [PATCH] mpt fusion: Power Management fixes for MPT SAS
	PCI-Econtrollers-revised
Date: Wed, 19 Mar 2008 10:08:06 -0500
Message-ID: <1205939287.11527.11.camel@localhost.localdomain>
References: <664A4EBB07F29743873A87CF62C26D70D82C72@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52637 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753115AbYCSTYw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Mar 2008 15:24:52 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D70D82C72@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: "Prakash, Sathya" <Sathya.Prakash@lsi.com>, linux-scsi@vger.kernel.org, djwong@us.ibm.com

On Fri, 2008-03-14 at 09:27 -0600, Moore, Eric wrote:
> On Thursday, March 13, 2008 3:42 PM,  James Bottomley wrote:
> > On Fri, 2008-03-07 at 16:19 +0530, Prakash, Sathya wrote:
> > > This patch includes the review comments from James on the 
> > previous version.
> > > 
> > > The system power state changes like hibernation and standby 
> > are not happening
> > > properly with 106XE controllers, this patch modifies the 
> > driver to free
> > > resources and allocate resources in power management entry points
> > 
> > This is supposed to be a bug fix patch to get suspend/resume working.
> > Because you've made it dependent on the msi_enable patch, which is a
> > feature enhancement, it still can't go in the scsi-rc-fixes tree.
> > 
> > Isn't it just best at this point to go with Darrick's patch for fixing
> > 2.6.25 and 2.6.24?
> > 
> 
> James, 
> 
> The patch supplied by Darrick will not fix the issue reported on the
> x-series IBM platforms.    To fix the problem we need to be sending a
> diagnostic reset, instead of MUR (message_unit_reset), when we are
> coming out of resume.  Regarding MSI, the driver already has MSI support
> for a couple years, however you would have to manually enable it thru a
> command line option.  The patch we supplied will have it always enabled
> for SAS parts.   Enabling MSI helped with debugging this issue IBM
> reported, however its not required.  We have no issues with having MSI
> always enabled, as today we are shipping other drivers having that
> enabled, and we've been testing this in the labs for the past year.
> The other part of the patch was to release/allocate resource power
> management seems to me to be more efficient method for power management,
> and this was coded it when we were working this issue, do you agree?
> 
> Here is the contents of the Power Management Errata which only effects
> PCIe SAS Parts:
> 
> Doorbell does not reset on a D0->D3->D0 transition.  If the part is
> power managed to D3 state, the doorbell register will remain at whatever
> it was set to before the part was power managed.  The driver will issue
> a MUR just before we are shutdown, to clear out all I/O's (there
> shouldn't be any, but just in case) and mainly to disable events.  If
> events are enabled the F/W can get stuck trying to issue an event even
> though the device has been unmapped.  Anyway, the doorbell will be in
> the Ready state due to the MUR.  Now, after the D0->D3->D0 transition
> the driver comes back up and immediately sees Ready in the doorbell and
> starts to try to initialize the device (IOCInit, PortEnable, etc.).
> But, the device really isn't ready yet (H/W and F/W are still getting
> things initialized after the D3->D0 transition).  So these handshake
> messages fail.  The workaround I was told to use is to do a diag reset
> after coming out of any power transisiton state.

OK, I think this will do:  I untangled the msi piece so it's applyable
upstream.

James

---

From: Prakash, Sathya <sathya.prakash@lsi.com>
Date: Fri, 7 Mar 2008 16:19:50 +0530
Subject: [SCSI] mpt fusion: Power Management fixes for MPT SAS PCI-E controllers

The system power state changes like hibernation and standby are not happening
properly with 106XE controllers, this patch modifies the driver to free
resources and allocate resources in power management entry points

[jejb: compile fixes for upstream]

Signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/message/fusion/mptbase.c  |  276 +++++++++++++++++++++----------------
 drivers/message/fusion/mptscsih.c |   11 ++-
 2 files changed, 166 insertions(+), 121 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 6b6df86..c6be6eb 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1430,6 +1430,98 @@ mpt_get_product_name(u16 vendor, u16 device, u8 revision, char *prod_name)
 		sprintf(prod_name, "%s", product_str);
 }
 
+/**
+ *	mpt_mapresources - map in memory mapped io
+ *	@ioc: Pointer to pointer to IOC adapter
+ *
+ **/
+static int
+mpt_mapresources(MPT_ADAPTER *ioc)
+{
+	u8		__iomem *mem;
+	int		 ii;
+	unsigned long	 mem_phys;
+	unsigned long	 port;
+	u32		 msize;
+	u32		 psize;
+	u8		 revision;
+	int		 r = -ENODEV;
+	struct pci_dev *pdev;
+
+	pdev = ioc->pcidev;
+	ioc->bars = pci_select_bars(pdev, IORESOURCE_MEM);
+	if (pci_enable_device_mem(pdev)) {
+		printk(MYIOC_s_ERR_FMT "pci_enable_device_mem() "
+		    "failed\n", ioc->name);
+		return r;
+	}
+	if (pci_request_selected_regions(pdev, ioc->bars, "mpt")) {
+		printk(MYIOC_s_ERR_FMT "pci_request_selected_regions() with "
+		    "MEM failed\n", ioc->name);
+		return r;
+	}
+
+	pci_read_config_byte(pdev, PCI_CLASS_REVISION, &revision);
+
+	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)
+	    && !pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK)) {
+		dinitprintk(ioc, printk(MYIOC_s_INFO_FMT
+		    ": 64 BIT PCI BUS DMA ADDRESSING SUPPORTED\n",
+		    ioc->name));
+	} else if (!pci_set_dma_mask(pdev, DMA_32BIT_MASK)
+	    && !pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK)) {
+		dinitprintk(ioc, printk(MYIOC_s_INFO_FMT
+		    ": 32 BIT PCI BUS DMA ADDRESSING SUPPORTED\n",
+		    ioc->name));
+	} else {
+		printk(MYIOC_s_WARN_FMT "no suitable DMA mask for %s\n",
+		    ioc->name, pci_name(pdev));
+		pci_release_selected_regions(pdev, ioc->bars);
+		return r;
+	}
+
+	mem_phys = msize = 0;
+	port = psize = 0;
+	for (ii = 0; ii < DEVICE_COUNT_RESOURCE; ii++) {
+		if (pci_resource_flags(pdev, ii) & PCI_BASE_ADDRESS_SPACE_IO) {
+			if (psize)
+				continue;
+			/* Get I/O space! */
+			port = pci_resource_start(pdev, ii);
+			psize = pci_resource_len(pdev, ii);
+		} else {
+			if (msize)
+				continue;
+			/* Get memmap */
+			mem_phys = pci_resource_start(pdev, ii);
+			msize = pci_resource_len(pdev, ii);
+		}
+	}
+	ioc->mem_size = msize;
+
+	mem = NULL;
+	/* Get logical ptr for PciMem0 space */
+	/*mem = ioremap(mem_phys, msize);*/
+	mem = ioremap(mem_phys, msize);
+	if (mem == NULL) {
+		printk(MYIOC_s_ERR_FMT ": ERROR - Unable to map adapter"
+			" memory!\n", ioc->name);
+		return -EINVAL;
+	}
+	ioc->memmap = mem;
+	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "mem = %p, mem_phys = %lx\n",
+	    ioc->name, mem, mem_phys));
+
+	ioc->mem_phys = mem_phys;
+	ioc->chip = (SYSIF_REGS __iomem *)mem;
+
+	/* Save Port IO values in case we need to do downloadboot */
+	ioc->pio_mem_phys = port;
+	ioc->pio_chip = (SYSIF_REGS __iomem *)port;
+
+	return 0;
+}
+
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	mpt_attach - Install a PCI intelligent MPT adapter.
@@ -1452,13 +1544,6 @@ int
 mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	MPT_ADAPTER	*ioc;
-	u8		__iomem *mem;
-	u8		__iomem *pmem;
-	unsigned long	 mem_phys;
-	unsigned long	 port;
-	u32		 msize;
-	u32		 psize;
-	int		 ii;
 	u8		 cb_idx;
 	int		 r = -ENODEV;
 	u8		 revision;
@@ -1468,52 +1553,32 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct proc_dir_entry *dent, *ent;
 #endif
 
-	if (mpt_debug_level)
-		printk(KERN_INFO MYNAM ": mpt_debug_level=%xh\n", mpt_debug_level);
-
 	ioc = kzalloc(sizeof(MPT_ADAPTER), GFP_ATOMIC);
 	if (ioc == NULL) {
 		printk(KERN_ERR MYNAM ": ERROR - Insufficient memory to add adapter!\n");
 		return -ENOMEM;
 	}
-	ioc->debug_level = mpt_debug_level;
+
 	ioc->id = mpt_ids++;
 	sprintf(ioc->name, "ioc%d", ioc->id);
 
-	ioc->bars = pci_select_bars(pdev, IORESOURCE_MEM);
-	if (pci_enable_device_mem(pdev)) {
-		printk(MYIOC_s_ERR_FMT "pci_enable_device_mem() "
-		       "failed\n", ioc->name);
-		kfree(ioc);
-		return r;
-	}
-	if (pci_request_selected_regions(pdev, ioc->bars, "mpt")) {
-		printk(MYIOC_s_ERR_FMT "pci_request_selected_regions() with "
-		       "MEM failed\n", ioc->name);
-		kfree(ioc);
-		return r;
-	}
+	/*
+	 * set initial debug level
+	 * (refer to mptdebug.h)
+	 *
+	 */
+	ioc->debug_level = mpt_debug_level;
+	if (mpt_debug_level)
+		printk(KERN_INFO "mpt_debug_level=%xh\n", mpt_debug_level);
 
 	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT ": mpt_adapter_install\n", ioc->name));
 
-	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
-		dprintk(ioc, printk(MYIOC_s_INFO_FMT
-			": 64 BIT PCI BUS DMA ADDRESSING SUPPORTED\n", ioc->name));
-	} else if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
-		printk(MYIOC_s_WARN_FMT ": 32 BIT PCI BUS DMA ADDRESSING NOT SUPPORTED\n",
-		    ioc->name);
+	ioc->pcidev = pdev;
+	if (mpt_mapresources(ioc)) {
 		kfree(ioc);
 		return r;
 	}
 
-	if (!pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK)) {
-		dprintk(ioc, printk(MYIOC_s_INFO_FMT
-			": Using 64 bit consistent mask\n", ioc->name));
-	} else {
-		dprintk(ioc, printk(MYIOC_s_INFO_FMT
-			": Not using 64 bit consistent mask\n", ioc->name));
-	}
-
 	ioc->alloc_total = sizeof(MPT_ADAPTER);
 	ioc->req_sz = MPT_DEFAULT_FRAME_SIZE;		/* avoid div by zero! */
 	ioc->reply_sz = MPT_REPLY_FRAME_SIZE;
@@ -1551,48 +1616,9 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* Find lookup slot. */
 	INIT_LIST_HEAD(&ioc->list);
 
-	mem_phys = msize = 0;
-	port = psize = 0;
-	for (ii=0; ii < DEVICE_COUNT_RESOURCE; ii++) {
-		if (pci_resource_flags(pdev, ii) & PCI_BASE_ADDRESS_SPACE_IO) {
-			if (psize)
-				continue;
-			/* Get I/O space! */
-			port = pci_resource_start(pdev, ii);
-			psize = pci_resource_len(pdev,ii);
-		} else {
-			if (msize)
-				continue;
-			/* Get memmap */
-			mem_phys = pci_resource_start(pdev, ii);
-			msize = pci_resource_len(pdev,ii);
-		}
-	}
-	ioc->mem_size = msize;
-
-	mem = NULL;
-	/* Get logical ptr for PciMem0 space */
-	/*mem = ioremap(mem_phys, msize);*/
-	mem = ioremap(mem_phys, msize);
-	if (mem == NULL) {
-		printk(MYIOC_s_ERR_FMT "Unable to map adapter memory!\n", ioc->name);
-		kfree(ioc);
-		return -EINVAL;
-	}
-	ioc->memmap = mem;
-	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "mem = %p, mem_phys = %lx\n", ioc->name, mem, mem_phys));
-
 	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "facts @ %p, pfacts[0] @ %p\n",
 	    ioc->name, &ioc->facts, &ioc->pfacts[0]));
 
-	ioc->mem_phys = mem_phys;
-	ioc->chip = (SYSIF_REGS __iomem *)mem;
-
-	/* Save Port IO values in case we need to do downloadboot */
-	ioc->pio_mem_phys = port;
-	pmem = (u8 __iomem *)port;
-	ioc->pio_chip = (SYSIF_REGS __iomem *)pmem;
-
 	pci_read_config_byte(pdev, PCI_CLASS_REVISION, &revision);
 	mpt_get_product_name(pdev->vendor, pdev->device, revision, ioc->prod_name);
 
@@ -1688,7 +1714,9 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 		list_del(&ioc->list);
 		if (ioc->alt_ioc)
 			ioc->alt_ioc->alt_ioc = NULL;
-		iounmap(mem);
+		iounmap(ioc->memmap);
+		if (r != -5)
+			pci_release_selected_regions(pdev, ioc->bars);
 		kfree(ioc);
 		pci_set_drvdata(pdev, NULL);
 		return r;
@@ -1784,13 +1812,10 @@ mpt_suspend(struct pci_dev *pdev, pm_message_t state)
 	u32 device_state;
 	MPT_ADAPTER *ioc = pci_get_drvdata(pdev);
 
-	device_state=pci_choose_state(pdev, state);
-
-	printk(MYIOC_s_INFO_FMT
-	"pci-suspend: pdev=0x%p, slot=%s, Entering operating state [D%d]\n",
-		ioc->name, pdev, pci_name(pdev), device_state);
-
-	pci_save_state(pdev);
+	device_state = pci_choose_state(pdev, state);
+	printk(MYIOC_s_INFO_FMT "pci-suspend: pdev=0x%p, slot=%s, Entering "
+	    "operating state [D%d]\n", ioc->name, pdev, pci_name(pdev),
+	    device_state);
 
 	/* put ioc into READY_STATE */
 	if(SendIocReset(ioc, MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET, CAN_SLEEP)) {
@@ -1805,10 +1830,14 @@ mpt_suspend(struct pci_dev *pdev, pm_message_t state)
 	/* Clear any lingering interrupt */
 	CHIPREG_WRITE32(&ioc->chip->IntStatus, 0);
 
+	free_irq(ioc->pci_irq, ioc);
+	if (mpt_msi_enable)
+		pci_disable_msi(ioc->pcidev);
+	ioc->pci_irq = -1;
+	pci_save_state(pdev);
 	pci_disable_device(pdev);
 	pci_release_selected_regions(pdev, ioc->bars);
 	pci_set_power_state(pdev, device_state);
-
 	return 0;
 }
 
@@ -1823,48 +1852,54 @@ mpt_resume(struct pci_dev *pdev)
 	MPT_ADAPTER *ioc = pci_get_drvdata(pdev);
 	u32 device_state = pdev->current_state;
 	int recovery_state;
+	int err;
 
-	printk(MYIOC_s_INFO_FMT
-	"pci-resume: pdev=0x%p, slot=%s, Previous operating state [D%d]\n",
-		ioc->name, pdev, pci_name(pdev), device_state);
+	printk(MYIOC_s_INFO_FMT "pci-resume: pdev=0x%p, slot=%s, Previous "
+	    "operating state [D%d]\n", ioc->name, pdev, pci_name(pdev),
+	    device_state);
 
-	pci_set_power_state(pdev, 0);
+	pci_set_power_state(pdev, PCI_D0);
+	pci_enable_wake(pdev, PCI_D0, 0);
 	pci_restore_state(pdev);
-	if (ioc->facts.Flags & MPI_IOCFACTS_FLAGS_FW_DOWNLOAD_BOOT) {
-		ioc->bars = pci_select_bars(ioc->pcidev, IORESOURCE_MEM |
-			IORESOURCE_IO);
-		if (pci_enable_device(pdev))
-			return 0;
-	} else {
-		ioc->bars = pci_select_bars(pdev, IORESOURCE_MEM);
-		if (pci_enable_device_mem(pdev))
-			return 0;
-	}
-	if (pci_request_selected_regions(pdev, ioc->bars, "mpt"))
-		return 0;
+	ioc->pcidev = pdev;
+	err = mpt_mapresources(ioc);
+	if (err)
+		return err;
 
-	/* enable interrupts */
-	CHIPREG_WRITE32(&ioc->chip->IntMask, MPI_HIM_DIM);
-	ioc->active = 1;
+	printk(MYIOC_s_INFO_FMT "pci-resume: ioc-state=0x%x,doorbell=0x%x\n",
+	    ioc->name, (mpt_GetIocState(ioc, 1) >> MPI_IOC_STATE_SHIFT),
+	    CHIPREG_READ32(&ioc->chip->Doorbell));
 
-	printk(MYIOC_s_INFO_FMT
-		"pci-resume: ioc-state=0x%x,doorbell=0x%x\n",
-		ioc->name,
-		(mpt_GetIocState(ioc, 1) >> MPI_IOC_STATE_SHIFT),
-		CHIPREG_READ32(&ioc->chip->Doorbell));
+	/*
+	 * Errata workaround for SAS pci express:
+	 * Upon returning to the D0 state, the contents of the doorbell will be
+	 * stale data, and this will incorrectly signal to the host driver that
+	 * the firmware is ready to process mpt commands.   The workaround is
+	 * to issue a diagnostic reset.
+	 */
+	if (ioc->bus_type == SAS && (pdev->device ==
+	    MPI_MANUFACTPAGE_DEVID_SAS1068E || pdev->device ==
+	    MPI_MANUFACTPAGE_DEVID_SAS1064E)) {
+		if (KickStart(ioc, 1, CAN_SLEEP) < 0) {
+			printk(MYIOC_s_WARN_FMT "pci-resume: Cannot recover\n",
+			    ioc->name);
+			goto out;
+		}
+	}
 
 	/* bring ioc to operational state */
-	if ((recovery_state = mpt_do_ioc_recovery(ioc,
-	    MPT_HOSTEVENT_IOC_RECOVER, CAN_SLEEP)) != 0) {
-		printk(MYIOC_s_INFO_FMT
-			"pci-resume: Cannot recover, error:[%x]\n",
-			ioc->name, recovery_state);
-	} else {
+	printk(MYIOC_s_INFO_FMT "Sending mpt_do_ioc_recovery\n", ioc->name);
+	recovery_state = mpt_do_ioc_recovery(ioc, MPT_HOSTEVENT_IOC_BRINGUP,
+						 CAN_SLEEP);
+	if (recovery_state != 0)
+		printk(MYIOC_s_WARN_FMT "pci-resume: Cannot recover, "
+		    "error:[%x]\n", ioc->name, recovery_state);
+	else
 		printk(MYIOC_s_INFO_FMT
-			"pci-resume: success\n", ioc->name);
-	}
-
+		    "pci-resume: success\n", ioc->name);
+ out:
 	return 0;
+
 }
 #endif
 
@@ -1903,6 +1938,7 @@ mpt_signal_reset(u8 index, MPT_ADAPTER *ioc, int reset_phase)
  *		-3 if READY but PrimeIOCFifos Failed
  *		-4 if READY but IOCInit Failed
  *		-5 if failed to enable_device and/or request_selected_regions
+ *		-6 if failed to upload firmware
  */
 static int
 mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
@@ -2097,7 +2133,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
 				} else {
 					printk(MYIOC_s_WARN_FMT
 					    "firmware upload failure!\n", ioc->name);
-					ret = -5;
+					ret = -6;
 				}
 			}
 		}
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 0c252f6..c207bda 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1170,6 +1170,10 @@ mptscsih_shutdown(struct pci_dev *pdev)
 int
 mptscsih_suspend(struct pci_dev *pdev, pm_message_t state)
 {
+	MPT_ADAPTER 		*ioc = pci_get_drvdata(pdev);
+
+	scsi_block_requests(ioc->sh);
+	flush_scheduled_work();
 	mptscsih_shutdown(pdev);
 	return mpt_suspend(pdev,state);
 }
@@ -1183,7 +1187,12 @@ mptscsih_suspend(struct pci_dev *pdev, pm_message_t state)
 int
 mptscsih_resume(struct pci_dev *pdev)
 {
-	return mpt_resume(pdev);
+	MPT_ADAPTER 		*ioc = pci_get_drvdata(pdev);
+	int rc;
+
+	rc = mpt_resume(pdev);
+	scsi_unblock_requests(ioc->sh);
+	return rc;
 }
 
 #endif
-- 
1.5.4.1




