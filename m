From: michaelc@cs.wisc.edu
Subject: [RFC PATCH 10/10] bfa: convert bfa to scsi bsg lib
Date: Fri, 22 Jul 2011 05:05:00 -0500
Message-ID: <1311329100-2982-11-git-send-email-michaelc@cs.wisc.edu>
References: <1311329100-2982-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564Ab1GVKCc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jul 2011 06:02:32 -0400
In-Reply-To: <1311329100-2982-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/bfa/bfad_bsg.c |   52 ++++++++++++++++++++++++-------------------
 drivers/scsi/bfa/bfad_im.h  |    4 +-
 2 files changed, 31 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index 89f863e..ba6f8f2 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -1710,9 +1710,11 @@ bfad_iocmd_handler(struct bfad_s *bfad, unsigned int cmd, void *iocmd,
 }
 
 static int
-bfad_im_bsg_vendor_request(struct fc_bsg_job *job)
+bfad_im_bsg_vendor_request(struct scsi_bsg_job *job)
 {
-	uint32_t vendor_cmd = job->request->rqst_data.h_vendor.vendor_cmd[0];
+	struct fc_bsg_reply *reply = job->reply;
+	struct fc_bsg_request *req = job->request;
+	uint32_t vendor_cmd = req->rqst_data.h_vendor.vendor_cmd[0];
 	struct bfad_im_port_s *im_port =
 			(struct bfad_im_port_s *) job->shost->hostdata[0];
 	struct bfad_s *bfad = im_port->bfad;
@@ -1748,18 +1750,18 @@ bfad_im_bsg_vendor_request(struct fc_bsg_job *job)
 
 	/* Fill the BSG job reply data */
 	job->reply_len = job->reply_payload.payload_len;
-	job->reply->reply_payload_rcv_len = job->reply_payload.payload_len;
-	job->reply->result = rc;
+	reply->reply_payload_rcv_len = job->reply_payload.payload_len;
+	reply->result = rc;
 
-	job->job_done(job);
+	job->job_done(job, reply->result, reply->reply_payload_rcv_len);
 	return rc;
 error:
 	/* free the command buffer */
 	kfree(payload_kbuf);
 out:
-	job->reply->result = rc;
+	reply->result = rc;
 	job->reply_len = sizeof(uint32_t);
-	job->reply->reply_payload_rcv_len = 0;
+	reply->reply_payload_rcv_len = 0;
 	return rc;
 }
 
@@ -1885,7 +1887,7 @@ bfad_fcxp_free_mem(struct bfad_s *bfad, struct bfad_buf_info *buf_base,
 }
 
 int
