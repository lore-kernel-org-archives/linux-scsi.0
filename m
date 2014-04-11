From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 41/42] qla2xxx: Remove wait for online from host reset handler.
Date: Fri, 11 Apr 2014 16:54:46 -0400
Message-ID: <1397249687-32666-42-git-send-email-saurav.kashyap@qlogic.com>
References: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:21283 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755133AbaDKVcH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2014 17:32:07 -0400
In-Reply-To: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

This can block progress of the SCSI error handler thread and cause long I/O
outages.  Instead just fail immediately if another reset is going on or we are
accessing flash memory.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |    1 +
 drivers/scsi/qla2xxx/qla_os.c  |   51 ++++------------------------------------
 2 files changed, 6 insertions(+), 46 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 96f7d71..c72ee97b 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -46,6 +46,7 @@
  * |                              |                    | 0x70d7-0x70db  |
  * |                              |                    | 0x70de-0x70df  |
  * | Task Management              |       0x803d       | 0x8000,0x800b  |
+ * |                              |                    | 0x8019         |
  * |                              |                    | 0x8025,0x8026  |
  * |                              |                    | 0x8031,0x8032  |
  * |                              |                    | 0x8039,0x803c  |
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 5a70e24..5a430c7 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -865,51 +865,6 @@ qla2x00_wait_for_hba_ready(scsi_qla_host_t *vha)
 		msleep(1000);
 }
 
-/*
- * qla2x00_wait_for_reset_ready
- *    Wait till the HBA is online after going through
- *    <= MAX_RETRIES_OF_ISP_ABORT  or
- *    finally HBA is disabled ie marked offline or flash
- *    operations are in progress.
- *
- * Input:
- *     ha - pointer to host adapter structure
- *
- * Note:
- *    Does context switching-Release SPIN_LOCK
- *    (if any) before calling this routine.
- *
- * Return:
- *    Success (Adapter is online/no flash ops) : 0
- *    Failed  (Adapter is offline/disabled/flash ops in progress) : 1
- */
-static int
-qla2x00_wait_for_reset_ready(scsi_qla_host_t *vha)
-{
-	int		return_status;
-	unsigned long	wait_online;
-	struct qla_hw_data *ha = vha->hw;
-	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
-
-	wait_online = jiffies + (MAX_LOOP_TIMEOUT * HZ);
-	while (((test_bit(ISP_ABORT_NEEDED, &base_vha->dpc_flags)) ||
-	    test_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags) ||
-	    test_bit(ISP_ABORT_RETRY, &base_vha->dpc_flags) ||
-	    ha->optrom_state != QLA_SWAITING ||
-	    ha->dpc_active) && time_before(jiffies, wait_online))
-		msleep(1000);
-
-	if (base_vha->flags.online &&  ha->optrom_state == QLA_SWAITING)
-		return_status = QLA_SUCCESS;
-	else
-		return_status = QLA_FUNCTION_FAILED;
-
-	ql_dbg(ql_dbg_taskm, vha, 0x8019,
-	    "%s return status=%d.\n", __func__, return_status);
-
-	return return_status;
-}
-
 int
 qla2x00_wait_for_chip_reset(scsi_qla_host_t *vha)
 {
@@ -1274,7 +1229,11 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
 	ql_log(ql_log_info, vha, 0x8018,
 	    "ADAPTER RESET ISSUED nexus=%ld:%d:%d.\n", vha->host_no, id, lun);
 
-	if (qla2x00_wait_for_reset_ready(vha) != QLA_SUCCESS)
+	/*
+	 * No point in issuing another reset if one is active.  Also do not
+	 * attempt a reset if we are updating flash.
+	 */
+	if (qla2x00_reset_active(vha) || ha->optrom_state != QLA_SWAITING)
 		goto eh_host_reset_lock;
 
 	if (vha != base_vha) {
-- 
1.7.7

