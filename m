Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00AC0C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Feb 2022 21:48:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235562AbiBAVsz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Feb 2022 16:48:55 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:39875 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235300AbiBAVsy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Feb 2022 16:48:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643752134; x=1675288134;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EUtA/YtUkif9sUP59gUGSDmEapkZ3sVZMoaxZyr6094=;
  b=Dm5Mnf0Q6ET2OtQ8A5xfDzdH8x5e/uFxH6Rk8lfARZvFMvbxFXITKYC9
   4vcxiPf7cvFH6KTZdEDf7HeaChfpCzE7YirMgIpNEugdBu8QEEU7AM1kr
   UOSTeiSMu3wtdGw9jdxIpb1ErGpB0DUD6IhGjOghcS5Djp7yEnRe4NWHu
   KegYpzmO1/ULGkY/vUggT6JKDirCdlK7MZAXHkWnjCix3bYlWgIdA+YMb
   cOC676a5HhUahD1iDq2tg2eB5C45e+k2/bl0NchJxHnbu8rcU4J7njpy2
   hzMXDX7ecCDZBUVyTWTl/dwl4JcY1vfF20l93uXyVFvewnhkpcXCyiyoF
   A==;
IronPort-SDR: Q33TkUd4WDwqZ+CcOFYLELOrvz5sPB6URoo7aXVqH1tpQkHH8BRmNJUy+2MfJnxvHiDnpndT7i
 kHsufpPMZ8EaXHMYOB1yshJFa6it7pM+i1XvyF6EIqXVUhRbt7WEreGOXFOhw4q0MYzOiL2awA
 qZjqswzBBd9lq/Siew4dpUJ/TaJaquLqA2K2tzGKQxQbH+uLkvrbRdlxQ+4JKOAmXAwfdQvmQ+
 jdWXUxxukhK7kiMC14FUNO+yUKMGQpYD+PzMMTSC31EO6Ata2aJqRL6IomsbSfrEAzneca4VVC
 o3tDmeuYZI/E65otuUv3ypSx
X-IronPort-AV: E=Sophos;i="5.88,335,1635231600"; 
   d="scan'208";a="160764729"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Feb 2022 14:48:54 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 1 Feb 2022 14:48:53 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Tue, 1 Feb 2022 14:48:53 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (Postfix) with ESMTP id 7A11870236E;
        Tue,  1 Feb 2022 15:48:53 -0600 (CST)
Subject: [PATCH 13/18] smartpqi: expose SAS address for SATA drives
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 1 Feb 2022 15:48:53 -0600
Message-ID: <164375213346.440833.12379222470149882747.stgit@brunhilda.pdev.net>
In-Reply-To: <164375113574.440833.13174600317115819605.stgit@brunhilda.pdev.net>
References: <164375113574.440833.13174600317115819605.stgit@brunhilda.pdev.net>
User-Agent: StGit/1.4.dev36+g39bf3b02665a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microchip.com>

Remove UNIQUE_WWID_IN_REPORT_PHYS_LUN PQI feature.

This feature was originally added to solve a problem with NVMe drives,
but this problem has since been solved a different way, so this
PQI feature is no longer required for any type of drive.

Linux kernel was not creating symbolic links in sysfs between SATA
drives and their enclosure.

The driver was enabling the UNIQUE_WWID_IN_REPORT_PHYS_LUN PQI feature,
which causes the FW to return a WWID for SATA drives that is derived
from a unique ID read from the SATA drive itself. The driver was
exposing this WWID as the drive's SAS address. However, because this
SAS address does not match the SAS address returned by an enclosure's
SES Page 0xA data, the Linux kernel was not able to match a SATA
drive with its enclosure.

Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |    2 --
 drivers/scsi/smartpqi/smartpqi_init.c |   43 ++-------------------------------
 2 files changed, 3 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 826c4001bac2..c4c48272d8ad 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1141,7 +1141,6 @@ struct pqi_scsi_dev {
 	struct pqi_stream_data stream_data[NUM_STREAMS_PER_LUN];
 	atomic_t scsi_cmds_outstanding;
 	atomic_t raid_bypass_cnt;
-	u8	page_83_identifier[16];
 };
 
 /* VPD inquiry pages */
@@ -1331,7 +1330,6 @@ struct pqi_ctrl_info {
 	u8		soft_reset_handshake_supported : 1;
 	u8		raid_iu_timeout_supported : 1;
 	u8		tmf_iu_timeout_supported : 1;
-	u8		unique_wwid_in_report_phys_lun_supported : 1;
 	u8		firmware_triage_supported : 1;
 	u8		rpl_extended_format_4_5_supported : 1;
 	u8		enable_r1_writes : 1;
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 18c695202c52..76ad919b0812 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1588,9 +1588,6 @@ static int pqi_get_physical_device_info(struct pqi_ctrl_info *ctrl_info,
 		sizeof(device->phys_connector));
 	device->bay = id_phys->phys_bay_in_box;
 
-	memcpy(&device->page_83_identifier, &id_phys->page_83_identifier,
-		sizeof(device->page_83_identifier));
-
 	if ((id_phys->even_more_flags & PQI_DEVICE_PHY_MAP_SUPPORTED) &&
 		id_phys->phy_count)
 		device->phy_id =
@@ -2281,18 +2278,6 @@ static inline void pqi_mask_device(u8 *scsi3addr)
 	scsi3addr[3] |= 0xc0;
 }
 
