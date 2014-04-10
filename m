From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 2/6] qla4xxx: Export sysfs DDBs from DPC handler
Date: Wed, 9 Apr 2014 21:12:25 -0400
Message-ID: <1397092349-25332-3-git-send-email-vikas.chaudhary@qlogic.com>
References: <1397092349-25332-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:31825 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933779AbaDJBvn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Apr 2014 21:51:43 -0400
In-Reply-To: <1397092349-25332-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, giridhar.malavali@qlogic.com, Nilesh Javali <nilesh.javali@qlogic.com>

From: Nilesh Javali <nilesh.javali@qlogic.com>

Issue:
modprobe qla4xxx is killed by systemd due to timeout.

Solution:
The exporting of sysfs DDBs from qla4xxx_probe_adapter added delay of
approximately 15s due to which system-udevd killed the modprobe of the
driver. Added fix to export the sysfs DDBs from the DPC handler.

Signed-off-by: Nilesh Javali <nilesh.javali@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h  |  1 +
 drivers/scsi/qla4xxx/ql4_glbl.h |  1 +
 drivers/scsi/qla4xxx/ql4_os.c   | 15 +++++++++------
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 73a5022..8f6d0fb 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -601,6 +601,7 @@ struct scsi_qla_host {
 #define DPC_HA_NEED_QUIESCENT		22 /* 0x00400000 ISP-82xx only*/
 #define DPC_POST_IDC_ACK		23 /* 0x00800000 */
 #define DPC_RESTORE_ACB			24 /* 0x01000000 */
+#define DPC_SYSFS_DDB_EXPORT		25 /* 0x02000000 */
 
 	struct Scsi_Host *host; /* pointer to host data */
 	uint32_t tot_ddbs;
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index 2035475..5f58b45 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -281,6 +281,7 @@ int qla4_83xx_get_port_config(struct scsi_qla_host *ha, uint32_t *config);
 int qla4_83xx_set_port_config(struct scsi_qla_host *ha, uint32_t *config);
 int qla4_8xxx_check_init_adapter_retry(struct scsi_qla_host *ha);
 int qla4_83xx_is_detached(struct scsi_qla_host *ha);
+int qla4xxx_sysfs_ddb_export(struct scsi_qla_host *ha);
 
 extern int ql4xextended_error_logging;
 extern int ql4xdontresethba;
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index bb16040..9be829b 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -4565,6 +4565,7 @@ static void qla4xxx_timer(struct scsi_qla_host *ha)
 	     test_bit(DPC_LINK_CHANGED, &ha->dpc_flags) ||
 	     test_bit(DPC_HA_UNRECOVERABLE, &ha->dpc_flags) ||
 	     test_bit(DPC_HA_NEED_QUIESCENT, &ha->dpc_flags) ||
+	     test_bit(DPC_SYSFS_DDB_EXPORT, &ha->dpc_flags) ||
 	     test_bit(DPC_AEN, &ha->dpc_flags)) {
 		DEBUG2(printk("scsi%ld: %s: scheduling dpc routine"
 			      " - dpc flags = 0x%lx\n",
@@ -5429,6 +5430,11 @@ dpc_post_reset_ha:
 				qla4xxx_relogin_all_devices(ha);
 		}
 	}
+	if (test_and_clear_bit(DPC_SYSFS_DDB_EXPORT, &ha->dpc_flags)) {
+		if (qla4xxx_sysfs_ddb_export(ha))
+			ql4_printk(KERN_ERR, ha, "%s: Error exporting ddb to sysfs\n",
+				   __func__);
+	}
 }
 
 /**
@@ -8406,7 +8412,7 @@ exit_ddb_del:
  *
  * Export the firmware DDB for all send targets and normal targets to sysfs.
  **/
-static int qla4xxx_sysfs_ddb_export(struct scsi_qla_host *ha)
+int qla4xxx_sysfs_ddb_export(struct scsi_qla_host *ha)
 {
 	struct dev_db_entry *fw_ddb_entry = NULL;
 	dma_addr_t fw_ddb_entry_dma;
@@ -8844,11 +8850,8 @@ skip_retry_init:
 		ql4_printk(KERN_ERR, ha,
 			   "%s: No iSCSI boot target configured\n", __func__);
 
-	if (qla4xxx_sysfs_ddb_export(ha))
-		ql4_printk(KERN_ERR, ha,
-			   "%s: Error exporting ddb to sysfs\n", __func__);
-
-		/* Perform the build ddb list and login to each */
+	set_bit(DPC_SYSFS_DDB_EXPORT, &ha->dpc_flags);
+	/* Perform the build ddb list and login to each */
 	qla4xxx_build_ddb_list(ha, INIT_ADAPTER);
 	iscsi_host_for_each_session(ha->host, qla4xxx_login_flash_ddb);
 	qla4xxx_wait_login_resp_boot_tgt(ha);
-- 
1.8.2.GIT

