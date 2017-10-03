From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/9] libfc: don't assign resid_len in fc_lport_bsg_request
Date: Tue,  3 Oct 2017 12:48:39 +0200
Message-ID: <20171003104845.10417-4-hch@lst.de>
References: <20171003104845.10417-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171003104845.10417-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

bsg_job_done takes care of updating the scsi_request structure fields.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/libfc/fc_lport.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 2fd0ec651170..5da46052e179 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -2083,7 +2083,6 @@ int fc_lport_bsg_request(struct bsg_job *job)
 {
 	struct fc_bsg_request *bsg_request = job->request;
 	struct fc_bsg_reply *bsg_reply = job->reply;
-	struct request *rsp = job->req->next_rq;
 	struct Scsi_Host *shost = fc_bsg_to_shost(job);
 	struct fc_lport *lport = shost_priv(shost);
 	struct fc_rport *rport;
@@ -2092,8 +2091,6 @@ int fc_lport_bsg_request(struct bsg_job *job)
 	u32 did, tov;
 
 	bsg_reply->reply_payload_rcv_len = 0;
-	if (rsp)
-		scsi_req(rsp)->resid_len = job->reply_payload.payload_len;
 
 	mutex_lock(&lport->lp_mutex);
 
-- 
2.14.1
