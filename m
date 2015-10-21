From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v6 09/37] cxlflash: Correct naming of limbo state and waitq
Date: Wed, 21 Oct 2015 15:12:00 -0500
Message-ID: <1445458320-3176-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:50958 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932285AbbJUUN1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2015 16:13:27 -0400
Received: from localhost
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 21 Oct 2015 14:13:27 -0600
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id C930C3E4004E
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 14:13:24 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9LKCLLE8126964
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 13:12:21 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9LKDKfG025412
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 14:13:23 -0600
In-Reply-To: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org

Limbo is not an accurate representation of this state and is
also not consistent with the terminology that other drivers
use to represent this concept. Rename the state and and its
associated waitq to 'reset'.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
Reviewed-by: Daniel Axtens <dja@axtens.net>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/cxlflash/common.h    |  4 ++--
 drivers/scsi/cxlflash/main.c      | 26 +++++++++++++-------------
 drivers/scsi/cxlflash/superpipe.c | 14 +++++++-------
 3 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index 1abe4e0..11318de 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -79,7 +79,7 @@ enum cxlflash_init_state {
 
 enum cxlflash_state {
 	STATE_NORMAL,	/* Normal running state, everything good */
-	STATE_LIMBO,	/* Limbo running state, trying to reset/recover */
+	STATE_RESET,	/* Reset state, trying to reset/recover */
 	STATE_FAILTERM	/* Failed/terminating state, error out users/threads */
 };
 
@@ -125,7 +125,7 @@ struct cxlflash_cfg {
 
 	wait_queue_head_t tmf_waitq;
 	bool tmf_active;
-	wait_queue_head_t limbo_waitq;
+	wait_queue_head_t reset_waitq;
 	enum cxlflash_state state;
 };
 
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 6e85c77..8940336 100644
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
@@ -2304,7 +2304,7 @@ static int cxlflash_probe(struct pci_dev *pdev,
 	cfg->mcctx = NULL;
 
 	init_waitqueue_head(&cfg->tmf_waitq);
-	init_waitqueue_head(&cfg->limbo_waitq);
+	init_waitqueue_head(&cfg->reset_waitq);
 
 	INIT_WORK(&cfg->work_q, cxlflash_worker_thread);
 	cfg->lr_state = LINK_RESET_INVALID;
@@ -2396,7 +2396,7 @@ static pci_ers_result_t cxlflash_pci_error_detected(struct pci_dev *pdev,
 
 	switch (state) {
 	case pci_channel_io_frozen:
-		cfg->state = STATE_LIMBO;
+		cfg->state = STATE_RESET;
 		scsi_block_requests(cfg->host);
 		drain_ioctls(cfg);
 		rc = cxlflash_mark_contexts_error(cfg);
@@ -2408,7 +2408,7 @@ static pci_ers_result_t cxlflash_pci_error_detected(struct pci_dev *pdev,
 		return PCI_ERS_RESULT_NEED_RESET;
 	case pci_channel_io_perm_failure:
 		cfg->state = STATE_FAILTERM;
-		wake_up_all(&cfg->limbo_waitq);
+		wake_up_all(&cfg->reset_waitq);
 		scsi_unblock_requests(cfg->host);
 		return PCI_ERS_RESULT_DISCONNECT;
 	default:
@@ -2455,7 +2455,7 @@ static void cxlflash_pci_resume(struct pci_dev *pdev)
 	dev_dbg(dev, "%s: pdev=%p\n", __func__, pdev);
 
 	cfg->state = STATE_NORMAL;
-	wake_up_all(&cfg->limbo_waitq);
+	wake_up_all(&cfg->reset_waitq);
 	scsi_unblock_requests(cfg->host);
 }
 
diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index 655cbf1..8a7ec5d 100644
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
@@ -1233,11 +1233,11 @@ static int check_state(struct cxlflash_cfg *cfg)
 
 retry:
 	switch (cfg->state) {
-	case STATE_LIMBO:
-		dev_dbg(dev, "%s: Limbo state, going to wait...\n", __func__);
+	case STATE_RESET:
+		dev_dbg(dev, "%s: Reset state, going to wait...\n", __func__);
 		up_read(&cfg->ioctl_rwsem);
-		rc = wait_event_interruptible(cfg->limbo_waitq,
-					      cfg->state != STATE_LIMBO);
+		rc = wait_event_interruptible(cfg->reset_waitq,
+					      cfg->state != STATE_RESET);
 		down_read(&cfg->ioctl_rwsem);
 		if (unlikely(rc))
 			break;
@@ -1578,10 +1578,10 @@ err1:
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

