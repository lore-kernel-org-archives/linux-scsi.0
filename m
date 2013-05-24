From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 1/1] ipr: possible irq lock inversion dependency detected
Date: Fri, 24 May 2013 09:59:13 -0500
Message-ID: <20130524145946.307147926@linux.vnet.ibm.com>
References: <20130524145912.801776828@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.57] ([32.97.110.57]:43900 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1755033Ab3EXPCW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 May 2013 11:02:22 -0400
Content-Disposition: inline; filename=driver_lock_patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, Wen Xiong <wenxiong@linux.vnet.ibm.com>

When enable lockdep, seeing "possible irq lock inversion dependency detected"
error. This patch fixes the issue.

Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2013-05-20 09:55:23.000000000 -0500
+++ b/drivers/scsi/ipr.c	2013-05-20 10:00:34.548380858 -0500
@@ -9408,7 +9408,7 @@ static int ipr_probe_ioa(struct pci_dev 
 	void __iomem *ipr_regs;
 	int rc = PCIBIOS_SUCCESSFUL;
 	volatile u32 mask, uproc, interrupts;
-	unsigned long lock_flags;
+	unsigned long lock_flags, driver_lock_flags;
 
 	ENTER;
 
@@ -9631,9 +9631,9 @@ static int ipr_probe_ioa(struct pci_dev 
 	} else
 		ioa_cfg->reset = ipr_reset_start_bist;
 
-	spin_lock(&ipr_driver_lock);
+	spin_lock_irqsave(&ipr_driver_lock, driver_lock_flags);
 	list_add_tail(&ioa_cfg->queue, &ipr_ioa_head);
-	spin_unlock(&ipr_driver_lock);
+	spin_unlock_irqrestore(&ipr_driver_lock, driver_lock_flags);
 
 	LEAVE;
 out:
@@ -9716,6 +9716,7 @@ static void __ipr_remove(struct pci_dev 
 	unsigned long host_lock_flags = 0;
 	struct ipr_ioa_cfg *ioa_cfg = pci_get_drvdata(pdev);
 	int i;
+	unsigned long driver_lock_flags;
 	ENTER;
 
 	spin_lock_irqsave(ioa_cfg->host->host_lock, host_lock_flags);
@@ -9739,9 +9740,9 @@ static void __ipr_remove(struct pci_dev 
 	INIT_LIST_HEAD(&ioa_cfg->used_res_q);
 	spin_lock_irqsave(ioa_cfg->host->host_lock, host_lock_flags);
 
-	spin_lock(&ipr_driver_lock);
+	spin_lock_irqsave(&ipr_driver_lock, driver_lock_flags);
 	list_del(&ioa_cfg->queue);
-	spin_unlock(&ipr_driver_lock);
+	spin_unlock_irqrestore(&ipr_driver_lock, driver_lock_flags);
 
 	if (ioa_cfg->sdt_state == ABORT_DUMP)
 		ioa_cfg->sdt_state = WAIT_FOR_DUMP;
@@ -10007,12 +10008,12 @@ static int ipr_halt(struct notifier_bloc
 {
 	struct ipr_cmnd *ipr_cmd;
 	struct ipr_ioa_cfg *ioa_cfg;
-	unsigned long flags = 0;
+	unsigned long flags = 0, driver_lock_flags;
 
 	if (event != SYS_RESTART && event != SYS_HALT && event != SYS_POWER_OFF)
 		return NOTIFY_DONE;
 
-	spin_lock(&ipr_driver_lock);
+	spin_lock_irqsave(&ipr_driver_lock, driver_lock_flags);
 
 	list_for_each_entry(ioa_cfg, &ipr_ioa_head, queue) {
 		spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
@@ -10030,7 +10031,7 @@ static int ipr_halt(struct notifier_bloc
 		ipr_do_req(ipr_cmd, ipr_halt_done, ipr_timeout, IPR_DEVICE_RESET_TIMEOUT);
 		spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
 	}
-	spin_unlock(&ipr_driver_lock);
+	spin_unlock_irqrestore(&ipr_driver_lock, driver_lock_flags);
 
 	return NOTIFY_OK;
 }

-- 
