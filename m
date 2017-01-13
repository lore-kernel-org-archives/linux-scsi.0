From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/4] sd: remove __data_len hack for WRITE SAME
Date: Fri, 13 Jan 2017 12:29:13 +0100
Message-ID: <1484306953-3194-5-git-send-email-hch@lst.de>
References: <1484306953-3194-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51332 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751441AbdAML3i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jan 2017 06:29:38 -0500
In-Reply-To: <1484306953-3194-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Dexuan Cui <decui@microsoft.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org

Now that we have the blk_rq_payload_bytes helper available to determine
the actual I/O size we don't need to mess around with __data_len for
WRITE SAME.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b193304..1fbb1ec 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -836,7 +836,6 @@ static int sd_setup_write_same_cmnd(struct scsi_cmnd *cmd)
 	struct bio *bio = rq->bio;
 	sector_t sector = blk_rq_pos(rq);
 	unsigned int nr_sectors = blk_rq_sectors(rq);
-	unsigned int nr_bytes = blk_rq_bytes(rq);
 	int ret;
 
 	if (sdkp->device->no_write_same)
@@ -869,21 +868,7 @@ static int sd_setup_write_same_cmnd(struct scsi_cmnd *cmd)
 
 	cmd->transfersize = sdp->sector_size;
 	cmd->allowed = SD_MAX_RETRIES;
-
-	/*
-	 * For WRITE_SAME the data transferred in the DATA IN buffer is
-	 * different from the amount of data actually written to the target.
-	 *
-	 * We set up __data_len to the amount of data transferred from the
-	 * DATA IN buffer so that blk_rq_map_sg set up the proper S/G list
-	 * to transfer a single sector of data first, but then reset it to
-	 * the amount of data to be written right after so that the I/O path
-	 * knows how much to actually write.
-	 */
-	rq->__data_len = sdp->sector_size;
-	ret = scsi_init_io(cmd);
-	rq->__data_len = nr_bytes;
-	return ret;
+	return scsi_init_io(cmd);
 }
 
 static int sd_setup_flush_cmnd(struct scsi_cmnd *cmd)
-- 
2.1.4

