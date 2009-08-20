From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 3/7] mpt2sas: [Resend] Removed wrapper funtions _scsih_link_change.
Date: Thu, 20 Aug 2009 13:22:39 +0530
Message-ID: <20090820075233.GD17192@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og104.obsmtp.com ([64.18.2.161]:56767 "EHLO
	exprod7og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbZHTIOX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Aug 2009 04:14:23 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Deleted the wrapper function called _scsih_link_change. This function was
implemented for compatibility reasons only, between different kernel versions.
Currently this function is no longer needed.  The calling function are
converted to calling mpt2sas_transport_update_phy_link_change directly in the
transport layer.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Reviewed-by: Eric Moore <Eric.moore@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 1582758..39dc696 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -798,7 +798,7 @@ int mpt2sas_transport_add_host_phy(struct MPT2SAS_ADAPTER *ioc, struct _sas_phy
     *mpt2sas_phy, Mpi2SasPhyPage0_t phy_pg0, struct device *parent_dev);
 int mpt2sas_transport_add_expander_phy(struct MPT2SAS_ADAPTER *ioc, struct _sas_phy
     *mpt2sas_phy, Mpi2ExpanderPage1_t expander_pg1, struct device *parent_dev);
-void mpt2sas_transport_update_phy_link_change(struct MPT2SAS_ADAPTER *ioc, u16 handle,
+void mpt2sas_transport_update_links(struct MPT2SAS_ADAPTER *ioc, u16 handle,
    u16 attached_handle, u8 phy_number, u8 link_rate);
 extern struct sas_function_template mpt2sas_transport_functions;
 extern struct scsi_transport_template *mpt2sas_transport_template;
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 195f5e5..c0d5d5e 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -3124,25 +3124,6 @@ _scsih_io_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID, u32 reply)
 }
 
 /**
- * _scsih_link_change - process phy link changes
- * @ioc: per adapter object
- * @handle: phy handle
- * @attached_handle: valid for devices attached to link
- * @phy_number: phy number
- * @link_rate: new link rate
- * Context: user.
- *
- * Return nothing.
- */
-static void
-_scsih_link_change(struct MPT2SAS_ADAPTER *ioc, u16 handle, u16 attached_handle,
-   u8 phy_number, u8 link_rate)
-{
-	mpt2sas_transport_update_phy_link_change(ioc, handle, attached_handle,
-	    phy_number, link_rate);
-}
-
-/**
  * _scsih_sas_host_refresh - refreshing sas host object contents
  * @ioc: per adapter object
  * @update: update link information
@@ -3186,7 +3167,8 @@ _scsih_sas_host_refresh(struct MPT2SAS_ADAPTER *ioc, u8 update)
 			    le16_to_cpu(sas_iounit_pg0->PhyData[i].
 				ControllerDevHandle);
 			if (update)
-				_scsih_link_change(ioc,
+				mpt2sas_transport_update_links(
+				    ioc,
 				    ioc->sas_hba.phy[i].handle,
 				    le16_to_cpu(sas_iounit_pg0->PhyData[i].
 				    AttachedDevHandle), i,
@@ -3868,9 +3850,10 @@ _scsih_sas_topology_change_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
 		case MPI2_EVENT_SAS_TOPO_RC_TARG_ADDED:
 			if (!parent_handle) {
 				if (phy_number < ioc->sas_hba.num_phys)
-					_scsih_link_change(ioc,
-					   ioc->sas_hba.phy[phy_number].handle,
-					   handle, phy_number, link_rate_);
+					mpt2sas_transport_update_links(
+					ioc,
+					ioc->sas_hba.phy[phy_number].handle,
+					handle, phy_number, link_rate_);
 			} else {
 				spin_lock_irqsave(&ioc->sas_node_lock, flags);
 				sas_expander =
@@ -3880,11 +3863,12 @@ _scsih_sas_topology_change_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
 				    flags);
 				if (sas_expander) {
 					if (phy_number < sas_expander->num_phys)
-						_scsih_link_change(ioc,
-						   sas_expander->
-						   phy[phy_number].handle,
-						   handle, phy_number,
-						   link_rate_);
+						mpt2sas_transport_update_links(
+						ioc,
+						sas_expander->
+						phy[phy_number].handle,
+						handle, phy_number,
+						link_rate_);
 				}
 			}
 			if (reason_code == MPI2_EVENT_SAS_TOPO_RC_PHY_CHANGED) {
@@ -4400,7 +4384,7 @@ _scsih_sas_pd_add(struct MPT2SAS_ADAPTER *ioc,
 		return;
 	}
 
-	_scsih_link_change(ioc,
+	mpt2sas_transport_update_links(ioc,
 	    le16_to_cpu(sas_device_pg0.ParentDevHandle),
 	    handle, sas_device_pg0.PhyNum, MPI2_SAS_NEG_LINK_RATE_1_5);
 
@@ -4689,7 +4673,7 @@ _scsih_sas_ir_physical_disk_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
 			return;
 		}
 
-		_scsih_link_change(ioc,
+		mpt2sas_transport_update_links(ioc,
 		    le16_to_cpu(sas_device_pg0.ParentDevHandle),
 		    handle, sas_device_pg0.PhyNum, MPI2_SAS_NEG_LINK_RATE_1_5);
 
diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index a53086d..742324a 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -792,7 +792,7 @@ mpt2sas_transport_add_expander_phy(struct MPT2SAS_ADAPTER *ioc, struct _sas_phy
 }
 
 /**
- * mpt2sas_transport_update_phy_link_change - refreshing phy link changes and attached devices
+ * mpt2sas_transport_update_links - refreshing phy link changes
  * @ioc: per adapter object
  * @handle: handle to sas_host or expander
  * @attached_handle: attached device handle
@@ -802,7 +802,7 @@ mpt2sas_transport_add_expander_phy(struct MPT2SAS_ADAPTER *ioc, struct _sas_phy
  * Returns nothing.
  */
 void
-mpt2sas_transport_update_phy_link_change(struct MPT2SAS_ADAPTER *ioc,
+mpt2sas_transport_update_links(struct MPT2SAS_ADAPTER *ioc,
     u16 handle, u16 attached_handle, u8 phy_number, u8 link_rate)
 {
 	unsigned long flags;
