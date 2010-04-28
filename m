From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 05/11] qla4xxx: do not retry login to CHAP auth failed
	targets
Date: Wed, 28 Apr 2010 11:41:21 +0530
Message-ID: <20100428061121.GA11150@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:65028
	"HELO sles11sp1b1.site" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1750744Ab0D1GPM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Apr 2010 02:15:12 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Karen Higgins <karen.higgins@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

Per RFC 3720, Login Response Status Code 0x02 should not be retried.
Condensed connection error checking code to a single routine, and
added check for status class 0x02.

Signed-off-by: Karen Higgins <karen.higgins@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_glbl.h |    5 +-
 drivers/scsi/qla4xxx/ql4_init.c |  130 +++++++++++++++++++++++++++------------
 drivers/scsi/qla4xxx/ql4_isr.c  |    2 +-
 3 files changed, 94 insertions(+), 43 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index 96ebfb0..987658f 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -67,11 +67,12 @@ struct srb * qla4xxx_del_from_active_array(struct scsi_qla_host *ha,
 					uint32_t index);
 void qla4xxx_srb_compl(struct scsi_qla_host *ha, struct srb *srb);
 int qla4xxx_reinitialize_ddb_list(struct scsi_qla_host * ha);
-int qla4xxx_process_ddb_changed(struct scsi_qla_host * ha,
-				uint32_t fw_ddb_index, uint32_t state);
+int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
+		uint32_t state, uint32_t conn_error);
 void qla4xxx_dump_buffer(void *b, uint32_t size);
 int qla4xxx_send_marker_iocb(struct scsi_qla_host *ha,
 	struct ddb_entry *ddb_entry, int lun, uint16_t mrkr_mod);
