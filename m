Return-Path: <SRS0=WBt/=BK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC370C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 21:01:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1624208E4
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 21:01:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbgGaVBS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Jul 2020 17:01:18 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:47333 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729062AbgGaVBR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Jul 2020 17:01:17 -0400
IronPort-SDR: GTqBlVzndrC1baDiEZVYiNqsOCh0f7mP045jPypYGgiWWZB2mAN1D63rwDAb7+sVzMXk2Sdb2q
 i4TLmlpoTiImCpJ3AqDPAiaR8k8kHhlwisVuswD/l8xFd+9bGy8BmNa3WLr9sxdICL4cUhFO8u
 jfA+ioSVIY4N+87sruK1d0FiDKEQJ+IdbuzQP8NMgU+uE8ZciCs5RfpZUPzvtnSd8sVrMsEyGs
 Q6NOWPneIYA4jj4R2DGx3S3611gZgm4VXMcFKCCwN8Q1UQ0uIxWs4bl/gYtUTHLAvQEtHzMShn
 EA4=
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="84056388"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 31 Jul 2020 14:01:16 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 31 Jul 2020 14:01:14 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 31 Jul 2020 14:01:10 -0700
Subject: [PATCH 1/7] smartpqi identify physical devices without issuing
 INQUIRY
From:   Don Brace <don.brace@microsemi.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <bader.alisaleh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 31 Jul 2020 16:01:11 -0500
Message-ID: <159622927172.30579.3960527536810532094.stgit@brunhilda>
In-Reply-To: <159622890296.30579.6820363566594432069.stgit@brunhilda>
References: <159622890296.30579.6820363566594432069.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

