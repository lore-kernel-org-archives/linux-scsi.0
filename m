Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183BA39AC6
	for <linux-scsi@vger.kernel.org>; Tue, 19 Dec 2023 19:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="C76dSHFI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1703014642; x=1734550642;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9XlKijK4XuHMN8gDTuZcRf4egvfTs3qhReYoCDGcUuI=;
  b=C76dSHFI2upDjCnAaeNsNdmIdjw3d6NPKHbzP6zB7e9s+qO02QIm4l4Q
   LK8hy2aBxki1LeWLYiMXBGYXCkuCAAo4UNhgGeMXol7j5aKbjroTocld1
   i6+VNtSRUvn3jsZyBmhFYEp/hwxUAuvJnvk4aEjitsgx+IRIsJeQ8jZFe
   c7Eyv39G2za2l/49bR/3phyaoz516cQkn6VRgrQsxFJJNuEpZnNYRT8sx
   Qymnf4x15quAMEIZQ+hu6hdx5w5kJ3f8pPtOWoJuMCzw22K5Ezgx7iSxa
   9IsD5VGNRUGN0eCuLuoKFPbM8hmouKKqrviKlF265+DvY8DQSdqIPJokf
   A==;
X-CSE-ConnectionGUID: QfATRU5QQbSZ4OmFfcIKRQ==
X-CSE-MsgGUID: Th3VWzNXQ1e8ZGN2MtMemA==
X-ThreatScanner-Verdict: Negative
X-IronPort-AV: E=Sophos;i="6.04,289,1695711600"; 
   d="scan'208";a="13591433"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Dec 2023 12:37:18 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 19 Dec 2023 12:36:55 -0700
Received: from brunhilda.pdev.net (10.10.85.11) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Tue, 19 Dec 2023 12:36:54 -0700
From: Don Brace <don.brace@microchip.com>
To: <don.brace@microchip.com>, <Kevin.Barnett@microchip.com>,
	<scott.teel@microchip.com>, <Justin.Lindley@microchip.com>,
	<scott.benesh@microchip.com>, <gerry.morong@microchip.com>,
	<mahesh.rajashekhara@microchip.com>, <mike.mcgowen@microchip.com>,
	<murthy.bhat@microchip.com>, <kumar.meiyappan@microchip.com>,
	<jeremy.reeves@microchip.com>, <david.strahan@microchip.com>,
	<hch@infradead.org>, <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
	<POSWALD@suse.com>
CC: <linux-scsi@vger.kernel.org>
Subject: [PATCH 2/3] smartpqi: fix logical volume rescan race condition
Date: Tue, 19 Dec 2023 13:36:51 -0600
Message-ID: <20231219193653.277553-3-don.brace@microchip.com>
X-Mailer: git-send-email 2.43.0.76.g1a87c842ec
In-Reply-To: <20231219193653.277553-1-don.brace@microchip.com>
References: <20231219193653.277553-1-don.brace@microchip.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>

