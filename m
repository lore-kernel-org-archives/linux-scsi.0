From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 5/6] scsi-lib: implement init_flush_rq and its pair
Date: Sun,  7 Sep 2014 16:39:21 +0800
Message-ID: <1410079162-9872-6-git-send-email-ming.lei@canonical.com>
References: <1410079162-9872-1-git-send-email-ming.lei@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1410079162-9872-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@canonical.com>
List-Id: linux-scsi@vger.kernel.org

Now implement init_flush_rq callback to avoid the unnecessary
pdu copying done in blk_mq_clone_flush_request().

The sense buffer is introduced to flush req, but it won't be
a deal since there is only one flush request per queue. It still
may be borrowed from the sence buffer of the request cloned from,
but looks a bit ugly.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/scsi/scsi_lib.c |   32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b9a8ddd..9090418 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1930,9 +1930,7 @@ out:
 	return ret;
 }
 
-static int scsi_init_request(void *data, struct request *rq,
-		unsigned int hctx_idx, unsigned int request_idx,
-		unsigned int numa_node)
+static int __scsi_init_request(struct request *rq, int numa_node)
 {
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
 
@@ -1943,14 +1941,36 @@ static int scsi_init_request(void *data, struct request *rq,
 	return 0;
 }
 
-static void scsi_exit_request(void *data, struct request *rq,
-		unsigned int hctx_idx, unsigned int request_idx)
+static void __scsi_exit_request(struct request *rq)
 {
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
 
 	kfree(cmd->sense_buffer);
 }
 
+static int scsi_init_request(void *data, struct request *rq,
+		unsigned int hctx_idx, unsigned int request_idx,
+		unsigned int numa_node)
+{
+	return __scsi_init_request(rq, numa_node);
+}
+
+static void scsi_exit_request(void *data, struct request *rq,
+		unsigned int hctx_idx, unsigned int request_idx)
+{
+	__scsi_exit_request(rq);
+}
+
+static int scsi_init_flush_rq(struct request_queue *q, struct request *rq)
+{
+	return __scsi_init_request(rq, NUMA_NO_NODE);
+}
+
+static void scsi_exit_flush_rq(struct request_queue *q, struct request *rq)
+{
+	__scsi_exit_request(rq);
+}
+
 static u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
 {
 	struct device *host_dev;
@@ -2044,6 +2064,8 @@ static struct blk_mq_ops scsi_mq_ops = {
 	.timeout	= scsi_times_out,
 	.init_request	= scsi_init_request,
 	.exit_request	= scsi_exit_request,
+	.init_flush_rq	= scsi_init_flush_rq,
+	.exit_flush_rq	= scsi_exit_flush_rq,
 };
 
 struct request_queue *scsi_mq_alloc_queue(struct scsi_device *sdev)
-- 
1.7.9.5
