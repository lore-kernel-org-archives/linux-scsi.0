From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/3] scsi: allow LLDDs to expose the queue mapping to blk-mq
Date: Tue,  1 Nov 2016 08:12:48 -0600
Message-ID: <1478009569-19026-3-git-send-email-hch@lst.de>
References: <1478009569-19026-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34194 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966238AbcKAOMy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2016 10:12:54 -0400
In-Reply-To: <1478009569-19026-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, don.brace@microsemi.com
Cc: axboe@kernel.dk, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org

Just hand through the blk-mq map_queues method in the host template.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_lib.c  | 10 ++++++++++
 include/scsi/scsi_host.h |  8 ++++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 2cca9cf..f23ec24 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1990,6 +1990,15 @@ static void scsi_exit_request(void *data, struct request *rq,
 	kfree(cmd->sense_buffer);
 }
 
+static int scsi_map_queues(struct blk_mq_tag_set *set)
+{
+	struct Scsi_Host *shost = container_of(set, struct Scsi_Host, tag_set);
+
+	if (shost->hostt->map_queues)
+		return shost->hostt->map_queues(shost);
+	return blk_mq_map_queues(set);
+}
+
 static u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
 {
 	struct device *host_dev;
@@ -2082,6 +2091,7 @@ static struct blk_mq_ops scsi_mq_ops = {
 	.timeout	= scsi_timeout,
 	.init_request	= scsi_init_request,
 	.exit_request	= scsi_exit_request,
+	.map_queues	= scsi_map_queues,
 };
 
 struct request_queue *scsi_mq_alloc_queue(struct scsi_device *sdev)
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 7e4cd53..36680f1 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -278,6 +278,14 @@ struct scsi_host_template {
 	int (* change_queue_depth)(struct scsi_device *, int);
 
 	/*
+	 * This functions lets the driver expose the queue mapping
+	 * to the block layer.
+	 *
+	 * Status: OPTIONAL
+	 */
+	int (* map_queues)(struct Scsi_Host *shost);
+
+	/*
 	 * This function determines the BIOS parameters for a given
 	 * harddisk.  These tend to be numbers that are made up by
 	 * the host adapter.  Parameters:
-- 
2.1.4

