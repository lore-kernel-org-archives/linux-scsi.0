From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] scsi_transport_fc: fix NULL pointer dereference in fc_bsg_job_timeout
Date: Wed,  6 Sep 2017 12:11:08 +0200
Message-ID: <20170906101109.9270-2-hch@lst.de>
References: <20170906101109.9270-1-hch@lst.de>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170906101109.9270-1-hch@lst.de>
Sender: stable-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

bsg-lib now embeddeds the job structure into the request, and req->special
can't be used anymore.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org
---
 drivers/scsi/scsi_transport_fc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 3c6bc0081fcb..d8de46806a1e 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3571,7 +3571,7 @@ fc_vport_sched_delete(struct work_struct *work)
 static enum blk_eh_timer_return
 fc_bsg_job_timeout(struct request *req)
 {
-	struct bsg_job *job = (void *) req->special;
+	struct bsg_job *job = blk_mq_rq_to_pdu(req->special);
 	struct Scsi_Host *shost = fc_bsg_to_shost(job);
 	struct fc_rport *rport = fc_bsg_to_rport(job);
 	struct fc_internal *i = to_fc_internal(shost->transportt);
-- 
2.11.0
