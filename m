From: Ben Collins <bcollins@ubuntu.com>
Subject: [PATCH 2/4] SCSI: AACRAID: Better handling of in-flight events on
 thread stop
Date: Mon, 11 Jun 2012 14:16:36 -0400
Message-ID: <60b4233a6568a0555e6c3b07fd5c9fb89b56dea8.1339453250.git.bcollins@ubuntu.com>
References: <cover.1339453250.git.bcollins@ubuntu.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59707 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab2FKWkj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jun 2012 18:40:39 -0400
Received: by mail-pz0-f46.google.com with SMTP id y13so6004726dad.19
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jun 2012 15:40:39 -0700 (PDT)
In-Reply-To: <cover.1339453250.git.bcollins@ubuntu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>

When an error occured that would shut down the driver, some in-flight
events were getting caught up, deadlocking a CPU or two.

Signed-off-by: Ben Collins <bcollins@ubuntu.com>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/aacraid/linit.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index fdfc4be..2be612b 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1089,8 +1089,17 @@ static struct scsi_host_template aac_driver_template = {
 
 static void __aac_shutdown(struct aac_dev * aac)
 {
-	if (aac->aif_thread)
+	if (aac->aif_thread) {
+		int i;
+		/* Clear out events first */
+		for (i = 0; i < (aac->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB); i++) {
+			struct fib *fib = &aac->fibs[i];
+			if (!(fib->hw_fib_va->header.XferState & cpu_to_le32(NoResponseExpected | Async)) &&
+			    (fib->hw_fib_va->header.XferState & cpu_to_le32(ResponseExpected)))
+				up(&fib->event_wait);
+		}
 		kthread_stop(aac->thread);
+	}
 	aac_send_shutdown(aac);
 	aac_adapter_disable_int(aac);
 	free_irq(aac->pdev->irq, aac);
@@ -1191,6 +1200,7 @@ static int __devinit aac_probe_one(struct pci_dev *pdev,
 	if (IS_ERR(aac->thread)) {
 		printk(KERN_ERR "aacraid: Unable to create command thread.\n");
 		error = PTR_ERR(aac->thread);
+		aac->thread = NULL;
 		goto out_deinit;
 	}
 
-- 
1.7.9.5

