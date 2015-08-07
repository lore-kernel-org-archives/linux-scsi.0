From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH 3/7] megaraid_sas : Chip reset if driver fail to bring ioc ready
Date: Fri, 7 Aug 2015 17:54:02 +0530
Message-ID: <201508071230.t77CUI9R021131@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bastion.smtp.avagotech.com ([199.3.246.86]:60045 "EHLO
	sgpsmtp2.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069AbbHGMfp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2015 08:35:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, kiran-kumar.kasturi@avagotech.com
Cc: uday.lingala@avagotech.com

Patch which fix the issue reported as below.

http://marc.info/?l=linux-scsi&m=143694494104544&w=2

This patch will try to do chip reset from driver load time.
Driver load time, if firmware is not comming to ready state, driver try chip reset calling
adp_reset() callback. For fusion adapter, that call back was void, so it will not do any chip reset.

Now, using this patch megasas_adp_reset_fusion() will have chip reset logic for Fusion adapter.

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
---

diff --git a/megaraid_sas_fusion.c b/megaraid_sas_fusion.c
index a065da7..c31750a 100644
--- a/megaraid_sas_fusion.c
+++ b/megaraid_sas_fusion.c
@@ -2509,6 +2509,70 @@ static int
 megasas_adp_reset_fusion(struct megasas_instance *instance,
 			 struct megasas_register_set __iomem *regs)
 {
+	u32 host_diag, abs_state, retry;
+
+	/* Now try to reset the chip */
+	writel(MPI2_WRSEQ_FLUSH_KEY_VALUE, &instance->reg_set->fusion_seq_offset);
+	writel(MPI2_WRSEQ_1ST_KEY_VALUE, &instance->reg_set->fusion_seq_offset);
+	writel(MPI2_WRSEQ_2ND_KEY_VALUE, &instance->reg_set->fusion_seq_offset);
+	writel(MPI2_WRSEQ_3RD_KEY_VALUE, &instance->reg_set->fusion_seq_offset);
+	writel(MPI2_WRSEQ_4TH_KEY_VALUE, &instance->reg_set->fusion_seq_offset);
+	writel(MPI2_WRSEQ_5TH_KEY_VALUE, &instance->reg_set->fusion_seq_offset);
+	writel(MPI2_WRSEQ_6TH_KEY_VALUE, &instance->reg_set->fusion_seq_offset);
+
+	/* Check that the diag write enable (DRWE) bit is on */
+	host_diag = readl(&instance->reg_set->fusion_host_diag);
+	retry = 0;
+	while (!(host_diag & HOST_DIAG_WRITE_ENABLE)) {
+		msleep(100);
+		host_diag = readl(&instance->reg_set->fusion_host_diag);
+		if (retry++ == 100) {
+			dev_warn(&instance->pdev->dev,
+				"Host diag unlock failed from %s %d\n",
+				__func__, __LINE__);
+			break;
+		}
+	}
+	if (!(host_diag & HOST_DIAG_WRITE_ENABLE))
+		return -1;
+
+	/* Send chip reset command */
+	writel(host_diag | HOST_DIAG_RESET_ADAPTER,
+		&instance->reg_set->fusion_host_diag);
+	msleep(3000);
+
+	/* Make sure reset adapter bit is cleared */
+	host_diag = readl(&instance->reg_set->fusion_host_diag);
+	retry = 0;
+	while (host_diag & HOST_DIAG_RESET_ADAPTER) {
+		msleep(100);
+		host_diag = readl(&instance->reg_set->fusion_host_diag);
+		if (retry++ == 1000) {
+			dev_warn(&instance->pdev->dev,
+				"Diag reset adapter never cleared %s %d\n",
+				__func__, __LINE__);
+			break;
+		}
+	}
+	if (host_diag & HOST_DIAG_RESET_ADAPTER)
+		return -1;
+
+	abs_state = instance->instancet->read_fw_status_reg(instance->reg_set)
+			& MFI_STATE_MASK;
+	retry = 0;
+
+	while ((abs_state <= MFI_STATE_FW_INIT) && (retry++ < 1000)) {
+		msleep(100);
+		abs_state = instance->instancet->
+			read_fw_status_reg(instance->reg_set) & MFI_STATE_MASK;
+	}
+	if (abs_state <= MFI_STATE_FW_INIT) {
+		dev_warn(&instance->pdev->dev,
+			"fw state < MFI_STATE_FW_INIT, state = 0x%x %s %d\n",
+			abs_state, __func__, __LINE__);
+		return -1;
+	}
+
 	return 0;
 }
 
@@ -2674,11 +2738,11 @@ out:
 /* Core fusion reset function */
 int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 {
-	int retval = SUCCESS, i, retry = 0, convert = 0;
+	int retval = SUCCESS, i, convert = 0;
 	struct megasas_instance *instance;
 	struct megasas_cmd_fusion *cmd_fusion;
 	struct fusion_context *fusion;
-	u32 host_diag, abs_state, status_reg, reset_adapter;
+	u32 abs_state, status_reg, reset_adapter;
 	u32 io_timeout_in_crash_mode = 0;
 	struct scsi_cmnd *scmd_local = NULL;
 
@@ -2832,81 +2896,10 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 
 		/* Now try to reset the chip */
 		for (i = 0; i < MEGASAS_FUSION_MAX_RESET_TRIES; i++) {
-			writel(MPI2_WRSEQ_FLUSH_KEY_VALUE,
-			       &instance->reg_set->fusion_seq_offset);
-			writel(MPI2_WRSEQ_1ST_KEY_VALUE,
-			       &instance->reg_set->fusion_seq_offset);
-			writel(MPI2_WRSEQ_2ND_KEY_VALUE,
-			       &instance->reg_set->fusion_seq_offset);
-			writel(MPI2_WRSEQ_3RD_KEY_VALUE,
-			       &instance->reg_set->fusion_seq_offset);
-			writel(MPI2_WRSEQ_4TH_KEY_VALUE,
-			       &instance->reg_set->fusion_seq_offset);
-			writel(MPI2_WRSEQ_5TH_KEY_VALUE,
-			       &instance->reg_set->fusion_seq_offset);
-			writel(MPI2_WRSEQ_6TH_KEY_VALUE,
-			       &instance->reg_set->fusion_seq_offset);
-
-			/* Check that the diag write enable (DRWE) bit is on */
-			host_diag = readl(&instance->reg_set->fusion_host_diag);
-			retry = 0;
-			while (!(host_diag & HOST_DIAG_WRITE_ENABLE)) {
-				msleep(100);
-				host_diag =
-				readl(&instance->reg_set->fusion_host_diag);
-				if (retry++ == 100) {
-					printk(KERN_WARNING "megaraid_sas: "
-					       "Host diag unlock failed! "
-					       "for scsi%d\n",
-						instance->host->host_no);
-					break;
-				}
-			}
-			if (!(host_diag & HOST_DIAG_WRITE_ENABLE))
-				continue;
-
-			/* Send chip reset command */
-			writel(host_diag | HOST_DIAG_RESET_ADAPTER,
-			       &instance->reg_set->fusion_host_diag);
-			msleep(3000);
-
-			/* Make sure reset adapter bit is cleared */
-			host_diag = readl(&instance->reg_set->fusion_host_diag);
-			retry = 0;
-			while (host_diag & HOST_DIAG_RESET_ADAPTER) {
-				msleep(100);
-				host_diag =
-				readl(&instance->reg_set->fusion_host_diag);
-				if (retry++ == 1000) {
-					printk(KERN_WARNING "megaraid_sas: "
-					       "Diag reset adapter never "
-					       "cleared for scsi%d!\n",
-						instance->host->host_no);
-					break;
-				}
-			}
-			if (host_diag & HOST_DIAG_RESET_ADAPTER)
-				continue;
 
-			abs_state =
-				instance->instancet->read_fw_status_reg(
-					instance->reg_set) & MFI_STATE_MASK;
-			retry = 0;
-
-			while ((abs_state <= MFI_STATE_FW_INIT) &&
-			       (retry++ < 1000)) {
-				msleep(100);
-				abs_state =
-				instance->instancet->read_fw_status_reg(
-					instance->reg_set) & MFI_STATE_MASK;
-			}
-			if (abs_state <= MFI_STATE_FW_INIT) {
-				printk(KERN_WARNING "megaraid_sas: firmware "
-				       "state < MFI_STATE_FW_INIT, state = "
-				       "0x%x for scsi%d\n", abs_state,
-					instance->host->host_no);
+			if (instance->instancet->adp_reset
+				(instance, instance->reg_set))
 				continue;
-			}
 
 			/* Wait for FW to become ready */
 			if (megasas_transition_to_ready(instance, 1)) {
-- 
1.8.3.1

