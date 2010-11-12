From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 05/11] mpt2sas: Modify code to support Expander switch
Date: Sat, 13 Nov 2010 04:35:30 +0530
Message-ID: <20101112230521.GG853@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:39228 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932303Ab0KLXrz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Nov 2010 18:47:55 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Issue : Switch swap doesn't work when device missing delay is enabled.

(1) add support to individually add and remove phys to and from
existing ports. This replaces the routine
_transport_delete_duplicate_port.
(2) _scsih_sas_host_refresh - was modified to change the link rate
from zero to 1.5 GB rate when the firmware reports there is an
attached device with zero link.
(3) add new function mpt2sas_device_remove, this is wrapper function
deletes some redundant code through out driver by combining into one
subrountine
(4) two subroutines were modified so the sas_device, raid_device, and
port lists are traversed once when objects are deleted from the list.
Previously it was looping back each time an object was deleted from the
list.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index edf1a02..428a8c2 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -849,6 +849,8 @@ int mpt2sas_scsih_issue_tm(struct MPT2SAS_ADAPTER *ioc, u16 handle,
     ulong timeout, struct scsi_cmnd *scmd);
 void mpt2sas_scsih_set_tm_flag(struct MPT2SAS_ADAPTER *ioc, u16 handle);
 void mpt2sas_scsih_clear_tm_flag(struct MPT2SAS_ADAPTER *ioc, u16 handle);
+void mpt2sas_expander_remove(struct MPT2SAS_ADAPTER *ioc, u64 sas_address);
+void mpt2sas_device_remove(struct MPT2SAS_ADAPTER *ioc, u64 sas_address);
 struct _sas_node *mpt2sas_scsih_expander_find_by_handle(struct MPT2SAS_ADAPTER *ioc,
     u16 handle);
 struct _sas_node *mpt2sas_scsih_expander_find_by_sas_address(struct MPT2SAS_ADAPTER
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 3824a39..0c17352 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2584,9 +2584,9 @@ _scsih_block_io_to_children_attached_to_ex(struct MPT2SAS_ADAPTER *ioc,
 	   &sas_expander->sas_port_list, port_list) {
 
 		if (mpt2sas_port->remote_identify.device_type ==
-		    MPI2_SAS_DEVICE_INFO_EDGE_EXPANDER ||
+		    SAS_EDGE_EXPANDER_DEVICE ||
 		    mpt2sas_port->remote_identify.device_type ==
-		    MPI2_SAS_DEVICE_INFO_FANOUT_EXPANDER) {
+		    SAS_FANOUT_EXPANDER_DEVICE) {
 
 			spin_lock_irqsave(&ioc->sas_node_lock, flags);
 			expander_sibling =
@@ -3970,6 +3970,7 @@ _scsih_sas_host_refresh(struct MPT2SAS_ADAPTER *ioc)
 	Mpi2ConfigReply_t mpi_reply;
 	Mpi2SasIOUnitPage0_t *sas_iounit_pg0 = NULL;
 	u16 attached_handle;
+	u8 link_rate;
 
 	dtmprintk(ioc, printk(MPT2SAS_INFO_FMT
 	    "updating handles for sas_host(0x%016llx)\n",
@@ -3991,15 +3992,17 @@ _scsih_sas_host_refresh(struct MPT2SAS_ADAPTER *ioc)
 	if (ioc_status != MPI2_IOCSTATUS_SUCCESS)
 		goto out;
 	for (i = 0; i < ioc->sas_hba.num_phys ; i++) {
+		link_rate = sas_iounit_pg0->PhyData[i].NegotiatedLinkRate >> 4;
 		if (i == 0)
 			ioc->sas_hba.handle = le16_to_cpu(sas_iounit_pg0->
 			    PhyData[0].ControllerDevHandle);
 		ioc->sas_hba.phy[i].handle = ioc->sas_hba.handle;
 		attached_handle = le16_to_cpu(sas_iounit_pg0->PhyData[i].
 		    AttachedDevHandle);
+		if (attached_handle && link_rate < MPI2_SAS_NEG_LINK_RATE_1_5)
+			link_rate = MPI2_SAS_NEG_LINK_RATE_1_5;
 		mpt2sas_transport_update_links(ioc, ioc->sas_hba.sas_address,
-		    attached_handle, i, sas_iounit_pg0->PhyData[i].
-		    NegotiatedLinkRate >> 4);
+		    attached_handle, i, link_rate);
 	}
  out:
 	kfree(sas_iounit_pg0);
@@ -4343,14 +4346,14 @@ _scsih_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 }
 
 /**
- * _scsih_expander_remove - removing expander object
+ * mpt2sas_expander_remove - removing expander object
  * @ioc: per adapter object
  * @sas_address: expander sas_address
  *
  * Return nothing.
  */
-static void
-_scsih_expander_remove(struct MPT2SAS_ADAPTER *ioc, u64 sas_address)
+void
+mpt2sas_expander_remove(struct MPT2SAS_ADAPTER *ioc, u64 sas_address)
 {
 	struct _sas_node *sas_expander;
 	unsigned long flags;
@@ -4361,6 +4364,11 @@ _scsih_expander_remove(struct MPT2SAS_ADAPTER *ioc, u64 sas_address)
 	spin_lock_irqsave(&ioc->sas_node_lock, flags);
 	sas_expander = mpt2sas_scsih_expander_find_by_sas_address(ioc,
 	    sas_address);
+	if (!sas_expander) {
+		spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
+		return;
+	}
+	list_del(&sas_expander->list);
 	spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
 	_scsih_expander_node_remove(ioc, sas_expander);
 }
@@ -4650,6 +4658,33 @@ _scsih_remove_device(struct MPT2SAS_ADAPTER *ioc,
 	    sas_device_backup.sas_address));
 }
 
+/**
+ * mpt2sas_device_remove - removing device object
+ * @ioc: per adapter object
+ * @sas_address: expander sas_address
+ *
+ * Return nothing.
+ */
+void
+mpt2sas_device_remove(struct MPT2SAS_ADAPTER *ioc, u64 sas_address)
+{
+	struct _sas_device *sas_device;
+	unsigned long flags;
+
+	if (ioc->shost_recovery)
+		return;
+
+	spin_lock_irqsave(&ioc->sas_device_lock, flags);
+	sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
+	    sas_address);
+	if (!sas_device) {
+		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+		return;
+	}
+	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+	_scsih_remove_device(ioc, sas_device);
+}
+
 #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
 /**
  * _scsih_sas_topology_change_event_debug - debug for topology event
@@ -4851,7 +4886,7 @@ _scsih_sas_topology_change_event(struct MPT2SAS_ADAPTER *ioc,
 	/* handle expander removal */
 	if (event_data->ExpStatus == MPI2_EVENT_SAS_TOPO_ES_NOT_RESPONDING &&
 	    sas_expander)
