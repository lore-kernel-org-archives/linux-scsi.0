From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: [PATCH] 2.6.2-rc2 - MPT Fusion driver 3.00.02 update
Date: Mon, 26 Jan 2004 11:37:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5703D19D2F@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:10186 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S264284AbUAZQiI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jan 2004 11:38:08 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@steeleye.com, hch@infradead.org

Here is another update for the MPT Fusion drivers.

Here is list of fix's.
* added new PCI API support
* added ACPI support
* added CONFIG_LBA, READ16, WRITE16 support
* underun fix
* chain buffer free list not being init properly
* reduce task management 
	(abort=2sec,reset bus=5sec, timeout=10sec)
* Hot plug fix's requested from Christoph Hellwig, and several
others from the linux-scsi@ list.


Here's location of patches and full source.
ftp://ftp.lsil.com/HostAdapterDrivers/linux/Fusion-MPT/2.6-patches/




diff -uarN linux-2.6.2-rc1-reference/drivers/message/fusion/mptbase.c
linux-2.6.2-rc1/drivers/message/fusion/mptbase.c
--- linux-2.6.2-rc1-reference/drivers/message/fusion/mptbase.c	2004-01-24
00:17:20.525861896 -0700
+++ linux-2.6.2-rc1/drivers/message/fusion/mptbase.c	2004-01-23
23:52:15.000000000 -0700
@@ -167,6 +167,7 @@
 static MPT_EVHANDLER		 MptEvHandlers[MPT_MAX_PROTOCOL_DRIVERS];
 					/* Reset handler lookup table */
 static MPT_RESETHANDLER
MptResetHandlers[MPT_MAX_PROTOCOL_DRIVERS];
+static struct mpt_pci_driver
*MptDeviceDriverHandlers[MPT_MAX_PROTOCOL_DRIVERS];
 
 static int	FusionInitCalled = 0;
 static int	mpt_base_index = -1;
@@ -183,7 +184,6 @@
 static int	mpt_base_reply(MPT_ADAPTER *ioc, MPT_FRAME_HDR *req,
MPT_FRAME_HDR *reply);
 
 static int	mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int
sleepFlag);
-static int	mpt_adapter_install(struct pci_dev *pdev);
 static void	mpt_detect_bound_ports(MPT_ADAPTER *this, struct pci_dev
*pdev);
 static void	mpt_adapter_disable(MPT_ADAPTER *ioc, int freeup);
 static void	mpt_adapter_dispose(MPT_ADAPTER *ioc);
@@ -232,8 +232,12 @@
 static void	mpt_fc_log_info(MPT_ADAPTER *ioc, u32 log_info);
 static void	mpt_sp_log_info(MPT_ADAPTER *ioc, u32 log_info);
 
-int		fusion_init(void);
-static void	fusion_exit(void);
+/* module entry point */
+static int  __devinit mptbase_probe (struct pci_dev *, const struct
pci_device_id *);
+static void __devexit mptbase_remove(struct pci_dev *);
+static void mptbase_shutdown(struct device * );
+static int  __init    fusion_init  (void);
+static void __exit    fusion_exit  (void);
 
 
/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
=*/
 /*
@@ -260,6 +264,30 @@
 
 #endif
 
+/**************************************************************************
**
+ * Supported hardware
+ */
+
+static struct pci_device_id mptbase_pci_table[] = {
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_FC909,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_FC929,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_FC919,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_FC929X,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_FC919X,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_53C1030,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_1030_53C1035,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{0}	/* Terminating entry */
+};
+MODULE_DEVICE_TABLE(pci, mptbase_pci_table);
+
+
 
/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
=*/
 /* 20000207 -sralston
  *  GRRRRR...  IOSpace (port i/o) register access (for the 909) is back!
@@ -518,7 +546,7 @@
  *	@mf: Pointer to original MPT request frame
  *	@reply: Pointer to MPT reply frame (NULL if TurboReply)
  *
- *	Returns 1 indicating original alloc'd request frame ptr
+	*	Returns 1 indicating original alloc'd request frame ptr
  *	should be freed, or 0 if it shouldn't.
  */
 static int
@@ -805,6 +833,34 @@
 
 
/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
=*/
 /**
+ *	mpt_device_driver_register - Register device driver hooks
+ */
+int
+mpt_device_driver_register(struct mpt_pci_driver * dd_cbfunc, int cb_idx)
+{
+	if (cb_idx < 1 || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS)
+		return -1;
+
+	MptDeviceDriverHandlers[cb_idx] = dd_cbfunc;
+	return 0;
+}
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-=*/
+/**
+ *	mpt_device_driver_deregister - DeRegister device driver hooks
+ */
+void
+mpt_device_driver_deregister(int cb_idx)
+{
+	if (cb_idx < 1 || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS)
+		return;
+
+	MptDeviceDriverHandlers[cb_idx] = NULL;
+}
+
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-=*/
+/**
  *	mpt_get_msg_frame - Obtain a MPT request frame from the pool (of
1024)
  *	allocated per MPT adapter.
  *	@handle: Handle of registered MPT protocol driver
@@ -1142,88 +1198,6 @@
 	return next;
 }
 
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-=*/
-/*
- *	mpt_pci_scan - Scan PCI devices for MPT adapters.
- *
- *	Returns count of MPT adapters found, keying off of PCI vendor and
- *	device_id's.
- */
-static int __init
-mpt_pci_scan(void)
-{
-	struct pci_dev *pdev = NULL;
-	struct pci_dev *pdev2;
-	int found = 0;
-	int count = 0;
-	int r;
-
-	dprintk((KERN_INFO MYNAM ": Checking for MPT adapters...\n"));
-
-	/*
-	 *  NOTE: The 929, 929X, 1030 and 1035 will appear as 2 separate PCI
devices,
-	 *  one for each channel.
-	 */
-	while ((pdev = pci_find_device(PCI_VENDOR_ID_LSI_LOGIC, PCI_ANY_ID,
pdev)) != NULL) {
-		pdev2 = NULL;
-		if ((pdev->device != MPI_MANUFACTPAGE_DEVICEID_FC909) &&
-		    (pdev->device != MPI_MANUFACTPAGE_DEVICEID_FC929) &&
-		    (pdev->device != MPI_MANUFACTPAGE_DEVICEID_FC919) &&
-		    (pdev->device != MPI_MANUFACTPAGE_DEVICEID_FC929X) &&
-		    (pdev->device != MPI_MANUFACTPAGE_DEVICEID_FC919X) &&
-		    (pdev->device != MPI_MANUFACTPAGE_DEVID_53C1030) &&
-		    (pdev->device != MPI_MANUFACTPAGE_DEVID_1030_53C1035) &&
-		    1) {
-			dprintk((KERN_INFO MYNAM ": Skipping LSI
device=%04xh\n", pdev->device));
-			continue;
-		}
-
-		/* GRRRRR
-		 * dual function devices (929, 929X, 1030, 1035) may be
presented in Func 1,0 order,
-		 * but we'd really really rather have them in Func 0,1
order.
-		 * Do some kind of look ahead here...
-		 */
-		if (pdev->devfn & 1) {
-			pdev2 = pci_find_device(PCI_ANY_ID, PCI_ANY_ID,
pdev);
-			if (pdev2 && (pdev2->vendor == 0x1000) &&
-			    (PCI_SLOT(pdev2->devfn) ==
PCI_SLOT(pdev->devfn)) &&
-			    (pdev2->device == pdev->device) &&
-			    (pdev2->bus->number == pdev->bus->number) &&
-			    !(pdev2->devfn & 1)) {
-				dprintk((KERN_INFO MYNAM ": MPT adapter
found: PCI bus/dfn=%02x/%02xh, class=%08x, id=%xh\n",
-					pdev2->bus->number, pdev2->devfn,
pdev2->class, pdev2->device));
-				found++;
-				if ((r = mpt_adapter_install(pdev2)) == 0)
-					count++;
-			} else {
-				pdev2 = NULL;
-			}
-		}
-
-		dprintk((KERN_INFO MYNAM ": MPT adapter found: PCI
bus/dfn=%02x/%02xh, class=%08x, id=%xh\n",
-			 pdev->bus->number, pdev->devfn, pdev->class,
pdev->device));
-		found++;
-		if ((r = mpt_adapter_install(pdev)) == 0)
-			count++;
-
-		if (pdev2)
-			pdev = pdev2;
-	}
-
-	printk(KERN_INFO MYNAM ": %d MPT adapter%s found, %d installed.\n",
-		 found, (found==1) ? "" : "s", count);
-
-	if (!found || !count) {
-		fusion_exit();
-		return -ENODEV;
-	}
-
-#ifdef CONFIG_PROC_FS
-	(void) procmpt_create();
-#endif
-
-	return count;
-}
 
 
/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
=*/
 /**
@@ -1253,7 +1227,7 @@
 
 
/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
=*/
 /*
- *	mpt_adapter_install - Install a PCI intelligent MPT adapter.
+ *	mptbase_probe - Install a PCI intelligent MPT adapter.
  *	@pdev: Pointer to pci_dev structure
  *
  *	This routine performs all the steps necessary to bring the IOC of
@@ -1268,8 +1242,8 @@
  *
  *	TODO: Add support for polled controllers
  */
-static int __init
-mpt_adapter_install(struct pci_dev *pdev)
+static int __devinit
+mptbase_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	MPT_ADAPTER	*ioc;
 	u8		*mem;
@@ -1292,6 +1266,13 @@
 		return r;
 	}
 
+	if (!pci_set_consistent_dma_mask(pdev, mask))
+		dprintk((KERN_INFO MYNAM
+			": Using 64 bit consistent mask\n"));
+	else
+		dprintk((KERN_INFO MYNAM
+			": Not using 64 bit consistent mask\n"));
+
 	ioc = kmalloc(sizeof(MPT_ADAPTER), GFP_ATOMIC);
 	if (ioc == NULL) {
 		printk(KERN_ERR MYNAM ": ERROR - Insufficient memory to add
adapter!\n");
@@ -1500,6 +1481,7 @@
 		ioc->pci_irq = pdev->irq;
 
 		pci_set_master(pdev);			/* ?? */
+		pci_set_drvdata(pdev, ioc);
 
 #ifndef __sparc__
 		dprintk((KERN_INFO MYNAM ": %s installed at interrupt %d\n",
ioc->name, pdev->irq));
@@ -1520,11 +1502,209 @@
 				ioc->name, r);
 	}
 
-	return r;
+	if(r != 0 )
+		return r;
+
+
+	/* call per device driver probe entry point */
+	for(ii=0; ii<MPT_MAX_PROTOCOL_DRIVERS; ii++) {
+		if(MptDeviceDriverHandlers[ii] &&
+		  MptDeviceDriverHandlers[ii]->probe) {
+			MptDeviceDriverHandlers[ii]->probe(pdev,id);
+		}
+	}
+
+	return 0;
+}
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-=*/
+/*
+ *	mptbase_remove - Remove a PCI intelligent MPT adapter.
+ *	@pdev: Pointer to pci_dev structure
+ *
+ */
+
+static void __devexit
+mptbase_remove(struct pci_dev *pdev)
+{
+	MPT_ADAPTER 	*ioc = pci_get_drvdata(pdev);
+	int ii;
+
+	/* call per device driver remove entry point */
+	for(ii=0; ii<MPT_MAX_PROTOCOL_DRIVERS; ii++) {
+		if(MptDeviceDriverHandlers[ii] &&
+		  MptDeviceDriverHandlers[ii]->remove) {
+			MptDeviceDriverHandlers[ii]->remove(pdev);
+		}
+	}
+
+	/* Disable interrupts! */
+	CHIPREG_WRITE32(&ioc->chip->IntMask, 0xFFFFFFFF);
+
+	ioc->active = 0;
+
+	/* Clear any lingering interrupt */
+	CHIPREG_WRITE32(&ioc->chip->IntStatus, 0);
+
+	CHIPREG_READ32(&ioc->chip->IntStatus);
+
+	Q_DEL_ITEM(ioc);
+	mpt_adapter_dispose(ioc);
+
+	mptscsih_sync_irq(ioc->irq);
+	pci_set_drvdata(pdev, NULL);
 }
 
 