-bfad_fcxp_bsg_send(struct fc_bsg_job *job, struct bfad_fcxp *drv_fcxp,
+bfad_fcxp_bsg_send(struct scsi_bsg_job *job, struct bfad_fcxp *drv_fcxp,
 		   bfa_bsg_fcpt_t *bsg_fcpt)
 {
 	struct bfa_fcxp_s *hal_fcxp;
@@ -1925,8 +1927,10 @@ bfad_fcxp_bsg_send(struct fc_bsg_job *job, struct bfad_fcxp *drv_fcxp,
 }
 
 int
-bfad_im_bsg_els_ct_request(struct fc_bsg_job *job)
+bfad_im_bsg_els_ct_request(struct scsi_bsg_job *job)
 {
+	struct fc_bsg_reply *reply = job->reply;
+	struct fc_bsg_request *req = job->request;
 	struct bfa_bsg_data *bsg_data;
 	struct bfad_im_port_s *im_port =
 			(struct bfad_im_port_s *) job->shost->hostdata[0];
@@ -1935,17 +1939,17 @@ bfad_im_bsg_els_ct_request(struct fc_bsg_job *job)
 	struct bfad_fcxp    *drv_fcxp;
 	struct bfa_fcs_lport_s *fcs_port;
 	struct bfa_fcs_rport_s *fcs_rport;
-	uint32_t command_type = job->request->msgcode;
+	uint32_t command_type = req->msgcode;
 	unsigned long flags;
 	struct bfad_buf_info *rsp_buf_info;
 	void *req_kbuf = NULL, *rsp_kbuf = NULL;
 	int rc = -EINVAL;
 
 	job->reply_len  = sizeof(uint32_t);	/* Atleast uint32_t reply_len */
-	job->reply->reply_payload_rcv_len = 0;
+	reply->reply_payload_rcv_len = 0;
 
 	/* Get the payload passed in from userspace */
-	bsg_data = (struct bfa_bsg_data *) (((char *)job->request) +
+	bsg_data = (struct bfa_bsg_data *) (((char *)req) +
 					sizeof(struct fc_bsg_request));
 	if (bsg_data == NULL)
 		goto out;
@@ -2086,13 +2090,13 @@ bfad_im_bsg_els_ct_request(struct fc_bsg_job *job)
 	/* fill the job->reply data */
 	if (drv_fcxp->req_status == BFA_STATUS_OK) {
 		job->reply_len = drv_fcxp->rsp_len;
-		job->reply->reply_payload_rcv_len = drv_fcxp->rsp_len;
-		job->reply->reply_data.ctels_reply.status = FC_CTELS_STATUS_OK;
+		reply->reply_payload_rcv_len = drv_fcxp->rsp_len;
+		reply->reply_data.ctels_reply.status = FC_CTELS_STATUS_OK;
 	} else {
-		job->reply->reply_payload_rcv_len =
+		reply->reply_payload_rcv_len =
 					sizeof(struct fc_bsg_ctels_reply);
 		job->reply_len = sizeof(uint32_t);
-		job->reply->reply_data.ctels_reply.status =
+		reply->reply_data.ctels_reply.status =
 						FC_CTELS_STATUS_REJECT;
 	}
 
@@ -2118,20 +2122,22 @@ out_free_mem:
 	kfree(bsg_fcpt);
 	kfree(drv_fcxp);
 out:
-	job->reply->result = rc;
+	reply->result = rc;
 
 	if (rc == BFA_STATUS_OK)
-		job->job_done(job);
+		job->job_done(job, reply->result, reply->reply_payload_rcv_len);
 
 	return rc;
 }
 
 int
-bfad_im_bsg_request(struct fc_bsg_job *job)
+bfad_im_bsg_request(struct scsi_bsg_job *job)
 {
+	struct fc_bsg_reply *reply = job->reply;
+	struct fc_bsg_request *req = job->request;
 	uint32_t rc = BFA_STATUS_OK;
 
-	switch (job->request->msgcode) {
+	switch (req->msgcode) {
 	case FC_BSG_HST_VENDOR:
 		/* Process BSG HST Vendor requests */
 		rc = bfad_im_bsg_vendor_request(job);
@@ -2144,8 +2150,8 @@ bfad_im_bsg_request(struct fc_bsg_job *job)
 		rc = bfad_im_bsg_els_ct_request(job);
 		break;
 	default:
-		job->reply->result = rc = -EINVAL;
-		job->reply->reply_payload_rcv_len = 0;
+		reply->result = rc = -EINVAL;
+		reply->reply_payload_rcv_len = 0;
 		break;
 	}
 
@@ -2153,7 +2159,7 @@ bfad_im_bsg_request(struct fc_bsg_job *job)
 }
 
 int
-bfad_im_bsg_timeout(struct fc_bsg_job *job)
+bfad_im_bsg_timeout(struct scsi_bsg_job *job)
 {
 	/* Don't complete the BSG job request - return -EAGAIN
 	 * to reset bsg job timeout : for ELS/CT pass thru we
diff --git a/drivers/scsi/bfa/bfad_im.h b/drivers/scsi/bfa/bfad_im.h
index 4fe34d5..2b78735 100644
--- a/drivers/scsi/bfa/bfad_im.h
+++ b/drivers/scsi/bfa/bfad_im.h
@@ -141,7 +141,7 @@ extern struct device_attribute *bfad_im_vport_attrs[];
 
 irqreturn_t bfad_intx(int irq, void *dev_id);
 
-int bfad_im_bsg_request(struct fc_bsg_job *job);
-int bfad_im_bsg_timeout(struct fc_bsg_job *job);
+int bfad_im_bsg_request(struct scsi_bsg_job *job);
+int bfad_im_bsg_timeout(struct scsi_bsg_job *job);
 
 #endif
-- 
1.7.2.3

