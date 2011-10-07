From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH v2 05/14] qla4xxx: Fix exporting boot targets to sysfs
Date: Fri, 7 Oct 2011 16:55:43 -0700
Message-ID: <1318031752-3836-6-git-send-email-vikas.chaudhary@qlogic.com>
References: <1318031752-3836-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:7997
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754507Ab1JHAH0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Oct 2011 20:07:26 -0400
In-Reply-To: <1318031752-3836-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

The driver failed to export primary boot target if secondary target did not
exist in the FLASH. If boot targets are not valid then driver assumed 0 and
1 as default boot targets. Since these target did not exist in flash, the
driver failed exporting all the targets.

JIRA Key: UPSISCSI-148

Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |   37 +++++++++++++++++++++----------------
 1 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 874621d..0bcb6fd 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -2812,15 +2812,11 @@ static int get_fw_boot_info(struct scsi_qla_host *ha, uint16_t ddb_index[])
 		val = rd_nvram_byte(ha, pri_addr);
 		if (val & BIT_7)
 			ddb_index[0] = (val & 0x7f);
-		else
-			ddb_index[0] = 0;
 
 		/* get secondary valid target index */
 		val = rd_nvram_byte(ha, sec_addr);
 		if (val & BIT_7)
 			ddb_index[1] = (val & 0x7f);
-		else
-			ddb_index[1] = 1;
 
 	} else if (is_qla8022(ha)) {
 		buf = dma_alloc_coherent(&ha->pdev->dev, size,
@@ -2862,15 +2858,10 @@ static int get_fw_boot_info(struct scsi_qla_host *ha, uint16_t ddb_index[])
 		/* get primary valid target index */
 		if (buf[2] & BIT_7)
 			ddb_index[0] = buf[2] & 0x7f;
-		else
-			ddb_index[0] = 0;
 
 		/* get secondary valid target index */
 		if (buf[11] & BIT_7)
 			ddb_index[1] = buf[11] & 0x7f;
-		else
-			ddb_index[1] = 1;
-
 	} else {
 		ret = QLA_ERROR;
 		goto exit_boot_info;
@@ -2980,9 +2971,12 @@ exit_boot_target:
 static int qla4xxx_get_boot_info(struct scsi_qla_host *ha)
 {
 	uint16_t ddb_index[2];
-	int ret = QLA_SUCCESS;
+	int ret = QLA_ERROR;
+	int rval;
 
 	memset(ddb_index, 0, sizeof(ddb_index));
+	ddb_index[0] = 0xffff;
+	ddb_index[1] = 0xffff;
 	ret = get_fw_boot_info(ha, ddb_index);
 	if (ret != QLA_SUCCESS) {
 		DEBUG2(ql4_printk(KERN_ERR, ha,
@@ -2990,19 +2984,30 @@ static int qla4xxx_get_boot_info(struct scsi_qla_host *ha)
 		return ret;
 	}
 
-	ret = qla4xxx_get_boot_target(ha, &(ha->boot_tgt.boot_pri_sess),
+	if (ddb_index[0] == 0xffff)
+		goto sec_target;
+
+	rval = qla4xxx_get_boot_target(ha, &(ha->boot_tgt.boot_pri_sess),
 				      ddb_index[0]);
-	if (ret != QLA_SUCCESS) {
+	if (rval != QLA_SUCCESS) {
 		DEBUG2(ql4_printk(KERN_ERR, ha, "%s: Failed to get "
 				  "primary target\n", __func__));
-	}
+	} else
+		ret = QLA_SUCCESS;
 
-	ret = qla4xxx_get_boot_target(ha, &(ha->boot_tgt.boot_sec_sess),
+sec_target:
+	if (ddb_index[1] == 0xffff)
+		goto exit_get_boot_info;
+
+	rval = qla4xxx_get_boot_target(ha, &(ha->boot_tgt.boot_sec_sess),
 				      ddb_index[1]);
-	if (ret != QLA_SUCCESS) {
+	if (rval != QLA_SUCCESS) {
 		DEBUG2(ql4_printk(KERN_ERR, ha, "%s: Failed to get "
 				  "secondary target\n", __func__));
-	}
+	} else
+		ret = QLA_SUCCESS;
+
+exit_get_boot_info:
 	return ret;
 }
 
-- 
1.7.6


