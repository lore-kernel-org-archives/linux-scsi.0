From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 34/42] qla2xxx: Don't check for firmware hung during the reset context for ISP82XX.
Date: Fri, 11 Apr 2014 16:54:39 -0400
Message-ID: <1397249687-32666-35-git-send-email-saurav.kashyap@qlogic.com>
References: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:36566 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754985AbaDKVcE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2014 17:32:04 -0400
In-Reply-To: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Tej Prakash <tej.prakash@qlogic.com>

Signed-off-by: Tej Prakash <tej.prakash@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |   43 ++++++++++++----------------------------
 1 files changed, 13 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 190283e..58f3c91 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -2852,47 +2852,30 @@ static int
 qla82xx_device_bootstrap(scsi_qla_host_t *vha)
 {
 	int rval = QLA_SUCCESS;
-	int i, timeout;
+	int i;
 	uint32_t old_count, count;
 	struct qla_hw_data *ha = vha->hw;
-	int need_reset = 0, peg_stuck = 1;
+	int need_reset = 0;
 
 	need_reset = qla82xx_need_reset(ha);
 
-	old_count = qla82xx_rd_32(ha, QLA82XX_PEG_ALIVE_COUNTER);
-
-	for (i = 0; i < 10; i++) {
-		timeout = msleep_interruptible(200);
-		if (timeout) {
-			qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE,
-				QLA8XXX_DEV_FAILED);
-			return QLA_FUNCTION_FAILED;
-		}
-
-		count = qla82xx_rd_32(ha, QLA82XX_PEG_ALIVE_COUNTER);
-		if (count != old_count)
-			peg_stuck = 0;
-	}
-
 	if (need_reset) {
 		/* We are trying to perform a recovery here. */
-		if (peg_stuck)
+		if (ha->flags.isp82xx_fw_hung)
 			qla82xx_rom_lock_recovery(ha);
-		goto dev_initialize;
 	} else  {
-		/* Start of day for this ha context. */
-		if (peg_stuck) {
-			/* Either we are the first or recovery in progress. */
-			qla82xx_rom_lock_recovery(ha);
-			goto dev_initialize;
-		} else
-			/* Firmware already running. */
-			goto dev_ready;
+		old_count = qla82xx_rd_32(ha, QLA82XX_PEG_ALIVE_COUNTER);
+		for (i = 0; i < 10; i++) {
+			msleep(200);
+			count = qla82xx_rd_32(ha, QLA82XX_PEG_ALIVE_COUNTER);
+			if (count != old_count) {
+				rval = QLA_SUCCESS;
+				goto dev_ready;
+			}
+		}
+		qla82xx_rom_lock_recovery(ha);
 	}
 
-	return rval;
-
-dev_initialize:
 	/* set to DEV_INITIALIZING */
 	ql_log(ql_log_info, vha, 0x009e,
 	    "HW State: INITIALIZING.\n");
-- 
1.7.7