-		_scsih_expander_remove(ioc, sas_address);
+		mpt2sas_expander_remove(ioc, sas_address);
 
 }
 
@@ -6226,7 +6261,7 @@ _scsih_remove_unresponding_sas_devices(struct MPT2SAS_ADAPTER *ioc)
 			sas_expander->responding = 0;
 			continue;
 		}
-		_scsih_expander_remove(ioc, sas_expander->sas_address);
+		mpt2sas_expander_remove(ioc, sas_expander->sas_address);
 		goto retry_expander_search;
 	}
 }
@@ -6497,56 +6532,23 @@ static void
 _scsih_expander_node_remove(struct MPT2SAS_ADAPTER *ioc,
     struct _sas_node *sas_expander)
 {
-	struct _sas_port *mpt2sas_port;
-	struct _sas_device *sas_device;
-	struct _sas_node *expander_sibling;
-	unsigned long flags;
-
-	if (!sas_expander)
-		return;
+	struct _sas_port *mpt2sas_port, *next;
 
 	/* remove sibling ports attached to this expander */
- retry_device_search:
-	list_for_each_entry(mpt2sas_port,
-	   &sas_expander->sas_port_list, port_list) {
-		if (mpt2sas_port->remote_identify.device_type ==
-		    SAS_END_DEVICE) {
-			spin_lock_irqsave(&ioc->sas_device_lock, flags);
-			sas_device =
-			    mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
-			   mpt2sas_port->remote_identify.sas_address);
-			spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
-			if (!sas_device)
-				continue;
-			_scsih_remove_device(ioc, sas_device);
-			if (ioc->shost_recovery)
-				return;
-			goto retry_device_search;
-		}
-	}
-
- retry_expander_search:
-	list_for_each_entry(mpt2sas_port,
+	list_for_each_entry_safe(mpt2sas_port, next,
 	   &sas_expander->sas_port_list, port_list) {
-
+		if (ioc->shost_recovery)
+			return;
 		if (mpt2sas_port->remote_identify.device_type ==
-		    MPI2_SAS_DEVICE_INFO_EDGE_EXPANDER ||
+		    SAS_END_DEVICE)
+			mpt2sas_device_remove(ioc,
+			    mpt2sas_port->remote_identify.sas_address);
+		else if (mpt2sas_port->remote_identify.device_type ==
+		    SAS_EDGE_EXPANDER_DEVICE ||
 		    mpt2sas_port->remote_identify.device_type ==
-		    MPI2_SAS_DEVICE_INFO_FANOUT_EXPANDER) {
-
-			spin_lock_irqsave(&ioc->sas_node_lock, flags);
-			expander_sibling =
-			    mpt2sas_scsih_expander_find_by_sas_address(
-			    ioc, mpt2sas_port->remote_identify.sas_address);
-			spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
-			if (!expander_sibling)
-				continue;
-			_scsih_expander_remove(ioc,
-			    expander_sibling->sas_address);
-			if (ioc->shost_recovery)
-				return;
-			goto retry_expander_search;
-		}
+		    SAS_FANOUT_EXPANDER_DEVICE)
+			mpt2sas_expander_remove(ioc,
+			    mpt2sas_port->remote_identify.sas_address);
 	}
 
 	mpt2sas_transport_port_remove(ioc, sas_expander->sas_address,
@@ -6557,7 +6559,6 @@ _scsih_expander_node_remove(struct MPT2SAS_ADAPTER *ioc,
 	    sas_expander->handle, (unsigned long long)
 	    sas_expander->sas_address);
 
-	list_del(&sas_expander->list);
 	kfree(sas_expander->phy);
 	kfree(sas_expander);
 }
