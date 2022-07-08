Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12699C43334
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jul 2022 18:46:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239645AbiGHSqI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 14:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237887AbiGHSqF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 14:46:05 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A411F7E02A
        for <linux-scsi@vger.kernel.org>; Fri,  8 Jul 2022 11:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657305966; x=1688841966;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=G40Hrl0WaJ706ecMQ2MPlPKe2MX3jTdT55GqGzFDmL8=;
  b=0uja6W/ZggJmOzM1hmpc/89bVeyJdyjAaf0ldHI5RlRn6tPGduTXitM3
   fAsJudZudsSzKk7evaz2MErnu3HNPh019INk7tvVP6vLqDGG//fjrn+Lm
   LM8xQhH+txb0TkfuvJ25h3VYInHj5WttZ43CjKs8vY3esgFYzVFpYCTGr
   aZInoX0p577j7frTAHN5xHeNhwN91VOFS3OnKEqVVnwCoQuXfmQPdT7cc
   +S1ZkgNy2a3LFFxiFdSpLVrJ0CcGMopDUtexhAR2LyxNjbc+8l896Uc24
   qs5qbQZuKxABmVW3N9Ck5e92HGOykTxfZBUyu2WbzxreQecqpwDV0LROb
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="171374377"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Jul 2022 11:46:05 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 8 Jul 2022 11:46:03 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Fri, 8 Jul 2022 11:46:03 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (8.15.2/8.15.2/Debian-22ubuntu3) with ESMTP id 268IlANQ177337;
        Fri, 8 Jul 2022 13:47:10 -0500
Received: (from brace@localhost)
        by brunhilda.pdev.net (8.15.2/8.15.2/Submit) id 268IlArk177336;
        Fri, 8 Jul 2022 13:47:10 -0500
X-Authentication-Warning: brunhilda.pdev.net: brace set sender to don.brace@microchip.com using -f
Subject: [PATCH V2 05/16] smartpqi: add driver support for multi-LUN devices
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <kumar.meiyappan@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 8 Jul 2022 13:47:10 -0500
Message-ID: <165730603067.177165.14016422176841798336.stgit@brunhilda>
In-Reply-To: <165730597930.177165.11663580730429681919.stgit@brunhilda>
References: <165730597930.177165.11663580730429681919.stgit@brunhilda>
User-Agent: StGit/1.5.dev2+g9ce680a52bd9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kumar Meiyappan <Kumar.Meiyappan@microchip.com>

Add driver support for up to 256 LUNs per device.

Update AIO path to pass the appropriate LUN number for base-code to
target the correct LUN.

Update RAID IO path to pass the appropriate LUN number for FW to target
the correct LUN.

Pass the correct LUN number while doing a LUN reset.

Count the outstanding commands based on LUN number.
While removing a Multi-LUN device, wait for all outstanding commands to
complete for all LUNs.

Add Feature bit support.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Kumar Meiyappan <Kumar.Meiyappan@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |   15 ++++-
 drivers/scsi/smartpqi/smartpqi_init.c |   92 ++++++++++++++++++++++-----------
 2 files changed, 72 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 49895c6ca64c..aa8663e1b98b 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -293,7 +293,8 @@ struct pqi_raid_path_request {
 	u8	additional_cdb_bytes_usage : 3;
 	u8	reserved5 : 3;
 	u8	cdb[16];
-	u8	reserved6[12];
+	u8	reserved6[11];
+	u8	ml_device_lun_number;
 	__le32	timeout;
 	struct pqi_sg_descriptor sg_descriptors[PQI_MAX_EMBEDDED_SG_DESCRIPTORS];
 };
