From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2 2/4] Introduce scsi_execute_async()
Date: Mon, 10 Apr 2017 10:54:00 -0700
Message-ID: <20170410175402.9003-3-bart.vanassche@sandisk.com>
References: <20170410175402.9003-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:46822 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752508AbdDJRy3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Apr 2017 13:54:29 -0400
In-Reply-To: <20170410175402.9003-1-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Israel Rukshin <israelr@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Hannes Reinecke <hare@suse.de>

Move the code for submitting a SCSI command from scsi_execute()
into scsi_build_rq(). Introduce scsi_execute_async(). This patch
does not change any functionality.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Israel Rukshin <israelr@mellanox.com>
Cc: Max Gurtovoy <maxg@mellanox.com>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_lib.c    | 89 +++++++++++++++++++++++++++++++++++++---------
 include/scsi/scsi_device.h |  4 +++
 2 files changed, 76 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 4893f2908edf..b68699cba6a2 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -213,6 +213,73 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 	__scsi_queue_insert(cmd, reason, 1);
 }
 
+static struct request *scsi_build_rq(const struct scsi_device *sdev,
+		const unsigned char *cmd, int data_direction, void *buffer,
+		unsigned bufflen, int timeout, int retries, u64 flags,
+		req_flags_t rq_flags)
+{
+	struct request *req;
+	struct scsi_request *rq;
+	int ret;
+
+	req = blk_get_request(sdev->request_queue,
+			data_direction == DMA_TO_DEVICE ?
+			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, __GFP_RECLAIM);
+	if (IS_ERR(req))
+		return req;
+	rq = scsi_req(req);
+	scsi_req_init(req);
+
+	if (bufflen) {
+		ret = blk_rq_map_kern(sdev->request_queue, req,
+				      buffer, bufflen, __GFP_RECLAIM);
+		if (ret) {
+			blk_put_request(req);
+			return ERR_PTR(ret);
+		}
+	}
+
+	rq->cmd_len = COMMAND_SIZE(cmd[0]);
+	memcpy(rq->cmd, cmd, rq->cmd_len);
+	req->retries = retries;
+	req->timeout = timeout;
+	req->cmd_flags |= flags;
+	req->rq_flags |= rq_flags | RQF_QUIET | RQF_PREEMPT;
+
+	return req;
+}
+
+/**
+ * scsi_execute_async - insert a SCSI request
+ * @sdev:	scsi device
+ * @cmd:	scsi command
+ * @data_direction: data direction
+ * @buffer:	data buffer
+ * @bufflen:	length of buffer
+ * @timeout:	request timeout in seconds
+ * @retries:	number of times to retry request
+ * @flags:	flags for ->cmd_flags
+ * @rq_flags:	flags for ->rq_flags
+ */
+int scsi_execute_async(const struct scsi_device *sdev,
+		const unsigned char *cmd, int data_direction, void *buffer,
+		unsigned bufflen, int timeout, int retries, u64 flags,
+		req_flags_t rq_flags)
+{
+	struct request *req;
+
+	req = scsi_build_rq(sdev, cmd, data_direction, buffer, bufflen, timeout,
+			    retries, flags, rq_flags);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+	/*
+	 * head injection *required* here otherwise quiesce won't work
+	 */
+	blk_execute_rq_nowait(req->q, NULL, req, 1, NULL);
+
+	return 0;
+}
+EXPORT_SYMBOL(scsi_execute_async);
 
 /**
  * scsi_execute - insert request and wait for the result
@@ -242,24 +309,12 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	struct scsi_request *rq;
 	int ret = DRIVER_ERROR << 24;
 
-	req = blk_get_request(sdev->request_queue,
-			data_direction == DMA_TO_DEVICE ?
-			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, __GFP_RECLAIM);
+	req = scsi_build_rq(sdev, cmd, data_direction, buffer, bufflen,
+			    timeout, retries, flags, rq_flags);
 	if (IS_ERR(req))
-		return ret;
-	rq = scsi_req(req);
-	scsi_req_init(req);
+		return PTR_ERR(req);
 
-	if (bufflen &&	blk_rq_map_kern(sdev->request_queue, req,
-					buffer, bufflen, __GFP_RECLAIM))
-		goto out;
-
-	rq->cmd_len = COMMAND_SIZE(cmd[0]);
-	memcpy(rq->cmd, cmd, rq->cmd_len);
-	req->retries = retries;
-	req->timeout = timeout;
-	req->cmd_flags |= flags;
-	req->rq_flags |= rq_flags | RQF_QUIET | RQF_PREEMPT;
+	rq = scsi_req(req);
 
 	/*
 	 * head injection *required* here otherwise quiesce won't work
@@ -282,7 +337,7 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	if (sshdr)
 		scsi_normalize_sense(rq->sense, rq->sense_len, sshdr);
 	ret = req->errors;
- out:
+
 	blk_put_request(req);
 
 	return ret;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 080c7ce9bae8..cdff28519393 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -408,6 +408,10 @@ extern const char *scsi_device_state_name(enum scsi_device_state);
 extern int scsi_is_sdev_device(const struct device *);
 extern int scsi_is_target_device(const struct device *);
 extern void scsi_sanitize_inquiry_string(unsigned char *s, int len);
+extern int scsi_execute_async(const struct scsi_device *sdev,
+		const unsigned char *cmd, int data_direction, void *buffer,
+		unsigned bufflen, int timeout, int retries, u64 flags,
+		req_flags_t rq_flags);
 extern int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 			int data_direction, void *buffer, unsigned bufflen,
 			unsigned char *sense, struct scsi_sense_hdr *sshdr,
-- 
2.12.0
