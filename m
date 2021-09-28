Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1319FC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 23:54:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1E5B6136F
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 23:54:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243346AbhI1X40 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 19:56:26 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:8279 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243210AbhI1X4X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 19:56:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632873283; x=1664409283;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+qx/edq93aSRyxSlXMkVhY1cCFBQYOv/snC62sVz344=;
  b=cGPIdEenLp5Cc/+TeOun9MMEPynMmGa6lqCIR06Kki3xScypUhGB2U38
   k8UNsFhvKZqW23DbHQlzwzyyFpKA2itGSQ0TogB3+eO+WxWSX9wRUNTCA
   ZuMbDGAEtRW0ZaWnvz6zToPJ3zRKLALS6hr1vgYWCwePPVT6tGoZUHZaM
   d0QhnkndhIg5jA8yk+SBLvmCwX5CDSJu1Tc5PnSkVutaVYTo3iCtijFhW
   3iJcQdmmJcNW+tOhidNc+MYtrPh1OD+3imTwrg8yUoXd4J0JXLrM3Xlgg
   twS7CZi2CWJp/IFBhtGxHb5KT8bs7HDhZ6uBzPkAlqV1RyJ9kf1P6ILzT
   Q==;
IronPort-SDR: skraNHxYpFzEO+WRtMne7VNJ1Y0IszGet+4CCfx5vbD7o39+V03qqLcf6A1VZhkKBxzW8VJ22G
 1BuaUCmfeplSo7w63TgqbO6M0EtHpYWR/RX81WHH9zHG+cK05cVllhXagCJWYftTSEclPEd5PE
 CQo5H5oY7qLGP4dPEf1d5oVYffa1nuFpo7l2iSQ6FzAtt7NJpF14d0NDLB62i+IYscTHej2Bhr
 VH6BcHjMcxm9zyPAVSyDzdT3ZpvZSf4MQp1BNskpI115/G+DOn1K2yv+eG4aIAEWNK/yyv7Y8G
 JDoGXup7ed0XABDM5IbTeT8Y
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="138333250"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Sep 2021 16:54:42 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 28 Sep 2021 16:54:42 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Tue, 28 Sep 2021 16:54:42 -0700
Received: by brunhilda.pdev.net (Postfix, from userid 1467)
        id 6AD04702865; Tue, 28 Sep 2021 18:54:42 -0500 (CDT)
From:   Don Brace <don.brace@microchip.com>
To:     <hch@infradead.org>, <martin.petersen@oracle.com>,
        <jejb@linux.vnet.ibm.com>, <linux-scsi@vger.kernel.org>
CC:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <balsundar.p@microchip.com>, <joseph.szczypek@hpe.com>,
        <jeff@canonical.com>, <POSWALD@suse.com>,
        <john.p.donnelly@oracle.com>, <mwilck@suse.com>,
        <pmenzel@molgen.mpg.de>, <linux-kernel@vger.kernel.org>
Subject: [smartpqi updates PATCH V2 03/11] smartpqi: capture controller reason codes
Date:   Tue, 28 Sep 2021 18:54:34 -0500
Message-ID: <20210928235442.201875-4-don.brace@microchip.com>
X-Mailer: git-send-email 2.28.0.rc1.9.ge7ae437ac1
In-Reply-To: <20210928235442.201875-1-don.brace@microchip.com>
References: <20210928235442.201875-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Murthy Bhat <Murthy.Bhat@microchip.com>

Store controller reason codes in a controller register for
debugging purposes.

