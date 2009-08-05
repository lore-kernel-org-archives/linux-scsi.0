From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 4/11] mpt2sas: [Resend] Code cleanup for _scsih_link_change function
Date: Wed, 5 Aug 2009 11:42:08 +0530
Message-ID: <20090805061208.GE13733@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og116.obsmtp.com ([64.18.2.219]:46899 "EHLO
	exprod7og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362AbZHEGdI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2009 02:33:08 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Function name changed.
_scsih_link_change is now mpt2sas_transport_update_links.
Added check for shost->recovery before processing.

---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Eric Moore <Eric.moore@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 1e8792f..51962bd 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -796,7 +796,7 @@ int mpt2sas_transport_add_host_phy(struct MPT2SAS_ADAPTER *ioc, struct _sas_phy
     *mpt2sas_phy, Mpi2SasPhyPage0_t phy_pg0, struct device *parent_dev);
 int mpt2sas_transport_add_expander_phy(struct MPT2SAS_ADAPTER *ioc, struct _sas_phy
     *mpt2sas_phy, Mpi2ExpanderPage1_t expander_pg1, struct device *parent_dev);
-void mpt2sas_transport_update_phy_link_change(struct MPT2SAS_ADAPTER *ioc, u16 handle,
+void mpt2sas_transport_update_links(struct MPT2SAS_ADAPTER *ioc, u16 handle,
    u16 attached_handle, u8 phy_number, u8 link_rate);
 extern struct sas_function_template mpt2sas_transport_functions;
 extern struct scsi_transport_template *mpt2sas_transport_template;
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 245b7a6..19d44c0 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -3120,25 +3120,6 @@ _scsih_io_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID, u32 reply)
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
@@ -3182,7 +3163,8 @@ _scsih_sas_host_refresh(struct MPT2SAS_ADAPTER *ioc, u8 update)
 			    le16_to_cpu(sas_iounit_pg0->PhyData[i].
 				ControllerDevHandle);
 			if (update)
-				_scsih_link_change(ioc,
+				mpt2sas_transport_update_links(
+				    ioc,
 				    ioc->sas_hba.phy[i].handle,
 				    le16_to_cpu(sas_iounit_pg0->PhyData[i].
 				    AttachedDevHandle), i,
@@ -3852,9 +3834,10 @@ _scsih_sas_topology_change_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
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
@@ -3864,11 +3847,12 @@ _scsih_sas_topology_change_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
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
diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index 7507c17..5e562fc 100644
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
@@ -802,13 +802,19 @@ mpt2sas_transport_add_expander_phy(struct MPT2SAS_ADAPTER *ioc, struct _sas_phy
  * Returns nothing.
  */
 void
-mpt2sas_transport_update_phy_link_change(struct MPT2SAS_ADAPTER *ioc,
+mpt2sas_transport_update_links(struct MPT2SAS_ADAPTER *ioc,
     u16 handle, u16 attached_handle, u8 phy_number, u8 link_rate)
 {
 	unsigned long flags;
 	struct _sas_node *sas_node;
 	struct _sas_phy *mpt2sas_phy;
 
+	if (ioc->shost_recovery) {
+		printk(MPT2SAS_INFO_FMT "%s: host reset in progress!\n",
+		    __func__, ioc->name);
+		return;
+	}
+
 	spin_lock_irqsave(&ioc->sas_node_lock, flags);
 	sas_node = _transport_sas_node_find_by_handle(ioc, handle);
 	spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
