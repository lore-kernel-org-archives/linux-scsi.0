From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 02/44] bfa: don't use fc_bsg_job::request and fc_bsg_job::reply directly
Date: Tue, 11 Oct 2016 13:28:33 +0200
Message-ID: <f7d9c60e8fbf46e896fe5fb09b47bf1b552f8c9b.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39073 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752884AbcJKL3Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 11 Oct 2016 07:29:25 -0400
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>

Don't use fc_bsg_job::request and fc_bsg_job::reply directly, but use
helper variables bsg_request and bsg_reply. This will be helpfull  when
transitioning to bsg-lib.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/bfa/bfad_bsg.c | 40 +++++++++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index d1ad020..48366d8 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -3132,7 +3132,9 @@ bfad_iocmd_handler(struct bfad_s *bfad, unsigned int cmd, void *iocmd,
 static int
 bfad_im_bsg_vendor_request(struct fc_bsg_job *job)
 {
-	uint32_t vendor_cmd = job->request->rqst_data.h_vendor.vendor_cmd[0];
+	struct fc_bsg_request *bsg_request = job->request;
+	struct fc_bsg_reply *bsg_reply = job->reply;
+	uint32_t vendor_cmd = bsg_request->rqst_data.h_vendor.vendor_cmd[0];
 	struct bfad_im_port_s *im_port =
 			(struct bfad_im_port_s *) job->shost->hostdata[0];
 	struct bfad_s *bfad = im_port->bfad;
@@ -3175,8 +3177,8 @@ bfad_im_bsg_vendor_request(struct fc_bsg_job *job)
 
 	/* Fill the BSG job reply data */
 	job->reply_len = job->reply_payload.payload_len;
-	job->reply->reply_payload_rcv_len = job->reply_payload.payload_len;
-	job->reply->result = rc;
+	bsg_reply->reply_payload_rcv_len = job->reply_payload.payload_len;
+	bsg_reply->result = rc;
 
 	job->job_done(job);
 	return rc;
@@ -3184,9 +3186,9 @@ error:
 	/* free the command buffer */
 	kfree(payload_kbuf);
 out:
-	job->reply->result = rc;
+	bsg_reply->result = rc;
 	job->reply_len = sizeof(uint32_t);
-	job->reply->reply_payload_rcv_len = 0;
+	bsg_reply->reply_payload_rcv_len = 0;
 	return rc;
 }
 
@@ -3362,18 +3364,20 @@ bfad_im_bsg_els_ct_request(struct fc_bsg_job *job)
 	struct bfad_fcxp    *drv_fcxp;
 	struct bfa_fcs_lport_s *fcs_port;
 	struct bfa_fcs_rport_s *fcs_rport;
-	uint32_t command_type = job->request->msgcode;
+	struct fc_bsg_request *bsg_request = bsg_request;
+	struct fc_bsg_reply *bsg_reply = job->reply;
+	uint32_t command_type = bsg_request->msgcode;
 	unsigned long flags;
 	struct bfad_buf_info *rsp_buf_info;
 	void *req_kbuf = NULL, *rsp_kbuf = NULL;
 	int rc = -EINVAL;
 
 	job->reply_len  = sizeof(uint32_t);	/* Atleast uint32_t reply_len */
-	job->reply->reply_payload_rcv_len = 0;
+	bsg_reply->reply_payload_rcv_len = 0;
 
 	/* Get the payload passed in from userspace */
-	bsg_data = (struct bfa_bsg_data *) (((char *)job->request) +
-					sizeof(struct fc_bsg_request));
+	bsg_data = (struct bfa_bsg_data *) (((char *)bsg_request) +
+					    sizeof(struct fc_bsg_request));
 	if (bsg_data == NULL)
 		goto out;
 
@@ -3517,13 +3521,13 @@ bfad_im_bsg_els_ct_request(struct fc_bsg_job *job)
 	/* fill the job->reply data */
 	if (drv_fcxp->req_status == BFA_STATUS_OK) {
 		job->reply_len = drv_fcxp->rsp_len;
-		job->reply->reply_payload_rcv_len = drv_fcxp->rsp_len;
-		job->reply->reply_data.ctels_reply.status = FC_CTELS_STATUS_OK;
+		bsg_reply->reply_payload_rcv_len = drv_fcxp->rsp_len;
+		bsg_reply->reply_data.ctels_reply.status = FC_CTELS_STATUS_OK;
 	} else {
-		job->reply->reply_payload_rcv_len =
+		bsg_reply->reply_payload_rcv_len =
 					sizeof(struct fc_bsg_ctels_reply);
 		job->reply_len = sizeof(uint32_t);
-		job->reply->reply_data.ctels_reply.status =
+		bsg_reply->reply_data.ctels_reply.status =
 						FC_CTELS_STATUS_REJECT;
 	}
 
@@ -3549,7 +3553,7 @@ out_free_mem:
 	kfree(bsg_fcpt);
 	kfree(drv_fcxp);
 out:
-	job->reply->result = rc;
+	bsg_reply->result = rc;
 
 	if (rc == BFA_STATUS_OK)
 		job->job_done(job);
@@ -3560,9 +3564,11 @@ out:
 int
 bfad_im_bsg_request(struct fc_bsg_job *job)
 {
+	struct fc_bsg_request *bsg_request = job->request;
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	uint32_t rc = BFA_STATUS_OK;
 
-	switch (job->request->msgcode) {
+	switch (bsg_request->msgcode) {
 	case FC_BSG_HST_VENDOR:
 		/* Process BSG HST Vendor requests */
 		rc = bfad_im_bsg_vendor_request(job);
@@ -3575,8 +3581,8 @@ bfad_im_bsg_request(struct fc_bsg_job *job)
 		rc = bfad_im_bsg_els_ct_request(job);
 		break;
 	default:
-		job->reply->result = rc = -EINVAL;
-		job->reply->reply_payload_rcv_len = 0;
+		bsg_reply->result = rc = -EINVAL;
+		bsg_reply->reply_payload_rcv_len = 0;
 		break;
 	}
 
-- 
1.8.5.6

