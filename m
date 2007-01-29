From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 5/9] - fusion - inactive raid support, and raid event bug fix's
Date: Mon, 29 Jan 2007 09:45:37 -0700
Message-ID: <20070129164537.GA1904@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:60598 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520AbXA2QpC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Jan 2007 11:45:02 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

inactive raid support, e.g. exposing hidden raid components
belonging to a volume that are inactive.  Also misc bug fix's for
various raid asyn events.

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>


diff -uarpN b/drivers/message/fusion/mptbase.c a/drivers/message/fusion/mptbase.c
--- b/drivers/message/fusion/mptbase.c	2007-01-28 12:57:29.000000000 -0700
+++ a/drivers/message/fusion/mptbase.c	2007-01-28 12:57:29.000000000 -0700
@@ -184,6 +184,7 @@ static void	mpt_fc_log_info(MPT_ADAPTER 
 static void	mpt_spi_log_info(MPT_ADAPTER *ioc, u32 log_info);
 static void	mpt_sas_log_info(MPT_ADAPTER *ioc, u32 log_info);
 static int	mpt_read_ioc_pg_3(MPT_ADAPTER *ioc);
+static void	mpt_inactive_raid_list_free(MPT_ADAPTER *ioc);
 
 /* module entry point */
 static int  __init    fusion_init  (void);
@@ -1815,6 +1816,13 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 	 *	and we try GetLanConfigPages again...
 	 */
 	if ((ret == 0) && (reason == MPT_HOSTEVENT_IOC_BRINGUP)) {
+
+		/*
+		 * Initalize link list for inactive raid volumes.
+		 */
+		init_MUTEX(&ioc->raid_data.inactive_list_mutex);
+		INIT_LIST_HEAD(&ioc->raid_data.inactive_list);
+
 		if (ioc->bus_type == SAS) {
 
 			/* clear persistency table */
@@ -2021,6 +2029,8 @@ mpt_adapter_disable(MPT_ADAPTER *ioc)
 	}
 
 	kfree(ioc->spi_data.nvram);
+	mpt_inactive_raid_list_free(ioc);
+	kfree(ioc->raid_data.pIocPg2);
 	kfree(ioc->raid_data.pIocPg3);
 	ioc->spi_data.nvram = NULL;
 	ioc->raid_data.pIocPg3 = NULL;
@@ -2417,6 +2427,9 @@ GetIocFacts(MPT_ADAPTER *ioc, int sleepF
 			facts->FWVersion.Word = le32_to_cpu(facts->FWVersion.Word);
 
 		facts->ProductID = le16_to_cpu(facts->ProductID);
+		if ((ioc->facts.ProductID & MPI_FW_HEADER_PID_PROD_MASK)
+		    > MPI_FW_HEADER_PID_PROD_TARGET_SCSI)
+			ioc->ir_firmware = 1;
 		facts->CurrentHostMfaHighAddr =
 				le32_to_cpu(facts->CurrentHostMfaHighAddr);
 		facts->GlobalCredits = le16_to_cpu(facts->GlobalCredits);
@@ -2735,9 +2748,7 @@ SendPortEnable(MPT_ADAPTER *ioc, int por
 
 	/* RAID FW may take a long time to enable
 	 */
-	if (((ioc->facts.ProductID & MPI_FW_HEADER_PID_PROD_MASK)
-	    > MPI_FW_HEADER_PID_PROD_TARGET_SCSI) ||
-	    (ioc->bus_type == SAS)) {
+	if (ioc->ir_firmware || ioc->bus_type == SAS) {
 		rc = mpt_handshake_req_reply_wait(ioc, req_sz,
 		(u32*)&port_enable, reply_sz, (u16*)&reply_buf,
 		300 /*seconds*/, sleepFlag);
@@ -4325,8 +4336,8 @@ mptbase_raid_process_event_data(MPT_ADAP
 	if ((reason >= MPI_EVENT_RAID_RC_PHYSDISK_CREATED &&
 	     reason <= MPI_EVENT_RAID_RC_PHYSDISK_STATUS_CHANGED) ||
 	    (reason == MPI_EVENT_RAID_RC_SMART_DATA)) {
-		printk(MYIOC_s_INFO_FMT "RAID STATUS CHANGE for PhysDisk %d\n",
-			ioc->name, disk);
+		printk(MYIOC_s_INFO_FMT "RAID STATUS CHANGE for PhysDisk %d id=%d\n",
+			ioc->name, disk, volume);
 	} else {
 		printk(MYIOC_s_INFO_FMT "RAID STATUS CHANGE for VolumeID %d\n",
 			ioc->name, volume);
@@ -4727,7 +4738,187 @@ mpt_readScsiDevicePageHeaders(MPT_ADAPTE
 	return 0;
 }
 
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/**
+ * mpt_inactive_raid_list_free
+ *
+ * This clears this link list.
+ *
+ * @ioc - pointer to per adapter structure
+ *
+ **/
+static void
+mpt_inactive_raid_list_free(MPT_ADAPTER *ioc)
+{
+	struct inactive_raid_component_info *component_info, *pNext;
+
+	if (list_empty(&ioc->raid_data.inactive_list))
+		return;
+
+	down(&ioc->raid_data.inactive_list_mutex);
+	list_for_each_entry_safe(component_info, pNext,
+	    &ioc->raid_data.inactive_list, list) {
+		list_del(&component_info->list);
+		kfree(component_info);
+	}
+	up(&ioc->raid_data.inactive_list_mutex);
+}
+
+/**
+ * mpt_inactive_raid_volumes
+ *
+ * This sets up link list of phy_disk_nums for devices belonging in an inactive volume
+ *
+ * @ioc - pointer to per adapter structure
+ * @channel - volume channel
+ * @id - volume target id
+ *
+ *
+ **/
+static void
+mpt_inactive_raid_volumes(MPT_ADAPTER *ioc, u8 channel, u8 id)
+{
+	CONFIGPARMS			cfg;
+	ConfigPageHeader_t		hdr;
+	dma_addr_t			dma_handle;
+	pRaidVolumePage0_t		buffer = NULL;
+	int				i;
+	RaidPhysDiskPage0_t 		phys_disk;
+	struct inactive_raid_component_info *component_info;
+	int				handle_inactive_volumes;
+
+	memset(&cfg, 0 , sizeof(CONFIGPARMS));
+	memset(&hdr, 0 , sizeof(ConfigPageHeader_t));
+	hdr.PageType = MPI_CONFIG_PAGETYPE_RAID_VOLUME;
+	cfg.pageAddr = (channel << 8) + id;
+	cfg.cfghdr.hdr = &hdr;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
+
+	if (mpt_config(ioc, &cfg) != 0)
+		goto out;
+
+	if (!hdr.PageLength)
+		goto out;
+
+	buffer = pci_alloc_consistent(ioc->pcidev, hdr.PageLength * 4,
+	    &dma_handle);
+
+	if (!buffer)
+		goto out;
+
+	cfg.physAddr = dma_handle;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
+
+	if (mpt_config(ioc, &cfg) != 0)
+		goto out;
+
+	if (!buffer->NumPhysDisks)
+		goto out;
+
+	handle_inactive_volumes =
+	   (buffer->VolumeStatus.Flags & MPI_RAIDVOL0_STATUS_FLAG_VOLUME_INACTIVE ||
+	   (buffer->VolumeStatus.Flags & MPI_RAIDVOL0_STATUS_FLAG_ENABLED) == 0 ||
+	    buffer->VolumeStatus.State == MPI_RAIDVOL0_STATUS_STATE_FAILED ||
+	    buffer->VolumeStatus.State == MPI_RAIDVOL0_STATUS_STATE_MISSING) ? 1 : 0;
+
+	if (!handle_inactive_volumes)
+		goto out;
+
+	down(&ioc->raid_data.inactive_list_mutex);
+	for (i = 0; i < buffer->NumPhysDisks; i++) {
+		if(mpt_raid_phys_disk_pg0(ioc,
+		    buffer->PhysDisk[i].PhysDiskNum, &phys_disk) != 0)
+			continue;
+
+		if ((component_info = kmalloc(sizeof (*component_info),
+		 GFP_KERNEL)) == NULL)
+			continue;
+
+		component_info->volumeID = id;
+		component_info->volumeBus = channel;
+		component_info->d.PhysDiskNum = phys_disk.PhysDiskNum;
+		component_info->d.PhysDiskBus = phys_disk.PhysDiskBus;
+		component_info->d.PhysDiskID = phys_disk.PhysDiskID;
+		component_info->d.PhysDiskIOC = phys_disk.PhysDiskIOC;
+
+		list_add_tail(&component_info->list,
+		    &ioc->raid_data.inactive_list);
+	}
+	up(&ioc->raid_data.inactive_list_mutex);
+
+ out:
+	if (buffer)
+		pci_free_consistent(ioc->pcidev, hdr.PageLength * 4, buffer,
+		    dma_handle);
+}
+
+/**
+ *	mpt_raid_phys_disk_pg0 - returns phys disk page zero
+ *	@ioc: Pointer to a Adapter Structure
+ *	@phys_disk_num: io unit unique phys disk num generated by the ioc
+ *	@phys_disk: requested payload data returned
+ *
+ *	Return:
+ *	0 on success
+ *	-EFAULT if read of config page header fails or data pointer not NULL
+ *	-ENOMEM if pci_alloc failed
+ **/
+int
+mpt_raid_phys_disk_pg0(MPT_ADAPTER *ioc, u8 phys_disk_num, pRaidPhysDiskPage0_t phys_disk)
+{
+	CONFIGPARMS		 	cfg;
+	ConfigPageHeader_t	 	hdr;
+	dma_addr_t			dma_handle;
+	pRaidPhysDiskPage0_t		buffer = NULL;
+	int				rc;
+
+	memset(&cfg, 0 , sizeof(CONFIGPARMS));
+	memset(&hdr, 0 , sizeof(ConfigPageHeader_t));
+
+	hdr.PageType = MPI_CONFIG_PAGETYPE_RAID_PHYSDISK;
+	cfg.cfghdr.hdr = &hdr;
+	cfg.physAddr = -1;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
+
+	if (mpt_config(ioc, &cfg) != 0) {
+		rc = -EFAULT;
+		goto out;
+	}
+
+	if (!hdr.PageLength) {
+		rc = -EFAULT;
+		goto out;
+	}
+
+	buffer = pci_alloc_consistent(ioc->pcidev, hdr.PageLength * 4,
+	    &dma_handle);
+
+	if (!buffer) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	cfg.physAddr = dma_handle;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
+	cfg.pageAddr = phys_disk_num;
+
+	if (mpt_config(ioc, &cfg) != 0) {
+		rc = -EFAULT;
+		goto out;
+	}
+
+	rc = 0;
+	memcpy(phys_disk, buffer, sizeof(*buffer));
+	phys_disk->MaxLBA = le32_to_cpu(buffer->MaxLBA);
+
+ out:
+
+	if (buffer)
+		pci_free_consistent(ioc->pcidev, hdr.PageLength * 4, buffer,
+		    dma_handle);
+
+	return rc;
+}
+
 /**
  *	mpt_findImVolumes - Identify IDs of hidden disks and RAID Volumes
  *	@ioc: Pointer to a Adapter Strucutre
@@ -4737,21 +4928,27 @@ mpt_readScsiDevicePageHeaders(MPT_ADAPTE
  *	0 on success
  *	-EFAULT if read of config page header fails or data pointer not NULL
  *	-ENOMEM if pci_alloc failed
- */
+ **/
 int
 mpt_findImVolumes(MPT_ADAPTER *ioc)
 {
 	IOCPage2_t		*pIoc2;
 	u8			*mem;
-	ConfigPageIoc2RaidVol_t	*pIocRv;
 	dma_addr_t		 ioc2_dma;
 	CONFIGPARMS		 cfg;
 	ConfigPageHeader_t	 header;
-	int			 jj;
 	int			 rc = 0;
 	int			 iocpage2sz;
-	u8			 nVols, nPhys;
-	u8			 vid, vbus, vioc;
+	int			 i;
+
+	if (!ioc->ir_firmware)
+		return 0;
+
+	/* Free the old page
+	 */
+	kfree(ioc->raid_data.pIocPg2);
+	ioc->raid_data.pIocPg2 = NULL;
+	mpt_inactive_raid_list_free(ioc);
 
 	/* Read IOCP2 header then the page.
 	 */
@@ -4779,55 +4976,23 @@ mpt_findImVolumes(MPT_ADAPTER *ioc)
 	cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
 	cfg.physAddr = ioc2_dma;
 	if (mpt_config(ioc, &cfg) != 0)
-		goto done_and_free;
+		goto out;
 
-	if ( (mem = (u8 *)ioc->raid_data.pIocPg2) == NULL ) {
-		mem = kmalloc(iocpage2sz, GFP_ATOMIC);
-		if (mem) {
-			ioc->raid_data.pIocPg2 = (IOCPage2_t *) mem;
-		} else {
-			goto done_and_free;
-		}
-	}
-	memcpy(mem, (u8 *)pIoc2, iocpage2sz);
+	mem = kmalloc(iocpage2sz, GFP_KERNEL);
+	if (!mem)
+		goto out;
 
-	/* Identify RAID Volume Id's */
-	nVols = pIoc2->NumActiveVolumes;
-	if ( nVols == 0) {
-		/* No RAID Volume.
-		 */
-		goto done_and_free;
-	} else {
-		/* At least 1 RAID Volume
-		 */
-		pIocRv = pIoc2->RaidVolume;
-		ioc->raid_data.isRaid = 0;
-		for (jj = 0; jj < nVols; jj++, pIocRv++) {
-			vid = pIocRv->VolumeID;
-			vbus = pIocRv->VolumeBus;
-			vioc = pIocRv->VolumeIOC;
+	memcpy(mem, (u8 *)pIoc2, iocpage2sz);
+	ioc->raid_data.pIocPg2 = (IOCPage2_t *) mem;
 
-			/* find the match
-			 */
-			if (vbus == 0) {
-				ioc->raid_data.isRaid |= (1 << vid);
-			} else {
-				/* Error! Always bus 0
-				 */
-			}
-		}
-	}
+	mpt_read_ioc_pg_3(ioc);
 
-	/* Identify Hidden Physical Disk Id's */
-	nPhys = pIoc2->NumActivePhysDisks;
-	if (nPhys == 0) {
-		/* No physical disks.
-		 */
-	} else {
-		mpt_read_ioc_pg_3(ioc);
-	}
+	for (i = 0; i < pIoc2->NumActiveVolumes ; i++)
+		mpt_inactive_raid_volumes(ioc,
+		    pIoc2->RaidVolume[i].VolumeBus,
+		    pIoc2->RaidVolume[i].VolumeID);
 
-done_and_free:
+ out:
 	pci_free_consistent(ioc->pcidev, iocpage2sz, pIoc2, ioc2_dma);
 
 	return rc;
@@ -4880,7 +5045,7 @@ mpt_read_ioc_pg_3(MPT_ADAPTER *ioc)
 	cfg.physAddr = ioc3_dma;
 	cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
 	if (mpt_config(ioc, &cfg) == 0) {
-		mem = kmalloc(iocpage3sz, GFP_ATOMIC);
+		mem = kmalloc(iocpage3sz, GFP_KERNEL);
 		if (mem) {
 			memcpy(mem, (u8 *)pIoc3, iocpage3sz);
 			ioc->raid_data.pIocPg3 = (IOCPage3_t *) mem;
@@ -6833,6 +6998,7 @@ EXPORT_SYMBOL(mpt_findImVolumes);
 EXPORT_SYMBOL(mpt_alloc_fw_memory);
 EXPORT_SYMBOL(mpt_free_fw_memory);
 EXPORT_SYMBOL(mptbase_sas_persist_operation);
+EXPORT_SYMBOL(mpt_raid_phys_disk_pg0);
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
diff -uarpN b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2007-01-28 12:57:29.000000000 -0700
+++ a/drivers/message/fusion/mptbase.h	2007-01-28 12:57:29.000000000 -0700
@@ -485,10 +485,24 @@ typedef	struct _SasCfgData {
 						 */
 }SasCfgData;
 
+/*
+ * Inactive volume link list of raid component data
+ * @inactive_list
+ */
+struct inactive_raid_component_info {
+	struct 	 list_head list;
+	u8		 volumeID;		/* volume target id */
+	u8		 volumeBus;		/* volume channel */
+	IOC_3_PHYS_DISK	 d;			/* phys disk info */
+};
+
 typedef	struct _RaidCfgData {
 	IOCPage2_t	*pIocPg2;		/* table of Raid Volumes */
 	IOCPage3_t	*pIocPg3;		/* table of physical disks */
-	int		 isRaid;		/* bit field, 1 if RAID */
+	struct semaphore	inactive_list_mutex;
+	struct list_head	inactive_list; /* link list for physical
+						disk that belong in
+						inactive volumes */
 }RaidCfgData;
 
 typedef struct _FcCfgData {
@@ -611,6 +625,8 @@ typedef struct _MPT_ADAPTER
 	u8			 persist_reply_frame[MPT_DEFAULT_FRAME_SIZE]; /* persist reply */
 	LANPage0_t		 lan_cnfg_page0;
 	LANPage1_t		 lan_cnfg_page1;
+
+	u8			 ir_firmware; /* =1 if IR firmware detected */
 	/*
 	 * Description: errata_flag_1064
 	 * If a PCIX read occurs within 1 or 2 cycles after the chip receives
@@ -1043,6 +1059,7 @@ extern void	 mpt_alloc_fw_memory(MPT_ADA
 extern void	 mpt_free_fw_memory(MPT_ADAPTER *ioc);
 extern int	 mpt_findImVolumes(MPT_ADAPTER *ioc);
 extern int	 mptbase_sas_persist_operation(MPT_ADAPTER *ioc, u8 persist_opcode);
+extern int	 mpt_raid_phys_disk_pg0(MPT_ADAPTER *ioc, u8 phys_disk_num, pRaidPhysDiskPage0_t phys_disk);
 
 /*
  *  Public data decl's...
diff -uarpN b/drivers/message/fusion/mptsas.c a/drivers/message/fusion/mptsas.c
--- b/drivers/message/fusion/mptsas.c	2007-01-28 12:57:29.000000000 -0700
+++ a/drivers/message/fusion/mptsas.c	2007-01-28 12:57:29.000000000 -0700
@@ -94,12 +94,14 @@ static int	mptsasTaskCtx = -1;
 static int	mptsasInternalCtx = -1; /* Used only for internal commands */
 static int	mptsasMgmtCtx = -1;
 
+static void mptsas_hotplug_work(struct work_struct *work);
 
 enum mptsas_hotplug_action {
 	MPTSAS_ADD_DEVICE,
 	MPTSAS_DEL_DEVICE,
 	MPTSAS_ADD_RAID,
 	MPTSAS_DEL_RAID,
+	MPTSAS_ADD_INACTIVE_VOLUME,
 	MPTSAS_IGNORE_EVENT,
 };
 
@@ -108,14 +110,15 @@ struct mptsas_hotplug_event {
 	MPT_ADAPTER		*ioc;
 	enum mptsas_hotplug_action event_type;
 	u64			sas_address;
-	u32			channel;
-	u32			id;
+	u8			channel;
+	u8			id;
 	u32			device_info;
 	u16			handle;
 	u16			parent_handle;
 	u8			phy_id;
-	u8			phys_disk_num;
-	u8			phys_disk_num_valid;
+	u8			phys_disk_num_valid;	/* hrc (hidden raid component) */
+	u8			phys_disk_num;		/* hrc - unique index*/
+	u8			hidden_raid_component;	/* hrc - don't expose*/
 };
 
 struct mptsas_discovery_event {
@@ -140,6 +143,7 @@ struct mptsas_devinfo {
 	u8	port_id;	/* sas physical port this device
 				   is assoc'd with */
 	u8	id;		/* logical target id of this device */
+	u32	phys_disk_num;	/* phys disk id, for csmi-ioctls */
 	u8	channel;	/* logical bus number of this device */
 	u64	sas_address;    /* WWN of this device,
 				   SATA is assigned by HBA,expander */
@@ -711,6 +715,7 @@ mptsas_target_alloc(struct scsi_target *
 						channel, id);
 				vtarget->tflags |=
 				    MPT_TARGET_FLAGS_RAID_COMPONENT;
+				p->phy_info[i].attached.phys_disk_num = id;
 			}
 			mutex_unlock(&hd->ioc->sas_topology_mutex);
 			goto out;
@@ -1272,6 +1277,7 @@ mptsas_sas_device_pg0(MPT_ADAPTER *ioc, 
 	device_info->phy_id = buffer->PhyNum;
 	device_info->port_id = buffer->PhysicalPort;
 	device_info->id = buffer->TargetID;
+	device_info->phys_disk_num = ~0;
 	device_info->channel = buffer->Bus;
 	memcpy(&sas_address, &buffer->SASAddress, sizeof(__le64));
 	device_info->sas_address = le64_to_cpu(sas_address);
@@ -1983,6 +1989,8 @@ mptsas_scan_sas_topology(MPT_ADAPTER *io
 	/*
 	  Reporting RAID volumes.
 	*/
+	if (!ioc->ir_firmware)
+		goto out;
 	if (!ioc->raid_data.pIocPg2)
 		goto out;
 	if (!ioc->raid_data.pIocPg2->NumActiveVolumes)
@@ -2041,12 +2049,37 @@ mptsas_find_phyinfo_by_sas_address(MPT_A
 	mutex_lock(&ioc->sas_topology_mutex);
 	list_for_each_entry(port_info, &ioc->sas_topology, list) {
 		for (i = 0; i < port_info->num_phys; i++) {
+			if (!mptsas_is_end_device(
+				&port_info->phy_info[i].attached))
+				continue;
 			if (port_info->phy_info[i].attached.sas_address
 			    != sas_address)
 				continue;
+			phy_info = &port_info->phy_info[i];
+			break;
+		}
+	}
+	mutex_unlock(&ioc->sas_topology_mutex);
+	return phy_info;
+}
+
+static struct mptsas_phyinfo *
+mptsas_find_phyinfo_by_target(MPT_ADAPTER *ioc, u8 channel, u8 id)
+{
+	struct mptsas_portinfo *port_info;
+	struct mptsas_phyinfo *phy_info = NULL;
+	int i;
+
+	mutex_lock(&ioc->sas_topology_mutex);
+	list_for_each_entry(port_info, &ioc->sas_topology, list) {
+		for (i = 0; i < port_info->num_phys; i++) {
 			if (!mptsas_is_end_device(
 				&port_info->phy_info[i].attached))
 				continue;
+			if (port_info->phy_info[i].attached.id != id)
+				continue;
+			if (port_info->phy_info[i].attached.channel != channel)
+				continue;
 			phy_info = &port_info->phy_info[i];
 			break;
 		}
@@ -2056,7 +2089,7 @@ mptsas_find_phyinfo_by_sas_address(MPT_A
 }
 
 static struct mptsas_phyinfo *
-mptsas_find_phyinfo_by_target(MPT_ADAPTER *ioc, u32 id)
+mptsas_find_phyinfo_by_phys_disk_num(MPT_ADAPTER *ioc, u8 channel, u8 id)
 {
 	struct mptsas_portinfo *port_info;
 	struct mptsas_phyinfo *phy_info = NULL;
@@ -2065,11 +2098,15 @@ mptsas_find_phyinfo_by_target(MPT_ADAPTE
 	mutex_lock(&ioc->sas_topology_mutex);
 	list_for_each_entry(port_info, &ioc->sas_topology, list) {
 		for (i = 0; i < port_info->num_phys; i++) {
-			if (port_info->phy_info[i].attached.id != id)
-				continue;
 			if (!mptsas_is_end_device(
 				&port_info->phy_info[i].attached))
 				continue;
+			if (port_info->phy_info[i].attached.phys_disk_num == ~0)
+				continue;
+			if (port_info->phy_info[i].attached.phys_disk_num != id)
+				continue;
+			if (port_info->phy_info[i].attached.channel != channel)
+				continue;
 			phy_info = &port_info->phy_info[i];
 			break;
 		}
@@ -2105,6 +2142,76 @@ mptsas_reprobe_target(struct scsi_target
 			mptsas_reprobe_lun);
 }
 
+static void
+mptsas_adding_inactive_raid_components(MPT_ADAPTER *ioc, u8 channel, u8 id)
+{
+	CONFIGPARMS			cfg;
+	ConfigPageHeader_t		hdr;
+	dma_addr_t			dma_handle;
+	pRaidVolumePage0_t		buffer = NULL;
+	RaidPhysDiskPage0_t 		phys_disk;
+	int				i;
+	struct mptsas_hotplug_event 	*ev;
+
+	memset(&cfg, 0 , sizeof(CONFIGPARMS));
+	memset(&hdr, 0 , sizeof(ConfigPageHeader_t));
+	hdr.PageType = MPI_CONFIG_PAGETYPE_RAID_VOLUME;
+	cfg.pageAddr = (channel << 8) + id;
+	cfg.cfghdr.hdr = &hdr;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
+
+	if (mpt_config(ioc, &cfg) != 0)
+		goto out;
+
+	if (!hdr.PageLength)
+		goto out;
+
+	buffer = pci_alloc_consistent(ioc->pcidev, hdr.PageLength * 4,
+	    &dma_handle);
+
+	if (!buffer)
+		goto out;
+
+	cfg.physAddr = dma_handle;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
+
+	if (mpt_config(ioc, &cfg) != 0)
+		goto out;
+
+	if (!(buffer->VolumeStatus.Flags &
+	    MPI_RAIDVOL0_STATUS_FLAG_VOLUME_INACTIVE))
+		goto out;
+
+	if (!buffer->NumPhysDisks)
+		goto out;
+
+	for (i = 0; i < buffer->NumPhysDisks; i++) {
+
+		if (mpt_raid_phys_disk_pg0(ioc,
+		    buffer->PhysDisk[i].PhysDiskNum, &phys_disk) != 0)
+			continue;
+
+		ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
+		if (!ev) {
+			printk(KERN_WARNING "mptsas: lost hotplug event\n");
+			goto out;
+		}
+
+		INIT_WORK(&ev->work, mptsas_hotplug_work);
+		ev->ioc = ioc;
+		ev->id = phys_disk.PhysDiskID;
+		ev->channel = phys_disk.PhysDiskBus;
+		ev->phys_disk_num_valid = 1;
+		ev->phys_disk_num = phys_disk.PhysDiskNum;
+		ev->event_type = MPTSAS_ADD_DEVICE;
+		schedule_work(&ev->work);
+	}
+
+ out:
+	if (buffer)
+		pci_free_consistent(ioc->pcidev, hdr.PageLength * 4, buffer,
+		    dma_handle);
+}
 /*
  * Work queue thread to handle SAS hotplug events
  */
@@ -2113,6 +2220,7 @@ mptsas_hotplug_work(struct work_struct *
 {
 	struct mptsas_hotplug_event *ev =
 		container_of(work, struct mptsas_hotplug_event, work);
+
 	MPT_ADAPTER *ioc = ev->ioc;
 	struct mptsas_phyinfo *phy_info;
 	struct sas_rphy *rphy;
@@ -2125,17 +2233,43 @@ mptsas_hotplug_work(struct work_struct *
 	VirtTarget *vtarget;
 	VirtDevice *vdevice;
 
-
 	mutex_lock(&ioc->sas_discovery_mutex);
 	switch (ev->event_type) {
 	case MPTSAS_DEL_DEVICE:
 
-		phy_info = mptsas_find_phyinfo_by_target(ioc, ev->id);
+		phy_info = NULL;
+		if (ev->phys_disk_num_valid) {
+			if (ev->hidden_raid_component){
+				if (mptsas_sas_device_pg0(ioc, &sas_device,
+				    (MPI_SAS_DEVICE_PGAD_FORM_BUS_TARGET_ID <<
+				     MPI_SAS_DEVICE_PGAD_FORM_SHIFT),
+				    (ev->channel << 8) + ev->id)) {
+					dfailprintk((MYIOC_s_ERR_FMT
+					"%s: exit at line=%d\n", ioc->name,
+						__FUNCTION__, __LINE__));
+					break;
+				}
+				phy_info = mptsas_find_phyinfo_by_sas_address(
+				    ioc, sas_device.sas_address);
+			}else
+				phy_info = mptsas_find_phyinfo_by_phys_disk_num(
+				    ioc, ev->channel, ev->phys_disk_num);
+		}
+
+		if (!phy_info)
+			phy_info = mptsas_find_phyinfo_by_target(ioc,
+			    ev->channel, ev->id);
 
 		/*
 		 * Sanity checks, for non-existing phys and remote rphys.
 		 */
-		if (!phy_info || !phy_info->port_details) {
+		if (!phy_info){
+			dfailprintk((MYIOC_s_ERR_FMT
+				"%s: exit at line=%d\n", ioc->name,
+			       	__FUNCTION__, __LINE__));
+			break;
+		}
+		if (!phy_info->port_details) {
 			dfailprintk((MYIOC_s_ERR_FMT
 				"%s: exit at line=%d\n", ioc->name,
 			       	__FUNCTION__, __LINE__));
@@ -2148,6 +2282,7 @@ mptsas_hotplug_work(struct work_struct *
 			       	__FUNCTION__, __LINE__));
 			break;
 		}
+
 		port = mptsas_get_port(phy_info);
 		if (!port) {
 			dfailprintk((MYIOC_s_ERR_FMT
@@ -2170,28 +2305,38 @@ mptsas_hotplug_work(struct work_struct *
 			/*
 			 * Handling  RAID components
 			 */
-			if (ev->phys_disk_num_valid) {
+			if (ev->phys_disk_num_valid &&
+			    ev->hidden_raid_component) {
+				printk(MYIOC_s_INFO_FMT
+				    "RAID Hidding: channel=%d, id=%d, "
+				    "physdsk %d \n", ioc->name, ev->channel,
+				    ev->id, ev->phys_disk_num);
 				vtarget->id = ev->phys_disk_num;
-				vtarget->tflags |= MPT_TARGET_FLAGS_RAID_COMPONENT;
+				vtarget->tflags |=
+				    MPT_TARGET_FLAGS_RAID_COMPONENT;
 				mptsas_reprobe_target(starget, 1);
-				break;
+				phy_info->attached.phys_disk_num =
+				    ev->phys_disk_num;
+			break;
 			}
 
 			vtarget->deleted = 1;
 			mptsas_target_reset(ioc, vtarget);
 		}
 
-		if (phy_info->attached.device_info & MPI_SAS_DEVICE_INFO_SSP_TARGET)
+		if (phy_info->attached.device_info &
+		    MPI_SAS_DEVICE_INFO_SSP_TARGET)
 			ds = "ssp";
-		if (phy_info->attached.device_info & MPI_SAS_DEVICE_INFO_STP_TARGET)
+		if (phy_info->attached.device_info &
+		    MPI_SAS_DEVICE_INFO_STP_TARGET)
 			ds = "stp";
-		if (phy_info->attached.device_info & MPI_SAS_DEVICE_INFO_SATA_DEVICE)
+		if (phy_info->attached.device_info &
+		    MPI_SAS_DEVICE_INFO_SATA_DEVICE)
 			ds = "sata";
 
 		printk(MYIOC_s_INFO_FMT
 		       "removing %s device, channel %d, id %d, phy %d\n",
 		       ioc->name, ds, ev->channel, ev->id, phy_info->phy_id);
-
 #ifdef MPT_DEBUG_SAS_WIDE
 		dev_printk(KERN_DEBUG, &port->dev,
 		    "delete port (%d)\n", port->port_identifier);
@@ -2209,14 +2354,14 @@ mptsas_hotplug_work(struct work_struct *
 		 */
 		if (mptsas_sas_device_pg0(ioc, &sas_device,
 		    (MPI_SAS_DEVICE_PGAD_FORM_BUS_TARGET_ID <<
-		     MPI_SAS_DEVICE_PGAD_FORM_SHIFT), ev->id)) {
+		     MPI_SAS_DEVICE_PGAD_FORM_SHIFT),
+			(ev->channel << 8) + ev->id)) {
 				dfailprintk((MYIOC_s_ERR_FMT
 					"%s: exit at line=%d\n", ioc->name,
 					__FUNCTION__, __LINE__));
 			break;
 		}
 
-		ssleep(2);
 		__mptsas_discovery_work(ioc);
 
 		phy_info = mptsas_find_phyinfo_by_sas_address(ioc,
@@ -2230,7 +2375,8 @@ mptsas_hotplug_work(struct work_struct *
 		}
 
 		starget = mptsas_get_starget(phy_info);
-		if (starget) {
+		if (starget && (!ev->hidden_raid_component)){
+
 			vtarget = starget->hostdata;
 
 			if (!vtarget) {
@@ -2243,9 +2389,15 @@ mptsas_hotplug_work(struct work_struct *
 			 * Handling  RAID components
 			 */
 			if (vtarget->tflags & MPT_TARGET_FLAGS_RAID_COMPONENT) {
-				vtarget->tflags &= ~MPT_TARGET_FLAGS_RAID_COMPONENT;
+				printk(MYIOC_s_INFO_FMT
+				    "RAID Exposing: channel=%d, id=%d, "
+				    "physdsk %d \n", ioc->name, ev->channel,
+				    ev->id, ev->phys_disk_num);
+				vtarget->tflags &=
+				    ~MPT_TARGET_FLAGS_RAID_COMPONENT;
 				vtarget->id = ev->id;
 				mptsas_reprobe_target(starget, 0);
+				phy_info->attached.phys_disk_num = ~0;
 			}
 			break;
 		}
@@ -2254,8 +2406,10 @@ mptsas_hotplug_work(struct work_struct *
 			dfailprintk((MYIOC_s_ERR_FMT
 				"%s: exit at line=%d\n", ioc->name,
 			       	__FUNCTION__, __LINE__));
+			if (ev->channel) printk("%d\n", __LINE__);
 			break;
 		}
+
 		port = mptsas_get_port(phy_info);
 		if (!port) {
 			dfailprintk((MYIOC_s_ERR_FMT
@@ -2263,15 +2417,17 @@ mptsas_hotplug_work(struct work_struct *
 			       	__FUNCTION__, __LINE__));
 			break;
 		}
-
 		memcpy(&phy_info->attached, &sas_device,
 		    sizeof(struct mptsas_devinfo));
 
-		if (phy_info->attached.device_info & MPI_SAS_DEVICE_INFO_SSP_TARGET)
+		if (phy_info->attached.device_info &
+		    MPI_SAS_DEVICE_INFO_SSP_TARGET)
 			ds = "ssp";
-		if (phy_info->attached.device_info & MPI_SAS_DEVICE_INFO_STP_TARGET)
+		if (phy_info->attached.device_info &
+		    MPI_SAS_DEVICE_INFO_STP_TARGET)
 			ds = "stp";
-		if (phy_info->attached.device_info & MPI_SAS_DEVICE_INFO_SATA_DEVICE)
+		if (phy_info->attached.device_info &
+		    MPI_SAS_DEVICE_INFO_SATA_DEVICE)
 			ds = "sata";
 
 		printk(MYIOC_s_INFO_FMT
@@ -2312,19 +2468,23 @@ mptsas_hotplug_work(struct work_struct *
 		break;
 	case MPTSAS_DEL_RAID:
 		sdev = scsi_device_lookup(ioc->sh, MPTSAS_RAID_CHANNEL,
-	    	    ev->id, 0);
+		    ev->id, 0);
 		if (!sdev)
 			break;
 		printk(MYIOC_s_INFO_FMT
 		       "removing raid volume, channel %d, id %d\n",
 		       ioc->name, MPTSAS_RAID_CHANNEL, ev->id);
-		vdevice = sdev->hostdata;
 		vdevice->vtarget->deleted = 1;
 		mptsas_target_reset(ioc, vdevice->vtarget);
+		vdevice = sdev->hostdata;
 		scsi_remove_device(sdev);
 		scsi_device_put(sdev);
 		mpt_findImVolumes(ioc);
 		break;
+	case MPTSAS_ADD_INACTIVE_VOLUME:
+		mptsas_adding_inactive_raid_components(ioc,
+		    ev->channel, ev->id);
+		break;
 	case MPTSAS_IGNORE_EVENT:
 	default:
 		break;
@@ -2332,7 +2492,6 @@ mptsas_hotplug_work(struct work_struct *
 
 	mutex_unlock(&ioc->sas_discovery_mutex);
 	kfree(ev);
-
 }
 
 static void
@@ -2386,15 +2545,20 @@ mptsas_send_sas_event(MPT_ADAPTER *ioc,
 		    mptsas_persist_clear_table);
 		schedule_work(&ioc->sas_persist_task);
 		break;
+	/*
+	 * TODO, handle other events
+	 */
 	case MPI_EVENT_SAS_DEV_STAT_RC_SMART_DATA:
-	/* TODO */
+	case MPI_EVENT_SAS_DEV_STAT_RC_UNSUPPORTED:
 	case MPI_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET:
-	/* TODO */
+	case MPI_EVENT_SAS_DEV_STAT_RC_TASK_ABORT_INTERNAL:
+	case MPI_EVENT_SAS_DEV_STAT_RC_ABORT_TASK_SET_INTERNAL:
+	case MPI_EVENT_SAS_DEV_STAT_RC_CLEAR_TASK_SET_INTERNAL:
+	case MPI_EVENT_SAS_DEV_STAT_RC_QUERY_TASK_INTERNAL:
 	default:
 		break;
 	}
 }
-
 static void
 mptsas_send_raid_event(MPT_ADAPTER *ioc,
 		EVENT_DATA_RAID *raid_event_data)
@@ -2415,31 +2579,36 @@ mptsas_send_raid_event(MPT_ADAPTER *ioc,
 	INIT_WORK(&ev->work, mptsas_hotplug_work);
 	ev->ioc = ioc;
 	ev->id = raid_event_data->VolumeID;
+	ev->channel = raid_event_data->VolumeBus;
 	ev->event_type = MPTSAS_IGNORE_EVENT;
 
 	switch (raid_event_data->ReasonCode) {
 	case MPI_EVENT_RAID_RC_PHYSDISK_DELETED:
+		ev->phys_disk_num_valid = 1;
+		ev->phys_disk_num = raid_event_data->PhysDiskNum;
 		ev->event_type = MPTSAS_ADD_DEVICE;
 		break;
 	case MPI_EVENT_RAID_RC_PHYSDISK_CREATED:
-		ioc->raid_data.isRaid = 1;
 		ev->phys_disk_num_valid = 1;
 		ev->phys_disk_num = raid_event_data->PhysDiskNum;
+		ev->hidden_raid_component = 1;
 		ev->event_type = MPTSAS_DEL_DEVICE;
 		break;
 	case MPI_EVENT_RAID_RC_PHYSDISK_STATUS_CHANGED:
 		switch (state) {
 		case MPI_PD_STATE_ONLINE:
-			ioc->raid_data.isRaid = 1;
+		case MPI_PD_STATE_NOT_COMPATIBLE:
 			ev->phys_disk_num_valid = 1;
 			ev->phys_disk_num = raid_event_data->PhysDiskNum;
+			ev->hidden_raid_component = 1;
 			ev->event_type = MPTSAS_ADD_DEVICE;
 			break;
 		case MPI_PD_STATE_MISSING:
-		case MPI_PD_STATE_NOT_COMPATIBLE:
 		case MPI_PD_STATE_OFFLINE_AT_HOST_REQUEST:
 		case MPI_PD_STATE_FAILED_AT_HOST_REQUEST:
 		case MPI_PD_STATE_OFFLINE_FOR_ANOTHER_REASON:
+			ev->phys_disk_num_valid = 1;
+			ev->phys_disk_num = raid_event_data->PhysDiskNum;
 			ev->event_type = MPTSAS_DEL_DEVICE;
 			break;
 		default:
@@ -2496,6 +2665,35 @@ mptsas_send_discovery_event(MPT_ADAPTER 
 	schedule_work(&ev->work);
 };
 
+/*
+ * mptsas_send_ir2_event - handle exposing hidden disk when 
+ * an inactive raid volume is added
+ *
+ * @ioc: Pointer to MPT_ADAPTER structure
+ * @ir2_data
+ *
+ */
+static void
+mptsas_send_ir2_event(MPT_ADAPTER *ioc, PTR_MPI_EVENT_DATA_IR2 ir2_data)
+{
+	struct mptsas_hotplug_event *ev;
+
+	if (ir2_data->ReasonCode !=
+	    MPI_EVENT_IR2_RC_FOREIGN_CFG_DETECTED)
+		return;
+
+	ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
+	if (!ev)
+		return;
+
+	INIT_WORK(&ev->work, mptsas_hotplug_work);
+	ev->ioc = ioc;
+	ev->id = ir2_data->TargetID;
+	ev->channel = ir2_data->Bus;
+	ev->event_type = MPTSAS_ADD_INACTIVE_VOLUME;
+
+	schedule_work(&ev->work);
+};
 
 static int
 mptsas_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *reply)
@@ -2535,6 +2733,10 @@ mptsas_event_process(MPT_ADAPTER *ioc, E
 		mptsas_send_discovery_event(ioc,
 			(EVENT_DATA_SAS_DISCOVERY *)reply->Data);
 		break;
+	case MPI_EVENT_IR2:
+		mptsas_send_ir2_event(ioc,
+		    (PTR_MPI_EVENT_DATA_IR2)reply->Data);
+		break;
 	default:
 		rc = mptscsih_event_process(ioc, reply);
 		break;
@@ -2742,7 +2944,7 @@ static void __devexit mptsas_remove(stru
 	struct mptsas_portinfo *p, *n;
 	int i;
 
-	ioc->sas_discovery_ignore_events=1;
+	ioc->sas_discovery_ignore_events = 1;
 	sas_remove_host(ioc->sh);
 
 	mutex_lock(&ioc->sas_topology_mutex);
diff -uarpN b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion/mptscsih.c
--- b/drivers/message/fusion/mptscsih.c	2007-01-28 12:57:29.000000000 -0700
+++ a/drivers/message/fusion/mptscsih.c	2007-01-28 12:57:29.000000000 -0700
@@ -2243,6 +2243,7 @@ mptscsih_bios_param(struct scsi_device *
 int
 mptscsih_is_phys_disk(MPT_ADAPTER *ioc, u8 channel, u8 id)
 {
+	struct inactive_raid_component_info *component_info;
 	int i;
 	int rc = 0;
 
@@ -2256,6 +2257,21 @@ mptscsih_is_phys_disk(MPT_ADAPTER *ioc, 
 		}
 	}
 
+	/*
+	 * Check inactive list for matching phys disks
+	 */
+	if (list_empty(&ioc->raid_data.inactive_list))
+		goto out;
+
+	down(&ioc->raid_data.inactive_list_mutex);
+	list_for_each_entry(component_info, &ioc->raid_data.inactive_list,
+	    list) {
+		if ((component_info->d.PhysDiskID == id) &&
+		    (component_info->d.PhysDiskBus == channel))
+			rc = 1;
+	}
+	up(&ioc->raid_data.inactive_list_mutex);
+
  out:
 	return rc;
 }
@@ -2264,6 +2280,7 @@ EXPORT_SYMBOL(mptscsih_is_phys_disk);
 u8
 mptscsih_raid_id_to_num(MPT_ADAPTER *ioc, u8 channel, u8 id)
 {
+	struct inactive_raid_component_info *component_info;
 	int i;
 	int rc = -ENXIO;
 
@@ -2277,6 +2294,21 @@ mptscsih_raid_id_to_num(MPT_ADAPTER *ioc
 		}
 	}
 
+	/*
+	 * Check inactive list for matching phys disks
+	 */
+	if (list_empty(&ioc->raid_data.inactive_list))
+		goto out;
+
+	down(&ioc->raid_data.inactive_list_mutex);
+	list_for_each_entry(component_info, &ioc->raid_data.inactive_list,
+	    list) {
+		if ((component_info->d.PhysDiskID == id) &&
+		    (component_info->d.PhysDiskBus == channel))
+			rc = component_info->d.PhysDiskNum;
+	}
+	up(&ioc->raid_data.inactive_list_mutex);
+
  out:
 	return rc;
 }
diff -uarpN b/drivers/message/fusion/mptspi.c a/drivers/message/fusion/mptspi.c
--- b/drivers/message/fusion/mptspi.c	2007-01-28 12:57:29.000000000 -0700
+++ a/drivers/message/fusion/mptspi.c	2007-01-28 12:57:29.000000000 -0700
@@ -1363,8 +1363,7 @@ mptspi_probe(struct pci_dev *pdev, const
 	/*
 	 * If RAID Firmware Detected, setup virtual channel
 	 */
-	if ((ioc->facts.ProductID & MPI_FW_HEADER_PID_PROD_MASK)
-	    > MPI_FW_HEADER_PID_PROD_TARGET_SCSI)
+	if (ioc->ir_firmware)
 		sh->max_channel = 1;
 	else
 		sh->max_channel = 0;
