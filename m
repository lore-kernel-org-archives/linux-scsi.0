From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] mptsas: support basic hotplug
Date: Fri, 13 Jan 2006 18:04:41 +0100
Message-ID: <20060113170441.GA2288@lst.de>
References: <20060113100905.GA26592@lst.de> <1137167747.3365.6.camel@mulgrave> <20060113160529.GA813@lst.de> <1137169147.3365.12.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:33243 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1161559AbWAMREy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 12:04:54 -0500
Content-Disposition: inline
In-Reply-To: <1137169147.3365.12.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@lst.de>, Eric.Moore@lsil.com, linux-scsi@vger.kernel.org

On Fri, Jan 13, 2006 at 10:19:07AM -0600, James Bottomley wrote:
> On Fri, 2006-01-13 at 17:05 +0100, Christoph Hellwig wrote:
> > well, the scsi-misc tree doesn't have the mutex code yet, so it wouldn't
> > compile if I did it that way.  I'll send a followon patch to convert it
> > to use real mutexes ones scsi-misc has merged the latest linus tree.
> 
> Yes it does ... I updated it last night.  Could you pull it down again
> and reroll this patch based on mutexes.


Index: scsi-misc-2.6/drivers/message/fusion/mptsas.c
===================================================================
--- scsi-misc-2.6.orig/drivers/message/fusion/mptsas.c	2006-01-13 17:55:56.000000000 +0100
+++ scsi-misc-2.6/drivers/message/fusion/mptsas.c	2006-01-13 18:03:15.000000000 +0100
@@ -5,7 +5,7 @@
  *
  *  Copyright (c) 1999-2005 LSI Logic Corporation
  *  (mailto:mpt_linux_developer@lsil.com)
- *  Copyright (c) 2005 Dell
+ *  Copyright (c) 2005-2006 Dell
  */
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
@@ -86,6 +86,24 @@
 static int	mptsasMgmtCtx = -1;
 
 
+enum mptsas_hotplug_action {
+	MPTSAS_ADD_DEVICE,
+	MPTSAS_DEL_DEVICE,
+};
+
+struct mptsas_hotplug_event {
+	struct work_struct	work;
+	MPT_ADAPTER		*ioc;
+	enum mptsas_hotplug_action event_type;
+	u64			sas_address;
+	u32			channel;
+	u32			id;
+	u32			device_info;
+	u16			handle;
+	u16			parent_handle;
+	u8			phy_id;
+};
+
 /*
  * SAS topology structures
  *
@@ -99,8 +117,8 @@
 	u8	phy_id;		/* phy number of parent device */
 	u8	port_id;	/* sas physical port this device
 				   is assoc'd with */
-	u8	target;		/* logical target id of this device */
-	u8	bus;		/* logical bus number of this device */
+	u8	id;		/* logical target id of this device */
+	u8	channel;	/* logical bus number of this device */
 	u64	sas_address;    /* WWN of this device,
 				   SATA is assigned by HBA,expander */
 	u32	device_info;	/* bitfield detailed info about this device */
@@ -114,6 +132,7 @@
 	u8	programmed_link_rate;	/* programmed max/min phy link rate */
 	struct mptsas_devinfo identify;	/* point to phy device info */
 	struct mptsas_devinfo attached;	/* point to attached device info */
+	struct sas_phy *phy;
 	struct sas_rphy *rphy;
 };
 
@@ -257,24 +276,27 @@
 	}
 
 	rphy = dev_to_rphy(sdev->sdev_target->dev.parent);
+	mutex_lock(&hd->ioc->sas_topology_mutex);
 	list_for_each_entry(p, &hd->ioc->sas_topology, list) {
 		for (i = 0; i < p->num_phys; i++) {
 			if (p->phy_info[i].attached.sas_address ==
 					rphy->identify.sas_address) {
 				vdev->target_id =
-					p->phy_info[i].attached.target;
-				vdev->bus_id = p->phy_info[i].attached.bus;
+					p->phy_info[i].attached.id;
+				vdev->bus_id = p->phy_info[i].attached.channel;
 				vdev->lun = sdev->lun;
 				goto out;
 			}
 		}
 	}
