From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH RESEND 09/11] bnx2fc: Do not arm CQ when there are no
 CQEs
Date: Tue, 26 Jul 2011 14:51:47 -0700
Message-ID: <1311717109-14077-10-git-send-email-bprakash@broadcom.com>
References: <1311717109-14077-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2783 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753929Ab1GZVwH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jul 2011 17:52:07 -0400
In-Reply-To: <1311717109-14077-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, devel@open-fcoe.org, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_hwi.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index 9f38c57..357a63d 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -1070,8 +1070,10 @@ unlock:
 				1 - tgt->cq_curr_toggle_bit;
 		}
 	}
-	bnx2fc_arm_cq(tgt);
-	atomic_add(num_free_sqes, &tgt->free_sqes);
+	if (num_free_sqes) {
+		bnx2fc_arm_cq(tgt);
+		atomic_add(num_free_sqes, &tgt->free_sqes);
+	}
 	spin_unlock_bh(&tgt->cq_lock);
 	return 0;
 }
-- 
1.7.0.6


