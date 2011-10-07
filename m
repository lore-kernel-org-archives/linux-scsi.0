From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH v2 07/14] qla4xxx: Free Device Database (DDB) reserved by FW
Date: Fri, 7 Oct 2011 16:55:45 -0700
Message-ID: <1318031752-3836-8-git-send-email-vikas.chaudhary@qlogic.com>
References: <1318031752-3836-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:32550
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754798Ab1JHAH1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Oct 2011 20:07:27 -0400
In-Reply-To: <1318031752-3836-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

Firmware reserves DDBs if there are entries in the FLASH.
So there are no free DDBs left when a iSCSI login is initiated
by user space tool like iscsiadm.
Since now login is not controlled by firmware, LLD need to free
up the DDBs after firmware init. This will ensure free DDBs are
available for iSCSI logins using iscsiadm.

JIRA Key: UPSISCSI-151

Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_init.c |   40 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index b0bffe1..064a3a3 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -765,6 +765,44 @@ int qla4xxx_start_firmware(struct scsi_qla_host *ha)
 	}
 	return status;
 }
+/**
+ * qla4xxx_free_ddb_index - Free DDBs reserved by firmware
+ * @ha: pointer to adapter structure
+ *
+ * Since firmware is not running in autoconnect mode the DDB indices should
+ * be freed so that when login happens from user space there are free DDB
+ * indices available.
+ **/
+static void qla4xxx_free_ddb_index(struct scsi_qla_host *ha)
+{
+	int max_ddbs;
+	int ret;
+	uint32_t idx = 0, next_idx = 0;
+	uint32_t state = 0, conn_err = 0;
+
+	max_ddbs =  is_qla40XX(ha) ? MAX_PRST_DEV_DB_ENTRIES :
+				     MAX_DEV_DB_ENTRIES;
+
+	for (idx = 0; idx < max_ddbs; idx = next_idx) {
+		ret = qla4xxx_get_fwddb_entry(ha, idx, NULL, 0, NULL,
+					      &next_idx, &state, &conn_err,
+						NULL, NULL);
+		if (ret == QLA_ERROR)
+			continue;
+		if (state == DDB_DS_NO_CONNECTION_ACTIVE ||
+		    state == DDB_DS_SESSION_FAILED) {
+			DEBUG2(ql4_printk(KERN_INFO, ha,
+					  "Freeing DDB index = 0x%x\n", idx));
+			ret = qla4xxx_clear_ddb_entry(ha, idx);
+			if (ret == QLA_ERROR)
+				ql4_printk(KERN_ERR, ha,
+					   "Unable to clear DDB index = "
+					   "0x%x\n", idx);
+		}
+		if (next_idx == 0)
+			break;
+	}
+}
 
 
 /**
@@ -802,6 +840,8 @@ int qla4xxx_initialize_adapter(struct scsi_qla_host *ha)
 	if (status == QLA_ERROR)
 		goto exit_init_hba;
 
+	qla4xxx_free_ddb_index(ha);
+
 	set_bit(AF_ONLINE, &ha->flags);
 exit_init_hba:
 	if (is_qla8022(ha) && (status == QLA_ERROR)) {
-- 
1.7.6


