From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH 10/29] cxlflash: Rename limbo to reset
Date: Fri, 11 Sep 2015 16:10:50 -0500
Message-ID: <1442005850-46688-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:52490 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbbIKVMG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Sep 2015 17:12:06 -0400
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Fri, 11 Sep 2015 15:12:06 -0600
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id EEDF21FF0042
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 15:03:11 -0600 (MDT)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8BLBsUi40894650
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 14:12:02 -0700
Received: from d03av01.boulder.ibm.com (localhost [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8BLBSav020592
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 15:11:30 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, andrew.donnellan@au1.ibm.com
Cc: mikey@neuling.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

Rename the state and waitq.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h    |  4 ++--
 drivers/scsi/cxlflash/main.c      | 26 +++++++++++++-------------
 drivers/scsi/cxlflash/superpipe.c | 14 +++++++-------
 3 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index 03d2cc6..6e0be53 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -79,7 +79,7 @@ enum cxlflash_init_state {
 
 enum cxlflash_state {
 	STATE_NORMAL,	/* Normal running state, everything good */
-	STATE_LIMBO,	/* Limbo running state, trying to reset/recover */
+	STATE_RESET,	/* Reset state, trying to reset/recover */
 	STATE_FAILTERM	/* Failed/terminating state, error out users/threads */
 };
 
@@ -127,7 +127,7 @@ struct cxlflash_cfg {
 
 	wait_queue_head_t tmf_waitq;
 	bool tmf_active;
-	wait_queue_head_t limbo_waitq;
+	wait_queue_head_t reset_waitq;
 	enum cxlflash_state state;
 };
 
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 89ee648..01b7f3e 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -382,8 +382,8 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 	spin_unlock_irqrestore(&cfg->tmf_waitq.lock, lock_flags);
 
 	switch (cfg->state) {
-	case STATE_LIMBO:
-		dev_dbg_ratelimited(&cfg->dev->dev, "%s: device in limbo!\n",
+	case STATE_RESET:
+		dev_dbg_ratelimited(&cfg->dev->dev, "%s: device is in reset!\n",
 				    __func__);
 		rc = SCSI_MLQUEUE_HOST_BUSY;
 		goto out;
@@ -479,8 +479,8 @@ static int cxlflash_eh_device_reset_handler(struct scsi_cmnd *scp)
 		if (unlikely(rcr))
 			rc = FAILED;
 		break;
-	case STATE_LIMBO:
-		wait_event(cfg->limbo_waitq, cfg->state != STATE_LIMBO);
+	case STATE_RESET:
+		wait_event(cfg->reset_waitq, cfg->state != STATE_RESET);
 		if (cfg->state == STATE_NORMAL)
 			break;
 		/* fall through */
@@ -519,7 +519,7 @@ static int cxlflash_eh_host_reset_handler(struct scsi_cmnd *scp)
 
 	switch (cfg->state) {
 	case STATE_NORMAL:
-		cfg->state = STATE_LIMBO;
+		cfg->state = STATE_RESET;
 		scsi_block_requests(cfg->host);
 		cxlflash_mark_contexts_error(cfg);
 		rcr = cxlflash_afu_reset(cfg);
@@ -528,11 +528,11 @@ static int cxlflash_eh_host_reset_handler(struct scsi_cmnd *scp)
 			cfg->state = STATE_FAILTERM;
 		} else
 			cfg->state = STATE_NORMAL;
-		wake_up_all(&cfg->limbo_waitq);
+		wake_up_all(&cfg->reset_waitq);
 		scsi_unblock_requests(cfg->host);
 		break;
-	case STATE_LIMBO:
-		wait_event(cfg->limbo_waitq, cfg->state != STATE_LIMBO);
+	case STATE_RESET:
+		wait_event(cfg->reset_waitq, cfg->state != STATE_RESET);
 		if (cfg->state == STATE_NORMAL)
 			break;
 		/* fall through */
@@ -705,7 +705,7 @@ static void cxlflash_wait_for_pci_err_recovery(struct cxlflash_cfg *cfg)
 	struct pci_dev *pdev = cfg->dev;
 
 	if (pci_channel_offline(pdev))
-		wait_event_timeout(cfg->limbo_waitq,
+		wait_event_timeout(cfg->reset_waitq,
 				   !pci_channel_offline(pdev),
 				   CXLFLASH_PCI_ERROR_RECOVERY_TIMEOUT);
 }
@@ -2313,7 +2313,7 @@ static int cxlflash_probe(struct pci_dev *pdev,
 	cfg->mcctx = NULL;
 
 	init_waitqueue_head(&cfg->tmf_waitq);
-	init_waitqueue_head(&cfg->limbo_waitq);
+	init_waitqueue_head(&cfg->reset_waitq);
 
 	INIT_WORK(&cfg->work_q, cxlflash_worker_thread);
 	cfg->lr_state = LINK_RESET_INVALID;
@@ -2405,7 +2405,7 @@ static pci_ers_result_t cxlflash_pci_error_detected(struct pci_dev *pdev,
 
 	switch (state) {
 	case pci_channel_io_frozen:
-		cfg->state = STATE_LIMBO;
+		cfg->state = STATE_RESET;
 		scsi_block_requests(cfg->host);
 		drain_ioctls(cfg);
 		rc = cxlflash_mark_contexts_error(cfg);
@@ -2417,7 +2417,7 @@ static pci_ers_result_t cxlflash_pci_error_detected(struct pci_dev *pdev,
 		return PCI_ERS_RESULT_NEED_RESET;
 	case pci_channel_io_perm_failure:
 		cfg->state = STATE_FAILTERM;
-		wake_up_all(&cfg->limbo_waitq);
+		wake_up_all(&cfg->reset_waitq);
 		scsi_unblock_requests(cfg->host);
 		return PCI_ERS_RESULT_DISCONNECT;
 	default:
@@ -2464,7 +2464,7 @@ static void cxlflash_pci_resume(struct pci_dev *pdev)
 	dev_dbg(dev, "%s: pdev=%p\n", __func__, pdev);
 
 	cfg->state = STATE_NORMAL;
-	wake_up_all(&cfg->limbo_waitq);
+	wake_up_all(&cfg->reset_waitq);
 	scsi_unblock_requests(cfg->host);
 }
 
diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index 8a18230..5d51c65 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -100,7 +100,7 @@ void cxlflash_stop_term_user_contexts(struct cxlflash_cfg *cfg)
 
 		dev_dbg(dev, "%s: Wait for user contexts to quiesce...\n",
 			__func__);
-		wake_up_all(&cfg->limbo_waitq);
+		wake_up_all(&cfg->reset_waitq);
 		ssleep(1);
 	}
 }
@@ -1233,12 +1233,12 @@ static int check_state(struct cxlflash_cfg *cfg, bool ioctl)
 
 retry:
 	switch (cfg->state) {
-	case STATE_LIMBO:
-		dev_dbg(dev, "%s: Limbo state, going to wait...\n", __func__);
+	case STATE_RESET:
+		dev_dbg(dev, "%s: Reset state, going to wait...\n", __func__);
 		if (ioctl)
 			up_read(&cfg->ioctl_rwsem);
-		rc = wait_event_interruptible(cfg->limbo_waitq,
-					      cfg->state != STATE_LIMBO);
+		rc = wait_event_interruptible(cfg->reset_waitq,
+					      cfg->state != STATE_RESET);
 		if (ioctl)
 			down_read(&cfg->ioctl_rwsem);
 		if (unlikely(rc))
@@ -1581,10 +1581,10 @@ err1:
  * quite possible for this routine to act as the kernel's EEH detection
  * source (MMIO read of mbox_r). Because of this, there is a window of
  * time where an EEH might have been detected but not yet 'serviced'
- * (callback invoked, causing the device to enter limbo state). To avoid
+ * (callback invoked, causing the device to enter reset state). To avoid
  * looping in this routine during that window, a 1 second sleep is in place
  * between the time the MMIO failure is detected and the time a wait on the
- * limbo wait queue is attempted via check_state().
+ * reset wait queue is attempted via check_state().
  *
  * Return: 0 on success, -errno on failure
  */
-- 
2.1.0

