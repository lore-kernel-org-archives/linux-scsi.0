From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 08/44] scsi: fc: don't use fc_bsg_job::request and fc_bsg_job::reply directly
Date: Tue, 11 Oct 2016 13:28:39 +0200
Message-ID: <be834e90d34855b0822aba07cb58b210f5df43b4.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Don't use fc_bsg_job::request and fc_bsg_job::reply directly, but use
helper variables bsg_request and bsg_reply. This will be helpfull when
transitioning to bsg-lib.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_transport_fc.c | 37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 8ff2067..eafc7555 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3588,9 +3588,10 @@ fc_bsg_jobdone(struct fc_bsg_job *job)
 {
 	struct request *req = job->req;
 	struct request *rsp = req->next_rq;
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	int err;
 
-	err = job->req->errors = job->reply->result;
+	err = job->req->errors = bsg_reply->result;
 
 	if (err < 0)
 		/* we're only returning the result field in the reply */
@@ -3602,10 +3603,10 @@ fc_bsg_jobdone(struct fc_bsg_job *job)
 	req->resid_len = 0;
 
 	if (rsp) {
-		WARN_ON(job->reply->reply_payload_rcv_len > rsp->resid_len);
+		WARN_ON(bsg_reply->reply_payload_rcv_len > rsp->resid_len);
 
 		/* set reply (bidi) residual */
-		rsp->resid_len -= min(job->reply->reply_payload_rcv_len,
+		rsp->resid_len -= min(bsg_reply->reply_payload_rcv_len,
 				      rsp->resid_len);
 	}
 	blk_complete_request(req);
@@ -3701,6 +3702,8 @@ fc_req_to_bsgjob(struct Scsi_Host *shost, struct fc_rport *rport,
 	struct fc_internal *i = to_fc_internal(shost->transportt);
 	struct request *rsp = req->next_rq;
 	struct fc_bsg_job *job;
+	struct fc_bsg_request *bsg_request;
+	struct fc_bsg_reply *bsg_reply;
 	int ret;
 
 	BUG_ON(req->special);
@@ -3726,9 +3729,9 @@ fc_req_to_bsgjob(struct Scsi_Host *shost, struct fc_rport *rport,
 	if (i->f->dd_bsg_size)
 		job->dd_data = (void *)&job[1];
 	spin_lock_init(&job->job_lock);
-	job->request = (struct fc_bsg_request *)req->cmd;
+	bsg_request = (struct fc_bsg_request *)req->cmd;
 	job->request_len = req->cmd_len;
-	job->reply = req->sense;
+	bsg_reply = req->sense;
 	job->reply_len = SCSI_SENSE_BUFFERSIZE;	/* Size of sense buffer
 						 * allocated */
 	if (req->bio) {
@@ -3779,11 +3782,13 @@ fc_bsg_host_dispatch(struct request_queue *q, struct Scsi_Host *shost,
 			 struct fc_bsg_job *job)
 {
 	struct fc_internal *i = to_fc_internal(shost->transportt);
+	struct fc_bsg_request *bsg_request = job->request;
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	int cmdlen = sizeof(uint32_t);	/* start with length of msgcode */
 	int ret;
 
 	/* Validate the host command */
-	switch (job->request->msgcode) {
+	switch (bsg_request->msgcode) {
 	case FC_BSG_HST_ADD_RPORT:
 		cmdlen += sizeof(struct fc_bsg_host_add_rport);
 		break;
@@ -3815,7 +3820,7 @@ fc_bsg_host_dispatch(struct request_queue *q, struct Scsi_Host *shost,
 	case FC_BSG_HST_VENDOR:
 		cmdlen += sizeof(struct fc_bsg_host_vendor);
 		if ((shost->hostt->vendor_id == 0L) ||
-		    (job->request->rqst_data.h_vendor.vendor_id !=
+		    (bsg_request->rqst_data.h_vendor.vendor_id !=
 			shost->hostt->vendor_id)) {
 			ret = -ESRCH;
 			goto fail_host_msg;
@@ -3840,8 +3845,8 @@ fc_bsg_host_dispatch(struct request_queue *q, struct Scsi_Host *shost,
 fail_host_msg:
 	/* return the errno failure code as the only status */
 	BUG_ON(job->reply_len < sizeof(uint32_t));
-	job->reply->reply_payload_rcv_len = 0;
-	job->reply->result = ret;
+	bsg_reply->reply_payload_rcv_len = 0;
+	bsg_reply->result = ret;
 	job->reply_len = sizeof(uint32_t);
 	fc_bsg_jobdone(job);
 	return FC_DISPATCH_UNLOCKED;
@@ -3878,11 +3883,13 @@ fc_bsg_rport_dispatch(struct request_queue *q, struct Scsi_Host *shost,
 			 struct fc_rport *rport, struct fc_bsg_job *job)
 {
 	struct fc_internal *i = to_fc_internal(shost->transportt);
+	struct fc_bsg_request *bsg_request = job->request;
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	int cmdlen = sizeof(uint32_t);	/* start with length of msgcode */
 	int ret;
 
 	/* Validate the rport command */
-	switch (job->request->msgcode) {
+	switch (bsg_request->msgcode) {
 	case FC_BSG_RPT_ELS:
 		cmdlen += sizeof(struct fc_bsg_rport_els);
 		goto check_bidi;
@@ -3915,8 +3922,8 @@ check_bidi:
 fail_rport_msg:
 	/* return the errno failure code as the only status */
 	BUG_ON(job->reply_len < sizeof(uint32_t));
-	job->reply->reply_payload_rcv_len = 0;
-	job->reply->result = ret;
+	bsg_reply->reply_payload_rcv_len = 0;
+	bsg_reply->result = ret;
 	job->reply_len = sizeof(uint32_t);
 	fc_bsg_jobdone(job);
 	return FC_DISPATCH_UNLOCKED;
@@ -3937,6 +3944,7 @@ fc_bsg_request_handler(struct request_queue *q, struct Scsi_Host *shost,
 	struct request *req;
 	struct fc_bsg_job *job;
 	enum fc_dispatch_result ret;
+	struct fc_bsg_reply *bsg_reply;
 
 	if (!get_device(dev))
 		return;
@@ -3973,8 +3981,9 @@ fc_bsg_request_handler(struct request_queue *q, struct Scsi_Host *shost,
 		/* check if we have the msgcode value at least */
 		if (job->request_len < sizeof(uint32_t)) {
 			BUG_ON(job->reply_len < sizeof(uint32_t));
-			job->reply->reply_payload_rcv_len = 0;
-			job->reply->result = -ENOMSG;
+			bsg_reply = job->reply;
+			bsg_reply->reply_payload_rcv_len = 0;
+			bsg_reply->result = -ENOMSG;
 			job->reply_len = sizeof(uint32_t);
 			fc_bsg_jobdone(job);
 			spin_lock_irq(q->queue_lock);
-- 
1.8.5.6
