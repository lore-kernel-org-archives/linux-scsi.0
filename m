From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 7/8] bnx2fc: Fix FW assert during RSCN stress tests
Date: Tue, 30 Aug 2011 15:54:53 -0700
Message-ID: <1314744894-24710-8-git-send-email-bprakash@broadcom.com>
References: <1314744894-24710-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3372 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689Ab1H3WzS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Aug 2011 18:55:18 -0400
In-Reply-To: <1314744894-24710-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, nsujir@broadcom.com, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Firmware asserts when the same CQE is armed twice. This scenario happens during
RSCN stress tests as driver incorrects arms the CQ after the session is
offloaded.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_tgt.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_tgt.c b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
index 2138da9..c1800b5 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_tgt.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
@@ -133,9 +133,7 @@ retry_ofld:
 		printk(KERN_ERR PFX "map doorbell failed - no mem\n");
 		/* upload will take care of cleaning up sess resc */
 		lport->tt.rport_logoff(rdata);
-	} else
-		/* Arm CQ */
-		bnx2fc_arm_cq(tgt);
+	}
 	return;
 
 ofld_err:
-- 
1.7.0.6


