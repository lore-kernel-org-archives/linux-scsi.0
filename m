From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/4] scsi: use blk_rq_payload_bytes
Date: Fri, 13 Jan 2017 12:29:11 +0100
Message-ID: <1484306953-3194-3-git-send-email-hch@lst.de>
References: <1484306953-3194-1-git-send-email-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1484306953-3194-1-git-send-email-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Dexuan Cui <decui@microsoft.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

Without that we'll pass a wrong payload size in cmd->sdb, which
can lead to hangs with drivers that need the total transfer size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Chris Valean <v-chvale@microsoft.com>
Reported-by: Dexuan Cui <decui@microsoft.com>
Fixes: f9d03f96 ("block: improve handling of the magic discard payload")
---
 drivers/scsi/scsi_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c35b6de..ad4ff8f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1018,7 +1018,7 @@ static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb)
 	count = blk_rq_map_sg(req->q, req, sdb->table.sgl);
 	BUG_ON(count > sdb->table.nents);
 	sdb->table.nents = count;
-	sdb->length = blk_rq_bytes(req);
+	sdb->length = blk_rq_payload_bytes(req);
 	return BLKPREP_OK;
 }
 
-- 
2.1.4

