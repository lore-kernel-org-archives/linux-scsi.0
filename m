From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 2/3] ipr: dlpar failed when adding an adapter back
Date: Thu, 14 Mar 2013 13:52:24 -0500
Message-ID: <20130314185803.399503691@linux.vnet.ibm.com>
References: <20130314185222.994529433@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.57] ([32.97.110.57]:43831 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1751682Ab3CNTAb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Mar 2013 15:00:31 -0400
Content-Disposition: inline; filename=reinit_used_res_q
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, klebers@linux.vnet.ibm.com, Wen Xiong <wenxiong@linux.vnet.ibm.com>

Reinitialize resource queue prior to freeing resource entries to ensure they
are not referenced. This fixes an issue with target_destoy accessing memory
after it was freed.

Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c |    1 +
 1 file changed, 1 insertion(+)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2013-03-14 13:15:46.289276262 -0500
+++ b/drivers/scsi/ipr.c	2013-03-14 13:16:03.398966326 -0500
@@ -9728,6 +9728,7 @@ static void __ipr_remove(struct pci_dev 
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, host_lock_flags);
 	wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
 	flush_work(&ioa_cfg->work_q);
+	INIT_LIST_HEAD(&ioa_cfg->used_res_q);
 	spin_lock_irqsave(ioa_cfg->host->host_lock, host_lock_flags);
 
 	spin_lock(&ipr_driver_lock);

-- 
