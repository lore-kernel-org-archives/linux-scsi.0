From: michaelc@cs.wisc.edu
Subject: [PATCH RFC/RFT 10/10] ibmvfc: convert ibmvfc to blk bsg lib
Date: Sun, 24 Jul 2011 03:59:24 -0500
Message-ID: <1311497964-26842-11-git-send-email-michaelc@cs.wisc.edu>
References: <1311497964-26842-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349Ab1GXI46 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Jul 2011 04:56:58 -0400
In-Reply-To: <1311497964-26842-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, Brian King <brking@linux.vnet.ibm.com>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch converts ibmvfc to the bsg lib. The differences
visible to the driver are:
- fc_bsg_job is now named bsg_job.
- no rport pointer. Can access it through the device pointer.
- the request and reply pointers on the bsg_job struct
  are now void pointers, so you cannot do bsg_job->request->some_field.

Patch is only compile tested and made over scsi-misc.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Cc: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c |   44 +++++++++++++++++++++------------------
 1 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index bdfa223..48b4140 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1704,14 +1704,14 @@ static void ibmvfc_bsg_timeout_done(struct ibmvfc_event *evt)
 
 /**
  * ibmvfc_bsg_timeout - Handle a BSG timeout
- * @job:	struct fc_bsg_job that timed out
+ * @job:	struct bsg_job that timed out
  *
  * Returns:
  *	0 on success / other on failure
  **/
-static int ibmvfc_bsg_timeout(struct fc_bsg_job *job)
+static int ibmvfc_bsg_timeout(struct bsg_job *job)
 {
-	struct ibmvfc_host *vhost = shost_priv(job->shost);
+	struct ibmvfc_host *vhost = shost_priv(fc_bsg_to_shost(job));
 	unsigned long port_id = (unsigned long)job->dd_data;
 	struct ibmvfc_event *evt;
 	struct ibmvfc_tmf *tmf;
@@ -1817,42 +1817,46 @@ unlock_out:
 
 /**
  * ibmvfc_bsg_request - Handle a BSG request
- * @job:	struct fc_bsg_job to be executed
+ * @job:	struct bsg_job to be executed
  *
  * Returns:
  *	0 on success / other on failure
  **/
-static int ibmvfc_bsg_request(struct fc_bsg_job *job)
+static int ibmvfc_bsg_request(struct bsg_job *job)
 {
-	struct ibmvfc_host *vhost = shost_priv(job->shost);
-	struct fc_rport *rport = job->rport;
+	struct ibmvfc_host *vhost = shost_priv(fc_bsg_to_shost(job));
+	struct fc_rport *rport;
+	struct fc_bsg_request *req = job->request;
+	struct fc_bsg_reply *reply = job->reply;
 	struct ibmvfc_passthru_mad *mad;
 	struct ibmvfc_event *evt;
 	union ibmvfc_iu rsp_iu;
 	unsigned long flags, port_id = -1;
-	unsigned int code = job->request->msgcode;
+	unsigned int code = req->msgcode;
 	int rc = 0, req_seg, rsp_seg, issue_login = 0;
 	u32 fc_flags, rsp_len;
 
 	ENTER;
-	job->reply->reply_payload_rcv_len = 0;
-	if (rport)
-		port_id = rport->port_id;
+	reply->reply_payload_rcv_len = 0;
 
 	switch (code) {
 	case FC_BSG_HST_ELS_NOLOGIN:
-		port_id = (job->request->rqst_data.h_els.port_id[0] << 16) |
-			(job->request->rqst_data.h_els.port_id[1] << 8) |
-			job->request->rqst_data.h_els.port_id[2];
+		port_id = (req->rqst_data.h_els.port_id[0] << 16) |
+			(req->rqst_data.h_els.port_id[1] << 8) |
+			req->rqst_data.h_els.port_id[2];
 	case FC_BSG_RPT_ELS:
+		rport = dev_to_rport(job->dev);
+		port_id = rport->port_id;
 		fc_flags = IBMVFC_FC_ELS;
 		break;
 	case FC_BSG_HST_CT:
 		issue_login = 1;
-		port_id = (job->request->rqst_data.h_ct.port_id[0] << 16) |
-			(job->request->rqst_data.h_ct.port_id[1] << 8) |
-			job->request->rqst_data.h_ct.port_id[2];
+		port_id = (req->rqst_data.h_ct.port_id[0] << 16) |
+			(req->rqst_data.h_ct.port_id[1] << 8) |
+			req->rqst_data.h_ct.port_id[2];
 	case FC_BSG_RPT_CT:
+		rport = dev_to_rport(job->dev);
+		port_id = rport->port_id;
 		fc_flags = IBMVFC_FC_CT_IU;
 		break;
 	default:
@@ -1940,13 +1944,13 @@ static int ibmvfc_bsg_request(struct fc_bsg_job *job)
 	if (rsp_iu.passthru.common.status)
 		rc = -EIO;
 	else
-		job->reply->reply_payload_rcv_len = rsp_len;
+		reply->reply_payload_rcv_len = rsp_len;
 
 	spin_lock_irqsave(vhost->host->host_lock, flags);
 	ibmvfc_free_event(evt);
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
-	job->reply->result = rc;
-	job->job_done(job);
+	reply->result = rc;
+	bsg_job_done(job, reply->result, reply->reply_payload_rcv_len);
 	rc = 0;
 out:
 	dma_unmap_sg(vhost->dev, job->request_payload.sg_list,
-- 
1.7.2.3

