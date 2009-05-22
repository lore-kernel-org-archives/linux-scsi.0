From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 15/24] mpt fusion: [2.6.30-rc6] SAS topology scan changes, expander events, link status events added
Date: Fri, 22 May 2009 16:35:40 +0530
Message-ID: <20090522110531.GI16331@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og111.obsmtp.com ([64.18.2.175]:49535 "EHLO
	exprod7og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396AbZEVL0k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2009 07:26:40 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com



1.) SAS topology scan is restructured. HBA firmware is generating more
events. Expander Events are added, Link status events are also added with
respect to SAS topology scan optimization.

---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index b6efc64..8d1aadb 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -704,6 +704,11 @@ typedef struct _MPT_ADAPTER
 	struct mutex		 sas_discovery_mutex;
 	u8			 sas_discovery_runtime;
 	u8			 sas_discovery_ignore_events;
+
+	/* port_info object for the host */
+	struct mptsas_portinfo	*hba_port_info;
+	u64			 hba_port_sas_addr;
+	u16			 hba_port_num_phy;
 	struct list_head	 sas_device_info_list;
 	struct mutex		 sas_device_info_mutex;
 	u8			 sas_discovery_quiesce_io;
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 29a8fe2..556f2f9 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -113,6 +113,12 @@ static int mptsas_add_end_device(MPT_ADAPTER *ioc,
 	struct mptsas_phyinfo *phy_info);
 static void mptsas_del_end_device(MPT_ADAPTER *ioc,
 	struct mptsas_phyinfo *phy_info);
+static void mptsas_send_link_status_event(struct fw_event_work *fw_event);
+static struct mptsas_portinfo	*mptsas_find_portinfo_by_sas_address
+		(MPT_ADAPTER *ioc, u64 sas_address);
+static void mptsas_expander_delete(MPT_ADAPTER *ioc,
+		struct mptsas_portinfo *port_info, u8 force);
+static void mptsas_send_expander_event(struct fw_event_work *fw_event);
 
 static void mptsas_print_phy_data(MPT_ADAPTER *ioc,
 					MPI_SAS_IO_UNIT0_PHY_DATA *phy_data)
@@ -377,6 +383,38 @@ mptsas_find_portinfo_by_handle(MPT_ADAPTER *ioc, u16 handle)
 	return rc;
 }
 
+/**
+ *	mptsas_find_portinfo_by_sas_address -
+ *	@ioc: Pointer to MPT_ADAPTER structure
+ *	@handle:
+ *
+ *	This function should be called with the sas_topology_mutex already held
+ *
+ **/
+static struct mptsas_portinfo *
+mptsas_find_portinfo_by_sas_address(MPT_ADAPTER *ioc, u64 sas_address)
+{
+	struct mptsas_portinfo *port_info, *rc = NULL;
+	int i;
+
+	if (sas_address >= ioc->hba_port_sas_addr &&
+	    sas_address < (ioc->hba_port_sas_addr +
+	    ioc->hba_port_num_phy))
+		return ioc->hba_port_info;
+
+	mutex_lock(&ioc->sas_topology_mutex);
+	list_for_each_entry(port_info, &ioc->sas_topology, list)
+		for (i = 0; i < port_info->num_phys; i++)
+			if (port_info->phy_info[i].identify.sas_address ==
+			    sas_address) {
+				rc = port_info;
+				goto out;
+			}
+ out:
+	mutex_unlock(&ioc->sas_topology_mutex);
+	return rc;
+}
+
 /*
  * Returns true if there is a scsi end device
  */
@@ -940,7 +978,6 @@ mptsas_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 {
 	MPT_SCSI_HOST	*hd = shost_priv(ioc->sh);
         struct list_head *head = &hd->target_reset_list;
-	EVENT_DATA_SAS_DEVICE_STATUS_CHANGE *sas_event_data;
 	u8		id, channel;
 	struct mptsas_target_reset_event	*target_reset_list;
 	SCSITaskMgmtReply_t *pScsiTmReply;
@@ -995,7 +1032,6 @@ mptsas_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 	    ioc->name, jiffies_to_msecs(jiffies -
 	    target_reset_list->time_count)/1000));
 
