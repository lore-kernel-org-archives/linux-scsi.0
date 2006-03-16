From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 2/2] scsi-ml: remove blk_queue_end_tag
Date: Thu, 16 Mar 2006 09:04:29 +0900
Message-ID: <20060316090429M.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:43227 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP id S932619AbWCPAEf
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Mar 2006 19:04:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

Remove blk_queue_end_tag() in scsi_host_put_command() because tgt
doesn't use the elevator code.


Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

---

 drivers/scsi/scsi.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

fd45c05acbc00cd21fa7c82f6aed5a5ef3e5b98a
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 3cf02b1..9c22465 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -352,8 +352,6 @@ void scsi_host_put_command(struct Scsi_H
 	spin_unlock(&shost->free_list_lock);
 
 	spin_lock(q->queue_lock);
-	if (blk_rq_tagged(rq))
-		blk_queue_end_tag(q, rq);
 	__blk_put_request(q, rq);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
-- 
1.1.3
