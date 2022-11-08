Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF1CBC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Nov 2022 19:19:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbiKHTTU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Nov 2022 14:19:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiKHTTJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2022 14:19:09 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64EFF10FF4
        for <linux-scsi@vger.kernel.org>; Tue,  8 Nov 2022 11:19:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667935148; x=1699471148;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xfsLnDVEQ1dtkSdh+rKWE7Ambxdf8B/AhTAHRQ1rbSA=;
  b=vwwD3a458VWAE1I9s0g/UxUoPrJP5T53B4/e9q3ON8CQ/k7BZcwbsLUv
   iw83LmOnFuEtCl4apmkD+a7wlU1zBGMFIKWnhPCl9gdvsq4eDn4rtSq7U
   rYU8ApmpOuPPiFIVaux9zXzkncrS1XdL7J/cQhhFoYtaSK1GkbeKcUuy8
   njN31ufX4P2KSzKiAirLMGlevEMFNoSteujTfg1d6c9cUqbgMEUn4XyAM
   JTTLjoOhzaQkWujEQzwppI50PFtjZPyOaoaFDcBx+TLKYhymnJK/kQMu1
   8Qr2WVqrabTYWVSxYNUX9vC1r2H+AVy0d1RLkuE7gZpSm1ATaeZgPYmfH
   A==;
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="122430385"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Nov 2022 12:19:07 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 8 Nov 2022 12:19:07 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Tue, 8 Nov 2022 12:19:06 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (8.15.2/8.15.2/Debian-22ubuntu3) with ESMTP id 2A8JLwAf322619;
        Tue, 8 Nov 2022 13:21:58 -0600
Received: (from brace@localhost)
        by brunhilda.pdev.net (8.15.2/8.15.2/Submit) id 2A8JLwDx322618;
        Tue, 8 Nov 2022 13:21:58 -0600
X-Authentication-Warning: brunhilda.pdev.net: brace set sender to don.brace@microchip.com using -f
Subject: [PATCH 5/8] smartpqi: correct device removal for multiactuator
 devices
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <kumar.meiyappan@microchip.com>, <jeremy.reeves@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 8 Nov 2022 13:21:58 -0600
Message-ID: <166793531872.322537.9003385780343419275.stgit@brunhilda>
In-Reply-To: <166793527478.322537.6742384652975581503.stgit@brunhilda>
References: <166793527478.322537.6742384652975581503.stgit@brunhilda>
User-Agent: StGit/1.5.dev2+g9ce680a52bd9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kumar Meiyappan <Kumar.Meiyappan@microchip.com>

Correct device count for multi-actuator drives which can cause
kernel panics.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike Mcgowan <mike.mcgowan@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Kumar Meiyappan <Kumar.Meiyappan@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |    2 +-
 drivers/scsi/smartpqi/smartpqi_init.c |   33 ++++++++++++++++++++++++---------
 2 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 8cdf4d2476dd..af27bb0f3133 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1130,7 +1130,7 @@ struct pqi_scsi_dev {
 	u8	phy_id;
 	u8	ncq_prio_enable;
 	u8	ncq_prio_support;
-	u8	multi_lun_device_lun_count;
+	u8	lun_count;
 	bool	raid_bypass_configured;	/* RAID bypass configured */
 	bool	raid_bypass_enabled;	/* RAID bypass enabled */
 	u32	next_bypass_group[RAID_MAP_MAX_DATA_DISKS_PER_ROW];
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 20fc6c8044ac..e82f4de46ea7 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1623,9 +1623,7 @@ static int pqi_get_physical_device_info(struct pqi_ctrl_info *ctrl_info,
 		&id_phys->alternate_paths_phys_connector,
 		sizeof(device->phys_connector));
 	device->bay = id_phys->phys_bay_in_box;
-	device->multi_lun_device_lun_count = id_phys->multi_lun_device_lun_count;
-	if (!device->multi_lun_device_lun_count)
-		device->multi_lun_device_lun_count = 1;
+	device->lun_count = id_phys->multi_lun_device_lun_count;
 	if ((id_phys->even_more_flags & PQI_DEVICE_PHY_MAP_SUPPORTED) &&
 		id_phys->phy_count)
 		device->phy_id =
@@ -1759,7 +1757,7 @@ static bool pqi_keep_device_offline(struct pqi_ctrl_info *ctrl_info,
 	return offline;
 }
 
-static int pqi_get_device_info(struct pqi_ctrl_info *ctrl_info,
+static int pqi_get_device_info_phys_logical(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_scsi_dev *device,
 	struct bmic_identify_physical_device *id_phys)
 {
@@ -1776,6 +1774,20 @@ static int pqi_get_device_info(struct pqi_ctrl_info *ctrl_info,
 	return rc;
 }
 
+static int pqi_get_device_info(struct pqi_ctrl_info *ctrl_info,
+	struct pqi_scsi_dev *device,
+	struct bmic_identify_physical_device *id_phys)
+{
+	int rc;
+
+	rc = pqi_get_device_info_phys_logical(ctrl_info, device, id_phys);
+
+	if (rc == 0 && device->lun_count == 0)
+		device->lun_count = 1;
+
+	return rc;
+}
+
 static void pqi_show_volume_status(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_scsi_dev *device)
 {
@@ -1910,7 +1922,7 @@ static inline void pqi_remove_device(struct pqi_ctrl_info *ctrl_info, struct pqi
 	int rc;
 	int lun;
 
-	for (lun = 0; lun < device->multi_lun_device_lun_count; lun++) {
+	for (lun = 0; lun < device->lun_count; lun++) {
 		rc = pqi_device_wait_for_pending_io(ctrl_info, device, lun,
 			PQI_REMOVE_DEVICE_PENDING_IO_TIMEOUT_MSECS);
 		if (rc)
@@ -2089,6 +2101,7 @@ static void pqi_scsi_update_device(struct pqi_ctrl_info *ctrl_info,
 	existing_device->sas_address = new_device->sas_address;
 	existing_device->queue_depth = new_device->queue_depth;
 	existing_device->device_offline = false;
+	existing_device->lun_count = new_device->lun_count;
 
 	if (pqi_is_logical_device(existing_device)) {
 		existing_device->is_external_raid_device = new_device->is_external_raid_device;
@@ -2121,10 +2134,6 @@ static void pqi_scsi_update_device(struct pqi_ctrl_info *ctrl_info,
 		existing_device->phy_connected_dev_type = new_device->phy_connected_dev_type;
 		memcpy(existing_device->box, new_device->box, sizeof(existing_device->box));
 		memcpy(existing_device->phys_connector, new_device->phys_connector, sizeof(existing_device->phys_connector));
-
-		existing_device->multi_lun_device_lun_count = new_device->multi_lun_device_lun_count;
-		if (existing_device->multi_lun_device_lun_count == 0)
-			existing_device->multi_lun_device_lun_count = 1;
 	}
 }
 
@@ -6502,6 +6511,12 @@ static void pqi_slave_destroy(struct scsi_device *sdev)
 		return;
 	}
 
+	device->lun_count--;
+	if (device->lun_count > 0) {
+		mutex_unlock(&ctrl_info->scan_mutex);
+		return;
+	}
+
 	spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
 	list_del(&device->scsi_device_list_entry);
 	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);

