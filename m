From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 04/10] mpt3sas: separate out _base_recovery_check()
Date: Tue, 21 Feb 2017 13:27:03 +0100
Message-ID: <1487680029-3701-5-git-send-email-hare@suse.de>
References: <1487680029-3701-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58976 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752453AbdBUM1l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Feb 2017 07:27:41 -0500
In-Reply-To: <1487680029-3701-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

No functional change.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 6229eda..0133e7c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2383,6 +2383,19 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
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
@@ -2408,15 +2421,7 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
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
1.8.5.6