-	sas_event_data = &target_reset_list->sas_event_data;
 	id = pScsiTmReply->TargetID;
 	channel = pScsiTmReply->Bus;
 	target_reset_list->time_count = jiffies;
@@ -1410,6 +1446,12 @@ mptsas_firmware_event_work(struct work_struct *work)
 		    MPI_SAS_OP_CLEAR_NOT_PRESENT);
 		mptsas_free_fw_event(ioc, fw_event);
 		break;
+	case MPI_EVENT_SAS_EXPANDER_STATUS_CHANGE:
+		mptsas_send_expander_event(fw_event);
+		break;
+	case MPI_EVENT_SAS_PHY_LINK_STATUS:
+		mptsas_send_link_status_event(fw_event);
+		break;
 	}
 }
 
@@ -1909,7 +1951,7 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 		struct mptsas_portinfo *port_info;
 
 		mutex_lock(&ioc->sas_topology_mutex);
-		port_info = mptsas_get_hba_portinfo(ioc);
+		port_info = ioc->hba_port_info;
 		if (port_info && port_info->phy_info)
 			sas_address =
 				port_info->phy_info[0].phy->identify.sas_address;
@@ -2646,9 +2688,7 @@ static int mptsas_probe_one_phy(struct device *dev,
 			struct mptsas_portinfo *port_info;
 			int i;
 
-			mutex_lock(&ioc->sas_topology_mutex);
-			port_info = mptsas_get_hba_portinfo(ioc);
-			mutex_unlock(&ioc->sas_topology_mutex);
+			port_info = ioc->hba_port_info;
 
 			for (i = 0; i < port_info->num_phys; i++)
 				if (port_info->phy_info[i].identify.sas_address ==
@@ -2707,7 +2747,7 @@ mptsas_probe_hba_phys(MPT_ADAPTER *ioc)
 	struct mptsas_portinfo *port_info, *hba;
 	int error = -ENOMEM, i;
 
-	hba = kzalloc(sizeof(*port_info), GFP_KERNEL);
+	hba = kzalloc(sizeof(struct mptsas_portinfo), GFP_KERNEL);
 	if (! hba)
 		goto out;
 
@@ -2717,9 +2757,10 @@ mptsas_probe_hba_phys(MPT_ADAPTER *ioc)
 
 	mptsas_sas_io_unit_pg1(ioc);
 	mutex_lock(&ioc->sas_topology_mutex);
-	port_info = mptsas_get_hba_portinfo(ioc);
+	port_info = ioc->hba_port_info;
 	if (!port_info) {
-		port_info = hba;
+		ioc->hba_port_info = port_info = hba;
+		ioc->hba_port_num_phy = port_info->num_phys;
 		list_add_tail(&port_info->list, &ioc->sas_topology);
 	} else {
 		for (i = 0; i < hba->num_phys; i++) {
@@ -2735,15 +2776,22 @@ mptsas_probe_hba_phys(MPT_ADAPTER *ioc)
 		hba = NULL;
 	}
 	mutex_unlock(&ioc->sas_topology_mutex);
+#if defined(CPQ_CIM)
+	ioc->num_ports = port_info->num_phys;
+#endif
 	for (i = 0; i < port_info->num_phys; i++) {
 		mptsas_sas_phy_pg0(ioc, &port_info->phy_info[i],
 			(MPI_SAS_PHY_PGAD_FORM_PHY_NUMBER <<
 			 MPI_SAS_PHY_PGAD_FORM_SHIFT), i);
-
+		port_info->phy_info[i].identify.handle =
+		    port_info->phy_info[i].handle;
 		mptsas_sas_device_pg0(ioc, &port_info->phy_info[i].identify,
 			(MPI_SAS_DEVICE_PGAD_FORM_HANDLE <<
 			 MPI_SAS_DEVICE_PGAD_FORM_SHIFT),
-			 port_info->phy_info[i].handle);
+			 port_info->phy_info[i].identify.handle);
+		if (!ioc->hba_port_sas_addr)
+			ioc->hba_port_sas_addr =
+			    port_info->phy_info[i].identify.sas_address;
 		port_info->phy_info[i].identify.phy_id =
 		    port_info->phy_info[i].phy_id = i;
 		if (port_info->phy_info[i].attached.handle)
@@ -2944,34 +2992,496 @@ mptsas_delete_expander_phys(MPT_ADAPTER *ioc)
 	mutex_unlock(&ioc->sas_topology_mutex);
 }
 
+static void
+mptsas_expander_refresh(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info)
+{
+	struct mptsas_portinfo *parent;
+	struct device *parent_dev;
+	struct sas_rphy	*rphy;
+	int		i;
+	u64		sas_address; /* expander sas address */
+	u32		handle;
+
+	handle = port_info->phy_info[0].handle;
+	sas_address = port_info->phy_info[0].identify.sas_address;
+	for (i = 0; i < port_info->num_phys; i++) {
+		mptsas_sas_expander_pg1(ioc, &port_info->phy_info[i],
+		    (MPI_SAS_EXPAND_PGAD_FORM_HANDLE_PHY_NUM <<
+		    MPI_SAS_EXPAND_PGAD_FORM_SHIFT), (i << 16) + handle);
+
+		mptsas_sas_device_pg0(ioc,
+		    &port_info->phy_info[i].identify,
+		    (MPI_SAS_DEVICE_PGAD_FORM_HANDLE <<
+		    MPI_SAS_DEVICE_PGAD_FORM_SHIFT),
+		    port_info->phy_info[i].identify.handle);
+		port_info->phy_info[i].identify.phy_id =
+		    port_info->phy_info[i].phy_id;
+
+		if (port_info->phy_info[i].attached.handle) {
+			mptsas_sas_device_pg0(ioc,
+			    &port_info->phy_info[i].attached,
+			    (MPI_SAS_DEVICE_PGAD_FORM_HANDLE <<
+			     MPI_SAS_DEVICE_PGAD_FORM_SHIFT),
+			    port_info->phy_info[i].attached.handle);
+			port_info->phy_info[i].attached.phy_id =
+			    port_info->phy_info[i].phy_id;
+		}
+	}
+
+	mutex_lock(&ioc->sas_topology_mutex);
+	parent = mptsas_find_portinfo_by_handle(ioc,
+	    port_info->phy_info[0].identify.handle_parent);
+	if (!parent) {
+		mutex_unlock(&ioc->sas_topology_mutex);
+		return;
+	}
+	for (i = 0, parent_dev = NULL; i < parent->num_phys && !parent_dev;
+	    i++) {
+		if (parent->phy_info[i].attached.sas_address == sas_address) {
+			rphy = mptsas_get_rphy(&parent->phy_info[i]);
+			parent_dev = &rphy->dev;
+		}
+	}
+	mutex_unlock(&ioc->sas_topology_mutex);
+
+	mptsas_setup_wide_ports(ioc, port_info);
+	for (i = 0; i < port_info->num_phys; i++, ioc->sas_index++)
+		mptsas_probe_one_phy(parent_dev, &port_info->phy_info[i],
+		    ioc->sas_index, 0);
+}
+
+static void
+mptsas_expander_event_add(MPT_ADAPTER *ioc,
+    MpiEventDataSasExpanderStatusChange_t *expander_data)
+{
+	struct mptsas_portinfo *port_info;
+	int i;
+	__le64 sas_address;
+
+	port_info = kzalloc(sizeof(struct mptsas_portinfo), GFP_KERNEL);
+	if (!port_info)
+		BUG();
+	port_info->num_phys = (expander_data->NumPhys) ?
+	    expander_data->NumPhys : 1;
+	port_info->phy_info = kcalloc(port_info->num_phys,
+	    sizeof(struct mptsas_phyinfo), GFP_KERNEL);
+	if (!port_info->phy_info)
+		BUG();
+	memcpy(&sas_address, &expander_data->SASAddress, sizeof(__le64));
+	for (i = 0; i < port_info->num_phys; i++) {
+		port_info->phy_info[i].portinfo = port_info;
+		port_info->phy_info[i].handle =
+		    le16_to_cpu(expander_data->DevHandle);
+		port_info->phy_info[i].identify.sas_address =
+		    le64_to_cpu(sas_address);
+		port_info->phy_info[i].identify.handle_parent =
+		    le16_to_cpu(expander_data->ParentDevHandle);
+	}
+
+	mutex_lock(&ioc->sas_topology_mutex);
+	list_add_tail(&port_info->list, &ioc->sas_topology);
+	mutex_unlock(&ioc->sas_topology_mutex);
+
+	printk(MYIOC_s_INFO_FMT "add expander: num_phys %d, "
+	    "sas_addr (0x%llx)\n", ioc->name, port_info->num_phys,
+	    (unsigned long long)sas_address);
+
+	mptsas_expander_refresh(ioc, port_info);
+}
+
+/**
+ * mptsas_delete_expander_siblings - remove siblings attached to expander
+ * @ioc: Pointer to MPT_ADAPTER structure
+ * @parent: the parent port_info object
+ * @expander: the expander port_info object
+ **/
+static void
+mptsas_delete_expander_siblings(MPT_ADAPTER *ioc, struct mptsas_portinfo
+    *parent, struct mptsas_portinfo *expander)
+{
+	struct mptsas_phyinfo *phy_info;
+	struct mptsas_portinfo *port_info;
+	struct sas_rphy *rphy;
+	int i;
+
+	phy_info = expander->phy_info;
+	for (i = 0; i < expander->num_phys; i++, phy_info++) {
+		rphy = mptsas_get_rphy(phy_info);
+		if (!rphy)
+			continue;
+		if (rphy->identify.device_type == SAS_END_DEVICE)
+			mptsas_del_end_device(ioc, phy_info);
+	}
+
+	phy_info = expander->phy_info;
+	for (i = 0; i < expander->num_phys; i++, phy_info++) {
+		rphy = mptsas_get_rphy(phy_info);
+		if (!rphy)
+			continue;
+		if (rphy->identify.device_type ==
+		    MPI_SAS_DEVICE_INFO_EDGE_EXPANDER ||
+		    rphy->identify.device_type ==
+		    MPI_SAS_DEVICE_INFO_FANOUT_EXPANDER) {
+			port_info = mptsas_find_portinfo_by_sas_address(ioc,
+			    rphy->identify.sas_address);
+			if (!port_info)
+				continue;
+			if (port_info == parent) /* backlink rphy */
+				continue;
+			/*
+			Delete this expander even if the expdevpage is exists
+			because the parent expander is already deleted
+			*/
+			mptsas_expander_delete(ioc, port_info, 1);
+		}
+	}
+}
+
+
+/**
+ *	mptsas_expander_delete - remove this expander
+ *	@ioc: Pointer to MPT_ADAPTER structure
+ *	@port_info: expander port_info struct
+ *	@force: Flag to forcefully delete the expander
+ *
+ **/
+
+static void mptsas_expander_delete(MPT_ADAPTER *ioc,
+		struct mptsas_portinfo *port_info, u8 force)
+{
+
+	struct mptsas_portinfo *parent;
+	int		i;
+	u64		expander_sas_address;
+	struct mptsas_phyinfo *phy_info;
+	struct mptsas_portinfo buffer;
+	struct mptsas_portinfo_details *port_details;
+	struct sas_port *port;
+
+	if (!port_info)
+		return;
+
+	/* see if expander is still there before deleting */
+	mptsas_sas_expander_pg0(ioc, &buffer,
+	    (MPI_SAS_EXPAND_PGAD_FORM_HANDLE <<
+	    MPI_SAS_EXPAND_PGAD_FORM_SHIFT),
+	    port_info->phy_info[0].identify.handle);
+
+	if (buffer.num_phys) {
+		kfree(buffer.phy_info);
+		if (!force)
+			return;
+	}
+
+
+	/*
+	 * Obtain the port_info instance to the parent port
+	 */
+	port_details = NULL;
+	expander_sas_address =
+	    port_info->phy_info[0].identify.sas_address;
+	parent = mptsas_find_portinfo_by_handle(ioc,
+	    port_info->phy_info[0].identify.handle_parent);
+	mptsas_delete_expander_siblings(ioc, parent, port_info);
+	if (!parent)
+		goto out;
+
+	/*
+	 * Delete rphys in the parent that point
+	 * to this expander.
+	 */
+	phy_info = parent->phy_info;
+	port = NULL;
+	for (i = 0; i < parent->num_phys; i++, phy_info++) {
+		if (!phy_info->phy)
+			continue;
+		if (phy_info->attached.sas_address !=
+		    expander_sas_address)
+			continue;
+		if (!port) {
+			port = mptsas_get_port(phy_info);
+			port_details = phy_info->port_details;
+		}
+		dev_printk(KERN_DEBUG, &phy_info->phy->dev,
+		    MYIOC_s_FMT "delete phy %d, phy-obj (0x%p)\n", ioc->name,
+		    phy_info->phy_id, phy_info->phy);
+		sas_port_delete_phy(port, phy_info->phy);
+	}
+	if (port) {
+		dev_printk(KERN_DEBUG, &port->dev,
+		    MYIOC_s_FMT "delete port %d, sas_addr (0x%llx)\n",
+		    ioc->name, port->port_identifier,
+		    (unsigned long long)expander_sas_address);
+		sas_port_delete(port);
+		mptsas_port_delete(ioc, port_details);
+	}
+ out:
+
+	printk(MYIOC_s_INFO_FMT "delete expander: num_phys %d, "
+	    "sas_addr (0x%llx)\n",  ioc->name, port_info->num_phys,
+	    (unsigned long long)expander_sas_address);
+
+	/*
+	 * free link
+	 */
+	list_del(&port_info->list);
+	kfree(port_info->phy_info);
+	kfree(port_info);
+}
+
+
+/**
+ * mptsas_send_expander_event - expanders events
+ * @ioc: Pointer to MPT_ADAPTER structure
+ * @expander_data: event data
+ *
+ *
+ * This function handles adding, removing, and refreshing
+ * device handles within the expander objects.
+ */
+static void
+mptsas_send_expander_event(struct fw_event_work *fw_event)
+{
+	MPT_ADAPTER *ioc;
+	MpiEventDataSasExpanderStatusChange_t *expander_data;
+	struct mptsas_portinfo *port_info;
+	__le64 sas_address;
+	int i;
+
+	ioc = fw_event->ioc;
+	expander_data = (MpiEventDataSasExpanderStatusChange_t *)
+	    fw_event->event_data;
+	memcpy(&sas_address, &expander_data->SASAddress, sizeof(__le64));
+	port_info = mptsas_find_portinfo_by_sas_address(ioc, sas_address);
+
+	if (expander_data->ReasonCode == MPI_EVENT_SAS_EXP_RC_ADDED) {
+		if (port_info) {
+			for (i = 0; i < port_info->num_phys; i++) {
+				port_info->phy_info[i].portinfo = port_info;
+				port_info->phy_info[i].handle =
+				    le16_to_cpu(expander_data->DevHandle);
+				port_info->phy_info[i].identify.sas_address =
+				    le64_to_cpu(sas_address);
+				port_info->phy_info[i].identify.handle_parent =
+				    le16_to_cpu(expander_data->ParentDevHandle);
+			}
+			mptsas_expander_refresh(ioc, port_info);
+		} else if (!port_info && expander_data->NumPhys)
+			mptsas_expander_event_add(ioc, expander_data);
+	} else if (expander_data->ReasonCode ==
+	    MPI_EVENT_SAS_EXP_RC_NOT_RESPONDING)
+		mptsas_expander_delete(ioc, port_info, 0);
+
+	mptsas_free_fw_event(ioc, fw_event);
+}
+
+
+/**
+ * mptsas_expander_add -
+ * @ioc: Pointer to MPT_ADAPTER structure
+ * @handle:
+ *
+ */
+struct mptsas_portinfo *
+mptsas_expander_add(MPT_ADAPTER *ioc, u16 handle)
+{
+	struct mptsas_portinfo buffer, *port_info;
+	int i;
+
+	if ((mptsas_sas_expander_pg0(ioc, &buffer,
+	    (MPI_SAS_EXPAND_PGAD_FORM_HANDLE <<
+	    MPI_SAS_EXPAND_PGAD_FORM_SHIFT), handle)))
+		return NULL;
+
+	port_info = kzalloc(sizeof(struct mptsas_portinfo), GFP_ATOMIC);
+	if (!port_info) {
+		dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
+		"%s: exit at line=%d\n", ioc->name,
+		__func__, __LINE__));
+		return NULL;
+	}
+	port_info->num_phys = buffer.num_phys;
+	port_info->phy_info = buffer.phy_info;
+	for (i = 0; i < port_info->num_phys; i++)
+		port_info->phy_info[i].portinfo = port_info;
+	mutex_lock(&ioc->sas_topology_mutex);
+	list_add_tail(&port_info->list, &ioc->sas_topology);
+	mutex_unlock(&ioc->sas_topology_mutex);
+	printk(MYIOC_s_INFO_FMT "add expander: num_phys %d, "
+	    "sas_addr (0x%llx)\n", ioc->name, port_info->num_phys,
+	    (unsigned long long)buffer.phy_info[0].identify.sas_address);
+	mptsas_expander_refresh(ioc, port_info);
+	return port_info;
+}
+
+static void
+mptsas_send_link_status_event(struct fw_event_work *fw_event)
+{
+	MPT_ADAPTER *ioc;
+	MpiEventDataSasPhyLinkStatus_t *link_data;
+	struct mptsas_portinfo *port_info;
+	struct mptsas_phyinfo *phy_info = NULL;
+	__le64 sas_address;
+	u8 phy_num;
+	u8 link_rate;
+
+	ioc = fw_event->ioc;
+	link_data = (MpiEventDataSasPhyLinkStatus_t *)fw_event->event_data;
+
+	memcpy(&sas_address, &link_data->SASAddress, sizeof(__le64));
+	sas_address = le64_to_cpu(sas_address);
+	link_rate = link_data->LinkRates >> 4;
+	phy_num = link_data->PhyNum;
+
+	port_info = mptsas_find_portinfo_by_sas_address(ioc, sas_address);
+	if (port_info) {
+		phy_info = &port_info->phy_info[phy_num];
+		if (phy_info)
+			phy_info->negotiated_link_rate = link_rate;
+	}
+
+	if (link_rate == MPI_SAS_IOUNIT0_RATE_1_5 ||
+	    link_rate == MPI_SAS_IOUNIT0_RATE_3_0) {
+
+		if (!port_info) {
+			goto out;
+		}
+		if (port_info == ioc->hba_port_info)
+			mptsas_probe_hba_phys(ioc);
+		else
+			mptsas_expander_refresh(ioc, port_info);
+	} else if (phy_info && phy_info->phy) {
+		if (link_rate ==  MPI_SAS_IOUNIT0_RATE_PHY_DISABLED)
+			phy_info->phy->negotiated_linkrate =
+			    SAS_PHY_DISABLED;
+		else if (link_rate ==
+		    MPI_SAS_IOUNIT0_RATE_FAILED_SPEED_NEGOTIATION)
+			phy_info->phy->negotiated_linkrate =
+			    SAS_LINK_RATE_FAILED;
+		else
+			phy_info->phy->negotiated_linkrate =
+			    SAS_LINK_RATE_UNKNOWN;
+	}
+ out:
+	mptsas_free_fw_event(ioc, fw_event);
+}
+
+/**
+ *	mptsas_probe_expanders - adding expanders
+ *	@ioc: Pointer to MPT_ADAPTER structure
+ *
+ **/
+static void
+mptsas_probe_expanders(MPT_ADAPTER *ioc)
+{
+	struct mptsas_portinfo buffer, *port_info;
+	u32 			handle;
+	int i;
+
+	handle = 0xFFFF;
+	while (!mptsas_sas_expander_pg0(ioc, &buffer,
+	    (MPI_SAS_EXPAND_PGAD_FORM_GET_NEXT_HANDLE <<
+	     MPI_SAS_EXPAND_PGAD_FORM_SHIFT), handle)) {
+
+		handle = buffer.phy_info[0].handle;
+		port_info = mptsas_find_portinfo_by_sas_address(ioc,
+		    buffer.phy_info[0].identify.sas_address);
+
+		if (port_info) {
+			/* refreshing handles */
+			for (i = 0; i < buffer.num_phys; i++) {
+				port_info->phy_info[i].handle = handle;
+				port_info->phy_info[i].identify.handle_parent =
+				    buffer.phy_info[0].identify.handle_parent;
+			}
+			mptsas_expander_refresh(ioc, port_info);
+			kfree(buffer.phy_info);
+			continue;
+		}
+
+		port_info = kzalloc(sizeof(struct mptsas_portinfo), GFP_KERNEL);
+		if (!port_info) {
+			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
+			"%s: exit at line=%d\n", ioc->name,
+			__func__, __LINE__));
+			return;
+		}
+		port_info->num_phys = buffer.num_phys;
+		port_info->phy_info = buffer.phy_info;
+		for (i = 0; i < port_info->num_phys; i++)
+			port_info->phy_info[i].portinfo = port_info;
+		mutex_lock(&ioc->sas_topology_mutex);
+		list_add_tail(&port_info->list, &ioc->sas_topology);
+		mutex_unlock(&ioc->sas_topology_mutex);
+		printk(MYIOC_s_INFO_FMT "add expander: num_phys %d, "
+		    "sas_addr (0x%llx)\n", ioc->name, port_info->num_phys,
+	    (unsigned long long)buffer.phy_info[0].identify.sas_address);
+		mptsas_expander_refresh(ioc, port_info);
+	}
+}
+
+static void
+mptsas_probe_devices(MPT_ADAPTER *ioc)
+{
+	u16 handle;
+	struct mptsas_devinfo sas_device;
+	struct mptsas_phyinfo *phy_info;
+
+	handle = 0xFFFF;
+	while (!(mptsas_sas_device_pg0(ioc, &sas_device,
+	    MPI_SAS_DEVICE_PGAD_FORM_GET_NEXT_HANDLE, handle))) {
+
+		handle = sas_device.handle;
+
+		if ((sas_device.device_info &
+		     (MPI_SAS_DEVICE_INFO_SSP_TARGET |
+		      MPI_SAS_DEVICE_INFO_STP_TARGET |
+		      MPI_SAS_DEVICE_INFO_SATA_DEVICE)) == 0)
+			continue;
+
+		phy_info = mptsas_refreshing_device_handles(ioc, &sas_device);
+		if (!phy_info)
+			continue;
+
+		if (mptsas_get_rphy(phy_info))
+			continue;
+
+		mptsas_add_end_device(ioc, phy_info);
+	}
+}
+
 /*
  * Start of day discovery
  */
 static void
 mptsas_scan_sas_topology(MPT_ADAPTER *ioc)
 {
-	u32 handle = 0xFFFF;
+	struct scsi_device *sdev;
 	int i;
 
-	mutex_lock(&ioc->sas_discovery_mutex);
 	mptsas_probe_hba_phys(ioc);
-	while (!mptsas_probe_expander_phys(ioc, &handle))
-		;
+	mptsas_probe_expanders(ioc);
+	mptsas_probe_devices(ioc);
+
 	/*
 	  Reporting RAID volumes.
 	*/
-	if (!ioc->ir_firmware)
-		goto out;
-	if (!ioc->raid_data.pIocPg2)
-		goto out;
-	if (!ioc->raid_data.pIocPg2->NumActiveVolumes)
-		goto out;
+	if (!ioc->ir_firmware || !ioc->raid_data.pIocPg2 ||
+	    !ioc->raid_data.pIocPg2->NumActiveVolumes)
+		return;
 	for (i = 0; i < ioc->raid_data.pIocPg2->NumActiveVolumes; i++) {
+		sdev = scsi_device_lookup(ioc->sh, MPTSAS_RAID_CHANNEL,
+		    ioc->raid_data.pIocPg2->RaidVolume[i].VolumeID, 0);
+		if (sdev) {
+			scsi_device_put(sdev);
+			continue;
+		}
+		printk(MYIOC_s_INFO_FMT "attaching raid volume, channel %d, "
+		    "id %d\n", ioc->name, MPTSAS_RAID_CHANNEL,
+		    ioc->raid_data.pIocPg2->RaidVolume[i].VolumeID);
 		scsi_add_device(ioc->sh, MPTSAS_RAID_CHANNEL,
 		    ioc->raid_data.pIocPg2->RaidVolume[i].VolumeID, 0);
 	}
- out:
-	mutex_unlock(&ioc->sas_discovery_mutex);
 }
 
 /*
@@ -3631,10 +4141,28 @@ mptsas_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *reply)
 		}
 		break;
 	}
-	case MPI_EVENT_SAS_DISCOVERY:
-		mptsas_send_discovery_event(ioc,
-			(EVENT_DATA_SAS_DISCOVERY *)reply->Data);
+	case MPI_EVENT_SAS_EXPANDER_STATUS_CHANGE:
+	{
+		MpiEventDataSasExpanderStatusChange_t *expander_data =
+		    (MpiEventDataSasExpanderStatusChange_t *)reply->Data;
+
+
+		if (expander_data->ReasonCode ==
+		    MPI_EVENT_SAS_EXP_RC_NOT_RESPONDING &&
+		    ioc->device_missing_delay)
+			delay = HZ * ioc->device_missing_delay;
 		break;
+	}
+	case MPI_EVENT_SAS_DISCOVERY:
+	{
+		u32 discovery_status;
+		EventDataSasDiscovery_t *discovery_data =
+		    (EventDataSasDiscovery_t *)reply->Data;
+
+		discovery_status = le32_to_cpu(discovery_data->DiscoveryStatus);
+		ioc->sas_discovery_quiesce_io = discovery_status ? 1 : 0;
+		return 0;
+	}
 	case MPI_EVENT_INTEGRATED_RAID:
 	case MPI_EVENT_PERSISTENT_TABLE_FULL:
 	case MPI_EVENT_IR2:
@@ -3882,7 +4410,7 @@ static void __devexit mptsas_remove(struct pci_dev *pdev)
 		kfree(p);
 	}
 	mutex_unlock(&ioc->sas_topology_mutex);
-
+	ioc->hba_port_info = NULL;
 	mptscsih_remove(pdev);
 }
 
