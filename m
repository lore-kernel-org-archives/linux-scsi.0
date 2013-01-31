From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 1/1] ipr: Fix oops while resetting an ipr adapter
Date: Wed, 30 Jan 2013 23:45:08 -0600
Message-ID: <20130131055053.742877117@linux.vnet.ibm.com>
References: <20130131054507.796972036@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.65] ([32.97.110.65]:45225 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1751069Ab3AaFxO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jan 2013 00:53:14 -0500
Content-Disposition: inline; filename=ipr_bringdown_oops_fix.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, klebers@linux.vnet.ibm.com, Wen Xiong <wenxiong@linux.vnet.ibm.com>

From: Brian King <brking@linux.vnet.ibm.com>

When resetting an ipr adapter, we use scsi_block_requests to
block any new commands from scsi core, and then unblock after
the reset. When hotplug removing an adapter, we shut it down
and go through this same code, but we've seen issues with
scsi_unblock_requests running after the adapter's memory has
been freed. There is really no need to block/unblock when
the adapter is being removed, so this patch skips the
block/unblock and will immediately fail any commands that
happen to make it to queuecommand while the adapter is
being shutdown.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |   33 +++++++++++++++++++++++----------
 drivers/scsi/ipr.h |    1 +
 2 files changed, 24 insertions(+), 10 deletions(-)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2013-01-21 13:45:10.000000000 -0600
+++ b/drivers/scsi/ipr.c	2013-01-22 14:21:00.394286989 -0600
@@ -6112,7 +6112,7 @@ static int ipr_queuecommand(struct Scsi_
 	 * We have told the host to stop giving us new requests, but
 	 * ERP ops don't count. FIXME
 	 */
-	if (unlikely(!hrrq->allow_cmds && !hrrq->ioa_is_dead)) {
+	if (unlikely(!hrrq->allow_cmds && !hrrq->ioa_is_dead && !hrrq->removing_ioa)) {
 		spin_unlock_irqrestore(hrrq->lock, hrrq_flags);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
@@ -6121,7 +6121,7 @@ static int ipr_queuecommand(struct Scsi_
 	 * FIXME - Create scsi_set_host_offline interface
 	 *  and the ioa_is_dead check can be removed
 	 */
-	if (unlikely(hrrq->ioa_is_dead || !res)) {
+	if (unlikely(hrrq->ioa_is_dead || hrrq->removing_ioa || !res)) {
 		spin_unlock_irqrestore(hrrq->lock, hrrq_flags);
 		goto err_nodev;
 	}
@@ -6741,14 +6741,17 @@ static int ipr_ioa_bringdown_done(struct
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 
 	ENTER;
+	if (!ioa_cfg->hrrq[IPR_INIT_HRRQ].removing_ioa) {
+		ipr_trace;
+		spin_unlock_irq(ioa_cfg->host->host_lock);
+		scsi_unblock_requests(ioa_cfg->host);
+		spin_lock_irq(ioa_cfg->host->host_lock);
+	}
+
 	ioa_cfg->in_reset_reload = 0;
 	ioa_cfg->reset_retries = 0;
 	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
 	wake_up_all(&ioa_cfg->reset_wait_q);
-
-	spin_unlock_irq(ioa_cfg->host->host_lock);
-	scsi_unblock_requests(ioa_cfg->host);
-	spin_lock_irq(ioa_cfg->host->host_lock);
 	LEAVE;
 
 	return IPR_RC_JOB_RETURN;
@@ -8494,7 +8497,8 @@ static void _ipr_initiate_ioa_reset(stru
 		spin_unlock(&ioa_cfg->hrrq[i]._lock);
 	}
 	wmb();
-	scsi_block_requests(ioa_cfg->host);
+	if (!ioa_cfg->hrrq[IPR_INIT_HRRQ].removing_ioa)
+		scsi_block_requests(ioa_cfg->host);
 
 	ipr_cmd = ipr_get_free_ipr_cmnd(ioa_cfg);
 	ioa_cfg->reset_cmd = ipr_cmd;
@@ -8549,9 +8553,11 @@ static void ipr_initiate_ioa_reset(struc
 			ipr_fail_all_ops(ioa_cfg);
 			wake_up_all(&ioa_cfg->reset_wait_q);
 
-			spin_unlock_irq(ioa_cfg->host->host_lock);
-			scsi_unblock_requests(ioa_cfg->host);
-			spin_lock_irq(ioa_cfg->host->host_lock);
+			if (!ioa_cfg->hrrq[IPR_INIT_HRRQ].removing_ioa) {
+				spin_unlock_irq(ioa_cfg->host->host_lock);
+				scsi_unblock_requests(ioa_cfg->host);
+				spin_lock_irq(ioa_cfg->host->host_lock);
+			}
 			return;
 		} else {
 			ioa_cfg->in_ioa_bringdown = 1;
@@ -9695,6 +9701,7 @@ static void __ipr_remove(struct pci_dev 
 {
 	unsigned long host_lock_flags = 0;
 	struct ipr_ioa_cfg *ioa_cfg = pci_get_drvdata(pdev);
+	int i;
 	ENTER;
 
 	spin_lock_irqsave(ioa_cfg->host->host_lock, host_lock_flags);
@@ -9704,6 +9711,12 @@ static void __ipr_remove(struct pci_dev 
 		spin_lock_irqsave(ioa_cfg->host->host_lock, host_lock_flags);
 	}
 
+	for (i = 0; i < ioa_cfg->hrrq_num; i++) {
+		spin_lock(&ioa_cfg->hrrq[i]._lock);
+		ioa_cfg->hrrq[i].removing_ioa = 1;
+		spin_unlock(&ioa_cfg->hrrq[i]._lock);
+	}
+	wmb();
 	ipr_initiate_ioa_bringdown(ioa_cfg, IPR_SHUTDOWN_NORMAL);
 
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, host_lock_flags);
Index: b/drivers/scsi/ipr.h
===================================================================
--- a/drivers/scsi/ipr.h	2013-01-21 13:45:10.000000000 -0600
+++ b/drivers/scsi/ipr.h	2013-01-22 11:10:23.414280773 -0600
@@ -493,6 +493,7 @@ struct ipr_hrr_queue {
 	u8 allow_interrupts:1;
 	u8 ioa_is_dead:1;
 	u8 allow_cmds:1;
+	u8 removing_ioa:1;
 
 	struct blk_iopoll iopoll;
 };

-- 
