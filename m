From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH v1 01/12] be2iscsi: Remove unused mcc_cq_lock
Date: Thu,  4 Feb 2016 15:49:09 +0530
Message-ID: <1454581160-31869-2-git-send-email-jitendra.bhivare@broadcom.com>
References: <1454581160-31869-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:62101 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757733AbcBDKhQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2016 05:37:16 -0500
In-Reply-To: <1454581160-31869-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jitendra Bhivare <jitendra.bhivare@broadcom.com>

mcc_cq_lock spin_lock is used only in beiscsi_process_mcc which is called
only when all interrupts are disabled from mgmt_epfw_cleanup during
unloading of driver. There is no other context where there can be
contention for the processing of CQ.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/be2iscsi/be.h      | 1 -
 drivers/scsi/be2iscsi/be_cmds.c | 2 --
 drivers/scsi/be2iscsi/be_main.c | 1 -
 3 files changed, 4 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be.h b/drivers/scsi/be2iscsi/be.h
index 7d425af..1524fe4 100644
--- a/drivers/scsi/be2iscsi/be.h
+++ b/drivers/scsi/be2iscsi/be.h
@@ -132,7 +132,6 @@ struct be_ctrl_info {
 	/* MCC Rings */
 	struct be_mcc_obj mcc_obj;
 	spinlock_t mcc_lock;	/* For serializing mcc cmds to BE card */
-	spinlock_t mcc_cq_lock;
 
 	wait_queue_head_t mcc_wait[MAX_MCC_CMD + 1];
 	unsigned int mcc_tag[MAX_MCC_CMD];
diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 34c33d4..e8e9d22 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -532,7 +532,6 @@ int beiscsi_process_mcc(struct beiscsi_hba *phba)
 	int num = 0, status = 0;
 	struct be_ctrl_info *ctrl = &phba->ctrl;
 
-	spin_lock_bh(&phba->ctrl.mcc_cq_lock);
 	while ((compl = be_mcc_compl_get(phba))) {
 		if (compl->flags & CQE_FLAGS_ASYNC_MASK) {
 			beiscsi_process_async_event(phba, compl);
@@ -547,7 +546,6 @@ int beiscsi_process_mcc(struct beiscsi_hba *phba)
 	if (num)
 		hwi_ring_cq_db(phba, phba->ctrl.mcc_obj.cq.id, num, 1);
 
-	spin_unlock_bh(&phba->ctrl.mcc_cq_lock);
 	return status;
 }
 
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 70179e1..314fd2c 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -730,7 +730,6 @@ static int be_ctrl_init(struct beiscsi_hba *phba, struct pci_dev *pdev)
 	memset(mbox_mem_align->va, 0, sizeof(struct be_mcc_mailbox));
 	mutex_init(&ctrl->mbox_lock);
 	spin_lock_init(&phba->ctrl.mcc_lock);
-	spin_lock_init(&phba->ctrl.mcc_cq_lock);
 
 	return status;
 }
-- 
2.5.0