/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
=*/
 /*
+ *	mptbase_shutdown -
+ *
+ */
+static void
+mptbase_shutdown(struct device * dev)
+{
+	int ii;
+
+	/* call per device driver shutdown entry point */
+	for(ii=0; ii<MPT_MAX_PROTOCOL_DRIVERS; ii++) {
+		if(MptDeviceDriverHandlers[ii] &&
+		  MptDeviceDriverHandlers[ii]->shutdown) {
+			MptDeviceDriverHandlers[ii]->shutdown(dev);
+		}
+	}
+
+}
+
+
+/**************************************************************************
+ * Power Management
+ */
+#ifdef CONFIG_PM
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-=*/
+/*
+ *	mptbase_suspend - Fusion MPT base driver suspend routine.
+ *
+ *
+ */
+static int
+mptbase_suspend(struct pci_dev *pdev, u32 state)
+{
+	u32 device_state;
+	MPT_ADAPTER *ioc = pci_get_drvdata(pdev);
+	int ii;
+
+	switch(state)
+	{
+		case 1: /* S1 */
+			device_state=1; /* D1 */;
+			break;
+		case 3: /* S3 */
+		case 4: /* S4 */
+			device_state=3; /* D3 */;
+			break;
+		default:
+			return -EAGAIN /*FIXME*/;
+			break;
+	}
+
+	printk(MYIOC_s_INFO_FMT
+	"pci-suspend: pdev=0x%p, slot=%s, Entering operating state [D%d]\n",
+		ioc->name, pdev, pci_name(pdev), device_state);
+
+	/* call per device driver suspend entry point */
+	for(ii=0; ii<MPT_MAX_PROTOCOL_DRIVERS; ii++) {
+		if(MptDeviceDriverHandlers[ii] &&
+		  MptDeviceDriverHandlers[ii]->suspend) {
+			MptDeviceDriverHandlers[ii]->suspend(pdev, state);
+		}
+	}
+
+	pci_save_state(pdev, ioc->PciState);
+
+	/* put ioc into READY_STATE */
+	if(SendIocReset(ioc, MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET,
CAN_SLEEP)) {
+		printk(MYIOC_s_ERR_FMT
+		"pci-suspend:  IOC msg unit reset failed!\n", ioc->name);
+	}
+
+	/* disable interrupts */
+	CHIPREG_WRITE32(&ioc->chip->IntMask, 0xFFFFFFFF);
+	ioc->active = 0;
+
+	/* Clear any lingering interrupt */
+	CHIPREG_WRITE32(&ioc->chip->IntStatus, 0);
+
+	pci_disable_device(pdev);
+	pci_set_power_state(pdev, device_state);
+
+	return 0;
+}
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-=*/
+/*
+ *	mptbase_resume - Fusion MPT base driver resume routine.
+ *
+ *
+ */
+static int
+mptbase_resume(struct pci_dev *pdev)
+{
+	MPT_ADAPTER *ioc = pci_get_drvdata(pdev);
+	u32 device_state = pdev->current_state;
+	int recovery_state;
+	int ii;
+
+	printk(MYIOC_s_INFO_FMT
+	"pci-resume: pdev=0x%p, slot=%s, Previous operating state [D%d]\n",
+		ioc->name, pdev, pci_name(pdev), device_state);
+
+	pci_set_power_state(pdev, 0);
+	pci_restore_state(pdev, ioc->PciState);
+	pci_enable_device(pdev);
+
+	/* enable interrupts */
+	CHIPREG_WRITE32(&ioc->chip->IntMask, ~(MPI_HIM_RIM));
+	ioc->active = 1;
+
+	/* F/W not running */
+	if(!CHIPREG_READ32(&ioc->chip->Doorbell)) {
+		/* enable domain validation flags */
+		for (ii=0; ii < MPT_MAX_SCSI_DEVICES; ii++) {
+			ioc->spi_data.dvStatus[ii] |= MPT_SCSICFG_NEED_DV;
+		}
+	}
+
+	printk(MYIOC_s_INFO_FMT
+		"pci-resume: ioc-state=0x%x,doorbell=0x%x\n",
+		ioc->name,
+		(mpt_GetIocState(ioc, 1) >> MPI_IOC_STATE_SHIFT),
+		CHIPREG_READ32(&ioc->chip->Doorbell));
+
+	/* bring ioc to operational state */
+	if ((recovery_state = mpt_do_ioc_recovery(ioc,
+	    MPT_HOSTEVENT_IOC_RECOVER, CAN_SLEEP)) != 0) {
+		printk(MYIOC_s_INFO_FMT
+			"pci-resume: Cannot recover, error:[%x]\n",
+			ioc->name, recovery_state);
+	} else {
+		printk(MYIOC_s_INFO_FMT
+			"pci-resume: success\n", ioc->name);
+	}
+
+	/* call per device driver resume entry point */
+	for(ii=0; ii<MPT_MAX_PROTOCOL_DRIVERS; ii++) {
+		if(MptDeviceDriverHandlers[ii] &&
+		  MptDeviceDriverHandlers[ii]->resume) {
+			MptDeviceDriverHandlers[ii]->resume(pdev);
+		}
+	}
+
+	return 0;
+}
+#endif
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-=*/
+/*
  *	mpt_do_ioc_recovery - Initialize or recover MPT adapter.
  *	@ioc: Pointer to MPT adapter structure
  *	@reason: Event word / reason
@@ -5851,6 +6031,8 @@
 EXPORT_SYMBOL(mpt_event_deregister);
 EXPORT_SYMBOL(mpt_reset_register);
 EXPORT_SYMBOL(mpt_reset_deregister);
+EXPORT_SYMBOL(mpt_device_driver_register);
+EXPORT_SYMBOL(mpt_device_driver_deregister);
 EXPORT_SYMBOL(mpt_get_msg_frame);
 EXPORT_SYMBOL(mpt_put_msg_frame);
 EXPORT_SYMBOL(mpt_free_msg_frame);
@@ -5877,16 +6059,32 @@
 EXPORT_SYMBOL(mpt_ASCQ_TableSz);
 EXPORT_SYMBOL(mpt_ScsiOpcodesPtr);
 
+
+static struct pci_driver mptbase_driver = {
+	.name		= "mptbase",
+	.id_table	= mptbase_pci_table,
+	.probe		= mptbase_probe,
+	.remove		= __devexit_p(mptbase_remove),
+	.driver         = {
+		.shutdown = mptbase_shutdown,
+        },
+#ifdef CONFIG_PM
+	.suspend	= mptbase_suspend,
+	.resume		= mptbase_resume,
+#endif
+};
+
 
/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
=*/
 /*
  *	fusion_init - Fusion MPT base driver initialization routine.
  *
  *	Returns 0 for success, non-zero for failure.
  */
