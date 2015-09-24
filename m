From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v3 28/32] cxlflash: Fix to avoid state change collision
Date: Thu, 24 Sep 2015 14:42:36 -0500
Message-ID: <1443123756-17736-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1443123193-16498-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:42881 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbbIXToN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Sep 2015 15:44:13 -0400
Received: from localhost
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Thu, 24 Sep 2015 13:44:13 -0600
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id CDE6E1FF0045
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2015 13:35:19 -0600 (MDT)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8OJi2iE66191436
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2015 12:44:10 -0700
Received: from d03av01.boulder.ibm.com (localhost [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8OJhaeF008530
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2015 13:43:38 -0600
In-Reply-To: <1443123193-16498-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

The adapter state machine is susceptible to missing and/or
corrupting state updates at runtime. This can lead to a variety
of unintended issues and is due to the lack of a serialization
mechanism to protect the adapter state.

Use an adapter-wide mutex to serialize state changes.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>

Conflicts:
	drivers/scsi/cxlflash/main.c
---
 drivers/scsi/cxlflash/common.h    |  1 +
 drivers/scsi/cxlflash/main.c      | 48 ++++++++++++++++++++++++++++++---------
 drivers/scsi/cxlflash/superpipe.c |  7 +++++-
 3 files changed, 44 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index bbfe711..89c82d2 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -127,6 +127,7 @@ struct cxlflash_cfg {
 	bool tmf_active;
 	wait_queue_head_t reset_waitq;
 	enum cxlflash_state state;
+	struct mutex mutex;
 };
 
 struct afu_cmd {
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index ab11ee6..325ba31 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -496,6 +496,7 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)host->hostdata;
 	struct afu *afu = cfg->afu;
 	struct device *dev = &cfg->dev->dev;
+	enum cxlflash_state state;
 	struct afu_cmd *cmd;
 	u32 port_sel = scp->device->channel + 1;
 	int nseg, i, ncount;
@@ -525,7 +526,11 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 	}
 	spin_unlock_irqrestore(&cfg->tmf_slock, lock_flags);
 
-	switch (cfg->state) {
+	mutex_lock(&cfg->mutex);
+	state = cfg->state;
+	mutex_unlock(&cfg->mutex);
+
+	switch (state) {
 	case STATE_RESET:
 		dev_dbg_ratelimited(dev, "%s: device is in reset!\n", __func__);
 		rc = SCSI_MLQUEUE_HOST_BUSY;
@@ -722,7 +727,9 @@ static void cxlflash_remove(struct pci_dev *pdev)
 						  cfg->tmf_slock);
 	spin_unlock_irqrestore(&cfg->tmf_slock, lock_flags);
 
+	mutex_lock(&cfg->mutex);
 	cfg->state = STATE_FAILTERM;
+	mutex_unlock(&cfg->mutex);
 	cxlflash_stop_term_user_contexts(cfg);
 
 	switch (cfg->init_state) {
@@ -1776,9 +1783,10 @@ err1:
  * @mode:	Type of sync to issue (lightweight, heavyweight, global).
  *
  * The AFU can only take 1 sync command at a time. This routine enforces this
- * limitation by using a mutex to provide exclusive access to the AFU during
- * the sync. This design point requires calling threads to not be on interrupt
- * context due to the possibility of sleeping during concurrent sync operations.
+ * limitation by holding the adapter mutex across the entirety of the function
+ * to provide exclusive access to the AFU during the sync. This design point
+ * requires calling threads to not be on interrupt context due to the
+ * possibility of sleeping during concurrent sync operations.
  *
  * AFU sync operations are only necessary and allowed when the device is
  * operating normally. When not operating normally, sync requests can occur as
@@ -1798,14 +1806,13 @@ int cxlflash_afu_sync(struct afu *afu, ctx_hndl_t ctx_hndl_u,
 	struct afu_cmd *cmd = NULL;
 	int rc = 0;
 	int retry_cnt = 0;
-	static DEFINE_MUTEX(sync_active);
 
+	mutex_lock(&cfg->mutex);
 	if (cfg->state != STATE_NORMAL) {
 		pr_debug("%s: Sync not required! (%u)\n", __func__, cfg->state);
-		return 0;
+		goto out;
 	}
 
-	mutex_lock(&sync_active);
 retry:
 	cmd = cmd_checkout(afu);
 	if (unlikely(!cmd)) {
@@ -1847,7 +1854,7 @@ retry:
 		     (cmd->sa.host_use_b[0] & B_ERROR)))
 		rc = -1;
 out:
-	mutex_unlock(&sync_active);
+	mutex_unlock(&cfg->mutex);
 	if (cmd)
 		cmd_checkin(cmd);
 	pr_debug("%s: returning rc=%d\n", __func__, rc);
@@ -1889,6 +1896,7 @@ static int cxlflash_eh_device_reset_handler(struct scsi_cmnd *scp)
 	struct Scsi_Host *host = scp->device->host;
 	struct cxlflash_cfg *cfg = (struct cxlflash_cfg *)host->hostdata;
 	struct afu *afu = cfg->afu;
+	enum cxlflash_state state;
 	int rcr = 0;
 
 	pr_debug("%s: (scp=%p) %d/%d/%d/%llu "
@@ -1901,7 +1909,11 @@ static int cxlflash_eh_device_reset_handler(struct scsi_cmnd *scp)
 		 get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
 
 retry:
-	switch (cfg->state) {
+	mutex_lock(&cfg->mutex);
+	state = cfg->state;
+	mutex_unlock(&cfg->mutex);
+
+	switch (state) {
 	case STATE_NORMAL:
 		rcr = send_tmf(afu, scp, TMF_LUN_RESET);
 		if (unlikely(rcr))
@@ -1943,6 +1955,7 @@ static int cxlflash_eh_host_reset_handler(struct scsi_cmnd *scp)
 		 get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
 		 get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
 
+	mutex_lock(&cfg->mutex);
 	switch (cfg->state) {
 	case STATE_NORMAL:
 		cfg->state = STATE_RESET;
@@ -1956,7 +1969,9 @@ static int cxlflash_eh_host_reset_handler(struct scsi_cmnd *scp)
 		wake_up_all(&cfg->reset_waitq);
 		break;
 	case STATE_RESET:
+		mutex_unlock(&cfg->mutex);
 		wait_event(cfg->reset_waitq, cfg->state != STATE_RESET);
+		mutex_lock(&cfg->mutex);
 		if (cfg->state == STATE_NORMAL)
 			break;
 		/* fall through */
@@ -1964,6 +1979,7 @@ static int cxlflash_eh_host_reset_handler(struct scsi_cmnd *scp)
 		rc = FAILED;
 		break;
 	}
+	mutex_unlock(&cfg->mutex);
 
 	pr_debug("%s: returning rc=%d\n", __func__, rc);
 	return rc;
@@ -2301,10 +2317,11 @@ static void cxlflash_worker_thread(struct work_struct *work)
 	int port;
 	ulong lock_flags;
 
-	/* Avoid MMIO if the device has failed */
+	mutex_lock(&cfg->mutex);
 
+	/* Avoid MMIO if the device has failed */
 	if (cfg->state != STATE_NORMAL)
-		return;
+		goto out;
 
 	spin_lock_irqsave(cfg->host->host_lock, lock_flags);
 
@@ -2335,6 +2352,8 @@ static void cxlflash_worker_thread(struct work_struct *work)
 
 	if (atomic_dec_if_positive(&cfg->scan_host_needed) >= 0)
 		scsi_scan_host(cfg->host);
+out:
+	mutex_unlock(&cfg->mutex);
 }
 
 /**
@@ -2405,6 +2424,7 @@ static int cxlflash_probe(struct pci_dev *pdev,
 	INIT_WORK(&cfg->work_q, cxlflash_worker_thread);
 	cfg->lr_state = LINK_RESET_INVALID;
 	cfg->lr_port = -1;
+	mutex_init(&cfg->mutex);
 	mutex_init(&cfg->ctx_tbl_list_mutex);
 	mutex_init(&cfg->ctx_recovery_mutex);
 	init_rwsem(&cfg->ioctl_rwsem);
@@ -2492,7 +2512,9 @@ static pci_ers_result_t cxlflash_pci_error_detected(struct pci_dev *pdev,
 
 	switch (state) {
 	case pci_channel_io_frozen:
+		mutex_lock(&cfg->mutex);
 		cfg->state = STATE_RESET;
+		mutex_unlock(&cfg->mutex);
 		scsi_block_requests(cfg->host);
 		drain_ioctls(cfg);
 		rc = cxlflash_mark_contexts_error(cfg);
@@ -2503,7 +2525,9 @@ static pci_ers_result_t cxlflash_pci_error_detected(struct pci_dev *pdev,
 		stop_afu(cfg);
 		return PCI_ERS_RESULT_NEED_RESET;
 	case pci_channel_io_perm_failure:
+		mutex_lock(&cfg->mutex);
 		cfg->state = STATE_FAILTERM;
+		mutex_unlock(&cfg->mutex);
 		wake_up_all(&cfg->reset_waitq);
 		scsi_unblock_requests(cfg->host);
 		return PCI_ERS_RESULT_DISCONNECT;
@@ -2550,7 +2574,9 @@ static void cxlflash_pci_resume(struct pci_dev *pdev)
 
 	dev_dbg(dev, "%s: pdev=%p\n", __func__, pdev);
 
+	mutex_lock(&cfg->mutex);
 	cfg->state = STATE_NORMAL;
+	mutex_unlock(&cfg->mutex);
 	wake_up_all(&cfg->reset_waitq);
 	scsi_unblock_requests(cfg->host);
 }
diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index 0d92594..6aaeee0 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -1229,10 +1229,15 @@ static const struct file_operations null_fops = {
 static int check_state(struct cxlflash_cfg *cfg, bool ioctl)
 {
 	struct device *dev = &cfg->dev->dev;
+	enum cxlflash_state state;
 	int rc = 0;
 
 retry:
-	switch (cfg->state) {
+	mutex_lock(&cfg->mutex);
+	state = cfg->state;
+	mutex_unlock(&cfg->mutex);
+
+	switch (state) {
 	case STATE_RESET:
 		dev_dbg(dev, "%s: Reset state, going to wait...\n", __func__);
 		if (ioctl)
-- 
2.1.0

