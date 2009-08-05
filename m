From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 6/11] mpt2sas: [Resend] Added proper error handling for _scsih_expander_add.
Date: Wed, 5 Aug 2009 11:43:21 +0530
Message-ID: <20090805061321.GG13733@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og110.obsmtp.com ([64.18.2.173]:34086 "EHLO
	exprod7og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755468AbZHEGeU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2009 02:34:20 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


when there is a failure during _scsih_expander_add, need to call mpt2sas_transport_port_remove to properly tear down the port.

---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Eric Moore <Eric.moore@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 19d44c0..92a90b8 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2327,6 +2327,7 @@ _scsih_block_io_to_children_attached_directly(struct MPT2SAS_ADAPTER *ioc,
 	u16 handle;
 	u16 reason_code;
 	u8 phy_number;
+	u8 link_rate;
 
 	for (i = 0; i < event_data->NumEntries; i++) {
 		handle = le16_to_cpu(event_data->PHY[i].AttachedDevHandle);
@@ -2337,6 +2338,11 @@ _scsih_block_io_to_children_attached_directly(struct MPT2SAS_ADAPTER *ioc,
 		    MPI2_EVENT_SAS_TOPO_RC_MASK;
 		if (reason_code == MPI2_EVENT_SAS_TOPO_RC_DELAY_NOT_RESPONDING)
 			_scsih_block_io_device(ioc, handle);
+		if (reason_code == MPI2_EVENT_SAS_TOPO_RC_PHY_CHANGED) {
+			link_rate = event_data->PHY[i].LinkRate >> 4;
+			if (link_rate >= MPI2_SAS_NEG_LINK_RATE_1_5)
+				_scsih_ublock_io_device(ioc, handle);
+		}
 	}
 }
 
@@ -3343,12 +3349,15 @@ _scsih_expander_add(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 	__le64 sas_address;
 	int i;
 	unsigned long flags;
-	struct _sas_port *mpt2sas_port;
+	struct _sas_port *mpt2sas_port = NULL;
 	int rc = 0;
 
 	if (!handle)
 		return -1;
 
+	if (ioc->shost_recovery)
+		return -1;
+
 	if ((mpt2sas_config_get_expander_pg0(ioc, &mpi_reply, &expander_pg0,
 	    MPI2_SAS_EXPAND_PGAD_FORM_HNDL, handle))) {
 		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
@@ -3435,12 +3444,20 @@ _scsih_expander_add(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 		    &expander_pg1, i, handle))) {
 			printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
 			    ioc->name, __FILE__, __LINE__, __func__);
-			continue;
+			rc = -1;
+			goto out_fail;
 		}
 		sas_expander->phy[i].handle = handle;
 		sas_expander->phy[i].phy_id = i;
-		mpt2sas_transport_add_expander_phy(ioc, &sas_expander->phy[i],
-		    expander_pg1, sas_expander->parent_dev);
+
+		if ((mpt2sas_transport_add_expander_phy(ioc,
+		    &sas_expander->phy[i], expander_pg1,
+		    sas_expander->parent_dev))) {
+			printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
+			    ioc->name, __FILE__, __LINE__, __func__);
+			rc = -1;
+			goto out_fail;
+		}
 	}
 
 	if (sas_expander->enclosure_handle) {
@@ -3457,8 +3474,9 @@ _scsih_expander_add(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 
  out_fail:
 
-	if (sas_expander)
-		kfree(sas_expander->phy);
+	if (mpt2sas_port)
+		mpt2sas_transport_port_remove(ioc, sas_expander->sas_address,
+		    sas_expander->parent_handle);
 	kfree(sas_expander);
 	return rc;
 }
@@ -3855,10 +3873,6 @@ _scsih_sas_topology_change_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
 						link_rate_);
 				}
 			}
-			if (reason_code == MPI2_EVENT_SAS_TOPO_RC_PHY_CHANGED) {
-				if (link_rate_ >= MPI2_SAS_NEG_LINK_RATE_1_5)
-					_scsih_ublock_io_device(ioc, handle);
-			}
 			if (reason_code == MPI2_EVENT_SAS_TOPO_RC_TARG_ADDED) {
 				if (link_rate_ < MPI2_SAS_NEG_LINK_RATE_1_5)
 					break;
