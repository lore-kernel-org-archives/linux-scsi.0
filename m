From: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Subject: [PATCH 5/8] [SCSI] mpt2sas : Fix for device scan following host
 reset could get stuck in a infinite loop
Date: Fri, 1 Feb 2013 21:58:30 +0530
Message-ID: <20130201162830.GA21652@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:37656 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751671Ab3BAFe1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Feb 2013 00:34:27 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, sreekanth.reddy@lsi.com, Nagalakshmi.Nandigama@lsi.com, JBottomley@Parallels.com
Cc: linux-scsi@vger.kernel.org, sathya.prakash@lsi.com, stable@vger.kernel.org

Modified device scan routine so each configuration page read breaks from the while loop
when the ioc_status is not equal to MPI2_IOCSTATUS_SUCCESS.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 5073586..014caef 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -7097,12 +7097,15 @@ _scsih_scan_for_devices_after_reset(struct MPT2SAS_ADAPTER *ioc)
 	struct _sas_device *sas_device;
 	struct _sas_node *expander_device;
 	static struct _raid_device *raid_device;
+	u8 retry_count;
 	unsigned long flags;
 
 	printk(MPT2SAS_INFO_FMT "scan devices: start\n", ioc->name);
 
 	_scsih_sas_host_refresh(ioc);
 
+	printk(MPT2SAS_INFO_FMT "\tscan devices: expanders start\n",
+		ioc->name);
 	/* expanders */
 	handle = 0xFFFF;
 	while (!(mpt2sas_config_get_expander_pg0(ioc, &mpi_reply, &expander_pg0,
@@ -7111,6 +7114,13 @@ _scsih_scan_for_devices_after_reset(struct MPT2SAS_ADAPTER *ioc)
 		    MPI2_IOCSTATUS_MASK;
 		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
 			break;
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+			printk(MPT2SAS_INFO_FMT "\tbreak from expander scan: " \
+				"ioc_status(0x%04x), loginfo(0x%08x)\n",
+				ioc->name, ioc_status,
+				le32_to_cpu(mpi_reply.IOCLogInfo));
+			break;
+		}
 		handle = le16_to_cpu(expander_pg0.DevHandle);
 		spin_lock_irqsave(&ioc->sas_node_lock, flags);
 		expander_device = mpt2sas_scsih_expander_find_by_sas_address(
@@ -7119,13 +7129,26 @@ _scsih_scan_for_devices_after_reset(struct MPT2SAS_ADAPTER *ioc)
 		if (expander_device)
 			_scsih_refresh_expander_links(ioc, expander_device,
 			    handle);
-		else
+		else {
+			printk(MPT2SAS_INFO_FMT "\tBEFORE adding expander: " \
+				"handle (0x%04x), sas_addr(0x%016llx)\n",
+				ioc->name, handle, (unsigned long long)
+				le64_to_cpu(expander_pg0.SASAddress));
 			_scsih_expander_add(ioc, handle);
+			printk(MPT2SAS_INFO_FMT "\tAFTER adding expander: " \
+				"handle (0x%04x), sas_addr(0x%016llx)\n",
+				ioc->name, handle, (unsigned long long)
+				le64_to_cpu(expander_pg0.SASAddress));
+		}
 	}
 
+	printk(MPT2SAS_INFO_FMT "\tscan devices: expanders complete\n",
+		ioc->name);
+
 	if (!ioc->ir_firmware)
 		goto skip_to_sas;
 
+	printk(MPT2SAS_INFO_FMT "\tscan devices phys disk start\n", ioc->name);
 	/* phys disk */
 	phys_disk_num = 0xFF;
 	while (!(mpt2sas_config_get_phys_disk_pg0(ioc, &mpi_reply,
@@ -7135,6 +7158,13 @@ _scsih_scan_for_devices_after_reset(struct MPT2SAS_ADAPTER *ioc)
 		    MPI2_IOCSTATUS_MASK;
 		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
 			break;
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+			printk(MPT2SAS_INFO_FMT "\tbreak from phys disk scan:" \
+				"ioc_status(0x%04x), loginfo(0x%08x)\n",
+				ioc->name, ioc_status,
+				le32_to_cpu(mpi_reply.IOCLogInfo));
+			break;
+		}
 		phys_disk_num = pd_pg0.PhysDiskNum;
 		handle = le16_to_cpu(pd_pg0.DevHandle);
 		spin_lock_irqsave(&ioc->sas_device_lock, flags);
@@ -7146,17 +7176,46 @@ _scsih_scan_for_devices_after_reset(struct MPT2SAS_ADAPTER *ioc)
 		    &sas_device_pg0, MPI2_SAS_DEVICE_PGAD_FORM_HANDLE,
 		    handle) != 0)
 			continue;
+		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+			MPI2_IOCSTATUS_MASK;
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+			printk(MPT2SAS_INFO_FMT "\tbreak from phys disk scan " \
+				"ioc_status(0x%04x), loginfo(0x%08x)\n",
+				ioc->name, ioc_status,
+				le32_to_cpu(mpi_reply.IOCLogInfo));
+			break;
+		}
 		parent_handle = le16_to_cpu(sas_device_pg0.ParentDevHandle);
 		if (!_scsih_get_sas_address(ioc, parent_handle,
 		    &sas_address)) {
+			printk(MPT2SAS_INFO_FMT "\tBEFORE adding phys disk: " \
+				" handle (0x%04x), sas_addr(0x%016llx)\n",
+				ioc->name, handle, (unsigned long long)
+				le64_to_cpu(sas_device_pg0.SASAddress));
 			mpt2sas_transport_update_links(ioc, sas_address,
 			    handle, sas_device_pg0.PhyNum,
 			    MPI2_SAS_NEG_LINK_RATE_1_5);
 			set_bit(handle, ioc->pd_handles);
-			_scsih_add_device(ioc, handle, 0, 1);
+			retry_count = 0;
+			/* This will retry adding the end device.
+			* _scsih_add_device() will decide on retries and
+			* return "1" when it should be retried
+			*/
+			while (_scsih_add_device(ioc, handle, retry_count++,
+				1)) {
+					ssleep(1);
+			}
+			printk(MPT2SAS_INFO_FMT "\tAFTER adding phys disk: " \
+				" handle (0x%04x), sas_addr(0x%016llx)\n",
+				ioc->name, handle, (unsigned long long)
+				le64_to_cpu(sas_device_pg0.SASAddress));
 		}
 	}
 