@@ -467,7 +468,8 @@ struct pqi_task_management_request {
 	struct pqi_iu_header header;
 	__le16	request_id;
 	__le16	nexus_id;
-	u8	reserved[2];
+	u8	reserved;
+	u8	ml_device_lun_number;
 	__le16  timeout;
 	u8	lun_number[8];
 	__le16	protocol_specific;
@@ -864,7 +866,8 @@ struct pqi_config_table_firmware_features {
 #define PQI_FIRMWARE_FEATURE_UNIQUE_WWID_IN_REPORT_PHYS_LUN	16
 #define PQI_FIRMWARE_FEATURE_FW_TRIAGE				17
 #define PQI_FIRMWARE_FEATURE_RPL_EXTENDED_FORMAT_4_5		18
-#define PQI_FIRMWARE_FEATURE_MAXIMUM				18
+#define PQI_FIRMWARE_FEATURE_MULTI_LUN_DEVICE_SUPPORT           21
+#define PQI_FIRMWARE_FEATURE_MAXIMUM                            21
 
 struct pqi_config_table_debug {
 	struct pqi_config_table_section_header header;
@@ -1082,6 +1085,8 @@ struct pqi_stream_data {
 	u32	last_accessed;
 };
 
+#define PQI_MAX_LUNS_PER_DEVICE         256
+
 struct pqi_scsi_dev {
 	int	devtype;		/* as reported by INQUIRY command */
 	u8	device_type;		/* as reported by */
@@ -1125,6 +1130,7 @@ struct pqi_scsi_dev {
 	u8	phy_id;
 	u8	ncq_prio_enable;
 	u8	ncq_prio_support;
+	u8	multi_lun_device_lun_count;
 	bool	raid_bypass_configured;	/* RAID bypass configured */
 	bool	raid_bypass_enabled;	/* RAID bypass enabled */
 	u32	next_bypass_group[RAID_MAP_MAX_DATA_DISKS_PER_ROW];
@@ -1140,7 +1146,7 @@ struct pqi_scsi_dev {
 	struct list_head delete_list_entry;
 
 	struct pqi_stream_data stream_data[NUM_STREAMS_PER_LUN];
-	atomic_t scsi_cmds_outstanding;
+	atomic_t scsi_cmds_outstanding[PQI_MAX_LUNS_PER_DEVICE];
 	atomic_t raid_bypass_cnt;
 };
 
@@ -1333,6 +1339,7 @@ struct pqi_ctrl_info {
 	u8		tmf_iu_timeout_supported : 1;
 	u8		firmware_triage_supported : 1;
 	u8		rpl_extended_format_4_5_supported : 1;
+	u8		multi_lun_device_supported : 1;
 	u8		enable_r1_writes : 1;
 	u8		enable_r5_writes : 1;
 	u8		enable_r6_writes : 1;
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index b13233dbe46c..11a8e224fe84 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -94,7 +94,7 @@ static void pqi_ofa_setup_host_buffer(struct pqi_ctrl_info *ctrl_info);
 static void pqi_ofa_free_host_buffer(struct pqi_ctrl_info *ctrl_info);
 static int pqi_ofa_host_memory_update(struct pqi_ctrl_info *ctrl_info);
 static int pqi_device_wait_for_pending_io(struct pqi_ctrl_info *ctrl_info,
-	struct pqi_scsi_dev *device, unsigned long timeout_msecs);
+	struct pqi_scsi_dev *device, u8 lun, unsigned long timeout_msecs);
 
 /* for flags argument to pqi_submit_raid_request_synchronous() */
 #define PQI_SYNC_FLAGS_INTERRUPTABLE	0x1
@@ -1597,7 +1597,9 @@ static int pqi_get_physical_device_info(struct pqi_ctrl_info *ctrl_info,
 		&id_phys->alternate_paths_phys_connector,
 		sizeof(device->phys_connector));
 	device->bay = id_phys->phys_bay_in_box;
-
+	device->multi_lun_device_lun_count = id_phys->multi_lun_device_lun_count;
+	if (!device->multi_lun_device_lun_count)
+		device->multi_lun_device_lun_count = 1;
 	if ((id_phys->even_more_flags & PQI_DEVICE_PHY_MAP_SUPPORTED) &&
 		id_phys->phy_count)
 		device->phy_id =
@@ -1880,15 +1882,18 @@ static int pqi_add_device(struct pqi_ctrl_info *ctrl_info,
 static inline void pqi_remove_device(struct pqi_ctrl_info *ctrl_info, struct pqi_scsi_dev *device)
 {
 	int rc;
+	int lun;
 
-	rc = pqi_device_wait_for_pending_io(ctrl_info, device,
-		PQI_REMOVE_DEVICE_PENDING_IO_TIMEOUT_MSECS);
-	if (rc)
-		dev_err(&ctrl_info->pci_dev->dev,
-			"scsi %d:%d:%d:%d removing device with %d outstanding command(s)\n",
-			ctrl_info->scsi_host->host_no, device->bus,
-			device->target, device->lun,
-			atomic_read(&device->scsi_cmds_outstanding));
+	for (lun = 0; lun < device->multi_lun_device_lun_count; lun++) {
+		rc = pqi_device_wait_for_pending_io(ctrl_info, device, lun,
+			PQI_REMOVE_DEVICE_PENDING_IO_TIMEOUT_MSECS);
+		if (rc)
+			dev_err(&ctrl_info->pci_dev->dev,
+				"scsi %d:%d:%d:%d removing device with %d outstanding command(s)\n",
+				ctrl_info->scsi_host->host_no, device->bus,
+				device->target, lun,
+				atomic_read(&device->scsi_cmds_outstanding[lun]));
+	}
 
 	if (pqi_is_logical_device(device))
 		scsi_remove_device(device->sdev);
@@ -2061,6 +2066,9 @@ static void pqi_scsi_update_device(struct pqi_ctrl_info *ctrl_info,
 	existing_device->box_index = new_device->box_index;
 	existing_device->phys_box_on_bus = new_device->phys_box_on_bus;
 	existing_device->phy_connected_dev_type = new_device->phy_connected_dev_type;
+	existing_device->multi_lun_device_lun_count = new_device->multi_lun_device_lun_count;
+	if (!existing_device->multi_lun_device_lun_count)
+		existing_device->multi_lun_device_lun_count = 1;
 	memcpy(existing_device->box, new_device->box,
 		sizeof(existing_device->box));
 	memcpy(existing_device->phys_connector, new_device->phys_connector,
@@ -5463,6 +5471,7 @@ static int pqi_raid_submit_scsi_cmd_with_io_request(
 	put_unaligned_le16(io_request->index, &request->request_id);
 	request->error_index = request->request_id;
 	memcpy(request->lun_number, device->scsi3addr, sizeof(request->lun_number));
+	request->ml_device_lun_number = (u8)scmd->device->lun;
 
 	cdb_length = min_t(size_t, scmd->cmd_len, sizeof(request->cdb));
 	memcpy(request->cdb, scmd->cmnd, cdb_length);
@@ -5627,7 +5636,9 @@ static int pqi_aio_submit_io(struct pqi_ctrl_info *ctrl_info,
 	int rc;
 	struct pqi_io_request *io_request;
 	struct pqi_aio_path_request *request;
+	struct pqi_scsi_dev *device;
 
+	device = scmd->device->hostdata;
 	io_request = pqi_alloc_io_request(ctrl_info);
 	io_request->io_complete_callback = pqi_aio_io_complete;
 	io_request->scmd = scmd;
@@ -5643,6 +5654,8 @@ static int pqi_aio_submit_io(struct pqi_ctrl_info *ctrl_info,
 	request->command_priority = io_high_prio;
 	put_unaligned_le16(io_request->index, &request->request_id);
 	request->error_index = request->request_id;
+	if (!pqi_is_logical_device(device) && ctrl_info->multi_lun_device_supported)
+		put_unaligned_le64(((scmd->device->lun) << 8), &request->lun_number);
 	if (cdb_length > sizeof(request->cdb))
 		cdb_length = sizeof(request->cdb);
 	request->cdb_length = cdb_length;
@@ -5852,7 +5865,7 @@ void pqi_prep_for_scsi_done(struct scsi_cmnd *scmd)
 		return;
 	}
 
-	atomic_dec(&device->scsi_cmds_outstanding);
+	atomic_dec(&device->scsi_cmds_outstanding[scmd->device->lun]);
 }
 
 static bool pqi_is_parity_write_stream(struct pqi_ctrl_info *ctrl_info,
@@ -5947,7 +5960,7 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scm
 		return 0;
 	}
 
-	atomic_inc(&device->scsi_cmds_outstanding);
+	atomic_inc(&device->scsi_cmds_outstanding[scmd->device->lun]);
 
 	ctrl_info = shost_to_hba(shost);
 
@@ -5993,7 +6006,7 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scm
 
 out:
 	if (rc)
-		atomic_dec(&device->scsi_cmds_outstanding);
+		atomic_dec(&device->scsi_cmds_outstanding[scmd->device->lun]);
 
 	return rc;
 }
@@ -6133,7 +6146,7 @@ static void pqi_fail_io_queued_for_device(struct pqi_ctrl_info *ctrl_info,
 #define PQI_PENDING_IO_WARNING_TIMEOUT_SECS	10
 
 static int pqi_device_wait_for_pending_io(struct pqi_ctrl_info *ctrl_info,
-	struct pqi_scsi_dev *device, unsigned long timeout_msecs)
+	struct pqi_scsi_dev *device, u8 lun, unsigned long timeout_msecs)
 {
 	int cmds_outstanding;
 	unsigned long start_jiffies;
@@ -6143,7 +6156,7 @@ static int pqi_device_wait_for_pending_io(struct pqi_ctrl_info *ctrl_info,
 	start_jiffies = jiffies;
 	warning_timeout = (PQI_PENDING_IO_WARNING_TIMEOUT_SECS * HZ) + start_jiffies;
 
-	while ((cmds_outstanding = atomic_read(&device->scsi_cmds_outstanding)) > 0) {
+	while ((cmds_outstanding = atomic_read(&device->scsi_cmds_outstanding[lun])) > 0) {
 		pqi_check_ctrl_health(ctrl_info);
 		if (pqi_ctrl_offline(ctrl_info))
 			return -ENXIO;
@@ -6152,14 +6165,14 @@ static int pqi_device_wait_for_pending_io(struct pqi_ctrl_info *ctrl_info,
 			dev_err(&ctrl_info->pci_dev->dev,
 				"scsi %d:%d:%d:%d: timed out after %lu seconds waiting for %d outstanding command(s)\n",
 				ctrl_info->scsi_host->host_no, device->bus, device->target,
-				device->lun, msecs_waiting / 1000, cmds_outstanding);
+				lun, msecs_waiting / 1000, cmds_outstanding);
 			return -ETIMEDOUT;
 		}
 		if (time_after(jiffies, warning_timeout)) {
 			dev_warn(&ctrl_info->pci_dev->dev,
 				"scsi %d:%d:%d:%d: waiting %lu seconds for %d outstanding command(s)\n",
 				ctrl_info->scsi_host->host_no, device->bus, device->target,
-				device->lun, msecs_waiting / 1000, cmds_outstanding);
+				lun, msecs_waiting / 1000, cmds_outstanding);
 			warning_timeout = (PQI_PENDING_IO_WARNING_TIMEOUT_SECS * HZ) + jiffies;
 		}
 		usleep_range(1000, 2000);
@@ -6179,7 +6192,7 @@ static void pqi_lun_reset_complete(struct pqi_io_request *io_request,
 #define PQI_LUN_RESET_POLL_COMPLETION_SECS	10
 
 static int pqi_wait_for_lun_reset_completion(struct pqi_ctrl_info *ctrl_info,
-	struct pqi_scsi_dev *device, struct completion *wait)
+	struct pqi_scsi_dev *device, u8 lun, struct completion *wait)
 {
 	int rc;
 	unsigned int wait_secs;
@@ -6201,10 +6214,10 @@ static int pqi_wait_for_lun_reset_completion(struct pqi_ctrl_info *ctrl_info,
 		}
 
 		wait_secs += PQI_LUN_RESET_POLL_COMPLETION_SECS;
-		cmds_outstanding = atomic_read(&device->scsi_cmds_outstanding);
+		cmds_outstanding = atomic_read(&device->scsi_cmds_outstanding[lun]);
 		dev_warn(&ctrl_info->pci_dev->dev,
 			"scsi %d:%d:%d:%d: waiting %u seconds for LUN reset to complete (%d command(s) outstanding)\n",
-			ctrl_info->scsi_host->host_no, device->bus, device->target, device->lun, wait_secs, cmds_outstanding);
+			ctrl_info->scsi_host->host_no, device->bus, device->target, lun, wait_secs, cmds_outstanding);
 	}
 
 	return rc;
@@ -6212,13 +6225,15 @@ static int pqi_wait_for_lun_reset_completion(struct pqi_ctrl_info *ctrl_info,
 
 #define PQI_LUN_RESET_FIRMWARE_TIMEOUT_SECS	30
 
-static int pqi_lun_reset(struct pqi_ctrl_info *ctrl_info, struct pqi_scsi_dev *device)
+static int pqi_lun_reset(struct pqi_ctrl_info *ctrl_info, struct scsi_cmnd *scmd)
 {
 	int rc;
 	struct pqi_io_request *io_request;
 	DECLARE_COMPLETION_ONSTACK(wait);
 	struct pqi_task_management_request *request;
+	struct pqi_scsi_dev *device;
 
+	device = scmd->device->hostdata;
 	io_request = pqi_alloc_io_request(ctrl_info);
 	io_request->io_complete_callback = pqi_lun_reset_complete;
 	io_request->context = &wait;
@@ -6232,6 +6247,8 @@ static int pqi_lun_reset(struct pqi_ctrl_info *ctrl_info, struct pqi_scsi_dev *d
 	put_unaligned_le16(io_request->index, &request->request_id);
 	memcpy(request->lun_number, device->scsi3addr,
 		sizeof(request->lun_number));
+	if (!pqi_is_logical_device(device) && ctrl_info->multi_lun_device_supported)
+		request->ml_device_lun_number = (u8)scmd->device->lun;
 	request->task_management_function = SOP_TASK_MANAGEMENT_LUN_RESET;
 	if (ctrl_info->tmf_iu_timeout_supported)
 		put_unaligned_le16(PQI_LUN_RESET_FIRMWARE_TIMEOUT_SECS, &request->timeout);
@@ -6239,7 +6256,7 @@ static int pqi_lun_reset(struct pqi_ctrl_info *ctrl_info, struct pqi_scsi_dev *d
 	pqi_start_io(ctrl_info, &ctrl_info->queue_groups[PQI_DEFAULT_QUEUE_GROUP], RAID_PATH,
 		io_request);
 
-	rc = pqi_wait_for_lun_reset_completion(ctrl_info, device, &wait);
+	rc = pqi_wait_for_lun_reset_completion(ctrl_info, device, (u8)scmd->device->lun, &wait);
 	if (rc == 0)
 		rc = io_request->status;
 
@@ -6253,15 +6270,17 @@ static int pqi_lun_reset(struct pqi_ctrl_info *ctrl_info, struct pqi_scsi_dev *d
 #define PQI_LUN_RESET_PENDING_IO_TIMEOUT_MSECS		(10 * 60 * 1000)
 #define PQI_LUN_RESET_FAILED_PENDING_IO_TIMEOUT_MSECS	(2 * 60 * 1000)
 
-static int pqi_lun_reset_with_retries(struct pqi_ctrl_info *ctrl_info, struct pqi_scsi_dev *device)
+static int pqi_lun_reset_with_retries(struct pqi_ctrl_info *ctrl_info, struct scsi_cmnd *scmd)
 {
 	int reset_rc;
 	int wait_rc;
 	unsigned int retries;
 	unsigned long timeout_msecs;
+	struct pqi_scsi_dev *device;
 
+	device = scmd->device->hostdata;
 	for (retries = 0;;) {
-		reset_rc = pqi_lun_reset(ctrl_info, device);
+		reset_rc = pqi_lun_reset(ctrl_info, scmd);
 		if (reset_rc == 0 || reset_rc == -ENODEV || ++retries > PQI_LUN_RESET_RETRIES)
 			break;
 		msleep(PQI_LUN_RESET_RETRY_INTERVAL_MSECS);
@@ -6270,18 +6289,19 @@ static int pqi_lun_reset_with_retries(struct pqi_ctrl_info *ctrl_info, struct pq
 	timeout_msecs = reset_rc ? PQI_LUN_RESET_FAILED_PENDING_IO_TIMEOUT_MSECS :
 		PQI_LUN_RESET_PENDING_IO_TIMEOUT_MSECS;
 
-	wait_rc = pqi_device_wait_for_pending_io(ctrl_info, device, timeout_msecs);
+	wait_rc = pqi_device_wait_for_pending_io(ctrl_info, device, scmd->device->lun, timeout_msecs);
 	if (wait_rc && reset_rc == 0)
 		reset_rc = wait_rc;
 
 	return reset_rc == 0 ? SUCCESS : FAILED;
 }
 
-static int pqi_device_reset(struct pqi_ctrl_info *ctrl_info,
-	struct pqi_scsi_dev *device)
+static int pqi_device_reset(struct pqi_ctrl_info *ctrl_info, struct scsi_cmnd *scmd)
 {
 	int rc;
+	struct pqi_scsi_dev *device;
 
+	device = scmd->device->hostdata;
 	pqi_ctrl_block_requests(ctrl_info);
 	pqi_ctrl_wait_until_quiesced(ctrl_info);
 	pqi_fail_io_queued_for_device(ctrl_info, device);
@@ -6289,7 +6309,7 @@ static int pqi_device_reset(struct pqi_ctrl_info *ctrl_info,
 	if (rc)
 		rc = FAILED;
 	else
-		rc = pqi_lun_reset_with_retries(ctrl_info, device);
+		rc = pqi_lun_reset_with_retries(ctrl_info, scmd);
 	pqi_ctrl_unblock_requests(ctrl_info);
 
 	return rc;
@@ -6311,18 +6331,18 @@ static int pqi_eh_device_reset_handler(struct scsi_cmnd *scmd)
 	dev_err(&ctrl_info->pci_dev->dev,
 		"resetting scsi %d:%d:%d:%d due to cmd 0x%02x\n",
 		shost->host_no,
-		device->bus, device->target, device->lun,
+		device->bus, device->target, (u32)scmd->device->lun,
 		scmd->cmd_len > 0 ? scmd->cmnd[0] : 0xff);
 
 	pqi_check_ctrl_health(ctrl_info);
 	if (pqi_ctrl_offline(ctrl_info))
 		rc = FAILED;
 	else
-		rc = pqi_device_reset(ctrl_info, device);
+		rc = pqi_device_reset(ctrl_info, scmd);
 
 	dev_err(&ctrl_info->pci_dev->dev,
 		"reset of scsi %d:%d:%d:%d: %s\n",
-		shost->host_no, device->bus, device->target, device->lun,
+		shost->host_no, device->bus, device->target, (u32)scmd->device->lun,
 		rc == SUCCESS ? "SUCCESS" : "FAILED");
 
 	mutex_unlock(&ctrl_info->lun_reset_mutex);
@@ -7296,6 +7316,7 @@ static int pqi_register_scsi(struct pqi_ctrl_info *ctrl_info)
 	shost->this_id = -1;
 	shost->max_channel = PQI_MAX_BUS;
 	shost->max_cmd_len = MAX_COMMAND_SIZE;
+	shost->max_lun = PQI_MAX_LUNS_PER_DEVICE;
 	shost->max_lun = ~0;
 	shost->max_id = ~0;
 	shost->max_sectors = ctrl_info->max_sectors;
@@ -7643,6 +7664,9 @@ static void pqi_ctrl_update_feature_flags(struct pqi_ctrl_info *ctrl_info,
 	case PQI_FIRMWARE_FEATURE_RPL_EXTENDED_FORMAT_4_5:
 		ctrl_info->rpl_extended_format_4_5_supported = firmware_feature->enabled;
 		break;
+	case PQI_FIRMWARE_FEATURE_MULTI_LUN_DEVICE_SUPPORT:
+		ctrl_info->multi_lun_device_supported = firmware_feature->enabled;
+		break;
 	}
 
 	pqi_firmware_feature_status(ctrl_info, firmware_feature);
@@ -7743,6 +7767,11 @@ static struct pqi_firmware_feature pqi_firmware_features[] = {
 		.feature_bit = PQI_FIRMWARE_FEATURE_RPL_EXTENDED_FORMAT_4_5,
 		.feature_status = pqi_ctrl_update_feature_flags,
 	},
+	{
+		.feature_name = "Multi-LUN Target",
+		.feature_bit = PQI_FIRMWARE_FEATURE_MULTI_LUN_DEVICE_SUPPORT,
+		.feature_status = pqi_ctrl_update_feature_flags,
+	},
 };
 
 static void pqi_process_firmware_features(
@@ -7844,6 +7873,7 @@ static void pqi_ctrl_reset_config(struct pqi_ctrl_info *ctrl_info)
 	ctrl_info->tmf_iu_timeout_supported = false;
 	ctrl_info->firmware_triage_supported = false;
 	ctrl_info->rpl_extended_format_4_5_supported = false;
+	ctrl_info->multi_lun_device_supported = false;
 }
 
 static int pqi_process_config_table(struct pqi_ctrl_info *ctrl_info)

