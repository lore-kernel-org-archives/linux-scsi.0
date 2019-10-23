Return-Path: <SRS0=dT41=YQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2100ACA9EB7
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 05:29:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D82DF2084C
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 05:29:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KCqS8fQb";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="m/bTf4Bd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388713AbfJWF3m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Oct 2019 01:29:42 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:45944 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731266AbfJWF3l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2019 01:29:41 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 376C560A34; Wed, 23 Oct 2019 05:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571808580;
        bh=0LW3KGK8NnBBT2U7/OrsWHSQgB36Jc/7xhcvT2p59Ik=;
        h=From:To:Cc:Subject:Date:From;
        b=KCqS8fQbzR8/N8aaNpiTmrqt2LP4cElg3pqkVGWS0L4Q98rQmUV1p4NFW0QNQU0iY
         AqKZWTrM8J66t5oVgIwIlukNz0i0UE4F2oN3KGlqL4lFxmgp/T+XYeO4GvPhc07lZw
         2IdXhRn8ieT/vH3bKAoqZ7GxUXMc5pURqQjNeAEM=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5132A60953;
        Wed, 23 Oct 2019 05:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571808574;
        bh=0LW3KGK8NnBBT2U7/OrsWHSQgB36Jc/7xhcvT2p59Ik=;
        h=From:To:Cc:Subject:Date:From;
        b=m/bTf4BdF+6+2nGRcuxuXR6WqsQcTj8sKTC7KALamnbH9YeXAGTcIjJ/hbCKyTRD7
         /FAXevmJ+UXwDlAsUI54qlB3E2pzDDjih68/cAQYlAQPnpytt+mS1yopgSJ8WLGc6b
         2e2xKq/1Qden4SE8Kh17WMjnYN1Y9fhbUggz6j5U=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5132A60953
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Evan Green <evgreen@chromium.org>,
        Janek Kotas <jank@cadence.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 1/1] scsi: ufs: Add command logging infrastructure
Date:   Tue, 22 Oct 2019 22:29:12 -0700
Message-Id: <1571808560-3965-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add the necessary infrastructure to keep timestamp history
of commands, events and other useful info for debugging
complex issues. This helps in diagnosing events leading
upto failure.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/Kconfig  |  12 +++
 drivers/scsi/ufs/ufshcd.c | 214 +++++++++++++++++++++++++++++++++++++++-------
 drivers/scsi/ufs/ufshcd.h |  24 +++++-
 3 files changed, 218 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 0b845ab..afc70cb 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -50,6 +50,18 @@ config SCSI_UFSHCD
 	  However, do not compile this as a module if your root file system
 	  (the one containing the directory /) is located on a UFS device.
 
+config SCSI_UFSHCD_CMD_LOGGING
+	bool "Universal Flash Storage host controller driver layer command logging support"
+	depends on SCSI_UFSHCD
+	help
+	  This selects the UFS host controller driver layer command logging.
+	  UFS host controller driver layer command logging records all the
+	  command information sent from UFS host controller for debugging
+	  purpose.
+
+	  Select this if you want above mentioned debug information captured.
+	  If unsure, say N.
+
 config SCSI_UFSHCD_PCI
 	tristate "PCI bus based UFS Controller support"
 	depends on SCSI_UFSHCD && PCI
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c28c144..f3faa85 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -91,6 +91,9 @@
 /* default delay of autosuspend: 2000 ms */
 #define RPM_AUTOSUSPEND_DELAY_MS 2000
 
+/* Maximum command logging entries */
+#define UFSHCD_MAX_CMD_LOGGING	20
+
 #define ufshcd_toggle_vreg(_dev, _vreg, _on)				\
 	({                                                              \
 		int _ret;                                               \
@@ -328,14 +331,135 @@ static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 			&descp->input_param1);
 }
 
