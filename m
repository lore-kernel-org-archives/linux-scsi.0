From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH v2 12/18] bnx2fc: Fix NULL pointer deref during arm_cq.
Date: Thu, 4 Aug 2011 17:38:46 -0700
Message-ID: <1312504732-4572-13-git-send-email-bprakash@broadcom.com>
References: <1312504732-4572-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4917 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755895Ab1HEAjQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2011 20:39:16 -0400
In-Reply-To: <1312504732-4572-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, robert.w.love@intel.com, devel@open-fcoe.org, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

There exists a race condition between CQ doorbell unmap and IO completion path
that arms the CQ which causes a NULL dereference. Protect the ctx_base with
cq_lock to avoid this. Also, wait for the CQ doorbell to be successfully mapped
before arming the CQ.

Also, do not count uncolicited CQ completions for free_sqes.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_hwi.c |   10 +++++++---
 drivers/scsi/bnx2fc/bnx2fc_tgt.c |   19 +++++++++++--------
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index 72cfb14..b241f3d 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -1009,6 +1009,7 @@ int bnx2fc_process_new_cqes(struct bnx2fc_rport *tgt)
 	u32 cq_cons;
 	struct fcoe_cqe *cqe;
 	u32 num_free_sqes = 0;
+	u32 num_cqes = 0;
 	u16 wqe;
 
 	/*
@@ -1058,10 +1059,11 @@ unlock:
 				wake_up_process(fps->iothread);
 			else
 				bnx2fc_process_cq_compl(tgt, wqe);
+			num_free_sqes++;
 		}
 		cqe++;
 		tgt->cq_cons_idx++;
-		num_free_sqes++;
+		num_cqes++;
 
 		if (tgt->cq_cons_idx == BNX2FC_CQ_WQES_MAX) {
 			tgt->cq_cons_idx = 0;
@@ -1070,8 +1072,10 @@ unlock:
 				1 - tgt->cq_curr_toggle_bit;
 		}
 	}
-	if (num_free_sqes) {
-		bnx2fc_arm_cq(tgt);
+	if (num_cqes) {
+		/* Arm CQ only if doorbell is mapped */
+		if (tgt->ctx_base)
+			bnx2fc_arm_cq(tgt);
 		atomic_add(num_free_sqes, &tgt->free_sqes);
 	}
 	spin_unlock_bh(&tgt->cq_lock);
diff --git a/drivers/scsi/bnx2fc/bnx2fc_tgt.c b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
index 3d28fbe..2f7a7da 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_tgt.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
@@ -133,9 +133,9 @@ retry_ofld:
 		printk(KERN_ERR PFX "map doorbell failed - no mem\n");
 		/* upload will take care of cleaning up sess resc */
 		lport->tt.rport_logoff(rdata);
-	}
-	/* Arm CQ */
-	bnx2fc_arm_cq(tgt);
+	} else
+		/* Arm CQ */
+		bnx2fc_arm_cq(tgt);
 	return;
 
 ofld_err:
@@ -806,14 +806,14 @@ mem_alloc_failure:
 static void bnx2fc_free_session_resc(struct bnx2fc_hba *hba,
 						struct bnx2fc_rport *tgt)
 {
-	BNX2FC_TGT_DBG(tgt, "Freeing up session resources\n");
+	void __iomem *ctx_base_ptr;
 
-	if (tgt->ctx_base) {
-		iounmap(tgt->ctx_base);
-		tgt->ctx_base = NULL;
-	}
+	BNX2FC_TGT_DBG(tgt, "Freeing up session resources\n");
 
 	spin_lock_bh(&tgt->cq_lock);
+	ctx_base_ptr = tgt->ctx_base;
+	tgt->ctx_base = NULL;
+
 	/* Free LCQ */
 	if (tgt->lcq) {
 		dma_free_coherent(&hba->pcidev->dev, tgt->lcq_mem_size,
@@ -867,4 +867,7 @@ static void bnx2fc_free_session_resc(struct bnx2fc_hba *hba,
 		tgt->sq = NULL;
 	}
 	spin_unlock_bh(&tgt->cq_lock);
+
+	if (ctx_base_ptr)
+		iounmap(ctx_base_ptr);
 }
-- 
1.7.0.6