In some rare cases, the driver can halt the controller.
- Add in a reason code on why the controller was halted.
- Store this reason code in a controller register to aid
  in debugging the issue.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Murthy Bhat <Murthy.Bhat@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      | 25 +++++++++++++++--
 drivers/scsi/smartpqi/smartpqi_init.c | 40 ++++++++++++++++++---------
 drivers/scsi/smartpqi/smartpqi_sis.c  |  9 ++++--
 drivers/scsi/smartpqi/smartpqi_sis.h  |  3 +-
 4 files changed, 57 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 70eca203d72f..d66863f8d1cf 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -82,9 +82,11 @@ struct pqi_ctrl_registers {
 	__le32  sis_product_identifier;			/* B4h */
 	u8	reserved5[0xbc - (0xb4 + sizeof(__le32))];
 	__le32	sis_firmware_status;			/* BCh */
-	u8	reserved6[0x1000 - (0xbc + sizeof(__le32))];
+	u8	reserved6[0xcc - (0xbc + sizeof(__le32))];
+	__le32	sis_ctrl_shutdown_reason_code;		/* CCh */
+	u8	reserved7[0x1000 - (0xcc + sizeof(__le32))];
 	__le32	sis_mailbox[8];				/* 1000h */
-	u8	reserved7[0x4000 - (0x1000 + (sizeof(__le32) * 8))];
+	u8	reserved8[0x4000 - (0x1000 + (sizeof(__le32) * 8))];
 	/*
 	 * The PQI spec states that the PQI registers should be at
 	 * offset 0 from the PCIe BAR 0.  However, we can't map
@@ -102,6 +104,21 @@ struct pqi_ctrl_registers {
 
 #define PQI_DEVICE_REGISTERS_OFFSET	0x4000
 
+/* shutdown reasons for taking the controller offline */
+enum pqi_ctrl_shutdown_reason {
+	PQI_IQ_NOT_DRAINED_TIMEOUT = 1,
+	PQI_LUN_RESET_TIMEOUT = 2,
+	PQI_IO_PENDING_POST_LUN_RESET_TIMEOUT = 3,
+	PQI_NO_HEARTBEAT = 4,
+	PQI_FIRMWARE_KERNEL_NOT_UP = 5,
+	PQI_OFA_RESPONSE_TIMEOUT = 6,
+	PQI_INVALID_REQ_ID = 7,
+	PQI_UNMATCHED_REQ_ID = 8,
+	PQI_IO_PI_OUT_OF_RANGE = 9,
+	PQI_EVENT_PI_OUT_OF_RANGE = 10,
+	PQI_UNEXPECTED_IU_TYPE = 11
+};
+
 enum pqi_io_path {
 	RAID_PATH = 0,
 	AIO_PATH = 1
@@ -850,7 +867,8 @@ struct pqi_config_table_firmware_features {
 #define PQI_FIRMWARE_FEATURE_TMF_IU_TIMEOUT			14
 #define PQI_FIRMWARE_FEATURE_RAID_BYPASS_ON_ENCRYPTED_NVME	15
 #define PQI_FIRMWARE_FEATURE_UNIQUE_WWID_IN_REPORT_PHYS_LUN	16
-#define PQI_FIRMWARE_FEATURE_MAXIMUM				16
+#define PQI_FIRMWARE_FEATURE_FW_TRIAGE				17
+#define PQI_FIRMWARE_FEATURE_MAXIMUM				17
 
 struct pqi_config_table_debug {
 	struct pqi_config_table_section_header header;
@@ -1297,6 +1315,7 @@ struct pqi_ctrl_info {
 	u8		raid_iu_timeout_supported : 1;
 	u8		tmf_iu_timeout_supported : 1;
 	u8		unique_wwid_in_report_phys_lun_supported : 1;
+	u8		firmware_triage_supported : 1;
 	u8		enable_r1_writes : 1;
 	u8		enable_r5_writes : 1;
 	u8		enable_r6_writes : 1;
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 5655d240f7a7..b6ac4d607664 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -54,7 +54,8 @@ MODULE_DESCRIPTION("Driver for Microchip Smart Family Controller version "
 MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL");
 
-static void pqi_take_ctrl_offline(struct pqi_ctrl_info *ctrl_info);
+static void pqi_take_ctrl_offline(struct pqi_ctrl_info *ctrl_info,
+	enum pqi_ctrl_shutdown_reason ctrl_shutdown_reason);
 static void pqi_ctrl_offline_worker(struct work_struct *work);
 static int pqi_scan_scsi_devices(struct pqi_ctrl_info *ctrl_info);
 static void pqi_scan_start(struct Scsi_Host *shost);
@@ -226,7 +227,7 @@ static inline void pqi_check_ctrl_health(struct pqi_ctrl_info *ctrl_info)
 {
 	if (ctrl_info->controller_online)
 		if (!sis_is_firmware_running(ctrl_info))
-			pqi_take_ctrl_offline(ctrl_info);
+			pqi_take_ctrl_offline(ctrl_info, PQI_FIRMWARE_KERNEL_NOT_UP);
 }
 
 static inline bool pqi_is_hba_lunid(u8 *scsi3addr)
@@ -3180,9 +3181,10 @@ static int pqi_interpret_task_management_response(struct pqi_ctrl_info *ctrl_inf
 	return rc;
 }
 
-static inline void pqi_invalid_response(struct pqi_ctrl_info *ctrl_info)
+static inline void pqi_invalid_response(struct pqi_ctrl_info *ctrl_info,
+	enum pqi_ctrl_shutdown_reason ctrl_shutdown_reason)
 {
-	pqi_take_ctrl_offline(ctrl_info);
+	pqi_take_ctrl_offline(ctrl_info, ctrl_shutdown_reason);
 }
 
 static int pqi_process_io_intr(struct pqi_ctrl_info *ctrl_info, struct pqi_queue_group *queue_group)
@@ -3200,7 +3202,7 @@ static int pqi_process_io_intr(struct pqi_ctrl_info *ctrl_info, struct pqi_queue
 	while (1) {
 		oq_pi = readl(queue_group->oq_pi);
 		if (oq_pi >= ctrl_info->num_elements_per_oq) {
-			pqi_invalid_response(ctrl_info);
+			pqi_invalid_response(ctrl_info, PQI_IO_PI_OUT_OF_RANGE);
 			dev_err(&ctrl_info->pci_dev->dev,
 				"I/O interrupt: producer index (%u) out of range (0-%u): consumer index: %u\n",
 				oq_pi, ctrl_info->num_elements_per_oq - 1, oq_ci);
@@ -3215,7 +3217,7 @@ static int pqi_process_io_intr(struct pqi_ctrl_info *ctrl_info, struct pqi_queue
 
 		request_id = get_unaligned_le16(&response->request_id);
 		if (request_id >= ctrl_info->max_io_slots) {
-			pqi_invalid_response(ctrl_info);
+			pqi_invalid_response(ctrl_info, PQI_INVALID_REQ_ID);
 			dev_err(&ctrl_info->pci_dev->dev,
 				"request ID in response (%u) out of range (0-%u): producer index: %u  consumer index: %u\n",
 				request_id, ctrl_info->max_io_slots - 1, oq_pi, oq_ci);
@@ -3224,7 +3226,7 @@ static int pqi_process_io_intr(struct pqi_ctrl_info *ctrl_info, struct pqi_queue
 
 		io_request = &ctrl_info->io_request_pool[request_id];
 		if (atomic_read(&io_request->refcount) == 0) {
-			pqi_invalid_response(ctrl_info);
+			pqi_invalid_response(ctrl_info, PQI_UNMATCHED_REQ_ID);
 			dev_err(&ctrl_info->pci_dev->dev,
 				"request ID in response (%u) does not match an outstanding I/O request: producer index: %u  consumer index: %u\n",
 				request_id, oq_pi, oq_ci);
@@ -3260,7 +3262,7 @@ static int pqi_process_io_intr(struct pqi_ctrl_info *ctrl_info, struct pqi_queue
 			pqi_process_io_error(response->header.iu_type, io_request);
 			break;
 		default:
-			pqi_invalid_response(ctrl_info);
+			pqi_invalid_response(ctrl_info, PQI_UNEXPECTED_IU_TYPE);
 			dev_err(&ctrl_info->pci_dev->dev,
 				"unexpected IU type: 0x%x: producer index: %u  consumer index: %u\n",
 				response->header.iu_type, oq_pi, oq_ci);
@@ -3442,7 +3444,7 @@ static void pqi_process_soft_reset(struct pqi_ctrl_info *ctrl_info)
 		pqi_ofa_free_host_buffer(ctrl_info);
 		pqi_ctrl_ofa_done(ctrl_info);
 		pqi_ofa_ctrl_unquiesce(ctrl_info);
-		pqi_take_ctrl_offline(ctrl_info);
+		pqi_take_ctrl_offline(ctrl_info, PQI_OFA_RESPONSE_TIMEOUT);
 		break;
 	}
 }
@@ -3567,7 +3569,7 @@ static void pqi_heartbeat_timer_handler(struct timer_list *t)
 			dev_err(&ctrl_info->pci_dev->dev,
 				"no heartbeat detected - last heartbeat count: %u\n",
 				heartbeat_count);
-			pqi_take_ctrl_offline(ctrl_info);
+			pqi_take_ctrl_offline(ctrl_info, PQI_NO_HEARTBEAT);
 			return;
 		}
 	} else {
@@ -3631,7 +3633,7 @@ static int pqi_process_event_intr(struct pqi_ctrl_info *ctrl_info)
 	while (1) {
 		oq_pi = readl(event_queue->oq_pi);
 		if (oq_pi >= PQI_NUM_EVENT_QUEUE_ELEMENTS) {
-			pqi_invalid_response(ctrl_info);
+			pqi_invalid_response(ctrl_info, PQI_EVENT_PI_OUT_OF_RANGE);
 			dev_err(&ctrl_info->pci_dev->dev,
 				"event interrupt: producer index (%u) out of range (0-%u): consumer index: %u\n",
 				oq_pi, PQI_NUM_EVENT_QUEUE_ELEMENTS - 1, oq_ci);
@@ -7323,7 +7325,10 @@ static void pqi_ctrl_update_feature_flags(struct pqi_ctrl_info *ctrl_info,
 		ctrl_info->unique_wwid_in_report_phys_lun_supported =
 			firmware_feature->enabled;
 		break;
+	case PQI_FIRMWARE_FEATURE_FW_TRIAGE:
+		ctrl_info->firmware_triage_supported = firmware_feature->enabled;
 		pqi_save_fw_triage_setting(ctrl_info, firmware_feature->enabled);
+		break;
 	}
 
 	pqi_firmware_feature_status(ctrl_info, firmware_feature);
@@ -7419,6 +7424,11 @@ static struct pqi_firmware_feature pqi_firmware_features[] = {
 		.feature_bit = PQI_FIRMWARE_FEATURE_UNIQUE_WWID_IN_REPORT_PHYS_LUN,
 		.feature_status = pqi_ctrl_update_feature_flags,
 	},
+	{
+		.feature_name = "Firmware Triage",
+		.feature_bit = PQI_FIRMWARE_FEATURE_FW_TRIAGE,
+		.feature_status = pqi_ctrl_update_feature_flags,
+	},
 };
 
 static void pqi_process_firmware_features(
@@ -7519,6 +7529,7 @@ static void pqi_ctrl_reset_config(struct pqi_ctrl_info *ctrl_info)
 	ctrl_info->raid_iu_timeout_supported = false;
 	ctrl_info->tmf_iu_timeout_supported = false;
 	ctrl_info->unique_wwid_in_report_phys_lun_supported = false;
+	ctrl_info->firmware_triage_supported = false;
 }
 
 static int pqi_process_config_table(struct pqi_ctrl_info *ctrl_info)
@@ -8459,7 +8470,8 @@ static void pqi_ctrl_offline_worker(struct work_struct *work)
 	pqi_take_ctrl_offline_deferred(ctrl_info);
 }
 
-static void pqi_take_ctrl_offline(struct pqi_ctrl_info *ctrl_info)
+static void pqi_take_ctrl_offline(struct pqi_ctrl_info *ctrl_info,
+	enum pqi_ctrl_shutdown_reason ctrl_shutdown_reason)
 {
 	if (!ctrl_info->controller_online)
 		return;
@@ -8468,7 +8480,7 @@ static void pqi_take_ctrl_offline(struct pqi_ctrl_info *ctrl_info)
 	ctrl_info->pqi_mode_enabled = false;
 	pqi_ctrl_block_requests(ctrl_info);
 	if (!pqi_disable_ctrl_shutdown)
-		sis_shutdown_ctrl(ctrl_info);
+		sis_shutdown_ctrl(ctrl_info, ctrl_shutdown_reason);
 	pci_disable_device(ctrl_info->pci_dev);
 	dev_err(&ctrl_info->pci_dev->dev, "controller offline\n");
 	schedule_work(&ctrl_info->ctrl_offline_work);
@@ -9303,6 +9315,8 @@ static void __attribute__((unused)) verify_structures(void)
 		sis_product_identifier) != 0xb4);
 	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers,
 		sis_firmware_status) != 0xbc);
+	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers,
+		sis_ctrl_shutdown_reason_code) != 0xcc);
 	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers,
 		sis_mailbox) != 0x1000);
 	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers,
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.c b/drivers/scsi/smartpqi/smartpqi_sis.c
index 8acd3a80f582..d66eb8ea161c 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.c
+++ b/drivers/scsi/smartpqi/smartpqi_sis.c
@@ -397,14 +397,17 @@ void sis_enable_intx(struct pqi_ctrl_info *ctrl_info)
 	sis_set_doorbell_bit(ctrl_info, SIS_ENABLE_INTX);
 }
 
-void sis_shutdown_ctrl(struct pqi_ctrl_info *ctrl_info)
+void sis_shutdown_ctrl(struct pqi_ctrl_info *ctrl_info,
+	enum pqi_ctrl_shutdown_reason ctrl_shutdown_reason)
 {
 	if (readl(&ctrl_info->registers->sis_firmware_status) &
 		SIS_CTRL_KERNEL_PANIC)
 		return;
 
-	writel(SIS_TRIGGER_SHUTDOWN,
-		&ctrl_info->registers->sis_host_to_ctrl_doorbell);
+	if (ctrl_info->firmware_triage_supported)
+		writel(ctrl_shutdown_reason, &ctrl_info->registers->sis_ctrl_shutdown_reason_code);
+
+	writel(SIS_TRIGGER_SHUTDOWN, &ctrl_info->registers->sis_host_to_ctrl_doorbell);
 }
 
 int sis_pqi_reset_quiesce(struct pqi_ctrl_info *ctrl_info)
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.h b/drivers/scsi/smartpqi/smartpqi_sis.h
index c1db93054c86..bd92ff49f385 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.h
+++ b/drivers/scsi/smartpqi/smartpqi_sis.h
@@ -21,7 +21,8 @@ int sis_get_pqi_capabilities(struct pqi_ctrl_info *ctrl_info);
 int sis_init_base_struct_addr(struct pqi_ctrl_info *ctrl_info);
 void sis_enable_msix(struct pqi_ctrl_info *ctrl_info);
 void sis_enable_intx(struct pqi_ctrl_info *ctrl_info);
-void sis_shutdown_ctrl(struct pqi_ctrl_info *ctrl_info);
+void sis_shutdown_ctrl(struct pqi_ctrl_info *ctrl_info,
+	enum pqi_ctrl_shutdown_reason ctrl_shutdown_reason);
 int sis_pqi_reset_quiesce(struct pqi_ctrl_info *ctrl_info);
 int sis_reenable_sis_mode(struct pqi_ctrl_info *ctrl_info);
 void sis_write_driver_scratch(struct pqi_ctrl_info *ctrl_info, u32 value);
-- 
2.28.0.rc1.9.ge7ae437ac1

