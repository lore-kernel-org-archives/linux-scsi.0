From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 2/3] BNX2I: Updated the connection shutdown/cleanup
 timeout
Date: Mon, 16 May 2011 11:13:19 -0700
Message-ID: <1305569600-1523-3-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1866 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758Ab1EPSNh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2011 14:13:37 -0400
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

Modified the 10s wait time for inflight offload connections to
advance to the next state to 2s based on test result.
Modified the 20s shutdown timeout to 30s based on test result.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_init.c  |    2 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index 1d24a28..6adbdc3 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -244,7 +244,7 @@ void bnx2i_stop(void *handle)
 	wait_event_interruptible_timeout(hba->eh_wait,
 					 (list_empty(&hba->ep_ofld_list) &&
 					 list_empty(&hba->ep_destroy_list)),
-					 10 * HZ);
+					 2 * HZ);
 	/* Wait for all endpoints to be torn down, Chip will be reset once
 	 *  control returns to network driver. So it is required to cleanup and
 	 * release all connection resources before returning from this routine.
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 7b4d1d0..51a970f 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -858,7 +858,7 @@ struct bnx2i_hba *bnx2i_alloc_hba(struct cnic_dev *cnic)
 	mutex_init(&hba->net_dev_lock);
 	init_waitqueue_head(&hba->eh_wait);
 	if (test_bit(BNX2I_NX2_DEV_57710, &hba->cnic_dev_type)) {
-		hba->hba_shutdown_tmo = 20 * HZ;
+		hba->hba_shutdown_tmo = 30 * HZ;
 		hba->conn_teardown_tmo = 20 * HZ;
 		hba->conn_ctx_destroy_tmo = 6 * HZ;
 	} else {	/* 5706/5708/5709 */
-- 
1.7.0.5


