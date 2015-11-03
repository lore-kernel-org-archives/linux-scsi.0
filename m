From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Subject: [PATCH v2 1/5] ipr: Add delay to ensure coherent dumps.
Date: Tue,  3 Nov 2015 16:26:06 -0200
Message-ID: <1446575170-18656-1-git-send-email-krisman@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:43877 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169AbbKCS02 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2015 13:26:28 -0500
Received: from /spool/local
	by e24smtp05.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <krisman@linux.vnet.ibm.com>;
	Tue, 3 Nov 2015 16:26:26 -0200
Received: from d24relay03.br.ibm.com (d24relay03.br.ibm.com [9.13.184.25])
	by d24dlp02.br.ibm.com (Postfix) with ESMTP id 385D91DC007C
	for <linux-scsi@vger.kernel.org>; Tue,  3 Nov 2015 13:25:20 -0500 (EST)
Received: from d24av01.br.ibm.com (d24av01.br.ibm.com [9.8.31.91])
	by d24relay03.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tA3IOYLA8782166
	for <linux-scsi@vger.kernel.org>; Tue, 3 Nov 2015 16:24:34 -0200
Received: from d24av01.br.ibm.com (localhost [127.0.0.1])
	by d24av01.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tA3IQNaF011774
	for <linux-scsi@vger.kernel.org>; Tue, 3 Nov 2015 16:26:23 -0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, manoj@linux.vnet.ibm.com, Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>

Add a holding pattern prior to collecting dump data, to wait for the IOA
indication that the Mailbox register is stable and won't change without
an explicit reset.  This ensures we'll be collecting meaningful dump
data, even when dumping right after an adapter reset.

In the event of a timeout, we still force the dump, since a partial dump
still might be useful.

Changes since v1:
	- Fix checkpatch.pl warnings.

Signed-off-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c | 51 +++++++++++++++++++++++++++++++++++++++------------
 drivers/scsi/ipr.h |  3 +++
 2 files changed, 42 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index b62836d..238efab 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -8277,6 +8277,42 @@ static int ipr_reset_get_unit_check_job(struct ipr_cmnd *ipr_cmd)
 	return IPR_RC_JOB_RETURN;
 }
 
+static int ipr_dump_mailbox_wait(struct ipr_cmnd *ipr_cmd)
+{
+	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
+
+	ENTER;
+
+	if (ioa_cfg->sdt_state != GET_DUMP)
+		return IPR_RC_JOB_RETURN;
+
+	if (!ioa_cfg->sis64 || !ipr_cmd->u.time_left ||
+	    (readl(ioa_cfg->regs.sense_interrupt_reg) &
+	     IPR_PCII_MAILBOX_STABLE)) {
+
+		if (!ipr_cmd->u.time_left)
+			dev_err(&ioa_cfg->pdev->dev,
+				"Timed out waiting for Mailbox register.\n");
+
+		ioa_cfg->sdt_state = READ_DUMP;
+		ioa_cfg->dump_timeout = 0;
+		if (ioa_cfg->sis64)
+			ipr_reset_start_timer(ipr_cmd, IPR_SIS64_DUMP_TIMEOUT);
+		else
+			ipr_reset_start_timer(ipr_cmd, IPR_SIS32_DUMP_TIMEOUT);
+		ipr_cmd->job_step = ipr_reset_wait_for_dump;
+		schedule_work(&ioa_cfg->work_q);
+
+	} else {
+		ipr_cmd->u.time_left -= IPR_CHECK_FOR_RESET_TIMEOUT;
+		ipr_reset_start_timer(ipr_cmd,
+				      IPR_CHECK_FOR_RESET_TIMEOUT);
+	}
+
+	LEAVE;
+	return IPR_RC_JOB_RETURN;
+}
+
 /**
  * ipr_reset_restore_cfg_space - Restore PCI config space.
  * @ipr_cmd:	ipr command struct
@@ -8326,20 +8362,11 @@ static int ipr_reset_restore_cfg_space(struct ipr_cmnd *ipr_cmd)
 
 	if (ioa_cfg->in_ioa_bringdown) {
 		ipr_cmd->job_step = ipr_ioa_bringdown_done;
+	} else if (ioa_cfg->sdt_state == GET_DUMP) {
+		ipr_cmd->job_step = ipr_dump_mailbox_wait;
+		ipr_cmd->u.time_left = IPR_WAIT_FOR_MAILBOX;
 	} else {
 		ipr_cmd->job_step = ipr_reset_enable_ioa;
-
-		if (GET_DUMP == ioa_cfg->sdt_state) {
-			ioa_cfg->sdt_state = READ_DUMP;
-			ioa_cfg->dump_timeout = 0;
-			if (ioa_cfg->sis64)
-				ipr_reset_start_timer(ipr_cmd, IPR_SIS64_DUMP_TIMEOUT);
-			else
-				ipr_reset_start_timer(ipr_cmd, IPR_SIS32_DUMP_TIMEOUT);
-			ipr_cmd->job_step = ipr_reset_wait_for_dump;
-			schedule_work(&ioa_cfg->work_q);
-			return IPR_RC_JOB_RETURN;
-		}
 	}
 
 	LEAVE;
diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index e4fb17a..69257c4 100644
--- a/drivers/scsi/ipr.h
+++ b/drivers/scsi/ipr.h
@@ -279,6 +279,9 @@
 #define IPR_IPL_INIT_STAGE_TIME_MASK			0x0000ffff
 #define IPR_PCII_IPL_STAGE_CHANGE			(0x80000000 >> 0)
 
+#define IPR_PCII_MAILBOX_STABLE				(0x80000000 >> 4)
+#define IPR_WAIT_FOR_MAILBOX				(2 * HZ)
+
 #define IPR_PCII_IOA_TRANS_TO_OPER			(0x80000000 >> 0)
 #define IPR_PCII_IOARCB_XFER_FAILED			(0x80000000 >> 3)
 #define IPR_PCII_IOA_UNIT_CHECKED			(0x80000000 >> 4)
-- 
2.1.0

