From: <nagalakshmi.nandigama@lsi.com>
Subject: [PATCH 10/12] [SCSI] mpt2sas : Fix for hard drive going OFFLINE
 when hard reset issued and simultaneously another hard drive is hot
 unplugged
Date: Tue, 20 Mar 2012 12:09:26 +0530
Message-ID: <201203200638.q2K6ct1m000546@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:34020 "EHLO
	psmtp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754645Ab2CTGi7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Mar 2012 02:38:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stable@vger.kernel.org, linux-scsi@vger.kernel.org, Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com
Cc: jejb@kernel.org

A hard drive is going OFFLINE when there is a hard reset issued
and simultaneously another hard drive is hot unplugged.
    
Following the host reset, the firmware discovery is reassigning another
hard drive in the topology to the same device handle as that device is
getting hot removed. Until the driver device removal routine is called,
there will be two hard drive with the matching device handle in the
internal device link list. In the device removal routine, a separate 
function which moves the device from BLOCKED into OFFLINE state.
Since this routine is passed  with the device handle passed as input parameter,
the routine will be traversing the internal device link list searching for
matching device handle. This results in two devices with matching
device handle, therefore both devices goes OFFLINE. 

To fix this issue,the input parameter is changed from device handle to 
SAS address, therefore only the device that is hot unplugged will be placed 
in OFFLINE state.


Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
Cc: stable@vger.kernel.org
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 6454c33..9fd5c10 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2921,7 +2921,7 @@ _scsih_ublock_io_all_device(struct MPT2SAS_ADAPTER *ioc)
  * During device pull we need to appropiately set the sdev state.
  */
 static void
-_scsih_ublock_io_device(struct MPT2SAS_ADAPTER *ioc, u16 handle)
+_scsih_ublock_io_device(struct MPT2SAS_ADAPTER *ioc, u64 sas_address)
 {
 	struct MPT2SAS_DEVICE *sas_device_priv_data;
 	struct scsi_device *sdev;
@@ -2932,10 +2932,12 @@ _scsih_ublock_io_device(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 			continue;
 		if (!sas_device_priv_data->block)
 			continue;
-		if (sas_device_priv_data->sas_target->handle == handle) {
+		if (sas_device_priv_data->sas_target->sas_address ==
+								sas_address) {
 			dewtprintk(ioc, sdev_printk(KERN_INFO, sdev,
 			    MPT2SAS_INFO_FMT "SDEV_RUNNING: "
-			    "handle(0x%04x)\n", ioc->name, handle));
+			    "sas address(0x%016llx)\n", ioc->name,
+				(unsigned long long)sas_address));
 			sas_device_priv_data->block = 0;
 			scsi_internal_device_unblock(sdev);
 		}
@@ -3144,7 +3146,7 @@ _scsih_tm_tr_send(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 		dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "setting delete flag: "
 		"handle(0x%04x), sas_addr(0x%016llx)\n", ioc->name, handle,
 			(unsigned long long)sas_address));
-		_scsih_ublock_io_device(ioc, handle);
+		_scsih_ublock_io_device(ioc, sas_address);
 		sas_target_priv_data->handle = MPT2SAS_INVALID_DEVICE_HANDLE;
 	}
 
@@ -5203,7 +5205,7 @@ _scsih_check_device(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 		return;
 	}
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
-	_scsih_ublock_io_device(ioc, handle);
+	_scsih_ublock_io_device(ioc, sas_address);
 
 }
 
@@ -5340,7 +5342,7 @@ _scsih_remove_device(struct MPT2SAS_ADAPTER *ioc,
 	if (sas_device->starget && sas_device->starget->hostdata) {
 		sas_target_priv_data = sas_device->starget->hostdata;
 		sas_target_priv_data->deleted = 1;
-		_scsih_ublock_io_device(ioc, sas_device->handle);
+		_scsih_ublock_io_device(ioc, sas_device->sas_address);
 		sas_target_priv_data->handle =
 		     MPT2SAS_INVALID_DEVICE_HANDLE;
 	}
@@ -7016,8 +7018,8 @@ _scsih_remove_unresponding_sas_devices(struct MPT2SAS_ADAPTER *ioc)
 	list_for_each_entry_safe(sas_device, sas_device_next,
 	    &ioc->sas_device_list, list) {
 		if (!sas_device->responding)
-			_scsih_device_remove_by_handle(ioc,
-			    sas_device->handle);
+			mpt2sas_device_remove_by_sas_address(ioc,
+				sas_device->sas_address);
 		else
 			sas_device->responding = 0;
 	}
