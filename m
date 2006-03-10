From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 6/6] scsi tgt: fix double lock in scsi_uspace_request_fn
Date: Fri, 10 Mar 2006 20:47:10 +0900
Message-ID: <20060310204710S.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:21667 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP id S932335AbWCJLuR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Mar 2006 06:50:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

---

 drivers/scsi/scsi_tgt_lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

e5b0b9fed4c7707038aee8438be004da274c6d4e
diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index 8746236..5d76078 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -136,7 +136,7 @@ requeue:
 	spin_lock_irq(q->queue_lock);
 	/* need to track cnts and plug */
 	blk_requeue_request(q, rq);
-	spin_lock_irq(q->queue_lock);
+	spin_unlock_irq(q->queue_lock);
 }
 
 /**
-- 
1.1.5
