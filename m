From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 15/24] qla4xxx: Reduce rom-lock contention during reset recovery.
Date: Mon, 16 Dec 2013 06:49:45 -0500
Message-ID: <1387194594-29817-16-git-send-email-vikas.chaudhary@qlogic.com>
References: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:37650 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754324Ab3LPMXm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Dec 2013 07:23:42 -0500
In-Reply-To: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Issue:
Driver holds rom-lock for too long during reset recovery.

During adapter reset testing, it was found that the driver
holds the rom-lock for too long, because of which other
drivers fail to acquire the rom-lock, leading to reset
failures.
The primary cause is, in the bootstrap code, while
holding the rom-lock, the driver checks if the peg is
halted, causing a 2 second contention.

Fix:
When a reset recovery starts, the driver deduces the cause, and
sets appropriate flags in watchdog & recover_adapter routines.
This flag should be used to determine if bootstrap is invoked
from probe or reset context, reducing the rom-lock footprint of
the drivers.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_nx.c | 33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index d2040b4..63328c8 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -2828,37 +2828,28 @@ int qla4_8xxx_device_bootstrap(struct scsi_qla_host *ha)
 	int rval = QLA_ERROR;
 	int i;
 	uint32_t old_count, count;
-	int need_reset = 0, peg_stuck = 1;
+	int need_reset = 0;
 
 	need_reset = ha->isp_ops->need_reset(ha);
-	old_count = qla4_8xxx_rd_direct(ha, QLA8XXX_PEG_ALIVE_COUNTER);
-
-	for (i = 0; i < 10; i++) {
-		msleep(200);
-		count = qla4_8xxx_rd_direct(ha, QLA8XXX_PEG_ALIVE_COUNTER);
-		if (count != old_count)
-			peg_stuck = 0;
-	}
 
 	if (need_reset) {
 		/* We are trying to perform a recovery here. */
-		if (peg_stuck)
+		if (test_bit(AF_FW_RECOVERY, &ha->flags))
 			ha->isp_ops->rom_lock_recovery(ha);
-		goto dev_initialize;
 	} else  {
-		/* Start of day for this ha context. */
-		if (peg_stuck) {
-			/* Either we are the first or recovery in progress. */
-			ha->isp_ops->rom_lock_recovery(ha);
-			goto dev_initialize;
-		} else {
-			/* Firmware already running. */
-			rval = QLA_SUCCESS;
-			goto dev_ready;
+		old_count = qla4_8xxx_rd_direct(ha, QLA8XXX_PEG_ALIVE_COUNTER);
+		for (i = 0; i < 10; i++) {
+			msleep(200);
+			count = qla4_8xxx_rd_direct(ha,
+						    QLA8XXX_PEG_ALIVE_COUNTER);
+			if (count != old_count) {
+				rval = QLA_SUCCESS;
+				goto dev_ready;
+			}
 		}
+		ha->isp_ops->rom_lock_recovery(ha);
 	}
 
-dev_initialize:
 	/* set to DEV_INITIALIZING */
 	ql4_printk(KERN_INFO, ha, "HW State: INITIALIZING\n");
 	qla4_8xxx_wr_direct(ha, QLA8XXX_CRB_DEV_STATE,
-- 
1.8.2.GIT