@@ -6675,9 +6676,7 @@ _scsih_remove(struct pci_dev *pdev)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct MPT2SAS_ADAPTER *ioc = shost_priv(shost);
-	struct _sas_port *mpt2sas_port;
-	struct _sas_device *sas_device;
-	struct _sas_node *expander_sibling;
+	struct _sas_port *mpt2sas_port, *next_port;
 	struct _raid_device *raid_device, *next;
 	struct MPT2SAS_TARGET *sas_target_priv_data;
 	struct workqueue_struct	*wq;
@@ -6709,28 +6708,18 @@ _scsih_remove(struct pci_dev *pdev)
 	}
 
 	/* free ports attached to the sas_host */
- retry_again:
-	list_for_each_entry(mpt2sas_port,
+	list_for_each_entry_safe(mpt2sas_port, next_port,
 	   &ioc->sas_hba.sas_port_list, port_list) {
 		if (mpt2sas_port->remote_identify.device_type ==
-		    SAS_END_DEVICE) {
-			sas_device =
-			    mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
-			   mpt2sas_port->remote_identify.sas_address);
-			if (sas_device) {
-				_scsih_remove_device(ioc, sas_device);
-				goto retry_again;
-			}
-		} else {
-			expander_sibling =
-			    mpt2sas_scsih_expander_find_by_sas_address(ioc,
+		    SAS_END_DEVICE)
+			mpt2sas_device_remove(ioc,
+			    mpt2sas_port->remote_identify.sas_address);
+		else if (mpt2sas_port->remote_identify.device_type ==
+		    SAS_EDGE_EXPANDER_DEVICE ||
+		    mpt2sas_port->remote_identify.device_type ==
+		    SAS_FANOUT_EXPANDER_DEVICE)
+			mpt2sas_expander_remove(ioc,
 			    mpt2sas_port->remote_identify.sas_address);
-			if (expander_sibling) {
-				_scsih_expander_remove(ioc,
-				    expander_sibling->sas_address);
-				goto retry_again;
-			}
-		}
 	}
 
 	/* free phys attached to the sas_host */
diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index b55c6dc..cb1cdec 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -465,62 +465,149 @@ _transport_expander_report_manufacture(struct MPT2SAS_ADAPTER *ioc,
 	return rc;
 }
 
