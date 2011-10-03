From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 05/13] qla4xxx: Fix exporting boot targets to sysfs
Date: Mon, 3 Oct 2011 10:29:19 -0700
Message-ID: <1317662967-30110-6-git-send-email-vikas.chaudhary@qlogic.com>
References: <1317662967-30110-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:42179
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932159Ab1JCRlz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2011 13:41:55 -0400
In-Reply-To: <1317662967-30110-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

The driver failed to export primary boot target if secondary target did not
exist in the FLASH. If boot targets are not valid then driver assumed 0 and
1 as default boot targets. Since these target did not exist in flash, the
driver failed exporting all the targets.
Also fixed,
- for 8022 calculate max chap entries based on the size of CHAP table in FLASH
- If a boot target has a BIDI CHAP enabled, then read the user/secret from
CHAP table. Do not assume BIDI chap at peer CHAP idx + 1

JIRA Key: UPSISCSI-148

Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_mbx.c |    3 +-
 drivers/scsi/qla4xxx/ql4_os.c  |  102 +++++++++++++++++++++++++++++++--------
 2 files changed, 83 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index ba4eadf..475676f 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -1416,7 +1416,8 @@ static int qla4xxx_get_chap_index(struct scsi_qla_host *ha, char *username,
 	struct ql4_chap_table *chap_table;
 
 	if (is_qla8022(ha))
-		max_chap_entries = MAX_CHAP_ENTRIES_82XX;
+		max_chap_entries = (ha->hw.flt_chap_size / 2) /
+						sizeof(struct ql4_chap_table);
 	else
 		max_chap_entries = MAX_CHAP_ENTRIES_40XX;
 
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 52877ca..c621152 100644
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
@@ -2886,6 +2877,60 @@ exit_boot_info:
 	return ret;
 }
 
+/**
+ * qla4xxx_get_bidi_chap - Get a BI-DI CHAP user and secret.
+ * @ha: pointer to adapter structure
+ * @username
+ * @password
+ *
+ * If a boot entry has BIDI CHAP enabled then we need to set the BIDI CHAP
+ * user and secret in the sysfs entry in /sys/firmware/iscsi_boot#/.
+ * So from the CHAP cache find the first BIDI CHAP entry and set it
+ * to the boot record in sysfs.
+ **/
+static int qla4xxx_get_bidi_chap(struct scsi_qla_host *ha, char *username,
+			    char *password)
+{
+	int i, ret = -EINVAL;
+	int max_chap_entries = 0;
+	struct ql4_chap_table *chap_table;
+
+	if (is_qla8022(ha))
+		max_chap_entries = (ha->hw.flt_chap_size / 2) /
+						sizeof(struct ql4_chap_table);
+	else
+		max_chap_entries = MAX_CHAP_ENTRIES_40XX;
+
+	if (!ha->chap_list) {
+		ql4_printk(KERN_ERR, ha, "Do not have CHAP table cache\n");
+		return ret;
+	}
+
+	mutex_lock(&ha->chap_sem);
+	for (i = 0; i < max_chap_entries; i++) {
+		chap_table = (struct ql4_chap_table *)ha->chap_list + i;
+		if (chap_table->cookie !=
+		    __constant_cpu_to_le16(CHAP_VALID_COOKIE)) {
+			continue;
+		}
+
+		if (chap_table->flags & BIT_7) /* local */
+			continue;
+
+		if (!(chap_table->flags & BIT_6)) /* Not BIDI */
+			continue;
+
+		strncpy(password, chap_table->secret, QL4_CHAP_MAX_SECRET_LEN);
+		strncpy(username, chap_table->name, QL4_CHAP_MAX_NAME_LEN);
+		ret = 0;
+		break;
+	}
+	mutex_unlock(&ha->chap_sem);
+
+	return ret;
+}
+
+
 static int qla4xxx_get_boot_target(struct scsi_qla_host *ha,
 				   struct ql4_boot_session_info *boot_sess,
 				   uint16_t ddb_index)
@@ -2957,10 +3002,10 @@ static int qla4xxx_get_boot_target(struct scsi_qla_host *ha,
 
 		DEBUG2(ql4_printk(KERN_INFO, ha, "Setting BIDI chap\n"));
 
-		ret = qla4xxx_get_chap(ha, (char *)&boot_conn->chap.
-				       intr_chap_name,
-				       (char *)&boot_conn->chap.intr_secret,
-				       (idx + 1));
+		ret = qla4xxx_get_bidi_chap(ha,
+				    (char *)&boot_conn->chap.intr_chap_name,
+				    (char *)&boot_conn->chap.intr_secret);
+
 		if (ret) {
 			ql4_printk(KERN_ERR, ha, "Failed to set BIDI chap\n");
 			ret = QLA_ERROR;
@@ -2980,9 +3025,12 @@ exit_boot_target:
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
@@ -2990,19 +3038,30 @@ static int qla4xxx_get_boot_info(struct scsi_qla_host *ha)
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
 
@@ -3331,12 +3390,13 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
 	       ha->host_no, ha->firmware_version[0], ha->firmware_version[1],
 	       ha->patch_number, ha->build_number);
 
+	qla4xxx_create_chap_list(ha);
+
 	if (qla4xxx_setup_boot_info(ha))
 		ql4_printk(KERN_ERR, ha, "%s:ISCSI boot info setup failed\n",
 			   __func__);
 
 	qla4xxx_create_ifaces(ha);
-	qla4xxx_create_chap_list(ha);
 	return 0;
 
 remove_host:
-- 
1.7.6


