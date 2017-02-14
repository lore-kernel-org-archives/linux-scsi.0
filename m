From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/6] scsi: simplify scsi_execute_req_flags
Date: Tue, 14 Feb 2017 20:15:58 +0100
Message-ID: <20170214191600.17480-5-hch@lst.de>
References: <20170214191600.17480-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170214191600.17480-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernek.dk
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Add a sshdr argument to __scsi_execute so that we can decode the sense
data directly into the sense header instead of needing a copy of it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c | 27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 227a77869e13..35b43a8f1bfa 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -215,8 +215,9 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 
 static int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 		 int data_direction, void *buffer, unsigned bufflen,
-		 unsigned char *sense, int timeout, int retries, u64 flags,
-		 req_flags_t rq_flags, int *resid)
+		 unsigned char *sense, struct scsi_sense_hdr *sshdr,
+		 int timeout, int retries, u64 flags, req_flags_t rq_flags,
+		 int *resid)
 {
 	struct request *req;
 	struct scsi_request *rq;
@@ -259,6 +260,8 @@ static int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 		*resid = rq->resid_len;
 	if (sense && rq->sense_len)
 		memcpy(sense, rq->sense, SCSI_SENSE_BUFFERSIZE);
+	if (sshdr)
+		scsi_normalize_sense(rq->sense, rq->sense_len, sshdr);
 	ret = req->errors;
  out:
 	blk_put_request(req);
@@ -288,7 +291,7 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 		 int *resid)
 {
 	return __scsi_execute(sdev, cmd, data_direction, buffer, bufflen, sense,
-			timeout, retries, flags, 0, resid);
+			NULL, timeout, retries, flags, 0, resid);
 }
 EXPORT_SYMBOL(scsi_execute);
 
@@ -297,21 +300,9 @@ int scsi_execute_req_flags(struct scsi_device *sdev, const unsigned char *cmd,
 		     struct scsi_sense_hdr *sshdr, int timeout, int retries,
 		     int *resid, u64 flags, req_flags_t rq_flags)
 {
-	char *sense = NULL;
-	int result;
-	
-	if (sshdr) {
-		sense = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_NOIO);
-		if (!sense)
-			return DRIVER_ERROR << 24;
-	}
-	result = __scsi_execute(sdev, cmd, data_direction, buffer, bufflen,
-			      sense, timeout, retries, flags, rq_flags, resid);
-	if (sshdr)
-		scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE, sshdr);
-
-	kfree(sense);
-	return result;
+	return __scsi_execute(sdev, cmd, data_direction, buffer, bufflen,
+			      NULL, sshdr, timeout, retries, flags, rq_flags,
+			      resid);
 }
 EXPORT_SYMBOL(scsi_execute_req_flags);
 
-- 
2.11.0