+/**
+ * _transport_delete_port - helper function to removing a port
+ * @ioc: per adapter object
+ * @mpt2sas_port: mpt2sas per port object
+ *
+ * Returns nothing.
+ */
+static void
+_transport_delete_port(struct MPT2SAS_ADAPTER *ioc,
+	struct _sas_port *mpt2sas_port)
+{
+	u64 sas_address = mpt2sas_port->remote_identify.sas_address;
+	enum sas_device_type device_type =
+	    mpt2sas_port->remote_identify.device_type;
+
+	dev_printk(KERN_INFO, &mpt2sas_port->port->dev,
+	    "remove: sas_addr(0x%016llx)\n",
+	    (unsigned long long) sas_address);
+
+	ioc->logging_level |= MPT_DEBUG_TRANSPORT;
+	if (device_type == SAS_END_DEVICE)
+		mpt2sas_device_remove(ioc, sas_address);
+	else if (device_type == SAS_EDGE_EXPANDER_DEVICE ||
+	    device_type == SAS_FANOUT_EXPANDER_DEVICE)
+		mpt2sas_expander_remove(ioc, sas_address);
+	ioc->logging_level &= ~MPT_DEBUG_TRANSPORT;
+}
 
 /**
- * _transport_delete_duplicate_port - (see below description)
+ * _transport_delete_phy - helper function to removing single phy from port
  * @ioc: per adapter object
- * @sas_node: sas node object (either expander or sas host)
- * @sas_address: sas address of device being added
- * @phy_num: phy number
+ * @mpt2sas_port: mpt2sas per port object
+ * @mpt2sas_phy: mpt2sas per phy object
  *
- * This function is called when attempting to add a new port that is claiming
- * the same phy resources already in use by another port.  If we don't release
- * the claimed phy resources, the sas transport layer will hang from the BUG
- * in sas_port_add_phy.
+ * Returns nothing.
+ */
+static void
+_transport_delete_phy(struct MPT2SAS_ADAPTER *ioc,
+	struct _sas_port *mpt2sas_port, struct _sas_phy *mpt2sas_phy)
+{
+	u64 sas_address = mpt2sas_port->remote_identify.sas_address;
+
+	dev_printk(KERN_INFO, &mpt2sas_phy->phy->dev,
+	    "remove: sas_addr(0x%016llx), phy(%d)\n",
+	    (unsigned long long) sas_address, mpt2sas_phy->phy_id);
+
+	list_del(&mpt2sas_phy->port_siblings);
+	mpt2sas_port->num_phys--;
+	sas_port_delete_phy(mpt2sas_port->port, mpt2sas_phy->phy);
+	mpt2sas_phy->phy_belongs_to_port = 0;
+}
+
+/**
+ * _transport_add_phy - helper function to adding single phy to port
+ * @ioc: per adapter object
+ * @mpt2sas_port: mpt2sas per port object
+ * @mpt2sas_phy: mpt2sas per phy object
  *
- * The reason we would hit this issue is becuase someone is changing the
- * sas address of a device on the fly, meanwhile controller firmware sends
- * EVENTs out of order when removing the previous instance of the device.
+ * Returns nothing.
  */
 static void