-int __init
+static int __init
 fusion_init(void)
 {
 	int i;
+	int r;
 
 	if (FusionInitCalled++) {
 		dprintk((KERN_INFO MYNAM ": INFO - Driver late-init entry
point called\n"));
@@ -5920,10 +6118,15 @@
 		/* FIXME! */
 	}
 
-	if ((i = mpt_pci_scan()) < 0)
-		return i;
+	r = pci_module_init(&mptbase_driver);
+	if(r)
+		return(r);
 
-	return 0;
+#ifdef CONFIG_PROC_FS
+	(void) procmpt_create();
+#endif
+
+	return r;
 }
 
 
/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
=*/
@@ -5933,13 +6136,12 @@
  *	This routine frees all resources associated with each MPT adapter
  *	and removes all %MPT_PROCFS_MPTBASEDIR entries.
  */
-static void
+static void __exit
 fusion_exit(void)
 {
-	MPT_ADAPTER *this;
-	struct pci_dev *pdev = NULL;
 
 	dprintk((KERN_INFO MYNAM ": fusion_exit() called!\n"));
+	pci_unregister_driver(&mptbase_driver);
 
 	/* Whups?  20010120 -sralston
 	 *  Moved this *above* removal of all MptAdapters!
@@ -5948,30 +6150,9 @@
 	(void) procmpt_destroy();
 #endif
 
-	while (! Q_IS_EMPTY(&MptAdapters)) {
-		this = MptAdapters.head;
-
-		/* Disable interrupts! */
-		CHIPREG_WRITE32(&this->chip->IntMask, 0xFFFFFFFF);
-
-		this->active = 0;
-
-		pdev = (struct pci_dev *)this->pcidev;
-		mptscsih_sync_irq(pdev->irq);
-
-		/* Clear any lingering interrupt */
-		CHIPREG_WRITE32(&this->chip->IntStatus, 0);
-
-		CHIPREG_READ32(&this->chip->IntStatus);
-
-		Q_DEL_ITEM(this);
-		mpt_adapter_dispose(this);
-	}
-
 	mpt_reset_deregister(mpt_base_index);
 }
 
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-=*/
 
 module_init(fusion_init);
 module_exit(fusion_exit);
diff -uarN linux-2.6.2-rc1-reference/drivers/message/fusion/mptbase.h
linux-2.6.2-rc1/drivers/message/fusion/mptbase.h
--- linux-2.6.2-rc1-reference/drivers/message/fusion/mptbase.h	2004-01-24
00:17:20.449873448 -0700
+++ linux-2.6.2-rc1/drivers/message/fusion/mptbase.h	2004-01-23
23:52:57.000000000 -0700
@@ -80,8 +80,8 @@
 #define COPYRIGHT	"Copyright (c) 1999-2003 " MODULEAUTHOR
 #endif
 
-#define MPT_LINUX_VERSION_COMMON	"2.05.00.06"
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-2.05.00.06"
+#define MPT_LINUX_VERSION_COMMON	"3.00.02"
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.00.02"
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"
 
 #define show_mptmod_ver(s,ver)  \
@@ -180,6 +180,16 @@
 	MPTUNKNOWN_DRIVER
 } MPT_DRIVER_CLASS;
 
+struct mpt_pci_driver{
+	int  (*probe) (struct pci_dev *dev, const struct pci_device_id *id);
+	void (*remove) (struct pci_dev *dev);
+	int  (*suspend) (struct pci_dev *dev, u32 state);
+#ifdef CONFIG_PM
+	int  (*resume) (struct pci_dev *dev);
+	void (*shutdown) (struct device * dev);
+#endif
+};
+
 /*
  *  MPT adapter / port / bus / device info structures...
  */
@@ -629,6 +639,9 @@
 	FCPortPage0_t		 fc_port_page0[2];
 	LANPage0_t		 lan_cnfg_page0;
 	LANPage1_t		 lan_cnfg_page1;
+#ifdef CONFIG_PM
+	u32           		 PciState[64];     /* save PCI state to this
area */
+#endif
 	u8			 FirstWhoInit;
 	u8			 upload_fw;	/* If set, do a fw upload */
 	u8			 reload_fw;	/* Force a FW Reload on next
reset */
@@ -1001,6 +1014,8 @@
 extern void	 mpt_event_deregister(int cb_idx);
 extern int	 mpt_reset_register(int cb_idx, MPT_RESETHANDLER
reset_func);
 extern void	 mpt_reset_deregister(int cb_idx);
+extern int	 mpt_device_driver_register(struct mpt_pci_driver *
dd_cbfunc, int cb_idx);
+extern void	 mpt_device_driver_deregister(int cb_idx);
 extern int	 mpt_register_ascqops_strings(void *ascqTable, int
ascqtbl_sz, const char **opsTable);
 extern void	 mpt_deregister_ascqops_strings(void);
 extern MPT_FRAME_HDR	*mpt_get_msg_frame(int handle, int iocid);
diff -uarN linux-2.6.2-rc1-reference/drivers/message/fusion/mptscsih.c
linux-2.6.2-rc1/drivers/message/fusion/mptscsih.c
--- linux-2.6.2-rc1-reference/drivers/message/fusion/mptscsih.c	2004-01-24
00:17:20.545858856 -0700
+++ linux-2.6.2-rc1/drivers/message/fusion/mptscsih.c	2004-01-23
23:49:18.000000000 -0700
@@ -75,7 +75,8 @@
 #include <linux/interrupt.h>	/* needed for in_interrupt() proto */
 #include <linux/reboot.h>	/* notifier code */
 #include "../../scsi/scsi.h"
-#include "../../scsi/hosts.h"
+#include <scsi/scsi_host.h>
+
 
 #include "mptbase.h"
 #include "mptscsih.h"
@@ -164,8 +165,8 @@
 static MPT_FRAME_HDR *mptscsih_search_pendingQ(MPT_SCSI_HOST *hd, int
scpnt_idx);
 static void	post_pendingQ_commands(MPT_SCSI_HOST *hd);
 
-static int	mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 target, u8
lun, int ctx2abort, int sleepFlag);
-static int	mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8
target, u8 lun, int ctx2abort, int sleepFlag);
+static int	mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 target, u8
lun, int ctx2abort, ulong timeout, int sleepFlag);
+static int	mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8
target, u8 lun, int ctx2abort, ulong timeout, int sleepFlag);
 
 static int	mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset);
 static int	mptscsih_event_process(MPT_ADAPTER *ioc,
EventNotificationReply_t *pEvReply);
@@ -184,7 +185,7 @@
 
 static struct mpt_work_struct   mptscsih_rstTask;
 
-#ifndef MPTSCSIH_DISABLE_DOMAIN_VALIDATION
+#ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
 static int	mptscsih_do_raid(MPT_SCSI_HOST *hd, u8 action, INTERNAL_CMD
*io);
 static void	mptscsih_domainValidation(void *hd);
 static int	mptscsih_is_phys_disk(MPT_ADAPTER *ioc, int id);
@@ -194,14 +195,19 @@
 static void	mptscsih_fillbuf(char *buffer, int size, int index, int
width);
 #endif
 static int	mptscsih_setup(char *str);
-static int	mptscsih_halt(struct notifier_block *nb, ulong event, void
*buf);
 
-/*
- *	Reboot Notification
- */
-static struct notifier_block mptscsih_notifier = {
-	mptscsih_halt, NULL, 0
-};
+/* module entry point */
+static int  __init    mptscsih_init  (void);
+static void __exit    mptscsih_exit  (void);
+
+static int  __devinit mptscsih_probe (struct pci_dev *, const struct
pci_device_id *);
+static void __devexit mptscsih_remove(struct pci_dev *);
+static void mptscsih_shutdown(struct device *);
+#ifdef CONFIG_PM
+static int mptscsih_suspend(struct pci_dev *pdev, u32 state);
+static int mptscsih_resume(struct pci_dev *pdev);
+#endif
+
 
 /*
  *	Private data...
@@ -216,7 +222,7 @@
 
 #define SNS_LEN(scp)	sizeof((scp)->sense_buffer)
 
-#ifndef MPTSCSIH_DISABLE_DOMAIN_VALIDATION
+#ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
 /*
  * Domain Validation task structure
  */
@@ -238,6 +244,32 @@
 	driver_setup = MPTSCSIH_DRIVER_SETUP;
 
 
/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
=*/
+
+/* see mptscsih.h */
+
+static struct scsi_host_template driver_template = {
+	.proc_name			= "mptscsih",
+	.proc_info			= x_scsi_proc_info,
+	.name				= "MPT SCSI Host",
+	.info				= x_scsi_info,
+	.queuecommand			= x_scsi_queuecommand,
+	.slave_alloc			= x_scsi_slave_alloc,
+	.slave_configure		= x_scsi_slave_configure,
+	.slave_destroy			= x_scsi_slave_destroy,
+	.eh_abort_handler		= x_scsi_abort,
+	.eh_device_reset_handler	= x_scsi_dev_reset,
+	.eh_bus_reset_handler		= x_scsi_bus_reset,
+	.eh_host_reset_handler		= x_scsi_host_reset,
+	.bios_param			= x_scsi_bios_param,
+	.can_queue			= MPT_SCSI_CAN_QUEUE,
+	.this_id			= -1,
+	.sg_tablesize			= MPT_SCSI_SG_DEPTH,
+	.max_sectors			= MPT_SCSI_MAX_SECTORS,
+	.cmd_per_lun			= MPT_SCSI_CMD_PER_LUN,
+	.use_clustering			= ENABLE_CLUSTERING,
+};
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-=*/
 /*
  *  Private inline routines...
  */
