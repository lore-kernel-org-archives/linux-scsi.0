From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/5] nvme: cleanup nvme_req_needs_retry
Date: Wed,  5 Apr 2017 19:18:09 +0200
Message-ID: <20170405171812.19911-3-hch@lst.de>
References: <20170405171812.19911-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170405171812.19911-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>
Cc: linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Don't pass the status explicitly but derive it from the requeust,
and unwind the complex condition to be more readable.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/nvme/host/core.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 0437f44d00f9..b225aacf4b89 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -67,11 +67,17 @@ static DEFINE_SPINLOCK(dev_list_lock);
 
 static struct class *nvme_class;
 
-static inline bool nvme_req_needs_retry(struct request *req, u16 status)
+static inline bool nvme_req_needs_retry(struct request *req)
 {
-	return !(status & NVME_SC_DNR || blk_noretry_request(req)) &&
-		(jiffies - req->start_time) < req->timeout &&
-		req->retries < nvme_max_retries;
+	if (blk_noretry_request(req))
+		return false;
+	if (req->errors & NVME_SC_DNR)
+		return false;
+	if (jiffies - req->start_time >= req->timeout)
+		return false;
+	if (req->retries >= nvme_max_retries)
+		return false;
+	return true;
 }
 
 void nvme_complete_rq(struct request *req)
@@ -79,7 +85,7 @@ void nvme_complete_rq(struct request *req)
 	int error = 0;
 
 	if (unlikely(req->errors)) {
-		if (nvme_req_needs_retry(req, req->errors)) {
+		if (nvme_req_needs_retry(req)) {
 			req->retries++;
 			blk_mq_requeue_request(req,
 					!blk_mq_queue_stopped(req->q));
-- 
2.11.0
