From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 19/20] mpt2sas: No link rate change, do not call update links nor unblock device
Date: Wed, 23 Sep 2009 17:36:52 +0530
Message-ID: <20090923120652.GX6772@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:42047 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751862AbZIWMaK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Sep 2009 08:30:10 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


(1) target resets are sending link change rate events with no link rate
change -> thus said the driver was modified so when there is no link rate
change, we don't need to call mpt2sas_transport_update_links nor
_scsih_ublock_io_device.
(2) There were changes made in _scsih_sas_topology_change_event_debug to
change the debug strings so they are more clear.  Also the link rate change
information was added to display the new and previous link rate.
for the MPI2_EVENT_SAS_TOPOLOGY_CHANGE_LIST event when the ExpStatus is
set to zero, display "responding" instead of "unknown status".

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Eric Moore <Eric.moore@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 4dd7d0c..2d08605 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2380,7 +2380,6 @@ _scsih_block_io_to_children_attached_directly(struct MPT2SAS_ADAPTER *ioc,
 	u16 handle;
 	u16 reason_code;
 	u8 phy_number;
-	u8 link_rate;
 
 	for (i = 0; i < event_data->NumEntries; i++) {
 		handle = le16_to_cpu(event_data->PHY[i].AttachedDevHandle);
@@ -2391,11 +2390,6 @@ _scsih_block_io_to_children_attached_directly(struct MPT2SAS_ADAPTER *ioc,
 		    MPI2_EVENT_SAS_TOPO_RC_MASK;
 		if (reason_code == MPI2_EVENT_SAS_TOPO_RC_DELAY_NOT_RESPONDING)
 			_scsih_block_io_device(ioc, handle);
-		if (reason_code == MPI2_EVENT_SAS_TOPO_RC_PHY_CHANGED) {
-			link_rate = event_data->PHY[i].LinkRate >> 4;
-			if (link_rate >= MPI2_SAS_NEG_LINK_RATE_1_5)
-				_scsih_ublock_io_device(ioc, handle);
-		}
 	}
 }
 
@@ -4084,7 +4078,7 @@ _scsih_sas_topology_change_event_debug(struct MPT2SAS_ADAPTER *ioc,
 	u16 reason_code;
 	u8 phy_number;
 	char *status_str = NULL;
-	char link_rate[25];
+	u8 link_rate, prev_link_rate;
 
 	switch (event_data->ExpStatus) {
 	case MPI2_EVENT_SAS_TOPO_ES_ADDED:
@@ -4094,6 +4088,7 @@ _scsih_sas_topology_change_event_debug(struct MPT2SAS_ADAPTER *ioc,
 		status_str = "remove";
 		break;
 	case MPI2_EVENT_SAS_TOPO_ES_RESPONDING:
+	case 0:
 		status_str =  "responding";
 		break;
 	case MPI2_EVENT_SAS_TOPO_ES_DELAY_NOT_RESPONDING:
@@ -4119,30 +4114,30 @@ _scsih_sas_topology_change_event_debug(struct MPT2SAS_ADAPTER *ioc,
 		    MPI2_EVENT_SAS_TOPO_RC_MASK;
 		switch (reason_code) {
 		case MPI2_EVENT_SAS_TOPO_RC_TARG_ADDED:
-			snprintf(link_rate, 25, ": add, link(0x%02x)",
-			    (event_data->PHY[i].LinkRate >> 4));
-			status_str = link_rate;
+			status_str = "target add";
 			break;
 		case MPI2_EVENT_SAS_TOPO_RC_TARG_NOT_RESPONDING:
-			status_str = ": remove";
+			status_str = "target remove";
 			break;
 		case MPI2_EVENT_SAS_TOPO_RC_DELAY_NOT_RESPONDING:
-			status_str = ": remove_delay";
+			status_str = "delay target remove";
 			break;
 		case MPI2_EVENT_SAS_TOPO_RC_PHY_CHANGED:
-			snprintf(link_rate, 25, ": link(0x%02x)",
-			    (event_data->PHY[i].LinkRate >> 4));
-			status_str = link_rate;
+			status_str = "link rate change";
 			break;
 		case MPI2_EVENT_SAS_TOPO_RC_NO_CHANGE:
-			status_str = ": responding";
+			status_str = "target responding";
 			break;
 		default:
-			status_str = ": unknown";
+			status_str = "unknown";
 			break;
 		}
-		printk(KERN_DEBUG "\tphy(%02d), attached_handle(0x%04x)%s\n",
-		    phy_number, handle, status_str);
+		link_rate = event_data->PHY[i].LinkRate >> 4;
+		prev_link_rate = event_data->PHY[i].LinkRate & 0xF;
+		printk(KERN_DEBUG "\tphy(%02d), attached_handle(0x%04x): %s:"
+		    " link rate: new(0x%02x), old(0x%02x)\n", phy_number,
+		    handle, status_str, link_rate, prev_link_rate);
+
 	}
 }
 #endif
@@ -4166,7 +4161,7 @@ _scsih_sas_topology_change_event(struct MPT2SAS_ADAPTER *ioc,
 	struct _sas_device *sas_device;
 	u64 sas_address;
 	unsigned long flags;
-	u8 link_rate;
+	u8 link_rate, prev_link_rate;
 	Mpi2EventDataSasTopologyChangeList_t *event_data = fw_event->event_data;
 
 #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
@@ -4226,18 +4221,25 @@ _scsih_sas_topology_change_event(struct MPT2SAS_ADAPTER *ioc,
 		if (!handle)
 			continue;
 		link_rate = event_data->PHY[i].LinkRate >> 4;
+		prev_link_rate = event_data->PHY[i].LinkRate & 0xF;
 		switch (reason_code) {
 		case MPI2_EVENT_SAS_TOPO_RC_PHY_CHANGED:
+
+			if (link_rate == prev_link_rate)
+				break;
+
+			mpt2sas_transport_update_links(ioc, sas_address,
+			    handle, phy_number, link_rate);
+
+			if (link_rate >= MPI2_SAS_NEG_LINK_RATE_1_5)
+				_scsih_ublock_io_device(ioc, handle);
+			break;
 		case MPI2_EVENT_SAS_TOPO_RC_TARG_ADDED:
 
 			mpt2sas_transport_update_links(ioc, sas_address,
 			    handle, phy_number, link_rate);
 
-			if (link_rate < MPI2_SAS_NEG_LINK_RATE_1_5)
-				break;
-			if (reason_code == MPI2_EVENT_SAS_TOPO_RC_TARG_ADDED) {
-				_scsih_add_device(ioc, handle, phy_number, 0);
-			}
+			_scsih_add_device(ioc, handle, phy_number, 0);
 			break;
 		case MPI2_EVENT_SAS_TOPO_RC_TARG_NOT_RESPONDING:
 
