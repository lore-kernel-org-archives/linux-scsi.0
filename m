From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/8] ipr: Prevent overlapped adapter resets
Date: Thu, 26 Apr 2007 16:00:06 -0500
Message-ID: <200704262101.l3QL1I42010256@d01av01.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:57374 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755081AbXDZVBU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Apr 2007 17:01:20 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l3QL2DhX026115
	for <linux-scsi@vger.kernel.org>; Thu, 26 Apr 2007 17:02:13 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l3QL1Jl0549842
	for <linux-scsi@vger.kernel.org>; Thu, 26 Apr 2007 17:01:19 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l3QL1Ixf010314
	for <linux-scsi@vger.kernel.org>; Thu, 26 Apr 2007 17:01:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


This patch fixes some scenarios where an ipr adapter
could get reset overlapped, which could cause very
long timeouts to occur, or PCI bus errors.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/ipr.c~ipr_fix_overlapped_resets drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_fix_overlapped_resets	2007-04-26 09:15:37.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2007-04-26 09:17:16.000000000 -0500
@@ -2635,8 +2635,13 @@ static ssize_t ipr_store_diagnostics(str
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	while(ioa_cfg->in_reset_reload) {
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
+		spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	}
+
 	ioa_cfg->errors_logged = 0;
 	ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_NORMAL);
 
@@ -2958,6 +2963,11 @@ static int ipr_update_ioa_ucode(struct i
 	unsigned long lock_flags;
 
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	while(ioa_cfg->in_reset_reload) {
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
+		spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	}
 
 	if (ioa_cfg->ucode_sglist) {
 		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
@@ -7434,6 +7444,12 @@ static void __ipr_remove(struct pci_dev 
 	ENTER;
 
 	spin_lock_irqsave(ioa_cfg->host->host_lock, host_lock_flags);
+	while(ioa_cfg->in_reset_reload) {
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, host_lock_flags);
+		wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
+		spin_lock_irqsave(ioa_cfg->host->host_lock, host_lock_flags);
+	}
+
 	ipr_initiate_ioa_bringdown(ioa_cfg, IPR_SHUTDOWN_NORMAL);
 
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, host_lock_flags);
@@ -7557,6 +7573,12 @@ static void ipr_shutdown(struct pci_dev 
 	unsigned long lock_flags = 0;
 
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	while(ioa_cfg->in_reset_reload) {
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
+		spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	}
+
 	ipr_initiate_ioa_bringdown(ioa_cfg, IPR_SHUTDOWN_NORMAL);
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 	wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
_
