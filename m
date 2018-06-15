From: Jianchao Wang <jianchao.w.wang@oracle.com>
Subject: [PATCH 2/2] scsi_transport_fc: use __blk_complete_request in fc_bsg_job_timeout
Date: Fri, 15 Jun 2018 09:57:27 +0800
Message-ID: <1529027847-29085-2-git-send-email-jianchao.w.wang@oracle.com>
References: <1529027847-29085-1-git-send-email-jianchao.w.wang@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1529027847-29085-1-git-send-email-jianchao.w.wang@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, hch@lst.de
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

bsg is based on blk-legacy, so we should use blk-legacy interface
here. On the other hand, for blk-legacy, the timed out request
has 'complete' mark, so use __blk_complete_request.

Signed-off-by: Jianchao Wang <jianchao.w.wang@oracle.com>
---
 drivers/scsi/scsi_transport_fc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 1da3d71..1394810 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3592,7 +3592,7 @@ fc_bsg_job_timeout(struct request *req)
 
 	/* the blk_end_sync_io() doesn't check the error */
 	if (inflight)
-		blk_mq_complete_request(req);
+		__blk_complete_request(req);
 	return BLK_EH_DONE;
 }
 
-- 
2.7.4
