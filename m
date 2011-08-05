From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH v2 09/18] bnx2fc: Clear DESTROY_CMPL flag after firmware
 destroy
Date: Thu, 4 Aug 2011 17:38:43 -0700
Message-ID: <1312504732-4572-10-git-send-email-bprakash@broadcom.com>
References: <1312504732-4572-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4919 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755949Ab1HEAjL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2011 20:39:11 -0400
In-Reply-To: <1312504732-4572-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, robert.w.love@intel.com, devel@open-fcoe.org, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Since this flag was never cleared, the driver does not wait for firmware
destroy completions, causing missed KCQEs.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index dccabaf..ca2e206 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -771,8 +771,8 @@ static void bnx2fc_destroy_timer(unsigned long data)
 {
 	struct bnx2fc_hba *hba = (struct bnx2fc_hba *)data;
 
-	BNX2FC_MISC_DBG("ERROR:bnx2fc_destroy_timer - "
-		   "Destroy compl not received!!\n");
+	printk(KERN_ERR PFX "ERROR:bnx2fc_destroy_timer - "
+	       "Destroy compl not received!!\n");
 	set_bit(BNX2FC_FLAG_DESTROY_CMPL, &hba->flags);
 	wake_up_interruptible(&hba->destroy_wait);
 }
@@ -1701,6 +1701,7 @@ static void bnx2fc_fw_destroy(struct bnx2fc_hba *hba)
 			wait_event_interruptible(hba->destroy_wait,
 					test_bit(BNX2FC_FLAG_DESTROY_CMPL,
 						 &hba->flags));
+			clear_bit(BNX2FC_FLAG_DESTROY_CMPL, &hba->flags);
 			/* This should never happen */
 			if (signal_pending(current))
 				flush_signals(current);
-- 
1.7.0.6


