From: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Subject: [PATCH 03/15] be2iscsi: Fix to use atomic operations for tag_state
Date: Tue, 15 Dec 2015 21:24:54 +0530
Message-ID: <1450194906-12925-4-git-send-email-jitendra.bhivare@avagotech.com>
References: <1450194906-12925-1-git-send-email-jitendra.bhivare@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:63985 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754017AbbLOPzW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Dec 2015 10:55:22 -0500
In-Reply-To: <1450194906-12925-1-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jitendra <jitendra.bhivare@avagotech.com>

From: Jitendra <jitendra.bhivare@avagotech.com>

Replace lock based tag_state manipulations with atomic operations.

Signed-off-by: Jitendra <jitendra.bhivare@avagotech.com>
---
 drivers/scsi/be2iscsi/be.h      |    2 +-
 drivers/scsi/be2iscsi/be_cmds.c |   26 ++++++++++++--------------
 2 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be.h b/drivers/scsi/be2iscsi/be.h
index cf19bce..419b53f 100644
--- a/drivers/scsi/be2iscsi/be.h
+++ b/drivers/scsi/be2iscsi/be.h
@@ -113,7 +113,7 @@ struct beiscsi_mcc_tag_state {
 #define MCC_TAG_STATE_COMPLETED 0x00
 #define MCC_TAG_STATE_RUNNING   0x01
 #define MCC_TAG_STATE_TIMEOUT   0x02
-	uint8_t tag_state;
+	atomic_t tag_state;
 	struct be_dma_mem tag_mem_state;
 };
 
diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 6fabded..21c806f 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -164,9 +164,8 @@ int beiscsi_mccq_compl(struct beiscsi_hba *phba,
 	}
 
 	/* Set MBX Tag state to Active */
-	mutex_lock(&phba->ctrl.mbox_lock);
-	phba->ctrl.ptag_state[tag].tag_state = MCC_TAG_STATE_RUNNING;
-	mutex_unlock(&phba->ctrl.mbox_lock);
+	atomic_set(&phba->ctrl.ptag_state[tag].tag_state,
+			MCC_TAG_STATE_RUNNING);
 
 	/* wait for the mccq completion */
 	rc = wait_event_interruptible_timeout(
@@ -178,9 +177,8 @@ int beiscsi_mccq_compl(struct beiscsi_hba *phba,
 	if (rc <= 0) {
 		struct be_dma_mem *tag_mem;
 		/* Set MBX Tag state to timeout */
-		mutex_lock(&phba->ctrl.mbox_lock);
-		phba->ctrl.ptag_state[tag].tag_state = MCC_TAG_STATE_TIMEOUT;
-		mutex_unlock(&phba->ctrl.mbox_lock);
+		atomic_set(&phba->ctrl.ptag_state[tag].tag_state,
+				MCC_TAG_STATE_TIMEOUT);
 
 		/* Store resource addr to be freed later */
 		tag_mem = &phba->ctrl.ptag_state[tag].tag_mem_state;
@@ -199,9 +197,8 @@ int beiscsi_mccq_compl(struct beiscsi_hba *phba,
 	} else {
 		rc = 0;
 		/* Set MBX Tag state to completed */
-		mutex_lock(&phba->ctrl.mbox_lock);
-		phba->ctrl.ptag_state[tag].tag_state = MCC_TAG_STATE_COMPLETED;
-		mutex_unlock(&phba->ctrl.mbox_lock);
+		atomic_set(&phba->ctrl.ptag_state[tag].tag_state,
+				MCC_TAG_STATE_COMPLETED);
 	}
 
 	mcc_tag_response = phba->ctrl.mcc_numtag[tag];
@@ -373,9 +370,11 @@ int be_mcc_compl_process_isr(struct be_ctrl_info *ctrl,
 	ctrl->mcc_numtag[tag] |= (extd_status & 0x000000FF) << 8;
 	ctrl->mcc_numtag[tag] |= (compl_status & 0x000000FF);
 
-	if (ctrl->ptag_state[tag].tag_state == MCC_TAG_STATE_RUNNING) {
+	if (atomic_read(&ctrl->ptag_state[tag].tag_state) ==
+		MCC_TAG_STATE_RUNNING) {
 		wake_up_interruptible(&ctrl->mcc_wait[tag]);
-	} else if (ctrl->ptag_state[tag].tag_state == MCC_TAG_STATE_TIMEOUT) {
+	} else if (atomic_read(&ctrl->ptag_state[tag].tag_state) ==
+			MCC_TAG_STATE_TIMEOUT) {
 		struct be_dma_mem *tag_mem;
 		tag_mem = &ctrl->ptag_state[tag].tag_mem_state;
 
@@ -390,9 +389,8 @@ int be_mcc_compl_process_isr(struct be_ctrl_info *ctrl,
 					    tag_mem->va, tag_mem->dma);
 
 		/* Change tag state */
-		mutex_lock(&phba->ctrl.mbox_lock);
-		ctrl->ptag_state[tag].tag_state = MCC_TAG_STATE_COMPLETED;
-		mutex_unlock(&phba->ctrl.mbox_lock);
+		atomic_set(&ctrl->ptag_state[tag].tag_state,
+				MCC_TAG_STATE_COMPLETED);
 
 		/* Free MCC Tag */
 		free_mcc_tag(ctrl, tag);
-- 
1.7.1

