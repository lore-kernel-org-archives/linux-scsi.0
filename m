Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72DF5C43334
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jul 2022 18:46:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239670AbiGHSqq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 14:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239668AbiGHSqm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 14:46:42 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B247391C
        for <linux-scsi@vger.kernel.org>; Fri,  8 Jul 2022 11:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657306001; x=1688842001;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J24ctuYQc7bP/vyFaK6iVmJcyxbGlIc8x4UXjEO98E8=;
  b=ldEKgNe8UxrQ2D4ZcTSA1PmkTzbYQ3jymajvzvsu8NraOL+xLZo/GUzq
   ymbPA4sZELQxi/NZ8kwWfzpdvAMax9/Cbrgrb78GVugAl6OxQOLLE7wXw
   8KDvJakTiHp365huoZF1aZU8IKP2GmFCRb8NaUA1MR+rvg5xwOxE7QEv+
   hBtZ07/DAW6nYahoE34Bl3uEQW91Y80eIwT4YAYffcLkPWq68nxtyu692
   hWnxllHmLibf5cobfDgKXlF0+DFexDtWyhX4pjR/M9MSkYJ3UHt14FFla
   pAuUJsHZzTg/2slLu3liBDYs5AarbWuI46XOOPcirPcIi2NCF1ACSrvbl
   g==;
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="181377317"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Jul 2022 11:46:41 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 8 Jul 2022 11:46:33 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Fri, 8 Jul 2022 11:46:33 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (8.15.2/8.15.2/Debian-22ubuntu3) with ESMTP id 268IlfMB177471;
        Fri, 8 Jul 2022 13:47:41 -0500
Received: (from brace@localhost)
        by brunhilda.pdev.net (8.15.2/8.15.2/Submit) id 268Ilfnt177470;
        Fri, 8 Jul 2022 13:47:41 -0500
X-Authentication-Warning: brunhilda.pdev.net: brace set sender to don.brace@microchip.com using -f
Subject: [PATCH V2 11/16] smartpqi: fix RAID map race condition
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <kumar.meiyappan@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 8 Jul 2022 13:47:41 -0500
Message-ID: <165730606128.177165.7671413443814750829.stgit@brunhilda>
In-Reply-To: <165730597930.177165.11663580730429681919.stgit@brunhilda>
References: <165730597930.177165.11663580730429681919.stgit@brunhilda>
User-Agent: StGit/1.5.dev2+g9ce680a52bd9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microchip.com>

Correct a rare stale RAID map access when performing AIO during
a RAID configuration change.

A race condition in the driver could cause it to access a stale RAID map
when a logical volume is reconfigured.

Modify the driver logic to invalidate a RAID map very early when a RAID
configuration change is detected and only switch to a new RAID map after
the driver detects that the RAID map has changed.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |  110 +++++++++++++++++++++------------
 1 file changed, 71 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 51b5a11efa9c..e07282ed0f34 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -2026,6 +2026,23 @@ static void pqi_dev_info(struct pqi_ctrl_info *ctrl_info,
 	dev_info(&ctrl_info->pci_dev->dev, "%s %s\n", action, buffer);
 }
 
