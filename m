From: brking@us.ibm.com
Subject: [PATCH 1/3] ipr: Fix ipr PCI hotplug hang with CDROM attach
Date: Mon, 02 May 2005 14:50:47 -0500
Message-ID: <200505021950.j42JorvN013392@d03av03.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:1467 "EHLO e34.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S261737AbVEBTvA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2005 15:51:00 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e34.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j42JoseE383646
	for <linux-scsi@vger.kernel.org>; Mon, 2 May 2005 15:50:54 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j42JosID358874
	for <linux-scsi@vger.kernel.org>; Mon, 2 May 2005 13:50:54 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j42Josqa013582
	for <linux-scsi@vger.kernel.org>; Mon, 2 May 2005 13:50:54 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Currently, during PCI hotplug remove, if the upper layer
drivers of the attached devices send commands down as part
of the remove action, like a CDROM, the hotplug action
will hang forever due to the ipr driver returning
SCSI_MLQUEUE_HOST_BUSY. Patch fixes this.


Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.12-rc3-bjking1/drivers/scsi/ipr.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_hotplug_hang drivers/scsi/ipr.c
--- linux-2.6.12-rc3/drivers/scsi/ipr.c~ipr_hotplug_hang	2005-05-02 14:32:56.000000000 -0500
+++ linux-2.6.12-rc3-bjking1/drivers/scsi/ipr.c	2005-05-02 14:34:57.000000000 -0500
@@ -5887,6 +5887,7 @@ static void __ipr_remove(struct pci_dev 
 
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, host_lock_flags);
 	wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
+	flush_scheduled_work();
 	spin_lock_irqsave(ioa_cfg->host->host_lock, host_lock_flags);
 
 	spin_lock(&ipr_driver_lock);
@@ -5917,8 +5918,6 @@ static void ipr_remove(struct pci_dev *p
 
 	ENTER;
 
-	ioa_cfg->allow_cmds = 0;
-	flush_scheduled_work();
 	ipr_remove_trace_file(&ioa_cfg->host->shost_classdev.kobj,
 			      &ipr_trace_attr);
 	ipr_remove_dump_file(&ioa_cfg->host->shost_classdev.kobj,
_
