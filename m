From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [Resend 10/11] mpt3sas: simplify _wait_for_commands_to_complete()
Date: Thu,  4 Jan 2018 04:57:10 -0800
Message-ID: <1515070631-14740-11-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1515070631-14740-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:44900 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752895AbeADM6I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Jan 2018 07:58:08 -0500
Received: by mail-qt0-f193.google.com with SMTP id m59so1718132qte.11
        for <linux-scsi@vger.kernel.org>; Thu, 04 Jan 2018 04:58:08 -0800 (PST)
In-Reply-To: <1515070631-14740-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, chaitra.basappa@broadcom.com, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>, Suganath Prabu S <suganath-prabu.subramani@broadcom.com>

From: Hannes Reinecke <hare@suse.de>

Use 'host_busy' instead of counting outstanding commands by hand.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index d4b32af..2314949 100644
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
