From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 01/05] mpt2sas: sanity added to remove duplicate port from topology
Date: Mon, 5 Apr 2010 14:18:34 +0530
Message-ID: <20100405084824.GB28900@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:45940 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751145Ab0DEJU0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Apr 2010 05:20:26 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


There are few special cases which needs to be handled deleting old port.

CASE1: In topology you need cascaded expanders. Through sysfs just make sure 
topology is up. Erase the manufacturing image of the cascaded expander and
reset the board. In some cases Adapter will receive Exapnder Add event
before expander delete. In such a case, driver needs to delete duplicate
port before adding new port.

CASE2: Enable Device Missing delay of HBA through lsiutils. If expander or
end device is hotswapped with different device before DMD timer expires,
driver will get device add for new device first and then device deletion
event for the original devices will arrive later at DMD timer expires. In
this case also driver need to delete duplicate port before adding port for
new device.

Added new function which will make sure when new port is
added, that its not claiming the same phy resources already in use by
another port. If it does, then it will delete the other port before adding
the new port.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 2616bb1..454a74a 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -366,6 +366,7 @@ struct _sas_port {
  * @phy_id: unique phy id
  * @handle: device handle for this phy
  * @attached_handle: device handle for attached device
+ * @phy_belongs_to_port: port has been created for this phy
  */
 struct _sas_phy {
 	struct list_head port_siblings;
@@ -375,6 +376,7 @@ struct _sas_phy {
 	u8	phy_id;
 	u16	handle;
 	u16	attached_handle;
+	u8	phy_belongs_to_port;
 };
 
 /**
diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index 7f69d73..faa84c9 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -464,6 +464,85 @@ _transport_expander_report_manufacture(struct MPT2SAS_ADAPTER *ioc,
 	return rc;
 }
 
+
+/**
+ * _transport_delete_duplicate_port - (see below description)
+ * @ioc: per adapter object
+ * @sas_node: sas node object (either expander or sas host)
+ * @sas_address: sas address of device being added
+ * @phy_num: phy number
+ *
+ * This function is called when attempting to add a new port that is claiming
+ * the same phy resources already in use by another port.  If we don't release
+ * the claimed phy resources, the sas transport layer will hang from the BUG
+ * in sas_port_add_phy.
+ *
+ * The reason we would hit this issue is becuase someone is changing the
+ * sas address of a device on the fly, meanwhile controller firmware sends
+ * EVENTs out of order when removing the previous instance of the device.
+ */
+static void
+_transport_delete_duplicate_port(struct MPT2SAS_ADAPTER *ioc,
+    struct _sas_node *sas_node, u64 sas_address, int phy_num)
+{
+	struct _sas_port *mpt2sas_port, *mpt2sas_port_duplicate;
+	struct _sas_phy *mpt2sas_phy;
+
+	printk(MPT2SAS_ERR_FMT "new device located at sas_addr(0x%016llx), "
+	    "phy_id(%d)\n", ioc->name, (unsigned long long)sas_address,
+	    phy_num);
+
+	mpt2sas_port_duplicate = NULL;
+	list_for_each_entry(mpt2sas_port, &sas_node->sas_port_list, port_list) {
+		dev_printk(KERN_ERR, &mpt2sas_port->port->dev,
+		    "existing device at sas_addr(0x%016llx), num_phys(%d)\n",
+		    (unsigned long long)
+		    mpt2sas_port->remote_identify.sas_address,
+		    mpt2sas_port->num_phys);
+		list_for_each_entry(mpt2sas_phy, &mpt2sas_port->phy_list,
+		    port_siblings) {
+			dev_printk(KERN_ERR, &mpt2sas_phy->phy->dev,
+			    "phy_number(%d)\n", mpt2sas_phy->phy_id);
+			if (mpt2sas_phy->phy_id == phy_num)
+				mpt2sas_port_duplicate = mpt2sas_port;
+		}
+	}
+
+	if (!mpt2sas_port_duplicate)
+		return;
+
+	dev_printk(KERN_ERR, &mpt2sas_port_duplicate->port->dev,
+	    "deleting duplicate device at sas_addr(0x%016llx), phy(%d)!!!!\n",
+	    (unsigned long long)
+	    mpt2sas_port_duplicate->remote_identify.sas_address, phy_num);
+	ioc->logging_level |= MPT_DEBUG_TRANSPORT;
+	mpt2sas_transport_port_remove(ioc,
+	    mpt2sas_port_duplicate->remote_identify.sas_address,
+	    sas_node->sas_address);
+	ioc->logging_level &= ~MPT_DEBUG_TRANSPORT;
+}
+
+/**
+ * _transport_sanity_check - sanity check when adding a new port
+ * @ioc: per adapter object
+ * @sas_node: sas node object (either expander or sas host)
+ * @sas_address: sas address of device being added
+ *
+ * See the explanation above from _transport_delete_duplicate_port
+ */
+static void
+_transport_sanity_check(struct MPT2SAS_ADAPTER *ioc, struct _sas_node *sas_node,
+     u64 sas_address)
+{
+	int i;
+
+	for (i = 0; i < sas_node->num_phys; i++)
+		if (sas_node->phy[i].remote_identify.sas_address == sas_address)
+			if (sas_node->phy[i].phy_belongs_to_port)
+				_transport_delete_duplicate_port(ioc, sas_node,
+					sas_address, i);
+}
+
 /**
  * mpt2sas_transport_port_add - insert port to the list
  * @ioc: per adapter object
@@ -521,6 +600,9 @@ mpt2sas_transport_port_add(struct MPT2SAS_ADAPTER *ioc, u16 handle,
 		goto out_fail;
 	}
 
+	_transport_sanity_check(ioc, sas_node,
+	    mpt2sas_port->remote_identify.sas_address);
+
 	for (i = 0; i < sas_node->num_phys; i++) {
 		if (sas_node->phy[i].remote_identify.sas_address !=
 		    mpt2sas_port->remote_identify.sas_address)
@@ -552,6 +634,7 @@ mpt2sas_transport_port_add(struct MPT2SAS_ADAPTER *ioc, u16 handle,
 			    mpt2sas_port->remote_identify.sas_address,
 			    mpt2sas_phy->phy_id);
 		sas_port_add_phy(port, mpt2sas_phy->phy);
+		mpt2sas_phy->phy_belongs_to_port = 1;
 	}
 
 	mpt2sas_port->port = port;
@@ -650,6 +733,7 @@ mpt2sas_transport_port_remove(struct MPT2SAS_ADAPTER *ioc, u64 sas_address,
 			    (unsigned long long)
 			    mpt2sas_port->remote_identify.sas_address,
 			    mpt2sas_phy->phy_id);
+		mpt2sas_phy->phy_belongs_to_port = 0;
 		sas_port_delete_phy(mpt2sas_port->port, mpt2sas_phy->phy);
 		list_del(&mpt2sas_phy->port_siblings);
 	}
