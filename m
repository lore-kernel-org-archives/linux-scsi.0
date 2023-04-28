Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB6D7C77B7E
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Apr 2023 15:38:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346516AbjD1Pid (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Apr 2023 11:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346177AbjD1PiI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Apr 2023 11:38:08 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14BD55FEE
        for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2023 08:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1682696270; x=1714232270;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qQiteBZnMNApMzJjq37F4Wk7Oi9HNXUu+P4qg6GDuGs=;
  b=RvQDksfCK2fUMT7ywcMTCsn03llm1umgoJyo3hugKwLSB/sIF+OyRqb6
   I1Dkw6H2k9daWuMkEpm8XSJASZMn4UQU+Z4b2WE+xo1fYXJ7ML0s7MMn9
   7XnmZnKE7d9U2SI0vP2/Kz4IRLxBv6KZtkRNoatG2xVTz2PcUfaVKbfDc
   IjKJetHAvqhfua7ZulGB0o6Na5VQMSJw6L83R2OOytDcOWTkx9b70dSQm
   GEypLBY/3kXH+mu6u3OMaCtXLA/w4G/UzWimHaJ70yW2nwOxbc7XxJkWV
   7ncQaNAj7C8H8p4TrLUmGuGDA9D62ZEeQxf9k8tn45ASfmqO/DnraiCLZ
   g==;
X-IronPort-AV: E=Sophos;i="5.99,234,1677567600"; 
   d="scan'208";a="223049432"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Apr 2023 08:37:03 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 28 Apr 2023 08:37:03 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Fri, 28 Apr 2023 08:37:02 -0700
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
Subject: [PATCH 07/12] smartpqi: Add support for RAID NCQ priority
Date:   Fri, 28 Apr 2023 10:37:07 -0500
Message-ID: <20230428153712.297638-8-don.brace@microchip.com>
X-Mailer: git-send-email 2.40.1.375.g9ce9dea4e1
In-Reply-To: <20230428153712.297638-1-don.brace@microchip.com>
References: <20230428153712.297638-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Gilbert Wu <Gilbert.Wu@microchip.com>

Enable NCQ priority feature for the RAID path when AIO path
is disabled.

Move function pqi_is_io_high_priority() up to avoid adding a prototype.
Remove unused argument ctrl_info.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Gilbert Wu <Gilbert.Wu@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 89 ++++++++++++++-------------
 1 file changed, 45 insertions(+), 44 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index f76b5a3e0fd1..19a97bbf89b5 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -519,6 +519,36 @@ static inline void pqi_clear_soft_reset_status(struct pqi_ctrl_info *ctrl_info)
 	writeb(status, ctrl_info->soft_reset_status);
 }
 
+static inline bool pqi_is_io_high_priority(struct pqi_scsi_dev *device, struct scsi_cmnd *scmd)
+{
+	bool io_high_prio;
+	int priority_class;
+
+	io_high_prio = false;
+
+	if (device->ncq_prio_enable) {
+		priority_class =
+			IOPRIO_PRIO_CLASS(req_get_ioprio(scsi_cmd_to_rq(scmd)));
+		if (priority_class == IOPRIO_CLASS_RT) {
+			/* Set NCQ priority for read/write commands. */
+			switch (scmd->cmnd[0]) {
+			case WRITE_16:
+			case READ_16:
+			case WRITE_12:
+			case READ_12:
+			case WRITE_10:
+			case READ_10:
+			case WRITE_6:
+			case READ_6:
+				io_high_prio = true;
+				break;
+			}
+		}
+	}
+
+	return io_high_prio;
+}
+
 static int pqi_map_single(struct pci_dev *pci_dev,
 	struct pqi_sg_descriptor *sg_descriptor, void *buffer,
 	size_t buffer_length, enum dma_data_direction data_direction)
@@ -5505,15 +5535,19 @@ static void pqi_raid_io_complete(struct pqi_io_request *io_request,
 	pqi_scsi_done(scmd);
 }
 
