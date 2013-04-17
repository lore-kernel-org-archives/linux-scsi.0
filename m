From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 1/1] ipr: Need to reset adapter after the 6th EEH error
Date: Wed, 17 Apr 2013 09:34:06 -0500
Message-ID: <20130417143720.845632047@linux.vnet.ibm.com>
References: <20130417143405.849599713@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.57] ([32.97.110.57]:11504 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S966466Ab3DQOjw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Apr 2013 10:39:52 -0400
Content-Disposition: inline; filename=fix_config_restore_after_eeh
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, Wen Xiong <wenxiong@linux.vnet.ibm.com>

Add reset adapter after the 6th EEH errors in ipr driver. This triggers
the adapter reset via the PCI config space even when the slot is frozen.

Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2013-04-15 13:43:29.000000000 -0500
+++ b/drivers/scsi/ipr.c	2013-04-16 14:16:42.727859429 -0500
@@ -4777,7 +4777,7 @@ static int ipr_eh_host_reset(struct scsi
 	ioa_cfg = (struct ipr_ioa_cfg *) cmd->device->host->hostdata;
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 
-	if (!ioa_cfg->in_reset_reload) {
+	if (!ioa_cfg->in_reset_reload && !ioa_cfg->hrrq[IPR_INIT_HRRQ].ioa_is_dead) {
 		ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_ABBREV);
 		dev_err(&ioa_cfg->pdev->dev,
 			"Adapter being reset as a result of error recovery.\n");
@@ -6739,6 +6739,7 @@ static int ipr_invalid_adapter(struct ip
 static int ipr_ioa_bringdown_done(struct ipr_cmnd *ipr_cmd)
 {
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
+	int i;
 
 	ENTER;
 	if (!ioa_cfg->hrrq[IPR_INIT_HRRQ].removing_ioa) {
@@ -6750,6 +6751,13 @@ static int ipr_ioa_bringdown_done(struct
 
 	ioa_cfg->in_reset_reload = 0;
 	ioa_cfg->reset_retries = 0;
+	for (i = 0; i < ioa_cfg->hrrq_num; i++) {
+		spin_lock(&ioa_cfg->hrrq[i]._lock);
+		ioa_cfg->hrrq[i].ioa_is_dead = 1;
+		spin_unlock(&ioa_cfg->hrrq[i]._lock);
+	}
+	wmb();
+
 	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
 	wake_up_all(&ioa_cfg->reset_wait_q);
 	LEAVE;
@@ -8651,7 +8659,7 @@ static void ipr_pci_perm_failure(struct 
 	spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
 	if (ioa_cfg->sdt_state == WAIT_FOR_DUMP)
 		ioa_cfg->sdt_state = ABORT_DUMP;
-	ioa_cfg->reset_retries = IPR_NUM_RESET_RELOAD_RETRIES;
+	ioa_cfg->reset_retries = IPR_NUM_RESET_RELOAD_RETRIES - 1;
 	ioa_cfg->in_ioa_bringdown = 1;
 	for (i = 0; i < ioa_cfg->hrrq_num; i++) {
 		spin_lock(&ioa_cfg->hrrq[i]._lock);

-- 