+static bool pqi_raid_maps_equal(struct raid_map *raid_map1, struct raid_map *raid_map2)
+{
+	u32 raid_map1_size;
+	u32 raid_map2_size;
+
+	if (raid_map1 == NULL || raid_map2 == NULL)
+		return raid_map1 == raid_map2;
+
+	raid_map1_size = get_unaligned_le32(&raid_map1->structure_size);
+	raid_map2_size = get_unaligned_le32(&raid_map2->structure_size);
+
+	if (raid_map1_size != raid_map2_size)
+		return false;
+
+	return memcmp(raid_map1, raid_map2, raid_map1_size) == 0;
+}
+
 /* Assumes the SCSI device list lock is held. */
 
 static void pqi_scsi_update_device(struct pqi_ctrl_info *ctrl_info,
@@ -2039,52 +2056,51 @@ static void pqi_scsi_update_device(struct pqi_ctrl_info *ctrl_info,
 		existing_device->target_lun_valid = true;
 	}
 
-	if (pqi_is_logical_device(existing_device) &&
-		ctrl_info->logical_volume_rescan_needed)
-		existing_device->rescan = true;
-
 	/* By definition, the scsi3addr and wwid fields are already the same. */
 
 	existing_device->is_physical_device = new_device->is_physical_device;
-	existing_device->is_external_raid_device =
-		new_device->is_external_raid_device;
-	existing_device->is_expander_smp_device =
-		new_device->is_expander_smp_device;
-	existing_device->aio_enabled = new_device->aio_enabled;
-	memcpy(existing_device->vendor, new_device->vendor,
-		sizeof(existing_device->vendor));
-	memcpy(existing_device->model, new_device->model,
-		sizeof(existing_device->model));
+	memcpy(existing_device->vendor, new_device->vendor, sizeof(existing_device->vendor));
+	memcpy(existing_device->model, new_device->model, sizeof(existing_device->model));
 	existing_device->sas_address = new_device->sas_address;
-	existing_device->raid_level = new_device->raid_level;
 	existing_device->queue_depth = new_device->queue_depth;
-	existing_device->aio_handle = new_device->aio_handle;
-	existing_device->volume_status = new_device->volume_status;
-	existing_device->active_path_index = new_device->active_path_index;
-	existing_device->phy_id = new_device->phy_id;
-	existing_device->path_map = new_device->path_map;
-	existing_device->bay = new_device->bay;
-	existing_device->box_index = new_device->box_index;
-	existing_device->phys_box_on_bus = new_device->phys_box_on_bus;
-	existing_device->phy_connected_dev_type = new_device->phy_connected_dev_type;
-	existing_device->multi_lun_device_lun_count = new_device->multi_lun_device_lun_count;
-	if (!existing_device->multi_lun_device_lun_count)
-		existing_device->multi_lun_device_lun_count = 1;
-	memcpy(existing_device->box, new_device->box,
-		sizeof(existing_device->box));
-	memcpy(existing_device->phys_connector, new_device->phys_connector,
-		sizeof(existing_device->phys_connector));
-	memset(existing_device->next_bypass_group, 0, sizeof(existing_device->next_bypass_group));
-	kfree(existing_device->raid_map);
-	existing_device->raid_map = new_device->raid_map;
-	existing_device->raid_bypass_configured =
-		new_device->raid_bypass_configured;
-	existing_device->raid_bypass_enabled =
-		new_device->raid_bypass_enabled;
 	existing_device->device_offline = false;
 
-	/* To prevent this from being freed later. */
-	new_device->raid_map = NULL;
+	if (pqi_is_logical_device(existing_device)) {
+		existing_device->is_external_raid_device = new_device->is_external_raid_device;
+
+		if (existing_device->devtype == TYPE_DISK) {
+			existing_device->raid_level = new_device->raid_level;
+			existing_device->volume_status = new_device->volume_status;
+			if (ctrl_info->logical_volume_rescan_needed)
+				existing_device->rescan = true;
+			memset(existing_device->next_bypass_group, 0, sizeof(existing_device->next_bypass_group));
+			if (!pqi_raid_maps_equal(existing_device->raid_map, new_device->raid_map)) {
+				kfree(existing_device->raid_map);
+				existing_device->raid_map = new_device->raid_map;
+				/* To prevent this from being freed later. */
+				new_device->raid_map = NULL;
+			}
+			existing_device->raid_bypass_configured = new_device->raid_bypass_configured;
+			existing_device->raid_bypass_enabled = new_device->raid_bypass_enabled;
+		}
+	} else {
+		existing_device->aio_enabled = new_device->aio_enabled;
+		existing_device->aio_handle = new_device->aio_handle;
+		existing_device->is_expander_smp_device = new_device->is_expander_smp_device;
+		existing_device->active_path_index = new_device->active_path_index;
+		existing_device->phy_id = new_device->phy_id;
+		existing_device->path_map = new_device->path_map;
+		existing_device->bay = new_device->bay;
+		existing_device->box_index = new_device->box_index;
+		existing_device->phys_box_on_bus = new_device->phys_box_on_bus;
+		existing_device->phy_connected_dev_type = new_device->phy_connected_dev_type;
+		memcpy(existing_device->box, new_device->box, sizeof(existing_device->box));
+		memcpy(existing_device->phys_connector, new_device->phys_connector, sizeof(existing_device->phys_connector));
+
+		existing_device->multi_lun_device_lun_count = new_device->multi_lun_device_lun_count;
+		if (existing_device->multi_lun_device_lun_count == 0)
+			existing_device->multi_lun_device_lun_count = 1;
+	}
 }
 
 static inline void pqi_free_device(struct pqi_scsi_dev *device)
@@ -3675,6 +3691,20 @@ static bool pqi_ofa_process_event(struct pqi_ctrl_info *ctrl_info,
 	return ack_event;
 }
 
+static void pqi_disable_raid_bypass(struct pqi_ctrl_info *ctrl_info)
+{
+	unsigned long flags;
+	struct pqi_scsi_dev *device;
+
+	spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
+
+	list_for_each_entry(device, &ctrl_info->scsi_device_list, scsi_device_list_entry)
+		if (device->raid_bypass_enabled)
+			device->raid_bypass_enabled = false;
+
+	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
+}
+
 static void pqi_event_worker(struct work_struct *work)
 {
 	unsigned int i;
@@ -3702,6 +3732,8 @@ static void pqi_event_worker(struct work_struct *work)
 				rescan_needed = true;
 				if (event->event_type == PQI_EVENT_TYPE_LOGICAL_DEVICE)
 					ctrl_info->logical_volume_rescan_needed = true;
+				else if (event->event_type == PQI_EVENT_TYPE_AIO_STATE_CHANGE)
+					pqi_disable_raid_bypass(ctrl_info);
 			}
 			if (ack_event)
 				pqi_acknowledge_event(ctrl_info, event);

