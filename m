From: michaelc@cs.wisc.edu
Subject: [PATCH RFC/RFT 05/10] libfc: convert to blk bsg lib
Date: Sun, 24 Jul 2011 03:59:19 -0500
Message-ID: <1311497964-26842-6-git-send-email-michaelc@cs.wisc.edu>
References: <1311497964-26842-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121Ab1GXI4l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Jul 2011 04:56:41 -0400
In-Reply-To: <1311497964-26842-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, Robert Love <robert.w.love@intel.com>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch converts libfc to the blk bsg lib. The differences
visible to the driver are:
- fc_bsg_job is now named bsg_job.
- no rport pointer. Can access it through the device pointer.
- the request and reply pointers on the blk_bsg_job struct
  are now void pointers, so you cannot do bsg_job->request->some_field.

Patch is only quickly tested with fcping and made over scsi-misc.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Cc: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_lport.c |   51 ++++++++++++++++++----------------------
 include/scsi/libfc.h          |    3 +-
 2 files changed, 25 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index e008b16..6043173 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -140,7 +140,7 @@ static const char *fc_lport_state_names[] = {
  * @offset:   The offset into the response data
  */
 struct fc_bsg_info {
-	struct fc_bsg_job *job;
+	struct bsg_job *job;
 	struct fc_lport *lport;
 	u16 rsp_code;
 	struct scatterlist *sg;
@@ -1653,18 +1653,18 @@ static void fc_lport_bsg_resp(struct fc_seq *sp, struct fc_frame *fp,
 			      void *info_arg)
 {
 	struct fc_bsg_info *info = info_arg;
-	struct fc_bsg_job *job = info->job;
+	struct bsg_job *job = info->job;
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
+		bsg_job_done(job, reply->result, reply->reply_payload_rcv_len);
 		kfree(info);
 		return;
 	}
@@ -1681,25 +1681,24 @@ static void fc_lport_bsg_resp(struct fc_seq *sp, struct fc_frame *fp,
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
+		bsg_job_done(job, reply->result, reply->reply_payload_rcv_len);
 		kfree(info);
 	}
 	fc_frame_free(fp);
@@ -1715,7 +1714,7 @@ static void fc_lport_bsg_resp(struct fc_seq *sp, struct fc_frame *fp,
  * Locking Note: The lport lock is expected to be held before calling
  * this routine.
  */
-static int fc_lport_els_request(struct fc_bsg_job *job,
+static int fc_lport_els_request(struct bsg_job *job,
 				struct fc_lport *lport,
 				u32 did, u32 tov)
 {
@@ -1776,7 +1775,7 @@ static int fc_lport_els_request(struct fc_bsg_job *job,
  * Locking Note: The lport lock is expected to be held before calling
  * this routine.
  */
-static int fc_lport_ct_request(struct fc_bsg_job *job,
+static int fc_lport_ct_request(struct bsg_job *job,
 			       struct fc_lport *lport, u32 did, u32 tov)
 {
 	struct fc_bsg_info *info;
@@ -1832,45 +1831,41 @@ static int fc_lport_ct_request(struct fc_bsg_job *job,
  *			    FC Passthrough requests
  * @job: The BSG passthrough job
  */
-int fc_lport_bsg_request(struct fc_bsg_job *job)
+int fc_lport_bsg_request(struct bsg_job *job)
 {
 	struct request *rsp = job->req->next_rq;
-	struct Scsi_Host *shost = job->shost;
+	struct fc_bsg_request *req = job->request;
+	struct fc_bsg_reply *reply = job->reply;
+	struct Scsi_Host *shost = fc_bsg_to_shost(job);
 	struct fc_lport *lport = shost_priv(shost);
 	struct fc_rport *rport;
 	struct fc_rport_priv *rdata;
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
@@ -1883,7 +1878,7 @@ int fc_lport_bsg_request(struct fc_bsg_job *job)
 		break;
 
 	case FC_BSG_HST_ELS_NOLOGIN:
-		did = ntoh24(job->request->rqst_data.h_els.port_id);
+		did = ntoh24(req->rqst_data.h_els.port_id);
 		rc = fc_lport_els_request(job, lport, did, lport->e_d_tov);
 		break;
 	}
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 7d96829..eb7fc9f 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -23,6 +23,7 @@
 #include <linux/timer.h>
 #include <linux/if.h>
 #include <linux/percpu.h>
+#include <linux/bsg-lib.h>
 
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_fc.h>
@@ -1055,7 +1056,7 @@ int fc_lport_reset(struct fc_lport *);
 int fc_set_mfs(struct fc_lport *, u32 mfs);
 struct fc_lport *libfc_vport_create(struct fc_vport *, int privsize);
 struct fc_lport *fc_vport_id_lookup(struct fc_lport *, u32 port_id);
-int fc_lport_bsg_request(struct fc_bsg_job *);
+int fc_lport_bsg_request(struct bsg_job *);
 void fc_lport_set_local_id(struct fc_lport *, u32 port_id);
 void fc_lport_iterate(void (*func)(struct fc_lport *, void *), void *);
 
-- 
1.7.2.3

