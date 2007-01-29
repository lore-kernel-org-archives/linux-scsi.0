From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 8/14] qla2xxx: Check loop-state before reading host statistics.
Date: Mon, 29 Jan 2007 10:22:25 -0800
Message-ID: <11700949511417-git-send-email-andrew.vasquez@qlogic.com>
References: <20070129182124.GA26940@andrew-vasquezs-computer.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:47719 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbXA2SWh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jan 2007 13:22:37 -0500
In-Reply-To: <20070129182124.GA26940@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Non-ISP24xx cards must have a loop-id in order to query host
statistics.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 78a5867..834c404 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -885,21 +885,24 @@ qla2x00_get_fc_host_stats(struct Scsi_Host *shost)
 	link_stat_t stat_buf;
 	struct fc_host_statistics *pfc_host_stat;
 
+	rval = QLA_FUNCTION_FAILED;
 	pfc_host_stat = &ha->fc_host_stat;
 	memset(pfc_host_stat, -1, sizeof(struct fc_host_statistics));
 
 	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
 		rval = qla24xx_get_isp_stats(ha, (uint32_t *)&stat_buf,
 		    sizeof(stat_buf) / 4, mb_stat);
-	} else {
+	} else if (atomic_read(&ha->loop_state) == LOOP_READY &&
+		    !test_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags) &&
+		    !test_bit(ISP_ABORT_NEEDED, &ha->dpc_flags) &&
+		    !ha->dpc_active) {
+		/* Must be in a 'READY' state for statistics retrieval. */
 		rval = qla2x00_get_link_status(ha, ha->loop_id, &stat_buf,
 		    mb_stat);
 	}
-	if (rval != 0) {
-		qla_printk(KERN_WARNING, ha,
-		    "Unable to retrieve host statistics (%d).\n", mb_stat[0]);
-		return pfc_host_stat;
-	}
+
+	if (rval != QLA_SUCCESS)
+		goto done;
 
 	pfc_host_stat->link_failure_count = stat_buf.link_fail_cnt;
 	pfc_host_stat->loss_of_sync_count = stat_buf.loss_sync_cnt;
@@ -907,7 +910,7 @@ qla2x00_get_fc_host_stats(struct Scsi_Host *shost)
 	pfc_host_stat->prim_seq_protocol_err_count = stat_buf.prim_seq_err_cnt;
 	pfc_host_stat->invalid_tx_word_count = stat_buf.inval_xmit_word_cnt;
 	pfc_host_stat->invalid_crc_count = stat_buf.inval_crc_cnt;
-
+done:
 	return pfc_host_stat;
 }
 
-- 
1.5.0.rc2.gdbaa0