+int qla4_is_relogin_allowed(struct scsi_qla_host *ha, uint32_t conn_err);
 
 extern int ql4xextended_error_logging;
 extern int ql4xdiscoverywait;
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index beaeb18..5510df8 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -505,6 +505,7 @@ static int qla4xxx_update_ddb_entry(struct scsi_qla_host *ha,
 	struct dev_db_entry *fw_ddb_entry = NULL;
 	dma_addr_t fw_ddb_entry_dma;
 	int status = QLA_ERROR;
+	uint32_t conn_err;
 
 	if (ddb_entry == NULL) {
 		DEBUG2(printk("scsi%ld: %s: ddb_entry is NULL\n", ha->host_no,
@@ -525,7 +526,7 @@ static int qla4xxx_update_ddb_entry(struct scsi_qla_host *ha,
 
 	if (qla4xxx_get_fwddb_entry(ha, fw_ddb_index, fw_ddb_entry,
 				    fw_ddb_entry_dma, NULL, NULL,
-				    &ddb_entry->fw_ddb_device_state, NULL,
+				    &ddb_entry->fw_ddb_device_state, &conn_err,
 				    &ddb_entry->tcp_source_port_num,
 				    &ddb_entry->connection_id) ==
 	    QLA_ERROR) {
@@ -578,12 +579,26 @@ static int qla4xxx_update_ddb_entry(struct scsi_qla_host *ha,
 			fw_ddb_entry->link_local_ipv6_addr,
 			min(sizeof(ddb_entry->link_local_ipv6_addr),
 			sizeof(fw_ddb_entry->link_local_ipv6_addr)));
-	}
-
-	DEBUG2(printk("scsi%ld: %s: ddb[%d] - State= %x status= %d.\n",
-			ha->host_no, __func__, fw_ddb_index,
-			ddb_entry->fw_ddb_device_state, status));
 
+		DEBUG2(dev_info(&ha->pdev->dev, "%s: DDB[%d] osIdx = %d "
+					"State %04x ConnErr %08x IP %pI6 "
+					":%04d \"%s\"\n",
+					__func__, fw_ddb_index,
+					ddb_entry->os_target_id,
+					ddb_entry->fw_ddb_device_state,
+					conn_err, fw_ddb_entry->ip_addr,
+					le16_to_cpu(fw_ddb_entry->port),
+					fw_ddb_entry->iscsi_name));
+	} else
+		DEBUG2(dev_info(&ha->pdev->dev, "%s: DDB[%d] osIdx = %d "
+					"State %04x ConnErr %08x IP %pI4 "
+					":%04d \"%s\"\n",
+					__func__, fw_ddb_index,
+					ddb_entry->os_target_id,
+					ddb_entry->fw_ddb_device_state,
+					conn_err, fw_ddb_entry->ip_addr,
+					le16_to_cpu(fw_ddb_entry->port),
+					fw_ddb_entry->iscsi_name));
 exit_update_ddb:
 	if (fw_ddb_entry)
 		dma_free_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry),
@@ -630,6 +645,40 @@ static struct ddb_entry * qla4xxx_alloc_ddb(struct scsi_qla_host *ha,
 }
 
 /**
+ * qla4_is_relogin_allowed - Are we allowed to login?
+ * @ha: Pointer to host adapter structure.
+ * @conn_err: Last connection error associated with the ddb
+ *
+ * This routine tests the given connection error to determine if
+ * we are allowed to login.
+ **/
+int qla4_is_relogin_allowed(struct scsi_qla_host *ha, uint32_t conn_err)
+{
+	uint32_t err_code, login_rsp_sts_class;
+	int relogin = 1;
+
+	err_code = ((conn_err & 0x00ff0000) >> 16);
+	login_rsp_sts_class = ((conn_err & 0x0000ff00) >> 8);
+	if (err_code == 0x1c || err_code == 0x06) {
+		DEBUG2(dev_info(&ha->pdev->dev,
+				": conn_err=0x%08x, send target completed"
+				" or access denied failure\n", conn_err));
+		relogin = 0;
+	}
+	if ((err_code == 0x08) && (login_rsp_sts_class == 0x02)) {
+		/* Login Response PDU returned an error.
+		   Login Response Status in Error Code Detail
+		   indicates login should not be retried.*/
+		DEBUG2(dev_info(&ha->pdev->dev,
+				": conn_err=0x%08x, do not retry relogin\n",
+				conn_err));
+		relogin = 0;
+	}
+
+	return relogin;
+}
+
+/**
  * qla4xxx_configure_ddbs - builds driver ddb list
  * @ha: Pointer to host adapter structure.
  *
@@ -643,18 +692,30 @@ static int qla4xxx_build_ddb_list(struct scsi_qla_host *ha)
 	uint32_t fw_ddb_index = 0;
 	uint32_t next_fw_ddb_index = 0;
 	uint32_t ddb_state;
-	uint32_t conn_err, err_code;
+	uint32_t conn_err;
 	struct ddb_entry *ddb_entry;
+	struct dev_db_entry *fw_ddb_entry = NULL;
+	dma_addr_t fw_ddb_entry_dma;
+	uint32_t ipv6_device;
 	uint32_t new_tgt;
 
+	fw_ddb_entry = dma_alloc_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry),
+			&fw_ddb_entry_dma, GFP_KERNEL);
+	if (fw_ddb_entry == NULL) {
+		DEBUG2(dev_info(&ha->pdev->dev, "%s: DMA alloc failed\n",
+				__func__));
+		return QLA_ERROR;
+	}
+
 	dev_info(&ha->pdev->dev, "Initializing DDBs ...\n");
 	for (fw_ddb_index = 0; fw_ddb_index < MAX_DDB_ENTRIES;
 	     fw_ddb_index = next_fw_ddb_index) {
 		/* First, let's see if a device exists here */
-		if (qla4xxx_get_fwddb_entry(ha, fw_ddb_index, NULL, 0, NULL,
-					    &next_fw_ddb_index, &ddb_state,
-					    &conn_err, NULL, NULL) ==
-		    QLA_ERROR) {
+		if (qla4xxx_get_fwddb_entry(ha, fw_ddb_index, fw_ddb_entry,
+					    0, NULL, &next_fw_ddb_index,
+					    &ddb_state, &conn_err,
+					    NULL, NULL) ==
+					    QLA_ERROR) {
 			DEBUG2(printk("scsi%ld: %s: get_ddb_entry, "
 				      "fw_ddb_index %d failed", ha->host_no,
 				      __func__, fw_ddb_index));
@@ -671,18 +732,19 @@ static int qla4xxx_build_ddb_list(struct scsi_qla_host *ha)
 			/* Try and login to device */
 			DEBUG2(printk("scsi%ld: %s: Login to DDB[%d]\n",
 				      ha->host_no, __func__, fw_ddb_index));
-			err_code = ((conn_err & 0x00ff0000) >> 16);
-			if (err_code == 0x1c || err_code == 0x06) {
-				DEBUG2(printk("scsi%ld: %s send target "
-					      "completed "
-					      "or access denied failure\n",
-					      ha->host_no, __func__));
-			} else {
+			ipv6_device = le16_to_cpu(fw_ddb_entry->options) &
+					DDB_OPT_IPV6_DEVICE;
+			if (qla4_is_relogin_allowed(ha, conn_err) &&
+					((!ipv6_device &&
+					  *((uint32_t *)fw_ddb_entry->ip_addr))
+					 || ipv6_device)) {
 				qla4xxx_set_ddb_entry(ha, fw_ddb_index, 0);
 				if (qla4xxx_get_fwddb_entry(ha, fw_ddb_index,
-					NULL, 0, NULL, &next_fw_ddb_index,
-					&ddb_state, &conn_err, NULL, NULL)
-					== QLA_ERROR) {
+							NULL, 0, NULL,
+							&next_fw_ddb_index,
+							&ddb_state, &conn_err,
+							NULL, NULL)
+						== QLA_ERROR) {
 					DEBUG2(printk("scsi%ld: %s:"
 						"get_ddb_entry %d failed\n",
 						ha->host_no,
@@ -737,7 +799,6 @@ next_one:
 struct qla4_relog_scan {
 	int halt_wait;
 	uint32_t conn_err;
-	uint32_t err_code;
 	uint32_t fw_ddb_index;
 	uint32_t next_fw_ddb_index;
 	uint32_t fw_ddb_device_state;
@@ -747,18 +808,7 @@ static int qla4_test_rdy(struct scsi_qla_host *ha, struct qla4_relog_scan *rs)
 {
 	struct ddb_entry *ddb_entry;
 
-	/*
-	 * Don't want to do a relogin if connection
-	 * error is 0x1c.
-	 */
-	rs->err_code = ((rs->conn_err & 0x00ff0000) >> 16);
-	if (rs->err_code == 0x1c || rs->err_code == 0x06) {
-		DEBUG2(printk(
-			       "scsi%ld: %s send target"
-			       " completed or "
-			       "access denied failure\n",
-			       ha->host_no, __func__));
-	} else {
+	if (qla4_is_relogin_allowed(ha, rs->conn_err)) {
 		/* We either have a device that is in
 		 * the process of relogging in or a
 		 * device that is waiting to be
@@ -1411,8 +1461,8 @@ static void qla4xxx_add_device_dynamically(struct scsi_qla_host *ha,
  *
  * This routine processes a Decive Database Changed AEN Event.
  **/
-int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha,
-				uint32_t fw_ddb_index, uint32_t state)
+int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
+		uint32_t state, uint32_t conn_err)
 {
 	struct ddb_entry * ddb_entry;
 	uint32_t old_fw_ddb_device_state;
@@ -1470,13 +1520,13 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha,
 
 		/*
 		 * Relogin if device state changed to a not active state.
-		 * However, do not relogin if this aen is a result of an IOCTL
-		 * logout (DF_NO_RELOGIN) or if this is a discovered device.
+		 * However, do not relogin if a RELOGIN is in process, or
+		 * we are not allowed to relogin to this DDB.
 		 */
 		if (ddb_entry->fw_ddb_device_state == DDB_DS_SESSION_FAILED &&
 		    !test_bit(DF_RELOGIN, &ddb_entry->flags) &&
 		    !test_bit(DF_NO_RELOGIN, &ddb_entry->flags) &&
-		    !test_bit(DF_ISNS_DISCOVERED, &ddb_entry->flags)) {
+		    qla4_is_relogin_allowed(ha, conn_err)) {
 			/*
 			 * This triggers a relogin.  After the relogin_timer
 			 * expires, the relogin gets scheduled.	 We must wait a
@@ -1484,7 +1534,7 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha,
 			 * with failed device_state or a logout response before
 			 * we can issue another relogin.
 			 */
-			/* Firmware padds this timeout: (time2wait +1).
+			/* Firmware pads this timeout: (time2wait +1).
 			 * Driver retry to login should be longer than F/W.
 			 * Otherwise F/W will fail
 			 * set_ddb() mbx cmd with 0x4005 since it still
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index 9db286d..ce5838e 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -838,7 +838,7 @@ void qla4xxx_process_aen(struct scsi_qla_host * ha, uint8_t process_aen)
 				qla4xxx_reinitialize_ddb_list(ha);
 			} else if (mbox_sts[1] == 1) {	/* Specific device. */
 				qla4xxx_process_ddb_changed(ha, mbox_sts[2],
-							    mbox_sts[3]);
+						mbox_sts[3], mbox_sts[4]);
 			}
 			break;
 		}
-- 
1.7.0.5

