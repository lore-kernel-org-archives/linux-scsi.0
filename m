From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v2 1/3] cxlflash: Base error recovery support
Date: Thu, 16 Jul 2015 18:26:35 -0500
Message-ID: <1437089195-52118-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:48214 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380AbbGPX1F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jul 2015 19:27:05 -0400
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Thu, 16 Jul 2015 17:27:05 -0600
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 80AD03E4003E
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2015 17:27:02 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t6GNQHsk38076648
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2015 16:26:17 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t6GNR1II002453
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2015 17:27:02 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com
Cc: hch@infradead.org, mikey@neuling.org, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

Introduce support for enhanced I/O error handling.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h |  11 +++-
 drivers/scsi/cxlflash/main.c   | 135 ++++++++++++++++++++++++++++++++++++++---
 2 files changed, 133 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index fe86bfe..155c2f7 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -76,6 +76,12 @@ enum cxlflash_init_state {
 	INIT_STATE_SCSI
 };
 
+enum eeh_state {
+	EEH_STATE_NONE,
+	EEH_STATE_ACTIVE,
+	EEH_STATE_FAILED
+};
+
 /*
  * Each context has its own set of resource handles that is visible
  * only from that context.
@@ -91,8 +97,6 @@ struct cxlflash_cfg {
 
 	ulong cxlflash_regs_pci;
 
-	wait_queue_head_t eeh_waitq;
-
 	struct work_struct work_q;
 	enum cxlflash_init_state init_state;
 	enum cxlflash_lr_state lr_state;
@@ -105,7 +109,8 @@ struct cxlflash_cfg {
 
 	wait_queue_head_t tmf_waitq;
 	bool tmf_active;
-	u8 err_recovery_active:1;
+	wait_queue_head_t eeh_waitq;
+	enum eeh_state eeh_active;
 };
 
 struct afu_cmd {
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 76a7286..e1f93ef 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -455,9 +455,18 @@ static int cxlflash_eh_device_reset_handler(struct scsi_cmnd *scp)
 		 get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
 		 get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
 
-	rcr = send_tmf(afu, scp, TMF_LUN_RESET);
-	if (unlikely(rcr))
-		rc = FAILED;
+	switch (cfg->eeh_active) {
+	case EEH_STATE_NONE:
+		rcr = send_tmf(afu, scp, TMF_LUN_RESET);
+		if (unlikely(rcr))
+			rc = FAILED;
+		break;
+	case EEH_STATE_ACTIVE:
+		wait_event(cfg->eeh_waitq, cfg->eeh_active != EEH_STATE_ACTIVE);
+		break;
+	case EEH_STATE_FAILED:
+		break;
+	}
 
 	pr_debug("%s: returning rc=%d\n", __func__, rc);
 	return rc;
@@ -487,11 +496,20 @@ static int cxlflash_eh_host_reset_handler(struct scsi_cmnd *scp)
 		 get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
 		 get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
 
-	rcr = cxlflash_afu_reset(cfg);
-	if (rcr == 0)
-		rc = SUCCESS;
-	else
-		rc = FAILED;
+	switch (cfg->eeh_active) {
+	case EEH_STATE_NONE:
+		rcr = cxlflash_afu_reset(cfg);
+		if (rcr == 0)
+			rc = SUCCESS;
+		else
+			rc = FAILED;
+		break;
+	case EEH_STATE_ACTIVE:
+		wait_event(cfg->eeh_waitq, cfg->eeh_active != EEH_STATE_ACTIVE);
+		break;
+	case EEH_STATE_FAILED:
+		break;
+	}
 
 	pr_debug("%s: returning rc=%d\n", __func__, rc);
 	return rc;
@@ -1879,6 +1897,8 @@ static int init_afu(struct cxlflash_cfg *cfg)
 	struct afu *afu = cfg->afu;
 	struct device *dev = &cfg->dev->dev;
 
+	cxl_perst_reloads_same_image(cfg->cxl_afu, true);
+
 	rc = init_mc(cfg);
 	if (rc) {
 		dev_err(dev, "%s: call to init_mc failed, rc=%d!\n",
@@ -2021,6 +2041,12 @@ void cxlflash_wait_resp(struct afu *afu, struct afu_cmd *cmd)
  * the sync. This design point requires calling threads to not be on interrupt
  * context due to the possibility of sleeping during concurrent sync operations.
  *
+ * AFU sync operations should be gated during EEH recovery. When a recovery
+ * fails and an adapter is to be removed, sync requests can occur as part of
+ * cleaning up resources associated with an adapter prior to its removal. In
+ * this scenario, these requests are identified here and simply ignored (safe
+ * due to the AFU going away).
+ *
  * Return:
  *	0 on success
  *	-1 on failure
@@ -2028,11 +2054,17 @@ void cxlflash_wait_resp(struct afu *afu, struct afu_cmd *cmd)
 int cxlflash_afu_sync(struct afu *afu, ctx_hndl_t ctx_hndl_u,
 		      res_hndl_t res_hndl_u, u8 mode)
 {
+	struct cxlflash_cfg *cfg = afu->parent;
 	struct afu_cmd *cmd = NULL;
 	int rc = 0;
 	int retry_cnt = 0;
 	static DEFINE_MUTEX(sync_active);
 
+	if (cfg->eeh_active == EEH_STATE_FAILED) {
+		pr_debug("%s: Sync not required due to EEH state!\n", __func__);
+		return 0;
+	}
+
 	mutex_lock(&sync_active);
 retry:
 	cmd = cxlflash_cmd_checkout(afu);
@@ -2122,6 +2154,11 @@ static void cxlflash_worker_thread(struct work_struct *work)
 	int port;
 	ulong lock_flags;
 
+	/* Avoid MMIO if the device has failed */
+
+	if (cfg->eeh_active == EEH_STATE_FAILED)
+		return;
+
 	spin_lock_irqsave(cfg->host->host_lock, lock_flags);
 
 	if (cfg->lr_state == LINK_RESET_REQUIRED) {
@@ -2199,8 +2236,7 @@ static int cxlflash_probe(struct pci_dev *pdev,
 	cfg->init_state = INIT_STATE_NONE;
 	cfg->dev = pdev;
 	cfg->dev_id = (struct pci_device_id *)dev_id;
-	cfg->mcctx = NULL;
-	cfg->err_recovery_active = 0;
+	cfg->eeh_active = EEH_STATE_NONE;
 
 	init_waitqueue_head(&cfg->tmf_waitq);
 	init_waitqueue_head(&cfg->eeh_waitq);
@@ -2259,6 +2295,84 @@ out_remove:
 	goto out;
 }
 
+/**
+ * cxlflash_pci_error_detected() - called when a PCI error is detected
+ * @pdev:	PCI device struct.
+ * @state:	PCI channel state.
+ *
+ * Return: PCI_ERS_RESULT_NEED_RESET or PCI_ERS_RESULT_DISCONNECT
+ */
+static pci_ers_result_t cxlflash_pci_error_detected(struct pci_dev *pdev,
+						    pci_channel_state_t state)
+{
+	struct cxlflash_cfg *cfg = pci_get_drvdata(pdev);
+
+	pr_debug("%s: pdev=%p state=%u\n", __func__, pdev, state);
+
+	switch (state) {
+	case pci_channel_io_frozen:
+		cfg->eeh_active = EEH_STATE_ACTIVE;
+		udelay(100);
+
+		term_mc(cfg, UNDO_START);
+		stop_afu(cfg);
+
+		return PCI_ERS_RESULT_CAN_RECOVER;
+	case pci_channel_io_perm_failure:
+		cfg->eeh_active = EEH_STATE_FAILED;
+		wake_up_all(&cfg->eeh_waitq);
+		return PCI_ERS_RESULT_DISCONNECT;
+	default:
+		break;
+	}
+	return PCI_ERS_RESULT_NEED_RESET;
+}
+
+/**
+ * cxlflash_pci_slot_reset() - called when PCI slot has been reset
+ * @pdev:	PCI device struct.
+ *
+ * This routine is called by the pci error recovery code after the PCI
+ * slot has been reset, just before we should resume normal operations.
+ *
+ * Return: PCI_ERS_RESULT_RECOVERED or PCI_ERS_RESULT_DISCONNECT
+ */
+static pci_ers_result_t cxlflash_pci_slot_reset(struct pci_dev *pdev)
+{
+	int rc = 0;
+	struct cxlflash_cfg *cfg = pci_get_drvdata(pdev);
+
+	pr_debug("%s: pdev=%p\n", __func__, pdev);
+
+	rc = init_afu(cfg);
+	if (unlikely(rc)) {
+		pr_err("%s: EEH recovery failed! (%d)\n", __func__, rc);
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+
+	return PCI_ERS_RESULT_RECOVERED;
+}
+
+/**
+ * cxlflash_pci_resume() - called when normal operation can resume
+ * @pdev:	PCI device struct
+ */
+static void cxlflash_pci_resume(struct pci_dev *pdev)
+{
+	struct cxlflash_cfg *cfg = pci_get_drvdata(pdev);
+
+	pr_debug("%s: pdev=%p\n", __func__, pdev);
+
+	cfg->eeh_active = EEH_STATE_NONE;
+	wake_up_all(&cfg->eeh_waitq);
+}
+
+static const struct pci_error_handlers cxlflash_err_handler = {
+	.error_detected = cxlflash_pci_error_detected,
+	.slot_reset = cxlflash_pci_slot_reset,
+	.resume = cxlflash_pci_resume,
+};
+
 /*
  * PCI device structure
  */
@@ -2267,6 +2381,7 @@ static struct pci_driver cxlflash_driver = {
 	.id_table = cxlflash_pci_table,
 	.probe = cxlflash_probe,
 	.remove = cxlflash_remove,
+	.err_handler = &cxlflash_err_handler,
 };
 
 /**
-- 
2.1.0

