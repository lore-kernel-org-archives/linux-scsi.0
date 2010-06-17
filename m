From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 04/08] mptfusion: Added sanity to check B_T mapping for device before adding to OS
Date: Thu, 17 Jun 2010 14:40:10 +0530
Message-ID: <20100617091001.GE29165@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:52498 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759231Ab0FQJpq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2010 05:45:46 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Added sanity check before treating any device is a valid device.
It is possible that firmware can have device page0 in its table, but that
devicemay not be available in topology. Device will be available in topology
only if there is Bus Target mapping is done in firmware. Driver will always
check B_T mapping of firmware before reporting device to upper layer.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 1caf03e..92f033a 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -2549,6 +2549,7 @@ mptsas_sas_device_pg0(MPT_ADAPTER *ioc, struct mptsas_devinfo *device_info,
 	device_info->sas_address = le64_to_cpu(sas_address);
 	device_info->device_info =
 	    le32_to_cpu(buffer->DeviceInfo);
+	device_info->flags = le16_to_cpu(buffer->Flags);
 
  out_free_consistent:
 	pci_free_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
@@ -3840,6 +3841,13 @@ mptsas_probe_devices(MPT_ADAPTER *ioc)
 		      MPI_SAS_DEVICE_INFO_SATA_DEVICE)) == 0)
 			continue;
 
+		/* If there is no FW B_T mapping for this device then continue
+		 * */
+		if (!(sas_device.flags & MPI_SAS_DEVICE0_FLAGS_DEVICE_PRESENT)
+			|| !(sas_device.flags &
+			MPI_SAS_DEVICE0_FLAGS_DEVICE_MAPPED))
+			continue;
+
 		phy_info = mptsas_refreshing_device_handles(ioc, &sas_device);
 		if (!phy_info)
 			continue;
@@ -4149,6 +4157,14 @@ mptsas_adding_inactive_raid_components(MPT_ADAPTER *ioc, u8 channel, u8 id)
 			phys_disk.PhysDiskID))
 			continue;
 
+		/* If there is no FW B_T mapping for this device then continue
+		 * */
+		if (!(sas_device.flags & MPI_SAS_DEVICE0_FLAGS_DEVICE_PRESENT)
+			|| !(sas_device.flags &
+			MPI_SAS_DEVICE0_FLAGS_DEVICE_MAPPED))
+			continue;
+
+
 		phy_info = mptsas_find_phyinfo_by_sas_address(ioc,
 		    sas_device.sas_address);
 		mptsas_add_end_device(ioc, phy_info);
@@ -4199,6 +4215,13 @@ mptsas_hotplug_work(MPT_ADAPTER *ioc, struct fw_event_work *fw_event,
 		    (hot_plug_info->channel << 8) +
 		    hot_plug_info->id);
 
+		/* If there is no FW B_T mapping for this device then break
+		 * */
+		if (!(sas_device.flags & MPI_SAS_DEVICE0_FLAGS_DEVICE_PRESENT)
+			|| !(sas_device.flags &
+			MPI_SAS_DEVICE0_FLAGS_DEVICE_MAPPED))
+			break;
+
 		if (!sas_device.handle)
 			return;
 
@@ -4241,6 +4264,13 @@ mptsas_hotplug_work(MPT_ADAPTER *ioc, struct fw_event_work *fw_event,
 			break;
 		}
 
+		/* If there is no FW B_T mapping for this device then break
+		 * */
+		if (!(sas_device.flags & MPI_SAS_DEVICE0_FLAGS_DEVICE_PRESENT)
+			|| !(sas_device.flags &
+			MPI_SAS_DEVICE0_FLAGS_DEVICE_MAPPED))
+			break;
+
 		phy_info = mptsas_find_phyinfo_by_sas_address(
 		    ioc, sas_device.sas_address);
 
@@ -4294,6 +4324,13 @@ mptsas_hotplug_work(MPT_ADAPTER *ioc, struct fw_event_work *fw_event,
 			break;
 		}
 
+		/* If there is no FW B_T mapping for this device then break
+		 * */
+		if (!(sas_device.flags & MPI_SAS_DEVICE0_FLAGS_DEVICE_PRESENT)
+			|| !(sas_device.flags &
+			MPI_SAS_DEVICE0_FLAGS_DEVICE_MAPPED))
+			break;
+
 		phy_info = mptsas_find_phyinfo_by_sas_address(ioc,
 				sas_device.sas_address);
 		if (!phy_info) {
diff --git a/drivers/message/fusion/mptsas.h b/drivers/message/fusion/mptsas.h
index 7b249ed..57e86ab 100644
--- a/drivers/message/fusion/mptsas.h
+++ b/drivers/message/fusion/mptsas.h
@@ -140,6 +140,7 @@ struct mptsas_devinfo {
 	u64	sas_address;    /* WWN of this device,
 				   SATA is assigned by HBA,expander */
 	u32	device_info;	/* bitfield detailed info about this device */
+	u16	flags;		/* sas device pg0 flags */
 };
 
 /*
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
