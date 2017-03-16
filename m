From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [RFC 1/2] scsi: Provide mechanism for SCSI layer to poll for LLDD.
Date: Thu, 16 Mar 2017 14:40:47 -0700
Message-ID: <20170316214048.20481-2-himanshu.madhani@cavium.com>
References: <20170316214048.20481-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0061.outbound.protection.outlook.com ([104.47.41.61]:27694
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752562AbdCPWRk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Mar 2017 18:17:40 -0400
In-Reply-To: <20170316214048.20481-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org, darren.trapp@cavium.com

From: Darren Trapp <darren.trapp@cavium.com>

Signed-off-by: Darren Trapp <darren.trapp@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/scsi_lib.c  | 39 +++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_host.h | 12 ++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 19125d72f322..eb01be039677 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2154,6 +2154,43 @@ struct request_queue *scsi_alloc_queue(struct scsi_device *sdev)
 	return q;
 }
 
+static int
+scsi_poll(struct blk_mq_hw_ctx *hctx, unsigned int tag)
+
+{
+        struct Scsi_Host *shost = hctx->driver_data;
+        struct request *req;
+        struct scsi_cmnd *cmd;
+
+        req = blk_mq_tag_to_rq(shost->tag_set.tags[hctx->queue_num], tag);
+        if (!req)
+                return 0;
+
+        cmd = blk_mq_rq_to_pdu(req);
+	if (!cmd)
+		return 0;
+
+	if (shost->hostt->poll_queue)
+		return(shost->hostt->poll_queue(shost, cmd));
+	else return 0;
+}
+
+static inline void
+__scsi_init_hctx(struct blk_mq_hw_ctx *hctx, struct Scsi_Host *shost, unsigned int hctx_idx)
+{
+	hctx->driver_data = shost;
+}
+
+static int
+scsi_init_hctx(struct blk_mq_hw_ctx *hctx, void *data, unsigned int hctx_idx)
+{
+	struct Scsi_Host *shost = data;
+
+	__scsi_init_hctx(hctx, shost, hctx_idx);
+
+	return 0;
+}
+
 static struct blk_mq_ops scsi_mq_ops = {
 	.queue_rq	= scsi_queue_rq,
 	.complete	= scsi_softirq_done,
@@ -2161,6 +2198,8 @@ static struct blk_mq_ops scsi_mq_ops = {
 	.init_request	= scsi_init_request,
 	.exit_request	= scsi_exit_request,
 	.map_queues	= scsi_map_queues,
+	.poll		= scsi_poll,
+	.init_hctx	= scsi_init_hctx,
 };
 
 struct request_queue *scsi_mq_alloc_queue(struct scsi_device *sdev)
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 3cd8c3bec638..e87e8a69a0df 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -127,6 +127,18 @@ struct scsi_host_template {
 	int (* queuecommand)(struct Scsi_Host *, struct scsi_cmnd *);
 
 	/*
+	 * The poll_queue function allows the scsi layer to poll a
+	 * LLDD for the completion of a specific scsi_cmnd (upon request
+	 * from blk_mq).
+	 *
+	 * The LLDD returns 1 to indicate it completed the request or 0
+	 * otherwise.
+	 *
+	 * STATUS: OPTIONAL
+	 */
+	int (* poll_queue)(struct Scsi_Host *, struct scsi_cmnd *);
+
+	/*
 	 * This is an error handling strategy routine.  You don't need to
 	 * define one of these if you don't want to - there is a default
 	 * routine that is present that should work in most cases.  For those
-- 
2.12.0