- Eliminate issuing INQUIRYs to problematic devices by using
  information provided by controller.

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |    1 
 drivers/scsi/smartpqi/smartpqi_init.c |  173 ++++++++++++++++-----------------
 2 files changed, 87 insertions(+), 87 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 1129fe7a27ed..48ca2ee06972 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1255,6 +1255,7 @@ struct bmic_sense_subsystem_info {
 #define SA_DEVICE_TYPE_SATA		0x1
 #define SA_DEVICE_TYPE_SAS		0x2
 #define SA_DEVICE_TYPE_EXPANDER_SMP	0x5
+#define SA_DEVICE_TYPE_SES		0x6
 #define SA_DEVICE_TYPE_CONTROLLER	0x7
 #define SA_DEVICE_TYPE_NVME		0x9
 
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index cd157f11eb22..a5c76f024224 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1300,33 +1300,59 @@ static void pqi_get_volume_status(struct pqi_ctrl_info *ctrl_info,
 	device->volume_offline = volume_offline;
 }
 
-#define PQI_INQUIRY_PAGE0_RETRIES	3
+static int pqi_get_physical_device_info(struct pqi_ctrl_info *ctrl_info,
+	struct pqi_scsi_dev *device,
+	struct bmic_identify_physical_device *id_phys)
+{
+	int rc;
 
-static int pqi_get_device_info(struct pqi_ctrl_info *ctrl_info,
+	memset(id_phys, 0, sizeof(*id_phys));
+
+	rc = pqi_identify_physical_device(ctrl_info, device,
+		id_phys, sizeof(*id_phys));
+	if (rc) {
+		device->queue_depth = PQI_PHYSICAL_DISK_DEFAULT_MAX_QUEUE_DEPTH;
+		return rc;
+	}
+
+	scsi_sanitize_inquiry_string(&id_phys->model[0], 8);
+	scsi_sanitize_inquiry_string(&id_phys->model[8], 16);
+
+	memcpy(device->vendor, &id_phys->model[0], sizeof(device->vendor));
+	memcpy(device->model, &id_phys->model[8], sizeof(device->model));
+
+	device->box_index = id_phys->box_index;
+	device->phys_box_on_bus = id_phys->phys_box_on_bus;
+	device->phy_connected_dev_type = id_phys->phy_connected_dev_type[0];
+	device->queue_depth =
+		get_unaligned_le16(&id_phys->current_queue_depth_limit);
+	device->active_path_index = id_phys->active_path_number;
+	device->path_map = id_phys->redundant_path_present_map;
+	memcpy(&device->box,
+		&id_phys->alternate_paths_phys_box_on_port,
+		sizeof(device->box));
+	memcpy(&device->phys_connector,
+		&id_phys->alternate_paths_phys_connector,
+		sizeof(device->phys_connector));
+	device->bay = id_phys->phys_bay_in_box;
+
+	return 0;
+}
+
+static int pqi_get_logical_device_info(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_scsi_dev *device)
 {
 	int rc;
 	u8 *buffer;
-	unsigned int retries;
-
-	if (device->is_expander_smp_device)
-		return 0;
 
 	buffer = kmalloc(64, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
 	/* Send an inquiry to the device to see what it is. */
-	for (retries = 0;;) {
-		rc = pqi_scsi_inquiry(ctrl_info, device->scsi3addr, 0,
-			buffer, 64);
-		if (rc == 0)
-			break;
-		if (pqi_is_logical_device(device) ||
-			rc != PQI_CMD_STATUS_ABORTED ||
-			++retries > PQI_INQUIRY_PAGE0_RETRIES)
-			goto out;
-	}
+	rc = pqi_scsi_inquiry(ctrl_info, device->scsi3addr, 0, buffer, 64);
+	if (rc)
+		goto out;
 
 	scsi_sanitize_inquiry_string(&buffer[8], 8);
 	scsi_sanitize_inquiry_string(&buffer[16], 16);
@@ -1335,7 +1361,7 @@ static int pqi_get_device_info(struct pqi_ctrl_info *ctrl_info,
 	memcpy(device->vendor, &buffer[8], sizeof(device->vendor));
 	memcpy(device->model, &buffer[16], sizeof(device->model));
 
-	if (pqi_is_logical_device(device) && device->devtype == TYPE_DISK) {
+	if (device->devtype == TYPE_DISK) {
 		if (device->is_external_raid_device) {
 			device->raid_level = SA_RAID_UNKNOWN;
 			device->volume_status = CISS_LV_OK;
@@ -1353,36 +1379,21 @@ static int pqi_get_device_info(struct pqi_ctrl_info *ctrl_info,
 	return rc;
 }
 
-static void pqi_get_physical_disk_info(struct pqi_ctrl_info *ctrl_info,
+static int pqi_get_device_info(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_scsi_dev *device,
 	struct bmic_identify_physical_device *id_phys)
 {
 	int rc;
 
-	memset(id_phys, 0, sizeof(*id_phys));
+	if (device->is_expander_smp_device)
+		return 0;
 
-	rc = pqi_identify_physical_device(ctrl_info, device,
-		id_phys, sizeof(*id_phys));
-	if (rc) {
-		device->queue_depth = PQI_PHYSICAL_DISK_DEFAULT_MAX_QUEUE_DEPTH;
-		return;
-	}
+	if (pqi_is_logical_device(device))
+		rc = pqi_get_logical_device_info(ctrl_info, device);
+	else
+		rc = pqi_get_physical_device_info(ctrl_info, device, id_phys);
 
-	device->box_index = id_phys->box_index;
-	device->phys_box_on_bus = id_phys->phys_box_on_bus;
-	device->phy_connected_dev_type = id_phys->phy_connected_dev_type[0];
-	device->queue_depth =
-		get_unaligned_le16(&id_phys->current_queue_depth_limit);
-	device->device_type = id_phys->device_type;
-	device->active_path_index = id_phys->active_path_number;
-	device->path_map = id_phys->redundant_path_present_map;
-	memcpy(&device->box,
-		&id_phys->alternate_paths_phys_box_on_port,
-		sizeof(device->box));
-	memcpy(&device->phys_connector,
-		&id_phys->alternate_paths_phys_connector,
-		sizeof(device->phys_connector));
-	device->bay = id_phys->phys_bay_in_box;
+	return rc;
 }
 
 static void pqi_show_volume_status(struct pqi_ctrl_info *ctrl_info,
@@ -1872,9 +1883,10 @@ static void pqi_update_device_list(struct pqi_ctrl_info *ctrl_info,
 	/* Expose any new devices. */
 	list_for_each_entry_safe(device, next, &add_list, add_list_entry) {
 		if (!pqi_is_device_added(device)) {
-			pqi_dev_info(ctrl_info, "added", device);
 			rc = pqi_add_device(ctrl_info, device);
-			if (rc) {
+			if (rc == 0) {
+				pqi_dev_info(ctrl_info, "added", device);
+			} else {
 				dev_warn(&ctrl_info->pci_dev->dev,
 					"scsi %d:%d:%d:%d addition failed, device not added\n",
 					ctrl_info->scsi_host->host_no,
@@ -1886,36 +1898,19 @@ static void pqi_update_device_list(struct pqi_ctrl_info *ctrl_info,
 	}
 }
 
-static bool pqi_is_supported_device(struct pqi_scsi_dev *device)
+static inline bool pqi_is_supported_device(struct pqi_scsi_dev *device)
 {
-	bool is_supported;
-
-	if (device->is_expander_smp_device)
-		return true;
-
-	is_supported = false;
-
-	switch (device->devtype) {
-	case TYPE_DISK:
-	case TYPE_ZBC:
-	case TYPE_TAPE:
-	case TYPE_MEDIUM_CHANGER:
-	case TYPE_ENCLOSURE:
-		is_supported = true;
-		break;
-	case TYPE_RAID:
-		/*
-		 * Only support the HBA controller itself as a RAID
-		 * controller.  If it's a RAID controller other than
-		 * the HBA itself (an external RAID controller, for
-		 * example), we don't support it.
-		 */
-		if (pqi_is_hba_lunid(device->scsi3addr))
-			is_supported = true;
-		break;
-	}
+	/*
+	 * Only support the HBA controller itself as a RAID
+	 * controller.  If it's a RAID controller other than
+	 * the HBA itself (an external RAID controller, for
+	 * example), we don't support it.
+	 */
+	if (device->device_type == SA_DEVICE_TYPE_CONTROLLER &&
+		!pqi_is_hba_lunid(device->scsi3addr))
+		return false;
 
-	return is_supported;
+	return true;
 }
 
 static inline bool pqi_skip_device(u8 *scsi3addr)
@@ -1934,16 +1929,10 @@ static inline void pqi_mask_device(u8 *scsi3addr)
 
 static inline bool pqi_is_device_with_sas_address(struct pqi_scsi_dev *device)
 {
-	if (!device->is_physical_device)
-		return false;
-
-	if (device->is_expander_smp_device)
-		return true;
-
-	switch (device->devtype) {
-	case TYPE_DISK:
-	case TYPE_ZBC:
-	case TYPE_ENCLOSURE:
+	switch (device->device_type) {
+	case SA_DEVICE_TYPE_SAS:
+	case SA_DEVICE_TYPE_EXPANDER_SMP:
+	case SA_DEVICE_TYPE_SES:
 		return true;
 	}
 
@@ -2085,16 +2074,19 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 		memcpy(device->scsi3addr, scsi3addr, sizeof(device->scsi3addr));
 		device->is_physical_device = is_physical_device;
 		if (is_physical_device) {
-			if (phys_lun_ext_entry->device_type ==
-				SA_DEVICE_TYPE_EXPANDER_SMP)
+			device->device_type = phys_lun_ext_entry->device_type;
+			if (device->device_type == SA_DEVICE_TYPE_EXPANDER_SMP)
 				device->is_expander_smp_device = true;
 		} else {
 			device->is_external_raid_device =
 				pqi_is_external_raid_addr(scsi3addr);
 		}
 
+		if (!pqi_is_supported_device(device))
+			continue;
+
 		/* Gather information about the device. */
-		rc = pqi_get_device_info(ctrl_info, device);
+		rc = pqi_get_device_info(ctrl_info, device, id_phys);
 		if (rc == -ENOMEM) {
 			dev_warn(&ctrl_info->pci_dev->dev, "%s\n",
 				out_of_memory_msg);
@@ -2115,9 +2107,6 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 			continue;
 		}
 
-		if (!pqi_is_supported_device(device))
-			continue;
-
 		pqi_assign_bus_target_lun(device);
 
 		if (device->is_physical_device) {
@@ -2129,7 +2118,6 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 				device->aio_handle =
 					phys_lun_ext_entry->aio_handle;
 			}
-			pqi_get_physical_disk_info(ctrl_info, device, id_phys);
 		} else {
 			memcpy(device->volume_id, log_lun_ext_entry->volume_id,
 				sizeof(device->volume_id));
@@ -5831,6 +5819,16 @@ static int pqi_map_queues(struct Scsi_Host *shost)
 					ctrl_info->pci_dev, 0);
 }
 
+static int pqi_slave_configure(struct scsi_device *sdev)
+{
+	struct pqi_scsi_dev *device;
+
+	device = sdev->hostdata;
+	device->devtype = sdev->type;
+
+	return 0;
+}
+
 static int pqi_getpciinfo_ioctl(struct pqi_ctrl_info *ctrl_info,
 	void __user *arg)
 {
@@ -6501,6 +6499,7 @@ static struct scsi_host_template pqi_driver_template = {
 	.eh_device_reset_handler = pqi_eh_device_reset_handler,
 	.ioctl = pqi_ioctl,
 	.slave_alloc = pqi_slave_alloc,
+	.slave_configure = pqi_slave_configure,
 	.map_queues = pqi_map_queues,
 	.sdev_attrs = pqi_sdev_attrs,
 	.shost_attrs = pqi_shost_attrs,

