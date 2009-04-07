From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 09/15] qla2xxx: Restrict model-name/description device-table usage.
Date: Mon,  6 Apr 2009 22:33:45 -0700
Message-ID: <1239082431-19496-10-git-send-email-andrew.vasquez@qlogic.com>
References: <1239082431-19496-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29400 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbZDGFeD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2009 01:34:03 -0400
In-Reply-To: <1239082431-19496-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Information present in static table is only valid for pre-ISP25xx
adapters.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 4c14cde..a4a6a14 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1538,6 +1538,7 @@ qla2x00_set_model_info(scsi_qla_host_t *vha, uint8_t *model, size_t len,
 	char *st, *en;
 	uint16_t index;
 	struct qla_hw_data *ha = vha->hw;
+	int use_tbl = !IS_QLA25XX(ha) && IS_QLA81XX(ha);
 
 	if (memcmp(model, BINZERO, len) != 0) {
 		strncpy(ha->model_number, model, len);
@@ -1550,14 +1551,16 @@ qla2x00_set_model_info(scsi_qla_host_t *vha, uint8_t *model, size_t len,
 		}
 
 		index = (ha->pdev->subsystem_device & 0xff);
-		if (ha->pdev->subsystem_vendor == PCI_VENDOR_ID_QLOGIC &&
+		if (use_tbl &&
+		    ha->pdev->subsystem_vendor == PCI_VENDOR_ID_QLOGIC &&
 		    index < QLA_MODEL_NAMES)
 			strncpy(ha->model_desc,
 			    qla2x00_model_name[index * 2 + 1],
 			    sizeof(ha->model_desc) - 1);
 	} else {
 		index = (ha->pdev->subsystem_device & 0xff);
-		if (ha->pdev->subsystem_vendor == PCI_VENDOR_ID_QLOGIC &&
+		if (use_tbl &&
+		    ha->pdev->subsystem_vendor == PCI_VENDOR_ID_QLOGIC &&
 		    index < QLA_MODEL_NAMES) {
 			strcpy(ha->model_number,
 			    qla2x00_model_name[index * 2]);
-- 
1.6.2.2.404.ge96f3

