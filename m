From: Tyler Stachecki <tstache1@binghamton.edu>
Subject: [PATCH] [SCSI] mpt2sas: Don't disable device twice at suspend.
Date: Fri, 25 Apr 2014 16:41:04 -0400
Message-ID: <1398458464-11826-1-git-send-email-tstache1@binghamton.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:49128 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbaDYUlY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Apr 2014 16:41:24 -0400
Received: by mail-ig0-f173.google.com with SMTP id hl10so2665100igb.12
        for <linux-scsi@vger.kernel.org>; Fri, 25 Apr 2014 13:41:23 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com, JBottomley@parallels.com
Cc: DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, Tyler Stachecki <tstache1@binghamton.edu>

On suspend, _scsih_suspend calls mpt2sas_base_free_resources, which
in turn calls pci_disable_device if the device is enabled prior to
suspending. However, _scsih_suspend also calls pci_disable_device
itself.

Thus, in the event that the device is enabled prior to suspending,
pci_disable_device will be called twice. This patch removes the
duplicate call to pci_disable_device in _scsi_suspend as it is both
unnecessary and results in a kernel oops.

Signed-off-by: Tyler Stachecki <tstache1@binghamton.edu>
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 7f0af4f..6fd7d40 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -8293,7 +8293,6 @@ _scsih_suspend(struct pci_dev *pdev, pm_message_t state)
 
 	mpt2sas_base_free_resources(ioc);
 	pci_save_state(pdev);
-	pci_disable_device(pdev);
 	pci_set_power_state(pdev, device_state);
 	return 0;
 }
-- 
1.9.2