+	printk(MPT2SAS_INFO_FMT "\tscan devices: phys disk complete\n",
+		ioc->name);
+
+	printk(MPT2SAS_INFO_FMT "\tscan devices: volumes start\n", ioc->name);
 	/* volumes */
 	handle = 0xFFFF;
 	while (!(mpt2sas_config_get_raid_volume_pg1(ioc, &mpi_reply,
@@ -7165,6 +7225,13 @@ _scsih_scan_for_devices_after_reset(struct MPT2SAS_ADAPTER *ioc)
 		    MPI2_IOCSTATUS_MASK;
 		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
 			break;
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+			printk(MPT2SAS_INFO_FMT "\tbreak from volume scan: " \
+				"ioc_status(0x%04x), loginfo(0x%08x)\n",
+				ioc->name, ioc_status,
+				le32_to_cpu(mpi_reply.IOCLogInfo));
+			break;
+		}
 		handle = le16_to_cpu(volume_pg1.DevHandle);
 		spin_lock_irqsave(&ioc->raid_device_lock, flags);
 		raid_device = _scsih_raid_device_find_by_wwid(ioc,
@@ -7176,18 +7243,38 @@ _scsih_scan_for_devices_after_reset(struct MPT2SAS_ADAPTER *ioc)
 		    &volume_pg0, MPI2_RAID_VOLUME_PGAD_FORM_HANDLE, handle,
 		     sizeof(Mpi2RaidVolPage0_t)))
 			continue;
+		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+			MPI2_IOCSTATUS_MASK;
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+			printk(MPT2SAS_INFO_FMT "\tbreak from volume scan: " \
+				"ioc_status(0x%04x), loginfo(0x%08x)\n",
+				ioc->name, ioc_status,
+				le32_to_cpu(mpi_reply.IOCLogInfo));
+			break;
+		}
 		if (volume_pg0.VolumeState == MPI2_RAID_VOL_STATE_OPTIMAL ||
 		    volume_pg0.VolumeState == MPI2_RAID_VOL_STATE_ONLINE ||
 		    volume_pg0.VolumeState == MPI2_RAID_VOL_STATE_DEGRADED) {
 			memset(&element, 0, sizeof(Mpi2EventIrConfigElement_t));
 			element.ReasonCode = MPI2_EVENT_IR_CHANGE_RC_ADDED;
 			element.VolDevHandle = volume_pg1.DevHandle;
+			printk(MPT2SAS_INFO_FMT "\tBEFORE adding volume: " \
+				" handle (0x%04x)\n", ioc->name,
+				volume_pg1.DevHandle);
 			_scsih_sas_volume_add(ioc, &element);
+			printk(MPT2SAS_INFO_FMT "\tAFTER adding volume: " \
+				" handle (0x%04x)\n", ioc->name,
+				volume_pg1.DevHandle);
 		}
 	}
 
