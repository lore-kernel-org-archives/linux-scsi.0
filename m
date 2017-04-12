From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 10/17] cxlflash: Fence EEH during probe
Date: Wed, 12 Apr 2017 14:14:51 -0500
Message-ID: <1492024491-55992-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1492024215-55579-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56608 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752401AbdDLTPN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Apr 2017 15:15:13 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3CJ9K6R102025
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 15:15:12 -0400
Received: from e12.ny.us.ibm.com (e12.ny.us.ibm.com [129.33.205.202])
        by mx0a-001b2d01.pphosted.com with ESMTP id 29s91kf66v-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 15:15:12 -0400
Received: from localhost
        by e12.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 12 Apr 2017 15:15:11 -0400
In-Reply-To: <1492024215-55579-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

An EEH during probe can lead to a crash as the recovery thread races
with the probe thread. To avoid this issue, introduce new states to
fence out EEH recovery until probe has completed. Also ensure the reset
wait queue is flushed during device removal to avoid orphaned threads.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h    |  2 ++
 drivers/scsi/cxlflash/main.c      | 25 +++++++++++++++++++++----
 drivers/scsi/cxlflash/superpipe.c |  8 +++++---
 3 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index 28bb716..17aa74a 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -90,6 +90,8 @@ enum cxlflash_init_state {
 };
 
 enum cxlflash_state {
+	STATE_PROBING,	/* Initial state during probe */
+	STATE_PROBED,	/* Temporary state, probe completed but EEH occurred */
 	STATE_NORMAL,	/* Normal running state, everything good */
 	STATE_RESET,	/* Reset state, trying to reset/recover */
 	STATE_FAILTERM	/* Failed/terminating state, error out users/threads */
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 568cd63..ebba3c9 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -470,6 +470,8 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 	spin_unlock_irqrestore(&cfg->tmf_slock, lock_flags);
 
 	switch (cfg->state) {
+	case STATE_PROBING:
+	case STATE_PROBED:
 	case STATE_RESET:
 		dev_dbg_ratelimited(dev, "%s: device is in reset\n", __func__);
 		rc = SCSI_MLQUEUE_HOST_BUSY;
@@ -719,7 +721,8 @@ static void notify_shutdown(struct cxlflash_cfg *cfg, bool wait)
  * cxlflash_remove() - PCI entry point to tear down host
  * @pdev:	PCI device associated with the host.
  *
- * Safe to use as a cleanup in partially allocated/initialized state.
+ * Safe to use as a cleanup in partially allocated/initialized state. Note that
+ * the reset_waitq is flushed as part of the stop/termination of user contexts.
  */
 static void cxlflash_remove(struct pci_dev *pdev)
 {
@@ -752,7 +755,6 @@ static void cxlflash_remove(struct pci_dev *pdev)
 	case INIT_STATE_SCSI:
 		cxlflash_term_local_luns(cfg);
 		scsi_remove_host(cfg->host);
-		/* fall through */
 	case INIT_STATE_AFU:
 		term_afu(cfg);
 	case INIT_STATE_PCI:
@@ -2624,6 +2626,15 @@ static void cxlflash_worker_thread(struct work_struct *work)
  * @pdev:	PCI device associated with the host.
  * @dev_id:	PCI device id associated with device.
  *
+ * The device will initially start out in a 'probing' state and
+ * transition to the 'normal' state at the end of a successful
+ * probe. Should an EEH event occur during probe, the notification
+ * thread (error_detected()) will wait until the probe handler
+ * is nearly complete. At that time, the device will be moved to
+ * a 'probed' state and the EEH thread woken up to drive the slot
+ * reset and recovery (device moves to 'normal' state). Meanwhile,
+ * the probe will be allowed to exit successfully.
+ *
  * Return: 0 on success, -errno on failure
  */
 static int cxlflash_probe(struct pci_dev *pdev,
@@ -2707,7 +2718,7 @@ static int cxlflash_probe(struct pci_dev *pdev,
 	cfg->init_state = INIT_STATE_PCI;
 
 	rc = init_afu(cfg);
-	if (rc) {
+	if (rc && !wq_has_sleeper(&cfg->reset_waitq)) {
 		dev_err(dev, "%s: init_afu failed rc=%d\n", __func__, rc);
 		goto out_remove;
 	}
@@ -2720,6 +2731,11 @@ static int cxlflash_probe(struct pci_dev *pdev,
 	}
 	cfg->init_state = INIT_STATE_SCSI;
 
+	if (wq_has_sleeper(&cfg->reset_waitq)) {
+		cfg->state = STATE_PROBED;
+		wake_up_all(&cfg->reset_waitq);
+	} else
+		cfg->state = STATE_NORMAL;
 out:
 	dev_dbg(dev, "%s: returning rc=%d\n", __func__, rc);
 	return rc;
@@ -2750,7 +2766,8 @@ static pci_ers_result_t cxlflash_pci_error_detected(struct pci_dev *pdev,
 
 	switch (state) {
 	case pci_channel_io_frozen:
-		wait_event(cfg->reset_waitq, cfg->state != STATE_RESET);
+		wait_event(cfg->reset_waitq, cfg->state != STATE_RESET &&
+					     cfg->state != STATE_PROBING);
 		if (cfg->state == STATE_FAILTERM)
 			return PCI_ERS_RESULT_DISCONNECT;
 
diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index 488330f..158fa00 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -78,17 +78,18 @@ void cxlflash_free_errpage(void)
  * memory freed. This is accomplished by putting the contexts in error
  * state which will notify the user and let them 'drive' the tear down.
  * Meanwhile, this routine camps until all user contexts have been removed.
+ *
+ * Note that the main loop in this routine will always execute at least once
+ * to flush the reset_waitq.
  */
 void cxlflash_stop_term_user_contexts(struct cxlflash_cfg *cfg)
 {
 	struct device *dev = &cfg->dev->dev;
-	int i, found;
+	int i, found = true;
 
 	cxlflash_mark_contexts_error(cfg);
 
 	while (true) {
-		found = false;
-
 		for (i = 0; i < MAX_CONTEXT; i++)
 			if (cfg->ctx_tbl[i]) {
 				found = true;
@@ -102,6 +103,7 @@ void cxlflash_stop_term_user_contexts(struct cxlflash_cfg *cfg)
 			__func__);
 		wake_up_all(&cfg->reset_waitq);
 		ssleep(1);
+		found = false;
 	}
 }
 
-- 
2.1.0
