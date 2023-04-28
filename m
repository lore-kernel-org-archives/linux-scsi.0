Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 754C2C77B7E
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Apr 2023 15:37:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345900AbjD1Ph6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Apr 2023 11:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346087AbjD1Pht (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Apr 2023 11:37:49 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EAB35BBB
        for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2023 08:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1682696250; x=1714232250;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tIk/kN1rKS7uD/9eFw9SLa1rIEKyHQ+5g1LuMG2AJxg=;
  b=fHe6Ck5viVD0Zr5oNf7U5ZjF2T7cHNus7PNSxjkSF2cwZO2UrCyMTsgt
   8XsiV2rZF1JQ3Iuex9+tY+tybaNlUAup331K/CKeN7cgsOZDx9pcMmwhm
   TY1AlTLlPAiE/KJGmHz98r6z6CQ3Grce610Kx33F0mCgWsEyF+0Akrhwi
   bDHVl7j7pp02sHW0ZUL+umiE1PZys4DFMqzJhRdqWQG+3b+4z5fKvsil4
   pgEcvY5Y5iGr1Llxhz/HflOEq99QcVpuxkJws6d29oH+pb3Fy8yZMQyye
   HI79lagnYSIEprCpqvHu8crkplRti8pbJNHenN5MLuoEcQ2UpJqR4b/Tr
   g==;
X-IronPort-AV: E=Sophos;i="5.99,234,1677567600"; 
   d="scan'208";a="149474296"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Apr 2023 08:37:06 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 28 Apr 2023 08:37:05 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Fri, 28 Apr 2023 08:37:04 -0700
From:   Don Brace <don.brace@microchip.com>
To:     <don.brace@microchip.com>, <Kevin.Barnett@microchip.com>,
        <scott.teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <scott.benesh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <mike.mcgowen@microchip.com>,
        <murthy.bhat@microchip.com>, <kumar.meiyappan@microchip.com>,
        <jeremy.reeves@microchip.com>, <david.strahan@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Subject: [PATCH 09/12] smartpqi: stop sending driver initiated TURs
Date:   Fri, 28 Apr 2023 10:37:09 -0500
Message-ID: <20230428153712.297638-10-don.brace@microchip.com>
X-Mailer: git-send-email 2.40.1.375.g9ce9dea4e1
In-Reply-To: <20230428153712.297638-1-don.brace@microchip.com>
References: <20230428153712.297638-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <Kevin.Barnett@microchip.com>

Stop sending driver initiated TURs to physical devices during driver
load/rescan.

Note: Patch does not affect SML initiated TURs.

Some Linux kernels can cause lengthy delays in OS boot if the
kernel detects that a drive is being sanitized/erased. We were using
TURs to detect if a sanitize/erase was in progress.

Some devices do not return the TUR in a timely manner, causing driver
load/rescan stalls.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |  1 +
 drivers/scsi/smartpqi/smartpqi_init.c | 85 ++++-----------------------
 2 files changed, 11 insertions(+), 75 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 659a087a0e52..6883526db93c 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1108,6 +1108,7 @@ struct pqi_scsi_dev {
 	u8	volume_offline : 1;
 	u8	rescan : 1;
 	u8	ignore_device : 1;
+	u8	erase_in_progress : 1;
 	bool	aio_enabled;		/* only valid for physical disks */
 	bool	in_remove;
 	bool	device_offline;
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index d3d4fc90dcae..324870477bae 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -608,10 +608,6 @@ static int pqi_build_raid_path_request(struct pqi_ctrl_info *ctrl_info,
 	cdb = request->cdb;
 
 	switch (cmd) {
-	case TEST_UNIT_READY:
-		request->data_direction = SOP_READ_FLAG;
-		cdb[0] = TEST_UNIT_READY;
-		break;
 	case INQUIRY:
 		request->data_direction = SOP_READ_FLAG;
 		cdb[0] = INQUIRY;
@@ -1619,6 +1615,7 @@ static void pqi_get_volume_status(struct pqi_ctrl_info *ctrl_info,
 
 #define PQI_DEVICE_NCQ_PRIO_SUPPORTED	0x01
 #define PQI_DEVICE_PHY_MAP_SUPPORTED	0x10
+#define PQI_DEVICE_ERASE_IN_PROGRESS	0x10
 
 static int pqi_get_physical_device_info(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_scsi_dev *device,
@@ -1667,6 +1664,8 @@ static int pqi_get_physical_device_info(struct pqi_ctrl_info *ctrl_info,
 		((get_unaligned_le32(&id_phys->misc_drive_flags) >> 16) &
 		PQI_DEVICE_NCQ_PRIO_SUPPORTED);
 
+	device->erase_in_progress = !!(get_unaligned_le16(&id_phys->extra_physical_drive_flags) & PQI_DEVICE_ERASE_IN_PROGRESS);
+
 	return 0;
 }
 
@@ -1712,7 +1711,7 @@ static int pqi_get_logical_device_info(struct pqi_ctrl_info *ctrl_info,
 
 /*
  * Prevent adding drive to OS for some corner cases such as a drive
- * undergoing a sanitize operation. Some OSes will continue to poll
+ * undergoing a sanitize (erase) operation. Some OSes will continue to poll
  * the drive until the sanitize completes, which can take hours,
  * resulting in long bootup delays. Commands such as TUR, READ_CAP
  * are allowed, but READ/WRITE cause check condition. So the OS
@@ -1720,73 +1719,9 @@ static int pqi_get_logical_device_info(struct pqi_ctrl_info *ctrl_info,
  * Note: devices that have completed sanitize must be re-enabled
  *       using the management utility.
  */
-static bool pqi_keep_device_offline(struct pqi_ctrl_info *ctrl_info,
-	struct pqi_scsi_dev *device)
+static inline bool pqi_keep_device_offline(struct pqi_scsi_dev *device)
 {
-	u8 scsi_status;
-	int rc;
-	enum dma_data_direction dir;
-	char *buffer;
-	int buffer_length = 64;
-	size_t sense_data_length;
-	struct scsi_sense_hdr sshdr;
-	struct pqi_raid_path_request request;
-	struct pqi_raid_error_info error_info;
-	bool offline = false; /* Assume keep online */
-
-	/* Do not check controllers. */
-	if (pqi_is_hba_lunid(device->scsi3addr))
-		return false;
-
-	/* Do not check LVs. */
-	if (pqi_is_logical_device(device))
-		return false;
-
-	buffer = kmalloc(buffer_length, GFP_KERNEL);
-	if (!buffer)
-		return false; /* Assume not offline */
-
-	/* Check for SANITIZE in progress using TUR */
-	rc = pqi_build_raid_path_request(ctrl_info, &request,
-		TEST_UNIT_READY, RAID_CTLR_LUNID, buffer,
-		buffer_length, 0, &dir);
-	if (rc)
-		goto out; /* Assume not offline */
-
-	memcpy(request.lun_number, device->scsi3addr, sizeof(request.lun_number));
-
-	rc = pqi_submit_raid_request_synchronous(ctrl_info, &request.header, 0, &error_info);
-
-	if (rc)
-		goto out; /* Assume not offline */
-
-	scsi_status = error_info.status;
-	sense_data_length = get_unaligned_le16(&error_info.sense_data_length);
-	if (sense_data_length == 0)
-		sense_data_length =
-			get_unaligned_le16(&error_info.response_data_length);
-	if (sense_data_length) {
-		if (sense_data_length > sizeof(error_info.data))
-			sense_data_length = sizeof(error_info.data);
-
-		/*
-		 * Check for sanitize in progress: asc:0x04, ascq: 0x1b
-		 */
-		if (scsi_status == SAM_STAT_CHECK_CONDITION &&
-			scsi_normalize_sense(error_info.data,
-				sense_data_length, &sshdr) &&
-				sshdr.sense_key == NOT_READY &&
-				sshdr.asc == 0x04 &&
-				sshdr.ascq == 0x1b) {
-			device->device_offline = true;
-			offline = true;
-			goto out; /* Keep device offline */
-		}
-	}
-
-out:
-	kfree(buffer);
-	return offline;
+	return device->erase_in_progress;
 }
 
 static int pqi_get_device_info_phys_logical(struct pqi_ctrl_info *ctrl_info,
@@ -2530,10 +2465,6 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 		if (!pqi_is_supported_device(device))
 			continue;
 
-		/* Do not present disks that the OS cannot fully probe */
-		if (pqi_keep_device_offline(ctrl_info, device))
-			continue;
-
 		/* Gather information about the device. */
 		rc = pqi_get_device_info(ctrl_info, device, id_phys);
 		if (rc == -ENOMEM) {
@@ -2556,6 +2487,10 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 			continue;
 		}
 
+		/* Do not present disks that the OS cannot fully probe. */
+		if (pqi_keep_device_offline(device))
+			continue;
+
 		pqi_assign_bus_target_lun(device);
 
 		if (device->is_physical_device) {
-- 
2.40.1.375.g9ce9dea4e1

