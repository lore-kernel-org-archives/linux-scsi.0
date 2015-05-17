From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v1 01/10] scsi: ufs: introduce the capability and quirk for interrupt aggregation
Date: Sun, 17 May 2015 18:54:57 +0300
Message-ID: <1431878106-30579-2-git-send-email-ygardi@codeaurora.org>
References: <1431878106-30579-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1431878106-30579-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, dovl@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

UFS HCI (Host Controller Interface) allows the transfer requests
interrupts to be aggregated to generate the single interrupt but
this can impact the performance. Hence introduce the capability which
gives choice to use the interrupt aggregation capability or not.
By default interrupt aggregation capability is kept disabled.

This change also introduces a quirk for broken interrupt aggregation
feature, as in some UFS controllers, this feature may not work.

Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufshcd.c | 19 ++++++++++++++++---
 drivers/scsi/ufs/ufshcd.h | 21 ++++++++++++++++++++-
 2 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 648a446..9641bcb 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -481,6 +481,15 @@ ufshcd_config_intr_aggr(struct ufs_hba *hba, u8 cnt, u8 tmout)
 }
 
 /**
+ * ufshcd_disable_intr_aggr - Disables interrupt aggregation.
+ * @hba: per adapter instance
+ */
+static inline void ufshcd_disable_intr_aggr(struct ufs_hba *hba)
+{
+	ufshcd_writel(hba, 0, REG_UTP_TRANSFER_REQ_INT_AGG_CONTROL);
+}
+
+/**
  * ufshcd_enable_run_stop_reg - Enable run-stop registers,
  *			When run-stop registers are set to 1, it indicates the
  *			host controller that it can process the requests
@@ -1326,7 +1335,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	lrbp->sense_buffer = cmd->sense_buffer;
 	lrbp->task_tag = tag;
 	lrbp->lun = ufshcd_scsi_to_upiu_lun(cmd->device->lun);
-	lrbp->intr_cmd = false;
+	lrbp->intr_cmd = !ufshcd_is_intr_aggr_allowed(hba) ? true : false;
 	lrbp->command_type = UTP_CMD_TYPE_SCSI;
 
 	/* form UPIU before issuing the command */
@@ -2522,7 +2531,10 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
 	ufshcd_enable_intr(hba, UFSHCD_ENABLE_INTRS);
 
 	/* Configure interrupt aggregation */
-	ufshcd_config_intr_aggr(hba, hba->nutrs - 1, INT_AGGR_DEF_TO);
+	if (ufshcd_is_intr_aggr_allowed(hba))
+		ufshcd_config_intr_aggr(hba, hba->nutrs - 1, INT_AGGR_DEF_TO);
+	else
+		ufshcd_disable_intr_aggr(hba);
 
 	/* Configure UTRL and UTMRL base address registers */
 	ufshcd_writel(hba, lower_32_bits(hba->utrdl_dma_addr),
@@ -3073,7 +3085,8 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
 	 * false interrupt if device completes another request after resetting
 	 * aggregation and before reading the DB.
 	 */
-	ufshcd_reset_intr_aggr(hba);
+	if (ufshcd_is_intr_aggr_allowed(hba))
+		ufshcd_reset_intr_aggr(hba);
 
 	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	completed_reqs = tr_doorbell ^ hba->outstanding_reqs;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index b47ff07..fc8bec9 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -417,11 +417,15 @@ struct ufs_hba {
 	unsigned int irq;
 	bool is_irq_enabled;
 
+	/* Interrupt aggregation support is broken */
+	#define UFSHCD_QUIRK_BROKEN_INTR_AGGR			UFS_BIT(0)
+
 	/*
 	 * delay before each dme command is required as the unipro
 	 * layer has shown instabilities
 	 */
-	#define UFSHCD_QUIRK_DELAY_BEFORE_DME_CMDS		UFS_BIT(0)
+	#define UFSHCD_QUIRK_DELAY_BEFORE_DME_CMDS		UFS_BIT(1)
+
 
 	unsigned int quirks;	/* Deviations from standard UFSHCI spec. */
 
@@ -478,6 +482,12 @@ struct ufs_hba {
 #define UFSHCD_CAP_CLK_SCALING	(1 << 2)
 	/* Allow auto bkops to enabled during runtime suspend */
 #define UFSHCD_CAP_AUTO_BKOPS_SUSPEND (1 << 3)
+	/*
+	 * This capability allows host controller driver to use the UFS HCI's
+	 * interrupt aggregation capability.
+	 * CAUTION: Enabling this might reduce overall UFS throughput.
+	 */
+#define UFSHCD_CAP_INTR_AGGR (1 << 4)
 
 	struct devfreq *devfreq;
 	struct ufs_clk_scaling clk_scaling;
@@ -502,6 +512,15 @@ static inline bool ufshcd_can_autobkops_during_suspend(struct ufs_hba *hba)
 	return hba->caps & UFSHCD_CAP_AUTO_BKOPS_SUSPEND;
 }
 
+static inline bool ufshcd_is_intr_aggr_allowed(struct ufs_hba *hba)
+{
+	if ((hba->caps & UFSHCD_CAP_INTR_AGGR) &&
+	    !(hba->quirks & UFSHCD_QUIRK_BROKEN_INTR_AGGR))
+		return true;
+	else
+		return false;
+}
+
 #define ufshcd_writel(hba, val, reg)	\
 	writel((val), (hba)->mmio_base + (reg))
 #define ufshcd_readl(hba, reg)	\
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
