From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH v2 02/29] be2iscsi: Replace _bh version for mcc_lock spinlock
Date: Fri, 19 Aug 2016 15:19:59 +0530
Message-ID: <1471600226-22055-3-git-send-email-jitendra.bhivare@broadcom.com>
References: <1471600226-22055-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:37958 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752936AbcHSJvK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Aug 2016 05:51:10 -0400
Received: by mail-wm0-f47.google.com with SMTP id o80so32584681wme.1
        for <linux-scsi@vger.kernel.org>; Fri, 19 Aug 2016 02:50:50 -0700 (PDT)
In-Reply-To: <1471600226-22055-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mchristi@redhat.com, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

This got unnecessarily introduced with other changes in previous
commits. mcc_lock is taken only in process contexts.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/be2iscsi/be_cmds.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index a55eaee..0ef3d5a 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -133,7 +133,7 @@ struct be_mcc_wrb *alloc_mcc_wrb(struct beiscsi_hba *phba,
 	struct be_mcc_wrb *wrb = NULL;
 	unsigned int tag;
 
-	spin_lock_bh(&phba->ctrl.mcc_lock);
+	spin_lock(&phba->ctrl.mcc_lock);
 	if (mccq->used == mccq->len) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT |
 			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
@@ -174,7 +174,7 @@ struct be_mcc_wrb *alloc_mcc_wrb(struct beiscsi_hba *phba,
 	mccq->used++;
 
 alloc_failed:
-	spin_unlock_bh(&phba->ctrl.mcc_lock);
+	spin_unlock(&phba->ctrl.mcc_lock);
 	return wrb;
 }
 
@@ -182,7 +182,7 @@ void free_mcc_wrb(struct be_ctrl_info *ctrl, unsigned int tag)
 {
 	struct be_queue_info *mccq = &ctrl->mcc_obj.q;
 
-	spin_lock_bh(&ctrl->mcc_lock);
+	spin_lock(&ctrl->mcc_lock);
 	tag = tag & MCC_Q_CMD_TAG_MASK;
 	ctrl->mcc_tag[ctrl->mcc_free_index] = tag;
 	if (ctrl->mcc_free_index == (MAX_MCC_CMD - 1))
@@ -191,7 +191,7 @@ void free_mcc_wrb(struct be_ctrl_info *ctrl, unsigned int tag)
 		ctrl->mcc_free_index++;
 	ctrl->mcc_tag_available++;
 	mccq->used--;
-	spin_unlock_bh(&ctrl->mcc_lock);
+	spin_unlock(&ctrl->mcc_lock);
 }
 
 /**
-- 
1.9.1

