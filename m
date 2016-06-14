From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC-v2 08/11] nvmet/io-cmd: Hookup sbc_ops->execute_sync_cache backend ops
Date: Tue, 14 Jun 2016 04:35:43 +0000
Message-ID: <1465878946-26556-9-git-send-email-nab@linux-iscsi.org>
References: <1465878946-26556-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:38535 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933196AbcFNEg7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jun 2016 00:36:59 -0400
In-Reply-To: <1465878946-26556-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-nvme <linux-nvme@lists.infradead.org>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@intel.com>, Jay Freyensee <james.p.freyensee@intel.com>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Dave B Minturn <dave.b.minturn@intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts nvmet_execute_flush() to utilize
sbc_ops->execute_sync_cache() for target_iostate
submission into existing backends drivers via
configfs in /sys/kernel/config/target/core/.

Cc: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/nvme/target/io-cmd.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/target/io-cmd.c b/drivers/nvme/target/io-cmd.c
index 133a14a..23905a8 100644
--- a/drivers/nvme/target/io-cmd.c
+++ b/drivers/nvme/target/io-cmd.c
@@ -109,18 +109,21 @@ static void nvmet_execute_rw(struct nvmet_req *req)
 
 static void nvmet_execute_flush(struct nvmet_req *req)
 {
-#if 0
-	struct bio *bio;
+	struct target_iostate *ios = &req->t_iostate;
+	struct se_device *dev = rcu_dereference_raw(req->ns->dev);
+	struct sbc_ops *sbc_ops = dev->transport->sbc_ops;
+	sense_reason_t rc;
 
-	nvmet_inline_bio_init(req);
-	bio = &req->inline_bio;
+	if (!sbc_ops || !sbc_ops->execute_sync_cache) {
+		nvmet_req_complete(req, NVME_SC_INTERNAL | NVME_SC_DNR);
+		return;
+	}
 
-	bio->bi_bdev = req->ns->bdev;
-	bio->bi_private = req;
-	bio->bi_end_io = nvmet_bio_done;
+	ios->se_dev = dev;
+	ios->iomem = NULL;
+	ios->t_comp_func = &nvmet_complete_ios;
 
-	submit_bio(WRITE_FLUSH, bio);
-#endif
+	rc = sbc_ops->execute_sync_cache(ios, false);
 }
 
 #if 0
-- 
1.9.1

