From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 4/9] qla4xxx: Don't recover adapter if device state is FAILED
Date: Thu, 1 Dec 2011 22:42:09 -0800
Message-ID: <1322808134-21665-5-git-send-email-vikas.chaudhary@qlogic.com>
References: <1322808134-21665-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:1703 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab1LBGzx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Dec 2011 01:55:53 -0500
In-Reply-To: <1322808134-21665-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, poornima.vonti@qlogic.com, Sarang Radke <sarang.radke@qlogic.com>

From: Sarang Radke <sarang.radke@qlogic.com>

Multiple reset request don't get handled correctly as
the driver tries to recover adapter which is in FAILED state.

JIRA Key: UPSISCSI-198

Signed-off-by: Sarang Radke <sarang.radke@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index d9a6aa5..c5ae676 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -2414,6 +2414,7 @@ static int qla4xxx_recover_adapter(struct scsi_qla_host *ha)
 {
 	int status = QLA_ERROR;
 	uint8_t reset_chip = 0;
+	uint32_t dev_state;
 
 	/* Stall incoming I/O until we are done */
 	scsi_block_requests(ha->host);
@@ -2501,6 +2502,25 @@ recover_ha_init_adapter:
 		 * Since we don't want to block the DPC for too long
 		 * with multiple resets in the same thread,
 		 * utilize DPC to retry */
+		if (is_qla8022(ha)) {
+			qla4_8xxx_idc_lock(ha);
+			dev_state = qla4_8xxx_rd_32(ha, QLA82XX_CRB_DEV_STATE);
+			qla4_8xxx_idc_unlock(ha);
+			if (dev_state == QLA82XX_DEV_FAILED) {
+				ql4_printk(KERN_INFO, ha, "%s: don't retry "
+					   "recover adapter. H/W is in Failed "
+					   "state\n", __func__);
+				qla4xxx_dead_adapter_cleanup(ha);
+				clear_bit(DPC_RETRY_RESET_HA, &ha->dpc_flags);
+				clear_bit(DPC_RESET_HA, &ha->dpc_flags);
+				clear_bit(DPC_RESET_HA_FW_CONTEXT,
+						&ha->dpc_flags);
+				status = QLA_ERROR;
+
+				goto exit_recover;
+			}
+		}
+
 		if (!test_bit(DPC_RETRY_RESET_HA, &ha->dpc_flags)) {
 			ha->retry_reset_ha_cnt = MAX_RESET_HA_RETRIES;
 			DEBUG2(printk("scsi%ld: recover adapter - retrying "
@@ -2539,6 +2559,7 @@ recover_ha_init_adapter:
 		clear_bit(DPC_RETRY_RESET_HA, &ha->dpc_flags);
 	}
 
+exit_recover:
 	ha->adapter_error_count++;
 
 	if (test_bit(AF_ONLINE, &ha->flags))
-- 
1.7.8.rc2.3.g0911


