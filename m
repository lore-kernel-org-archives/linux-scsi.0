From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 8/8] V2 ipr: Fix sparse error in ipr driver
Date: Fri, 11 Jan 2013 17:43:54 -0600
Message-ID: <20130111234530.625732917@linux.vnet.ibm.com>
References: <20130111234346.012076652@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.65] ([32.97.110.65]:28615 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1755725Ab3AKXru (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jan 2013 18:47:50 -0500
Content-Disposition: inline; filename=sparse_error
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, klebers@linux.vnet.ibm.com, Wen Xiong <wenxiong@linux.vnet.ibm.com>

This patch fixes the following sparse error:

 CHECK   drivers/scsi/ipr.c
spinlock.h:147:9: warning: context imbalance in 'ipr_reset_reload' - unexpected unlock

Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c |   69 +++++++++++++----------------------------------------
 1 file changed, 17 insertions(+), 52 deletions(-)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2013-01-11 16:13:50.803418076 -0600
+++ b/drivers/scsi/ipr.c	2013-01-11 16:14:53.092477895 -0600
@@ -2553,36 +2553,6 @@ static void ipr_oper_timeout(struct ipr_
 }
 
 /**
- * ipr_reset_reload - Reset/Reload the IOA
- * @ioa_cfg:		ioa config struct
- * @shutdown_type:	shutdown type
- *
- * This function resets the adapter and re-initializes it.
- * This function assumes that all new host commands have been stopped.
- * Return value:
- * 	SUCCESS / FAILED
- **/
-static int ipr_reset_reload(struct ipr_ioa_cfg *ioa_cfg,
-			    enum ipr_shutdown_type shutdown_type)
-{
-	if (!ioa_cfg->in_reset_reload)
-		ipr_initiate_ioa_reset(ioa_cfg, shutdown_type);
-
-	spin_unlock_irq(ioa_cfg->host->host_lock);
-	wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
-	spin_lock_irq(ioa_cfg->host->host_lock);
-
-	/* If we got hit with a host reset while we were already resetting
-	 the adapter for some reason, and the reset failed. */
-	if (ioa_cfg->hrrq[IPR_INIT_HRRQ].ioa_is_dead) {
-		ipr_trace;
-		return FAILED;
-	}
-
-	return SUCCESS;
-}
-
-/**
  * ipr_find_ses_entry - Find matching SES in SES table
  * @res:	resource entry struct of SES
  *
@@ -4797,22 +4767,18 @@ static int ipr_slave_alloc(struct scsi_d
 	return rc;
 }
 
-/**
- * ipr_eh_host_reset - Reset the host adapter
- * @scsi_cmd:	scsi command struct
- *
- * Return value:
- * 	SUCCESS / FAILED
- **/
-static int __ipr_eh_host_reset(struct scsi_cmnd *scsi_cmd)
+static int ipr_eh_host_reset(struct scsi_cmnd *cmd)
 {
 	struct ipr_ioa_cfg *ioa_cfg;
-	int rc;
+	unsigned long lock_flags = 0;
+	int rc = SUCCESS;
 
 	ENTER;
-	ioa_cfg = (struct ipr_ioa_cfg *) scsi_cmd->device->host->hostdata;
+	ioa_cfg = (struct ipr_ioa_cfg *) cmd->device->host->hostdata;
+	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 
 	if (!ioa_cfg->in_reset_reload) {
+		ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_ABBREV);
 		dev_err(&ioa_cfg->pdev->dev,
 			"Adapter being reset as a result of error recovery.\n");
 
@@ -4820,20 +4786,19 @@ static int __ipr_eh_host_reset(struct sc
 			ioa_cfg->sdt_state = GET_DUMP;
 	}
 
-	rc = ipr_reset_reload(ioa_cfg, IPR_SHUTDOWN_ABBREV);
-
-	LEAVE;
-	return rc;
-}
-
-static int ipr_eh_host_reset(struct scsi_cmnd *cmd)
-{
-	int rc;
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
+	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 
-	spin_lock_irq(cmd->device->host->host_lock);
-	rc = __ipr_eh_host_reset(cmd);
-	spin_unlock_irq(cmd->device->host->host_lock);
+	/* If we got hit with a host reset while we were already resetting
+	 the adapter for some reason, and the reset failed. */
+	if (ioa_cfg->hrrq[IPR_INIT_HRRQ].ioa_is_dead) {
+		ipr_trace;
+		rc = FAILED;
+	}
 
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	LEAVE;
 	return rc;
 }
 

-- 
