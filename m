From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 06/10] scsi tgt: fix double lock in scsi_uspace_request_fn
Date: Mon, 10 Apr 2006 10:49:14 +0900 (JST)
Message-ID: <20060410104612O.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:15101 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP
	id S1750865AbWDJBtc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Apr 2006 21:49:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

Fix double lock in scsi_uspace_request_fn.


Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

---

 drivers/scsi/scsi_tgt_lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

1ddfd113a764450e7998cc16dd07dcc37077b05b
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