@@ -264,12 +296,14 @@
 mptscsih_io_direction(Scsi_Cmnd *cmd)
 {
 	switch (cmd->cmnd[0]) {
-	case WRITE_6:		
-	case WRITE_10:		
+	case WRITE_6:
+	case WRITE_10:
+	case WRITE_16:
 		return SCSI_DATA_WRITE;
 		break;
-	case READ_6:		
-	case READ_10:		
+	case READ_6:
+	case READ_10:
+	case READ_16:
 		return SCSI_DATA_READ;
 		break;
 	}
@@ -280,6 +314,7 @@
 	switch (cmd->cmnd[0]) {
 	/*  _DATA_OUT commands	*/
 	case WRITE_6:		case WRITE_10:		case WRITE_12:
+	case WRITE_16:
 	case WRITE_LONG:	case WRITE_SAME:	case WRITE_BUFFER:
 	case WRITE_VERIFY:	case WRITE_VERIFY_12:
 	case COMPARE:		case COPY:		case COPY_VERIFY:
@@ -826,6 +861,13 @@
 			sc->resid = sc->request_bufflen - xfer_cnt;
 			dprintk((KERN_NOTICE "  SET sc->resid=%02xh\n",
sc->resid));
 
+			if(sc->underflow > xfer_cnt) {
+				printk(MYIOC_s_INFO_FMT
+				"SCSI data underrun: underflow=%02x,
xfercnt=%02x\n",
+				ioc->name, sc->underflow, xfer_cnt);
+				sc->result = DID_SOFT_ERROR << 16;
+			}
+
 			/* Report Queue Full
 			 */
 			if (sc->result == MPI_SCSI_STATUS_TASK_SET_FULL)
@@ -1235,7 +1277,6 @@
 	for(ii=0;ii<hd->ioc->req_depth;ii++)
 		hd->ReqToChain[ii] = MPT_HOST_NO_CHAIN;
 
-
 	/* ChainToChain size must equal the total number
 	 * of chain buffers to be allocated.
 	 * index = chain_idx
@@ -1277,7 +1318,6 @@
 		mem = (u8 *) hd->ChainToChain;
 	}
 	memset(mem, 0xFF, sz);
-
 	sz = num_chain * hd->ioc->req_sz;
 	if (hd->ChainBuffer == NULL) {
 		/* Allocate free chain buffer pool
@@ -1353,28 +1393,25 @@
 }
 
 
/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
=*/
-static int BeenHereDoneThat = 0;
 static char *info_kbuf = NULL;
 
-/*  SCSI host fops start here...  */
 
/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
=*/
-/**
- *	mptscsih_detect - Register MPT adapter(s) as SCSI host(s) with
- *	linux scsi mid-layer.
- *	@tpnt: Pointer to Scsi_Host_Template structure
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-=*/
+/*
+ *	mptscsih_probe - Installs scsi devices per bus.
+ *	@pdev: Pointer to pci_dev structure
  *
- *	(linux Scsi_Host_Template.detect routine)
+ *	Returns 0 for success, non-zero for failure.
  *
- *	Returns number of SCSI host adapters that were successfully
- *	registered with the linux scsi mid-layer via the scsi_register()
- *	API call.
  */
-int
-mptscsih_detect(Scsi_Host_Template *tpnt)
+
+static int  __devinit
+mptscsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct Scsi_Host	*sh = NULL;
 	MPT_SCSI_HOST		*hd = NULL;
-	MPT_ADAPTER		*this;
+	MPT_ADAPTER 		*ioc = pci_get_drvdata(pdev);
+	int			portnum;
 	MPT_DONE_Q		*freedoneQ;
 	unsigned long		 flags;
 	int			 sz, ii;
@@ -1382,325 +1419,312 @@
 	int			 scale;
 	u8			*mem;
 
-	if (! BeenHereDoneThat++) {
-		show_mptmod_ver(my_NAME, my_VERSION);
-
-		ScsiDoneCtx = mpt_register(mptscsih_io_done,
MPTSCSIH_DRIVER);
-		ScsiTaskCtx = mpt_register(mptscsih_taskmgmt_complete,
MPTSCSIH_DRIVER);
-		ScsiScanDvCtx = mpt_register(mptscsih_scandv_complete,
MPTSCSIH_DRIVER);
+	for (portnum=0; portnum < ioc->facts.NumberOfPorts; portnum++) {
 
-		if (mpt_event_register(ScsiDoneCtx, mptscsih_event_process)
== 0) {
-			dprintk((KERN_INFO MYNAM ": Registered for IOC event
notifications\n"));
-		} else {
-			/* FIXME! */
+		/* 20010215 -sralston
+		 *  Added sanity check on SCSI Initiator-mode enabled
+		 *  for this MPT adapter.
+		 */
+		if (!(ioc->pfacts[portnum].ProtocolFlags &
+		  MPI_PORTFACTS_PROTOCOL_INITIATOR)) {
+			printk(MYIOC_s_WARN_FMT
+			  "Skipping because SCSI Initiator mode is NOT
enabled!\n",
+			  ioc->name);
+			continue;
 		}
 
-		if (mpt_reset_register(ScsiDoneCtx, mptscsih_ioc_reset) ==
0) {
-			dprintk((KERN_INFO MYNAM ": Registered for IOC reset
notifications\n"));
-		} else {
-			/* FIXME! */
+		/* 20010202 -sralston
+		 *  Added sanity check on readiness of the MPT adapter.
+		 */
+		if (ioc->last_state != MPI_IOC_STATE_OPERATIONAL) {
+			printk(MYIOC_s_WARN_FMT
+			  "Skipping because it's not operational!\n",
+			  ioc->name);
+			continue;
 		}
-	}
-	dprintk((KERN_INFO MYNAM ": mpt_scsih_detect()\n"));
 
-#ifdef MODULE
-	/* Evaluate the command line arguments, if any */
-	if (mptscsih)
-		mptscsih_setup(mptscsih);
-#endif
+		sh = scsi_host_alloc(&driver_template,
sizeof(MPT_SCSI_HOST));
+		if (sh != NULL) {
+			spin_lock_irqsave(&ioc->FreeQlock, flags);
 
-	this = mpt_adapter_find_first();
-	while (this != NULL) {
-		int	 portnum;
-		for (portnum=0; portnum < this->facts.NumberOfPorts;
portnum++) {
-
-			/* 20010215 -sralston
-			 *  Added sanity check on SCSI Initiator-mode
enabled
-			 *  for this MPT adapter.
-			 */
-			if (!(this->pfacts[portnum].ProtocolFlags &
MPI_PORTFACTS_PROTOCOL_INITIATOR)) {
-				printk(MYIOC_s_WARN_FMT "Skipping because
SCSI Initiator mode is NOT enabled!\n",
-						this->name);
-				continue;
-			}
+			/* Attach the SCSI Host to the IOC structure
+			 */
+			ioc->sh = sh;
 
-			/* 20010202 -sralston
-			 *  Added sanity check on readiness of the MPT
adapter.
+			sh->io_port = 0;
+			sh->n_io_port = 0;
+			sh->irq = 0;
+
+			/* set 16 byte cdb's */
+			sh->max_cmd_len = 16;
+
+			/* Yikes!  This is important!
+			 * Otherwise, by default, linux
+			 * only scans target IDs 0-7!
+			 * pfactsN->MaxDevices unreliable
+			 * (not supported in early
+			 *	versions of the FW).
+			 * max_id = 1 + actual max id,
+			 * max_lun = 1 + actual last lun,
+			 *	see hosts.h :o(
 			 */
-			if (this->last_state != MPI_IOC_STATE_OPERATIONAL) {
-				printk(MYIOC_s_WARN_FMT "Skipping because
it's not operational!\n",
-						this->name);
-				continue;
+			if ((int)ioc->chip_type > (int)FC929) {
+				sh->max_id = MPT_MAX_SCSI_DEVICES;
+			} else {
+			/* For FC, increase the queue depth
+			 * from MPT_SCSI_CAN_QUEUE (31)
+			 * to MPT_FC_CAN_QUEUE (63).
+			 */
+				sh->can_queue = MPT_FC_CAN_QUEUE;
+				sh->max_id =
+				  MPT_MAX_FC_DEVICES<256 ?
MPT_MAX_FC_DEVICES : 255;
 			}
 
-			tpnt->proc_info = mptscsih_proc_info;
-			sh = scsi_register(tpnt, sizeof(MPT_SCSI_HOST));
-			if (sh != NULL) {
-				spin_lock_irqsave(&this->FreeQlock, flags);
-				sh->io_port = 0;
-				sh->n_io_port = 0;
-				sh->irq = 0;
-
-				/* Yikes!  This is important!
-				 * Otherwise, by default, linux
-				 * only scans target IDs 0-7!
-				 * pfactsN->MaxDevices unreliable
-				 * (not supported in early
-				 *	versions of the FW).
-				 * max_id = 1 + actual max id,
-				 * max_lun = 1 + actual last lun,
-				 *	see hosts.h :o(
-				 */
-				if ((int)this->chip_type > (int)FC929)
-					sh->max_id = MPT_MAX_SCSI_DEVICES;
-				else {
-					/* For FC, increase the queue depth
-					 * from MPT_SCSI_CAN_QUEUE (31)
-					 * to MPT_FC_CAN_QUEUE (63).
-					 */
-					sh->can_queue = MPT_FC_CAN_QUEUE;
-					sh->max_id = MPT_MAX_FC_DEVICES<256
? MPT_MAX_FC_DEVICES : 255;
-				}
-				sh->max_lun = MPT_LAST_LUN + 1;
+			sh->max_lun = MPT_LAST_LUN + 1;
+			sh->max_sectors = MPT_SCSI_MAX_SECTORS;
+			sh->this_id = ioc->pfacts[portnum].PortSCSIID;
 
-				sh->max_sectors = MPT_SCSI_MAX_SECTORS;
-				sh->this_id =
this->pfacts[portnum].PortSCSIID;
+			/* Required entry.
+			 */
+			sh->unique_id = ioc->id;
 
-				/* Required entry.
-				 */
-				sh->unique_id = this->id;
+			/* Verify that we won't exceed the maximum
+			 * number of chain buffers
+			 * We can optimize:  ZZ = req_sz/sizeof(SGE)
+			 * For 32bit SGE's:
+			 *  numSGE = 1 + (ZZ-1)*(maxChain -1) + ZZ
+			 *               + (req_sz - 64)/sizeof(SGE)
+			 * A slightly different algorithm is required for
+			 * 64bit SGEs.
+			 */
+			scale = ioc->req_sz/(sizeof(dma_addr_t) +
sizeof(u32));
+			if (sizeof(dma_addr_t) == sizeof(u64)) {
+				numSGE = (scale - 1) *
+				  (ioc->facts.MaxChainDepth-1) + scale +
+				  (ioc->req_sz - 60) / (sizeof(dma_addr_t) +
+				  sizeof(u32));
+			} else {
+				numSGE = 1 + (scale - 1) *
+				  (ioc->facts.MaxChainDepth-1) + scale +
+				  (ioc->req_sz - 64) / (sizeof(dma_addr_t) +
+				  sizeof(u32));
+			}
 
-				/* Verify that we won't exceed the maximum
-				 * number of chain buffers
-				 * We can optimize:  ZZ = req_sz/sizeof(SGE)
-				 * For 32bit SGE's:
-				 *  numSGE = 1 + (ZZ-1)*(maxChain -1) + ZZ
-				 *               + (req_sz - 64)/sizeof(SGE)
-				 * A slightly different algorithm is
required for
-				 * 64bit SGEs.
-				 */
-				scale = this->req_sz/(sizeof(dma_addr_t) +
sizeof(u32));
-				if (sizeof(dma_addr_t) == sizeof(u64)) {
-					numSGE = (scale - 1) *
(this->facts.MaxChainDepth-1) + scale +
-						(this->req_sz - 60) /
(sizeof(dma_addr_t) + sizeof(u32));
-				} else {
-					numSGE = 1 + (scale - 1) *
(this->facts.MaxChainDepth-1) + scale +
-						(this->req_sz - 64) /
(sizeof(dma_addr_t) + sizeof(u32));
-				}
+			if (numSGE < sh->sg_tablesize) {
+				/* Reset this value */
+				dprintk((MYIOC_s_INFO_FMT
+				  "Resetting sg_tablesize to %d from %d\n",
+				  ioc->name, numSGE, sh->sg_tablesize));
+				sh->sg_tablesize = numSGE;
+			}
 
-				if (numSGE < sh->sg_tablesize) {
-					/* Reset this value */
-					dprintk((MYIOC_s_INFO_FMT
-						 "Resetting sg_tablesize to
%d from %d\n",
-						 this->name, numSGE,
sh->sg_tablesize));
-					sh->sg_tablesize = numSGE;
-				}
+			/* Set the pci device pointer in Scsi_Host
structure.
+			 */
+			scsi_set_device(sh, &ioc->pcidev->dev);
 
-				/* Set the pci device pointer in Scsi_Host
structure.
-				 */
-				scsi_set_device(sh, &this->pcidev->dev);
+			spin_unlock_irqrestore(&ioc->FreeQlock, flags);
 
-				spin_unlock_irqrestore(&this->FreeQlock,
flags);
+			hd = (MPT_SCSI_HOST *) sh->hostdata;
+			hd->ioc = ioc;
+			hd->max_sge = sh->sg_tablesize;
 
-				hd = (MPT_SCSI_HOST *) sh->hostdata;
-				hd->ioc = this;
-				hd->max_sge = sh->sg_tablesize;
+			if ((int)ioc->chip_type > (int)FC929)
+			hd->is_spi = 1;
 
-				if ((int)this->chip_type > (int)FC929)
-					hd->is_spi = 1;
+			if (DmpService && (ioc->chip_type == FC919 ||
+			  ioc->chip_type == FC929)) {
+				hd->is_multipath = 1;
+			}
+			hd->port = 0; /* FIXME! */
 
-				if (DmpService &&
-				    (this->chip_type == FC919 ||
this->chip_type == FC929))
-					hd->is_multipath = 1;
+			/* SCSI needs Scsi_Cmnd lookup table!
+			 * (with size equal to req_depth*PtrSz!)
+			 */
+			sz = hd->ioc->req_depth * sizeof(void *);
+			mem = kmalloc(sz, GFP_ATOMIC);
+			if (mem == NULL)
+				goto mptscsih_probe_failed;
 
-				hd->port = 0;		/* FIXME! */
+			memset(mem, 0, sz);
+			hd->ScsiLookup = (struct scsi_cmnd **) mem;
 
-				/* SCSI needs Scsi_Cmnd lookup table!
-				 * (with size equal to req_depth*PtrSz!)
-				 */
-				sz = hd->ioc->req_depth * sizeof(void *);
-				mem = kmalloc(sz, GFP_ATOMIC);
-				if (mem == NULL)
-					goto done;
+			dprintk((MYIOC_s_INFO_FMT "ScsiLookup @ %p,
sz=%d\n",
+				 ioc->name, hd->ScsiLookup, sz));
 
-				memset(mem, 0, sz);
-				hd->ScsiLookup = (struct scsi_cmnd **) mem;
+			if (mptscsih_initChainBuffers(hd, 1) < 0)
+				goto mptscsih_probe_failed;
 
-				dprintk((MYIOC_s_INFO_FMT "ScsiLookup @ %p,
sz=%d\n",
-					 this->name, hd->ScsiLookup, sz));
+			/* Allocate memory for free and doneQ's
+			 */
+			sz = sh->can_queue * sizeof(MPT_DONE_Q);
+			mem = kmalloc(sz, GFP_ATOMIC);
+			if (mem == NULL)
+				goto mptscsih_probe_failed;
 
-				if (mptscsih_initChainBuffers(hd, 1) < 0)
-					goto done;
+			memset(mem, 0xFF, sz);
+			hd->memQ = mem;
 
-				/* Allocate memory for free and doneQ's
-				 */
-				sz = sh->can_queue * sizeof(MPT_DONE_Q);
-				mem = kmalloc(sz, GFP_ATOMIC);
-				if (mem == NULL)
-					goto done;
+			/* Initialize the free, done and pending Qs.
+			 */
+			Q_INIT(&hd->freeQ, MPT_DONE_Q);
+			Q_INIT(&hd->doneQ, MPT_DONE_Q);
+			Q_INIT(&hd->pendingQ, MPT_DONE_Q);
+			spin_lock_init(&hd->freedoneQlock);
+
+			mem = hd->memQ;
+			for (ii=0; ii < sh->can_queue; ii++) {
+				freedoneQ = (MPT_DONE_Q *) mem;
+				Q_ADD_TAIL(&hd->freeQ.head, freedoneQ,
MPT_DONE_Q);
+				mem += sizeof(MPT_DONE_Q);
+			}
 
-				memset(mem, 0xFF, sz);
-				hd->memQ = mem;
+			/* Initialize this Scsi_Host
+			 * internal task Q.
+			 */
+			Q_INIT(&hd->taskQ, MPT_FRAME_HDR);
+			hd->taskQcnt = 0;
 
-				/* Initialize the free, done and pending Qs.
-				 */
-				Q_INIT(&hd->freeQ, MPT_DONE_Q);
-				Q_INIT(&hd->doneQ, MPT_DONE_Q);
-				Q_INIT(&hd->pendingQ, MPT_DONE_Q);
-				spin_lock_init(&hd->freedoneQlock);
-
-				mem = hd->memQ;
-				for (ii=0; ii < sh->can_queue; ii++) {
-					freedoneQ = (MPT_DONE_Q *) mem;
-					Q_ADD_TAIL(&hd->freeQ.head,
freedoneQ, MPT_DONE_Q);
-					mem += sizeof(MPT_DONE_Q);
-				}
+			/* Allocate memory for the device structures.
+			 * A non-Null pointer at an offset
+			 * indicates a device exists.
+			 * max_id = 1 + maximum id (hosts.h)
+			 */
+			sz = sh->max_id * sizeof(void *);
+			mem = kmalloc(sz, GFP_ATOMIC);
+			if (mem == NULL)
+				goto mptscsih_probe_failed;
 
-				/* Initialize this Scsi_Host
-				 * internal task Q.
-				 */
-				Q_INIT(&hd->taskQ, MPT_FRAME_HDR);
-				hd->taskQcnt = 0;
+			memset(mem, 0, sz);
+			hd->Targets = (VirtDevice **) mem;
 
-				/* Allocate memory for the device
structures.
-				 * A non-Null pointer at an offset
-				 * indicates a device exists.
-				 * max_id = 1 + maximum id (hosts.h)
-				 */
-				sz = sh->max_id * sizeof(void *);
-				mem = kmalloc(sz, GFP_ATOMIC);
-				if (mem == NULL)
-					goto done;
+			dprintk((KERN_INFO
+			  "  Targets @ %p, sz=%d\n", hd->Targets, sz));
 
-				memset(mem, 0, sz);
-				hd->Targets = (VirtDevice **) mem;
 
-				dprintk((KERN_INFO "  Targets @ %p,
sz=%d\n", hd->Targets, sz));
+			/* Clear the TM flags
+			 */
+			hd->tmPending = 0;
+			hd->tmState = TM_STATE_NONE;
+			hd->resetPending = 0;
+			hd->abortSCpnt = NULL;
+			hd->tmPtr = NULL;
+			hd->numTMrequests = 0;
 
+			/* Clear the pointer used to store
+			 * single-threaded commands, i.e., those
+			 * issued during a bus scan, dv and
+			 * configuration pages.
+			 */
+			hd->cmdPtr = NULL;
 
-				/* Clear the TM flags
-				 */
-				hd->tmPending = 0;
-				hd->tmState = TM_STATE_NONE;
-				hd->resetPending = 0;
-				hd->abortSCpnt = NULL;
-				hd->tmPtr = NULL;
-				hd->numTMrequests = 0;
+			/* Initialize this SCSI Hosts' timers
+			 * To use, set the timer expires field
+			 * and add_timer
+			 */
+			init_timer(&hd->timer);
+			hd->timer.data = (unsigned long) hd;
+			hd->timer.function = mptscsih_timer_expired;
+
+			init_timer(&hd->TMtimer);
+			hd->TMtimer.data = (unsigned long) hd;
+			hd->TMtimer.function = mptscsih_taskmgmt_timeout;
+			hd->qtag_tick = jiffies;
 
-				/* Clear the pointer used to store
-				 * single-threaded commands, i.e., those
-				 * issued during a bus scan, dv and
-				 * configuration pages.
-				 */
-				hd->cmdPtr = NULL;
+			/* Moved Earlier Pam D */
+			/* ioc->sh = sh;	*/
 
-				/* Attach the SCSI Host to the IOC structure
+			if (hd->is_spi) {
+				/* Update with the driver setup
+				 * values.
 				 */
-				this->sh = sh;
+				if (hd->ioc->spi_data.maxBusWidth >
+				  driver_setup.max_width) {
+					hd->ioc->spi_data.maxBusWidth =
+					  driver_setup.max_width;
+				}
 
-				/* Initialize this SCSI Hosts' timers
-				 * To use, set the timer expires field
-				 * and add_timer
-				 */
-				init_timer(&hd->timer);
-				hd->timer.data = (unsigned long) hd;
-				hd->timer.function = mptscsih_timer_expired;
-
-				init_timer(&hd->TMtimer);
-				hd->TMtimer.data = (unsigned long) hd;
-				hd->TMtimer.function =
mptscsih_taskmgmt_timeout;
-				hd->qtag_tick = jiffies;
-
-				/* Moved Earlier Pam D */
-				/* this->sh = sh;	*/
-
-				if (hd->is_spi) {
-					/* Update with the driver setup
-					 * values.
-					 */
-					if (hd->ioc->spi_data.maxBusWidth >
driver_setup.max_width)
-
hd->ioc->spi_data.maxBusWidth = driver_setup.max_width;
-					if (hd->ioc->spi_data.minSyncFactor
< driver_setup.min_sync_fac)
-
hd->ioc->spi_data.minSyncFactor = driver_setup.min_sync_fac;
+				if (hd->ioc->spi_data.minSyncFactor <
+				  driver_setup.min_sync_fac) {
+					hd->ioc->spi_data.minSyncFactor =
+					  driver_setup.min_sync_fac;
+				}
 
-					if (hd->ioc->spi_data.minSyncFactor
== MPT_ASYNC)
-
hd->ioc->spi_data.maxSyncOffset = 0;
+				if (hd->ioc->spi_data.minSyncFactor ==
MPT_ASYNC) {
+					hd->ioc->spi_data.maxSyncOffset = 0;
+				}
 
-					hd->negoNvram = 0;
-#ifdef MPTSCSIH_DISABLE_DOMAIN_VALIDATION
-					hd->negoNvram =
MPT_SCSICFG_USE_NVRAM;
+				hd->negoNvram = 0;
+#ifndef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
+				hd->negoNvram = MPT_SCSICFG_USE_NVRAM;
 #endif
-					if (driver_setup.dv == 0)
-						hd->negoNvram =
MPT_SCSICFG_USE_NVRAM;
-
-					hd->ioc->spi_data.forceDv = 0;
-					for (ii=0; ii <
MPT_MAX_SCSI_DEVICES; ii++)
-
hd->ioc->spi_data.dvStatus[ii] = MPT_SCSICFG_NEGOTIATE;
-	
-					if (hd->negoNvram == 0) {
-						for (ii=0; ii <
MPT_MAX_SCSI_DEVICES; ii++)
-
hd->ioc->spi_data.dvStatus[ii] |= MPT_SCSICFG_DV_NOT_DONE;
-					}
+				if (driver_setup.dv == 0) {
+					hd->negoNvram =
MPT_SCSICFG_USE_NVRAM;
+				}
 
-					ddvprintk((MYIOC_s_INFO_FMT
-						"dv %x width %x factor %x
\n",
-						hd->ioc->name,
driver_setup.dv,
-						driver_setup.max_width,
-						driver_setup.min_sync_fac));
+				hd->ioc->spi_data.forceDv = 0;
+				for (ii=0; ii < MPT_MAX_SCSI_DEVICES; ii++)
{
+					hd->ioc->spi_data.dvStatus[ii] =
+					  MPT_SCSICFG_NEGOTIATE;
+				}
 
+				if (hd->negoNvram == 0) {
+					for (ii=0; ii <
MPT_MAX_SCSI_DEVICES; ii++)
+
hd->ioc->spi_data.dvStatus[ii] |=
+						  MPT_SCSICFG_DV_NOT_DONE;
 				}
 
-				mpt_scsi_hosts++;
+				ddvprintk((MYIOC_s_INFO_FMT
+					"dv %x width %x factor %x \n",
+					hd->ioc->name, driver_setup.dv,
+					driver_setup.max_width,
+					driver_setup.min_sync_fac));
+
 			}
 
-		}	/* for each adapter port */
+			mpt_scsi_hosts++;
 
-		this = mpt_adapter_find_next(this);
-	}
+			if(scsi_add_host (sh, &ioc->pcidev->dev)) {
+				dprintk((KERN_ERR MYNAM,
+				  "scsi_add_host failed\n"));
+				goto mptscsih_probe_failed;
+			}
 
-done:
-	if (mpt_scsi_hosts > 0)
-		register_reboot_notifier(&mptscsih_notifier);
-	else {
-		mpt_reset_deregister(ScsiDoneCtx);
-		dprintk((KERN_INFO MYNAM ": Deregistered for IOC reset
notifications\n"));
+			scsi_scan_host(sh);
+			return 0;
 
-		mpt_event_deregister(ScsiDoneCtx);
-		dprintk((KERN_INFO MYNAM ": Deregistered for IOC event
notifications\n"));
+		} /* scsi_host_alloc */
 
-		mpt_deregister(ScsiScanDvCtx);
-		mpt_deregister(ScsiTaskCtx);
-		mpt_deregister(ScsiDoneCtx);
+	} /* for each adapter port */
 
-		if (info_kbuf != NULL)
-			kfree(info_kbuf);
-	}
+mptscsih_probe_failed:
+
+	mptscsih_remove(pdev);
+	return -ENODEV;
 
-	return mpt_scsi_hosts;
 }
 
 
/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
=*/
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-=*/
-/**
- *	mptscsih_release - Unregister SCSI host from linux scsi mid-layer
- *	@host: Pointer to Scsi_Host structure
+/*
+ *	mptscsih_remove - Removed scsi devices
+ *	@pdev: Pointer to pci_dev structure
  *
- *	(linux Scsi_Host_Template.release routine)
- *	This routine releases all resources associated with the SCSI host
- *	adapter.
  *
- *	Returns 0 for success.
  */
-int
-mptscsih_release(struct Scsi_Host *host)
+static void __devexit
+mptscsih_remove(struct pci_dev *pdev)
 {
-	MPT_SCSI_HOST	*hd;
-	int 		 count;
-	unsigned long	 flags;
+	MPT_ADAPTER 		*ioc = pci_get_drvdata(pdev);
+	struct Scsi_Host 	*host = ioc->sh;
+	MPT_SCSI_HOST		*hd;
+	int 		 	count;
+	unsigned long	 	flags;
+
+	if(!host)
+		return;
 
-	hd = (MPT_SCSI_HOST *) host->hostdata;
+	scsi_remove_host(host);
 
-#ifndef MPTSCSIH_DISABLE_DOMAIN_VALIDATION
+#ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
 	/* Check DV thread active */
 	count = 10 * HZ;
 	spin_lock_irqsave(&dvtaskQ_lock, flags);
@@ -1721,8 +1745,7 @@
 #endif
 #endif
 
-	unregister_reboot_notifier(&mptscsih_notifier);
-
+	hd = (MPT_SCSI_HOST *)host->hostdata;
 	if (hd != NULL) {
 		int sz1, sz2, sz3, sztarget=0;
 		int szr2chain = 0;
@@ -1730,9 +1753,7 @@
 		int szchain = 0;
 		int szQ = 0;
 
-		/* Synchronize disk caches
-		 */
-		(void) mptscsih_synchronize_cache(hd, 0);
+		mptscsih_shutdown(&pdev->dev);
 
 		sz1 = sz2 = sz3 = 0;
 
@@ -1796,72 +1817,203 @@
 			hd->Targets = NULL;
 		}
 
-		dprintk((MYIOC_s_INFO_FMT "Free'd ScsiLookup (%d), chain
(%d) and Target (%d+%d) memory\n",
-				hd->ioc->name, sz1, szchain, sz3,
sztarget));
+		dprintk((MYIOC_s_INFO_FMT
+		  "Free'd ScsiLookup (%d), chain (%d) and Target (%d+%d)
memory\n",
+		  hd->ioc->name, sz1, szchain, sz3, sztarget));
 		dprintk(("Free'd done and free Q (%d) memory\n", szQ));
+
+		/* NULL the Scsi_Host pointer
+		 */
+		hd->ioc->sh = NULL;
 	}
-	/* NULL the Scsi_Host pointer
+
+	scsi_host_put(host);
+
+}
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-=*/
+/*
+ *	mptscsih_shutdown - reboot notifier
+ *
+ */
+static void
+mptscsih_shutdown(struct device * dev)
+{
+	MPT_ADAPTER 		*ioc = pci_get_drvdata(to_pci_dev(dev));
+	struct Scsi_Host 	*host = ioc->sh;
+	MPT_SCSI_HOST		*hd;
+
+	if(!host)
+		return;
+
+	hd = (MPT_SCSI_HOST *)host->hostdata;
+
+	/* Flush the cache of this adapter
 	 */
-	hd->ioc->sh = NULL;
-	scsi_unregister(host);
+	if(hd != NULL)
+		mptscsih_synchronize_cache(hd, 0);
 
-	if (mpt_scsi_hosts) {
-		if (--mpt_scsi_hosts == 0) {
-			mpt_reset_deregister(ScsiDoneCtx);
-			dprintk((KERN_INFO MYNAM ": Deregistered for IOC
reset notifications\n"));
+}
 
-			mpt_event_deregister(ScsiDoneCtx);
-			dprintk((KERN_INFO MYNAM ": Deregistered for IOC
event notifications\n"));
+#ifdef CONFIG_PM
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-=*/
+/*
+ *	mptscsih_suspend - Fusion MPT scsie driver suspend routine.
+ *
+ *
+ */
+static int
+mptscsih_suspend(struct pci_dev *pdev, u32 state)
+{
+	mptscsih_shutdown(&pdev->dev);
+	return 0;
+}
 
-			mpt_deregister(ScsiScanDvCtx);
-			mpt_deregister(ScsiTaskCtx);
-			mpt_deregister(ScsiDoneCtx);
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-=*/
+/*
+ *	mptscsih_resume - Fusion MPT scsi driver resume routine.
+ *
+ *
+ */
+static int
+mptscsih_resume(struct pci_dev *pdev)
+{
+	MPT_ADAPTER 		*ioc = pci_get_drvdata(pdev);
+	struct Scsi_Host 	*host = ioc->sh;
+	MPT_SCSI_HOST		*hd;
 
-			if (info_kbuf != NULL)
-				kfree(info_kbuf);
-		}
-	}
+	if(!host)
+		return 0;
 
+	hd = (MPT_SCSI_HOST *)host->hostdata;
+	if(!hd)
+		return 0;
+
+#ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
+	{
+	unsigned long lflags;
+	spin_lock_irqsave(&dvtaskQ_lock, lflags);
+	if (!dvtaskQ_active) {
+		dvtaskQ_active = 1;
+		spin_unlock_irqrestore(&dvtaskQ_lock, lflags);
+		MPT_INIT_WORK(&mptscsih_dvTask,
+		  mptscsih_domainValidation, (void *) hd);
+		SCHEDULE_TASK(&mptscsih_dvTask);
+	} else {
+		spin_unlock_irqrestore(&dvtaskQ_lock, lflags);
+	}
+	}
+#endif
 	return 0;
 }
 
+#endif
+
+static struct mpt_pci_driver mptscsih_driver = {
+	.probe		= mptscsih_probe,
+	.remove		= __devexit_p(mptscsih_remove),
+	.shutdown	= mptscsih_shutdown,
+#ifdef CONFIG_PM
+	.suspend	= mptscsih_suspend,
+	.resume		= mptscsih_resume,
+#endif
+};
+
+
+/*  SCSI host fops start here...  */
 
/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
=*/
 /**
- *	mptscsih_halt - Process the reboot notification
- *	@nb: Pointer to a struct notifier_block (ignored)
- *	@event: event (SYS_HALT, SYS_RESTART, SYS_POWER_OFF)
- *	@buf: Pointer to a data buffer (ignored)
- *
- *	This routine called if a system shutdown or reboot is to occur.
+ *	mptscsih_init - Register MPT adapter(s) as SCSI host(s) with
+ *	linux scsi mid-layer.
  *
- *	Return NOTIFY_DONE if this is something other than a reboot message.
- *		NOTIFY_OK if this is a reboot message.
+ *	Returns 0 for success, non-zero for failure.
  */
 static int
-mptscsih_halt(struct notifier_block *nb, ulong event, void *buf)
+__init mptscsih_init(void)
 {
-	MPT_ADAPTER *ioc = NULL;
-	MPT_SCSI_HOST *hd = NULL;
+	MPT_ADAPTER		*ioc;
 
-	/* Ignore all messages other than reboot message
-	 */
-	if ((event != SYS_RESTART) && (event != SYS_HALT)
-		&& (event != SYS_POWER_OFF))
-		return (NOTIFY_DONE);
+	show_mptmod_ver(my_NAME, my_VERSION);
 
-	for (ioc = mpt_adapter_find_first(); ioc != NULL; ioc =
mpt_adapter_find_next(ioc)) {
-		/* Flush the cache of this adapter
-		 */
-		if (ioc->sh) {
-			hd = (MPT_SCSI_HOST *) ioc->sh->hostdata;
-			if (hd) {
-				mptscsih_synchronize_cache(hd, 0);
-			}
+	ScsiDoneCtx = mpt_register(mptscsih_io_done, MPTSCSIH_DRIVER);
+	ScsiTaskCtx = mpt_register(mptscsih_taskmgmt_complete,
MPTSCSIH_DRIVER);
+	ScsiScanDvCtx = mpt_register(mptscsih_scandv_complete,
MPTSCSIH_DRIVER);
+
+	if(mpt_device_driver_register(&mptscsih_driver,
+	  MPTSCSIH_DRIVER) != 0 ) {
+		dprintk((KERN_INFO MYNAM
+		": failed to register dd callbacks\n"));
+	}
+
+	if (mpt_event_register(ScsiDoneCtx, mptscsih_event_process) == 0) {
+		dprintk((KERN_INFO MYNAM
+		  ": Registered for IOC event notifications\n"));
+	}
+
+	if (mpt_reset_register(ScsiDoneCtx, mptscsih_ioc_reset) == 0) {
+		dprintk((KERN_INFO MYNAM
+		  ": Registered for IOC reset notifications\n"));
+	}
+
+#ifdef MODULE
+	/* Evaluate the command line arguments, if any */
+	if (mptscsih)
+		mptscsih_setup(mptscsih);
+#endif
+
+	/* probing for devices */
+	for(ioc = mpt_adapter_find_first(); ioc != NULL;
+	  ioc = mpt_adapter_find_next(ioc)) {
+		if(mptscsih_probe(ioc->pcidev,
ioc->pcidev->driver->id_table)) {
+			dprintk((KERN_INFO MYNAM ": probe failed\n"));
+			return -ENODEV;
 		}
 	}
 
-	unregister_reboot_notifier(&mptscsih_notifier);
-	return NOTIFY_OK;
+	if (mpt_scsi_hosts > 0)
+		return 0;
+
+	mptscsih_exit();
+	return -ENODEV;
+
+}
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-=*/
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-=*/
+/**
+ *	mptscsih_exit - Unregisters MPT adapter(s)
+ *
+ */
+static void
+__exit mptscsih_exit(void)
+{
+	MPT_ADAPTER	*ioc;
+
+	/* removing devices */
+	for(ioc = mpt_adapter_find_first(); ioc != NULL;
+	  ioc = mpt_adapter_find_next(ioc)) {
+		if ((ioc->last_state != MPI_IOC_STATE_OPERATIONAL) ||
+		  (ioc->sh == NULL))
+			continue;
+		mptscsih_remove(ioc->pcidev);
+	}
+
+	mpt_reset_deregister(ScsiDoneCtx);
+	dprintk((KERN_INFO MYNAM
+	  ": Deregistered for IOC reset notifications\n"));
+
+	mpt_event_deregister(ScsiDoneCtx);
+	dprintk((KERN_INFO MYNAM
+	  ": Deregistered for IOC event notifications\n"));
+
+	mpt_device_driver_deregister(MPTSCSIH_DRIVER);
+	mpt_deregister(ScsiScanDvCtx);
+	mpt_deregister(ScsiTaskCtx);
+	mpt_deregister(ScsiDoneCtx);
+
+	if (info_kbuf != NULL)
+		kfree(info_kbuf);
+
 }
 
 
/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
=*/
@@ -2436,7 +2588,7 @@
 					hd->ioc->spi_data.dvStatus[target] =
dvStatus;
 				}
 
-#ifndef MPTSCSIH_DISABLE_DOMAIN_VALIDATION
+#ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
 				if ((dvStatus & MPT_SCSICFG_NEED_DV) ||
 					(hd->ioc->spi_data.forceDv &
MPT_SCSICFG_NEED_DV)) {
 					unsigned long lflags;
@@ -2608,7 +2760,7 @@
  *	Returns 0 for SUCCESS or -1 if FAILED.
  */
 static int
-mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 target, u8 lun, int
ctx2abort, int sleepFlag)
+mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 target, u8 lun, int
ctx2abort, ulong timeout, int sleepFlag)
 {
 	MPT_ADAPTER	*ioc = NULL;
 	int		 rc = -1;
@@ -2664,7 +2816,7 @@
 		 */
 		if (hd->hard_resets < -1)
 			hd->hard_resets++;
-		rc = mptscsih_IssueTaskMgmt(hd, type, target, lun,
ctx2abort, sleepFlag);
+		rc = mptscsih_IssueTaskMgmt(hd, type, target, lun,
ctx2abort, timeout, sleepFlag);
 		if (rc) {
 			printk(MYIOC_s_INFO_FMT "Issue of TaskMgmt
failed!\n", hd->ioc->name);
 		} else {
@@ -2710,7 +2862,7 @@
  *	else other non-zero value returned.
  */
 static int
-mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 target, u8 lun, int
ctx2abort, int sleepFlag)
+mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 target, u8 lun, int
ctx2abort, ulong timeout, int sleepFlag)
 {
 	MPT_FRAME_HDR	*mf;
 	SCSITaskMgmt_t	*pScsiTm;
@@ -2760,7 +2912,7 @@
 	*/
 	hd->tmPtr = mf;
 	hd->numTMrequests++;
-	hd->TMtimer.expires = jiffies + HZ*20;  /* 20 seconds */
+	hd->TMtimer.expires = jiffies + timeout;
 	add_timer(&hd->TMtimer);
 
 	if ((retval = mpt_send_handshake_request(ScsiTaskCtx, hd->ioc->id,
@@ -2870,7 +3022,8 @@
 
 	spin_unlock_irq(host_lock);
 	if (mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_ABORT_TASK,
-	                       SCpnt->device->id, SCpnt->device->lun,
ctx2abort, CAN_SLEEP)
+		SCpnt->device->id, SCpnt->device->lun,
+		ctx2abort, (HZ*2) /* 2 second timeout */,CAN_SLEEP)
 		< 0) {
 
 		/* The TM request failed and the subsequent FW-reload
failed!
@@ -2940,7 +3093,7 @@
 	}
 
 	if (mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET,
-	                       SCpnt->device->id, 0, 0, CAN_SLEEP)
+		SCpnt->device->id, 0, 0, (HZ*5) /* 5 second timeout */,
CAN_SLEEP)
 		< 0){
 		/* The TM request failed and the subsequent FW-reload
failed!
 		 * Fatal error case.
@@ -3004,7 +3157,7 @@
 
 	/* We are now ready to execute the task management request. */
 	if (mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS,
-	                       0, 0, 0, CAN_SLEEP)
+		0, 0, 0, (HZ*5) /* 5 second timeout */, CAN_SLEEP)
 	    < 0){
 
 		/* The TM request failed and the subsequent FW-reload
failed!
@@ -3087,7 +3240,7 @@
 mptscsih_tm_pending_wait(MPT_SCSI_HOST * hd)
 {
 	unsigned long  flags;
-	int            loop_count = 60 * 4;  /* Wait 60 seconds */
+	int            loop_count = 10 * 4;  /* Wait 10 seconds */
 	int            status = FAILED;
 
 	do {
@@ -3227,18 +3380,50 @@
  */
 int
 mptscsih_bios_param(struct scsi_device * sdev, struct block_device *bdev,
-		sector_t capacity, int *ip)
+		sector_t capacity, int geom[])
 {
-	int size;
+	int		heads;
+	int		sectors;
+	sector_t	cylinders;
+#ifdef CONFIG_LBD
+	ulong 		dummy;
+#endif
 
-	size = capacity;
-	ip[0] = 64;				/* heads
*/
-	ip[1] = 32;				/* sectors
*/
-	if ((ip[2] = size >> 11) > 1024) {	/* cylinders, test for big
disk */
-		ip[0] = 255;			/* heads
*/
-		ip[1] = 63;			/* sectors
*/
-		ip[2] = size / (255 * 63);	/* cylinders
*/
+	heads = 64;
+	sectors = 32;
+#ifdef CONFIG_LBD
+	dummy = heads * sectors;
+	cylinders = capacity;
+	sector_div(cylinders,dummy);
+#else
+	cylinders = (ulong)capacity / (heads * sectors);
+#endif
+
+	/*
+	 * Handle extended translation size for logical drives
+	 * > 1Gb
+	 */
+	if ((ulong)capacity >= 0x200000) {
+		heads = 255;
+		sectors = 63;
+#ifdef CONFIG_LBD
+		dummy = heads * sectors;
+		cylinders = capacity;
+		sector_div(cylinders,dummy);
+#else
+		cylinders = (ulong)capacity / (heads * sectors);
+#endif
 	}
+
+	/* return result */
+	geom[0] = heads;
+	geom[1] = sectors;
+	geom[2] = cylinders;
+
+	dprintk((KERN_NOTICE
+		": bios_param: Id=%i Lun=%i Channel=%i CHS=%i/%i/%i\n",
+		sdev->id,
sdev->lun,sdev->channel,(int)cylinders,heads,sectors));
+
 	return 0;
 }
 
@@ -3368,7 +3553,7 @@
 			vdev->raidVolume = 0;
 			if (hd->is_spi && (hd->ioc->spi_data.isRaid & (1 <<
(device->id)))) {
 				vdev->raidVolume = 1;
-				ddvtprintk((KERN_INFO "RAID Volume @ id
%d\n", target_id));
+				ddvtprintk((KERN_INFO "RAID Volume @ id
%d\n", device->id));
 			}
 
 			mptscsih_target_settings(hd, vdev, device);
@@ -3650,36 +3835,6 @@
 	return -1;
 }
 
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-=*/
-
-/* see mptscsih.h */
-
-#ifdef MPT_SCSIHOST_NEED_ENTRY_EXIT_HOOKUPS
-static Scsi_Host_Template driver_template = {
-	.proc_name			= "mptscsih",
-	.proc_info			= x_scsi_proc_info,
-	.name				= "MPT SCSI Host",
-	.detect				= x_scsi_detect,
-	.release			= x_scsi_release,
-	.info				= x_scsi_info,	
-	.queuecommand			= x_scsi_queuecommand,
-	.slave_alloc			= x_scsi_slave_alloc,
-	.slave_configure		= x_scsi_slave_configure,
-	.slave_destroy			= x_scsi_slave_destroy,
-	.eh_abort_handler		= x_scsi_abort,
-	.eh_device_reset_handler	= x_scsi_dev_reset,
-	.eh_bus_reset_handler		= x_scsi_bus_reset,
-	.eh_host_reset_handler		= x_scsi_host_reset,
-	.bios_param			= x_scsi_bios_param,
-	.can_queue			= MPT_SCSI_CAN_QUEUE,
-	.this_id			= -1,
-	.sg_tablesize			= MPT_SCSI_SG_DEPTH,
-	.max_sectors			= MPT_SCSI_MAX_SECTORS,
-	.cmd_per_lun			= MPT_SCSI_CMD_PER_LUN,
-	.use_clustering			= ENABLE_CLUSTERING,
-};
-#include "../../scsi/scsi_module.c"
-#endif
 
 
/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
=*/
 /* Search the pendingQ for a command with specific index.
@@ -3958,7 +4113,7 @@
 		break;
 
 	case MPI_EVENT_INTEGRATED_RAID:			/* 0B */
-#ifndef MPTSCSIH_DISABLE_DOMAIN_VALIDATION
+#ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
 		/* negoNvram set to 0 if DV enabled and to USE_NVRAM if
 		 * if DV disabled. Need to check for target mode.
 		 */
@@ -3972,7 +4127,7 @@
 			int		 numPDisk;
 			u8		 reason;
 			u8		 physDiskNum;
-			
+
 			reason = (le32_to_cpu(pEvReply->Data[0]) &
0x00FF0000) >> 16;
 			if (reason == MPI_EVENT_RAID_RC_DOMAIN_VAL_NEEDED) {
 				/* New or replaced disk.
@@ -4320,6 +4475,8 @@
 	case WRITE_10:
 	case READ_12:
 	case WRITE_12:
+	case READ_16:
+	case WRITE_16:
 		break;
 	default:
 		return 0;
@@ -4618,7 +4775,7 @@
 			//negoFlags = MPT_TARGET_NO_NEGO_SYNC;
 		}
 
-#ifndef MPTSCSIH_DISABLE_DOMAIN_VALIDATION
+#ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
 		/* Force to async and narrow if DV has not been executed
 		 * for this ID
 		 */
@@ -5000,7 +5157,7 @@
 	return;
 }
 
-#ifndef MPTSCSIH_DISABLE_DOMAIN_VALIDATION
+#ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
 
/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
=*/
 /*	mptscsih_do_raid - Format and Issue a RAID volume request message.
  *	@hd: Pointer to scsi host structure
@@ -5071,7 +5228,7 @@
 
 	return 0;
 }
-#endif /* ~MPTSCSIH_DISABLE_DOMAIN_VALIDATION */
+#endif /* ~MPTSCSIH_ENABLE_DOMAIN_VALIDATION */
 
 
/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
=*/
 /**
@@ -5383,7 +5540,7 @@
 		if (ioc->spi_data.sdp1length > 0) {
 			pcfg1Data = (SCSIDevicePage1_t
*)pci_alloc_consistent(ioc->pcidev,
 					 ioc->spi_data.sdp1length * 4,
&cfg1_dma_addr);
-	
+
 			if (pcfg1Data != NULL) {
 				doConfig = 1;
 				header1.PageVersion =
ioc->spi_data.sdp1version;
@@ -5415,7 +5572,7 @@
 				flags = hd->ioc->spi_data.noQas;
 				if (hd->ioc->spi_data.nvram &&
(hd->ioc->spi_data.nvram[id] != MPT_HOST_NVRAM_INVALID)) {
 					data = hd->ioc->spi_data.nvram[id];
-	
+
 					if (data & MPT_NVRAM_WIDE_DISABLE)
 						flags |=
MPT_TARGET_NO_NEGO_WIDE;
 
@@ -5424,7 +5581,7 @@
 						flags |=
MPT_TARGET_NO_NEGO_SYNC;
 				}
 			}
-	
+
 			/* Force to async, narrow */
 			mptscsih_setDevicePage1Flags(0, MPT_ASYNC, 0,
&requested,
 					&configuration, flags);
@@ -5467,7 +5624,7 @@
 	return 0;
 }
 
-#ifndef MPTSCSIH_DISABLE_DOMAIN_VALIDATION
+#ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
 
/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
=*/
 /**
  *	mptscsih_domainValidation - Top level handler for domain validation.
@@ -5520,7 +5677,7 @@
 			/* DV only to SCSI adapters */
 			if ((int)ioc->chip_type <= (int)FC929)
 				continue;
-			
+
 			/* Make sure everything looks ok */
 			if (ioc->sh == NULL)
 				continue;
@@ -6914,7 +7071,7 @@
 		break;
 	}
 }
-#endif /* ~MPTSCSIH_DISABLE_DOMAIN_VALIDATION */
+#endif /* ~MPTSCSIH_ENABLE_DOMAIN_VALIDATION */
 
 
/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
=*/
 /* Commandline Parsing routines and defines.
@@ -7009,3 +7166,6 @@
 
 
/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
=*/
 
+
+module_init(mptscsih_init);
+module_exit(mptscsih_exit);
diff -uarN linux-2.6.2-rc1-reference/drivers/message/fusion/mptscsih.h
linux-2.6.2-rc1/drivers/message/fusion/mptscsih.h
--- linux-2.6.2-rc1-reference/drivers/message/fusion/mptscsih.h	2004-01-24
00:17:20.569855208 -0700
+++ linux-2.6.2-rc1/drivers/message/fusion/mptscsih.h	2004-01-13
15:46:09.000000000 -0700
@@ -98,13 +98,14 @@
 #define MPT_SCSI_SG_DEPTH	40
 #endif
 
-/* To disable domain validation, uncomment the
+/* To disable domain validation, comment the
  * following line. No effect for FC devices.
  * For SCSI devices, driver will negotiate to
  * NVRAM settings (if available) or to maximum adapter
  * capabilities.
  */
-/* #define MPTSCSIH_DISABLE_DOMAIN_VALIDATION */
+
+#define MPTSCSIH_ENABLE_DOMAIN_VALIDATION
 
 
 /* SCSI driver setup structure. Settings can be overridden
@@ -138,15 +139,6 @@
  */
 
 /*
- *	Conditionalizing with "#ifdef MODULE/#endif" around:
- *		static Scsi_Host_Template driver_template = XX;
- *		#include <../../scsi/scsi_module.c>
- *	lines was REMOVED @ lk-2.4.0-test9
- *	Issue discovered 20001213 by: sshirron
- */
-#define MPT_SCSIHOST_NEED_ENTRY_EXIT_HOOKUPS			1
-
-/*
  *	tq_scheduler disappeared @ lk-2.4.0-test12
  *	(right when <linux/sched.h> newly defined TQ_ACTIVE)
  *	tq_struct reworked in 2.5.41. Include workqueue.h.
@@ -160,8 +152,6 @@
 
 
/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
=*/
 
-#define x_scsi_detect		mptscsih_detect
-#define x_scsi_release		mptscsih_release
 #define x_scsi_info		mptscsih_info
 #define x_scsi_queuecommand	mptscsih_qcmd
 #define x_scsi_abort		mptscsih_abort
@@ -170,9 +160,6 @@
 #define x_scsi_host_reset	mptscsih_host_reset
 #define x_scsi_bios_param	mptscsih_bios_param
 
-#define x_scsi_taskmgmt_bh	mptscsih_taskmgmt_bh
-#define x_scsi_old_abort	mptscsih_old_abort
-#define x_scsi_old_reset	mptscsih_old_reset
 #define x_scsi_slave_alloc	mptscsih_slave_alloc
 #define x_scsi_slave_configure	mptscsih_slave_configure
 #define x_scsi_slave_destroy	mptscsih_slave_destroy
@@ -182,8 +169,6 @@
 /*
  *	MPT SCSI Host / Initiator decls...
  */
-extern	int		 x_scsi_detect(Scsi_Host_Template *);
-extern	int		 x_scsi_release(struct Scsi_Host *host);
 extern	const char	*x_scsi_info(struct Scsi_Host *);
 extern	int		 x_scsi_queuecommand(Scsi_Cmnd *, void
(*done)(Scsi_Cmnd *));
 extern	int		 x_scsi_abort(Scsi_Cmnd *);
@@ -191,8 +176,7 @@
 extern	int		 x_scsi_dev_reset(Scsi_Cmnd *);
 extern	int		 x_scsi_host_reset(Scsi_Cmnd *);
 extern int		 x_scsi_bios_param(struct scsi_device * sdev, struct
block_device *bdev,
-				sector_t capacity, int *ip);
-extern	void		 x_scsi_taskmgmt_bh(void *);
+				sector_t capacity, int geom[]);
 extern	int		 x_scsi_slave_alloc(Scsi_Device *);
 extern	int		 x_scsi_slave_configure(Scsi_Device *);
 extern	void		 x_scsi_slave_destroy(Scsi_Device *);
