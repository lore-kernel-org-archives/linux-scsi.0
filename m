From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC 6/8] nvmet/io-cmd: Hookup sbc_ops->execute_unmap backend ops
Date: Tue,  7 Jun 2016 06:36:54 +0000
Message-ID: <1465281416-28355-7-git-send-email-nab@linux-iscsi.org>
References: <1465281416-28355-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:47911 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbcFGGiA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2016 02:38:00 -0400
In-Reply-To: <1465281416-28355-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-nvme <linux-nvme@lists.infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Dave B Minturn <dave.b.minturn@intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts nvmet_execute_discard() to utilize
sbc_ops->execute_unmap() for target_iostate submission
into existing backends drivers via configfs in
/sys/kernel/config/target/core/.

Cc: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/nvme/target/io-cmd.c | 47 ++++++++++++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 13 deletions(-)

diff --git a/drivers/nvme/target/io-cmd.c b/drivers/nvme/target/io-cmd.c
index 23905a8..605f560 100644
--- a/drivers/nvme/target/io-cmd.c
+++ b/drivers/nvme/target/io-cmd.c
@@ -126,52 +126,73 @@ static void nvmet_execute_flush(struct nvmet_req *req)
 	rc = sbc_ops->execute_sync_cache(ios, false);
 }
 
-#if 0
-static u16 nvmet_discard_range(struct nvmet_ns *ns,
-		struct nvme_dsm_range *range, int type, struct bio **bio)
+static u16 nvmet_discard_range(struct nvmet_req *req, struct sbc_ops *sbc_ops,
+		struct nvme_dsm_range *range, struct bio **bio)
 {
-	if (__blkdev_issue_discard(ns->bdev,
+	struct nvmet_ns *ns = req->ns;
+	sense_reason_t rc;
+
+	rc = sbc_ops->execute_unmap(&req->t_iostate,
 			le64_to_cpu(range->slba) << (ns->blksize_shift - 9),
 			le32_to_cpu(range->nlb) << (ns->blksize_shift - 9),
-			GFP_KERNEL, type, bio))
+			bio);
+	if (rc)
 		return NVME_SC_INTERNAL | NVME_SC_DNR;
 
 	return 0;
 }
-#endif
+
+static void nvmet_discard_bio_done(struct bio *bio)
+{
+	struct nvmet_req *req = bio->bi_private;
+	int err = bio->bi_error;
+
+	bio_put(bio);
+	nvmet_req_complete(req, err ? NVME_SC_INTERNAL | NVME_SC_DNR : 0);
+}
 
 static void nvmet_execute_discard(struct nvmet_req *req)
 {
-#if 0
-	struct nvme_dsm_range range;
+	struct target_iostate *ios = &req->t_iostate;
+	struct se_device *dev = rcu_dereference_raw(req->ns->dev);
+	struct sbc_ops *sbc_ops = dev->transport->sbc_ops;
 	struct bio *bio = NULL;
-	int type = REQ_WRITE | REQ_DISCARD, i;
+	struct nvme_dsm_range range;
+	int i;
 	u16 status;
 
+	if (!sbc_ops || !sbc_ops->execute_unmap) {
+		nvmet_req_complete(req, NVME_SC_INTERNAL | NVME_SC_DNR);
+		return;
+	}
+
+	ios->se_dev = dev;
+	ios->iomem = NULL;
+	ios->t_comp_func = NULL;
+
 	for (i = 0; i <= le32_to_cpu(req->cmd->dsm.nr); i++) {
 		status = nvmet_copy_from_sgl(req, i * sizeof(range), &range,
 				sizeof(range));
 		if (status)
 			break;
 
-		status = nvmet_discard_range(req->ns, &range, type, &bio);
+		status = nvmet_discard_range(req, sbc_ops, &range, &bio);
 		if (status)
 			break;
 	}
 
 	if (bio) {
 		bio->bi_private = req;
-		bio->bi_end_io = nvmet_bio_done;
+		bio->bi_end_io = nvmet_discard_bio_done;
 		if (status) {
 			bio->bi_error = -EIO;
 			bio_endio(bio);
 		} else {
-			submit_bio(type, bio);
+			submit_bio(REQ_WRITE | REQ_DISCARD, bio);
 		}
 	} else {
 		nvmet_req_complete(req, status);
 	}
-#endif
 }
 
 static void nvmet_execute_dsm(struct nvmet_req *req)
-- 
1.9.1

