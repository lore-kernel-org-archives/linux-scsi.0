From: vikas.chaudhary@qlogic.com
Subject: [PATCH 1/5] qla4xxx: Use correct flash ddb offset for ISP40XX
Date: Fri,  5 Apr 2013 07:06:06 -0400
Message-ID: <1365159970-17672-2-git-send-email-vikas.chaudhary@qlogic.com>
References: <1365159970-17672-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:4632 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751608Ab3DEL3k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Apr 2013 07:29:40 -0400
In-Reply-To: <1365159970-17672-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

Use correct flash ddb offset to add and delete flash target
entries for ISP40XX

Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_mbx.c |  7 ++++--
 drivers/scsi/qla4xxx/ql4_os.c  | 57 ++++++++++++++++++++++++++++--------------
 2 files changed, 43 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 8985997..a501bea 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -1421,7 +1421,7 @@ int qla4xxx_flashdb_by_index(struct scsi_qla_host *ha,
 			     struct dev_db_entry *fw_ddb_entry,
 			     dma_addr_t fw_ddb_entry_dma, uint16_t ddb_index)
 {
-	uint32_t dev_db_start_offset = FLASH_OFFSET_DB_INFO;
+	uint32_t dev_db_start_offset;
 	uint32_t dev_db_end_offset;
 	int status = QLA_ERROR;
 
@@ -1429,6 +1429,7 @@ int qla4xxx_flashdb_by_index(struct scsi_qla_host *ha,
 
 	if (is_qla40XX(ha)) {
 		dev_db_start_offset = FLASH_OFFSET_DB_INFO;
+		dev_db_end_offset = FLASH_OFFSET_DB_END;
 	} else {
 		dev_db_start_offset = FLASH_RAW_ACCESS_ADDR +
 				      (ha->hw.flt_region_ddb << 2);
@@ -1437,9 +1438,11 @@ int qla4xxx_flashdb_by_index(struct scsi_qla_host *ha,
 		 */
 		if (ha->port_num == 1)
 			dev_db_start_offset += (ha->hw.flt_ddb_size / 2);
+
+		dev_db_end_offset = dev_db_start_offset +
+				    (ha->hw.flt_ddb_size / 2);
 	}
 
-	dev_db_end_offset = dev_db_start_offset + (ha->hw.flt_ddb_size / 2);
 	dev_db_start_offset += (ddb_index * sizeof(*fw_ddb_entry));
 
 	if (dev_db_start_offset > dev_db_end_offset) {
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 95a951c..5f7a2bc 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -6582,6 +6582,8 @@ static int qla4xxx_sysfs_ddb_delete(struct iscsi_bus_flash_session *fnode_sess)
 	struct dev_db_entry *fw_ddb_entry = NULL;
 	dma_addr_t fw_ddb_entry_dma;
 	uint16_t *ddb_cookie = NULL;
+	size_t ddb_size;
+	void *pddb = NULL;
 	int target_id;
 	int rc = 0;
 
@@ -6601,18 +6603,12 @@ static int qla4xxx_sysfs_ddb_delete(struct iscsi_bus_flash_session *fnode_sess)
 	if (fnode_sess->flash_state == DEV_DB_NON_PERSISTENT)
 		goto sysfs_ddb_del;
 
-	ddb_cookie = dma_alloc_coherent(&ha->pdev->dev, sizeof(*ddb_cookie),
-					&fw_ddb_entry_dma, GFP_KERNEL);
-	if (!ddb_cookie) {
-		rc = -ENOMEM;
-		DEBUG2(ql4_printk(KERN_ERR, ha,
-				  "%s: Unable to allocate dma buffer\n",
-				  __func__));
-		goto exit_ddb_del;
-	}
-
 	if (is_qla40XX(ha)) {
 		dev_db_start_offset = FLASH_OFFSET_DB_INFO;
+		dev_db_end_offset = FLASH_OFFSET_DB_END;
+		dev_db_start_offset += (fnode_sess->target_id *
+				       sizeof(*fw_ddb_entry));
+		ddb_size = sizeof(*fw_ddb_entry);
 	} else {
 		dev_db_start_offset = FLASH_RAW_ACCESS_ADDR +
 				      (ha->hw.flt_region_ddb << 2);
@@ -6621,12 +6617,17 @@ static int qla4xxx_sysfs_ddb_delete(struct iscsi_bus_flash_session *fnode_sess)
 		 */
 		if (ha->port_num == 1)
 			dev_db_start_offset += (ha->hw.flt_ddb_size / 2);
-	}
 
-	dev_db_end_offset = dev_db_start_offset + (ha->hw.flt_ddb_size / 2);
-	dev_db_start_offset += (fnode_sess->target_id * sizeof(*fw_ddb_entry));
-	dev_db_start_offset += (void *)&(fw_ddb_entry->cookie) -
-			       (void *)fw_ddb_entry;
+		dev_db_end_offset = dev_db_start_offset +
+				    (ha->hw.flt_ddb_size / 2);
+
+		dev_db_start_offset += (fnode_sess->target_id *
+				       sizeof(*fw_ddb_entry));
+		dev_db_start_offset += (void *)&(fw_ddb_entry->cookie) -
+				       (void *)fw_ddb_entry;
+
+		ddb_size = sizeof(*ddb_cookie);
+	}
 
 	DEBUG2(ql4_printk(KERN_ERR, ha, "%s: start offset=%u, end offset=%u\n",
 			  __func__, dev_db_start_offset, dev_db_end_offset));
@@ -6638,10 +6639,28 @@ static int qla4xxx_sysfs_ddb_delete(struct iscsi_bus_flash_session *fnode_sess)
 		goto exit_ddb_del;
 	}
 
+	pddb = dma_alloc_coherent(&ha->pdev->dev, ddb_size,
+				  &fw_ddb_entry_dma, GFP_KERNEL);
+	if (!pddb) {
+		rc = -ENOMEM;
+		DEBUG2(ql4_printk(KERN_ERR, ha,
+				  "%s: Unable to allocate dma buffer\n",
+				  __func__));
+		goto exit_ddb_del;
+	}
+
+	if (is_qla40XX(ha)) {
+		fw_ddb_entry = pddb;
+		memset(fw_ddb_entry, 0, ddb_size);
+		ddb_cookie = &fw_ddb_entry->cookie;
+	} else {
+		ddb_cookie = pddb;
+	}
+
 	/* invalidate the cookie */
 	*ddb_cookie = 0xFFEE;
 	qla4xxx_set_flash(ha, fw_ddb_entry_dma, dev_db_start_offset,
-			  sizeof(*ddb_cookie), FLASH_OPT_RMW_COMMIT);
+			  ddb_size, FLASH_OPT_RMW_COMMIT);
 
 sysfs_ddb_del:
 	target_id = fnode_sess->target_id;
@@ -6650,9 +6669,9 @@ sysfs_ddb_del:
 		   "%s: session and conn entries for flashnode %u of host %lu deleted\n",
 		   __func__, target_id, ha->host_no);
 exit_ddb_del:
-	if (ddb_cookie)
-		dma_free_coherent(&ha->pdev->dev, sizeof(*ddb_cookie),
-				  ddb_cookie, fw_ddb_entry_dma);
+	if (pddb)
+		dma_free_coherent(&ha->pdev->dev, ddb_size, pddb,
+				  fw_ddb_entry_dma);
 	return rc;
 }
 
-- 
1.8.2.GIT

