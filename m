From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 7/14] qla2xxx: Refactor set-HBA-model/description code.
Date: Mon, 29 Jan 2007 10:22:24 -0800
Message-ID: <11700949513962-git-send-email-andrew.vasquez@qlogic.com>
References: <20070129182124.GA26940@andrew-vasquezs-computer.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:47719 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbXA2SWg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jan 2007 13:22:36 -0500
In-Reply-To: <20070129182124.GA26940@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Limit assignments via qla2x00_model_name[] array to HBA
subsystem vendor IDs equal to QLogic.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |   83 +++++++++++++++++---------------------
 1 files changed, 37 insertions(+), 46 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 5c9ce61..f4c63ad 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1355,6 +1355,39 @@ qla2x00_configure_hba(scsi_qla_host_t *ha)
 	return(rval);
 }
 
+static inline void
+qla2x00_set_model_info(scsi_qla_host_t *ha, uint8_t *model, size_t len, char *def)
+{
+	char *st, *en;
+	uint16_t index;
+
+	if (memcmp(model, BINZERO, len) != 0) {
+		strncpy(ha->model_number, model, len);
+		st = en = ha->model_number;
+		en += len - 1;
+		while (en > st) {
+			if (*en != 0x20 && *en != 0x00)
+				break;
+			*en-- = '\0';
+		}
+
+		index = (ha->pdev->subsystem_device & 0xff);
+		if (ha->pdev->subsystem_vendor == PCI_VENDOR_ID_QLOGIC &&
+		    index < QLA_MODEL_NAMES)
+			ha->model_desc = qla2x00_model_name[index * 2 + 1];
+	} else {
+		index = (ha->pdev->subsystem_device & 0xff);
+		if (ha->pdev->subsystem_vendor == PCI_VENDOR_ID_QLOGIC &&
+		    index < QLA_MODEL_NAMES) {
+			strcpy(ha->model_number,
+			    qla2x00_model_name[index * 2]);
+			ha->model_desc = qla2x00_model_name[index * 2 + 1];
+		} else {
+			strcpy(ha->model_number, def);
+		}
+	}
+}
+
 /*
 * NVRAM configuration for ISP 2xxx
 *
@@ -1493,33 +1526,8 @@ qla2x00_nvram_config(scsi_qla_host_t *ha)
 				strcpy(ha->model_number, "QLA2300");
 			}
 		} else {
-			if (rval == 0 &&
-			    memcmp(nv->model_number, BINZERO,
-				    sizeof(nv->model_number)) != 0) {
-				char *st, *en;
-
-				strncpy(ha->model_number, nv->model_number,
-				    sizeof(nv->model_number));
-				st = en = ha->model_number;
-				en += sizeof(nv->model_number) - 1;
-				while (en > st) {
-					if (*en != 0x20 && *en != 0x00)
-						break;
-					*en-- = '\0';
-				}
-			} else {
-				uint16_t        index;
-
-				index = (ha->pdev->subsystem_device & 0xff);
-				if (index < QLA_MODEL_NAMES) {
-					strcpy(ha->model_number,
-					    qla2x00_model_name[index * 2]);
-					ha->model_desc =
-					    qla2x00_model_name[index * 2 + 1];
-				} else {
-					strcpy(ha->model_number, "QLA23xx");
-				}
-			}
+			qla2x00_set_model_info(ha, nv->model_number,
+			    sizeof(nv->model_number), "QLA23xx");
 		}
 	} else if (IS_QLA2200(ha)) {
 		nv->firmware_options[0] |= BIT_2;
@@ -3444,25 +3452,8 @@ qla24xx_nvram_config(scsi_qla_host_t *ha)
 	/*
 	 * Setup driver NVRAM options.
 	 */
-	if (memcmp(nv->model_name, BINZERO, sizeof(nv->model_name)) != 0) {
-		char *st, *en;
-		uint16_t index;
-
-		strncpy(ha->model_number, nv->model_name,
-		    sizeof(nv->model_name));
-		st = en = ha->model_number;
-		en += sizeof(nv->model_name) - 1;
-		while (en > st) {
-			if (*en != 0x20 && *en != 0x00)
-				break;
-			*en-- = '\0';
-		}
-
-		index = (ha->pdev->subsystem_device & 0xff);
-		if (index < QLA_MODEL_NAMES)
-			ha->model_desc = qla2x00_model_name[index * 2 + 1];
-	} else
-		strcpy(ha->model_number, "QLA2462");
+	qla2x00_set_model_info(ha, nv->model_name, sizeof(nv->model_name),
+	    "QLA2462");
 
 	/* Use alternate WWN? */
 	if (nv->host_p & __constant_cpu_to_le32(BIT_15)) {
-- 
1.5.0.rc2.gdbaa0

