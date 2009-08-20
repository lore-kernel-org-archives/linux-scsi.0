From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 4/7] mpt2sas: [Resend] setting SDEV into RUNNING state from Interrupt context
Date: Thu, 20 Aug 2009 13:23:19 +0530
Message-ID: <20090820075312.GE17192@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og106.obsmtp.com ([64.18.2.165]:37709 "EHLO
	exprod7og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbZHTIPA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Aug 2009 04:15:00 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Changing SDEV Running state from interrupt context. Previously It was
handle in work queue thread. With this change It will not wait for work
queue thread to execute scsih_ublock_io_device to put SDEV into Running
state. This will reduce delay for Device becoming RUNNING.

Modified this patch considering James comment "Not to change SDEV state 
using  scsi_device_set_state API, instead use scsi_internal_device_unblock
scsi_internal_device_block API"

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Reviewed-by: Eric Moore <Eric.moore@lsi.com>
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 39dc696..1f3efd6 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -802,5 +802,7 @@ void mpt2sas_transport_update_links(struct MPT2SAS_ADAPTER *ioc, u16 handle,
    u16 attached_handle, u8 phy_number, u8 link_rate);
 extern struct sas_function_template mpt2sas_transport_functions;
 extern struct scsi_transport_template *mpt2sas_transport_template;
+extern int scsi_internal_device_block(struct scsi_device *sdev);
+extern int scsi_internal_device_unblock(struct scsi_device *sdev);
 
 #endif /* MPT2SAS_BASE_H_INCLUDED */
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index c0d5d5e..6e6d5af 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2222,7 +2222,7 @@ _scsih_ublock_io_device(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 			    MPT2SAS_INFO_FMT "SDEV_RUNNING: "
 			    "handle(0x%04x)\n", ioc->name, handle));
 			sas_device_priv_data->block = 0;
-			scsi_device_set_state(sdev, SDEV_RUNNING);
+			scsi_internal_device_unblock(sdev);
 		}
 	}
 }
@@ -2251,7 +2251,7 @@ _scsih_block_io_device(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 			    MPT2SAS_INFO_FMT "SDEV_BLOCK: "
 			    "handle(0x%04x)\n", ioc->name, handle));
 			sas_device_priv_data->block = 1;
-			scsi_device_set_state(sdev, SDEV_BLOCK);
+			scsi_internal_device_block(sdev);
 		}
 	}
 }
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
 
@@ -3690,6 +3696,9 @@ _scsih_remove_device(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 	    le32_to_cpu(mpi_reply.IOCLogInfo)));
 
  out:
+
+	_scsih_ublock_io_device(ioc, handle);
+
 	mpt2sas_transport_port_remove(ioc, sas_device->sas_address,
 	    sas_device->parent_handle);
 
@@ -3871,10 +3880,6 @@ _scsih_sas_topology_change_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
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
