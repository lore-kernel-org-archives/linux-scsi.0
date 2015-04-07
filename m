From: Jens Axboe <axboe@fb.com>
Subject: [PATCH 1/6] scsi: add host template init/exit_command hooks
Date: Tue, 7 Apr 2015 11:18:35 -0600
Message-ID: <1428427120-20971-2-git-send-email-axboe@fb.com>
References: <1428427120-20971-1-git-send-email-axboe@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30294 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753325AbbDGRSu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2015 13:18:50 -0400
In-Reply-To: <1428427120-20971-1-git-send-email-axboe@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, Jens Axboe <axboe@fb.com>

If a LLD has hardware commands in the request pdu, then we need some
helper hooks to help the driver initialize state at load time, and
potentially to tear down state at rmmod time. Add a host template
->init_command() and ->exit_command() hook to help with that.

Note that for the non scsi-mq case, we can't pass in a reliable
request index, since we don't have one...

Signed-off-by: Jens Axboe <axboe@fb.com>
---
 drivers/scsi/scsi.c      |  9 +++++++++
 drivers/scsi/scsi_lib.c  | 16 ++++++++++++++++
 include/scsi/scsi_host.h |  6 +++++-
 3 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index c9c3b579eece..53e935c52300 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -182,6 +182,8 @@ scsi_host_free_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 {
 	struct scsi_host_cmd_pool *pool = shost->cmd_pool;
 
+	if (shost->hostt->exit_command)
+		shost->hostt->exit_command(shost, cmd);
 	if (cmd->prot_sdb)
 		kmem_cache_free(scsi_sdb_cache, cmd->prot_sdb);
 	kmem_cache_free(pool->sense_slab, cmd->sense_buffer);
@@ -217,8 +219,15 @@ scsi_host_alloc_command(struct Scsi_Host *shost, gfp_t gfp_mask)
 			goto fail_free_sense;
 	}
 
+	if (shost->hostt->init_command) {
+		if (shost->hostt->init_command(shost, cmd, 0))
+			goto fail_init;
+	}
+
 	return cmd;
 
+fail_init:
+	kmem_cache_free(scsi_sdb_cache, cmd->prot_sdb);
 fail_free_sense:
 	kmem_cache_free(pool->sense_slab, cmd->sense_buffer);
 fail_free_cmd:
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 54d7a6cbb98a..df46946aa708 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2056,11 +2056,23 @@ static int scsi_init_request(void *data, struct request *rq,
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
 
@@ -2068,8 +2080,12 @@ static void scsi_exit_request(void *data, struct request *rq,
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

