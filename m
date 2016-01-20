From: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Subject: [PATCH v4 04/17] be2iscsi: Fix to synchronize tag allocation using spin_lock
Date: Wed, 20 Jan 2016 14:10:48 +0530
Message-ID: <1453279261-659-5-git-send-email-jitendra.bhivare@avagotech.com>
References: <1453279261-659-1-git-send-email-jitendra.bhivare@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:55634 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933745AbcATIlh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jan 2016 03:41:37 -0500
In-Reply-To: <1453279261-659-1-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jitendra Bhivare <jitendra.bhivare@avagotech.com>

alloc_mcc_tag needs to be done under mcc_lock.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
---
 drivers/scsi/be2iscsi/be_cmds.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 1913e9e..db03149 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -121,6 +121,7 @@ unsigned int alloc_mcc_tag(struct beiscsi_hba *phba)
 {
 	unsigned int tag = 0;
 
+	spin_lock(&phba->ctrl.mcc_lock);
 	if (phba->ctrl.mcc_tag_available) {
 		tag = phba->ctrl.mcc_tag[phba->ctrl.mcc_alloc_index];
 		phba->ctrl.mcc_tag[phba->ctrl.mcc_alloc_index] = 0;
@@ -134,6 +135,7 @@ unsigned int alloc_mcc_tag(struct beiscsi_hba *phba)
 		else
 			phba->ctrl.mcc_alloc_index++;
 	}
+	spin_unlock(&phba->ctrl.mcc_lock);
 	return tag;
 }
 
@@ -254,7 +256,7 @@ int beiscsi_mccq_compl(struct beiscsi_hba *phba,
 
 void free_mcc_tag(struct be_ctrl_info *ctrl, unsigned int tag)
 {
-	spin_lock(&ctrl->mbox_lock);
+	spin_lock(&ctrl->mcc_lock);
 	tag = tag & 0x000000FF;
 	ctrl->mcc_tag[ctrl->mcc_free_index] = tag;
 	if (ctrl->mcc_free_index == (MAX_MCC_CMD - 1))
@@ -262,7 +264,7 @@ void free_mcc_tag(struct be_ctrl_info *ctrl, unsigned int tag)
 	else
 		ctrl->mcc_free_index++;
 	ctrl->mcc_tag_available++;
-	spin_unlock(&ctrl->mbox_lock);
+	spin_unlock(&ctrl->mcc_lock);
 }
 
 bool is_link_state_evt(u32 trailer)
-- 
2.5.0

