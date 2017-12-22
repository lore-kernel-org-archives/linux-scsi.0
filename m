From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 03/11] mpt3sas: separate out _base_recovery_check()
Date: Thu, 21 Dec 2017 23:31:39 -0800
Message-ID: <1513927907-19735-4-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1513927907-19735-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:46626 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753590AbdLVHcZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Dec 2017 02:32:25 -0500
Received: by mail-wr0-f193.google.com with SMTP id g17so17904611wrd.13
        for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2017 23:32:24 -0800 (PST)
In-Reply-To: <1513927907-19735-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, Hannes Reinecke <hare@suse.de>, Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>

From: Hannes Reinecke <hare@suse.de>

No functional change.

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 5a9ad26..35d36a9 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2873,6 +2873,19 @@ mpt3sas_base_get_smid_hpr(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx)
 	return smid;
 }
 
+static void
+_base_recovery_check(struct MPT3SAS_ADAPTER *ioc)
+{
+	/*
+	 * See _wait_for_commands_to_complete() call with regards to this code.
+	 */
+	if (ioc->shost_recovery && ioc->pending_io_count) {
+		if (ioc->pending_io_count == 1)
+			wake_up(&ioc->reset_wq);
+		ioc->pending_io_count--;
+	}
+}
+
 /**
  * mpt3sas_base_free_smid - put smid back on free_list
  * @ioc: per adapter object
@@ -2898,15 +2911,7 @@ mpt3sas_base_free_smid(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 		list_add(&ioc->scsi_lookup[i].tracker_list, &ioc->free_list);
 		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 
-		/*
-		 * See _wait_for_commands_to_complete() call with regards
-		 * to this code.
-		 */
-		if (ioc->shost_recovery && ioc->pending_io_count) {
-			if (ioc->pending_io_count == 1)
-				wake_up(&ioc->reset_wq);
-			ioc->pending_io_count--;
-		}
+		_base_recovery_check(ioc);
 		return;
 	} else if (smid < ioc->internal_smid) {
 		/* hi-priority */
-- 
2.5.5
