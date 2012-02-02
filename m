From: Vinayak Holikatti <vinholikatti@gmail.com>
Subject: [PATCH 3/4] [SCSI] ufshcd: UFSHCI error handling
Date: Thu,  2 Feb 2012 10:27:28 +0530
Message-ID: <1328158649-4137-4-git-send-email-vinholikatti@gmail.com>
References: <1328158649-4137-1-git-send-email-vinholikatti@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1328158649-4137-1-git-send-email-vinholikatti@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, saugata.das@linaro.org, arnd@arndb.de, venkat@linaro.org, girish.shivananjappa@linaro.org, vishak.g@samsung.com, k.rajesh@samsung.com, yejin.moon@samsung.com, Santosh Yaraganavi <santoshsy@gmail.com>, Vinayak Holikatti <vinholikatti@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Santosh Yaraganavi <santoshsy@gmail.com>

UFSHCI error handling includes support for:
 - UFS host controller errors
 - System bus errors
 - Unipro errors

Signed-off-by: Santosh Yaraganavi <santoshsy@gmail.com>
Signed-off-by: Vinayak Holikatti <vinholikatti@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Saugata Das <saugata.das@linaro.org>
Reviewed-by: Vishak G <vishak.g@samsung.com>
Reviewed-by: Girish K S <girish.shivananjappa@linaro.org>
---
 drivers/scsi/ufs/ufshcd.c |  104 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 104 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 23d758b..1bfae84 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -64,6 +64,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_dbg.h>
+#include <scsi/scsi_eh.h>
 
 #include "ufs.h"
 #include "ufshci.h"
@@ -153,9 +154,13 @@ struct uic_command {
  * @nutrs: Transfer Request Queue depth supported by controller
  * @nutmrs: Task Management Queue depth supported by controller
  * @active_uic_cmd: handle of active UIC command
+ * @ufshcd_tm_wait_queue: wait queue for task management
+ * @tm_condition: array of condition varibles for task management
  * @ufshcd_state: UFSHCD states
  * @int_enable_mask: Interrupt Mask Bits
  * @uic_workq: Work queue for UIC completion handling
+ * @feh_workq: Work queue for fatal controller error handling
+ * @errors: HBA errors
  */
 struct ufs_hba {
 	void __iomem *mmio_base;
@@ -201,6 +206,10 @@ struct ufs_hba {
 
 	/* Work Queues */
 	struct work_struct uic_workq;
+	struct work_struct feh_workq;
+
+	/* HBA Errors */
+	u32 errors;
 };
 
 /**
@@ -924,6 +933,9 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
 	/* Configure interrupt aggregation */
 	ufshcd_config_int_aggr(hba, INT_AGGR_CONFIG);
 
+	if (UFSHCD_STATE_RESET == hba->ufshcd_state)
+		scsi_unblock_requests(hba->host);
+
 	hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
 	scsi_scan_host(hba->host);
 
@@ -1009,6 +1021,53 @@ static int ufshcd_initialize_hba(struct ufs_hba *hba)
 }
 
 /**
+ * ufshcd_do_reset - reset the host controller
+ * @hba: per adapter instance
+ *
+ * Returns 0 on success, non-zero value on failure
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
+	writel(0, (UFSHCD_MMIO_BASE + REG_CONTROLLER_ENABLE));
+
+	/* abort outstanding commands */
+	for (tag = 0; tag < hba->host->can_queue; tag++) {
+		lrbp = &hba->lrb[tag];
+
+		/* if lrbp->cmd is not NULL, the command is outstanding */
+		if (lrbp->cmd) {
+			scsi_dma_unmap(lrbp->cmd);
+			lrbp->cmd->result = DID_RESET << 16;
+			lrbp->cmd->scsi_done(lrbp->cmd);
+			lrbp->cmd = NULL;
+		}
+	}
+
+	/* disable all the interrupts */
+	ufshcd_int_config(hba, UFSHCD_INT_DISABLE);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	/* start the initialization process */
+	if (ufshcd_initialize_hba(hba)) {
+		dev_err(&hba->pdev->dev,
+			"Reset: Controller initialization failed\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/**
  * ufshcd_slave_alloc - handle initial scsi devie configurations
  * @sdev: pointer to scsi device
  *
@@ -1215,12 +1274,56 @@ static void ufshcd_uic_cc_handler (struct work_struct *work)
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
+	if (UFSHCD_STATE_RESET != hba->ufshcd_state)
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
+		reg = readl(UFSHCD_MMIO_BASE +
+			    REG_UIC_ERROR_CODE_PHY_ADAPTER_LAYER);
+		if (reg & UIC_DATA_LINK_LAYER_ERROR_PA_INIT)
+			goto fatal_eh;
+	}
+
+	return;
+
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
 
@@ -1446,6 +1549,7 @@ ufshcd_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	/* Initialize work queues */
 	INIT_WORK(&hba->uic_workq, ufshcd_uic_cc_handler);
+	INIT_WORK(&hba->feh_workq, ufshcd_fatal_err_handler);
 
 	/* IRQ registration */
 	err = request_irq(pdev->irq, ufshcd_intr, IRQF_SHARED, UFSHCD, hba);
-- 
1.7.5.4