-static int pqi_raid_submit_scsi_cmd_with_io_request(
-	struct pqi_ctrl_info *ctrl_info, struct pqi_io_request *io_request,
+static int pqi_raid_submit_io(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_scsi_dev *device, struct scsi_cmnd *scmd,
-	struct pqi_queue_group *queue_group)
+	struct pqi_queue_group *queue_group, bool io_high_prio)
 {
 	int rc;
 	size_t cdb_length;
+	struct pqi_io_request *io_request;
 	struct pqi_raid_path_request *request;
 
+	io_request = pqi_alloc_io_request(ctrl_info, scmd);
+	if (!io_request)
+		return SCSI_MLQUEUE_HOST_BUSY;
+
 	io_request->io_complete_callback = pqi_raid_io_complete;
 	io_request->scmd = scmd;
 
@@ -5523,6 +5557,7 @@ static int pqi_raid_submit_scsi_cmd_with_io_request(
 	request->header.iu_type = PQI_REQUEST_IU_RAID_PATH_IO;
 	put_unaligned_le32(scsi_bufflen(scmd), &request->buffer_length);
 	request->task_attribute = SOP_TASK_ATTRIBUTE_SIMPLE;
+	request->command_priority = io_high_prio;
 	put_unaligned_le16(io_request->index, &request->request_id);
 	request->error_index = request->request_id;
 	memcpy(request->lun_number, device->scsi3addr, sizeof(request->lun_number));
@@ -5588,14 +5623,11 @@ static inline int pqi_raid_submit_scsi_cmd(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_scsi_dev *device, struct scsi_cmnd *scmd,
 	struct pqi_queue_group *queue_group)
 {
-	struct pqi_io_request *io_request;
+	bool io_high_prio;
 
-	io_request = pqi_alloc_io_request(ctrl_info, scmd);
-	if (!io_request)
-		return SCSI_MLQUEUE_HOST_BUSY;
+	io_high_prio = pqi_is_io_high_priority(device, scmd);
 
-	return pqi_raid_submit_scsi_cmd_with_io_request(ctrl_info, io_request,
-		device, scmd, queue_group);
+	return pqi_raid_submit_io(ctrl_info, device, scmd, queue_group, io_high_prio);
 }
 
 static bool pqi_raid_bypass_retry_needed(struct pqi_io_request *io_request)
@@ -5640,44 +5672,13 @@ static void pqi_aio_io_complete(struct pqi_io_request *io_request,
 	pqi_scsi_done(scmd);
 }
 
-static inline bool pqi_is_io_high_priority(struct pqi_ctrl_info *ctrl_info,
-	struct pqi_scsi_dev *device, struct scsi_cmnd *scmd)
-{
-	bool io_high_prio;
-	int priority_class;
-
-	io_high_prio = false;
-
-	if (device->ncq_prio_enable) {
-		priority_class =
-			IOPRIO_PRIO_CLASS(req_get_ioprio(scsi_cmd_to_rq(scmd)));
-		if (priority_class == IOPRIO_CLASS_RT) {
-			/* Set NCQ priority for read/write commands. */
-			switch (scmd->cmnd[0]) {
-			case WRITE_16:
-			case READ_16:
-			case WRITE_12:
-			case READ_12:
-			case WRITE_10:
-			case READ_10:
-			case WRITE_6:
-			case READ_6:
-				io_high_prio = true;
-				break;
-			}
-		}
-	}
-
-	return io_high_prio;
-}
-
 static inline int pqi_aio_submit_scsi_cmd(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_scsi_dev *device, struct scsi_cmnd *scmd,
 	struct pqi_queue_group *queue_group)
 {
 	bool io_high_prio;
 
-	io_high_prio = pqi_is_io_high_priority(ctrl_info, device, scmd);
+	io_high_prio = pqi_is_io_high_priority(device, scmd);
 
 	return pqi_aio_submit_io(ctrl_info, scmd, device->aio_handle,
 		scmd->cmnd, scmd->cmd_len, queue_group, NULL,
@@ -5695,10 +5696,10 @@ static int pqi_aio_submit_io(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_aio_path_request *request;
 	struct pqi_scsi_dev *device;
 
-	device = scmd->device->hostdata;
 	io_request = pqi_alloc_io_request(ctrl_info, scmd);
 	if (!io_request)
 		return SCSI_MLQUEUE_HOST_BUSY;
+
 	io_request->io_complete_callback = pqi_aio_io_complete;
 	io_request->scmd = scmd;
 	io_request->raid_bypass = raid_bypass;
@@ -5713,6 +5714,7 @@ static int pqi_aio_submit_io(struct pqi_ctrl_info *ctrl_info,
 	request->command_priority = io_high_prio;
 	put_unaligned_le16(io_request->index, &request->request_id);
 	request->error_index = request->request_id;
+	device = scmd->device->hostdata;
 	if (!pqi_is_logical_device(device) && ctrl_info->multi_lun_device_supported)
 		put_unaligned_le64(((scmd->device->lun) << 8), &request->lun_number);
 	if (cdb_length > sizeof(request->cdb))
@@ -7367,8 +7369,7 @@ static ssize_t pqi_sas_ncq_prio_enable_store(struct device *dev,
 		return -ENODEV;
 	}
 
-	if (!device->ncq_prio_support ||
-		!device->is_physical_device) {
+	if (!device->ncq_prio_support) {
 		spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 		return -EINVAL;
 	}
-- 
2.40.1.375.g9ce9dea4e1

