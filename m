From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 5/6] qla2xxx: Prevent enabling target mode for unsupported HBAs.
Date: Wed, 30 Jan 2013 03:34:41 -0500
Message-ID: <1359534882-17069-6-git-send-email-saurav.kashyap@qlogic.com>
References: <1359534882-17069-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:6800 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753558Ab3A3Iz2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jan 2013 03:55:28 -0500
In-Reply-To: <1359534882-17069-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Arun Easi <arun.easi@qlogic.com>

Signed-off-by: Arun Easi <arun.easi@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c    |    2 +-
 drivers/scsi/qla2xxx/qla_def.h    |    1 +
 drivers/scsi/qla2xxx/qla_target.c |    6 ++++++
 3 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index e690d05..f81e938 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -38,7 +38,7 @@
  * | ISP82XX Specific             |       0xb084       | 0xb002,0xb024  |
  * | MultiQ                       |       0xc00c       |		|
  * | Misc                         |       0xd010       |		|
- * | Target Mode		  |	  0xe06f       |		|
+ * | Target Mode		  |	  0xe070       |		|
  * | Target Mode Management	  |	  0xf072       |		|
  * | Target Mode Task Management  |	  0x1000b      |		|
  * ----------------------------------------------------------------------
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index b5fc478..5c42c91 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2798,6 +2798,7 @@ struct qla_hw_data {
 #define IS_PI_SPLIT_DET_CAPABLE(ha)	(IS_PI_SPLIT_DET_CAPABLE_HBA(ha) && \
     (((ha)->fw_attributes_h << 16 | (ha)->fw_attributes) & BIT_22))
 #define IS_ATIO_MSIX_CAPABLE(ha) (IS_QLA83XX(ha))
+#define IS_TGT_MODE_CAPABLE(ha)	(ha->tgt.atio_q_length)
 
 	/* HBA serial number */
 	uint8_t		serial0;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index cb8ea44..61b5d8c 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -4306,6 +4306,12 @@ int qlt_add_target(struct qla_hw_data *ha, struct scsi_qla_host *base_vha)
 	if (!QLA_TGT_MODE_ENABLED())
 		return 0;
 
+	if (!IS_TGT_MODE_CAPABLE(ha)) {
+		ql_log(ql_log_warn, base_vha, 0xe070,
+		    "This adapter does not support target mode.\n");
+		return 0;
+	}
+
 	ql_dbg(ql_dbg_tgt, base_vha, 0xe03b,
 	    "Registering target for host %ld(%p)", base_vha->host_no, ha);
 
-- 
1.7.7

