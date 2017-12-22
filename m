From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 10/11] mpt3sas: simplify _wait_for_commands_to_complete()
Date: Thu, 21 Dec 2017 23:31:46 -0800
Message-ID: <1513927907-19735-11-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1513927907-19735-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33477 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751246AbdLVHc4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Dec 2017 02:32:56 -0500
Received: by mail-wm0-f66.google.com with SMTP id g130so23272791wme.0
        for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2017 23:32:55 -0800 (PST)
In-Reply-To: <1513927907-19735-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, Hannes Reinecke <hare@suse.de>, Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>

From: Hannes Reinecke <hare@suse.de>

Use 'host_busy' instead of counting outstanding commands by hand.

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index a49040e..eb4cc20 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2898,9 +2898,9 @@ _base_recovery_check(struct MPT3SAS_ADAPTER *ioc)
 	 * See _wait_for_commands_to_complete() call with regards to this code.
 	 */
 	if (ioc->shost_recovery && ioc->pending_io_count) {
-		if (ioc->pending_io_count == 1)
+		ioc->pending_io_count = atomic_read(&ioc->shost->host_busy);
+		if (ioc->pending_io_count == 0)
 			wake_up(&ioc->reset_wq);
-		ioc->pending_io_count--;
 	}
 }
 
@@ -6310,15 +6310,13 @@ _base_reset_handler(struct MPT3SAS_ADAPTER *ioc, int reset_phase)
  * _wait_for_commands_to_complete - reset controller
  * @ioc: Pointer to MPT_ADAPTER structure
  *
- * This function waiting(3s) for all pending commands to complete
+ * This function is waiting 10s for all pending commands to complete
  * prior to putting controller in reset.
  */
 static void
 _wait_for_commands_to_complete(struct MPT3SAS_ADAPTER *ioc)
 {
 	u32 ioc_state;
-	unsigned long flags;
-	u16 i;
 
 	ioc->pending_io_count = 0;
 
@@ -6327,11 +6325,7 @@ _wait_for_commands_to_complete(struct MPT3SAS_ADAPTER *ioc)
 		return;
 
 	/* pending command count */
-	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	for (i = 0; i < ioc->scsiio_depth; i++)
-		if (ioc->scsi_lookup[i].cb_idx != 0xFF)
-			ioc->pending_io_count++;
-	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+	ioc->pending_io_count = atomic_read(&ioc->shost->host_busy);
 
 	if (!ioc->pending_io_count)
 		return;
-- 
2.5.5