-static void ufshcd_add_command_trace(struct ufs_hba *hba,
-		unsigned int tag, const char *str)
+static inline void ufshcd_add_command_trace(struct ufs_hba *hba,
+			struct ufshcd_cmd_log_entry *entry)
+{
+	if (trace_ufshcd_command_enabled()) {
+		u32 intr = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
+
+		trace_ufshcd_command(dev_name(hba->dev), entry->str, entry->tag,
+				     entry->doorbell, entry->transfer_len, intr,
+				     entry->lba, entry->cmd_id);
+	}
+}
+
+#ifdef CONFIG_SCSI_UFSHCD_CMD_LOGGING
+static void ufshcd_cmd_log_init(struct ufs_hba *hba)
+{
+	/* Allocate log entries */
+	if (!hba->cmd_log.entries) {
+		hba->cmd_log.entries = kcalloc(UFSHCD_MAX_CMD_LOGGING,
+			sizeof(struct ufshcd_cmd_log_entry), GFP_KERNEL);
+		if (!hba->cmd_log.entries)
+			return;
+		dev_dbg(hba->dev, "%s: cmd_log.entries initialized\n",
+				__func__);
+	}
+}
+
+static void __ufshcd_cmd_log(struct ufs_hba *hba, char *str, char *cmd_type,
+			     unsigned int tag, u8 cmd_id, u8 idn, u8 lun,
+			     sector_t lba, int transfer_len)
+{
+	struct ufshcd_cmd_log_entry *entry;
+
+	if (!hba->cmd_log.entries)
+		return;
+
+	entry = &hba->cmd_log.entries[hba->cmd_log.pos];
+	entry->lun = lun;
+	entry->str = str;
+	entry->cmd_type = cmd_type;
+	entry->cmd_id = cmd_id;
+	entry->lba = lba;
+	entry->transfer_len = transfer_len;
+	entry->idn = idn;
+	entry->doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
+	entry->tag = tag;
+	entry->tstamp = ktime_get();
+	entry->outstanding_reqs = hba->outstanding_reqs;
+	entry->seq_num = hba->cmd_log.seq_num;
+	hba->cmd_log.seq_num++;
+	hba->cmd_log.pos = (hba->cmd_log.pos + 1) % UFSHCD_MAX_CMD_LOGGING;
+
+	ufshcd_add_command_trace(hba, entry);
+}
+
+static void ufshcd_cmd_log(struct ufs_hba *hba, char *str, char *cmd_type,
+	unsigned int tag, u8 cmd_id, u8 idn)
+{
+	__ufshcd_cmd_log(hba, str, cmd_type, tag, cmd_id, idn, 0, 0, 0);
+}
+
+static void ufshcd_dme_cmd_log(struct ufs_hba *hba, char *str, u8 cmd_id)
+{
+	ufshcd_cmd_log(hba, str, "dme", 0, cmd_id, 0);
+}
+
+static void ufshcd_print_cmd_log(struct ufs_hba *hba)
+{
+	int i;
+	int pos;
+	struct ufshcd_cmd_log_entry *p;
+
+	if (!hba->cmd_log.entries)
+		return;
+
+	pos = hba->cmd_log.pos;
+	for (i = 0; i < UFSHCD_MAX_CMD_LOGGING; i++) {
+		p = &hba->cmd_log.entries[pos];
+		pos = (pos + 1) % UFSHCD_MAX_CMD_LOGGING;
+
+		if (ktime_to_us(p->tstamp)) {
+			pr_err("%s: %s: seq_no=%u lun=0x%x cmd_id=0x%02x lba=0x%llx txfer_len=%d tag=%u, doorbell=0x%x outstanding=0x%x idn=%d time=%lld us\n",
+				p->cmd_type, p->str, p->seq_num,
+				p->lun, p->cmd_id, (unsigned long long)p->lba,
+				p->transfer_len, p->tag, p->doorbell,
+				p->outstanding_reqs, p->idn,
+				ktime_to_us(p->tstamp));
+				usleep_range(1000, 1100);
+		}
+	}
+}
+#else
+static void ufshcd_cmd_log_init(struct ufs_hba *hba)
+{
+}
+
+static void __ufshcd_cmd_log(struct ufs_hba *hba, char *str, char *cmd_type,
+			     unsigned int tag, u8 cmd_id, u8 idn, u8 lun,
+			     sector_t lba, int transfer_len)
+{
+	struct ufshcd_cmd_log_entry entry;
+
+	entry.str = str;
+	entry.lba = lba;
+	entry.cmd_id = cmd_id;
+	entry.transfer_len = transfer_len;
+	entry.doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
+	entry.tag = tag;
+
+	ufshcd_add_command_trace(hba, &entry);
+}
+
+static void ufshcd_dme_cmd_log(struct ufs_hba *hba, char *str, u8 cmd_id)
+{
+}
+
+static void ufshcd_print_cmd_log(struct ufs_hba *hba)
+{
+}
+#endif
+
+static inline void ufshcd_cond_add_cmd_trace(struct ufs_hba *hba,
+					unsigned int tag, const char *str)
 {
-	sector_t lba = -1;
-	u8 opcode = 0;
-	u32 intr, doorbell;
 	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
-	int transfer_len = -1;
+	char *cmd_type = NULL;
+	u8 opcode = 0;
+	u8 cmd_id = 0, idn = 0;
+	sector_t lba = 0;
+	int transfer_len = 0;
 
 	if (!trace_ufshcd_command_enabled()) {
 		/* trace UPIU W/O tracing command */
@@ -361,10 +485,23 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba,
 		}
 	}
 
