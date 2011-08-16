From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 11/12] qla2xxx: Issue mailbox command only when firmware hung bit is reset for ISP82xx.
Date: Tue, 16 Aug 2011 11:31:54 -0700
Message-ID: <1313519515-23122-12-git-send-email-chad.dupuis@qlogic.com>
References: <1313519515-23122-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:47121 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050Ab1HPSna (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Aug 2011 14:43:30 -0400
In-Reply-To: <1313519515-23122-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h  |    1 +
 drivers/scsi/qla2xxx/qla_init.c |   26 +++++++------
 drivers/scsi/qla2xxx/qla_nx.c   |   74 +++++++++++++++++++++-----------------
 3 files changed, 56 insertions(+), 45 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index e1aebae..ce32d81 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -574,6 +574,7 @@ extern int qla82xx_mbx_intr_enable(scsi_qla_host_t *);
 extern int qla82xx_mbx_intr_disable(scsi_qla_host_t *);
 extern void qla82xx_start_iocbs(srb_t *);
 extern int qla82xx_fcoe_ctx_reset(scsi_qla_host_t *);
+extern int qla82xx_check_md_needed(scsi_qla_host_t *);
 extern void qla82xx_chip_reset_cleanup(scsi_qla_host_t *);
 extern int qla82xx_mbx_beacon_ctl(scsi_qla_host_t *, int);
 extern char *qdev_state(uint32_t);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 2375e38..f03e915 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1480,13 +1480,19 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
 			if (rval == QLA_SUCCESS) {
 enable_82xx_npiv:
 				fw_major_version = ha->fw_major_version;
-				rval = qla2x00_get_fw_version(vha,
-				    &ha->fw_major_version,
-				    &ha->fw_minor_version,
-				    &ha->fw_subminor_version,
-				    &ha->fw_attributes, &ha->fw_memory_size,
-				    ha->mpi_version, &ha->mpi_capabilities,
-				    ha->phy_version);
+				if (IS_QLA82XX(ha))
+					qla82xx_check_md_needed(vha);
+				else {
+					rval = qla2x00_get_fw_version(vha,
+					    &ha->fw_major_version,
+					    &ha->fw_minor_version,
+					    &ha->fw_subminor_version,
+					    &ha->fw_attributes,
+					    &ha->fw_memory_size,
+					    ha->mpi_version,
+					    &ha->mpi_capabilities,
+					    ha->phy_version);
+				}
 				if (rval != QLA_SUCCESS)
 					goto failed;
 				ha->flags.npiv_supported = 0;
@@ -5441,11 +5447,7 @@ qla82xx_restart_isp(scsi_qla_host_t *vha)
 		clear_bit(ISP_ABORT_RETRY, &vha->dpc_flags);
 
 		/* Update the firmware version */
-		qla2x00_get_fw_version(vha, &ha->fw_major_version,
-		    &ha->fw_minor_version, &ha->fw_subminor_version,
-		    &ha->fw_attributes, &ha->fw_memory_size,
-		    ha->mpi_version, &ha->mpi_capabilities,
-		    ha->phy_version);
+		status = qla82xx_check_md_needed(vha);
 
 		if (ha->fce) {
 			ha->flags.fce_enabled = 1;
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 8620cb4..18e6874 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -3618,44 +3618,52 @@ qla82xx_need_reset_handler(scsi_qla_host_t *vha)
 	}
 }
 
-static void
+int
 qla82xx_check_md_needed(scsi_qla_host_t *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
 	uint16_t fw_major_version, fw_minor_version, fw_subminor_version;
-	uint16_t fw_attributes;
-	uint32_t fw_memory_size, mpi_capabilities;
-	uint8_t	mpi_version[3], phy_version[3];
-
-	if (!ha->fw_dumped) {
-		qla2x00_get_fw_version(vha,
-		    &fw_major_version,
-		    &fw_minor_version,
-		    &fw_subminor_version,
-		    &fw_attributes, &fw_memory_size,
-		    mpi_version, &mpi_capabilities,
-		    phy_version);
-
-		if (fw_major_version != ha->fw_major_version ||
-		    fw_minor_version != ha->fw_minor_version ||
-		    fw_subminor_version != ha->fw_subminor_version) {
-			ql_log(ql_log_info, vha, 0xb02d,
-			    "Firmware version differs "
-			    "Previous version: %d:%d:%d - "
-			    "New version: %d:%d:%d\n",
-			    ha->fw_major_version,
-			    ha->fw_minor_version, ha->fw_subminor_version,
-			    fw_major_version, fw_minor_version,
-			    fw_subminor_version);
-			/* Release MiniDump resources */
-			qla82xx_md_free(vha);
-			/* ALlocate MiniDump resources */
-			qla82xx_md_prep(vha);
+	int rval = QLA_SUCCESS;
+
+	fw_major_version = ha->fw_major_version;
+	fw_minor_version = ha->fw_minor_version;
+	fw_subminor_version = ha->fw_subminor_version;
+
+	rval = qla2x00_get_fw_version(vha, &ha->fw_major_version,
+	    &ha->fw_minor_version, &ha->fw_subminor_version,
+	    &ha->fw_attributes, &ha->fw_memory_size,
+	    ha->mpi_version, &ha->mpi_capabilities,
+	    ha->phy_version);
+
+	if (rval != QLA_SUCCESS)
+		return rval;
+
+	if (ql2xmdenable) {
+		if (!ha->fw_dumped) {
+			if (fw_major_version != ha->fw_major_version ||
+			    fw_minor_version != ha->fw_minor_version ||
+			    fw_subminor_version != ha->fw_subminor_version) {
+
+				ql_log(ql_log_info, vha, 0xb02d,
+				    "Firmware version differs "
+				    "Previous version: %d:%d:%d - "
+				    "New version: %d:%d:%d\n",
+				    ha->fw_major_version,
+				    ha->fw_minor_version,
+				    ha->fw_subminor_version,
+				    fw_major_version, fw_minor_version,
+				    fw_subminor_version);
+				/* Release MiniDump resources */
+				qla82xx_md_free(vha);
+				/* ALlocate MiniDump resources */
+				qla82xx_md_prep(vha);
+			} else
+				ql_log(ql_log_info, vha, 0xb02e,
+				    "Firmware dump available to retrieve\n",
+				    vha->host_no);
 		}
-	} else
-		ql_log(ql_log_info, vha, 0xb02e,
-		    "Firmware dump available to retrieve\n",
-		    vha->host_no);
+	}
+	return rval;
 }
 
 
-- 
1.6.0.2