-_transport_delete_duplicate_port(struct MPT2SAS_ADAPTER *ioc,
-    struct _sas_node *sas_node, u64 sas_address, int phy_num)
+_transport_add_phy(struct MPT2SAS_ADAPTER *ioc, struct _sas_port *mpt2sas_port,
+	struct _sas_phy *mpt2sas_phy)
 {
-	struct _sas_port *mpt2sas_port, *mpt2sas_port_duplicate;
-	struct _sas_phy *mpt2sas_phy;
+	u64 sas_address = mpt2sas_port->remote_identify.sas_address;
 
-	printk(MPT2SAS_ERR_FMT "new device located at sas_addr(0x%016llx), "
-	    "phy_id(%d)\n", ioc->name, (unsigned long long)sas_address,
-	    phy_num);
+	dev_printk(KERN_INFO, &mpt2sas_phy->phy->dev,
+	    "add: sas_addr(0x%016llx), phy(%d)\n", (unsigned long long)
+	    sas_address, mpt2sas_phy->phy_id);
 
-	mpt2sas_port_duplicate = NULL;
-	list_for_each_entry(mpt2sas_port, &sas_node->sas_port_list, port_list) {
-		dev_printk(KERN_ERR, &mpt2sas_port->port->dev,
-		    "existing device at sas_addr(0x%016llx), num_phys(%d)\n",
-		    (unsigned long long)
-		    mpt2sas_port->remote_identify.sas_address,
-		    mpt2sas_port->num_phys);
-		list_for_each_entry(mpt2sas_phy, &mpt2sas_port->phy_list,
+	list_add_tail(&mpt2sas_phy->port_siblings, &mpt2sas_port->phy_list);
+	mpt2sas_port->num_phys++;
+	sas_port_add_phy(mpt2sas_port->port, mpt2sas_phy->phy);
+	mpt2sas_phy->phy_belongs_to_port = 1;
+}
+
+/**
+ * _transport_add_phy_to_an_existing_port - adding new phy to existing port
+ * @ioc: per adapter object
+ * @sas_node: sas node object (either expander or sas host)
+ * @mpt2sas_phy: mpt2sas per phy object
+ * @sas_address: sas address of device/expander were phy needs to be added to
+ *
+ * Returns nothing.
+ */
+static void
+_transport_add_phy_to_an_existing_port(struct MPT2SAS_ADAPTER *ioc,
+struct _sas_node *sas_node, struct _sas_phy *mpt2sas_phy, u64 sas_address)
+{
+	struct _sas_port *mpt2sas_port;
+	struct _sas_phy *phy_srch;
+
+	if (mpt2sas_phy->phy_belongs_to_port == 1)
+		return;
+
+	list_for_each_entry(mpt2sas_port, &sas_node->sas_port_list,
+	    port_list) {
+		if (mpt2sas_port->remote_identify.sas_address !=
+		    sas_address)
+			continue;
+		list_for_each_entry(phy_srch, &mpt2sas_port->phy_list,
 		    port_siblings) {
-			dev_printk(KERN_ERR, &mpt2sas_phy->phy->dev,
-			    "phy_number(%d)\n", mpt2sas_phy->phy_id);
-			if (mpt2sas_phy->phy_id == phy_num)
-				mpt2sas_port_duplicate = mpt2sas_port;
+			if (phy_srch == mpt2sas_phy)
+				return;
 		}
+		_transport_add_phy(ioc, mpt2sas_port, mpt2sas_phy);
+			return;
 	}
 
-	if (!mpt2sas_port_duplicate)
+}
+
+/**
+ * _transport_del_phy_from_an_existing_port - delete phy from existing port
+ * @ioc: per adapter object
+ * @sas_node: sas node object (either expander or sas host)
+ * @mpt2sas_phy: mpt2sas per phy object
+ *
+ * Returns nothing.
+ */
+static void
+_transport_del_phy_from_an_existing_port(struct MPT2SAS_ADAPTER *ioc,
+	struct _sas_node *sas_node, struct _sas_phy *mpt2sas_phy)
+{
+	struct _sas_port *mpt2sas_port, *next;
+	struct _sas_phy *phy_srch;
+
+	if (mpt2sas_phy->phy_belongs_to_port == 0)
 		return;
 
-	dev_printk(KERN_ERR, &mpt2sas_port_duplicate->port->dev,
-	    "deleting duplicate device at sas_addr(0x%016llx), phy(%d)!!!!\n",
-	    (unsigned long long)
-	    mpt2sas_port_duplicate->remote_identify.sas_address, phy_num);
-	ioc->logging_level |= MPT_DEBUG_TRANSPORT;
-	mpt2sas_transport_port_remove(ioc,
-	    mpt2sas_port_duplicate->remote_identify.sas_address,
-	    sas_node->sas_address);
-	ioc->logging_level &= ~MPT_DEBUG_TRANSPORT;
+	list_for_each_entry_safe(mpt2sas_port, next, &sas_node->sas_port_list,
+	    port_list) {
+		list_for_each_entry(phy_srch, &mpt2sas_port->phy_list,
+		    port_siblings) {
+			if (phy_srch != mpt2sas_phy)
+				continue;
+			if (mpt2sas_port->num_phys == 1)
+				_transport_delete_port(ioc, mpt2sas_port);
+			else
+				_transport_delete_phy(ioc, mpt2sas_port,
+				    mpt2sas_phy);
+			return;
+		}
+	}
 }
 
 /**
@@ -537,11 +624,13 @@ _transport_sanity_check(struct MPT2SAS_ADAPTER *ioc, struct _sas_node *sas_node,
 {
 	int i;
 
-	for (i = 0; i < sas_node->num_phys; i++)
-		if (sas_node->phy[i].remote_identify.sas_address == sas_address)
-			if (sas_node->phy[i].phy_belongs_to_port)
-				_transport_delete_duplicate_port(ioc, sas_node,
-					sas_address, i);
+	for (i = 0; i < sas_node->num_phys; i++) {
+		if (sas_node->phy[i].remote_identify.sas_address != sas_address)
+			continue;
+		if (sas_node->phy[i].phy_belongs_to_port == 1)
+			_transport_del_phy_from_an_existing_port(ioc, sas_node,
+			    &sas_node->phy[i]);
+	}
 }
 
 /**
@@ -905,10 +994,12 @@ mpt2sas_transport_update_links(struct MPT2SAS_ADAPTER *ioc,
 
 	mpt2sas_phy = &sas_node->phy[phy_number];
 	mpt2sas_phy->attached_handle = handle;
-	if (handle && (link_rate >= MPI2_SAS_NEG_LINK_RATE_1_5))
+	if (handle && (link_rate >= MPI2_SAS_NEG_LINK_RATE_1_5)) {
 		_transport_set_identify(ioc, handle,
 		    &mpt2sas_phy->remote_identify);
-	else
+		_transport_add_phy_to_an_existing_port(ioc, sas_node,
+		    mpt2sas_phy, mpt2sas_phy->remote_identify.sas_address);
+	} else
 		memset(&mpt2sas_phy->remote_identify, 0 , sizeof(struct
 		    sas_identify));
 
