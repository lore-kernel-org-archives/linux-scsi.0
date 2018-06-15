From: Jianchao Wang <jianchao.w.wang@oracle.com>
Subject: [PATCH 1/2] block: export __blk_complete_request
Date: Fri, 15 Jun 2018 09:57:26 +0800
Message-ID: <1529027847-29085-1-git-send-email-jianchao.w.wang@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, hch@lst.de
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

After f6e7d48 (block: remove BLK_EH_HANDLED), LLDD is responsible
to complete the timed out request, however, for blk-legacy, the
'complete' is still marked, blk_complete_request will do nothing,
we export __blk_complete_request for LLDD to complete the request
in timeout path.

Signed-off-by: Jianchao Wang <jianchao.w.wang@oracle.com>
---
 block/blk-softirq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index 01e2b35..15c1f5e 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -144,6 +144,7 @@ void __blk_complete_request(struct request *req)
 
 	local_irq_restore(flags);
 }
+EXPORT_SYMBOL(__blk_complete_request);
 
 /**
  * blk_complete_request - end I/O on a request
-- 
2.7.4