Correct rescan flag race condition.

   Multiple conditions are being evaluated before notifying OS
   to do a rescan.

   Driver will skip re-scanning the device if any one of the following
   conditions are met:
   - Devices that have not yet been added to the OS or devices
     that have been removed.
   - Devices which are already marked for removal or in the phase
     of removal.

   Under very rare conditions, after logical volume size expansion, the OS
   still sees the size of the logical volume which was before expansion.

   The rescan flag in the driver is used to signal the need for a logical
   volume rescan. A race condition can occur in the driver, and it leads
   to one thread overwriting the flag inadvertently. As a result, driver
   is not notifying the OS SML to rescan the logical volume.

   Move device->rescan update into new function
   pqi_mark_volumes_for_rescan() and protect with a spin lock.

   Move check for device->rescan into new function
   pqi_volume_rescan_needed() and protect function call with
   a spin_lock.

Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Co-developed-by: Murthy Bhat <Murthy.Bhat@microchip.com>
Signed-off-by: Murthy Bhat <Murthy.Bhat@microchip.com>
Signed-off-by: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |  1 -
 drivers/scsi/smartpqi/smartpqi_init.c | 43 ++++++++++++++++++++++-----
 2 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 041940183516..cdedc271857a 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1347,7 +1347,6 @@ struct pqi_ctrl_info {
 	bool		controller_online;
 	bool		block_requests;
 	bool		scan_blocked;
-	u8		logical_volume_rescan_needed : 1;
 	u8		inbound_spanning_supported : 1;
 	u8		outbound_spanning_supported : 1;
 	u8		pqi_mode_enabled : 1;
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index d56201120087..081bb2c09806 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -2093,8 +2093,6 @@ static void pqi_scsi_update_device(struct pqi_ctrl_info *ctrl_info,
 		if (existing_device->devtype == TYPE_DISK) {
 			existing_device->raid_level = new_device->raid_level;
 			existing_device->volume_status = new_device->volume_status;
-			if (ctrl_info->logical_volume_rescan_needed)
-				existing_device->rescan = true;
 			memset(existing_device->next_bypass_group, 0, sizeof(existing_device->next_bypass_group));
 			if (!pqi_raid_maps_equal(existing_device->raid_map, new_device->raid_map)) {
 				kfree(existing_device->raid_map);
@@ -2164,6 +2162,20 @@ static inline void pqi_init_device_tmf_work(struct pqi_scsi_dev *device)
 		INIT_WORK(&tmf_work->work_struct, pqi_tmf_worker);
 }
 
+static inline bool pqi_volume_rescan_needed(struct pqi_scsi_dev *device)
+{
+	if (pqi_device_in_remove(device))
+		return false;
+
+	if (device->sdev == NULL)
+		return false;
+
+	if (!scsi_device_online(device->sdev))
+		return false;
+
+	return device->rescan;
+}
+
 static void pqi_update_device_list(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_scsi_dev *new_device_list[], unsigned int num_new_devices)
 {
@@ -2284,9 +2296,13 @@ static void pqi_update_device_list(struct pqi_ctrl_info *ctrl_info,
 		if (device->sdev && device->queue_depth != device->advertised_queue_depth) {
 			device->advertised_queue_depth = device->queue_depth;
 			scsi_change_queue_depth(device->sdev, device->advertised_queue_depth);
-			if (device->rescan) {
-				scsi_rescan_device(device->sdev);
+			spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
+			if (pqi_volume_rescan_needed(device)) {
 				device->rescan = false;
+				spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
+				scsi_rescan_device(device->sdev);
+			} else {
+				spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 			}
 		}
 	}
@@ -2308,8 +2324,6 @@ static void pqi_update_device_list(struct pqi_ctrl_info *ctrl_info,
 		}
 	}
 
-	ctrl_info->logical_volume_rescan_needed = false;
-
 }
 
 static inline bool pqi_is_supported_device(struct pqi_scsi_dev *device)
@@ -3702,6 +3716,21 @@ static bool pqi_ofa_process_event(struct pqi_ctrl_info *ctrl_info,
 	return ack_event;
 }
 
+static void pqi_mark_volumes_for_rescan(struct pqi_ctrl_info *ctrl_info)
+{
+	unsigned long flags;
+	struct pqi_scsi_dev *device;
+
+	spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
+
+	list_for_each_entry(device, &ctrl_info->scsi_device_list, scsi_device_list_entry) {
+		if (pqi_is_logical_device(device) && device->devtype == TYPE_DISK)
+			device->rescan = true;
+	}
+
+	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
+}
+
 static void pqi_disable_raid_bypass(struct pqi_ctrl_info *ctrl_info)
 {
 	unsigned long flags;
@@ -3742,7 +3771,7 @@ static void pqi_event_worker(struct work_struct *work)
 				ack_event = true;
 				rescan_needed = true;
 				if (event->event_type == PQI_EVENT_TYPE_LOGICAL_DEVICE)
-					ctrl_info->logical_volume_rescan_needed = true;
+					pqi_mark_volumes_for_rescan(ctrl_info);
 				else if (event->event_type == PQI_EVENT_TYPE_AIO_STATE_CHANGE)
 					pqi_disable_raid_bypass(ctrl_info);
 			}
-- 
2.43.0.76.g1a87c842ec

