From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 07/35] qla2xxx: Add endianizer to max_payload_size modifier.
Date: Wed, 24 Sep 2014 03:08:10 -0400
Message-ID: <1411542518-2477-8-git-send-email-saurav.kashyap@qlogic.com>
References: <1411542518-2477-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:65168 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753053AbaIXHn1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2014 03:43:27 -0400
In-Reply-To: <1411542518-2477-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_fw.h   |    2 +-
 drivers/scsi/qla2xxx/qla_init.c |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index eb8f572..c7d1c45 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -91,7 +91,7 @@ struct nvram_24xx {
 	/* Firmware Initialization Control Block. */
 	uint16_t version;
 	uint16_t reserved_1;
-	uint16_t frame_payload_size;
+	__le16 frame_payload_size;
 	uint16_t execution_throttle;
 	uint16_t exchange_count;
 	uint16_t hard_address;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 46990f4..748bd90 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2596,18 +2596,18 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
 			nv->firmware_options[1] = BIT_7 | BIT_5;
 			nv->add_firmware_options[0] = BIT_5;
 			nv->add_firmware_options[1] = BIT_5 | BIT_4;
-			nv->frame_payload_size = __constant_cpu_to_le16(2048);
+			nv->frame_payload_size = 2048;
 			nv->special_options[1] = BIT_7;
 		} else if (IS_QLA2200(ha)) {
 			nv->firmware_options[0] = BIT_2 | BIT_1;
 			nv->firmware_options[1] = BIT_7 | BIT_5;
 			nv->add_firmware_options[0] = BIT_5;
 			nv->add_firmware_options[1] = BIT_5 | BIT_4;
-			nv->frame_payload_size = __constant_cpu_to_le16(1024);
+			nv->frame_payload_size = 1024;
 		} else if (IS_QLA2100(ha)) {
 			nv->firmware_options[0] = BIT_3 | BIT_1;
 			nv->firmware_options[1] = BIT_5;
-			nv->frame_payload_size = __constant_cpu_to_le16(1024);
+			nv->frame_payload_size = 1024;
 		}
 
 		nv->max_iocb_allocation = __constant_cpu_to_le16(256);
@@ -2643,7 +2643,7 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
 	 * are valid.
 	 */
 	if (ia64_platform_is("sn2")) {
-		nv->frame_payload_size = __constant_cpu_to_le16(2048);
+		nv->frame_payload_size = 2048;
 		if (IS_QLA23XX(ha))
 			nv->special_options[1] = BIT_7;
 	}
@@ -4958,7 +4958,7 @@ qla24xx_nvram_config(scsi_qla_host_t *vha)
 		memset(nv, 0, ha->nvram_size);
 		nv->nvram_version = __constant_cpu_to_le16(ICB_VERSION);
 		nv->version = __constant_cpu_to_le16(ICB_VERSION);
-		nv->frame_payload_size = __constant_cpu_to_le16(2048);
+		nv->frame_payload_size = 2048;
 		nv->execution_throttle = __constant_cpu_to_le16(0xFFFF);
 		nv->exchange_count = __constant_cpu_to_le16(0);
 		nv->hard_address = __constant_cpu_to_le16(124);
@@ -5905,7 +5905,7 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 		memset(nv, 0, ha->nvram_size);
 		nv->nvram_version = __constant_cpu_to_le16(ICB_VERSION);
 		nv->version = __constant_cpu_to_le16(ICB_VERSION);
-		nv->frame_payload_size = __constant_cpu_to_le16(2048);
+		nv->frame_payload_size = 2048;
 		nv->execution_throttle = __constant_cpu_to_le16(0xFFFF);
 		nv->exchange_count = __constant_cpu_to_le16(0);
 		nv->port_name[0] = 0x21;
-- 
1.7.7

