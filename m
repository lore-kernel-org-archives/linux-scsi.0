From: <nagalakshmi.nandigama@lsi.com>
Subject: [PATCH] mpt2sas: Fix for deadlock between hot plug worker threads and host reset context
Date: Wed, 19 Oct 2011 10:23:17 +0530
Message-ID: <201110191059.p9JAxEl3027367@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:53227 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755835Ab1JSK7V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Oct 2011 06:59:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, kashyap.desai@lsi.com, Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com
Cc: JBottomley@parallels.com

Fix for issue deadlock between hot plug worker threads and host reset context.

This is due to driver reporting a device missing to the OS then the OS sending 
a SYNC_CACHE request to driver while the IO queues are locked due to host reset.  

To fix the issue, the driver will be waking up the port enable context 
immediately when the driver receives the reply message, instead of waiting 
on the hot plug worker threads. 

Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index ca18a92..49a0530 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -3060,6 +3060,7 @@ _scsih_tm_tr_send(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 		"handle(0x%04x), sas_addr(0x%016llx)\n", ioc->name, handle,
 			(unsigned long long)sas_address));
 		_scsih_ublock_io_device(ioc, handle);
+		sas_target_priv_data->handle = MPT2SAS_INVALID_DEVICE_HANDLE;
 	}
 
 	smid = mpt2sas_base_get_smid_hpr(ioc, ioc->tm_tr_cb_idx);
@@ -5202,6 +5203,9 @@ _scsih_remove_device(struct MPT2SAS_ADAPTER *ioc,
 	if (sas_device_backup.starget && sas_device_backup.starget->hostdata) {
 		sas_target_priv_data = sas_device_backup.starget->hostdata;
 		sas_target_priv_data->deleted = 1;
+		_scsih_ublock_io_device(ioc, sas_device_backup.handle);
+		sas_target_priv_data->handle =
+		     MPT2SAS_INVALID_DEVICE_HANDLE;
 	}
 
 	_scsih_ublock_io_device(ioc, sas_device_backup.handle);
@@ -5355,7 +5359,7 @@ _scsih_sas_topology_change_event(struct MPT2SAS_ADAPTER *ioc,
 		_scsih_sas_topology_change_event_debug(ioc, event_data);
 #endif
 
-	if (ioc->shost_recovery || ioc->remove_host || ioc->pci_error_recovery)
+	if (ioc->remove_host || ioc->pci_error_recovery)
 		return;
 
 	if (!ioc->sas_hba.num_phys)
@@ -5416,6 +5420,9 @@ _scsih_sas_topology_change_event(struct MPT2SAS_ADAPTER *ioc,
 		switch (reason_code) {
 		case MPI2_EVENT_SAS_TOPO_RC_PHY_CHANGED:
 
+			if (ioc->shost_recovery)
+				break;
+
 			if (link_rate == prev_link_rate)
 				break;
 
@@ -5429,6 +5436,9 @@ _scsih_sas_topology_change_event(struct MPT2SAS_ADAPTER *ioc,
 			break;
 		case MPI2_EVENT_SAS_TOPO_RC_TARG_ADDED:
 
+			if (ioc->shost_recovery)
+				break;
+
 			mpt2sas_transport_update_links(ioc, sas_address,
 			    handle, phy_number, link_rate);
 
@@ -7092,7 +7102,13 @@ mpt2sas_scsih_reset_handler(struct MPT2SAS_ADAPTER *ioc, int reset_phase)
 		_scsih_search_responding_sas_devices(ioc);
 		_scsih_search_responding_raid_devices(ioc);
 		_scsih_search_responding_expanders(ioc);
+		if (!ioc->is_driver_loading) {
+			_scsih_prep_device_scan(ioc);
+			_scsih_search_responding_sas_devices(ioc);
+			_scsih_search_responding_raid_devices(ioc);
+			_scsih_search_responding_expanders(ioc);
 			_scsih_error_recovery_delete_devices(ioc);
+		}
 		break;
 	}
 }
@@ -7127,17 +7143,7 @@ _firmware_event_work(struct work_struct *work)
 		_scsih_scan_for_devices_after_reset(ioc);
 		break;
 	case MPT2SAS_PORT_ENABLE_COMPLETE:
-		if (!ioc->is_driver_loading && ioc->shost_recovery) {
-			_scsih_prep_device_scan(ioc);
-			_scsih_search_responding_sas_devices(ioc);
-			_scsih_search_responding_raid_devices(ioc);
-			_scsih_search_responding_expanders(ioc);
-		}
-
-		if (ioc->start_scan)
-			ioc->start_scan = 0;
-		else
-			complete(&ioc->port_enable_done);
+		ioc->start_scan = 0;
 
 
 
