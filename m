From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 09/11] mpt2sas: Sanity check for phy count is added using max phy count
Date: Sat, 13 Nov 2010 04:40:51 +0530
Message-ID: <20101112231043.GK853@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:42764 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933044Ab0KLXxO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Nov 2010 18:53:14 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Fix oops loading driver when there is direct attached
SEP device

The driver set max phys count to the value reported in sas iounit page
zero.  However this page doesn't take into account additional virutal
phys.  When sas topology event arrives, the phy count is larger than
expected, and the driver accesses memory array beyond the end of
allocated space, then oops.  Manufacturing page 8 contains the info
on direct attached phys.

For this fix will making sure that sas topology event is not
processing phys greater than the expected phy count.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 2b13438..900a367 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -4794,7 +4794,7 @@ _scsih_sas_topology_change_event(struct MPT2SAS_ADAPTER *ioc,
 	int i;
 	u16 parent_handle, handle;
 	u16 reason_code;
-	u8 phy_number;
+	u8 phy_number, max_phys;
 	struct _sas_node *sas_expander;
 	struct _sas_device *sas_device;
 	u64 sas_address;
@@ -4832,11 +4832,13 @@ _scsih_sas_topology_change_event(struct MPT2SAS_ADAPTER *ioc,
 	sas_expander = mpt2sas_scsih_expander_find_by_handle(ioc,
 	    parent_handle);
 	spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
-	if (sas_expander)
+	if (sas_expander) {
 		sas_address = sas_expander->sas_address;
-	else if (parent_handle < ioc->sas_hba.num_phys)
+		max_phys = sas_expander->num_phys;
+	} else if (parent_handle < ioc->sas_hba.num_phys) {
 		sas_address = ioc->sas_hba.sas_address;
-	else
+		max_phys = ioc->sas_hba.num_phys;
+	} else
 		return;
 
 	/* handle siblings events */
@@ -4850,6 +4852,8 @@ _scsih_sas_topology_change_event(struct MPT2SAS_ADAPTER *ioc,
 		    ioc->pci_error_recovery)
 			return;
 		phy_number = event_data->StartPhyNum + i;
+		if (phy_number >= max_phys)
+			continue;
 		reason_code = event_data->PHY[i].PhyStatus &
 		    MPI2_EVENT_SAS_TOPO_RC_MASK;
 		if ((event_data->PHY[i].PhyStatus &