+	mutex_unlock(&hd->ioc->sas_topology_mutex);
 
 	printk("No matching SAS device found!!\n");
 	kfree(vdev);
 	return -ENODEV;
 
  out:
+	mutex_unlock(&hd->ioc->sas_topology_mutex);
 	vtarget->ioc_id = vdev->ioc_id;
 	vtarget->target_id = vdev->target_id;
 	vtarget->bus_id = vdev->bus_id;
@@ -282,6 +304,42 @@
 	return 0;
 }
 
+static void
+mptsas_slave_destroy(struct scsi_device *sdev)
+{
+	struct Scsi_Host *host = sdev->host;
+	MPT_SCSI_HOST *hd = (MPT_SCSI_HOST *)host->hostdata;
+	struct sas_rphy *rphy;
+	struct mptsas_portinfo *p;
+	int i;
+
+	/*
+	 * Handle hotplug removal case.
+	 * We need to clear out attached data structure.
+	 */
+	rphy = dev_to_rphy(sdev->sdev_target->dev.parent);
+
+	mutex_lock(&hd->ioc->sas_topology_mutex);
+	list_for_each_entry(p, &hd->ioc->sas_topology, list) {
+		for (i = 0; i < p->num_phys; i++) {
+			if (p->phy_info[i].attached.sas_address ==
+					rphy->identify.sas_address) {
+				memset(&p->phy_info[i].attached, 0,
+				    sizeof(struct mptsas_devinfo));
+				p->phy_info[i].rphy = NULL;
+				goto out;
+			}
+		}
+	}
+
+ out:
+	mutex_unlock(&hd->ioc->sas_topology_mutex);
+	/*
+	 * TODO: Issue target reset to flush firmware outstanding commands.
+	 */
+	mptscsih_slave_destroy(sdev);
+}
+
 static struct scsi_host_template mptsas_driver_template = {
 	.module				= THIS_MODULE,
 	.proc_name			= "mptsas",
@@ -293,7 +351,7 @@
 	.slave_alloc			= mptsas_slave_alloc,
 	.slave_configure		= mptscsih_slave_configure,
 	.target_destroy			= mptscsih_target_destroy,
-	.slave_destroy			= mptscsih_slave_destroy,
+	.slave_destroy			= mptsas_slave_destroy,
 	.change_queue_depth 		= mptscsih_change_queue_depth,
 	.eh_abort_handler		= mptscsih_abort,
 	.eh_device_reset_handler	= mptscsih_dev_reset,
@@ -649,8 +707,8 @@
 	device_info->handle = le16_to_cpu(buffer->DevHandle);
 	device_info->phy_id = buffer->PhyNum;
 	device_info->port_id = buffer->PhysicalPort;
-	device_info->target = buffer->TargetID;
-	device_info->bus = buffer->Bus;
+	device_info->id = buffer->TargetID;
+	device_info->channel = buffer->Bus;
 	memcpy(&sas_address, &buffer->SASAddress, sizeof(__le64));
 	device_info->sas_address = le64_to_cpu(sas_address);
 	device_info->device_info =
@@ -858,36 +916,36 @@
 static int mptsas_probe_one_phy(struct device *dev,
 		struct mptsas_phyinfo *phy_info, int index, int local)
 {
-	struct sas_phy *port;
+	struct sas_phy *phy;
 	int error;
 
-	port = sas_phy_alloc(dev, index);
-	if (!port)
+	phy = sas_phy_alloc(dev, index);
+	if (!phy)
 		return -ENOMEM;
 
-	port->port_identifier = phy_info->port_id;
-	mptsas_parse_device_info(&port->identify, &phy_info->identify);
+	phy->port_identifier = phy_info->port_id;
+	mptsas_parse_device_info(&phy->identify, &phy_info->identify);
 
 	/*
 	 * Set Negotiated link rate.
 	 */
 	switch (phy_info->negotiated_link_rate) {
 	case MPI_SAS_IOUNIT0_RATE_PHY_DISABLED:
-		port->negotiated_linkrate = SAS_PHY_DISABLED;
+		phy->negotiated_linkrate = SAS_PHY_DISABLED;
 		break;
 	case MPI_SAS_IOUNIT0_RATE_FAILED_SPEED_NEGOTIATION:
-		port->negotiated_linkrate = SAS_LINK_RATE_FAILED;
+		phy->negotiated_linkrate = SAS_LINK_RATE_FAILED;
 		break;
 	case MPI_SAS_IOUNIT0_RATE_1_5:
-		port->negotiated_linkrate = SAS_LINK_RATE_1_5_GBPS;
+		phy->negotiated_linkrate = SAS_LINK_RATE_1_5_GBPS;
 		break;
 	case MPI_SAS_IOUNIT0_RATE_3_0:
-		port->negotiated_linkrate = SAS_LINK_RATE_3_0_GBPS;
+		phy->negotiated_linkrate = SAS_LINK_RATE_3_0_GBPS;
 		break;
 	case MPI_SAS_IOUNIT0_RATE_SATA_OOB_COMPLETE:
 	case MPI_SAS_IOUNIT0_RATE_UNKNOWN:
 	default:
-		port->negotiated_linkrate = SAS_LINK_RATE_UNKNOWN;
+		phy->negotiated_linkrate = SAS_LINK_RATE_UNKNOWN;
 		break;
 	}
 
@@ -896,10 +954,10 @@
 	 */
 	switch (phy_info->hw_link_rate & MPI_SAS_PHY0_PRATE_MAX_RATE_MASK) {
 	case MPI_SAS_PHY0_HWRATE_MAX_RATE_1_5:
-		port->maximum_linkrate_hw = SAS_LINK_RATE_1_5_GBPS;
+		phy->maximum_linkrate_hw = SAS_LINK_RATE_1_5_GBPS;
 		break;
 	case MPI_SAS_PHY0_PRATE_MAX_RATE_3_0:
-		port->maximum_linkrate_hw = SAS_LINK_RATE_3_0_GBPS;
+		phy->maximum_linkrate_hw = SAS_LINK_RATE_3_0_GBPS;
 		break;
 	default:
 		break;
@@ -911,10 +969,10 @@
 	switch (phy_info->programmed_link_rate &
 			MPI_SAS_PHY0_PRATE_MAX_RATE_MASK) {
 	case MPI_SAS_PHY0_PRATE_MAX_RATE_1_5:
-		port->maximum_linkrate = SAS_LINK_RATE_1_5_GBPS;
+		phy->maximum_linkrate = SAS_LINK_RATE_1_5_GBPS;
 		break;
 	case MPI_SAS_PHY0_PRATE_MAX_RATE_3_0:
-		port->maximum_linkrate = SAS_LINK_RATE_3_0_GBPS;
+		phy->maximum_linkrate = SAS_LINK_RATE_3_0_GBPS;
 		break;
 	default:
 		break;
@@ -925,10 +983,10 @@
 	 */
 	switch (phy_info->hw_link_rate & MPI_SAS_PHY0_HWRATE_MIN_RATE_MASK) {
 	case MPI_SAS_PHY0_HWRATE_MIN_RATE_1_5:
-		port->minimum_linkrate_hw = SAS_LINK_RATE_1_5_GBPS;
+		phy->minimum_linkrate_hw = SAS_LINK_RATE_1_5_GBPS;
 		break;
 	case MPI_SAS_PHY0_PRATE_MIN_RATE_3_0:
-		port->minimum_linkrate_hw = SAS_LINK_RATE_3_0_GBPS;
+		phy->minimum_linkrate_hw = SAS_LINK_RATE_3_0_GBPS;
 		break;
 	default:
 		break;
@@ -940,28 +998,29 @@
 	switch (phy_info->programmed_link_rate &
 			MPI_SAS_PHY0_PRATE_MIN_RATE_MASK) {
 	case MPI_SAS_PHY0_PRATE_MIN_RATE_1_5:
-		port->minimum_linkrate = SAS_LINK_RATE_1_5_GBPS;
+		phy->minimum_linkrate = SAS_LINK_RATE_1_5_GBPS;
 		break;
 	case MPI_SAS_PHY0_PRATE_MIN_RATE_3_0:
-		port->minimum_linkrate = SAS_LINK_RATE_3_0_GBPS;
+		phy->minimum_linkrate = SAS_LINK_RATE_3_0_GBPS;
 		break;
 	default:
 		break;
 	}
 
 	if (local)
-		port->local_attached = 1;
+		phy->local_attached = 1;
 
-	error = sas_phy_add(port);
+	error = sas_phy_add(phy);
 	if (error) {
-		sas_phy_free(port);
+		sas_phy_free(phy);
 		return error;
 	}
+	phy_info->phy = phy;
 
 	if (phy_info->attached.handle) {
 		struct sas_rphy *rphy;
 
-		rphy = sas_rphy_alloc(port);
+		rphy = sas_rphy_alloc(phy);
 		if (!rphy)
 			return 0; /* non-fatal: an rphy can be added later */
 
@@ -994,7 +1053,10 @@
 	if (error)
 		goto out_free_port_info;
 
+	mutex_lock(&ioc->sas_topology_mutex);
 	list_add_tail(&port_info->list, &ioc->sas_topology);
+	mutex_unlock(&ioc->sas_topology_mutex);
+
 	for (i = 0; i < port_info->num_phys; i++) {
 		mptsas_sas_phy_pg0(ioc, &port_info->phy_info[i],
 			(MPI_SAS_PHY_PGAD_FORM_PHY_NUMBER <<
@@ -1047,7 +1109,10 @@
 
 	*handle = port_info->handle;
 
+	mutex_lock(&ioc->sas_topology_mutex);
 	list_add_tail(&port_info->list, &ioc->sas_topology);
+	mutex_unlock(&ioc->sas_topology_mutex);
+
 	for (i = 0; i < port_info->num_phys; i++) {
 		struct device *parent;
 
@@ -1079,6 +1144,7 @@
 		 * HBA phys.
 		 */
 		parent = &ioc->sh->shost_gendev;
+		mutex_lock(&ioc->sas_topology_mutex);
 		list_for_each_entry(p, &ioc->sas_topology, list) {
 			for (j = 0; j < p->num_phys; j++) {
 				if (port_info->phy_info[i].identify.handle ==
@@ -1086,6 +1152,7 @@
 					parent = &p->phy_info[j].rphy->dev;
 			}
 		}
+		mutex_unlock(&ioc->sas_topology_mutex);
 
 		mptsas_probe_one_phy(parent, &port_info->phy_info[i],
 				     *index, 0);
@@ -1111,6 +1178,211 @@
 		;
 }
 
+static struct mptsas_phyinfo *
+mptsas_find_phyinfo_by_parent(MPT_ADAPTER *ioc, u16 parent_handle, u8 phy_id)
+{
+	struct mptsas_portinfo *port_info;
+	struct mptsas_devinfo device_info;
+	struct mptsas_phyinfo *phy_info = NULL;
+	int i, error;
+
+	/*
+	 * Retrieve the parent sas_address
+	 */
+	error = mptsas_sas_device_pg0(ioc, &device_info,
+		(MPI_SAS_DEVICE_PGAD_FORM_HANDLE <<
+		 MPI_SAS_DEVICE_PGAD_FORM_SHIFT),
+		parent_handle);
+	if (error) {
+		printk("mptsas: failed to retrieve device page\n");
+		return NULL;
+	}
+
+	/*
+	 * The phy_info structures are never deallocated during lifetime of
+	 * a host, so the code below is safe without additional refcounting.
+	 */
+	mutex_lock(&ioc->sas_topology_mutex);
+	list_for_each_entry(port_info, &ioc->sas_topology, list) {
+		for (i = 0; i < port_info->num_phys; i++) {
+			if (port_info->phy_info[i].identify.sas_address ==
+			    device_info.sas_address &&
+			    port_info->phy_info[i].phy_id == phy_id) {
+				phy_info = &port_info->phy_info[i];
+				break;
+			}
+		}
+	}
+	mutex_unlock(&ioc->sas_topology_mutex);
+
+	return phy_info;
+}
+
+static struct mptsas_phyinfo *
+mptsas_find_phyinfo_by_handle(MPT_ADAPTER *ioc, u16 handle)
+{
+	struct mptsas_portinfo *port_info;
+	struct mptsas_phyinfo *phy_info = NULL;
+	int i;
+
+	/*
+	 * The phy_info structures are never deallocated during lifetime of
+	 * a host, so the code below is safe without additional refcounting.
+	 */
+	mutex_lock(&ioc->sas_topology_mutex);
+	list_for_each_entry(port_info, &ioc->sas_topology, list) {
+		for (i = 0; i < port_info->num_phys; i++) {
+			if (port_info->phy_info[i].attached.handle == handle) {
+				phy_info = &port_info->phy_info[i];
+				break;
+			}
+		}
+	}
+	mutex_unlock(&ioc->sas_topology_mutex);
+
+	return phy_info;
+}
+
+static void
+mptsas_hotplug_work(void *arg)
+{
+	struct mptsas_hotplug_event *ev = arg;
+	MPT_ADAPTER *ioc = ev->ioc;
+	struct mptsas_phyinfo *phy_info;
+	struct sas_rphy *rphy;
+	char *ds = NULL;
+
+	if (ev->device_info & MPI_SAS_DEVICE_INFO_SSP_TARGET)
+		ds = "ssp";
+	if (ev->device_info & MPI_SAS_DEVICE_INFO_STP_TARGET)
+		ds = "stp";
+	if (ev->device_info & MPI_SAS_DEVICE_INFO_SATA_DEVICE)
+		ds = "sata";
+
+	switch (ev->event_type) {
+	case MPTSAS_DEL_DEVICE:
+		printk(MYIOC_s_INFO_FMT
+		       "removing %s device, channel %d, id %d, phy %d\n",
+		       ioc->name, ds, ev->channel, ev->id, ev->phy_id);
+
+		phy_info = mptsas_find_phyinfo_by_handle(ioc, ev->handle);
+		if (!phy_info) {
+			printk("mptsas: remove event for non-existant PHY.\n");
+			break;
+		}
+
+		if (phy_info->rphy) {
+			sas_rphy_delete(phy_info->rphy);
+			phy_info->rphy = NULL;
+		}
+		break;
+	case MPTSAS_ADD_DEVICE:
+		printk(MYIOC_s_INFO_FMT
+		       "attaching %s device, channel %d, id %d, phy %d\n",
+		       ioc->name, ds, ev->channel, ev->id, ev->phy_id);
+
+		phy_info = mptsas_find_phyinfo_by_parent(ioc,
+				ev->parent_handle, ev->phy_id);
+		if (!phy_info) {
+			printk("mptsas: add event for non-existant PHY.\n");
+			break;
+		}
+
+		if (phy_info->rphy) {
+			printk("mptsas: trying to add existing device.\n");
+			break;
+		}
+
+		/* fill attached info */
+		phy_info->attached.handle = ev->handle;
+		phy_info->attached.phy_id = ev->phy_id;
+		phy_info->attached.port_id = phy_info->identify.port_id;
+		phy_info->attached.id = ev->id;
+		phy_info->attached.channel = ev->channel;
+		phy_info->attached.sas_address = ev->sas_address;
+		phy_info->attached.device_info = ev->device_info;
+
+		rphy = sas_rphy_alloc(phy_info->phy);
+		if (!rphy)
+			break; /* non-fatal: an rphy can be added later */
+
+		mptsas_parse_device_info(&rphy->identify, &phy_info->attached);
+		if (sas_rphy_add(rphy)) {
+			sas_rphy_free(rphy);
+			break;
+		}
+
+		phy_info->rphy = rphy;
+		break;
+	}
+
+	kfree(ev);
+}
+
+static void
+mptscsih_send_sas_event(MPT_ADAPTER *ioc,
+		EVENT_DATA_SAS_DEVICE_STATUS_CHANGE *sas_event_data)
+{
+	struct mptsas_hotplug_event *ev;
+	u32 device_info = le32_to_cpu(sas_event_data->DeviceInfo);
+	__le64 sas_address;
+
+	if ((device_info &
+	     (MPI_SAS_DEVICE_INFO_SSP_TARGET |
+	      MPI_SAS_DEVICE_INFO_STP_TARGET |
+	      MPI_SAS_DEVICE_INFO_SATA_DEVICE )) == 0)
+		return;
+
+	if ((sas_event_data->ReasonCode &
+	     (MPI_EVENT_SAS_DEV_STAT_RC_ADDED |
+	      MPI_EVENT_SAS_DEV_STAT_RC_NOT_RESPONDING)) == 0)
+		return;
+
+	ev = kmalloc(sizeof(*ev), GFP_ATOMIC);
+	if (!ev) {
+		printk(KERN_WARNING "mptsas: lost hotplug event\n");
+		return;
+	}
+
+
+	INIT_WORK(&ev->work, mptsas_hotplug_work, ev);
+	ev->ioc = ioc;
+	ev->handle = le16_to_cpu(sas_event_data->DevHandle);
+	ev->parent_handle = le16_to_cpu(sas_event_data->ParentDevHandle);
+	ev->channel = sas_event_data->Bus;
+	ev->id = sas_event_data->TargetID;
+	ev->phy_id = sas_event_data->PhyNum;
+	memcpy(&sas_address, &sas_event_data->SASAddress, sizeof(__le64));
+	ev->sas_address = le64_to_cpu(sas_address);
+	ev->device_info = device_info;
+
+	if (sas_event_data->ReasonCode & MPI_EVENT_SAS_DEV_STAT_RC_ADDED)
+		ev->event_type = MPTSAS_ADD_DEVICE;
+	else
+		ev->event_type = MPTSAS_DEL_DEVICE;
+
+	schedule_work(&ev->work);
+}
+
+static int
+mptsas_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *reply)
+{
+	u8 event = le32_to_cpu(reply->Event) & 0xFF;
+
+	if (!ioc->sh)
+		return 1;
+
+	switch (event) {
+	case MPI_EVENT_SAS_DEVICE_STATUS_CHANGE:
+		mptscsih_send_sas_event(ioc,
+			(EVENT_DATA_SAS_DEVICE_STATUS_CHANGE *)reply->Data);
+		return 1;		/* currently means nothing really */
+
+	default:
+		return mptscsih_event_process(ioc, reply);
+	}
+}
+
 static int
 mptsas_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
@@ -1203,6 +1475,8 @@
 	sh->unique_id = ioc->id;
 
 	INIT_LIST_HEAD(&ioc->sas_topology);
+	mutex_init(&ioc->sas_topology_mutex);
+
 	init_MUTEX(&ioc->sas_mgmt.mutex);
 	init_completion(&ioc->sas_mgmt.done);
 
@@ -1339,10 +1613,12 @@
 
 	sas_remove_host(ioc->sh);
 
+	mutex_lock(&ioc->sas_topology_mutex);
 	list_for_each_entry_safe(p, n, &ioc->sas_topology, list) {
 		list_del(&p->list);
 		kfree(p);
 	}
+	mutex_unlock(&ioc->sas_topology_mutex);
 
 	mptscsih_remove(pdev);
 }
@@ -1393,7 +1669,7 @@
 		mpt_register(mptscsih_scandv_complete, MPTSAS_DRIVER);
 	mptsasMgmtCtx = mpt_register(mptsas_mgmt_done, MPTSAS_DRIVER);
 
-	if (mpt_event_register(mptsasDoneCtx, mptscsih_event_process) == 0) {
+	if (mpt_event_register(mptsasDoneCtx, mptsas_event_process) == 0) {
 		devtprintk((KERN_INFO MYNAM
 		  ": Registered for IOC event notifications\n"));
 	}
Index: scsi-misc-2.6/drivers/message/fusion/mptbase.h
===================================================================
--- scsi-misc-2.6.orig/drivers/message/fusion/mptbase.h	2006-01-13 17:55:56.000000000 +0100
+++ scsi-misc-2.6/drivers/message/fusion/mptbase.h	2006-01-13 18:01:07.000000000 +0100
@@ -612,6 +612,7 @@
 	struct list_head	 list;
 	struct net_device	*netdev;
 	struct list_head	 sas_topology;
+	struct mutex		 sas_topology_mutex;
 	MPT_SAS_MGMT		 sas_mgmt;
 } MPT_ADAPTER;
 
