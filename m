From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/10] scm_blk: remove unneeded REQ_TYPE_FS check
Date: Tue, 31 Jan 2017 16:57:22 +0100
Message-ID: <1485878251-6107-2-git-send-email-hch@lst.de>
References: <1485878251-6107-1-git-send-email-hch@lst.de>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1485878251-6107-1-git-send-email-hch@lst.de>
Sender: linux-ide-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/s390/block/scm_blk.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/s390/block/scm_blk.c b/drivers/s390/block/scm_blk.c
index 9f16ea6..152de68 100644
--- a/drivers/s390/block/scm_blk.c
+++ b/drivers/s390/block/scm_blk.c
@@ -300,13 +300,6 @@ static void scm_blk_request(struct request_queue *rq)
 	struct request *req;
 
 	while ((req = blk_peek_request(rq))) {
-		if (req->cmd_type != REQ_TYPE_FS) {
-			blk_start_request(req);
-			blk_dump_rq_flags(req, KMSG_COMPONENT " bad request");
-			__blk_end_request_all(req, -EIO);
-			continue;
-		}
-
 		if (!scm_permit_request(bdev, req))
 			goto out;
 
-- 
2.1.4

