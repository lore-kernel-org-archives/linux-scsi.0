From: michaelc@cs.wisc.edu
Subject: [PATCH RFC/RFT 08/10] bfa: convert bfa to blk bsg lib
Date: Sun, 24 Jul 2011 03:59:22 -0500
Message-ID: <1311497964-26842-9-git-send-email-michaelc@cs.wisc.edu>
References: <1311497964-26842-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206Ab1GXI4s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Jul 2011 04:56:48 -0400
In-Reply-To: <1311497964-26842-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, Krishna Gudipati <kgudipat@brocade.com>, Jing Huang <huangj@brocade.com>

From: Mike Christie <michaelc@cs.wisc.edu>

This converts bfa to use the bsg lib. I also coverted it
to use shost_priv in the bfa bsg code.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Cc: Krishna Gudipati <kgudipat@brocade.com>
Cc: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfad_bsg.c |   58 +++++++++++++++++++++++--------------------
 drivers/scsi/bfa/bfad_im.h  |    4 +-
 2 files changed, 33 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index 89f863e..6414244 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -1710,11 +1710,12 @@ bfad_iocmd_handler(struct bfad_s *bfad, unsigned int cmd, void *iocmd,
 }
 
 static int
-bfad_im_bsg_vendor_request(struct fc_bsg_job *job)
+bfad_im_bsg_vendor_request(struct bsg_job *job)
 {
-	uint32_t vendor_cmd = job->request->rqst_data.h_vendor.vendor_cmd[0];
-	struct bfad_im_port_s *im_port =
-			(struct bfad_im_port_s *) job->shost->hostdata[0];
+	struct fc_bsg_reply *reply = job->reply;
+	struct fc_bsg_request *req = job->request;
+	uint32_t vendor_cmd = req->rqst_data.h_vendor.vendor_cmd[0];
+	struct bfad_im_port_s *im_port = shost_priv(fc_bsg_to_shost(job));
 	struct bfad_s *bfad = im_port->bfad;
 	void *payload_kbuf;
 	int rc = -EINVAL;
@@ -1748,18 +1749,18 @@ bfad_im_bsg_vendor_request(struct fc_bsg_job *job)
 
 	/* Fill the BSG job reply data */
 	job->reply_len = job->reply_payload.payload_len;
-	job->reply->reply_payload_rcv_len = job->reply_payload.payload_len;
-	job->reply->result = rc;
+	reply->reply_payload_rcv_len = job->reply_payload.payload_len;
+	reply->result = rc;
 
-	job->job_done(job);
+	bsg_job_done(job, reply->result, reply->reply_payload_rcv_len);
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
 
@@ -1885,7 +1886,7 @@ bfad_fcxp_free_mem(struct bfad_s *bfad, struct bfad_buf_info *buf_base,
 }
 
 int
-bfad_fcxp_bsg_send(struct fc_bsg_job *job, struct bfad_fcxp *drv_fcxp,
+bfad_fcxp_bsg_send(struct bsg_job *job, struct bfad_fcxp *drv_fcxp,
 		   bfa_bsg_fcpt_t *bsg_fcpt)
 {
 	struct bfa_fcxp_s *hal_fcxp;
@@ -1925,27 +1926,28 @@ bfad_fcxp_bsg_send(struct fc_bsg_job *job, struct bfad_fcxp *drv_fcxp,
 }
 
 int
-bfad_im_bsg_els_ct_request(struct fc_bsg_job *job)
+bfad_im_bsg_els_ct_request(struct bsg_job *job)
 {
+	struct fc_bsg_reply *reply = job->reply;
+	struct fc_bsg_request *req = job->request;
+	struct bfad_im_port_s *im_port = shost_priv(fc_bsg_to_shost(job));
 	struct bfa_bsg_data *bsg_data;
-	struct bfad_im_port_s *im_port =
-			(struct bfad_im_port_s *) job->shost->hostdata[0];
 	struct bfad_s *bfad = im_port->bfad;
 	bfa_bsg_fcpt_t *bsg_fcpt;
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
@@ -2086,13 +2088,13 @@ bfad_im_bsg_els_ct_request(struct fc_bsg_job *job)
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
 
@@ -2118,20 +2120,22 @@ out_free_mem:
 	kfree(bsg_fcpt);
 	kfree(drv_fcxp);
 out:
-	job->reply->result = rc;
+	reply->result = rc;
 
 	if (rc == BFA_STATUS_OK)
-		job->job_done(job);
+		bsg_job_done(job, reply->result, reply->reply_payload_rcv_len);
 
 	return rc;
 }
 
 int
-bfad_im_bsg_request(struct fc_bsg_job *job)
+bfad_im_bsg_request(struct bsg_job *job)
 {
+	struct fc_bsg_reply *reply = job->reply;
+	struct fc_bsg_request *req = job->request;
 	uint32_t rc = BFA_STATUS_OK;
 
-	switch (job->request->msgcode) {
+	switch (req->msgcode) {
 	case FC_BSG_HST_VENDOR:
 		/* Process BSG HST Vendor requests */
 		rc = bfad_im_bsg_vendor_request(job);
@@ -2144,8 +2148,8 @@ bfad_im_bsg_request(struct fc_bsg_job *job)
 		rc = bfad_im_bsg_els_ct_request(job);
 		break;
 	default:
-		job->reply->result = rc = -EINVAL;
-		job->reply->reply_payload_rcv_len = 0;
+		reply->result = rc = -EINVAL;
+		reply->reply_payload_rcv_len = 0;
 		break;
 	}
 
@@ -2153,7 +2157,7 @@ bfad_im_bsg_request(struct fc_bsg_job *job)
 }
 
 int
-bfad_im_bsg_timeout(struct fc_bsg_job *job)
+bfad_im_bsg_timeout(struct bsg_job *job)
 {
 	/* Don't complete the BSG job request - return -EAGAIN
 	 * to reset bsg job timeout : for ELS/CT pass thru we
diff --git a/drivers/scsi/bfa/bfad_im.h b/drivers/scsi/bfa/bfad_im.h
index 4fe34d5..d7cc6a6 100644
--- a/drivers/scsi/bfa/bfad_im.h
+++ b/drivers/scsi/bfa/bfad_im.h
@@ -141,7 +141,7 @@ extern struct device_attribute *bfad_im_vport_attrs[];
 
 irqreturn_t bfad_intx(int irq, void *dev_id);
 
-int bfad_im_bsg_request(struct fc_bsg_job *job);
-int bfad_im_bsg_timeout(struct fc_bsg_job *job);
+int bfad_im_bsg_request(struct bsg_job *job);
+int bfad_im_bsg_timeout(struct bsg_job *job);
 
 #endif
-- 
1.7.2.3

