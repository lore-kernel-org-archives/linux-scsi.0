From: michaelc@cs.wisc.edu
Subject: [RFC PATCH 05/10] ibmvfc: convert ibmvfc to scsi bsg lib
Date: Fri, 22 Jul 2011 05:04:55 -0500
Message-ID: <1311329100-2982-6-git-send-email-michaelc@cs.wisc.edu>
References: <1311329100-2982-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783Ab1GVKCR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jul 2011 06:02:17 -0400
In-Reply-To: <1311329100-2982-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

This patch converts ibmvfc to the scsi bsg lib. The differences
visible to the driver are:
- fc_bsg_job is now named scsi_bsg_job.
- no rport pointer. Can access it through the device pointer.
- the request and reply pointers on the scsi_bsg_job struct
  are now void pointers, so you cannot do bsg_job->request->some_field.

Patch is only compile tested and made over scsi-misc.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c |   40 ++++++++++++++++++++++------------------
 1 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index b765061..576594b 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1704,12 +1704,12 @@ static void ibmvfc_bsg_timeout_done(struct ibmvfc_event *evt)
 
 /**
  * ibmvfc_bsg_timeout - Handle a BSG timeout
- * @job:	struct fc_bsg_job that timed out
+ * @job:	struct scsi_bsg_job that timed out
  *
  * Returns:
  *	0 on success / other on failure
  **/
-static int ibmvfc_bsg_timeout(struct fc_bsg_job *job)
+static int ibmvfc_bsg_timeout(struct scsi_bsg_job *job)
 {
 	struct ibmvfc_host *vhost = shost_priv(job->shost);
 	unsigned long port_id = (unsigned long)job->dd_data;
@@ -1817,42 +1817,46 @@ unlock_out:
 
 /**
  * ibmvfc_bsg_request - Handle a BSG request
- * @job:	struct fc_bsg_job to be executed
+ * @job:	struct scsi_bsg_job to be executed
  *
  * Returns:
  *	0 on success / other on failure
  **/
-static int ibmvfc_bsg_request(struct fc_bsg_job *job)
+static int ibmvfc_bsg_request(struct scsi_bsg_job *job)
 {
 	struct ibmvfc_host *vhost = shost_priv(job->shost);
-	struct fc_rport *rport = job->rport;
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
+	job->job_done(job, reply->result, reply->reply_payload_rcv_len);
 	rc = 0;
 out:
 	dma_unmap_sg(vhost->dev, job->request_payload.sg_list,
-- 
1.7.2.3