+	printk(MPT2SAS_INFO_FMT "\tscan devices: volumes complete\n",
+		ioc->name);
+
  skip_to_sas:
 
+	printk(MPT2SAS_INFO_FMT "\tscan devices: end devices start\n",
+		ioc->name);
 	/* sas devices */
 	handle = 0xFFFF;
 	while (!(mpt2sas_config_get_sas_device_pg0(ioc, &mpi_reply,
@@ -7197,6 +7285,13 @@ _scsih_scan_for_devices_after_reset(struct MPT2SAS_ADAPTER *ioc)
 		    MPI2_IOCSTATUS_MASK;
 		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
 			break;
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+			printk(MPT2SAS_INFO_FMT "\tbreak from end device scan:"\
+				" ioc_status(0x%04x), loginfo(0x%08x)\n",
+				ioc->name, ioc_status,
+				le32_to_cpu(mpi_reply.IOCLogInfo));
+				break;
+		}
 		handle = le16_to_cpu(sas_device_pg0.DevHandle);
 		if (!(_scsih_is_end_device(
 		    le32_to_cpu(sas_device_pg0.DeviceInfo))))
@@ -7209,12 +7304,31 @@ _scsih_scan_for_devices_after_reset(struct MPT2SAS_ADAPTER *ioc)
 			continue;
 		parent_handle = le16_to_cpu(sas_device_pg0.ParentDevHandle);
 		if (!_scsih_get_sas_address(ioc, parent_handle, &sas_address)) {
+			printk(MPT2SAS_INFO_FMT "\tBEFORE adding end device: " \
+				"handle (0x%04x), sas_addr(0x%016llx)\n",
+				ioc->name, handle, (unsigned long long)
+				le64_to_cpu(sas_device_pg0.SASAddress));
 			mpt2sas_transport_update_links(ioc, sas_address, handle,
 			    sas_device_pg0.PhyNum, MPI2_SAS_NEG_LINK_RATE_1_5);
-			_scsih_add_device(ioc, handle, 0, 0);
+			retry_count = 0;
+			/* This will retry adding the end device.
+			 * _scsih_add_device() will decide on retries and
+			 * return "1" when it should be retried
+			 */
+			while (_scsih_add_device(ioc, handle, retry_count++,
+				0)) {
+					ssleep(1);
+			}
+			printk(MPT2SAS_INFO_FMT "\tAFTER adding end device: " \
+				"handle (0x%04x), sas_addr(0x%016llx)\n",
+				ioc->name, handle, (unsigned long long)
+				le64_to_cpu(sas_device_pg0.SASAddress));
 		}
 	}
 
+	printk(MPT2SAS_INFO_FMT "\tscan devices: end devices complete\n",
+		ioc->name);
+
 	printk(MPT2SAS_INFO_FMT "scan devices: complete\n", ioc->name);
 }
 