-static inline bool pqi_is_device_with_sas_address(struct pqi_scsi_dev *device)
-{
-	switch (device->device_type) {
-	case SA_DEVICE_TYPE_SAS:
-	case SA_DEVICE_TYPE_EXPANDER_SMP:
-	case SA_DEVICE_TYPE_SES:
-		return true;
-	}
-
-	return false;
-}
-
 static inline bool pqi_is_multipath_device(struct pqi_scsi_dev *device)
 {
 	if (pqi_is_logical_device(device))
@@ -2306,17 +2291,6 @@ static inline bool pqi_expose_device(struct pqi_scsi_dev *device)
 	return !device->is_physical_device || !pqi_skip_device(device->scsi3addr);
 }
 
-static inline void pqi_set_physical_device_wwid(struct pqi_ctrl_info *ctrl_info,
-	struct pqi_scsi_dev *device, struct report_phys_lun_16byte_wwid *phys_lun)
-{
-	if (ctrl_info->unique_wwid_in_report_phys_lun_supported ||
-		ctrl_info->rpl_extended_format_4_5_supported ||
-		pqi_is_device_with_sas_address(device))
-		memcpy(device->wwid, phys_lun->wwid, sizeof(device->wwid));
-	else
-		memcpy(&device->wwid[8], device->page_83_identifier, 8);
-}
-
 static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 {
 	int i;
@@ -2484,7 +2458,7 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 		pqi_assign_bus_target_lun(device);
 
 		if (device->is_physical_device) {
-			pqi_set_physical_device_wwid(ctrl_info, device, phys_lun);
+			memcpy(device->wwid, phys_lun->wwid, sizeof(device->wwid));
 			if ((phys_lun->device_flags &
 				CISS_REPORT_PHYS_DEV_FLAG_AIO_ENABLED) &&
 				phys_lun->aio_handle) {
@@ -2497,8 +2471,7 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 				sizeof(device->volume_id));
 		}
 
-		if (pqi_is_device_with_sas_address(device))
-			device->sas_address = get_unaligned_be64(&device->wwid[8]);
+		device->sas_address = get_unaligned_be64(&device->wwid[8]);
 
 		new_device_list[num_valid_devices++] = device;
 	}
@@ -7087,7 +7060,7 @@ static ssize_t pqi_sas_address_show(struct device *dev,
 	spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
 
 	device = sdev->hostdata;
-	if (!device || !pqi_is_device_with_sas_address(device)) {
+	if (!device) {
 		spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 		return -ENODEV;
 	}
@@ -7643,10 +7616,6 @@ static void pqi_ctrl_update_feature_flags(struct pqi_ctrl_info *ctrl_info,
 	case PQI_FIRMWARE_FEATURE_TMF_IU_TIMEOUT:
 		ctrl_info->tmf_iu_timeout_supported = firmware_feature->enabled;
 		break;
-	case PQI_FIRMWARE_FEATURE_UNIQUE_WWID_IN_REPORT_PHYS_LUN:
-		ctrl_info->unique_wwid_in_report_phys_lun_supported =
-			firmware_feature->enabled;
-		break;
 	case PQI_FIRMWARE_FEATURE_FW_TRIAGE:
 		ctrl_info->firmware_triage_supported = firmware_feature->enabled;
 		pqi_save_fw_triage_setting(ctrl_info, firmware_feature->enabled);
@@ -7744,11 +7713,6 @@ static struct pqi_firmware_feature pqi_firmware_features[] = {
 		.feature_bit = PQI_FIRMWARE_FEATURE_RAID_BYPASS_ON_ENCRYPTED_NVME,
 		.feature_status = pqi_firmware_feature_status,
 	},
-	{
-		.feature_name = "Unique WWID in Report Physical LUN",
-		.feature_bit = PQI_FIRMWARE_FEATURE_UNIQUE_WWID_IN_REPORT_PHYS_LUN,
-		.feature_status = pqi_ctrl_update_feature_flags,
-	},
 	{
 		.feature_name = "Firmware Triage",
 		.feature_bit = PQI_FIRMWARE_FEATURE_FW_TRIAGE,
@@ -7858,7 +7822,6 @@ static void pqi_ctrl_reset_config(struct pqi_ctrl_info *ctrl_info)
 	ctrl_info->enable_r6_writes = false;
 	ctrl_info->raid_iu_timeout_supported = false;
 	ctrl_info->tmf_iu_timeout_supported = false;
-	ctrl_info->unique_wwid_in_report_phys_lun_supported = false;
 	ctrl_info->firmware_triage_supported = false;
 	ctrl_info->rpl_extended_format_4_5_supported = false;
 }


