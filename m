From: Jack Wang <jinpu.wang@profitbricks.com>
Subject: [PATCH 3/3] mvsas: remove SCSI host before detaching from SAS transport
Date: Thu,  5 Nov 2015 12:34:18 +0100
Message-ID: <1446723258-9751-1-git-send-email-jinpu.wang@profitbricks.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:33339 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031023AbbKELe0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Nov 2015 06:34:26 -0500
Received: by wmeg8 with SMTP id g8so11531991wme.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2015 03:34:25 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com
Cc: hch@lst.de, brood@attotech.com, Jack Wang <jinpu.wang@profitbricks.com>

commit cff549e4860f ("scsi: proper state checking and module refcount
handling in scsi_device_get")

the reference count of scsi device was changed, which could lead to
when rmmod with at least on drive attached, SCSI error handle will
run into infinite loop, and lockup the system.

Fix it by remove scsi host first, this way scsi core will not send
commands down after detaching SAS transport.

This is a follow up fix for Benjamin's fix for pm80xx.

See also:
http://www.spinics.net/lists/linux-scsi/msg90088.html

Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
---
 drivers/scsi/mvsas/mv_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index e2d555c..1960d95 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -641,9 +641,9 @@ static void mvs_pci_remove(struct pci_dev *pdev)
 	tasklet_kill(&((struct mvs_prv_info *)sha->lldd_ha)->mv_tasklet);
 #endif
 
+	scsi_remove_host(mvi->shost);
 	sas_unregister_ha(sha);
 	sas_remove_host(mvi->shost);
-	scsi_remove_host(mvi->shost);
 
 	MVS_CHIP_DISP->interrupt_disable(mvi);
 	free_irq(mvi->pdev->irq, sha);
-- 
1.9.1

