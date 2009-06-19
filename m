From: giridhar.malavali@qlogic.com
Subject: [PATCH 2/2] fc_transport: Selective return value from BSG timeout function
Date: Fri, 19 Jun 2009 16:26:54 -0700
Message-ID: <1245454014-1889-3-git-send-email-giridhar.malavali@qlogic.com>
References: <1245454014-1889-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:57598 "EHLO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752278AbZFSXcq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Jun 2009 19:32:46 -0400
In-Reply-To: <1245454014-1889-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

The return value from BSG timout function should be based on the state of the BSG job. This helps
block layer to take selective actions to clean up BSG job.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi_transport_fc.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 453d9e6..140c50c 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3480,7 +3480,10 @@ fc_bsg_job_timeout(struct request *req)
 	}
 
 	/* the blk_end_sync_io() doesn't check the error */
-	return BLK_EH_HANDLED;
+	if (done)
+		return BLK_EH_NOT_HANDLED;
+	else
+		return BLK_EH_HANDLED;
 }
 
 static int
-- 
1.6.2.rc1.30.gd43c

