From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 13/24] qla4xxx: Fix pending IO completion in reset path before initiating chip reset
Date: Mon, 16 Dec 2013 06:49:43 -0500
Message-ID: <1387194594-29817-14-git-send-email-vikas.chaudhary@qlogic.com>
References: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:6753 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754325Ab3LPMXi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Dec 2013 07:23:38 -0500
In-Reply-To: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Tej Parkash <tej.parkash@qlogic.com>

From: Tej Parkash <tej.parkash@qlogic.com>

Issue:
Pending IO wait does not complete after triggering Graceful reset,
causing ack timeout and call traces.

Fix:
1. Reducing the IO command wait timeout before triggering reset,
   as logically also timeout should be less than reset timeout (10sec).
2. Moving the abort IO after chip reset, because only after
   chip reset, driver owns the IO otherwise it is with firmware and can
   still revert back with response.

Signed-off-by: Tej Parkash <tej.parkash@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h |  2 +-
 drivers/scsi/qla4xxx/ql4_os.c  | 16 ++++++++++++----
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 33eae2e..c2deaa0 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -194,7 +194,7 @@
 #define ADAPTER_INIT_TOV		30
 #define ADAPTER_RESET_TOV		180
 #define EXTEND_CMD_TOV			60
-#define WAIT_CMD_TOV			30
+#define WAIT_CMD_TOV			5
 #define EH_WAIT_CMD_TOV			120
 #define FIRMWARE_UP_TOV			60
 #define RESET_FIRMWARE_TOV		30
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 3fec116..a27da31 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -4561,11 +4561,19 @@ static int qla4xxx_cmd_wait(struct scsi_qla_host *ha)
 	uint32_t index = 0;
 	unsigned long flags;
 	struct scsi_cmnd *cmd;
+	unsigned long wtime;
+	uint32_t wtmo;
 
-	unsigned long wtime = jiffies + (WAIT_CMD_TOV * HZ);
+	if (is_qla40XX(ha))
+		wtmo = WAIT_CMD_TOV;
+	else
+		wtmo = ha->nx_reset_timeout / 2;
 
-	DEBUG2(ql4_printk(KERN_INFO, ha, "Wait up to %d seconds for cmds to "
-	    "complete\n", WAIT_CMD_TOV));
+	wtime = jiffies + (wtmo * HZ);
+
+	DEBUG2(ql4_printk(KERN_INFO, ha,
+			  "Wait up to %u seconds for cmds to complete\n",
+			  wtmo));
 
 	while (!time_after_eq(jiffies, wtime)) {
 		spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -4868,11 +4876,11 @@ chip_reset:
 			qla4xxx_cmd_wait(ha);
 
 		qla4xxx_process_aen(ha, FLUSH_DDB_CHANGED_AENS);
-		qla4xxx_abort_active_cmds(ha, DID_RESET << 16);
 		DEBUG2(ql4_printk(KERN_INFO, ha,
 		    "scsi%ld: %s - Performing chip reset..\n",
 		    ha->host_no, __func__));
 		status = ha->isp_ops->reset_chip(ha);
+		qla4xxx_abort_active_cmds(ha, DID_RESET << 16);
 	}
 
 	/* Flush any pending ddb changed AENs */
-- 
1.8.2.GIT

