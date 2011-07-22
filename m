From: michaelc@cs.wisc.edu
Subject: [RFC PATCH 06/10] libfc: convert to scsi bsg lib
Date: Fri, 22 Jul 2011 05:04:56 -0500
Message-ID: <1311329100-2982-7-git-send-email-michaelc@cs.wisc.edu>
References: <1311329100-2982-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783Ab1GVKC0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jul 2011 06:02:26 -0400
In-Reply-To: <1311329100-2982-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

This patch converts libfc to the scsi bsg lib. The differences
visible to the driver are:
- fc_bsg_job is now named scsi_bsg_job.
- no rport pointer. Can access it through the device pointer.
- the request and reply pointers on the scsi_bsg_job struct
  are now void pointers, so you cannot do bsg_job->request->some_field.

Patch is only quickly tested with fcping and made over scsi-misc.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/libfc/fc_lport.c |   51 +++++++++++++++++++---------------------
 include/scsi/libfc.h          |    3 +-
 2 files changed, 26 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index e008b16..a6ec58b 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -140,7 +140,7 @@ static const char *fc_lport_state_names[] = {
  * @offset:   The offset into the response data
  */
 struct fc_bsg_info {
-	struct fc_bsg_job *job;
+	struct scsi_bsg_job *job;
 	struct fc_lport *lport;
 	u16 rsp_code;
 	struct scatterlist *sg;
@@ -1653,18 +1653,19 @@ static void fc_lport_bsg_resp(struct fc_seq *sp, struct fc_frame *fp,
 			      void *info_arg)
 {
 	struct fc_bsg_info *info = info_arg;
-	struct fc_bsg_job *job = info->job;
+	struct scsi_bsg_job *job = info->job;
+	struct fc_bsg_reply *reply = job->reply;
 	struct fc_lport *lport = info->lport;
 	struct fc_frame_header *fh;
 	size_t len;
 	void *buf;
 
 	if (IS_ERR(fp)) {
-		job->reply->result = (PTR_ERR(fp) == -FC_EX_CLOSED) ?
+		reply->result = (PTR_ERR(fp) == -FC_EX_CLOSED) ?
 			-ECONNABORTED : -ETIMEDOUT;
 		job->reply_len = sizeof(uint32_t);
-		job->state_flags |= FC_RQST_STATE_DONE;
-		job->job_done(job);
+		job->state_flags |= SCSI_RQST_STATE_DONE;
+		job->job_done(job, reply->result, reply->reply_payload_rcv_len);
 		kfree(info);
 		return;
 	}
@@ -1681,25 +1682,25 @@ static void fc_lport_bsg_resp(struct fc_seq *sp, struct fc_frame *fp,
 			(unsigned short)fc_frame_payload_op(fp);
 
 		/* Save the reply status of the job */
-		job->reply->reply_data.ctels_reply.status =
+		reply->reply_data.ctels_reply.status =
 			(cmd == info->rsp_code) ?
 			FC_CTELS_STATUS_OK : FC_CTELS_STATUS_REJECT;
 	}
 
-	job->reply->reply_payload_rcv_len +=
+	reply->reply_payload_rcv_len +=
 		fc_copy_buffer_to_sglist(buf, len, info->sg, &info->nents,
 					 &info->offset, KM_BIO_SRC_IRQ, NULL);
 
 	if (fr_eof(fp) == FC_EOF_T &&
 	    (ntoh24(fh->fh_f_ctl) & (FC_FC_LAST_SEQ | FC_FC_END_SEQ)) ==
 	    (FC_FC_LAST_SEQ | FC_FC_END_SEQ)) {
-		if (job->reply->reply_payload_rcv_len >
+		if (reply->reply_payload_rcv_len >
 		    job->reply_payload.payload_len)
-			job->reply->reply_payload_rcv_len =
+			reply->reply_payload_rcv_len =
 				job->reply_payload.payload_len;
-		job->reply->result = 0;
-		job->state_flags |= FC_RQST_STATE_DONE;
-		job->job_done(job);
+		reply->result = 0;
+		job->state_flags |= SCSI_RQST_STATE_DONE;
+		job->job_done(job, reply->result, reply->reply_payload_rcv_len);
 		kfree(info);
 	}
 	fc_frame_free(fp);
@@ -1715,7 +1716,7 @@ static void fc_lport_bsg_resp(struct fc_seq *sp, struct fc_frame *fp,
  * Locking Note: The lport lock is expected to be held before calling
  * this routine.
  */
-static int fc_lport_els_request(struct fc_bsg_job *job,
+static int fc_lport_els_request(struct scsi_bsg_job *job,
 				struct fc_lport *lport,
 				u32 did, u32 tov)
 {
@@ -1776,7 +1777,7 @@ static int fc_lport_els_request(struct fc_bsg_job *job,
  * Locking Note: The lport lock is expected to be held before calling
  * this routine.
  */
-static int fc_lport_ct_request(struct fc_bsg_job *job,
+static int fc_lport_ct_request(struct scsi_bsg_job *job,
 			       struct fc_lport *lport, u32 did, u32 tov)
 {
 	struct fc_bsg_info *info;
@@ -1832,9 +1833,11 @@ static int fc_lport_ct_request(struct fc_bsg_job *job,
  *			    FC Passthrough requests
  * @job: The BSG passthrough job
  */
-int fc_lport_bsg_request(struct fc_bsg_job *job)
+int fc_lport_bsg_request(struct scsi_bsg_job *job)
 {
 	struct request *rsp = job->req->next_rq;
+	struct fc_bsg_request *req = job->request;
+	struct fc_bsg_reply *reply = job->reply;
 	struct Scsi_Host *shost = job->shost;
 	struct fc_lport *lport = shost_priv(shost);
 	struct fc_rport *rport;
@@ -1842,35 +1845,29 @@ int fc_lport_bsg_request(struct fc_bsg_job *job)
 	int rc = -EINVAL;
 	u32 did;
 
-	job->reply->reply_payload_rcv_len = 0;
+	reply->reply_payload_rcv_len = 0;
 	if (rsp)
 		rsp->resid_len = job->reply_payload.payload_len;
 
 	mutex_lock(&lport->lp_mutex);
 
-	switch (job->request->msgcode) {
+	switch (req->msgcode) {
 	case FC_BSG_RPT_ELS:
-		rport = job->rport;
-		if (!rport)
-			break;
-
+		rport = dev_to_rport(job->dev);
 		rdata = rport->dd_data;
 		rc = fc_lport_els_request(job, lport, rport->port_id,
 					  rdata->e_d_tov);
 		break;
 
 	case FC_BSG_RPT_CT:
-		rport = job->rport;
-		if (!rport)
-			break;
-
+		rport = dev_to_rport(job->dev);
 		rdata = rport->dd_data;
 		rc = fc_lport_ct_request(job, lport, rport->port_id,
 					 rdata->e_d_tov);
 		break;
 
 	case FC_BSG_HST_CT:
-		did = ntoh24(job->request->rqst_data.h_ct.port_id);
+		did = ntoh24(req->rqst_data.h_ct.port_id);
 		if (did == FC_FID_DIR_SERV)
 			rdata = lport->dns_rdata;
 		else
@@ -1883,7 +1880,7 @@ int fc_lport_bsg_request(struct fc_bsg_job *job)
 		break;
 
 	case FC_BSG_HST_ELS_NOLOGIN:
-		did = ntoh24(job->request->rqst_data.h_els.port_id);
+		did = ntoh24(req->rqst_data.h_els.port_id);
 		rc = fc_lport_els_request(job, lport, did, lport->e_d_tov);
 		break;
 	}
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 7d96829..cdad338 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -27,6 +27,7 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_fc.h>
 #include <scsi/scsi_bsg_fc.h>
+#include <scsi/scsi_bsg.h>
 
 #include <scsi/fc/fc_fcp.h>
 #include <scsi/fc/fc_ns.h>
@@ -1055,7 +1056,7 @@ int fc_lport_reset(struct fc_lport *);
 int fc_set_mfs(struct fc_lport *, u32 mfs);
 struct fc_lport *libfc_vport_create(struct fc_vport *, int privsize);
 struct fc_lport *fc_vport_id_lookup(struct fc_lport *, u32 port_id);
-int fc_lport_bsg_request(struct fc_bsg_job *);
+int fc_lport_bsg_request(struct scsi_bsg_job *);
 void fc_lport_set_local_id(struct fc_lport *, u32 port_id);
 void fc_lport_iterate(void (*func)(struct fc_lport *, void *), void *);
 
-- 
1.7.2.3

