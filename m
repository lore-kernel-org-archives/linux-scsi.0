From: vikas.chaudhary@qlogic.com
Subject: [PATCH 08/10] qla4xxx: wait for boot target login response during probe.
Date: Sun, 20 Jan 2013 23:51:03 -0500
Message-ID: <1358743865-435-9-git-send-email-vikas.chaudhary@qlogic.com>
References: <1358743865-435-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:62187 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750926Ab3AUFLk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jan 2013 00:11:40 -0500
In-Reply-To: <1358743865-435-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Manish Rangankar <manish.rangankar@qlogic.com>

From: Manish Rangankar <manish.rangankar@qlogic.com>

Boot from SAN fails in some cases where boot target login response
is slow. In this case, probe finishes early and triggers init, which
doesn't find remote disk to mount root which leads to BFS failure.

Signed-off-by: Manish Rangankar <manish.rangankar@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h |    2 +
 drivers/scsi/qla4xxx/ql4_os.c  |   86 ++++++++++++++++++++++++++++++++++++++--
 2 files changed, 84 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index ad58062..129f5dd 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -181,6 +181,7 @@
 #define DISABLE_ACB_TOV			30
 #define IP_CONFIG_TOV			30
 #define LOGIN_TOV			12
+#define BOOT_LOGIN_RESP_TOV		60
 
 #define MAX_RESET_HA_RETRIES		2
 #define FW_ALIVE_WAIT_TOV		3
