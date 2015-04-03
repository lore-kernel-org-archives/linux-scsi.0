From: Jens Axboe <axboe@fb.com>
Subject: [PATCH 5/7] scsi: add host template init/exit_command hooks
Date: Fri, 3 Apr 2015 09:58:21 -0600
Message-ID: <1428076703-31014-6-git-send-email-axboe@fb.com>
References: <1428076703-31014-1-git-send-email-axboe@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1428076703-31014-1-git-send-email-axboe@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, Jens Axboe <axboe@fb.com>
List-Id: linux-scsi@vger.kernel.org

If a LLD has hardware commands in the request pdu, then we need some
helper hooks to help the driver initialize state at load time, and
potentially to tear down state at rmmod time. Add a host template
->init_command() and ->exit_command() hook to help with that.

Signed-off-by: Jens Axboe <axboe@fb.com>
---
 drivers/scsi/scsi_lib.c  | 16 ++++++++++++++++
 include/scsi/scsi_host.h |  6 +++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 87a4c53c8b48..d8f03526b836 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2081,11 +2081,23 @@ static int scsi_init_request(void *data, struct request *rq,
 		unsigned int numa_node)
 {
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
+	struct Scsi_Host *shost = data;
 
 	cmd->sense_buffer = kzalloc_node(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL,
 			numa_node);
 	if (!cmd->sense_buffer)
 		return -ENOMEM;
+
+	if (shost->hostt->init_command) {
+		int ret;
+
+		ret = shost->hostt->init_command(shost, cmd, request_idx);
+		if (ret) {
+			kfree(cmd->sense_buffer);
+			return ret;
+		}
+	}
+
 	return 0;
 }
 
@@ -2093,8 +2105,12 @@ static void scsi_exit_request(void *data, struct request *rq,
 		unsigned int hctx_idx, unsigned int request_idx)
 {
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
+	struct Scsi_Host *shost = data;
 
 	kfree(cmd->sense_buffer);
+
+	if (shost->hostt->exit_command)
+		shost->hostt->exit_command(shost, cmd);
 }
 
 static u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index e113c757d555..baaa7a2fc07d 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -496,10 +496,14 @@ struct scsi_host_template {
 	u64 vendor_id;
 
 	/*
-	 * Additional per-command data allocated for the driver.
+	 * Additional per-command data allocated for the driver, along
+	 * with init/exit helper hooks.
 	 */
 	unsigned int cmd_size;
 	struct scsi_host_cmd_pool *cmd_pool;
+	int (*init_command)(struct Scsi_Host *, struct scsi_cmnd *,
+				unsigned int);
+	void (*exit_command)(struct Scsi_Host *, struct scsi_cmnd *);
 
 	/* temporary flag to disable blk-mq I/O path */
 	bool disable_blk_mq;
-- 
1.9.1
