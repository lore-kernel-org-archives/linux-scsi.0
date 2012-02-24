From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH v2 3/5] [SCSI] ufshcd: UFSHCI error handling
Date: Fri, 24 Feb 2012 12:49:03 +0530
Message-ID: <1330067945-9128-4-git-send-email-santoshsy@gmail.com>
References: <1330067945-9128-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1330067945-9128-1-git-send-email-santoshsy@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, arnd@linaro.org, girish.shivananjappa@linaro.org, saugata.das@linaro.org, vishak.g@samsung.com, venkat@linaro.org, k.rajesh@samsung.com, yejin.moon@samsung.com, dsaxena@linaro.org, ilho215.lee@samsung.com, nala.la@samsung.com, stephen.doel@linaro.org, sreekumar.c@samsung.com, Santosh Yaraganavi <santoshsy@gmail.com>, Vinayak Holikatti <vinholikatti@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Santosh Yaraganavi <santoshsy@gmail.com>

UFSHCI error handling includes support for:
 - UFS host controller errors
 - System bus errors
 - Unipro errors

Signed-off-by: Santosh Yaraganavi <santoshsy@gmail.com>
Signed-off-by: Vinayak Holikatti <vinholikatti@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@linaro.org>
Reviewed-by: Vishak G <vishak.g@samsung.com>
Reviewed-by: Girish K S <girish.shivananjappa@linaro.org>
---
v1 -> v2:
	- ufshcd_do_reset(): change return value to SUCCESS/FAILED,
	  since the function can also be called from UFSHCD registered
	  SCSI midlayer error handling routines.
	  Ex: .eh_host_reset_handler which expects return value
	  SUCCESS/FAILED
	- ufshcd_do_reset(): aquire spin_lock_irqsave only for
	  instructions which share common data structure.

 drivers/scsi/ufs/ufshcd.c |   97 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 97 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e4335f5..1c6a9ed 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -139,6 +139,8 @@ struct uic_command {
  * @ufshcd_state: UFSHCD states
  * @int_enable_mask: Interrupt Mask Bits
  * @uic_workq: Work queue for UIC completion handling
+ * @feh_workq: Work queue for fatal controller error handling
+ * @errors: HBA errors
  */
 struct ufs_hba {
 	void __iomem *mmio_base;
@@ -172,6 +174,10 @@ struct ufs_hba {
 
 	/* Work Queues */
 	struct work_struct uic_workq;
+	struct work_struct feh_workq;
+
+	/* HBA Errors */
+	u32 errors;
 };
 
 /**
@@ -896,6 +902,9 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
 	/* Configure interrupt aggregation */
 	ufshcd_config_int_aggr(hba, INT_AGGR_CONFIG);
 
+	if (hba->ufshcd_state == UFSHCD_STATE_RESET)
+		scsi_unblock_requests(hba->host);
+
 	hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
 	scsi_scan_host(hba->host);
 out:
@@ -997,6 +1006,51 @@ static int ufshcd_initialize_hba(struct ufs_hba *hba)
 }
 
 /**
+ * ufshcd_do_reset - reset the host controller
+ * @hba: per adapter instance
+ *
+ * Returns SUCCESS/FAILED
+ */
+static int ufshcd_do_reset(struct ufs_hba *hba)
+{
+	struct ufshcd_lrb *lrbp;
+	unsigned long flags;
+	int tag;
+
+	/* block commands from midlayer */
+	scsi_block_requests(hba->host);
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	hba->ufshcd_state = UFSHCD_STATE_RESET;
+
+	/* send controller to reset state */
+	ufshcd_hba_stop(hba);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	/* abort outstanding commands */
+	for (tag = 0; tag < hba->nutrs; tag++) {
+		if (test_bit(tag, &hba->outstanding_reqs)) {
+			lrbp = &hba->lrb[tag];
+			scsi_dma_unmap(lrbp->cmd);
+			lrbp->cmd->result = DID_RESET << 16;
+			lrbp->cmd->scsi_done(lrbp->cmd);
+			lrbp->cmd = NULL;
+		}
+	}
+
+	/* clear outstanding request bit maps */
+	hba->outstanding_reqs = 0;
+
+	/* start the initialization process */
+	if (ufshcd_initialize_hba(hba)) {
+		dev_err(&hba->pdev->dev,
+			"Reset: Controller initialization failed\n");
+		return FAILED;
+	}
+	return SUCCESS;
+}
+
+/**
  * ufshcd_slave_alloc - handle initial SCSI device configurations
  * @sdev: pointer to SCSI device
  *
@@ -1248,12 +1302,54 @@ static void ufshcd_uic_cc_handler (struct work_struct *work)
 }
 
 /**
+ * ufshcd_fatal_err_handler - handle fatal errors
+ * @hba: per adapter instance
+ */
+static void ufshcd_fatal_err_handler(struct work_struct *work)
+{
+	struct ufs_hba *hba;
+	hba = container_of(work, struct ufs_hba, feh_workq);
+
+	/* check if reset is already in progress */
+	if (hba->ufshcd_state != UFSHCD_STATE_RESET)
+		ufshcd_do_reset(hba);
+}
+
+/**
+ * ufshcd_err_handler - Check for fatal errors
+ * @work: pointer to a work queue structure
+ */
+static void ufshcd_err_handler(struct ufs_hba *hba)
+{
+	u32 reg;
+
+	if (hba->errors & INT_FATAL_ERRORS)
+		goto fatal_eh;
+
+	if (hba->errors & UIC_ERROR) {
+
+		reg = readl(hba->mmio_base +
+			    REG_UIC_ERROR_CODE_PHY_ADAPTER_LAYER);
+		if (reg & UIC_DATA_LINK_LAYER_ERROR_PA_INIT)
+			goto fatal_eh;
+	}
+	return;
+fatal_eh:
+	hba->ufshcd_state = UFSHCD_STATE_ERROR;
+	schedule_work(&hba->feh_workq);
+}
+
+/**
  * ufshcd_sl_intr - Interrupt service routine
  * @hba: per adapter instance
  * @intr_status: contains interrupts generated by the controller
  */
 static void ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
 {
+	hba->errors = UFSHCD_ERROR_MASK & intr_status;
+	if (hba->errors)
+		ufshcd_err_handler(hba);
+
 	if (intr_status & UIC_COMMAND_COMPL)
 		schedule_work(&hba->uic_workq);
 
@@ -1499,6 +1595,7 @@ ufshcd_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	/* Initialize work queues */
 	INIT_WORK(&hba->uic_workq, ufshcd_uic_cc_handler);
+	INIT_WORK(&hba->feh_workq, ufshcd_fatal_err_handler);
 
 	/* IRQ registration */
 	err = request_irq(pdev->irq, ufshcd_intr, IRQF_SHARED, UFSHCD, hba);
-- 
1.7.5.4