-	intr = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
-	doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
-	trace_ufshcd_command(dev_name(hba->dev), str, tag,
-				doorbell, transfer_len, intr, lba, opcode);
+	if (lrbp->cmd && ((lrbp->command_type == UTP_CMD_TYPE_SCSI) ||
+			  (lrbp->command_type == UTP_CMD_TYPE_UFS_STORAGE))) {
+		cmd_type = "scsi";
+		cmd_id = (u8)(*lrbp->cmd->cmnd);
+	} else if (lrbp->command_type == UTP_CMD_TYPE_DEV_MANAGE) {
+		if (hba->dev_cmd.type == DEV_CMD_TYPE_NOP) {
+			cmd_type = "nop";
+			cmd_id = 0;
+		} else if (hba->dev_cmd.type == DEV_CMD_TYPE_QUERY) {
+			cmd_type = "query";
+			cmd_id = hba->dev_cmd.query.request.upiu_req.opcode;
+			idn = hba->dev_cmd.query.request.upiu_req.idn;
+		}
+	}
+
+	__ufshcd_cmd_log(hba, (char *) str, cmd_type, tag, cmd_id, idn,
+			 lrbp->lun, lba, transfer_len);
 }
 
 static void ufshcd_print_clk_freqs(struct ufs_hba *hba)
@@ -1886,7 +2023,8 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
 	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	/* Make sure that doorbell is committed immediately */
 	wmb();
-	ufshcd_add_command_trace(hba, task_tag, "send");
+	ufshcd_cond_add_cmd_trace(hba, task_tag,
+			hba->lrb[task_tag].cmd ? "scsi_send" : "dev_cmd_send");
 }
 
 /**
@@ -2001,6 +2139,7 @@ static inline u8 ufshcd_get_upmcrs(struct ufs_hba *hba)
 
 	hba->active_uic_cmd = uic_cmd;
 
+	ufshcd_dme_cmd_log(hba, "dme_send", hba->active_uic_cmd->command);
 	/* Write Args */
 	ufshcd_writel(hba, uic_cmd->argument1, REG_UIC_COMMAND_ARG_1);
 	ufshcd_writel(hba, uic_cmd->argument2, REG_UIC_COMMAND_ARG_2);
@@ -2031,6 +2170,8 @@ static inline u8 ufshcd_get_upmcrs(struct ufs_hba *hba)
 	else
 		ret = -ETIMEDOUT;
 
+	ufshcd_dme_cmd_log(hba, "dme_cmpl_1", hba->active_uic_cmd->command);
+
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	hba->active_uic_cmd = NULL;
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
@@ -3797,11 +3938,14 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 			cmd->command, status);
 		ret = (status != PWR_OK) ? status : -1;
 	}
+	ufshcd_dme_cmd_log(hba, "dme_cmpl_2", hba->active_uic_cmd->command);
+
 out:
 	if (ret) {
 		ufshcd_print_host_state(hba);
 		ufshcd_print_pwr_info(hba);
 		ufshcd_print_host_regs(hba);
+		ufshcd_print_cmd_log(hba);
 	}
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
@@ -4712,6 +4856,7 @@ static void ufshcd_slave_destroy(struct scsi_device *sdev)
 	int result = 0;
 	int scsi_status;
 	int ocs;
+	bool print_prdt;
 
 	/* overall command status of utrd */
 	ocs = ufshcd_get_tr_ocs(lrbp);
@@ -4787,8 +4932,11 @@ static void ufshcd_slave_destroy(struct scsi_device *sdev)
 		break;
 	} /* end of switch */
 
-	if (host_byte(result) != DID_OK)
-		ufshcd_print_trs(hba, 1 << lrbp->task_tag, true);
+	if (host_byte(result) != DID_OK) {
+		print_prdt = (ocs == OCS_INVALID_PRDT_ATTR ||
+				ocs == OCS_MISMATCH_DATA_BUF_SIZE);
+		ufshcd_print_trs(hba, 1 << lrbp->task_tag, print_prdt);
+	}
 	return result;
 }
 
