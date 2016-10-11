From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 07/44] libfc: don't use fc_bsg_job::request and
	fc_bsg_job::reply directly
Date: Tue, 11 Oct 2016 13:28:38 +0200
Message-ID: <cda702d61239f7b53582adb2712658424f2df082.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <cover.1476180827.git.jthumshirn-l3A5Bk7waGM@public.gmane.org>
In-Reply-To: <cover.1476180827.git.jthumshirn-l3A5Bk7waGM@public.gmane.org>
References: <cover.1476180827.git.jthumshirn-l3A5Bk7waGM@public.gmane.org>
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel/>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: "fcoe-devel" <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
To: "Martin K . Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Linux SCSI Mailinglist <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailinglist <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "open list:FCOE SUBSYSTEM libfc,
 libfcoe, fcoe" <fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>, Johannes Thumshirn <jth-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Don't use fc_bsg_job::request and fc_bsg_job::reply directly, but use
helper variables bsg_request and bsg_reply. This will be helpfull when
transitioning to bsg-lib.

Signed-off-by: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
---
 drivers/scsi/libfc/fc_lport.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 04ce7cf..a1c12e7 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1901,13 +1901,14 @@ static void fc_lport_bsg_resp(struct fc_seq *sp, struct fc_frame *fp,
 {
 	struct fc_bsg_info *info = info_arg;
 	struct fc_bsg_job *job = info->job;
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct fc_lport *lport = info->lport;
 	struct fc_frame_header *fh;
 	size_t len;
 	void *buf;
 
 	if (IS_ERR(fp)) {
-		job->reply->result = (PTR_ERR(fp) == -FC_EX_CLOSED) ?
+		bsg_reply->result = (PTR_ERR(fp) == -FC_EX_CLOSED) ?
 			-ECONNABORTED : -ETIMEDOUT;
 		job->reply_len = sizeof(uint32_t);
 		job->state_flags |= FC_RQST_STATE_DONE;
@@ -1928,23 +1929,23 @@ static void fc_lport_bsg_resp(struct fc_seq *sp, struct fc_frame *fp,
 			(unsigned short)fc_frame_payload_op(fp);
 
 		/* Save the reply status of the job */
-		job->reply->reply_data.ctels_reply.status =
+		bsg_reply->reply_data.ctels_reply.status =
 			(cmd == info->rsp_code) ?
 			FC_CTELS_STATUS_OK : FC_CTELS_STATUS_REJECT;
 	}
 
-	job->reply->reply_payload_rcv_len +=
+	bsg_reply->reply_payload_rcv_len +=
 		fc_copy_buffer_to_sglist(buf, len, info->sg, &info->nents,
 					 &info->offset, NULL);
 
 	if (fr_eof(fp) == FC_EOF_T &&
 	    (ntoh24(fh->fh_f_ctl) & (FC_FC_LAST_SEQ | FC_FC_END_SEQ)) ==
 	    (FC_FC_LAST_SEQ | FC_FC_END_SEQ)) {
-		if (job->reply->reply_payload_rcv_len >
+		if (bsg_reply->reply_payload_rcv_len >
 		    job->reply_payload.payload_len)
-			job->reply->reply_payload_rcv_len =
+			bsg_reply->reply_payload_rcv_len =
 				job->reply_payload.payload_len;
-		job->reply->result = 0;
+		bsg_reply->result = 0;
 		job->state_flags |= FC_RQST_STATE_DONE;
 		job->job_done(job);
 		kfree(info);
@@ -2081,6 +2082,8 @@ static int fc_lport_ct_request(struct fc_bsg_job *job,
  */
 int fc_lport_bsg_request(struct fc_bsg_job *job)
 {
+	struct fc_bsg_request *bsg_request = job->request;
+	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct request *rsp = job->req->next_rq;
 	struct Scsi_Host *shost = job->shost;
 	struct fc_lport *lport = shost_priv(shost);
@@ -2089,13 +2092,13 @@ int fc_lport_bsg_request(struct fc_bsg_job *job)
 	int rc = -EINVAL;
 	u32 did, tov;
 
-	job->reply->reply_payload_rcv_len = 0;
+	bsg_reply->reply_payload_rcv_len = 0;
 	if (rsp)
 		rsp->resid_len = job->reply_payload.payload_len;
 
 	mutex_lock(&lport->lp_mutex);
 
-	switch (job->request->msgcode) {
+	switch (bsg_request->msgcode) {
 	case FC_BSG_RPT_ELS:
 		rport = job->rport;
 		if (!rport)
@@ -2117,7 +2120,7 @@ int fc_lport_bsg_request(struct fc_bsg_job *job)
 		break;
 
 	case FC_BSG_HST_CT:
-		did = ntoh24(job->request->rqst_data.h_ct.port_id);
+		did = ntoh24(bsg_request->rqst_data.h_ct.port_id);
 		if (did == FC_FID_DIR_SERV) {
 			rdata = lport->dns_rdata;
 			if (!rdata)
@@ -2135,7 +2138,7 @@ int fc_lport_bsg_request(struct fc_bsg_job *job)
 		break;
 
 	case FC_BSG_HST_ELS_NOLOGIN:
-		did = ntoh24(job->request->rqst_data.h_els.port_id);
+		did = ntoh24(bsg_request->rqst_data.h_els.port_id);
 		rc = fc_lport_els_request(job, lport, did, lport->e_d_tov);
 		break;
 	}
-- 
1.8.5.6
