From: "Prakash, Sathya" <sathya.prakash@lsi.com>
Subject: [PATCH 4/5] mpt fusion: Changes in mptfc.c mptlan.c mptsas.c and mptspi.c for logging support
Date: Tue, 24 Jul 2007 15:47:41 +0530
Message-ID: <20070724101740.GE1831@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:42952 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123AbXGXKUK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jul 2007 06:20:10 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id l6OAImFF000678
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jul 2007 03:18:49 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: eric.moore@lsi.com


This patch contains changes in mptfc.c, mptlan.c, mptsas.c and mptspi.c to
support logging in MPT fusion drivers.

The changes are majorly in debug printks, the existing debugprintk are
modified accroding to new debug macros defined in the file mptbdebug.h

signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
---

diff -Naurp b/drivers/message/fusion/mptfc.c a/drivers/message/fusion/mptfc.c
--- b/drivers/message/fusion/mptfc.c	2007-07-23 14:24:35.000000000 +0530
+++ a/drivers/message/fusion/mptfc.c	2007-07-23 16:44:55.000000000 +0530
@@ -188,16 +188,18 @@ mptfc_block_error_handler(struct scsi_cm
 			  int (*func)(struct scsi_cmnd *SCpnt),
 			  const char *caller)
 {
+	MPT_SCSI_HOST		*hd;
 	struct scsi_device	*sdev = SCpnt->device;
 	struct Scsi_Host	*shost = sdev->host;
 	struct fc_rport		*rport = starget_to_rport(scsi_target(sdev));
 	unsigned long		flags;
 	int			ready;
 
+	hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata;
 	spin_lock_irqsave(shost->host_lock, flags);
 	while ((ready = fc_remote_port_chkready(rport) >> 16) == DID_IMM_RETRY) {
 		spin_unlock_irqrestore(shost->host_lock, flags);
-		dfcprintk ((MYIOC_s_INFO_FMT
+		dfcprintk (hd->ioc, printk(MYIOC_s_DEBUG_FMT
 			"mptfc_block_error_handler.%d: %d:%d, port status is "
 			"DID_IMM_RETRY, deferring %s recovery.\n",
 			((MPT_SCSI_HOST *) shost->hostdata)->ioc->name,
@@ -209,7 +211,7 @@ mptfc_block_error_handler(struct scsi_cm
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	if (ready == DID_NO_CONNECT || !SCpnt->device->hostdata) {
-		dfcprintk ((MYIOC_s_INFO_FMT
+		dfcprintk (hd->ioc, printk(MYIOC_s_DEBUG_FMT
 			"%s.%d: %d:%d, failing recovery, "
 			"port state %d, vdev %p.\n", caller,
 			((MPT_SCSI_HOST *) shost->hostdata)->ioc->name,
@@ -218,7 +220,7 @@ mptfc_block_error_handler(struct scsi_cm
 			SCpnt->device->hostdata));
 		return FAILED;
 	}
-	dfcprintk ((MYIOC_s_INFO_FMT
+	dfcprintk (hd->ioc, printk(MYIOC_s_DEBUG_FMT
 		"%s.%d: %d:%d, executing recovery.\n", caller,
 		((MPT_SCSI_HOST *) shost->hostdata)->ioc->name,
 		((MPT_SCSI_HOST *) shost->hostdata)->ioc->sh->host_no,
@@ -483,7 +485,7 @@ mptfc_register_dev(MPT_ADAPTER *ioc, int
 
 			pn = (u64)ri->pg0.WWPN.High << 32 | (u64)ri->pg0.WWPN.Low;
 			nn = (u64)ri->pg0.WWNN.High << 32 | (u64)ri->pg0.WWNN.Low;
-			dfcprintk ((MYIOC_s_INFO_FMT
+			dfcprintk (ioc, printk(MYIOC_s_DEBUG_FMT
 				"mptfc_reg_dev.%d: %x, %llx / %llx, tid %d, "
 				"rport tid %d, tmo %d\n",
 					ioc->name,
@@ -559,6 +561,35 @@ mptfc_target_alloc(struct scsi_target *s
 
 	return rc;
 }
+/*
+ *	mptfc_dump_lun_info
+ *	@ioc
+ *	@rport
+ *	@sdev
+ *
+ */
+static void
+mptfc_dump_lun_info(MPT_ADAPTER *ioc, struct fc_rport *rport, struct scsi_device *sdev,
+		VirtTarget *vtarget)
+{
+	u64 nn, pn;
+	struct mptfc_rport_info *ri;
+
+	ri = *((struct mptfc_rport_info **)rport->dd_data);
+	pn = (u64)ri->pg0.WWPN.High << 32 | (u64)ri->pg0.WWPN.Low;
+	nn = (u64)ri->pg0.WWNN.High << 32 | (u64)ri->pg0.WWNN.Low;
+	dfcprintk (ioc, printk(MYIOC_s_DEBUG_FMT
+		"mptfc_slv_alloc.%d: num_luns %d, sdev.id %d, "
+		"CurrentTargetID %d, %x %llx %llx\n",
+		ioc->name,
+		sdev->host->host_no,
+		vtarget->num_luns,
+		sdev->id, ri->pg0.CurrentTargetID,
+		ri->pg0.PortIdentifier,
+		(unsigned long long)pn,
+		(unsigned long long)nn));
+}
+
 
 /*
  *	OS entry point to allow host driver to alloc memory
@@ -606,25 +637,7 @@ mptfc_slave_alloc(struct scsi_device *sd
 	vtarget->num_luns++;
 
 
-#ifdef DMPT_DEBUG_FC
-	{
-	u64 nn, pn;
-	struct mptfc_rport_info *ri;
-	ri = *((struct mptfc_rport_info **)rport->dd_data);
-	pn = (u64)ri->pg0.WWPN.High << 32 | (u64)ri->pg0.WWPN.Low;
-	nn = (u64)ri->pg0.WWNN.High << 32 | (u64)ri->pg0.WWNN.Low;
-	dfcprintk ((MYIOC_s_INFO_FMT
-		"mptfc_slv_alloc.%d: num_luns %d, sdev.id %d, "
-	        "CurrentTargetID %d, %x %llx %llx\n",
-		hd->ioc->name,
-		sdev->host->host_no,
-		vtarget->num_luns,
-		sdev->id, ri->pg0.CurrentTargetID,
-		ri->pg0.PortIdentifier,
-		(unsigned long long)pn,
-		(unsigned long long)nn));
-	}
-#endif
+	mptfc_dump_lun_info(hd->ioc, rport, sdev, vtarget);
 
 	return 0;
 }
@@ -653,27 +666,12 @@ mptfc_qcmd(struct scsi_cmnd *SCpnt, void
 	/* dd_data is null until finished adding target */
 	ri = *((struct mptfc_rport_info **)rport->dd_data);
 	if (unlikely(!ri)) {
-		dfcprintk ((MYIOC_s_INFO_FMT
-			"mptfc_qcmd.%d: %d:%d, dd_data is null.\n",
-			((MPT_SCSI_HOST *) SCpnt->device->host->hostdata)->ioc->name,
-			((MPT_SCSI_HOST *) SCpnt->device->host->hostdata)->ioc->sh->host_no,
-			SCpnt->device->id,SCpnt->device->lun));
 		SCpnt->result = DID_IMM_RETRY << 16;
 		done(SCpnt);
 		return 0;
 	}
 
-	err = mptscsih_qcmd(SCpnt,done);
-#ifdef DMPT_DEBUG_FC
-	if (unlikely(err)) {
-		dfcprintk ((MYIOC_s_INFO_FMT
-			"mptfc_qcmd.%d: %d:%d, mptscsih_qcmd returns non-zero, (%x).\n",
-			((MPT_SCSI_HOST *) SCpnt->device->host->hostdata)->ioc->name,
-			((MPT_SCSI_HOST *) SCpnt->device->host->hostdata)->ioc->sh->host_no,
-			SCpnt->device->id,SCpnt->device->lun,err));
-	}
-#endif
-	return err;
+	return mptscsih_qcmd(SCpnt,done);
 }
 
 /*
@@ -1041,7 +1039,7 @@ mptfc_setup_reset(struct work_struct *wo
 
 			pn = (u64)ri->pg0.WWPN.High << 32 |
 			     (u64)ri->pg0.WWPN.Low;
-			dfcprintk ((MYIOC_s_INFO_FMT
+			dfcprintk (ioc, printk(MYIOC_s_DEBUG_FMT
 				"mptfc_setup_reset.%d: %llx deleted\n",
 				ioc->name,
 				ioc->sh->host_no,
@@ -1088,7 +1086,7 @@ mptfc_rescan_devices(struct work_struct 
 
 			pn = (u64)ri->pg0.WWPN.High << 32 |
 			     (u64)ri->pg0.WWPN.Low;
-			dfcprintk ((MYIOC_s_INFO_FMT
+			dfcprintk (ioc, printk(MYIOC_s_DEBUG_FMT
 				"mptfc_rescan.%d: %llx deleted\n",
 				ioc->name,
 				ioc->sh->host_no,
@@ -1212,7 +1210,7 @@ mptfc_probe(struct pci_dev *pdev, const 
 
 	if (numSGE < sh->sg_tablesize) {
 		/* Reset this value */
-		dprintk((MYIOC_s_INFO_FMT
+		dprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		  "Resetting sg_tablesize to %d from %d\n",
 		  ioc->name, numSGE, sh->sg_tablesize));
 		sh->sg_tablesize = numSGE;
@@ -1232,7 +1230,7 @@ mptfc_probe(struct pci_dev *pdev, const 
 		goto out_mptfc_probe;
 	}
 
-	dprintk((MYIOC_s_INFO_FMT "ScsiLookup @ %p\n",
+	dprintk(ioc, printk(MYIOC_s_DEBUG_FMT "ScsiLookup @ %p\n",
 		 ioc->name, hd->ScsiLookup));
 
 	/* Clear the TM flags
@@ -1264,7 +1262,7 @@ mptfc_probe(struct pci_dev *pdev, const 
 	sh->transportt = mptfc_transport_template;
 	error = scsi_add_host (sh, &ioc->pcidev->dev);
 	if(error) {
-		dprintk((KERN_ERR MYNAM
+		dprintk(ioc, printk(KERN_ERR MYNAM
 		  "scsi_add_host failed\n"));
 		goto out_mptfc_probe;
 	}
@@ -1323,7 +1321,7 @@ mptfc_event_process(MPT_ADAPTER *ioc, Ev
 	unsigned long flags;
 	int rc=1;
 
-	devtverboseprintk((MYIOC_s_INFO_FMT "MPT event (=%02Xh) routed to SCSI host driver!\n",
+	devtverboseprintk(ioc, printk(MYIOC_s_DEBUG_FMT "MPT event (=%02Xh) routed to SCSI host driver!\n",
 			ioc->name, event));
 
 	if (ioc->sh == NULL ||
@@ -1357,8 +1355,8 @@ mptfc_ioc_reset(MPT_ADAPTER *ioc, int re
 		return rc;
 
 
-	dtmprintk((KERN_WARNING MYNAM
-		": IOC %s_reset routed to FC host driver!\n",
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		": IOC %s_reset routed to FC host driver!\n",ioc->name,
 		reset_phase==MPT_IOC_SETUP_RESET ? "setup" : (
 		reset_phase==MPT_IOC_PRE_RESET ? "pre" : "post")));
 
@@ -1413,15 +1411,8 @@ mptfc_init(void)
 	mptfcTaskCtx = mpt_register(mptscsih_taskmgmt_complete, MPTFC_DRIVER);
 	mptfcInternalCtx = mpt_register(mptscsih_scandv_complete, MPTFC_DRIVER);
 
-	if (mpt_event_register(mptfcDoneCtx, mptfc_event_process) == 0) {
-		devtverboseprintk((KERN_INFO MYNAM
-		  ": Registered for IOC event notifications\n"));
-	}
-
-	if (mpt_reset_register(mptfcDoneCtx, mptfc_ioc_reset) == 0) {
-		dprintk((KERN_INFO MYNAM
-		  ": Registered for IOC reset notifications\n"));
-	}
+	mpt_event_register(mptfcDoneCtx, mptfc_event_process);
+	mpt_reset_register(mptfcDoneCtx, mptfc_ioc_reset);
 
 	error = pci_register_driver(&mptfc_driver);
 	if (error)
@@ -1486,12 +1477,7 @@ mptfc_exit(void)
 	fc_release_transport(mptfc_transport_template);
 
 	mpt_reset_deregister(mptfcDoneCtx);
-	dprintk((KERN_INFO MYNAM
-	  ": Deregistered for IOC reset notifications\n"));
-
 	mpt_event_deregister(mptfcDoneCtx);
-	dprintk((KERN_INFO MYNAM
-	  ": Deregistered for IOC event notifications\n"));
 
 	mpt_deregister(mptfcInternalCtx);
 	mpt_deregister(mptfcTaskCtx);
diff -Naurp b/drivers/message/fusion/mptlan.c a/drivers/message/fusion/mptlan.c
--- b/drivers/message/fusion/mptlan.c	2007-07-23 14:24:35.000000000 +0530
+++ a/drivers/message/fusion/mptlan.c	2007-07-23 16:45:01.000000000 +0530
@@ -1524,8 +1524,7 @@ static int __init mpt_lan_init (void)
 
 	dlprintk((KERN_INFO MYNAM ": Registered for IOC reset notifications\n"));
 	
-	if (mpt_device_driver_register(&mptlan_driver, MPTLAN_DRIVER))
-		dprintk((KERN_INFO MYNAM ": failed to register dd callbacks\n"));
+	mpt_device_driver_register(&mptlan_driver, MPTLAN_DRIVER);
 	return 0;
 }
 
diff -Naurp b/drivers/message/fusion/mptsas.c a/drivers/message/fusion/mptsas.c
--- b/drivers/message/fusion/mptsas.c	2007-07-23 14:24:35.000000000 +0530
+++ a/drivers/message/fusion/mptsas.c	2007-07-23 16:44:36.000000000 +0530
@@ -201,103 +201,91 @@ struct mptsas_enclosure {
 	u8	sep_channel;		/* SEP channel logical channel id */
 };
 
-#ifdef MPT_DEBUG_SAS
-static void mptsas_print_phy_data(MPI_SAS_IO_UNIT0_PHY_DATA *phy_data)
+static void mptsas_print_phy_data(MPT_ADAPTER *ioc,
+					MPI_SAS_IO_UNIT0_PHY_DATA *phy_data)
 {
-	printk("---- IO UNIT PAGE 0 ------------\n");
-	printk("Handle=0x%X\n",
-		le16_to_cpu(phy_data->AttachedDeviceHandle));
-	printk("Controller Handle=0x%X\n",
-		le16_to_cpu(phy_data->ControllerDevHandle));
-	printk("Port=0x%X\n", phy_data->Port);
-	printk("Port Flags=0x%X\n", phy_data->PortFlags);
-	printk("PHY Flags=0x%X\n", phy_data->PhyFlags);
-	printk("Negotiated Link Rate=0x%X\n", phy_data->NegotiatedLinkRate);
-	printk("Controller PHY Device Info=0x%X\n",
-		le32_to_cpu(phy_data->ControllerPhyDeviceInfo));
-	printk("DiscoveryStatus=0x%X\n",
-		le32_to_cpu(phy_data->DiscoveryStatus));
-	printk("\n");
+	dsasprintk(ioc, printk(KERN_DEBUG "---- IO UNIT PAGE 0 ------------\n"));
+	dsasprintk(ioc, printk(KERN_DEBUG "Handle=0x%X\n",
+		le16_to_cpu(phy_data->AttachedDeviceHandle)));
+	dsasprintk(ioc, printk(KERN_DEBUG "Controller Handle=0x%X\n",
+		le16_to_cpu(phy_data->ControllerDevHandle)));
+	dsasprintk(ioc, printk(KERN_DEBUG "Port=0x%X\n", phy_data->Port));
+	dsasprintk(ioc, printk(KERN_DEBUG "Port Flags=0x%X\n", phy_data->PortFlags));
+	dsasprintk(ioc, printk(KERN_DEBUG "PHY Flags=0x%X\n", phy_data->PhyFlags));
+	dsasprintk(ioc, printk(KERN_DEBUG "Negotiated Link Rate=0x%X\n", phy_data->NegotiatedLinkRate));
+	dsasprintk(ioc, printk(KERN_DEBUG "Controller PHY Device Info=0x%X\n",
+		le32_to_cpu(phy_data->ControllerPhyDeviceInfo)));
+	dsasprintk(ioc, printk(KERN_DEBUG "DiscoveryStatus=0x%X\n\n",
+		le32_to_cpu(phy_data->DiscoveryStatus)));
 }
 
-static void mptsas_print_phy_pg0(SasPhyPage0_t *pg0)
+static void mptsas_print_phy_pg0(MPT_ADAPTER *ioc, SasPhyPage0_t *pg0)
 {
 	__le64 sas_address;
 
 	memcpy(&sas_address, &pg0->SASAddress, sizeof(__le64));
 
-	printk("---- SAS PHY PAGE 0 ------------\n");
-	printk("Attached Device Handle=0x%X\n",
-			le16_to_cpu(pg0->AttachedDevHandle));
-	printk("SAS Address=0x%llX\n",
-			(unsigned long long)le64_to_cpu(sas_address));
-	printk("Attached PHY Identifier=0x%X\n", pg0->AttachedPhyIdentifier);
-	printk("Attached Device Info=0x%X\n",
-			le32_to_cpu(pg0->AttachedDeviceInfo));
-	printk("Programmed Link Rate=0x%X\n", pg0->ProgrammedLinkRate);
-	printk("Change Count=0x%X\n", pg0->ChangeCount);
-	printk("PHY Info=0x%X\n", le32_to_cpu(pg0->PhyInfo));
-	printk("\n");
-}
-
-static void mptsas_print_phy_pg1(SasPhyPage1_t *pg1)
-{
-	printk("---- SAS PHY PAGE 1 ------------\n");
-	printk("Invalid Dword Count=0x%x\n", pg1->InvalidDwordCount);
-	printk("Running Disparity Error Count=0x%x\n",
-			pg1->RunningDisparityErrorCount);
-	printk("Loss Dword Synch Count=0x%x\n", pg1->LossDwordSynchCount);
-	printk("PHY Reset Problem Count=0x%x\n", pg1->PhyResetProblemCount);
-	printk("\n");
+	dsasprintk(ioc, printk(KERN_DEBUG "---- SAS PHY PAGE 0 ------------\n"));
+	dsasprintk(ioc, printk(KERN_DEBUG "Attached Device Handle=0x%X\n",
+			le16_to_cpu(pg0->AttachedDevHandle)));
+	dsasprintk(ioc, printk(KERN_DEBUG "SAS Address=0x%llX\n",
+			(unsigned long long)le64_to_cpu(sas_address)));
+	dsasprintk(ioc, printk(KERN_DEBUG "Attached PHY Identifier=0x%X\n", pg0->AttachedPhyIdentifier));
+	dsasprintk(ioc, printk(KERN_DEBUG "Attached Device Info=0x%X\n",
+			le32_to_cpu(pg0->AttachedDeviceInfo)));
+	dsasprintk(ioc, printk(KERN_DEBUG "Programmed Link Rate=0x%X\n", pg0->ProgrammedLinkRate));
+	dsasprintk(ioc, printk(KERN_DEBUG "Change Count=0x%X\n", pg0->ChangeCount));
+	dsasprintk(ioc, printk(KERN_DEBUG "PHY Info=0x%X\n\n", le32_to_cpu(pg0->PhyInfo)));
+}
+
+static void mptsas_print_phy_pg1(MPT_ADAPTER *ioc, SasPhyPage1_t *pg1)
+{
+	dsasprintk(ioc, printk(KERN_DEBUG "---- SAS PHY PAGE 1 ------------\n"));
+	dsasprintk(ioc, printk(KERN_DEBUG "Invalid Dword Count=0x%x\n", pg1->InvalidDwordCount));
+	dsasprintk(ioc, printk(KERN_DEBUG "Running Disparity Error Count=0x%x\n",
+			pg1->RunningDisparityErrorCount));
+	dsasprintk(ioc, printk(KERN_DEBUG "Loss Dword Synch Count=0x%x\n", pg1->LossDwordSynchCount));
+	dsasprintk(ioc, printk(KERN_DEBUG "PHY Reset Problem Count=0x%x\n\n", pg1->PhyResetProblemCount));
 }
 
-static void mptsas_print_device_pg0(SasDevicePage0_t *pg0)
+static void mptsas_print_device_pg0(MPT_ADAPTER *ioc, SasDevicePage0_t *pg0)
 {
 	__le64 sas_address;
 
 	memcpy(&sas_address, &pg0->SASAddress, sizeof(__le64));
 
-	printk("---- SAS DEVICE PAGE 0 ---------\n");
-	printk("Handle=0x%X\n" ,le16_to_cpu(pg0->DevHandle));
-	printk("Parent Handle=0x%X\n" ,le16_to_cpu(pg0->ParentDevHandle));
-	printk("Enclosure Handle=0x%X\n", le16_to_cpu(pg0->EnclosureHandle));
-	printk("Slot=0x%X\n", le16_to_cpu(pg0->Slot));
-	printk("SAS Address=0x%llX\n", (unsigned long long)
-	    le64_to_cpu(sas_address));
-	printk("Target ID=0x%X\n", pg0->TargetID);
-	printk("Bus=0x%X\n", pg0->Bus);
+	dsasprintk(ioc, printk(KERN_DEBUG "---- SAS DEVICE PAGE 0 ---------\n"));
+	dsasprintk(ioc, printk(KERN_DEBUG "Handle=0x%X\n" ,le16_to_cpu(pg0->DevHandle)));
+	dsasprintk(ioc, printk(KERN_DEBUG "Parent Handle=0x%X\n" ,le16_to_cpu(pg0->ParentDevHandle)));
+	dsasprintk(ioc, printk(KERN_DEBUG "Enclosure Handle=0x%X\n", le16_to_cpu(pg0->EnclosureHandle)));
+	dsasprintk(ioc, printk(KERN_DEBUG "Slot=0x%X\n", le16_to_cpu(pg0->Slot)));
+	dsasprintk(ioc, printk(KERN_DEBUG "SAS Address=0x%llX\n", (unsigned long long)
+	    le64_to_cpu(sas_address)));
+	dsasprintk(ioc, printk(KERN_DEBUG "Target ID=0x%X\n", pg0->TargetID));
+	dsasprintk(ioc, printk(KERN_DEBUG "Bus=0x%X\n", pg0->Bus));
 	/* The PhyNum field specifies the PHY number of the parent
 	 * device this device is linked to
 	 */
-	printk("Parent Phy Num=0x%X\n", pg0->PhyNum);
-	printk("Access Status=0x%X\n", le16_to_cpu(pg0->AccessStatus));
-	printk("Device Info=0x%X\n", le32_to_cpu(pg0->DeviceInfo));
-	printk("Flags=0x%X\n", le16_to_cpu(pg0->Flags));
-	printk("Physical Port=0x%X\n", pg0->PhysicalPort);
-	printk("\n");
-}
-
-static void mptsas_print_expander_pg1(SasExpanderPage1_t *pg1)
-{
-	printk("---- SAS EXPANDER PAGE 1 ------------\n");
-
-	printk("Physical Port=0x%X\n", pg1->PhysicalPort);
-	printk("PHY Identifier=0x%X\n", pg1->PhyIdentifier);
-	printk("Negotiated Link Rate=0x%X\n", pg1->NegotiatedLinkRate);
-	printk("Programmed Link Rate=0x%X\n", pg1->ProgrammedLinkRate);
-	printk("Hardware Link Rate=0x%X\n", pg1->HwLinkRate);
-	printk("Owner Device Handle=0x%X\n",
-			le16_to_cpu(pg1->OwnerDevHandle));
-	printk("Attached Device Handle=0x%X\n",
-			le16_to_cpu(pg1->AttachedDevHandle));
-}
-#else
-#define mptsas_print_phy_data(phy_data)		do { } while (0)
-#define mptsas_print_phy_pg0(pg0)		do { } while (0)
-#define mptsas_print_phy_pg1(pg1)		do { } while (0)
-#define mptsas_print_device_pg0(pg0)		do { } while (0)
-#define mptsas_print_expander_pg1(pg1)		do { } while (0)
-#endif
+	dsasprintk(ioc, printk(KERN_DEBUG "Parent Phy Num=0x%X\n", pg0->PhyNum));
+	dsasprintk(ioc, printk(KERN_DEBUG "Access Status=0x%X\n", le16_to_cpu(pg0->AccessStatus)));
+	dsasprintk(ioc, printk(KERN_DEBUG "Device Info=0x%X\n", le32_to_cpu(pg0->DeviceInfo)));
+	dsasprintk(ioc, printk(KERN_DEBUG "Flags=0x%X\n", le16_to_cpu(pg0->Flags)));
+	dsasprintk(ioc, printk(KERN_DEBUG "Physical Port=0x%X\n\n", pg0->PhysicalPort));
+}
+
+static void mptsas_print_expander_pg1(MPT_ADAPTER *ioc, SasExpanderPage1_t *pg1)
+{
+	dsasprintk(ioc, printk(KERN_DEBUG "---- SAS EXPANDER PAGE 1 ------------\n"));
+	dsasprintk(ioc, printk(KERN_DEBUG "Physical Port=0x%X\n", pg1->PhysicalPort));
+	dsasprintk(ioc, printk(KERN_DEBUG "PHY Identifier=0x%X\n", pg1->PhyIdentifier));
+	dsasprintk(ioc, printk(KERN_DEBUG "Negotiated Link Rate=0x%X\n", pg1->NegotiatedLinkRate));
+	dsasprintk(ioc, printk(KERN_DEBUG "Programmed Link Rate=0x%X\n", pg1->ProgrammedLinkRate));
+	dsasprintk(ioc, printk(KERN_DEBUG "Hardware Link Rate=0x%X\n", pg1->HwLinkRate));
+	dsasprintk(ioc, printk(KERN_DEBUG "Owner Device Handle=0x%X\n",
+			le16_to_cpu(pg1->OwnerDevHandle)));
+	dsasprintk(ioc, printk(KERN_DEBUG "Attached Device Handle=0x%X\n\n",
+			le16_to_cpu(pg1->AttachedDevHandle)));
+}
 
 static inline MPT_ADAPTER *phy_to_ioc(struct sas_phy *phy)
 {
@@ -354,7 +342,7 @@ mptsas_is_end_device(struct mptsas_devin
 
 /* no mutex */
 static void
-mptsas_port_delete(struct mptsas_portinfo_details * port_details)
+mptsas_port_delete(MPT_ADAPTER *ioc, struct mptsas_portinfo_details * port_details)
 {
 	struct mptsas_portinfo *port_info;
 	struct mptsas_phyinfo *phy_info;
@@ -366,7 +354,7 @@ mptsas_port_delete(struct mptsas_portinf
 	port_info = port_details->port_info;
 	phy_info = port_info->phy_info;
 
-	dsaswideprintk((KERN_DEBUG "%s: [%p]: num_phys=%02d "
+	dsaswideprintk(ioc, printk(KERN_DEBUG "%s: [%p]: num_phys=%02d "
 	    "bitmask=0x%016llX\n", __FUNCTION__, port_details,
 	    port_details->num_phys, (unsigned long long)
 	    port_details->phy_bitmask));
@@ -390,20 +378,19 @@ mptsas_get_rphy(struct mptsas_phyinfo *p
 }
 
 static inline void
-mptsas_set_rphy(struct mptsas_phyinfo *phy_info, struct sas_rphy *rphy)
+mptsas_set_rphy(MPT_ADAPTER *ioc, struct mptsas_phyinfo *phy_info, struct sas_rphy *rphy)
 {
 	if (phy_info->port_details) {
 		phy_info->port_details->rphy = rphy;
-		dsaswideprintk((KERN_DEBUG "sas_rphy_add: rphy=%p\n", rphy));
+		dsaswideprintk(ioc, printk(KERN_DEBUG "sas_rphy_add: rphy=%p\n", rphy));
 	}
 
-#ifdef MPT_DEBUG_SAS_WIDE
 	if (rphy) {
-		dev_printk(KERN_DEBUG, &rphy->dev, "add:");
-		printk("rphy=%p release=%p\n",
-			rphy, rphy->dev.release);
+		dsaswideprintk(ioc, dev_printk(KERN_DEBUG,
+		    &rphy->dev, "add:"));
+		dsaswideprintk(ioc, printk(KERN_DEBUG "rphy=%p release=%p\n",
+			rphy, rphy->dev.release));
 	}
-#endif
 }
 
 static inline struct sas_port *
@@ -416,18 +403,17 @@ mptsas_get_port(struct mptsas_phyinfo *p
 }
 
 static inline void
-mptsas_set_port(struct mptsas_phyinfo *phy_info, struct sas_port *port)
+mptsas_set_port(MPT_ADAPTER *ioc, struct mptsas_phyinfo *phy_info, struct sas_port *port)
 {
 	if (phy_info->port_details)
 		phy_info->port_details->port = port;
 
-#ifdef MPT_DEBUG_SAS_WIDE
 	if (port) {
-		dev_printk(KERN_DEBUG, &port->dev, "add: ");
-		printk("port=%p release=%p\n",
-			port, port->dev.release);
+		dsaswideprintk(ioc, dev_printk(KERN_DEBUG,
+		    &port->dev, "add:"));
+		dsaswideprintk(ioc, printk(KERN_DEBUG "port=%p release=%p\n",
+			port, port->dev.release));
 	}
-#endif
 }
 
 static inline struct scsi_target *
@@ -477,7 +463,7 @@ mptsas_setup_wide_ports(MPT_ADAPTER *ioc
 		 * Removing a phy from a port, letting the last
 		 * phy be removed by firmware events.
 		 */
-		dsaswideprintk((KERN_DEBUG
+		dsaswideprintk(ioc, printk(KERN_DEBUG
 			"%s: [%p]: deleting phy = %d\n",
 			__FUNCTION__, port_details, i));
 		port_details->num_phys--;
@@ -493,7 +479,7 @@ mptsas_setup_wide_ports(MPT_ADAPTER *ioc
 	phy_info = port_info->phy_info;
 	for (i = 0 ; i < port_info->num_phys ; i++, phy_info++) {
 		sas_address = phy_info->attached.sas_address;
-		dsaswideprintk((KERN_DEBUG "phy_id=%d sas_address=0x%018llX\n",
+		dsaswideprintk(ioc, printk(KERN_DEBUG "phy_id=%d sas_address=0x%018llX\n",
 		    i, (unsigned long long)sas_address));
 		if (!sas_address)
 			continue;
@@ -512,7 +498,7 @@ mptsas_setup_wide_ports(MPT_ADAPTER *ioc
 				port_details->phy_bitmask |=
 				    (1 << phy_info->phy_id);
 			phy_info->sas_port_add_phy=1;
-			dsaswideprintk((KERN_DEBUG "\t\tForming port\n\t\t"
+			dsaswideprintk(ioc, printk(KERN_DEBUG "\t\tForming port\n\t\t"
 			    "phy_id=%d sas_address=0x%018llX\n",
 			    i, (unsigned long long)sas_address));
 			phy_info->port_details = port_details;
@@ -529,7 +515,7 @@ mptsas_setup_wide_ports(MPT_ADAPTER *ioc
 				continue;
 			if (phy_info_cmp->port_details == port_details )
 				continue;
-			dsaswideprintk((KERN_DEBUG
+			dsaswideprintk(ioc, printk(KERN_DEBUG
 			    "\t\tphy_id=%d sas_address=0x%018llX\n",
 			    j, (unsigned long long)
 			    phy_info_cmp->attached.sas_address));
@@ -559,21 +545,19 @@ mptsas_setup_wide_ports(MPT_ADAPTER *ioc
 
  out:
 
-#ifdef MPT_DEBUG_SAS_WIDE
 	for (i = 0; i < port_info->num_phys; i++) {
 		port_details = port_info->phy_info[i].port_details;
 		if (!port_details)
 			continue;
-		dsaswideprintk((KERN_DEBUG
+		dsaswideprintk(ioc, printk(KERN_DEBUG
 		    "%s: [%p]: phy_id=%02d num_phys=%02d "
 		    "bitmask=0x%016llX\n", __FUNCTION__,
 		    port_details, i, port_details->num_phys,
 		    (unsigned long long)port_details->phy_bitmask));
-		dsaswideprintk((KERN_DEBUG"\t\tport = %p rphy=%p\n",
+		dsaswideprintk(ioc, printk(KERN_DEBUG"\t\tport = %p rphy=%p\n",
 			port_details->port, port_details->rphy));
 	}
-	dsaswideprintk((KERN_DEBUG"\n"));
-#endif
+	dsaswideprintk(ioc, printk(KERN_DEBUG"\n"));
 	mutex_unlock(&ioc->sas_topology_mutex);
 }
 
@@ -622,7 +606,7 @@ mptsas_target_reset(MPT_ADAPTER *ioc, u8
 	SCSITaskMgmt_t	*pScsiTm;
 
 	if ((mf = mpt_get_msg_frame(ioc->TaskCtx, ioc)) == NULL) {
-		dfailprintk((MYIOC_s_WARN_FMT "%s, no msg frames @%d!!\n",
+		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT "%s, no msg frames @%d!!\n",
 		    ioc->name,__FUNCTION__, __LINE__));
 		return 0;
 	}
@@ -637,12 +621,12 @@ mptsas_target_reset(MPT_ADAPTER *ioc, u8
 	pScsiTm->TaskType = MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET;
 	pScsiTm->MsgFlags = MPI_SCSITASKMGMT_MSGFLAGS_LIPRESET_RESET_OPTION;
 
-	DBG_DUMP_TM_REQUEST_FRAME(mf);
+	DBG_DUMP_TM_REQUEST_FRAME(ioc, (u32 *)mf);
 
 	if (mpt_send_handshake_request(ioc->TaskCtx, ioc,
 	    sizeof(SCSITaskMgmt_t), (u32 *)mf, NO_SLEEP)) {
 		mpt_free_msg_frame(ioc, mf);
-		dfailprintk((MYIOC_s_WARN_FMT "%s, tm handshake failed @%d!!\n",
+		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT "%s, tm handshake failed @%d!!\n",
 		    ioc->name,__FUNCTION__, __LINE__));
 		return 0;
 	}
@@ -681,7 +665,7 @@ mptsas_target_reset_queue(MPT_ADAPTER *i
 	target_reset_list = kzalloc(sizeof(*target_reset_list),
 	    GFP_ATOMIC);
 	if (!target_reset_list) {
-		dfailprintk((MYIOC_s_WARN_FMT "%s, failed to allocate mem @%d..!!\n",
+		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT "%s, failed to allocate mem @%d..!!\n",
 		    ioc->name,__FUNCTION__, __LINE__));
 		return;
 	}
@@ -748,7 +732,7 @@ mptsas_dev_reset_complete(MPT_ADAPTER *i
 
 	ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
 	if (!ev) {
-		dfailprintk((MYIOC_s_WARN_FMT "%s, failed to allocate mem @%d..!!\n",
+		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT "%s, failed to allocate mem @%d..!!\n",
 		    ioc->name,__FUNCTION__, __LINE__));
 		return;
 	}
@@ -1168,7 +1152,7 @@ static int mptsas_get_linkerrors(struct 
 	if (error)
 		goto out_free_consistent;
 
-	mptsas_print_phy_pg1(buffer);
+	mptsas_print_phy_pg1(ioc, buffer);
 
 	phy->invalid_dword_count = le32_to_cpu(buffer->InvalidDwordCount);
 	phy->running_disparity_error_count =
@@ -1397,7 +1381,7 @@ mptsas_sas_io_unit_pg0(MPT_ADAPTER *ioc,
 	    le16_to_cpu(buffer->NvdataVersionDefault);
 
 	for (i = 0; i < port_info->num_phys; i++) {
-		mptsas_print_phy_data(&buffer->PhyData[i]);
+		mptsas_print_phy_data(ioc, &buffer->PhyData[i]);
 		port_info->phy_info[i].phy_id = i;
 		port_info->phy_info[i].port_id =
 		    buffer->PhyData[i].Port;
@@ -1522,7 +1506,7 @@ mptsas_sas_phy_pg0(MPT_ADAPTER *ioc, str
 	if (error)
 		goto out_free_consistent;
 
-	mptsas_print_phy_pg0(buffer);
+	mptsas_print_phy_pg0(ioc, buffer);
 
 	phy_info->hw_link_rate = buffer->HwLinkRate;
 	phy_info->programmed_link_rate = buffer->ProgrammedLinkRate;
@@ -1589,7 +1573,7 @@ mptsas_sas_device_pg0(MPT_ADAPTER *ioc, 
 	if (error)
 		goto out_free_consistent;
 
-	mptsas_print_device_pg0(buffer);
+	mptsas_print_device_pg0(ioc, buffer);
 
 	device_info->handle = le16_to_cpu(buffer->DevHandle);
 	device_info->handle_parent = le16_to_cpu(buffer->ParentDevHandle);
@@ -1737,7 +1721,7 @@ mptsas_sas_expander_pg1(MPT_ADAPTER *ioc
 		goto out_free_consistent;
 
 
-	mptsas_print_expander_pg1(buffer);
+	mptsas_print_expander_pg1(ioc, buffer);
 
 	/* save config data */
 	phy_info->phy_id = buffer->PhyIdentifier;
@@ -1946,17 +1930,17 @@ static int mptsas_probe_one_phy(struct d
 			}
 			error = sas_port_add(port);
 			if (error) {
-				dfailprintk((MYIOC_s_ERR_FMT
+				dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 					"%s: exit at line=%d\n", ioc->name,
 					__FUNCTION__, __LINE__));
 				goto out;
 			}
-			mptsas_set_port(phy_info, port);
-			dsaswideprintk((KERN_DEBUG
+			mptsas_set_port(ioc, phy_info, port);
+			dsaswideprintk(ioc, printk(KERN_DEBUG
 			    "sas_port_alloc: port=%p dev=%p port_id=%d\n",
 			    port, dev, port->port_identifier));
 		}
-		dsaswideprintk((KERN_DEBUG "sas_port_add_phy: phy_id=%d\n",
+		dsaswideprintk(ioc, printk(KERN_DEBUG "sas_port_add_phy: phy_id=%d\n",
 		    phy_info->phy_id));
 		sas_port_add_phy(port, phy_info->phy);
 		phy_info->sas_port_add_phy = 0;
@@ -2017,7 +2001,7 @@ static int mptsas_probe_one_phy(struct d
 			break;
 		}
 		if (!rphy) {
-			dfailprintk((MYIOC_s_ERR_FMT
+			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 				"%s: exit at line=%d\n", ioc->name,
 				__FUNCTION__, __LINE__));
 			goto out;
@@ -2026,13 +2010,13 @@ static int mptsas_probe_one_phy(struct d
 		rphy->identify = identify;
 		error = sas_rphy_add(rphy);
 		if (error) {
-			dfailprintk((MYIOC_s_ERR_FMT
+			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 				"%s: exit at line=%d\n", ioc->name,
 				__FUNCTION__, __LINE__));
 			sas_rphy_free(rphy);
 			goto out;
 		}
-		mptsas_set_rphy(phy_info, rphy);
+		mptsas_set_rphy(ioc, phy_info, rphy);
 	}
 
  out:
@@ -2258,18 +2242,17 @@ mptsas_delete_expander_phys(MPT_ADAPTER 
 				if (phy_info->attached.sas_address !=
 					expander_sas_address)
 					continue;
-#ifdef MPT_DEBUG_SAS_WIDE
-				dev_printk(KERN_DEBUG, &port->dev,
-				    "delete port (%d)\n", port->port_identifier);
-#endif
+				dsaswideprintk(ioc,
+					dev_printk(KERN_DEBUG, &port->dev,
+				    	"delete port (%d)\n", port->port_identifier));
 				sas_port_delete(port);
-				mptsas_port_delete(phy_info->port_details);
+				mptsas_port_delete(ioc, phy_info->port_details);
 			}
  next_port:
 
 			phy_info = port_info->phy_info;
 			for (i = 0; i < port_info->num_phys; i++, phy_info++)
-				mptsas_port_delete(phy_info->port_details);
+				mptsas_port_delete(ioc, phy_info->port_details);
 
 			list_del(&port_info->list);
 			kfree(port_info->phy_info);
@@ -2555,7 +2538,7 @@ mptsas_hotplug_work(struct work_struct *
 				    (MPI_SAS_DEVICE_PGAD_FORM_BUS_TARGET_ID <<
 				     MPI_SAS_DEVICE_PGAD_FORM_SHIFT),
 				    (ev->channel << 8) + ev->id)) {
-					dfailprintk((MYIOC_s_ERR_FMT
+					dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 					"%s: exit at line=%d\n", ioc->name,
 						__FUNCTION__, __LINE__));
 					break;
@@ -2575,20 +2558,20 @@ mptsas_hotplug_work(struct work_struct *
 		 * Sanity checks, for non-existing phys and remote rphys.
 		 */
 		if (!phy_info){
-			dfailprintk((MYIOC_s_ERR_FMT
+			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 				"%s: exit at line=%d\n", ioc->name,
 				__FUNCTION__, __LINE__));
 			break;
 		}
 		if (!phy_info->port_details) {
-			dfailprintk((MYIOC_s_ERR_FMT
+			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 				"%s: exit at line=%d\n", ioc->name,
 			       	__FUNCTION__, __LINE__));
 			break;
 		}
 		rphy = mptsas_get_rphy(phy_info);
 		if (!rphy) {
-			dfailprintk((MYIOC_s_ERR_FMT
+			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 				"%s: exit at line=%d\n", ioc->name,
 			       	__FUNCTION__, __LINE__));
 			break;
@@ -2596,7 +2579,7 @@ mptsas_hotplug_work(struct work_struct *
 
 		port = mptsas_get_port(phy_info);
 		if (!port) {
-			dfailprintk((MYIOC_s_ERR_FMT
+			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 				"%s: exit at line=%d\n", ioc->name,
 			       	__FUNCTION__, __LINE__));
 			break;
@@ -2607,7 +2590,7 @@ mptsas_hotplug_work(struct work_struct *
 			vtarget = starget->hostdata;
 
 			if (!vtarget) {
-				dfailprintk((MYIOC_s_ERR_FMT
+				dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 					"%s: exit at line=%d\n", ioc->name,
 					__FUNCTION__, __LINE__));
 				break;
@@ -2645,12 +2628,10 @@ mptsas_hotplug_work(struct work_struct *
 		printk(MYIOC_s_INFO_FMT
 		       "removing %s device, channel %d, id %d, phy %d\n",
 		       ioc->name, ds, ev->channel, ev->id, phy_info->phy_id);
-#ifdef MPT_DEBUG_SAS_WIDE
 		dev_printk(KERN_DEBUG, &port->dev,
 		    "delete port (%d)\n", port->port_identifier);
-#endif
 		sas_port_delete(port);
-		mptsas_port_delete(phy_info->port_details);
+		mptsas_port_delete(ioc, phy_info->port_details);
 		break;
 	case MPTSAS_ADD_DEVICE:
 
@@ -2664,7 +2645,7 @@ mptsas_hotplug_work(struct work_struct *
 		    (MPI_SAS_DEVICE_PGAD_FORM_BUS_TARGET_ID <<
 		     MPI_SAS_DEVICE_PGAD_FORM_SHIFT),
 			(ev->channel << 8) + ev->id)) {
-				dfailprintk((MYIOC_s_ERR_FMT
+				dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 					"%s: exit at line=%d\n", ioc->name,
 					__FUNCTION__, __LINE__));
 			break;
@@ -2676,7 +2657,7 @@ mptsas_hotplug_work(struct work_struct *
 				sas_device.sas_address);
 
 		if (!phy_info || !phy_info->port_details) {
-			dfailprintk((MYIOC_s_ERR_FMT
+			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 				"%s: exit at line=%d\n", ioc->name,
 			       	__FUNCTION__, __LINE__));
 			break;
@@ -2688,7 +2669,7 @@ mptsas_hotplug_work(struct work_struct *
 			vtarget = starget->hostdata;
 
 			if (!vtarget) {
-				dfailprintk((MYIOC_s_ERR_FMT
+				dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 					"%s: exit at line=%d\n", ioc->name,
 				       	__FUNCTION__, __LINE__));
 				break;
@@ -2711,7 +2692,7 @@ mptsas_hotplug_work(struct work_struct *
 		}
 
 		if (mptsas_get_rphy(phy_info)) {
-			dfailprintk((MYIOC_s_ERR_FMT
+			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 				"%s: exit at line=%d\n", ioc->name,
 			       	__FUNCTION__, __LINE__));
 			if (ev->channel) printk("%d\n", __LINE__);
@@ -2720,7 +2701,7 @@ mptsas_hotplug_work(struct work_struct *
 
 		port = mptsas_get_port(phy_info);
 		if (!port) {
-			dfailprintk((MYIOC_s_ERR_FMT
+			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 				"%s: exit at line=%d\n", ioc->name,
 			       	__FUNCTION__, __LINE__));
 			break;
@@ -2745,7 +2726,7 @@ mptsas_hotplug_work(struct work_struct *
 		mptsas_parse_device_info(&identify, &phy_info->attached);
 		rphy = sas_end_device_alloc(port);
 		if (!rphy) {
-			dfailprintk((MYIOC_s_ERR_FMT
+			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 				"%s: exit at line=%d\n", ioc->name,
 			       	__FUNCTION__, __LINE__));
 			break; /* non-fatal: an rphy can be added later */
@@ -2753,13 +2734,13 @@ mptsas_hotplug_work(struct work_struct *
 
 		rphy->identify = identify;
 		if (sas_rphy_add(rphy)) {
-			dfailprintk((MYIOC_s_ERR_FMT
+			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 				"%s: exit at line=%d\n", ioc->name,
 			       	__FUNCTION__, __LINE__));
 			sas_rphy_free(rphy);
 			break;
 		}
-		mptsas_set_rphy(phy_info, rphy);
+		mptsas_set_rphy(ioc, phy_info, rphy);
 		break;
 	case MPTSAS_ADD_RAID:
 		sdev = scsi_device_lookup(ioc->sh, MPTSAS_RAID_CHANNEL,
@@ -3175,7 +3156,7 @@ mptsas_probe(struct pci_dev *pdev, const
 
 	if (numSGE < sh->sg_tablesize) {
 		/* Reset this value */
-		dprintk((MYIOC_s_INFO_FMT
+		dprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		  "Resetting sg_tablesize to %d from %d\n",
 		  ioc->name, numSGE, sh->sg_tablesize));
 		sh->sg_tablesize = numSGE;
@@ -3193,7 +3174,7 @@ mptsas_probe(struct pci_dev *pdev, const
 		goto out_mptsas_probe;
 	}
 
-	dprintk((MYIOC_s_INFO_FMT "ScsiLookup @ %p\n",
+	dprintk(ioc, printk(MYIOC_s_DEBUG_FMT "ScsiLookup @ %p\n",
 		 ioc->name, hd->ScsiLookup));
 
 	/* Clear the TM flags
@@ -3233,7 +3214,7 @@ mptsas_probe(struct pci_dev *pdev, const
 
 	error = scsi_add_host(sh, &ioc->pcidev->dev);
 	if (error) {
-		dprintk((KERN_ERR MYNAM
+		dprintk(ioc, printk(KERN_ERR MYNAM
 		  "scsi_add_host failed\n"));
 		goto out_mptsas_probe;
 	}
@@ -3261,7 +3242,7 @@ static void __devexit mptsas_remove(stru
 	list_for_each_entry_safe(p, n, &ioc->sas_topology, list) {
 		list_del(&p->list);
 		for (i = 0 ; i < p->num_phys ; i++)
-			mptsas_port_delete(p->phy_info[i].port_details);
+			mptsas_port_delete(ioc, p->phy_info[i].port_details);
 		kfree(p->phy_info);
 		kfree(p);
 	}
@@ -3316,15 +3297,8 @@ mptsas_init(void)
 		mpt_register(mptscsih_scandv_complete, MPTSAS_DRIVER);
 	mptsasMgmtCtx = mpt_register(mptsas_mgmt_done, MPTSAS_DRIVER);
 
-	if (mpt_event_register(mptsasDoneCtx, mptsas_event_process) == 0) {
-		devtverboseprintk((KERN_INFO MYNAM
-		  ": Registered for IOC event notifications\n"));
-	}
-
-	if (mpt_reset_register(mptsasDoneCtx, mptsas_ioc_reset) == 0) {
-		dprintk((KERN_INFO MYNAM
-		  ": Registered for IOC reset notifications\n"));
-	}
+	mpt_event_register(mptsasDoneCtx, mptsas_event_process);
+	mpt_reset_register(mptsasDoneCtx, mptsas_ioc_reset);
 
 	error = pci_register_driver(&mptsas_driver);
 	if (error)
diff -Naurp b/drivers/message/fusion/mptspi.c a/drivers/message/fusion/mptspi.c
--- b/drivers/message/fusion/mptspi.c	2007-07-23 14:24:35.000000000 +0530
+++ a/drivers/message/fusion/mptspi.c	2007-07-23 16:44:44.000000000 +0530
@@ -138,7 +138,9 @@ mptspi_setTargetNegoParms(MPT_SCSI_HOST 
 				else {
 					factor = MPT_ULTRA320;
 					if (scsi_device_qas(sdev)) {
-						ddvprintk((KERN_INFO "Enabling QAS due to byte56=%02x on id=%d!\n", scsi_device_qas(sdev), id));
+						ddvprintk(hd->ioc,
+						printk(KERN_DEBUG "Enabling QAS due to "
+						"byte56=%02x on id=%d!\n", scsi_device_qas(sdev), id));
 						noQas = 0;
 					}
 					if (sdev->type == TYPE_TAPE &&
@@ -225,7 +227,8 @@ mptspi_setTargetNegoParms(MPT_SCSI_HOST 
 		/* Disable QAS in a mixed configuration case
 		 */
 
-		ddvprintk((KERN_INFO "Disabling QAS due to noQas=%02x on id=%d!\n", noQas, id));
+		ddvprintk(hd->ioc, printk(KERN_DEBUG
+			"Disabling QAS due to noQas=%02x on id=%d!\n", noQas, id));
 	}
 }
 
@@ -256,8 +259,8 @@ mptspi_writeIOCPage4(MPT_SCSI_HOST *hd, 
 	/* Get a MF for this command.
 	 */
 	if ((mf = mpt_get_msg_frame(ioc->DoneCtx, ioc)) == NULL) {
-		dfailprintk((MYIOC_s_WARN_FMT "writeIOCPage4 : no msg frames!\n",
-					ioc->name));
+		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT
+				"writeIOCPage4 : no msg frames!\n",ioc->name));
 		return -EAGAIN;
 	}
 
@@ -297,7 +300,7 @@ mptspi_writeIOCPage4(MPT_SCSI_HOST *hd, 
 
 	mpt_add_sge((char *)&pReq->PageBufferSGE, flagsLength, dataDma);
 
-	ddvprintk((MYIOC_s_INFO_FMT
+	ddvprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		"writeIOCPage4: MaxSEP=%d ActiveSEP=%d id=%d bus=%d\n",
 			ioc->name, IOCPage4Ptr->MaxSEP, IOCPage4Ptr->ActiveSEP, id, channel));
 
@@ -422,7 +425,7 @@ static int mptspi_target_alloc(struct sc
 	if (starget->channel == 0 &&
 	    mptspi_is_raid(hd, starget->id)) {
 		vtarget->raidVolume = 1;
-		ddvprintk((KERN_INFO
+		ddvprintk(hd->ioc, printk(KERN_DEBUG
 		    "RAID Volume @ channel=%d id=%d\n", starget->channel,
 		    starget->id));
 	}
@@ -462,7 +465,7 @@ mptspi_target_destroy(struct scsi_target
 static void
 mptspi_print_write_nego(struct _MPT_SCSI_HOST *hd, struct scsi_target *starget, u32 ii)
 {
-	ddvprintk((MYIOC_s_INFO_FMT "id=%d Requested = 0x%08x"
+	ddvprintk(hd->ioc, printk(MYIOC_s_DEBUG_FMT "id=%d Requested = 0x%08x"
 	    " ( %s factor = 0x%02x @ offset = 0x%02x %s%s%s%s%s%s%s%s)\n",
 	    hd->ioc->name, starget->id, ii,
 	    ii & MPI_SCSIDEVPAGE0_NP_WIDE ? "Wide ": "",
@@ -487,7 +490,7 @@ mptspi_print_write_nego(struct _MPT_SCSI
 static void
 mptspi_print_read_nego(struct _MPT_SCSI_HOST *hd, struct scsi_target *starget, u32 ii)
 {
-	ddvprintk((MYIOC_s_INFO_FMT "id=%d Read = 0x%08x"
+	ddvprintk(hd->ioc, printk(MYIOC_s_DEBUG_FMT "id=%d Read = 0x%08x"
 	    " ( %s factor = 0x%02x @ offset = 0x%02x %s%s%s%s%s%s%s%s)\n",
 	    hd->ioc->name, starget->id, ii,
 	    ii & MPI_SCSIDEVPAGE0_NP_WIDE ? "Wide ": "",
@@ -613,7 +616,7 @@ mptscsih_quiesce_raid(MPT_SCSI_HOST *hd,
 	/* Get and Populate a free Frame
 	 */
 	if ((mf = mpt_get_msg_frame(hd->ioc->InternalCtx, hd->ioc)) == NULL) {
-		ddvprintk((MYIOC_s_WARN_FMT "_do_raid: no msg frames!\n",
+		ddvprintk(hd->ioc, printk(MYIOC_s_WARN_FMT "_do_raid: no msg frames!\n",
 					hd->ioc->name));
 		return -EAGAIN;
 	}
@@ -635,7 +638,7 @@ mptscsih_quiesce_raid(MPT_SCSI_HOST *hd,
 	mpt_add_sge((char *)&pReq->ActionDataSGE,
 		MPT_SGE_FLAGS_SSIMPLE_READ | 0, (dma_addr_t) -1);
 
-	ddvprintk((MYIOC_s_INFO_FMT "RAID Volume action=%x channel=%d id=%d\n",
+	ddvprintk(hd->ioc, printk(MYIOC_s_DEBUG_FMT "RAID Volume action=%x channel=%d id=%d\n",
 			hd->ioc->name, pReq->Action, channel, id));
 
 	hd->pLocal = NULL;
@@ -735,7 +738,7 @@ static int mptspi_slave_configure(struct
 	if (ret)
 		return ret;
 
-	ddvprintk((MYIOC_s_INFO_FMT "id=%d min_period=0x%02x"
+	ddvprintk(hd->ioc, printk(MYIOC_s_DEBUG_FMT "id=%d min_period=0x%02x"
 		" max_offset=0x%02x max_width=%d\n", hd->ioc->name,
 		sdev->id, spi_min_period(scsi_target(sdev)),
 		spi_max_offset(scsi_target(sdev)),
@@ -768,10 +771,8 @@ mptspi_qcmd(struct scsi_cmnd *SCpnt, voi
 		return 0;
 	}
 
-#ifdef MPT_DEBUG_DV
 	if (spi_dv_pending(scsi_target(SCpnt->device)))
-		scsi_print_command(SCpnt);
-#endif
+		ddvprintk(hd->ioc, scsi_print_command(SCpnt));
 
 	return mptscsih_qcmd(SCpnt,done);
 }
@@ -1415,7 +1416,7 @@ mptspi_probe(struct pci_dev *pdev, const
 
 	if (numSGE < sh->sg_tablesize) {
 		/* Reset this value */
-		dprintk((MYIOC_s_INFO_FMT
+		dprintk(ioc, printk(MYIOC_s_INFO_FMT
 		  "Resetting sg_tablesize to %d from %d\n",
 		  ioc->name, numSGE, sh->sg_tablesize));
 		sh->sg_tablesize = numSGE;
@@ -1435,7 +1436,7 @@ mptspi_probe(struct pci_dev *pdev, const
 		goto out_mptspi_probe;
 	}
 
-	dprintk((MYIOC_s_INFO_FMT "ScsiLookup @ %p\n",
+	dprintk(ioc, printk(MYIOC_s_DEBUG_FMT "ScsiLookup @ %p\n",
 		 ioc->name, hd->ScsiLookup));
 
 	/* Clear the TM flags
@@ -1463,7 +1464,7 @@ mptspi_probe(struct pci_dev *pdev, const
 	ioc->spi_data.Saf_Te = mpt_saf_te;
 
 	hd->negoNvram = MPT_SCSICFG_USE_NVRAM;
-	ddvprintk((MYIOC_s_INFO_FMT
+	ddvprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		"saf_te %x\n",
 		ioc->name,
 		mpt_saf_te));
@@ -1481,7 +1482,7 @@ mptspi_probe(struct pci_dev *pdev, const
 
 	error = scsi_add_host (sh, &ioc->pcidev->dev);
 	if(error) {
-		dprintk((KERN_ERR MYNAM
+		dprintk(ioc, printk(KERN_ERR MYNAM
 		  "scsi_add_host failed\n"));
 		goto out_mptspi_probe;
 	}
@@ -1536,15 +1537,8 @@ mptspi_init(void)
 	mptspiTaskCtx = mpt_register(mptscsih_taskmgmt_complete, MPTSPI_DRIVER);
 	mptspiInternalCtx = mpt_register(mptscsih_scandv_complete, MPTSPI_DRIVER);
 
-	if (mpt_event_register(mptspiDoneCtx, mptspi_event_process) == 0) {
-		devtverboseprintk((KERN_INFO MYNAM
-		  ": Registered for IOC event notifications\n"));
-	}
-
-	if (mpt_reset_register(mptspiDoneCtx, mptspi_ioc_reset) == 0) {
-		dprintk((KERN_INFO MYNAM
-		  ": Registered for IOC reset notifications\n"));
-	}
+	mpt_event_register(mptspiDoneCtx, mptspi_event_process);
+	mpt_reset_register(mptspiDoneCtx, mptspi_ioc_reset);
 
 	error = pci_register_driver(&mptspi_driver);
 	if (error)
@@ -1564,12 +1558,7 @@ mptspi_exit(void)
 	pci_unregister_driver(&mptspi_driver);
 
 	mpt_reset_deregister(mptspiDoneCtx);
-	dprintk((KERN_INFO MYNAM
-	  ": Deregistered for IOC reset notifications\n"));
-
 	mpt_event_deregister(mptspiDoneCtx);
-	dprintk((KERN_INFO MYNAM
-	  ": Deregistered for IOC event notifications\n"));
 
 	mpt_deregister(mptspiInternalCtx);
 	mpt_deregister(mptspiTaskCtx);