@@ -4828,7 +4976,7 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 		lrbp = &hba->lrb[index];
 		cmd = lrbp->cmd;
 		if (cmd) {
-			ufshcd_add_command_trace(hba, index, "complete");
+			ufshcd_cond_add_cmd_trace(hba, index, "scsi_cmpl");
 			result = ufshcd_transfer_rsp_status(hba, lrbp);
 			scsi_dma_unmap(cmd);
 			cmd->result = result;
@@ -4841,8 +4989,8 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 		} else if (lrbp->command_type == UTP_CMD_TYPE_DEV_MANAGE ||
 			lrbp->command_type == UTP_CMD_TYPE_UFS_STORAGE) {
 			if (hba->dev_cmd.complete) {
-				ufshcd_add_command_trace(hba, index,
-						"dev_complete");
+				ufshcd_cond_add_cmd_trace(hba, index,
+						"dev_cmd_cmpl");
 				complete(hba->dev_cmd.complete);
 			}
 		}
@@ -5307,6 +5455,23 @@ static void ufshcd_err_handler(struct work_struct *work)
 		if (!ret)
 			goto skip_err_handling;
 	}
+
+	/*
+	 * Dump controller state before resetting. Transfer requests state
+	 * will be dump as part of the request completion.
+	 */
+	if (hba->saved_err & (INT_FATAL_ERRORS | UIC_ERROR)) {
+		dev_err(hba->dev, "%s: saved_err 0x%x saved_uic_err 0x%x\n",
+			__func__, hba->saved_err, hba->saved_uic_err);
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		ufshcd_print_host_regs(hba);
+		ufshcd_print_host_state(hba);
+		ufshcd_print_pwr_info(hba);
+		ufshcd_print_tmrs(hba, hba->outstanding_tasks);
+		ufshcd_print_cmd_log(hba);
+		spin_lock_irqsave(hba->host->host_lock, flags);
+	}
+
 	if ((hba->saved_err & INT_FATAL_ERRORS) ||
 	    (hba->saved_err & UFSHCD_UIC_HIBERN8_MASK) ||
 	    ((hba->saved_err & UIC_ERROR) &&
@@ -5523,21 +5688,6 @@ static void ufshcd_check_errors(struct ufs_hba *hba)
 
 			hba->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED;
 
-			/* dump controller state before resetting */
-			if (hba->saved_err & (INT_FATAL_ERRORS | UIC_ERROR)) {
-				bool pr_prdt = !!(hba->saved_err &
-						SYSTEM_BUS_FATAL_ERROR);
-
-				dev_err(hba->dev, "%s: saved_err 0x%x saved_uic_err 0x%x\n",
-					__func__, hba->saved_err,
-					hba->saved_uic_err);
-
-				ufshcd_print_host_regs(hba);
-				ufshcd_print_pwr_info(hba);
-				ufshcd_print_tmrs(hba, hba->outstanding_tasks);
-				ufshcd_print_trs(hba, hba->outstanding_reqs,
-							pr_prdt);
-			}
 			schedule_work(&hba->eh_work);
 		}
 	}
@@ -8425,6 +8575,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	 */
 	ufshcd_set_ufs_dev_active(hba);
 
+	ufshcd_cmd_log_init(hba);
+
 	async_schedule(ufshcd_async_scan, hba);
 	ufs_sysfs_add_nodes(hba->dev);
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index e0fe247..97cc5b0 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -414,7 +414,7 @@ struct ufs_init_prefetch {
 	u32 icc_level;
 };
 
-#define UFS_ERR_REG_HIST_LENGTH 8
+#define UIC_ERR_REG_HIST_LENGTH 20
 /**
  * struct ufs_err_reg_hist - keeps history of errors
  * @pos: index to indicate cyclic buffer position
@@ -471,6 +471,27 @@ struct ufs_stats {
 	struct ufs_err_reg_hist task_abort;
 };
 
+struct ufshcd_cmd_log_entry {
+	char *str;	/* context like "send", "complete" */
+	char *cmd_type;	/* "scsi", "query", "nop", "dme" */
+	u8 lun;
+	u8 cmd_id;
+	sector_t lba;
+	int transfer_len;
+	u8 idn;		/* used only for query idn */
+	u32 doorbell;
+	u32 outstanding_reqs;
+	u32 seq_num;
+	unsigned int tag;
+	ktime_t tstamp;
+};
+
+struct ufshcd_cmd_log {
+	struct ufshcd_cmd_log_entry *entries;
+	int pos;
+	u32 seq_num;
+};
+
 /**
  * struct ufs_hba - per adapter private structure
  * @mmio_base: UFSHCI base register address
@@ -692,6 +713,7 @@ struct ufs_hba {
 	struct ufs_pwr_mode_info max_pwr_info;
 
 	struct ufs_clk_gating clk_gating;
+	struct ufshcd_cmd_log cmd_log;
 	/* Control to enable/disable host capabilities */
 	u32 caps;
 	/* Allow dynamic clk gating */
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

