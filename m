From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/5] nvme: move the retries count to struct nvme_request
Date: Wed,  5 Apr 2017 19:18:11 +0200
Message-ID: <20170405171812.19911-5-hch@lst.de>
References: <20170405171812.19911-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170405171812.19911-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>
Cc: linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The way NVMe uses this field is entirely different from the older
SCSI/BLOCK_PC usage, so move it into struct nvme_request.

Also reduce the size of the file to a unsigned char so that we leave
space for additional smaller fields that will appear soon.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/nvme/host/core.c | 10 +++++-----
 drivers/nvme/host/nvme.h |  1 +
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 933e67c60e33..dc05f41c3992 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -49,8 +49,8 @@ unsigned char shutdown_timeout = 5;
 module_param(shutdown_timeout, byte, 0644);
 MODULE_PARM_DESC(shutdown_timeout, "timeout in seconds for controller shutdown");
 
-static unsigned int nvme_max_retries = 5;
-module_param_named(max_retries, nvme_max_retries, uint, 0644);
+static u8 nvme_max_retries = 5;
+module_param_named(max_retries, nvme_max_retries, byte, 0644);
 MODULE_PARM_DESC(max_retries, "max number of retries a command may have");
 
 static int nvme_char_major;
@@ -74,7 +74,7 @@ static inline bool nvme_req_needs_retry(struct request *req)
 		return false;
 	if (jiffies - req->start_time >= req->timeout)
 		return false;
-	if (req->retries >= nvme_max_retries)
+	if (nvme_req(req)->retries >= nvme_max_retries)
 		return false;
 	return true;
 }
@@ -85,7 +85,7 @@ void nvme_complete_rq(struct request *req)
 
 	if (unlikely(req->errors)) {
 		if (nvme_req_needs_retry(req)) {
-			req->retries++;
+			nvme_req(req)->retries++;
 			blk_mq_requeue_request(req,
 					!blk_mq_queue_stopped(req->q));
 			return;
@@ -356,7 +356,7 @@ int nvme_setup_cmd(struct nvme_ns *ns, struct request *req,
 	int ret = BLK_MQ_RQ_QUEUE_OK;
 
 	if (!(req->rq_flags & RQF_DONTPREP)) {
-		req->retries = 0;
+		nvme_req(req)->retries = 0;
 		req->rq_flags |= RQF_DONTPREP;
 	}
 
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 82ba9a305301..9eecb67177df 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -90,6 +90,7 @@ enum nvme_quirks {
 struct nvme_request {
 	struct nvme_command	*cmd;
 	union nvme_result	result;
+	u8			retries;
 };
 
 static inline struct nvme_request *nvme_req(struct request *req)
-- 
2.11.0
