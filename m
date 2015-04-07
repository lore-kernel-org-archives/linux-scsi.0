From: Jens Axboe <axboe@fb.com>
Subject: [PATCH 2/6] scsi: ensure that a request is valid when returning it from scsi_find_tag()
Date: Tue, 7 Apr 2015 11:18:36 -0600
Message-ID: <1428427120-20971-3-git-send-email-axboe@fb.com>
References: <1428427120-20971-1-git-send-email-axboe@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1428427120-20971-1-git-send-email-axboe@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, Jens Axboe <axboe@fb.com>
List-Id: linux-scsi@vger.kernel.org

For the scsi-mq case, ensure that the request has been started before
returning it from scsi_find_tag(). This is akin to the ->special
check for the non-mq case, it ensures that the request has been setup
and issued.

Signed-off-by: Jens Axboe <axboe@fb.com>
---
 include/scsi/scsi_tcq.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/scsi/scsi_tcq.h b/include/scsi/scsi_tcq.h
index b27977e8aaed..8634cab61aeb 100644
--- a/include/scsi/scsi_tcq.h
+++ b/include/scsi/scsi_tcq.h
@@ -35,8 +35,15 @@ static inline struct scsi_cmnd *scsi_find_tag(struct scsi_device *sdev, int tag)
         struct request *req;
 
         if (tag != SCSI_NO_TAG) {
-		if (shost_use_blk_mq(sdev->host))
-			return scsi_mq_find_tag(sdev->host, tag);
+		if (shost_use_blk_mq(sdev->host)) {
+			struct scsi_cmnd *scmd;
+
+			scmd = scsi_mq_find_tag(sdev->host, tag);
+			if (blk_mq_request_started(scmd->request))
+				return scmd;
+
+			return NULL;
+		}
 
 		req = blk_queue_find_tag(sdev->request_queue, tag);
 	        return req ? (struct scsi_cmnd *)req->special : NULL;
-- 
1.9.1