@@ -315,6 +316,7 @@ struct ql4_tuple_ddb {
  * DDB flags.
  */
 #define DF_RELOGIN		0	/* Relogin to device */
+#define DF_BOOT_TGT		1	/* Boot target entry */
 #define DF_ISNS_DISCOVERED	2	/* Device was discovered via iSNS */
 #define DF_FO_MASKED		3
 
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 2ccbb3b..b8acc40 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -4728,7 +4728,8 @@ static int qla4xxx_verify_boot_idx(struct scsi_qla_host *ha, uint16_t idx)
 }
 
 static void qla4xxx_setup_flash_ddb_entry(struct scsi_qla_host *ha,
-					  struct ddb_entry *ddb_entry)
+					  struct ddb_entry *ddb_entry,
+					  uint16_t idx)
 {
 	uint16_t def_timeout;
 
@@ -4748,6 +4749,10 @@ static void qla4xxx_setup_flash_ddb_entry(struct scsi_qla_host *ha,
 		def_timeout : LOGIN_TOV;
 	ddb_entry->default_time2wait =
 		le16_to_cpu(ddb_entry->fw_ddb_entry.iscsi_def_time2wait);
+
+	if (ql4xdisablesysfsboot &&
+	    (idx == ha->pri_ddb_idx || idx == ha->sec_ddb_idx))
+		set_bit(DF_BOOT_TGT, &ddb_entry->flags);
 }
 
 static void qla4xxx_wait_for_ip_configuration(struct scsi_qla_host *ha)
@@ -4884,7 +4889,7 @@ static void qla4xxx_remove_failed_ddb(struct scsi_qla_host *ha,
 
 static int qla4xxx_sess_conn_setup(struct scsi_qla_host *ha,
 				   struct dev_db_entry *fw_ddb_entry,
-				   int is_reset)
+				   int is_reset, uint16_t idx)
 {
 	struct iscsi_cls_session *cls_sess;
 	struct iscsi_session *sess;
@@ -4922,7 +4927,7 @@ static int qla4xxx_sess_conn_setup(struct scsi_qla_host *ha,
 	memcpy(&ddb_entry->fw_ddb_entry, fw_ddb_entry,
 	       sizeof(struct dev_db_entry));
 
-	qla4xxx_setup_flash_ddb_entry(ha, ddb_entry);
+	qla4xxx_setup_flash_ddb_entry(ha, ddb_entry, idx);
 
 	cls_conn = iscsi_conn_setup(cls_sess, sizeof(struct qla_conn), conn_id);
 
@@ -5039,7 +5044,7 @@ static void qla4xxx_build_nt_list(struct scsi_qla_host *ha,
 				goto continue_next_nt;
 		}
 
-		ret = qla4xxx_sess_conn_setup(ha, fw_ddb_entry, is_reset);
+		ret = qla4xxx_sess_conn_setup(ha, fw_ddb_entry, is_reset, idx);
 		if (ret == QLA_ERROR)
 			goto exit_nt_list;
 
@@ -5119,6 +5124,78 @@ void qla4xxx_build_ddb_list(struct scsi_qla_host *ha, int is_reset)
 }
 
 /**
+ * qla4xxx_wait_login_resp_boot_tgt -  Wait for iSCSI boot target login
+ * response.
+ * @ha: pointer to adapter structure
+ *
+ * When the boot entry is normal iSCSI target then DF_BOOT_TGT flag will be
+ * set in DDB and we will wait for login response of boot targets during
+ * probe.
+ **/
+static void qla4xxx_wait_login_resp_boot_tgt(struct scsi_qla_host *ha)
+{
+	struct ddb_entry *ddb_entry;
+	struct dev_db_entry *fw_ddb_entry = NULL;
+	dma_addr_t fw_ddb_entry_dma;
+	unsigned long wtime;
+	uint32_t ddb_state;
+	int max_ddbs, idx, ret;
+
+	max_ddbs =  is_qla40XX(ha) ? MAX_DEV_DB_ENTRIES_40XX :
+				     MAX_DEV_DB_ENTRIES;
+
+	fw_ddb_entry = dma_alloc_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry),
+					  &fw_ddb_entry_dma, GFP_KERNEL);
+	if (!fw_ddb_entry) {
+		ql4_printk(KERN_ERR, ha,
+			   "%s: Unable to allocate dma buffer\n", __func__);
+		goto exit_login_resp;
+	}
+
+	wtime = jiffies + (HZ * BOOT_LOGIN_RESP_TOV);
+
+	for (idx = 0; idx < max_ddbs; idx++) {
+		ddb_entry = qla4xxx_lookup_ddb_by_fw_index(ha, idx);
+		if (ddb_entry == NULL)
+			continue;
+
+		if (test_bit(DF_BOOT_TGT, &ddb_entry->flags)) {
+			DEBUG2(ql4_printk(KERN_INFO, ha,
+					  "%s: DDB index [%d]\n", __func__,
+					  ddb_entry->fw_ddb_index));
+			do {
+				ret = qla4xxx_get_fwddb_entry(ha,
+						ddb_entry->fw_ddb_index,
+						fw_ddb_entry, fw_ddb_entry_dma,
+						NULL, NULL, &ddb_state, NULL,
+						NULL, NULL);
+				if (ret == QLA_ERROR)
+					goto exit_login_resp;
+
+				if ((ddb_state == DDB_DS_SESSION_ACTIVE) ||
+				    (ddb_state == DDB_DS_SESSION_FAILED))
+					break;
+
+				schedule_timeout_uninterruptible(HZ);
+
+			} while ((time_after(wtime, jiffies)));
+
+			if (!time_after(wtime, jiffies)) {
+				DEBUG2(ql4_printk(KERN_INFO, ha,
+						  "%s: Login response wait timer expired\n",
+						  __func__));
+				 goto exit_login_resp;
+			}
+		}
+	}
+
+exit_login_resp:
+	if (fw_ddb_entry)
+		dma_free_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry),
+				  fw_ddb_entry, fw_ddb_entry_dma);
+}
+
+/**
  * qla4xxx_probe_adapter - callback function to probe HBA
  * @pdev: pointer to pci_dev structure
  * @pci_device_id: pointer to pci_device entry
@@ -5371,6 +5448,7 @@ skip_retry_init:
 		/* Perform the build ddb list and login to each */
 	qla4xxx_build_ddb_list(ha, INIT_ADAPTER);
 	iscsi_host_for_each_session(ha->host, qla4xxx_login_flash_ddb);
+	qla4xxx_wait_login_resp_boot_tgt(ha);
 
 	qla4xxx_create_chap_list(ha);
 
-- 
1.7.8.GIT

