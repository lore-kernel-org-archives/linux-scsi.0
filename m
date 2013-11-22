From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 7/8] qla4xxx: Recreate chap data list during get chap operation
Date: Fri, 22 Nov 2013 05:28:23 -0500
Message-ID: <1385116104-19784-8-git-send-email-vikas.chaudhary@qlogic.com>
References: <1385116104-19784-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:52945 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755308Ab3KVLBP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Nov 2013 06:01:15 -0500
In-Reply-To: <1385116104-19784-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

Recreate the chap data list during the get chap operation in
qla4xxx_get_chap_list().

Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 119 ++++++++++++++++++++++--------------------
 1 file changed, 61 insertions(+), 58 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 4181758..1c05f84 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -573,6 +573,65 @@ static umode_t qla4_attr_is_visible(int param_type, int param)
 	return 0;
 }
 
+/**
+ * qla4xxx_create chap_list - Create CHAP list from FLASH
+ * @ha: pointer to adapter structure
+ *
+ * Read flash and make a list of CHAP entries, during login when a CHAP entry
+ * is received, it will be checked in this list. If entry exist then the CHAP
+ * entry index is set in the DDB. If CHAP entry does not exist in this list
+ * then a new entry is added in FLASH in CHAP table and the index obtained is
+ * used in the DDB.
+ **/
+static void qla4xxx_create_chap_list(struct scsi_qla_host *ha)
+{
+	int rval = 0;
+	uint8_t *chap_flash_data = NULL;
+	uint32_t offset;
+	dma_addr_t chap_dma;
+	uint32_t chap_size = 0;
+
+	if (is_qla40XX(ha))
+		chap_size = MAX_CHAP_ENTRIES_40XX *
+			    sizeof(struct ql4_chap_table);
+	else	/* Single region contains CHAP info for both
+		 * ports which is divided into half for each port.
+		 */
+		chap_size = ha->hw.flt_chap_size / 2;
+
+	chap_flash_data = dma_alloc_coherent(&ha->pdev->dev, chap_size,
+					     &chap_dma, GFP_KERNEL);
+	if (!chap_flash_data) {
+		ql4_printk(KERN_ERR, ha, "No memory for chap_flash_data\n");
+		return;
+	}
+
+	if (is_qla40XX(ha)) {
+		offset = FLASH_CHAP_OFFSET;
+	} else {
+		offset = FLASH_RAW_ACCESS_ADDR + (ha->hw.flt_region_chap << 2);
+		if (ha->port_num == 1)
+			offset += chap_size;
+	}
+
+	rval = qla4xxx_get_flash(ha, chap_dma, offset, chap_size);
+	if (rval != QLA_SUCCESS)
+		goto exit_chap_list;
+
+	if (ha->chap_list == NULL)
+		ha->chap_list = vmalloc(chap_size);
+	if (ha->chap_list == NULL) {
+		ql4_printk(KERN_ERR, ha, "No memory for ha->chap_list\n");
+		goto exit_chap_list;
+	}
+
+	memset(ha->chap_list, 0, chap_size);
+	memcpy(ha->chap_list, chap_flash_data, chap_size);
+
+exit_chap_list:
+	dma_free_coherent(&ha->pdev->dev, chap_size, chap_flash_data, chap_dma);
+}
+
 static int qla4xxx_get_chap_by_index(struct scsi_qla_host *ha,
 				     int16_t chap_index,
 				     struct ql4_chap_table **chap_entry)
@@ -686,6 +745,8 @@ static int qla4xxx_get_chap_list(struct Scsi_Host *shost, uint16_t chap_tbl_idx,
 		goto exit_get_chap_list;
 	}
 
+	qla4xxx_create_chap_list(ha);
+
 	chap_rec = (struct iscsi_chap_rec *) buf;
 	mutex_lock(&ha->chap_sem);
 	for (i = chap_tbl_idx; i < max_chap_entries; i++) {
@@ -6121,64 +6182,6 @@ kset_free:
 }
 
 
-/**
- * qla4xxx_create chap_list - Create CHAP list from FLASH
- * @ha: pointer to adapter structure
- *
- * Read flash and make a list of CHAP entries, during login when a CHAP entry
- * is received, it will be checked in this list. If entry exist then the CHAP
- * entry index is set in the DDB. If CHAP entry does not exist in this list
- * then a new entry is added in FLASH in CHAP table and the index obtained is
- * used in the DDB.
- **/
-static void qla4xxx_create_chap_list(struct scsi_qla_host *ha)
-{
-	int rval = 0;
-	uint8_t *chap_flash_data = NULL;
-	uint32_t offset;
-	dma_addr_t chap_dma;
-	uint32_t chap_size = 0;
-
-	if (is_qla40XX(ha))
-		chap_size = MAX_CHAP_ENTRIES_40XX  *
-					sizeof(struct ql4_chap_table);
-	else	/* Single region contains CHAP info for both
-		 * ports which is divided into half for each port.
-		 */
-		chap_size = ha->hw.flt_chap_size / 2;
-
-	chap_flash_data = dma_alloc_coherent(&ha->pdev->dev, chap_size,
-					  &chap_dma, GFP_KERNEL);
-	if (!chap_flash_data) {
-		ql4_printk(KERN_ERR, ha, "No memory for chap_flash_data\n");
-		return;
-	}
-	if (is_qla40XX(ha))
-		offset = FLASH_CHAP_OFFSET;
-	else {
-		offset = FLASH_RAW_ACCESS_ADDR + (ha->hw.flt_region_chap << 2);
-		if (ha->port_num == 1)
-			offset += chap_size;
-	}
-
-	rval = qla4xxx_get_flash(ha, chap_dma, offset, chap_size);
-	if (rval != QLA_SUCCESS)
-		goto exit_chap_list;
-
-	if (ha->chap_list == NULL)
-		ha->chap_list = vmalloc(chap_size);
-	if (ha->chap_list == NULL) {
-		ql4_printk(KERN_ERR, ha, "No memory for ha->chap_list\n");
-		goto exit_chap_list;
-	}
-
-	memcpy(ha->chap_list, chap_flash_data, chap_size);
-
-exit_chap_list:
-	dma_free_coherent(&ha->pdev->dev, chap_size,
-			chap_flash_data, chap_dma);
-}
-
 static void qla4xxx_get_param_ddb(struct ddb_entry *ddb_entry,
 				  struct ql4_tuple_ddb *tddb)
 {
-- 
1.8.2.GIT

